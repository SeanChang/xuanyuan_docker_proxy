# 【镜像公告】mlikiowa/napcat-docker 已从 Docker Hub 下架：拉取会失败

![【镜像公告】mlikiowa/napcat-docker 已从 Docker Hub 下架：拉取会失败](https://imgs.xuanyuan.cloud/docker/blog/napcat1.webp)

*分类: Docker部署教程 | 标签: NapCat,Docker Hub,镜像下架,轩辕镜像,mlikiowa,NapCatQQ | 发布时间: 2026-11-16 22:51:20*

> Docker Hub 上 mlikiowa 名下的 napcat-docker、napcat-framework-docker、napcat-appimage、napcat-node 仓库已经不存在。GitHub 上 NapNeko/NapCatQQ 仓库壳仍在，但正文已被清空。短名或 docker.xuanyuan.run/mlikiowa/… 拉取都会失败。

**发布日期：** 2026 年 11 月 16 日  
**涉及镜像：** `mlikiowa/napcat-docker`、`mlikiowa/napcat-framework-docker`、`mlikiowa/napcat-appimage`、`mlikiowa/napcat-node`（Docker Hub 仓库已不存在）  
**统计截止：** 2026 年 11 月 16 日（UTC+8）

---

## 一、你会看到什么

`docker pull mlikiowa/napcat-docker`，或 Compose 里仍写着 `image: mlikiowa/napcat-docker`，拉取会失败。常见返回是：

```text
Error response from daemon: pull access denied for mlikiowa/napcat-docker, repository does not exist or may require 'docker login'
```

这句里的 `docker login` 是 Docker 在「仓库不存在」和「仓库是私有的」之间无法区分时的固定提示。登录 Docker Hub 不能把已经删除的仓库找回来。

截至 2026 年 11 月 16 日，Docker Hub 对下列仓库的接口返回 HTTP 404（`object not found`）：

- `mlikiowa/napcat-docker`
- `mlikiowa/napcat-framework-docker`
- `mlikiowa/napcat-appimage`
- `mlikiowa/napcat-node`

同一天复核：用户 [mlikiowa](https://hub.docker.com/u/mlikiowa) 仍存在，但仓库列表 `count=0`。

在 `daemon.json` 里配置了轩辕镜像加速，短名仍会失败。加速拉取访问的是 Docker Hub 上的同一个仓库，仓库已经不在，`docker.xuanyuan.run/mlikiowa/napcat-docker` 得到的是同一种失败。

本站对应说明页（保留历史简介，不再提供拉取命令）：

- [mlikiowa/napcat-docker](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker)
- [mlikiowa/napcat-framework-docker](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-framework-docker)

---

## 二、上游现状（复核记录）

公开渠道里没有找到「为何从 Docker Hub 删除这些仓库」的专门通告。下列事实以 2026 年 11 月 16 日实测为准，不臆造删库动机。

| 时间 | 发生了什么 | 依据 |
|------|------------|------|
| 2026 年 11 月 16 日 | Hub API 对上述四个 `mlikiowa/napcat*` 仓库返回 404 | `/v2/repositories/mlikiowa/…` |
| 2026 年 11 月 16 日 | Hub 用户 `mlikiowa` 仍在，仓库列表为空 | `/v2/repositories/mlikiowa/` 返回 `count: 0` |
| 2026 年 11 月 16 日 | GitHub `NapNeko/NapCatQQ` 仓库未归档，但内容已被清空（`size=1`，`language=null`） | [GitHub API](https://api.github.com/repos/NapNeko/NapCatQQ) |

此前站内教程跟做的标签是 `mlikiowa/napcat-docker:v4.18.28`。该坐标所在仓库现已不存在，不能再用于新部署。

---

## 三、本地缓存不等于上游仍在

本机以前拉过的标签可以留在本地镜像层里。正在运行的容器不会因为上游删库立刻退出。

新机器、清空本地镜像、或 `docker compose pull` / `docker pull` 重新拉取时，短名和 `docker.xuanyuan.run/mlikiowa/…` 都会失败。换方案之前，先备份挂载目录里的 `config/` 与 `QQ/`（以及需要保留的 `plugins/`）。

---

## 四、现在可以怎么处理

### 1. 到站内搜索仍在 Docker Hub 上的社区仓库

到轩辕镜像按 Docker Hub 来源搜索 napcat，自己看维护者、最近更新和说明：

[搜索 napcat](https://xuanyuan.cloud/search?q=napcat&source=docker.io)

选定某一个仍在维护的仓库之后，把 pull 和 Compose 改成**你的专属域名**下的完整地址。`***` 换成个人中心显示的前缀，形如 `abc.xuanyuan.run`。专属域名拉取 Docker Hub 上仍然存在的仓库时，不需要 `docker login`。

```bash
docker pull ***.xuanyuan.run/<namespace>/<image>:<tag>
```

```yaml
services:
  napcat:
    image: ***.xuanyuan.run/<namespace>/<image>:<tag>
```

下面这些写法仍然指向已经删除的仓库，改完还会失败：

- 短名 `mlikiowa/napcat-docker` 及同作者其它 `napcat-*`
- `docker.xuanyuan.run/mlikiowa/napcat-docker` 及同前缀其它坐标

轩辕镜像不把搜索结果里的某一个社区镜像指定为官方替代。选哪一个、用哪个标签，由你根据该仓库的更新记录决定。

专属域名的复制位置见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

### 2. 按上游当前说明自行构建或换部署方式

GitHub 上 [NapNeko/NapCatQQ](https://github.com/NapNeko/NapCatQQ) 仓库壳仍在，但正文已被清空。是否还有可用的发布物、文档或其它分发渠道，以该组织/仓库**当前页面**为准。不要假定旧 Docker Hub 标签会恢复。

---

## 五、参考链接

- Docker Hub 用户（仓库已空）：[mlikiowa](https://hub.docker.com/u/mlikiowa)
- GitHub（内容已清空，未归档）：[NapNeko/NapCatQQ](https://github.com/NapNeko/NapCatQQ)
- 本站下架页：[mlikiowa/napcat-docker](https://xuanyuan.cloud/zh/r/mlikiowa/napcat-docker)
- 旧教程（已过期，仅作历史记录）：[NapCat 部署 QQ 机器人](https://xuanyuan.cloud/blog/napcat-docker-deploy)、[NapCat 接入 AstrBot](https://xuanyuan.cloud/blog/docker-napcat-qq-bot-deploy)
- 社区镜像搜索：[xuanyuan.cloud 搜索 napcat](https://xuanyuan.cloud/search?q=napcat&source=docker.io)

---

**轩辕镜像**  
2026 年 11 月 16 日


