---
image: neilpang/acme.sh
description: "acme.sh的Docker容器版本是一个基于Shell脚本开发的轻量级ACME协议客户端，可在Docker环境中便捷运行，用于自动申请及续期Let's Encrypt等证书颁发机构的SSL/TLS证书，无需复杂系统依赖，配置简单易上手，适合容器化部署场景，项目官方仓库地址为[]"
source: https://xuanyuan.cloud/zh/r/neilpang/acme.sh
canonical: https://xuanyuan.cloud/zh/r/neilpang/acme.sh
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/neilpang/acme.sh" title="neilpang/acme.sh Docker 镜像中文简介、标签列表与拉取命令">neilpang/acme.sh 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### 在 Docker 中运行 acme.sh

以下是如何在 Docker 容器中运行 acme.sh 的简要指南，旨在简化 SSL/TLS 证书的获取与更新流程。

#### 1. 拉取 acme.sh Docker 镜像
首先，从 Docker Hub 拉取官方镜像：
```bash
docker pull docker.xuanyuan.run/neilpang/acme.sh
```

#### 2. 运行 acme.sh 容器
使用以下命令启动容器，核心是挂载本地目录以持久化证书和配置，并设置必要的环境变量。

**基础运行命令示例**：
```bash
docker run --rm -it \
  -v "$(pwd)/acme.sh:/acme.sh" \
  -e "EMAIL=[邮箱已删除]" \
  --net=host \
  docker.xuanyuan.run/neilpang/acme.sh --issue -d example.com --standalone
```

**参数说明**：
- `-v "$(pwd)/acme.sh:/acme.sh"`: 将本地当前目录下的 `acme.sh` 文件夹挂载到容器内的 `/acme.sh`，用于存储证书、密钥和配置。
- `-e "EMAIL=[邮箱已删除]"`: 设置注册邮箱，用于证书到期通知等。
- `--net=host`: 使用主机网络模式（如需绑定 80/443 端口验证时推荐，非必须，视验证方式而定）。
- `neilpang/acme.sh`: 镜像名称。
- `--issue -d example.com --standalone`: 这是传递给 acme.sh 的具体命令，用于签发证书（示例为 standalone 模式）。

#### 3. 获取证书
根据你的验证方式（HTTP-01、DNS-01 等），调整容器启动命令中的 acme.sh 参数。

**示例 1：HTTP-01 验证（需 80 端口）**
```bash
docker run --rm -it \
  -v "$(pwd)/acme.sh:/acme.sh" \
  -e "EMAIL=[邮箱已删除]" \
  -p 80:80 \
  docker.xuanyuan.run/neilpang/acme.sh --issue -d example.com --webroot /var/www/html
```
*注：需确保 `/var/www/html` 是你网站的根目录，并正确挂载。*

**示例 2：DNS-01 验证（推荐，无需开放端口）**
以 Cloudflare DNS 为例，需先设置 API 密钥环境变量：
```bash
docker run --rm -it \
  -v "$(pwd)/acme.sh:/acme.sh" \
  -e "EMAIL=[邮箱已删除]" \
  -e "CF_Key=your_cloudflare_api_key" \
  -e "CF_Email=your_cloudflare_email" \
  docker.xuanyuan.run/neilpang/acme.sh --issue -d example.com --dns dns_cf
```
*不同 DNS 提供商需设置对应的环境变量，具体参考 acme.sh 文档。*

#### 4. 安装/复制证书
证书生成后存储在挂载的本地目录（`./acme.sh/example.com/`）。你可以通过 `--install-cert` 命令将证书复制到指定位置（例如 Nginx 配置目录）：
```bash
docker run --rm -it \
  -v "$(pwd)/acme.sh:/acme.sh" \
  -v "/path/to/nginx/conf:/nginx/conf" \
  docker.xuanyuan.run/neilpang/acme.sh --install-cert -d example.com \
  --key-file /nginx/conf/key.pem \
  --fullchain-file /nginx/conf/cert.pem \
  --reloadcmd "nginx -s reload"
```

#### 5. 自动更新证书
acme.sh 容器默认会自动更新证书（通过内部 cron 任务）。确保容器持续运行，或使用 `--renew-hook` 设置更新后的钩子命令（如重启服务）。

#### 6. 备份与恢复
证书和配置存储在本地挂载的 `acme.sh` 目录，定期备份该目录即可。恢复时，将备份目录挂载到新容器中。

### 重要提示
- **权限问题**：确保本地挂载目录的权限允许容器读写。
- **网络模式**：`--net=host` 可能带来安全风险，若不使用，需确保端口映射正确（如 HTTP-01 需映射 80 端口）。
- **DNS 验证**：推荐使用 DNS-01 验证，无需暴露端口，支持泛域名证书。
- **命令参考**：容器内执行 `acme.sh --help` 可查看所有可用命令。

详细用法和高级配置（如不同 DNS 提供商、证书安装钩子等），请参考官方文档：[Run acme.sh in docker] 。
