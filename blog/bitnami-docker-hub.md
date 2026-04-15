# 重要公告：Bitnami 部分镜像 Docker Hub 免费获取通道变更，替代拉取方案看这篇就够了

![重要公告：Bitnami 部分镜像 Docker Hub 免费获取通道变更，替代拉取方案看这篇就够了](https://img.xuanyuan.dev/docker/blog/docker-bitnami.png)

*分类: Bitnami,公告,Docker | 标签: Bitnami,公告,Docker | 发布时间: 2026-02-23 04:37:37*

> 近期Bitnami官方对旗下镜像分发策略进行重大调整，原可在Docker Hub免费获取的Bitnami核心安全镜像（覆盖Kafka、Redis、MySQL、Elasticsearch等全品类），现已全面取消免费下载服务，这将直接影响大家日常的开发、测试和项目部署工作。为了让大家快速找到可落地的解决方案，我们整理了清晰的替代拉取方法、场景化使用建议，小白也能一步上手，建议收藏备用！

各位开发者小伙伴，大家好！近期Bitnami官方对旗下镜像分发策略进行重大调整，**原可在Docker Hub免费获取的Bitnami核心安全镜像（覆盖Kafka、Redis、MySQL、Elasticsearch等全品类），现已全面取消免费下载服务**，这将直接影响大家日常的开发、测试和项目部署工作。为了让大家快速找到可落地的解决方案，我们整理了清晰的替代拉取方法、场景化使用建议，小白也能一步上手，建议收藏备用！

此次调整并非针对单一镜像，而是覆盖**Bitnami整个命名空间下的所有核心安全镜像**，从主流的中间件、数据库到监控、运维工具均受影响，其中Kafka安全镜像是企业级流数据处理的常用资源，也是本次调整中最具代表性的受影响镜像。

## 一、先搞懂：Bitnami镜像现在分哪两类？
调整后，Bitnami镜像主要分为**商业安全镜像**和**旧版遗留镜像**，二者的获取方式、使用场景差异显著，大家可根据自身需求选择，避免用错版本踩坑。
### 1. Bitnami商业安全镜像（企业生产/正式开发首选）
这类镜像经官方深度安全加固，是当前主力版本，支持Debian和Photon两种基础系统格式，主打零漏洞、高合规，完美适配主流Helm图表，是企业生产环境的最优选择。
**关键提醒**：该类镜像已作为OCI制品，**必须通过Bitnami官方商业订阅才能获取**，Docker Hub无免费通道，直接拉取会失败；仅Docker Hub保留了部分镜像的**开发者版（试用版）**，可满足基础测试需求。

### 2. Bitnami Legacy旧版遗留镜像（无订阅用户核心替代方案）
这是Bitnami官方的旧版镜像备份仓库，包含Kafka、Redis、MySQL、Zookeeper等**全品类历史镜像的完整备份**，但所有镜像均已**完全停止更新和技术支持**，未来还可能被官方移除。
**适用场景**：无商业订阅时，用于旧项目**临时迁移、兼容性验证、数据同步**，也可满足开发/测试环境的基础需求；
**绝对禁用**：严禁用于生产环境长期运行，无安全补丁更新，存在极高的安全风险。

## 二、核心替代方案：通过轩辕镜像仓库拉取
轩辕镜像支持拉取 Bitnami Legacy 全品类旧版遗留镜像，是无订阅用户的最优选择；

### 1. 如何查询 Bitnami Legacy 镜像可用标签/全品类镜像列表？
轩辕镜像仓库提供了**镜像标签查询**和**全品类搜索**功能，可精准找到所需镜像及对应版本，地址如下：
1. **单镜像可用标签查询**（以Kafka为例）：https://xuanyuan.cloud/r/bitnamilegacy/kafka/tags
2. **Bitnami Legacy全品类镜像搜索**：https://xuanyuan.cloud/search?q=bitnamilegacy&source=docker.io&page=1
<br>
所有镜像的版本标签、系统架构、镜像大小均在页面清晰展示，直接复制即可用于拉取命令。

### 2. 无商业订阅：拉取旧版遗留镜像
#### 通用拉取格式
```bash
# 拉取Bitnami Legacy旧版遗留镜像（全品类通用，免认证）
docker pull docker.xuanyuan.run/bitnamilegacy/[镜像名]:[版本标签]
```
#### 实操示例（以Kafka 3.3.2为例，亲测可成功）
```bash
# 拉取Bitnami Legacy旧版Kafka 3.3.2（Debian 11基础版）
docker pull docker.xuanyuan.run/bitnamilegacy/kafka:3.3.2-debian-11-r11
```
#### 验证拉取是否成功
拉取完成后，运行以下命令，能看到对应镜像信息即为成功：
```bash
docker images | grep [镜像名]
```
**示例输出**（Kafka）：
```
docker.xuanyuan.run/bitnamilegacy/kafka   3.3.2-debian-11-r11   xxxxxxxx   2 months ago   337.55 MB
```

## 三、不同场景的最佳使用建议
### 场景1：企业生产环境/长期运行的正式项目
**首选**：购买Bitnami商业订阅，升级至Photon版商业安全镜像。
该版本相比旧版Debian镜像安全加固更彻底，支持FIPS、STIG合规要求，提供SBOM安全物料清单、软件供应链来源证明，且与原有Helm图表完全兼容，升级无适配压力，能最大程度保障生产环境稳定。

### 场景2：日常开发/测试/功能验证
**可选方案**：
1. 直接拉取轩辕镜像仓库的Bitnami Legacy旧版遗留镜像，免认证、易操作，满足基础开发测试需求；
2. 在Docker Hub筛选Bitnami安全镜像**开发者版（试用版）**，仅支持最新标签，适合轻量测试。

### 场景3：旧版Bitnami镜像项目临时迁移/数据同步
**仅用**：轩辕镜像仓库的Bitnami Legacy旧版遗留镜像，且**迁移完成后务必将镜像保存至私有仓库**，避免后续官方移除仓库导致镜像无法获取，具体操作步骤（全品类通用）：
```bash
# 1. 从轩辕仓库拉取旧版镜像到本地（以Kafka为例）
docker pull docker.xuanyuan.run/bitnamilegacy/kafka:3.3.2-debian-11-r11
# 2. 标记为自身私有仓库地址（替换为你的私有仓库域名）
docker tag docker.xuanyuan.run/bitnamilegacy/kafka:3.3.2-debian-11-r11 你的私有仓库域名/kafka:3.3.2
# 3. 推送到私有仓库永久保存
docker push 你的私有仓库域名/kafka:3.3.2
```

## 四、重要提醒
1. 此次调整是Bitnami官方全局策略，**Bitnami命名空间下所有安全镜像均无Docker Hub免费通道**，包括中间件（Kafka、RabbitMQ）、数据库（MySQL、PostgreSQL）、监控工具（Prometheus、Grafana）等，均需按上述方案操作；
2. 轩辕镜像仓库已同步**Bitnami Legacy全品类旧版遗留镜像**，且持续维护免认证拉取服务，后续镜像信息更新会第一时间同步；
3. 若需查询特定镜像的可用版本，可直接通过轩辕镜像的**标签查询页**和**全品类搜索页**获取，地址再次贴出方便大家访问：
   - 单镜像标签查询（Kafka示例）：https://xuanyuan.cloud/r/bitnamilegacy/kafka/tags
   - 全品类镜像搜索：https://xuanyuan.cloud/search?q=bitnamilegacy&source=docker.io&page=1
4. 如需了解Bitnami商业安全镜像的订阅信息、安全特性，可前往Bitnami官方网站查询。

