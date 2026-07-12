# GitHub Container Registry（ghcr.io）镜像拉取与加速配置教程

GitHub Container Registry（ghcr.io）拉取教程：给出 org/image 官方命令与轩辕 GHCR 专属域名替换示例，适合 CI 构建、开源项目镜像在国内网络下的加速部署。

## 官方源拉取

```bash
docker pull ghcr.io/org/image:tag
```

## 轩辕专属域名拉取

> 将 xxx-ghcr.xuanyuan.run 替换为你的 GHCR 专属域名

```bash
docker pull xxx-ghcr.xuanyuan.run/org/image:tag
```

## registry-mirrors 配置了仍很慢？

`registry-mirrors` 仅对 docker.io 生效，拉取 ghcr.io 镜像需使用专属域名前缀：

```bash
# 官方源（慢）
docker pull ghcr.io/astral-sh/uv:0.9.26

# 轩辕加速
docker pull xxx-ghcr.xuanyuan.run/astral-sh/uv:0.9.26
```

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
