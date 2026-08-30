# 02 中间件与数据库

> 原理和排障是必会；有没有在生产里做过主从延迟、缓存雪崩、Kafka 积压，用来定级。  
> 可观测性（Prometheus/告警/SLO/日志采集）在 [03-Kubernetes](../03-Kubernetes/) 的 18、19 章，这里不重复。

---

## 目录

| # | 章 | 权重 | 必会 |
|---|----|------|------|
| 01 | [MySQL](01-MySQL/) | ★★★★★ | 索引/Explain、事务/MVCC、主从延迟、备份恢复、大表 DDL、死锁 |
| 02 | [Redis](02-Redis/) | ★★★★★ | 持久化与 fork、热 key/大 key、集群、过期淘汰、游戏排行榜 |
| 03 | [缓存架构](03-缓存架构/) | ★★★★★ | 穿透/击穿/雪崩、一致性、旁路缓存、游戏热点活动 |
| 04 | [接入网关](04-接入网关/) | ★★★★★ | 502/504/超时链、限流；APISIX vs Nginx；长连接注意 |
| 05 | [Kafka](05-Kafka/) | ★★★★ | 分区/副本、消费组、积压、再均衡、幂等、丢消息怎么查 |
| 06 | [MongoDB](06-MongoDB/) | ★★★ | 文档模型、副本集、分片/shard key、索引、TTL |
| 07 | [分库分表与中间件](07-分库分表与中间件/) | ★★★★ | 垂直/水平拆分、分片键、跨片问题、ShardingSphere/Vitess/TiDB、迁移 |
| 08 | [注册中心与配置中心](08-注册中心与配置中心/) | ★★★ | 服务发现、Nacos/ZK/etcd、AP vs CP、配置下发 |
| 09 | [Elasticsearch](09-Elasticsearch/) | ★★★★ | 倒排/分片、yellow vs red、堆与磁盘、和 Loki/CH 怎么选 |

Nginx 配置细节以 [01-19 Nginx](../01-基础底座/19-Nginx/) 为准；本章网关只抓超时链、动态配置、和 APISIX 的差别。  
etcd 运维以 [03-02 etcd](../03-Kubernetes/02-etcd/) 为准。

PG / ClickHouse / RabbitMQ **不单开章**：高频主菜仍是 MySQL / Kafka / ES。被问到时——PG 对照 MySQL 五句、CH 看 ES 章选型、RabbitMQ/RocketMQ 看 Kafka 章怎么选。

---

综合自测：[综合练习题.md](综合练习题.md)  
项目故事：[项目深挖模板.md](项目深挖模板.md)
