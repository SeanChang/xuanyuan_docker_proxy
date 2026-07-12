# Kubernetes Registry（registry.k8s.io）镜像拉取与加速配置教程

Kubernetes 官方 registry.k8s.io 拉取教程：以 kube-apiserver 等组件为例，对比官方源与轩辕 K8s 专属域名命令，适合集群升级与离线节点镜像预热场景。

## 官方源拉取

```bash
docker pull registry.k8s.io/kube-apiserver:v1.30.1
```

## 轩辕专属域名拉取

> 将 xxx-k8s.xuanyuan.run 替换为你的 K8s 专属域名

```bash
docker pull xxx-k8s.xuanyuan.run/kube-apiserver:v1.30.1
```

## registry-mirrors 配置了仍很慢？

`registry-mirrors` 仅对 docker.io 生效，拉取 registry.k8s.io 镜像需使用专属域名前缀。

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
