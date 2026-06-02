<!-- xuanyuan-docker-images-zh
image: mathworks/matlab
source: https://xuanyuan.cloud/zh/r/mathworks/matlab
canonical: https://xuanyuan.cloud/zh/r/mathworks/matlab
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/mathworks/matlab" title="mathworks/matlab Docker 镜像中文简介、标签列表与拉取命令">mathworks/matlab — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/mathworks/matlab" title="mathworks/matlab Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/mathworks/matlab</a></p>

# MATLAB Docker容器

通过预构建的MATLAB容器在云或服务器环境中访问MATLAB®。该容器还允许通过浏览器和虚拟网络计算（VNC）与MATLAB交互。


## 支持的标签

| 标签                | MATLAB版本  | 操作系统       | 基础镜像       |
|---------------------|-------------|----------------|----------------|
| `latest`, `R2025b`, `r2025b` | R2025b      | Ubuntu® 24.04  | ubuntu:24.04   |
| `R2025a`, `r2025a`  | R2025a      | Ubuntu 24.04   | ubuntu:24.04   |
| `R2024b`, `r2024b`  | R2024b      | Ubuntu 24.04   | ubuntu:24.04   |
| `R2024a`, `r2024a`  | R2024a      | Ubuntu 24.04   | ubuntu:24.04   |
| `R2023b`, `r2023b`  | R2023b      | Ubuntu 24.04   | ubuntu:24.04   |
| `R2023a`, `r2023a`  | R2023a      | Ubuntu 24.04   | ubuntu:24.04   |
| `R2022b`, `r2022b`  | R2022b      | Ubuntu 20.04   | ubuntu:20.04   |
| `R2022a`, `r2022a`  | R2022a      | Ubuntu 20.04   | ubuntu:20.04   |
| `R2021b`, `r2021b`  | R2021b      | Ubuntu 20.04   | ubuntu:20.04   |
| `R2021a`, `r2021a`  | R2021a      | Ubuntu 20.04   | ubuntu:20.04   |
| `R2020b`, `r2020b`  | R2020b      | Ubuntu 20.04   | ubuntu:20.04   |


## 快速启动说明

本节介绍拉取R2025b MATLAB镜像并从镜像启动交互式MATLAB会话的示例工作流。

要将R2025b MATLAB镜像拉取到本地机器，请执行：
```console
docker pull mathworks/matlab:r2025b
```

要使用`-browser`选项启动容器，请执行：
```console
docker run -it --rm -p 8888:8888 --shm-size=512M mathworks/matlab:r2025b -browser
```
系统将提供一个URL，用于在Web浏览器中访问MATLAB。

