---
image: mattrayner/lamp
description: "Docker-LAMP是一套基于Phusion基础镜像的Docker镜像，包含Apache、MySQL和PHP组成的LAMP栈，支持Ubuntu 14.04、16.04和18.04版本，提供一站式LAMP开发环境，适用于各类PHP应用开发与部署，具备多版本灵活性和简便的使用流程。"
source: https://xuanyuan.cloud/zh/r/mattrayner/lamp
canonical: https://xuanyuan.cloud/zh/r/mattrayner/lamp
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/mattrayner/lamp" title="mattrayner/lamp Docker 镜像中文简介、标签列表与拉取命令">mattrayner/lamp 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Docker-LAMP

Docker-LAMP是一组Docker镜像，包含Phusion基础镜像（14.04、16.04和18.04版本）以及LAMP栈（[Apache][apache]、[MySQL][mysql]和[PHP][php]），打包为便捷的一站式解决方案。

通过`latest-1804`和`latest-1604`标签提供Ubuntu **18.04**和**16.04**镜像，Docker-LAMP具备足够的灵活性，可用于所有LAMP项目。

[![构建状态][shield-build-status]][info-build-status]
[![Docker Hub][shield-docker-hub]][info-docker-hub]
[![许可证][shield-license]][info-license]

## 目录
- [简介](#简介)
- [镜像版本](#镜像版本)
- [使用镜像](#使用镜像)
  - [命令行方式](#命令行方式)
  - [使用Dockerfile](#使用dockerfile)
  - [MySQL数据库](#mysql数据库)
    - [创建数据库](#创建数据库)
      - [通过PHPMyAdmin](#通过phpmyadmin)
      - [通过命令行](#通过命令行)
- [添加自定义内容](#添加自定义内容)
  - [添加应用](#添加应用)
  - [持久化MySQL数据](#持久化mysql数据)
  - [同时进行两者](#同时进行两者)
    - [`.bash_profile`别名示例](#bash_profile别名示例)
      - [使用示例](#使用示例)
- [镜像开发](#镜像开发)
  - [构建与运行](#构建与运行)
  - [测试](#测试)
  - [单行测试命令](#单行测试命令)
    - [`docker-compose -f docker-compose.test.yml -p ci build;`](#docker-compose--f-docker-composetestyml--p-ci-build)
    - [`docker-compose -f docker-compose.test.yml -p ci up -d;`](#docker-compose--f-docker-composetestyml--p-ci-up--d)
    - [`docker logs -f ci_sut_1;`](#docker-logs--f-ci_sut_1)
    - [`echo "Exited with status code: $(docker wait ci_sut_1)"`](#echo-exited-with-status-code-docker-wait-ci_sut_1)
- [灵感来源](#灵感来源)
- [贡献指南](#贡献指南)
- [许可证](#许可证)

## 简介
作为开发人员，日常工作中需要构建LAMP应用。在寻找满足需求的镜像时，发现现有选项缺乏更新的软件包、简洁的接口、完善的文档和活跃的支持。更复杂的是，需要同时支持14.04和16.04两个版本的镜像，而维护两套独立工作流并不合理，因此Docker-LAMP应运而生。

Docker-LAMP设计为单一接口，不干扰开发流程，支持14.04和16.04版本，兼容PHP 5和PHP 7。用户可在4个镜像间无缝切换，无需改变Docker使用方式。

## 镜像版本
> **注意：** [PHP 5.6已停止支持][end-of-life]，因此PHP 5镜像`mattrayner/lamp:latest-1404-php5`和`mattrayner/lamp:latest-1604-php5`将不再更新。尽管这些镜像仍会保留在Docker Hub上，但**强烈建议**将应用升级至PHP 7。

> **注意：** 该镜像的14.04变体不再积极支持更新。

Docker镜像主要有4个“版本”。下表显示了可用的不同标签，以及随附的PHP、MySQL和Apache版本。

| 组件 | `latest-1404` | `latest-1604` | `latest-1804` |
|------|---------------|---------------|---------------|
| [Apache][apache] | `2.4.7` | `2.4.18` | `2.4.29` |
| [MySQL][mysql] | `5.5.62` | `5.7.26` | `5.7.26` |
| [PHP][php] | `7.3.3` | `7.3.6` | `7.3.6` |
| [phpMyAdmin][phpmyadmin] | `4.8.5` | `4.9.0.1` | `4.9.0.1` |

## 使用镜像

### 命令行方式
这是最快捷的方式：
```bash
# 启动基于18.04的镜像
docker run -p "80:80" -v ${PWD}/app:/app docker.xuanyuan.run/mattrayner/lamp:latest-1804

# 启动基于16.04的镜像
docker run -p "80:80" -v ${PWD}/app:/app docker.xuanyuan.run/mattrayner/lamp:latest-1604

# 启动基于14.04的镜像
docker run -p "80:80" -v ${PWD}/app:/app docker.xuanyuan.run/mattrayner/lamp:latest-1404
```

### 使用Dockerfile
```docker
FROM docker.xuanyuan.run/mattrayner/lamp:latest-1804

# 自定义命令

CMD ["/run.sh"]
```

### MySQL数据库
默认情况下，镜像包含一个无密码的MySQL `root`账户。该账户仅本地可用（即应用内部），无法从Docker镜像外部或通过phpMyAdmin访问。

首次运行镜像时，会显示`admin`用户的密码信息。此用户可本地和外部使用，可通过连接MySQL端口（默认3306）使用MySQL Workbench或Sequel Pro等工具，或通过phpMyAdmin访问。

如需后续查看此登录信息，可运行`docker logs CONTAINER_ID`，密码信息会显示在日志顶部。

#### 创建数据库
应用如需数据库，有两种方式：

1. PHPMyAdmin
2. 命令行

##### 通过PHPMyAdmin
Docker-LAMP预装phpMyAdmin，可通过`http://DOCKER_ADDRESS/phpmyadmin`访问。

**注意：** 不能使用`root`用户登录PHPMyAdmin。建议使用本节介绍的admin用户登录。

##### 通过命令行
首先，使用`docker ps`获取运行中容器的ID，然后替换以下命令中的`CONTAINER_ID`和`DATABASE_NAME`：
```bash
docker exec CONTAINER_ID  mysql -uroot -e "create database DATABASE_NAME"
```

## 添加自定义内容
向LAMP镜像添加自定义内容的“最简单”方式是使用Docker卷，可将本地特定文件夹与Docker容器中的文件夹“同步”。

以下示例假设项目结构如下，且命令从“项目根目录”运行：
```
/ (项目根目录)
/app/ (PHP文件存放目录)
/mysql/ (Docker将创建此目录存储MySQL数据)
```

简单来说，项目应包含一个名为`app`的文件夹，其中包含所有应用代码。

### 添加应用
以下命令将交互式运行`mattrayner/lamp:latest`镜像，将主机的80端口映射到容器的80端口，并创建卷将项目中的`app/`目录链接到容器的`/app`目录（Apache期望PHP文件存放的位置）：
```bash
docker run -i -t -p "80:80" -v ${PWD}/app:/app docker.xuanyuan.run/mattrayner/lamp:latest
```

### 持久化MySQL数据
以下命令运行`mattrayner/lamp:latest`镜像，在项目中创建`mysql/`文件夹，链接到容器中存储MySQL文件的`/var/lib/mysql`目录。停止/启动容器后，数据库更改将保留。

也可在`-p 80:80`后添加`-p 3306:3306`，将MySQL端口暴露到主机，以便外部应用（如SequelPro或MySQL Workbench）连接：
```bash
docker run -i -t -p "80:80" -v ${PWD}/mysql:/var/lib/mysql docker.xuanyuan.run/mattrayner/lamp:latest
```

### 同时进行两者
以下命令是“推荐”方案，可同时添加PHP应用和持久化数据库文件。可在`.bash_profile`中创建更高级的别名，实现`ldi`和`launchdocker`等简短命令。详见下节示例：
```bash
docker run -i -t -p "80:80" -v ${PWD}/app:/app -v ${PWD}/mysql:/var/lib/mysql docker.xuanyuan.run/mattrayner/lamp:latest
```

#### `.bash_profile`别名示例
以下示例可添加到`~/.bash_profile`文件，创建`launchdocker`和`ldi`别名。默认启动16.04镜像，如需14.04镜像，将`mattrayner/lamp:latest`替换为`mattrayner/lamp:latest-1404`：
```bash
# 启动mattrayner/lamp容器的辅助函数，支持参数覆盖
#
# $1 - Apache端口（可选）
# $2 - MySQL端口（可选 - 无值则不映射MySQL）
function launchdockerwithparams {
    APACHE_PORT=80
    MYSQL_PORT_COMMAND=""
    
    if ! [[ -z "$1" ]]; then
        APACHE_PORT=$1
    fi
    
    if ! [[ -z "$2" ]]; then
        MYSQL_PORT_COMMAND="-p \"$2:3306\""
    fi

    docker run -i -t -p "$APACHE_PORT:80" $MYSQL_PORT_COMMAND -v ${PWD}/app:/app -v ${PWD}/mysql:/var/lib/mysql mattrayner/lamp:latest
}
alias launchdocker='launchdockerwithparams $1 $2'
alias ldi='launchdockerwithparams $1 $2'
```

##### 使用示例
```bash
# 启动docker并映射80端口（Apache）
ldi

# 启动docker并映射8080端口（Apache）
ldi 8080

# 启动docker并映射3000端口（Apache）和3306端口（MySQL）
ldi 3000 3306
```

## 镜像开发

### 构建与运行
```bash
# 从Github克隆项目
git clone https://github.com/mattrayner/docker-lamp.git
cd docker-lamp

# 构建18.04、16.04和14.04镜像
docker build -t=mattrayner/lamp:latest -f ./1804/Dockerfile-php7 .
docker build -t=mattrayner/lamp:latest-1604 -f ./1604/Dockerfile-php7 .
docker build -t=mattrayner/lamp:latest-1404 -f ./1404/Dockerfile-php7 .

# 运行14.04镜像作为容器
docker run -p "3000:80" docker.xuanyuan.run/mattrayner/lamp:latest-1404 -d

# 等待容器启动
sleep 5

# 访问容器内容
curl "http://$(docker-machine ip):3000/"
```

### 测试
我们使用`docker-compose`设置、构建和运行测试环境，可将大量测试工作负载转移到Docker，确保在不受主机影响的一致环境中测试镜像。

### 单行测试命令
可在`docker-lamp`目录中运行以下单行测试命令，测试所有更改，并验证Apache、MySQL、PHP和phpMyAdmin的安装版本是否符合预期：
```bash
docker-compose -f docker-compose.test.yml -p ci build; docker-compose -f docker-compose.test.yml -p ci up -d; docker logs -f ci_sut_1; echo "Exited with status code: $(docker wait ci_sut_1)";
```

该命令的作用如下：

#### `docker-compose -f docker-compose.test.yml -p ci build;`
首先，构建最新版本的docker-compose镜像。

#### `docker-compose -f docker-compose.test.yml -p ci up -d;`
以守护进程模式启动容器（`web1804`、`web1604`、`web1404`和`sut`即“被测系统”）。

#### `docker logs -f ci_sut_1;`
显示`sut`容器的所有日志输出（对调试非常有用）。

#### `echo "Exited with status code: $(docker wait ci_sut_1)"`
报告`sut`容器的退出状态码。

## 灵感来源
该镜像最初基于[dgraziotin/lamp][dgraziotin-lamp]，并进行了一些修改以兼容Concrete5 CMS。此外，将其设置为Ubuntu（基础镜像）镜像，以便该项目能尽可能多地帮助用户。

## 贡献指南
如需提交错误修复或功能，可创建拉取请求，经代码审查后合并。

1. 克隆/ Fork项目
2. 创建功能分支（git checkout -b my-new-feature）
3. 提交更改（git commit -am 'Add some feature'）
4. 使用[测试](#测试)中的步骤测试更改
5. 推送到分支（git push origin my-new-feature）
6. 创建新的拉取请求

## 许可证
Docker-LAMP采用[Apache 2.0许可证][info-license]授权。

[logo]: https://cdn.rawgit.com/mattrayner/docker-lamp/831976c022782e592b7e2758464b2a9efe3da042/docs/logo.svg

[apache]: http://www.apache.org/
[mysql]: https://www.mysql.com/
[php]: http://php.net/
[phpmyadmin]: https://www.phpmyadmin.net/

[end-of-life]: http://php.net/supported-versions.php

[info-build-status]: https://circleci.com/gh/mattrayner/docker-lamp
[info-docker-hub]: https://hub.docker.com/r/mattrayner/lamp
[info-license]: LICENSE

[shield-build-status]: https://img.shields.io/circleci/project/mattrayner/docker-lamp.svg
[shield-docker-hub]: https://img.shields.io/badge/docker%20hub-mattrayner%2Flamp-brightgreen.svg
[shield-license]: https://img.shields.io/badge/license-Apache%202.0-blue.svg

[dgraziotin-lamp]: https://github.com/dgraziotin/osx-docker-lamp
