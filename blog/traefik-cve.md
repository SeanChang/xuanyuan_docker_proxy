# 【漏洞预警】Traefik 七条高危公告：认证绕过与身份串用（暂无 CVE 编号）

![【漏洞预警】Traefik 七条高危公告：认证绕过与身份串用（暂无 CVE 编号）](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: Traefik, GHSA, 安全公告, 漏洞预警, 认证绕过, Ingress, Docker | 发布时间: 2026-10-08 12:40:43*

> Traefik 于 2026 年 10 月 7 日公开 7 条高危公告（CVSS 4.0 均为 7.0，暂无 CVE 编号），涉及 SNI 检查被跳过、NTLM/Negotiate 身份串用，以及 Ingress-NGINX provider 的认证与 mTLS 问题。请把官方镜像升到 v2.11.58 或 v3.7.14。官方二进制和官方镜像不受其中的 SNI 那一条影响。

**发布日期：** 2026 年 10 月 7 日  
**风险等级：** 高危（High）  
**漏洞编号：** 暂无 CVE 编号 · 见下文七条 GHSA  
**涉及镜像：** library/traefik — [轩辕镜像](https://xuanyuan.cloud/r/library/traefik) · [Docker Hub](https://hub.docker.com/_/traefik)  
**CVSS：** **7.0**（High，CVSS 4.0），七条相同  
**披露时间：** 修复版 v2.11.58 与 v3.7.14 于 2026 年 10 月 6 日发布；公告于 2026 年 10 月 7 日公开  
**相关公告：** [v2.11.58](https://github.com/traefik/traefik/releases/tag/v2.11.58) · [v3.7.14](https://github.com/traefik/traefik/releases/tag/v3.7.14)

---

## 一、漏洞概述

Traefik 是常用的反向代理和 Kubernetes Ingress 控制器。官方镜像是 `library/traefik`。2026 年 10 月 7 日公开的七条公告都是高危，评分都是 CVSS 4.0 的 **7.0**，目前都没有 CVE 编号。没有在野利用记录。

v3.0 到 v3.6 已停止维护，这些版本不会单独发补丁，需要直接升到 **v3.7.14**。v2 线升到 **v2.11.58**。

### 1. GHSA-fh26-gfpp-7xxx：HTTP/2 的 `:scheme http` 跳过 SNI 检查

请求带 HTTP/2 伪头 `:scheme http` 时，SNI 检查会被跳过，客户端可能不出示证书就访问到要求客户端证书的路由。受影响范围是 **≤ v2.11.57**，以及 **v3.0.0 至 v3.7.13**。

官方二进制和官方镜像用 Go 1.26 构建，**不受这一条影响**。只有自己用 Go 1.27 编译的 Traefik（含第三方重编译）受影响。

### 2. GHSA-qm9f-w54v-q2qh：预先带上的 Negotiate 令牌污染共享连接池

后端使用 NTLM 或 Kerberos（Negotiate），并且客户端在第一次请求里就带上 Negotiate 令牌时，已经完成认证的后端连接会留在共享连接池里。后面另一个未认证的客户端可能分到这条连接，从而使用别人的身份。标准的「先 401 再带凭据」握手不受影响。受影响范围是 **v2.11.0 至 v2.11.57**，以及 **v3.0.0 至 v3.7.13**。

### 3. GHSA-cw35-4q88-3rmp：NTLM/Kerberos 粘性连接不区分服务

后端返回 NTLM 或 Negotiate 质询后，Traefik 为这条客户端连接保留的后端传输不按服务分开。一个服务的 TLS 客户端配置（根证书、校验、客户端证书）会被用到同一条连接后面访问的另一个服务上。受影响范围与第 2 条相同：**v2.11.0 至 v2.11.57**，**v3.0.0 至 v3.7.13**。v2.11.0 之前的 v2 和 Traefik v1 没有这条 NTLM/Kerberos 支持。

### 4. GHSA-53qr-784g-cj35：FastProxy 泄露 NTLM/Negotiate 身份

打开实验开关 `experimental.fastProxy` 后，明文 HTTP 后端的连接池没有按前端连接隔离。未认证客户端可能拿到别人已经完成 NTLM 或 Negotiate 握手的后端连接。只影响 **v3.2.0 至 v3.7.13**，且后端是明文 HTTP、开启了连接复用。默认代理实现不受影响。v2 不受影响。修复只有 **v3.7.14**。

### 5. GHSA-qvj7-gq9c-hp7q：ssl-passthrough 多出一条没有认证的 HTTP 路由

Kubernetes Ingress-NGINX provider 从 **v3.7.13** 起，会给带 `ssl-passthrough: "true"` 的 Ingress 再生成一条 HTTP 路由，但没有挂上该 Ingress 的认证和来源白名单。未认证客户端可以从 HTTP 入口访问本应受保护的后端。**只有 v3.7.13** 受影响。v2 和 v3.7.13 之前的 v3 不受影响。

### 6. GHSA-mwrr-6hp4-pxr6：伪造的 Ssl-Client-* 头被原样转发

Ingress 使用 `auth-tls-pass-certificate-to-upstream`，并且设置了 `ssl-redirect: "false"` 时，明文 HTTP 路由会把客户端自己提交的 `Ssl-Client-*` 头原样转给后端。后端如果把这些头当成 mTLS 身份，未认证客户端就能被当成已通过客户端证书校验。只影响 **v3.7.0 至 v3.7.13**。

### 7. GHSA-rv2h-qh7j-xrjw：auth-tls-secret 名称规范化后撞车

`auth-tls-secret` 指向的 Secret 名字在生成 TLS 选项名时会把点号换成横线。只差一个点或一条横线的两个 Secret 会变成同一个 TLS 选项，一个主机可能被另一个主机的 CA 放行，自己的合法客户端证书反而被拒绝。只影响 **v3.7.0 至 v3.7.13**。v3.7.0 至 v3.7.10 里，规范化后相同的 Ingress 名称也可能撞车。

---

## 二、漏洞状态

**统计截止：** 2026 年 10 月 7 日（UTC+8）

| 公告 | 要满足的条件 | 受影响版本 | 修复 |
|------|----------------|------------|------|
| [GHSA-fh26-gfpp-7xxx](https://github.com/traefik/traefik/security/advisories/GHSA-fh26-gfpp-7xxx) | 用 Go 1.27 自行编译。官方镜像不受影响 | ≤ v2.11.57；v3.0.0–v3.7.13 | v2.11.58 / v3.7.14 |
| [GHSA-qm9f-w54v-q2qh](https://github.com/traefik/traefik/security/advisories/GHSA-qm9f-w54v-q2qh) | 后端使用 NTLM/Negotiate，且客户端预先带令牌 | v2.11.0–v2.11.57；v3.0.0–v3.7.13 | v2.11.58 / v3.7.14 |
| [GHSA-cw35-4q88-3rmp](https://github.com/traefik/traefik/security/advisories/GHSA-cw35-4q88-3rmp) | 后端使用 NTLM/Negotiate | v2.11.0–v2.11.57；v3.0.0–v3.7.13 | v2.11.58 / v3.7.14 |
| [GHSA-53qr-784g-cj35](https://github.com/traefik/traefik/security/advisories/GHSA-53qr-784g-cj35) | 打开了 FastProxy，且后端是明文 HTTP 上的 NTLM/Negotiate | v3.2.0–v3.7.13 | v3.7.14 |
| [GHSA-qvj7-gq9c-hp7q](https://github.com/traefik/traefik/security/advisories/GHSA-qvj7-gq9c-hp7q) | Ingress-NGINX provider，且 Ingress 带 ssl-passthrough | 仅 v3.7.13 | v3.7.14 |
| [GHSA-mwrr-6hp4-pxr6](https://github.com/traefik/traefik/security/advisories/GHSA-mwrr-6hp4-pxr6) | Ingress-NGINX provider，传递客户端证书头，且 ssl-redirect 为 false | v3.7.0–v3.7.13 | v3.7.14 |
| [GHSA-rv2h-qh7j-xrjw](https://github.com/traefik/traefik/security/advisories/GHSA-rv2h-qh7j-xrjw) | Ingress-NGINX provider，使用 auth-tls-secret | v3.7.0–v3.7.13 | v3.7.14 |

七条都未列入 CISA KEV。

---

## 三、影响范围

使用官方镜像时，优先处理第 2 至第 7 条里和你实际配置相交的部分。第 1 条可以跳过，除非 Traefik 是用 Go 1.27 自行编译的。

- 后端没有 NTLM 或 Kerberos 时，第 2、3、4 条没有直接暴露面。
- 没有打开 `experimental.fastProxy` 时，第 4 条没有直接暴露面。
- 没有使用 Kubernetes Ingress-NGINX provider 时，第 5、6、7 条没有直接暴露面。
- 仍建议升级。v3.0 至 v3.6 即使只中了一条，也要升到 v3.7.14，这些小版本线不会再收到补丁。

---

## 四、修复建议

### 1. 升级官方镜像（推荐）

| 当前线路 | 修复标签 |
|----------|----------|
| v2 | **v2.11.58** |
| v3，含 v3.0–v3.7.13 | **v3.7.14** |

Docker Hub 上已经有这两个标签。

**Docker Hub：** [traefik](https://hub.docker.com/_/traefik)

**轩辕镜像：** [library/traefik](https://xuanyuan.cloud/r/library/traefik)

```bash
docker pull docker.xuanyuan.run/library/traefik:v3.7.14
```

仍在 v2 线时：

```bash
docker pull docker.xuanyuan.run/library/traefik:v2.11.58
```

把 Compose 或 Helm 里的镜像改成对应标签后滚动升级。v3.7.14 会重命名 ssl-passthrough Ingress 生成的部分路由，升级前看 [v3.7.14 发布说明](https://github.com/traefik/traefik/releases/tag/v3.7.14)。

自行用 Go 1.27 编译的二进制，同样换成 v2.11.58 或 v3.7.14 的源码再编译，或改用官方镜像。

---

## 五、临时缓解措施

在完成升级之前，只对你实际打开的功能收紧：

1. **NTLM / Kerberos 后端**  
   在升级前避免让不可信客户端访问这些路由。预先发送 Negotiate 令牌的客户端是第 2 条的触发条件。

2. **关掉 FastProxy**  
   不需要实验性 FastProxy 时保持关闭。默认代理实现不走第 4 条。

3. **Ingress-NGINX**  
   在升到 v3.7.14 之前，检查带 `ssl-passthrough`、`auth-tls-pass-certificate-to-upstream` 和 `auth-tls-secret` 的 Ingress。不要用 `ssl-redirect: "false"` 把明文 HTTP 直接送到信任 `Ssl-Client-*` 头的后端。

官方镜像不需要为第 1 条单独做配置变更。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代你对 Traefik 版本的升级。

- 站内页：[library/traefik](https://xuanyuan.cloud/r/library/traefik)。拉取命令为 `docker.xuanyuan.run/library/traefik:v3.7.14` 或 `docker.xuanyuan.run/library/traefik:v2.11.58`。
- 加速拉取不会自动变成安全版本。请把标签固定为你所在主版本的修复标签。
- 配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- GHSA：[fh26-gfpp-7xxx](https://github.com/traefik/traefik/security/advisories/GHSA-fh26-gfpp-7xxx) · [qm9f-w54v-q2qh](https://github.com/traefik/traefik/security/advisories/GHSA-qm9f-w54v-q2qh) · [cw35-4q88-3rmp](https://github.com/traefik/traefik/security/advisories/GHSA-cw35-4q88-3rmp) · [53qr-784g-cj35](https://github.com/traefik/traefik/security/advisories/GHSA-53qr-784g-cj35) · [qvj7-gq9c-hp7q](https://github.com/traefik/traefik/security/advisories/GHSA-qvj7-gq9c-hp7q) · [mwrr-6hp4-pxr6](https://github.com/traefik/traefik/security/advisories/GHSA-mwrr-6hp4-pxr6) · [rv2h-qh7j-xrjw](https://github.com/traefik/traefik/security/advisories/GHSA-rv2h-qh7j-xrjw)
- 发布说明：[v2.11.58](https://github.com/traefik/traefik/releases/tag/v2.11.58) · [v3.7.14](https://github.com/traefik/traefik/releases/tag/v3.7.14)
- Docker Hub：[traefik](https://hub.docker.com/_/traefik)
- 轩辕站内镜像页：[library/traefik](https://xuanyuan.cloud/r/library/traefik)
- 项目主页：<https://github.com/traefik/traefik>

---

**轩辕镜像安全团队**  
2026 年 10 月 7 日


