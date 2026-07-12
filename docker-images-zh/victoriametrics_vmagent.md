---
image: victoriametrics/vmagent
description: "用于从各种来源收集指标、过滤并发送到VictoriaMetrics的代理"
source: https://xuanyuan.cloud/zh/r/victoriametrics/vmagent
canonical: https://xuanyuan.cloud/zh/r/victoriametrics/vmagent
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/victoriametrics/vmagent" title="victoriametrics/vmagent Docker 镜像中文简介、标签列表与拉取命令">victoriametrics/vmagent 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<p align="center">
  <img src="https://victoriametrics.com/icons/apple-touch-icon.webp" width="150" alt="VictoriaMetrics标志"/>
</p>
<h1 align="center">VictoriaMetrics vmagent</h1>

[![加入我们的SLACK社区](https://img.shields.io/badge/Join%20our%20SLACK%20Community-621773?style=for-the-badge&logo=slack&logoColor=white)](https://inviter.co/victoriametrics/)
[![在GitHub上提交Bug](https://img.shields.io/badge/File%20a%20Bug%20on%20GitHub-E94600?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/issues)
[![源代码](https://img.shields.io/badge/Source%20Code-323232?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VictoriaMetrics/VictoriaMetrics/)
</p>

---
[vmagent](https://docs.victoriametrics.com/vmagent/)是一款用于从各种来源收集指标的代理，支持[重新标记和过滤收集的指标](https://docs.victoriametrics.com/vmagent/#relabeling)，并可通过Prometheus `remote_write`协议或[VictoriaMetrics `remote_write`协议](https://docs.victoriametrics.com/vmagent/#victoriametrics-remote-write-protocol)将指标存储到[VictoriaMetrics](https://docs.victoriametrics.com/)或其他任何存储系统。

### Docker拉取命令

我们建议指定镜像的确切标签：
```
docker pull docker.xuanyuan.run/victoriametrics/vmagent:{TAG}
```
有关详细信息，请参见[快速开始](https://docs.victoriametrics.com/vmagent/#quick-start)。

### Docker部署示例

以下是使用`docker run`启动vmagent的基本示例，配置从文件收集指标并发送到VictoriaMetrics：
```
docker run -d --name vmagent \
  -v /path/to/prometheus.yml:/etc/vmagent/prometheus.yml \
  docker.xuanyuan.run/victoriametrics/vmagent:{TAG} \
  -promscrape.config=/etc/vmagent/prometheus.yml \
  -remoteWrite.url=http://victoriametrics:8428/api/v1/write
```
其中：
- `/path/to/prometheus.yml`为本地指标采集配置文件路径
- `{TAG}`替换为具体版本标签
- `-remoteWrite.url`指定VictoriaMetrics的写入地址

有关与VictoriaMetrics集成进行指标收集的完整示例，请参见[Docker Compose环境配置](https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/deployment/docker#docker-compose-environment-for-victoriametrics)。
