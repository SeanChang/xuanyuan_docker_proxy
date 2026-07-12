---
image: kicbase/stable
description: "minikube备用镜像是用于在本地运行Kubernetes的轻量级工具minikube的备用镜像资源，当主镜像无法访问或出现故障时，这些备用镜像可确保minikube能够正常启动和运行，保障本地Kubernetes环境的稳定性与可用性，该备用镜像资源由GitHub上的kubernetes/minikube项目（仓库地址：github.com/kubernetes/minikube）进行统一管理和维护。"
source: https://xuanyuan.cloud/zh/r/kicbase/stable
canonical: https://xuanyuan.cloud/zh/r/kicbase/stable
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kicbase/stable" title="kicbase/stable Docker 镜像中文简介、标签列表与拉取命令">kicbase/stable 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

### minikube备用镜像说明  

minikube备用镜像是minikube工具的配套资源，用于在默认镜像拉取失败时作为替代方案，确保minikube本地Kubernetes环境能正常启动和运行。  


#### 主要作用  
当用户启动minikube时，若因网络问题或镜像仓库访问限制导致默认镜像（如Kubernetes组件镜像、基础系统镜像等）拉取失败，minikube会自动尝试使用备用镜像，避免环境部署中断，保障本地K8s集群顺利启动。  


#### 管理与维护  
备用镜像由minikube官方项目（github.com/kubernetes/minikube）统一管理。项目会根据minikube版本更新，同步维护备用镜像的版本和内容，确保与minikube功能适配。  


#### 获取与使用  
用户可通过访问minikube的GitHub仓库，在项目文档或资源目录中查看备用镜像的具体列表、版本信息及配置方法。若需手动指定备用镜像源，可参考minikube启动参数说明（如`--image-mirror-country`或`--registry-mirror`），结合实际网络环境调整配置，确保备用镜像可正常拉取。
