# Google Container Registry（gcr.io）镜像拉取与加速配置教程

Google Container Registry（gcr.io）镜像拉取教程：对比官方 docker pull 与轩辕专属加速域名写法，说明 google-containers 等命名空间规则，适合 GKE 与云原生组件在国内环境稳定拉取。

## 官方源拉取

```bash
docker pull gcr.io/google-containers/pause:3.9
```

## 轩辕专属域名拉取

> 将 xxx-gcr.xuanyuan.run 替换为你的 GCR 专属域名

```bash
docker pull xxx-gcr.xuanyuan.run/google-containers/pause:3.9
```

## registry-mirrors 配置了仍很慢？

`registry-mirrors` 仅对 docker.io 生效，拉取 gcr.io 镜像需使用专属域名前缀：

```bash
docker pull xxx-gcr.xuanyuan.run/google-containers/pause:3.9
```

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
