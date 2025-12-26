# hpretl/iic-osic-tools  Docker 部署完整教程

![hpretl/iic-osic-tools  Docker 部署完整教程](https://img.xuanyuan.dev/docker/blog/docker-iic-osic-tools.png)

*分类: Docker | 标签: hpretliic-osic-tools,docker,部署教程 | 发布时间: 2025-10-10 03:33:09*

> hpretl/iic-osic-tools 的全称是 Integrated Infrastructure for Collaborative Open Source IC Tools（协作式开源集成电路工具集成环境），是由奥地利约翰内斯·开普勒大学（JKU）集成电路系（ICD）维护的一款「all-in-one」Docker/Podman 容器——简单说，它把 IC（集成电路）设计中需要的几十种开源工具、多款工艺库（PDK）打包成了一个现成的容器，不用你一个个下载、配置环境，拉取镜像就能直接用。

## 一、hpretl/iic-osic-tools 到底是什么？有什么用？
hpretl/iic-osic-tools 的全称是 **Integrated Infrastructure for Collaborative Open Source IC Tools**（协作式开源集成电路工具集成环境），是由奥地利约翰内斯·开普勒大学（JKU）集成电路系（ICD）维护的一款「all-in-one」Docker/Podman 容器——简单说，它把 IC（集成电路）设计中需要的几十种开源工具、多款工艺库（PDK）打包成了一个现成的容器，不用你一个个下载、配置环境，拉取镜像就能直接用。

### 它能解决 IC 设计中的哪些痛点？
做 IC 设计（不管是数字电路还是模拟电路）的人都知道，最麻烦的不是设计本身，而是**环境搭建**：比如要装仿真工具 ngspice、布局工具 klayout、综合工具 yosys，还要配工艺库（PDK），不同工具依赖的系统库版本不一样，很容易出现「A 工具装好了，B 工具因为依赖冲突启动不了」的问题；甚至同一工具在 Windows、Linux、macOS 上的配置步骤都不同，新手往往要卡好几天。

而 iic-osic-tools 直接把这些问题全解决了：
- **工具全集成**：预装了 50+ 款开源 IC 设计工具，从数字电路的 RTL 综合（yosys）、时序分析（opensta），到模拟电路的 schematic 绘制（xschem）、SPICE 仿真（ngspice），再到 GDS 查看（klayout）、代码覆盖率分析（covered），甚至 RISC-V 工具链都包含在内，不用再单独找安装包；
- **PDK 预配置**：自带 3 款主流开源工艺库（PDK）——SkyWater 的 sky130A（130nm CMOS）、Global Foundries 的 gf180mcuC（180nm CMOS）、IHP 的 ihp-sg13g2（130nm SiGe BiCMOS），支持一键切换，不用手动下载、配置 PDK 路径；
- **多架构支持**：原生兼容 x86_64（常见的 Intel/AMD 电脑）和 aarch64（ARM 架构，比如 M1/M2 苹果电脑、ARM 服务器），底层基于 Ubuntu 24.04 LTS，稳定性有保障；
- **多模式适配**：支持 4 种使用方式——浏览器访问的 VNC 桌面（适合远程/新手）、本地 X11 窗口（访问表现快，适合本地开发）、Jupyter Notebook（适合教学/脚本化设计）、VS Code 开发容器（适合团队协作），不管是新手学习还是工程师做项目都能用。

### 谁适合用它？
- **IC 设计初学者/学生**：不用纠结环境，打开就能学工具操作，快速入门数字/模拟 IC 设计流程；
- **独立开发者/小团队**：省去搭建团队统一环境的时间，大家用同一个容器，避免「你这能跑我这报错」的问题；
- **资深工程师**：支持自定义配置（比如挂载自己的设计目录、修改环境变量），也能直接用命令行模式，兼顾效率和灵活性。


## 二、准备工作：先装 Docker（没装的看这里）
iic-osic-tools 是 Docker 容器，所以必须先装 Docker 和 Docker Compose。如果你的 Linux 系统还没装，直接用下面的**一键安装脚本**——它会自动装 Docker、Docker Compose，还会配置轩辕镜像访问支持源，拉取 iic-osic-tools 镜像时更快，支持 Ubuntu、CentOS、Debian 等主流 Linux 发行版。

```bash
# 一键安装 Docker、Docker Compose 并配置轩辕镜像访问支持
bash <(wget -qO- https://xuanyuan.cloud/docker.sh)
```

执行完脚本后，关闭当前终端再重新打开，输入 `docker --version` 和 `docker compose --version`，能看到版本号就说明装好了（比如 `Docker version 26.0.0, build 2ae903e`）。


## 三、部署步骤：从获取代码到启动容器
整个流程分 4 步：获取仓库代码 → 拉取镜像 → 启动容器（选适合你的模式）→ 验证使用。每个步骤都写了「新手操作」和「高级配置」，跟着做就行。


### 步骤 1：获取 iic-osic-tools 仓库代码
官方提供的启动脚本（比如 `start_vnc.sh`、`start_x.sh`）在 GitHub 仓库里，所以要先把仓库代码克隆到本地。

#### 新手操作：用 Git 克隆（推荐）
如果你的系统没装 Git，先装：
```bash
# Ubuntu/Debian 系统
sudo apt update && sudo apt install -y git

# CentOS/RHEL 系统
sudo dnf install -y git
```

然后克隆仓库（浅克隆，只拉最新版本，节省空间和时间）：
```bash
git clone --depth=1 https://github.com/iic-jku/iic-osic-tools.git
```

克隆完成后，进入仓库目录（后续所有启动命令都要在这个目录下执行）：
```bash
cd iic-osic-tools
```

#### 备选：下载 ZIP 包（没装 Git 也能弄）
如果不想装 Git，直接在 GitHub 仓库页面下载 ZIP 包：
1. 打开 https://github.com/iic-jku/iic-osic-tools
2. 点击右上角绿色的「Code」按钮，选择「Download ZIP」
3. 把下载的 ZIP 包解压到你想放的目录（比如 `~/iic-osic-tools`）
4. 打开终端，进入解压后的目录：`cd ~/iic-osic-tools`


### 步骤 2：拉取 iic-osic-tools 镜像
仓库里的启动脚本会自动拉取镜像，但为了避免第一次启动时等太久，也可以手动拉取（用轩辕镜像源，比 Docker Hub 快）。

#### 新手操作：直接拉取最新版
```bash
# 从轩辕镜像拉取最新版 iic-osic-tools 镜像
docker pull xuanyuan.cloud/r/hpretl/iic-osic-tools:latest

# 给镜像改个短名（可选，后续命令更简洁）
docker tag xuanyuan.cloud/r/hpretl/iic-osic-tools:latest hpretl/iic-osic-tools:latest
```

#### 高级操作：拉取指定版本
如果需要特定版本（比如 2024.12），可以指定标签（Tag），标签列表可以在轩辕镜像页面看：https://xuanyuan.cloud/r/hpretl/iic-osic-tools
```bash
# 拉取 2024.12 版本
docker pull xuanyuan.cloud/r/hpretl/iic-osic-tools:2024.12
docker tag xuanyuan.cloud/r/hpretl/iic-osic-tools:2024.12 hpretl/iic-osic-tools:2024.12
```

#### 验证镜像是否拉取成功
输入以下命令，能看到 `hpretl/iic-osic-tools` 相关的记录就对了：
```bash
docker images | grep hpretl/iic-osic-tools
```

> 注意：镜像大小约 4GB，解压后会占用 20GB 左右的磁盘空间，确保你的磁盘有足够空间（可以用 `df -h` 查看剩余空间）。


### 步骤 3：启动容器（4 种模式任选，推荐新手先试 VNC 模式）
iic-osic-tools 支持 4 种启动模式，分别适合不同场景，下面逐一讲操作步骤。


#### 模式 1：VNC 桌面模式（推荐新手/远程使用）
这种模式会启动一个 XFCE 桌面环境，你可以用浏览器访问（noVNC），也能用 VNC 客户端连接，不用装额外工具，最容易上手。

##### 新手操作：一键启动
在 `iic-osic-tools` 目录下执行启动脚本：
```bash
# Linux/macOS 系统
./start_vnc.sh

# Windows 系统（用 PowerShell 或 cmd，进入目录后）
.\start_vnc.bat
```

第一次启动时，会自动拉取镜像（如果之前没手动拉），耐心等几分钟（取决于网速）。启动成功后，会看到类似这样的提示：
```
Webserver available at http://localhost:80
VNC server available at localhost:5901
Default password: abc123
```

然后打开浏览器，输入 `http://localhost`（如果是服务器，把 `localhost` 换成服务器 IP），输入默认密码 `abc123`，就能看到 XFCE 桌面了——桌面上有 klayout、xschem、yosys 等工具的快捷方式，双击就能打开用。

##### 高级操作：自定义配置（改端口、设计目录等）
如果默认配置不符合需求（比如 80 端口被占用、想把设计文件存在 `/data/ic-designs` 目录），可以通过「设置环境变量」修改参数，常见参数如下：

| 环境变量          | 默认值（Linux/macOS）       | 作用说明                                                                 |
|-------------------|-----------------------------|--------------------------------------------------------------------------|
| `DESIGNS`         | `$HOME/eda/designs`         | 宿主机上存放设计文件的目录，会挂载到容器内的 `/foss/designs`（持久化数据） |
| `WEBSERVER_PORT`  | 80                          | 浏览器访问的端口（比如改 8080 避免冲突）                                 |
| `VNC_PORT`        | 5901                        | VNC 客户端连接的端口（0 表示禁用）                                       |
| `DOCKER_TAG`      | `latest`                    | 指定用哪个版本的镜像（比如 `2024.12`）                                   |
| `CONTAINER_NAME`  | `iic-osic-tools_xvnc_uid_xxx` | 容器名称，方便后续管理（比如 `my-osic-vnc`）                             |
| `DRY_RUN`         | 未设置                      | 设为任意值（比如 `1`），只打印命令不实际执行（用于调试）                 |

**示例：修改端口和设计目录**
```bash
# 把浏览器端口改成 8080，设计目录放在 /data/ic-designs，启动 VNC 模式
DESIGNS=/data/ic-designs WEBSERVER_PORT=8080 ./start_vnc.sh
```

启动后，浏览器访问 `http://localhost:8080`，设计文件会存在宿主机的 `/data/ic-designs` 目录（容器内对应 `/foss/designs`），即使容器删除，文件也不会丢。


#### 模式 2：本地 X11 模式（推荐本地开发，访问表现快）
这种模式会把容器内的工具窗口直接显示在你的本地桌面（比如 Linux 的 GNOME、macOS 的 XQuartz、Windows 的 WSLg），比 VNC 快很多，还支持复制粘贴（VNC 偶尔会有延迟）。

##### 不同系统的操作步骤
###### （1）Linux 系统（最简单，直接启动）
Linux 自带 X11 服务，直接在 `iic-osic-tools` 目录下执行：
```bash
./start_x.sh
```

启动后，会自动打开一个终端窗口，在这个终端里输入工具命令（比如 `klayout` 打开布局工具、`xschem` 打开 schematic 工具），窗口会直接显示在你的桌面。

###### （2）macOS 系统（需要装 XQuartz）
macOS 没有自带 X11，要先装 XQuartz：
1. 下载 XQuartz：https://www.xquartz.org/，双击安装（需要重启电脑）；
2. 打开 XQuartz，在顶部菜单选「XQuartz → 偏好设置 → 安全性」，勾选「允许来自网络客户端的连接」；
3. 打开终端，进入 `iic-osic-tools` 目录，执行：
   ```bash
   ./start_x.sh
   ```
4. 启动后，在弹出的终端里输入 `klayout`，就能看到工具窗口了。

> 注意：macOS 用 Docker 时，不要开「VirtioFS 加速目录共享」（Docker Desktop → 设置 → 资源 → 文件共享 → 取消勾选「Enable VirtioFS accelerated directory sharing」），否则挂载的设计目录可能访问不了。

###### （3）Windows 系统（用 WSLg，需装 WSL2）
Windows 要通过 WSL2 的 WSLg 来支持 X11，步骤如下：
1. 先装 WSL2（打开 PowerShell，执行 `wsl --install`，重启电脑）；
2. 打开 WSL2 终端（比如 Ubuntu 子系统），按步骤 1 装 Git、克隆仓库、进入 `iic-osic-tools` 目录；
3. 执行：
   ```bash
   ./start_x.sh
   ```
4. 在弹出的终端里输入 `klayout`，窗口会显示在 Windows 桌面（和 WSL 窗口并列）。

##### 高级操作：自定义设计目录和镜像版本
和 VNC 模式一样，也可以通过环境变量修改配置，比如把设计目录改成 `/mnt/d/ic-designs`（Windows WSL 下的 D 盘）：
```bash
# Linux/macOS：设计目录放在 ~/my-ic-projects
DESIGNS=~/my-ic-projects ./start_x.sh

# Windows WSL：设计目录放在 D 盘的 ic-designs 文件夹
DESIGNS=/mnt/d/ic-designs ./start_x.sh
```


#### 模式 3：Shell 模式（高级用户，无图形界面）
如果只需要用命令行工具（比如用 `yosys` 做综合、`ngspice` 跑仿真脚本），不需要图形界面，可以用 Shell 模式，启动更快，占用资源更少。

##### 启动命令
```bash
# 普通用户模式（推荐，避免权限问题）
./start_shell.sh

# root 权限模式（需要修改文件权限时用，比如装额外工具）
CONTAINER_USER=0 CONTAINER_GROUP=0 ./start_shell.sh
```

启动后，会进入容器的命令行终端，在这里可以执行任何 IC 设计命令，比如：
- `yosys -help`：查看综合工具帮助；
- `ngspice test.sp`：运行 SPICE 仿真脚本；
- `sak-pdk list`：查看已装的 PDK。


#### 模式 4：VS Code 开发容器（团队协作首选）
如果习惯用 VS Code 写代码（比如用 Python 写 GDS 生成脚本、用 Verilog 写 RTL），可以把 iic-osic-tools 作为 VS Code 的开发容器，工具和代码在同一个环境里，团队成员用同一个配置，不会有环境差异。

##### 操作步骤
1. 装 VS Code 和「Remote - Containers」插件（打开 VS Code → 扩展 → 搜索「Remote - Containers」→ 安装）；
2. 用 VS Code 打开 `iic-osic-tools` 目录（「文件 → 打开文件夹」，选择克隆的仓库目录）；
3. 点击 VS Code 左下角的「><」图标（远程窗口图标），选择「Reopen in Container」；
4. 在弹出的窗口里，选择「From Docker Hub / Other Registry」，输入镜像地址：`xuanyuan.cloud/r/hpretl/iic-osic-tools:latest`，按回车；
5. VS Code 会自动拉取镜像、启动容器，等待几分钟后，就能在 VS Code 里用终端执行工具命令（比如 `klayout` 会弹出窗口），也能直接编辑代码（比如 `test.v`  RTL 文件）。

##### 高级配置：自定义 devcontainer
如果需要自定义（比如挂载额外目录、装插件），可以在 `iic-osic-tools` 目录下创建 `.devcontainer/devcontainer.json` 文件，内容示例：
```json
{
  "name": "IC Design Environment",
  "image": "xuanyuan.cloud/r/hpretl/iic-osic-tools:latest",
  "mounts": [
    // 挂载宿主机的设计目录到容器内的 /foss/my-designs
    "source=${localEnv:HOME}/ic-designs,target=/foss/my-designs,type=bind"
  ],
  "customizations": {
    "vscode": {
      // 自动装 VS Code 插件（比如 Verilog 语法高亮）
      "extensions": [
        "mshr-h.veriloghdl",
        "eirikpre/verilog-format"
      ]
    }
  }
}
```
保存后，重新「Reopen in Container」，配置就会生效。


### 步骤 4：PDK 切换（核心功能，必学）
PDK（Process Development Kit，工艺开发包）是 IC 设计的「地基」——工具需要靠 PDK 里的工艺参数（比如晶体管模型、金属层厚度）来做仿真和布局。iic-osic-tools 预装了 3 款 PDK，支持一键切换。

#### 新手操作：用 `sak-pdk` 命令切换（最简单）
不管是哪种启动模式（VNC、X11、Shell），打开终端，输入以下命令：
1. 查看已装的 PDK：
   ```bash
   sak-pdk list
   ```
   会显示：
   ```
   Installed PDKs:
   - sky130A
   - gf180mcuC
   - ihp-sg13g2
   ```

2. 切换到 sky130A（最常用的开源 PDK）：
   ```bash
   sak-pdk sky130A
   ```

3. 切换到 gf180mcuC：
   ```bash
   sak-pdk gf180mcuC
   ```

切换后，工具会自动加载对应 PDK 的参数（比如 `klayout` 打开后会显示该 PDK 的金属层、`ngspice` 会用该 PDK 的晶体管模型）。

#### 高级操作：手动设置环境变量（适合脚本化）
如果需要在脚本里自动切换 PDK（比如批量跑不同工艺的仿真），可以手动设置环境变量，以 sky130A 为例：
```bash
# 设置 sky130A 为当前 PDK
export PDK=sky130A
export PDKPATH=$PDK_ROOT/$PDK
# 设置默认标准单元库
export STD_CELL_LIBRARY=sky130_fd_sc_hd
# 设置 ngspice 和 klayout 的 PDK 路径
export SPICE_USERINIT_DIR=$PDKPATH/libs.tech/ngspice
export KLAYOUT_PATH=$PDKPATH/libs.tech/klayout:$PDKPATH/libs.tech/klayout/tech
```

也可以把这些命令写进 `~/.bashrc`（Linux/macOS）或 `~/.profile`（WSL），每次启动终端自动生效。


## 四、验证部署：确认工具能正常用
不管用哪种模式启动，都可以通过以下方法确认工具正常：

1. **检查 PDK 是否生效**：
   在终端输入 `echo $PDK`，能看到当前的 PDK 名称（比如 `sky130A`）；输入 `ls $PDKPATH`，能看到 PDK 的目录结构（比如 `libs.tech`、`libs.ref`）。

2. **打开一个工具测试**：
   - 输入 `klayout`，能看到布局工具窗口，顶部菜单选「File → New Layout」，在「Technology」里能看到当前 PDK（比如 `sky130A`），说明 PDK 加载成功；
   - 输入 `xschem`，打开 schematic 工具，顶部菜单选「File → New Schematic」，在右侧库列表里能看到 `sky130A` 的器件（比如 `nmos4`、`pmos4`），说明器件库正常。

3. **跑一个简单的仿真（进阶测试）**：
   在终端输入以下命令，用 ngspice 跑一个简单的反相器仿真：
   ```bash
   # 切换到 sky130A PDK
   sak-pdk sky130A
   # 创建一个简单的 SPICE 脚本
   cat > inv_test.sp << EOF
   * Inverter Test
   .include $PDKPATH/libs.tech/ngspice/sky130.lib.spice
   M1 vout vin vdd vdd sky130_fd_pr__pmos_4t_nvt w=0.5u l=0.15u
   M2 vout vin gnd gnd sky130_fd_pr__nmos_4t_nvt w=0.5u l=0.15u
   Vdd vdd gnd 1.8V
   Vin vin gnd PULSE(0 1.8 1n 1n 1n 5n 12n)
   .tran 1n 20n
   .end
   EOF
   # 运行仿真
   ngspice inv_test.sp
   ```
   仿真完成后，会生成 `inv_test.lis` 文件，里面有仿真结果，说明 ngspice 和 PDK 模型都正常。


## 五、常见问题与解决方案（踩坑总结）
1. **镜像拉取慢/失败？**
   - 原因：用了 Docker Hub 的源，国内网络慢；
   - 解决：用轩辕镜像源（步骤 2 里的 `docker pull xuanyuan.cloud/r/hpretl/iic-osic-tools:latest`），或检查一键安装脚本是否配置了轩辕加速（脚本会自动配，不用手动改）。

2. **VNC 访问不了（浏览器打开 localhost 没反应）？**
   - 检查端口是否被占用：执行 `netstat -tuln | grep 80`，如果有其他进程占用 80 端口，改用其他端口（比如 `WEBSERVER_PORT=8080 ./start_vnc.sh`）；
   - 检查防火墙：Linux 执行 `sudo ufw allow 80/tcp`（或对应端口），云服务器要在安全组里放行该端口。

3. **X11 模式打开工具没窗口？**
   - Linux：检查是否在图形界面下（比如远程 SSH 没开 X11 转发，要加 `-X` 参数：`ssh -X 用户名@服务器IP`）；
   - macOS：检查 XQuartz 是否打开、是否勾选了「允许网络连接」，重启 XQuartz 再试；
   - Windows：检查 WSL2 是否是最新版本（执行 `wsl --update`）。

4. **设计文件存在哪里？删除容器后文件会丢吗？**
   - 设计文件默认存在宿主机的 `$HOME/eda/designs`（Linux/macOS）或 `%USERPROFILE%\eda\designs`（Windows），这个目录会挂载到容器的 `/foss/designs`，即使删除容器，文件也不会丢；
   - 自定义目录：启动时用 `DESIGNS=/你的目录 ./start_vnc.sh`，文件会存在你指定的目录。

5. **容器占用空间太大？**
   - 原因：旧镜像堆积（每次拉新版本都会保留旧版本）；
   - 解决：执行 `docker system prune -a`，删除未使用的镜像和容器（注意：会删除所有没在运行的容器和没被使用的镜像，确保不需要的再删）。


## 六、总结：不同用户怎么选模式？
- **新手/学生**：先从「VNC 模式」开始，浏览器访问，不用管本地环境，熟悉工具后再换「X11 模式」；
- **本地开发（Linux/macOS）**：优先用「X11 模式」，访问表现快，支持复制粘贴；
- **命令行脚本/批量任务**：用「Shell 模式」，占用资源少，适合自动化；
- **团队协作/VS Code 爱好者**：用「开发容器模式」，统一环境，方便代码管理。

iic-osic-tools 最核心的价值就是「省去环境搭建的麻烦」，让你把精力放在 IC 设计本身——不管是学数字电路的 RTL2GDS 流程，还是做模拟电路的仿真和布局，都能直接用它快速上手。后续可以慢慢探索里面的工具（比如用 openroad 做自动布局布线、用 gdsfactory 生成 GDS），官方仓库也有示例项目，感兴趣的可以看：https://github.com/iic-jku/iic-osic-tools/tree/main/examples。

