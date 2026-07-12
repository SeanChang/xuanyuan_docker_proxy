# Quay.io 镜像拉取与加速配置教程

Red Hat Quay.io 镜像拉取教程：以 coreos/etcd 等为例对比 quay.io 官方源与轩辕 Quay 专属域名写法，适合 OpenShift 生态与企业私有仓库前置缓存场景。

## 官方源拉取

```bash
docker pull quay.io/coreos/etcd:latest
```

## 轩辕专属域名拉取

> 将 xxx-quay.xuanyuan.run 替换为你的 Quay 专属域名

```bash
docker pull xxx-quay.xuanyuan.run/coreos/etcd:latest
```

## registry-mirrors 配置了仍很慢？

`registry-mirrors` 仅对 docker.io 生效，拉取 quay.io 镜像需使用专属域名前缀。

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
