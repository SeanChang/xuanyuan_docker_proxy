---
image: redislabs/redisinsight
description: "RedisInsight是Redis的官方图形用户界面（GUI）工具，支持可视化浏览和管理Redis数据库中的键值数据，提供直观的命令执行界面、实时性能监控图表、集群节点状态查看、数据导入导出及配置管理等功能，帮助开发者和运维人员更高效地操作和维护Redis实例，简化复杂数据结构的管理流程，提升工作效率。"
source: https://xuanyuan.cloud/zh/r/redislabs/redisinsight
canonical: https://xuanyuan.cloud/zh/r/redislabs/redisinsight
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/redislabs/redisinsight" title="redislabs/redisinsight Docker 镜像中文简介、标签列表与拉取命令">redislabs/redisinsight — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/redislabs/redisinsight" title="redislabs/redisinsight Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/redislabs/redisinsight</a>

# RedisInsight：Redis图形化管理工具


## 简介  
RedisInsight是Redis官方推出的图形化管理工具，专为简化Redis数据库的日常操作设计。相比传统命令行工具，它通过直观的可视化界面，帮助用户更轻松地管理数据、执行命令、监控性能，覆盖开发、运维、学习等多种场景，适合各类Redis使用者。


## 核心功能  
### 1. 数据可视化浏览  
直接查看Redis中的所有键值对，支持按数据类型（如String、Hash、List、Set、Sorted Set等）分类展示。键的过期时间、内存占用、编码方式等元信息一目了然，无需手动执行`KEYS`或`TYPE`命令。  

### 2. 交互式命令执行  
内置命令行窗口，提供自动补全和语法提示。输入命令时实时显示参数说明，执行后结果以格式化方式呈现（如Hash以表格展示、List按顺序排列），降低对命令语法的记忆要求。  

### 3. 性能监控与分析  
实时展示Redis实例的关键指标：内存使用量、命中率、每秒命令数、连接数等，通过折线图、柱状图直观呈现趋势。支持查看慢查询日志，帮助快速定位执行耗时的命令。  

### 4. 数据导入导出  
支持将Redis数据导出为JSON、CSV格式，或从本地文件导入数据（如批量添加测试数据），方便数据备份、迁移或环境复制。  

### 5. 集群与哨兵管理  
兼容Redis集群和哨兵模式，可直观查看集群节点分布、槽位分配状态，以及哨兵的监控信息（如主从切换记录），简化分布式环境的管理。  


## 快速使用步骤  
### 1. 下载安装  
从Redis官网（[]  

### 2. 连接Redis实例  
打开RedisInsight后，点击界面左侧“添加连接”，输入Redis实例的地址（如`localhost`或远程服务器IP）、端口（默认6379）、密码（如有），点击“连接”即可（支持本地实例、云服务或自建服务器上的Redis）。  

### 3. 开始操作  
连接成功后，左侧导航栏会显示已连接的实例。点击实例名称，即可使用数据浏览（“Browser”标签）、命令执行（“CLI”标签）、性能监控（“Metrics”标签）等功能。  


## 适用场景  
- **开发调试**：日常开发中快速查看、修改Redis数据，验证业务逻辑（如检查缓存是否生效）。  
- **运维管理**：监控Redis实例运行状态，及时发现内存溢出、连接数过高等问题，配合日志分析优化配置。  
- **学习入门**：通过可视化界面直观理解Redis数据结构（如Sorted Set的分数排序）和命令效果（如`ZADD`与`ZRANGE`的对应关系），降低学习门槛。
