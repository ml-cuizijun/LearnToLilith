#!/usr/bin/env bash
# 清除集群架构章节的 TipTap 缓存（需先 Cmd+Q 完全退出 Cursor）。
set -euo pipefail

WS_ROOT="$HOME/Library/Application Support/Cursor/User/workspaceStorage"

if pgrep -xq Cursor; then
  echo "请先 Cmd+Q 完全退出 Cursor，再运行本脚本。" >&2
  exit 1
fi

targets=(
  "03-Kubernetes/01-集群架构/知识点.md"
  "04-Kubernetes/01-集群架构/知识点.md"
  "03-Kubernetes/01-集群架构/练习题.md"
  "04-Kubernetes/01-集群架构/练习题.md"
)

found=0
while IFS= read -r -d '' wsjson; do
  if ! grep -q "LearnToLilith" "$wsjson" 2>/dev/null; then
    continue
  fi
  db="$(dirname "$wsjson")/state.vscdb"
  [[ -f "$db" ]] || continue

  python3 - "$db" "${targets[@]}" <<'PY'
import json, sqlite3, sys
from urllib.parse import quote, unquote

db, *needles = sys.argv[1:]
conn = sqlite3.connect(db)
row = conn.execute("SELECT value FROM ItemTable WHERE key='memento/markdownEditor'").fetchone()
if not row:
    print(f"跳过（无 markdownEditor 缓存）: {db}")
    sys.exit(0)

data = json.loads(row[0])
vs = data.get("markdownEditorViewState", [])
kept, removed = [], []
for uri, state in vs:
    path = unquote(uri.removeprefix("file://"))
    if any(n in path for n in needles):
        removed.append(path)
    else:
        kept.append([uri, state])

if not removed:
    print(f"跳过（未命中集群架构）: {db}")
    sys.exit(0)

data["markdownEditorViewState"] = kept
conn.execute(
    "UPDATE ItemTable SET value=? WHERE key='memento/markdownEditor'",
    (json.dumps(data, ensure_ascii=False),),
)
conn.commit()
print(f"已清除 {len(removed)} 条缓存 @ {db}")
for p in removed:
    print(f"  - {p}")
PY
  found=1
done < <(find "$WS_ROOT" -name workspace.json -print0 2>/dev/null)

if [[ "$found" -eq 0 ]]; then
  echo "未找到 LearnToLilith 工作区。"
else
  echo
  echo "完成。重新打开 Cursor → 打开集群架构/知识点.md → 应能看到 learnPreview: 3 的 frontmatter。"
fi
