#!/usr/bin/env node
// Shivang personal Claude statusline (personal config, not company)
// Line 1:  user │ model │ repo[branch] │ ctx bar │ 5h/wk limits │ $cost │ 🔧 tool-calls │ 🤖 claude-sessions (+live subagents)
// Line 2+: ⚡ enabled plugins + skills invoked this session (deduped),
//          wrapped across lines so the full list is always visible.

const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

// ── Git info ─────────────────────────────────────────────────────────────────

function getGitBranch(dir) {
  let current = dir;
  for (let i = 0; i < 8; i++) {
    const headPath = path.join(current, '.git', 'HEAD');
    if (fs.existsSync(headPath)) {
      try {
        const head = fs.readFileSync(headPath, 'utf8').trim();
        return head.startsWith('ref: refs/heads/')
          ? head.replace('ref: refs/heads/', '')
          : head.slice(0, 7);
      } catch (e) { return null; }
    }
    const parent = path.dirname(current);
    if (parent === current) break;
    current = parent;
  }
  return null;
}

// ── Session skills (line 2) ─────────────────────────────────────────────────────
// Line 2 lists every skill "loaded" this session:
//   • auto-loaded → enabled plugins from ~/.claude/settings.json
//   • invoked     → Skill tool calls + slash commands, accumulated across the whole
//                   session via an incremental, position-based cache (O(delta)/render).

// Enabled plugins → short display names. "oh-my-claudecode@omc" → "omc".
const PLUGIN_ALIAS = { 'oh-my-claudecode': 'omc' };  // cosmetic shortening only
function getEnabledPlugins() {
  try {
    const settingsPath = path.join(os.homedir(), '.claude', 'settings.json');
    const raw = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
    const ep = raw.enabledPlugins || {};
    return Object.keys(ep)
      .filter(k => ep[k])            // only enabled
      .map(k => k.split('@')[0])     // strip @marketplace suffix
      .map(n => PLUGIN_ALIAS[n] || n);
  } catch (e) { return []; }
}

// Short display name: last ':'-segment, leading '/' stripped. Rejects garbage.
function shortSkillName(id) {
  let n = (id || '').trim();
  if (n.startsWith('/')) n = n.slice(1);
  if (n.includes(':')) n = n.slice(n.lastIndexOf(':') + 1);
  if (!n || /[\s\\"<>]/.test(n) || n.length > 80) return null;
  return n;
}

// Accumulate distinct invoked skills for this session. Reads only the bytes
// appended since last render (transcript is append-only) → O(delta), not O(size).
// Returns short names in first-seen order.
function accumulateSession(sessionId, transcriptPath) {
  if (!sessionId || !transcriptPath) return { skills: [], tools: 0, agents: 0 };
  const cacheFile = path.join(os.homedir(), '.claude', 'statusline-skills.json');
  const today = new Date().toISOString().slice(0, 10);
  const fresh = () => ({ skills: [], tools: 0, pendingAgents: [], offset: 0, date: today });

  let cache = {};
  try { if (fs.existsSync(cacheFile)) cache = JSON.parse(fs.readFileSync(cacheFile, 'utf8')); } catch (e) {}
  let entry = cache[sessionId] || fresh();
  if (entry.tools == null) entry.tools = 0;                              // back-compat
  if (!Array.isArray(entry.pendingAgents)) entry.pendingAgents = [];     // back-compat (was cumulative)

  try {
    if (!fs.existsSync(transcriptPath)) return { skills: entry.skills, tools: entry.tools, agents: entry.pendingAgents.length };
    const size = fs.statSync(transcriptPath).size;
    if (size < entry.offset) entry = fresh();   // rotated/shrank → rescan
    if (size > entry.offset) {
      const fd = fs.openSync(transcriptPath, 'r');
      let chunk;
      try {
        const buf = Buffer.alloc(size - entry.offset);
        fs.readSync(fd, buf, 0, buf.length, entry.offset);
        chunk = buf.toString('utf8');
      } finally { fs.closeSync(fd); }

      const seen = new Set(entry.skills);
      const add = (raw) => {
        const n = shortSkillName(raw);
        if (n && !seen.has(n)) { seen.add(n); entry.skills.push(n); }
      };
      let m;
      // Skill tool invocations — anchored to the genuine tool_use envelope so prose
      // mentioning "name":"Skill" cannot false-match.
      const skillRe = /"type":"tool_use","id":"toolu_[^"]*","name":"Skill","input":\{[^}]*?"skill":"([^"]+)"/g;
      while ((m = skillRe.exec(chunk)) !== null) add(m[1]);
      // Slash commands
      const cmdRe = /<command-name>([^<]*)<\/command-name>/g;
      while ((m = cmdRe.exec(chunk)) !== null) add(m[1]);
      // Total tool calls — every genuine tool_use (any tool), anchored to toolu_ id.
      const toolMatches = chunk.match(/"type":"tool_use","id":"toolu_/g);
      entry.tools += toolMatches ? toolMatches.length : 0;

      // LIVE subagents: spawned (Agent/Task tool_use) minus finished (tool_result).
      // Set-difference over the append-only log → agents currently in flight.
      const pending = new Set(entry.pendingAgents);
      const spawnRe = /"type":"tool_use","id":"(toolu_[^"]*)","name":"(?:Agent|Task)"/g;
      while ((m = spawnRe.exec(chunk)) !== null) pending.add(m[1]);
      const doneRe = /"tool_use_id":"(toolu_[^"]*)"/g;
      while ((m = doneRe.exec(chunk)) !== null) pending.delete(m[1]);
      entry.pendingAgents = [...pending];

      entry.offset = size;
      entry.date = today;
    }
  } catch (e) { /* keep whatever we have */ }

  cache[sessionId] = entry;
  // Prune sessions older than 8 days
  const cutoff = new Date(Date.now() - 8 * 86400000).toISOString().slice(0, 10);
  for (const sid of Object.keys(cache)) {
    if ((cache[sid].date || '') < cutoff) delete cache[sid];
  }
  try { fs.writeFileSync(cacheFile, JSON.stringify(cache)); } catch (e) {}

  return { skills: entry.skills, tools: entry.tools, agents: entry.pendingAgents.length };
}

