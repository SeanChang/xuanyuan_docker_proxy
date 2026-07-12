---
image: sonarsource/sonar-scanner-cli
description: "用于SonarQube和SonarCloud的SonarScanner CLI"
source: https://xuanyuan.cloud/zh/r/sonarsource/sonar-scanner-cli
canonical: https://xuanyuan.cloud/zh/r/sonarsource/sonar-scanner-cli
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/sonarsource/sonar-scanner-cli" title="sonarsource/sonar-scanner-cli Docker 镜像中文简介、标签列表与拉取命令">sonarsource/sonar-scanner-cli 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# SonarScanner CLI Docker镜像
[SonarScanner](https://redirect.sonarsource.com/doc/install-configure-scanner.html)是用于在SonarQube和SonarCloud上运行代码分析的官方命令行工具。此镜像由SonarSource提供，包含SonarScanner CLI。

注意：这些Docker镜像不兼容C#和Objective-C项目。对于C/C++，Docker镜像仅兼容[自动配置模式](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/languages/c-family/analysis-modes/)。

- 此镜像的源码仓库：https://github.com/SonarSource/sonar-scanner-cli-docker
- SonarScanner CLI的源码仓库：https://github.com/SonarSource/sonar-scanner-cli

## 更新日志

版本10引入了一项可能影响部分用户的重大变更。在此版本中，底层SonarScanner CLI进程以普通用户（uid 1000）而非root用户执行。您可能会在卷或绑定挂载上遇到权限问题。

## 版本控制

从版本10开始，镜像版本与嵌入的SonarScanner CLI版本不同。标签格式为：*x.y.z.buildNumber_ScannerCLIVersion*。请注意，`latest`标签始终指向最新发布版本，可能包含破坏性变更。为减少潜在影响，若希望更可控，建议使用特定版本。若需获取特定版本的最新补丁，可使用指向*major*或*major.minor*版本的标签，例如`10`或`10.0`。

## 如何使用此镜像

要使用最新的SonarScanner CLI Docker镜像进行扫描，使用以下命令：
```
docker run 
--rm 
-e SONAR_HOST_URL="https://${SONAR_HOST_URL}"  
-v "${PROJECT_BASEDIR}:/usr/src" 
sonarsource/sonar-scanner-cli
```

其中：
* `${SONAR_HOST_URL}`是您的SonarQube实例URL，若要在SonarCloud上扫描，则为https://sonarcloud.io/
* `${PROJECT_BASEDIR}`是您要扫描的源代码位置

有关如何使用和配置镜像的信息，请参阅[SonarScanner CLI文档](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)的Docker部分。

## 问题或反馈

对于支持问题（“如何做？”、“我遇到此错误，原因是什么？”等），请先阅读[文档](https://docs.sonarqube.org/)，然后前往[SonarSource论坛](https://community.sonarsource.com/)。您的问题可能已有类似解答。

请注意，此论坛是社区论坛，因此请使用标准礼貌用语（“您好”、“谢谢”等）。如果您的帖子未得到回复，请至少等待三天后再跟进。工作人员不会随时在线。:-)

## 贡献

如果您希望看到新功能，请在[社区论坛](https://community.sonarsource.com/)创建新帖子（“当日产品经理”）

## 许可证

版权所有2015-2024 SonarSource。

根据[GNU Lesser General Public License, Version 3.0](http://www.gnu.org/licenses/lgpl.txt)许可。
