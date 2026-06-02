<!-- xuanyuan-docker-images-zh
image: rocm/pytorch
source: https://xuanyuan.cloud/zh/r/rocm/pytorch
canonical: https://xuanyuan.cloud/zh/r/rocm/pytorch
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [rocm/pytorch — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/rocm/pytorch "rocm/pytorch Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/rocm/pytorch

# ROCm后端PyTorch Docker镜像使用说明

本仓库提供基于ROCm后端的PyTorch版本Docker镜像。


## 1. 支持的GPU型号
仓库中的Docker镜像可在以下GPU型号上运行：
- gfx908（对应MI100）
- gfx90a（对应MI210/MI250/MI250x）
- gfx942（对应MI300A/MI300X/MI325）
- gfx950（对应MI350/MI355，自ROCm 7.0起支持）
- gfx1030（基于Navi21的SKU型号）
- gfx1100/gfx1101（基于Navi31的SKU型号）
- gfx1200/gfx1201（基于Navi44/Navi48的SKU型号，自ROCm 6.4.2起支持）


## 2. 配置Docker环境
如需配置支持ROCm的Docker环境，操作指引请参考：  
[ROCm Docker环境快速配置指南]([])


## 3. 运行rocm/pytorch Docker镜像

### 3.1 添加快捷命令别名
为简化拉取和运行PyTorch容器的命令，建议将以下别名添加到`.profile`或`.bashrc`文件中（添加后需通过`source ~/.bashrc`或重启终端生效）：
```bash
alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --shm-size 8G -v $HOME/dockerx:/dockerx -w /dockerx'
```

### 3.2 启动容器示例
运行最新版本的ROCm PyTorch容器，执行以下命令即可：
```bash
drun rocm/pytorch
```
或显式指定`latest`标签：
```bash
drun rocm/pytorch:latest
```
