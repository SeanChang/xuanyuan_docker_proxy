---
image: lsioarmhf/pydio
description: "这是基于ARMHF架构的Linuxserver.io Pydio镜像，提供企业级文件共享与同步功能，支持多端访问，助力用户管控数据隐私与安全。"
source: https://xuanyuan.cloud/zh/r/lsioarmhf/pydio
canonical: https://xuanyuan.cloud/zh/r/lsioarmhf/pydio
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/lsioarmhf/pydio" title="lsioarmhf/pydio Docker 镜像中文简介、标签列表与拉取命令">lsioarmhf/pydio 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# lsioarmhf/pydio

**注意：此镜像已弃用，请使用多架构镜像 `linuxserver/pydio`**

## 镜像概述
本镜像由Linuxserver.io团队维护，是基于ARMHF架构的Pydio（原AjaXplorer）镜像。Pydio是一款成熟的开源文件共享与同步解决方案，提供直观的多端界面（Web/移动/桌面），具备企业级特性以帮助用户重新掌控数据隐私与安全。

## 核心功能
- 多端访问支持：Web、移动、桌面端无缝同步
- 企业级特性：用户目录连接器、传统文件系统驱动、全面的管理界面
- 数据隐私保障：自主部署，掌控数据存储与访问权限
- 灵活配置：支持SQLite（测试用）、MySQL/MariaDB或PostgreSQL数据库

## 使用场景
- 企业内部团队文件共享与协作
- 个人数据同步与隐私管理
- 小型组织的文档集中存储与访问控制

## 配置说明

### Docker部署示例
```bash
docker create \
--name=pydio \
-v /etc/localtime:/etc/localtime:ro \
-v <本地配置路径>:/config \
-v <本地数据路径>:/data \
-e PGID=<组ID> -e PUID=<用户ID>  \
-e TZ=<时区，如Asia/Shanghai> \
-p 443:443 \
lsioarmhf/pydio
```

### 参数解释
| 参数                | 说明                                                                 |
|---------------------|----------------------------------------------------------------------|
| `-p 443`            | 容器内部HTTPS端口映射到主机                                          |
| `-v /etc/localtime` | 同步主机时间（可选，若使用TZ变量可省略）                              |
| `-v /config`        | Pydio配置文件存储路径                                                |
| `-v /data`          | 上传文件存储路径                                                    |
| `-e PGID`           | 容器运行的组ID（需与主机数据目录权限匹配）                           |
| `-e PUID`           | 容器运行的用户ID（需与主机数据目录权限匹配）                         |
| `-e TZ`             | 设置时区（如Asia/Shanghai）                                          |

### 用户/组ID获取
使用`id <用户名>`命令获取主机用户的PUID和PGID：
```bash
id dockeruser
```

### 应用设置步骤
1. **数据库配置**：需为Pydio创建MySQL/MariaDB或PostgreSQL数据库（SQLite仅用于测试），设置时使用数据库IP而非主机名。
2. **密钥生成**：首次运行容器会生成自签名密钥，位于`/config/keys`，可替换为自定义密钥。
3. **服务器URL**：在设置向导中修改“Detected Server Url”为Pydio实例的实际URL，确保公共链接共享正常。
4. **邮件设置**：编辑`/config/ssmtp.conf`文件后重启容器以配置邮件功能。

### 其他信息
- 版本升级：通过Web界面升级到最新版本
- 日志查看：`docker logs -f pydio`
- 容器版本查询：`docker inspect -f '{{ index .Config.Labels "build_version" }}' pydio`
- 镜像版本查询：`docker inspect -f '{{ index .Config.Labels "build_version" }}' lsioarmhf/pydio`
