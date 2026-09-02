#!/usr/bin/env bash
# 把红色标题 CSS 注入 Cursor 的 Preview|Markdown（TipTap）工作台。
# Cursor 更新后若颜色消失，再跑一次本脚本即可。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/cursor-preview-red.css"
WB_DIR="/Applications/Cursor.app/Contents/Resources/app/out/vs/code/electron-sandbox/workbench"
WB_HTML="$WB_DIR/workbench.html"
DST="$WB_DIR/learntolilith-preview-red.css"
MARK_BEGIN="<!-- LearnToLilith preview-red BEGIN -->"
MARK_END="<!-- LearnToLilith preview-red END -->"
LINK_TAG="<link rel=\"stylesheet\" href=\"./learntolilith-preview-red.css\">"

if [[ ! -f "$SRC" ]]; then
  echo "缺少 $SRC" >&2
  exit 1
fi
if [[ ! -f "$WB_HTML" ]]; then
  echo "找不到 Cursor workbench.html：$WB_HTML" >&2
  exit 1
fi

cp "$SRC" "$DST"
echo "已复制 CSS → $DST"

# 去掉旧注入
if grep -q "LearnToLilith preview-red BEGIN" "$WB_HTML"; then
  # macOS BSD sed
  sed -i '' "/LearnToLilith preview-red BEGIN/,/LearnToLilith preview-red END/d" "$WB_HTML"
fi

# 在 </head> 前插入
tmp="$(mktemp)"
awk -v begin="$MARK_BEGIN" -v end="$MARK_END" -v link="$LINK_TAG" '
  /<\/head>/ && !done {
    print "\t\t" begin
    print "\t\t" link
    print "\t\t" end
    done=1
  }
  { print }
' "$WB_HTML" > "$tmp"
mv "$tmp" "$WB_HTML"

echo "已注入 workbench.html"
echo
echo "下一步：完全退出 Cursor（Cmd+Q）再打开，用顶部 Preview 看 12/13 章。"
echo "若提示安装损坏，选「仍然打开」即可（仅多了一条本仓库样式表）。"
