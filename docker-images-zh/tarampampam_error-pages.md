---
image: tarampampam/error-pages
description: "Docker镜像，提供美观的服务器错误页面，包含多种主题模板，支持HTTP服务器、K8S集群等场景集成，轻量高效且可高度自定义。"
source: https://xuanyuan.cloud/zh/r/tarampampam/error-pages
canonical: https://xuanyuan.cloud/zh/r/tarampampam/error-pages
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/tarampampam/error-pages" title="tarampampam/error-pages Docker 镜像中文简介、标签列表与拉取命令">tarampampam/error-pages 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

## 镜像概述

该Docker镜像旨在替换HTTP服务器或K8S集群的标准错误页面，提供更具原创性和吸引力的替代方案。包含以下核心组件：Go语言编写的错误页面生成器、多种设计风格的单页错误模板（主题）、轻量级HTTP服务器（独立二进制文件或Docker镜像形式提供）以及预生成的错误页面资源。

## 核心功能与特性

### HTTP服务器特性
- 基于Go语言和FastHTTP构建，性能高效且内存占用低
- 支持根据`Content-Type`或`X-Format`请求头返回对应格式响应（支持`json`、`xml`、`plaintext`）
- 错误页面默认配置为排除搜索引擎索引（通过元标签和HTTP头），避免SEO问题
- HTML内容（含CSS、SVG、JS）实时压缩，减少传输体积
- JSON格式日志输出，便于日志分析
- 内置健康检查端点`/healthz`，支持服务状态监控
- 资源消耗极低，适用于资源受限环境

### 镜像与部署特性
- 轻量级Docker镜像，采用无发行版（distroless）基础镜像，默认使用非特权用户运行
- 支持Go模板标签，可自定义模板内容
- 无缝集成Traefik、Ingress-nginx等反向代理/Ingress控制器
- 可通过简单步骤嵌入到自定义Nginx Docker镜像中
- 全配置化支持，可通过命令行参数或环境变量调整行为
- 提供Docker镜像和预编译二进制文件两种分发形式
- 多语言本地化支持（包含中文、英文、法文、俄文等16种语言），支持翻译扩展

## 安装方式

### Docker镜像

| 镜像仓库                          | 镜像地址                             |
|-----------------------------------|-----------------------------------|
| GitHub Container Registry (GHCR) | `ghcr.io/tarampampam/error-pages` |
| Docker Hub（镜像）                | `tarampampam/error-pages`         |

> [!重要]
> 强烈不建议使用`latest`标签，因为主版本升级可能包含不兼容变更。请使用`X.Y.Z`格式的具体版本标签。

### 二进制文件

