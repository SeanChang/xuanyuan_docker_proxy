---
image: amd64/gcc
description: "GNU编译器集合是支持多种语言的编译系统。"
source: https://xuanyuan.cloud/zh/r/amd64/gcc
canonical: https://xuanyuan.cloud/zh/r/amd64/gcc
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/amd64/gcc" title="amd64/gcc Docker 镜像中文简介、标签列表与拉取命令">amd64/gcc 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# GCC Docker镜像技术文档


## 1. 镜像概述

### 1.1 概述
本镜像是[官方gcc镜像](https://hub.docker.com/_/gcc)针对`amd64`架构的"per-architecture"构建版本。GNU编译器集合（GNU Compiler Collection, GCC）是由GNU项目开发的编译器系统，支持多种编程语言，是GNU工具链的核心组件。GCC以GNU通用公共许可证（GNU GPL）发布，在自由软件的发展中具有重要地位，既是开发工具也是自由软件的典范。

### 1.2 主要用途
提供轻量级、标准化的GCC编译环境，适用于软件开发中的编译环节，支持作为构建环境或独立编译工具使用。


## 2. 核心功能与特性

- **多语言支持**：支持C、C++、Objective-C、Fortran、Ada、Go等多种编程语言
- **完整工具链**：包含GNU工具链核心组件，如编译器(gcc, g++)、链接器(ld)、汇编器(as)等
- **优化能力**：提供丰富的代码优化选项（-O0至-O3、-Os等），支持针对不同架构的性能调优
- **跨平台编译**：支持生成多种目标平台的可执行文件
- **标准化环境**：基于Debian稳定版本（如trixie、bookworm）构建，环境一致性高，避免"开发环境不一致"问题


## 3. 支持的标签

| 标签 | 对应的Dockerfile链接 |
|------|----------------------|
| `15.2.0`, `15.2`, `15`, `latest`, `15.2.0-trixie`, `15.2-trixie`, `15-trixie`, `trixie` | [Dockerfile](https://github.com/docker-library/gcc/blob/915af5ccbb6b09575e244f280c26925e77172039/15/Dockerfile) |
| `14.3.0`, `14.3`, `14`, `14.3.0-trixie`, `14.3-trixie`, `14-trixie` | [Dockerfile](https://github.com/docker-library/gcc/blob/280306a58a2ff0c21a95ed8abe882ac483d03c8b/14/Dockerfile) |
| `13.4.0`, `13.4`, `13`, `13.4.0-bookworm`, `13.4-bookworm`, `13-bookworm` | [Dockerfile](https://github.com/docker-library/gcc/blob/118c07a8e6467baababb4634b6cfde14a67c24b0/13/Dockerfile) |
| `12.5.0`, `12.5`, `12`, `12.5.0-bookworm`, `12.5-bookworm`, `12-bookworm` | [Dockerfile](https://github.com/docker-library/gcc/blob/7070981b23d22d3ca790f87bff26f13f3614dd4c/12/Dockerfile) |


## 4. 使用场景

- **应用构建与运行环境**：作为Docker化应用的完整构建和运行环境
- **独立编译工具**：仅用于编译代码，不运行应用（通过挂载宿主机目录实现）
- **CI/CD集成**：在持续集成/部署流程中提供标准化编译环境
- **多版本测试**：快速切换不同GCC版本测试代码兼容性
- **跨平台开发**：在统一环境中进行跨平台代码编译


## 5. 使用方法

### 5.1 通过Dockerfile构建应用镜像

将GCC镜像作为构建和运行环境，创建如下`Dockerfile`：

```dockerfile
FROM docker.xuanyuan.run/amd64/gcc:15.2.0
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN gcc -o myapp main.c  # 编译应用
CMD ["./myapp"]  # 运行应用
```

构建并运行镜像：

```bash
# 构建镜像
docker build -t my-gcc-app .

# 运行容器
docker run -it --rm --name my-running-app docker.xuanyuan.run/my-gcc-app
```

### 5.2 直接使用容器编译代码

无需构建镜像，直接在容器中编译宿主机代码：

```bash
# 编译单个C文件
docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp docker.xuanyuan.run/amd64/gcc:15.2.0 gcc -o myapp main.c
```

参数说明：
- `--rm`：编译完成后自动删除容器
- `-v "$PWD":/usr/src/myapp`：将当前目录挂载到容器内的`/usr/src/myapp`
- `-w /usr/src/myapp`：设置工作目录为挂载目录
- `amd64/gcc:15.2.0`：使用的GCC镜像及版本
- `gcc -o myapp main.c`：编译命令

### 5.3 使用Makefile编译项目

如果项目使用Makefile管理，可直接运行`make`命令：

```bash
docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp docker.xuanyuan.run/amd64/gcc:15.2.0 make
```


## 6. 维护与支持

### 6.1 维护者
[Docker社区](https://github.com/docker-library/gcc)

### 6.2 获取帮助
- Docker Community Slack: [https://dockr.ly/comm-slack](https://dockr.ly/comm-slack)
- Server Fault: [https://serverfault.com/help/on-topic](https://serverfault.com/help/on-topic)
- Unix & Linux Stack Exchange: [https://unix.stackexchange.com/help/on-topic](https://unix.stackexchange.com/help/on-topic)
- Stack Overflow: [https://stackoverflow.com/help/on-topic](https://stackoverflow.com/help/on-topic)

### 6.3 提交问题
[https://github.com/docker-library/gcc/issues](https://github.com/docker-library/gcc/issues?q=)

### 6.4 支持的架构
- `amd64`: [https://hub.docker.com/r/amd64/gcc/](https://hub.docker.com/r/amd64/gcc/)
- `arm32v5`: [https://hub.docker.com/r/arm32v5/gcc/](https://hub.docker.com/r/arm32v5/gcc/)
- `arm32v7`: [https://hub.docker.com/r/arm32v7/gcc/](https://hub.docker.com/r/arm32v7/gcc/)
- `arm64v8`: [https://hub.docker.com/r/arm64v8/gcc/](https://hub.docker.com/r/arm64v8/gcc/)
- `ppc64le`: [https://hub.docker.com/r/ppc64le/gcc/](https://hub.docker.com/r/ppc64le/gcc/)
- `s390x`: [https://hub.docker.com/r/s390x/gcc/](https://hub.docker.com/r/s390x/gcc/)

### 6.5 镜像信息
- 镜像元数据与传输大小: [repo-info repo's `repos/gcc/` directory](https://github.com/docker-library/repo-info/blob/master/repos/gcc)
- 镜像更新记录: [official-images repo's `library/gcc` label](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fgcc)
- 镜像源文件历史: [official-images repo's `library/gcc` file](https://github.com/docker-library/official-images/blob/master/library/gcc)


## 7. 许可证信息

镜像中包含的GCC软件许可信息请参见: [https://gcc.gnu.org/onlinedocs/gcc-11.2.0/gcc/Copying.html](https://gcc.gnu.org/onlinedocs/gcc-11.2.0/gcc/Copying.html)

与所有Docker镜像一样，本镜像可能包含其他软件（如基础系统的Bash等），这些软件可能具有不同的许可证。自动检测到的附加许可信息可在[repo-info仓库的`gcc/`目录](https://github.com/docker-library/repo-info/tree/master/repos/gcc)中找到。

使用本镜像时，用户有责任确保对镜像中所有软件的使用符合相关许可证要求。
