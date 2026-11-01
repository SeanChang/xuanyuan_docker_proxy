# 【漏洞预警】Signal K 爆严重漏洞，路径穿越能伪造管理员并执行命令（GHSA-4xm8-rg9h-jhq2）

![【漏洞预警】Signal K 爆严重漏洞，路径穿越能伪造管理员并执行命令（GHSA-4xm8-rg9h-jhq2）](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: Signal K,GHSA,安全公告,漏洞预警 | 发布时间: 2026-10-31 15:58:05*

> Signal K Server 2.0.0 起、低于 2.34.0 的资源和 applicationData 接口存在路径穿越，可以读写存储根以外的文件。读到 JWT 签名密钥后可以伪造管理员令牌，并在服务器上执行命令（GHSA-4xm8-rg9h-jhq2，CVSS 3.1 为 9.8，暂无 CVE）。请把 signalk/signalk-server 固定到 v2.35.1。修复从 v2.34.0 起。今天的 latest 与 v2.35.1 是同一份镜像，不要把 latest 写进长期配置。

**发布日期：** 2026 年 10 月 31 日  
**风险等级：** 严重（Critical）  
**漏洞编号：** GHSA-4xm8-rg9h-jhq2（暂无 CVE）  
**涉及镜像：** signalk/signalk-server — [轩辕镜像](https://xuanyuan.cloud/r/signalk/signalk-server) · [Docker Hub](https://hub.docker.com/r/signalk/signalk-server)  
**CVSS：** **9.8**（Critical，CVSS 3.1）  
**披露时间：** v2.34.0 发布于 2026 年 10 月 18 日；v2.35.1 于 2026 年 10 月 24 日推送  
**相关公告：** [GHSA-4xm8-rg9h-jhq2](https://github.com/SignalK/signalk-server/security/advisories/GHSA-4xm8-rg9h-jhq2)

---

## 一、漏洞概述

Signal K Server **2.0.0 起、低于 2.34.0** 的 resources 和 applicationData 接口没有把路径限制在存储根里。未认证或低权限用户可以读写存储根以外的文件。读到 JWT 签名密钥之后，可以伪造管理员令牌，并在服务器上执行命令。CVSS 3.1 为 **9.8**。NVD 尚未分配 CVE 编号。

随服务器一起修复的 `@signalk/resources-provider` 下限是 **1.5.3**。官方镜像从 **v2.34.0** 起包含这项。

---

## 二、漏洞状态

**统计截止：** 2026 年 10 月 31 日（UTC+8）

| 项目 | 状态 |
|------|------|
| 漏洞细节 | 已公开（Signal K 公告） |
| 受影响版本 | signalk-server **≥ 2.0.0 且低于 2.34.0** |
| 官方补丁 | **≥ 2.34.0** |
| 镜像标签 | Hub 上已有 `v2.34.0`、`v2.34`、`v2.35.1`。`v2.34` 与 `v2.34.0` 是同一份镜像。今天的 `latest` 与 `v2.35.1` 是同一份镜像 |
| CISA KEV | 未列入 |

---

## 三、影响范围

对外提供 Signal K HTTP API 的实例，包括官方镜像 `signalk/signalk-server`。

---

## 四、修复建议

升到 **2.34.0** 或更高。请固定当前的 **v2.35.1**。`v2.34` 今天等于 `v2.34.0`，可以用来达到修复下限，但不要停在更旧的 2.x，也不要把 `latest` 写进长期配置。

```bash
docker pull docker.xuanyuan.run/signalk/signalk-server:v2.35.1
```

**Docker Hub：** [signalk/signalk-server](https://hub.docker.com/r/signalk/signalk-server)

**轩辕镜像：** [signalk/signalk-server](https://xuanyuan.cloud/r/signalk/signalk-server)

发行说明：[v2.34.0](https://github.com/SignalK/signalk-server/releases/tag/v2.34.0)

---

## 五、临时缓解措施

在升级之前，不要把 Signal K 的 HTTP API 继续暴露在不可信网络上。已经怀疑密钥被读走过的实例，升级后轮换 JWT 签名密钥，并作废已发出的管理员令牌。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代 Signal K 的版本修复。`docker pull docker.xuanyuan.run/signalk/signalk-server:v2.35.1` 高于修复下限 v2.34.0。加速拉取 `latest` 不会一直锁定在 v2.35.1。基于更旧标签二次构建的，要改基础标签后重新构建。

配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- GitHub：[GHSA-4xm8-rg9h-jhq2](https://github.com/SignalK/signalk-server/security/advisories/GHSA-4xm8-rg9h-jhq2) · [v2.34.0](https://github.com/SignalK/signalk-server/releases/tag/v2.34.0)
- Docker Hub：[signalk/signalk-server](https://hub.docker.com/r/signalk/signalk-server)
- 轩辕站内镜像页：[signalk/signalk-server](https://xuanyuan.cloud/r/signalk/signalk-server)

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/signalk-ghsa-4xm8-rg9h-jhq2-security-advisory)

---

**轩辕镜像安全团队**  
2026 年 10 月 31 日


