---
image: certbot/dns-cloudflare
description: "官方构建的EFF Certbot，包含用于通过Cloudflare进行DNS验证的插件，可处理DNS挑战以获取SSL/TLS证书。"
source: https://xuanyuan.cloud/zh/r/certbot/dns-cloudflare
canonical: https://xuanyuan.cloud/zh/r/certbot/dns-cloudflare
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/certbot/dns-cloudflare" title="certbot/dns-cloudflare Docker 镜像中文简介、标签列表与拉取命令">certbot/dns-cloudflare 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Certbot Cloudflare DNS插件 Docker镜像文档


## 一、镜像概述和主要用途

### 1.1 镜像基本信息
**镜像名称**：`certbot/dns-cloudflare`（基于Certbot官方镜像构建）  
**官方维护**：Electronic Frontier Foundation (EFF)  
**核心用途**：该镜像为Certbot的官方Docker镜像，集成了Cloudflare DNS插件，用于通过DNS-01挑战（DNS-01 challenge）自动获取、续期SSL/TLS证书。适用于使用Cloudflare DNS服务的域名，无需暴露服务器80/443端口即可完成域名验证。


## 二、核心功能和特性

### 2.1 核心功能
- **Cloudflare DNS-01验证**：通过Cloudflare DNS API自动添加/删除TXT记录，完成域名所有权验证（DNS-01挑战）。  
- **证书全生命周期管理**：支持自动申请、续期SSL/TLS证书（包括通配符证书和多域名证书）。  
- **Certbot核心兼容**：完全兼容Certbot标准命令和配置，可结合Certbot其他功能（如证书安装、 renewal-hooks等）使用。  

### 2.2 关键特性
- **轻量级**：基于Alpine或Debian slim基础镜像，镜像体积小，资源占用低。  
- **官方维护**：由EFF官方构建和更新，与Certbot主版本同步，安全性和兼容性有保障。  
- **无端口依赖**：无需暴露80/443端口，解决服务器端口受限场景下的证书申请问题。  


## 三、使用场景和适用范围

### 3.1 典型使用场景
- **通配符证书申请**：需为`*.example.com`等通配符域名申请证书（ACME协议要求通配符证书必须通过DNS-01验证）。  
- **多域名/子域名管理**：同时为多个独立域名或子域名（如`a.example.com`、`b.example.com`）申请证书。  
- **端口受限环境**：服务器无法开放80/443端口（如内网服务、防火墙限制），无法使用HTTP-01挑战。  
- **Cloudflare DNS用户**：域名DNS服务由Cloudflare托管，需通过Cloudflare API自动化DNS记录操作。  

### 3.2 适用范围
- 个人或企业用户使用Cloudflare DNS服务的域名。  
- 需要自动化SSL/TLS证书管理的Docker化部署环境。  
- 对证书安全性和续期可靠性有较高要求的生产环境。  


## 四、使用方法和配置说明

### 4.1 前置条件
1. **环境依赖**：已安装Docker Engine（20.10+推荐）或Docker Compose。  
2. **Cloudflare配置**：  
   - 拥有Cloudflare账户及目标域名的管理权限。  
   - 创建Cloudflare API令牌（API Token），需包含以下权限：  
     - `Zone:Read`（读取域名区域信息）  
     - `DNS:Edit`（修改DNS记录，用于添加/删除TXT记录）  
   - （可选）记录目标域名的Cloudflare区域ID（Zone ID），用于指定域名区域。  


### 4.2 核心配置参数

#### 4.2.1 环境变量（Cloudflare插件专用）
| 环境变量名                | 说明                                                                 | 是否必填 |
|---------------------------|----------------------------------------------------------------------|----------|
| `CF_DNS_API_TOKEN`        | Cloudflare API令牌（推荐），需包含`DNS:Edit`和`Zone:Read`权限        | 是       |
| `CF_ZONE_API_TOKEN`       | （可选）仅用于指定区域的令牌，优先级高于`CF_DNS_API_TOKEN`           | 否       |
| `CF_API_EMAIL`            | Cloudflare账户邮箱（传统API密钥模式使用，与`CF_API_KEY`配合）        | 否       |
| `CF_API_KEY`              | Cloudflare全局API密钥（传统模式，不推荐，优先使用API令牌）           | 否       |
| `CERTBOT_EMAIL`           | 用于接收证书过期通知的邮箱地址                                       | 是       |


