---
image: library/mediawiki
description: "MediaWiki是一款用PHP编写的免费开源维基软件包。"
source: https://xuanyuan.cloud/zh/r/library/mediawiki
canonical: https://xuanyuan.cloud/zh/r/library/mediawiki
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/mediawiki" title="library/mediawiki Docker 镜像中文简介、标签列表与拉取命令">library/mediawiki — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/mediawiki" title="library/mediawiki Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/mediawiki</a>

# 快速参考

- **维护者**：  
  [MediaWiki社区与Docker社区](https://github.com/wikimedia/mediawiki-docker)

- **获取帮助**：  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

# 支持的标签及对应的`Dockerfile`链接

- [`1.44.2`, `1.44`, `latest`, `stable`](https://github.com/wikimedia/mediawiki-docker/blob/22e0f2939d36bfc61d1572e4e1a2afd66d84e6f5/1.44/apache/Dockerfile)

- [`1.44.2-fpm`, `1.44-fpm`, `stable-fpm`](https://github.com/wikimedia/mediawiki-docker/blob/22e0f2939d36bfc61d1572e4e1a2afd66d84e6f5/1.44/fpm/Dockerfile)

- [`1.44.2-fpm-alpine`, `1.44-fpm-alpine`, `stable-fpm-alpine`](https://github.com/wikimedia/mediawiki-docker/blob/22e0f2939d36bfc61d1572e4e1a2afd66d84e6f5/1.44/fpm-alpine/Dockerfile)

- [`1.43.5`, `1.43`, `lts`](https://github.com/wikimedia/mediawiki-docker/blob/22e0f2939d36bfc61d1572e4e1a2afd66d84e6f5/1.43/apache/Dockerfile)

- [`1.43.5-fpm`, `1.43-fpm`, `lts-fpm`](https://github.com/wikimedia/mediawiki-docker/blob/22e0f2939d36bfc61d1572e4e1a2afd66d84e6f5/1.43/fpm/Dockerfile)

- [`1.43.5-fpm-alpine`, `1.43-fpm-alpine`, `lts-fpm-alpine`](https://github.com/wikimedia/mediawiki-docker/blob/22e0f2939d36bfc61d1572e4e1a2afd66d84e6f5/1.43/fpm-alpine/Dockerfile)

- [`1.39.15`, `1.39`](https://github.com/wikimedia/mediawiki-docker/blob/22e0f2939d36bfc61d1572e4e1a2afd66d84e6f5/1.39/apache/Dockerfile)

- [`1.39.15-fpm`, `1.39-fpm`](https://github.com/wikimedia/mediawiki-docker/blob/22e0f2939d36bfc61d1572e4e1a2afd66d84e6f5/1.39/fpm/Dockerfile)

- [`1.39.15-fpm-alpine`, `1.39-fpm-alpine`](https://github.com/wikimedia/mediawiki-docker/blob/22e0f2939d36bfc61d1572e4e1a2afd66d84e6f5/1.39/fpm-alpine/Dockerfile)

# 快速参考（续）

- **问题反馈**：  
  [https://phabricator.wikimedia.org/project/view/3094/](https://phabricator.wikimedia.org/project/view/3094/)

- **支持的架构**：([更多信息](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
  [`amd64`](https://hub.docker.com/r/amd64/mediawiki/), [`arm32v5`](https://hub.docker.com/r/arm32v5/mediawiki/), [`arm32v6`](https://hub.docker.com/r/arm32v6/mediawiki/), [`arm32v7`](https://hub.docker.com/r/arm32v7/mediawiki/), [`arm64v8`](https://hub.docker.com/r/arm64v8/mediawiki/), [`i386`](https://hub.docker.com/r/i386/mediawiki/), [`ppc64le`](https://hub.docker.com/r/ppc64le/mediawiki/)

- **已发布镜像制品详情**：  
  [repo-info仓库的`repos/mediawiki/`目录](https://github.com/docker-library/repo-info/blob/master/repos/mediawiki)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/mediawiki)）  
  （镜像元数据、传输大小等）

- **镜像更新**：  
  [official-images仓库的`library/mediawiki`标签](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fmediawiki)  
  [official-images仓库的`library/mediawiki`文件](https://github.com/docker-library/official-images/blob/master/library/mediawiki)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/mediawiki)）

- **本描述的来源**：  
  [docs仓库的`mediawiki/`目录](https://github.com/docker-library/docs/tree/master/mediawiki)（[历史记录](https://github.com/docker-library/docs/commits/master/mediawiki)）

# 什么是MediaWiki？

MediaWiki是一款免费开源的维基软件。最初由Magnus Manske开发，后经Lee Daniel Crocker改进，运行于众多网站，包括维基百科、维基词典和维基共享资源。它采用PHP编程语言编写，将内容存储在数据库中。与基于类似许可和架构的WordPress一样，它已成为其类别中的主导软件。

> [wikipedia.org/wiki/MediaWiki](https://en.wikipedia.org/wiki/MediaWiki)

![logo](https://raw.githubusercontent.com/docker-library/docs/27b797857efd9253c0981c09696f579a167062d4/mediawiki/logo.svg?sanitize=true)

# 如何使用此镜像

启动`mediawiki`实例的基本命令模式如下：

```console
$ docker run --name some-mediawiki -d mediawiki
```

如果希望从主机访问实例而无需使用容器IP，可以使用标准端口映射：

```console
$ docker run --name some-mediawiki -p 8080:80 -d mediawiki
```

然后，在浏览器中通过`http://localhost:8080`或`http://host-ip:8080`访问。

此镜像支持多种数据库类型，最容易通过标准容器链接使用。在默认配置中，可以使用SQLite来避免使用第二个容器并写入平面文件。以下是不同（更适合生产环境）数据库类型的详细说明。

首次访问此镜像提供的Web服务器时，会进行简短的设置过程。以下详细信息专门针对该配置过程中的“设置数据库”步骤。

## MySQL

```console
$ docker run --name some-mediawiki --link some-mysql:mysql -d mediawiki
```

- 数据库类型：`MySQL、MariaDB或等效数据库`
- 数据库名称/用户名/密码：`<访问MySQL实例的详细信息>`（`MYSQL_USER`、`MYSQL_PASSWORD`、`MYSQL_DATABASE`；参见[`mariadb`](https://hub.docker.com/_/mariadb/)描述中的环境变量）
- 高级选项；数据库主机：`some-mysql`（使用`--link`添加的`/etc/hosts`条目访问链接容器的MySQL实例）

## 卷

默认情况下，此镜像不包含任何卷。

路径`/var/www/html/images`和`/var/www/html/LocalSettings.php`通常应作为卷，但由于卷无法移除，因此此镜像中未明确声明`VOLUME`。

```console
$ docker run --rm mediawiki tar -cC /var/www/html/sites . | tar -xC /path/on/host/sites
```

## ... 通过[`docker compose`](https://github.com/docker/compose)

`mediawiki`的`compose.yaml`示例：

```yaml
# MediaWiki与MariaDB
#
# 通过"http://localhost:8080"访问
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8080:80
    links:
      - database
    volumes:
      - images:/var/www/html/images
      # 初始设置后，将LocalSettings.php下载到与此yaml相同的目录，取消以下行的注释并使用compose重启mediawiki服务
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php
  database: # <- 此键定义设置过程中的数据库名称
    image: mariadb
    restart: always
    environment:
      # 参见https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: example
      MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
    volumes:
      - db:/var/lib/mysql

volumes:
  images:
  db:
```

运行`docker compose up`，等待完全初始化后，通过`http://localhost:8080`或`http://host-ip:8080`（视情况而定）访问。

## 添加额外库/扩展

此镜像不包含任何额外的PHP扩展或其他库，即使是流行插件所需的。可能的插件数量众多，它们可能需要PHP支持的任何扩展。包含所有存在的PHP扩展会显著增加镜像大小。

如果需要额外的PHP扩展，需要基于此镜像创建自己的镜像。[`php`镜像文档](https://github.com/docker-library/docs/blob/31280550a3c7104fef824450753844d2f3d917be/php/README.md#how-to-install-more-php-extensions)解释了如何编译额外的扩展。

以下Docker Hub功能可帮助保持依赖镜像的更新：

- [自动构建](https://docs.docker.com/docker-hub/builds/)让Docker Hub在每次推送更改时自动构建Dockerfile。

# 镜像变体

`mediawiki`镜像有多种版本，每种版本设计用于特定用例。

## `mediawiki:<version>`

这是默认镜像。如果不确定自己的需求，可能需要使用此版本。它既可以用作临时容器（挂载源代码并启动容器以运行应用），也可以作为构建其他镜像的基础。

## `mediawiki:<version>-alpine`

此镜像基于流行的[Alpine Linux项目](https://alpinelinux.org)，可在[`alpine`官方镜像](https://hub.docker.com/_/alpine)中获取。Alpine Linux比大多数发行版基础镜像小得多（约5MB），因此通常会生成更精简的镜像。

当最终镜像大小是首要考虑因素时，此变体非常有用。需要注意的是，它使用[musl libc](https://musl.libc.org)而非[glibc及相关库](https://www.etalabs.net/compare_libcs.html)，因此软件可能会因libc需求/假设的深度而遇到问题。有关可能出现的问题以及使用Alpine基础镜像的优缺点比较，请参见[此Hacker News评论线程](https://news.ycombinator.com/item?id=10782897)。

为最小化镜像大小，Alpine基础镜像中通常不包含额外的相关工具（如`git`或`bash`）。以此镜像为基础，可在自己的Dockerfile中添加所需工具（如果不熟悉如何安装包，请参见[`alpine`镜像描述](https://hub.docker.com/_/alpine/)中的示例）。

# 许可证

查看此镜像中包含的软件的[许可证信息](https://phabricator.wikimedia.org/source/mediawiki/browse/master/COPYING)。

与所有Docker镜像一样，这些镜像可能还包含其他软件，这些软件可能具有其他许可证（如基础发行版中的Bash等，以及主要软件的任何直接或间接依赖项）。

可在[`repo-info`仓库的`mediawiki/`目录](https://github.com/docker-library/repo-info/tree/master/repos/mediawiki)中找到一些能够自动检测到的额外许可证信息。

对于任何预构建镜像的使用，镜像用户有责任确保对该镜像的任何使用都符合其中包含的所有软件的相关许可证。
