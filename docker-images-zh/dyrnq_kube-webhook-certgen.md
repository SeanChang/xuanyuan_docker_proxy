<!-- xuanyuan-docker-images-zh
image: dyrnq/kube-webhook-certgen
source: https://xuanyuan.cloud/zh/r/dyrnq/kube-webhook-certgen
canonical: https://xuanyuan.cloud/zh/r/dyrnq/kube-webhook-certgen
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [dyrnq/kube-webhook-certgen — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/dyrnq/kube-webhook-certgen "dyrnq/kube-webhook-certgen Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/dyrnq/kube-webhook-certgen

### k8s.gcr.io/ingress-nginx/kube-webhook-certgen 工具镜像介绍


#### 一、基本说明  
这是 ingress-nginx 项目提供的工具镜像，用于生成和管理 Kubernetes 集群中 ingress-nginx 控制器 webhook 服务所需的 TLS 证书。webhook 服务（如 admission webhook）需通过 TLS 加密通信，该工具可自动或手动生成证书，并以 Secret 形式注入集群，支撑 ingress-nginx 控制器的正常运行。


#### 二、主要功能  
1. **证书生成**  
   为 ingress-nginx 的 webhook 服务生成自签名 TLS 证书，支持指定服务域名、命名空间等参数。  
2. **证书更新**  
   支持证书过期前手动触发更新，或配合控制器实现自动轮换（需配置对应策略）。  
3. **证书注入**  
   将生成的证书（包含公钥、私钥）打包为 Kubernetes Secret，存储在指定命名空间，供控制器直接调用。  


#### 三、典型使用场景  
1. **首次部署 ingress-nginx**  
   部署控制器时，通过 Helm 或 YAML 配置自动触发该工具生成初始证书，避免手动配置证书的繁琐。  
2. **证书过期更新**  
   当现有 webhook 证书临近过期（默认有效期 365 天），手动执行更新命令替换旧证书。  
3. **webhook 服务变更**  
   若 webhook 服务的域名、端口或命名空间变更，需重新生成证书以匹配新配置。  


#### 四、操作步骤（以手动生成为例）  
##### 1. 拉取镜像  
需根据 ingress-nginx 控制器版本选择对应工具版本（版本号需匹配，如控制器 v1.8.0 对应 certgen v1.8.0）：  
```bash
docker pull k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.8.0
```  
> 国内环境可替换镜像源（如 `registry.aliyuncs.com/google_containers/ingress-nginx/kube-webhook-certgen:v1.8.0`）。

##### 2. 生成证书  
执行以下命令生成证书，参数说明：  
- `--host`：webhook 服务的域名（通常为 `<service-name>,<service-name>.<namespace>.svc`）  
- `--namespace`：证书 Secret 所在命名空间（建议与控制器同命名空间，如 `ingress-nginx`）  
- `--secret-name`：生成的 Secret 名称（默认 `ingress-nginx-admission`）  

```bash
docker run --rm k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.8.0 \
  create \
  --host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.ingress-nginx.svc \
  --namespace=ingress-nginx \
  --secret-name=ingress-nginx-admission
```  

##### 3. 验证证书  
生成后查看 Secret 是否存在：  
```bash
kubectl get secret ingress-nginx-admission -n ingress-nginx
```  
输出应包含 `tls.crt`（公钥）和 `tls.key`（私钥）字段。  

##### 4. 证书更新（如需）  
将命令中的 `create` 替换为 `renew`，其他参数不变，即可更新证书：  
```bash
docker run --rm k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.8.0 \
  renew \
  --host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.ingress-nginx.svc \
  --namespace=ingress-nginx \
  --secret-name=ingress-nginx-admission
```  


#### 五、注意事项  
1. **版本匹配**：工具版本必须与 ingress-nginx 控制器版本一致，否则可能导致证书不兼容（如控制器 v1.8.0 需搭配 certgen v1.8.0）。  
2. **权限要求**：执行生成/更新命令的账号需有目标命名空间的 Secret 创建权限。  
3. **生产环境建议**：自签名证书仅适用于测试环境，生产环境需使用外部 CA 签发的证书，并关闭工具的自动生成功能。  
4. **镜像拉取**：k8s.gcr.io 镜像源国内访问受限，建议提前配置镜像代理或使用第三方镜像源（如阿里云、Docker Hub 镜像）。
