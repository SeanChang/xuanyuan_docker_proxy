# Docker Hub（docker.io）镜像拉取与加速配置教程

Docker Hub（docker.io）最常用的官方镜像仓库拉取教程：给出 library/nginx 等官方命令、轩辕专属域名写法与 library/ 命名规则，适合新手与国内宽带环境快速验证加速效果。

## 官方源拉取

> 部分镜像可能无需 library/（取决于原始镜像名）

```bash
docker pull docker.io/library/nginx:latest
```

## 轩辕专属域名拉取

> 将 xxx.xuanyuan.run 替换为你的专属域名

```bash
docker pull xxx.xuanyuan.run/library/nginx:latest
```

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
