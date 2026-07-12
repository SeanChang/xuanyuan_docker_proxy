---
image: library/haxe
description: "Haxe Docker镜像是包含Haxe编译器、haxelib库管理器和neko虚拟机的工具包，支持将静态类型的Haxe代码编译为JavaScript、Java、C#等多种目标平台，适用于跨平台开发。"
source: https://xuanyuan.cloud/zh/r/library/haxe
canonical: https://xuanyuan.cloud/zh/r/library/haxe
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/haxe" title="library/haxe Docker 镜像中文简介、标签列表与拉取命令">library/haxe 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Haxe Docker镜像文档

## 快速参考

- **维护者**：  
  [Haxe基金会](https://github.com/HaxeFoundation/docker-library-haxe)

- **获取帮助**：  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)


## 支持的标签及对应的`Dockerfile`链接

（参见FAQ中的“‘Shared’和‘Simple’标签有什么区别？”[https://github.com/docker-library/faq#whats-the-difference-between-shared-and-simple-tags](https://github.com/docker-library/faq#whats-the-difference-between-shared-and-simple-tags)）

### Simple Tags

- [`4.3.7-bookworm`, `4.3-bookworm`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.3/bookworm/Dockerfile)

- [`4.3.7-bullseye`, `4.3-bullseye`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.3/bullseye/Dockerfile)

- [`4.3.7-windowsservercore-ltsc2025`, `4.3-windowsservercore-ltsc2025`](https://github.com/HaxeFoundation/docker-library-haxe/blob/4e5b49d4004e4996d1d405de45967da6d36bdd94/4.3/windowsservercore-ltsc2025/Dockerfile)

- [`4.3.7-windowsservercore-ltsc2022`, `4.3-windowsservercore-ltsc2022`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.3/windowsservercore-ltsc2022/Dockerfile)

- [`4.3.7-alpine3.22`, `4.3-alpine3.22`, `4.3.7-alpine`, `4.3-alpine`](https://github.com/HaxeFoundation/docker-library-haxe/blob/29c1c10f60a3d5d96c92c23ed8d07f5393c962b5/4.3/alpine3.22/Dockerfile)

- [`4.3.7-alpine3.21`, `4.3-alpine3.21`](https://github.com/HaxeFoundation/docker-library-haxe/blob/29c1c10f60a3d5d96c92c23ed8d07f5393c962b5/4.3/alpine3.21/Dockerfile)

- [`4.3.7-alpine3.20`, `4.3-alpine3.20`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.3/alpine3.20/Dockerfile)

- [`4.3.7-alpine3.19`, `4.3-alpine3.19`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.3/alpine3.19/Dockerfile)

- [`5.0.0-preview.1-bookworm`, `5.0.0-bookworm`, `5.0-bookworm`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/5.0/bookworm/Dockerfile)

- [`5.0.0-preview.1-bullseye`, `5.0.0-bullseye`, `5.0-bullseye`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/5.0/bullseye/Dockerfile)

- [`5.0.0-preview.1-windowsservercore-ltsc2025`, `5.0.0-windowsservercore-ltsc2025`, `5.0-windowsservercore-ltsc2025`](https://github.com/HaxeFoundation/docker-library-haxe/blob/4e5b49d4004e4996d1d405de45967da6d36bdd94/5.0/windowsservercore-ltsc2025/Dockerfile)

- [`5.0.0-preview.1-windowsservercore-ltsc2022`, `5.0.0-windowsservercore-ltsc2022`, `5.0-windowsservercore-ltsc2022`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/5.0/windowsservercore-ltsc2022/Dockerfile)

- [`5.0.0-preview.1-alpine3.22`, `5.0.0-preview.1-alpine`, `5.0.0-alpine3.22`, `5.0-alpine3.22`, `5.0.0-alpine`, `5.0-alpine`](https://github.com/HaxeFoundation/docker-library-haxe/blob/29c1c10f60a3d5d96c92c23ed8d07f5393c962b5/5.0/alpine3.22/Dockerfile)

- [`5.0.0-preview.1-alpine3.21`, `5.0.0-alpine3.21`, `5.0-alpine3.21`](https://github.com/HaxeFoundation/docker-library-haxe/blob/29c1c10f60a3d5d96c92c23ed8d07f5393c962b5/5.0/alpine3.21/Dockerfile)

- [`5.0.0-preview.1-alpine3.20`, `5.0.0-alpine3.20`, `5.0-alpine3.20`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/5.0/alpine3.20/Dockerfile)

- [`5.0.0-preview.1-alpine3.19`, `5.0.0-alpine3.19`, `5.0-alpine3.19`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/5.0/alpine3.19/Dockerfile)

- [`4.2.5-bookworm`, `4.2-bookworm`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.2/bookworm/Dockerfile)

- [`4.2.5-bullseye`, `4.2-bullseye`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.2/bullseye/Dockerfile)

- [`4.2.5-windowsservercore-ltsc2025`, `4.2-windowsservercore-ltsc2025`](https://github.com/HaxeFoundation/docker-library-haxe/blob/4e5b49d4004e4996d1d405de45967da6d36bdd94/4.2/windowsservercore-ltsc2025/Dockerfile)

- [`4.2.5-windowsservercore-ltsc2022`, `4.2-windowsservercore-ltsc2022`](https://github.com/HaxeFoundation/docker-library-haxe/blob/c0367972017a7b87845bf33477e29b1fe64ccc4a/4.2/windowsservercore-ltsc2022/Dockerfile)

- [`4.2.5-alpine3.20`, `4.2-alpine3.20`, `4.2.5-alpine`, `4.2-alpine`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.2/alpine3.20/Dockerfile)

- [`4.2.5-alpine3.19`, `4.2-alpine3.19`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.2/alpine3.19/Dockerfile)

- [`4.1.5-bullseye`, `4.1-bullseye`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.1/bullseye/Dockerfile)

- [`4.1.5-windowsservercore-ltsc2025`, `4.1-windowsservercore-ltsc2025`](https://github.com/HaxeFoundation/docker-library-haxe/blob/4e5b49d4004e4996d1d405de45967da6d36bdd94/4.1/windowsservercore-ltsc2025/Dockerfile)

- [`4.1.5-windowsservercore-ltsc2022`, `4.1-windowsservercore-ltsc2022`](https://github.com/HaxeFoundation/docker-library-haxe/blob/c0367972017a7b87845bf33477e29b1fe64ccc4a/4.1/windowsservercore-ltsc2022/Dockerfile)

- [`4.1.5-alpine3.20`, `4.1-alpine3.20`, `4.1.5-alpine`, `4.1-alpine`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.1/alpine3.20/Dockerfile)

- [`4.1.5-alpine3.19`, `4.1-alpine3.19`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.1/alpine3.19/Dockerfile)

- [`4.0.5-bullseye`, `4.0-bullseye`](https://github.com/HaxeFoundation/docker-library-haxe/blob/２636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.0/bullseye/Dockerfile)

- [`4.0.5-windowsservercore-ltsc2025`, `4.0-windowsservercore-ltsc2025`](https://github.com/HaxeFoundation/docker-library-haxe/blob/4e5b49d4004e4996d1d405de45967da6d36bdd94/4.0/windowsservercore-ltsc2025/Dockerfile)

- [`4.0.5-windowsservercore-ltsc2022`, `4.0-windowsservercore-ltsc2022`](https://github.com/HaxeFoundation/docker-library-haxe/blob/c0367972017a7b87845bf33477e29b1fe64ccc4a/4.0/windowsservercore-ltsc2022/Dockerfile)

- [`4.0.5-alpine3.20`, `4.0-alpine3.20`, `4.0.5-alpine`, `4.0-alpine`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.0/alpine3.20/Dockerfile)

- [`4.0.5-alpine3.19`, `4.0-alpine3.19`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.0/alpine3.19/Dockerfile)

### Shared Tags

- `4.3.7`, `4.3`, `latest`:

  - [`4.3.7-bookworm`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.3/bookworm/Dockerfile)
  - [`4.3.7-windowsservercore-ltsc2025`](https://github.com/HaxeFoundation/docker-library-haxe/blob/4e5b49d4004e4996d1d405de45967da6d36bdd94/4.3/windowsservercore-ltsc2025/Dockerfile)
  - [`4.3.7-windowsservercore-ltsc2022`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.3/windowsservercore-ltsc2022/Dockerfile)

- `4.3.7-windowsservercore`, `4.3-windowsservercore`:

  - [`4.3.7-windowsservercore-ltsc2025`](https://github.com/HaxeFoundation/docker-library-haxe/blob/4e5b49d4004e4996d1d405de45967da6d36bdd94/4.3/windowsservercore-ltsc2025/Dockerfile)
  - [`4.3.7-windowsservercore-ltsc2022`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/4.3/windowsservercore-ltsc2022/Dockerfile)

- `5.0.0-preview.1`, `5.0.0`, `5.0`:

  - [`5.0.0-preview.1-bookworm`](https://github.com/HaxeFoundation/docker-library-haxe/blob/2636eee6b67d0c99730e4ab1d0d752d66809e3fa/5.0/bookworm/Dockerfile)
  - [`5.0.0-preview.1-windowsservercore-ltsc2025`](https://github.com/HaxeFoundation/docker-library-haxe/blob/4e5b49d4004e4996d1d405de45967da6d36bdd94/5.0/window