从[GitHub Releases页面](https://github.com/tarampampam/error-pages/releases/latest)下载对应操作系统/架构的最新预编译二进制文件。

### 预生成错误页面包

可直接下载已渲染的错误页面压缩包：
- [ZIP格式](https://github.com/tarampampam/error-pages/zipball/gh-pages/)
- [TAR.GZ格式](https://github.com/tarampampam/error-pages/tarball/gh-pages/)

## 内置模板（Themes）

以下模板已内置，无需额外配置即可使用：

| 模板名称          | 说明                                                                 |
|-------------------|----------------------------------------------------------------------|
| `app-down`        | 应用下线风格，简洁明了                                                |
| `cats`            | 猫咪图片风格（唯一依赖外部资源的模板，需联网加载图片）                  |
| `connection`      | 网络连接风格，带有连接状态可视化元素                                  |
| `ghost`           | 幽灵主题，深色背景与动态效果                                          |
| `hacker-terminal` | 黑客终端风格，模拟命令行界面                                          |
| `l7`              | L7风格，现代简约设计                                                  |
| `lost-in-space`   | 太空迷失风格，科幻主题                                                |
| `noise`           | 噪点风格，复古颗粒感设计                                              |
| `orient`          | 东方风格，融合传统元素                                                |
| `shuffle`         | 随机风格，动态变化视觉效果                                            |
| `win98`           | Windows 98风格，复古操作系统界面                                      |

> [!注意]
> `cats`模板会从外部服务器加载实际猫咪图片，其他模板均为自包含设计，不依赖外部资源。

## 使用场景与示例

### HTTP服务器启动（二进制/ Docker）

#### 二进制文件启动
```bash
./error-pages serve
```

#### Docker启动
```bash
docker run --rm -p '8080:8080/tcp' docker.xuanyuan.run/tarampampam/error-pages serve
```

服务器默认监听`0.0.0.0:8080`，可通过`http://127.0.0.1:8080/{状态码}.html`访问错误页面（如`http://127.0.0.1:8080/404.html`）。

#### 自定义错误状态码
通过`X-Code` HTTP头指定错误状态码，使用静态URL访问：
```bash
curl -H 'X-Code: 500' http://127.0.0.1:8080/
```

#### 配置选项
- 通过`--template-name`或环境变量`TEMPLATE_NAME`切换模板（如`TEMPLATE_NAME=l7`）
- 通过`--show-details`或环境变量`SHOW_DETAILS=true`启用详细错误信息（含上游代理信息）
- 通过`--rotation-mode`或环境变量`TEMPLATES_ROTATION_MODE`启用模板自动切换（支持`random-on-startup`/`random-on-each-request`/`random-hourly`/`random-daily`）

### 使用自定义模板

1. 创建自定义模板文件`my-super-theme.html`：
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <title>{{ code }} - 自定义错误页面</title>
</head>
<body>
  <h1>错误 {{ code }}: {{ message }}</h1>
  <p>{{ description }}</p>
</body>
</html>
```

2. 启动服务器并加载自定义模板：
```bash
docker run --rm \
  -v "$(pwd)/my-super-theme.html:/opt/my-template.html:ro" \
  -p '8080:8080/tcp' \
  ***-ghcr.xuanyuan.run/tarampampam/error-pages:3 serve \
    --add-template /opt/my-template.html \
    --template-name my-template
```

3. 测试自定义模板：
```bash
curl -H "Accept: text/html" http://127.0.0.1:8080/503
```

### 生成静态错误页面

使用自定义模板生成静态错误页面文件：

```bash
# 创建输出目录
mkdir -p /path/to/output

# 生成错误页面
./error-pages build \
  --add-template /path/to/your/my-template.html \
  --target-dir /path/to/output
```

生成的文件结构示例：
```
/path/to/output/
└── my-template
    ├── 400.html
    ├── 401.html
    ├── 403.html
    ├── 404.html
    ├── ...（其他状态码文件）
```

### 自定义Nginx Docker镜像

#### 1. 创建Nginx配置文件`nginx.conf`：
```nginx
server {
  listen      80;
  server_name localhost;

  # 配置错误页面映射
  error_page 401 /_error-pages/401.html;
  error_page 403 /_error-pages/403.html;
  error_page 404 /_error-pages/404.html;
  error_page 500 /_error-pages/500.html;
  error_page 502 /_error-pages/502.html;
  error_page 503 /_error-pages/503.html;

  # 内部错误页面路径配置
  location ^~ /_error-pages/ {
    internal;
    root /usr/share/nginx/errorpages;
  }

  # 主站点配置
  location / {
    root  /usr/share/nginx/html;
    index index.html index.htm;
  }
}
```

#### 2. 创建Dockerfile：
```dockerfile
FROM docker.xuanyuan.run/library/nginx:1.27-alpine

# 覆盖默认Nginx配置
COPY --chown=nginx ./nginx.conf /etc/nginx/conf.d/default.conf

# 从error-pages镜像复制预生成的错误页面（将ghost替换为其他模板名称）
COPY --chown=nginx \
     --from=ghcr.io/tarampampam/error-pages:3 \
     /opt/html/ghost /usr/share/nginx/errorpages/_error-pages
```

#### 3. 构建并测试镜像：
```bash
# 构建镜像
docker build --tag your-nginx:local -f ./Dockerfile .

# 启动镜像
docker run --rm -p '8081:80/tcp' docker.xuanyuan.run/your-nginx:local

# 测试错误页面（新终端）
curl http://127.0.0.1:8081/不存在的路径
```

### Traefik与Docker Compose集成

创建`compose.yml`文件：

```yaml
services:
  traefik:
    image: docker.xuanyuan.run/library/traefik:v3.1
    command:
      - --api.dashboard=true
      - --api.insecure=true
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false
      - --entrypoints.web.address=:80
    ports:
      - "80:80/tcp"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    labels:
      traefik.enable: true
      traefik.http.routers.traefik.rule: Host(`traefik.localtest.me`)
      traefik.http.routers.traefik.service: api@internal
      traefik.http.routers.traefik.entrypoints: web
      traefik.http.routers.traefik.middlewares: error-pages-middleware
    depends_on:
      error-pages: {condition: service_healthy}

  error-pages:
    image: ***-ghcr.xuanyuan.run/tarampampam/error-pages:3
    environment:
      TEMPLATE_NAME: l7  # 设置模板名称
    labels:
      traefik.enable: true
      traefik.http.routers.error-pages-router.rule: HostRegexp(`.+`)
      traefik.http.routers.error-pages-router.priority: 10
      traefik.http.routers.error-pages-router.entrypoints: web
      traefik.http.routers.error-pages-router.middlewares: error-pages-middleware
      # 错误中间件配置
      traefik.http.middlewares.error-pages-middleware.errors.status: 400-599
      traefik.http.middlewares.error-pages-middleware.errors.service: error-pages-service
      traefik.http.middlewares.error-pages-middleware.errors.query: /{status}.html
      traefik.http.services.error-pages-service.loadbalancer.server.port: 8080

  # 测试服务（可选）
  nginx-or-any-another-service:
    image: docker.xuanyuan.run/library/nginx:1.27-alpine
    labels:
      traefik.enable: true
      traefik.http.routers.test-service.rule: Host(`test.localtest.me`)
      traefik.http.routers.test-service.entrypoints: web
      traefik.http.routers.test-service.middlewares: error-pages-middleware
```

启动服务：
```bash
docker compose up
```

访问测试：
- Traefik dashboard: `http://traefik.localtest.me/dashboard/`
- 测试服务错误页面: `http://test.localtest.me/不存在的路径`

### Kubernetes与Ingress Nginx集成

通过Helm配置Ingress Nginx，添加以下参数至`values.yaml`：

```yaml
controller:
  config:
    custom-http-errors: >-
      401,403,404,500,501,502,503  # 需处理的错误状态码

defaultBackend:
  enabled: true
  image:
    repository: ghcr.io/tarampampam/error-pages
    tag: '3'  # 指定具体版本，不建议使用latest
  extraEnvs:
  - name: TEMPLATE_NAME  # 可选：设置模板
    value: l7
  - name: SHOW_DETAILS   # 可选：启用详细错误信息
    value: 'true'
```

### Kubernetes与Traefik集成

通过Helm部署错误页面服务及Traefik中间件，主要包含以下资源（示例模板）：

#### 1. 命名空间（namespace.yaml）
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: error-pages
```

#### 2. 部署（deployment.yaml）
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: error-pages
  namespace: error-pages
  labels:
    app: error-pages
spec:
  replicas: 1
  selector:
    matchLabels:
      app: error-pages
  template:
    metadata:
      labels:
        app: error-pages
    spec:
      automountServiceAccountToken: false
      containers:
      - name: error-pages
        image: ***-ghcr.xuanyuan.run/tarampampam/error-pages:3
        env:
        - name: TEMPLATE_NAME
          value: shuffle  # 设置模板
        securityContext:
          runAsNonRoot: true
          runAsUser: 10001
          runAsGroup: 10001
          readOnlyRootFilesystem: true
        ports:
        - name: http
          containerPort: 8080
        livenessProbe:
          httpGet:
            path: /healthz
            port: http
        readinessProbe:
          httpGet:
            path: /healthz
            port: http
        resources:
          limits:
            memory: 64Mi
            cpu: 200m
          requests:
            memory: 16Mi
            cpu: 20m
```

#### 3. 服务（service.yaml）
```yaml
apiVersion: v1
kind: Service
metadata:
  name: error-pages-service
  namespace: error-pages
spec:
  type: ClusterIP
  selector:
    app: error-pages
  ports:
  - name: http
    port: 8080
    targetPort: 8080
```

#### 4. Traefik中间件（middleware.yaml）
```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: error-pages
  namespace: error-pages
spec:
  errors:
    status: ["401", "403", "404", "500-599"]
    service:
      name: error-pages-service
      port: 8080
    query: "/{status}.html"
```

应用上述资源后，在Traefik IngressRoute中引用中间件：
```yaml
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: example-app
  namespace: example
spec:
  entryPoints:
  - websecure
  routes:
  - match: Host(`app.example.com`)
    kind: Rule
    services:
    - name: example-service
      port: 80
    middlewares:
    - name: error-pages
      namespace: error-pages  # 跨命名空间引用需Traefik开启allowCrossNamespace
```

> 注：Traefik需配置`--providers.kubernetescrd.allowCrossNamespace=true`以支持跨命名空间中间件引用。
