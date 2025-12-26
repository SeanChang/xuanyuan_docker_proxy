# Docker 部署银河麒麟（Kylin Linux）全流程教程

![Docker 部署银河麒麟（Kylin Linux）全流程教程](https://img.xuanyuan.dev/docker/blog/docker-kylin-linux.png)

*分类: Docker,Kylin | 标签: kylin,docker,部署教程 | 发布时间: 2025-10-27 03:51:37*

> 银河麒麟高级服务器操作系统V10是国产自主可控的企业级系统，自带安全增强机制，专为关键行业（政务、金融、能源等）定制，适配国产化硬件与软件生态。通过Docker部署，能把“国产化适配+安全稳定”的优势与容器化的“环境一致、轻量高效”结合，彻底解决传统国产化部署中“环境适配繁琐、迁移难、版本管理乱”的痛点。

银河麒麟高级服务器操作系统V10作为国产自主可控的企业级系统，在政务、金融等关键行业应用广泛。通过Docker部署，既能保留其安全增强、国产化生态适配的优势，又能解决传统部署中环境不一致、迁移繁琐的问题。下面按实际运维场景，从环境准备到验证落地，一步步讲清部署全流程。


## 核心价值与部署优势
### 银河麒麟的核心竞争力
- **自主可控与安全加固**：基于自研软件源构建，集成强制访问控制、安全审计等机制，符合等保2.0要求，适合处理敏感数据。
- **版本迭代适配需求**：提供V10-SP1/SP2/SP3及SP3-2403更新版，SP3系列对国产硬件（鲲鹏、飞腾）和软件（达梦、金仓数据库）兼容性更优。
- **双架构支持**：同时适配amd64（x86服务器）和arm64（国产CPU），无需二次编译即可部署国产化应用。

### Docker部署的实际价值
- **环境一致性**：镜像打包完整依赖，开发、测试、生产环境完全一致，避免“国产化软件在本地跑通，线上报错”。
- **轻量高效**：镜像体积仅200MB左右，启动耗时3秒内，比虚拟机节省80%内存，适合国产化服务器高密度部署。
- **版本隔离**：可同时运行SP2和SP3容器，分别适配新旧国产软件，互不干扰。


## 准备工作：安装Docker环境
部署前需确保服务器已安装Docker，推荐用轩辕镜像提供的一键脚本，自动配置加速源：

```bash
# 一键安装Docker及Docker Compose（支持银河麒麟、CentOS等系统）
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成后验证：
```bash
docker --version && docker compose --version
```
输出类似以下内容即成功（版本号可能不同）：
```
Docker version 27.0.3, build 7d4bcd8
Docker Compose version v2.20.2
```


## 拉取银河麒麟镜像
银河麒麟镜像无`latest`标签，需指定具体版本（SP1/SP2/SP3等），且需匹配服务器架构（amd64/arm64）。

### 1. 镜像信息查询
先确认所需版本和架构，参考轩辕镜像平台的标签列表：
👉 [轩辕镜像银河麒麟页面](https://xuanyuan.cloud/r/macrosan/kylin)

常用标签说明：
- `v10-sp3-2403`：最新更新版，安全补丁全，推荐新项目
- `v10-sp3`：基础稳定版，兼容性广
- `v10-sp2`：适配旧国产软件，适合遗留项目

### 2. 拉取方式
#### 场景1：新手快速拉取（默认架构）
直接拉取最新稳定版（SP3-2403），自动匹配服务器架构：
```bash
docker pull macrosan/kylin:v10-sp3-2403
```

#### 场景2：指定架构拉取（关键！）
国产CPU服务器（如鲲鹏、飞腾，arm64架构）需明确指定：
```bash
# arm64架构（国产CPU）
docker pull --platform=linux/arm64 macrosan/kylin:v10-sp3-2403

# amd64架构（x86服务器）
docker pull --platform=linux/amd64 macrosan/kylin:v10-sp3-2403
```

#### 场景3：使用轩辕镜像访问支持（推荐国内服务器）
通过轩辕镜像拉取，访问表现更快：
```bash
# 加速拉取SP3版本（替换为轩辕镜像地址）
docker pull xxx.xuanyuan.run/macrosan/kylin:v10-sp3
```

#### 场景4：拉取后重命名（简化命令）
若标签较长，可重命名方便后续使用：
```bash
docker tag macrosan/kylin:v10-sp3-2403 kylin:latest
```

### 3. 验证拉取结果
```bash
docker images | grep kylin
```
输出类似以下内容即成功：
```
REPOSITORY          TAG           IMAGE ID       CREATED        SIZE
macrosan/kylin      v10-sp3-2403  d8f7e6a5b3c2   1个月前        210MB
```


## 部署实战：三种场景方案
### 1. 快速测试：临时验证环境
适合测试国产软件依赖、熟悉系统命令，启动交互式容器：
```bash
# 启动并进入容器（指定架构加--platform参数）
docker run -it --name kylin-test macrosan/kylin:v10-sp3-2403 /bin/bash
```

进入后可执行以下命令验证：
```bash
# 查看系统版本
cat /etc/.productinfo

# 安装基础工具
yum install -y vim wget

# 退出容器：Ctrl+P+Q（保留容器）或exit（停止容器）
```

### 2. 生产部署：数据持久化挂载
通过目录挂载确保数据不丢失，适合部署国产数据库、中间件：

#### 步骤1：创建宿主机目录
```bash
mkdir -p /data/kylin/{data,conf,logs}
chmod -R 777 /data/kylin  # 授权避免权限问题
```

#### 步骤2：启动容器并挂载
```bash
docker run -d --name kylin-prod \
  -p 2222:22 \  # 映射SSH端口
  -p 5432:5432 \  # 国产数据库端口
  -v /data/kylin/data:/var/data \  # 业务数据
  -v /data/kylin/conf:/etc/custom \  # 配置文件
  -v /data/kylin/logs:/var/log/custom \  # 日志
  -e TZ=Asia/Shanghai \  # 设时区
  --platform=linux/arm64 \  # 按服务器架构调整
  macrosan/kylin:v10-sp3-2403 \
  /bin/bash -c "yum install -y crontabs && crond -n"  # 后台运行命令
```

进入运行中的容器：
```bash
docker exec -it kylin-prod /bin/bash
```

### 3. 批量管理：Docker Compose部署
适合多服务组合（如麒麟+达梦数据库），通过配置文件统一管理：

#### 步骤1：创建docker-compose.yml
```yaml
version: '3.8'
services:
  kylin:
    image: macrosan/kylin:v10-sp3-2403
    container_name: kylin-service
    platform: linux/arm64  # 架构
    ports:
      - "2222:22"
      - "5432:5432"
    volumes:
      - ./data:/var/data
      - ./conf:/etc/custom
      - ./logs:/var/log/custom
    environment:
      - TZ=Asia/Shanghai
      - LANG=zh_CN.UTF-8
    restart: always
    command: /bin/bash -c "yum install -y openssh-server && /usr/sbin/sshd -D"
```

#### 步骤2：启动服务
```bash
mkdir -p /data/kylin-compose/{data,conf,logs}
cd /data/kylin-compose
docker compose up -d
```

常用管理命令：
```bash
docker compose ps  # 查看状态
docker compose logs -f  # 看日志
docker compose down  # 停止并删除容器
```


## 验证部署结果
### 1. 基础状态检查
```bash
# 查看容器是否运行
docker ps | grep kylin

# 查看资源占用
docker stats kylin-prod
```

### 2. 功能验证
```bash
# 进入容器
docker exec -it kylin-prod /bin/bash

# 安装国产软件依赖
yum install -y libaio-devel

# 测试挂载目录
echo "测试数据" > /var/data/test.txt
exit

# 宿主机查看文件（验证挂载生效）
cat /data/kylin/data/test.txt
```

### 3. 服务访问
若部署了Nginx，测试端口映射：
```bash
docker exec -it kylin-prod yum install -y nginx
docker exec -it kylin-prod systemctl start nginx
curl http://127.0.0.1:80  # 应返回Nginx页面
```


## 常见问题排查
### 1. 架构不匹配导致启动失败
**现象**：容器启动报错“exec format error”  
**解决**：拉取时指定正确架构，如arm64服务器用`--platform=linux/arm64`

### 2. yum安装软件提示“找不到包”
**解决**：切换国内源：
```bash
# 容器内执行
yum clean all && yum makecache
```

### 3. 挂载目录权限被拒绝
**解决**：宿主机授权或启动时加`--privileged`（临时测试用）：
```bash
chmod -R 777 /data/kylin
```

### 4. 容器启动后立即退出
**原因**：无后台进程  
**解决**：启动时指定循环命令：
```bash
docker run -d --name kylin-test macrosan/kylin:v10-sp3-2403 /bin/bash -c "while true; do sleep 3600; done"
```


## 结尾
通过以上步骤，可快速在Docker中部署银河麒麟系统，兼顾国产化需求与容器化优势。实际部署时需注意架构匹配和版本选择，SP3-2403版适合新项目，SP2版适合遗留系统迁移。

