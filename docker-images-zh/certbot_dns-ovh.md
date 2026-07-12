---
image: certbot/dns-ovh
description: "EFF的Certbot官方构建版本，包含用于通过OVH进行DNS验证挑战的插件。"
source: https://xuanyuan.cloud/zh/r/certbot/dns-ovh
canonical: https://xuanyuan.cloud/zh/r/certbot/dns-ovh
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/certbot/dns-ovh" title="certbot/dns-ovh Docker 镜像中文简介、标签列表与拉取命令">certbot/dns-ovh 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Certbot OVH DNS插件 Docker镜像文档


## 镜像概述和主要用途

本镜像为EFF (Electronic Frontier Foundation) 官方维护的Certbot Docker镜像，集成了针对OVH DNS服务的专用插件。Certbot是一款符合ACME (Automated Certificate Management Environment) 协议的证书管理工具，可自动从Let's Encrypt等证书颁发机构 (CA) 获取、续期SSL/TLS证书。该镜像通过OVH DNS插件，支持利用OVH DNS服务完成ACME DNS-01挑战，实现域名所有权验证，适用于无法通过HTTP-01挑战验证域名的场景。


## 核心功能和特性

### 核心功能
- 基于Certbot v1.7.0核心构建，兼容ACME v2协议
- 集成OVH DNS插件，支持通过OVH DNS API自动完成DNS-01挑战
- 自动生成、获取和续期SSL/TLS证书（支持ECC和RSA证书）
- 支持证书私钥和链文件的持久化存储


### 主要特性
- **官方维护**：由EFF官方发布和维护，确保兼容性和安全性
- **DNS挑战自动化**：无需手动添加DNS TXT记录，插件自动完成验证流程
- **轻量级**：基于Docker容器化部署，环境依赖隔离
- **可扩展**：支持自定义证书存储路径、配置文件挂载


## 使用场景和适用范围

### 适用场景
- 域名DNS服务由OVH提供的用户
- 需要为域名获取Let's Encrypt等CA免费SSL/TLS证书的场景
- 无法使用HTTP-01挑战的环境（如：防火墙限制80/443端口、非公开服务、多服务器共享域名证书等）
- 需自动化证书续期的生产环境


### 适用范围
- 个人网站、企业官网、API服务等需HTTPS加密的服务
- 基于OVH DNS管理的单域名或多域名证书申请
- 支持通配符证书（如`*.example.com`）的申请和续期


## 详细使用方法和配置说明

### 前提条件
1. 拥有OVH账号及域名的DNS管理权限
2. 获取OVH API凭证（需在OVH控制台创建应用并生成`APPLICATION_KEY`、`APPLICATION_SECRET`和`CONSUMER_KEY`）
3. 安装Docker Engine（18.06+）或Docker Compose（2.0+）


### 环境变量配置

OVH DNS插件需通过环境变量注入API凭证，具体参数如下：

| 环境变量名                | 描述                                                                 | 示例值                |
|--------------------------|----------------------------------------------------------------------|-----------------------|
| `OVH_ENDPOINT`           | OVH API端点（根据服务区域选择）                                       | `ovh-eu`（欧洲区域）  |
| `OVH_APPLICATION_KEY`    | OVH API应用密钥（从OVH开发者控制台获取）                              | `xxxxxxxxxxxx`        |
| `OVH_APPLICATION_SECRET` | OVH API应用密钥（从OVH开发者控制台获取）                              | `xxxxxxxxxxxx`        |
| `OVH_CONSUMER_KEY`       | OVH API消费者密钥（通过API授权流程生成）                              | `xxxxxxxxxxxx`        |


### 证书存储路径

为确保证书持久化，需将容器内证书存储目录挂载到宿主机。默认路径：
- 证书存储：`/etc/letsencrypt`（包含私钥、证书链、配置文件等）
- 临时工作目录：`/var/lib/letsencrypt`（ACME挑战临时文件）


### Docker运行示例

