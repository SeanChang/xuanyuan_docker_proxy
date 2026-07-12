---
image: smallstep/step-ca
description: "🛡️ 一个在线证书颁发机构(CA)和ACME服务器，用于安全自动化的X.509和SSH证书管理。"
source: https://xuanyuan.cloud/zh/r/smallstep/step-ca
canonical: https://xuanyuan.cloud/zh/r/smallstep/step-ca
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/smallstep/step-ca" title="smallstep/step-ca Docker 镜像中文简介、标签列表与拉取命令">smallstep/step-ca 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# step-ca

### step-ca 是一个私有在线证书颁发机构(CA)，用于安全、自动化的X.509和SSH证书管理。

- 为所有工作负载颁发TLS和HTTPS证书：虚拟机、容器、API、移动客户端、数据库连接、打印机、用户、WiFi网络、烤面包机等。
- 可与[任何ACME v2客户端](https://smallstep.com/docs/tutorials/acme-protocol-acme-clients)配合使用——certbot、acme.sh、Traefik、Caddy、Kubernetes cert-manager等。
- 为用户（通过单点登录OIDC [ID令牌](https://openid.net/specs/openid-connect-core-1_0.html#IDToken)）或主机（通过云实例身份文档或一次性令牌）颁发SSH证书。
- 支持PKCS#11 HSM和Yubikey PIV插槽中的硬件绑定私钥（参见[`step-ca-hsm`](https://hub.docker.com/r/smallstep/step-ca-hsm)镜像）。

## 重要链接：

- [`step-ca` 文档](https://smallstep.com/docs/step-ca)
- [源码仓库](https://github.com/smallstep/certificates) 和此包的 [Dockerfile](https://github.com/smallstep/certificates/tree/master/docker)
- 有问题？在 [GitHub Discussions](https://github.com/smallstep/certificates/discussions) 或 [Discord](https://u.step.sm/discord) 上向我们提问。

## 标签

**默认镜像** 适用于大多数用户。  
标签为 `latest` 和版本号，例如 `0.23.0`。  
这是一个基于Alpine的镜像。  

**HSM镜像** 用于存储在PKCS#11硬件安全模块(HSM)或Yubikey PIV插槽中的密钥。  
标签为 `hsm` 和带版本的 `hsm-` 标签，例如 `hsm-0.23.0`、`hsm-0.23.1` 等。  
此镜像中的 `step-ca` 二进制文件启用CGO编译。  
基于Bullseye，因此可集成来自HSM供应商的 `glibc` 兼容PKCS#11模块。


---

**不想运行自己的CA？**  
如需快速上手或作为运行自己 `step-ca` 服务器的替代方案，可考虑创建[免费托管的smallstep证书管理器权威机构](https://info.smallstep.com/certificate-manager-early-access-mvp/)。

---

# 快速开始

## 要求

- 要与 `step-ca` 交互，需在主机环境中安装 `step` 客户端。参见[安装文档](https://smallstep.com/docs/step-cli/installation)。

## 快速初始化

### 初始化PKI

在Docker主机上运行以下命令初始化PKI：

```
docker run -it -v step:/home/step \
    -p 9000:9000 \
    -e "DOCKER_STEPCA_INIT_NAME=Smallstep" \
    -e "DOCKER_STEPCA_INIT_DNS_NAMES=localhost,$(hostname -f)" \
    -e "DOCKER_STEPCA_INIT_REMOTE_MANAGEMENT=true" \
    docker.xuanyuan.run/smallstep/step-ca
```

👉 注意输出中的CA指纹(SHA256)、远程管理超级管理员用户名和远程管理密码。

以下环境变量可用于初始化CA配置：

- （**必填**）`DOCKER_STEPCA_INIT_NAME`：CA名称——将作为CA证书的颁发者
- （**必填**）`DOCKER_STEPCA_INIT_DNS_NAMES`：CA接受请求的主机名或IP
- （**推荐**）`DOCKER_STEPCA_INIT_REMOTE_MANAGEMENT`：启用[远程配置器管理](https://smallstep.com/docs/step-ca/provisioners#remote-provisioner-management)
- `DOCKER_STEPCA_INIT_PROVISIONER_NAME`：初始管理员(JWK)配置器的标签。默认：`admin`
- `DOCKER_STEPCA_INIT_SSH`：设为`true`以启用SSH证书支持
- `DOCKER_STEPCA_INIT_ACME`：为CA创建初始ACME配置器
- `DOCKER_STEPCA_INIT_PASSWORD_FILE`：用于私钥和默认CA配置器的密码文件位置。适用于指向容器中`/run/secrets`内的Docker密钥。若同时设置`DOCKER_STEPCA_INIT_PASSWORD`和`DOCKER_STEPCA_INIT_PASSWORD_FILE`，仅使用`DOCKER_STEPCA_INIT_PASSWORD_FILE`。
- （**不推荐**）`DOCKER_STEPCA_INIT_PASSWORD`：通常CA密码会自动生成。使用此选项可指定加密CA密钥和默认CA配置器的密码。**注意**：存储在环境变量中的密码[不安全](https://smallstep.com/blog/command-line-secrets/#environment-variables)。生产环境中，更安全的方式是使用下文的手动安装流程。

这些变量仅在首次运行前配置`step-ca`时生效。

### 引导step客户端

CA初始化后将开始运行，可进行连接。客户端需知道CA的URL和SHA256指纹。

在主机环境中引导`step`客户端并将根CA证书安装到主机信任存储：

```bash
{
  CA_FINGERPRINT=$(docker run -v step:/home/step smallstep/step-ca step certificate fingerprint certs/root_ca.crt)
  step ca bootstrap --ca-url https://localhost:9000 --fingerprint $CA_FINGERPRINT --install
}
```

输出：

```
The root certificate has been saved in /Users/alice/.step/certs/root_ca.crt.
Your configuration has been saved in /Users/alice/.step/config/defaults.json.
Installing the root certificate in the system truststore...
[sudo] password for alice: ....
done.
```

本地`step` CLI现已配置为使用容器实例的`step-ca`，且根证书受主机环境信任。

运行健康检查：

```bash
curl https://localhost:9000/health
```

输出：

```json
{"status":"ok"}
```

CA已准备就绪。

## 手动安装

已在Linux的Bash中测试。

### 1. 拉取Docker镜像

获取最新版本的`step-ca`：

```bash
docker pull docker.xuanyuan.run/smallstep/step-ca
```

### 2. 启动PKI引导容器

Docker卷`step`将存储CA配置、密钥和数据库：

```bash
docker run -it -v step:/home/step docker.xuanyuan.run/smallstep/step-ca step ca init --remote-management
```

init命令将引导配置流程。示例输出：

```
✔ What would you like to name your new PKI? (e.g. Smallstep): Smallstep
✔ What DNS names or IP addresses would you like to add to your new CA? (e.g. ca.smallstep.com[,1.1.1.1,etc.]): localhost
✔ What address will your new CA listen at? (e.g. :443): :9000
✔ What would you like to name the first provisioner for your new CA? (e.g. you@smallstep.com): admin@smallstep.com
✔ What do you want your password to be? [leave empty and we'll generate one]:

Generating root certificate... done!
Generating intermediate certificate... done!

✔ Root certificate: /home/step/certs/root_ca.crt
✔ Root private key: /home/step/secrets/root_ca_key
✔ Root fingerprint: fa08cceda8501b1d93d275cfc614a5af2a37c6c72e674192b4598808c5bae91e
✔ Intermediate certificate: /home/step/certs/intermediate_ca.crt
✔ Intermediate private key: /home/step/secrets/intermediate_ca_key
✔ Database folder: /home/step/db
✔ Default configuration: /home/step/config/defaults.json
✔ Certificate Authority configuration: /home/step/config/ca.json
✔ Admin provisioner: admin@smallstep.com (JWK)
✔ Super admin subject: step

Your PKI is ready to go. To generate certificates for individual services see 'step help ca'.
```

**保存根指纹值**！客户端引导需使用。

### 3. 将PKI密码存放在安全位置

镜像期望中间CA私钥密码存放在`/home/step/secrets/password`。再次启动容器shell并写入文件：

```bash
docker run -it -v step:/home/step docker.xuanyuan.run/smallstep/step-ca sh
```

**在容器内**，将密码写入指定位置：

```bash
echo -n "<your password here>" > /home/step/secrets/password
```

CA已配置完成，可启动。

### 4. 启动step-ca

CA在容器内的9000端口运行HTTPS API。本地暴露该端口并启动：

```bash
docker run -d -p 9000:9000 -v step:/home/step docker.xuanyuan.run/smallstep/step-ca
```

在主机环境中引导`step`客户端配置：

```bash
{
CA_FINGERPRINT=$(docker run  -v step:/home/step smallstep/step-ca step certificate fingerprint /home/step/certs/root_ca.crt)
step ca bootstrap --ca-url https://localhost:9000 --fingerprint $CA_FINGERPRINT --install
}
```

输出：

```
The root certificate has been saved in /Users/alice/.step/certs/root_ca.crt.
Your configuration has been saved in /Users/alice/.step/config/defaults.json.
Installing the root certificate in the system truststore...
[sudo] password for alice: ...
done.
```

本地`step` CLI现已配置为使用容器实例的`step-ca`，新根证书受主机环境信任。

运行健康检查：

```bash
curl https://localhost:9000/health
```

输出：

```json
{"status":"ok"}
```

### 后续步骤：

- 参见[基本CA操作](https://smallstep.com/docs/step-ca/basic-certificate-authority-operations)指南。
- 参见[配置指南](https://smallstep.com/docs/step-ca/configuration)了解如何调整`step-ca`以适应基础设施。
- 需为其他容器获取证书？阅读文章[Docker中的TLS证书自动化管理](https://smallstep.com/blog/automate-docker-ssl-tls-certificates/)。
- 或在下文设置开发环境。

## 代码签名

`step-ca`使用[sigstore/cosign](https://github.com/sigstore/cosign)进行容器签名和验证。验证示例：

```bash
cosign verify smallstep/step-ca:0.23.1 \
--certificate-identity-regexp "https://github\.com/smallstep/workflows/.*" \
--certificate-oidc-issuer https://token.actions.githubusercontent.com
```

## 开发环境设置

**需求**：

- Python 2.7.x解释器（用于启动独立Web服务器，可选）

在安装Docker的主机上运行以下步骤。

引导本地环境后，可运行配置TLS和mTLS的Web服务。首先获取`localhost`证书：

```bash
step ca certificate localhost localhost.crt localhost.key
```

输出：

```
✔ Key ID: aTPGWP0qbuQdflR5VxtNouDIOXyNMH1H9KAZKP-UcHo (admin)
✔ Please enter the password to decrypt the provisioner key:
✔ CA: <https://localhost:9000/1.0/sign>
✔ Certificate: localhost.crt
✔ Private Key: localhost.key
```

保存根CA证书副本：

```bash
step ca root root_ca.crt
```

输出：

```
The root certificate has been saved in root_ca.crt.
```

启动HTTPS安全Web服务器：

```bash
{
cat <<EOF > server.py
import BaseHTTPServer, ssl

class HelloHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200);
        self.send_header('content-type', 'text/html; charset=utf-8');
        self.end_headers()
        self.wfile.write(b'\\n\\xf0\\x9f\\x91\\x8b Hello! Welcome to TLS \\xf0\\x9f\\x94\\x92\\xe2\\x9c\\x85\\n\\n')

httpd = BaseHTTPServer.HTTPServer(('', 8443), HelloHandler)
httpd.socket = ssl.wrap_socket(httpd.socket,
                   server_side=True,
                   keyfile="localhost.key",
                   certfile="localhost.crt",
                   ca_certs="root_ca.crt")
httpd.serve_forever()
EOF

python server.py
}
```

打开另一个终端查看运行的服务器：

```bash
$ curl https://localhost:8443
👋 Hello! Welcome to TLS 🔒✅
```

或在浏览器中访问 [https://localhost:8443](https://localhost:8443/)。

### 故障排除

### 树莓派Badger数据库错误

在树莓派上运行`step-ca`时，容器日志可能出现以下错误：

```
step-ca  | badger 2021/05/08 20:13:12 INFO: All 0 tables opened in 0s
step-ca  | Error opening database of Type badger with source /home/step/db: error opening Badger database: Mmap value log file. Path=/home/step/db/000000.vlog. Error=cannot allocate memory
```

修复方法：编辑`config/ca.json`中的`db`配置块：

```bash
docker run -v step:/home/step -it docker.xuanyuan.run/smallstep/step-ca vi /home/step/config/ca.json
```

将`badgerFileLoadingMode`的值从`""`改为`"FileIO"`：

```json
    "db": {
          "type": "badger",
          "dataSource": "/home/step/db",
          "badgerFileLoadingMode": "FileIO"
    },
```

保存并重启容器。

**有问题？在 [GitHub Discussions](https://github.com/smallstep/certificates/discussions) 或 [Discord](https://u.step.sm/discord) 上向我们提问。**