// Detect how many columns the skill rows may use. Priority:
//   1. STATUSLINE_SKILL_WIDTH env → explicit budget, wins.
//   2. tmux PANE width (the pane we render in — NOT client width, which can be a
//      wider/other attached client). Pinned to $TMUX_PANE so multi-client/multi-pane
//      setups resolve to the right pane.
//   3. COLUMNS env.  4. fallback 100.
// stdout is piped for a statusline, so process.stdout.columns / tput / /dev/tty
// are all unavailable — tmux is the only reliable live width source here.
// Leaves 4 cols for the "⚡ "/"  " prefix so rows never quite hit the edge.
function skillWrapBudget() {
  const override = parseInt(process.env.STATUSLINE_SKILL_WIDTH || '', 10);
  if (override > 0) return Math.max(12, override);
  let width = 0;
  if (process.env.TMUX) {
    try {
      const pane = process.env.TMUX_PANE;
      const target = /^%\d+$/.test(pane || '') ? `-t ${pane} ` : '';
      width = parseInt(execSync(`tmux display -p ${target}'#{pane_width}'`,
        { encoding: 'utf8', timeout: 200, stdio: ['ignore', 'pipe', 'ignore'] }).trim(), 10) || 0;
    } catch (e) {}
  }
  if (!width) width = parseInt(process.env.COLUMNS || '', 10) || 0;
  if (!width) width = 100;
  return Math.max(12, width - 4);
}

// Count running Claude CLI sessions/agents (each is its own `claude` process).
// Match `comm` exactly == "claude" so MCP children (comm=node) and the desktop
// app (comm=/Applications/Cl…) are excluded; `pgrep -f claude` would over-match
// every process whose argv contains the ~/.claude path.
function countClaudeSessions() {
  try {
    const out = execSync('ps -eo comm', { encoding: 'utf8', timeout: 400, stdio: ['ignore', 'pipe', 'ignore'] });
    let n = 0;
    for (const line of out.split('\n')) {
      const c = line.trim();
      if (c === 'claude' || c.endsWith('/claude')) n++;
    }
    return n;
  } catch (e) { return 0; }
}

