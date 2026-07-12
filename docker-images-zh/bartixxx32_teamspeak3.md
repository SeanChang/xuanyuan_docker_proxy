---
image: bartixxx32/teamspeak3
description: "Docker官方Teamspeak镜像，用于快速部署和运行Teamspeak语音通信服务器，提供官方维护的容器化解决方案，支持便捷配置与数据持久化。"
source: https://xuanyuan.cloud/zh/r/bartixxx32/teamspeak3
canonical: https://xuanyuan.cloud/zh/r/bartixxx32/teamspeak3
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/bartixxx32/teamspeak3" title="bartixxx32/teamspeak3 Docker 镜像中文简介、标签列表与拉取命令">bartixxx32/teamspeak3 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Teamspeak Docker官方镜像文档

## 镜像概述

本镜像为Docker官方维护的[Teamspeak](https://www.teamspeak.com/)服务器容器化解决方案，对应Docker Hub上的[teamspeak官方镜像](https://registry.hub.docker.com/_/teamspeak/)。该镜像提供了标准化的Teamspeak服务器部署方式，便于用户快速搭建语音通信服务。

镜像的完整使用说明及贡献、问题反馈信息，请参考[Docker Hub页面](https://registry.hub.docker.com/_/teamspeak/)。文档源文件维护在[docker-library/docs](https://github.com/docker-library/docs)仓库的[teamspeak目录](https://github.com/docker-library/docs/tree/master/teamspeak)。

## 核心功能与特性

- **官方维护**：作为Docker官方镜像，由Docker团队与Teamspeak项目共同维护，确保安全性和稳定性
- **标准化部署**：提供统一的容器化部署流程，简化传统服务器配置步骤
- **版本同步**：镜像版本与Teamspeak官方服务器版本保持同步，支持获取最新功能
- **灵活配置**：支持通过环境变量、数据卷等方式进行个性化配置

## 使用场景

- 游戏团队语音通信服务器搭建
- 远程协作团队实时语音沟通平台
- 在线社区、公会的语音交流服务
- 企业内部团队的语音会议系统

## 使用方法

### 基本部署（docker run）

```bash
docker run -d --name docker.xuanyuan.run/teamspeak -p 9987:9987/udp -p 10011:10011 -p 30033:30033 -e TS3SERVER_LICENSE=accept teamspeak
```

#### 参数说明：
- `-p 9987:9987/udp`：映射Teamspeak语音通信端口（UDP）
- `-p 10011:10011`：映射服务器查询端口（TCP）
- `-p 30033:30033`：映射文件传输端口（TCP）
- `-e TS3SERVER_LICENSE=accept`：接受Teamspeak许可协议
- `--name teamspeak`：指定容器名称

### 数据持久化

为避免容器重启导致数据丢失，建议挂载数据卷：

```bash
docker run -d --name docker.xuanyuan.run/teamspeak -p 9987:9987/udp -p 10011:10011 -p 30033:30033 -e TS3SERVER_LICENSE=accept -v teamspeak_data:/var/ts3server teamspeak
```

其中`teamspeak_data`为持久化数据卷名称，会自动创建并存储服务器配置、用户数据等信息。

### 查看服务器初始管理员令牌

首次启动后，通过容器日志获取管理员令牌：

```bash
docker logs teamspeak
```

日志中会包含类似以下内容的管理员令牌，用于首次登录管理界面：
`token=abcdef1234567890abcdef1234567890`

## 注意事项

- 镜像更新：若需获取最新版本，可通过`docker pull docker.xuanyuan.run/teamspeak`拉取最新镜像
- 端口配置：根据实际网络环境调整端口映射，确保防火墙允许相关端口访问
- 许可协议：必须通过`TS3SERVER_LICENSE=accept`接受Teamspeak许可协议才能正常启动
- 详细文档：完整配置参数及高级用法请参考[Docker Hub官方文档](https://registry.hub.docker.com/_/teamspeak/)

## 相关资源

- [Docker Hub镜像页面](https://registry.hub.docker.com/_/teamspeak/)
- [官方文档仓库](https://github.com/docker-library/docs/tree/master/teamspeak)
- [镜像发布跟踪](https://github.com/docker-library/official-images/labels/library%2Fteamspeak)
