---
image: kubegreen/kube-green
description: "官方kube-green控制器镜像"
source: https://xuanyuan.cloud/zh/r/kubegreen/kube-green
canonical: https://xuanyuan.cloud/zh/r/kubegreen/kube-green
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/kubegreen/kube-green" title="kubegreen/kube-green Docker 镜像中文简介、标签列表与拉取命令">kubegreen/kube-green — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/kubegreen/kube-green" title="kubegreen/kube-green Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/kubegreen/kube-green</a>

# kube-green

## 项目介绍

有多少开发/预览环境的Pod在周末或夜间仍在运行？这无疑是对资源和资金的浪费！别担心，kube-green正是为此而生。

kube-green是一个简单的**Kubernetes插件**，能够在您不需要资源时自动**关闭（部分）资源**，从而节省资源和成本。

如果您正在使用kube-green，欢迎将您的组织添加为[采用者][add-adopters]！

## 部署

### Docker镜像部署

kube-green控制器可通过Docker镜像部署在Kubernetes集群中。以下是使用Docker镜像在K8s集群中部署kube-green控制器的示例：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kube-green-controller
  namespace: kube-green
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kube-green
  template:
    metadata:
      labels:
        app: kube-green
    spec:
      serviceAccountName: kube-green-controller
      containers:
      - name: kube-green
        image: kube-green/kube-green:latest  # 替换为具体版本标签
        args:
        - --metrics-addr=:8080
        - --enable-leader-election
        resources:
          limits:
            cpu: 100m
            memory: 128Mi
          requests:
            cpu: 10m
            memory: 64Mi
```

> 注：完整部署需包含RBAC权限配置（ServiceAccount、ClusterRole、ClusterRoleBinding），详情请参考[官方安装文档](https://kube-green.dev/docs/install/)。

### 开发环境部署

如需本地开发，可使用[ko](https://ko.build/)部署到KinD集群：
1. 创建KinD集群：`kind create cluster --name kube-green-development`
2. 部署kube-green：`make local-run clusterName=kube-green-development`

## 使用方法

安装后，通过配置CRD（CustomResourceDefinition）`SleepInfo`来定义资源休眠规则。

### CRD配置说明

`SleepInfo` CRD用于定义资源的休眠策略，主要字段说明：
- `weekdays`：指定星期几应用规则（如"1-5"表示周一至周五，"*"表示每天）
- `sleepAt`：休眠时间（如"20:00"）
- `wakeUpAt`：唤醒时间（如"08:00"，不指定则仅休眠不唤醒）
- `timeZone`：时区（如"Europe/Rome"）
- `suspendCronJobs`：是否暂停CronJob（true/false）
- `excludeRef`：排除的资源（如特定Deployment）

### CRD示例

#### 工作时间运行（欧洲/罗马时区）
仅在工作日运行Pod，暂停CronJob，排除名为`api-gateway`的Deployment：
```yaml
apiVersion: kube-green.com/v1alpha1
kind: SleepInfo
metadata:
  name: working-hours
spec:
  weekdays: "1-5"  # 周一至周五（1=周一，5=周五）
  sleepAt: "20:00"  # 20:00休眠
  wakeUpAt: "08:00"  # 08:00唤醒
  timeZone: "Europe/Rome"  # 时区
  suspendCronJobs: true  # 暂停CronJob
  excludeRef:
    - apiVersion: "apps/v1"
      kind:       Deployment
      name:       api-gateway  # 排除此Deployment
```

#### 夜间休眠不唤醒
每天夜间休眠，不设置唤醒时间（需手动唤醒）：
```yaml
apiVersion: kube-green.com/v1alpha1
kind: SleepInfo
metadata:
  name: working-hours-no-wakeup
spec:
  sleepAt: "20:00"  # 20:00休眠
  timeZone: "Europe/Rome"  # 时区
  weekdays: "*"  # 每天应用
```

更多示例请参考[官方文档](https://kube-green.dev/docs/configuration/#examples)。

## 贡献

请阅读[CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426)了解代码规范和PR提交流程。

## 版本控制

采用[SemVer](http://semver.org/)语义化版本控制，版本列表见[GitHub Releases](https://github.com/kube-green/kube-green/releases)。

## 许可证

本项目基于MIT许可证，详情见[LICENSE](LICENSE)文件。

## 致谢

特别感谢[JGiola](https://github.com/JGiola)的技术评审。

## 采用者

查看[采用者列表](https://kube-green.dev/docs/adopters/)，如使用kube-green，欢迎[添加您的组织][add-adopters]！

[add-adopters]: https://github.com/kube-green/kube-green.github.io/blob/main/CONTRIBUTING.md#add-your-organization-to-adopters
