---
image: factoriotools/factorio
description: "搭建《异星工厂》私人服务器，为好友打造稳定联机空间，共同进入危机与机遇并存的异星世界：协作采集矿石、提炼材料，设计精密自动化生产线，研发科技解锁高级设备，在抵御异星生物突袭时分工配合，于建造与生存的沉浸式体验中增进默契，尽情享受多人联机的策略布局与创造乐趣。"
source: https://xuanyuan.cloud/zh/r/factoriotools/factorio
canonical: https://xuanyuan.cloud/zh/r/factoriotools/factorio
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/factoriotools/factorio" title="factoriotools/factorio Docker 镜像中文简介、标签列表与拉取命令">factoriotools/factorio — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/factoriotools/factorio" title="factoriotools/factorio Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/factoriotools/factorio</a>

# Factorio [![Docker 版本]([])]([]) [![Docker 拉取量]([])]([]) [![Docker 星标]([])]([])


> [!NOTE]
> ARM 架构支持为实验性，在树莓派等设备上运行可能出现崩溃或卡顿。


## 镜像标签说明

* `latest` - 最新版本（可能为实验版）。  
* `stable` - 在 [factorio.com]([]) 上标记为稳定的版本（自 2.0 起，版本先以实验版发布，稳定后会更新为此标签，详见 [FFF-435]([])）。  
* `0.x` - 某分支的最新版本（如 `2.0` 为 2.0 分支最新版）。  
* `0.x.y` - 特定版本（如 `2.0.69`）。  
* `0.x-z` - 版本的增量修复版。  


## 关于 Factorio 服务器

[Factorio]([]) 是一款工厂建造与维护主题的游戏。玩家可通过采矿、研发科技、搭建基础设施、自动化生产来扩张工厂，并抵御敌人。游戏支持自定义地图、Lua 编写模组及多人联机，且针对大规模工厂优化，运行稳定。

**注意**：本镜像仅包含服务器程序，完整游戏需从 [Factorio 官网]([])、[Steam]([])、[GOG.com]([]) 或 [Humble Bundle]([]) 购买。


## 使用指南

### 快速启动

以下示例将数据存储在 `/opt/factorio`，首次运行会生成必要的目录结构和配置文件：

```shell
# 创建数据目录并设置权限（容器内使用 UID/GID 845 运行）
sudo mkdir -p /opt/factorio
sudo chown 845:845 /opt/factorio

# 启动容器
sudo docker run -d \
  -p 34197:34197/udp \  # 游戏端口（必选）
  -p 27015:27015/tcp \  # RCON 端口（可选，用于远程命令）
  -v /opt/factorio:/factorio \  # 挂载数据卷（持久化配置、存档、模组）
  --name factorio \  # 容器名称
  --restart=unless-stopped \  # 崩溃或重启后自动启动
  factoriotools/factorio
```

**参数说明**：  
- `-d`：后台运行；  
- `-p`：端口映射；  
- `-v`：挂载宿主机目录到容器内 `/factorio`（核心，确保数据不丢失）；  
- `--restart`：自动恢复策略；  
- `--name`：自定义容器名（避免随机名称）。


#### 查看日志与配置服务器

```shell
# 查看启动日志
docker logs factorio

# 停止服务器（修改配置前需执行）
docker stop factorio

# 配置文件路径：/opt/factorio/config/server-settings.json
# 修改后重启服务器
docker start factorio
```


### 控制台命令

如需直接向服务器发送命令，启动时添加 `-it` 参数，并通过 `docker attach` 进入控制台：

```shell
# 启动容器（带交互终端）
docker run -d -it --name factorio factoriotools/factorio

# 进入控制台（按 Ctrl+P+Q 可退出但不终止容器）
docker attach factorio
```


### RCON 远程命令（2.0.18+）

适合脚本自动化，无需暴露 RCON 端口，直接通过容器内命令发送：

```shell
# 示例：发送帮助命令
docker exec factorio rcon /h
```


