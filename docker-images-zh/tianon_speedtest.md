---
image: tianon/speedtest
description: "SPEEDTEST.NET是全球领先的专业网络速度测试平台，提供全面的网络性能评估服务，涵盖下载速度、上传速度、网络延迟、连接稳定性等核心指标，支持电脑、手机、平板等多种设备及宽带、5G、Wi-Fi等各类网络类型的实时测试，帮助用户精准掌握网络状况、诊断网络问题、优化网络体验，是全球用户广泛信赖的网络性能检测工具。"
source: https://xuanyuan.cloud/zh/r/tianon/speedtest
canonical: https://xuanyuan.cloud/zh/r/tianon/speedtest
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [tianon/speedtest — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/tianon/speedtest)

含镜像标签、拉取命令、部署文档与相关推荐。

[tianon/speedtest Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/tianon/speedtest)

## 服务器测速工具：轻松访问speedtest.net

### 适用场景
如果你需要测试服务器的网络速度，但不想费劲配置复杂的隧道技术来访问speedtest.net，这个工具能帮你快速解决问题。


### 使用方法
直接运行以下Docker命令即可启动测速：
```bash
docker run -it --rm --net=host tianon/speedtest
```


### 参数说明
关于命令中的`--net=host`参数：  
它并非强制选项，但在以下情况建议添加：  
- 你需要测试服务器的原生网络性能（避免Docker网络模式带来的额外开销）；  
- 你需要指定特定的主机IP（例如使用`--ip 目标IP`参数）或特定网络接口（例如使用`--interface 接口名`参数）。  
添加后，工具会直接使用主机的网络连接，确保测试结果更贴近实际，同时支持直接调用主机的网络接口和IP。
