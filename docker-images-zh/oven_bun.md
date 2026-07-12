---
image: oven/bun
description: "Bun是一款快速的一体化JavaScript运行时，它原生支持TypeScript、JSX等语法，集成了打包器、测试运行器等开发工具，为开发者提供从代码编写到应用部署的全流程解决方案，相比Node.js等传统运行时，Bun凭借更快的启动速度和更高的运行性能，有效提升开发效率与应用执行效率，是现代JavaScript项目高效开发与运行的得力工具。"
source: https://xuanyuan.cloud/zh/r/oven/bun
canonical: https://xuanyuan.cloud/zh/r/oven/bun
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/oven/bun" title="oven/bun Docker 镜像中文简介、标签列表与拉取命令">oven/bun 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Bun

Bun 是一款快速的全功能 JavaScript 运行时。官网：[] Dockerfile 示例

以下是使用 Bun 官方镜像构建应用的示例 Dockerfile：

```dockerfile
FROM docker.xuanyuan.run/oven/bun:latest

COPY package.json ./
COPY bun.lockb ./
COPY src ./

RUN bun install
```


## 镜像变体

Bun 官方镜像提供以下变体版本，可根据需求选择：

- `debian`  
- `slim`  
- `alpine`  
- `distroless`
