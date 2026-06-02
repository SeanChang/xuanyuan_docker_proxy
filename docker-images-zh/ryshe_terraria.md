<!-- xuanyuan-docker-images-zh
image: ryshe/terraria
source: https://xuanyuan.cloud/zh/r/ryshe/terraria
canonical: https://xuanyuan.cloud/zh/r/ryshe/terraria
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [ryshe/terraria — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/ryshe/terraria "ryshe/terraria Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/ryshe/terraria

# Terraria Docker镜像文档  

**TShock & Vanilla & Mobile 版本支持**  


## 镜像概述和主要用途  

本镜像是将[TShock](https://github.com/Pryaxis/TShock/releases)和[Terraria](https://terraria.org/)的`TerrariaServer.exe`容器化的Docker镜像，使其可在Linux系统中运行。通过Docker容器化部署，用户无需手动配置Linux环境依赖，即可快速搭建Terraria服务器，特别适合初学者。镜像支持TShock（含1.4版本预发布版）、Vanilla及Mobile（移动版）服务器，满足不同版本需求。  


## 核心功能和特性  

- **容器化部署**：简化Linux环境下的依赖管理，一键启动服务器  
- **多版本支持**：包含TShock预发布版（适配Terraria 1.4）、Vanilla版及Mobile专用版（`mobile-1.4.0.5`标签）  
- **数据持久化**：通过卷挂载实现世界文件、配置文件及日志的持久化存储  
- **插件扩展**：支持TShock插件，可通过卷挂载自定义插件目录  
- **日志管理**：支持日志目录独立挂载，便于外部存储和分析  
- **简易更新**：通过拉取最新镜像快速更新服务器版本  
- **交互式配置**：支持首次运行时通过交互式命令生成世界或配置服务器  


## 使用场景和适用范围  

- **用户群体**：适合希望在Linux系统（物理机、虚拟机或云服务器）上搭建Terraria服务器的用户，尤其适合初学者  
- **世界规模**：支持小型（1）、中型（2）、大型（3）世界生成  
- **并发用户**：建议8人以下服务器配置1-1.5GB内存  
- **部署环境**：兼容所有支持Docker的Linux发行版，云服务器需开放TCP/UDP 7777端口  


## 环境准备  

### 系统要求  
- Linux系统（支持Docker），1-1.5GB内存（小型/中型世界，≤8用户）  
- 已安装[Docker](https://docs.docker.com/get-docker/)，并确保Docker服务运行（`systemctl start docker`）  


## 快速启动指南  

### 步骤1：创建持久化目录  
创建目录用于存储世界文件、配置及日志（避免容器删除后数据丢失）：  
```bash
mkdir -p $HOME/terraria/world  # 世界文件和配置  
mkdir -p $HOME/terraria/plugins  # 插件（可选）  
mkdir -p $HOME/terraria/logs  # 日志（可选）  
```  


### 步骤2：生成新世界  

#### 方式1：命令行快速生成  
通过命令行指定世界大小（1=小型，2=中型，3=大型）直接生成世界：  
```bash
docker run -it -p 7777:7777 --rm \
  -v $HOME/terraria/world:/root/.local/share/Terraria/Worlds \
  ryshe/terraria:latest \
  -world /root/.local/share/Terraria/Worlds/<世界名称>.wld \
  -autocreate <世界大小>
```  
**说明**：  
- `<世界名称>`：自定义世界文件名（无需`.wld`后缀，生成后自动添加）  
- `<世界大小>`：1（小型）、2（中型）或3（大型）  
- `-it`：交互式模式，生成过程中需确认设置（如世界名称、难度）  
- 生成完成后建议关闭终端，修改`config.json`配置（如服务器密码）  


#### 方式2：交互式生成  
通过交互式终端自定义世界参数（如名称、难度、种子）：  
```bash
docker run -it -p 7777:7777 --rm \
  -v $HOME/terraria/world:/root/.local/share/Terraria/Worlds \
  ryshe/terraria:latest
```  


### 步骤3：运行已有世界  
生成世界后，通过后台模式启动服务器并加载世界：  
```bash
docker run -d --rm --name="terraria-server" \
  -p 7777:7777 \
  -v $HOME/terraria/world:/root/.local/share/Terraria/Worlds \
  -e WORLD_FILENAME=<世界文件名>.wld \  # 环境变量指定世界文件
  ryshe/terraria:latest
```  
**参数说明**：  
- `-d`：后台运行，关闭终端不影响服务器  
- `--name`：自定义容器名称，便于管理  
- `-e WORLD_FILENAME`：指定世界文件（需在`$HOME/terraria/world`目录下）  


## 更新容器  

1. 拉取最新镜像：  
   ```bash
   docker pull ryshe/terraria:latest
   ```  

2. 停止并删除旧容器（需替换`<容器ID/名称>`）：  
   ```bash
   docker rm -f <容器ID/名称>  # 如上文的"terraria-server"
   ```  

3. 重新启动容器（参考[步骤3：运行已有世界](#步骤3运行已有世界)）  


## 从源码构建  

如需自定义镜像（如修改TShock版本），可从源码构建：  

1. 克隆仓库：  
   ```bash
   git clone https://github.com/ryansheehan/terraria.git && cd terraria
   ```  

2. （可选）修改Dockerfile中的TShock版本（默认使用最新预发布版）：  
   ```dockerfile
   # 替换为目标TShock版本的下载链接
   ADD https://github.com/Pryaxis/TShock/releases/download/v<版本号>/<TShock压缩包> /
   ```  

3. 构建镜像：  
   ```bash
   docker build -t my-terraria:latest .  # "my-terraria"为自定义镜像名称
   ```  


## 配置说明  

### 环境变量  

| 变量名               | 说明                          | 示例值                |  
|----------------------|-------------------------------|-----------------------|  
| `WORLD_FILENAME`     | 指定启动时加载的世界文件名    | `my_world.wld`        |  


### 命令行参数  

可在`docker run`命令的镜像名称后添加TShock服务器参数，完整参数参考[TShock文档](https://tshock.readme.io/docs/command-line-parameters)。常用参数：  

| 参数                  | 说明                          | 示例                  |  
|-----------------------|-------------------------------|-----------------------|  
| `-autocreate <size>`  | 自动创建世界（1=小，2=中，3=大） | `-autocreate 2`       |  
| `-world <path>`       | 指定世界文件路径              | `-world /path/world.wld` |  
| `-password <pwd>`     | 设置服务器密码                | `-password myserver123` |  
| `-maxplayers <num>`   | 最大玩家数                    | `-maxplayers 8`       |  


### 卷挂载  

通过`-v`参数挂载目录实现数据持久化，支持以下目录：  

| 宿主机目录                | 容器内路径                          | 用途                          |  
|---------------------------|-------------------------------------|-------------------------------|  
| `$HOME/terraria/world`    | `/root/.local/share/Terraria/Worlds` | 世界文件、配置文件（`config.json`） |  
| `<插件目录>`              | `/plugins`                          | TShock插件（需提前创建目录）  |  
| `<日志目录>`              | `/tshock/logs`                      | 服务器日志（避免容器内堆积）  |  


## 高级功能  

### 插件支持  

1. 创建插件目录：  
   ```bash
   mkdir -p $HOME/terraria/plugins
   ```  

2. 启动时挂载插件目录：  
   ```bash
   docker run -d --rm --name="terraria-server" \
     -p 7777:7777 \
     -v $HOME/terraria/world:/root/.local/share/Terraria/Worlds \
     -v $HOME/terraria/plugins:/plugins \  # 挂载插件目录
     -e WORLD_FILENAME=my_world.wld \
     ryshe/terraria:latest
   ```  


### 日志管理  

挂载日志目录到宿主机，避免日志占用容器空间：  
```bash
docker run -d --rm --name="terraria-server" \
  -p 7777:7777 \
  -v $HOME/terraria/world:/root/.local/share/Terraria/Worlds \
  -v $HOME/terraria/logs:/tshock/logs \  # 挂载日志目录
  -e WORLD_FILENAME=my_world.wld \
  ryshe/terraria:latest
```  

**日志大小限制**：添加`--log-opt max-size=200k`限制单日志文件大小，避免磁盘占满：  
```bash
docker run -d --rm --name="terraria-server" \
  --log-opt max-size=200k \  # 限制日志文件大小为200KB
  -p 7777:7777 \
  -v $HOME/terraria/world:/root/.local/share/Terraria/Worlds \
  -e WORLD_FILENAME=my_world.wld \
  ryshe/terraria:latest
```  


## 注意事项  

1. **权限**：部分系统可能需要`sudo`执行`docker`命令（如`sudo docker run ...`）。  
2. **端口开放**：云服务器需在防火墙/安全组中开放TCP和UDP端口7777。  
3. **内存要求**：小型/中型世界（≤8人）建议1-1.5GB内存，大型世界或更多玩家需增加内存。  
4. **移动版支持**：使用`mobile-1.4.0.5`标签启动移动版服务器（需参考[官方指南](https://forums.terraria.org/index.php?threads/terraria-mobile-1-3-multiplayer-setup-guide.82210/)配置）：  
   ```bash
   docker run -it -p 7777:7777 --rm \
     -v $HOME/terraria/world:/root/.local/share/Terraria/Worlds \
     ryshe/terraria:mobile-1.4.0.5
   ```  
5. **TShock文档**：服务器管理细节（如命令行参数、权限配置）参考[TShock官方文档](https://tshock.readme.io/)。  


## 贡献与开发  

若发现文档或镜像问题，可通过以下方式贡献：  
1. Fork [GitHub仓库](https://github.com/ryansheehan/terraria)  
2. 创建特性分支：`git checkout -b my-new-feature`  
3. 提交修改：`git commit -am 'Add some feature'`  
4. 推送分支：`git push origin my-new-feature`  
5. 提交Pull Request  

问题反馈可发送邮件至：rsheehan@gmail.com  


## TODO  

-  Fork TShock项目并编写Dockerfile直接构建源码  
-  完善移动版服务器测试与文档  

---  

[TShock]: https://github.com/Pryaxis/TShock/releases  
[Docker]: https://docs.docker.com/get-docker/
