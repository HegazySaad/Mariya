# AGENTS.md

<!-- handoff:learnings:begin -->
## Session Learnings (auto-updated by handoff)

### Implicit Rules
- User preferences: talk to user in Egyptian Arabic; no tashkeel, no emoji; user called abu Mariya or Hegazy, never misspell as Hegazy-variant
- Do not create PR unless asked; commit only on branch claude/beautiful-franklin-2q9v5n
- Skill needs Python 3.10+, claude and codex CLIs authenticated
- Install commands for user machine: /plugin marketplace add chaseai-yt/claudex-loop then /plugin install claudex-loop@claudex-loop, or npx skills add chaseai-yt/claudex-loop

### Key Decisions
- Decision: install at project level in /home/user/Mariya/.claude/skills — Reason: cloud container ephemeral, no user machine attached, cannot write personal ~/.claude/skills
- Decision: grep-vet runner.py before copying — Reason: runner executes commands on host; found only git/codex/claude subprocess, no network libs, no shell=True
- Decision: commit+push to claude/beautiful-franklin-2q9v5n — Reason: Stop hook feedback demanded it for untracked files; no PR created since not requested
- Decision: default roles are host builds, other provider inspects — Reason: README; reel-style flow needs builder=codex reviewer_model=gpt-6-astra
- Decision: treat reel text FABLE 3.5 as likely AI misread — Reason: repo says Fable 5.1

<!-- handoff:learnings:end -->
