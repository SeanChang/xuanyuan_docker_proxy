# 手把手教你在 Windows 安装 Docker Desktop

![手把手教你在 Windows 安装 Docker Desktop](https://img.xuanyuan.dev/docker/blog/docker-desktop.png)

*分类: Docker Desktop | 标签: Docker Desktop,docker,部署教程 | 发布时间: 2025-10-04 12:53:41*

> 本文是一份零基础友好、步骤化的实操教程，旨在帮助初学者和高级开发者快速掌握在 Windows 系统中基于 WSL 2（适用于 Linux 的 Windows 子系统，版本 2）安装 Docker Desktop 的方法，并学会使用 VS Code 在远程容器中开发应用。

## 简介
本文是一份**零基础友好、步骤化的实操教程**，旨在帮助初学者和高级开发者快速掌握在 Windows 系统中基于 WSL 2（适用于 Linux 的 Windows 子系统，版本 2）安装 Docker Desktop 的方法，并学会使用 VS Code 在远程容器中开发应用。

Linux 系统的 docker & docker compose 安装参考链接：[Linux Docker & Docker Compose 一键安装](https://xuanyuan.cloud/install/linux)

通过本教程，你将实现：
- 在 Windows 上搭建支持 Linux 容器的 Docker 开发环境
- 配置 WSL 2 与 Docker Desktop 的深度集成
- 使用 VS Code 远程连接容器，完成代码编写、调试和运行
- 解决安装和使用过程中的常见问题


## 一、先决条件
在开始安装前，请确保你的环境满足以下要求，避免后续操作报错。

### 1.1 系统与硬件要求
| 类型         | 具体要求                                                                 |
|--------------|--------------------------------------------------------------------------|
| WSL 版本     | 1.1.3.0 或更高（可通过 `wsl --version` 命令检查）                        |
| Windows 系统 | - Windows 11：家庭版/专业版/企业版/教育版<br>- Windows 10：22H2（内部版本 19045）及以上（家庭版/专业版/企业版/教育版，21H2（19044）为最低支持版本） |
| 硬件         | - 64 位处理器（需支持**二级地址转换（SLAT）**）<br>- 至少 4GB 系统内存    |
| 虚拟化       | 在 BIOS/UEFI 中启用**硬件虚拟化**（不同主板型号操作不同，可参考主板说明书） |

> 提示：若 Windows 版本过低，可通过「设置 → Windows 更新」升级（链接：[ms-settings:windowsupdate](ms-settings:windowsupdate)）。


### 1.2 已安装软件
1. **WSL 及 Linux 分发版**  
   需提前安装 WSL 并配置 Linux 分发版（如 Ubuntu、Debian），且确保分发版使用 WSL 2 模式。  
   - 安装教程：[安装 WSL 并设置 Linux 用户名和密码](https://learn.microsoft.com/zh-cn/windows/wsl/install)  
   - 检查 WSL 模式：打开 PowerShell 或 Windows 终端，执行命令 `wsl -l -v`，若分发版的「VERSION」列显示「1」，需执行 `wsl --set-version <Distro> 2`（将 `<Distro>` 替换为你的分发版名称，如 `Ubuntu-22.04`）切换为 WSL 2。
2. **可选软件（推荐安装，提升体验）**  
   - [Visual Studio Code（VS Code）](https://code.visualstudio.com/download)：用于远程容器开发、代码编辑和调试。  
   - [Windows 终端](https://learn.microsoft.com/zh-cn/windows/terminal/get-started)：可同时管理 WSL 终端、PowerShell 等，支持自定义界面。


### 1.3 其他准备
1. **Docker ID（可选）**：用于登录 Docker Hub 下载镜像，注册链接：[Docker Hub 注册](https://hub.docker.com/signup)。  
2. **了解许可协议**：Docker Desktop 免费供个人和小型企业使用，其他场景需参考 [Docker Desktop 许可协议](https://docs.docker.com/subscription/#docker-desktop-license-agreement)。


## 二、安装 Docker Desktop
Docker Desktop 是 Windows 上的官方 Docker 工具，支持 WSL 2 后端，可原生运行 Linux 容器，性能优于传统虚拟化方案。

### 步骤 1：下载 Docker Desktop
访问官方下载链接，获取最新版 Docker Desktop 安装包：  
[Docker Desktop 下载（支持 WSL 2）](https://docs.docker.com/desktop/features/wsl/#turn-on-docker-desktop-wsl-2)


### 步骤 2：运行安装程序
1. 双击下载的 `.exe` 安装包，进入安装向导，默认选项已适配 WSL 2，无需修改，直接点击「OK」开始安装。  
2. 安装过程中会自动启用 Windows 所需的组件（如 Hyper-V、容器功能），若提示重启，点击「重启」完成配置。


### 步骤 3：配置 WSL 2 集成
1. 从 Windows 「开始菜单」启动 Docker Desktop，等待启动完成（任务栏隐藏图标中出现 Docker 图标，无报错提示）。  
2. 右键点击任务栏中的 Docker 图标，选择「设置」（如图 1）。  
   ![图 1：Docker Desktop 任务栏图标（右键打开设置）](https://learn.microsoft.com/zh-cn/windows/wsl/media/docker-starting.png)  
3. 在设置界面中，进入「常规」选项卡，确保「使用基于 WSL 2 的引擎」已勾选（如图 2），若未勾选则勾选后点击「应用并重启」。  
   ![图 2：Docker Desktop 常规设置（启用 WSL 2 引擎）](https://learn.microsoft.com/zh-cn/windows/wsl/media/docker-running.png)  
4. 进入「资源 → WSL 集成」选项卡，在「启用集成的 WSL 发行版」中，勾选你需要集成的 Linux 分发版（如 Ubuntu-22.04，如图 3），点击「应用」保存配置。  
   ![图 3：Docker Desktop WSL 集成设置（选择分发版）](https://learn.microsoft.com/zh-cn/windows/wsl/media/docker-dashboard.png)


### 步骤 4：验证 Docker 安装
1. 打开你的 Linux 分发版终端（如 Ubuntu 终端，或通过 Windows 终端切换到 WSL 标签页）。  
2. 执行以下命令，检查 Docker 版本是否正常显示：  
   ```bash
   docker --version
   ```  
   成功结果示例：`Docker version 26.0.0, build 2ae903e`。  
3. 执行「Hello World」测试镜像，验证 Docker 能否正常拉取和运行容器：  
   ```bash
   docker run hello-world
   ```  
   成功结果：终端会输出 Docker 欢迎信息（包含「Hello from Docker!」），说明容器运行正常。


### 常用 Docker 命令提示
| 命令                          | 用途                                                                 |
|-------------------------------|-----------------------------------------------------------------------|
| `docker`                      | 列出所有 Docker CLI 可用命令                                          |
| `docker <COMMAND> --help`     | 查看特定命令的帮助文档（如 `docker run --help`）                      |
| `docker image ls --all`       | 列出本地所有 Docker 镜像                                              |
| `docker container ls --all`   | 列出本地所有容器（`docker ps -a` 为简写，不加 `-a` 只显示运行中容器） |
| `docker info`                 | 查看 Docker 系统信息（含 WSL 2 资源配置、镜像仓库等）                 |


## 三、使用 VS Code 在远程容器中开发
通过 VS Code 的「远程容器」扩展，可直接在 Docker 容器中编写、调试代码，避免本地环境依赖冲突。以下以 Python Django 项目为例，演示完整流程。


### 步骤 1：安装必要的 VS Code 扩展
打开 VS Code，在「扩展」面板（Ctrl+Shift+X）中搜索并安装以下 3 个扩展：
1. **WSL 扩展**：实现 VS Code 与 WSL 的连接，链接：[Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)  
2. **开发容器扩展**：支持在容器中打开项目，链接：[Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)  
3. **Docker 扩展**：提供容器管理、镜像构建等功能，链接：[Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)  


### 步骤 2：准备示例项目（可选，也可使用自己的项目）
我们以 GitHub 上的 `helloworld-django` 项目为例（Python Django 入门项目），步骤如下：
1. 打开 Linux 分发版终端，执行以下命令克隆项目到 WSL 文件系统（**务必存储在 WSL 文件系统，避免性能问题**）：  
   ```bash
   git clone https://github.com/mattwojo/helloworld-django.git
   ```  
   > 提示：WSL 文件系统路径为 `\\wsl\`（如 `\\wsl\Ubuntu-22.04\home\<你的用户名>\`），若将项目存放在 Windows 本地路径（如 `C:\`），会导致文件访问访问表现大幅下降。

2. 进入项目目录：  
   ```bash
   cd helloworld-django
   ```


### 步骤 3：在 VS Code 中打开项目
1. 在项目目录下，执行以下命令，通过 WSL 扩展打开 VS Code：  
   ```bash
   code .
   ```  
2. 检查 VS Code 左下角的「远程指示器」，若显示「WSL: <你的分发版名称>」（如图 4），说明已成功连接到 WSL。  
   ![图 4：VS Code WSL 远程指示器](https://learn.microsoft.com/zh-cn/windows/wsl/media/vscode-remote-indicator.png)


### 步骤 4：配置开发容器
1. 在 VS Code 中打开「命令面板」（Ctrl+Shift+P），输入并选择「开发者容器：重新以容器方式打开」（如图 5）。  
   > 若项目未在 WSL 中打开，可选择「开发者容器：在容器中打开文件夹...」，然后通过 `\\wsl\` 路径选择 WSL 中的项目文件夹。  
   ![图 5：VS Code 开发容器命令](https://learn.microsoft.com/zh-cn/windows/wsl/media/docker-extension.png)

2. 选择项目文件夹（如 `\\wsl\Ubuntu-22.04\home\<你的用户名>\helloworld-django`，如图 6），点击「选择文件夹」。  
   ![图 6：选择 WSL 中的项目文件夹](https://learn.microsoft.com/zh-cn/windows/wsl/media/docker-extension2.png)

3. 由于项目中无预设容器配置，VS Code 会提示选择容器定义，根据项目类型选择（本例为 Django 项目，选择「Python 3」，如图 7）。  
   ![图 7：选择 Python 3 容器配置](https://learn.microsoft.com/zh-cn/windows/wsl/media/docker-extension3.png)

4. VS Code 会自动构建 Docker 镜像并启动容器，构建完成后，项目中会新增 `.devcontainer` 文件夹（含 `Dockerfile` 和 `devcontainer.json` 配置文件，如图 8），表示容器环境已就绪。  
   ![图 8：项目中的 .devcontainer 文件夹](https://learn.microsoft.com/zh-cn/windows/wsl/media/docker-extension4.png)


### 步骤 5：运行与调试容器应用
1. 打开 VS Code 的「运行和调试」面板（Ctrl+Shift+D），点击「运行和调试」，选择适合项目的调试配置（本例选择「Django」，如图 9）。  
   ![图 9：选择 Django 调试配置](https://learn.microsoft.com/zh-cn/windows/wsl/media/vscode-run-config.png)

2. 按「F5」键启动调试，VS Code 会自动在容器中运行 Django 开发服务器，终端会输出「开发服务器正在 http://127.0.0.1:8000/ 启动」（如图 10）。  
   ![图 10：容器中运行的 Django 服务器](https://learn.microsoft.com/zh-cn/windows/wsl/media/vscode-running-in-container.png)

3. 按住「Ctrl」键并点击终端中的 `http://127.0.0.1:8000/`，即可在浏览器中查看运行中的 Django 应用，完成远程容器开发流程。


## 四、故障排除
### 4.1 问题 1：WSL Docker 上下文已弃用
#### 症状
执行 Docker 命令时提示：  
`docker wsl open //./pipe/docker_wsl：系统找不到指定的文件` 或 `连接期间出错：获取 http://%2F%2F.%2Fpipe%2Fdocker_wsl/v1.40/images/json?all=1: 打开 //./pipe/docker_wsl：系统找不到指定的文件`。

#### 原因
使用了早期 Docker 预览版的「wsl」上下文，该上下文已弃用，需删除。

#### 解决步骤
1. 打开 Linux 终端，执行以下命令查看当前 Docker 上下文：  
   ```bash
   docker context ls
   ```  
2. 若存在名为「wsl」的上下文，执行以下命令删除：  
   ```bash
   docker context rm wsl
   ```  
3. 重新使用默认上下文执行 Docker 命令即可。


### 4.2 问题 2：找不到 Docker 映像存储文件夹
#### 原因
Docker Desktop 在 WSL 中创建了两个隐藏文件夹存储数据，默认不显示。

#### 解决步骤
1. 打开 Linux 终端，执行以下命令打开 WSL 文件系统的 Windows 资源管理器：  
   ```bash
   explorer.exe .
   ```  
2. 在资源管理器地址栏输入 `\\wsl\<你的分发版名称>\mnt\wsl`（如 `\\wsl\Ubuntu-22.04\mnt\wsl`），即可看到以下两个存储文件夹：  
   - `docker-desktop`：Docker 核心组件存储  
   - `docker-desktop-data`：Docker 镜像和容器数据存储  


### 4.3 其他 WSL 故障排除资源
若遇到其他 WSL 相关问题，可参考官方文档：[WSL 故障排除](https://learn.microsoft.com/zh-cn/windows/wsl/troubleshooting)。  
若需在 Windows Server 上安装 Docker，参考：[入门：为容器准备 Windows Server](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/quick-start/set-up-environment)。


## 五、其他学习资源
| 资源类型       | 链接与简介                                                                 |
|----------------|----------------------------------------------------------------------------|
| Docker 官方文档 | [Docker Desktop + WSL 2 最佳实践](https://docs.docker.com/docker-for-windows/wsl/#best-practices)：了解 Docker 与 WSL 2 集成的优化技巧。 |
| VS Code 官方文档 | [选择开发环境的指南](https://code.visualstudio.com/docs/containers/choosing-dev-environment#_guidelines-for-choosing-a-development-environment)：学习如何根据项目需求选择容器/本地/WSL 环境。 |
| VS Code 博客    | [在 WSL 2 中使用 Docker](https://code.visualstudio.com/blogs/2020/03/02/docker-in-wsl2)、[在 WSL 2 中使用远程容器](https://code.visualstudio.com/blogs/2020/07/01/containers-wsl)：深入讲解 VS Code 与 WSL、容器的结合用法。 |
| 播客           | [Hanselminutes：让 Docker 更贴近开发人员](https://hanselminutes.com/736/making-docker-lovely-for-developers-with-simon-ferquel)：了解 Docker 开发理念和最佳实践。 |
| Docker 反馈     | [Docker Desktop for Windows 问题反馈](https://github.com/docker/for-win/issues)：提交 Docker 安装或使用中的 Bug。 |


## 总结
通过本教程，你已掌握：
1. 在 Windows 上基于 WSL 2 安装和配置 Docker Desktop 的完整流程；
2. 使用 VS Code 远程连接容器，实现代码编写、调试和运行；
3. 解决 Docker 与 WSL 集成的常见问题。

建议后续尝试将自己的项目容器化，或探索 Kubernetes 等容器编排工具，进一步提升开发效率。

