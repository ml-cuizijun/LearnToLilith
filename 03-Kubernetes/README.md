# 03 Kubernetes

> 中大厂 SRE 考察占 30% 以上。7–10 年要求：**能讲控制面原理、能排生产故障、能做发布和节点操作**，不是会写 YAML。  
> kubectl/YAML 入门不单开。

> **编号 = 阅读顺序**：控制面 → 工作负载 → 网络存储安全 → 流量与发布 → 观测 → 应用与前沿，越靠前越基础。标 🚧 的是目录已建、**内容待写**。

---

## 目录

### 控制面

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 01 | [集群架构](01-集群架构/) | ★★★★★ | 声明式、控制循环、各组件职责、组件挂了对业务的影响面 |
| 02 | [etcd](02-etcd/) | ★★★★ | Raft、quorum、备份恢复、etcd 挂了 Pod 还在不在 |
| 03 | [API Server](03-API-Server/) | ★★★★ | 认证鉴权准入、限流、审计、唯一入口 |

### 工作负载

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 04 | [Pod 生命周期](04-Pod生命周期/) | ★★★★★ | 三探针、优雅退出、QoS、preStop、游戏有状态能杀吗 |
| 05 | [工作负载控制器](05-工作负载控制器/) | ★★★★★ | Deploy/STS/DS/Job 怎么选，滚动更新，PDB |
| 06 | [调度](06-调度机制/) | ★★★★ | 预选优选、亲和/反亲和、污点、资源不足 Pending |
| 07 | [弹性伸缩](07-弹性伸缩/) | ★★★★ | HPA 指标、自定义指标、HPA 解决不了有状态游戏服什么问题 |

### 网络 / 存储 / 配置 / 安全

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 08 | [Service 与 kube-proxy](08-Service与kube-proxy/) | ★★★★★ | 四种 Service、Endpoints 为空、iptables vs IPVS |
| 09 | [CoreDNS](09-CoreDNS/) | ★★★★ | 解析链路、ndots、DNS 打满、故障排查 |
| 10 | [CNI 与网络策略](10-CNI与网络策略/) | ★★★★★ | Pod IP 从哪来、Calico/Flannel 差异、NetworkPolicy |
| 11 | [存储](11-存储/) | ★★★★ | PV/PVC/SC、CSI、RWO vs RWX、丢盘 |
| 12 | [配置与密钥](12-配置与密钥/) | ★★★ | 注入方式、热更新、Secret 不是保险箱 |
| 13 | [RBAC 与安全](13-RBAC与安全/) | ★★★★ | SA、RoleBinding、PSS、最小化权限、配额与租户 |
| 14 | [证书与 kubeconfig](14-证书与kubeconfig/) | ★★★★ | 集群 CA 体系、证书到期集群失联、kubeconfig 结构与多集群切换 |

### 流量入口与发布

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 15 | [Ingress 与流量管理](15-Ingress与流量管理/) | ★★★★ | Ingress vs Gateway API、三层模型、长连接、证书、金丝雀 |
| 16 | [灰度与回滚](16-灰度与回滚/) | ★★★★★ | 滚动/蓝绿/金丝雀、回滚 RTO、游戏服灰度约束 |
| 17 | [节点、运行时与升级](17-节点运行时与升级/) | ★★★★ | cordon/drain、containerd、集群升级、驱逐 |
| 18 | [典型故障剧本](18-典型故障剧本/) | ★★★★★ | Pending/CrashLoop/OOMKilled/Evicted/网络不通——按现象查分支 |

### 可观测性（体系与方法论已迁到 09 章）

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 19 | [监控与可观测性](19-监控与可观测性/) | ★★★★★ | K8s 场景怎么接：指标分层、kube-state-metrics、集群黄金指标 |
| 20 | [日志管理](20-日志管理/) | ★★★★★ | 采集架构、DaemonSet vs Sidecar、容器日志轮转 |

Prometheus/PromQL、告警设计、SLI/SLO、链路追踪、故障复盘 → [09 可观测性与 SRE 方法论](../09-可观测性与SRE方法论/)

### 应用管理与前沿

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 21 | [Operator 与 CRD](21-Operator与CRD/) | ★★★ | 控制器模式、何时自研、别把 Operator 当银弹 |
| 22 | [Helm 与 Kustomize](22-Helm与Kustomize/) | ★★★★★ | Chart 结构、模板渲染、release 回滚、Kustomize overlay/patch |
| 23 | [GitOps：ArgoCD 与 Tekton](23-GitOps-ArgoCD与Tekton/) | ★★★★★ | GitOps 原理、ArgoCD 同步/self-heal/回滚、Tekton Pipeline |
| 24 | [ServiceMesh：Istio 与 Envoy](24-ServiceMesh-Istio与Envoy/) | ★★★★ | Sidecar 模型与成本、和 Ingress 的分界、mTLS/流量治理、什么时候不该上 |
| 25 | [eBPF 与 Cilium](25-eBPF与Cilium/) | ★★★★ | eBPF 原理、Cilium 替代 kube-proxy、Hubble 可观测、L7 策略 |
| 26 | [多集群与联邦](26-多集群与联邦/) | ★★★ | 为什么多集群、Karmada/舰队思路、跨集群流量与配置一致性 |

---

## 不会就过不了

Pod Pending / CrashLoop · 三探针区别 · Service Endpoints 为空 · 滚动更新与就绪探针 · drain 会怎样 · 资源 limit 与 OOMKilled · 集群证书过期

串题：[综合练习题.md](综合练习题.md) · 项目故事：[项目深挖模板.md](项目深挖模板.md)

ServiceMesh / Istio 已单开：[24 ServiceMesh](24-ServiceMesh-Istio与Envoy/)；[15 Ingress](15-Ingress与流量管理/) 只留南北向入口，不再承担 Mesh 概念。Thanos 挂 09 章。
