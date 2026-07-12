---
image: daschswiss/sipi
description: "Sipi 官方Docker镜像，用于运行dasch-swiss/sipi项目，支持默认配置快速启动及自定义配置与脚本挂载。"
source: https://xuanyuan.cloud/zh/r/daschswiss/sipi
canonical: https://xuanyuan.cloud/zh/r/daschswiss/sipi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/daschswiss/sipi" title="daschswiss/sipi Docker 镜像中文简介、标签列表与拉取命令">daschswiss/sipi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Sipi 官方镜像文档

## 镜像概述和主要用途
Sipi 官方Docker镜像是dasch-swiss/sipi项目（https://github.com/dasch-swiss/sipi）的容器化部署方案，提供便捷的Sipi服务运行环境。该镜像支持默认配置下的快速启动，也可通过挂载本地目录实现自定义配置与脚本扩展，适用于各类需要部署Sipi服务的场景。

## 核心功能和特性
- 官方维护：与Sipi项目同步更新，确保镜像可靠性和兼容性
- 即开即用：内置默认配置，无需额外设置即可快速启动服务
- 灵活扩展：支持挂载本地配置文件和脚本目录，满足个性化需求
- 端口映射：默认使用1024端口，支持通过Docker端口映射对外提供服务

## 使用场景和适用范围
- 开发调试：快速部署Sipi服务进行功能验证和代码调试
- 测试环境：基于默认配置搭建临时测试环境，验证业务流程
- 生产部署：结合自定义配置和脚本，部署满足特定需求的稳定服务

## 使用方法和配置说明

### 默认配置运行
使用镜像内置的默认配置和端点脚本启动Sipi，命令如下：
```bash
docker run --rm -it -p 1024:1024 docker.xuanyuan.run/daschswiss/sipi
```
参数说明：
- `--rm`：容器退出后自动删除
- `-it`：以交互式终端模式运行
- `-p 1024:1024`：将容器1024端口映射到主机1024端口，允许外部访问Sipi服务

### 自定义配置和脚本
如需使用自定义配置文件或端点脚本，可通过挂载本地目录实现。示例命令如下：
```bash
docker run --rm -it -v $PWD/config:/sipi/config -v $PWD/scripts:/sipi/scripts -p 1024:1024 docker.xuanyuan.run/daschswiss/sipi --config=/sipi/config/sipi.custom-config.lua
```
参数说明：
- `-v $PWD/config:/sipi/config`：挂载本地`config`目录到容器内`/sipi/config`，用于提供自定义配置文件
- `-v $PWD/scripts:/sipi/scripts`：挂载本地`scripts`目录到容器内`/sipi/scripts`，用于提供自定义端点脚本
- `--config=/sipi/config/sipi.custom-config.lua`：指定使用挂载的自定义配置文件路径
