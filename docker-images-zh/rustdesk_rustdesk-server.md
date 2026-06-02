---
image: rustdesk/rustdesk-server
description: "RustDesk服务器软件是搭建私有远程桌面服务的核心组件，包括hbbs（打洞服务器，负责节点发现与连接初始建立）和hbbr（中继服务器，承担数据中转任务）两个关键程序，支持用户自主部署以构建安全、稳定的远程控制环境，其核心功能通过这两个程序协同实现，满足用户对私有远程桌面服务的搭建需求。"
source: https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server
canonical: https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server" title="rustdesk/rustdesk-server Docker 镜像中文简介、标签列表与拉取命令">rustdesk/rustdesk-server — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server" title="rustdesk/rustdesk-server Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/rustdesk/rustdesk-server</a>

## RustDesk 服务器软件介绍  


### 整体说明  
RustDesk 服务器软件是远程控制场景中的服务端组件，主要用来支持客户端设备间的连接与通信，核心包含两个程序：`hbbs`（中转协调服务器）和 `hbbr`（中继服务器）。两者分工协作，共同实现设备发现、连接引导与数据传输功能。  


### hbbs（中转协调服务器）  
`hbbs` 全称中转协调服务器，主要负责处理客户端的连接请求与设备发现。当两台设备需要建立远程控制连接时，`hbbs` 会先接收双方的注册信息，协助完成身份验证，并尝试引导它们建立直接连接（P2P 连接）。如果设备处于复杂网络环境（如 NAT 穿透困难），`hbbs` 会将连接请求转发给 `hbbr`，确保通信流程不中断。  


### hbbr（中继服务器）  
`hbbr` 即中继服务器，作用是在客户端无法直接连接时提供数据转发支持。当两台设备因网络限制（如防火墙、多层 NAT）无法通过 P2P 方式直连时，`hbbr` 会作为中间节点，接收一方设备的控制指令或屏幕数据，再转发给另一方，相当于“桥梁”角色，保证远程控制操作的实时性和稳定性。  


### 使用建议  
实际部署时，需同时运行 `hbbs` 和 `hbbr` 两个程序，两者配合完成连接流程：`hbbs` 负责前期协调与引导，`hbbr` 负责应对复杂网络下的中继需求。部署前建议根据使用规模（如并发连接数）配置服务器带宽和硬件资源，确保中继数据传输时的稳定性（尤其企业场景下多设备同时远程控制时）。
