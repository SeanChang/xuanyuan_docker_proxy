# 最新 Docker 镜像源加速列表与使用指南（2026年2月更新）

## 📚 目录

### 🚀 一键安装
- [Linux 一键安装 Docker + 轩辕镜像加速](#linux-一键安装-docker--轩辕镜像加速)

### 🖥️ 操作系统平台
- [Linux Docker 加速 - 轩辕镜像配置手册](#linux-配置轩辕镜像源)
- [Windows/Mac Docker 加速 - 轩辕镜像配置手册](./windows-mac-docker-guide.md)

### 🏠 NAS 设备平台
- [群晖 NAS Docker 加速 - 轩辕镜像配置手册](./synology-docker-guide.md)
- [威联通 NAS Docker 加速 - 轩辕镜像配置手册](./qnap-docker-guide.md)
- [绿联 NAS Docker 加速 - 轩辕镜像配置手册](./lvlian-docker-guide.md)
- [极空间 NAS Docker 加速 - 轩辕镜像配置手册](./jikongjian-docker-guide.md)
- [飞牛fnOS Docker 加速 - 轩辕镜像配置手册](./feiniu-docker-guide.md)

### 🛠️ 管理面板与路由
- [宝塔面板 Docker 加速 - 轩辕镜像配置手册](./baota-docker-guide.md)
- [爱快路由 ikuai Docker 加速 - 轩辕镜像配置手册](./ikuai-docker-guide.md)

### ☸️ 容器编排与云原生
- [Docker Compose Docker 镜像加速 - 轩辕镜像配置手册](./docker-compose-docker-guide.md)
- [K8s containerd 下载加速 - 轩辕镜像配置手册](./containerd-guide.md)
- [ghcr、Quay、nvcr、k8s、gcr 仓库下载加速 - 轩辕镜像配置手册](./docker-acceleration-guide.md)
- [Podman Docker 镜像下载加速 - 轩辕镜像配置手册](./podman-docker-guide.md)

### 📖 Docker 部署教程

#### 🗄️ 数据库类
- [MySQL Docker 容器化部署全指南](./blog/docker-mysql-deploy.md)
- [PostgreSQL Docker 部署教程](./blog/docker-postgresql.md)
- [MongoDB Docker 部署教程](./blog/docker-mongodb.md)
- [Redis Docker 部署教程](./blog/docker-redis.md)
- [MariaDB Docker 部署教程](./blog/mariadb-docker.md)
- [Elasticsearch Docker 部署教程](./blog/docker-elasticsearch.md)
- [InfluxDB Docker 部署教程](./blog/influxdb-docker.md)
- [Neo4j Docker 部署教程](./blog/neo4j-docker.md)
- [TDengine Docker 部署教程](./blog/tdengine-docker.md)
- [Doris Docker 部署教程](./blog/doris-docker.md)
- [OceanBase CE Docker 部署教程](./blog/oceanbase-ce-docker.md)
- [OBProxy CE Docker 部署教程](./blog/obproxy-ce-docker.md)
- [MiniOB Docker 部署教程](./blog/miniob-docker.md)
- [etcd Docker 部署教程](./blog/etcd-host-docker.md)
- [Valkey Docker 部署教程](./blog/valkey-docker.md)
- [Qdrant Docker 部署教程](./blog/qdrant-docker.md)
- [Weaviate Docker 部署教程](./blog/weaviate-docker.md)
- [Milvus Docker 部署教程](./blog/milvus-docker.md)
- [pgvector Docker 部署教程](./blog/pgvector-docker.md)
- [PostGIS Docker 部署教程](./blog/postgis-docker.md)
- [Supabase Studio Docker 部署教程](./blog/supabase-studio-docker.md)
- [Supabase Postgres Meta Docker 部署教程](./blog/supabase-postgres-meta-docker.md)
- [Supabase Postgres Docker 部署教程](./blog/supabase-postgres-docker.md)
- [Redis Stack Server Docker 部署教程](./blog/redis-stack-server-docker.md)
- [Redis Stack Docker 部署教程](./blog/redis-stack-docker.md)
- [RedisInsight Docker 部署教程](./blog/redisinsight-docker.md)
- [MySQL Server Docker 部署教程](./blog/mysql-server-docker.md)

#### 💻 编程语言类
- [Python Docker 部署教程](./blog/docker-python.md)
- [Node.js Docker 部署教程](./blog/docker-nodejs.md)
- [PHP Docker 部署教程](./blog/docker-php.md)
- [Golang Docker 部署教程](./blog/golang-docker.md)
- [OpenJDK Docker 部署教程](./blog/docker-openjdk.md)
- [Eclipse Temurin Docker 部署教程](./blog/eclipse-temurin-docker.md)
- [JDK Docker 部署教程](./blog/jdk-docker.md)
- [Perl Docker 部署教程](./blog/perl-docker.md)

#### 🌐 Web 服务器/反向代理
- [Nginx Docker 部署教程](./blog/docker-nginx-deploy.md)
- [Caddy Docker 部署教程](./blog/caddy-docker.md)
- [Traefik Docker 部署教程](./blog/traefik-docker.md)
- [HAProxy Docker 部署教程](./blog/haproxy-docker.md)
- [Nginx Proxy Manager Docker 部署教程](./blog/nginx-proxy-manager-docker.md)
- [Nginx WebUI Docker 部署教程](./blog/nginx-webui-docker.md)

#### 📨 消息队列
- [RabbitMQ Docker 部署教程](./blog/docker-rabbitmq.md)
- [Apache Kafka Docker 部署教程](./blog/apache-kafka-docker.md)
- [Confluent Kafka Docker 部署教程](./blog/cp-kafka-docker.md)
- [Apache RocketMQ Docker 部署教程](./blog/apache-rocketmq-docker.md)
- [RocketMQ Dashboard Docker 部署教程](./blog/rocketmq-dashboard-docker.md)
- [Apache ZooKeeper Docker 部署教程](./blog/apache-zookeeper-docker.md)

#### ☸️ 容器编排/云原生
- [Kubernetes Dashboard Docker 部署教程](./blog/kubernetes-dashboard-docker.md)
- [Kuboard Docker 部署教程](./blog/kuboard-docker.md)
- [Rancher Docker 部署教程](./blog/rancher-docker.md)
- [Portainer CE Docker 部署教程](./blog/portainer-ce-docker.md)
- [Portainer CE CN Docker 部署教程](./blog/portainer-ce-cn-docker.md)
- [Watchtower Docker 部署教程](./blog/watchtower-docker.md)
- [Docker in Docker 部署教程](./blog/docker-in-docker.md)
- [BuildKit Docker 部署教程](./blog/buildkit-docker.md)
- [Container Network Interface Docker 部署教程](./blog/container-network-interface-docker.md)

#### 🤖 AI/ML 相关
- [Dify Docker 部署教程](./blog/dify-docker.md)
- [Dify Web Docker 部署教程](./blog/dify-web-docker.md)
- [Dify Sandbox Docker 部署教程](./blog/dify-sandbox-docker.md)
- [Dify Plugin Daemon Docker 部署教程](./blog/dify-plugin-daemon-docker.md)
- [Ollama Docker 部署教程](./blog/ollama-docker.md)
- [vLLM OpenAI Docker 部署教程](./blog/vllm-openai-docker.md)
- [vLLM Docker NVIDIA Jetson 部署教程](./blog/vllm-docker-nvidia-jetson.md)
- [SGLang Docker 部署教程](./blog/sglang-docker.md)
- [LocalAI Docker 部署教程](./blog/localai-docker.md)
- [RAGFlow Docker 部署教程](./blog/ragflow-docker.md)
- [ComfyUI Docker 部署教程](./blog/comfyui-docker.md)
- [PaddleDetection Docker 部署教程](./blog/paddledetection-docker.md)
- [xProbeXInference Docker 部署教程](./blog/docker-xprobexinference.md)
- [Nano LLM Docker 部署教程](./blog/nano_llm-docker.md)
- [HP RetLiic OSIC Tools Docker 部署教程](./blog/hpretliic-osic-tools-docker.md)
- [Fish Speech Docker 部署教程](./blog/fish-speech-docker.md)
- [PowerRAG Docker 部署教程](./blog/powerrag-docker.md)
- [Refly Docker 部署教程](./blog/refly-docker.md)
- [Refly API Docker 部署教程](./blog/refly-api-dockerai.md)
- [TradingAgents Backend Docker 部署教程](./blog/tradingagents-backend-docker.md)

#### 🎬 媒体服务器
- [Jellyfin Docker 部署教程](./blog/jellyfin-docker.md)
- [Emby Media Server Docker 部署教程](./blog/emby-media-server-docker.md)
- [Emby Media Server ARM32v7 Docker 部署教程](./blog/emby-media-server-arm32v7-docker.md)
- [Emby Media Server ARM64v8 Docker 部署教程](./blog/emby-media-server-arm64v8-docker.md)
- [Navidrome Docker 部署教程](./blog/navidrome-docker.md)
- [Komga Docker 部署教程](./blog/komga-docker.md)
- [Immich Server Docker 部署教程](./blog/immich-server-docker.md)

#### 🛠️ 开发工具
- [Jenkins Docker 部署教程](./blog/jenkins-docker.md)
- [Gitea Docker 部署教程](./blog/gitea-docker.md)
- [GitLab Docker 部署教程](./blog/gitlab-docker.md)
- [VS Code Server Docker 部署教程](./blog/vs-code-server-docker.md)
- [Maven Docker 部署教程](./blog/maven-docker.md)
- [Tomcat Docker 部署教程](./blog/tomcat-docker.md)
- [Lobe Chat Docker 部署教程](./blog/lobe-chat-docker.md)
- [Lobe Chat Database Docker 部署教程](./blog/lobe-chat-database-docker.md)
- [LobeHub Docker 部署教程](./blog/lobehub-docker.md)

#### 📊 监控/日志
- [Prometheus Docker 部署教程](./blog/prometheus-docker.md)
- [Grafana Docker 部署教程](./blog/grafana-docker.md)
- [Uptime Kuma Docker 部署教程](./blog/uptime-kuma-docker.md)
- [Kibana Docker 部署教程](./blog/kibana-docker.md)
- [Falco Docker 部署教程](./blog/falco-docker.md)

#### 🐧 操作系统基础镜像
- [Ubuntu Docker 部署教程](./blog/ubuntu-docker.md)
- [Debian Docker 部署教程](./blog/docker-debian.md)
- [CentOS Docker 部署教程](./blog/docker-centos.md)
- [Rocky Linux Docker 部署教程](./blog/docker-rocky-linux.md)
- [AlmaLinux Docker 部署教程](./blog/docker-almalinux.md)
- [Alpine Linux Docker 部署教程](./blog/docker-alpine-linux.md)
- [openEuler Docker 部署教程](./blog/docker-openeuler.md)
- [Kylin Linux Docker 部署教程](./blog/docker-kylin-linux.md)
- [Oracle Linux Docker 部署教程](./blog/docker-oracle-linux.md)
- [Red Hat UBI8 Docker 部署教程](./blog/red-hat-ubi8-docker.md)
- [Linux for Tegra Docker 部署教程](./blog/linux-for-tegra-docker.md)

#### 🎯 其他应用
- [WordPress Docker 部署教程](./blog/docker-wordpress.md)
- [Nextcloud Docker 部署教程](./blog/nextcloud-docker.md)
- [Halo Docker 部署教程](./blog/halo-docker.md)
- [OnlyOffice DocumentServer Docker 部署教程](./blog/onlyoffice-documentserver-docker.md)
- [Home Assistant Docker 部署教程](./blog/docker-home-assistant.md)
- [qBittorrent Docker 部署教程](./blog/docker-qbittorrent.md)
- [Transmission Docker 部署教程](./blog/transmission-docker.md)
- [Jackett Docker 部署教程](./blog/jackett-docker.md)
- [MoviePilot Docker 部署教程](./blog/moviepilot.md)
- [Lucky Docker 部署教程](./blog/lucky-docker.md)
- [n8n Docker 部署教程](./blog/n8n-docker.md)
- [MinIO Docker 部署教程](./blog/minio-docker.md)
- [MinIO Client MC Docker 部署教程](./blog/minio-client-mc-docker.md)
- [phpMyAdmin Docker 部署教程](./blog/phpmyadmin-docker.md)
- [pgAdmin4 Docker 部署教程](./blog/pgadmin4-docker.md)
- [Mongo Express Docker 部署教程](./blog/mongo-express-docker.md)
- [SeekDB Docker 部署教程](./blog/seekdb-docker.md)
- [Hashicorp Vault Docker 部署教程](./blog/hashicorp-vault-docker.md)
- [Server Vaultwarden Docker 部署教程](./blog/server-vaultwardenserver-docker.md)
- [DDNS-Go Docker 部署教程](./blog/ddns-go-docker.md)
- [AdGuardHome Docker 部署教程](./blog/adguardhome-docker.md)
- [Calibre Web Docker 部署教程](./blog/calibre-web-docker.md)
- [Talebook Docker 部署教程](./blog/talebook-docker.md)
- [Papermerge Docker 部署教程](./blog/papermerge-docker.md)
- [Stirling PDF Docker 部署教程](./blog/stirling-pdf-docker-pdf.md)
- [Draw.io Docker 部署教程](./blog/drawio-docker.md)
- [Sun Panel Docker 部署教程](./blog/sun-panel-docker.md)
- [TrendRadar Docker 部署教程](./blog/trendradar-docker.md)
- [QuartzUI Docker 部署教程](./blog/quartzui-docker.md)
- [Hitokoto API Docker 部署教程](./blog/hitokoto-api-docker.md)
- [OpenList Docker 部署教程](./blog/openlist-docker.md)
- [SiYuan Docker 部署教程](./blog/siyuandocker.md)
- [EzBookkeeping Docker 部署教程](./blog/ezbookkeeping-docker.md)
- [Firefly III Docker 部署教程](./blog/firefly-iii-docker.md)
- [Music Tag Web Docker 部署教程](./blog/music_tag_web-docker.md)
- [Label Studio Docker 部署教程](./blog/label-studio-docker.md)
- [Langfuse Docker 部署教程](./blog/langfuse-docker.md)
- [Mineru Docker 部署教程](./blog/docker-mineru.md)
- [Crawl4AI Docker 部署教程](./blog/crawl4ai-docker.md)
- [OLMOCR Docker 部署教程](./blog/olmocr-docker.md)
- [Nacos Server Docker 部署教程](./blog/nacos-server-docker.md)
- [Apache Flink Docker 部署教程](./blog/apache-flink-docker.md)
- [Apache IoTDB Docker 部署教程](./blog/apache-iotdb-docker.md)
- [CVAT Server Docker 部署教程](./blog/cvat-server-docker.md)
- [FastSurfer Docker 部署教程](./blog/fastsurfer-docker.md)
- [GPUSTACK Docker 部署教程](./blog/gpustack-docker.md)
- [NVIDIA CUDA Docker 部署教程](./blog/nvidia-cuda-docker.md)
- [Docker 微服务架构部署教程](./blog/docker-microservices.md)
- [ROS Docker 部署教程](./blog/ros-docker.md)
- [OSRF ROS Docker 部署教程](./blog/osrf-ros-docker.md)
- [RustFS Docker 部署教程](./blog/rustfs-docker.md)
- [XCP Derivatives Docker 部署教程](./blog/xcp-derivatives-docker.md)
- [Pandas Final Docker 部署教程](./blog/pandas-final-docker.md)
- [Pillow Final Docker 部署教程](./blog/pillow_final-docker.md)
- [Standalone Chrome Docker 部署教程](./blog/standalone-chrome-docker.md)
- [Squid Docker 部署教程](./blog/squid-docker.md)
- [Netshoot Docker 部署教程](./blog/netshoot-docker.md)
- [BusyBox Docker 部署教程](./blog/busybox-docker.md)
- [Hello World Docker 部署教程](./blog/hello-world-docker.md)
- [Docker Port Viewer Docker 部署教程](./blog/docker-port-viewer-docker.md)
- [LAMP Docker 部署教程](./blog/lamp-docker.md)
- [LinuxServer.io LibreOffice Docker 部署教程](./blog/linuxserverio-libreoffice.md)
- [LinuxServer.io Webtop Docker 部署教程](./blog/linuxserverio-webtop-dockerlinux.md)
- [Milvus GUI Attu Docker 部署教程](./blog/milvus-gui-attu-docker.md)
- [Seafile MC Docker 部署教程](./blog/seafile-mc-docker.md)
- [AstrBot Docker 部署教程](./blog/astrbot-docker.md)
- [Baota Linux Docker 部署教程](./blog/baota-linux-docker.md)
- [QingLong Docker 部署教程](./blog/docker-qinglong.md)
- [Windows Docker Desktop 部署教程](./blog/windows-docker-desktop.md)
- [Linux Docker Docker Compose Ubuntu/CentOS 部署教程](./blog/linux-docker-docker-compose-ubuntucentos-11.md)
- [2025年11月 Docker 更新](./blog/2025-11-docker.md)
- [2025年12月 Docker 更新](./blog/2025-12-docker.md)

## Linux 一键安装 Docker + 轩辕镜像加速

### 🚀 推荐方案：一键安装配置脚本

该脚本支持 13 种 Linux 发行版，包括国产操作系统（openEuler、Anolis OS、OpenCloudOS、Alinux、Kylin Linux），一键安装 docker、docker-compose 并自动配置轩辕镜像加速源。

```bash
# 下载并执行一键安装脚本
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 也可以使用 GitHub 上的脚本
bash <(curl -sSL https://raw.githubusercontent.com/SeanChang/xuanyuan_docker_proxy/refs/heads/main/docker.sh)
```

**脚本已开源：** [GitHub 源码](https://github.com/SeanChang/xuanyuan_docker_proxy)

### ✨ 脚本特性与优势

- ✅ **支持 13 种主流发行版**：openEuler (欧拉)、OpenCloudOS、Anolis OS (龙蜥)、Alinux (阿里云)、Kylin Linux (银河麒麟)、Fedora、Rocky Linux、AlmaLinux、Ubuntu、Debian、CentOS、RHEL、Oracle Linux
- ✅ **国产操作系统完整支持**：深度适配国产操作系统（openEuler、Anolis OS、OpenCloudOS、Alinux、Kylin Linux），支持版本自动识别和最优配置
- ✅ **多镜像源智能切换**：内置阿里云、腾讯云、华为云、中科大、清华等 6+ 国内镜像源，自动检测并选择最快源
- ✅ **老版本系统特殊处理**：支持 Ubuntu 16.04、Debian 9/10 等已过期系统，自动配置兼容的安装方案
- ✅ **双重安装保障**：包管理器安装失败时自动切换到二进制安装，确保安装成功率
- ✅ **macOS/Windows 友好提示**：自动检测 macOS 和 Windows 系统，提供适合的 Docker Desktop 安装指引

### 📋 支持的操作系统

我们的一键安装脚本支持 13 种主流 Linux 发行版，包括国产操作系统、CentOS 替代品和传统发行版：

| 操作系统 | 版本 | 支持状态 | 说明 |
|---------|------|---------|------|
| **🇨🇳 国产操作系统** | | | |
| openEuler (欧拉) | 20.03+, 22.03+, 24.03+ | ✅ | 华为开源，CentOS 兼容 |
| OpenCloudOS | 9.x | ✅ | 腾讯开源，CentOS 9 兼容 |
| Anolis OS (龙蜥) | 7.x, 8.x | ✅ | 阿里云支持，RHEL 兼容 |
| Alinux (阿里云) | 2.x, 3.x | ✅ | 阿里云 ECS 默认系统 |
| Kylin Linux (银河麒麟) | V10 | ✅ | 国产操作系统，RHEL 兼容 |
| **🌍 CentOS 替代品（企业级）** | | | |
| Rocky Linux | 8.x, 9.x | ✅ | 10年支持，RHEL 兼容 |
| AlmaLinux | 8.x, 9.x | ✅ | 10年支持，RHEL 兼容 |
| **🔄 创新发行版** | | | |
| Fedora | 34+ | ✅ | Red Hat 上游，最新特性 |
| **📦 传统发行版** | | | |
| Ubuntu | 16.04+ | ✅ | 含老版本特殊处理 |
| Debian | 9+ | ✅ | 含老版本特殊处理 |
| CentOS | 7, 8, 9 | ✅ | 包含 Stream 版本 |
| RHEL | 7, 8, 9 | ✅ | Red Hat Enterprise Linux |
| Oracle Linux | 7, 8, 9 | ✅ | Oracle 企业级发行版 |

> 💡 **提示**：脚本会自动检测您的操作系统类型和版本，并选择最优的安装方案。对于老版本系统（如 Ubuntu 16.04、Debian 9/10），脚本会自动使用兼容的安装方式。

### 📖 使用说明

1. 复制上述命令到您的 Linux 终端
2. 按提示选择版本（免费版或专业版）
3. 如选择专业版，输入您的专属免登录地址
4. 脚本将自动完成所有配置

---

## Linux Docker 加速 - 轩辕镜像配置手册

<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a> 提供高速稳定的 Docker 镜像加速服务，让您的 Docker 操作享受极速体验。

## Linux 配置轩辕镜像源

在 Linux 系统上配置<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>源，让所有 Docker 操作都享受高速加速体验。

### 1. 获取专属免登录地址

在<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>个人中心获取您的专属免登录加速地址，格式为：`xxx.xuanyuan.run`

> **注意**：`xxx.xuanyuan.run` 请替换为您的专属免登录加速地址，请登录网站后在个人中心获取。

### 2. 配置 Docker daemon

使用以下命令配置 Docker daemon 文件：

```bash
echo '{"insecure-registries":["xxx.xuanyuan.run"],"registry-mirrors":["https://xxx.xuanyuan.run"]}' | sudo tee /etc/docker/daemon.json > /dev/null
```

此命令会将镜像源配置写入 `/etc/docker/daemon.json` 文件

> **注意**：`xxx.xuanyuan.run` 请替换为您的专属免登录加速地址，请登录网站后在个人中心获取。

### 3. 重新加载 daemon

重新加载 systemd daemon 配置：

```bash
systemctl daemon-reload
```

### 4. 重启 Docker 服务

重启 Docker 服务使配置生效：

```bash
systemctl restart docker
```

重启后，Docker 将使用新的镜像源配置

### 5. 验证配置

验证配置是否生效：

```bash
docker info | grep -A 10 "Registry Mirrors"
```

如果配置成功，您应该能看到您的<a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像</a>地址

### 6. 镜像搜索步骤

配置完成后，您可以直接使用标准的 Docker 命令搜索镜像：

```bash
docker search nginx
```

### 7. 镜像下载步骤

配置完成后，您可以直接使用标准的 Docker 命令拉取镜像：

```bash
docker pull mysql:latest
```

> **PS**: 不加 TAG 默认为 latest，建议指定具体的 TAG 版本进行下载。

## 配置说明

### 🐳 为什么配置了 Docker Registry Mirrors 仍然走官方源？

很多用户反馈，已经在 Docker 中配置了镜像加速器（registry-mirrors），但拉取镜像时仍然访问官方源（docker.io）。

拉取报错如下：

```
Get "https://registry-1.docker.io/v2/": net/http: request canceled while waiting for connection (Client. Timeout exceeded while awaiting headers)
```

这是因为 Docker 的镜像拉取机制是优先尝试使用镜像加速器，而不是强制始终使用。部分镜像的 tag 或 namespace 特殊（如 docker-library），可能仍绕过加速器。

### 常见原因

#### 免登录地址没有可用流量

如果你使用免登录地址，但该地址没有购买流量，当 Docker 客户端请求加速器时，服务端会返回 402 Payment Required 错误，Docker 就会直接回退到官方仓库 docker.io 拉取镜像。

**解决方案**: 请前往<a href="https://xuanyuan.cloud/recharge" target="_blank">轩辕镜像</a>充值页面购买相应的流量包，确保您的免登录地址有足够的流量支持镜像加速服务。

### 如何确认免登录地址可用

建议先用下列方式测试：

```bash
docker pull abc123def456.xuanyuan.run/mysql
```

如果能正常拉取，说明免登录地址可用且有流量。

### 解决方法

如果配置后仍然不生效，建议参考下列文档拉取镜像：

- <a href="https://xuanyuan.cloud/" target="_blank">免登录配置教程</a> 或 <a href="https://xuanyuan.cloud/" target="_blank">登录方式配置教程</a>

## 更多信息

访问 <a href="https://xuanyuan.cloud/" target="_blank">轩辕镜像官网</a> 获取更多配置教程和技术支持。
