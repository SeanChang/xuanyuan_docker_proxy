<!-- xuanyuan-docker-images-zh
image: openresty/openresty
source: https://xuanyuan.cloud/zh/r/openresty/openresty
canonical: https://xuanyuan.cloud/zh/r/openresty/openresty
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/openresty/openresty" title="openresty/openresty Docker 镜像中文简介、标签列表与拉取命令">openresty/openresty — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/openresty/openresty" title="openresty/openresty Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openresty/openresty</a></p>

# docker-openresty：OpenResty 的 Docker 工具


## 简介  
`docker-openresty` 是 OpenResty 的 Docker 化工具（[GitHub 仓库]([])）。Docker 是容器管理平台，而 OpenResty 是基于 Nginx 核心，集成大量第三方模块及依赖的全功能 Web 应用服务器。


## 镜像标签说明  
建议将镜像固定到明确的标签以确保稳定性。以下是常见标签示例及说明：  

### 带版本的镜像标签（推荐）  
| 镜像示例                          | 说明                     |
|-----------------------------------|--------------------------|
| `openresty/openresty:1.21.4.1-0-jammy` | 基于源码构建的 Ubuntu Jammy 版本 |
| `openresty/openresty:1.21.4.1-0-focal` | 基于源码构建的 Ubuntu Focal 版本 |
| `openresty/openresty:1.21.4.1-0-bullseye-fat` | 基于上游包构建的 Debian Bullseye 版本 |
| `openresty/openresty:1.21.4.1-0-alpine` | 基于源码构建的 Alpine 版本 |
| `openresty/openresty:1.21.4.1-0-alpine-apk` | 基于上游包构建的 Alpine 版本 |

### 不带版本的镜像标签（默认最新版）  
| 镜像示例                | 说明                |
|-------------------------|---------------------|
| `openresty/openresty:jammy` | Ubuntu Jammy 最新版 |
| `openresty/openresty:focal` | Ubuntu Focal 最新版 |
| `openresty/openresty:alpine` | Alpine 最新版       |


## 基本使用  
若无需自定义构建，可直接使用 Docker Hub 上的镜像。基础运行命令：  
```bash
docker run [选项] openresty/openresty:bullseye-fat
```  
- **选项说明**：`-p` 映射端口，`-v` 挂载数据卷，`-d` 后台运行。  
- **日志处理**：容器将 Nginx 的 `access.log` 和 `error.log` 分别链接到 `/dev/stdout` 和 `/dev/stderr`，适配 Docker 日志系统。若修改配置中的日志路径，需手动创建对应链接。  
- **临时目录**：`client_body_temp_path` 等临时目录位于 `/var/run/openresty/`，建议挂载该目录以避免容器内存储占用。  


## Nginx 配置文件  
容器默认包含 `nginx.conf` 配置，路径为 `/usr/local/openresty/nginx/conf/nginx.conf`。配置逻辑如下：  
- **包含子配置**：默认配置通过 `include /etc/nginx/conf.d/*.conf;` 加载 `/etc/nginx/conf.d/` 目录下的所有 `.conf` 文件，其中 `default.conf` 为默认虚拟主机配置。  

### 自定义配置方法  
1. **挂载配置目录**：将本地配置目录挂载到容器的 `/etc/nginx/conf.d/`，覆盖默认子配置：  
   ```bash
   docker run -v /本地/custom/conf.d:/etc/nginx/conf.d openresty/openresty:alpine
   ```  
2. **替换主配置**：直接挂载自定义的 `nginx.conf` 替换默认配置（适用于 Windows 镜像）：  
   ```bash
   docker run -v C:/本地/nginx.conf:C:/openresty/conf/nginx.conf openresty/openresty:windows
   ```  
3. **SELinux 环境**：若主机启用 SELinux（如 CentOS），挂载时需添加 `:Z` 标签：  
   ```bash
   docker run -v /本地/custom/conf.d:/etc/nginx/conf.d:Z openresty/openresty:alpine
   ```  


## OPM 工具  
OpenResty 包管理器 `opm`（路径 `/usr/local/openresty/bin/opm`）用于安装 OpenResty 模块，**以下镜像默认包含 opm**：`alpine-fat`、`centos`、`bionic`、`bullseye-fat` 等。  

### 特殊镜像的 opm 使用  
- **Alpine 镜像**：需手动安装依赖（`curl` 和 `perl`）：  
  ```bash
  apk add --no-cache curl perl
  ```  
