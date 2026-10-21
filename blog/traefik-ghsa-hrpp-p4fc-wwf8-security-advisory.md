# 【漏洞预警】Traefik ForwardAuth 连接池会串用 NTLM/Negotiate 身份（GHSA-hrpp-p4fc-wwf8）

![【漏洞预警】Traefik ForwardAuth 连接池会串用 NTLM/Negotiate 身份（GHSA-hrpp-p4fc-wwf8）](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: Traefik,GHSA,安全公告,漏洞预警,ForwardAuth,Ingress | 发布时间: 2026-10-21 21:21:59*

> Traefik 的 ForwardAuth，以及 v3.7 Ingress-NGINX 的 auth-url，对鉴权服务器共用连接池。鉴权端使用 NTLM 或 Negotiate 时，已为用户 A 完成的连接可能被复用到用户 B 的请求上（GHSA-hrpp-p4fc-wwf8，CVSS 4.0 为 7.0，暂无 CVE）。v2 请升到 v2.11.60 或更高，v3 请升到 v3.7.16 或更高。v3.7.15 与 v2.11.59 仍受影响。

**发布日期：** 2026 年 10 月 21 日  
**风险等级：** 高危（High）  
**漏洞编号：** GHSA-hrpp-p4fc-wwf8（暂无 CVE）  
**涉及镜像：** library/traefik — [轩辕镜像](https://xuanyuan.cloud/r/library/traefik) · [Docker Hub](https://hub.docker.com/_/traefik)  
**CVSS：** **7.0**（High，CVSS 4.0）  
**披露时间：** 修复版 v2.11.60 与 v3.7.16 于 2026 年 10 月 20 日发布  
**相关公告：** [GHSA-hrpp-p4fc-wwf8](https://github.com/traefik/traefik/security/advisories/GHSA-hrpp-p4fc-wwf8)

---

## 一、漏洞概述

Traefik 是常用的反向代理和 Kubernetes Ingress 控制器。官方镜像是 `library/traefik`。

ForwardAuth 中间件，以及 v3.7 里 Ingress-NGINX 的 `auth-url` 外部鉴权，对鉴权服务器共用一个连接池。鉴权端如果使用绑定在连接上的认证，例如 NTLM，或 SPNEGO / Kerberos Negotiate（常见于 IIS Windows 认证），已经为用户 A 完成鉴权的连接可能被拿去发送用户 B 的 ForwardAuth 子请求。

未认证客户端因此可能拿到带有受害者身份的成功鉴权响应，并凭响应头里交还的身份访问后端。

这条和此前后端连接池上的身份串用不是同一次修复。那些问题的修复线停在 v2.11.58 / v3.7.14 一带。**v3.7.15** 和 **v2.11.59** 仍然受这条 ForwardAuth 问题影响。NVD 尚未挂出编号。

---

## 二、漏洞状态

**统计截止：** 2026 年 10 月 21 日（UTC+8）

| 项目 | 状态 |
|------|------|
| 漏洞细节 | 已公开（GitHub Advisory）。NVD 尚未收录 |
| 漏洞类型 | 鉴权服务器连接池复用了绑定在连接上的身份 |
| 受影响版本 | v2 **≤ v2.11.59**；v3 **v3.0.0 至 v3.7.15** |
| 官方补丁 | v2 **≥ v2.11.60**；v3 **≥ v3.7.16** |
| CISA KEV | 未列入 |

v3.0 至 v3.6 已停止维护，这些版本不会单独发补丁，需要直接升到 **v3.7.16**。

---

## 三、影响范围

### 1. 版本与发行形态

| 发行线 | 受影响范围 | 修复标签 |
|--------|------------|----------|
| v2 | **≤ v2.11.59** | **v2.11.60** |
| v3.7 | **≤ v3.7.15** | **v3.7.16** |
| v3.0 至 v3.6 | 已停维，没有单独补丁 | **v3.7.16** |

Docker Hub 上已有 **v3.7.16** 和 **v2.11.60**（均于 2026 年 10 月 20 日推送）。**v3.7.15** 与 **v2.11.59** 仍在受影响范围内。

### 2. 典型受影响场景

- 对外入口启用了 ForwardAuth，或 v3.7 的 Ingress-NGINX `auth-url`
- 鉴权服务使用 NTLM 或 Negotiate，身份跟 TCP 连接绑定
- 多个用户的鉴权子请求会落到同一个连接池

没有启用这两类外部鉴权，或者鉴权不依赖连接绑定身份时，不会踩中这条复用。版本仍在上表范围内的，建议按修复线升级。

---

## 四、修复建议

### 1. 升级官方镜像（推荐）

| 当前版本 | 升级到 |
|----------|--------|
| v2，含 v2.11.59 及更低 | **v2.11.60** |
| v3，含 v3.0 至 v3.7.15 | **v3.7.16** |

```bash
docker pull docker.xuanyuan.run/library/traefik:v3.7.16
```

仍在 v2 线的：

```bash
docker pull docker.xuanyuan.run/library/traefik:v2.11.60
```

将 Compose、Kubernetes 或 Helm 中的镜像改为上述标签后滚动升级。升级后确认版本不低于对应修复线。

发行说明：[v2.11.60](https://github.com/traefik/traefik/releases/tag/v2.11.60) · [v3.7.16](https://github.com/traefik/traefik/releases/tag/v3.7.16)。

**Docker Hub：** [library/traefik](https://hub.docker.com/_/traefik)

**轩辕镜像：** [library/traefik](https://xuanyuan.cloud/r/library/traefik)

### 2. 暂时不能升级时

收紧谁能访问启用了 ForwardAuth 或 `auth-url` 的入口。这不能分开连接池里已经绑定的身份。鉴权服务若可以改成不依赖 NTLM / Negotiate 的方式，能缩小这条的触发条件，仍然需要升级。

---

## 五、临时缓解措施

在升到修复版之前：

1. **不要把启用了 ForwardAuth 或 auth-url、且鉴权为 NTLM / Negotiate 的入口暴露给不可信客户端**  
   未认证请求可能拿到别人的鉴权结果。

2. **不要停在 v3.7.15 或 v2.11.59**  
   这两档修的是更早的公告，不包含 GHSA-hrpp-p4fc-wwf8。

3. **v3.0 至 v3.6 直接升到 v3.7.16**  
   停维小版本没有这条的单独补丁。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代 Traefik 的版本修复。

- 站内页：[library/traefik](https://xuanyuan.cloud/r/library/traefik)。拉取命令为 `docker.xuanyuan.run/library/traefik:v3.7.16` 或 `docker.xuanyuan.run/library/traefik:v2.11.60`。
- 加速拉取不会自动变成这两个标签。请把标签固定到修复版，不要继续使用 v3.7.15 或 v2.11.59。
- 配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- GitHub Advisory：[GHSA-hrpp-p4fc-wwf8](https://github.com/traefik/traefik/security/advisories/GHSA-hrpp-p4fc-wwf8)
- 发布说明：[v2.11.60](https://github.com/traefik/traefik/releases/tag/v2.11.60) · [v3.7.16](https://github.com/traefik/traefik/releases/tag/v3.7.16)
- Docker Hub：[library/traefik](https://hub.docker.com/_/traefik)
- 轩辕站内镜像页：[library/traefik](https://xuanyuan.cloud/r/library/traefik)

---

**轩辕镜像安全团队**  
2026 年 10 月 21 日


