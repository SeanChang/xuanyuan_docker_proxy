<!-- xuanyuan-docker-images-zh
image: openeuler/open-webui
source: https://xuanyuan.cloud/zh/r/openeuler/open-webui
canonical: https://xuanyuan.cloud/zh/r/openeuler/open-webui
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/openeuler/open-webui" title="openeuler/open-webui Docker 镜像中文简介、标签列表与拉取命令">openeuler/open-webui — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/openeuler/open-webui" title="openeuler/open-webui Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/open-webui</a></p>

# 快速参考

- open-webui的官方Docker镜像。

- 维护者：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)。

- 获取帮助：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)、[openEuler](https://gitee.com/openeuler/community)。

# open-webui | openEuler
当前open-webui Docker镜像基于[openEuler](https://repo.openeuler.org/)构建。本仓库可免费使用，且无每用户速率限制。

# 支持的标签及对应Dockerfile链接
每个`open-webui` Docker镜像的标签由完整的软件栈版本组成。详情如下：
| 标签 | 当前版本 | 架构 |
|------|----------|------|
|[0.1.108-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/open-webui/0.1.108/22.03-lts-sp4/Dockerfile)| open-webui 0.1.108 基于 openEuler 22.03-LTS-SP4 | amd64、arm64 |
|[0.1.108-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/open-webui/0.1.108/24.03-lts-sp1/Dockerfile)| open-webui 0.1.108 基于 openEuler 24.03-LTS-SP1 | amd64、arm64 |

# 使用方法
在使用时，用户可根据需求选择相应的`{Tag}`和容器启动选项。

- 从Docker拉取`openeuler/open-webui`镜像

  ```bash
  docker pull openeuler/open-webui:{Tag}
  ```

- 启动open-webui实例

  ```bash
  docker run \
      --name my-open-webui \
      -p 8080:8080 \
      -itd openeuler/open-webui:{Tag}
  ```

- 容器启动选项

  | 选项 | 描述 |
  |------|------|
  | `--name my-open-webui` | 为容器命名为`my-open-webui`。 |
  | `-p 8080:8080` | 将主机的8080端口映射到容器的8080端口，8080是open-webui的Web服务端口。 |
  | `-itd` | 以交互模式后台启动容器。 |
  | `openeuler/open-webui:{Tag}` | 指定要运行的Docker镜像，将`{Tag}`替换为所需的`openeuler/open-webui`镜像的具体版本或标签。 |

- 查看容器运行日志

  ```bash
  docker logs -f my-open-webui
  ```

- 获取交互式shell

  ```bash
  docker exec -it my-open-webui /bin/bash
  ```

# 问题与反馈
如有任何问题或需要使用某些特殊功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/openeuler/open-webui" title="openeuler/open-webui Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/openeuler/open-webui</a></p>
