# Docker 部署 Milvus：轻松搭建高性能向量数据库平台

![Docker 部署 Milvus：轻松搭建高性能向量数据库平台](https://imgs.xuanyuan.cloud/docker/blog/milvus.webp)

*分类: Docker部署教程 | 标签: Milvus,openeuler/milvus,Docker,轩辕镜像,向量数据库,RAG,私有化部署,部署教程 | 发布时间: 2026-09-11 09:36:09*

> Milvus 是一款面向大规模非结构化数据的高性能向量数据库，擅长相似度检索与 AI 检索增强。本文将介绍如何通过 Docker Compose 快速部署 openEuler 构建的 openeuler/milvus，轻松搭建可自托管的向量检索节点，适合 RAG、图像检索、推荐召回与多模态检索等场景。

*本文基于 [openeuler/milvus:2.6.0-oe2403sp2](https://xuanyuan.cloud/zh/r/openeuler/milvus)，跟做标签 **2.6.0-oe2403sp2**（Milvus **2.6.0** / openEuler **24.03-LTS-SP2**），客户端实测 **pymilvus 3.0.1**，测试平台 **Ubuntu 24.04** Linux。*

做 RAG、以图搜图或推荐召回时，手里往往先有一批 Embedding：PDF 切段、商品图特征、会话摘要向量。下一步就卡在「向量写哪、怎么近邻检索」。塞进 MySQL 的 JSON 列硬扫，慢且难建索引；整库托管到公有云向量服务，又要过出域评审——密钥、语料、客户文档常常不允许离机房。

内网、等保、交付到客户现场的项目，更现实的诉求是：本机起一个 Standalone，**gRPC 对上 SDK，健康检查过了就能写集合、查 Top-K**。不必一上来就上 Kubernetes 多副本，也不必为了试用再单独啃一遍 etcd、对象存储安装手册。

**Milvus**（[官网](https://milvus.io/)、[GitHub · milvus-io/milvus](https://github.com/milvus-io/milvus)）是开源高性能向量数据库，面向文本、图像等多模态非结构化数据的组织与相似度搜索。本文用 openEuler 社区镜像 **`openeuler/milvus`**（[镜像页](https://xuanyuan.cloud/zh/r/openeuler/milvus)、[Gitee · cloudnative](https://gitee.com/openeuler/cloudnative)）：在 **openEuler 24.03-LTS-SP2** 上把 **Milvus + etcd + MinIO** 打进同一容器，适合学习与单机联调。同站官方线 **`milvusdb/milvus`** 的选型见第一节。

**部署跑通之后，你实际能做这些事：**

| 场景 | 部署后怎么用 |
|------|----------------|
| 健康检查 | `curl` 宿主机 **9091** 的 `/healthz`，返回 **OK** |
| WebUI | 打开 `http://服务器IP:9091/webui/`，看集群、集合、段与任务 |
| SDK 联调 | pymilvus 等连 **19530**，建集合、插向量、搜 Top-K |
| RAG 原型 | 把文档 Embedding 写入本机卷，检索结果交给自己的 LLM 流水线 |
| 备份搬家 | 停容器后打包 `./data` |

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取 **`openeuler/milvus:2.6.0-oe2403sp2`**，**Docker Compose** 启动（etcd → MinIO → `milvus run standalone`），映射 **19530 / 9091**。实测局域网 IP **`192.168.1.35`**，请换成你的。无 Compose 见第九节。文内附 **6** 张 WebUI 截图。

> **上手要点**
> - **部署**：第五节 Compose；备选 `docker run` 见第九节  
> - **端口**：宿主机 **19530**（gRPC）、**9091**（healthz / WebUI）；勿占宿主机 **3000**  
> - **标签**：跟做 **`2.6.0-oe2403sp2`**；勿写 `latest`  
> - **数据**：`./data` → `/data/milvus/data`  
> - **资源**：镜像 DISK **4.71GB**；内存建议 ≥ **4 GB**  
> - **目录**：Linux `/www/wwwroot/milvus`；macOS `~/docker/milvus`  
> - **用法**：第七节 venv + pymilvus；插入后务必 `flush` 再搜  

官方与社区：[Milvus Docs](https://milvus.io/docs) · [镜像页](https://xuanyuan.cloud/zh/r/openeuler/milvus) · [标签列表](https://xuanyuan.cloud/r/openeuler/milvus/tags) · [Docker Hub](https://hub.docker.com/r/openeuler/milvus) · [Gitee · openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)

---

## 一、openeuler/milvus 是什么？

`openeuler/milvus` 是 **一体 Standalone**：容器内自带 `etcd`、`minio`、`milvus`。**9091** 提供 `/healthz` 与 WebUI（`/webui/`）；业务写入与检索走 **19530**（gRPC）+ SDK。

| | openeuler/milvus（本文） | milvusdb/milvus | Qdrant / Weaviate 等 |
|--|--------------------------|----------------|----------------------|
| 定位 | openEuler 一体包 | 上游官方镜像 / Compose | 其他向量库 |
| 依赖 | etcd + MinIO **同容器** | 多为多容器 | 各产品不同 |
| 适合 | 单机试用、对齐 openEuler | 生产跟官方多服务文档 | 不同 API 偏好 |

```text
SDK / 应用     ──gRPC:19530──▶  milvus run standalone
健康 / WebUI   ──HTTP:9091──▶  /healthz · /webui/
etcd / MinIO   ──容器内后台──▶  同容器进程
./data         ──挂载──▶  /data/milvus/data
```

[`/r/`](https://xuanyuan.cloud/r/openeuler/milvus) 与 [`/zh/r/`](https://xuanyuan.cloud/zh/r/openeuler/milvus) 为同一镜像的不同页面语言。**本文只用 `openeuler/milvus:2.6.0-oe2403sp2`**。

要横向扩展、独立扩容对象存储，或严格跟上游 Cluster 文档，请改用 [milvusdb/milvus](https://xuanyuan.cloud/zh/r/milvusdb/milvus)。一体镜像的代价是启停顺序与资源都挤在一个容器里——联调够用，不是高可用方案。

---

## 二、环境要求

| 项目 | 建议 |
|------|------|
| 系统 | Linux（建议 Ubuntu 24.04）；amd64 / arm64 |
| Docker | Engine + **Compose V2** |
| 内存 | ≥ **4 GB** 可用（向量规模上去再加） |
| 磁盘 | 镜像约 **4.7 GB**（DISK）+ 数据增长空间 |
| 端口 | 宿主机 **19530**、**9091** 空闲 |

```bash
docker --version
docker compose version
```

Linux 未装 Docker 可使用轩辕镜像一键安装脚本：

```bash
bash <(wget -qO- https://get.xuanyuan.cloud/docker.sh)
```

备用地址：

```bash
bash <(wget -qO- https://get.xuanyuan.me/docker.sh)
```

更多见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。端口被占用时，Compose 可改为 `"19531:19530"`、`"19091:9091"`，客户端与健康检查跟着改宿主机端口。

---

## 三、标签怎么选

| 标签 | 含义 | 推荐 |
|------|------|------|
| **`2.6.0-oe2403sp2`** | Milvus 2.6.0 + openEuler 24.03-LTS-SP2 | **跟做（本文）** |
| **`2.5.14-oe2403sp2`** | Milvus 2.5.14 + 同上基础 | 需对齐 2.5.x 时用 |
| `latest` | 当前与 2.6.0 同线 | **勿写入跟做命令** |

命名：`{Milvus 版本}-oe{openEuler 缩写}`。完整列表见 [标签页](https://xuanyuan.cloud/r/openeuler/milvus/tags)。

---

## 四、拉取镜像

用 [轩辕镜像](https://xuanyuan.cloud) 加速拉取：

```bash
docker pull docker.xuanyuan.run/openeuler/milvus:2.6.0-oe2403sp2
```

Ubuntu 24.04 实测：

```text
2.6.0-oe2403sp2: Pulling from openeuler/milvus
ed90f2ff4836: Pull complete
a51fe3cdb425: Pull complete
0e960775f9a1: Pull complete
7e67a747e12a: Pull complete
730ddf564964: Pull complete
009204109834: Pull complete
15e5f9640146: Pull complete
93d14b741252: Pull complete
1a6782dcfcf6: Pull complete
38e5a5aafe40: Pull complete
Digest: sha256:e761daa832ccfd04e87336c96bacc2d70028489b47def91612b4bb6f2a27c0ba
Status: Downloaded newer image for docker.xuanyuan.run/openeuler/milvus:2.6.0-oe2403sp2
docker.xuanyuan.run/openeuler/milvus:2.6.0-oe2403sp2
```

```bash
docker images docker.xuanyuan.run/openeuler/milvus:2.6.0-oe2403sp2
```

```text
IMAGE                                                  ID             DISK USAGE   CONTENT SIZE   EXTRA
docker.xuanyuan.run/openeuler/milvus:2.6.0-oe2403sp2   e761daa832cc       4.71GB         1.13GB
```

---

## 五、Docker Compose 部署（推荐）

工作目录：`/www/wwwroot/milvus`（macOS 用 `~/docker/milvus`）。

### 5.1 创建目录

```bash
sudo mkdir -p /www/wwwroot/milvus/data
sudo chown -R "$USER:$USER" /www/wwwroot/milvus
cd /www/wwwroot/milvus
```

### 5.2 编写 docker-compose.yml

该镜像默认进 shell，**不会**自动拉起 Milvus。用启动脚本：etcd → MinIO → 前台 `milvus run standalone`。

```bash
cat > docker-compose.yml <<'EOF'
services:
  milvus:
    image: docker.xuanyuan.run/openeuler/milvus:2.6.0-oe2403sp2
    container_name: milvus
    restart: unless-stopped
    ports:
      - "19530:19530"
      - "9091:9091"
    volumes:
      - ./data:/data/milvus/data
    environment:
      - TZ=Asia/Shanghai
    shm_size: "2gb"
    command:
      - bash
      - -c
      - |
        set -e
        mkdir -p /data/milvus/data/etcd-data /data/milvus/data/minio-data
        etcd --data-dir=/data/milvus/data/etcd-data/ &
        sleep 2
        minio server /data/milvus/data/minio-data/ &
        sleep 3
        exec milvus run standalone
EOF
```

| 项 | 说明 |
|----|------|
| 端口 | **19530** gRPC；**9091** healthz / WebUI |
| 卷 | `./data` → `/data/milvus/data` |
| `shm_size` | 加大共享内存，降低压力 |
| `exec` | 让 Milvus 作 PID 1，便于收停止信号 |

> MinIO 默认 `minioadmin` / `minioadmin`。内网试用可先用；公网务必改密并收紧端口。

### 5.3 启动

```bash
cd /www/wwwroot/milvus
docker compose up -d
docker compose ps
```

Ubuntu 24.04 实测：

```text
[+] up 2/2
 ✔ Network milvus_default Created
 ✔ Container milvus       Started
```

```text
NAME      IMAGE                                                  COMMAND                   SERVICE   CREATED         STATUS         PORTS
milvus    docker.xuanyuan.run/openeuler/milvus:2.6.0-oe2403sp2   "bash -c 'set -e\nmkd…"   milvus    5 minutes ago   Up 5 minutes   0.0.0.0:9091->9091/tcp, [::]:9091->9091/tcp, 0.0.0.0:19530->19530/tcp, [::]:19530->19530/tcp
```

`STATUS` 为 **Up** 且已映射两端口即可。首次就绪可能要等十几秒到一两分钟。

### 5.4 日志（辅助）

```bash
docker compose logs --tail=50 milvus
```

运行中出现 `apply balance success` 一类 INFO 正常。社区镜像页示例里有 `Welcome to use Milvus!` 横幅，Compose 启动脚本实测时日志里**未必出现**——以第六节 `/healthz` 与 WebUI 为准。

---

## 六、验证启动

### 6.1 健康检查

```bash
curl -s http://127.0.0.1:9091/healthz
echo
```

实测返回：

```text
OK
```

远程访问时换成服务器 IP，并放行 **9091**。

### 6.2 WebUI

浏览器打开 `http://192.168.1.35:9091/webui/`（换成你的 IP）。首页应显示 **Your Cluster is running well!**，**Deploy Mode = STANDALONE**，**Build Version = 2.6.0**，各组件与 etcd / mq 为 **Healthy**。

![Milvus WebUI 首页：Standalone 2.6.0 集群运行正常，各组件与 etcd/mq 均为 Healthy](https://imgs.xuanyuan.cloud/docker/blog/milvus-1.webp)

### 6.3 端口监听

```bash
ss -lntp | grep -E '19530|9091' || netstat -lntp | grep -E '19530|9091'
```

实测两端口均由 `docker-proxy` 监听。建集合、插向量见第七节；写完后再回 WebUI 对照（§7.3）。

---

## 七、怎么使用：建集合 / 插向量 / 检索

Milvus **不负责生成 Embedding**。常见链路：文本/图片 → 你的模型算向量 → 写入 **19530** → 查询时再 embedding → `search` Top-K →（可选）交给 LLM 做 RAG。

演示用维度 **8**；真实项目改成与模型一致（常见 768 / 1024 / 1536）。

### 7.1 安装 pymilvus（venv）

Ubuntu 24.04 受 **PEP 668** 限制，不能直接 `pip install`（会报 `externally-managed-environment`）：

```bash
cd /www/wwwroot/milvus
sudo apt-get update
sudo apt-get install -y python3-venv python3-full
python3 -m venv .venv
source .venv/bin/activate
pip install -U pip
pip install -U pymilvus
```

若出现 **`THESE PACKAGES DO NOT MATCH THE HASHES`**（慢网中断 / 缓存损坏）：

```bash
pip cache purge
pip install -U pip pymilvus --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple
```

确认版本（实测 **3.0.1**）：

```bash
python -c "import pymilvus; print(pymilvus.__version__)"
```

### 7.2 一键演示脚本

保存为 `/www/wwwroot/milvus/demo_pymilvus.py`：

```python
#!/usr/bin/env python3
"""建集合 → 插入 → flush → 搜索。维度请与真实 Embedding 对齐。"""
from __future__ import annotations

import random
from pymilvus import MilvusClient

URI = "http://127.0.0.1:19530"  # 远程改成 http://192.168.1.35:19530
COLLECTION = "demo_docs"
DIM = 8


def fake_vec(dim: int) -> list[float]:
    return [random.random() for _ in range(dim)]


def main() -> None:
    client = MilvusClient(uri=URI)
    print("before:", client.list_collections())

    if client.has_collection(COLLECTION):
        client.drop_collection(COLLECTION)

    client.create_collection(
        collection_name=COLLECTION,
        dimension=DIM,
        metric_type="COSINE",
    )

    vec1 = fake_vec(DIM)
    rows = [
        {"id": 1, "vector": vec1, "text": "轩辕镜像加速拉取 Docker 镜像"},
        {"id": 2, "vector": fake_vec(DIM), "text": "Milvus 做向量相似度检索"},
        {"id": 3, "vector": fake_vec(DIM), "text": "RAG 把检索结果喂给大模型"},
    ]
    print("insert:", client.insert(collection_name=COLLECTION, data=rows))
    client.flush(COLLECTION)

    hits = client.search(
        collection_name=COLLECTION,
        data=[vec1],
        limit=3,
        output_fields=["text"],
    )
    print("search:", hits)
    print("after:", client.list_collections())


if __name__ == "__main__":
    main()
```

```bash
cd /www/wwwroot/milvus
source .venv/bin/activate
python3 demo_pymilvus.py
```

要点：

- 插入后 **`flush`**，否则易出现 `search: data: [[]]`
- 演示用刚写入的 `vec1` 查询，更容易看到命中；真实 RAG 传入问题对应的 Embedding
- 生产把 `vector` 换成真实向量，`DIM` 与模型对齐

Ubuntu 24.04 实测（pymilvus **3.0.1**）：

```text
before: ['demo_docs']
insert: {'insert_count': 3, 'ids': [1, 2, 3]}
search: data: [[{'id': 1, 'distance': 1.0000001192092896, 'entity': {'text': '轩辕镜像加速拉取 Docker 镜像'}}, {'id': 2, 'distance': 0.7550168037414551, 'entity': {'text': 'Milvus 做向量相似度检索'}}, {'id': 3, 'distance': 0.43331214785575867, 'entity': {'text': 'RAG 把检索结果喂给大模型'}}]]
after: ['demo_docs']
```

`id: 1` 的 `distance ≈ 1.0`：查询向量与自身最相近（COSINE）。可选 API：`client.get(...)` / `client.delete(...)`。

### 7.3 在 WebUI 里对照

脚本跑通后刷新 WebUI：

**Collections**：`default` 库下有 **`demo_docs`**，Loaded **100%**。

![Milvus WebUI Collections：default 库下 demo_docs 已加载 100%](https://imgs.xuanyuan.cloud/docker/blog/milvus-2.webp)

**Query**：Segments **Rows: 3**，Channel **Healthy**。

![Milvus WebUI Query：demo_docs 段 Rows 为 3，Channel 状态 Healthy](https://imgs.xuanyuan.cloud/docker/blog/milvus-3.webp)

**Data**：可见 **Flushed** 段；多次重建集合时也可能有 **Dropped** 旧段。

![Milvus WebUI Data：Segments 列表含 Flushed 与 Dropped 状态，行数为 3](https://imgs.xuanyuan.cloud/docker/blog/milvus-4.webp)

**Tasks**：QueryCoord / Compaction / Index Build 多为成功或已完成。

![Milvus WebUI Tasks：QueryCoord、Compaction、Index Build 任务成功或已完成](https://imgs.xuanyuan.cloud/docker/blog/milvus-5.webp)

WebUI 适合观察状态；批量写入与检索仍用 SDK。更多示例见 [Hello Milvus](https://milvus.io/docs/quickstart.md)。

---

## 八、生产与安全提示

| 项 | 建议 |
|----|------|
| 版本 | pull / Compose / 脚本统一具体标签；升级前备份 `./data` |
| 网络 | **19530 / 9091** 勿裸暴露公网 |
| 凭据 | 更换 MinIO 默认账号；按官方文档开启鉴权 |
| 资源 | 盯磁盘与内存；规模上去考虑官方多服务方案 |
| 备份 | 停写或停容器后打包 `./data` |

Configurations 实测：`TZ=Asia/Shanghai`，`common.security.authorizationenabled=false`（默认未开鉴权）——内网试用方便，**公网务必加固**。

![Milvus WebUI Configurations：TZ 为 Asia/Shanghai，authorizationenabled 为 false](https://imgs.xuanyuan.cloud/docker/blog/milvus-6.webp)

---

## 九、备选：docker run

与 Compose 同逻辑的后台启动：

```bash
mkdir -p /www/wwwroot/milvus/data
docker run -d \
  --name milvus \
  --restart unless-stopped \
  --shm-size=2g \
  -p 19530:19530 \
  -p 9091:9091 \
  -v /www/wwwroot/milvus/data:/data/milvus/data \
  -e TZ=Asia/Shanghai \
  docker.xuanyuan.run/openeuler/milvus:2.6.0-oe2403sp2 \
  bash -c 'mkdir -p /data/milvus/data/etcd-data /data/milvus/data/minio-data && etcd --data-dir=/data/milvus/data/etcd-data/ & sleep 2 && minio server /data/milvus/data/minio-data/ & sleep 3 && exec milvus run standalone'
```

```bash
docker logs -f --tail=80 milvus
```

对照社区文档逐步手启时，可用 `-it` 进容器后依次执行 `etcd &`、`minio server … &`、`milvus run standalone`。退出交互即停服务；日常跟做仍用第五节 Compose。

---

## 十、升级与迁移

1. `docker compose down`  
2. 备份 `/www/wwwroot/milvus/data`  
3. 修改 Compose 中的镜像标签  
4. `docker compose pull && docker compose up -d`  
5. 查 `/healthz` 与 WebUI；pymilvus 抽查集合  

跨大版本先看 [发行说明](https://github.com/milvus-io/milvus/releases)。迁到官方多容器时按上游导入导出，勿直接混挂数据目录。

---

## 十一、常见问题 FAQ

**Q：不写 command 直接 `docker run`？**  
A：默认进 shell。必须用 Compose / run 的启动脚本，或 `-it` 手启。

**Q：该用哪个标签？镜像页写 `latest`？**  
A：跟做用 **`2.6.0-oe2403sp2`**。介绍页常写 `latest`（当前与 2.6.0 同线），脚本里仍写具体版本，避免静默漂移。

**Q：healthz 失败或 19530 连不上？**  
A：看 `docker compose logs`、端口映射与防火墙；内存过小会杀进程。以 `/healthz` → **OK** 为准。

**Q：`pip` 报 `externally-managed-environment` 或 HASHES 不匹配？**  
A：用 venv；HASHES 问题执行 `pip cache purge` 后 `--no-cache-dir` + 国内 PyPI 镜像，见第七节。

**Q：`search` 返回 `data: [[]]`？**  
A：`insert` 后加 `client.flush(集合名)`。集合已在 `list_collections()` 中则说明写入成功。

**Q：维度报错？**  
A：`dimension` 必须等于每条 `vector` 长度，并与 Embedding 模型输出一致。

**Q：适合生产 Cluster 吗？**  
A：本文是 Standalone 一体容器。高可用请跟 [milvusdb/milvus](https://xuanyuan.cloud/zh/r/milvusdb/milvus) 与官方架构文档。

**Q：数据会丢吗？宿主机能否用 3000？**  
A：务必挂卷 `./data`。本服务默认不用 3000；若另挂 UI 且容器内听 3000，宿主机改映如 **13300:3000**。

---

## 十二、命令速查

```bash
# 拉取
docker pull docker.xuanyuan.run/openeuler/milvus:2.6.0-oe2403sp2

# Compose
cd /www/wwwroot/milvus
docker compose up -d
docker compose ps
docker compose logs -f --tail=50 milvus
docker compose down

# 健康检查
curl -s http://127.0.0.1:9091/healthz; echo
# WebUI：http://服务器IP:9091/webui/

# pymilvus（venv）
python3 -m venv .venv
.venv/bin/pip install -U pip pymilvus --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple
.venv/bin/python demo_pymilvus.py
```

---

## 十三、延伸阅读

| 资源 | 链接 |
|------|------|
| [openeuler/milvus 镜像页](https://xuanyuan.cloud/zh/r/openeuler/milvus) | [https://xuanyuan.cloud/zh/r/openeuler/milvus](https://xuanyuan.cloud/zh/r/openeuler/milvus) |
| [openeuler/milvus 概览](https://xuanyuan.cloud/r/openeuler/milvus) | [https://xuanyuan.cloud/r/openeuler/milvus](https://xuanyuan.cloud/r/openeuler/milvus) |
| [openeuler/milvus 标签列表](https://xuanyuan.cloud/r/openeuler/milvus/tags) | [https://xuanyuan.cloud/r/openeuler/milvus/tags](https://xuanyuan.cloud/r/openeuler/milvus/tags) |
| [Docker Hub · openeuler/milvus](https://hub.docker.com/r/openeuler/milvus) | [https://hub.docker.com/r/openeuler/milvus](https://hub.docker.com/r/openeuler/milvus) |
| [Gitee · openeuler/cloudnative](https://gitee.com/openeuler/cloudnative) | [https://gitee.com/openeuler/cloudnative](https://gitee.com/openeuler/cloudnative) |
| [Gitee · openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images) | [https://gitee.com/openeuler/openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images) |
| [Milvus 官方文档](https://milvus.io/docs) | [https://milvus.io/docs](https://milvus.io/docs) |
| [Milvus Quickstart](https://milvus.io/docs/quickstart.md) | [https://milvus.io/docs/quickstart.md](https://milvus.io/docs/quickstart.md) |
| [GitHub · milvus-io/milvus](https://github.com/milvus-io/milvus) | [https://github.com/milvus-io/milvus](https://github.com/milvus-io/milvus) |
| [milvusdb/milvus 镜像页](https://xuanyuan.cloud/zh/r/milvusdb/milvus) | [https://xuanyuan.cloud/zh/r/milvusdb/milvus](https://xuanyuan.cloud/zh/r/milvusdb/milvus) |
| [轩辕镜像使用手册](https://xuanyuan.cloud/usage) | [https://xuanyuan.cloud/usage](https://xuanyuan.cloud/usage) |

---

## 总结

- 镜像：`openeuler/milvus:2.6.0-oe2403sp2`（一体 Standalone，勿写 `latest`）  
- 部署：轩辕镜像加速拉取 + Compose + 卷 `./data`；端口 **19530 / 9091**  
- 验证：`/healthz` → OK；WebUI 看 Standalone 与依赖  
- 用法：venv + pymilvus → 建集合 → 插入 → **flush** → search；WebUI 对照集合与段  
- 生产：收紧网络；默认未开鉴权；大规模改走官方多服务  

## 阅读原文

- 轩辕镜像官方博客：https://xuanyuan.cloud/blog/milvus-docker-deploy


