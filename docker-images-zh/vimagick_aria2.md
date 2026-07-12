---
image: vimagick/aria2
description: "aria2是一个文件下载工具，结合yaaw Web前端，提供高效的文件下载功能和便捷的Web管理界面，支持RPC控制及安全配置。"
source: https://xuanyuan.cloud/zh/r/vimagick/aria2
canonical: https://xuanyuan.cloud/zh/r/vimagick/aria2
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/vimagick/aria2" title="vimagick/aria2 Docker 镜像中文简介、标签列表与拉取命令">vimagick/aria2 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# aria2 Docker镜像文档

## 镜像概述和主要用途

`aria2` 是一款高效的文件下载工具，支持HTTP、HTTPS、FTP、BitTorrent等多种协议。`yaaw` 是其Web前端界面，提供直观的可视化管理功能。本镜像组合了aria2后端服务与yaaw前端界面，方便用户通过Web浏览器管理下载任务，适用于个人或服务器环境的文件下载管理。

## 核心功能和特性

- **多协议支持**：支持HTTP/HTTPS、FTP、SFTP、BitTorrent等多种下载协议
- **RPC控制**：通过JSON-RPC接口实现远程控制，支持安全认证
- **Web管理界面**：集成yaaw前端，提供直观的下载任务管理界面
- **灵活配置**：支持自定义下载目录、速度限制、种子策略等
- **安全传输**：支持SSL/TLS加密，保障RPC通信安全

## 目录结构

```
~/fig/aria2/
├── docker-compose.yml   # Docker Compose配置文件
├── html/                # yaaw前端文件目录
│   ├── README.md
│   ├── TODO.md
│   ├── css/...          # 样式文件
│   ├── img/...          # 图片资源
│   ├── index.html       # 前端入口页面
│   ├── js/...           # JavaScript文件
│   └── offline.appcache
├── data -> /home/aria2/ # 下载文件存储目录（符号链接）
└── keys/                # SSL证书目录
    ├── server.crt       # 服务器证书
    └── server.key       # 私钥文件
```

> 可将`data`目录创建为指向`/home/aria2`或其他位置的符号链接。如需实现磁盘配额，可创建[虚拟磁盘][1]。

## 使用方法和配置说明

### Docker Compose配置

创建`docker-compose.yml`文件，内容如下：

```yaml
version: "3.8"

services:

  aria2:
    image: docker.xuanyuan.run/vimagick/aria2
    ports:
      - "6800:6800"  # RPC端口
    volumes:
      - ./data:/home/aria2  # 挂载下载目录
      - ./keys:/etc/aria2/keys  # 挂载证书目录
    environment:
      - TOKEN=e6c3778f-6361-4ed0-b126-f2cf8fca06db  # RPC认证令牌
    restart: unless-stopped

  yaaw:
    image: docker.xuanyuan.run/nginx:alpine
    ports:
      - "8080:80"  # Web界面端口
    volumes:
      - ./html:/usr/share/nginx/html  # 挂载yaaw前端文件
    restart: unless-stopped
```

### aria2配置文件说明

`aria2.conf`主要配置项说明：

```ini
dir=/home/aria2                  # 下载文件保存目录
disable-ipv6=true                # 禁用IPv6
enable-rpc=true                  # 启用RPC功能
max-download-limit=0             # 最大下载速度限制（0为无限制）
max-upload-limit=0               # 最大上传速度限制（0为无限制）
rpc-allow-origin-all=true        # 允许所有来源的RPC请求
rpc-certificate=/etc/aria2/keys/server.crt  # SSL证书路径
rpc-listen-all=true              # 监听所有网络接口
rpc-listen-port=6800             # RPC监听端口
rpc-private-key=/etc/aria2/keys/server.key  # 私钥路径
rpc-secret=00000000-0000-0000-0000-000000000000  # RPC认证密钥（与环境变量TOKEN对应）
rpc-secure=true                  # 启用RPC安全连接（HTTPS）
seed-ratio=0                     # 种子分享率（0为无限制）
seed-time=0                      # 种子分享时间（0为无限制）
```

### 服务器端部署步骤

1. 创建目录结构：
   ```bash
   $ mkdir -p ~/fig/aria2/{html,keys}/
   $ cd ~/fig/aria2/
   ```

2. 创建下载目录符号链接：
   ```bash
   $ ln -s /home/aria2 data
   ```

3. 下载yaaw前端文件：
   ```bash
   $ curl -sSL https://github.com/binux/yaaw/archive/master.tar.gz | tar xz --strip 1 -C html
   ```

4. 生成SSL证书：
   ```bash
   $ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout keys/server.key -out keys/server.crt
   ```
   > 生成证书时请正确设置`CommonName`（通常为服务器域名或IP）

5. 编辑`docker-compose.yml`配置文件，设置合适的`TOKEN`值

6. 启动服务：
   ```bash
   $ docker-compose up -d
   ```

### 客户端使用方法

#### 证书配置（可选）

将服务器证书添加到客户端信任列表：
```bash
$ scp server:fig/aria2/keys/server.crt /usr/local/share/ca-certificates/
$ update-ca-certificates --fresh
```

#### 通过API调用控制aria2

生成UUID作为请求ID：
```bash
$ uuidgen
3c5323b8-79f7-49d4-8303-fcfe51488db5
```

使用httpie调用API（获取全局状态）：
```bash
$ http --verify no https://server:6800/jsonrpc \
       id=3c5323b8-79f7-49d4-8303-fcfe51488db5 \
       method=aria2.getGlobalStat \
       params:='["token:e6c3778f-6361-4ed0-b126-f2cf8fca06db"]'
```

使用curl调用API：
```bash
$ curl https://server:6800/jsonrpc --data '
       {
         "id": "3c5323b8-79f7-49d4-8303-fcfe51488db5",
         "method": "aria2.getGlobalStat",
         "params": ["token:e6c3778f-6361-4ed0-b126-f2cf8fca06db"]
       }' | jq .
```

返回示例：
```json
{
  "id": "3c5323b8-79f7-49d4-8303-fcfe51488db5",
  "jsonrpc": "2.0",
  "result": {
    "downloadSpeed": "0",
    "numActive": "0",
    "numStopped": "0",
    "numStoppedTotal": "0",
    "numWaiting": "0",
    "uploadSpeed": "0"
  }
}
```

#### 通过Web界面管理

1. 在浏览器中访问：`http://server:8080/`

2. 配置JSON-RPC路径：
   - 进入设置（Settings）
   - JSON-RPC Path设置为：`wss://token:e6c3778f-6361-4ed0-b126-f2cf8fca06db@server:6800/jsonrpc`

3. 浏览器右上角将显示aria2状态信息（如版本、下载/上传速度）

> 首次访问`https://server:6800`时，需在浏览器中接受安全证书。使用httpie时可能需要添加`--verify no`选项绕过证书验证。

[1]: http://souptonuts.sourceforge.net/quota_tutorial.html
