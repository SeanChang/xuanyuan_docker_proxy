<!-- xuanyuan-docker-images-zh
image: grafana/loki
source: https://xuanyuan.cloud/zh/r/grafana/loki
canonical: https://xuanyuan.cloud/zh/r/grafana/loki
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [grafana/loki — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/grafana/loki "grafana/loki Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/grafana/loki

# Loki Docker镜像


## 运行容器

### 基本运行
通过以下命令启动Loki容器，默认使用`:latest`标签（建议实际使用时指定具体版本，见下文说明）：  
```bash
docker run -d --name=loki -p 3100:3100 grafana/loki
```


### 持久化数据到卷
若要将数据持久化到名为`loki-data`的Docker卷中，可使用卷挂载：  
```bash
docker run -d --name=loki --mount source=loki-data,target=/loki -p 3100:3100 grafana/loki
```


### 使用自定义配置文件
如需使用自定义配置文件（如`loki-config.yaml`），通过绑定挂载将配置文件映射到容器内指定路径：  
```bash
docker run -d --name=loki --mount type=bind,source="本地配置文件路径",target=/etc/loki/local-config.yaml -p 3100:3100 grafana/loki
```


### 指定版本标签
生产环境中建议使用具体版本标签，而非默认的`:latest`。例如使用1.4.1版本：  
```bash
docker run -d --name=loki -p 3100:3100 grafana/loki:1.4.1
```


## 镜像标签说明

### Master构建标签
Loki仓库的每次master分支提交会生成一个标签，格式为`master-xxxxxxx`（其中`xxxxxxx`是提交哈希的前7位字符）。  
**注意**：这类标签会在Docker Hub上保留60天后自动删除，不建议长期使用。


### 发布版本标签
Loki的[GitHub发布页]([])中每个带标签的版本会对应生成镜像标签，可在镜像标签列表中找到（可能需在大量master标签中筛选）。发布版本标签会永久保留。  

**版本标签格式说明**：  
- Loki 0.1.0至1.3.0版本：标签带`v`前缀，如`grafana/loki:v0.1.0`、`grafana/loki:v1.3.0`。  
- Loki 1.4.0及以上版本：标签移除`v`前缀，如`grafana/loki:1.4.0`、`grafana/loki:1.4.1`。


### k标签
格式如`grafana/loki:k15-d70fc0e`的`k`标签用于Grafana内部构建流程，外部用户不建议使用。此类标签的测试状态和潜在问题无公开通知机制，目前暂不稳定。


## 更多信息
- [Loki文档]([])  
- [获取帮助]([])
