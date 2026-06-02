<!-- xuanyuan-docker-images-zh
image: pulp/pulp-ci-centos
source: https://xuanyuan.cloud/zh/r/pulp/pulp-ci-centos
canonical: https://xuanyuan.cloud/zh/r/pulp/pulp-ci-centos
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/pulp/pulp-ci-centos" title="pulp/pulp-ci-centos Docker 镜像中文简介、标签列表与拉取命令">pulp/pulp-ci-centos — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/pulp/pulp-ci-centos" title="pulp/pulp-ci-centos Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/pulp/pulp-ci-centos</a></p>

# Pulp 3 基础镜像

## 镜像概述

该镜像为Pulp 3提供基础运行环境，是构建Pulp 3生态系统中各类服务（如Pulp Core、Pulp插件等）的底层基础镜像。它包含运行Pulp 3所需的核心依赖、系统库和环境配置，旨在简化Pulp 3相关服务的构建与部署流程。

## 核心功能和特性

- **预配置依赖**：内置Pulp 3运行所需的核心系统库、Python依赖及工具链，减少构建过程中的依赖安装步骤。
- **标准化环境**：提供统一的运行环境，确保Pulp 3相关服务在不同部署场景下的一致性和兼容性。
- **轻量级设计**：基于精简的基础系统镜像构建，平衡功能完整性与镜像体积，优化部署效率。
- **版本兼容性**：针对Pulp 3的版本特性进行适配，确保与Pulp 3核心及官方插件的兼容性。

## 使用场景

- **Pulp 3服务开发**：开发者可基于此镜像构建自定义Pulp 3服务或插件，无需从零配置基础环境。
- **Pulp 3部署**：作为生产或测试环境中Pulp 3服务的基础镜像，简化部署流程。
- **CI/CD流水线**：在持续集成/持续部署流程中，用于标准化Pulp 3相关组件的构建和测试环境。

## 使用方法

### 拉取镜像

通过Docker Hub拉取官方镜像（具体标签请参考Pulp官方版本说明）：

```bash
docker pull pulp/pulp-3-base:latest
```

### 作为基础镜像构建自定义服务

在Dockerfile中使用该镜像作为基础，构建包含特定插件或配置的Pulp 3服务：

```dockerfile
# 基于Pulp 3基础镜像
FROM pulp/pulp-3-base:latest

# 示例：安装Pulp Maven插件
RUN pip install pulp-maven-plugin==0.16.0

# 设置环境变量（如数据库连接信息，根据实际需求配置）
ENV PULP_DB_HOST=postgres \
    PULP_DB_NAME=pulp \
    PULP_DB_USER=pulp \
    PULP_DB_PASSWORD=password

# 暴露Pulp API端口
EXPOSE 24817

# 启动Pulp服务
CMD ["gunicorn", "pulp.wsgi:application", "--bind", "0.0.0.0:24817"]
```

### 构建并运行自定义镜像

```bash
# 构建自定义镜像
docker build -t my-custom-pulp:latest .

# 运行容器（需提前配置数据库等依赖服务）
docker run -d -p 24817:24817 --name my-pulp-service my-custom-pulp:latest
```

## 注意事项

- 该镜像仅包含基础运行环境，生产环境部署需额外配置数据库（如PostgreSQL）、缓存（如Redis）等依赖服务。
- 请根据Pulp 3的具体版本选择对应标签的基础镜像，避免版本兼容性问题。
- 详细配置说明及高级用法，请参考[Pulp官方文档](https://docs.pulpproject.org/)。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/pulp/pulp-ci-centos" title="pulp/pulp-ci-centos Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/pulp/pulp-ci-centos</a></p>
