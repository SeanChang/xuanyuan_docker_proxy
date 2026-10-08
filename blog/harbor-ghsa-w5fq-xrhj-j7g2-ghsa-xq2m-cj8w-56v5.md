# 【漏洞预警】Harbor 系统机器人账户越权（GHSA-w5fq-xrhj-j7g2 / GHSA-xq2m-cj8w-56v5）

![【漏洞预警】Harbor 系统机器人账户越权（GHSA-w5fq-xrhj-j7g2 / GHSA-xq2m-cj8w-56v5）](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: Harbor, GHSA, 安全公告, 漏洞预警, 机器人账户, 越权, Docker | 发布时间: 2026-10-07 11:33:01*

> Harbor 低于 2.13.6、2.14.0 至 2.14.4、2.15.0 至 2.15.2 时，带有 User: Update 的系统机器人可以改任意用户的系统管理员标记；勾选覆盖所有项目并带有 Project 权限的系统机器人会变成全局权限（两条均为 High，CVSS 7.2，暂无 CVE 编号）。请升级到 2.13.6、2.14.5 或 2.15.3。同一批版本也修复了 CVE-2026-92770。

**发布日期：** 2026 年 10 月 7 日  
**风险等级：** 高危（High）  
**漏洞编号：** 暂无 CVE 编号 · [GHSA-w5fq-xrhj-j7g2](https://github.com/goharbor/harbor/security/advisories/GHSA-w5fq-xrhj-j7g2) · [GHSA-xq2m-cj8w-56v5](https://github.com/goharbor/harbor/security/advisories/GHSA-xq2m-cj8w-56v5)  
**涉及镜像：** goharbor/harbor-core — [轩辕镜像](https://xuanyuan.cloud/r/goharbor/harbor-core) · [Docker Hub](https://hub.docker.com/r/goharbor/harbor-core)  
**CVSS：** **7.2**（High，CVSS 3.1）· **7.2**（High，CVSS 3.1）  
**披露时间：** 两条 GitHub Security Advisory 均发布于 2026 年 10 月 6 日  
**相关公告：** [GHSA-w5fq-xrhj-j7g2](https://github.com/goharbor/harbor/security/advisories/GHSA-w5fq-xrhj-j7g2) · [GHSA-xq2m-cj8w-56v5](https://github.com/goharbor/harbor/security/advisories/GHSA-xq2m-cj8w-56v5)

---

## 一、漏洞概述

Harbor 是常见的私有容器镜像仓库。系统管理员可以创建系统级机器人账户，把令牌交给 CI 或同步任务使用。下面两条都只在这种机器人已经被建好、而且令牌落到不完全可信的地方时才会被利用。普通项目机器人不在范围内。

### 1. GHSA-w5fq-xrhj-j7g2：User: Update 可改系统管理员标记（High，7.2）

拥有 User: Update 权限的系统级机器人，可以给任意用户设置或取消系统管理员标记。持有该令牌的人能把自己控制的账号提成管理员，也能撤掉真正管理员的权限，从而接管整个 Harbor。

只有系统管理员能创建这种机器人。升级之后，更改管理员标记只允许系统管理员操作；仍带有 User: Update 的机器人做这一项会收到 HTTP 403，其余用户更新操作保持原样。如果自动化任务本来靠机器人授予或取消管理员，升级后要改用管理员账户。

### 2. GHSA-xq2m-cj8w-56v5：覆盖所有项目的 Project 权限扩散成全局权限（High，7.2）

勾选了「覆盖所有项目」（Cover all projects），并且带有 Project 资源权限（读、更新或删除）的系统机器人，该权限会扩散成全局通配，而不只作用于项目本身。

例如只授予「Project: Update」时，这个机器人还能更新任意项目里的机器人账户、成员、仓库和其他资源，包括修改项目机器人的权限、重置它们的密钥，从而接管这些机器人并把它的所有者锁在外面。「Project: Read」可以读到未单独授权的资源，「Project: Delete」可以删除任意项目内部的资源。

只绑定到具体项目的机器人不受影响。升级之后，这类机器人的 Project 权限只作用于项目本身。如果仍需要拉取仓库或删除制品，要单独授予 Repository、Artifact 等具体权限。

同一批修复版本也包含此前 CVE-2026-92770（扫描仪凭据可被过滤条件逐字符推出）的官方修复。升级后如果不可信用户能创建项目，轮换扫描仪适配器凭据。

---

## 二、漏洞状态

**统计截止：** 2026 年 10 月 7 日（UTC+8）

| 项目 | GHSA-w5fq-xrhj-j7g2 | GHSA-xq2m-cj8w-56v5 |
|------|---------------------|---------------------|
| 风险 | High（7.2，CVSS 3.1） | High（7.2，CVSS 3.1） |
| 类型 | 错误的权限分配（CWE-266 / CWE-269） | 权限管理与授权错误（CWE-269 / CWE-732 / CWE-863） |
| CVE 编号 | 暂无 | 暂无 |
| 受影响版本 | **< 2.13.6**；**2.14.0–2.14.4**；**2.15.0–2.15.2** | 同左 |
| 官方修复 | **2.13.6**、**2.14.5**、**2.15.3**，以及 **2.16.0** 及以上 | 同左 |
| CISA KEV | 未列入 | 未列入 |

---

## 三、影响范围

### 1. 版本与发行形态

| 发行形态 | 受影响范围 | 修复 |
|----------|------------|------|
| Harbor 发行版 | 低于 2.13.6；2.14.0 至 2.14.4；2.15.0 至 2.15.2 | 升到所在发行线的 **2.13.6**、**2.14.5** 或 **2.15.3**；公告亦将 **2.16.0** 及以上列为修复版本 |
| 官方镜像 `goharbor/harbor-core` | 与上表相同的发行版本 | Docker Hub 已有标签 **v2.13.6**、**v2.14.5**、**v2.15.3** |

Harbor 由 core、portal、jobservice 等多个镜像组成。升级时整套组件使用同一发行版本，不要只更换 `harbor-core`。

### 2. 典型受影响场景

- 系统管理员创建了带 User: Update 的系统机器人，令牌放在用户开通或同步任务里（第一条）
- 系统管理员创建了「覆盖所有项目」且带 Project 权限的系统机器人，令牌放在 CI 里（第二条）
- 令牌的持有者不完全可信，或令牌可能已泄露

没有这类系统机器人时，这两条的直接暴露面很小。仍应升级，因为同一版本也修复 CVE-2026-92770。

---

## 四、修复建议

### 1. 升级到所在发行线的修复版本（推荐）

| 当前发行线 | 最低修复版本 | Hub 标签 |
|------------|--------------|----------|
| 2.13 | **2.13.6** | `v2.13.6` |
| 2.14 | **2.14.5** | `v2.14.5` |
| 2.15 | **2.15.3** | `v2.15.3` |
| 2.16 及以上 | **2.16.0** 或更高 | 以你使用的安装渠道为准 |

**Docker Hub：** [goharbor/harbor-core](https://hub.docker.com/r/goharbor/harbor-core)

**轩辕镜像：** [goharbor/harbor-core](https://xuanyuan.cloud/r/goharbor/harbor-core)

以 2.15 线为例：

```bash
docker pull docker.xuanyuan.run/goharbor/harbor-core:v2.15.3
```

portal、jobservice 等其余 `goharbor/harbor-*` 组件使用同一个版本标签，再按你的 Helm chart 或 Compose 滚动升级。

### 2. 升级后核对机器人

1. 列出仍具有系统管理员标记的用户，确认每一名都是预期账户。
2. 收回系统机器人上不必要的 User: Update。
3. 收回「覆盖所有项目」机器人上不必要的 Project 权限；仍需要仓库或制品权限时，改授具体资源。
4. 轮换这些机器人的密钥。
5. 若不可信用户能够创建项目，同时轮换扫描仪适配器凭据（CVE-2026-92770）。

---

## 五、临时缓解措施

在完成升级之前：

1. **收回多余权限**  
   系统机器人如果不需要修改用户，去掉 User: Update。如果不需要改项目本身，去掉「覆盖所有项目」上的 Project 权限。

2. **轮换密钥并限制持有者**  
   令牌曾经放在 CI、同步任务或共享变量里时，轮换密钥，只留给可信的任务运行环境。

3. **核对管理员名单**  
   出现无法解释的系统管理员，或项目机器人的权限、过期时间和密钥被改过时，按失陷处理：撤掉异常管理员、轮换相关机器人密钥。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代你对 Harbor 发行版和机器人权限的升级。

- 站内页：[goharbor/harbor-core](https://xuanyuan.cloud/r/goharbor/harbor-core)。拉取命令形如 `docker.xuanyuan.run/goharbor/harbor-core:v2.15.3`，标签换成你所在发行线的修复版本。
- 加速拉取不会自动变成安全版本。整套 `goharbor/harbor-*` 组件要一起固定到 **v2.13.6**、**v2.14.5** 或 **v2.15.3**。
- 配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- GitHub Security Advisory：[GHSA-w5fq-xrhj-j7g2](https://github.com/goharbor/harbor/security/advisories/GHSA-w5fq-xrhj-j7g2) · [GHSA-xq2m-cj8w-56v5](https://github.com/goharbor/harbor/security/advisories/GHSA-xq2m-cj8w-56v5)
- 同一批修复版本中的扫描仪凭据问题：[GHSA-vwvv-675v-p6rr](https://github.com/goharbor/harbor/security/advisories/GHSA-vwvv-675v-p6rr)（CVE-2026-92770）
- Docker Hub：[goharbor/harbor-core](https://hub.docker.com/r/goharbor/harbor-core)
- 轩辕站内镜像页：[goharbor/harbor-core](https://xuanyuan.cloud/r/goharbor/harbor-core)
- 项目主页：<https://github.com/goharbor/harbor>

---

**轩辕镜像安全团队**  
2026 年 10 月 7 日