### 升级服务器

**升级前建议备份存档**（可在游戏客户端内完成）。步骤：

```shell
# 停止并删除旧容器（数据已通过 -v 持久化，不会丢失）
docker stop factorio
docker rm factorio

# 拉取最新镜像
docker pull factoriotools/factorio

# 重新启动（使用原命令即可）
sudo docker run -d ...  # 同快速启动步骤
```


### 存档管理

#### 自动存档与地图设置

首次启动会生成名为 `_autosave1.zip` 的存档，地图参数由 `/opt/factorio/config` 下的 `map-gen-settings.json` 和 `map-settings.json` 控制。后续启动默认加载最新存档。


#### 加载指定存档（0.17.79+）

通过环境变量指定存档，需将存档文件（不含 `.zip`）放在 `/opt/factorio/saves` 目录：

```shell
sudo docker run -d \
  -p 34197:34197/udp -p 27015:27015/tcp \
  -v /opt/factorio:/factorio \
  -e LOAD_LATEST_SAVE=false \  # 禁用加载最新存档
  -e SAVE_NAME=my_save \  # 存档名（不含 .zip）
  --name factorio factoriotools/factorio
```


#### 生成新地图或加载旧存档

- **生成新地图**：停止服务器 → 删除 `/opt/factorio/saves` 下所有存档 → 重启。  
- **加载旧存档**：停止服务器 → 对目标存档执行 `touch old_save.zip`（更新修改时间）→ 重启；或删除其他存档仅保留目标文件。


#### 指定地图预设（生成新存档时）

结合 `GENERATE_NEW_SAVE=true` 和 `PRESET` 环境变量，使用内置预设生成地图：

```shell
sudo docker run -d ... \
  -e LOAD_LATEST_SAVE=false \
  -e GENERATE_NEW_SAVE=true \  # 强制生成新存档
  -e SAVE_NAME=new_world \
  -e PRESET=death-world  # 预设名称（如 death-world 为敌人生成强化模式）
```

**常用预设值**：  
`default`（默认）、`rich-resources`（富资源）、`marathon`（马拉松模式，配方/科技成本提高）、`death-world`（死亡世界，敌人强化）、`rail-world`（铁路世界，资源分散）等。


### 模组管理

1. **手动安装**：将模组（`.zip`）复制到 `/opt/factorio/mods` 目录，重启服务器。  

2. **自动更新模组（0.17+）**：  
   设置 `UPDATE_MODS_ON_START=true`，并提供 Factorio 账号的 `USERNAME` 和 `TOKEN`（在 [Factorio 个人资料]([]) 获取）。  

3. **跳过指定模组更新**：  
   通过 `UPDATE_IGNORE=mod1,mod2` 忽略特定模组（逗号分隔名称），避免兼容性问题。  

**注意**：Space Age DLC 的内置模组（`elevated-rails`、`quality`、`space-age`）会自动跳过更新，无需单独下载。


### 场景（Scenario）管理

#### 从零启动场景

使用场景启动需指定备用入口点，示例：

```shell
docker run -d \
  -p 34197:34197/udp -p 27015:27015/tcp \
  -v /opt/factorio:/factorio \
  --name factorio \
  --entrypoint "/scenario.sh" \  # 场景入口点
  factoriotools/factorio \
  MyScenarioName  # 场景名称（位于 Scenarios 目录下）
```


#### 场景转存档

将场景转换为可加载的存档，使用 `scenario2map.sh`：

```shell
docker run -d ... \
  --entrypoint "/scenario2map.sh" \
  factoriotools/factorio MyScenarioName
```


### 权限管理（白名单/黑名单/管理员列表）

在 `/opt/factorio/config` 目录创建对应 JSON 文件：

- **白名单**（0.15.3+）：`server-whitelist.json`  
  ```json
  ["允许的玩家1", "允许的玩家2"]
  ```

- **黑名单**（0.17.1+）：`server-banlist.json`  
  ```json
  ["禁止的玩家1", "禁止的玩家2"]
  ```

