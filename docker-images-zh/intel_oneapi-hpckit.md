---
image: intel/oneapi-hpckit
description: "英特尔® oneAPI 高性能计算工具包是集成编译器、数学库及并行编程工具的开发套件，用于构建和优化跨架构高性能计算应用，具备针对Intel架构的深度优化能力。"
source: https://xuanyuan.cloud/zh/r/intel/oneapi-hpckit
canonical: https://xuanyuan.cloud/zh/r/intel/oneapi-hpckit
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/intel/oneapi-hpckit" title="intel/oneapi-hpckit Docker 镜像中文简介、标签列表与拉取命令">intel/oneapi-hpckit 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Intel® oneAPI HPC Toolkit Docker镜像文档


## 镜像概述和主要用途  
Intel® oneAPI HPC Toolkit Docker镜像是面向高性能计算（HPC）领域的容器化开发工具集，旨在为开发者提供构建、分析、优化和扩展HPC应用的一体化环境。该工具集集成了最新技术，支持向量化、多线程、多节点并行化及内存优化，帮助用户提升HPC应用的性能与可扩展性。


## 核心功能和特性  
- **向量化优化**：支持最新CPU指令集向量化，提升单核心计算效率；  
- **多线程技术**：提供多线程编程模型与优化工具，充分利用多核处理器资源；  
- **多节点并行化**：支持跨节点分布式计算，实现HPC应用的集群级扩展；  
- **内存优化**：集成内存访问模式分析与优化工具，减少内存瓶颈；  
- **全流程工具链**：包含编译、调试、性能分析一体化工具，简化HPC应用开发流程。  


## 使用场景和适用范围  
### 适用场景  
- HPC应用开发：科学计算、工程模拟、数据分析等领域的高性能应用开发；  
- 性能优化：针对现有HPC应用进行性能瓶颈分析与优化；  
- 多节点集群应用：开发需跨节点协同计算的大规模并行应用；  
- 学术研究与工业仿真：为科研机构和企业提供高效的HPC开发环境。  

### 适用用户  
HPC应用开发者、高性能计算工程师、科研人员及需要构建大规模并行应用的技术团队。  


## 使用方法和配置说明  

### 获取镜像  
通过Docker Hub或GitHub仓库获取官方镜像，命令示例：  
```bash
docker pull docker.xuanyuan.run/intel/oneapi-hpckit:devel-ubuntu24.04  # Ubuntu 24.04版本  
docker pull docker.xuanyuan.run/intel/oneapi-hpckit:devel-ubuntu22.04  # Ubuntu 22.04版本  
```

### 运行容器示例  
#### 基础交互式运行  
启动交互式容器，直接使用工具集：  
```bash
docker run -it --rm docker.xuanyuan.run/intel/oneapi-hpckit:devel-ubuntu24.04 bash
```  
- `-it`：启用交互式终端；  
- `--rm`：容器退出后自动删除，避免残留。  

#### 挂载本地项目目录  
将本地HPC项目目录挂载到容器中，便于开发调试：  
```bash
docker run -it --rm -v /本地项目路径:/workspace docker.xuanyuan.run/intel/oneapi-hpckit:devel-ubuntu24.04 bash
```  
- `-v /本地项目路径:/workspace`：将本地目录映射到容器内`/workspace`路径。  

### 可用镜像标签  
| 标签                  | 基础系统   | 说明                     |  
|-----------------------|------------|--------------------------|  
| `devel-ubuntu24.04`   | Ubuntu 24.04 | 基于Ubuntu 24.04的开发镜像 |  
| `devel-ubuntu22.04`   | Ubuntu 22.04 | 基于Ubuntu 22.04的开发镜像 |  


## Docker部署方案示例  

### docker run命令示例  
以下示例启动容器并挂载本地项目，同时设置工作目录：  
```bash
docker run -it --rm \  
  -v /home/user/hpc-project:/workspace \  
  -w /workspace \  
  docker.xuanyuan.run/intel/oneapi-hpckit:devel-ubuntu24.04 \
  bash -c "source /opt/intel/oneapi/setvars.sh && make"  
```  
- `-w /workspace`：设置容器内工作目录为`/workspace`；  
- `source /opt/intel/oneapi/setvars.sh`：激活oneAPI环境变量。  

### docker-compose配置示例  
创建`docker-compose.yml`文件，配置容器服务：  
```yaml
version: '3'  
services:  
  hpckit:  
    image: docker.xuanyuan.run/intel/oneapi-hpckit:devel-ubuntu24.04  
    volumes:  
      - ./hpc-project:/workspace  
    working_dir: /workspace  
    stdin_open: true  # 保持标准输入打开  
    tty: true         # 分配伪终端  
    command: bash -c "source /opt/intel/oneapi/setvars.sh && bash"  
```  
启动服务：  
```bash
docker-compose up -d  
docker-compose exec hpckit bash  # 进入运行中的容器  
```  


## 许可证协议  
用户下载并使用本容器及包含的软件，即表示同意[软件许可协议](https://github.com/intel/oneapi-containers/tree/master/licensing)的条款和条件。容器源代码可访问：[Container Sources](https://iotdk.intel.com/oneapi-container-sources)。  


## 注意事项  
- **CentOS 8容器支持终止**：基于CentOS 8的容器已弃用且不再支持，详情参见[CentOS Linux生命周期说明](https://www.centos.org/centos-linux-eol/)。  
- **Ubuntu容器用途限制**：所有Ubuntu容器镜像仅用于演示目的，不应用于生产环境。如需在生产环境中获得Canonical提供的Ubuntu基础层扩展安全维护，需参考[《如何在Dockerfile中启用Ubuntu Pro》](https://documentation.ubuntu.com/pro-client/en/docs/howtoguides/enable_in_dockerfile/)并重新构建镜像。  
- **官方文档参考**：更多使用细节可查阅[oneAPI HPC Toolkit容器入门指南](https://www.intel.com/content/www/us/en/docs/oneapi-hpc-toolkit/get-started-guide-linux/2025-2/using-containers.html)。
