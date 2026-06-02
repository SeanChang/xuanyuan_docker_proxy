<!-- xuanyuan-docker-images-zh
image: apache/iotdb
source: https://xuanyuan.cloud/zh/r/apache/iotdb
canonical: https://xuanyuan.cloud/zh/r/apache/iotdb
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [apache/iotdb — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/apache/iotdb "apache/iotdb Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/apache/iotdb

# Apache IoTDB 简介

Apache IoTDB 是一款 IoT 原生数据库，专为物联网场景设计，在数据管理与分析方面性能优异，可同时部署于边缘设备和云端。其架构轻量、性能高效且功能丰富，深度集成 Apache Hadoop、Spark、Flink 等大数据工具，能够满足工业物联网领域对海量数据存储、高速数据写入及复杂数据分析的需求。


## 快速体验

### Docker 部署步骤

通过以下步骤可快速部署单机版 IoTDB：

1. **拉取官方镜像**  
   ```shell
   docker pull apache/iotdb:<version>-standalone
   ```
   （将 `<version>` 替换为具体版本号，如 `1.2.0`）

2. **创建 Docker 桥接网络**  
   ```shell
   docker network create --driver=bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 iotdb
   ```

3. **启动容器**  
   ```shell
   docker run -d --name iotdb-service \
                --hostname iotdb-service \
                --network iotdb \
                --ip 172.18.0.6 \
                -p 6667:6667 \
                -e cn_internal_address=iotdb-service \
                -e cn_seed_config_node=iotdb-service:10710 \
                -e cn_internal_port=10710 \
                -e cn_consensus_port=10720 \
                -e dn_rpc_address=iotdb-service \
                -e dn_internal_address=iotdb-service \
                -e dn_seed_config_node=iotdb-service:10710 \
                -e dn_mpp_data_exchange_port=10740 \
                -e dn_schema_region_consensus_port=10750 \
                -e dn_data_region_consensus_port=10760 \
                -e dn_rpc_port=6667 \
                apache/iotdb:<version>-standalone              
   ```

4. **执行 SQL 命令**  
   进入容器内的客户端：  
   ```shell
   docker exec -ti iotdb-service /iotdb/sbin/start-cli.sh -h iotdb-service
   ```


### 外部访问方法

容器外可通过客户端连接 IoTDB，命令如下：  
```shell
# <IP Address/hostname> 需替换为宿主机的实际 IP 或域名（非 Docker 网络内 IP），本地测试可用 127.0.0.1
$IOTDB_HOME/sbin/start-cli.sh -h <IP Address/hostname> -p 6667
```


### 注意事项

- 若容器 IP 地址发生变化，重启容器时配置节点（confignode）服务可能启动失败。


### docker-compose 配置示例

也可通过 `docker-compose` 部署，创建 `docker-compose-standalone.yml` 文件：  
```yaml
version: "3"
services:
  iotdb-service:
    image: apache/iotdb:<version>-standalone  # 替换 <version> 为实际版本
    hostname: iotdb-service
    container_name: iotdb-service
    ports:
      - "6667:6667"  # 映射 RPC 端口
    environment:
      - cn_internal_address=iotdb-service
      - cn_internal_port=10710
      - cn_consensus_port=10720
      - cn_seed_config_node=iotdb-service:10710
      - dn_rpc_address=iotdb-service
      - dn_internal_address=iotdb-service
      - dn_rpc_port=6667
      - dn_mpp_data_exchange_port=10740
      - dn_schema_region_consensus_port=10750
      - dn_data_region_consensus_port=10760
      - dn_seed_config_node=iotdb-service:10710
    volumes:
        - ./data:/iotdb/data  # 数据持久化
        - ./logs:/iotdb/logs  # 日志持久化
    networks:
      iotdb:
        ipv4_address: 172.18.0.6  # 固定容器 IP

networks:
  iotdb:
    external: true  # 使用已创建的 iotdb 网络（需先执行 docker network create 命令）
```

更多部署细节可参考 [Docker 安装文档]([])。
