---
image: metabase/metabase-head
description: "Metabase仓库的开发主分支版本。请自行承担使用风险。"
source: https://xuanyuan.cloud/zh/r/metabase/metabase-head
canonical: https://xuanyuan.cloud/zh/r/metabase/metabase-head
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/metabase/metabase-head" title="metabase/metabase-head Docker 镜像中文简介、标签列表与拉取命令">metabase/metabase-head 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Metabase

Metabase 是一种简单的开源方式，让公司中的每个人都能提出问题并从数据中学习。

![Metabase 产品截图](docs/metabase-product-screenshot.png)

[![最新版本](https://img.shields.io/github/release/metabase/metabase.svg?label=latest%20release)](https://github.com/metabase/metabase/releases) [![Circle CI](https://circleci.com/gh/metabase/metabase.svg?style=svg&circle-token=3ccf0aa841028af027f2ac9e8df17ce603e90ef9)](https://circleci.com/gh/metabase/metabase) [![codecov](https://codecov.io/gh/metabase/metabase/branch/master/graph/badge.svg)](https://codecov.io/gh/metabase/metabase)

# 特性

- 5 分钟[设置](https://metabase.com/docs/latest/setting-up-metabase.html)（我们是认真的）
- 让团队中的任何人无需了解 SQL 即可[提出问题](https://metabase.com/docs/latest/users-guide/04-asking-questions.html)
- 丰富美观的[仪表板](https://metabase.com/docs/latest/users-guide/06-sharing-answers.html)，支持自动刷新和全屏模式
- 供分析师和数据专业人员使用的[SQL 模式](https://www.metabase.com/docs/latest/users-guide/writing-sql.html)
- 创建规范的[细分和指标](https://metabase.com/docs/latest/administration-guide/07-segments-and-metrics.html)供团队使用
- 通过[仪表板订阅](https://www.metabase.com/docs/latest/users-guide/dashboard-subscriptions.html)按计划将数据发送到 Slack 或电子邮件
- 使用[MetaBot](https://metabase.com/docs/latest/users-guide/11-metabot.html)随时在 Slack 中查看数据
- 通过重命名、注释和隐藏字段为团队[优化数据](https://metabase.com/docs/latest/administration-guide/03-metadata-editing.html)
- 使用[警报](https://www.metabase.com/docs/latest/users-guide/15-alerts.html)查看数据变化

更多信息请访问 [metabase.com](https://metabase.com/)

## 支持的数据库

- [官方支持的数据库](https://www.metabase.com/docs/latest/administration-guide/01-managing-databases.html#officially-supported-databases)。
- [社区支持的驱动](https://www.metabase.com/docs/latest/developers-guide-drivers.html#how-to-use-a-community-built-driver)。

## 安装

Metabase 几乎可以在任何地方运行，因此请查看我们的[安装指南](https://www.metabase.com/docs/latest/operations-guide/installing-metabase.html)以获取各种部署的详细说明。以下是简要概述：

### Docker

要通过 Docker 运行 Metabase，只需输入

```
docker run -d -p 3000:3000 --name metabase docker.xuanyuan.run/metabase/metabase
```

**Docker 部署方案示例（持久化数据）**：为确保数据持久化，建议使用数据卷挂载 Metabase 数据目录：

```
docker run -d -p 3000:3000 --name metabase -v metabase-data:/metabase-data docker.xuanyuan.run/metabase/metabase
```

### JAR 文件

要通过 JAR 文件运行 Metabase，您需要在系统上安装 Java 运行环境。

我们推荐使用 [AdoptOpenJDK](https://adoptopenjdk.net/releases.html) 提供的最新 LTS 版本 JRE，带有 HotSpot JVM 和 x64 架构，但其他[Java 版本](https://www.metabase.com/docs/latest/operations-guide/java-versions.html)也可能适用。

访问 [Metabase 下载页面](https://metabase.com/start/jar.html) 下载最新版本。将下载的 JAR 文件放入新建目录（运行时会创建一些文件），然后使用以下命令运行：

```
java -jar metabase.jar
```

现在，打开浏览器访问 [http://localhost:3000](http://localhost:3000)，系统会引导您设置用户账户，然后添加数据库连接。为此，您需要获取要连接的数据库信息，例如主机名、端口、数据库名称以及使用的用户名和密码。

添加连接后，您将进入应用程序，准备提出第一个问题。

有关详细步骤，请查看我们的[入门指南](https://www.metabase.com/docs/latest/getting-started.html)。

# 常见问题

一些问题经常被问到。请先查看：[FAQ](https://www.metabase.com/docs/latest/faq/start.html)

# 安全披露

详情参见 [SECURITY.md](./SECURITY.md)。

# 贡献

要开始 Metabase 的开发安装，请按照我们的[开发者指南](https://www.metabase.com/docs/latest/developers-guide.html)中的说明进行操作。

然后查看我们的[贡献指南](https://www.metabase.com/docs/latest/contributing.html)，了解我们的流程以及您可以参与的部分！

# 国际化

我们希望 Metabase 支持尽可能多的语言。查看可用的翻译，并通过我们在 [POEditor](https://poeditor.com/join/project/ynjQmwSsGh) 上的项目帮助贡献国际化内容。您也可以查看我们的[翻译政策](https://www.metabase.com/docs/latest/faq/general/what-languages-can-be-used-with-metabase.html)。

# 扩展和深度集成

Metabase 还允许您直接从 Javascript 访问我们的查询 API，将我们提供的简单分析与您自己的应用程序或第三方服务集成，以执行以下操作：

- 构建审核界面
- 将用户子集导出到第三方营销自动化软件
- 为公司人员提供专门的客户查询应用程序


# 许可证

此仓库包含 Metabase 开源版的源代码（根据 AGPL 许可发布）以及 Metabase Enterprise 商业版的源代码（根据 Metabase 商业软件许可发布）。

详情参见 [LICENSE.txt](./LICENSE.txt)。

除非另有说明，所有文件 © 2021 Metabase, Inc.
