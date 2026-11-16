# 群晖拉不到第三方镜像？多半是 ghcr.io 这条链没通

![群晖拉不到第三方镜像？多半是 ghcr.io 这条链没通](https://imgs.xuanyuan.cloud/docker/blog/m4-cover-900x600.webp)

*分类: Docker部署教程 | 标签: 群晖,DS920+,NAS,Docker,ghcr.io,immich,镜像加速,Container Manager,极空间,威联通 | 发布时间: 2026-11-12 15:00:11*

> 群晖 DS920+ 实测：注册表搜得到、镜像下不动，immich 一直卡在 0%。讲清 Docker Hub 和 ghcr.io 两条链的差别，含图形界面配置步骤、前缀写法和排查顺序。

## 一个很常见的场景

手上这台是 DS920+，四盘位，DSM 7.2，平时存照片、跑几个自建服务。

上个月想装 immich（自建相册），在 Container Manager 的注册表里搜 `immich`，什么都没有。查了半天才知道它整套镜像全发在 `ghcr.io`，而群晖的注册表搜索只走 Docker Hub，天然搜不到。

退一步去试 Docker Hub 上的镜像，也不顺：搜得到，点「下载此映像」，进度条停在 0% 十分钟不动，最后报一句 `registry-1.docker.io` 相关的超时。

这两件事看着像一回事，其实不是。前者是**这条链根本没通**，后者是**通了，但没配加速**。大部分人在这一步会去反复换镜像源，换到第五个还是不行——因为换源只解决后者。

## 先分清：你的镜像来自哪个仓库

Docker 的镜像不是都存在一个地方。常见的至少有这些：

| 仓库 | 地址 | 典型内容 |
|---|---|---|
| Docker Hub | `docker.io` | nginx、redis、mysql 等官方镜像，以及大部分个人镜像 |
| GitHub Container Registry | `ghcr.io` | 开源项目的新版本、大量 NAS 第三方套件、AI 工具 |
| Kubernetes | `registry.k8s.io` | K8s 组件 |
| Google | `gcr.io` | Google 系镜像 |
| Quay | `quay.io` | Red Hat 系开源项目 |
| NVIDIA | `nvcr.io` | 深度学习与 GPU 镜像 |
| Microsoft | `mcr.microsoft.com` | .NET、Azure 系 |

**`daemon.json` 里的 `registry-mirrors` 只作用于 Docker Hub。** 这是整个问题的核心。

群晖也一样。你在 Container Manager 里加的镜像源，只改变了 `docker.io` 的走向。`ghcr.io` 的请求仍然是直连 GitHub 的服务器——而它在国内能不能通、有多快，完全看运气。

所以就会看到那种很迷惑的现象：`docker pull nginx` 飞快，`docker pull ghcr.io/xxx/yyy` 一动不动。

## 群晖配 Docker Hub 加速

先解决基础的那一半。

### 1. 拿到专属域名

[注册](https://xuanyuan.cloud/dashboard?register=true&code=BC9MPZ&xy_from=blog-m4)后，在控制台的「专属域名」页面点显示，会得到一个形如 `abcd1234.xuanyuan.run` 的地址。已经注册的直接[登录](https://xuanyuan.cloud/usage/login)就能看。

**用专属域名的好处是不用填账号密码**——地址本身就是凭证。群晖的注册表设置里，用户名和密码留空即可。

### 2. 在 Container Manager 里添加

1. 打开 DSM，进入 **Container Manager**（DSM 7.2 以前叫 Docker）
2. 左侧点 **注册表**
3. 右上角 **设置**
4. 点 **新增**
5. 填写：
   - **注册表名称**：随便填，比如 `xuanyuan`
   - **注册表 URL**：你的专属域名，`https://abcd1234.xuanyuan.run`
   - **用户名 / 密码**：**留空**
6. 点 **测试连接**
7. 显示成功后点 **保存**

测试连接成功就说明这条路通了。

### 3. 如果要用 SSH 改配置文件

图形界面有时会漏改某些东西，比如你想让 `docker compose` 命令行也走加速。DSM 7.2 以后的配置文件在：

```
/var/packages/ContainerManager/etc/dockerd.json
```

DSM 7.2 以前（套件还叫 Docker）在：

```
/var/packages/Docker/etc/dockerd.json
```

编辑时**只改 `registry-mirrors` 这一项，其他不要动**：

```json
{
    "registry-mirrors": [
        "https://abcd1234.xuanyuan.run"
    ],
    "data-root": "/var/packages/ContainerManager/var/docker",
    "log-driver": "db",
    "storage-driver": "btrfs"
}
```

改完重启服务：

```bash
/var/packages/ContainerManager/scripts/start-stop-status stop
/var/packages/ContainerManager/scripts/start-stop-status start
```

## 关键的一半：ghcr.io 的镜像怎么拉

这是绝大多数教程没讲的部分。

专属域名给**每个仓库单独开了一个前缀**，规则很统一——在原仓库名前面加一段：

| 原地址 | 换成 |
|---|---|
| `docker.io/library/nginx` | `abcd1234.xuanyuan.run/library/nginx` |
| `ghcr.io/org/image` | `abcd1234-ghcr.xuanyuan.run/org/image` |
| `gcr.io/google-containers/pause` | `abcd1234-gcr.xuanyuan.run/google-containers/pause` |
| `quay.io/coreos/etcd` | `abcd1234-quay.xuanyuan.run/coreos/etcd` |
| `registry.k8s.io/kube-apiserver` | `abcd1234-k8s.xuanyuan.run/kube-apiserver` |
| `nvcr.io/nvidia/pytorch` | `abcd1234-nvcr.xuanyuan.run/nvidia/pytorch` |
| `mcr.microsoft.com/dotnet/runtime` | `abcd1234-mcr.xuanyuan.run/dotnet/runtime` |
| `docker.elastic.co/elasticsearch/elasticsearch` | `abcd1234-elastic.xuanyuan.run/elasticsearch/elasticsearch` |
| `registry.gitlab.com/gitlab-org/gitlab-runner` | `abcd1234-gitlab.xuanyuan.run/gitlab-org/gitlab-runner` |

所以 immich 那几个镜像，把名字换一下就行：

```bash
# 原来（大概率卡住）
docker pull ghcr.io/immich-app/immich-server:release

# 换成
docker pull abcd1234-ghcr.xuanyuan.run/immich-app/immich-server:release
```

**注意不要保留 `ghcr.io/` 这个前缀**，直接写 `org/image`。这是最常见的写法错误。

拉下来之后，如果某些界面要求镜像名必须和官方一致，可以再打个标签去掉前缀：

```bash
docker tag abcd1234-ghcr.xuanyuan.run/immich-app/immich-server:release immich-app/immich-server:release
```

### 在 Container Manager 图形界面里操作

开头说过，群晖的注册表搜索只走 Docker Hub，`ghcr.io` 的镜像在图形界面里根本搜不出来。所以只能绕一下：

1. SSH 登录群晖，`sudo -i` 拿 root
2. 用上面的命令把镜像拉到本地
3. 回到 Container Manager 的 **映像** 页面，镜像已经在了
4. 直接在图形界面创建容器

这条路虽然要开一次终端，但比在界面里反复重试快得多。

## 验证配置是否真的生效

```bash
docker info | grep -A 4 "Registry Mirrors"
```

输出里有你的专属域名就对了。然后实测一次速度：

```bash
time docker pull abcd1234.xuanyuan.run/library/redis:7-alpine
```

正常是几秒钟。如果是几十 KB/s，检查一下是不是走了代理（见下面的排查）。

## 拉不动时的排查顺序

按这个顺序走，比乱换源快。

**第一步：关掉 NAS 上的代理**

群晖控制面板 → 网络 → 代理服务器，确认没有启用。轩辕镜像是国内节点，挂着代理反而绕远路，甚至直接连不上。

**第二步：换 DNS**

控制面板 → 网络 → 网络接口 → 编辑 → 手动配置 DNS，填 `223.5.5.5` 和 `114.114.114.114`。DNS 解析不了同样表现为"下载不动"。

**第三步：命令行测试，绕开图形界面**

开启 SSH（控制面板 → 终端机和 SNMP），登录后：

```bash
sudo -i
docker pull abcd1234.xuanyuan.run/library/mysql:8.0
```

命令行能拉下来，说明配置是对的，问题在 Container Manager 的界面缓存，重启一下套件即可。命令行也拉不动，再看报错内容——`401` 是凭证、`429` 是频率、`manifest unknown` 是名字错，处理方式完全不同。

**第四步：看报错里的域名**

报错里出现的是 `docker.xuanyuan.me` 还是你的专属域名，决定了你走的是哪条路。前者是免费版公共域名，只覆盖 Docker Hub，遇到 ghcr.io 的镜像必然失败。

## 其他 NAS 也差不多

机制是一样的，差别只在配置文件位置和菜单名：

- **极空间**：容器管理 → 镜像仓库设置
- **绿联**：Docker 应用 → 仓库设置
- **飞牛 fnOS**：应用中心装 Docker 后，在设置里加
- **威联通 QNAP**：Container Station → 偏好设置 → Registry
- **Unraid**：Settings → Docker → Registry mirrors

各个平台的详细步骤在[配置手册](https://xuanyuan.cloud/usage)里按设备分开写了，包括截图。

## 关于免费版和专业版

这一点在 NAS 场景下特别容易踩坑，单独说一下。

免费版的公共域名只加速 `docker.io`，**对 `ghcr.io`、`gcr.io`、`registry.k8s.io` 一律无效**。而 NAS 上的第三方套件、Docker 生态里的新项目，越来越多只发在 `ghcr.io`。

所以会出现这样的判断错误：明明配了加速，`nginx` 拉得飞快，但想装的套件怎么都下不来，于是以为"这个套件有问题"或者"我的 NAS 坏了"。

实际情况是那条链从来没通过。

专业版的专属域名覆盖上面表里列的 10 个仓库，每个都有独立前缀；每小时 1,000 次请求，免费版是 100 次。50GB 流量一年八块，[按年充一次就不用管了](https://xuanyuan.cloud/recharge?code=BC9MPZ&xy_from=blog-m4)。如果你只是偶尔拉个 `nginx`，免费版够用；但只要涉及 NAS 第三方套件、AI 工具、K8s，专属域名是必需品。

## 常见问题

**Q：注册表「测试连接」失败了怎么办？**

先确认地址有没有带 `https://`，再确认 NAS 的 DNS 和代理（前两步）。如果都正常还是失败，用 SSH 执行 `curl -I https://你的专属域名/v2/`，看返回码。返回 `401` 是正常的（说明服务通了，只是要认证），超时才是网络问题。

**Q：搜不到想装的镜像？**

站内搜索的索引不是 Docker Hub 全量。搜不到不代表拉不到，直接用完整的镜像名 pull 就行。

**Q：能不能用同一个域名拉私有镜像？**

不能。轩辕镜像只加速公开镜像，各仓库的私有镜像仍然需要原有的登录授权。

**Q：拉 AI 模型镜像报 413 或者提示单层过大？**

单层超过 20GB 的镜像不做缓存加速，这类镜像建议直接从官方源拉，或者用 `docker save` / `load` 做离线迁移。

---

NAS 上装东西的体验，一半取决于硬件，一半取决于这条路通不通。把 Docker Hub 和 ghcr.io 两条链都配通，后面装什么都不会再卡在第一步。

**接下来**

- 没注册过：[领专属域名](https://xuanyuan.cloud/dashboard?register=true&code=BC9MPZ&xy_from=blog-m4)，群里最常见的配置问题都是卡在这一步
- 已注册但不知道前缀怎么拼：[10 个仓库前缀对照](https://xuanyuan.cloud/usage/nologin)
- 配完还是拉不动：[按报错查](https://xuanyuan.cloud/faq)，20 个常见报错都有单独页面


