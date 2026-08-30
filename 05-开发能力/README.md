# 05 开发能力

> **定位**：不是语言教程，是 **SRE 面试 + 值班能写** 的脚本/小工具能力。  
> **原则**：只保留必会语法、必考坑、可复制模板；语言八股、冷门 API 不收。

---

## 复习路线（按优先级）

```
04 实战题（必做）→ 01 Shell → 05 正则 → 02 Python → 03 Go
```

| # | 章 | 面试权重 | 看完你能 |
|---|----|:--------:|----------|
| 04 | [运维开发实战题](04-运维开发实战题/) | ★★★★★ | 批量 SSH、限流、巡检、告警聚合——白板/现场 coding |
| 01 | [Shell](01-Shell/) | ★★★★ | `set -euo pipefail`、trap、并发、one-liner vs 入库脚本 |
| 05 | [正则与文本处理](05-正则与文本处理/) | ★★★★ | grep/sed/awk/jq 从日志抠字段 |
| 02 | [Python 运维](02-Python运维/) | ★★★★ | timeout、线程池、exit 1、平台 API 胶水 |
| 03 | [Go 运维工具](03-Go运维工具/) | ★★★ | 读 Exporter/Operator；context、pprof（简历没写 Go 别主动展开） |

---

## 三语言怎么选（面试口径）

| 语言 | SRE 用来干什么 | 大厂常问 |
|------|----------------|----------|
| **Shell** | 编排 kubectl/systemctl/awk；开服清单、探活 | pipefail、引号、后台 wait、xargs -P |
| **Python** | HTTP JSON、Cron/CI 脚本、开服/对账 | 退出码、requests timeout、ThreadPoolExecutor |
| **Go** | Exporter、Operator、长期跑的小 Agent | goroutine 泄漏、context 取消、pprof |

**一句话**：10 行管道 → Shell；调 API + JSON → Python；常驻采集/控制器 → Go。

---

## 每章结构（与 02～05 模块不同）

1. **面试怎么考** — 直接对着背
2. **能力边界** — 别用错语言
3. **语法必会** — 带示例，不是大全
4. **原理讲透** — 图 + 为什么
5. **生产模板** — 复制改就能用
6. **必会 · 常考** + **合上书**

配套 `练习题.md`：读代码找 bug、手写片段、场景口述。
