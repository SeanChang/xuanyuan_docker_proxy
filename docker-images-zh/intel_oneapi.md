---
image: intel/oneapi
description: "Intel® oneAPI工具包：一套统一的、基于标准的编程工具，支持跨CPU、GPU、AI、FPGA等架构部署应用，包含运行时库和工具包，简化开发流程。"
source: https://xuanyuan.cloud/zh/r/intel/oneapi
canonical: https://xuanyuan.cloud/zh/r/intel/oneapi
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/oneapi" title="intel/oneapi Docker 镜像中文简介、标签列表与拉取命令">intel/oneapi 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Intel® oneAPI工具包

## 概述
现代工作负载的多样性要求架构多样性；没有单一架构适用于所有工作负载。需在CPU、GPU、AI、FPGA及其他加速器中部署标量、向量、矩阵和空间（SVMS）混合架构，以实现高性能。

Intel oneAPI产品提供跨SVMS架构部署应用和解决方案的工具，包括运行时库及互补工具包（基础工具包与专业附加组件），可简化编程流程，提升开发效率与创新能力。[oneAPI工具包详情](https://software.intel.com/oneapi)

## 容器镜像
[oneAPI容器快速入门指南](https://www.intel.com/content/www/us/en/docs/oneapi-base-toolkit/get-started-guide-linux/2025-2/using-containers.html)

- [Intel® oneAPI基础工具包](https://hub.docker.com/r/intel/oneapi-basekit)
- [Intel® oneAPI HPC工具包](https://hub.docker.com/r/intel/oneapi-hpckit)
- [Intel® oneAPI IoT工具包](https://hub.docker.com/r/intel/oneapi-iotkit) **已弃用，建议使用[Intel® HPC工具包](https://hub.docker.com/r/intel/oneapi-hpckit)替代**
- [Intel® oneAPI深度学习框架开发者工具包](https://hub.docker.com/r/intel/oneapi-dlfdkit) **已弃用，建议使用[Intel® oneAPI基础工具包](https://hub.docker.com/r/intel/oneapi-basekit)替代**
- [Intel® AI Analytics工具包](https://hub.docker.com/r/intel/oneapi-aikit) **已弃用，建议使用[AI工具选择器](https://www.intel.com/content/www/us/en/developer/tools/oneapi/ai-tools-selector.html)替代**
- [Intel® oneAPI运行时库](https://hub.docker.com/r/intel/oneapi-runtime)
- [Intel® VTune™ Profiler](https://hub.docker.com/r/intel/oneapi-vtune)

## Docker部署示例
### 拉取基础工具包镜像
```bash
docker pull docker.xuanyuan.run/intel/oneapi-basekit
```

### 运行容器
```bash
docker run -it --rm docker.xuanyuan.run/intel/oneapi-basekit bash
```

## 相关资源
- Dockerfiles: [https://github.com/intel/oneapi-containers](https://github.com/intel/oneapi-containers)
- Singularity容器: [https://github.com/intel/oneapi-containers/tree/master/images/singularity](https://github.com/intel/oneapi-containers/tree/master/images/singularity)

## 许可协议
下载并使用此容器及包含的软件，即表示您同意[软件许可协议](https://github.com/intel/oneapi-containers/tree/master/licensing)的条款和条件。

[容器源代码](https://iotdk.intel.com/oneapi-container-sources)
