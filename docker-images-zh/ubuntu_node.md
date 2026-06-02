<!-- xuanyuan-docker-images-zh
image: ubuntu/node
source: https://xuanyuan.cloud/zh/r/ubuntu/node
canonical: https://xuanyuan.cloud/zh/r/ubuntu/node
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/ubuntu/node" title="ubuntu/node Docker 镜像中文简介、标签列表与拉取命令">ubuntu/node — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/ubuntu/node" title="ubuntu/node Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/node</a></p>

# Chiselled Ubuntu for Nodejs

Canonical 提供的当前 Node.js Docker 镜像，基于 Ubuntu 构建。接收安全更新，并会滚动更新至更新的 Node.js 或 Ubuntu 版本。**此仓库可免费使用，且不受每用户速率限制影响。**


## 关于 Node.js

Node.js 是一个免费、开源、跨平台的 JavaScript 运行时环境，允许开发人员创建服务器、Web 应用程序、命令行工具和脚本。此镜像是精简的 Node.js 版本，仅包含所需的 Node.js 运行时。


## 标签和架构
![LTS](https://assets.ubuntu.com/v1/0a5ff561-LTS%402x.png?h=17)
LTS 通道提供长达 5 年的免费安全维护。

![ESM](https://assets.ubuntu.com/v1/572f3fbd-ESM%402x.png?h=17)
通过 Canonical 的受限仓库提供长达 10 年的客户安全维护[从 Canonical 的受限仓库](https://ubuntu.com/security/docker-images#get-in-touch)。


| 通道标签               | 支持至       | 当前版本                          | 架构       |
|------------------------|--------------|-----------------------------------|------------|
| **`18-24.04_edge`**    | 2025年09月   | Ubuntu 24.04 LTS 上的 Nodejs 18   | `amd64`    |
| `18.19.1-24.04_edge`   | -            | Ubuntu 24.04 LTS 上的 Nodejs 18.19.1 | `amd64`    |
| _`track_risk`_         |              |                                   |            |


通道标签按稳定性排序显示该轨道的最稳定通道：`stable`、`candidate`、`beta`、`edge`。风险更高的通道始终隐式可用。例如，若列出 `beta`，则也可拉取 `edge`；若列出 `candidate`，则可拉取 `beta` 和 `edge`；若列出 `stable`，则四个通道均可用。镜像会按 `edge` → `beta` → `candidate` → `stable` 的顺序更新。

### 商业用途和扩展安全维护通道
如果您的使用场景包括商业再分发，或需要 ESM 或未列出的通道/版本，请[联系 Canonical 团队](https://ubuntu.com/security/docker-images#get-in-touch)（或发送邮件至 rocks@canonical.com）。


## 使用方法

### 本地启动镜像
```sh
docker run -d --name node-container -e TZ=UTC ubuntu/node:18-24.04_edge
```


### 测试/调试

查看容器日志：
```sh
docker logs -f node-container
```

进入交互式 Node.js 解释器：
```bash
docker exec -it nodejs-container node
```


## 问题反馈和功能请求
如果您在镜像中发现 bug 或想要请求特定功能，请在此提交 bug：

[https://bugs.launchpad.net/ubuntu-docker-images/+filebug](https://bugs.launchpad.net/ubuntu-docker-images/+filebug)

请将 bug 标题设为“`node: <问题摘要>`”。确保包含您使用的镜像摘要，可通过以下命令获取：
```sh
docker images --no-trunc --quiet ubuntu/node:<tag>
```


## 已弃用的通道和标签
以下通道（标签）不再更新。请升级到较新的通道，如无法升级，请[联系我们](https://ubuntu.com/security/docker-images#get-in-touch)。

| 轨道   | 版本   | 停止维护日期 | 升级路径   |
|--------|--------|--------------|------------|
| _`track`_ |        |              |            |

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/ubuntu/node" title="ubuntu/node Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/ubuntu/node</a></p>
