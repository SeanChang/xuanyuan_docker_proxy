<!-- xuanyuan-docker-images-zh
image: chromedp/headless-shell
source: https://xuanyuan.cloud/zh/r/chromedp/headless-shell
canonical: https://xuanyuan.cloud/zh/r/chromedp/headless-shell
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [chromedp/headless-shell — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/chromedp/headless-shell "chromedp/headless-shell Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/chromedp/headless-shell

# chromedp/headless-shell Docker镜像文档


## 镜像概述和主要用途

[headless-shell][headless-shell]项目提供了一个Docker镜像[`chromedp/headless-shell`][docker-headless-shell]，该镜像包含预构建的Chrome `headless-shell`——一个精简版Chrome，主要用于驱动、分析或测试网页。

此Docker镜像专为Go语言的[`chromedp`包][chromedp]设计，该包提供了简单易用的API，用于驱动兼容[Chrome调试协议][devtools-protocol]的浏览器。

镜像中的`headless-shell`版本基于Chromium源码树修改而来，已调整为与Chrome相同的用户代理，并进行了其他 minor 修改，以更好地适应嵌入式环境。


## 核心功能和特性

- **精简架构**：基于Chrome内核的精简版本，去除不必要组件，降低资源占用
- **调试协议兼容**：完全支持[Chrome调试协议][devtools-protocol]，可与各类自动化工具集成
- **用户代理优化**：修改用户代理字符串，与标准Chrome保持一致
- **嵌入式适配**：针对嵌入式环境进行优化，提升稳定性和兼容性
- **版本可控**：提供明确版本标记，支持固定版本部署，确保环境一致性


## 使用场景和适用范围

- Web应用自动化测试与UI交互验证
- 网页内容抓取与数据提取
- 网页性能分析与加载速度评估
- 基于Chrome内核的无头浏览器场景
- 与`chromedp`等Chrome调试协议客户端工具集成


## 使用方法和配置说明

### 拉取镜像

```bash
# 拉取最新版本
docker pull chromedp/headless-shell:latest

# 拉取特定版本（示例版本号）
docker pull chromedp/headless-shell:74.0.3717.1
```

### 运行容器

#### 基本运行命令

```bash
docker run -d -p 9222:9222 --rm --name headless-shell chromedp/headless-shell
```

#### 处理常见问题

若容器因`BUS_ADRERR`错误崩溃，需增大共享内存大小：

```bash
docker run -d -p 9222:9222 --rm --name headless-shell --shm-size 2G chromedp/headless-shell
```

#### 参数说明

- `-p 9222:9222`：映射容器内Chrome调试端口（9222）到主机，供外部工具连接
- `--rm`：容器停止后自动清理文件系统
- `--name headless-shell`：指定容器名称，便于管理
- `--shm-size`：设置共享内存大小，解决内存不足导致的崩溃问题（建议2G及以上）


## 构建与打包

以下为手动构建和打包`chromedp/headless-shell` Docker镜像的说明。


### 环境准备与构建

如需本地手动构建镜像，需先从Chromium源码手动构建`headless-shell`，因此需准备：
- Chromium的`depot_tools`工具集
- 完整的构建环境
- Chromium源码树及其依赖的完整检出

#### 构建依赖文档

请参考以下文档完成Linux环境下的Chromium和`headless-shell`构建准备：
- [Linux环境下检出与构建Chromium][building-linux]
- [构建无头Chromium（Headless Chromium）][building-headless]

> **注意**：在继续之前，请确保已完成上述步骤，至少成功手动构建一次`headless-shell`，且Chromium源码树为最新状态。


### 手动构建步骤

成功从Chromium源码构建`headless-shell`后，可通过以下脚本完成Docker镜像构建：

```bash
# 构建headless-shell（指定Chromium源码路径和版本号）
./build-headless-shell.sh /path/to/chromium/src 74.0.3717.1

# 构建Docker镜像（使用$PWD/out/headless-shell-$VER.tar.bz2作为源文件）
./docker-build.sh 74.0.3717.1
```


## Docker Compose配置示例

```yaml
version: '3.8'
services:
  headless-shell:
    image: chromedp/headless-shell:latest
    container_name: headless-shell
    ports:
      - "9222:9222"
    shm_size: "2G"  # 解决共享内存不足问题
    restart: unless-stopped  # 可选：异常退出后自动重启
```


[headless-shell]: https://github.com/chromedp/docker-headless-shell
[docker-headless-shell]: https://hub.docker.com/r/chromedp/headless-shell/
[devtools-protocol]: https://chromedevtools.github.io/devtools-protocol/
[chromedp]: https://github.com/chromedp/chromedp
[building-linux]: https://chromium.googlesource.com/chromium/src/+/master/docs/linux_build_instructions.md
[building-headless]: https://chromium.googlesource.com/chromium/src/+/master/headless/README.md
