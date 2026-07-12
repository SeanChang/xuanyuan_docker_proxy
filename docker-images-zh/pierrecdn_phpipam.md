---
image: pierrecdn/phpipam
description: "phpIPAM是一款开源的Web IP地址管理应用，旨在提供轻量且简单的IP地址管理功能，由Miha Petkovsek开发维护，基于GPL v3许可。"
source: https://xuanyuan.cloud/zh/r/pierrecdn/phpipam
canonical: https://xuanyuan.cloud/zh/r/pierrecdn/phpipam
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/pierrecdn/phpipam" title="pierrecdn/phpipam Docker 镜像中文简介、标签列表与拉取命令">pierrecdn/phpipam 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# docker-phpipam

phpIPAM是一款开源的Web IP地址管理应用，其目标是提供轻量且简单的IP地址管理解决方案。该项目由Miha Petkovsek开发并维护，基于GPL v3许可发布，项目源码可在[此处](https://github.com/phpipam/phpipam)获取。更多信息请访问[phpIPAM官网](http://phpipam.net)。

![phpIPAM logo](http://phpipam.net/wp-content/uploads/2014/12/phpipam_logo_small.png)

## 如何使用此Docker镜像

### MySQL数据库

运行一个专用于phpipam的MySQL数据库容器：

```bash
$ docker run --name phpipam-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -v /my_dir/phpipam:/var/lib/mysql -d mysql:5.6
```

在此命令中，数据存储在主机系统的`/my_dir/phpipam`目录下，并使用指定的root密码。

### Phpipam容器

```bash
$ docker run -ti -d -p 80:80 -e MYSQL_ENV_MYSQL_ROOT_PASSWORD=my-secret-pw --name ipam --link phpipam-mysql:mysql pierrecdn/phpipam
```

此命令将两个容器链接起来，并暴露HTTP端口。

### 首次安装步骤

* 访问 `http://<ip>[:<特定端口>]/install/`
* 步骤1：选择"Automatic database installation"（自动数据库安装）

![step1](https://cloud.githubusercontent.com/assets/4225738/8746785/01758b9e-2c8d-11e5-8643-7f5862c75efe.png)

* 步骤2：重新输入连接信息

![step2](https://cloud.githubusercontent.com/assets/4225738/8746789/0ad367e2-2c8d-11e5-80bb-f5093801e139.png)

* 注意：这两个步骤的顺序可以通过修补phpipam来交换（参见https://github.com/phpipam/phpipam/issues/25）
* 步骤3：配置管理员用户密码

![step3](https://cloud.githubusercontent.com/assets/4225738/8746790/0c434bf6-2c8d-11e5-9ae7-b7d1021b7aa0.png)

* 完成安装！

![done](https://cloud.githubusercontent.com/assets/4225738/8746792/0d6fa34e-2c8d-11e5-8002-3793361ae34d.png)

### Docker Compose配置

您也可以使用Docker Compose创建一体化的YAML部署描述文件，如下所示：

```yaml
version: '2'

services:
  mysql:
    image: docker.xuanyuan.run/mysql:5.6
    environment:
      - MYSQL_ROOT_PASSWORD=my-secret-pw
    restart: always
    volumes:
      - db_data:/var/lib/mysql
  ipam:
    depends_on:
      - mysql
    image: docker.xuanyuan.run/pierrecdn/phpipam
    environment:
      - MYSQL_ENV_MYSQL_USER=root
      - MYSQL_ENV_MYSQL_ROOT_PASSWORD=my-secret-pw
      - MYSQL_ENV_MYSQL_HOST=mysql
    ports:
      - "80:80"
volumes:
  db_data:
```

然后运行：

```bash
$ docker-compose up -d
```

您还可以将`MYSQL_ENV_PASSWORD_FILE`环境变量指向一个文件，此时该文件的内容将被用作密码。这使得可以使用Docker Secrets等功能：

```yaml
version: '3'

services:
  ipam:
    environment:
      - MYSQL_ENV_MYSQL_PASSWORD_FILE=/run/secrets/phpipam_mysql_root_password
    secrets:
      - phpipam_mysql_root_password
```

可以通过运行`echo my-secret-pw | docker secret create phpipam_mysql_root_password -`来创建密钥。

### 高级配置

以下是phpipam容器中可用的环境变量列表，可使用`-e`参数传递给docker。运行容器并不实际需要这些变量，它们仅用于调整行为。

| 环境变量 | 默认值 | 描述 |
| ------------------------------ |:-------------:| --------------------------------------------------------------------------------------------------------:|
| MYSQL_ENV_MYSQL_HOST | mysql | 用于连接MySQL实例的主机名 |
| MYSQL_ENV_MYSQL_USER | root | 连接MySQL实例的用户名 |
| MYSQL_ENV_MYSQL_ROOT_PASSWORD | (空) | MySQL密码，可在首次安装时通过Web UI设置 |
| MYSQL_ENV_MYSQL_DB | phpipam | 要连接的MySQL数据库名称 |
| MYSQL_ENV_MYSQL_PASSWORD_FILE | (空) | 包含密码的文件（如果不使用MYSQL_ROOT_PASSWORD），允许利用Docker Secrets |
| PHPIPAM_BASE | / | phpipam运行的基础URI，在使用反向代理重写时有用 |
| GMAPS_API_KEY | (空) | Google Maps API密钥，用于显示设备地图 |
| GMAPS_API_GEOCODE_KEY | (空) | Google Maps地理编码API密钥，用于根据设备地址/位置查找坐标 |

### 特定集成（HTTPS、多主机容器等）

根据您的需求和Docker设置，需要暴露相应资源。

对于HTTPS，在phpipam容器前运行反向代理并链接到它。

对于多主机容器，暴露端口，运行etcd或consul以实现服务发现等。

### 注意事项

phpIPAM由Miha团队积极开发中。要升级版本，只需将`PHPIPAM_VERSION`环境变量设置为目标版本（参见[phpIPAM发布页面](https://github.com/phpipam/phpipam/releases)）。
