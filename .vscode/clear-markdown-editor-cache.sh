#!/usr/bin/env bash
# 清除集群架构 Preview 的 TipTap 缓存（需先 Cmd+Q 完全退出 Cursor）。
set -euo pipefail

WS_ROOT="$HOME/Library/Application Support/Cursor/User/workspaceStorage"
GS_DB="$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb"

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
  sqlite3 "$db" "DELETE FROM ItemTable WHERE key='memento/markdownEditor';"
  echo "已清除 workspace markdownEditor 缓存: $db"
  found=1
done < <(find "$WS_ROOT" -name workspace.json -print0 2>/dev/null)

if [[ -f "$GS_DB" ]]; then
  python3 - "$GS_DB" "${targets[@]}" <<'PY'
import json, sqlite3, sys
from urllib.parse import unquote

db, *needles = sys.argv[1:]
conn = sqlite3.connect(db)
key = "cursor/markdownEditorModePreferences"
row = conn.execute("SELECT value FROM ItemTable WHERE key=?", (key,)).fetchone()
if not row:
    sys.exit(0)
data = json.loads(row[0])
removed = []
for uri in list(data.keys()):
    path = unquote(uri.removeprefix("file://"))
    if any(n in path for n in needles):
        removed.append(path)
        del data[uri]
if removed:
    conn.execute("UPDATE ItemTable SET value=? WHERE key=?", (json.dumps(data, ensure_ascii=False), key))
    conn.commit()
    print(f"已清除 global 模式偏好 {len(removed)} 条")
    for p in removed:
        print(f"  - {p}")
PY
fi

if [[ "$found" -eq 0 ]]; then
  echo "未找到 LearnToLilith 工作区。"
else
  echo
  echo "完成。重开 Cursor → 打开 01-集群架构/知识点.md → Revert File → Preview。"
fi
