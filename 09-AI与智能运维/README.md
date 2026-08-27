# 09 AI 与智能运维

> **加分模块，不是过关生死线。** 实用 > 原理：会用 LLM 提效、能讲清 RAG、懂工具调用/MCP/Agent 边界、集群有 GPU 会运维、AIOps 不吹自动修。  
> 生产数据/密钥不出域；AI 只做草稿和只读；写操作必须人审；模型会幻觉。

---

## 目录

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 01 | [LLM 与 Transformer 基础](01-LLM与Transformer基础/) | ★★★★ | token/上下文/温度/幻觉；开闭源怎么选 |
| 02 | [Prompt 工程](02-Prompt工程/) | ★★★★ | 结构化 prompt、few-shot、运维场景怎么写 |
| 03 | [RAG 检索增强](03-RAG检索增强/) | ★★★★★ | 切块→embedding→检索→生成；向量库挂在这章 |
| 04 | [Function Calling 与 Tool Use](04-Function-Calling与Tool-Use/) | ★★★★ | 调监控/只读命令；schema、审批 |
| 05 | [MCP 协议](05-MCP协议/) | ★★★★ | 是什么、和 Function Calling 的关系、落地 |
| 06 | [Agent 智能体](06-Agent智能体/) | ★★★★ | ReAct、工具/记忆、失控防护 |
| 07 | [AI 工具实战与 Vibe Coding](07-AI工具实战与Vibe-Coding/) | ★★★★★ | Cursor/CLI 提效；什么不能交给模型 |
| 08 | [GPU 与推理服务运维](08-GPU与推理服务运维/) | ★★★★★ | K8s GPU、显存/OOM、TTFT、vLLM vs Ollama |
| 09 | [AIOps 落地](09-AIOps落地/) | ★★★★ | 降噪、根因辅助、边界：不能自动修 |

LangChain / Dify 等框架名不单开章：编排一句挂 Agent，推理引擎挂 GPU。

---

## 复习路线

- **必须吃透**：03 RAG、04 Function Calling、05 MCP、07 工具实战、08 GPU
- **要会用**：02 Prompt、06 Agent
- **建立直觉**：01 LLM 基础
- **看项目**：09 AIOps（有落地是加分，没有也要能讲边界）
