# Elastic Registry（docker.elastic.co）镜像拉取与加速配置教程

Elastic 官方 docker.elastic.co 拉取教程：以 Elasticsearch 等组件为例对比官方 registry 与轩辕 Elastic 专属域名写法，适合 ELK 栈在国内环境的镜像加速与版本固定部署。

## 官方源拉取

```bash
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.13.4
```

## 轩辕专属域名拉取

> 将 xxx-elastic.xuanyuan.run 替换为你的 Elastic 专属域名

```bash
docker pull xxx-elastic.xuanyuan.run/elasticsearch/elasticsearch:8.13.4
```

## registry-mirrors 配置了仍很慢？

`registry-mirrors` 仅对 docker.io 生效，拉取 docker.elastic.co 镜像需使用专属域名前缀。

---

[← 返回多仓库教程总览](../mirror-tutorial-docker-guide.md)
