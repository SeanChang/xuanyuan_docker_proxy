# 【漏洞预警】Traefik 同 host 的 Ingress 会关掉 mTLS，FastProxy 协议升级可致进程退出

![【漏洞预警】Traefik 同 host 的 Ingress 会关掉 mTLS，FastProxy 协议升级可致进程退出](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: Traefik,GHSA,安全公告,漏洞预警,Kubernetes,拒绝服务 | 发布时间: 2026-10-18 18:04:29*

> Traefik 有两条尚无 CVE 的高危。Kubernetes Ingress NGINX provider 下，同一 host 上未对齐的 Ingress 会让 auth-tls-secret 配置的客户端证书认证被静默关闭（GHSA-p8wx-ph99-xgcr，CVSS 4.0 为 7.0）。实验特性 FastProxy 在 HTTP/1 协议升级后存在数据竞争，未认证客户端可让进程 panic（GHSA-ww7c-q3mv-xx22，CVSS 4.0 为 8.2）。请把 library/traefik 的 v3 升到 v3.7.15 或更高。v2 不受这两条影响。

**发布日期：** 2026 年 10 月 17 日  
**更新日期：** 2026 年 10 月 21 日  
**更新内容：** v3.7.15 仍受 ForwardAuth 连接池身份复用影响。v3 请继续升到 **v3.7.16**。启用 ForwardAuth 且鉴权为 NTLM 或 Negotiate 的 v2，升到 **v2.11.60**。  
**风险等级：** 高危（High）  
**漏洞编号：** GHSA-p8wx-ph99-xgcr · GHSA-ww7c-q3mv-xx22（暂无 CVE）  
**涉及镜像：** library/traefik — [轩辕镜像](https://xuanyuan.cloud/r/library/traefik) · [Docker Hub](https://hub.docker.com/_/traefik)  
**CVSS：** **8.2**（High，CVSS 4.0，GHSA-ww7c-q3mv-xx22）  
**披露时间：** 两条公告于 2026 年 10 月 16 日发布  
**相关公告：** [GHSA-ww7c-q3mv-xx22](https://github.com/traefik/traefik/security/advisories/GHSA-ww7c-q3mv-xx22)

---

## 一、漏洞概述

Traefik 是常用的反向代理和 Kubernetes Ingress 控制器。官方镜像是 `library/traefik`。这两条发布于 2026 年 10 月 16 日，都还没有 CVE 编号，也还没进 NVD。此前建议的 **v3.7.14** 低于这次的修复线。

**GHSA-p8wx-ph99-xgcr：** 使用 Kubernetes Ingress NGINX provider，并且用 `nginx.ingress.kubernetes.io/auth-tls-secret` 做 mTLS 客户端认证时，provider 按 Ingress 而不是按 host 挂载客户端认证的 TLS option。同一个 host 上如果还有一条 Ingress 路径没有带上同样的 auth-tls 设置，Traefik 会在 TLS option 冲突时退回默认选项，不再向客户端要证书。除非打开了 `core.strictTLSOptions`。未认证的远程访问就可以直达本应要求客户端证书的后端。`auth-tls-secret` 这条注解自 v3.7 引入，v2 以及 v3.7.0 之前不受影响。

**GHSA-ww7c-q3mv-xx22：** 实验特性 `experimental.fastProxy` 在 HTTP/1 协议升级（例如 WebSocket 返回 101）之后，连接池和隧道拷贝器会同时读同一个 `bufio.Reader`。数据竞争可以导致进程 panic，而且没有被恢复，整个进程退出。未认证客户端反复建立升级连接再中断，就可以打出拒绝服务。只有打开了 FastProxy 才受影响。v2 没有 FastProxy。v3.2 到 v3.6 受影响且已停止维护，需要升到已经打补丁的 v3.7。

---

## 二、漏洞状态

**统计截止：** 2026 年 10 月 18 日（UTC+8）

| 项目 | 状态 |
|------|------|
| 漏洞细节 | 已公开（Traefik 安全公告）。暂无 CVE，NVD 未收录 |
| 官方补丁 | **v3.7.15** 及更高 |
| CISA KEV | 未列入 |

| 公告 | CVSS 4.0 | 要点 | 受影响版本 |
|------|----------|------|------------|
| GHSA-p8wx-ph99-xgcr | **7.0** High | 同 host 上未对齐的 Ingress 会关掉 mTLS 客户端认证 | 使用 auth-tls-secret 的 v3.7，低于 **v3.7.15**。v2 与 v3.7.0 之前不受影响 |
| GHSA-ww7c-q3mv-xx22 | **8.2** High | FastProxy 在协议升级后数据竞争，进程 panic | 打开了 `experimental.fastProxy` 的 **v3.2.0 至 v3.7.14**。v2 不受影响 |

---

## 三、影响范围

### 1. 版本与发行形态

| 发行形态 | 受影响范围 | 修复 |
|----------|------------|------|
| Traefik v3.7 | 低于 **v3.7.15**，且命中上表条件 | **≥ v3.7.15** |
| Traefik v3.2 至 v3.6 | FastProxy 已停维，没有单独补丁 | 直接升到 **v3.7.15** |
| Traefik v2 | 这两条都不适用 | 不必为这两条改到 v3 |

官方镜像 `library/traefik` 在 Docker Hub 上已有标签 **v3.7.15**。Hub 上还有更新的 v2 标签 **v2.11.59**，那是 v2 线，不用来修这两条。

没有使用 Ingress NGINX provider 的 auth-tls-secret、并且没有打开 `experimental.fastProxy` 的 v3.7.14，不会同时踩中两条。版本低于 v3.7.15 时，对应功能开着就仍在范围内。

### 2. 典型受影响场景

- 一个 host 上有多条 Ingress，只有一部分配置了 `auth-tls-secret`
- 边缘入口打开了 `experimental.fastProxy`，并且对外提供 WebSocket 或其他 HTTP 升级
- 集群还停在 v3.2 到 v3.6，这些版本不会再收到 FastProxy 的补丁

---

## 四、修复建议

### 1. 把 v3 升到 v3.7.15 或更高（推荐）

| 当前版本 | 建议 |
|----------|------|
| v3.7.0 至 v3.7.14 | **v3.7.15** |
| v3.2 至 v3.6，且打开了 FastProxy | **v3.7.15** |
| v2 | 这两条不必升级；若仍要跟 v2 的其他修复，Hub 上已有 **v2.11.59** |

**Docker Hub：** [traefik](https://hub.docker.com/_/traefik)

**轩辕镜像：** [library/traefik](https://xuanyuan.cloud/r/library/traefik)

```bash
docker pull docker.xuanyuan.run/library/traefik:v3.7.15
```

将 Compose、Kubernetes 或 Helm 中的镜像改为上述坐标后滚动升级。升级后确认版本不低于 **v3.7.15**。

发行说明：[v3.7.15](https://github.com/traefik/traefik/releases/tag/v3.7.15)。

### 2. 升级前核对 Ingress

同一个 host 上的 Ingress 要么都带上相同的客户端证书认证，要么在升到 v3.7.15 之前打开 `core.strictTLSOptions`，避免冲突时退回不请求证书的默认 TLS option。打开了 FastProxy 的，升级完成前可以先关掉 `experimental.fastProxy`。

---

## 五、临时缓解措施

在升到 v3.7.15 之前：

1. **需要 mTLS 的 host，不要混放未配置 auth-tls 的 Ingress**  
   未对齐时，客户端证书认证会被静默关掉。临时可以启用 `core.strictTLSOptions`。

2. **关掉 experimental.fastProxy**  
   v3.2 至 v3.7.14 上，这项实验特性开着就会受到协议升级导致的进程退出影响。v2 没有这项开关。

3. **不要停在 v3.7.14**  
   这一版修的是更早一批公告，不包含本文两条。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代 Traefik 的版本升级。

- 站内页：[library/traefik](https://xuanyuan.cloud/r/library/traefik)。拉取命令为 `docker.xuanyuan.run/library/traefik:v3.7.15`。
- 加速拉取不会自动变成 v3.7.15。v3 请把标签固定为 **v3.7.15** 或更高。
- 配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- Traefik：[GHSA-p8wx-ph99-xgcr](https://github.com/traefik/traefik/security/advisories/GHSA-p8wx-ph99-xgcr)
- Traefik：[GHSA-ww7c-q3mv-xx22](https://github.com/traefik/traefik/security/advisories/GHSA-ww7c-q3mv-xx22)
- 发行说明：[v3.7.15](https://github.com/traefik/traefik/releases/tag/v3.7.15)
- Docker Hub：[traefik](https://hub.docker.com/_/traefik)
- 轩辕站内镜像页：[library/traefik](https://xuanyuan.cloud/r/library/traefik)

---

**轩辕镜像安全团队**  
2026 年 10 月 17 日


