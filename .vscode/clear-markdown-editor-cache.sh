#!/usr/bin/env bash
# 清除 TipTap Preview 缓存（需先 Cmd+Q 完全退出 Cursor）。
# 集群架构反复只显示 3 节时：Cmd+Q → 本脚本 → 重开 → 关掉旧标签 → 只打开 知识点.md
set -euo pipefail

WS_ROOT="$HOME/Library/Application Support/Cursor/User/workspaceStorage"
GS_DB="$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb"

if pgrep -xq Cursor; then
  echo "请先 Cmd+Q 完全退出 Cursor，再运行本脚本。" >&2
  exit 1
fi

cluster_needles=(
  "03-Kubernetes/01-集群架构"
  "04-Kubernetes/01-集群架构"
  "01-集群架构/知识点"
  "01-集群架构/集群架构"
)

found=0
while IFS= read -r -d '' wsjson; do
  if ! grep -q "LearnToLilith" "$wsjson" 2>/dev/null; then
    continue
  fi
  db="$(dirname "$wsjson")/state.vscdb"
  [[ -f "$db" ]] || continue

  # 整表删除 markdownEditor（比按 URI 删更彻底）
  sqlite3 "$db" "DELETE FROM ItemTable WHERE key='memento/markdownEditor';"
  echo "已清除 workspace markdownEditor 缓存: $db"
  found=1
done < <(find "$WS_ROOT" -name workspace.json -print0 2>/dev/null)

if [[ -f "$GS_DB" ]]; then
  python3 - "$GS_DB" "${cluster_needles[@]}" <<'PY'
import json, sqlite3, sys
from urllib.parse import unquote

db, *needles = sys.argv[1:]
conn = sqlite3.connect(db)
key = "cursor/markdownEditorModePreferences"
row = conn.execute("SELECT value FROM ItemTable WHERE key=?", (key,)).fetchone()
if row:
    data = json.loads(row[0])
    removed = []
    for uri in list(data.keys()):
        path = unquote(uri.removeprefix("file://"))
        if any(n in path for n in needles):
            removed.append(path)
            del data[uri]
    if removed:
        conn.execute(
            "UPDATE ItemTable SET value=? WHERE key=?",
            (json.dumps(data, ensure_ascii=False), key),
        )
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
  echo "完成。重开 Cursor 后："
  echo "  ① 关掉所有「01-集群架构」相关标签（含已删除文件的幽灵标签）"
  echo "  ② 只打开 03-Kubernetes/01-集群架构/知识点.md"
  echo "  ③ Markdown 源里 Cmd+F 搜「四、对账」应能找到"
fi
