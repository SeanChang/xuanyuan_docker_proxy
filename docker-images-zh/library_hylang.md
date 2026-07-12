---
image: library/hylang
description: "Hy是一种Lisp方言，可将表达式转换为Python的抽象语法树(AST)，实现与Python的互操作性，允许导入和使用Python库。"
source: https://xuanyuan.cloud/zh/r/library/hylang
canonical: https://xuanyuan.cloud/zh/r/library/hylang
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/hylang" title="library/hylang Docker 镜像中文简介、标签列表与拉取命令">library/hylang 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Hy Docker镜像文档

## 快速参考

- **维护者**:  
  [Paul Tagliamonte, Hy BDFL](https://github.com/hylang/hy)

- **获取帮助**:  
  [Docker社区Slack](https://dockr.ly/comm-slack)、[Server Fault](https://serverfault.com/help/on-topic)、[Unix & Linux](https://unix.stackexchange.com/help/on-topic) 或 [Stack Overflow](https://stackoverflow.com/help/on-topic)

## 支持的标签及对应`Dockerfile`链接

（参见FAQ中的["'Shared'和'Simple'标签有何区别？"](https://github.com/docker-library/faq#whats-the-difference-between-shared-and-simple-tags)）

### Simple标签

- [`1.1.0-python3.14-trixie`, `1.1-python3.14-trixie`, `1-python3.14-trixie`, `python3.14-trixie`, `1.1.0-trixie`, `1.1-trixie`, `1-trixie`, `trixie`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.14-trixie)

- [`1.1.0-python3.14-bookworm`, `1.1-python3.14-bookworm`, `1-python3.14-bookworm`, `python3.14-bookworm`, `1.1.0-bookworm`, `1.1-bookworm`, `1-bookworm`, `bookworm`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.14-bookworm)

- [`1.1.0-python3.14-alpine3.22`, `1.1-python3.14-alpine3.22`, `1-python3.14-alpine3.22`, `python3.14-alpine3.22`, `1.1.0-alpine3.22`, `1.1-alpine3.22`, `1-alpine3.22`, `alpine3.22`, `1.1.0-python3.14-alpine`, `1.1-python3.14-alpine`, `1-python3.14-alpine`, `python3.14-alpine`, `1.1.0-alpine`, `1.1-alpine`, `1-alpine`, `alpine`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.14-alpine3.22)

- [`1.1.0-python3.14-alpine3.21`, `1.1-python3.14-alpine3.21`, `1-python3.14-alpine3.21`, `python3.14-alpine3.21`, `1.1.0-alpine3.21`, `1.1-alpine3.21`, `1-alpine3.21`, `alpine3.21`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.14-alpine3.21)

- [`1.1.0-python3.14-windowsservercore-ltsc2025`, `1.1-python3.14-windowsservercore-ltsc2025`, `1-python3.14-windowsservercore-ltsc2025`, `python3.14-windowsservercore-ltsc2025`, `1.1.0-windowsservercore-ltsc2025`, `1.1-windowsservercore-ltsc2025`, `1-windowsservercore-ltsc2025`, `windowsservercore-ltsc2025`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.14-windowsservercore-ltsc2025)

- [`1.1.0-python3.14-windowsservercore-ltsc2022`, `1.1-python3.14-windowsservercore-ltsc2022`, `1-python3.14-windowsservercore-ltsc2022`, `python3.14-windowsservercore-ltsc2022`, `1.1.0-windowsservercore-ltsc2022`, `1.1-windowsservercore-ltsc2022`, `1-windowsservercore-ltsc2022`, `windowsservercore-ltsc2022`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.14-windowsservercore-ltsc2022)

- [`1.1.0-python3.13-trixie`, `1.1-python3.13-trixie`, `1-python3.13-trixie`, `python3.13-trixie`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.13-trixie)

- [`1.1.0-python3.13-bookworm`, `1.1-python3.13-bookworm`, `1-python3.13-bookworm`, `python3.13-bookworm`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.13-bookworm)

- [`1.1.0-python3.13-alpine3.22`, `1.1-python3.13-alpine3.22`, `1-python3.13-alpine3.22`, `python3.13-alpine3.22`, `1.1.0-python3.13-alpine`, `1.1-python3.13-alpine`, `1-python3.13-alpine`, `python3.13-alpine`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.13-alpine3.22)

- [`1.1.0-python3.13-alpine3.21`, `1.1-python3.13-alpine3.21`, `1-python3.13-alpine3.21`, `python3.13-alpine3.21`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.13-alpine3.21)

- [`1.1.0-python3.13-windowsservercore-ltsc2025`, `1.1-python3.13-windowsservercore-ltsc2025`, `1-python3.13-windowsservercore-ltsc2025`, `python3.13-windowsservercore-ltsc2025`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.13-windowsservercore-ltsc2025)

- [`1.1.0-python3.13-windowsservercore-ltsc2022`, `1.1-python3.13-windowsservercore-ltsc2022`, `1-python3.13-windowsservercore-ltsc2022`, `python3.13-windowsservercore-ltsc2022`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.13-windowsservercore-ltsc2022)

- [`1.1.0-python3.12-trixie`, `1.1-python3.12-trixie`, `1-python3.12-trixie`, `python3.12-trixie`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.12-trixie)

- [`1.1.0-python3.12-bookworm`, `1.1-python3.12-bookworm`, `1-python3.12-bookworm`, `python3.12-bookworm`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.12-bookworm)

- [`1.1.0-python3.12-alpine3.22`, `1.1-python3.12-alpine3.22`, `1-python3.12-alpine3.22`, `python3.12-alpine3.22`, `1.1.0-python3.12-alpine`, `1.1-python3.12-alpine`, `1-python3.12-alpine`, `python3.12-alpine`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.12-alpine3.22)

- [`1.1.0-python3.12-alpine3.21`, `1.1-python3.12-alpine3.21`, `1-python3.12-alpine3.21`, `python3.12-alpine3.21`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.12-alpine3.21)

- [`1.1.0-python3.11-trixie`, `1.1-python3.11-trixie`, `1-python3.11-trixie`, `python3.11-trixie`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.11-trixie)

- [`1.1.0-python3.11-bookworm`, `1.1-python3.11-bookworm`, `1-python3.11-bookworm`, `python3.11-bookworm`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.11-bookworm)

- [`1.1.0-python3.11-alpine3.22`, `1.1-python3.11-alpine3.22`, `1-python3.11-alpine3.22`, `python3.11-alpine3.22`, `1.1.0-python3.11-alpine`, `1.1-python3.11-alpine`, `1-python3.11-alpine`, `python3.11-alpine`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.11-alpine3.22)

- [`1.1.0-python3.11-alpine3.21`, `1.1-python3.11-alpine3.21`, `1-python3.11-alpine3.21`, `python3.11-alpine3.21`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.11-alpine3.21)

- [`1.1.0-python3.10-trixie`, `1.1-python3.10-trixie`, `1-python3.10-trixie`, `python3.10-trixie`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.10-trixie)

- [`1.1.0-python3.10-bookworm`, `1.1-python3.10-bookworm`, `1-python3.10-bookworm`, `python3.10-bookworm`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.10-bookworm)

- [`1.1.0-python3.10-alpine3.22`, `1.1-python3.10-alpine3.22`, `1-python3.10-alpine3.22`, `python3.10-alpine3.22`, `1.1.0-python3.10-alpine`, `1.1-python3.10-alpine`, `1-python3.10-alpine`, `python3.10-alpine`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.10-alpine3.22)

- [`1.1.0-python3.10-alpine3.21`, `1.1-python3.10-alpine3.21`, `1-python3.10-alpine3.21`, `python3.10-alpine3.21`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.10-alpine3.21)

- [`1.1.0-python3.9-trixie`, `1.1-python3.9-trixie`, `1-python3.9-trixie`, `python3.9-trixie`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.9-trixie)

- [`1.1.0-python3.9-bookworm`, `1.1-python3.9-bookworm`, `1-python3.9-bookworm`, `python3.9-bookworm`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile.python3.9-bookworm)

- [`1.1.0-python3.9-alpine3.22`, `1.1-python3.9-alpine3.22`, `1-python3.9-alpine3.22`, `python3.9-alpine3.22`, `1.1.0-python3.9-alpine`, `1.1-python3.9-alpine`, `1-python3.9-alpine`, `python3.9-alpine`](https://github.com/hylang/docker-hylang/blob/fed7ae62acf5651a05a296ab7396151e8182aa89/dockerfiles-generated/Dockerfile
