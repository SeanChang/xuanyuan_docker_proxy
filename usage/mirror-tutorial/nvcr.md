# NVIDIA Container Registry（nvcr.io）镜像拉取与加速配置教程

NVIDIA NVCR（nvcr.io）镜像拉取教程：涵盖 PyTorch 等 AI 镜像的官方 pull 命令、轩辕 NVCR 专属域名替换方式，并说明 API Key 与企业授权等认证要求。

## 官方源拉取

> NVCR 私有镜像通常需要登录认证（API Key/企业授权）

```bash
docker pull nvcr.io/nvidia/pytorch:23.05-py3
```

## 轩辕专属域名拉取

> 将 xxx-nvcr.xuanyuan.run 替换为你的 NVCR 专属域名

```bash
docker pull xxx-nvcr.xuanyuan.run/nvidia/pytorch:23.05-py3
```

## 注意事项

- **认证说明**：私有镜像仍需登录认证；镜像加速不改变仓库权限控制逻辑。

## registry-mirrors 配置了仍很慢？

`registry-mirrors` 仅对 docker.io 生效，拉取 nvcr.io 镜像需使用专属域名前缀。

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
