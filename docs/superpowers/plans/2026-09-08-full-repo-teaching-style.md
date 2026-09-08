# 全库教学样板改造 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把全库 173 章 `知识点.md` 统一到 `01-基础底座/13-TCP与UDP/知识点.md` 的教学样板：讲透、好懂、不长篇。

**Architecture:** 先改 `GOLDEN_STYLE.md` 固化规则 → 按模块分批改写（每批 4～6 章并行）→ 每章自检行数/读图/❓/技术口径 → 进度记入 `docs/superpowers/plans/2026-09-08-teaching-style-TRACKER.md`。

**Tech Stack:** Markdown + mermaid；样板章 `13-TCP与UDP`；标准见根目录 `GOLDEN_STYLE.md`。

## Global Constraints

- 样板：`01-基础底座/13-TCP与UDP/知识点.md`（已达标，勿回退）
- 行数硬顶：**550～800**（800 封顶）
- 嵌套列表拉开层级；难概念加 `#### ❓ …`；图后 `- 📖 **读图**`
- 保留技术正确性与练习题交叉引用；不滥加表格；mermaid 无 `classDef`
- 练习题.md 本轮可不改，除非正文改了关键口径导致题干错误

---

### Task 0: 固化 GOLDEN_STYLE

- [ ] 把「透彻不长篇 / 嵌套列表 / ❓ 为什么 / 读图列表 / 图标」写入 `GOLDEN_STYLE.md`
- [ ] 建立 TRACKER，勾选 13 章为 done

### Task 1: 01-基础底座 第一批（邻接 13）

- [ ] `12-网络栈与Socket`（890→≤800 + 样板）
- [ ] `14-HTTP与TLS`
- [ ] `16-网络排障与抓包`
- [ ] `34-主机排查命令`
- [ ] `05-进程与信号`
- [ ] `06-CPU与Load`

### Task 2～N: 按模块扫完

- [ ] 01 余下 26 章
- [ ] 02 中间件
- [ ] 03 K8s
- [ ] 04～10

**每章验收：**

1. `wc -l` ≤ 800  
2. 至少 1 个 `#### ❓`（工具纯命令章可例外，但须有等价「别混/为什么」）  
3. 每张主图/机制图后有 `- 📖 **读图**`  
4. 开篇 3 行 + 🎯 一句话 + 合上书仍在  
5. 无元叙述目录；关键易混点有 ⚠️  
