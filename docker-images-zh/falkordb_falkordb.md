---
image: falkordb/falkordb
description: "可查询的属性图数据库是一种用于存储实体（节点）与关系（边）并支持属性关联的数据库系统，它采用稀疏矩阵邻接矩阵作为核心数据结构来表示节点间的连接关系，这种结构能高效处理大规模图数据中节点关系稀疏的特点，通过压缩存储非零元素节省空间，同时优化查询性能，使数据库可快速响应路径查找、关系分析等复杂图查询需求。"
source: https://xuanyuan.cloud/zh/r/falkordb/falkordb
canonical: https://xuanyuan.cloud/zh/r/falkordb/falkordb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/falkordb/falkordb" title="falkordb/falkordb Docker 镜像中文简介、标签列表与拉取命令">falkordb/falkordb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

[![Dockerhub] ] 
[![]()]()

# FalkorDB
[![Try Free] ] 


## 项目目标  
我们的目标是打造一款专为大型语言模型（LLM）设计的卓越知识图谱，它具备极低的延迟，通过名为KG-RAG的图数据库确保信息的快速交付。


## 关于FalkorDB  
[FalkorDB] 是首个可查询的属性图数据库，它采用稀疏矩阵表示图中的邻接矩阵，并通过线性代数实现图查询。


## 主要特性  
- **采用属性图模型**  
  - 节点（顶点）和关系（边）可包含属性  
  - 节点支持多标签  
  - 关系具有明确类型  
- 图以稀疏邻接矩阵形式存储  
- **查询语言**：基于OpenCypher（含专有扩展），查询会被转换为线性代数表达式  


## 快速开始  
1. [试用FalkorDB](#试用falkordb)  
2. [使用方法](#使用方法)  
3. [文档]   


### 试用FalkorDB  
通过Docker可快速启动FalkorDB实例：  

```bash
docker run -p 6379:6379 -p 3000:3000 -it --rm docker.xuanyuan.run/falkordb/falkordb:edge
```  

启动后，可通过`redis-cli`交互。以下示例将创建一个 MotoGP 骑手和车队的关系图，并进行简单查询。  


#### 使用`redis-cli`操作  
```sh
$ redis-cli
127.0.0.1:6379> GRAPH.QUERY MotoGP "CREATE (:Rider {name:'Valentino Rossi'})-[:rides]->(:Team {name:'Yamaha'}), (:Rider {name:'Dani Pedrosa'})-[:rides]->(:Team {name:'Honda'}), (:Rider {name:'Andrea Dovizioso'})-[:rides]->(:Team {name:'Ducati'})"
1) 1) 已添加标签：2
   2) 已创建节点：6
   3) 已设置属性：6
   4) 已创建关系：3
   5) "查询内部执行时间：0.399000 毫秒"
```  


##### 示例查询1：谁在为Yamaha车队效力？  
```sh
127.0.0.1:6379> GRAPH.QUERY MotoGP "MATCH (r:Rider)-[:rides]->(t:Team) WHERE t.name = 'Yamaha' RETURN r.name, t.name"
1) 1) "r.name"
   2) "t.name"
2) 1) 1) "Valentino Rossi"
      2) "Yamaha"
3) 1) "查询内部执行时间：0.625399 毫秒"
```  


##### 示例查询2：Ducati车队有多少名骑手？  
```sh
127.0.0.1:6379> GRAPH.QUERY MotoGP "MATCH (r:Rider)-[:rides]->(t:Team {name:'Ducati'}) RETURN count(r)"
1) 1) "count(r)"
2) 1) 1) (integer) 1
3) 1) "查询内部执行时间：0.624435 毫秒"
```  


### 使用方法  
FalkorDB支持通过任何Redis客户端调用其命令，以下是具体示例。  


#### 通过`redis-cli`创建节点  
```sh
$ redis-cli
127.0.0.1:6379> GRAPH.QUERY social "CREATE (:person {name: 'roi', age: 33, gender: 'male', status: 'married'})"
```  


#### 通过其他客户端操作  
可通过客户端的原生Redis命令发送功能与FalkorDB交互，具体方法因客户端而异。  


##### Python示例（使用`redis-py`）  
```Python
import redis

r = redis.StrictRedis()
# 创建一个含属性的person节点
reply = r.execute_command('GRAPH.QUERY', 'social', "CREATE (:person {name:'roi', age:33, gender:'male', status:'married'})")
```  


## 许可证  
采用Server Side Public License v1（SSPLv1）许可，详见[LICENSE] 。
