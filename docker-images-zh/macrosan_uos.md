<!-- xuanyuan-docker-images-zh
image: macrosan/uos
source: https://xuanyuan.cloud/zh/r/macrosan/uos
canonical: https://xuanyuan.cloud/zh/r/macrosan/uos
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/macrosan/uos" title="macrosan/uos Docker 镜像中文简介、标签列表与拉取命令">macrosan/uos — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/macrosan/uos" title="macrosan/uos Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/macrosan/uos</a></p>

# 统信UOS服务器操作系统Docker镜像文档


## 1. 镜像概述和主要用途

本镜像为统信UOS服务器操作系统的Docker化版本，基于UOS官方软件源构建，提供V20（E版）的1050和1060两个稳定版本。旨在为开发者和运维人员提供轻量级、标准化的UOS服务器系统环境，可作为应用构建基础、测试环境或生产环境的底层容器镜像。

- **维护者**：[MacroSAN-Tech/sys-docker-image](https://github.com/MacroSAN-Tech/sys-docker-image)
- **版本信息**：基于统信UOS服务器操作系统V20（E版），包含1050e和1060e两个子版本


## 2. 核心功能和特性

### 2.1 基础特性
- **官方兼容性**：基于UOS官方软件源构建，确保系统包完整性和兼容性
- **多版本支持**：提供V20（E版）1050和1060两个稳定版本，满足不同场景需求
- **轻量级设计**：作为基础镜像优化，减少冗余组件，适合应用构建

### 2.2 架构支持
- `amd64`：适用于64位x86架构服务器
- `arm64`：适用于64位ARM架构服务器


## 3. 使用场景和适用范围

### 3.1 开发环境
- 作为本地开发环境的基础镜像，快速搭建与生产环境一致的UOS服务器环境
- 集成开发工具链，构建基于UOS系统的应用程序

### 3.2 应用构建
- 作为Dockerfile的基础镜像（`FROM`指令），构建需要UOS系统依赖的应用容器
- 预安装特定系统库或工具，简化应用打包流程

### 3.3 兼容性测试
- 验证应用在UOS服务器操作系统不同版本（1050e/1060e）上的兼容性
- 模拟生产环境进行功能和性能测试


## 4. 使用方法和配置说明

### 4.1 拉取镜像

#### 4.1.1 拉取特定架构镜像
根据目标架构指定`--platform`参数拉取镜像：

```console
# 拉取amd64架构的v20-1050版本
$ docker pull --platform=linux/amd64 macrosan/uos:v20-1050

# 拉取arm64架构的v20-1060版本
$ docker pull --platform=linux/arm64 macrosan/uos:v20-1060
```

#### 4.1.2 拉取默认架构镜像
若本地环境架构与镜像默认架构一致，可省略`--platform`参数：

```console
$ docker pull macrosan/uos:v20-1050
```


### 4.2 运行容器

#### 4.2.1 交互式测试
通过交互式终端运行容器，验证镜像可用性：

```console
# 运行v20-1050版本并进入终端
$ docker run -it macrosan/uos:v20-1050

# 运行v20-1060版本并进入终端
$ docker run -it macrosan/uos:v20-1060
```

#### 4.2.2 后台运行
如需长期运行容器（如作为服务基础），可添加`-d`参数后台运行：

```console
$ docker run -d --name uos-test macrosan/uos:v20-1050 tail -f /dev/null
```


### 4.3 构建自定义镜像

基于本镜像构建包含额外工具或依赖的自定义镜像，示例Dockerfile：

```dockerfile
# 基于v20-1050版本构建
FROM macrosan/uos:v20-1050

# 安装常用工具（如vi编辑器）
RUN yum install -y vi

# 安装开发依赖（如gcc编译器）
RUN yum install -y gcc
```

构建命令：

```console
$ docker build -t my-uos-app:v1 .
```


## 5. 镜像变体说明

### 5.1 macrosan/uos:v20-1050
对应统信UOS服务器操作系统V20（E版）1050版本，系统标识信息：

```console
bash-5.0# cat /etc/system-release-cpe  
cpe:/o:UnionTech:UnionTech OS Server 20:1050e:ga:server

bash-5.0# rpm -q UnionTech-release
UnionTech-release-1050-1.2.uel20.UFU.01.x86_64
```

### 5.2 macrosan/uos:v20-1060
对应统信UOS服务器操作系统V20（E版）1060版本，系统标识信息：

```console
bash-5.0# cat /etc/system-release-cpe  
cpe:/o:UOS:UOS Server 20:1060e:ga:server

bash-5.0# rpm -q UnionTech-release
UnionTech-release-1060-1.6.uel20.x86_64
```


## 6. 支持的标签及Dockerfile链接

| 镜像标签       | 对应版本       | Dockerfile链接                                                                 |
|----------------|----------------|--------------------------------------------------------------------------------|
| `v20-1050`     | V20（E版）1050 | [uos_v20.sys.Dockerfile](https://github.com/MacroSAN-Tech/sys-docker-image/blob/main/uos_v20.sys.Dockerfile) |
| `v20-1060`     | V20（E版）1060 | [uos_v20.sys.Dockerfile](https://github.com/MacroSAN-Tech/sys-docker-image/blob/main/uos_v20.sys.Dockerfile) |

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/macrosan/uos" title="macrosan/uos Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/macrosan/uos</a></p>
