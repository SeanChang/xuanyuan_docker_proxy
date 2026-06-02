---
image: library/django
description: "该镜像已官方弃用，推荐使用标准`python`镜像替代，2016年12月31日后不再更新。其原价值为预安装mysql-client、postgresql-client和sqlite3，用于Django框架，现可通过自定义Dockerfile实现类似功能。"
source: https://xuanyuan.cloud/zh/r/library/django
canonical: https://xuanyuan.cloud/zh/r/library/django
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/django" title="library/django Docker 镜像中文简介、标签列表与拉取命令">library/django — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/library/django" title="library/django Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/library/django</a>

# **已弃用**

该镜像已官方弃用，推荐使用[标准`python`镜像](https://hub.docker.com/_/python/)替代，2016年12月31日后将不再接收更新。请相应调整您的使用方式。

对于该镜像的大多数使用场景，Django实际上并非从此镜像获取，而是来自项目的`requirements.txt`，因此其唯一“价值”是预安装了`mysql-client`、`postgresql-client`和`sqlite3`，用于Django框架的各种使用场景。

例如，以下`Dockerfile`可作为使用PostgreSQL的Django项目的良好起点：

```dockerfile
FROM python:3.4

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		postgresql-client \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY . .

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

# 支持的标签及对应的`Dockerfile`链接

- [`1.10.4-python3`, `1.10-python3`, `1-python3`, `python3`, `1.10.4`, `1.10`, `1`, `latest` (*3.4/Dockerfile*)](https://github.com/docker-library/django/blob/d7f1d0e61cffe81d6ca9797c63fc25eba7e277db/3.4/Dockerfile)
- [`python3-onbuild`, `onbuild` (*3.4/onbuild/Dockerfile*)](https://github.com/docker-library/django/blob/4fe080675e4a85ef6ee25c811e9d3d3ef0905794/3.4/onbuild/Dockerfile)
- [`1.10.4-python2`, `1.10-python2`, `1-python2`, `python2` (*2.7/Dockerfile*)](https://github.com/docker-library/django/blob/d7f1d0e61cffe81d6ca9797c63fc25eba7e277db/2.7/Dockerfile)
- [`python2-onbuild` (*2.7/onbuild/Dockerfile*)](https://github.com/docker-library/django/blob/cecbb2bbbcb69d1b8358398eaf8d9638e3bdd447/2.7/onbuild/Dockerfile)

# 快速参考

- **获取帮助的途径**：  
  [Docker社区论坛](https://forums.docker.com/)、[Docker社区Slack](https://blog.docker.com/2016/11/introducing-docker-community-directory-docker-community-slack/) 或 [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)

- **提交问题的地址**：  
  [https://github.com/docker-library/django/issues](https://github.com/docker-library/django/issues)

- **维护者**：  
  [Docker社区](https://github.com/docker-library/django)

- **镜像 artifact 详情**：  
  [repo-info 仓库的`repos/django/`目录](https://github.com/docker-library/repo-info/blob/master/repos/django)（[历史记录](https://github.com/docker-library/repo-info/commits/master/repos/django)）  
  （镜像元数据、传输大小等）

- **镜像更新**：  
  [带有`library/django`标签的 official-images PR](https://github.com/docker-library/official-images/pulls?q=label%3Alibrary%2Fdjango)  
  [official-images 仓库的`library/django`文件](https://github.com/docker-library/official-images/blob/master/library/django)（[历史记录](https://github.com/docker-library/official-images/commits/master/library/django)）

- **本描述的来源**：  
  [docs 仓库的`django/`目录](https://github.com/docker-library/docs/tree/master/django)（[历史记录](https://github.com/docker-library/docs/commits/master/django)）

- **支持的 Docker 版本**：  
  [最新版本](https://github.com/docker/docker/releases/latest)（尽最大努力支持低至1.6版本）

# 什么是 Django？

Django 是一个免费开源的 Web 应用框架，使用 Python 编写，遵循模型-视图-控制器（MVC）架构模式。Django 的主要目标是简化复杂的、数据库驱动网站的创建，强调组件的可重用性和“可插拔性”。

> [wikipedia.org/wiki/Django_(web_framework)](https://en.wikipedia.org/wiki/Django_%28web_framework%29)

![logo](https://raw.githubusercontent.com/docker-library/docs/164cc29281655dc81242824d1b4f90b4e6d8d7eb/django/logo.png)

# 如何使用该镜像

## 在 Django 应用项目中创建`Dockerfile`

```dockerfile
FROM django:onbuild
```

将此文件放在应用根目录，与`requirements.txt`同级。

该镜像包含多个`ONBUILD`触发器，可覆盖大多数应用场景。构建过程会执行`COPY . /usr/src/app`、`RUN pip install`、`EXPOSE 8000`，并将默认命令设置为`python manage.py runserver`。

然后可以构建并运行 Docker 镜像：

```console
$ docker build -t my-django-app .
$ docker run --name some-django-app -d my-django-app
```

可通过浏览器访问`http://container-ip:8000`进行测试；若需从主机外部访问，可使用以下命令在`http://localhost:8000`访问：

```console
$ docker run --name some-django-app -p 8000:8000 -d my-django-app
```

## 不使用`Dockerfile`

当然，若不想使用便捷的`ONBUILD`触发器，也可直接使用`docker run`命令，无需在项目中添加`Dockerfile`：

```console
$ docker run --name some-django-app -v "$PWD":/usr/src/app -w /usr/src/app -p 8000:8000 -d django bash -c "pip install -r requirements.txt && python manage.py runserver 0.0.0.0:8000"
```

## 引导新的 Django 应用

若要生成新 Django 项目的脚手架，可执行以下命令：

```console
$ docker run -it --rm --user "$(id -u):$(id -g)" -v "$PWD":/usr/src/app -w /usr/src/app django django-admin.py startproject mysite
```

这将在当前目录下创建名为`mysite`的子目录。

# 镜像变体

`django`镜像有多种变体，适用于不同使用场景。

## `django:<version>`

这是默认镜像。若不确定需求，建议使用此变体。它既可作为临时容器（挂载源代码并启动容器以运行应用），也可作为构建其他镜像的基础。

## `django:onbuild`

此镜像简化了衍生镜像的构建。对于大多数场景，在项目根目录创建包含`FROM django:onbuild`的`Dockerfile`，即可快速创建独立的项目镜像。

虽然`onbuild`变体有助于“快速启动”（短时间内实现 Docker 化），但不建议在项目中长期使用，因为无法控制`ONBUILD`触发器的执行时机（另见[`docker/docker#5714`](https://github.com/docker/docker/issues/5714)、[`docker/docker#8240`](https://github.com/docker/docker/issues/8240)、[`docker/docker#11917`](https://github.com/docker/docker/issues/11917)）。

当熟悉项目在 Docker 中的运行方式后，建议调整`Dockerfile`，继承非`onbuild`变体，并将`onbuild`变体`Dockerfile`中的命令（将`ONBUILD`行移至末尾并移除`ONBUILD`关键字）复制到自己的文件中，以便更好地控制这些命令，同时提高`Dockerfile`的透明度，便于自己和他人理解其功能。这也能更轻松地添加额外需求（如在执行原`ONBUILD`步骤前安装更多包）。

# 许可证

查看此镜像中包含软件的[许可证信息](https://github.com/django/django/blob/master/LICENSE)。
