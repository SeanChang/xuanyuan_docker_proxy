<!-- xuanyuan-docker-images-zh
image: oven/bun
source: https://xuanyuan.cloud/zh/r/oven/bun
canonical: https://xuanyuan.cloud/zh/r/oven/bun
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [oven/bun — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/oven/bun "oven/bun Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/oven/bun

# Bun

Bun 是一款快速的全功能 JavaScript 运行时。官网：[] Dockerfile 示例

以下是使用 Bun 官方镜像构建应用的示例 Dockerfile：

```dockerfile
FROM oven/bun:latest

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
