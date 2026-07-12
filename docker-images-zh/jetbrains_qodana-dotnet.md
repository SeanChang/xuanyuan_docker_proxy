---
image: jetbrains/qodana-dotnet
description: "Qodana for .NET Docker镜像提供针对.NET项目的静态代码分析、代码质量检查及漏洞检测功能，帮助开发团队提升代码质量并发现潜在问题。"
source: https://xuanyuan.cloud/zh/r/jetbrains/qodana-dotnet
canonical: https://xuanyuan.cloud/zh/r/jetbrains/qodana-dotnet
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jetbrains/qodana-dotnet" title="jetbrains/qodana-dotnet Docker 镜像中文简介、标签列表与拉取命令">jetbrains/qodana-dotnet 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Qodana for .NET Docker镜像文档


## 镜像概述与主要用途

Qodana for .NET 是由 JetBrains 官方开发的 Docker 镜像，专为 .NET 项目提供代码质量分析解决方案。作为 JetBrains Qodana 系列工具的一部分，该镜像集成了 JetBrains 深厚的代码分析技术，可对 .NET 项目（包括 .NET Core、ASP.NET、.NET Framework 等）进行静态代码分析，帮助开发者检测代码缺陷、潜在问题、不符合最佳实践的代码风格，并生成详细的质量报告，从而提升项目代码质量和可维护性。


## 核心功能与特性

- **静态代码分析**：基于 JetBrains IDE（如 Rider）的代码检查引擎，支持对 .NET 项目进行深度静态分析，覆盖语法错误、逻辑缺陷、性能问题、安全漏洞等。
- **多项目类型支持**：兼容各类 .NET 项目，包括控制台应用、Web 应用（ASP.NET Core）、类库、单元测试项目等。
- **可定制规则集**：支持根据项目需求调整代码检查规则，可启用/禁用特定检查项，适配团队编码规范。
- **详细报告生成**：分析完成后生成结构化报告，包含问题分类、严重程度、位置定位及修复建议，支持本地查看或集成到 CI/CD 系统。
- **官方持续维护**：作为 JetBrains 官方项目，镜像定期更新，确保与最新 .NET 版本及代码检查规则同步。


## 使用场景与适用范围

- **开发者日常开发**：集成到本地开发流程，在提交代码前进行快速质量检查，提前发现问题。
- **CI/CD 流程集成**：作为自动化构建的一部分，在代码合并前执行质量门禁，阻止低质量代码进入主分支。
- **团队协作与代码审查**：为代码审查提供客观质量数据，聚焦关键问题，提升审查效率。
- **开源项目质量保障**：帮助开源项目维护者监控代码质量，吸引贡献者并确保贡献代码符合项目标准。
- **遗留系统重构**：辅助分析遗留 .NET 项目的质量状况，识别重构优先级和风险点。


## 使用方法与配置说明

### 前提条件
- 已安装 Docker 环境（参考 [Docker 官方安装指南](https://docs.docker.com/engine/install/)）。
- 待分析的 .NET 项目源代码（本地目录或版本控制仓库）。


### 基本使用命令（docker run）

通过以下命令启动 Qodana for .NET 分析本地 .NET 项目：

```bash
docker run --rm -v <本地项目路径>:/data/project \
  -v <报告输出路径>:/data/results \
  docker.xuanyuan.run/jetbrains/qodana-dotnet
```

#### 参数说明：
- `--rm`：容器退出后自动删除，避免残留临时文件。
- `-v <本地项目路径>:/data/project`：将本地 .NET 项目目录挂载到容器内的 `/data/project`（分析目标目录）。
- `-v <报告输出路径>:/data/results`：将容器内生成的分析报告挂载到本地目录，便于查看。
- `jetbrains/qodana-dotnet`：Qodana for .NET 镜像名称（具体版本可通过 `:tag` 指定，如 `jetbrains/qodana-dotnet:latest`）。


### 高级配置与扩展

更多配置选项（如指定分析规则、排除目录、设置报告格式等）可参考 [官方用户指南](https://jetbrains.com/help/qodana/qodana-dotnet.html)。常见扩展场景包括：

#### 1. 集成到 CI/CD 系统（如 GitHub Actions）
通过环境变量或配置文件指定分析参数，例如：
```yaml
# .github/workflows/qodana.yml 示例
jobs:
  qodana:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Qodana for .NET
        uses: docker://jetbrains/qodana-dotnet:latest
        with:
          args: --source=/github/workspace --output=/github/workspace/qodana-report
```

#### 2. 自定义检查规则
通过挂载规则配置文件（如 `qodana.yaml`）自定义检查项：
```bash
docker run --rm -v <本地项目路径>:/data/project \
  -v <本地规则文件路径>:/data/project/qodana.yaml \
  docker.xuanyuan.run/jetbrains/qodana-dotnet
```


## 许可证信息

使用 Qodana Docker 镜像即表示您同意 [JetBrains 隐私政策](https://www.jetbrains.com/company/privacy.html)。

- **EAP 镜像许可**：EAP（Early Access Program）版本镜像包含评估许可证，有效期为 30 天。请定期拉取新镜像以获取更新。
- **第三方软件许可**：镜像中可能包含其他开源软件，其许可证信息详见 [JetBrains 第三方软件许可页面](https://www.jetbrains.com/legal/third-party-software/?product=QDNET)。
- **Dockerfile 源码**：Qodana 镜像的构建文件（Dockerfile）开源托管于 [JetBrains/qodana-docker](https://github.com/JetBrains/qodana-docker/tree/main) 仓库。


## 反馈与支持

如有使用问题或功能建议，可通过以下方式联系 JetBrains 团队：
- 邮箱：[qodana-support@jetbrains.com](mailto:qodana-support@jetbrains.com)
- Issue Tracker：[提交新问题](https://youtrack.jetbrains.com/newIssue?project=QD)（项目代号：QD）

我们欢迎您的反馈，帮助改进工具功能和用户体验。
