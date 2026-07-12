---
image: tinylab/linux-lab
description: "基于Qemu的Linux内核开发环境，集成必要编辑器、交叉工具、qemu、git、tftp及nfs服务器，需配合cloud-lab源代码使用。"
source: https://xuanyuan.cloud/zh/r/tinylab/linux-lab
canonical: https://xuanyuan.cloud/zh/r/tinylab/linux-lab
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tinylab/linux-lab" title="tinylab/linux-lab Docker 镜像中文简介、标签列表与拉取命令">tinylab/linux-lab 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## Linux Lab 镜像文档

### 镜像概述和主要用途
该镜像提供核心嵌入式Linux开发环境，集成了嵌入式Linux开发所需的必要工具，包括编辑器、交叉编译工具、Qemu模拟器、Git版本控制、TFTP服务器和NFS服务器等。需配合`cloud-lab`项目源代码使用，主要用于Linux内核及嵌入式系统的开发、测试与学习。

### 核心功能和特性
- **完整开发工具链**：包含嵌入式开发所需的编辑器、交叉编译工具
- **模拟环境**：集成Qemu模拟器，支持内核调试与运行
- **版本控制**：内置Git工具，方便代码管理
- **网络服务**：集成TFTP和NFS服务器，支持文件传输与挂载
- **便捷部署**：通过`cloud-lab`项目脚本实现一键部署与启动

### 使用场景和适用范围
- Linux内核开发者进行内核代码编写、调试和测试
- 嵌入式系统工程师开发嵌入式Linux应用与驱动
- 学生及Linux爱好者学习嵌入式Linux系统开发

### 使用方法和配置说明

#### 前置要求
需先获取`cloud-lab`项目源代码，仓库地址：https://github.com/tinyclub/cloud-lab.git

#### 部署步骤
1. **克隆项目代码**
   ```bash
   git clone https://github.com/tinyclub/cloud-lab.git
   ```

2. **进入项目目录并选择Linux Lab**
   ```bash
   cd cloud-lab/ && tools/docker/choose linux-lab
   ```

3. **拉取Docker镜像**
   ```bash
   tools/docker/pull
   ```

4. **启动开发环境**
   ```bash
   tools/docker/run
   ```

#### 访问与登录
启动后，环境将通过浏览器自动打开。使用控制台输出的`PASSWORD`进行登录。

### 相关资源
- **主页**：http://tinylab.org/linux-lab
- **代码仓库**：https://github.com/tinyclub/linux-lab.git
- **演示视频**：
  - http://showterm.io/6fb264246580281d372c6#fast
  - http://showdesk.io/7977891c1d24e38dffbea1b8550ffbb8/
  - https://v.qq.com/x/page/y0543o6zlh5.html
- **文档**：
  - 英文：[README.md](https://github.com/tinyclub/linux-lab/blob/master/README.md)
  - 中文：[利用 Linux Lab 完成嵌入式系统开发全过程](http://tinylab.org/using-linux-lab-to-do-embedded-linux-development/)
