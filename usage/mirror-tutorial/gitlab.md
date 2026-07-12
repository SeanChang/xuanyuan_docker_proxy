# GitLab Container Registry（registry.gitlab.com）镜像拉取与加速配置教程

GitLab Container Registry 拉取教程：以 gitlab-org/gitlab-runner 为例说明官方 pull 命令、轩辕 GitLab 专属域名替换方式，并提示仅支持 SaaS 公共镜像。

## 官方源拉取

```bash
docker pull registry.gitlab.com/gitlab-org/gitlab-runner:latest
```

## 轩辕专属域名拉取

> 将 xxx-gitlab.xuanyuan.run 替换为你的 GitLab 专属域名

```bash
docker pull xxx-gitlab.xuanyuan.run/gitlab-org/gitlab-runner:latest
```

## 注意事项

- **范围说明**：仅支持 registry.gitlab.com（SaaS）；GitLab 私有项目镜像不支持通过专属域名拉取。

## registry-mirrors 配置了仍很慢？

`registry-mirrors` 仅对 docker.io 生效，拉取 registry.gitlab.com 镜像需使用专属域名前缀。

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
