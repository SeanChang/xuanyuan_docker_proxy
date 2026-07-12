---
image: jetbrains/qodana-python
description: "Qodana Python镜像为Python项目提供静态代码分析功能，可检测代码质量问题、安全漏洞及代码风格违规，帮助开发者提升代码可靠性与开发效率。"
source: https://xuanyuan.cloud/zh/r/jetbrains/qodana-python
canonical: https://xuanyuan.cloud/zh/r/jetbrains/qodana-python
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/jetbrains/qodana-python" title="jetbrains/qodana-python Docker 镜像中文简介、标签列表与拉取命令">jetbrains/qodana-python 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Qodana Python 镜像文档


## 镜像概述和主要用途

Qodana Python 镜像是 JetBrains 官方提供的 Docker 镜像，专为 Python 项目的代码质量分析设计。基于 PyCharm 的静态分析引擎，该镜像可自动化执行代码检查、风格规范验证、潜在错误识别等任务，帮助开发团队提升代码质量、确保项目合规性并减少技术债务。


## 核心功能和特性

- **深度静态代码分析**：基于 PyCharm 检查引擎，支持 Python 语法、类型提示、代码复杂度等多维度分析  
- **全面规范支持**：内置对 PEP 8、PEP 257 等 Python 代码规范的检查，可自定义规则集  
- **框架兼容性**：适配主流 Python 框架（如 Django、Flask、FastAPI 等）的项目结构和特性  
- **集成能力**：支持与 CI/CD 流程（Jenkins、GitHub Actions 等）无缝集成，实现自动化质量门禁  
- **详细报告生成**：提供交互式 HTML 报告，包含问题定位、修复建议及优先级分级  
- **IDE 规则同步**：可导入/导出 PyCharm 项目配置，确保团队代码检查规则一致  


## 使用场景和适用范围

- **本地开发环境**：开发人员在提交代码前进行快速本地检查，提前发现问题  
- **CI/CD 流程集成**：在代码合并或部署前自动执行质量检查，阻止不合格代码进入生产环境  
- **开源项目维护**：通过自动化检查确保贡献代码符合项目规范，降低人工审核成本  
- **大型团队协作**：统一团队代码质量标准，减少代码评审中的主观分歧  
- **技术债务管理**：定期扫描项目，跟踪代码质量趋势，逐步优化历史遗留问题  


## 使用方法和配置说明

### 前提条件
- 安装 Docker Engine（20.10.0+）  
- 访问 JetBrains 账户（如需使用高级功能或私有项目分析）  


### 基本使用（`docker run` 命令）
通过以下命令启动容器，对当前目录的 Python 项目进行分析并生成报告：

```bash
docker run --rm \
  -v $(pwd):/data/project \  # 挂载本地项目目录到容器内
  -p 8080:8080 \             # 暴露端口以访问 HTML 报告
  jetbrains/qodana-python \  # 镜像名称
  --show-report              # 启动本地报告服务（默认端口 8080）
```

分析完成后，可通过 `http://localhost:8080` 在浏览器中查看报告。


### 关键配置参数

| 参数/环境变量       | 说明                                                                 |
|---------------------|----------------------------------------------------------------------|
| `-v <本地路径>:/data/project` | 挂载 Python 项目根目录（必选）                                        |
| `-p <本地端口>:8080`         | 映射容器内报告服务端口，用于访问 HTML 报告                            |
| `--rm`              | 分析完成后自动删除容器（推荐，避免残留容器占用资源）                  |
| `QODANA_TOKEN`      | 环境变量，用于访问私有仓库或 JetBrains 服务（需从 [Qodana 账户](https://qodana.cloud/) 获取） |
| `--profile <路径>`  | 指定自定义检查规则配置文件（如 `.qodana.yaml`），覆盖默认规则          |
| `--fail-threshold <数量>` | 设置失败阈值：当严重问题数量超过阈值时，容器以非 0 状态退出（用于 CI 门禁） |


### CI/CD 集成示例（GitHub Actions）
在 `.github/workflows/qodana.yml` 中添加以下配置，实现每次 push 时自动运行代码检查：

```yaml
name: Qodana
on: [push]

jobs:
  qodana:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Qodana
        uses: JetBrains/qodana-action@v2024.1
        with:
          image: docker.xuanyuan.run/jetbrains/qodana-python
          args: --fail-threshold 5  # 严重问题超过 5 个则阻断流程
```


## 许可证信息

使用 Qodana Docker 镜像即表示您同意 [JetBrains 隐私政策](https://www.jetbrains.com/company/privacy.html)。  
EAP（早期访问）版本镜像包含评估许可证，有效期为 30 天，需定期拉取更新镜像以继续使用。  
镜像中第三方软件的许可证信息详见 [JetBrains 第三方软件许可页面](https://www.jetbrains.com/legal/third-party-software/?product=QDPY)。  
Qodana 镜像的 Dockerfile 源码托管于 [JetBrains/qodana-docker](https://github.com/JetBrains/qodana-docker/tree/main) 仓库。


## 联系与支持

- 邮箱：[qodana-support@jetbrains.com](mailto:qodana-support@jetbrains.com)  
- 问题跟踪：[JetBrains YouTrack](https://youtrack.jetbrains.com/newIssue?project=QD)  

欢迎反馈功能建议或问题，帮助我们持续优化工具能力。


**用户指南**：[Qodana for Python 官方文档](https://jetbrains.com/help/qodana/qodana-python.html)