// Skills, deduped & wrapped to fit the terminal width so the FULL list is always
// visible. First row prefixed "⚡ "; continuations indented to align. Returns string[].
function buildSkillLines(plugins, invoked) {
  const wrapWidth = skillWrapBudget();
  const seen = new Set();
  const all = [];
  for (const name of [...plugins, ...invoked]) {
    const key = name.toLowerCase();
    if (!seen.has(key)) { seen.add(key); all.push(name); }
  }
  if (!all.length) return [];

  const SEP = ' · ';
  const rows = [];
  let cur = [], curLen = 0;
  for (const name of all) {
    const add = (cur.length ? SEP.length : 0) + name.length;
    if (cur.length && curLen + add > wrapWidth) {
      rows.push(cur.join(SEP));
      cur = [name]; curLen = name.length;
    } else {
      cur.push(name); curLen += add;
    }
  }
  if (cur.length) rows.push(cur.join(SEP));

  // First row gets the ⚡ marker; continuations indent 2 spaces to align under it.
  return rows.map((r, i) => `\x1b[2m${i === 0 ? '⚡ ' : '  '}${r}\x1b[0m`);
}

// ── Context bar ──────────────────────────────────────────────────────────────

function buildContextBar(remaining, totalTokens) {
  if (remaining == null) return '';
  const acw = parseInt(process.env.CLAUDE_CODE_AUTO_COMPACT_WINDOW || '0', 10);
  const AUTO_COMPACT_BUFFER_PCT = acw > 0
    ? Math.min(100, (acw / (totalTokens || 1000000)) * 100)
    : 16.5;
  const usableRemaining = Math.max(0, ((remaining - AUTO_COMPACT_BUFFER_PCT) / (100 - AUTO_COMPACT_BUFFER_PCT)) * 100);
  const used = Math.max(0, Math.min(100, Math.round(100 - usableRemaining)));
  const filled = Math.floor(used / 10);
  const bar = '█'.repeat(filled) + '░'.repeat(10 - filled);
  if (used < 50)  return `\x1b[32m[${bar}] ${used}%\x1b[0m`;
  if (used < 65)  return `\x1b[33m[${bar}] ${used}%\x1b[0m`;
  if (used < 80)  return `\x1b[38;5;208m[${bar}] ${used}%\x1b[0m`;
  return `\x1b[5;31m💀[${bar}] ${used}%\x1b[0m`;
}

// ── Rate limits (real plan usage, from stdin) ──────────────────────────────────
// Claude Code (>= 2.1.168) pipes `rate_limits` in the statusline JSON:
//   five_hour / seven_day → { used_percentage, resets_at (epoch seconds) }
// We read these directly — no API call, no self-tracking. Mirrors OMC's
// `5h:19%(2h30m) wk:33%(2d1h)` format.

// Color by usage %: low=green, climbing=yellow, high=orange, critical=red.
function pctColor(pct) {
  if (pct < 50) return '\x1b[32m';
  if (pct < 75) return '\x1b[33m';
  if (pct < 90) return '\x1b[38;5;208m';
  return '\x1b[31m';
}

// Epoch seconds → compact countdown. >=1 day: "2d5h"; else "3h42m". Past: ''.
function formatResetTime(epochSeconds) {
  if (!epochSeconds) return '';
  const diffMs = epochSeconds * 1000 - Date.now();
  if (diffMs <= 0) return '';
  const totalMinutes = Math.floor(diffMs / 60000);
  const days = Math.floor(totalMinutes / 1440);
  const hours = Math.floor((totalMinutes % 1440) / 60);
  const minutes = totalMinutes % 60;
  return days >= 1 ? `${days}d${hours}h` : `${hours}h${minutes}m`;
}