#### 1. 获取证书（首次申请）

使用`docker run`命令执行证书申请，需挂载证书存储目录并注入OVH API凭证：

```bash
docker run -it --rm \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/lib/letsencrypt:/var/lib/letsencrypt \
  -e "OVH_ENDPOINT=ovh-eu" \
  -e "OVH_APPLICATION_KEY=your_application_key" \
  -e "OVH_APPLICATION_SECRET=your_application_secret" \
  -e "OVH_CONSUMER_KEY=your_consumer_key" \
  docker.xuanyuan.run/certbot/dns-ovh:v1.7.0 \
  certonly \
  --dns-ovh \
  --dns-ovh-propagation-seconds 60 \  # DNS记录传播等待时间（根据OVH DNS生效时间调整）
  -d example.com \                    # 目标域名（支持多个-d参数）
  -d "*.example.com" \                # 通配符域名（需DNS-01挑战）
  --email admin@example.com \         # 通知邮箱（证书续期/过期提醒）
  --agree-tos \                       # 同意CA服务条款
  --non-interactive                   # 非交互式模式（适合自动化脚本）
```


#### 2. 证书续期

Certbot默认支持自动续期（证书过期前30天），可通过以下命令手动触发续期：

```bash
docker run -it --rm \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/lib/letsencrypt:/var/lib/letsencrypt \
  -e "OVH_ENDPOINT=ovh-eu" \
  -e "OVH_APPLICATION_KEY=your_application_key" \
  -e "OVH_APPLICATION_SECRET=your_application_secret" \
  -e "OVH_CONSUMER_KEY=your_consumer_key" \
  docker.xuanyuan.run/certbot/dns-ovh:v1.7.0 \
  renew \
  --dns-ovh \
  --dns-ovh-propagation-seconds 60 \
  --non-interactive
```


### Docker Compose配置示例

创建`docker-compose.yml`文件，集成证书申请和续期流程：

```yaml
version: '3.8'

services:
  certbot-ovh:
    image: docker.xuanyuan.run/certbot/dns-ovh:v1.7.0
    volumes:
      - ./letsencrypt:/etc/letsencrypt  # 宿主机证书存储目录（需提前创建）
      - ./var-lib-letsencrypt:/var/lib/letsencrypt  # 工作目录
    environment:
      - OVH_ENDPOINT=ovh-eu
      - OVH_APPLICATION_KEY=your_application_key
      - OVH_APPLICATION_SECRET=your_application_secret
      - OVH_CONSUMER_KEY=your_consumer_key
    command: >
      certonly
      --dns-ovh
      --dns-ovh-propagation-seconds 60
      -d example.com
      -d "*.example.com"
      --email admin@example.com
      --agree-tos
      --non-interactive
```

启动服务：
```bash
docker-compose up -d
```


## 注意事项

1. **OVH API凭证安全**：`OVH_APPLICATION_SECRET`和`OVH_CONSUMER_KEY`属于敏感信息，建议通过环境变量文件（如`.env`）管理，避免直接明文写入配置文件。

2. **证书备份**：`/etc/letsencrypt`目录包含所有证书和私钥，需定期备份，防止数据丢失。

3. **DNS传播时间**：`--dns-ovh-propagation-seconds`参数需根据OVH DNS记录生效时间调整（通常建议60-300秒），过短可能导致验证失败。

4. **自动化续期**：可通过crontab或Docker Compose调度工具（如Watchtower）配置定期续期任务，确保证书不过期。

5. **版本兼容性**：本镜像基于v1.7.0构建，如需使用更新特性，可访问[Certbot官方仓库](https://github.com/certbot/certbot)获取最新版本信息。


## 参考链接
- [Certbot官方文档](https://certbot.eff.org/docs/)
- [OVH API凭证获取指南](https://docs.ovh.com/gb/en/customer/first-steps-with-ovh-api/)
- [ACME DNS-01挑战说明](https://letsencrypt.org/docs/challenge-types/#dns-01-challenge)
