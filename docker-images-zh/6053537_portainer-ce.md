---
image: 6053537/portainer-ce
description: "Portainer-CE 中文版"
source: https://xuanyuan.cloud/zh/r/6053537/portainer-ce
canonical: https://xuanyuan.cloud/zh/r/6053537/portainer-ce
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/6053537/portainer-ce" title="6053537/portainer-ce Docker 镜像中文简介、标签列表与拉取命令">6053537/portainer-ce — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/6053537/portainer-ce" title="6053537/portainer-ce Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/6053537/portainer-ce</a>

# Portainer-CE 中文版


## 项目简介  
这是 Portainer-CE 的中文优化版本，已更新至 **2.19.4**。版本特点包括：彻底汉化界面，去除左上角「升级企业版」广告、首次登录英文公告及汉化相关广告，提升使用体验。  

**支持架构**：仅测试过 arm64 与 amd64 架构，其他架构因无测试设备暂不保证兼容性。  


## 支持与反馈  
- **源码仓库**：[[]]([])  
- **Star 支持**：若你觉得项目有帮助，可通过 [爱发电]([]) 支持作者更新。  
- **Bug 反馈**：使用中遇到问题，可提交至 GitHub Issues。  
- **项目数据**：镜像 Pull 量已突破 150 万，感谢用户支持（笔者非专业开发者，优化工作离不开社区帮助）。  


## 安装指南  

### 通用 Docker 安装  
适用于 Linux/macOS 等主流 Docker 环境：  
```bash
docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock 6053537/portainer-ce
```

#### 国内镜像（CloudFlare 自建）  
若无法访问 Docker Hub，可尝试：  
```bash
docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock docker.simon.us.kg/6053537/portainer-ce
```


### Windows Docker Desktop 安装  
适用于 Windows 系统的 Docker Desktop：  
```bash
docker run -d -p 9000:9000 --name portainer --restart always -v \\.\pipe\docker_engine:\\.\pipe\docker_engine -v portainer_data:C:\data 6053537/portainer-ce
```


### 启用 SSL 访问（远程主机建议配置）  
需自行准备证书（路径 `/certs`）及调整端口（示例用 443）：  
```bash
docker run -d -p 8000:8000 -p 443:9443 --name portainer --restart always -v ~/local-certs:/certs -v portainer_data:/data 6053537/portainer-ce -v /var/run/docker.sock:/var/run/docker.sock --ssl --sslcert /certs/portainer.crt --sslkey /certs/portainer.key
```


### Nginx 反代配置  
#### 普通反代（根路径）  
```nginx
location / {
  proxy_pass [];
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_read_timeout 300s;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "upgrade";
}
```

#### 子目录反代（如 `youname.com/portainer`）  
```nginx
location ^~ /portainer/ {
  proxy_pass [];
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_read_timeout 300s;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "upgrade";
}
```


### docker-compose 配置  
```yaml
services:
  portainer:
      container_name: portainer
      network_mode: bridge
      image: 6053537/portainer-ce:latest  # 中文镜像；官方原版为 portainer/portainer-ce
      # image: hub-mirror.c.163.com/6053537/portainer-ce  # 国内服务器可选，需注释上一行
      ports:
        - 9000:9000
        # - 8000:8000  # 如需 Agent 通信可开放
        # - 9443:9443  # 如需 SSL 可开放
      volumes:
        - portainer_data:/data
        - /var/run/docker.sock:/var/run/docker.sock
      restart: unless-stopped
volumes:
  portainer_data:
```


## 注意事项  
- **登录密码问题**：程序本身不含任何密码或加密。若安装后提示输入密码，可能是此前安装过英文版或其他版本残留数据，建议尝试旧账号密码登录。  


## 致谢  
感谢社区群友支持：  
- @我不是矿神：提供 JS 精简指导  
- @52Fancy：提供编译脚本  


## 许可信息  
Portainer 基于 zlib 许可证开源，详见 [LICENSE]([])。第三方开源组件说明见 [ATTRIBUTIONS.md]([])。
