# Docker Compose 部署 ELK 完整教程：搭建企业级日志中心

![Docker Compose 部署 ELK 完整教程：搭建企业级日志中心](https://img.xuanyuan.dev/docker/blog/elk.webp)

*分类: Docker部署教程 | 标签: ELK,Elasticsearch,Logstash,Kibana,Docker,Compose,轩辕镜像,日志分析,私有化部署,部署教程 | 发布时间: 2026-07-17 09:53:10*

> Ubuntu 24.04 实测：轩辕镜像 Elastic 专属域名拉取 Elasticsearch / Logstash / Kibana 7.17.2，/data/elk Compose 一键启动，含 17 张截图与 FAQ。

*本文基于 Elastic 官方栈镜像，**Ubuntu 24.04** 实测（IP `192.168.1.10`）：主方案 **`7.17.2` 已跑通**；**`9.4.3` 因宿主机 CPU 不支持 x86-64-v2 未能启动**，文中仍给出 Compose 写法供有新 CPU 的环境参考。*

应用日志散落各机、云日志按量又贵？**ELK**（Elasticsearch + Logstash + Kibana）是经典的开源日志检索与可视化栈——采集、索引、浏览器里搜图一气呵成，数据落在自己的服务器上。

本文用 [轩辕镜像](https://xuanyuan.cloud) **Elastic 专属域名**加速拉取，在 **`/data/elk`** 用 Docker Compose 联合部署三组件。国内拉取 `docker.elastic.co` 不能指望 `daemon.json` 的 `registry-mirrors`（只对 Docker Hub 生效），须在 `image` / `docker pull` 里**显式**写专属域，见 [Elastic 拉取教程](https://xuanyuan.cloud/usage/mirror-tutorial/elastic)。

镜像页（可核对标签与简介）：

- [elasticsearch](https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch?tag=7.17.2)
- [logstash](https://xuanyuan.cloud/docker.elastic.co/logstash/logstash?tag=7.17.2)
- [kibana](https://xuanyuan.cloud/docker.elastic.co/kibana/kibana?tag=7.17.2)

![Kibana 欢迎页 Welcome to Elastic](https://img.xuanyuan.dev/docker/blog/elk-1.webp)

*图 1：Kibana 就绪后的 Welcome 页（可选 Explore on my own）*

---

## 一、ELK 是什么？三个镜像怎么联合？

**ELK** 是 Elastic Stack 的俗称，由三个官方组件组成：

| 组件 | 作用 | 默认端口 | 轩辕镜像页 |
|------|------|----------|------------|
| **E**lasticsearch | 存储与全文检索、聚合 | 9200 / 9300 | [elasticsearch](https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch?tag=7.17.2&tab=pull) |
| **L**ogstash | 采集、过滤、写入 ES | 5044（Beats）等 | [logstash](https://xuanyuan.cloud/docker.elastic.co/logstash/logstash?tag=7.17.2) |
| **K**ibana | Web 查询与仪表盘 | 5601 | [kibana](https://xuanyuan.cloud/docker.elastic.co/kibana/kibana?tag=7.17.2) |

数据流：

```text
Filebeat / Syslog / 应用日志
        │
        ▼
   Logstash 容器  ──写入──▶  Elasticsearch 容器(:9200)
                                      ▲
   浏览器 ──HTTP:5601──▶ Kibana 容器 ─┘（查询）
```

- Compose 同一网络内，用**服务名** `elasticsearch` 互访，不要写 `127.0.0.1`。
- **三个镜像版本号必须一致**（本文实测 `7.17.2`）。
- 可选扩展：同版本 Filebeat（`.../beats/filebeat:7.17.2`）做采集端。

> **版本选型（务必先看）**  
> - **旧 CPU / 虚拟机阉割指令集**（无 SSE4.2，或报 `CPU does not support x86-64-v2`）→ 用本文 **§三～§八 的 7.17.2**。  
> - **新 CPU（支持 x86-64-v2）** → 可参考 **§九 的 9.4.3** Compose；**本文服务器未能实测跑通 9.4.3**。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux x86_64（本文 Ubuntu 24.04） |
| Docker | Engine 24+，Compose V2（`docker compose`） |
| 内存 | ES 堆默认 1g，整机建议 ≥ 4 GB 可用 |
| 内核 | `vm.max_map_count >= 262144` |
| 端口 | **9200**（ES）、**5601**（Kibana）、可选 5044 / 1514 |
| 工作目录 | `/data/elk`（与雷池 `/data/safeline` 并列） |
| 拉取域 | 轩辕 Elastic 专属域，例如 `***-elastic.xuanyuan.run`（以你控制台为准） |

```bash
docker --version
docker compose version
sudo sysctl -w vm.max_map_count=262144
# 永久：echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

未装 Docker 可用轩辕一键脚本：

```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)

# 备用地址1
bash <(wget -qO- https://get.xuanyuan.dev/docker.sh)

# 备用地址2
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 三、实测方案 A：部署 ELK 7.17.2（已跑通）

### 3.1 创建目录

与雷池同机时，可从任意目录建 ELK 目录：

```bash
mkdir -p /data/elk/logstash/pipeline
cd /data/elk
```

实测提示符：`root@ubuntu2404:/data/elk#`

### 3.2 编写 docker-compose.yml

```bash
vim docker-compose.yml
```

内容（三镜像均为 **7.17.2**，实验环境关闭 security）：

```yaml
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
      test: ["CMD-SHELL", "curl -s http://localhost:9200/_cluster/health | grep -qE '\"status\":\"(green|yellow)\"'"]
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
```

> 将 `***-elastic.xuanyuan.run` 换成你在轩辕控制台的 Elastic 专属域。

### 3.3 编写 .env

```bash
vim .env
```

```env
TZ=Asia/Shanghai
```

### 3.4 编写 Logstash pipeline

```bash
vim logstash/pipeline/main.conf
```

```ruby
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
```

### 3.5 确认文件与镜像标签

```bash
ls -la
ls -la logstash/pipeline/
grep image docker-compose.yml
```

实测目录：

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

### 3.6 拉取镜像

```bash
docker compose pull
```

大镜像偶发 `TLS handshake timeout` 或 layer digest 校验失败时，**再执行一次** `docker compose pull` 即可。实测最终成功：

```text
[+] Pulling 33/34
 ✔ logstash Pulled                                                          198.4s
 ✔ elasticsearch Pulled                                                     112.9s
 ✔ kibana Pulled                                                            127.3s
```

也可单独拉：

```bash
docker pull ***-elastic.xuanyuan.run/elasticsearch/elasticsearch:7.17.2
docker pull ***-elastic.xuanyuan.run/logstash/logstash:7.17.2
docker pull ***-elastic.xuanyuan.run/kibana/kibana:7.17.2
```

### 3.7 启动

确保已设置 `vm.max_map_count` 后：

```bash
sudo sysctl -w vm.max_map_count=262144
docker compose up -d
```

实测输出：

```text
[+] Running 3/3
 ✔ Container elasticsearch  Healthy                                          44.4s
 ✔ Container kibana         Started                                          44.3s
 ✔ Container logstash       Started                                          44.5s
```

---

## 四、验证 Elasticsearch

浏览器或本机访问：

```text
http://192.168.1.10:9200/
```

应看到类似：

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

```bash
curl http://127.0.0.1:9200/_cluster/health?pretty
```

---

## 五、打开 Kibana（5601）

访问：

```text
http://192.168.1.10:5601/
```

首次可能短暂出现 **Kibana server is not ready yet**（冷启动加载插件），等 **2～5 分钟** 再刷新。

就绪后进入 **Welcome to Elastic**（见图 1）。建议点 **Explore on my own**（自己探索）；实验环境不必先走 Add integrations。右下角若提示缺少 `server.publicBaseUrl`，可 Mute，或在 compose 里给 Kibana 加上文注释中的 `SERVER_PUBLICBASEURL`。

进入主页后可见 Enterprise Search / Observability / Security / Analytics 等入口：

![Kibana Welcome home 主页四入口](https://img.xuanyuan.dev/docker/blog/elk-2.webp)

*图 2：Welcome home — Enterprise Search / Observability / Security / Analytics*

![Enterprise Search 产品选择](https://img.xuanyuan.dev/docker/blog/elk-3.webp)

*图 3：Enterprise Search 欢迎页*

![Elastic Security Overview](https://img.xuanyuan.dev/docker/blog/elk-4.webp)

*图 4：Security Overview*

![Analytics 欢迎页](https://img.xuanyuan.dev/docker/blog/elk-5.webp)

*图 5：Analytics 欢迎页*

![Observability 欢迎页](https://img.xuanyuan.dev/docker/blog/elk-6.webp)

*图 6：Observability 欢迎页*

至此 **三容器已联合运行**，浏览器可搜、可逛解决方案页。下面用官方样例数据快速验证可视化能力。

---

## 六、导入样例数据并逛仪表盘

路径：**Integrations → Sample data**（或主页 **Try sample data**），可添加 eCommerce / Flights / Web logs。

![Sample data：eCommerce / Flights / Web logs](https://img.xuanyuan.dev/docker/blog/elk-7.webp)

*图 7：More ways to add data — Sample data*

### 6.1 eCommerce 样例

![eCommerce Revenue Dashboard](https://img.xuanyuan.dev/docker/blog/elk-18.webp)

*图 8：[eCommerce] Revenue Dashboard*

![eCommerce Canvas Revenue Tracking](https://img.xuanyuan.dev/docker/blog/elk-9.webp)

*图 9：Canvas — [eCommerce] Revenue Tracking*

![eCommerce Orders by Country 地图](https://img.xuanyuan.dev/docker/blog/elk-10.webp)

*图 10：Maps — [eCommerce] Orders by Country*

### 6.2 Flights 样例

![Flights Global Flight Dashboard](https://img.xuanyuan.dev/docker/blog/elk-11.webp)

*图 11：[Flights] Global Flight Dashboard*

![Flights Canvas Overview](https://img.xuanyuan.dev/docker/blog/elk-12.webp)

*图 12：Canvas — [Flights] Overview*

![Flights Origin Time Delayed 地图](https://img.xuanyuan.dev/docker/blog/elk-13.webp)

*图 13：Maps — [Flights] Origin Time Delayed*

### 6.3 Web logs 样例

![Logs Web Traffic 仪表盘](https://img.xuanyuan.dev/docker/blog/elk-20.webp)

*图 14：[Logs] Web Traffic Dashboard*

![Logs Canvas Web Traffic](https://img.xuanyuan.dev/docker/blog/elk-15.webp)

*图 15：Canvas — [Logs] Web Traffic*

![Logs Total Requests and Bytes 地图](https://img.xuanyuan.dev/docker/blog/elk-16.webp)

*图 16：Maps — [Logs] Total Requests and Bytes*

![Observability Logs Stream](https://img.xuanyuan.dev/docker/blog/elk-17.webp)

*图 17：Observability → Logs → Stream（样例 web logs 流）*

真实业务日志：用 Filebeat 打到 Logstash `:5044`，或按 `main.conf` 扩展 input；索引名默认 `logs-YYYY.MM.dd`，在 **Stack Management → Index Patterns** 中创建匹配模式即可在 Discover 查询。

---

## 七、日常运维

```bash
cd /data/elk
docker compose ps
docker compose logs -f --tail=100
docker compose restart kibana
docker compose down          # 停栈，保留命名卷
# docker compose down -v   # 危险：会删 es-data
```

升级小版本：改三个 `image` 标签为同一新版本 → `docker compose pull && docker compose up -d`。  
**跨大版本**（如 7→9）不要复用旧数据卷，先备份再 `docker volume rm elk_es-data` 重建。

---

## 八、方案 B：ELK 9.4.3（Compose 参考 · 本文未实测跑通）

适用：**CPU 支持 x86-64-v2（含 SSE4.2）** 的机器。镜像页：

- [elasticsearch:9.4.3](https://xuanyuan.cloud/docker.elastic.co/elasticsearch/elasticsearch?tag=9.4.3&tab=pull)
- [logstash:9.4.3](https://xuanyuan.cloud/docker.elastic.co/logstash/logstash?tag=9.4.3)
- [kibana:9.4.3](https://xuanyuan.cloud/docker.elastic.co/kibana/kibana?tag=9.4.3)

### 8.1 本文服务器上的失败实录（供对照）

1. **首次 pull** 曾遇 Kibana `TLS handshake timeout`，重试后三镜像均 Pulled（约 10 分钟级）。  
2. **`docker compose up -d`** 报：`dependency failed to start: container elasticsearch is unhealthy`。  
3. 日志根因：

```text
Fatal glibc error: CPU does not support x86-64-v2
```

即 **镜像用户态要求 x86-64-v2，当前宿主机/虚拟机 CPU 标志不满足**。改 healthcheck、改密码均无效。随后清理容器与 9.4.3 镜像，改用 **7.17.2** 才跑通。

自检：

```bash
lscpu | grep -E 'Model name|Flags'
grep -o 'sse4_2' /proc/cpuinfo | head -1
```

- 无 `sse4_2` → 请用 **7.17.2**，或换机 / 虚拟机改 CPU 为 `host` 透传后再试 9.x。  
- 有 `sse4_2` 仍失败 → 检查是否虚拟机用了 `kvm64` 等阉割型号。

### 8.2 9.4.3 Compose 示例（未在本文机器验证）

开启基础 security，健康检查须带密码：

```yaml
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
      test: ["CMD-SHELL", "curl -s -u elastic:$${ELASTIC_PASSWORD} http://localhost:9200/_cluster/health | grep -qE '\"status\":\"(green|yellow)\"'"]
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
```

`.env`：

```env
ELASTIC_PASSWORD=你的强密码
```

`main.conf` 输出需带账号：

```ruby
output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
    user => "elastic"
    password => "${ELASTIC_PASSWORD}"
    index => "logs-%{+YYYY.MM.dd}"
  }
}
```

从 9.x 失败环境改回 7.x 时，务必清数据卷，避免大版本混用：

```bash
cd /data/elk
docker compose down
docker volume rm elk_es-data
# 再改 compose 为 7.17.2 后 pull && up -d
```

---

## 九、FAQ

**Q：`registry-mirrors` 配了轩辕，拉 Elastic 还是很慢？**  
A：`registry-mirrors` 只对 `docker.io` 生效。Elastic 必须写 `***-elastic.xuanyuan.run/...`，见 [Elastic 专属域教程](https://xuanyuan.cloud/usage/mirror-tutorial/elastic)。

**Q：`Fatal glibc error: CPU does not support x86-64-v2`？**  
A：9.x 基线要求更高。换支持 SSE4.2 的机器 / VM `host` 透传，或改用 **7.17.2**（本文实测路径）。

**Q：Kibana 一直 not ready yet？**  
A：先等几分钟；`docker logs kibana`；确认 `ELASTICSEARCH_HOSTS=http://elasticsearch:9200`；确认 ES 已 healthy。

**Q：生产能关 `xpack.security` 吗？**  
A：本文 7.17.2 为内网实验关闭。生产请开启认证与 TLS，并限制 9200/5601 暴露范围。

**Q：只需 ES + Kibana，不要 Logstash？**  
A：可以，从 compose 删掉 `logstash` 服务即可（有时称 EK）；采集改由 Filebeat 直写 ES。

---

## 十、小结

| 项 | 内容 |
|----|------|
| 实测版本 | **7.17.2**（ES / Logstash / Kibana） |
| 工作目录 | `/data/elk` |
| 访问 | ES `http://IP:9200`，Kibana `http://IP:5601` |
| 加速 | 轩辕 `***-elastic.xuanyuan.run` |
| 9.4.3 | Compose 已给出；**本文 CPU 限制未跑通** |
| 截图 | 17 张（欢迎页 → 样例 eCommerce / Flights / Logs） |

日志私有化并不神秘：三镜像同一版本、同一 Compose 网络、专属域拉取，旧 CPU 选 7.17、新 CPU 再评估 9.x——浏览器打开 Kibana，就能开始搜和画图。

