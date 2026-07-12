---
image: ziggyds/iventoy
description: "这是适用于Unraid系统的Docker化版本iventoy，作为一款多系统启动工具，它支持通过网络部署多种操作系统镜像，实现快速启动与安装；Docker化设计使其能在Unraid平台上便捷部署、高效管理，有效隔离运行环境，无需复杂配置即可稳定运行，特别适合家庭服务器或小型IT环境中进行多系统测试、维护与批量部署使用。"
source: https://xuanyuan.cloud/zh/r/ziggyds/iventoy
canonical: https://xuanyuan.cloud/zh/r/ziggyds/iventoy
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/ziggyds/iventoy" title="ziggyds/iventoy Docker 镜像中文简介、标签列表与拉取命令">ziggyds/iventoy 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# iventoy Docker镜像


## 项目简介  
这是一个运行iventoy的Docker镜像，每日通过GitHub Actions工作流检查是否有新版本发布。  
项目地址：<[]>  


## Docker Compose配置  

### 运行要求  
- 不支持无根（rootless）Docker，容器必须以root用户运行。  


### 配置示例  
以下是Docker Compose配置文件示例：  
```yaml
---
version: '3.9'
services:
  iventoy:
    image: docker.xuanyuan.run/ziggyds/iventoy:latest
    container_name: iventoy
    restart: always
    privileged: true # 必须设为true
    ports:
      - 26000:26000
      - 16000:16000
      - 10809:10809
      - 67:67/udp
      - 69:69/udp
    volumes:
      - isos:/app/iso       # 存放ISO文件的卷
      - config:/app/data    # 存放配置数据的卷
      - /<path to logs>:/app/log  # 宿主机日志目录，需替换为实际路径
    environment:
      - AUTO_START_PXE=true # 可选，默认值为true

volumes:
  isos:
    external: true  # 需提前创建外部卷
  config:
    external: true  # 需提前创建外部卷
```  


## 注意事项  
- **端口说明**：无需暴露所有列出的端口，具体端口用途可参考iventoy官方文档：<[]>。  
- **卷配置**：`isos`和`config`卷需提前创建为外部卷（external: true），避免容器删除时数据丢失。
