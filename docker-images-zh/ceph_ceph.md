<!-- xuanyuan-docker-images-zh
image: ceph/ceph
source: https://xuanyuan.cloud/zh/r/ceph/ceph
canonical: https://xuanyuan.cloud/zh/r/ceph/ceph
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/ceph/ceph" title="ceph/ceph Docker 镜像中文简介、标签列表与拉取命令">ceph/ceph — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/ceph/ceph" title="ceph/ceph Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/ceph/ceph</a></p>

# ceph/ceph 镜像说明

自2021年8月起，新的容器镜像仅推送到quay.io registry，Docker Hub不再接收新内容，但现有镜像仍可正常使用。

## 镜像概述
本镜像包含所有Ceph二进制文件，以及NFS-Ganesha和iSCSI二进制文件，因为这些组件与Ceph版本紧密关联以确保兼容性。除非标签中另有说明，所有镜像均基于CentOS构建。新镜像会在Ceph新版本发布到官方包仓库后的24小时内完成构建。

## Docker部署方案示例
以下示例展示如何使用quay.io的ceph/ceph镜像启动一个Ceph Monitor守护进程：
```bash
docker run -d --name ceph-mon \
  --net=host \
  -v /etc/ceph:/etc/ceph \
  -v /var/lib/ceph:/var/lib/ceph \
  quay.io/ceph/ceph:v18.2.1-20240101 \
  ceph-mon --cluster ceph --id a --foreground
```
> 说明：`--net=host`用于使用主机网络，`-v`挂载Ceph配置和数据目录，`:v18.2.1-20240101`为具体镜像标签，可根据需求替换。

## 镜像标签解析

### 构建日期（Build date）
部分镜像标签后缀带有8位构建日期（格式为`YYYYMMDD`），用于标识镜像的构建日期，功能类似于常规软件包的构建编号。若已有镜像（如`v12.2.7-20181023`），当基础镜像（如CentOS）发生更新（如安全修复）时，会构建带有新构建日期的新版本。例如，若CentOS基础镜像在2080年2月10日更新，上述示例镜像将生成新标签`v12.2.7-20800210`。

### 版本选择（Versions）
可通过以下标签格式选择所需的Ceph版本：
- **完整语义化版本（带构建日期）**：如`v12.2.9-20181026`，适用于需要精确控制镜像升级的场景，推荐生产环境使用。
- **主版本**：如`v12`（对应Ceph Luminous版本），此类标签始终指向与标签匹配的最新Ceph主版本的最新构建。
- **次版本**：如`v12.1`，此类标签始终指向与标签匹配的最新Ceph次版本的最新构建，适用于需要比主版本更精确控制，但希望自动获取Ceph及基础镜像bug修复的环境。

## 镜像架构
本镜像为多架构清单（manifest list），会根据主机系统的架构自动拉取amd64或arm64架构的镜像。

## 镜像来源
镜像基于GitHub上的[ceph/ceph-container](https://github.com/ceph/ceph-container)项目构建，是专门构建的`daemon-base`镜像，使用特定的Ceph版本而非最新版本。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/ceph/ceph" title="ceph/ceph Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/ceph/ceph</a></p>
