---
image: hexlo/minecraft-bedrock-server
description: "在Docker容器中运行的Minecraft基岩版服务器，支持世界和配置文件导入，便于部署和管理多实例。"
source: https://xuanyuan.cloud/zh/r/hexlo/minecraft-bedrock-server
canonical: https://xuanyuan.cloud/zh/r/hexlo/minecraft-bedrock-server
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/hexlo/minecraft-bedrock-server" title="hexlo/minecraft-bedrock-server Docker 镜像中文简介、标签列表与拉取命令">hexlo/minecraft-bedrock-server 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Minecraft基岩版服务器
Github镜像：https://github.com/hexlo/minecraft-bedrock-server


## 初始设置

你可以轻松导入世界和配置文件。以下是docker-compose.yml示例：  
适当修改卷的路径。

```yaml
version: '3'
services:

  minecraft-server:
    image: ***-ghcr.xuanyuan.run/iceoid/minecraft-bedrock-server:latest
    container_name: minecraft-server
    stdin_open: true  # 对应docker run -i
    tty: true         # 对应docker run -t
    restart: unless-stopped  # 重启策略：除非手动停止
    ports:
      - 19132:19132/udp  # 基岩版默认UDP端口
    volumes:
      - ./path_to/config:/bedrock-server/config  # 配置文件目录映射
      - ./path_to/worlds:/bedrock-server/worlds  # 世界文件目录映射
```

若需同时运行多个服务器，可为每个服务器配置不同端口，并相应进行端口转发。例如：
```yaml
    ports:
      - 20000:19132/udp  # 该服务器将运行在20000端口
```


### 配置文件说明

在你的config文件夹中，需包含以下3个文件（若需使用默认配置，可省略这些文件）：  
- **server.properties**：服务器配置文件（可根据需求编辑）  
- **allowlist.json**：白名单文件（当server.properties中设置whitelist=true时，需在此添加玩家，xuid会自动生成）  
  ```json
  [
       {
           "ignoresPlayerLimit": false,
           "name": "Player1"
       },
       {
           "ignoresPlayerLimit": false,
           "name": "Player2",
           "xuid": "12346764585"
       }
  ]
  ```
- **permissions.json**：权限配置文件（需玩家的xuid，可在添加玩家后查看白名单文件或使用在线xuid获取工具）  
  ```json
  [
       {
           "permission": "operator",  # 权限等级：operator（管理员）等
           "xuid": "12346764585"
       }
  ]
  ```


### 世界文件夹结构

世界文件夹的结构如下：
```
bedrock-server
|__worlds
     |__level  # 世界文件夹（名称可自定义）
          |__db  # 世界数据文件
             level.dat  # 世界数据
             level.dat_old  # 世界数据备份
             levelname.txt  # 世界名称文件
```


## 使用方法

### 启动服务器
服务器将随容器启动自动运行。


### 停止服务器但不停止容器
1. 连接到容器：  
   `docker attach minecraft-server`  
2. 输入停止命令：  
   `stop`  


### 使用服务器命令

首先，连接到容器：  
`docker attach minecraft-server`  

可使用[常用命令](https://minecraftbedrock-archive.fandom.com/wiki/Commands/List_of_Commands)（无需添加前缀“/”，例如直接输入`say Hello!`而非`/say Hello!`）。


### 分离容器（不停止服务器）
按下 `Ctrl+p + Ctrl+q` 组合键。
