---
image: chigusa/bililive-go
description: "这是一个针对GitHub项目github.com/hr3lxphr6j/bililive-go的Docker镜像，其中bililive-go是一款专注于B站直播的实用工具，通常具备直播录制、弹幕管理、直播状态监控等功能，该Docker镜像的作用是为用户提供便捷的部署与运行环境，有效简化安装配置流程，帮助开发者或普通用户快速启用bililive-go进行B站直播相关的操作与管理。"
source: https://xuanyuan.cloud/zh/r/chigusa/bililive-go
canonical: https://xuanyuan.cloud/zh/r/chigusa/bililive-go
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [chigusa/bililive-go — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/chigusa/bililive-go)

含镜像标签、拉取命令、部署文档与相关推荐。

[chigusa/bililive-go Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/chigusa/bililive-go)

# bililive-go


## 项目地址  
项目代码托管于 GitHub，可访问仓库获取更多信息：  
[hr3lxphr6j/bililive-go]([])  


## Docker 快速启动示例  
通过 Docker 可便捷部署 bililive-go，以下是基础运行命令：  

```bash
docker run --restart=always -v ~/Videos:/srv/bililive -p 8080:8080 -d 
```  


### 命令参数说明  
- `--restart=always`：容器意外退出后自动重启，保障服务持续可用。  
- `-v ~/Videos:/srv/bililive`：将本地目录（示例为 `~/Videos`）挂载到容器内的 `/srv/bililive` 路径，可根据实际需求替换本地目录（如 `-v /path/to/your/folder:/srv/bililive`）。  
- `-p 8080:8080`：端口映射，将容器的 8080 端口映射到主机的 8080 端口。若主机 8080 端口已被占用，可修改主机端口部分（如 `-p 8081:8080` 映射到主机 8081 端口）。  
- `-d`：后台运行容器，不阻塞当前终端。  
- ``：使用的 Docker 镜像名称。
