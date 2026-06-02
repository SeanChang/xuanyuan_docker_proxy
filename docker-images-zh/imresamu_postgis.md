<!-- xuanyuan-docker-images-zh
image: imresamu/postgis
source: https://xuanyuan.cloud/zh/r/imresamu/postgis
canonical: https://xuanyuan.cloud/zh/r/imresamu/postgis
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [imresamu/postgis — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/imresamu/postgis "imresamu/postgis Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/imresamu/postgis

# imresamu/postgis 镜像介绍


## 开发状态
### 🚧 实验性开发中
- **测试镜像**（支持 amd64 + arm64）：[[]]([])  
  - 内部仅 amd64 仓库：[[]]([])  
  - 内部仅 arm64 仓库：[[]]([])  
- **代码仓库**：[[]]([])  
- **状态**：实验性，积极开发中  


## 镜像概述
`imresamu/postgis` 镜像基于官方 [`postgres`]([]) 镜像构建，提供 Debian 和 Alpine 两种变体，支持 PostgreSQL 13、14、15、16、17 版本，且包含 PostGIS 扩展。此外，还提供基于最新两个 PostgreSQL 版本（16、17）构建的镜像，其中 PostGIS 及其依赖（如 GEOS、PROJ 等）均从各自的主分支编译。

### 默认数据库扩展
父镜像 `postgres` 创建的默认数据库会预装以下扩展：

| 已安装扩展                | 是否初始化 |
|--------------------------|------------|
| `postgis`                | 是         |
| `postgis_topology`       | 是         |
| `postgis_tiger_geocoder` | 是         |
| `postgis_raster`         |            |
| `postgis_sfcgal`         |            |
| `address_standardizer`   |            |
| `address_standardizer_data_us` |      |

- 若未通过 `-e POSTGRES_DB` 指定数据库名，默认数据库名称与管理员用户一致（`postgres` 或 `-e POSTGRES_USER` 指定的用户）。  
- 同时提供 PostGIS 启用的模板数据库 `template_postgis`，可用于传统模板机制。


## 版本信息（2025-06-30）
### 多平台支持
镜像支持以下架构：
- **amd64**（x86-64）：使用时需指定 `--platform=linux/amd64`  
- **arm64**（AArch64）：使用时需指定 `--platform=linux/arm64`（实验性支持）  

> 注意：仅支持 64 位架构，不提供 32 位版本；arm64 架构支持仍为实验性，具体版本需参考版本表格中的“架构”列。


## 构建状态

| 架构   | 构建系统                          | 状态                                                                 |
|--------|-----------------------------------|----------------------------------------------------------------------|
| Amd64  | [GithubCI-logs]([]) | [![Build PostGIS images]([])]([]) |
| Arm64  | [CircleCI-logs]([]) | [![CircleCI]([])]([]) |


## 推荐版本（新用户）
- **基础版**：`imresamu/postgis:17-3.5-bookworm`  
  包含 PostgreSQL 和 PostGIS 的最小化配置（基于 Debian bookworm，易于扩展）。  
- **最新依赖版**：`imresamu/postgis:17-recent-bookworm`（实验性）  
  基于最新 PostgreSQL 版本，PostGIS 及其依赖（GEOS、PROJ 等）均为最新主分支构建（扩展配置较复杂）。  
- **扩展功能版**：`imresamu/postgis:16-3.5-bundle0-bookworm`（实验性）  
  包含 PostgreSQL、PostGIS 及额外地理空间工具（如 pgRouting、MobilityDB 等）。


## Debian - bookworm（推荐）
- **特点**：发布周期谨慎，稳定性高，使用 Debian 仓库的 PostGIS 及依赖包（GEOS=3.11、GDAL=3.6、PROJ=9.1、SFCGAL=1.4），易于扩展。  

| `docker.io/imresamu/postgis:` 标签                                                                 | Dockerfile                                                                 | 架构       | 系统     | PostgreSQL | PostGIS |
|---------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|------------|----------|------------|---------|
| [`13-3.5-bookworm`]([]), [`13-3.5.3-bookworm`]([]), [`13-3.5`]([]) | [Dockerfile]([]) | amd64 arm64 | bookworm | 13         | 3.5.3   |
| [`14-3.5-bookworm`]([]), [`14-3.5.3-bookworm`]([]), [`14-3.5`]([]) | [Dockerfile]([]) | amd64 arm64 | bookworm | 14         | 3.5.3   |
| [`15-3.5-bookworm`]([]), [`15-3.5.3-bookworm`]([]), [`15-3.5`]([]) | [Dockerfile]([]) | amd64 arm64 | bookworm | 15         | 3.5.3   |
| [`16-3.5-bookworm`]([]), [`16-3.5.3-bookworm`]([]), [`16-3.5`]([]) | [Dockerfile]([]) | amd64 arm64 | bookworm | 16         | 3.5.3   |
| [`17-3.5-bookworm`]([]), [`17-3.5.3-bookworm`]([]), [`17-3.5`]([]), [`latest`]([]) | [Dockerfile]([]) | amd64 arm64 | bookworm | 17         | 3.5.3   |


## Debian - bullseye
- **特点**：使用 Debian Bullseye 仓库的依赖包（GEOS=3.9、GDAL=3.2、PROJ=7.2、SFCGAL=1.3.9），易于扩展。  

| `docker.io/imresamu/postgis:` 标签                                                                 | Dockerfile                                                                 | 架构       | 系统     | PostgreSQL | PostGIS |
|---------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|------------|----------|------------|---------|
| [`13-3.5-bullseye`]([]), [`13-3.5.2-bullseye`]([]) | [Dockerfile]([]) | amd64 arm64 | bullseye | 13         | 3.5.2   |
| [`14-3.5-bullseye`]([]), [`14-3.5.2-bullseye`]([]) | [Dockerfile]([]) | amd64 arm64 | bullseye | 14         | 3.5.2   |
| [`15-3.5-bullseye`]([]), [`15-3.5.2-bullseye`]([]) | [Dockerfile]([]) | amd64 arm64 | bullseye | 15         | 3.5.2   |
| [`16-3.5-bullseye`]([]), [`16-3.5.2-bullseye`]([]) | [Dockerfile]([]) | amd64 arm64 | bullseye | 16         | 3.5.2   |
| [`17-3.5-bullseye`]([]), [`17-3.5.2-bullseye`]([]) | [Dockerfile]([]) | amd64 arm64 | bullseye | 17         | 3.5.2   |


## Recent（实验性）
- **特点**：基于最新发布的 PostGIS 及依赖（GEOS、PROJ、GDAL 等）构建，适合测试，扩展复杂。  

| `docker.io/imresamu/postgis:` 标签                                                                                                                                                                                                 | Dockerfile                                                                 | 架构       | 系统     | PostgreSQL | PostGIS                                                                 |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|------------|----------|------------|-------------------------------------------------------------------------|
| [`16-recent-bookworm`]([]), [`16-recent-postgis3.5.3-geos3.13.1-proj9.6.2-gdal3.11.0-cgal6.0.1-sfcgal2.1.0-bookworm`]([]), [`16-recent`]([]) | [Dockerfile]([]) | amd64 arm64 | bookworm | 16         | postgis=tags/3.5.3, geos=tags/3.13.1, proj=tags/9.6.2, gdal=tags/v3.11.0, cgal=tags/v6.0.1, sfcgal=tags/v2.1.0 |
| [`17-recent-bookworm`]([]), [`17-recent-postgis3.5.3-geos3.13.1-proj9.6.2-gdal3.11.0-cgal6.0.1-sfcgal2.1.0-bookworm`]([]), [`17-recent`]([]), [`recent`]([]) | [Dockerfile]([]) | amd64 arm64 | bookworm | 17         | postgis=tags/3.5.3, geos=tags/3.13.1, proj=tags/9.6.2, gdal=tags/v3.11.0, cgal=tags/v6.0.1, sfcgal=tags/v2.1.0 |


## Debian Geo Bundle（实验性）
- **特点**：包含额外地理空间工具（pgRouting、h3-pg、MobilityDB 等），适合服务端地理空间需求。  

| `docker.io/imresamu/postgis:` 标签                                                                         | Dockerfile                                                                       | 架构       | 系统     | PostgreSQL | PostGIS |
|-----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------|------------|----------|------------|---------|
| [`16-3.5-bundle0-bookworm`]([]), [`16-3.5.3-bundle0-bookworm`]([]), [`16-3.5-bundle0`]([]) | [Dockerfile]([]) | amd64 arm64 | bookworm | 16         | 3.5.3   |
| [`17-3.5-bundle0-bookworm`]([]