有关运行容器的更多信息，请参见[如何使用此镜像](#如何使用此镜像)部分。


## 什么是MATLAB？

[MATLAB](https://www.mathworks.com/products/matlab.html)是为工程师和科学家设计的编程平台。它结合了针对迭代分析和设计流程优化的桌面环境，以及直接表达矩阵和数组数学的编程语言。有关更多信息，请[点击此链接访问我们的网站](https://www.mathworks.com/discovery/what-is-matlab.html)。

MATLAB容器提供基于Ubuntu的镜像，包含MATLAB安装。


## 配置许可证

要运行此容器，您的许可证必须配置为云使用。个人许可证和校园许可证已配置为云使用。对于其他许可证类型，请联系您的许可证管理员。您可以通过查看[MathWorks账户](https://www.mathworks.com/login)确定您的许可证类型和管理员。管理员可参考[管理网络许可证](https://www.mathworks.com/help/install/administer-network-licenses.html)。如果您没有MATLAB许可证，可以在[MATLAB Docker试用版](https://www.mathworks.com/campaigns/products/trials/targeted/dkr.html)获取试用许可证。


## 如何使用此镜像

本节根据不同使用场景，介绍运行容器的各种选项。某些选项允许通过命令行界面与MATLAB交互，其他选项则支持通过MATLAB桌面交互。


### 在交互式命令提示符中运行MATLAB

要启动容器并在交互式命令提示符中运行MATLAB，请执行：
```console
$ docker run -it --rm --shm-size=512M mathworks/matlab:r2025b
```


### 以批处理模式非交互式运行MATLAB

要启动容器并运行MATLAB命令`RAND`，请执行：
```console
$ docker run --rm -e MLM_LICENSE_FILE=27000@MyLicenseServer mathworks/matlab:r2025b -batch rand
```
其中，您必须将`27000@MyLicenseServer`替换为网络许可证管理器的正确端口号和DNS地址。

或者，如果系统管理员提供了许可证文件，您可以将许可证文件挂载到容器，并将`MLM_LICENSE_FILE`指向容器中的许可证文件路径。例如，要启动容器并使用许可证文件运行MATLAB命令`RAND`，请执行：
```console
$ docker run --rm -v /path/to/local/license/file:/licenses/license.lic -e MLM_LICENSE_FILE=/licenses/license.lic mathworks/matlab:r2025b -batch rand
```

如果提供了有效的许可证文件，容器将运行MATLAB命令`RAND`然后退出。有关运行网络许可证管理器的更多信息，请参见[使用网络许可证管理器](https://github.com/mathworks-ref-arch/matlab-dockerfile#use-the-network-license-manager)。


### 通过Web浏览器运行并交互MATLAB

要启动容器，请执行：
```console
$ docker run -it --rm -p 8888:8888 --shm-size=512M mathworks/matlab:r2025b -browser
```

运行上述命令会在终端中打印用于在Web浏览器中访问MATLAB的URL。例如：
```console
MATLAB can be accessed at:
http://localhost:8888/index.html
```
将提供的URL输入Web浏览器。如果出现提示，请输入与MATLAB许可证关联的MathWorks®账户凭据。
如果使用网络许可证管理器，请切换到“网络许可证管理器”选项卡并输入许可证服务器地址。提供许可证信息后，MATLAB会话将在浏览器中启动（可能需要几分钟）。

要修改使用`-browser`标志启动时的MATLAB行为，请将环境变量传递给`docker run`命令。有关更多信息，请参见[高级用法](https://github.com/mathworks/matlab-proxy/blob/main/Advanced-Usage.md)。

某些浏览器可能不支持此工作流。有关更多信息，请参见[云解决方案浏览器要求](https://www.mathworks.com/support/requirements/browser-requirements.html)。

**注意：** Docker®镜像从MATLAB `R2022a`开始支持`-browser`标志。
要在自定义Docker镜像或旧版MATLAB Docker镜像（例如`R2021b`）中通过Web浏览器访问MATLAB，请参见[示例](https://github.com/mathworks/matlab-proxy/blob/main/examples/Dockerfile)。


### 以桌面模式运行MATLAB并通过VNC交互

要启动MATLAB桌面，请执行：
```console
$ docker run -it --rm -p 5901:5901 -p 6080:6080 --shm-size=512M mathworks/matlab:r2025b -vnc
```

要连接到MATLAB桌面，请选择以下任一方式：
1. 将浏览器指向运行此容器的Docker主机的6080端口（`http://hostname:6080`）
2. 使用VNC客户端连接到Docker主机的显示1（`hostname:1`）

默认VNC密码为`matlab`。使用`PASSWORD`环境变量更改密码。


### 使用X11运行MATLAB桌面

要启动容器并使用`X11`运行MATLAB桌面，请执行：
```console
$ xhost +
$ docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro --shm-size=512M mathworks/matlab:r2025b
```

MATLAB桌面窗口将在您的机器上打开。
注意，上述命令仅在安装了`X11`及其依赖项的Linux®操作系统上有效。


### 使用启动选项运行MATLAB

要覆盖容器的默认行为并使用任意参数集运行MATLAB（例如`-logfile`），请执行：
```console
$ docker run -it --rm --shm-size=512M mathworks/matlab:r2025b -logfile "logfilename.log"
```


### 环境变量

执行`docker run`命令时，可以使用`-e`选项指定环境变量。本节描述所有可指定的环境变量。


#### `MLM_LICENSE_FILE`

当您希望使用许可证文件或网络许可证管理器为MATLAB授权时，使用此环境变量。

<i>示例：</i>
```console
docker run -it --rm -e MLM_LICENSE_FILE=27000@MyLicenseServer --shm-size=512M mathworks/matlab:r2025b
```
<br />
```console
docker run -it --rm -e MLM_LICENSE_FILE=/license.dat --shm-size=512M mathworks/matlab:r2025b
```


#### `PROXY_SETTINGS`

当您希望使用代理服务器连接到MathWorks许可证服务器时，使用此环境变量。

<i>示例：</i>
```console
docker run -it --rm -e PROXY_SETTINGS=<proxy-server-address> --shm-size=512M mathworks/matlab:r2025b
```

您可以使用以下任一形式指定代理服务器地址：
- `hostname:12345`
- `shorthostname:12345`
- `http://hostname:12345`
- `http://username:password@hostname:12345`
- `IPaddress:12345`

其中，`hostname`是完全限定域名，`shorthostname`是相对域名，12345是端口号。


#### `PASSWORD`

当您希望更改访问VNC服务器的密码时，使用此环境变量。

<i>示例：</i>
```console
docker run -it --rm -e PASSWORD=ILoveMATLAB -p 5901:5901 -p 6080:6080 --shm-size=512M mathworks/matlab:r2025b -vnc
```


### 从MATLAB容器基础镜像创建自定义Docker镜像

创建名为`Dockerfile`的文件，内容如下：
```dockerfile
## 基于MATLAB基础镜像构建
FROM mathworks/matlab:r2025b

## 复制要执行的脚本/函数
COPY myscript.m ./

## 以批处理模式启动MATLAB并执行脚本/函数
CMD ["matlab","-batch","myscript"]
```

然后可以构建并运行Docker镜像：
```console
$ docker build -t my-matlab-container .
$ docker run -it --rm --shm-size=512M my-matlab-container
```


### 在容器中安装更新、工具箱、附加组件并保存更改

您可以在此容器中安装最新的MATLAB更新或其他工具箱和附加组件。有关更多信息，请参见[在容器中安装更新、工具箱、支持包和附加组件](https://www.mathworks.com/help/cloudcenter/ug/install-updates-toolboxes-support-packages-and-add-ons-in-containers.html)。


## 安全报告

按照这些说明[报告疑似安全问题](https://github.com/mathworks-ref-arch/container-images/blob/master/SECURITY.md)。


## 其他信息

此容器包含The MathWorks, Inc.的商业软件产品（“MathWorks程序”）及相关材料。MathWorks程序根据MathWorks软件许可协议授权，该协议位于此容器的MATLAB安装中。此容器中的相关材料根据单独的许可证授权，可在各自的文件夹中找到。

要了解有关MATLAB容器的更多信息，请参见[Docker Hub上的MATLAB容器](https://www.mathworks.com/help/cloudcenter/ug/matlab-container-on-docker-hub.html)。

要查看用于构建此Docker镜像的源文件，请参见[GitHub上的MATLAB容器镜像](https://github.com/mathworks-ref-arch/container-images/tree/main/matlab)。

要提供其他功能或能力的建议，请[联系我们](https://www.mathworks.com/solutions/cloud.html)。


## 技术支持

如果您需要帮助或请求其他功能或能力，请联系[MathWorks技术支持](https://www.mathworks.com/support/contact_us.html)。

Copyright 2020-2025 The MathWorks, Inc.

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/mathworks/matlab" title="mathworks/matlab Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/mathworks/matlab</a></p>
