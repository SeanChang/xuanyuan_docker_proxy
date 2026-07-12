---
image: b4tman/squid
description: "基于Alpine Linux的Squid容器"
source: https://xuanyuan.cloud/zh/r/b4tman/squid
canonical: https://xuanyuan.cloud/zh/r/b4tman/squid
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/b4tman/squid" title="b4tman/squid Docker 镜像中文简介、标签列表与拉取命令">b4tman/squid 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-squid

基于Alpine Linux的Squid容器。

自动化构建的镜像可在以下仓库获取：

- DockerHub:
  - [b4tman/squid](https://hub.docker.com/r/b4tman/squid)
- Github:
  - [ghcr.io/b4tman/squid](https://github.com/users/b4tman/packages/container/package/squid)
  - [ghcr.io/b4tman/squid-armhf](https://github.com/users/b4tman/packages/container/package/squid-armhf)
  - [ghcr.io/b4tman/squid-ssl-bump](https://github.com/users/b4tman/packages/container/package/squid-ssl-bump)

# 快速启动

直接启动容器：

```bash
docker run -p 3128:3128 docker.xuanyuan.run/b4tman/squid
```

或使用 [docker-compose](https://docs.docker.com/compose/)：

```bash
wget https://raw.githubusercontent.com/b4tman/docker-squid/master/docker-compose.yml
docker-compose up
```

# 配置

## 环境变量：

- **SQUID_CONFIG_FILE**：指定Squid的配置文件路径。默认为 `/etc/squid/squid.conf`。

## 示例：

```bash
docker run -p 3128:3128 \
	--env='SQUID_CONFIG_FILE=/etc/squid/my-squid.conf' \
	--volume=/srv/docker/squid/squid.conf:/etc/squid/my-squid.conf:ro \
	docker.xuanyuan.run/b4tman/squid
```

此命令将启动一个使用自定义配置文件 `/srv/docker/squid/squid.conf` 的Squid容器。
