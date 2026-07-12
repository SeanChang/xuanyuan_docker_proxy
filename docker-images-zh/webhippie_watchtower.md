---
image: webhippie/watchtower
description: "Watchtower的Docker镜像，用于自动监控Docker容器镜像更新，支持定时检查、自动拉取新镜像并重启容器，基于Alpine Linux构建，提供丰富的配置选项。"
source: https://xuanyuan.cloud/zh/r/webhippie/watchtower
canonical: https://xuanyuan.cloud/zh/r/webhippie/watchtower
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/webhippie/watchtower" title="webhippie/watchtower Docker 镜像中文简介、标签列表与拉取命令">webhippie/watchtower 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# watchtower

基于Alpine Linux构建的Watchtower Docker镜像，用于自动监控和更新Docker容器。Watchtower能够定期检查容器镜像的更新，自动拉取新镜像并重启容器，简化容器的维护流程。

## 版本

可用版本请查看 [Docker Hub][dockerhub]、[Quay][quayio] 或 [GitHub仓库][github] 中的相关文件夹。

## 卷

*  无

## 端口

*  无

## 可用环境变量

```console
DOCKER_API_VERSION = 1.24
WATCHTOWER_CLEANUP = false
WATCHTOWER_DEBUG = false
WATCHTOWER_ENABLE_LIFECYCLE_HOOKS = false
WATCHTOWER_HOST = unix:///var/run/docker.sock
WATCHTOWER_HTTP_API_METRICS = false
WATCHTOWER_HTTP_API_PERIODIC_POLLS = false
WATCHTOWER_HTTP_API_TOKEN =
WATCHTOWER_HTTP_API_UPDATE = false
WATCHTOWER_INCLUDE_RESTARTING = false
WATCHTOWER_INCLUDE_STOPPED = false
WATCHTOWER_INTERVAL = 300
WATCHTOWER_LABEL_ENABLE = false
WATCHTOWER_MONITOR_ONLY = false
WATCHTOWER_NO_COLOR = false
WATCHTOWER_NO_PULL = false
WATCHTOWER_NO_RESTART = false
WATCHTOWER_NO_STARTUP_MESSAGE = false
WATCHTOWER_OPTS =
WATCHTOWER_REMOVE_VOLUMES = false
WATCHTOWER_REVIVE_STOPPED = false
WATCHTOWER_ROLLING_RESTART = false
WATCHTOWER_RUN_ONCE = false
WATCHTOWER_SCHEDULE =
WATCHTOWER_SCOPE =
WATCHTOWER_STOP_TIMEOUT =
WATCHTOWER_TLS_VERIFY = false
WATCHTOWER_TRACE = false
WATCHTOWER_WARN_ON_HEAD_FAILURE =
```

### 环境变量说明

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| `DOCKER_API_VERSION` | 1.24 | Docker API 版本 |
| `WATCHTOWER_CLEANUP` | false | 是否清理旧镜像 |
| `WATCHTOWER_DEBUG` | false | 是否启用调试模式 |
| `WATCHTOWER_ENABLE_LIFECYCLE_HOOKS` | false | 是否启用生命周期钩子 |
| `WATCHTOWER_HOST` | unix:///var/run/docker.sock | Docker 守护进程地址 |
| `WATCHTOWER_INTERVAL` | 300 | 检查间隔（秒），默认5分钟 |
| `WATCHTOWER_LABEL_ENABLE` | false | 是否通过标签控制容器更新 |
| `WATCHTOWER_MONITOR_ONLY` | false | 是否仅监控不执行更新 |
| `WATCHTOWER_RUN_ONCE` | false | 是否仅运行一次检查后退出 |
| `WATCHTOWER_SCHEDULE` |  | cron 表达式，用于定时检查（如 "0 0 * * *" 每天午夜） |

## 继承的环境变量

*  [webhippie/alpine](https://github.com/dockhippie/alpine#available-environment-variables)

## 使用示例

### Docker Run 命令

```bash
docker run -d \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e WATCHTOWER_INTERVAL=600 \  # 10分钟检查一次
  -e WATCHTOWER_CLEANUP=true \   # 清理旧镜像
  -e WATCHTOWER_LABEL_ENABLE=true \  # 通过标签控制更新
  webhippie/watchtower
```

### Docker Compose 配置

```yaml
version: '3'
services:
  watchtower:
    image: docker.xuanyuan.run/webhippie/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_SCHEDULE=0 3 * * *  # 每天凌晨3点检查
      - WATCHTOWER_DEBUG=true
      - WATCHTOWER_NO_RESTART=false  # 更新后重启容器
    restart: unless-stopped
```

## 核心功能与特性

- **自动更新**：定期检查容器镜像更新，自动拉取并重启容器
- **灵活调度**：支持固定间隔或cron表达式定时检查
- **选择性更新**：通过标签控制特定容器的更新行为
- **清理功能**：可自动清理更新后遗留的旧镜像
- **监控模式**：支持仅监控不执行更新的模式
- **生命周期钩子**：可选启用容器的生命周期钩子（需配置`WATCHTOWER_ENABLE_LIFECYCLE_HOOKS`）

## 使用场景

- 开发环境中自动更新依赖服务
- 小型生产环境中简化容器维护
- 需要定期更新的无状态服务
- 希望减少手动更新操作的场景

## 贡献

Fork -> Patch -> Push -> Pull Request

## 作者

*  [Thomas Boerger](https://github.com/tboerger)

## 许可证

MIT

## 版权

```console
Copyright (c) 2015 Thomas Boerger <http://www.webhippie.de>
```

[upstream]: https://github.com/containrrr/watchtower
[parent]: https://github.com/dockhippie/alpine
[dockerhub]: https://hub.docker.com/r/webhippie/watchtower/tags
[quayio]: https://quay.io/repository/webhippie/watchtower?tab=tags
[github]: https://github.com/dockhippie/watchtower
