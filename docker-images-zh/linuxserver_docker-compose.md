<!-- xuanyuan-docker-images-zh
image: linuxserver/docker-compose
source: https://xuanyuan.cloud/zh/r/linuxserver/docker-compose
canonical: https://xuanyuan.cloud/zh/r/linuxserver/docker-compose
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/docker-compose" title="linuxserver/docker-compose Docker 镜像中文简介、标签列表与拉取命令">linuxserver/docker-compose — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/linuxserver/docker-compose" title="linuxserver/docker-compose Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/docker-compose</a></p>

# 弃用通知

该镜像已停止维护。我们不再提供技术支持，也不会推送更新。  
Docker Compose 现已可通过 Docker 官方仓库获取：  
[[]]([])  
也可直接下载：  
[[]]([])  


## 关于 LinuxServer.io 团队

LinuxServer.io 团队发布的容器具有以下特点：  
- 应用更新定期且及时  
- 支持简单的用户权限映射（PGID、PUID）  
- 基于 s6 overlay 的自定义基础镜像  
- 每周更新基础系统，通过统一底层依赖减少存储空间占用、 downtime 和带宽消耗  
- 定期推送安全更新  


## linuxserver/docker-compose 镜像说明

[docker-compose]([]) 是一款用于定义和运行多容器 Docker 应用的工具。通过 Compose 文件配置应用服务后，可一键创建并启动所有服务。


### 支持的架构

通过 Docker manifest 实现多平台适配，拉取 `lscr.io/linuxserver/docker-compose:latest` 即可自动匹配对应架构。也可通过标签指定具体架构：  

| 架构   | 是否支持 | 标签格式              |
| :----- | :------- | :-------------------- |
| x86-64 | ✅        | amd64-\<版本标签\>    |
| arm64  | ✅        | arm64v8-\<版本标签\>  |
| armhf  | ✅        | arm32v7-\<版本标签\>  |


### 版本标签

镜像提供多个版本标签，使用时请注意区分稳定性：  

| 标签    | 是否支持 | 说明                          |
| :------ | :------- | :---------------------------- |
| latest  | ✅        | docker-compose v1 稳定版      |
| alpine  | ✅        | 基于 alpine 基础镜像的 v1 版  |
| v2      | ✅        | docker compose v2 稳定版      |


## 使用方法

### 直接通过 Docker 命令运行

```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD:$PWD" \
  -w="$PWD" \
  lscr.io/linuxserver/docker-compose:latest \
  up
```
可将最后一行的 `up` 替换为任意 docker-compose 命令及参数（如 `down`、`ps` 等）。


### 推荐：通过脚本实现“原生”使用体验

我们提供了便捷脚本，可让 docker-compose 容器像本地安装一样运行：  

```bash
# 下载脚本并保存到 /usr/local/bin/docker-compose
sudo curl -L --fail [] -o /usr/local/bin/docker-compose

# 赋予执行权限
sudo chmod +x /usr/local/bin/docker-compose
```
安装后即可直接使用 `docker-compose up -d` 等命令，容器会在后台自动运行。


## 支持与维护

### 基础支持操作

- 容器运行中进入 shell：`docker exec -it docker-compose /bin/bash`  
- 实时查看日志：`docker logs -f docker-compose`  
- 查看容器版本：`docker inspect -f '{{ index .Config.Labels "build_version" }}' docker-compose`  
- 查看镜像版本：`docker inspect -f '{{ index .Config.Labels "build_version" }}' lscr.io/linuxserver/docker-compose:latest`  


### 更新镜像

1. 拉取最新镜像：  
   `docker pull lscr.io/linuxserver/docker-compose:latest`  

2. 清理旧镜像（可选）：  
   `docker image prune`  


### 本地构建

如需修改镜像代码或自定义构建：  

```bash
# 克隆仓库
git clone [] docker-docker-compose

# 构建镜像
docker build \
  --no-cache \
  --pull \
  -t lscr.io/linuxserver/docker-compose:latest .
```

**构建 ARM 版本**（需在 x86_64 设备上先注册 qemu）：  
```bash
# 注册 qemu 以支持多架构构建
docker run --rm --privileged multiarch/qemu-user-static:register --reset

# 构建指定架构（如 arm64）
docker build -f Dockerfile.aarch64 -t lscr.io/linuxserver/docker-compose:arm64v8-latest .
```


## 版本历史

- **2023.02.16**：镜像弃用  
- **2022.03.15**：新增 v2 分支，master 分支仅保留 v1 版本，alpine 分支基于 3.15 构建  
- **2020.12.17**：优化 run.sh 脚本格式  
- **2020.07.01**：发布 alpine 基础镜像版本（标签 `alpine`）  
- **2020.05.19**：初始发布  


> 注：如需获取 LinuxServer.io 团队更多支持，可访问其 [博客]([])、[]() 或 [GitHub]([])。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/linuxserver/docker-compose" title="linuxserver/docker-compose Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/linuxserver/docker-compose</a></p>
