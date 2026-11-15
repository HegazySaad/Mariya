#!/usr/bin/env bash
# Same logic as install.ps1 (Linux/macOS/Git-Bash). Needs python3 for JSON.
set -e
src="$(cd "$(dirname "$0")" && pwd)"; dst="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$dst/agents"; bk="$dst/backups/routing-$(date +%Y%m%d-%H%M%S)"; mkdir -p "$bk"
for f in CLAUDE.md settings.json; do [ -f "$dst/$f" ] && cp "$dst/$f" "$bk/"; done
cp -r "$dst/agents" "$bk/agents"
python3 - "$src" "$dst" <<'PY'
import sys,re,json,os
src,dst=sys.argv[1:]
blk="<!-- routing:start -->\n"+open(f"{src}/CLAUDE.global.md",encoding="utf-8").read().rstrip()+"\n<!-- routing:end -->"
p=f"{dst}/CLAUDE.md"; cur=open(p,encoding="utf-8").read() if os.path.exists(p) else ""
pat=re.compile(r"<!-- routing:start -->.*?<!-- routing:end -->",re.S)
cur=pat.sub(lambda m:blk,cur) if pat.search(cur) else (cur.rstrip()+"\n\n"+blk+"\n").lstrip()
open(p,"w",encoding="utf-8").write(cur)
for a in os.listdir(f"{src}/agents"):
    t=f"{dst}/agents/{a}"
    if os.path.exists(t): print("kept existing",a)
    else: open(t,"w",encoding="utf-8").write(open(f"{src}/agents/{a}",encoding="utf-8").read())
s=f"{dst}/settings.json"; j=json.load(open(s,encoding="utf-8")) if os.path.exists(s) else {}
if "model" not in j: j["model"]="sonnet"; json.dump(j,open(s,"w",encoding="utf-8"),indent=2); print("settings: model=sonnet added")
else: print("settings: model already set, untouched")
PY
echo "Done. Backup: $bk"
