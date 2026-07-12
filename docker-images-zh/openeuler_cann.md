---
image: openeuler/cann
description: "Ascend CANN的官方容器镜像仓库，基于openEuler构建，提供面向AI的异构计算架构，通过分层API助力快速构建基于昇腾平台的AI应用和服务。"
source: https://xuanyuan.cloud/zh/r/openeuler/cann
canonical: https://xuanyuan.cloud/zh/r/openeuler/cann
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/openeuler/cann" title="openeuler/cann Docker 镜像中文简介、标签列表与拉取命令">openeuler/cann 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 快速参考

- 官方CANN Docker镜像。

- 维护者：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)。

- 获取帮助：[openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)、[openEuler](https://gitee.com/openeuler/community)。

# CANN | openEuler
当前CANN Docker镜像基于[openEuler](https://repo.openeuler.org/)构建。本仓库可免费使用，且不受每用户速率限制。

面向AI的异构计算架构提供分层API，帮助您基于昇腾平台快速构建AI应用和服务。

更多信息请参见[CANN文档](https://www.hiascend.com/en/document)。

# 支持的标签及对应Dockerfile链接
每个`cann` Docker镜像的标签由完整软件栈版本组成，详情如下：

| 标签                                                                                                                                                               | 当前版本说明                                                     | 架构          |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------|---------------|
| [7.0.RC1.alpha002-oe2203sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/7.0.RC1.alpha002/22.03-lts-sp2/Dockerfile)                   | CANN 7.0.RC1.alpha002 基于 openEuler 22.03-LTS-SP2             | arm64         |
| [8.0.RC1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/8.0.RC1/22.03-lts-sp4/Dockerfile)                                     | CANN 8.0.RC1（含Python 3.8）基于 openEuler 22.03-LTS-SP4       | arm64,amd64   |
| [8.1.RC1-python3.11-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/8.1.RC1-python3.11/22.03-lts/Dockerfile)                   | CANN 8.1.RC1（含Python 3.11）基于 openEuler 22.03-LTS          | arm64,amd64   |
| [8.1.RC1-python3.11-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/8.1.RC1-python3.11/24.03-lts/Dockerfile)                   | CANN 8.1.RC1（含Python 3.11）基于 openEuler 24.03-LTS          | arm64,amd64   |
| [8.2.RC1.alpha001-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/8.2.RC1.alpha001-python3.10/22.03-lts/Dockerfile) | CANN 8.2.RC1.alpha001（含Python 3.10）基于 openEuler 22.03-LTS | arm64,amd64   |
| [8.2.RC1.alpha002-python3.10-oe2203lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/cann/8.2.RC1.alpha002-python3.10/22.03-lts/Dockerfile) | CANN 8.2.RC1.alpha002（含Python 3.10）基于 openEuler 22.03-LTS | arm64,amd64   |

# 使用方法
用户可根据需求选择对应的`{Tag}`和容器启动选项。

- 从Docker拉取`openeuler/cann`镜像

  ```bash
  docker pull docker.xuanyuan.run/openeuler/cann:{Tag}
  ```

- 启动CANN实例

  ```bash
  docker run \
      --name my-cann \
      --device /dev/davinci1 \
      --device /dev/davinci_manager \
      --device /dev/devmm_svm \
      --device /dev/hisi_hdc \
      -v /usr/local/dcmi:/usr/local/dcmi \
      -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
      -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
      -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
      -v /etc/ascend_install.info:/etc/ascend_install.info \
      -it docker.xuanyuan.run/openeuler/cann:{Tag} bash
  ```

- 容器启动选项说明

  | 选项                                                                           | 描述                                                                                                |
  |--------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
  | `--name my-cann`                                                               | 为容器命名为`my-cann`。                                                                            |
  | `--device /dev/davinciX`                                                       | NPU设备，其中`X`为芯片物理ID号，例如davinci1。                                                      |
  | `--device /dev/davinci_manager`                                                | Davinci相关管理设备。                                                                               |
  | `--device /dev/devmm_svm`                                                      | 内存管理相关设备。                                                                                 |
  | `--device /dev/hisi_hdc`                                                       | HDC相关管理设备。                                                                                  |
  | `-v /usr/local/dcmi:/usr/local/dcmi`                                           | 将主机的DCMI .so及接口文件目录/usr/local/dcmi挂载到容器，需根据实际情况修改。                          |
  | `-v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi`                             | 将主机npu-smi工具"/usr/local/bin/npu-smi"挂载到容器，需根据实际情况修改。                              |
  | `-v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/`           | 将主机目录/usr/local/Ascend/driver/lib64/挂载到容器，需根据驱动.so文件实际路径修改。                    |
  | `-v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info` | 将主机版本信息文件/usr/local/Ascend/driver/version.info挂载到容器，需根据实际情况修改。                  |
  | `-v /etc/ascend_install.info:/etc/ascend_install.info`                         | 将主机安装信息文件/etc/ascend_install.info挂载到容器。                                               |
  | `-it`                                                                          | 以交互模式启动容器并分配终端（bash）。                                                               |
  | `openeuler/cann:{Tag}`                                                         | 指定要运行的Docker镜像，将`{Tag}`替换为所需`openeuler/cann`镜像的具体版本或标签。                       |

- 查看容器运行日志

  ```bash
  docker logs -f my-cann
  ```

- 获取交互式shell

  ```bash
  docker exec -it my-cann /bin/bash
  ```

# 问题与反馈
如有任何问题或需使用特定功能，请在[openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images)提交issue或pull request。
