<!-- xuanyuan-docker-images-zh
image: joxit/docker-registry-ui
source: https://xuanyuan.cloud/zh/r/joxit/docker-registry-ui
canonical: https://xuanyuan.cloud/zh/r/joxit/docker-registry-ui
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [joxit/docker-registry-ui — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/joxit/docker-registry-ui "joxit/docker-registry-ui Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/joxit/docker-registry-ui

# Docker Registry 用户界面

[![Stars]([])]([])
[![Pulls]([])]([])
[![Sponsor]([])]([])
[![Artifact Hub]([])]([])
[![Version]([])]([])


## 概述

本项目旨在为私有 Docker 镜像仓库提供简洁完整的用户界面，支持多种自定义配置，核心选项 `SINGLE_REGISTRY` 可禁用镜像仓库动态切换功能（与旧版 **static** 标签行为一致）。

若从 1.x 版本迁移至 2.x，可参考 [迁移指南]([])；1.x 版本说明见 [历史文档]([])。

界面基于类 React 微型库 [Riot]([]) 和组件库 [riot-mui]([]) 开发。如果觉得本项目有帮助，欢迎通过 [赞助]([]) 支持开发。


## 支持的 Docker 镜像标签

- `latest`：基于 `nginx:alpine` 的最新稳定版
- `latest-debian`：基于 `nginx:debian` 的最新稳定版
- `main`/`master`：基于 `nginx:alpine` 的 2.x 测试版（beta）
- `main-debian`/`master-debian`：基于 `nginx:debian` 的 2.x 测试版（beta）
- `2`：2.x 系列最新版本（包含最新小版本和补丁版本）
- `2.x`：2.x 系列指定主版本的最新版本（包含最新补丁版本）
- `2.x.y`：2.x.y 具体版本


## [项目页面]([]) | [在线演示]([]) | [使用示例]([]) | [Helm Chart]([])

![预览]([] "Docker Registry UI 预览")


## 隐藏功能

- **批量删除镜像**：
  - 通过复选框选择多个标签删除（1.2.0 起支持，详见 [#29]([])、[#79]([])）。
  - 按住 `ALT + 点击` 表头复选框，选中当前页所有标签（1.2.1 起支持，详见 [#80]([])、[#81]([])）。
  - 按住 `Shift + 点击` 起始标签，再 `Shift + 点击` 结束标签，选中连续标签（2.4.0 起支持，详见 [#287]([])）。

- 鼠标悬停标签时显示 sha256 摘要。

- 标签列表支持数字排序（0.4.0 起支持，详见 [#45]([])、[#46]([])）。

- **共享界面**：当 `SINGLE_REGISTRY=false` 时，可通过公共演示页 + URL 参数共享（例如 `[] `Access-Control-Allow-Origin` 设为 `[] **搜索框快捷键**：按 `Ctrl + F` 或 `F3` 聚焦搜索框（2.1.0 起支持，详见 [#213]([])）。

- 历史页面支持多架构显示（1.5.0 起支持，详见 [#130]([])、[#134]([])）。

- 显示 Dockerfile 内容（2.4.0 起支持，详见 [#286]([])）。

- 缓存仓库请求（如 blobs 和含 `sha256:` 的 manifest）。


## 常见问题（FAQ）

- **`SINGLE_REGISTRY=false` 与 `true` 的区别？**  
  `false` 时界面顶部显示仓库切换菜单，支持动态添加/切换仓库；`true` 时仅显示单个仓库，无切换菜单。

- **删除所有标签后，镜像为何仍显示在界面？**  
  Docker 仓库的垃圾回收机制不会自动删除空镜像（无标签但有残留数据）。需手动删除仓库数据目录中的对应文件夹（详见 [#77]([])）。

- **界面显示的镜像大小与 `docker images` 不一致？**  
  界面显示的是镜像压缩后的大小，而非本地解压后的大小。

- **能否通过 HTTPS 访问界面？**  
  可以。需在前端部署反向代理（如 Nginx）处理 HTTPS 连接。

- **是否支持认证？**  
  仅支持基础认证（Basic Auth）。作为纯前端应用，依赖浏览器自带的认证窗口。

- **能否搭配非安全仓库（无 HTTPS）使用？**  
  可以，但需先配置 Docker 客户端（详见 [#76]([])）。

- **"Mixed Content" 错误是什么？**  
  表示界面使用 HTTPS 但仓库使用 HTTP（非加密）。HTTPS 页面无法加载 HTTP 资源，需将仓库升级为 HTTPS。

- **为何 Nginx 默认 `Host` 设为 `$http_host`？**  
  用于解决 [#88]([]) 问题，详见 [#113]([])。

- **使用 Basic Auth 时，OPTIONS（预检请求）和 DELETE 请求返回 401 错误？**  
  Docker 仓库存在 bug，预检请求会返回 401，违反 [W3C 预检请求规范]([])，且官方已明确不会修复（[distribution/distribution#4458]([])）。解决方案：将界面与仓库部署在同一域名下（如 `registry.example.com/ui/`），或使用 `NGINX_PROXY_PASS_URL`，或在仓库前端部署反向代理（Nginx/Apache）并对 OPTIONS 请求返回 200。

- **能否通过 Electron 作为独立应用运行？**  
  可以，示例见 [此处]([])（详见 [#129]([])）。

- **通过界面删除镜像后，服务器上仍存在？**  
  界面仅删除标签引用，需运行仓库垃圾回收命令清理残留数据：`registry garbage-collect config.yml` 或 `docker exec registry registry garbage-collect config.yml`（详见 [#77]([])、[#147]([])）。

- **删除一个标签后，相同 SHA 的所有标签都被删除？**  
  Docker 仓库 API 限制：删除标签需通过 `name` 和 `manifest`（内容 SHA），因此相同 SHA 的标签会被批量删除。

- **能否以非特权用户运行容器？**  
  可以，使用 `--user nginx` 以 `nginx` 用户运行，此时监听端口自动改为 8080（详见 [#224]([])、[#234]([])）。

- **更多问题**：可参考 [使用示例]([]) 或提交 Issue。


## 配置选项

以下环境变量用于自定义界面行为（当 `SINGLE_REGISTRY=true` 时，部分选项仅对单仓库模式生效）：

| 变量名                  | 说明                                                                 | 默认值                                  | 版本要求       |
|-------------------------|----------------------------------------------------------------------|-----------------------------------------|----------------|
| `REGISTRY_URL`          | 仓库地址（需配置 CORS），如 `[]            | 从界面域名推导                          | -              |
| `REGISTRY_TITLE`        | 界面标题                                                             | 从 `REGISTRY_URL` 推导                  | 0.3.4+         |
| `PULL_URL`              | `docker pull` 命令中显示的仓库地址                                   | 同 `REGISTRY_URL`                       | 1.1.0+         |
| `DELETE_IMAGES`         | 是否允许删除镜像（`true`/`false`）                                   | `false`                                 | -              |
| `SHOW_CONTENT_DIGEST`   | 是否显示标签的 content digest（sha256）                              | `false`                                 | 1.4.9+         |
| `CATALOG_ELEMENTS_LIMIT`| 目录页最多显示的镜像数量                                             | `1000`                                  | 1.4.9+         |
| `SINGLE_REGISTRY`       | 是否禁用仓库切换菜单（`true`/`false`）                               | `false`                                 | 2.0.0+         |
| `NGINX_PROXY_PASS_URL`  | 代理仓库地址（如 `[] CORS 问题         | -                                       | 2.0.0+         |
| `NGINX_LISTEN_PORT`     | 监听端口（root 用户默认 80，非 root 用户默认 8080）                  | `80`/`8080`                             | 2.2.0+         |
| `DEFAULT_REGISTRIES`    | 初始仓库列表（逗号分隔，`SINGLE_REGISTRY=false` 时生效）              | -                                       | 2.1.0+         |
| `READ_ONLY_REGISTRIES`  | 是否禁止添加/删除仓库（`SINGLE_REGISTRY=false` 时生效）              | `false`                                 | 2.1.0+         |
| `THEME`                 | 主题（`light`/`dark`/`auto`）                                        | `auto`                                  | 2.4.0+         |
| `TAGLIST_ORDER`         | 标签排序规则（如 `alpha-asc;num-desc`）                              | `alpha-asc;num-desc`                    | 2.5.0+         |


### 主题自定义（2.4.0+）

通过 `THEME_*` 环境变量自定义主题颜色，支持以下参数（示例值为默认的亮色/暗色主题配置）：

| 变量名                     | 亮色主题值    | 暗色主题值    |
|----------------------------|---------------|---------------|
| `THEME_PRIMARY_TEXT`       | `#25313b`     | `#98a8bd`     |
| `THEME_BACKGROUND`         | `#ffffff`     | `#22272e`     |
| `THEME_HEADER_BACKGROUND`  | `#25313b`     | `#333a45`     |


## 推荐部署方式（docker-compose）

以下示例通过 docker-compose 部署界面和仓库，两者共享同一域名以规避 CORS 问题：

```yaml
version: '3.8'

services:
  registry-ui:
    image: joxit/docker-registry-ui:main
    restart: always
    ports:
      - 80:80
    environment:
      - SINGLE_REGISTRY=true                   # 单仓库模式
      - REGISTRY_TITLE=Docker Registry UI      # 界面标题
      - DELETE_IMAGES=true                     # 允许删除镜像
      - NGINX_PROXY_PASS_URL=[]  # 代理仓库地址
      - SHOW_CATALOG_NB_TAGS=true              # 显示每个镜像的标签数量
    container_name: registry-ui

  registry-server:
    image: registry:2.8.2
    restart: always
    environment:
      # 配置 CORS，允许界面域名访问
      REGISTRY_HTTP_HEADERS_Access-Control-Allow-Origin: '[[]]'
      REGISTRY_HTTP_HEADERS_Access-Control-Allow-Methods: '[HEAD,GET,OPTIONS,DELETE]'
      REGISTRY_HTTP_HEADERS_Access-Control-Allow-Credentials: '[true]'
      REGISTRY_HTTP_HEADERS_Access-Control-Allow-Headers: '[Authorization,Accept,Cache-Control]'
      REGISTRY_STORAGE_DELETE_ENABLED: 'true'  # 允许删除镜像
    volumes:
      - ./registry/data:/var/lib/registry      # 挂载仓库数据目录
    container_name: registry-server
```


## 配置 CORS

仓库需开启 CORS 以允许界面访问，配置方式如下：

- **无需认证的仓库**：  
  ```yaml
  http:
    headers:
      Access-Control-Allow-Origin: ['*']  # 允许所有域名
  ```

- **需要认证的仓库**：  
  ```yaml
  http:
    headers:
      Access-Control-Allow-Origin: ['[]']  # 界面域名（含协议和端口）
      Access-Control-Allow-Credentials: [true]
      Access-Control-Allow-Headers: ['Authorization', 'Accept', 'Cache-Control']
  ```

> 若仍有 CORS 问题，可尝试浏览器插件临时绕过（详见 [#25]([])）。


## 启用删除功能

需同时配置界面和仓库：

1. **界面**：设置 `DELETE_IMAGES=true`。  
2. **仓库**：启用删除功能并允许 DELETE 方法：  
   ```yaml
   storage:
     delete:
       enabled: true  # 允许删除镜像
   http:
     headers:
       Access-Control-Allow-Methods: ['HEAD', 'GET', 'OPTIONS', 'DELETE']  # 允许 DELETE 方法
       Access-Control-Expose-Headers: ['Docker-Content-Digest']  # 暴露 digest 用于删除
   ```


## 更多示例

- [将界面作为代理使用]([])  
- [独立部署界面]([])  
- [搭配 Traefik 使用]([])  
- [S3 存储后端配置]([])  
- [HTTPS 配置]([])  
- [Electron 独立应用]([])
