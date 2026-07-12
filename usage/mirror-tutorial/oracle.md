# Oracle Container Registry（container-registry.oracle.com）镜像拉取与加速配置教程

Oracle Container Registry 拉取教程：说明 database/enterprise 等镜像的官方 pull 命令、轩辕 Oracle 专属域名替换方式，并提示官网授权登录等前置要求。

## 官方源拉取

> Oracle 镜像通常需要先在官网完成授权/登录。

```bash
docker pull container-registry.oracle.com/database/enterprise:21.3.0
```

## 轩辕专属域名拉取

> 将 xxx-oracle.xuanyuan.run 替换为你的 Oracle 专属域名

```bash
docker pull xxx-oracle.xuanyuan.run/database/enterprise:21.3.0
```

## 注意事项

- **授权说明**：Oracle 镜像需先登录授权；加速不改变权限控制。

## registry-mirrors 配置了仍很慢？

`registry-mirrors` 仅对 docker.io 生效，拉取 Oracle 镜像需使用专属域名前缀。

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
