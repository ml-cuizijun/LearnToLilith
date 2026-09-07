# TCP 与 UDP Chapter Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 TCP 与 UDP 知识点章节压缩到 600～700 行，改成自然、易懂且技术严谨的连接生命周期叙事。

**Architecture:** 只修改一个知识点文件，保留现有九个顶层标题及顺序以兼容练习题引用。先建立旧考点清单，再整体重写，最后通过结构、术语、链接和技术口径检查验收。

**Tech Stack:** Markdown、Mermaid、Bash/Python 静态检查、Git

## Global Constraints

- 只修改 `01-基础底座/13-TCP与UDP/知识点.md`。
- 正文总行数必须在 600～700 行。
- 保留选型、握手、传输、保活、关闭、UDP/KCP/QUIC、排障主线。
- 不删除握手、挥手、滑动窗口、流量控制、拥塞控制、重传、心跳、TIME_WAIT/CLOSE_WAIT 等高频考点。
- 不把 `ss -ti` 的 `rcv_space` 当作对端通告窗口或 ZeroWindow 的单一证据。
- 保留现有九个顶层标题及其顺序。

---

### Task 1: 建立重写基线

**Files:**
- Read: `01-基础底座/13-TCP与UDP/知识点.md`
- Read: `01-基础底座/13-TCP与UDP/练习题.md`
- Read: `docs/superpowers/specs/2026-09-07-tcp-udp-chapter-refactor-design.md`

**Interfaces:**
- Consumes: 现有章节考点、练习题的节名引用、已批准设计。
- Produces: 重写时必须保留的九节结构和术语检查清单。

- [ ] **Step 1: 记录现有顶层标题**

Run:

```bash
rg '^## ' '01-基础底座/13-TCP与UDP/知识点.md'
```

Expected: 依次出现“一、一张图”到“九、收口”以及“合上书”。

- [ ] **Step 2: 记录高频术语基线**

Run:

```bash
for term in 三次握手 四次挥手 字节流 粘包 滑动窗口 流量控制 拥塞控制 RTO 快速重传 SACK TIME_WAIT CLOSE_WAIT 心跳 KCP QUIC; do
  rg -q "$term" '01-基础底座/13-TCP与UDP/知识点.md' || exit 1
done
```

Expected: exit 0。

### Task 2: 重写知识点正文

**Files:**
- Modify: `01-基础底座/13-TCP与UDP/知识点.md`

**Interfaces:**
- Consumes: Task 1 的九节结构和术语清单。
- Produces: 600～700 行、可独立阅读的 TCP/UDP 知识点正文。

- [ ] **Step 1: 重写开篇与一、二节**

保留三行开篇、连接生命周期主图、TCP/UDP 选型和粘包/拆包。每个机制只保留一套图文表达；应用层定界明确为长度前缀、分隔符、定长三种。

- [ ] **Step 2: 重写三、四节**

握手图保留标准 `seq/ack` 和两端状态；传输部分按“为什么能连续发 → 谁限制发送量 → 丢包后如何补 → 如何避免灌爆网络”展开。保留可靠性七件套，压缩算法支线。

- [ ] **Step 3: 重写五、六节**

把半打开、心跳、NAT/LB 空闲超时、Nagle、切网串成“连接仍显示 ESTAB 为什么也会失效”；把挥手、半关闭、TIME_WAIT/CLOSE_WAIT 串成关闭过程。复用选项只保留生产必需边界。

- [ ] **Step 4: 重写七、八、九节和合上书**

UDP/KCP/QUIC 只讲能力边界；排障以“未建立 / 已建立但慢 / 空闲后断 / 关闭残留”分流。命令速查、面试锚点和易错项只保留正文未重复出现的压缩口径。

- [ ] **Step 5: 检查行数**

Run:

```bash
wc -l '01-基础底座/13-TCP与UDP/知识点.md'
```

Expected: 600～700 行。

### Task 3: 技术与结构验证

**Files:**
- Verify: `01-基础底座/13-TCP与UDP/知识点.md`

**Interfaces:**
- Consumes: Task 2 重写后的正文。
- Produces: 满足设计稿验收标准的最终章节。

- [ ] **Step 1: 验证标题兼容**

Run:

```bash
python3 - <<'PY'
from pathlib import Path
import re
p = Path("01-基础底座/13-TCP与UDP/知识点.md")
heads = re.findall(r"^## (.+)$", p.read_text(), re.M)
expected = [
    "一、一张图：连接的一生",
    "二、选型：这条道用 TCP 还是 UDP",
    "三、出生：三次握手",
    "四、干活：滑动窗口与重传",
    "五、老去：为什么「还连着」也断",
    "六、死亡：挥手与 TIME_WAIT / CLOSE_WAIT",
    "七、另一条路：UDP / KCP / QUIC",
    "八、作战：`ss -ti` + 定责",
    "九、收口",
    "合上书",
]
assert heads == expected, (heads, expected)
PY
```

Expected: exit 0。

- [ ] **Step 2: 验证术语、代码块与重复口径**

Run:

```bash
python3 - <<'PY'
from pathlib import Path
import re
t = Path("01-基础底座/13-TCP与UDP/知识点.md").read_text()
terms = ["三次握手", "四次挥手", "字节流", "粘包", "滑动窗口", "流量控制",
         "拥塞控制", "RTO", "快速重传", "SACK", "TIME_WAIT", "CLOSE_WAIT",
         "心跳", "KCP", "QUIC"]
assert all(term in t for term in terms)
assert t.count("```") % 2 == 0
assert "classDef" not in t
assert not re.search(r"rcv_space[^。\n]*(对端|通告窗口|ZeroWindow)", t)
PY
```

Expected: exit 0。

- [ ] **Step 3: 验证本地 Markdown 链接目标**

Run:

```bash
python3 - <<'PY'
from pathlib import Path
import re
p = Path("01-基础底座/13-TCP与UDP/知识点.md")
for target in re.findall(r"\]\(([^)#]+)(?:#[^)]+)?\)", p.read_text()):
    if "://" not in target:
        assert (p.parent / target).resolve().exists(), target
PY
```

Expected: exit 0。

- [ ] **Step 4: 检查编辑器诊断并审阅差异**

Run:

```bash
git diff --check
git diff --stat -- '01-基础底座/13-TCP与UDP/知识点.md'
```

Expected: `git diff --check` exit 0，差异仅包含目标知识点文件。

- [ ] **Step 5: 提交章节重构**

```bash
git add -- '01-基础底座/13-TCP与UDP/知识点.md'
git commit -m 'Refactor TCP and UDP chapter for clarity'
```