- **Debian (bullseye/buster) 镜像**：使用 `bullseye-fat` 镜像，或在自定义构建中安装 `openresty-opm` 包（参考 [示例 Dockerfile]([])）。  


## LuaRocks 工具  
Lua 包管理器 [LuaRocks]([]) 用于安装 Lua 模块，**默认包含在 `alpine-fat`、`centos`、`bionic` 镜像中**（`alpine` 镜像因追求精简未包含）。使用路径：`/usr/local/openresty/luajit/bin/luarocks`。  

### 安装 Lua 包示例  
```bash
RUN /usr/local/openresty/luajit/bin/luarocks install <包名>
```  


## 注意事项与常见问题  
1. **SSE4.2 优化兼容性**：  
   Docker Hub 镜像默认启用 SSE4.2 优化，若运行在不支持 SSE4.2 的设备（如老旧服务器、嵌入式系统），会出现“无效指令”错误。需手动构建不含 SSE4.2 的镜像：  
   ```bash
   docker build -f bionic/Dockerfile --build-arg "RESTY_LUAJIT_OPTIONS=--with-luajit-xcflags='-DLUAJIT_NUMMODE=2 -DLUAJIT_ENABLE_LUA52COMPAT -mno-sse4.2'" .
   ```  

2. **OpenSSL 版本兼容性**：  
   确保 `opm`/LuaRocks 包与镜像的 OpenSSL 版本匹配（版本号需一致，如 `1.1.1`）。可通过镜像标签 `resty_openssl_version` 查看 OpenSSL 版本。  

3. **envsubst 工具**：  
   除 `alpine` 和 `windows` 镜像外，其他镜像均包含 `envsubst`（用于配置文件环境变量替换）。  

4. **容器停止信号**：  
   容器默认使用 `SIGQUIT` 信号停止 Nginx，以优雅关闭连接（Docker 默认 `SIGTERM` 会强制终止连接）。若配置中使用 UNIX 域套接字，需手动清理套接字文件（Nginx 已知问题 [#753]([])）。  


## 镜像标签信息  
镜像内置标签记录构建信息（如 OpenResty 版本、依赖库版本等），可通过 `docker inspect` 查看。例如：  
```bash
docker inspect openresty/openresty:1.17.8.1-0-bionic | jq '.[].Config.Labels'
```  

### 主要标签说明  
| 标签名                  | 说明                          |
|-------------------------|-------------------------------|
| `resty_version`         | OpenResty 版本                |
| `resty_openssl_version` | OpenSSL 版本                  |
| `resty_pcre_version`    | PCRE 版本                     |
| `resty_luarocks_version`| LuaRocks 版本（若包含）       |  


## Docker CMD 说明  
容器默认 CMD 为 `["openresty", "-g", "daemon off;"]`，确保 Nginx 前台运行。若 `nginx.conf` 中已配置 `daemon off;`，需显式指定命令：  
```bash
docker run [选项] openresty/openresty:bionic openresty
```  

### 运行其他命令示例  
执行 `resty` 工具（需 `perl` 和 `ncurses` 依赖，`alpine` 镜像需额外安装）：  
```bash
docker run [选项] openresty/openresty:bionic resty [脚本.lua]
```  


## 自定义构建（从源码）  
可通过克隆仓库并指定 Dockerfile 构建自定义镜像，支持调整 OpenResty 版本、依赖库等参数。  

### 构建步骤示例  
```bash
git clone [] docker-openresty
# 构建 Ubuntu Bionic 版本
docker build -t 自定义镜像名 -f bionic/Dockerfile .
```  

### 常用构建参数  
| 参数名                 | 默认值          | 说明                          |
|-------------------------|-----------------|-------------------------------|
| `RESTY_VERSION`         | 1.21.4.1        | OpenResty 版本                |
| `RESTY_OPENSSL_VERSION` | 1.1.1q          | OpenSSL 版本                  |
| `RESTY_PCRE_VERSION`    | 8.45            | PCRE 版本                     |
| `RESTY_LUAROCKS_VERSION`| 3.9.0           | LuaRocks 版本（若构建）       |  


## 反馈与贡献  
使用中遇到问题可提交 [GitHub Issue]([])，或通过 [Travis CI]([])、[Appveyor]([]) 查看构建状态。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/openresty/openresty" title="openresty/openresty Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/openresty/openresty</a></p>
