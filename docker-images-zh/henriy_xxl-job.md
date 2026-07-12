---
image: henriy/xxl-job
description: "用于配置Spring应用数据库连接参数的Docker镜像，支持通过环境变量设置MySQL连接URL、用户名和密码，确保应用容器化部署时正确连接数据库。"
source: https://xuanyuan.cloud/zh/r/henriy/xxl-job
canonical: https://xuanyuan.cloud/zh/r/henriy/xxl-job
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/henriy/xxl-job" title="henriy/xxl-job Docker 镜像中文简介、标签列表与拉取命令">henriy/xxl-job 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像文档

## 1. 镜像概述
该Docker镜像主要用于配置需要连接MySQL数据库的Spring应用，通过环境变量方式提供数据库连接参数，确保应用在容器化部署时能够正确加载数据库连接信息，实现与MySQL数据库的正常通信。

## 2. 核心功能与特性
- **数据库连接配置**：支持通过环境变量配置MySQL数据库连接信息，包括连接URL、用户名和密码
- **灵活性部署**：避免配置硬编码，可在容器启动时动态指定数据库连接参数，适应不同环境（开发、测试、生产）的数据库配置需求
- **Spring生态兼容**：配置参数符合Spring框架数据源配置规范，可直接被Spring应用识别并加载

## 3. 使用场景
适用于在Docker环境中部署需要连接MySQL数据库的Spring应用时，通过设置环境变量来指定数据库连接信息，尤其适用于：
- 多环境部署（开发/测试/生产环境使用不同数据库实例）
- 需要快速切换数据库连接配置的场景
- 容器化部署中遵循"配置与代码分离"原则的场景

## 4. 使用方法与配置说明

### 4.1 基础使用（docker run命令）
通过`docker run`命令启动容器时，使用`-e`参数指定数据库连接环境变量：

```bash
docker run -d \
  -e "spring.datasource.url=jdbc:mysql://172.27.217.224:3306/xxl_job?Unicode=true&characterEncoding=UTF-8&useSSL=true" \
  -e "spring.datasource.username=root" \
  -e "spring.datasource.password=3D3%IRK7UGC3j" \
  [镜像名称]:[标签]
```

### 4.2 配置参数说明

| 环境变量名称                | 作用描述                                                                 | 格式要求                                                                 | 示例值                                                                 |
|---------------------------|--------------------------------------------------------------------------|--------------------------------------------------------------------------|------------------------------------------------------------------------|
| `spring.datasource.url`   | 指定MySQL数据库连接URL，包含数据库地址、端口、数据库名及连接参数           | `jdbc:mysql://[数据库IP]:[端口]/[数据库名]?[连接参数]`                   | `jdbc:mysql://172.27.217.224:3306/xxl_job?Unicode=true&characterEncoding=UTF-8&useSSL=true` |
| `spring.datasource.username` | 连接MySQL数据库的用户名                                                   | 字符串，需与目标MySQL数据库中已存在的用户匹配                               | `root`                                                                 |
| `spring.datasource.password` | 连接MySQL数据库的用户密码                                                 | 字符串，需与目标MySQL数据库中对应用户的密码匹配                             | `3D3%IRK7UGC3j`                                                        |

### 4.3 注意事项
- `spring.datasource.url`中的连接参数（如`useSSL`）需根据实际数据库环境配置，生产环境建议启用`useSSL=true`并配置证书
- 数据库地址、端口、数据库名需与实际部署的MySQL实例信息一致
- 用户名和密码需具备目标数据库的访问权限，建议遵循最小权限原则配置数据库用户
