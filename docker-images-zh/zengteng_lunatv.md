---
image: zengteng/lunatv
description: "基于 MoonTechLab/LunaTV 重新编译的影视聚合播放器 Docker 镜像，支持多源聚合搜索、在线播放、收藏与播放记录多端同步。上游官方镜像为 ghcr.io/moontechlab/lunatv，可通过轩辕镜像 GHCR 专属域加速拉取，完整拉取命令与部署说明见镜像详情页。需配合 Kvrocks、Redis 或 Upstash 存储，部署后不含内置播放源，需在管理后台自行配置。"
source: https://xuanyuan.cloud/zh/r/zengteng/lunatv
canonical: https://xuanyuan.cloud/zh/r/zengteng/lunatv
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zengteng/lunatv" title="zengteng/lunatv Docker 镜像中文简介、标签列表与拉取命令">zengteng/lunatv 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# LunaTV（MoonTV）影视聚合播放器

> 本镜像 `zengteng/lunatv` 基于开源项目 [MoonTechLab/LunaTV](https://github.com/MoonTechLab/LunaTV) 重新编译构建，提供开箱即用的 Docker 部署方式。

LunaTV（亦称 MoonTV）是一款跨平台影视聚合播放器，基于 **Next.js 14** + **Tailwind CSS** + **TypeScript** 构建，支持多资源搜索、在线播放、收藏同步、播放记录与云端存储，可在浏览器、PWA 及 Android TV 等场景使用。

## 镜像来源

| 镜像 | 说明 |
| --- | --- |
| `zengteng/lunatv` | 社区维护版本，基于上游最新源码重新编译 |
| `ghcr.io/moontechlab/lunatv` | **官方 GHCR 镜像**，由 MoonTechLab 项目发布 |

官方 GHCR 镜像可通过轩辕镜像加速拉取，镜像详情与拉取命令见：

**[https://xuanyuan.cloud/ghcr.io/moontechlab/lunatv?tag=latest](https://xuanyuan.cloud/ghcr.io/moontechlab/lunatv?tag=latest)**

> `***` 为轩辕镜像 **GHCR 专属域名前缀**，请在 [个人中心](https://xuanyuan.cloud/) 查看并替换。GHCR 镜像映射规则：`ghcr.io/moontechlab/lunatv` → `***-ghcr.xuanyuan.run/moontechlab/lunatv`。

拉取官方镜像（轩辕镜像）：

```bash
docker pull ***-ghcr.xuanyuan.run/moontechlab/lunatv:latest
```

拉取本镜像（轩辕镜像）：

```bash
docker pull docker.xuanyuan.run/r/zengteng/lunatv:latest
```

支持 `amd64` 与 `arm64` 架构。下文部署示例以 `zengteng/lunatv` 为例，使用官方镜像时将镜像地址替换为 `***-ghcr.xuanyuan.run/moontechlab/lunatv:latest` 即可。

## 功能特性

- **多源聚合搜索**：一次搜索返回多个资源站结果
- **丰富详情页**：剧集列表、演员、年份、简介等信息展示
- **流畅在线播放**：集成 HLS.js 与 ArtPlayer
- **收藏与继续观看**：支持 Kvrocks / Redis / Upstash 存储，多端同步进度
- **PWA 支持**：可安装到桌面或手机主屏
- **响应式布局**：桌面侧边栏 + 移动底部导航
- **智能去广告**：自动跳过视频切片广告（实验性）

> **重要提示**：部署完成后为空壳应用，**不包含内置播放源和直播源**，需在管理后台自行配置资源站。

## 技术栈

| 分类 | 主要依赖 |
| --- | --- |
| 前端框架 | Next.js 14（App Router） |
| UI 与样式 | Tailwind CSS 3 |
| 语言 | TypeScript |
| 播放器 | ArtPlayer、HLS.js |
| 部署 | Docker |

## 快速部署

### 方式一：Docker Compose + Kvrocks（推荐）

Kvrocks 提供持久化存储，适合收藏与播放记录长期保存。

创建 `docker-compose.yml`：

```yaml
services:
  lunatv-core:
    image: docker.xuanyuan.run/r/zengteng/lunatv:latest
    container_name: lunatv-core
    restart: on-failure
    ports:
      - '3000:3000'
    environment:
      - USERNAME=admin
      - PASSWORD=your_secure_password
      - NEXT_PUBLIC_STORAGE_TYPE=kvrocks
      - KVROCKS_URL=redis://lunatv-kvrocks:6666
      - NEXT_PUBLIC_SITE_NAME=LunaTV
      - NEXT_PUBLIC_DOUBAN_PROXY_TYPE=cmliussss-cdn-tencent
      - NEXT_PUBLIC_DOUBAN_IMAGE_PROXY_TYPE=cmliussss-cdn-tencent
    networks:
      - lunatv-network
    depends_on:
      - lunatv-kvrocks

  lunatv-kvrocks:
    image: docker.xuanyuan.run/r/apache/kvrocks
    container_name: lunatv-kvrocks
    restart: unless-stopped
    volumes:
      - kvrocks-data:/var/lib/kvrocks
    networks:
      - lunatv-network

networks:
  lunatv-network:
    driver: bridge

volumes:
  kvrocks-data:
```

启动服务：

```bash
docker compose up -d
```

浏览器访问：`http://localhost:3000`，使用环境变量中配置的 `USERNAME` / `PASSWORD` 登录管理后台。

### 方式二：Docker Compose + Redis

```yaml
services:
  lunatv-core:
    image: docker.xuanyuan.run/r/zengteng/lunatv:latest
    container_name: lunatv-core
    restart: on-failure
    ports:
      - '3000:3000'
    environment:
      - USERNAME=admin
      - PASSWORD=your_secure_password
      - NEXT_PUBLIC_STORAGE_TYPE=redis
      - REDIS_URL=redis://lunatv-redis:6379
    networks:
      - lunatv-network
    depends_on:
      - lunatv-redis

  lunatv-redis:
    image: docker.xuanyuan.run/r/library/redis:alpine
    container_name: lunatv-redis
    restart: unless-stopped
    volumes:
      - ./data:/data
    networks:
      - lunatv-network

networks:
  lunatv-network:
    driver: bridge
```

> 使用 Redis 时建议开启持久化卷，否则容器升级或重启可能导致数据丢失。

### 方式三：单容器运行（需外部 Redis / Kvrocks）

```bash
docker run -d \
  --name lunatv \
  -p 3000:3000 \
  -e USERNAME=admin \
  -e PASSWORD=your_secure_password \
  -e NEXT_PUBLIC_STORAGE_TYPE=redis \
  -e REDIS_URL=redis://your-redis-host:6379 \
  docker.xuanyuan.run/r/zengteng/lunatv:latest
```

### 方式四：Upstash 云存储

若使用 [Upstash](https://upstash.com/) Redis，只需部署应用容器：

```bash
docker run -d \
  --name lunatv \
  -p 3000:3000 \
  -e USERNAME=admin \
  -e PASSWORD=your_secure_password \
  -e NEXT_PUBLIC_STORAGE_TYPE=upstash \
  -e UPSTASH_URL=你的_HTTPS_ENDPOINT \
  -e UPSTASH_TOKEN=你的_TOKEN \
  docker.xuanyuan.run/r/zengteng/lunatv:latest
```

## 播放源配置

部署完成后，登录管理后台，在「配置文件」中填写 JSON 配置。示例：

```json
{
  "cache_time": 7200,
  "api_site": {
    "example": {
      "api": "http://example.com/api.php/provide/vod",
      "name": "示例资源站",
      "detail": "http://example.com"
    }
  },
  "custom_category": [
    {
      "name": "华语",
      "type": "movie",
      "query": "华语"
    }
  ]
}
```

字段说明：

- `cache_time`：接口缓存时间（秒）
- `api_site`：资源站列表，key 为唯一标识（小写字母/数字）
  - `api`：苹果 CMS V10 格式的 `vod` JSON API 根地址
  - `name`：前端展示名称
  - `detail`：（可选）无法通过 API 获取详情时的网页根 URL
- `custom_category`：自定义分类，用于导航栏个性化影视分类

LunaTV 支持标准 **苹果 CMS V10 API** 格式资源站。

## 环境变量

| 变量 | 说明 | 可选值 | 默认值 |
| --- | --- | --- | --- |
| `USERNAME` | 站长账号 | 任意字符串 | **必填** |
| `PASSWORD` | 站长密码 | 任意字符串 | **必填** |
| `SITE_BASE` | 站点 URL | 如 `https://example.com` | 空 |
| `NEXT_PUBLIC_SITE_NAME` | 站点名称 | 任意字符串 | MoonTV |
| `ANNOUNCEMENT` | 站点公告 | 任意字符串 | 内置默认公告 |
| `NEXT_PUBLIC_STORAGE_TYPE` | 存储类型 | `redis`、`kvrocks`、`upstash` | **必填** |
| `KVROCKS_URL` | Kvrocks 连接地址 | Redis 协议 URL | 空 |
| `REDIS_URL` | Redis 连接地址 | Redis 协议 URL | 空 |
| `UPSTASH_URL` | Upstash HTTPS 端点 | HTTPS URL | 空 |
| `UPSTASH_TOKEN` | Upstash Token | Token 字符串 | 空 |
| `NEXT_PUBLIC_SEARCH_MAX_PAGE` | 搜索最大页数 | 1–50 | 5 |
| `NEXT_PUBLIC_DOUBAN_PROXY_TYPE` | 豆瓣数据代理 | `direct`、`cmliussss-cdn-tencent` 等 | direct |
| `NEXT_PUBLIC_DOUBAN_IMAGE_PROXY_TYPE` | 豆瓣图片代理 | `direct`、`img3`、`cmliussss-cdn-tencent` 等 | direct |
| `NEXT_PUBLIC_DISABLE_YELLOW_FILTER` | 关闭色情过滤 | `true` / `false` | false |
| `NEXT_PUBLIC_FLUID_SEARCH` | 搜索流式输出 | `true` / `false` | true |

国内部署建议将豆瓣相关代理设置为 `cmliussss-cdn-tencent`，以改善海报与元数据加载速度。

## 客户端与扩展

- **Selene 移动端**：v100.0.0 以上可配合 [Selene](https://github.com/MoonTechLab/Selene) 使用，数据完全同步
- **Android TV**：可配合 [OrionTV](https://github.com/zimplexing/OrionTV) 作为后端，播放记录与网页端同步
- **自动更新**：可借助 Watchtower、Dockge、Komodo 等工具自动更新容器镜像

## 安全与使用提醒

1. **务必设置强密码**：通过 `PASSWORD` 环境变量保护管理后台
2. **仅供个人学习使用**：请勿公开分享实例链接或用于商业/公开服务
3. **遵守当地法律法规**：本项目不存储视频资源，内容均来自第三方站点
4. **合规声明**：请确保使用行为符合当地法律，公开分享导致的法律风险由使用者自行承担

## 参考链接

- 上游项目：[MoonTechLab/LunaTV](https://github.com/MoonTechLab/LunaTV)
- 官方 GHCR 镜像（轩辕镜像入口）：[ghcr.io/moontechlab/lunatv:latest](https://xuanyuan.cloud/ghcr.io/moontechlab/lunatv?tag=latest)
- 本镜像拉取：`docker pull docker.xuanyuan.run/r/zengteng/lunatv:latest`
- 官方镜像拉取：`docker pull ***-ghcr.xuanyuan.run/moontechlab/lunatv:latest`（`***` 为 GHCR 专属域名前缀）
