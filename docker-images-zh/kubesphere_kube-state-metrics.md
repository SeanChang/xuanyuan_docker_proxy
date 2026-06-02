---
image: kubesphere/kube-state-metrics
description: "KubeSphere作为一款开源云原生容器平台，对Kubernetes生态中的状态指标工具kube-state-metrics进行了针对性修订，通过优化指标采集逻辑、扩展监控维度并提升数据处理效率，有效增强了对集群内Pod、Deployment、Service等核心资源状态指标的实时采集与精准分析能力，满足用户在容器化应用管理中对资源监控、故障排查及性能优化的精细化需求。"
source: https://xuanyuan.cloud/zh/r/kubesphere/kube-state-metrics
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[kubesphere/kube-state-metrics](https://xuanyuan.cloud/zh/r/kubesphere/kube-state-metrics)
> 含镜像标签、拉取命令、部署文档与相关推荐。

## KubeSphere优化版kube-state-metrics介绍


### 一、背景与优化必要性  
原生kube-state-metrics作为Kubernetes集群资源状态指标的核心采集工具，在企业级运维中存在一些实际痛点：指标覆盖不够全面（如缺乏自定义资源、存储/网络深度指标）、配置灵活性低（自定义指标需修改源码或复杂配置）、高负载场景下资源占用偏高。KubeSphere基于大量用户反馈，对其进行针对性改造，旨在提升监控能力、简化使用流程，同时保障性能稳定性。


### 二、主要改进内容  

#### 1. 扩展指标覆盖范围  
- **工作负载细节指标**：新增Deployment滚动更新进度（`deployment_rollout_progress`）、StatefulSet序号就绪状态（`statefulset_ordinal_ready`）等，解决原生版本中“只看副本数，不知更新是否卡住”的问题。  
- **存储与网络指标**：补充PV/PVC实际使用容量（`persistentvolumeclaim_usage_bytes`）、Service后端Endpoint健康比例（`service_endpoint_healthy_ratio`），覆盖存储资源耗尽预警、服务流量分发监控等场景。  
- **自定义资源（CRD）支持**：无需修改代码，通过配置文件即可声明CRD指标（如KubeSphere的`ClusterResourceQuota`、用户业务CRD），满足业务自定义监控需求。  


#### 2. 简化配置与自定义流程  
- **配置文件驱动指标规则**：通过`metrics-rules.yaml`定义需采集的资源类型、字段路径及指标名称，支持标签过滤（如仅采集`prod`命名空间资源）。例如：  
  ```yaml
  # 采集Namespace标签为env=prod的Deployment可用副本数
  workloads:
    - resource: deployments
      namespaces:
        matchLabels: env=prod
      metrics:
        - name: deployment_available_replicas
          field: status.availableReplicas
          type: Gauge
  ```  
- **KubeSphere控制台可视化配置**：在“集群设置-监控配置”页面直接编辑指标规则，自动生成配置文件并热加载，无需手动操作YAML。  


#### 3. 性能与资源优化  
- **增量采集机制**：原生版本通过定时全量拉取资源对象生成指标，优化版改为“对象变更时触发更新”，降低API Server请求压力（实测1000节点集群中，API请求量减少60%+）。  
- **内存占用优化**：通过指标缓存复用、非核心指标按需加载，同等规模集群下内存占用较原生版本降低约40%（原生2GB→优化后1.2GB）。  


#### 4. 兼容性与集成友好性  
- **完全兼容原生输出格式**：指标名称、标签规范与原生版本一致，可直接对接Prometheus、Grafana等现有监控栈，无需修改告警规则或仪表盘。  
- **适配多K8s版本**：支持Kubernetes 1.19~1.28，兼容最新资源特性（如EphemeralContainers、PodSecurityContext字段）。  


### 三、使用方法  

#### 1. 部署方式  
- **通过KubeSphere应用商店一键部署**（推荐）：  
  在控制台“应用市场”搜索“kube-state-metrics (KubeSphere优化版)”，选择版本后点击“部署”，自动关联集群监控组件（Prometheus、Alertmanager）。  
- **手动部署**：  
  从[KubeSphere GitHub仓库]([])下载部署文件，修改`ConfigMap`中的`metrics-rules.yaml`配置指标规则，执行：  
  ```bash
  kubectl apply -f deploy/
  ```  


#### 2. 自定义CRD指标示例  
以采集业务CRD `MyApp`（group: example.com, version: v1）的`status.readyReplicas`为例：  
1. 在`metrics-rules.yaml`中添加规则：  
   ```yaml
   customResources:
     - name: myapps
       group: example.com
       version: v1
       metrics:
         - name: myapp_ready_replicas
           help: "Number of ready replicas in MyApp"
           field: status.readyReplicas
           type: Gauge
           labels:  # 提取资源标签作为指标标签
             - key: app
               valueFrom: metadata.labels.app
   ```  
2. 重启Pod使配置生效：  
   ```bash
   kubectl rollout restart deployment kube-state-metrics -n kube-system
   ```  
3. 验证指标：  
   ```bash
   kubectl exec -it <pod-name> -n kube-system -- curl localhost:8080/metrics | grep myapp_ready_replicas
   ```  


#### 3. 监控集成与验证  
- **Prometheus对接**：优化版默认暴露`8080`端口，直接在Prometheus的`ServiceMonitor`中添加如下配置即可采集：  
  ```yaml
  apiVersion: monitoring.coreos.com/v1
  kind: ServiceMonitor
  metadata:
    name: kube-state-metrics
  spec:
    selector:
      matchLabels:
        app.kubernetes.io/name: kube-state-metrics
    endpoints:
      - port: http-metrics
  ```  
- **Grafana仪表盘**：可直接复用原生kube-state-metrics仪表盘（如Grafana ID 315），新增指标会自动显示。  


### 四、适用场景  
- **企业级集群精细化监控**：需跟踪工作负载更新状态、存储资源使用趋势的场景（如电商大促前的资源预警）。  
- **多集群统一监控**：通过标准化指标输出，配合KubeSphere Federation实现跨集群指标聚合（如“华北-华东集群资源使用率对比”）。  
- **业务自定义CRD监控**：用户有自研CRD（如`Order`、`Payment`），需采集其状态指标用于业务告警。  


### 五、注意事项  
- **版本兼容性**：需Kubernetes集群版本≥1.19，CRD API版本为`apiextensions.k8s.io/v1`（避免使用旧版`v1beta1`）。  
- **字段路径准确性**：配置CRD指标时，建议先用`kubectl get <crd-name> <instance> -o yaml`确认字段存在（如`status.readyReplicas`是否真实存在于CRD中）。  
- **高并发调优**：10万+ Pod集群建议调整启动参数：`--kube-api-qps=200 --kube-api-burst=400`（默认100/200），避免API限流。  


通过上述优化，KubeSphere版kube-state-metrics在保留原生工具核心能力的基础上，更贴合企业实际监控需求，降低了自定义指标门槛，同时保障了大规模集群下的性能稳定。
