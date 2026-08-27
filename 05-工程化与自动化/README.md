# 05 工程化与自动化

> 用来验证「你是不是只会 kubectl」。大厂看的是：变更可回滚、流水线可重复、基础设施可审计、故障有 oncall 机制。  
> Shell/Python/Go 在 [06-开发能力](../06-开发能力/)；GitOps（ArgoCD/Helm）在 [04-22](../04-Kubernetes/22-GitOps-ArgoCD与Tekton/)。

---

## 目录

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 01 | [Git 工作流](01-Git工作流/) | ★★★★ | 分支策略、revert vs reset、冲突、生产 hotfix、bisect |
| 02 | [CI/CD](02-CI-CD/) | ★★★★★ | 流水线阶段、制品不可变、凭证、失败策略；Jenkins 对照 |
| 03 | [制品与镜像](03-制品与镜像/) | ★★★★ | 多阶段构建、镜像膨胀、漏洞扫描、Harbor、禁 latest |
| 04 | [Ansible](04-Ansible/) | ★★★★ | 幂等、库存、Role、何时用 Ansible 何时用 Terraform |
| 05 | [Terraform](05-Terraform/) | ★★★★ | State、锁、Plan/Apply、漂移、模块、生产事故 |
| 06 | [运维平台与 Oncall](06-运维平台与Oncall/) | ★★★★★ | CMDB、工单、事件分级、值班、复盘、Runbook 边界 |
| 07 | [Docker 深度](07-Docker深度/) | ★★★★★ | 镜像分层、Dockerfile、BuildKit、瘦身、运行时 |
| 08 | [GitHub Actions 与 GitLab CI](08-GitHub-Actions与GitLab-CI/) | ★★★★ | workflow、自托管 runner、密钥、和 Jenkins 怎么选 |

密钥不单开 Vault：K8s Secret 见 [04-12](../04-Kubernetes/12-配置与密钥/)；云上 RAM/IAM 见 [07-07](../07-云平台/07-IAM与多账号/)；镜像扫描见 03。

---

综合自测：[综合练习题.md](综合练习题.md)  
项目故事：[项目深挖模板.md](项目深挖模板.md)
