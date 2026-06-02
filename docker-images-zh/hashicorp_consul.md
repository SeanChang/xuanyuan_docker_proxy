<!-- xuanyuan-docker-images-zh
image: hashicorp/consul
source: https://xuanyuan.cloud/zh/r/hashicorp/consul
canonical: https://xuanyuan.cloud/zh/r/hashicorp/consul
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/hashicorp/consul" title="hashicorp/consul Docker 镜像中文简介、标签列表与拉取命令">hashicorp/consul — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/hashicorp/consul" title="hashicorp/consul Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/hashicorp/consul</a></p>

# Consul 官方镜像构建说明

构建此镜像包含以下几个部分：

* 基础镜像与CA证书：基于Alpine基础镜像构建，并添加CA证书以访问HashiCorp发布服务器。这些证书保留在镜像中，以便容器能够使用Atlas功能。
* 基础工具集成：通过拉取docker-base的发布版本，集成HashiCorp官方构建的部分基础工具，包括dumb-init和gosu。更多详情参见https://github.com/hashicorp/docker-base。
* Consul构建与配置：最后获取特定版本的Consul构建，并根据Dockerfile完成其余Consul特定配置。

# 官方镜像弃用通知

Consul 1.16版本起，我们将停止在Dockerhub发布官方镜像，仅发布Verified Publisher镜像。使用Docker镜像的用户应从“hashicorp/consul”拉取镜像，而非“consul”。Verified Publisher镜像可访问https://hub.docker.com/r/hashicorp/consul。

## Docker部署方案示例

### 基本运行命令
```bash
docker run -d --name consul -p 8500:8500 hashicorp/consul agent -server -bootstrap -ui -client=0.0.0.0
```

### 服务注册示例
创建`service.json`文件：
```json
{
  "service": {
    "name": "web",
    "port": 80,
    "check": {
      "http": "http://localhost:80/health",
      "interval": "10s"
    }
  }
}
```
通过以下命令注册服务：
```bash
docker cp service.json consul:/consul/config/
docker restart consul
```

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/hashicorp/consul" title="hashicorp/consul Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/hashicorp/consul</a></p>