- **管理员列表**（0.17.1+）：`server-adminlist.json`  
  ```json
  ["管理员1", "管理员2"]
  ```


### 环境变量配置

通过环境变量自定义服务器行为，常用参数如下：

| 变量名               | 说明                                  | 默认值         | 支持版本   |
|----------------------|---------------------------------------|----------------|------------|
| `LOAD_LATEST_SAVE`   | 是否加载最新存档（false 则用 `SAVE_NAME`） | true           | 0.17+      |
| `GENERATE_NEW_SAVE`  | 是否生成新存档（需配合 `SAVE_NAME`）   | false          | 0.17+      |
| `SAVE_NAME`          | 指定存档名（不含 .zip）               | _autosave1     | 0.17+      |
| `PRESET`             | 地图预设（生成新存档时）              | -              | 0.17+      |
| `PORT`               | 游戏端口（UDP）                       | 34197          | 0.15+      |
| `RCON_PORT`          | RCON 端口（TCP）                      | 27015          | 0.15+      |
| `UPDATE_MODS_ON_START` | 启动时更新模组                       | -              | 0.17+      |
| `USERNAME`/`TOKEN`   | Factorio 账号（用于模组更新）         | -              | 0.17+      |


## Docker Compose 配置

创建 `docker-compose.yml`：

```yaml
version: '2'
services:
  factorio:
    image: factoriotools/factorio
    ports:
      - "34197:34197/udp"  # 游戏端口
      - "27015:27015/tcp"  # RCON 端口
    volumes:
      - /opt/factorio:/factorio  # 数据卷
    restart: unless-stopped
```

启动命令：

```shell
# 准备目录（同快速启动步骤）
sudo mkdir -p /opt/factorio
sudo chown 845:845 /opt/factorio

# 启动服务（后台运行）
docker-compose up -d
```


## LAN 局域网游戏

1. 修改 `/opt/factorio/config/server-settings.json`，开启局域网可见：  
   ```json
   "visibility": { "public": false, "lan": true }
   ```

2. 启动容器时添加 `--network=host`，使客户端能自动发现服务器：  
   ```shell
   sudo docker run -d \
     --network=host \  # 共享宿主机网络
     -v /opt/factorio:/factorio \
     --name factorio --restart=unless-stopped factoriotools/factorio
   ```


## 无根 Docker 支持（实验性）

适合无根 Docker 环境，避免权限问题，镜像标签带 `-rootless` 后缀（如 `stable-rootless`）。特点：

- 无需 `chown` 目录权限；  
- 默认以 UID 1000 运行；  
- 不支持 PUID/PGID 动态映射。

**快速启动**：

```shell
docker run -d \
  -p 34197:34197/udp -p 27015:27015/tcp \
  -v ~/factorio:/factorio \  # 宿主机用户目录（无需权限设置）
  --name factorio --restart=unless-stopped \
  factoriotools/factorio:stable-rootless
```


## 常见问题

### 权限错误

如遇 `chown: Operation not permitted` 或文件权限异常：  
- 升级 Docker 至 20.x+；  
- 使用 `-rootless` 镜像；  
- 参考 [权限问题指南](./PERMISSION_ISSUES_GUIDE.md)。


### 服务器列表可见但无法连接

日志中若出现 `Own address is RIGHT IP:WRONG PORT`，可能是 Docker 代理导致端口检测错误。解决：  
- 禁用 Docker 用户态代理：启动 Docker 服务时添加 `--userland-proxy=false`（具体配置因系统而异）；  
- 检查防火墙或端口转发是否正确。


## 贡献者

- [dtandersen]([])（维护者）  
- [Fank]([])（版本更新监控）  
- [SuperSandro2000]([])（CI 与维护）  
- [DBendit]([])（权限列表支持）  
- [Zopanix]([])（原作者）  
- 其他贡献者：[Rfvgyhn]([])、[gnomus]([])、[bplein]([]) 等。
