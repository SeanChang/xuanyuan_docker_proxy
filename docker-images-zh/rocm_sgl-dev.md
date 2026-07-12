---
image: rocm/sgl-dev
description: "AMD构建的sgl-dev容器，提供统一的预配置开发环境，适用于基于AMD技术栈的项目开发。"
source: https://xuanyuan.cloud/zh/r/rocm/sgl-dev
canonical: https://xuanyuan.cloud/zh/r/rocm/sgl-dev
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/rocm/sgl-dev" title="rocm/sgl-dev Docker 镜像中文简介、标签列表与拉取命令">rocm/sgl-dev 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# sgl-dev容器（AMD构建）

## 概述
sgl-dev容器是由AMD官方构建的开发环境容器，旨在为开发人员提供统一、预配置的软件开发与测试环境，尤其适用于基于AMD技术栈的项目开发。

## 特性
- **官方构建**：由AMD直接维护，确保与AMD硬件及软件生态的兼容性。
- **环境一致性**：预配置常用开发工具，避免因环境差异导致的开发问题。
- **便捷部署**：容器化设计，支持快速启动与销毁，降低环境配置成本。

## 使用场景
- 基于AMD硬件/软件的应用开发与调试
- 跨平台开发环境标准化
- 快速验证代码在AMD环境下的兼容性

## 部署示例
### 基本运行
通过以下命令启动交互式终端会话：
```bash
docker run -it --rm docker.xuanyuan.run/amd/sgl-dev:latest
```

### 挂载本地目录（可选）
如需将本地项目目录挂载至容器内进行开发，可使用：
```bash
docker run -it --rm -v /本地项目路径:/workspace docker.xuanyuan.run/amd/sgl-dev:latest
```

## 注意事项
- 容器标签（如`:latest`）可能需根据实际需求替换为特定版本。
- 运行前请确保本地已安装Docker引擎。
