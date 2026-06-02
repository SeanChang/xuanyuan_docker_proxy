---
image: mediagis/nominatim
description: "可直接运行的Nominatim容器，提供地理编码（地址与坐标互转）服务。"
source: https://xuanyuan.cloud/zh/r/mediagis/nominatim
canonical: https://xuanyuan.cloud/zh/r/mediagis/nominatim
exported_at: 2026-06-02T12:26:10.133Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mediagis/nominatim" title="mediagis/nominatim Docker 镜像中文简介、标签列表与拉取命令">mediagis/nominatim 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Nominatim Docker 镜像文档

![Nominatim Version](https://img.shields.io/badge/Nominatim%20Version-5.1.0-blue?style=flat-square) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/mediagis/nominatim-docker/ci.yml?branch=master&style=flat-square) ![Github All Contributors](https://img.shields.io/github/all-contributors/mediagis/nominatim-docker?style=flat-square) ![Docker Pulls](https://img.shields.io/docker/pulls/mediagis/nominatim?style=flat-square) ![Docker Image Size with architecture (latest by date/latest semver)](https://img.shields.io/docker/image-size/mediagis/nominatim?style=flat-square)


## 镜像概述和主要用途

Nominatim Docker 镜像是一个 100% 可正常工作的容器化解决方案，用于部署 [Nominatim](https://github.com/openstreetmap/Nominatim) 地理编码服务。Nominatim 是 OpenStreetMap (OSM) 项目的开源地理编码工具，支持从地址文本查询地理位置（正向地理编码）和从坐标反查地址（反向地理编码）。本镜像将 Nominatim 及其依赖组件（如 PostgreSQL 数据库、Apache Web 服务器）打包为单容器，提供便捷的部署和使用体验。


## 核心功能和特性

- **单容器集成**：整合所有服务组件（Nominatim 核心、PostgreSQL、Apache）于单个容器，简化部署流程。
- **数据导入支持**：通过环境变量配置 OSM PBF 数据文件 URL，自动完成数据下载与导入。
- **API 访问**：内置 Apache 服务器，提供 HTTP API 接口，支持标准 Nominatim 查询操作。
- **版本化镜像**：提供不同版本的 Nominatim 镜像标签，适配不同需求场景。
- **即开即用**：无需手动配置数据库和 Web 服务，启动容器后自动完成初始化流程。


## 使用场景和适用范围

- **开发与测试**：快速搭建本地地理编码服务，用于应用开发调试。
- **小型应用部署**：适用于数据量较小（如城市级 OSM 数据）的自托管地理编码需求。
- **演示环境**：展示地理编码功能的轻量级部署方案。
- **定制数据场景**：支持导入自定义 OSM PBF 数据，满足特定区域的地理编码需求。


## 详细使用方法和配置说明

### 快速启动

通过以下命令可快速部署一个使用小型数据集（如摩纳哥）的 Nominatim 服务：

```bash
docker run -it \
  -e PBF_URL=https://download.geofabrik.de/europe/monaco-latest.osm.pbf \
  -p 8080:8080 \
  --name nominatim \
  mediagis/nominatim:5.1
```

**参数说明**：
- `-e PBF_URL`: 指定 OSM PBF 数据文件的下载 URL（必填），用于初始化数据库。
- `-p 8080:8080`: 端口映射，将容器内 Apache 服务的 8080 端口映射到主机的 8080 端口。
- `--name nominatim`: 容器名称，便于后续管理。
- `mediagis/nominatim:5.1`: 镜像名称及标签（Nominatim 5.1 版本）。

数据导入完成后，可通过 `http://localhost:8080/search.php?q=avenue%20pasteur` 访问 Nominatim API 进行地址查询。


### 访问不同版本

可通过指定标签拉取特定版本的 Nominatim 镜像，例如：

```bash
# 拉取 Nominatim 5.1 版本
docker pull mediagis/nominatim:5.1
```

所有可用标签参见 [Docker Hub 标签页](https://hub.docker.com/r/mediagis/nominatim/tags)。


### 环境变量配置

| 环境变量 | 说明 | 是否必填 |
|----------|------|----------|
| `PBF_URL` | OSM PBF 数据文件的 HTTP/HTTPS 下载 URL，用于数据库初始化 | 是 |
| （其他高级配置） | 如需持久化数据、数据库调优、更新数据等高级配置，参见 [详细指南](howto.md) | 否 |


### Docker Compose 部署示例

创建 `docker-compose.yml` 文件，内容如下：

```yaml
version: '3'

services:
  nominatim:
    image: mediagis/nominatim:5.1
    container_name: nominatim
    ports:
      - "8080:8080"
    environment:
      - PBF_URL=https://download.geofabrik.de/europe/monaco-latest.osm.pbf
    volumes:
      - nominatim_data:/var/lib/postgresql/14/main  # 持久化数据库数据（可选）
    restart: unless-stopped

volumes:
  nominatim_data:  # 定义数据卷，用于持久化数据库文件
```

通过以下命令启动服务：

```bash
docker-compose up -d
```


## 安全信息

关于 Nominatim 的最新安全版本支持和安全策略，参见官方文档：[Nominatim 安全策略](https://github.com/osm-search/Nominatim/blob/master/SECURITY.md)。


## 项目目标与替代方案

### 项目目标
本项目旨在提供一个易用的单容器镜像，将所有服务组件整合在一起，简化部署流程。缺点是 Dockerfile 相对复杂，定制化难度较高。

### 替代方案
若需将各组件拆分为独立容器（如数据库、Web 服务分离），可参考项目：[n7m](https://github.com/smithmicro/n7m)。


## 贡献者

感谢以下贡献者对本项目的支持（[emoji 说明](https://allcontributors.org/docs/en/emoji-key)）：

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="16.66%"><a href="https://www.linkedin.com/in/winsent/"><img src="https://avatars.githubusercontent.com/u/2316328?v=4?s=100" width="100px;" alt="Andrew"/><br /><sub><b>Andrew</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=winsento" title="代码">💻</a> <a href="https://github.com/mediagis/nominatim-docker/commits?author=winsento" title="文档">📖</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/dlucia"><img src="https://avatars3.githubusercontent.com/u/1665623?v=4?s=100" width="100px;" alt="Donato Lucia"/><br /><sub><b>Donato Lucia</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=dlucia" title="代码">💻</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/geomark"><img src="https://avatars1.githubusercontent.com/u/1500692?v=4?s=100" width="100px;" alt="Georgios Markakis"/><br /><sub><b>Georgios Markakis</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=geomark" title="文档">📖</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/philipkozeny"><img src="https://avatars1.githubusercontent.com/u/16721635?v=4?s=100" width="100px;" alt="Philip Kozeny"/><br /><sub><b>Philip Kozeny</b></sub></a><br /><a href="#infra-philipkozeny" title="基础设施（托管、构建工具等）">🚇</a> <a href="https://github.com/mediagis/nominatim-docker/commits?author=philipkozeny" title="代码">💻</a> <a href="https://github.com/mediagis/nominatim-docker/commits?author=philipkozeny" title="测试">⚠️</a> <a href="https://github.com/mediagis/nominatim-docker/pulls?q=is%3Apr+reviewed-by%3Aphilipkozeny" title="代码审查">👀</a> <a href="https://github.com/mediagis/nominatim-docker/commits?author=philipkozeny" title="文档">📖</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://www.therek.net/"><img src="https://avatars2.githubusercontent.com/u/89052?v=4?s=100" width="100px;" alt="Cezary Morga"/><br /><sub><b>Cezary Morga</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=therek" title="代码">💻</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/thomasnordquist"><img src="https://avatars0.githubusercontent.com/u/7721625?v=4?s=100" width="100px;" alt="Thomas Nordquist"/><br /><sub><b>Thomas Nordquist</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=thomasnordquist" title="代码">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="16.66%"><a href="https://keybase.io/davkorss"><img src="https://avatars0.githubusercontent.com/u/5597595?v=4?s=100" width="100px;" alt="Andrey Ruíz"/><br /><sub><b>Andrey Ruíz</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=davkorss" title="文档">📖</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/UntitleDude"><img src="https://avatars2.githubusercontent.com/u/14983691?v=4?s=100" width="100px;" alt="UntitleDude"/><br /><sub><b>UntitleDude</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=UntitleDude" title="代码">💻</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://www.linkedin.com/in/jmcker"><img src="https://avatars3.githubusercontent.com/u/25001741?v=4?s=100" width="100px;" alt="Jack McKernan"/><br /><sub><b>Jack McKernan</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=jmcker" title="代码">💻</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://twitter.com/mtmthemovie"><img src="https://avatars1.githubusercontent.com/u/3727288?v=4?s=100" width="100px;" alt="mtmail"/><br /><sub><b>mtmail</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=mtmail" title="文档">📖</a> <a href="https://github.com/mediagis/nominatim-docker/commits?author=mtmail" title="代码">💻</a> <a href="#question-mtmail" title="回答问题">💬</a> <a href="https://github.com/mediagis/nominatim-docker/pulls?q=is%3Apr+reviewed-by%3Amtmail" title="代码审查">👀</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://angel.co/eSlider"><img src="https://avatars3.githubusercontent.com/u/1188335?v=4?s=100" width="100px;" alt="Andrey Oblivantsev"/><br /><sub><b>Andrey Oblivantsev</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=eSlider" title="代码">💻</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://www.linkedin.com/in/simoneromano92/"><img src="https://avatars2.githubusercontent.com/u/6860423?v=4?s=100" width="100px;" alt="Simone"/><br /><sub><b>Simone</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=sromano1992" title="代码">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/DuncanMackintosh"><img src="https://avatars0.githubusercontent.com/u/4966417?v=4?s=100" width="100px;" alt="DuncanMackintosh"/><br /><sub><b>DuncanMackintosh</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=DuncanMackintosh" title="代码">💻</a> <a href="https://github.com/mediagis/nominatim-docker/commits?author=DuncanMackintosh" title="文档">📖</a></td>
      <td align="center" valign="top" width="16.66%"><a href="http://iiroalhonen.com"><img src="https://avatars2.githubusercontent.com/u/18322926?v=4?s=100" width="100px;" alt="Iiro Alhonen"/><br /><sub><b>Iiro Alhonen</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=Iikeli" title="文档">📖</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://www.ufoproger.ru"><img src="https://avatars3.githubusercontent.com/u/212711?v=4?s=100" width="100px;" alt="Mikhail Snetkov"/><br /><sub><b>Mikhail Snetkov</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=ufoproger" title="代码">💻</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/FritschAuctores"><img src="https://avatars2.githubusercontent.com/u/43264099?v=4?s=100" width="100px;" alt="FritschAuctores"/><br /><sub><b>FritschAuctores</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=FritschAuctores" title="代码">💻</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/rebos"><img src="https://avatars.githubusercontent.com/u/490798?v=4?s=100" width="100px;" alt="rebos"/><br /><sub><b>rebos</b></sub></a><br /><a href="https://github.com/mediagis/nominatim-docker/commits?author=rebos" title="代码">💻</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://leonard.io/blog/"><img src="https://avatars.githubusercontent.com/u/151346?v=4?s=100" width="100px;" alt="Leonard Ehrenfried"/><br /><sub><b>Leonard Ehrenfried</b></sub></a><br /><a href="#infra-leonardehrenfried" title="基础设施（托管、构建工具等）">🚇
