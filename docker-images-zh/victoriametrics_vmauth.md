---
image: victoriametrics/vmauth
description: "VictoriaMetrics的简单认证代理与路由器"
source: https://xuanyuan.cloud/zh/r/victoriametrics/vmauth
canonical: https://xuanyuan.cloud/zh/r/victoriametrics/vmauth
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/victoriametrics/vmauth" title="victoriametrics/vmauth Docker 镜像中文简介、标签列表与拉取命令">victoriametrics/vmauth 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<p align="center">
  <img src="https://victoriametrics.com/icons/apple-touch-icon.webp" width="150" alt="VictoriaMetrics logo"/>
</p>
<h1 align="center">VictoriaMetrics vmauth</h1>

[![加入我们的SLACK社区](https://img.shields.io/badge/Join%20our%20SLACK%20Community-621773?style=for-the-badge&logo=slack&logoColor=white)](https://inviter.co/victoriametrics/)
[![在GitHub上提交Bug](https://img.shields.io/badge/File%20a%20Bug%20on%20GitHub-E94600?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/issues)
[![源代码](https://img.shields.io/badge/Source%20Code-323232?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmauth)

---

# victoriametrics/vmauth

`vmauth` 是 VictoriaMetrics 的简单快速认证授权代理。它部署在 VictoriaMetrics 组件（单节点或集群）之前，通过要求传入请求提供有效凭据来保护这些组件，仅在验证成功后才将请求路由到正确的后端。

---

## 使用方法

使用本地配置文件运行vmauth实例：

```bash
docker run -d --name vmauth -p 8427:8427 \
  -v /path/to/auth.yml:/etc/auth.yml \
  docker.xuanyuan.run/victoriametrics/vmauth:latest \
  -auth.config=/etc/auth.yml
```
