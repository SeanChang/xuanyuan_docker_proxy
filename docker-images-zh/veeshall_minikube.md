<!-- xuanyuan-docker-images-zh
image: veeshall/minikube
source: https://xuanyuan.cloud/zh/r/veeshall/minikube
canonical: https://xuanyuan.cloud/zh/r/veeshall/minikube
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [veeshall/minikube — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/veeshall/minikube "veeshall/minikube Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/veeshall/minikube

# 镜像概述

该Docker镜像基于Ubuntu 16.04构建，集成了Kubernetes本地开发测试所需的核心工具，包括kubectl v1.7.5和minikube v0.22.1，并预装vim、curl、sudo等基础系统工具。镜像创建专用用户`mkuser`并配置无密码sudo权限，默认以交互式bash shell启动，为本地Kubernetes环境搭建和操作提供基础运行环境。

# 核心功能与特性

## 基础系统与预装工具
- **基础镜像**：Ubuntu 16.04
- **系统工具**：vim（文本编辑器）、curl（网络请求工具）、sudo（权限管理工具）

## Kubernetes工具
- **kubectl**：版本v1.7.5，Kubernetes命令行管理工具，已配置bash自动补全（通过`source <(kubectl completion bash)`）
- **minikube**：版本v0.22.1，本地单节点Kubernetes集群管理工具

## 用户与权限配置
- 创建专用用户`mkuser`，默认shell为bash
- 配置`mkuser`无密码sudo权限（`mkuser ALL=(ALL) NOPASSWD:ALL`）
- 工作目录设置为`/opt/roadtrip/minikube`

# 使用场景与适用范围

- **本地Kubernetes学习环境**：适合初学者搭建基础Kubernetes测试环境，学习kubectl命令和minikube操作
- **基础开发测试**：作为本地Kubernetes应用开发的基础容器环境，进行简单的集群操作和配置测试
- **工具兼容性验证**：验证基于kubectl v1.7.5和minikube v0.22.1的脚本或应用兼容性

# 使用方法与配置说明

## 基本运行命令

通过以下命令启动容器并进入交互式bash环境：

```bash
docker run -it --name minikube-env <镜像名称或ID>
```

> 注意：minikube运行可能需要宿主机虚拟化支持，若在容器内启动minikube，建议添加`--privileged`参数以获取足够权限：
> ```bash
> docker run -it --privileged --name minikube-env <镜像名称或ID>
> ```

## 容器内操作示例

1. **验证工具版本**：
   ```bash
   # 查看kubectl版本
   kubectl version --client
   
   # 查看minikube版本
   minikube version
   ```

2. **启动minikube（示例）**：
   ```bash
   # 启动minikube（可能需要根据宿主机环境调整驱动，如--driver=docker）
   minikube start --kubernetes-version v1.7.5
   ```

3. **使用kubectl操作集群**：
   ```bash
   # 查看集群节点
   kubectl get nodes
   
   # 查看命名空间
   kubectl get namespaces
   ```

4. **切换用户与权限**：
   容器默认以`mkuser`身份运行，可通过`sudo -i`切换至root用户（无需密码）。

## 环境配置说明

- **kubectl自动补全**：容器已预配置`~/.bashrc`，包含`source <(kubectl completion bash)`，启动bash后自动生效，可通过`kubectl <Tab>`触发补全。
- **工作目录**：默认工作目录为`/opt/roadtrip/minikube`，工具安装路径：
  - kubectl：`/usr/local/bin/kubectl`
  - minikube：`/usr/local/bin/minikube`

# 注意事项

1. **minikube运行依赖**：minikube需要宿主机提供虚拟化支持（如Docker、KVM等），容器内运行可能受限于Docker引擎配置，建议在支持嵌套虚拟化的环境中使用。
2. **工具版本兼容性**：预装的kubectl（v1.7.5）和minikube（v0.22.1）版本较旧，可能不支持最新Kubernetes特性，仅适用于历史版本兼容性测试。
3. **安全考虑**：镜像配置了`mkuser`无密码sudo权限，生产环境中应谨慎使用，建议仅用于开发测试场景。
