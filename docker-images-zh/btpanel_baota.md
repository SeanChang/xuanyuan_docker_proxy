---
image: btpanel/baota
description: "宝塔Linux面板是一款提升运维效率的服务器管理软件，支持一键部署LAMP/LNMP、集群管理、系统监控、网站搭建、FTP服务、数据库配置及JAVA环境等100多项服务器管理功能，其功能全面、稳定少故障且安全可靠，已获全球百万用户认可并安装使用。"
source: https://xuanyuan.cloud/zh/r/btpanel/baota
canonical: https://xuanyuan.cloud/zh/r/btpanel/baota
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/btpanel/baota" title="btpanel/baota Docker 镜像中文简介、标签列表与拉取命令">btpanel/baota — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/btpanel/baota" title="btpanel/baota Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/btpanel/baota</a>

# 宝塔面板 Docker 部署指南


## 一、镜像基本信息  
堡塔安全官方发布的宝塔面板 Docker 镜像，支持 x86_64 及 arm 架构，镜像版本随面板更新。主要版本及拉取命令如下：  

| 版本类型         | 标签               | 拉取命令                                  | 说明                     |  
|------------------|--------------------|-------------------------------------------|--------------------------|  
| 9.3.0 正式版     | latest             | `docker pull btpanel/baota:latest`        | 基于 Debian12            |  
| 9.0.0 LTS 稳定版 | 9.0_lts_lnmp       | `docker pull btpanel/baota:9.0_lts_lnmp`  | -                        |  
| 9.2.0 正式版     | 其他分支           | 前往 [Tags 页面]([]) 选择 | 基于不同系统维护         |  


## 二、镜像标签说明  
不同标签对应不同环境配置，选择时需注意：  

- **latest**：预装面板及部分环境依赖库  
- **fresh&slim**：仅装面板，无集成依赖包（首次安装软件需额外下载依赖，速度较慢）  
- **lib**：预装面板及集成依赖包（后续安装软件速度较快）  
- **lnmp**：预装面板、依赖包及 LNMP 环境（Nginx 1.26 + MySQL 8 + PHP 8）  
- **lamp**：预装面板、依赖包及 LAMP 环境（Apache 2.4 + MySQL 8 + PHP 8）  
- **7.9.4 的 lnmp**：旧版环境（Nginx 1.22 + MySQL 5.7 + PHP 7.4，arm 架构为 MySQL 5.6）  
- **7.9.4 的 lamp**：旧版环境（Apache 2.4 + MySQL 5.7 + PHP 7.4，arm 架构为 MySQL 5.6）  


## 三、部署前注意事项  
1. **安全配置**：部署完成后，**必须立即登录面板**，通过「面板设置」修改用户名、密码及安全入口，避免默认信息泄露。  
2. **功能限制**：镜像默认隐藏左侧菜单栏「安全」「Docker」选项，且不提供 systemd 管理（安全考虑）。  


## 四、拉取镜像方法  
拉取镜像后将永久保存到本地，后续部署无需重复拉取（若本地无镜像，部署时 Docker 会自动从云端拉取）。  

### 1. 常规拉取  
- 拉取指定标签镜像（以 lnmp 为例）：  
  ```bash  
  docker pull btpanel/baota:lnmp  
  ```  

### 2. 旧版本（7.9.4）拉取  
```bash  
docker pull btpanel/baota:7.9.4-lnmp  # lnmp 环境  
# 或  
docker pull btpanel/baota:7.9.4-lamp  # lamp 环境  
```  

### 3. ARM 架构服务器  
无需额外操作，Docker 会自动根据系统架构拉取匹配的镜像。  


## 五、部署步骤  
根据网络需求选择以下任一方法部署，命令中 `-v` 参数为目录映射（用户可自定义本地路径），确保数据持久化。  

### 方法 1：使用本地网络（--net=host）  
无需映射端口，直接使用主机网络：  
```bash  
docker run -d --restart unless-stopped --name baota \  
  --net=host \  
  -v ~/website_data:/www/wwwroot \  # 网站数据目录映射  
  -v ~/mysql_data:/www/server/data \  # MySQL 数据目录映射  
  -v /vhost:/www/server/panel/vhost \  # vhost 配置文件映射  
  btpanel/baota:lnmp  # 镜像标签（可替换为其他标签，如 lamp、latest）  
```  

**自定义路径示例**：若需将网站数据目录改为 `/home/website_data`，命令调整为：  
```bash  
docker run -d --restart unless-stopped --name baota \  
  --net=host \  
  -v /home/website_data:/www/wwwroot \  
  -v /home/mysql_data:/www/server/data \  
  -v /home/vhost:/www/server/panel/vhost \  
  btpanel/baota:lnmp  
```  


### 方法 2：映射指定端口  
手动映射常用端口（适用于需要限制端口访问的场景）：  
```bash  
docker run -d --restart unless-stopped --name baota \  
  -p 8888:8888 -p 22:22 -p 443:443 -p 80:80 -p 888:888 \  # 端口映射  
  -v ~/website_data:/www/wwwroot \  
  -v ~/mysql_data:/www/server/data \  
  -v ~/vhost:/www/server/panel/vhost \  
  btpanel/baota:lnmp  
```  


## 六、访问面板  
### 1. 登录信息  
- **默认地址**：`[]  
- **默认用户名**：`btpanel`  
- **默认密码**：`btpaneldocker`  
- **容器 SSH 密码**：`btpaneldocker`  


### 2. 无法访问解决  
若无法访问，需先开放服务器安全组端口（如阿里云、腾讯云服务器）：  
- [阿里云安全组配置指引]([])  
- [腾讯云安全组配置指引]([])  


## 七、端口与目录说明  
### 常用端口  
| 服务/功能       | 端口  |  
|-----------------|-------|  
| 宝塔面板        | 8888  |  
| phpMyAdmin      | 888   |  
| SSH             | 22    |  
| FTP             | 21    |  
| 网站服务（HTTP/HTTPS） | 80/443 |  
| MySQL           | 3306  |  


### 容器内关键目录  
| 用途               | 容器内路径                  |  
|--------------------|-----------------------------|  
| 网站数据           | `/www/wwwroot`              |  
| MySQL 数据         | `/www/server/data`          |  
| 虚拟主机配置文件   | `/www/server/panel/vhost`   |  


## 相关资源  
- Dockerfile 仓库：[btpanel]([])（欢迎 PR/Issue）  
- 官方支持：[堡塔安全官方团队]([])（问题反馈与建议）