#### 4.2.2 Certbot通用参数
| 参数                          | 说明                                                                 |
|-------------------------------|----------------------------------------------------------------------|
| `certonly`                    | 仅申请证书（不自动安装到服务器）                                     |
| `--dns-cloudflare`            | 指定使用Cloudflare DNS插件                                           |
| `--dns-cloudflare-credentials`| （可选）指定包含Cloudflare凭据的配置文件路径（替代环境变量）          |
| `--non-interactive`           | 非交互式模式（适合自动化脚本）                                       |
| `--agree-tos`                 | 同意ACME服务条款                                                     |
| `--email`                     | 指定管理员邮箱（同`CERTBOT_EMAIL`环境变量，命令行参数优先级更高）    |
| `-d`                          | 指定目标域名（支持多个，如`-d example.com -d *.example.com`）         |


### 4.3 部署示例

#### 4.3.1 使用`docker run`获取证书
##### 首次申请证书（通配符域名示例）
```bash
docker run --rm \
  -v /etc/letsencrypt:/etc/letsencrypt \  # 挂载证书存储目录（持久化证书）
  -v /var/lib/letsencrypt:/var/lib/letsencrypt \  # 挂载Certbot工作目录
  -e "CF_DNS_API_TOKEN=your_cloudflare_api_token" \  # Cloudflare API令牌
  -e "CERTBOT_EMAIL=admin@example.com" \  # 管理员邮箱
  certbot/dns-cloudflare \
  certonly \
  --dns-cloudflare \
  --non-interactive \
  --agree-tos \
  -d example.com \
  -d *.example.com
```

##### 证书续期（自动续期）
Certbot默认会检查证书有效期（剩余30天内自动续期），可通过以下命令手动触发续期：
```bash
docker run --rm \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/lib/letsencrypt:/var/lib/letsencrypt \
  -e "CF_DNS_API_TOKEN=your_cloudflare_api_token" \
  docker.xuanyuan.run/certbot/dns-cloudflare \
  renew \
  --non-interactive
```


#### 4.3.2 Docker Compose配置示例
创建`docker-compose.yml`文件：
```yaml
version: '3.8'

services:
  certbot:
    image: docker.xuanyuan.run/certbot/dns-cloudflare
    volumes:
      - ./letsencrypt:/etc/letsencrypt  # 本地目录挂载，持久化证书
      - ./letsencrypt-lib:/var/lib/letsencrypt  # 工作目录
    environment:
      - CF_DNS_API_TOKEN=your_cloudflare_api_token  # 替换为实际API令牌
      - CERTBOT_EMAIL=admin@example.com  # 替换为实际邮箱
    command: >
      certonly
      --dns-cloudflare
      --non-interactive
      --agree-tos
      -d example.com
      -d *.example.com
```

启动容器申请证书：
```bash
docker-compose up
```


### 4.4 证书管理

#### 4.4.1 证书存储路径
容器内证书默认存储于`/etc/letsencrypt`，通过卷挂载到宿主机后，可在宿主机路径（如`/etc/letsencrypt`）中查看：
- 证书文件：`/etc/letsencrypt/live/example.com/fullchain.pem`  
- 私钥文件：`/etc/letsencrypt/live/example.com/privkey.pem`  


#### 4.4.2 自动续期配置
Certbot证书默认有效期为90天，建议通过定时任务（如`crontab`）自动续期：  
1. 创建续期脚本`/opt/certbot/renew.sh`：
```bash
#!/bin/bash
docker run --rm \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/lib/letsencrypt:/var/lib/letsencrypt \
  -e "CF_DNS_API_TOKEN=your_cloudflare_api_token" \
  docker.xuanyuan.run/certbot/dns-cloudflare renew --non-interactive
```

2. 添加可执行权限：
```bash
chmod +x /opt/certbot/renew.sh
```

3. 配置crontab（每日凌晨3点执行）：
```bash
echo "0 3 * * * /opt/certbot/renew.sh >> /var/log/certbot-renew.log 2>&1" | crontab -
```


## 五、注意事项

1. **API令牌权限**：确保Cloudflare API令牌至少包含`Zone:Read`和`DNS:Edit`权限，避免因权限不足导致验证失败。  
2. **证书备份**：`/etc/letsencrypt`目录需持久化存储（通过Docker卷挂载），防止容器删除后证书丢失。  
3. **隐私保护**：避免将API令牌或密钥直接写入命令行或配置文件，建议通过环境变量或安全文件管理。  
4. **日志查看**：通过`docker logs <容器ID>`查看证书申请/续期过程中的详细日志，用于排查错误。  


## 六、参考链接
- [Certbot官方文档](https://certbot.eff.org/docs/)  
- [Certbot Cloudflare DNS插件文档](https://certbot-dns-cloudflare.readthedocs.io/)  
- [Cloudflare API令牌创建指南](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
