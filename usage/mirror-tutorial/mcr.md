# Microsoft Container Registry（mcr.microsoft.com）镜像拉取与加速配置教程

Microsoft MCR（mcr.microsoft.com）镜像拉取教程：以 dotnet/runtime 等为例说明官方 pull 与轩辕 MCR 专属域名替换，适合 .NET 与 Azure 相关容器在国内 CI/CD 中加速拉取。

## 官方源拉取

```bash
docker pull mcr.microsoft.com/dotnet/runtime:8.0
```

## 轩辕专属域名拉取

> 将 xxx-mcr.xuanyuan.run 替换为你的 MCR 专属域名

```bash
docker pull xxx-mcr.xuanyuan.run/dotnet/runtime:8.0
```

## registry-mirrors 配置了仍很慢？

`registry-mirrors` 仅对 docker.io 生效，拉取 mcr.microsoft.com 镜像需使用专属域名前缀。

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
