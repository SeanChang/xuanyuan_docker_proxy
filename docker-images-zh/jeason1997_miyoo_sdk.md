---
image: jeason1997/miyoo_sdk
description: "MiyooSDK Docker镜像为Miyoo掌机应用开发者提供预配置的开发环境，集成交叉编译工具链、依赖库和构建脚本，简化跨平台应用开发与测试流程。"
source: https://xuanyuan.cloud/zh/r/jeason1997/miyoo_sdk
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[jeason1997/miyoo_sdk](https://xuanyuan.cloud/zh/r/jeason1997/miyoo_sdk)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# MiyooSDK Docker镜像文档

## 镜像概述

MiyooSDK Docker镜像是针对Miyoo系列掌机应用开发的标准化开发环境解决方案。该镜像封装了Miyoo掌机软件开发所需的完整工具链、依赖库及构建系统，旨在消除不同操作系统下开发环境配置差异，帮助开发者快速搭建一致的开发平台，专注于应用功能实现而非环境配置。

## 核心功能与特性

- **完整交叉编译环境**：内置Miyoo掌机专用arm-linux-gnueabihf工具链，支持C/C++应用编译
- **预集成依赖库**：包含SDL2、libretro、Miyoo硬件抽象层等核心游戏开发库
- **标准化构建流程**：内置Makefile模板与构建脚本，支持一键编译、打包与模拟器测试
- **多平台兼容**：基于Ubuntu基础镜像构建，可在Linux、Windows（WSL2）、macOS等系统运行
- **轻量级设计**：优化镜像体积，仅包含开发必需组件，启动快速资源占用低

## 使用场景与适用范围

- Miyoo Mini/Mini+/Pocket Go等系列掌机应用开发
- 复古游戏模拟器移植与优化
- 掌机应用原型验证与快速迭代
- 教育机构掌机开发教学环境
- 开源掌机项目贡献者协作开发

## 使用方法与配置说明

### 基本使用流程

1. **拉取镜像**（假设镜像名称为`miyoo-sdk`）：
   ```bash
   docker pull jeason1997/miyoo-sdk:latest
   ```

2. **启动开发环境**：
   ```bash
   docker run -it --rm \
     -v $(pwd):/workspace \
     -w /workspace \
     jeason1997/miyoo-sdk:latest
   ```
   - `-v $(pwd):/workspace`：将当前目录挂载为容器工作目录
   - `-w /workspace`：设置容器工作目录为`/workspace`
   - `--rm`：容器退出后自动清理

3. **编译示例项目**：
   在容器内执行：
   ```bash
   # 克隆示例项目（如仓库内examples目录）
   git clone https://github.com/jeason1997/MiyooSDK.git && cd MiyooSDK/examples/hello-world
   # 使用SDK工具链编译
   make -f Makefile.miyoo
   ```

### 高级配置

#### 环境变量配置

通过`-e`参数设置环境变量自定义开发行为：

| 环境变量 | 说明 | 可选值 | 默认值 |
|----------|------|--------|--------|
| `MIYOO_MODEL` | 目标掌机型号 | `miyoo_mini`, `miyoo_mini_plus`, `pocket_go` | `miyoo_mini` |
| `DEBUG_MODE` | 启用调试模式 | `on`, `off` | `off` |
| `CC` | C编译器路径 | 工具链路径 | `/opt/miyoo-toolchain/bin/arm-linux-gnueabihf-gcc` |
| `CXX` | C++编译器路径 | 工具链路径 | `/opt/miyoo-toolchain/bin/arm-linux-gnueabihf-g++` |

示例：指定目标为Miyoo Mini+并启用调试模式
```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -e MIYOO_MODEL=miyoo_mini_plus \
  -e DEBUG_MODE=on \
  jeason1997/miyoo-sdk:latest
```

#### 持久化开发环境

如需保存自定义配置（如额外安装的工具），可将容器提交为新镜像：
```bash
# 启动容器并自定义配置
docker run -it --name my-miyoo-dev jeason1997/miyoo-sdk:latest
# 在容器内安装额外工具后，新开终端执行提交
docker commit my-miyoo-dev my-custom-miyoo-sdk:latest
```

### docker-compose配置示例

创建`docker-compose.yml`简化开发环境管理：
```yaml
version: '3'
services:
  miyoo-dev:
    image: jeason1997/miyoo-sdk:latest
    volumes:
      - ./project:/workspace
    environment:
      - MIYOO_MODEL=miyoo_mini_plus
      - DEBUG_MODE=on
    working_dir: /workspace
    tty: true
    stdin_open: true
```

启动服务：
```bash
docker-compose up -d
docker-compose exec miyoo-dev bash  # 进入容器环境
```

## 注意事项

- 宿主机需安装Docker Engine 20.10+或Docker Desktop
- Windows用户需启用WSL2后端以获得最佳性能
- 挂载目录权限问题：Linux/macOS用户可通过`-u $(id -u):$(id -g)`参数解决权限映射
- 详细SDK使用文档请参考[官方仓库](https://github.com/jeason1997/MiyooSDK)
- 编译产物位于项目`build/`目录，可通过`miyoo-tools`工具传输至掌机测试
