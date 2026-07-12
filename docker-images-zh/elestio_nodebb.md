---
image: elestio/nodebb
description: "Nodebb是一款基于现代Web技术构建的开源论坛与社区平台，具备实时互动、模块化扩展及响应式设计等特性，可助力用户快速搭建活跃的在线社区；该版本由Elestio进行专业验证与打包，确保了部署流程的简便性、代码的安全性及运行的稳定性，为开发者和社区管理者提供了可靠的即用型解决方案。"
source: https://xuanyuan.cloud/zh/r/elestio/nodebb
canonical: https://xuanyuan.cloud/zh/r/elestio/nodebb
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/elestio/nodebb" title="elestio/nodebb Docker 镜像中文简介、标签列表与拉取命令">elestio/nodebb 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# NodeBB，由 Elestio 验证并打包  

NodeBB 是适用于现代网络的优质社区平台。  

[NodeBB]  是下一代论坛软件——功能强大且易于使用。  

![nodebb]   


如果您需要自动化备份、带 SSL 终止的反向代理、防火墙、自动化的操作系统和软件更新，以及由 Linux 专家和开源爱好者组成的团队确保服务始终安全可用，可在 [elest.io]  上部署 [完全托管的 NodeBB] 。  

[![部署] ]   


## 为什么选择 Elestio 镜像？  

- Elestio 与原始源码的更新保持同步，并通过自动化流程快速发布该镜像的新版本。  
- Elestio 镜像能让您及时获取最新的错误修复和功能。  
- 我们的团队会执行质量控制检查，确保发布的产品符合高标准。  


## 使用方法  

### 通过 Git 部署  

您可以通过以下命令轻松部署：  

```bash  
git clone []  
```  

从 tests 文件夹复制 .env 文件到项目目录：  

```bash  
cp ./tests/.env ./.env  
```  

编辑 .env 文件，填入您自己的值。  

创建数据文件夹并设置正确权限：  

```bash  
mkdir -p ./nodebb-data  
mkdir -p ./nodebb-files  
mkdir -p ./nodebb-config  

chmod 777 ./nodebb-data  
chmod 777 ./nodebb-files  
chmod 777 ./nodebb-config  
```  

运行项目：  

```bash  
docker-compose up -d  
```  

您可通过 `[] 访问 Web 界面。  


### Docker Compose 配置  

以下是启动容器的示例配置片段：  

```yaml  
version: "3.3"  
services:  
  nodebb:  
    image: docker.xuanyuan.run/elestio/nodebb:latest  
    restart: always  
    environment:  
      URL: "[]}"  
      DATABASE: "redis"  
      DB_NAME: "0"  
      DB_HOST: "redis"  
      DB_PORT: "8443"  
    volumes:  
      - ./nodebb-files:/usr/src/app/public/uploads  
      # - ./nodebb-config/config.json:/usr/src/app/config.json  
      - ./entrypoint.sh:/usr/src/app/entrypoint.sh  
    ports:  
      - "172.17.0.1:4567:4567"  

  redis:  
    image: docker.xuanyuan.run/redis  
    restart: always  
    command: redis-server --requirepass ${REDIS_PASSWORD}  
    volumes:  
      - ./nodebb-data:/data  
    ports:  
      - "172.17.0.1:6379:6379"  
```  


#### 环境变量  

| 变量名               | 示例值          |  
|----------------------|-----------------|  
| SOFTWARE_VERSION_TAG | latest          |  
| DOMAIN               | your.domain     |  
| REDIS_PASSWORD       | your-password   |  


## 维护  

### 日志查看  

Elestio NodeBB Docker 镜像将容器日志输出到 stdout。可通过以下命令查看日志：  

```bash  
docker-compose logs -f  
```  

停止服务栈：  

```bash  
docker-compose down  
```  


### 备份与恢复（基于 Docker Compose）  

为简化备份和恢复操作，我们使用文件夹卷挂载。您只需执行以下步骤：  

1. **停止服务栈**：  
   ```bash  
   docker-compose down  
   ```  

2. **创建 ZIP 备份**：  
   进入 docker-compose.yml 所在目录，执行：  
   ```bash  
   zip -r myarchive.zip .  
   ```  

3. **从 ZIP 恢复**：  
   将备份文件解压到原目录：  
   ```bash  
   unzip myarchive.zip -d /path/to/original/folder  
   ```  

4. **启动服务栈**：  
   ```bash  
   docker-compose up -d  
   ```  


## 相关链接  

- [NodeBB 官方文档]   
- [NodeBB GitHub 仓库]   
- [Elestio/nodebb GitHub 仓库]   


[![]()]( "通过聊天功能获取即时帮助，与社区和团队进行实时讨论。")  
[![Elestio examples] ]([] "查看所有仓库的源代码。")  
[![Blog] ]([] "关于 elestio、开源软件和 DevOps 技术的最新资讯。")
