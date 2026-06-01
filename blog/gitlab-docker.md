# Docker 部署 GitLab CE 完整版教程

![Docker 部署 GitLab CE 完整版教程](https://img.xuanyuan.dev/docker/blog/docker-gitlab.png)

*分类: Docker,GITLAB | 标签: gitlab,docker,部署教程 | 发布时间: 2025-12-03 07:44:58*

> GitLab Community Edition（简称GITLAB-CE）是一款开源的DevOps平台，集成了代码仓库管理、版本控制、 issue 跟踪、CI/CD 流水线、Wiki 和容器仓库等功能，为软件开发团队提供一站式的协作解决方案。通过Docker容器化部署GITLAB-CE，可大幅简化安装流程、提高环境一致性，并便于快速扩展和迁移。本文将详细介绍如何通过Docker快速部署GITLAB-CE，并提供生产环境优化建议及故障排查方案。

## 概述
GitLab Community Edition（GitLab CE）是开源一站式 DevOps 平台，集成代码托管、版本控制、Issue 管理、CI/CD 流水线、Wiki、容器仓库等核心功能。
使用 **Docker 容器化部署** 可大幅简化安装、保证环境一致性、方便迁移与升级，是个人/企业快速搭建代码托管平台的最优方案。

本文包含：**一键部署、持久化配置、登录使用、生产环境加固、高频故障排查**，全程可直接复制命令执行。

---

## 一、环境准备
### 1.1 安装 Docker（一键脚本，支持 Ubuntu/CentOS）
```bash
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

安装完成验证：
```bash
docker --version
docker compose version
systemctl status docker
```

### 1.2 服务器最低要求（必看）
- CPU：≥2核
- 内存：**≥4GB**（低于 2GB 绝对无法启动）
- 存储：SSD ≥20GB

---

## 二、拉取 GitLab CE 镜像
### 2.1 拉取稳定版（推荐固定版本，避免 latest 自动更新）
```bash
# 推荐稳定版
docker pull gitlab/gitlab-ce:19.0.1-ce.0

# 如需使用国内加速镜像
# docker pull xxx.xuanyuan.run/gitlab/gitlab-ce:19.0.1-ce.0
```

### 2.2 验证镜像
```bash
docker images | grep gitlab-ce
```

---

## 三、容器部署（最关键步骤）
### 3.1 创建持久化目录（数据不丢失）
```bash
sudo mkdir -p /data/gitlab/{config,logs,data}
```

### 3.2 启动 GitLab 容器（标准生产命令）
**如果之前运行失败、创建过旧容器，必须先删除：**
```bash
docker rm -f gitlab
```

**正式启动命令：**
```bash
docker run -d \
  --hostname gitlab.example.com \
  --publish 80:80 \
  --publish 443:443 \
  --publish 2222:22 \
  --name gitlab \
  --restart always \
  --volume /data/gitlab/config:/etc/gitlab \
  --volume /data/gitlab/logs:/var/log/gitlab \
  --volume /data/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:19.0.1-ce.0
```

### 3.3 端口说明
- 80：Web 访问端口
- 443：HTTPS 端口
- 2222：Git SSH 克隆端口（避免与主机 22 冲突）

---

## 四、启动状态检查
### 4.1 查看容器是否运行
```bash
docker ps
```
看到 `gitlab` 状态为 `Up` 即运行正常。

### 4.2 实时查看初始化日志（必看）
```bash
docker logs -f gitlab
```

**出现以下任意一行，代表启动完成：**
- `gitlab Reconfigured!`
- `Puma starting`

**首次启动非常慢**（小内存机器可能需要 5~10 分钟），耐心等待！

---

## 五、登录 GitLab Web 界面
### 5.1 访问地址
```
http://你的服务器IP
```

### 5.2 获取默认管理员密码（自动生成）
```bash
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

### 5.3 登录信息
- 用户名：`root`
- 密码：上面命令输出的字符串

![gitlab 登录页](https://img.xuanyuan.dev/docker/blog/docker-gitlab-1.png)

### 5.4 登录后必须做
1. 修改 root 密码
2. 关闭用户注册（后台 → 设置 → 通用）
3. 配置外部访问 URL
4. 配置邮件服务

![gitlab 主页](https://img.xuanyuan.dev/docker/blog/docker-gitlab-2.png)

---

## 六、Git 使用示例（克隆/提交）
由于 SSH 端口改为 **2222**，克隆命令格式如下：
```bash
git clone ssh://git@服务器IP:2222/root/demo.git
```

HTTP 方式：
```bash
git clone http://服务器IP/root/demo.git
```

---

## 七、生产环境优化建议
### 7.1 服务器资源
- 内存 ≥8GB
- CPU ≥4核
- SSD 存储

### 7.2 防火墙放行（Ubuntu/Debian）
```bash
ufw allow 80
ufw allow 443
ufw allow 2222
ufw reload
```

### 7.3 云服务器安全组（阿里云/腾讯云/华为云）
必须开放以下端口：
- 80
- 443
- 2222

### 7.4 数据备份
```bash
# 手动备份
docker exec -it gitlab gitlab-backup create

# 自动备份（配置 gitlab.rb 开启）
```

---

## 八、高频故障排查（最实用）
### 问题 1：浏览器提示 **ERR_CONNECTION_REFUSED**（拒绝连接）
**原因 99% 是以下之一：**
1. GitLab 还没初始化完成
2. 80 端口未监听成功
3. 服务器防火墙没放行
4. 云服务器安全组未开放端口

**排查命令：**
```bash
# 查看 80 端口是否监听
ss -lntp | grep :80

# 查看最后 50 行日志
docker logs gitlab --tail 50
```

### 问题 2：找不到 initial_root_password 文件
说明：**GitLab 未初始化完成**
解决：继续等待，直到日志出现 `Reconfigured`。

### 问题 3：容器反复重启
原因：**内存不足**
解决：升级服务器内存 ≥4GB。

### 问题 4：Web 打开 502
原因：GitLab 还在启动中 / 资源占用过高
解决：等待 3~5 分钟即可。

---

## 九、常用管理命令
```bash
# 重启 GitLab
docker restart gitlab

# 停止 GitLab
docker stop gitlab

# 删除容器（保留数据）
docker rm -f gitlab

# 查看实时日志
docker logs -f gitlab
```

---

## 总结（核心要点）
1. **第一次启动极慢**，必须等日志出现 `Reconfigured` 才能访问
2. **管理员账号固定为 root**，密码自动生成
3. **80/443/2222** 三个端口必须放行
4. 数据目录在 `/data/gitlab`，删除容器不会丢失数据
5. 内存 <4GB 基本无法正常运行

