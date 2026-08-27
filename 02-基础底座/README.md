# 02 基础底座

> **基础运维完整底座**（过关生死线）。不只 Linux 原理和网络协议：还包括服务管理、安全、监控告警、日志、接入、高可用、堡垒机。  
> 数据库 / Shell / Python / Go 在 03、06，本章点到即止。**25 章都要会**，权重只决定先看哪。  
> 写法以全库样板 [04-Kubernetes/01-集群架构](../04-Kubernetes/01-集群架构/) 为准：开篇分层框图（ASCII，打开文件就能看见）、能画就画、不能画用 1 2 3 4；练习题给场景 + 完整解答 + 追问。

---

## 目录

### 一、Linux 原理（排障前提）

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 01 | [内核与系统](01-内核与系统/) | ★★★★ | 用户态/内核态、syscall、journal/dmesg、包管理、救援模式 |
| 02 | [进程与信号](02-进程与信号/) | ★★★★★ | R/S/D/Z、kill vs -9、strace、优雅退出、core dump |
| 03 | [CPU 与 Load](03-CPU与Load/) | ★★★★★ | Load≠util、软中断、steal、throttle、perf、NUMA |
| 04 | [内存与 OOM](04-内存与OOM/) | ★★★★★ | RSS/Cache、OOM、cgroup、泄漏 vs 打满、THP |
| 05 | [磁盘与 IO](05-磁盘与IO/) | ★★★★ | await、inode、D 状态、脏页、SSD 调度器 |
| 06 | [网络栈与 Socket](06-网络栈与Socket/) | ★★★★★ | 连接队列、TW/CW、fd、conntrack |
| 07 | [cgroup 与容器](07-cgroup与容器/) | ★★★★ | namespace/cgroup、throttle、limit 和 K8s |

### 二、网络协议与排障

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 08 | [TCP 与 UDP](08-TCP与UDP/) | ★★★★★ | 握手挥手、重传、长连接、KCP/UDP |
| 09 | [HTTP 与 TLS](09-HTTP与TLS/) | ★★★★★ | 499/502/504、Keep-Alive、证书 |
| 10 | [DNS 与 CDN](10-DNS与CDN/) | ★★★★ | 解析链路、hosts/resolv、TTL、回源 |
| 11 | [网络排障与抓包](11-网络排障与抓包/) | ★★★★★ | 分层、tcpdump、MTU、TSO 假 checksum |
| 12 | [性能观测与排障](12-性能观测与排障/) | ★★★★★ | 30 秒全景、USE/RED、火焰图 |

### 三、主机运维日常（基础运维每天干的）

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 13 | [Systemd 与服务管理](13-Systemd与服务管理/) | ★★★★ | unit、Restart、journalctl、Timer **和 crontab 排障** |
| 14 | [文件系统与 inode](14-文件系统与inode/) | ★★★★ | inode 满、XFS/ext4、fstab/UUID、删文件不释放 |
| 15 | [iptables 与 conntrack](15-iptables与conntrack/) | ★★★★ | 五链四表、NAT、表满、firewalld |
| 16 | [LVS 与四层负载均衡](16-LVS与四层负载均衡/) | ★★★★ | NAT/DR、四层 vs 七层、keepalived 脑裂 |
| 17 | [Linux 安全加固](17-Linux安全加固/) | ★★★★ | 用户权限/SUID、SSH、sudo、SELinux、auditd |
| 18 | [内核参数与 sysctl](18-内核参数与sysctl/) | ★★★★★ | somaxconn、fd、tw_reuse、容器 sysctl |
| 19 | [NTP 与时间同步](19-NTP与时间同步/) | ★★★★ | Chrony、证书/日志/游戏结算 |

### 四、基础运维体系（监控、日志、接入、HA、合规）

| # | 章 | 权重 | 必会 | 和后面模块怎么分 |
|---|----|------|------|------------------|
| 20 | [高可用与容灾](20-高可用与容灾/) | ★★★★★ | RTO/RPO、主备、脑裂、3-2-1 备份 | 云多 AZ / 游戏 SLO 在 07、08 |
| 21 | [监控与告警](21-监控与告警/) | ★★★★★ | 主机黄金指标、分级、告警风暴、blackbox | PromQL 深挖/SLO 细节在 K8s 18 |
| 22 | [日志运维](22-日志运维/) | ★★★★★ | logrotate/journal/rsyslog、采集、ELK vs Loki | 集群日志在 K8s 19 |
| 23 | [Nginx](23-Nginx/) | ★★★★★ | 502/504/499、超时链、限流、reload、upstream keepalive | 动态网关/APISIX 在 03 |
| 24 | [HAProxy 与 Keepalived](24-HAProxy与Keepalived/) | ★★★★ | HAProxy、Keepalived、VPN、正向代理 | LVS 在 16，Nginx 在 23 |
| 25 | [堡垒机与跳板机](25-堡垒机与跳板机/) | ★★★★ | 唯一入口、审计、禁止直连 | SSH 加固细节在 17 |

语言和脚本不在本模块展开 → [06 开发能力](../06-开发能力/)

---

## 不会就过不了

TCP 握手/TIME_WAIT/CLOSE_WAIT · HTTP 499/502/504 · OOM · CPU 高 · 抓包 · fd 耗尽 · somaxconn · Nginx 502/504 · 告警该不该叫醒 · 日志把盘打满 · RTO/RPO

## 学习顺序

```
第一遍救命：12 排障 → 03 CPU → 04 OOM → 11 抓包 → 08 TCP → 09 HTTP → 23 Nginx → 18 sysctl
第二遍主机：13 systemd/cron → 22 日志轮转 → 21 监控告警 → 17 安全 → 20 HA
第三遍补全：05/14 磁盘 → 15 防火墙 → 16+24 LB → 19 NTP → 25 堡垒 → 01/07/10
```

串题：[综合练习题.md](综合练习题.md) · 项目故事：[项目深挖模板.md](项目深挖模板.md)
