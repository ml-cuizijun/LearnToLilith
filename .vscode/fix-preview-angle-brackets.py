#!/usr/bin/env python3
"""Fix Markdown patterns that break Cursor Preview (TipTap HTML parsing)."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# word placeholders: <pod> → {pod}  (skip regex (?P<name>...)
WORD_PLACEHOLDER = re.compile(
    r"(?<!\(\?P)<([a-z][\w-]*(?:/[\w-]+)?)>",
    re.I,
)

# numeric comparisons: <14 天, <5ms, <5000, <99%, <3s, <1024
NUM_LT = re.compile(
    r"(?<![`<\\,])<(\d+(?:\.\d+)?)([\w%./个分钟秒hMiKk]*)"
)

# registry path
REGISTRY_PATH = re.compile(
    r"/registry/<([a-z]+)>/<([a-z]+)>/<([a-z]+)>",
    re.I,
)

# mermaid raw arrows
MERMAID_ARROW = re.compile(r"<\-->")

# uppercase template like <N>, <PID> in prose
UPPER_TEMPLATE = re.compile(r"<\s*([A-Z_%→][^>\s]*)\s*>")

# common multi-char templates with special chars
SPECIAL_TEMPLATE = re.compile(r"<\s*([A-Za-z0-9%→/_、+\-]+)\s*>")


def split_inline_code(line: str) -> list[tuple[str, bool]]:
    parts: list[tuple[str, bool]] = []
    i = 0
    while i < len(line):
        if line[i] == "`":
            # double-backtick span
            if i + 1 < len(line) and line[i + 1] == "`":
                end = line.find("``", i + 2)
                if end == -1:
                    parts.append((line[i:], True))
                    return parts
                parts.append((line[i : end + 2], True))
                i = end + 2
                continue
            end = line.find("`", i + 1)
            if end == -1:
                parts.append((line[i:], True))
                return parts
            parts.append((line[i : end + 1], True))
            i = end + 1
            continue
        nxt = line.find("`", i)
        if nxt == -1:
            parts.append((line[i:], False))
            break
        parts.append((line[i:nxt], False))
        i = nxt
    return parts


# cross-chapter links ending in 知识点.md → folder link (TipTap embed bug)
CROSS_MD = re.compile(
    r"\]\((\.\./[^)]+/)知识点\.md\)",
)


def fix_segment(text: str, in_mermaid: bool) -> str:
    if in_mermaid:
        text = MERMAID_ARROW.sub("---", text)
        return text

    text = CROSS_MD.sub(r"](\1)", text)

    text = REGISTRY_PATH.sub(r"/registry/{\1}/{\2}/{\3}", text)

    def repl_num(m: re.Match[str]) -> str:
        num, suffix = m.group(1), m.group(2)
        # preserve version constraints like ,<3 inside backtick segments already skipped
        if suffix in ("", "s", "ms", "%"):
            suf_map = {"s": " 秒", "ms": "ms", "%": "%"}
            return f"小于 {num}{suf_map.get(suffix, suffix)}"
        if suffix in ("min", "分钟"):
            return f"小于 {num} 分钟"
        if suffix in ("天", "d", " 天"):
            return f"小于 {num} 天"
        if suffix.startswith("个"):
            return f"少于 {num}{suffix}"
        return f"小于 {num}{suffix}"

    text = NUM_LT.sub(repl_num, text)

    # templates with uppercase / special (before lowercase word rule)
    def repl_upper(m: re.Match[str]) -> str:
        inner = m.group(1).strip()
        return "{" + inner + "}"

    text = UPPER_TEMPLATE.sub(repl_upper, text)

    # lowercase placeholders like pod, ns — but skip (?P<name> regex fragments
    def repl_word(m: re.Match[str]) -> str:
        w = m.group(1)
        if w.startswith("P"):  # already handled or regex
            return m.group(0)
        return "{" + w + "}"

    text = WORD_PLACEHOLDER.sub(repl_word, text)

    return text


def fix_line(line: str, in_fence: bool, fence_lang: str) -> str:
    in_mermaid = in_fence and fence_lang == "mermaid"
    if in_fence and not in_mermaid:
        # code blocks: fix only obvious k8s/cli placeholders
        for old, new in [
            ("<pod>", "{pod}"),
            ("<ns>", "{ns}"),
            ("<name>", "{name}"),
            ("<revision>", "{revision}"),
            ("<id>", "{id}"),
            ("<file>", "{file}"),
            ("<kind>", "{kind}"),
            ("<d>", "{d}"),
            ("<PID>", "{PID}"),
            ("<pid>", "{pid}"),
        ]:
            line = line.replace(old, new)
        return line

    segments = split_inline_code(line)
    out = []
    for seg, is_code in segments:
        if is_code:
            out.append(seg)
        else:
            out.append(fix_segment(seg, in_mermaid))
    return "".join(out)


def fix_file(path: Path) -> bool:
    original = path.read_text(encoding="utf-8")
    lines = original.splitlines(keepends=True)
    in_fence = False
    fence_lang = ""
    changed = False
    out_lines = []
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("```"):
            if not in_fence:
                in_fence = True
                fence_lang = stripped[3:].strip()
            else:
                in_fence = False
                fence_lang = ""
            out_lines.append(line)
            continue
        new_line = fix_line(line, in_fence, fence_lang)
        if new_line != line:
            changed = True
        out_lines.append(new_line)
    if changed:
        path.write_text("".join(out_lines), encoding="utf-8")
    return changed


def main() -> int:
    changed_files: list[str] = []
    for path in sorted(ROOT.rglob("*.md")):
        if ".git" in path.parts:
            continue
        if fix_file(path):
            changed_files.append(str(path.relative_to(ROOT)))
    print(f"fixed {len(changed_files)} files")
    for f in changed_files:
        print(f"  {f}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
