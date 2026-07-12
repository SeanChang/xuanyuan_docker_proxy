---
image: privoce/vocechat-server
description: "轻量级私有部署聊天服务器，20MB超小体积，基于Rust、TypeScript和Flutter构建，支持Docker快速部署，保障数据本地存储安全。"
source: https://xuanyuan.cloud/zh/r/privoce/vocechat-server
canonical: https://xuanyuan.cloud/zh/r/privoce/vocechat-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/privoce/vocechat-server" title="privoce/vocechat-server Docker 镜像中文简介、标签列表与拉取命令">privoce/vocechat-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

**镜像概述**
VoceChat Server 是一款轻量级私有聊天服务器镜像，体积仅20MB，基于 Rust、TypeScript 和 Flutter 技术栈构建，提供高效、安全的私有聊天解决方案，支持本地部署以保障数据隐私。

**核心特性**
- **极致轻量**：20MB 超小体积，资源占用低，部署便捷；
- **私有部署**：数据本地存储，确保聊天内容与用户信息不外流；
- **跨平台兼容**：配套移动应用（支持多平台），可通过官方链接下载；
- **高性能架构**：Rust 保障后端性能与安全性，TypeScript 和 Flutter 提供流畅的前后端交互体验。

**使用场景**
适用于个人、小团队或企业搭建私有聊天系统，例如：
- 团队内部即时通讯，替代第三方工具以保护商业数据；
- 个人私有聊天服务，避免数据存储于公有云平台；
- 对数据隐私有严格要求的组织或场景。

**Docker 快速部署**
通过以下命令启动容器：
```dockerfile
docker run -d --restart=always \
  -p <自定义端口>:3000 \
  --name vocechat-server \
  -v <本地数据路径>:/home/vocechat-server/data \
  docker.xuanyuan.run/privoce/vocechat-server:latest
```
**参数说明**：
- `-d`：后台运行容器；
- `--restart=always`：容器退出时自动重启；
- `-p <自定义端口>:3000`：映射容器3000端口至主机自定义端口（如3456）；
- `--name vocechat-server`：指定容器名称；
- `-v <本地数据路径>:/home/vocechat-server/data`：挂载本地目录持久化存储数据。

部署后，通过浏览器访问 `http://<域名或IP>:<自定义端口>` 即可使用。

**相关资源**
- 官方文档：[https://doc.voce.chat/](https://doc.voce.chat/)
- 移动应用下载：[https://voce.chat/#download](https://voce.chat/#download)
