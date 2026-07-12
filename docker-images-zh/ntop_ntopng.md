---
image: ntop/ntopng
description: "高速网络流量分析与流采集系统（稳定版）是一款基于网络平台的工具，能够实时监测网络流量动态、深度分析流量数据特征，并高效完成流量信息的采集工作，适用于企业、机构等各类网络环境下的流量管理、数据监控及运维优化需求，确保网络数据处理的稳定性与高效性。"
source: https://xuanyuan.cloud/zh/r/ntop/ntopng
canonical: https://xuanyuan.cloud/zh/r/ntop/ntopng
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ntop/ntopng" title="ntop/ntopng Docker 镜像中文简介、标签列表与拉取命令">ntop/ntopng 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 安装与运行


## 镜像说明  
当前为 ntopng 稳定版镜像。如需 nightly 构建版本，请使用 `ntop/ntopng.dev` 镜像（[Docker Hub 地址] ）。


## 运行命令  
通过以下 Docker 命令启动 ntopng：  
```bash
docker run -it -p 3000:3000 -v $(pwd)/ntopng.license:/etc/ntopng.license:ro --net=host docker.xuanyuan.run/ntop/ntopng:latest -i eth0
```


## 参数说明  
- `-it`：以交互模式运行容器，便于查看实时输出。  
- `-p 3000:3000`：将容器的 3000 端口映射到主机 3000 端口，用于访问 Web 界面。  
- `-v $(pwd)/ntopng.license:/etc/ntopng.license:ro`：（非社区版需添加）将宿主机当前目录下的 `ntopng.license` 文件挂载到容器内，供 ntopng 识别许可证（`ro` 表示只读）。  
- `--net=host`：使用主机网络模式，确保容器能直接访问主机网卡。  
- `ntop/ntopng:latest`：指定使用最新版稳定镜像。  
- `-i eth0`：指定要捕获流量的网卡，**请将 `eth0` 替换为你的主机实际网卡名称**（如 `ens33`、`wlan0` 等）。  


## 访问 Web 界面  
启动容器后，通过浏览器访问 `[] 打开 ntopng 界面。默认登录信息：  
- 用户名：`admin`  
- 密码：`admin`  


## 许可证说明  
- **社区版**：无需挂载许可证文件，可直接运行上述命令（去掉 `-v` 挂载许可证的参数）。  
- **非社区版**：必须通过 `-v` 参数挂载许可证文件，否则容器内的 ntopng 无法识别许可证。  
更多许可证相关说明可参考 [官方文档] 。
