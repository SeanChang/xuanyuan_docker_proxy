<!-- xuanyuan-docker-images-zh
image: apache/skywalking-oap-server
source: https://xuanyuan.cloud/zh/r/apache/skywalking-oap-server
canonical: https://xuanyuan.cloud/zh/r/apache/skywalking-oap-server
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [apache/skywalking-oap-server — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/apache/skywalking-oap-server "apache/skywalking-oap-server Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/apache/skywalking-oap-server

# Apache SkyWalking OAP Server 镜像

SkyWalking 是一款应用性能监控（APM）系统，专为微服务、云原生及容器化（Docker、Kubernetes、Mesos）架构设计。


## 如何使用本镜像

### 通过 docker-compose 启动存储、OAP 及 Booster UI  
快速启动时，可以使用单行脚本启动 ElasticSearch 或 [BanyanDB]([]) 作为存储，同时启动 OAP 服务器和 Booster UI。确保已安装 Docker。  

**Linux、macOS、Windows（WSL）**  
```shell
bash <(curl -sSL https://skywalking.apache.org/quickstart-docker.sh]) 
```  

**Windows（Powershell）**  
```powershell
Invoke-Expression ([System.Text.Encoding]::UTF8.GetString((Invoke-WebRequest -Uri [] -UseBasicParsing).Content))
```  

执行后会提示选择存储类型，脚本将根据选择启动后端集群。停止集群可运行：  
```shell
docker compose --project-name=skywalking-quickstart down
```  


### 启动使用 H2 存储的独立容器  
```shell
docker run --name oap --restart always -d apache/skywalking-oap-server:10.1.0
```  


### 启动使用 BanyanDB 存储的独立容器  
若 BanyanDB 地址为 `banyandb:17912`：  
```shell
docker run --name oap --restart always -d -e SW_STORAGE=banyandb -e SW_STORAGE_BANYANDB_TARGETS=banyandb:17912 apache/skywalking-oap-server:10.1.0
```  


### 启动使用 ElasticSearch 7 存储的独立容器  
若 ElasticSearch 地址为 `elasticsearch:9200`：  
```shell
docker run --name oap --restart always -d -e SW_STORAGE=elasticsearch -e SW_STORAGE_ES_CLUSTER_NODES=elasticsearch:9200 apache/skywalking-oap-server:10.1.0
```  


## 配置  
可通过环境变量配置镜像，具体变量定义可参考 [后端设置文档]([])。  


## 扩展镜像  
- **配置文件扩展**：如需覆盖或添加 `/skywalking/config` 目录下的配置文件，可将文件放入 `/skywalking/ext-config` 目录。同名文件会被覆盖，其他文件则添加到 `/skywalking/config`。  
- **依赖库扩展**：如需向 OAP 类路径添加更多库/jar包（例如 OAL 新指标），可将 jar 包挂载到 `/skywalking/ext-libs` 目录。entrypoint 脚本会自动将其添加到类路径，注意无法覆盖已有 jar 包。  


## 许可证  
Apache 2.0 许可证
