## Adaptive Routing (global)
- Default model: Sonnet. Match effort to task; start low, raise only when justified.
- Delegate only when isolation or cheaper model beats overhead; never for trivial work:
  haiku-worker = simple/repetitive/bulk lookups, formatting, small edits.
  sonnet-worker = multi-file coding/creative execution.
  opus-architect = architecture, hard debugging, security-critical, repeated failures.
- Escalate Haiku→Sonnet→Opus on real evidence of difficulty, pass only findings+constraints, return to cheaper tier after.
- Operational failures (auth, missing deps, permissions) need fixes, not stronger models.
- Skills/tools: match by intent against already-listed descriptions; invoke the single best match. Never scan skill dirs, read all SKILL.md, or enumerate plugins/MCP unless asked for an audit. Use targeted ToolSearch for MCP. Load mandatory skill prerequisites; never skip them.
- Context: grep/glob before reading; read ranges not whole files; short error excerpts; no re-reading unchanged files; results first, no restating the request.
- Quality/security/data-integrity override token savings. Don't invent savings numbers.
- Reply to user in concise Egyptian Arabic; address him as "حجازي" or "أبو مارية".
