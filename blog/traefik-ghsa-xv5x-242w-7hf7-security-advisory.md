# 【漏洞预警】Traefik 爆高危漏洞，未登录的 NTLM 头就能耗尽连接（GHSA-xv5x-242w-7hf7）

![【漏洞预警】Traefik 爆高危漏洞，未登录的 NTLM 头就能耗尽连接（GHSA-xv5x-242w-7hf7）](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: Traefik,GHSA,安全公告,漏洞预警 | 发布时间: 2026-11-02 19:50:24*

> 自 v2.11.58 / v3.7.14 起，未认证请求只要带上 Authorization: NTLM 或 Negotiate，Traefik 就会为这条客户端连接分配专用的后端传输；连接关掉之后，传输、空闲后端连接和相关协程不会释放。FastProxy 也有同样问题（GHSA-xv5x-242w-7hf7，CVSS 3.1 为 7.5）。受影响为 v2.11.58–v2.11.60、v3.7.14–v3.7.16。请升到 v2.11.61 或 v3.7.17。此前只升到 2.11.60 / 3.7.16 的仍要再升。今天的 latest 与 v3.7.17 是同一份镜像。

**发布日期：** 2026 年 11 月 2 日  
**风险等级：** 高危（High）  
**漏洞编号：** GHSA-xv5x-242w-7hf7（暂无 CVE）  
**涉及镜像：** library/traefik — [轩辕镜像](https://xuanyuan.cloud/r/library/traefik) · [Docker Hub](https://hub.docker.com/_/traefik)  
**CVSS：** **7.5**（High，CVSS 3.1）  
**披露时间：** 修复版 v2.11.61 与 v3.7.17 于 2026 年 10 月 30 日推送  
**相关公告：** [GHSA-xv5x-242w-7hf7](https://github.com/traefik/traefik/security/advisories/GHSA-xv5x-242w-7hf7)

---

## 一、漏洞概述

从 **v2.11.58** 和 **v3.7.14** 起，Traefik 一看到请求头里的 `Authorization` 是 `NTLM` 或 `Negotiate`，就会给这条客户端连接单独分配一份后端传输。它不要求有效凭据，也不要求后端先返回挑战。客户端连接关掉之后，这份传输、上面的空闲后端连接和相关协程都不会释放。FastProxy 路径也一样。

未登录的人可以开很多短连接，把 Traefik 的内存、文件描述符和到后端的连接打满。是否真的配了 NTLM 或 Kerberos 后端，都不影响这条能否触发。CVSS 3.1 为 **7.5**。

**v2.11.57 及更早**、以及 **v3.6 及更早的 v3 线**不受影响：那些版本要等后端返回 `WWW-Authenticate` 之后，才会单独分配传输。

这条和此前已经修好的 ForwardAuth 连接池身份复用、以及更早一批 NTLM 串用不是同一次修复。**v2.11.60** 和 **v3.7.16** 仍在受影响范围内。

---

## 二、漏洞状态

**统计截止：** 2026 年 11 月 2 日（UTC+8）

| 项目 | 状态 |
|------|------|
| 漏洞细节 | 已公开（Traefik 公告） |
| 受影响版本 | **v2.11.58–v2.11.60**；**v3.7.14–v3.7.16** |
| 官方补丁 | **≥ v2.11.61**；**≥ v3.7.17** |
| 镜像标签 | Hub 上已有 `v2.11.61` 与 `v3.7.17`。今天的 `latest` 与 `v3.7.17` 是同一份镜像 |
| CISA KEV | 未列入 |

| 你现在的版本 | 是否仍受影响 | 升到 |
|--------------|--------------|------|
| v2.11.57 及更早 | 不受这条影响 | 若还要盖此前其它公告，升到 **v2.11.61** |
| v2.11.58–v2.11.60 | 是 | **v2.11.61** |
| v3.7.13 及更早的 v3.7 | 不受这条影响 | 若还要盖此前其它公告，升到 **v3.7.17** |
| v3.7.14–v3.7.16 | 是 | **v3.7.17** |
| v3.0–v3.6 | 不受这条影响 | 停维线请直接迁到 **v3.7.17** |

---

## 三、影响范围

跑着上述受影响版本、并且入口可被不可信客户端访问的 Traefik。不需要有效的 NTLM 或 Kerberos 凭据，也不要求后端真的开了这类认证。

---

## 四、修复建议

v3 升到 **v3.7.17**。v2 升到 **v2.11.61**。不要停在 v3.7.16 或 v2.11.60，也不要把 `latest` 写进长期配置。

```bash
docker pull docker.xuanyuan.run/library/traefik:v3.7.17
```

```bash
docker pull docker.xuanyuan.run/library/traefik:v2.11.61
```

发行说明：[v3.7.17](https://github.com/traefik/traefik/releases/tag/v3.7.17) · [v2.11.61](https://github.com/traefik/traefik/releases/tag/v2.11.61)

**Docker Hub：** [library/traefik](https://hub.docker.com/_/traefik)

**轩辕镜像：** [library/traefik](https://xuanyuan.cloud/r/library/traefik)

---

## 五、临时缓解措施

在升级之前，可在入口挡掉带 `Authorization: NTLM` 或 `Authorization: Negotiate`、且本就不该出现的请求。这只缩小冲击，不能代替 v2.11.61 / v3.7.17。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代 Traefik 的版本修复。`docker pull docker.xuanyuan.run/library/traefik:v3.7.17` 或 `...:v2.11.61` 覆盖本条。今天的 `latest` 与 `v3.7.17` 是同一份镜像，加速拉取 `latest` 以后可能不再锁定在这个版本。此前固定在 v3.7.16 或 v2.11.60 的，要改标签后重新部署。

配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- GitHub：[GHSA-xv5x-242w-7hf7](https://github.com/traefik/traefik/security/advisories/GHSA-xv5x-242w-7hf7)
- 发行说明：[v3.7.17](https://github.com/traefik/traefik/releases/tag/v3.7.17) · [v2.11.61](https://github.com/traefik/traefik/releases/tag/v2.11.61)
- Docker Hub：[library/traefik](https://hub.docker.com/_/traefik)
- 轩辕站内镜像页：[library/traefik](https://xuanyuan.cloud/r/library/traefik)

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/traefik-ghsa-xv5x-242w-7hf7-security-advisory)

---

**轩辕镜像安全团队**  
2026 年 11 月 2 日


