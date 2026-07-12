---
image: concourse/test-image-file-perms-mtime
description: "用于测试Registry Image Resource的测试镜像"
source: https://xuanyuan.cloud/zh/r/concourse/test-image-file-perms-mtime
canonical: https://xuanyuan.cloud/zh/r/concourse/test-image-file-perms-mtime
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/concourse/test-image-file-perms-mtime" title="concourse/test-image-file-perms-mtime Docker 镜像中文简介、标签列表与拉取命令">concourse/test-image-file-perms-mtime 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 镜像概述

本镜像为测试专用镜像，主要用于测试 [Registry Image Resource](https://github.com/concourse/registry-image-resource)——一个Concourse CI/CD工具的资源类型，用于与容器镜像仓库进行交互。

# 核心功能与特性

- 测试目标载体：作为Registry Image Resource的测试目标，用于验证其核心功能（如镜像拉取、推送、版本检测、元数据提取等）。
- 标准化测试环境：提供一致的镜像环境，确保Registry Image Resource测试用例的可重复性和准确性。

# 使用场景

- Registry Image Resource开发测试：在Registry Image Resource的开发或维护过程中，作为测试对象验证功能正确性。
- 兼容性验证：用于测试Registry Image Resource与不同容器镜像仓库（如Docker Hub、私有仓库等）的交互兼容性。

# 使用方法

## 在Concourse Pipeline中使用

通常在Concourse pipeline配置中，将本镜像作为Registry Image Resource的目标仓库引用，示例如下：

```yaml
resources:
- name: test-registry-image
  type: registry-image
  source:
    repository: <本测试镜像仓库地址>
    tag: latest  # 或指定测试版本

jobs:
- name: verify-registry-image-resource
  plan:
  - get: test-registry-image
    trigger: true
  # 后续添加测试步骤，验证Registry Image Resource功能
```

## 本地测试

如需本地验证Registry Image Resource与本镜像的交互，可通过以下步骤：

1. 拉取镜像：
   ```bash
   docker pull docker.xuanyuan.run/<镜像仓库地址>/<镜像名称>:<标签>
   ```

2. 运行测试命令（具体命令取决于Registry Image Resource的测试需求）：
   ```bash
   # 示例：验证镜像元数据提取
   registry-image-resource-check <镜像仓库地址>/<镜像名称> --tag latest
   ```

> 注：实际使用时需替换`<镜像仓库地址>`、`<镜像名称>`和`<标签>`为具体值，详细信息可参考镜像的仓库页面或项目文档。
