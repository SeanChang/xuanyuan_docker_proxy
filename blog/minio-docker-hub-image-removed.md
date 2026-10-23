# 【镜像公告】minio/minio 已从 Docker Hub 下架：拉取会失败

![【镜像公告】minio/minio 已从 Docker Hub 下架：拉取会失败](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker部署教程 | 标签: MinIO,Docker Hub,镜像下架,轩辕镜像,AIStor,Quay | 发布时间: 2026-10-22 17:03:49*

> Docker Hub 上的 minio/minio 与 minio/mc 仓库已经不存在。MinIO 在 2025 年 10 月把社区版改为只发源码，2026 年 4 月 25 日归档 GitHub 仓库；2026 年 9 月中旬下游项目记录到 Hub 整库消失。把短名改成仍指向这两个仓库的专属域名，拉取一样会失败。

**发布日期：** 2026 年 10 月 22 日  
**涉及镜像：** `minio/minio`、`minio/mc`（Docker Hub 仓库已不存在，本文不附仓库页）  
**统计截止：** 2026 年 10 月 22 日（UTC+8）

---

## 一、你会看到什么

`docker pull minio/minio`，或 Compose 里仍写着 `image: minio/minio`、`image: minio/mc`，拉取会失败。下游项目记录到的典型返回是：

```text
Error response from daemon: pull access denied for minio/minio, repository does not exist or may require 'docker login'
```

这句文案里的 `docker login` 是 Docker 在「仓库不存在」和「仓库是私有的」之间无法区分时的固定提示。登录 Docker Hub 不能把已经删除的 `minio/minio`、`minio/mc` 找回来。

截至 2026 年 10 月 22 日，Docker Hub 对这两个仓库的接口返回 HTTP 404，内容为 `object not found`。`quay.io/minio/minio` 的匿名接口返回 HTTP 401，内容为 `Requires authentication`。

在 `daemon.json` 里配置了轩辕镜像加速，短名仍会失败。加速拉取访问的是 Docker Hub 上的同一个仓库，仓库已经不在，加速地址得到的是同一种失败。

---

## 二、上游自己写过的决定

上游写在仓库里的决定，是社区版改为只发源码、进入维护状态，然后归档。下载站对归档项目也有一段明文。专门宣布「从 Docker Hub 删除 `minio/minio`」的通告，公开渠道里没有找到；Hub 上整库消失的日期，来自下游项目的记录。

| 时间 | 发生了什么 | 依据 |
|------|------------|------|
| 2025 年 10 月 15 日 | README 改为社区版只以源码分发，不再提供社区版预编译二进制 | [commit 9e49d5e](https://github.com/minio/minio/commit/9e49d5e7a648f00e26f2246f4dc28e6b07f8c84a) |
| 2025 年 10 月 16 日 | 发布安全版 `RELEASE.2025-10-15T17-29-55Z`（CVE-2025-62506）。发布说明要求容器用户克隆源码自行构建 | [该 tag 的发布说明](https://github.com/minio/minio/releases/tag/RELEASE.2025-10-15T17-29-55Z) |
| 2025 年 10 月 18 日 | 维护者在 issue 中写明：项目已是 source-only，要容器就自己构建 | [#21647](https://github.com/minio/minio/issues/21647) |
| 2025 年 10 月 24 日 | 维护者拒绝把上述安全版推到 Docker Hub 和 Quay，并给出自行 `docker build` 的说明 | [#21661](https://github.com/minio/minio/issues/21661) |
| 2025 年 12 月 3 日 | README 进入 maintenance mode：不接受新功能，安全修复按个案评估 | [commit 27742d46](https://github.com/minio/minio/commit/27742d469462e1561c776f88ca7a1f26816d69e2) |
| 2026 年 2 月 12 日 | README 顶部改为 `THIS REPOSITORY IS NO LONGER MAINTAINED`，替代方向写成 AIStor Free 与 AIStor Enterprise | [commit 7aac2a2c](https://github.com/minio/minio/commit/7aac2a2c5b7c882e68c1ce017d8256be2feea27f) |
| 2026 年 4 月 25 日 | GitHub 上 [minio/minio](https://github.com/minio/minio) 由所有者归档，仓库只读 | 仓库页面横幅 |
| 2026 年 7 月 14 日 | GitHub 上 [minio/mc](https://github.com/minio/mc) 由所有者归档，仓库只读 | 仓库页面横幅 |
| 2026 年 9 月 12 日前后 | 下游项目开始报告 `minio/minio` 与 `minio/mc` 无法再从 Docker Hub 拉取 | [StableBuild 复盘](https://www.stablebuild.com/blog/minio-images-disappeared-from-docker-hub)、[Milvus #53430](https://github.com/milvus-io/milvus/issues/53430)、[dandi-cli 0.79.0 变更记录](https://github.com/dandi/dandi-cli/blob/master/CHANGELOG.md)（2026 年 9 月 14 日） |
| 2026 年 9 月 17 日 | 已有项目记录 `dl.min.io` 上的社区版二进制返回 HTTP 410 | [TiDB #71290](https://github.com/pingcap/tidb/issues/71290) |
| 2026 年 9 月 25 日 | 已有项目记录 `quay.io/minio/minio` 匿名访问返回 401 | [dartway #331](https://github.com/dartway/dartway/issues/331) |

StableBuild 的复盘同样写明，没有找到 MinIO 专门解释 Docker Hub 删库的公告。删库发生在社区版停发预构建镜像之后，日期以下游实测为准。

下载站现在的说明比仓库页更直接。截至 2026 年 10 月 22 日，请求社区版服务端二进制得到 HTTP 410，正文包括：

> The open-source MinIO Server, MinIO Client (mc) and MinIO KES projects are archived and no longer maintained. MinIO does not provide product support, security updates, or security advisories for them, and does not accept or process vulnerability reports concerning them.

社区版服务端、客户端 `mc`、KES 都在这段话的范围内。这些文件不再从该站点提供，包括历史社区版本和对应的热修复构建。

---

## 三、Quay 上的历史镜像不能当官方替代

维护者在 [#21647](https://github.com/minio/minio/issues/21647)（2025 年 10 月 18 日、23 日）和 [#21661](https://github.com/minio/minio/issues/21661)（2025 年 10 月 24 日）写明：社区版已是 source-only，安全版容器由使用者自己构建，这个决定是最终决定。按这两则 issue 的记录，`RELEASE.2025-10-15T17-29-55Z` 没有作为 `minio/minio` 的预构建标签推到 Docker Hub 或 Quay。

删库前留在官方仓库里的预构建标签，不含 CVE-2025-62506 的修复。仓库归档之后，这些标签也不会再更新。该漏洞是服务账号和 STS 会话策略绕过导致的权限提升，修复版本即上述 tag。GitHub Advisory [GHSA-jjjj-jwhf-8rgr](https://github.com/advisories/GHSA-jjjj-jwhf-8rgr) 评定为高危，CVSS 8.1。NVD 条目见 [CVE-2025-62506](https://nvd.nist.gov/vuln/detail/CVE-2025-62506)。

2026 年 9 月 25 日起，已有项目记录匿名拉取 `quay.io/minio/minio` 返回 401。截至 2026 年 10 月 22 日，该仓库的匿名 API 仍返回 `Requires authentication`。把 Compose 改成 Quay 专属域名（形如 `***-quay.xuanyuan.run/minio/minio`），加速拉取访问的仍是这个仓库：匿名访问过不去，标签也仍是冻结的历史构建。

本机以前拉过的官方标签可以留在本地缓存里。那是冻结的旧构建，不包含 2025 年 10 月 15 日这次安全修复，上游也不再为归档后的社区版提供安全更新和安全通告。

---

## 四、现在可以怎么处理

本地已经有镜像层时，正在运行的容器不会因为上游删库立刻退出。新机器、清空本地镜像、或 Compose 重新拉取时，短名会失败。换镜像之前先备份数据卷。社区构建的入口命令、用户 ID 和环境变量可能与原来的 `minio/minio` 不一致，以该镜像自己的说明为准。

### 1. 改用仍在 Docker Hub 上的社区构建

到轩辕镜像里按 Docker Hub 来源搜索 MinIO，自己看维护者、最近更新和许可证：

[搜索 minio（docker.io）](https://xuanyuan.cloud/search?q=minio&source=docker.io&page=1)

选定某一个仍在维护的仓库之后，把 pull 和 Compose 改成**你的专属域名**下的完整地址。`***` 换成个人中心显示的前缀，形如 `abc.xuanyuan.run`，不要用带 `-quay`、`-ghcr` 后缀的域名。专属域名拉取 Docker Hub 上仍然存在的仓库时，不需要 `docker login`。

```bash
docker pull ***.xuanyuan.run/<namespace>/<image>:<tag>
```

```yaml
services:
  minio:
    image: ***.xuanyuan.run/<namespace>/<image>:<tag>
```

下面这些写法仍然指向已经删除或需要认证的官方仓库，改完还会失败：

- 短名 `minio/minio`、`minio/mc`
- `docker.xuanyuan.run/minio/minio`、`docker.xuanyuan.run/minio/mc`
- `***-quay.xuanyuan.run/minio/minio`

轩辕镜像不把搜索结果里的某一个社区镜像指定为官方替代。选哪一个、用哪个标签，由你根据该仓库的更新记录决定。

专属域名的复制位置见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

### 2. 按上游 README 自行构建

归档后的 [minio/minio](https://github.com/minio/minio) 仍保留 Source-Only Distribution 说明：用 `go install` 从源码安装，或用仓库里的 Dockerfile 在本地构建镜像。安全版 tag 的发布说明同样要求容器用户克隆对应 tag 再构建。

仓库已于 2026 年 4 月 25 日只读归档。这样构建出来的是归档时的社区源码，没有后续的上游安全更新。社区版许可证仍是 GNU AGPLv3，构建或再分发前按你的使用方式核对许可证义务。

### 3. 需要厂商当前产品线时看 AIStor

README 在 2026 年 2 月 12 日把替代方向写成两条：AIStor Free（独立部署，社区使用，免费许可证）和 AIStor Enterprise（分布式，商业支持）。产品页：[MinIO AIStor](https://www.min.io/product/aistor)。

AIStor 使用独立的产品线和许可证。原来的 `minio/minio` 坐标不会因此重新可用。要不要迁移、数据怎么迁，以 MinIO 当前文档和你的许可证为准。

---

## 五、参考链接

- 源码仓库（已归档）：[minio/minio](https://github.com/minio/minio)、[minio/mc](https://github.com/minio/mc)
- 只发源码的 README 提交：[9e49d5e](https://github.com/minio/minio/commit/9e49d5e7a648f00e26f2246f4dc28e6b07f8c84a)（2025 年 10 月 15 日）、[27742d46](https://github.com/minio/minio/commit/27742d469462e1561c776f88ca7a1f26816d69e2)（2025 年 12 月 3 日）、[7aac2a2c](https://github.com/minio/minio/commit/7aac2a2c5b7c882e68c1ce017d8256be2feea27f)（2026 年 2 月 12 日）
- 维护者说明：[issue #21647](https://github.com/minio/minio/issues/21647)、[issue #21661](https://github.com/minio/minio/issues/21661)
- 安全版：[RELEASE.2025-10-15T17-29-55Z](https://github.com/minio/minio/releases/tag/RELEASE.2025-10-15T17-29-55Z)、[GHSA-jjjj-jwhf-8rgr](https://github.com/advisories/GHSA-jjjj-jwhf-8rgr)、[CVE-2025-62506](https://nvd.nist.gov/vuln/detail/CVE-2025-62506)
- 下游对删库和 Quay 401 的记录：[StableBuild](https://www.stablebuild.com/blog/minio-images-disappeared-from-docker-hub)、[Milvus #53430](https://github.com/milvus-io/milvus/issues/53430)、[dandi-cli 变更记录](https://github.com/dandi/dandi-cli/blob/master/CHANGELOG.md)、[dartway #331](https://github.com/dartway/dartway/issues/331)、[TiDB #71290](https://github.com/pingcap/tidb/issues/71290)
- 当前产品线：[AIStor](https://www.min.io/product/aistor)
- 社区镜像搜索：[xuanyuan.cloud 搜索 minio](https://xuanyuan.cloud/search?q=minio&source=docker.io&page=1)

---

**轩辕镜像**  
2026 年 10 月 22 日


