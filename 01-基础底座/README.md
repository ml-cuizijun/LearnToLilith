# 01 基础底座

> **基础运维完整底座**（过关生死线）。先会**排查刀法**，再啃主机/网络原理，再到接入与观测体系。  
> 数据库 / Shell / Python / Go 深挖在 **02、05**；本章 **28 章都要会**，权重只决定先看哪。  
> 写法以 [12-网络栈与Socket](12-网络栈与Socket/) 为详度样板：总图 → 走读 → 名词 → 易混专节 → 定责。

---

## 目录

### 一、排查刀法（值班第一刀）

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 01 | [主机排查命令](01-主机排查命令/) | ★★★★★ | top/mpstat/free/iostat/ps/journalctl 刀法与输出解读 |
| 02 | [网络排查命令](02-网络排查命令/) | ★★★★★ | ss/curl -w/dig/mtr/nc/tcpdump 速查与场景闭环 |
| 03 | [文本三剑客](03-文本三剑客/) | ★★★★★ | grep/sed/awk（+ jq 点到）值班 one-liner |

### 二、主机原理

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 04 | [内核与系统](04-内核与系统/) | ★★★★ | 用户态/内核态、syscall、journal/dmesg、包管理、救援模式 |
| 05 | [进程与信号](05-进程与信号/) | ★★★★★ | R/S/D/Z、kill vs -9、strace、优雅退出、core dump |
| 06 | [CPU 与 Load](06-CPU与Load/) | ★★★★★ | Load≠util、软中断、steal、throttle、perf、NUMA |
| 07 | [内存与 OOM](07-内存与OOM/) | ★★★★★ | RSS/Cache、OOM、cgroup、泄漏 vs 打满、THP |
| 08 | [磁盘与 IO](08-磁盘与IO/) | ★★★★ | await、inode、D 状态、脏页、SSD 调度器 |
| 09 | [文件系统与 inode](09-文件系统与inode/) | ★★★★ | inode 满、XFS/ext4、fstab/UUID、删文件不释放 |
| 10 | [cgroup 与容器](10-cgroup与容器/) | ★★★★ | namespace/cgroup、throttle、limit 和 K8s |
| 11 | [Systemd 与服务管理](11-Systemd与服务管理/) | ★★★★ | unit、Restart、journalctl、Timer **和 crontab 排障** |

### 三、网络原理与排障

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 12 | [网络栈与 Socket](12-网络栈与Socket/) | ★★★★★ | 连接队列、TW/CW、fd、conntrack |
| 13 | [TCP 与 UDP](13-TCP与UDP/) | ★★★★★ | 握手挥手、重传、长连接、KCP/UDP |
| 14 | [HTTP 与 TLS](14-HTTP与TLS/) | ★★★★★ | 499/502/504、Keep-Alive、证书 |
| 15 | [DNS 与 CDN](15-DNS与CDN/) | ★★★★ | 解析链路、hosts/resolv、TTL、回源 |
| 16 | [网络排障与抓包](16-网络排障与抓包/) | ★★★★★ | 分层、tcpdump、MTU、TSO 假 checksum |
| 17 | [iptables 与 conntrack](17-iptables与conntrack/) | ★★★★ | 五链四表、NAT、表满、firewalld |
| 18 | [LVS 与四层负载均衡](18-LVS与四层负载均衡/) | ★★★★ | NAT/DR、四层 vs 七层、keepalived 脑裂 |

### 四、接入层

| # | 章 | 权重 | 必会 | 和后面模块怎么分 |
|---|----|------|------|------------------|
| 19 | [Nginx](19-Nginx/) | ★★★★★ | 502/504/499、超时链、限流、reload、upstream keepalive | 动态网关/APISIX 在 02 |
| 20 | [HAProxy 与 Keepalived](20-HAProxy与Keepalived/) | ★★★★ | HAProxy、Keepalived、VPN、正向代理 | LVS 在 18，Nginx 在 19 |

### 五、观测与体系

| # | 章 | 权重 | 必会 | 和后面模块怎么分 |
|---|----|------|------|------------------|
| 21 | [性能观测与排障](21-性能观测与排障/) | ★★★★★ | 30 秒全景、USE/RED、火焰图 | 命令刀法在 01/02 |
| 22 | [监控与告警](22-监控与告警/) | ★★★★★ | 主机黄金指标、分级、告警风暴、blackbox | PromQL 深挖在 K8s 18 |
| 23 | [日志运维](23-日志运维/) | ★★★★★ | logrotate/journal/rsyslog、采集、ELK vs Loki | 集群日志在 K8s 19；过滤在 03 |
| 24 | [内核参数与 sysctl](24-内核参数与sysctl/) | ★★★★★ | somaxconn、fd、tw_reuse、容器 sysctl | 含义链 12/13 |
| 25 | [NTP 与时间同步](25-NTP与时间同步/) | ★★★★ | Chrony、证书/日志/游戏结算 | |
| 26 | [高可用与容灾](26-高可用与容灾/) | ★★★★★ | RTO/RPO、主备、脑裂、3-2-1 备份 | 云多 AZ / 游戏 SLO 在 06、07 |
| 27 | [Linux 安全加固](27-Linux安全加固/) | ★★★★ | 用户权限/SUID、SSH、sudo、SELinux、auditd | |
| 28 | [堡垒机与跳板机](28-堡垒机与跳板机/) | ★★★★ | 唯一入口、审计、禁止直连 | SSH 加固细节在 02 |

Shell / Python / Go 深挖 → [05 开发能力](../05-开发能力/) · 正则深挖 → [05-05](../05-开发能力/05-正则与文本处理/)

---

## 不会就过不了

TCP 握手/TIME_WAIT/CLOSE_WAIT · HTTP 499/502/504 · OOM · CPU 高 · 抓包 · fd 耗尽 · somaxconn · Nginx 502/504 · 告警该不该叫醒 · 日志把盘打满 · RTO/RPO · **30 秒命令定域** · **三剑客过滤日志**

## 学习顺序

```
第一遍救命：01 主机命令 → 02 网络命令 → 03 三剑客 → 21 排障框架 → 06 CPU → 07 OOM → 16 抓包 → 13 TCP → 14 HTTP → 19 Nginx
第二遍主机：04/05 内核进程 → 08/09 磁盘 inode → 10 cgroup → 11 systemd → 22/23 监控日志
第三遍网络与体系：12 Socket → 15 DNS → 17/18 防火墙与 LVS → 20 HAProxy → 24 sysctl → 25 NTP → 26 HA → 27/28 安全堡垒
```

串题：[综合练习题.md](综合练习题.md) · 项目故事：[项目深挖模板.md](项目深挖模板.md)
