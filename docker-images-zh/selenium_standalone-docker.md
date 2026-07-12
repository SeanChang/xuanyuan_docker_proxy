---
image: selenium/standalone-docker
description: "带动态功能的Selenium Grid Standalone镜像，可动态创建Docker浏览器容器，支持远程运行WebDriver测试，实现按需启动和销毁容器，简化自动化测试环境配置。"
source: https://xuanyuan.cloud/zh/r/selenium/standalone-docker
canonical: https://xuanyuan.cloud/zh/r/selenium/standalone-docker
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/selenium/standalone-docker" title="selenium/standalone-docker Docker 镜像中文简介、标签列表与拉取命令">selenium/standalone-docker 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 带动态功能的Selenium Grid Standalone

### 此镜像提供[Selenium Grid Standalone](https://www.selenium.dev/documentation/grid/getting_started/#standalone)，可动态创建Docker浏览器子容器，使您能够[远程运行WebDriver测试](https://www.selenium.dev/documentation/webdriver/drivers/remote_webdriver/)。

## 动态网格

Grid 4具备按需启动Docker容器的能力，这意味着它会为每个新的会话请求在后台启动一个Docker容器，测试在其中执行，测试完成后容器会被销毁。

此执行模式可用于Standalone或Node角色。"动态"执行模式需要指定启动容器时使用的Docker镜像。此外，Grid需要知道Docker守护进程的URI。此配置可放在本地`toml`文件中。

更多详情请参见[GitHub上的动态网格部分](https://github.com/SeleniumHQ/docker-selenium/tree/trunk#dynamic-grid)。

### 配置示例

您可以将以下内容保存为本地文件，例如命名为`config.toml`。

```toml
[docker]
# 配置包含Docker镜像与需要匹配的功能之间的映射关系
# 以启动具有给定镜像的容器。
configs = [
    "selenium/standalone-firefox:latest", '{"browserName": "firefox"}',
    "selenium/standalone-chrome:latest", '{"browserName": "chrome"}',
    "selenium/standalone-edge:latest", '{"browserName": "MicrosoftEdge"}'
]

# 连接到docker守护进程的URL
# 最简单的方法是保持为http://127.0.0.1:2375，并挂载/var/run/docker.sock。
# 使用127.0.0.1是因为当挂载/var/run/docker.sock时，容器内部使用socat
# 如果未挂载var/run/docker.sock：
# Windows：确保Docker Desktop通过tcp暴露守护进程，并使用http://host.docker.internal:2375。
# macOS：安装socat并运行以下命令，socat -4 TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock,
# 然后使用http://host.docker.internal:2375。
# Linux：因机器而异，请挂载/var/run/docker.sock。如果这不起作用，请创建issue。
url = "http://127.0.0.1:2375"
# 用于视频录制的Docker镜像
video-image = "selenium/video:ffmpeg-4.3.1-20230421"

# 如果在单独的VM上运行节点，请取消以下部分的注释
# 用适当的值填写占位符
#[server]
#host = <node-machine的IP>
#port = <node-machine的端口>
```

## 如何运行此镜像

1. 启动Standalone Dynamic容器

```bash
docker run --rm --name selenium-docker -p 4444:4444 \
    -v ${PWD}/config.toml:/opt/bin/config.toml \
    -v ${PWD}/assets:/opt/selenium/assets \
    -v /var/run/docker.sock:/var/run/docker.sock \
    docker.xuanyuan.run/selenium/standalone-docker:latest
```

#### Windows PowerShell

```bash
docker run --rm --name selenium-docker -p 4444:4444 `
    -v ${PWD}/config.toml:/opt/bin/config.toml `
    -v ${PWD}/assets:/opt/selenium/assets `
    -v /var/run/docker.sock:/var/run/docker.sock `
    selenium/standalone-docker:latest
```

2. 将您的WebDriver测试指向http://localhost:4444

3. 完成！

4. （可选）要查看容器内部情况，请访问Grid UI：http://localhost:4444/ui。

* 上述示例使用`latest`作为标签，但建议使用完整标签来固定特定的浏览器和Grid版本。详情请参见[标签约定](https://github.com/SeleniumHQ/docker-selenium/wiki/Tagging-Convention)。

## 如何选择正确的标签

标签结构如下：

```
selenium/standalone-docker-<Major>.<Minor>.<Patch>-<YYYYMMDD>
```


### Selenium Grid Server 4.9.0版本示例（发布于20230426）

```
    Selenium Server 4.9.0
    发布日期 20230426


e126989f151e        selenium/standalone-docker   4
e126989f151e        selenium/standalone-docker   4.9
e126989f151e        selenium/standalone-docker   4.9.0
e126989f151e        selenium/standalone-docker   4.9.0-20230426
```

通过这种方式，您可以使用不同的标签来获取最新版本。

## 完整文档

Docker-Selenium项目在GitHub上有详细的[README](https://github.com/SeleniumHQ/docker-selenium)，可帮助您找到适合您使用场景的正确配置方法。

## 许可证

该项目由志愿者贡献者实现，他们投入了数千小时的时间，并根据[Apache License 2.0](https://raw.githubusercontent.com/SeleniumHQ/selenium/trunk/LICENSE)许可协议开源源代码。
