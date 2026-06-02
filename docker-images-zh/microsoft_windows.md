<!-- xuanyuan-docker-images-zh
image: microsoft/windows
source: https://xuanyuan.cloud/zh/r/microsoft/windows
canonical: https://xuanyuan.cloud/zh/r/microsoft/windows
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [microsoft/windows — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/microsoft/windows "microsoft/windows Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/microsoft/windows

# 特色标签

- `LTSC2019` ([LTSC](https://docs.microsoft.com/en-us/windows-server/get-started/servicing-channels-comparison)) `docker pull mcr.microsoft.com/windows:ltsc2019`

注意：我们未基于Windows Server 2022版本构建此容器镜像。不过，您可以使用Windows Server 2022版本附带的Windows Server基础OS容器镜像：[windows/server](https://hub.docker.com/_/microsoft-windows-server)。


# 关于本镜像
这是Windows Server容器的基础镜像，包含Windows基础操作系统镜像。

有关服务生命周期的更多信息，请访问[基础镜像服务生命周期](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/base-image-lifecycle)。

# 如何使用本镜像
Windows要求主机操作系统版本与容器操作系统版本匹配。如果您想运行基于较新Windows版本的容器，请确保您的主机版本与之对应。否则，您可以使用Hyper-V隔离在新版本主机上运行旧版本容器。您可以在[容器文档](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility)中阅读有关Windows容器版本兼容性的更多信息。

本镜像的默认入口点为Cmd.exe。运行镜像的命令如下：

`docker run mcr.microsoft.com/windows:ltsc2019`

**注意：此仓库未发布或维护`latest`标签。从本仓库拉取或引用镜像时，请指定具体标签。**

# 配置
- 您的主机必须已启用Windows容器功能。Windows容器功能仅在Windows Server 2016（核心版和带桌面体验版）、Windows 10专业版和企业版（周年更新及更高版本）上可用。
- 如果您打算使用Hyper-V隔离运行容器，必须先在主机上安装Hyper-V角色。

# 相关仓库
+ [windows/nanoserver](https://hub.docker.com/_/microsoft-windows-nanoserver)：Nano Server基础OS容器镜像
+ [windows/servercore](https://hub.docker.com/_/microsoft-windows-servercore)：Windows Server Core基础OS容器镜像
+ [windows/server](https://hub.docker.com/_/microsoft-windows-server)：Server基础OS容器镜像
+ [windows/insider](https://hub.docker.com/_/microsoft-windows-insider/)：此基础OS镜像的Insider版本

# 完整标签列表
## Windows镜像
| 标签 | 架构 | Dockerfile | 操作系统版本 | 创建时间 | 最后更新时间 |
|---------|--------------|-----------|-------------|-------------|-------------|
| 20H2 | multiarch | 无 | 10.0.19042.1889 | 11/10/2020 | 08/09/2022 |
| 20H2-KB5016616 | multiarch | 无 | 10.0.19042.1889 | 08/09/2022 | 08/09/2022 |
| 10.0.19042.1889 | multiarch | 无 | 10.0.19042.1889 | 08/09/2022 | 08/09/2022 |
| 20H2-amd64 | amd64 | 无 | 10.0.19042.1889 | 11/10/2020 | 08/09/2022 |
| 20H2-KB5016616-amd64 | amd64 | 无 | 10.0.19042.1889 | 08/09/2022 | 08/09/2022 |
| 10.0.19042.1889-amd64 | amd64 | 无 | 10.0.19042.1889 | 08/09/2022 | 08/09/2022 |
| 2004 | multiarch | 无 | 10.0.19041.1415 | 05/27/2020 | 12/14/2021 |
| 2004-KB5008212 | multiarch | 无 | 10.0.19041.1415 | 12/14/2021 | 12/14/2021 |
| 10.0.19041.1415 | multiarch | 无 | 10.0.19041.1415 | 12/14/2021 | 12/14/2021 |
| 2004-amd64 | amd64 | 无 | 10.0.19041.1415 | 05/27/2020 | 12/14/2021 |
| 2004-KB5008212-amd64 | amd64 | 无 | 10.0.19041.1415 | 12/14/2021 | 12/14/2021 |
| 10.0.19041.1415-amd64 | amd64 | 无 | 10.0.19041.1415 | 12/14/2021 | 12/14/2021 |
| 1909 | multiarch | 无 | 10.0.18363.1556 | 11/12/2019 | 05/11/2021 |
| 1909-KB5003169 | multiarch | 无 | 10.0.18363.1556 | 05/11/2021 | 05/11/2021 |
| 10.0.18363.1556 | multiarch | 无 | 10.0.18363.1556 | 05/11/2021 | 05/11/2021 |
| 1909-amd64 | amd64 | 无 | 10.0.18363.1556 | 11/12/2019 | 05/11/2021 |
| 1909-KB5003169-amd64 | amd64 | 无 | 10.0.18363.1556 | 05/11/2021 | 05/11/2021 |
| 10.0.18363.1556-amd64 | amd64 | 无 | 10.0.18363.1556 | 05/11/2021 | 05/11/2021 |
| ltsc2019 | multiarch | 无 | 10.0.17763.7919 | 08/09/2022 | 10/14/2025 |
| 1809 | multiarch | 无 | 10.0.17763.7919 | 11/13/2018 | 10/14/2025 |
| 1809-KB5066586 | multiarch | 无 | 10.0.17763.7919 | 10/14/2025 | 10/14/2025 |
| 10.0.17763.7919 | multiarch | 无 | 10.0.17763.7919 | 10/14/2025 | 10/14/2025 |
| ltsc2019-amd64 | amd64 | 无 | 10.0.17763.7919 | 08/09/2022 | 10/14/2025 |
| 1809-amd64 | amd64 | 无 | 10.0.17763.7919 | 04/05/2019 | 10/14/2025 |
| 1809-KB5066586-amd64 | amd64 | 无 | 10.0.17763.7919 | 10/14/2025 | 10/14/2025 |
| 10.0.17763.7919-amd64 | amd64 | 无 | 10.0.17763.7919 | 10/14/2025 | 10/14/2025 |

## 多架构镜像
| 标签 | 架构 | 操作系统 | 操作系统版本 | 创建时间 | 最后更新时间 |
|---------|--------------|-------------|-------------|-------------|-------------|
| 20H2 | multiarch | windows | 10.0.19042.1889 | 11/10/2020 | 08/09/2022 |
| 20H2-KB5016616 | multiarch | windows | 10.0.19042.1889 | 08/09/2022 | 08/09/2022 |
| 10.0.19042.1889 | multiarch | windows | 10.0.19042.1889 | 08/09/2022 | 08/09/2022 |
| 2004 | multiarch | windows | 10.0.19041.1415 | 05/27/2020 | 12/14/2021 |
| 2004-KB5008212 | multiarch | windows | 10.0.19041.1415 | 12/14/2021 | 12/14/2021 |
| 10.0.19041.1415 | multiarch | windows | 10.0.19041.1415 | 12/14/2021 | 12/14/2021 |
| 1909 | multiarch | windows | 10.0.18363.1556 | 11/12/2019 | 05/11/2021 |
| 1909-KB5003169 | multiarch | windows | 10.0.18363.1556 | 05/11/2021 | 05/11/2021 |
| 10.0.18363.1556 | multiarch | windows | 10.0.18363.1556 | 05/11/2021 | 05/11/2021 |
| ltsc2019 | multiarch | windows | 10.0.17763.7919 | 08/09/2022 | 10/14/2025 |
| 1809 | multiarch | windows | 10.0.17763.7919 | 11/13/2018 | 10/14/2025 |
| 1809-KB5066586 | multiarch | windows | 10.0.17763.7919 | 10/14/2025 | 10/14/2025 |
| 10.0.17763.7919 | multiarch | windows | 10.0.17763.7919 | 10/14/2025 | 10/14/2025 |

您可以通过 https://mcr.microsoft.com/v2/windows/tags/list 获取所有可用的windows标签列表。

# 支持

## 反馈

* [提交问题](https://github.com/microsoft/Windows-Containers/issues/new/choose)
* [联系Microsoft支持](https://support.microsoft.com/contactus/)

# 许可
- 法律声明：[容器许可信息](https://aka.ms/mcr/osslegalnotice)

**MICROSOFT SOFTWARE SUPPLEMENTAL LICENSE FOR WINDOWS CONTAINER BASE IMAGE**<br/>
本补充许可适用于Windows容器基础镜像（“容器镜像”）。如果您遵守本补充许可的条款，您可以按如下所述使用容器镜像。

**容器操作系统镜像**<br/>
容器镜像只能与有效许可的以下软件一起使用：
* Windows Server标准版或Windows Server数据中心版软件（统称为“服务器主机软件”），或
* Microsoft Windows操作系统（版本10和11）软件（“客户端主机软件”），或
* Windows 10和11 IoT企业版以及Windows 10和11 IoT核心版（统称为“IoT主机软件”）。

服务器主机软件、客户端主机软件和IoT主机软件统称为“主机软件”，主机软件的许可称为“主机许可”。

如果您没有相应版本和版本的主机许可，则不得使用容器镜像。可能适用某些限制和附加条款，如下所述。如果本许可条款与主机许可冲突，则本补充许可应适用于容器镜像。接受本补充许可或使用容器镜像，即表示您同意所有这些条款。如果您不接受并遵守这些条款，则不得使用容器镜像。

**定义**<br/>
**Windows Server容器**（无Hyper-V隔离）是Microsoft Windows Server软件的一项功能。

**带Hyper-V隔离的Windows Server容器**。Microsoft Windows Server许可条款的第2(k)节现全文删除，并替换为下文“更新”所示的修订条款。

更新：带Hyper-V隔离的Windows Server容器（以前称为Hyper-V容器）是Windows Server中的一种容器技术，它利用虚拟操作系统环境托管一个或多个Windows Server容器。每个用于托管一个或多个Windows Server容器的Hyper-V隔离实例被视为一个虚拟操作系统环境。

**许可条款**<br/>
**主机许可**。主机许可条款适用于您对容器镜像以及使用容器镜像创建的、与虚拟机不同且独立的任何Windows容器的使用。

**使用权利**。容器镜像可用于创建隔离的虚拟化Windows操作系统环境，其中至少包含一个添加主要和重要功能的应用程序。您只能在主机软件上使用容器镜像创建、构建和运行Windows容器。主机软件的更新可能不会更新容器镜像，因此您可以基于更新的容器镜像重新创建任何Windows容器。

**限制**。您不得从容器镜像中删除本补充许可文档文件。您不得启用对容器内运行的应用程序的远程访问以规避适用的许可费用。您不得对容器镜像进行反向工程、反编译或反汇编，或尝试这样做，除非且仅限于第三方许可条款要求对可能包含在软件中的某些开源组件的使用进行此类操作。主机许可中的其他限制可能适用。

**附加条款**<br/>
**客户端主机软件**。在客户端主机软件上运行容器镜像时，您可以运行任意数量的容器镜像实例化为Windows容器，仅用于测试或开发目的。您不得在客户端主机软件的生产环境中使用这些Windows容器。

**IoT主机软件**。在IoT主机软件上运行容器镜像时，您可以运行任意数量的容器镜像实例化为Windows容器，仅用于测试或开发目的。只有在您同意《Windows 10 Core Runtime Images的Microsoft商业使用条款》或《Windows 10 IoT企业版设备许可》（“Windows IoT商业协议”）的情况下，才能在生产环境中使用容器镜像。Windows IoT商业协议中的附加条款和限制适用于您在生产环境中对容器镜像的使用。

**第三方软件**。容器镜像可能包含根据本补充许可或许可其自身条款许可给您的第三方应用程序。第三方应用程序的许可条款、通知和声明（如有）可在http://aka.ms/thirdpartynotices在线获取或在随附的通知文件中获取。即使此类应用程序受其他协议管辖，主机许可中的免责声明、责任限制和损害排除在适用法律允许的范围内也同样适用。

**开源组件**。容器镜像可能包含根据开源许可授权的第三方版权软件，这些许可要求提供源代码。这些许可的副本包含在ThirdPartyNotices文件
