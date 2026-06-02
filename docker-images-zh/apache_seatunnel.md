---
image: apache/seatunnel
description: "SeaTunnel是一款下一代超高性能、分布式的海量数据集成工具，它专注于高效处理大规模数据的抽取、转换与加载（ETL）任务，支持多种异构数据源与目标系统的无缝对接，具备优异的横向扩展能力和运行稳定性，适用于各类企业级大数据平台环境，能够为数据整合、流转与分析提供快速、可靠且易维护的技术支撑。"
source: https://xuanyuan.cloud/zh/r/apache/seatunnel
canonical: https://xuanyuan.cloud/zh/r/apache/seatunnel
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/apache/seatunnel" title="apache/seatunnel Docker 镜像中文简介、标签列表与拉取命令">apache/seatunnel — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/apache/seatunnel" title="apache/seatunnel Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/apache/seatunnel</a>

# Apache SeaTunnel  

Apache SeaTunnel 是一款易用、高性能的分布式数据集成平台，支持海量数据实时同步，每日可稳定高效同步数百亿条数据，已在近百家企业的生产环境中应用。


# 使用Docker部署  

## 本地模式部署  

### Zeta Engine  

#### 下载镜像  
```shell  
docker pull apache/seatunnel:<version_tag>  # 替换<version_tag>为具体版本号  
```  

#### 本地模式提交作业  
以下为本地模式运行作业的常用命令及示例：  

- **运行默认配置作业（Fake Source 到 Console Sink）**  
  ```shell  
  docker run --rm -it apache/seatunnel:<version_tag> ./bin/seatunnel.sh -m local -c config/v2.batch.config.template  
  ```  

- **运行自定义配置文件**  
  需将本地配置文件目录挂载到容器内，示例如下：  
  ```shell  
  # 假设本地配置文件路径为 /tmp/job/fake_to_console.conf  
  docker run --rm -it -v /tmp/job/:/config apache/seatunnel:<version_tag> ./bin/seatunnel.sh -m local -c /config/fake_to_console.conf  
  ```  

- **设置JVM参数运行**  
  通过 `-DJvmOption` 指定JVM参数（如内存配置）：  
  ```shell  
  docker run --rm -it -v /tmp/job/:/config apache/seatunnel:<version_tag> ./bin/seatunnel.sh -DJvmOption="-Xms4G -Xmx4G" -m local -c /config/fake_to_console.conf  
  ```  


## 集群模式部署  

集群模式仅支持 Zeta 引擎，部署方式分为两种：直接使用Docker或通过Docker Compose。  


### 直接使用Docker部署  

#### 步骤1：创建网络  
```shell  
docker network create seatunnel-network  
```  

#### 步骤2：启动主节点（Master）  
```shell  
docker run -d --name seatunnel_master \  
  --network seatunnel-network \  
  --rm \  
  -p 5801:5801 \  # 暴露5801端口  
  apache/seatunnel \  
  ./bin/seatunnel-cluster.sh -r master  
```  

#### 步骤3：获取主节点IP  
执行以下命令查看主节点容器IP（需替换为实际容器名）：  
```shell  
docker inspect seatunnel_master  
```  
在输出中找到 `IPAddress` 字段，记录主节点IP（如 `172.18.0.2`）。  

#### 步骤4：启动工作节点（Worker）  
需将主节点IP替换为实际值，示例启动2个工作节点：  
```shell  
# 启动worker1  
docker run -d --name seatunnel_worker_1 \  
  --network seatunnel-network \  
  --rm \  
  -e ST_DOCKER_MEMBER_LIST=172.18.0.2:5801 \  # 替换为主节点IP:端口  
  apache/seatunnel \  
  ./bin/seatunnel-cluster.sh -r worker  

# 启动worker2（同上，仅容器名不同）  
docker run -d --name seatunnel_worker_2 \  
  --network seatunnel-network \  
  --rm \  
  -e ST_DOCKER_MEMBER_LIST=172.18.0.2:5801 \  
  apache/seatunnel \  
  ./bin/seatunnel-cluster.sh -r worker  
```  

