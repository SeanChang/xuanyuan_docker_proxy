<!-- xuanyuan-docker-images-zh
image: tailscale/tailscale
source: https://xuanyuan.cloud/zh/r/tailscale/tailscale
canonical: https://xuanyuan.cloud/zh/r/tailscale/tailscale
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/tailscale/tailscale" title="tailscale/tailscale Docker 镜像中文简介、标签列表与拉取命令">tailscale/tailscale — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/tailscale/tailscale" title="tailscale/tailscale Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/tailscale/tailscale</a></p>

### Tailscale Docker 镜像使用说明


#### 拉取镜像
```bash
docker pull :stable
```


### 快速参考
- **维护方**：[Tailscale]([])  
- **获取帮助**：[Tailscale 支持]([])  
- **提交问题**：  
- **支持架构**：arm、arm64、amd64、386  


### 支持的标签
容器标签基于 Tailscale 的[版本方案]([])：  
- `stable`、`latest`：获取最新稳定版  
  - 特定稳定版：`v1.20.1`、`v1.20` 等  
- `unstable`：获取最新开发版  
  - 特定开发版：`unstable-v1.33.159`、`unstable-v1.33` 等  


### 什么是 Tailscale？
[Tailscale]([]) 可让你的设备和用户在专属安全虚拟网络中相互连接。它基于开源的 []() 协议，实现加密的点对点连接。  

[了解更多关于 Tailscale 的信息]([])，以及[如何在容器中使用 Tailscale]([])。  


### 如何使用此镜像
该镜像包含所有 Tailscale 二进制文件。


#### 构建 Dockerfile
```bash
docker build -t  .
```


#### 运行 tailscaled 代理
```bash
docker run -d --name=tailscaled -v /var/lib:/var/lib -v /dev/net/tun:/dev/net/tun --network=host --cap-add=NET_ADMIN --cap-add=NET_RAW 
```

**建议**：在容器中使用 Tailscale 时，为[临时节点]([])搭配[认证密钥]([])，可通过设置 `TS_AUTHKEY` 环境变量实现：  
```bash
docker run -d --name=tailscaled -v /var/lib:/var/lib -v /dev/net/tun:/dev/net/tun --network=host --cap-add=NET_ADMIN --cap-add=NET_RAW --env TS_AUTHKEY=tskey-auth-ab1CDE2CNTRL-0123456789abcdef 
```


#### 查看状态
```bash
docker exec tailscaled tailscale --socket /tmp/tailscaled.sock status
```


### 参数说明
以下环境变量可用于配置容器：  

| 参数                    | 说明                                                                 |
|-------------------------|----------------------------------------------------------------------|
| `TS_ACCEPT_DNS`         | 接受来自管理控制台的 DNS 配置，默认不接受。                           |
| `TS_AUTH_ONCE`          | 仅在未登录时尝试登录，默认关闭（容器启动时强制登录）。                 |
| `TS_AUTHKEY`            | [Tailscale 认证密钥]([])，用于容器认证。 |
| `TS_DEST_IP`            | 将所有入站 Tailscale 流量代理到指定目标 IP。                          |
| `TS_KUBE_SECRET`        | Kubernetes 环境中存储 Tailscale 状态的密钥名称，默认 `tailscale`。    |
| `TS_HOSTNAME`           | 节点使用的主机名。                                                   |
| `TS_OUTBOUND_HTTP_PROXY_LISTEN` | [HTTP 代理]([]) 的地址和端口。 |
| `TS_ROUTES`             | 声明[子网路由]([])，等同于 `tailscale set --advertise-routes=`。接受路由需通过 `TS_EXTRA_ARGS` 传入 `--accept-routes`。 |
| `TS_SOCKET`             | `tailscaled` 本地 API 套接字路径，默认 `/var/run/[已屏蔽]d.sock`。 |
| `TS_SOCKS5_SERVER`      | [SOCKS5 代理]([]) 的地址和端口。 |
| `TS_STATE_DIR`          | `tailscaled` 状态存储目录，需持久化以保留容器重启后的配置。           |
| `TS_USERSPACE`          | 启用[用户空间网络]([])（默认开启），替代内核网络。 |

**额外参数**：  
- `TS_EXTRA_ARGS`：`tailscale set` 的其他命令行参数  
- `TS_TAILSCALED_EXTRA_ARGS`：`tailscaled` 的其他参数  

详细说明可参考 [Tailscale 官方镜像文档]([])。  


### 常见问题


#### 为什么容器重启后 IP 地址会变化？
容器通常用于动态场景，默认情况下 `tailscaled` 状态存储在 `/tmp`，节点为[临时节点]([])，因此重启后 IP 会变化。  

若需容器保留配置和身份（长期服务），需：  
1. 提供持久化存储，例如 `-v /var/lib/tailscale:/var/lib/tailscale`  
2. 设置 `TS_STATE_DIR` 为持久化存储路径，例如 `-e TS_STATE_DIR=/var/lib/tailscale`  


#### 为什么入站连接正常但出站连接失败？
`tailscaled` 需要访问 `/dev/net/tun` 设备以支持任意进程使用 Linux 套接字，而多数容器默认不提供该设备。默认情况下，Dockerfile 运行在[用户空间网络]([])模式，此时  隧道的入站连接会转发到 `localhost` 相同端口，但出站连接需通过 SOCKS5 或 HTTP 代理。  

若需任意套接字应用支持出站连接：  
1. 挂载 TUN 设备：`-v /dev/net/tun:/dev/net/tun`  
2. 关闭用户空间网络：`-e TS_USERSPACE=0`  


### 许可证
详见 [许可证信息]()。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/tailscale/tailscale" title="tailscale/tailscale Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/tailscale/tailscale</a></p>
