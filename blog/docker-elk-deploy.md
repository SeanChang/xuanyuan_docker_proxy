# Docker 部署 ELK：轻松搭建开源日志检索与可视化平台

![Docker 部署 ELK：轻松搭建开源日志检索与可视化平台](https://imgs.xuanyuan.cloud/docker/blog/elk/elk1.webp)

*分类: Docker部署教程 | 标签: ELK,Elasticsearch,Logstash,Kibana,Docker,轩辕镜像,日志,私有化部署,部署教程 | 发布时间: 2026-10-20 19:21:32*

> ELK 是面向需要集中检索日志的开源日志栈，由 Elasticsearch、Logstash 和 Kibana 组成，旨在把采集、存储、查询和可视化放在同一套服务里，并通过索引与仪表盘整理日志。本文将介绍如何通过 Docker Compose 快速部署 ELK，搭建日志检索与可视化平台，帮助你在自己的服务器上搜索日志和查看仪表盘，适合内网日志集中与样例数据演示等场景。

*本文基于 [docker.elastic.co/elasticsearch/elasticsearch:7.17.2](https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch)，同栈 [Logstash](https://xuanyuan.cloud/docker.elastic.co/logstash/logstash?tag=7.17.2)、[Kibana](https://xuanyuan.cloud/docker.elastic.co/kibana/kibana?tag=7.17.2) 均为 **7.17.2**，测试平台 **Ubuntu 24.04** Linux。*

## ELK 是什么

ELK 是 Elastic 公司 Elastic Stack 的常用叫法，由 Elasticsearch、Logstash 和 Kibana 三个组件组成。它用来把分散的日志收进来，做成可以检索的索引，再在浏览器里查询和看图。

与在每台机器上翻日志文件，或把日志交给按量计费的云日志服务不同，ELK 把存储、管道和查询界面放在你自己的服务器上。检索和仪表盘都对着这份自己保存的数据。

## ELK 能做什么

- **集中存储和检索日志**：Elasticsearch 保存日志，并提供全文检索和聚合统计。
- **接入并整理日志**：Logstash 接收 Beats 或 Syslog，过滤、转换后再写入 Elasticsearch。
- **在浏览器里查询**：Kibana 按时间和条件查看日志，也可以打开现成的解决方案页面。
- **查看仪表盘和地图**：官方样例数据里有订单收入、航班和 Web 访问的图表。
- **按天存放索引**：日志可以写入带日期的索引，便于按天查询。

## 为什么要使用 ELK

应用日志散在多台机器上时，出了问题要一台一台打开文件。把日志交给云服务，又要按写入量和保留时间付费，数据也不在自己这边。

ELK 把采集、索引和可视化放在同一套服务里。日志留在自己的磁盘上，浏览器打开 Kibana 就能搜索和看图。它适合需要集中查看应用日志、又不想把日志只放在第三方的团队。

## 使用 Docker 部署 ELK

ELK 可以用 Docker 把 Elasticsearch、Logstash 和 Kibana 一起跑起来。开始之前准备好 Docker 运行环境，并按这台机器的内存和 CPU 准备好运行参数。

接下来用 Docker Compose 写好三个服务，完成启动，再在浏览器里打开 Kibana，确认能查询并查看样例数据。

## 环境要求

本文三个镜像都使用 **7.17.2**。版本怎么选，见「标签怎么选」。Elasticsearch 堆内存按下面的 Compose 设为 1g，整机建议至少还有 4 GB 可用内存。实验环境关闭了认证，生产环境不要沿用这个写法，见「常见问题」。

| 项目 | 建议 |
|------|------|
| 系统 | Linux x86_64（本文 Ubuntu 24.04）。macOS 把 `/data/elk` 换成 `~/docker/elk`。Windows 安装 Docker Desktop 后，在能执行 bash 的终端里运行下文命令 |
| Docker | 已安装 Docker Engine 与 **Compose V2**（`docker compose`） |
| 内存 | Elasticsearch 堆 1g，整机建议 ≥ 4 GB 可用 |
| 内核 | `vm.max_map_count` 至少为 262144 |
| 端口 | 宿主机 **9200** → Elasticsearch **9200**；宿主机 **5601** → Kibana **5601**；宿主机 **5044** → Logstash **5044**；宿主机 **1514/udp** → Logstash **1514/udp** |
| 工作目录 | `/data/elk`（本文实测目录，其下还有 `logstash/pipeline`） |
| 拉取地址 | `***-elastic.xuanyuan.run`。`***` 换成你在轩辕镜像控制台里的专属前缀 |
| 账号 | 7.17.2 这套实验配置没有登录账号 |

```bash
docker --version
docker compose version
sudo sysctl -w vm.max_map_count=262144
```

要开机后仍然生效，再执行：

```bash
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

Windows 和 Mac 从 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 安装，安装后启动 Docker Desktop。下文的 `cat > … <<'EOF'` 是 bash 写法。PowerShell 不能直接粘贴这一段，请改用 Git Bash、WSL，或在 Linux 上执行。

## 标签怎么选

三个镜像的版本号保持一致。本文命令使用 **7.17.2**，这一套在 Ubuntu 24.04 上已经启动，Kibana 可以打开。

**9.4.3** 的 Compose 写在「ELK 9.4.3」。本文这台机器执行后，Elasticsearch 日志里是 `Fatal glibc error: CPU does not support x86-64-v2`，健康检查未通过，Kibana 和 Logstash 也没有起来。没有 SSE4.2，或虚拟机使用了阉割后的 CPU 型号时，用 7.17.2。

自检：

```bash
lscpu | grep -E 'Model name|Flags'
grep -o 'sse4_2' /proc/cpuinfo | head -1
```

没有 `sse4_2` 时，不要改用 9.4.3。有 `sse4_2` 仍出现上面的 glibc 报错时，检查虚拟机是不是用了 `kvm64` 这类型号；改成 `host` 透传后再试 9.x。

| 标签 | 说明 | 是否写入本文主路径 |
|------|------|--------------------|
| **`7.17.2`** | 本文 Ubuntu 24.04 已启动 Elasticsearch、Logstash、Kibana | **是** |
| `9.4.3` | 需要 CPU 支持 x86-64-v2。本文机器未跑通 | 否。仅作「ELK 9.4.3」里的参考 |
| `latest` | 会随仓库更新改指向 | 否 |

镜像页上可能展示别的 7.17 标签。要更换版本时，三个 `image` 一起改，并先看「升级」。不要只改其中一个组件。

## 拉取镜像

Elastic 官方镜像在 `docker.elastic.co`。`daemon.json` 里的 `registry-mirrors` 只对 Docker Hub 生效，这里要在镜像名里写专属地址。用 [轩辕镜像](https://xuanyuan.cloud) **加速拉取**，把 `***` 换成你的专属前缀。写法见 [Elastic 拉取教程](https://xuanyuan.cloud/usage/mirror-tutorial/elastic)。

```bash
docker pull ***-elastic.xuanyuan.run/elasticsearch/elasticsearch:7.17.2
docker pull ***-elastic.xuanyuan.run/logstash/logstash:7.17.2
docker pull ***-elastic.xuanyuan.run/kibana/kibana:7.17.2
```

写好「Docker Compose 部署」里的文件后，也可以在 `/data/elk` 执行 `docker compose pull`。Ubuntu 24.04 实测输出：

```text
[+] Pulling 33/34
 ✔ logstash Pulled                                                          198.4s
 ✔ elasticsearch Pulled                                                     112.9s
 ✔ kibana Pulled                                                            127.3s
```

大镜像偶发 `TLS handshake timeout`，或某一层 digest 校验失败时，再执行一次同一条拉取命令。

## Docker Compose 部署

工作目录是 `/data/elk`。Elasticsearch 的数据在命名卷 `es-data` 里，不在这个目录下。Logstash 的管道配置在 `./logstash/pipeline`。三个服务在同一个 `elk` 网络里，用服务名 `elasticsearch` 互访，不要写成 `127.0.0.1`。

数据流如下：

```text
Filebeat / Syslog / 应用日志
        │
        ▼
   Logstash 容器  ──写入──▶  Elasticsearch 容器(:9200)
                                      ▲
   浏览器 ──HTTP:5601──▶ Kibana 容器 ─┘（查询）
```

下面这套 Compose 关闭了 `xpack.security`，只适合内网实验。宿主机端口是 **9200**、**5601**、**5044** 和 **1514/udp**。

### 创建目录

```bash
mkdir -p /data/elk/logstash/pipeline
chown -R "$USER:$USER" /data/elk
cd /data/elk

# macOS：mkdir -p ~/docker/elk/logstash/pipeline && cd ~/docker/elk
```

当前用户不是 root 时，给 `mkdir` 和 `chown` 加上 `sudo`。这次实测的提示符是 `root@ubuntu2404:/data/elk#`。

### 编写 docker-compose.yml

```bash
cd /data/elk
cat > docker-compose.yml <<'EOF'
services:
  elasticsearch:
    image: ***-elastic.xuanyuan.run/elasticsearch/elasticsearch:7.17.2
    container_name: elasticsearch
    restart: unless-stopped
    environment:
      - discovery.type=single-node
      - ES_JAVA_OPTS=-Xms1g -Xmx1g
      - xpack.security.enabled=false
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - es-data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
    networks:
      - elk
    healthcheck:
      test: ["CMD-SHELL", "curl -s http://localhost:9200/_cluster/health | grep -qE '"status":"(green|yellow)"'"]
      interval: 30s
      timeout: 10s
      retries: 10
      start_period: 60s

  kibana:
    image: ***-elastic.xuanyuan.run/kibana/kibana:7.17.2
    container_name: kibana
    restart: unless-stopped
    depends_on:
      elasticsearch:
        condition: service_healthy
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      # 可选：消除 publicBaseUrl 警告
      # - SERVER_PUBLICBASEURL=http://192.168.1.10:5601
    ports:
      - "5601:5601"
    networks:
      - elk

  logstash:
    image: ***-elastic.xuanyuan.run/logstash/logstash:7.17.2
    container_name: logstash
    restart: unless-stopped
    depends_on:
      elasticsearch:
        condition: service_healthy
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline:ro
    ports:
      - "5044:5044"
      - "1514:1514/udp"
    networks:
      - elk

volumes:
  es-data:

networks:
  elk:
    driver: bridge
EOF
```

| 项 | 说明 |
|----|------|
| `***-elastic.xuanyuan.run` | 换成你的专属前缀。三个 `image` 都是 **7.17.2** |
| `"9200:9200"` | 宿主机 **9200** → Elasticsearch **9200** |
| `"5601:5601"` | 宿主机 **5601** → Kibana **5601** |
| `"5044:5044"` | 宿主机 **5044** → Logstash Beats **5044** |
| `"1514:1514/udp"` | 宿主机 **1514/udp** → Logstash **1514/udp** |
| `es-data` | Elasticsearch 数据卷，挂到容器内 `/usr/share/elasticsearch/data` |
| `xpack.security.enabled=false` | 实验环境关闭认证。生产环境见「常见问题」 |
| `ELASTICSEARCH_HOSTS` | 使用服务名 `elasticsearch`，不要写 `127.0.0.1` |

`SERVER_PUBLICBASEURL` 那一行默认是注释。要去掉 Kibana 里缺少 `server.publicBaseUrl` 的提示时，删掉行首的 `#`，并把 IP 换成这台机器的地址。

### 编写 .env

```bash
cd /data/elk
cat > .env <<'EOF'
TZ=Asia/Shanghai
EOF
```

### 编写 Logstash 管道

```bash
cd /data/elk
cat > logstash/pipeline/main.conf <<'EOF'
input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    index => "logs-%{+YYYY.MM.dd}"
  }
}
EOF
```

这个管道在 5044 接收 Beats，按天写入索引 `logs-YYYY.MM.dd`。输出地址同样使用服务名 `elasticsearch`。

### 确认文件

```bash
cd /data/elk
ls -la
ls -la logstash/pipeline/
grep image docker-compose.yml
```

Ubuntu 24.04 实测：

```text
total 20
drwxr-xr-x 3 root root 4096 Jul 17 09:13 .
drwxr-xr-x 7 root root 4096 Jul 17 08:50 ..
-rw-r--r-- 1 root root 1461 Jul 17 09:12 docker-compose.yml
-rw-r--r-- 1 root root   17 Jul 17 09:13 .env
drwxr-xr-x 3 root root 4096 Jul 17 08:50 logstash
```

```text
logstash/pipeline/
-rw-r--r-- 1 root root  152 Jul 17 09:13 main.conf
```

```text
    image: ***-elastic.xuanyuan.run/elasticsearch/elasticsearch:7.17.2
    image: ***-elastic.xuanyuan.run/kibana/kibana:7.17.2
    image: ***-elastic.xuanyuan.run/logstash/logstash:7.17.2
```

### 启动并验证

确认 `vm.max_map_count` 已经设好。镜像还没在本地时，先执行「拉取镜像」里的命令，或在这个目录执行 `docker compose pull`。

```bash
cd /data/elk
sudo sysctl -w vm.max_map_count=262144
docker compose up -d
```

Ubuntu 24.04 实测：

```text
[+] Running 3/3
 ✔ Container elasticsearch  Healthy                                          44.4s
 ✔ Container kibana         Started                                          44.3s
 ✔ Container logstash       Started                                          44.5s
```

`elasticsearch` 变成 Healthy 之后，Kibana 和 Logstash 才会启动。Healthy 表示集群状态是 green 或 yellow。

## 验证 Elasticsearch

浏览器访问 `http://服务器IP:9200/`。把 IP 换成这台机器的地址。这次实测访问的是 `http://192.168.1.10:9200/`，在服务器本机上也可以用 `http://127.0.0.1:9200/`。

返回体类似：

```json
{
  "name": "ccacef2fe6f8",
  "cluster_name": "docker-cluster",
  "version": {
    "number": "7.17.2",
    "build_flavor": "default",
    "build_type": "docker",
    "lucene_version": "8.11.1"
  },
  "tagline": "You Know, for Search"
}
```

`version.number` 为 `7.17.2` 即可。再看集群状态：

```bash
curl http://127.0.0.1:9200/_cluster/health?pretty
```

## 打开 Kibana

浏览器访问 `http://服务器IP:5601/`。这次实测是 `http://192.168.1.10:5601/`。

首次打开可能出现「Kibana server is not ready yet」。冷启动时等 2～5 分钟再刷新。若一直停在这句话，按「常见问题」查看日志。

就绪后是「Welcome to Elastic」。实验环境点「Explore on my own」。右下角若提示缺少 `server.publicBaseUrl`，可以点「Mute」，或按 `docker-compose.yml` 里的注释打开 `SERVER_PUBLICBASEURL`。

![Kibana 欢迎页：Welcome to Elastic，可点 Explore on my own](https://img.xuanyuan.dev/docker/blog/elk-1.webp)

进入主页后能看到 Enterprise Search、Observability、Security、Analytics。

![Kibana 主页：Enterprise Search、Observability、Security、Analytics 四个入口](https://img.xuanyuan.dev/docker/blog/elk-2.webp)

![Kibana Enterprise Search 欢迎页](https://img.xuanyuan.dev/docker/blog/elk-3.webp)

![Kibana Elastic Security Overview](https://img.xuanyuan.dev/docker/blog/elk-4.webp)

![Kibana Analytics 欢迎页](https://img.xuanyuan.dev/docker/blog/elk-5.webp)

![Kibana Observability 欢迎页](https://img.xuanyuan.dev/docker/blog/elk-6.webp)

三个容器已经在跑，浏览器可以打开这些页面。下面用官方样例数据看仪表盘。

## 导入样例数据

在 Kibana 打开「Integrations」→「Sample data」，或从主页进入「Try sample data」。可以添加 eCommerce、Flights、Web logs。

![Kibana Sample data：eCommerce、Flights、Web logs](https://img.xuanyuan.dev/docker/blog/elk-7.webp)

### eCommerce 样例

![Kibana eCommerce Revenue Dashboard](https://img.xuanyuan.dev/docker/blog/elk-18.webp)

![Kibana Canvas：eCommerce Revenue Tracking](https://img.xuanyuan.dev/docker/blog/elk-9.webp)

![Kibana Maps：eCommerce Orders by Country](https://img.xuanyuan.dev/docker/blog/elk-10.webp)

### Flights 样例

![Kibana Flights Global Flight Dashboard](https://img.xuanyuan.dev/docker/blog/elk-11.webp)

![Kibana Canvas：Flights Overview](https://img.xuanyuan.dev/docker/blog/elk-12.webp)

![Kibana Maps：Flights Origin Time Delayed](https://img.xuanyuan.dev/docker/blog/elk-13.webp)

### Web logs 样例

![Kibana Logs Web Traffic 仪表盘](https://img.xuanyuan.dev/docker/blog/elk-20.webp)

![Kibana Canvas：Logs Web Traffic](https://img.xuanyuan.dev/docker/blog/elk-15.webp)

![Kibana Maps：Logs Total Requests and Bytes](https://img.xuanyuan.dev/docker/blog/elk-16.webp)

![Kibana Observability Logs Stream：样例 web logs](https://img.xuanyuan.dev/docker/blog/elk-17.webp)

真实业务日志可以让 Filebeat 发到 Logstash 的 5044，或在 `main.conf` 里增加别的 input。索引名默认是 `logs-YYYY.MM.dd`。在「Stack Management」→「Index Patterns」里创建匹配这个名字的模式后，就可以在「Discover」里查询。同版本 Filebeat 的镜像名是 `***-elastic.xuanyuan.run/beats/filebeat:7.17.2`。本文没有部署 Filebeat。

## 日常运维

```bash
cd /data/elk
docker compose ps
docker compose logs -f --tail=100
docker compose restart kibana
docker compose down
```

`docker compose down` 会停掉容器，命名卷 `es-data` 还在。下面这条会删掉 Elasticsearch 的数据，执行前先确认：

```bash
# docker compose down -v
```

### 升级

小版本升级时，把三个 `image` 改成同一个新标签，再拉取并重建：

```bash
cd /data/elk
docker compose pull
docker compose up -d
```

跨大版本时不要复用旧数据卷，例如从 7.17.2 换到 9.x。先备份，再删除卷，然后用新标签重新启动：

```bash
cd /data/elk
docker compose down
docker volume rm elk_es-data
```

`elk_es-data` 里的 `elk` 是 Compose 项目名，默认取工作目录的文件夹名。目录不叫 `elk` 时，用 `docker volume ls` 看实际卷名，再删除。

## ELK 9.4.3

下面的 Compose 只给 CPU 支持 x86-64-v2（含 SSE4.2）的机器作参考。本文的 Ubuntu 24.04 **没有**把 9.4.3 跑起来。镜像页：

- [elasticsearch:9.4.3](https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch?tag=9.4.3)
- [logstash:9.4.3](https://xuanyuan.cloud/docker.elastic.co/logstash/logstash?tag=9.4.3)
- [kibana:9.4.3](https://xuanyuan.cloud/docker.elastic.co/kibana/kibana?tag=9.4.3)

### 本文机器上的失败记录

1. 第一次 `docker compose pull` 时，Kibana 出现 `TLS handshake timeout`。再拉一次后，三个镜像都显示 Pulled，耗时大约 10 分钟。
2. 接着执行 `docker compose up -d`，结果是 `dependency failed to start: container elasticsearch is unhealthy`。
3. Elasticsearch 日志里的原因是：

```text
Fatal glibc error: CPU does not support x86-64-v2
```

这是镜像要求的 CPU 指令集，当前宿主机或虚拟机不满足。改健康检查、改密码都不能让它启动。随后删掉 9.4.3 的容器和镜像，改回 **7.17.2** 才启动成功。CPU 自检命令在「标签怎么选」。

### 9.4.3 的 Compose

下面打开了基础认证，HTTP 仍是明文（`xpack.security.http.ssl.enabled=false`）。健康检查要带上 `elastic` 用户的密码。本文没有用这套文件完成启动。`ELASTIC_PASSWORD` 换成你自己的强密码，不要使用示例里的占位文字。

下面三条 `cat` 会覆盖 `/data/elk` 里已经写好的 `docker-compose.yml`、`.env` 和 `main.conf`。先确认 CPU 支持 x86-64-v2，再覆盖。这台机器若已经用 7.17.2 跑起来，不要在同一目录里直接覆盖。

```bash
cd /data/elk
cat > docker-compose.yml <<'EOF'
services:
  elasticsearch:
    image: ***-elastic.xuanyuan.run/elasticsearch/elasticsearch:9.4.3
    container_name: elasticsearch
    restart: unless-stopped
    environment:
      - discovery.type=single-node
      - ES_JAVA_OPTS=-Xms1g -Xmx1g
      - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
      - xpack.security.enabled=true
      - xpack.security.http.ssl.enabled=false
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - es-data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
    networks:
      - elk
    healthcheck:
      test: ["CMD-SHELL", "curl -s -u elastic:$${ELASTIC_PASSWORD} http://localhost:9200/_cluster/health | grep -qE '"status":"(green|yellow)"'"]
      interval: 30s
      timeout: 10s
      retries: 10
      start_period: 60s

  kibana:
    image: ***-elastic.xuanyuan.run/kibana/kibana:9.4.3
    container_name: kibana
    restart: unless-stopped
    depends_on:
      elasticsearch:
        condition: service_healthy
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=elastic
      - ELASTICSEARCH_PASSWORD=${ELASTIC_PASSWORD}
    ports:
      - "5601:5601"
    networks:
      - elk

  logstash:
    image: ***-elastic.xuanyuan.run/logstash/logstash:9.4.3
    container_name: logstash
    restart: unless-stopped
    depends_on:
      elasticsearch:
        condition: service_healthy
    environment:
      - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline:ro
    ports:
      - "5044:5044"
      - "1514:1514/udp"
    networks:
      - elk

volumes:
  es-data:

networks:
  elk:
    driver: bridge
EOF
```

`.env`：

```bash
cd /data/elk
cat > .env <<'EOF'
ELASTIC_PASSWORD=你的强密码
EOF
```

`main.conf` 的输入与 7.17.2 相同，输出要带账号：

```bash
cd /data/elk
cat > logstash/pipeline/main.conf <<'EOF'
input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    user => "elastic"
    password => "${ELASTIC_PASSWORD}"
    index => "logs-%{+YYYY.MM.dd}"
  }
}
EOF
```

从 9.4.3 改回 7.17.2 时，先删掉数据卷，避免两个大版本共用同一份数据。删卷会清掉已经写入的索引：

```bash
cd /data/elk
docker compose down
docker volume rm elk_es-data
```

然后把 Compose、`.env` 和 `main.conf` 改回 7.17.2 那一节的内容，再执行 `docker compose pull` 和 `docker compose up -d`。

## 常见问题

**Q1：`registry-mirrors` 里已经写了轩辕镜像，拉 Elastic 仍然很慢或拉不到？**

`registry-mirrors` 只对 Docker Hub 生效。Elastic 镜像要写成 `***-elastic.xuanyuan.run/elasticsearch/elasticsearch:7.17.2` 这种专属地址。见 [Elastic 拉取教程](https://xuanyuan.cloud/usage/mirror-tutorial/elastic)。

**Q2：日志里出现 `Fatal glibc error: CPU does not support x86-64-v2`？**

9.x 这套镜像要求 CPU 支持 x86-64-v2。换一台有 SSE4.2 的机器，或把虚拟机 CPU 改成 `host` 透传后再试。当前机器也可以改回 **7.17.2**。改健康检查不能绕过这个报错。对照见「标签怎么选」和「ELK 9.4.3」。

**Q3：Kibana 一直显示 not ready yet？**

先等 2～5 分钟再刷新。仍然不行时执行 `docker logs kibana`，并确认 Compose 里是 `ELASTICSEARCH_HOSTS=http://elasticsearch:9200`，且 `docker compose ps` 里 Elasticsearch 已经是 Healthy。

**Q4：生产环境可以关闭 `xpack.security` 吗？**

本文 7.17.2 是在内网实验里关闭的。生产环境不要把 9200 和 5601 直接暴露到公网，也不要继续关闭认证。9.4.3 那一节写了打开认证的 Compose，但本文机器没有跑通。证书和 TLS 需要另按 Elastic 文档配置，本文没有做这一步。

**Q5：只需要 Elasticsearch 和 Kibana，不要 Logstash？**

可以。从 `docker-compose.yml` 里删掉 `logstash` 服务后再 `docker compose up -d`。采集可以改成 Filebeat 直接写入 Elasticsearch。本文没有实测这条路径。

**Q6：拉取时报 `TLS handshake timeout`，或某一层 digest 校验失败？**

再执行一次 `docker pull` 或 `docker compose pull`。本文拉 7.17.2 和 9.4.3 时都遇到过，重试后三个镜像可以拉完。9.4.3 拉完后仍可能因 CPU 起不来，那是另一件事。

**Q7：升级或改回 7.17.2 之后，Kibana 里看不到原来的索引？**

跨大版本时本文要求先删掉 `elk_es-data`。删卷之后，旧索引不在了。小版本升级如果保留了这个卷，索引还在。「Discover」里没有数据时，先到「Stack Management」→「Index Patterns」看模式是否还匹配 `logs-*`。

## 命令速查

三个服务要在同一网络里用服务名互相访问，本文用 Docker Compose 启动。把 `***` 换成你的专属前缀。

```bash
sudo sysctl -w vm.max_map_count=262144

docker pull ***-elastic.xuanyuan.run/elasticsearch/elasticsearch:7.17.2
docker pull ***-elastic.xuanyuan.run/logstash/logstash:7.17.2
docker pull ***-elastic.xuanyuan.run/kibana/kibana:7.17.2

cd /data/elk
docker compose pull
docker compose up -d
docker compose ps
docker compose logs -f --tail=100
curl http://127.0.0.1:9200/_cluster/health?pretty

docker compose restart kibana
docker compose down
```

浏览器打开 `http://服务器IP:5601`。Elasticsearch 是 `http://服务器IP:9200`。

## 延伸阅读

| 资源 | 链接 |
|------|------|
| [elasticsearch 镜像页](https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch) | [https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch](https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch) |
| [logstash:7.17.2 镜像页](https://xuanyuan.cloud/docker.elastic.co/logstash/logstash?tag=7.17.2) | [https://xuanyuan.cloud/docker.elastic.co/logstash/logstash?tag=7.17.2](https://xuanyuan.cloud/docker.elastic.co/logstash/logstash?tag=7.17.2) |
| [kibana:7.17.2 镜像页](https://xuanyuan.cloud/docker.elastic.co/kibana/kibana?tag=7.17.2) | [https://xuanyuan.cloud/docker.elastic.co/kibana/kibana?tag=7.17.2](https://xuanyuan.cloud/docker.elastic.co/kibana/kibana?tag=7.17.2) |
| [elasticsearch:9.4.3 镜像页](https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch?tag=9.4.3) | [https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch?tag=9.4.3](https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch?tag=9.4.3) |
| [Elastic 拉取教程](https://xuanyuan.cloud/usage/mirror-tutorial/elastic) | [https://xuanyuan.cloud/usage/mirror-tutorial/elastic](https://xuanyuan.cloud/usage/mirror-tutorial/elastic) |
| [Elastic Stack](https://www.elastic.co/elastic-stack) | [https://www.elastic.co/elastic-stack](https://www.elastic.co/elastic-stack) |
| [Elasticsearch 7.17 Docker 文档](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docker.html) | [https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docker.html](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/docker.html) |
| [Logstash 7.17 Docker 文档](https://www.elastic.co/guide/en/logstash/7.17/docker.html) | [https://www.elastic.co/guide/en/logstash/7.17/docker.html](https://www.elastic.co/guide/en/logstash/7.17/docker.html) |
| [Kibana 7.17 Docker 文档](https://www.elastic.co/guide/en/kibana/7.17/docker.html) | [https://www.elastic.co/guide/en/kibana/7.17/docker.html](https://www.elastic.co/guide/en/kibana/7.17/docker.html) |
| [GitHub · elastic/elasticsearch](https://github.com/elastic/elasticsearch) | [https://github.com/elastic/elasticsearch](https://github.com/elastic/elasticsearch) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/docker-elk-deploy


