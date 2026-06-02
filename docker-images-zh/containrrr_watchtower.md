<!-- xuanyuan-docker-images-zh
image: containrrr/watchtower
source: https://xuanyuan.cloud/zh/r/containrrr/watchtower
canonical: https://xuanyuan.cloud/zh/r/containrrr/watchtower
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/containrrr/watchtower" title="containrrr/watchtower Docker 镜像中文简介、标签列表与拉取命令">containrrr/watchtower — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/containrrr/watchtower" title="containrrr/watchtower Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/containrrr/watchtower</a></p>

# Watchtower

![Watchtower]([])


## 简介  
Watchtower 是一款用于自动化 Docker 容器基础镜像更新的工具。当你向 Docker Hub 或私有镜像仓库推送新版本镜像后，它会自动拉取最新镜像，优雅停止当前运行的容器，并使用原部署配置重启容器，全程无需手动干预。


## 注意事项  
⚠️ **需要帮助**  
目前项目仅由维护者 @simskij 独自维护，难以处理所有的 issues 和拉取请求。如果你有兴趣参与问题分类、故障排查或 issue 处理，欢迎通过 Gitter 联系！


## 快速开始  
直接运行以下命令启动 Watchtower 容器：  

```bash
docker run -d \
    --name watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower
```  

**说明**：  
- 命令通过挂载 `/var/run/docker.sock` 让 Watchtower 与 Docker 守护进程通信，从而监控和管理容器。  
- 启动后，它会定期检查所有运行中容器的基础镜像是否有更新，发现新版本时自动完成更新和重启。  


## 文档  
完整使用文档（含参数配置、私有仓库支持等）可访问：[[]]([])  


## 贡献者  
感谢所有为项目贡献代码、文档和反馈的开发者。本项目遵循 [all-contributors]([]) 规范，欢迎任何形式的贡献（代码优化、文档完善、测试用例等）！

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/containrrr/watchtower" title="containrrr/watchtower Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/containrrr/watchtower</a></p>
