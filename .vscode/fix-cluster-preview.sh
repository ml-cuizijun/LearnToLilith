#!/usr/bin/env bash
# 一键修复集群架构 Preview：红标题 + 全宽 + 清 TipTap 缓存
# 用法：Cmd+Q 退出 Cursor → bash .vscode/fix-cluster-preview.sh → 重开 Cursor
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if pgrep -xq Cursor; then
  echo "请先 Cmd+Q 完全退出 Cursor，再运行本脚本。" >&2
  exit 1
fi

bash "$ROOT/.vscode/apply-cursor-preview-red.sh"
bash "$ROOT/.vscode/clear-markdown-editor-cache.sh"

echo
echo "完成。重新打开 Cursor → 打开 01-集群架构/知识点.md"
echo "  ① Revert File（若标签有未保存圆点）"
echo "  ② 点 Preview → Cmd+F 搜「四、对账」"
echo "  ③ 标题应变红、内容应铺满宽度、Mermaid 应渲染成图"