#### 扩展集群  
如需增加工作节点，重复步骤4，修改容器名（如 `seatunnel_worker_3`）即可。  


### 使用Docker Compose部署  

#### 1. 基础集群配置  
创建 `docker-compose.yaml` 文件，内容如下（固定IP配置，避免节点通信问题）：  
```yaml  
version: '3.8'  

services:  
  master:  
    image: apache/seatunnel  
    container_name: seatunnel_master  
    environment:  
      - ST_DOCKER_MEMBER_LIST=172.16.0.2,172.16.0.3,172.16.0.4  # 集群节点IP列表  
    entrypoint: /opt/seatunnel/bin/seatunnel-cluster.sh -r master  
    ports:  
      - "5801:5801"  
    networks:  
      seatunnel_network:  
        ipv4_address: 172.16.0.2  # 主节点固定IP  

  worker1:  
    image: apache/seatunnel  
    container_name: seatunnel_worker_1  
    environment:  
      - ST_DOCKER_MEMBER_LIST=172.16.0.2,172.16.0.3,172.16.0.4  
    entrypoint: /opt/seatunnel/bin/seatunnel-cluster.sh -r worker  
    depends_on: [master]  
    networks:  
      seatunnel_network:  
        ipv4_address: 172.16.0.3  # worker1固定IP  

  worker2:  
    image: apache/seatunnel  
    container_name: seatunnel_worker_2  
    environment:  
      - ST_DOCKER_MEMBER_LIST=172.16.0.2,172.16.0.3,172.16.0.4  
    entrypoint: /opt/seatunnel/bin/seatunnel-cluster.sh -r worker  
    depends_on: [master]  
    networks:  
      seatunnel_network:  
        ipv4_address: 172.16.0.4  # worker2固定IP  

networks:  
  seatunnel_network:  
    driver: bridge  
    ipam:  
      config:  
        - subnet: 172.16.0.0/24  # 子网配置  
```  

#### 2. 启动集群  
```shell  
docker-compose up -d  
```  

#### 3. 验证集群状态  
- 查看节点日志：  
  ```shell  
  docker logs -f seatunnel_master  # 主节点日志  
  docker logs -f seatunnel_worker_1  # worker1日志  
  ```  
- 访问集群监控接口（确认节点数量）：  
  ```  
  []  
  ```  

#### 4. 扩展集群（新增工作节点）  
修改 `docker-compose.yaml`，添加 `worker3` 配置（示例）：  
```yaml  
  worker3:  
    image: apache/seatunnel  
    container_name: seatunnel_worker_3  
    environment:  
      - ST_DOCKER_MEMBER_LIST=172.16.0.2,172.16.0.3,172.16.0.4,172.16.0.5  # 添加新IP  
    entrypoint: /opt/seatunnel/bin/seatunnel-cluster.sh -r worker  
    depends_on: [master]  
    networks:  
      seatunnel_network:  
        ipv4_address: 172.16.0.5  # 未使用的固定IP  
```  
执行 `docker-compose up -d` 启动新增节点（原有节点不会重启）。  


## 集群作业操作  

### 通过Docker客户端操作  

#### 提交作业  
```shell  
docker run --name seatunnel_client \  
  --network seatunnel-network \  
  -e ST_DOCKER_MEMBER_LIST=172.18.0.2:5801 \  # 替换为主节点IP:端口  
  --rm \  
  apache/seatunnel \  
  ./bin/seatunnel.sh -c config/v2.batch.config.template  # 使用默认配置文件  
```  

#### 列出作业  
```shell  
docker run --name seatunnel_client \  
  --network seatunnel-network \  
  -e ST_DOCKER_MEMBER_LIST=172.18.0.2:5801 \  
  --rm \  
  apache/seatunnel \  
  ./bin/seatunnel.sh -l  
```  

更多命令参考 [用户命令文档]([])。  


### 通过REST API操作  
作业提交、状态查询等操作可通过REST API实现，详情参考 [作业提交API文档]([])。
