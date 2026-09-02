#!/usr/bin/env bash
# 撤销 apply-cursor-preview-red.sh 对 Cursor 安装包的修改，消除 "installation corrupt" 提示。
set -euo pipefail

WB_DIR="/Applications/Cursor.app/Contents/Resources/app/out/vs/code/electron-sandbox/workbench"
WB_HTML="$WB_DIR/workbench.html"
DST="$WB_DIR/learntolilith-preview-red.css"

if [[ ! -f "$WB_HTML" ]]; then
  echo "找不到 Cursor workbench.html：$WB_HTML" >&2
  exit 1
fi

if grep -q "LearnToLilith preview-red BEGIN" "$WB_HTML"; then
  sed -i '' '/LearnToLilith preview-red BEGIN/,/LearnToLilith preview-red END/d' "$WB_HTML"
  echo "已从 workbench.html 移除注入"
else
  echo "workbench.html 里没有注入标记，跳过"
fi

rm -f "$DST"
echo "已删除 $DST"
echo
echo "下一步：Cmd+Q 完全退出 Cursor，再重新打开。"
echo "然后打开 01-集群架构/知识点.md → Cmd+Shift+P → Markdown Editor: Toggle Editor Mode（切两次强制重渲染）"