function buildRateLimitSegment(rateLimits) {
  if (!rateLimits) return '';
  const dim = '\x1b[2m';
  const reset = '\x1b[0m';

  const fmtWindow = (label, win) => {
    if (!win || win.used_percentage == null) return null;
    const pct = Math.min(100, Math.max(0, Math.round(win.used_percentage)));
    const r = formatResetTime(win.resets_at);
    const resetPart = r ? `${dim}(${r})${reset}` : '';
    return `${dim}${label}:${reset}${pctColor(pct)}${pct}%${reset}${resetPart}`;
  };

  const parts = [];
  const fiveHour = fmtWindow('5h', rateLimits.five_hour);
  if (fiveHour) parts.push(fiveHour);
  const weekly = fmtWindow('wk', rateLimits.seven_day);
  if (weekly) parts.push(weekly);

  return parts.join(' ');
}

// ── Main ──────────────────────────────────────────────────────────────────────

let inputBuf = '';
const stdinTimeout = setTimeout(() => process.exit(0), 3000);
process.stdin.setEncoding('utf8');
process.stdin.on('data', chunk => inputBuf += chunk);
process.stdin.on('end', () => {
  clearTimeout(stdinTimeout);
  try {
    const data = JSON.parse(inputBuf);
    // Debug: dump raw JSON once so we can inspect all available fields
    try { fs.writeFileSync('/tmp/shivang-claude-statusline-last.json', JSON.stringify(data, null, 2)); } catch (e) {}

    const username = os.userInfo().username || 'user';
    const model    = data.model?.display_name || 'Claude';
    const dir      = data.workspace?.current_dir || process.cwd();
    const project  = path.basename(dir);
    const branch   = getGitBranch(dir);
    const sessionId = data.session_id || '';
    const sessionCost = data.cost?.total_cost_usd || 0;

    // Context bar
    const ctxBar = buildContextBar(
      data.context_window?.remaining_percentage,
      data.context_window?.total_tokens
    );

    // Write context bridge file for context-monitor hook
    if (sessionId && !/[/\\]|\.\./.test(sessionId) && data.context_window?.remaining_percentage != null) {
      try {
        const rawUsedPct = Math.round(100 - data.context_window.remaining_percentage);
        fs.writeFileSync(
          path.join(os.tmpdir(), `claude-ctx-${sessionId}.json`),
          JSON.stringify({ session_id: sessionId, remaining_percentage: data.context_window.remaining_percentage, used_pct: rawUsedPct, timestamp: Math.floor(Date.now() / 1000) })
        );
      } catch (e) {}
    }

    // Rate limits (real plan usage) from stdin + session cost
    const rateLimitSeg = buildRateLimitSegment(data.rate_limits);
    const costSeg = `\x1b[2m$${sessionCost.toFixed(2)}\x1b[0m`;

    // Session activity: skills (→ line 2) + total tool-call count (→ line 1)
    const session = accumulateSession(sessionId, data.transcript_path);
    const skillLines = buildSkillLines(getEnabledPlugins(), session.skills);
    const toolsSeg = session.tools > 0 ? `\x1b[2m🔧 ${session.tools}\x1b[0m` : null;
    const sessions = countClaudeSessions();
    const sessSeg = sessions > 0
      ? `\x1b[2m🤖 ${sessions}${session.agents > 0 ? ` (+${session.agents})` : ''}\x1b[0m`
      : null;

    // ── Compose ────────────────────────────────────────────────────────────
    const sep = '\x1b[2m │ \x1b[0m';

    const userSeg    = `\x1b[36;1m${username}\x1b[0m`;
    const modelSeg   = `\x1b[2m${model}\x1b[0m`;
    const repoSeg    = branch
      ? `\x1b[2m${project}\x1b[0m\x1b[2m[\x1b[0m\x1b[35m${branch}\x1b[0m\x1b[2m]\x1b[0m`
      : `\x1b[2m${project}\x1b[0m`;

    const parts = [userSeg, modelSeg, repoSeg];
    if (ctxBar)       parts.push(ctxBar);
    if (rateLimitSeg) parts.push(rateLimitSeg);
    parts.push(costSeg);
    if (toolsSeg)     parts.push(toolsSeg);
    if (sessSeg)      parts.push(sessSeg);

    const line1 = parts.join(sep);
    process.stdout.write([line1, ...skillLines].join('\n') + '\n');
  } catch (e) {
    process.stdout.write('');
  }
});
