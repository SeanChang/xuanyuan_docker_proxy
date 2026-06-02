---
image: mcp/redis
description: "提供Redis数据库操作访问能力，支持44种工具，包括键管理、数据结构操作、向量索引创建及相似度搜索等，基于Model Context Protocol (MCP) 实现安全高效的Redis交互。"
source: https://xuanyuan.cloud/zh/r/mcp/redis
canonical: https://xuanyuan.cloud/zh/r/mcp/redis
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mcp/redis" title="mcp/redis Docker 镜像中文简介、标签列表与拉取命令">mcp/redis — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/mcp/redis" title="mcp/redis Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mcp/redis</a>

# Redis MCP Server

用于访问Redis数据库操作。

[什么是MCP Server？](https://www.docker.com/blog/the-model-context-protocol-simplifying-building-ai-apps-with-anthropic-claude-desktop-and-docker/)

## MCP信息
| 属性 | 详情 |
|-|-|
**Docker镜像**|[mcp/redis](https://hub.docker.com/repository/docker/mcp/redis)
**作者**|[redis](https://github.com/redis)
**代码仓库**|https://github.com/redis/mcp-redis

## 镜像构建信息
| 属性 | 详情 |
|-|-|
**Dockerfile**|https://github.com/redis/mcp-redis/blob/main/Dockerfile
**Docker镜像构建者**|Docker Inc.
**Docker Scout健康评分**| ![Docker Scout健康评分](https://api.scout.docker.com/v1/policy/insights/org-image-score/badge/mcp/redis)
**验证签名**|`COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/redis --key https://raw.githubusercontent.com/docker/keyring/refs/heads/main/public/mcp/latest.pub`
**许可证**|MIT License

## 可用工具（44种）
| 本服务器提供的工具 | 简短描述 |
|-|-|
`client_list`|获取Redis服务器的已连接客户端列表。|
`create_vector_index_hash`|在Redis哈希上使用HNSW创建Redis 8向量相似度索引。|
`dbsize`|获取Redis数据库中存储的键数量|
`delete`|删除Redis键。|
`expire`|为Redis键设置过期时间。|
`get`|获取Redis字符串值。|
`get_index_info`|使用FT.INFO检索特定Redis索引的模式和信息。|
`get_indexed_keys_number`|检索索引所索引的键数量|
`get_indexes`|Redis数据库中的索引列表|
`get_vector_from_hash`|从Redis哈希中检索向量并从二进制blob转换回来。|
`hdel`|从Redis哈希中删除字段。|
`hexists`|检查Redis哈希中是否存在字段。|
`hget`|获取Redis哈希中字段的值。|
`hgetall`|获取Redis哈希中的所有字段和值。|
`hset`|在哈希中设置字段，可选设置过期时间。|
`info`|获取Redis服务器信息和统计数据。|
`json_del`|从Redis中删除指定路径的JSON值。|
`json_get`|从Redis中检索指定路径的JSON值。|
`json_set`|在Redis中指定路径设置JSON值，可选设置过期时间。|
`llen`|获取Redis列表的长度。|
`lpop`|从Redis列表中移除并返回第一个元素。|
`lpush`|将值添加到Redis列表左侧，可选设置过期时间。|
`lrange`|获取Redis列表中特定范围内的元素。|
`publish`|向Redis频道发布消息。|
`rename`|将Redis键从旧键名重命名为新键名。|
`rpop`|从Redis列表中移除并返回最后一个元素。|
`rpush`|将值添加到Redis列表右侧，可选设置过期时间。|
`sadd`|向Redis集合添加值，可选设置过期时间。|
`scan_all_keys`|使用多次SCAN迭代扫描并返回所有匹配模式的键。|
`scan_keys`|使用SCAN命令扫描Redis数据库中的键（非阻塞，生产环境安全）。|
`set`|设置Redis字符串值，可选设置过期时间。|
`set_vector_in_hash`|将向量存储为Redis哈希中的字段。|
`smembers`|获取Redis集合的所有成员。|
`srem`|从Redis集合中移除值。|
`subscribe`|订阅Redis频道。|
`type`|返回键存储的值类型的字符串表示。|
`unsubscribe`|取消订阅Redis频道。|
`vector_search_hash`|使用Redis 8或更高版本对存储在哈希数据结构中的向量执行KNN向量相似度搜索。|
`xadd`|向Redis流添加条目，可选设置过期时间。|
`xdel`|从Redis流中删除条目。|
`xrange`|从Redis流中读取条目。|
`zadd`|向Redis有序集合添加成员，可选设置过期时间。|
`zrange`|从Redis有序集合中检索成员范围。|
`zrem`|从Redis有序集合中移除成员。|

---
## 工具详情

#### 工具：**`client_list`**获取Redis服务器的已连接客户端列表。

#### 工具：**`create_vector_index_hash`**在Redis哈希上使用HNSW创建Redis 8向量相似度索引。

此函数使用HNSW算法和float32向量嵌入设置Redis索引，用于近似最近邻（ANN）搜索。

| 参数 | 类型 | 描述 |
|-|-|-|
`dim`|`integer` 可选|向量字段下存储的向量维度。
`distance_metric`|`string` 可选|使用的距离函数（例如：'COSINE'、'L2'、'IP'）。
`index_name`|`string` 可选|要创建的Redis索引名称。除非特别需要，否则使用默认索引名称。
`prefix`|`string` 可选|用于标识要索引的文档的键前缀（例如：'doc:'）。除非特别需要，否则使用默认前缀。
`vector_field`|`string` 可选|要索引用于相似度搜索的向量字段名称。除非特别需要，否则使用默认字段名称。

---
#### 工具：**`dbsize`**获取Redis数据库中存储的键数量。

#### 工具：**`delete`**删除Redis键。

| 参数 | 类型 | 描述 |
|-|-|-|
`key`|`string`|

---
#### 工具：**`expire`**为Redis键设置过期时间。

| 参数 | 类型 | 描述 |
|-|-|-|
`expire_seconds`|`integer`|键过期的时间（秒）。
`name`|`string`|Redis键名。

---
#### 工具：**`get`**获取Redis字符串值。

| 参数 | 类型 | 描述 |
|-|-|-|
`key`|`string`|

---
#### 工具：**`get_index_info`**使用FT.INFO检索特定Redis索引的模式和信息。

| 参数 | 类型 | 描述 |
|-|-|-|
`index_name`|`string`|

---
#### 工具：**`get_indexed_keys_number`**检索索引所索引的键数量。

| 参数 | 类型 | 描述 |
|-|-|-|
`index_name`|`string`|

---
#### 工具：**`get_indexes`**Redis数据库中的索引列表。

返回：
    str: 包含索引列表的JSON字符串或错误消息。

#### 工具：**`get_vector_from_hash`**从Redis哈希中检索向量并从二进制blob转换回来。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|Redis哈希键名。
`vector_field`|`string` 可选|哈希中的字段名。除非特别需要，否则使用默认字段名称。

---
#### 工具：**`hdel`**从Redis哈希中删除字段。

| 参数 | 类型 | 描述 |
|-|-|-|
`key`|`string`|哈希中的字段名。
`name`|`string`|Redis哈希键名。

---
#### 工具：**`hexists`**检查Redis哈希中是否存在字段。

| 参数 | 类型 | 描述 |
|-|-|-|
`key`|`string`|哈希中的字段名。
`name`|`string`|Redis哈希键名。

---
#### 工具：**`hget`**获取Redis哈希中字段的值。

| 参数 | 类型 | 描述 |
|-|-|-|
`key`|`string`|哈希中的字段名。
`name`|`string`|Redis哈希键名。

---
#### 工具：**`hgetall`**获取Redis哈希中的所有字段和值。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|Redis哈希键名。

---
#### 工具：**`hset`**在哈希中设置字段，可选设置过期时间。

| 参数 | 类型 | 描述 |
|-|-|-|
`key`|`string`|哈希中的字段名。
`name`|`string`|Redis哈希键名。
`value`|`string`|要设置的值。
`expire_seconds`|`string` 可选|可选；键过期的时间（秒）。

---
#### 工具：**`info`**获取Redis服务器信息和统计数据。

| 参数 | 类型 | 描述 |
|-|-|-|
`section`|`string` 可选|info命令的部分（default、memory、cpu等）。

---
#### 工具：**`json_del`**从Redis中删除指定路径的JSON值。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|存储JSON文档的Redis键名。
`path`|`string` 可选|要删除的JSON路径（默认：根路径'$'）。

---
#### 工具：**`json_get`**从Redis中检索指定路径的JSON值。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|存储JSON文档的Redis键名。
`path`|`string` 可选|要检索的JSON路径（默认：根路径'$'）。

---
#### 工具：**`json_set`**在Redis中指定路径设置JSON值，可选设置过期时间。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|存储JSON文档的Redis键名。
`path`|`string`|设置值的JSON路径。
`value`|`string`|要存储的JSON值。
`expire_seconds`|`string` 可选|可选；键过期的时间（秒）。

---
#### 工具：**`llen`**获取Redis列表的长度。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|

---
#### 工具：**`lpop`**从Redis列表中移除并返回第一个元素。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|

---
#### 工具：**`lpush`**将值添加到Redis列表左侧，可选设置过期时间。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|
`value`|`string`|
`expire`|`string` 可选|

---
#### 工具：**`lrange`**获取Redis列表中特定范围内的元素。

返回：
str: 包含元素列表的JSON字符串或错误消息。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|
`start`|`integer`|
`stop`|`integer`|

---
#### 工具：**`publish`**向Redis频道发布消息。

| 参数 | 类型 | 描述 |
|-|-|-|
`channel`|`string`|要发布的Redis频道。
`message`|`string`|要发送的消息。

---
#### 工具：**`rename`**将Redis键从旧键名重命名为新键名。

| 参数 | 类型 | 描述 |
|-|-|-|
`new_key`|`string`|
`old_key`|`string`|

---
#### 工具：**`rpop`**从Redis列表中移除并返回最后一个元素。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|

---
#### 工具：**`rpush`**将值添加到Redis列表右侧，可选设置过期时间。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|
`value`|`string`|
`expire`|`string` 可选|

---
#### 工具：**`sadd`**向Redis集合添加值，可选设置过期时间。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|Redis集合键名。
`value`|`string`|要添加到集合的值。
`expire_seconds`|`string` 可选|可选；集合过期的时间（秒）。

---
#### 工具：**`scan_all_keys`**使用多次SCAN迭代扫描并返回所有匹配模式的键。

此函数自动处理SCAN游标迭代以收集所有匹配键。对于大型数据库，它比KEYS *更安全，但仍会将所有结果收集到内存中。

⚠️ 警告：对于非常大的数据集（数百万个键），这可能会消耗大量内存。对于大规模操作，请考虑使用scan_keys()进行手动迭代。

| 参数 | 类型 | 描述 |
|-|-|-|
`batch_size`|`integer` 可选|每次迭代扫描的键数（默认100）。
`pattern`|`string` 可选|匹配键的模式（默认"*"匹配所有键）。

---
#### 工具：**`scan_keys`**使用SCAN命令扫描Redis数据库中的键（非阻塞，生产环境安全）。

⚠️ 重要：这返回一次迭代的部分结果。使用scan_all_keys()获取所有匹配键，或使用返回的游标多次调用此函数，直到游标变为0。

SCAN命令以小批量迭代键空间，可安全用于大型数据库而不会阻塞其他操作。

| 参数 | 类型 | 描述 |
|-|-|-|
`count`|`integer` 可选|每次迭代返回的键数提示（默认100）。
`cursor`|`integer` 可选|开始扫描的游标位置（0表示从开始）。
`pattern`|`string` 可选|匹配键的模式（默认"*"匹配所有键）。

---
#### 工具：**`set`**设置Redis字符串值，可选设置过期时间。

| 参数 | 类型 | 描述 |
|-|-|-|
`key`|`string`|
`value`|`string`|
`expiration`|`string` 可选|

---
#### 工具：**`set_vector_in_hash`**将向量存储为Redis哈希中的字段。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|Redis哈希键名。
`vector`|`array`|要存储在哈希中的向量（数字列表）。
`vector_field`|`string` 可选|哈希中的字段名。除非特别需要，否则使用默认字段名称。

---
#### 工具：**`smembers`**获取Redis集合的所有成员。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|Redis集合键名。

---
#### 工具：**`srem`**从Redis集合中移除值。

| 参数 | 类型 | 描述 |
|-|-|-|
`name`|`string`|Redis集合键名。
`value`|`string`|要从集合中移除的值。

---
#### 工具：**`subscribe`**订阅Redis频道。

| 参数 | 类型 | 描述 |
|-|-|-|
`channel`|`string`|要订阅的Redis频道。

---
#### 工具：**`type`**返回键存储的值类型的字符串表示。

| 参数 | 类型 | 描述 |
|-|-|-|
`key`|`string`|

---
#### 工具：**`unsubscribe`**取消订阅Redis频道。

| 参数 | 类型 | 描述 |
|-|-|-|
`channel`|`string`|要取消订阅的Redis频道。

---
#### 工具：**`vector_search_hash`**使用Redis 8或更高版本对存储在哈希数据结构中的向量执行KNN向量相似度搜索。

| 参数 | 类型 | 描述 |
|-|-|-|
`query_vector`|`array`|用作查询向量的浮点数列表。
`index_name`|`string` 可选|Redis索引名称。除非特别指定，否则使用默认索引名称。
`k`|`integer` 可选|要返回的最近邻数量。
`return_fields`|`string` 可选|要返回的字段列表（可选）。
`vector_field`|`string` 可选|已索引的向量字段名称。除非特别需要，否则使用默认字段名称。

---
#### 工具：**`xadd`**向Redis流添加条目，可选设置过期时间。

| 参数 | 类型 | 描述 |
|-|-|-|
`fields`|`object`|
`key`|`string`|
`expiration`|`string` 可选|

---
#### 工具：**`xdel`**从Redis流中删除条目。

| 参数 | 类型 | 描述 |
|-|-|-|
`entry_id`|`string`|
`key`|`string`|

---
#### 工具：**`xrange`**从Redis流中读取条目。

| 参数 | 类型 | 描述 |
|-|-|-|
`key`|`string`|
`count`|`integer` 可选|

---
#### 工具：**`zadd`**向Redis
