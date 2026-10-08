# 【漏洞预警】Harbor webhook SSRF、镜像路径穿越与认证代理管理员越权

![【漏洞预警】Harbor webhook SSRF、镜像路径穿越与认证代理管理员越权](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: Harbor, GHSA, 安全公告, 漏洞预警, SSRF, 路径穿越, Docker | 发布时间: 2026-10-08 12:38:02*

> Harbor 低于 2.13.6、2.14.0 至 2.14.4、2.15.0 至 2.15.2 存在三条高危问题：项目管理员可将 webhook 指向内网并读到错误响应（GHSA-2phj-cp9f-qq6w，CVSS 8.5）；/v2/ 路径中的 .. 可跨项目读写 manifest（GHSA-qj39-pjf2-wmrc，CVSS 8.3）；HTTP 认证代理下名为 admin 的用户会获得仓库管理员权限（GHSA-xvh7-74g6-29xw，CVSS 7.5）。请升级到 2.13.6、2.14.5 或 2.15.3。暂无 CVE 编号。

**发布日期：** 2026 年 10 月 8 日  
**风险等级：** 高危（High）  
**漏洞编号：** 暂无 CVE 编号 · [GHSA-2phj-cp9f-qq6w](https://github.com/goharbor/harbor/security/advisories/GHSA-2phj-cp9f-qq6w) · [GHSA-qj39-pjf2-wmrc](https://github.com/goharbor/harbor/security/advisories/GHSA-qj39-pjf2-wmrc) · [GHSA-xvh7-74g6-29xw](https://github.com/goharbor/harbor/security/advisories/GHSA-xvh7-74g6-29xw)  
**涉及镜像：** goharbor/harbor-jobservice — [轩辕镜像](https://xuanyuan.cloud/r/goharbor/harbor-jobservice) · [Docker Hub](https://hub.docker.com/r/goharbor/harbor-jobservice) · goharbor/harbor-core — [轩辕镜像](https://xuanyuan.cloud/r/goharbor/harbor-core) · [Docker Hub](https://hub.docker.com/r/goharbor/harbor-core)  
**CVSS：** **8.5** · **8.3** · **7.5**（均为 High）  
**披露时间：** 三条公告发布于 2026 年 10 月 6 日；webhook 一条于 2026 年 10 月 7 日上调为高危  
**相关公告：** [GHSA-2phj-cp9f-qq6w](https://github.com/goharbor/harbor/security/advisories/GHSA-2phj-cp9f-qq6w) · [GHSA-qj39-pjf2-wmrc](https://github.com/goharbor/harbor/security/advisories/GHSA-qj39-pjf2-wmrc) · [GHSA-xvh7-74g6-29xw](https://github.com/goharbor/harbor/security/advisories/GHSA-xvh7-74g6-29xw)

---

## 一、漏洞概述

下面三条都落在 Harbor，修复版本与系统机器人越权（GHSA-w5fq-xrhj-j7g2、GHSA-xq2m-cj8w-56v5）以及 CVE-2026-92770 相同。升到所在发行线的修复版本，可以一次盖住这几条。三条目前都没有 CVE 编号。

### 1. GHSA-2phj-cp9f-qq6w：webhook 指向内网（High，8.5）

项目管理员可以把 HTTP 或 Slack webhook 指向内网地址，包括 localhost、私有网段、链路本地地址，以及云元数据地址 `169.254.169.254`。事件触发时，jobservice 会从部署内部向该地址发请求。目标返回错误状态时，响应内容会写进项目成员能看到的执行日志。

厂商于 2026 年 10 月 7 日把这条从中危上调为高危。受影响的是 **1.7.0 及以后、低于对应修复版** 的版本。默认允许所有人创建项目时，注册用户就能成为项目管理员。jobservice 还能访问内网或云元数据时，影响最大。

升级之后，指向私有、回环和链路本地地址的 webhook 会被拒绝，已经存在的这类目标也会停止发送。如果业务确实要把 webhook 发到集群内部，需要显式打开例外：`harbor.yml` 安装设置 `network.allow_private_network_access: true` 后重新执行 prepare；Helm 或其他部署则在 **core 和 jobservice** 上都设置环境变量 `HARBOR_ALLOW_PRIVATE_NETWORK_ACCESS=true`。打开之后，这层限制就不再生效，只应在信任全部项目管理员时使用。

### 2. GHSA-qj39-pjf2-wmrc：/v2/ 路径穿越（High，8.3）

Harbor 做权限检查时看的是原始请求路径，真正处理之前会先解析路径里的 `..`。攻击者可以用一个自己有权访问的仓库通过检查，实际操作的却是另一个项目的仓库。受影响的是对 manifest 的读取、推送和删除。

只要实例里有一个公开项目，任何人不用登录就能读取所有项目的镜像 manifest，包括私有项目。在任一项目有推送权限的用户，都能修改或删除任意项目的 tag 和 manifest。默认设置下所有用户都能建项目，也就都有推送权限。对公网开放的仓库风险最高。

升级之后，路径里含 `.` 或 `..` 段的 `/v2/` 请求会返回 HTTP 400。Docker、containerd、Podman 等正常客户端不会发送这种路径。

### 3. GHSA-xvh7-74g6-29xw：认证代理下的 admin 用户名（High，7.5）

只影响 `auth_mode = http_auth`。Harbor 按用户名查找同名的本地用户。如果这个本地用户是系统管理员，发到 `/v2/` 的请求就按管理员处理，不管身份提供方有没有授予管理员权限。内置本地 `admin` 账号一定存在，所以身份提供方里任何叫 `admin` 的用户，以及其他与本地系统管理员同名的用户，都会拿到镜像仓库的管理员权限。

可以拉取、推送、删除所有项目的镜像，包括私有项目。Web 界面和 `/api/v2.0` 不受影响。使用 database、LDAP、UAA 或 OIDC 认证的部署不受影响。

升级之后，`http_auth` 模式下 `/v2/` 的管理员权限只来自 `http_authproxy_admin_usernames` 和 `http_authproxy_admin_groups`。如果之前依赖 Harbor 界面里的本地管理员标记，要把这些用户或用户组写进认证代理的管理员设置。

---

## 二、漏洞状态

**统计截止：** 2026 年 10 月 8 日（UTC+8）

| 项目 | webhook SSRF | 路径穿越 | 认证代理 admin |
|------|--------------|----------|----------------|
| 公告 | GHSA-2phj-cp9f-qq6w | GHSA-qj39-pjf2-wmrc | GHSA-xvh7-74g6-29xw |
| CVSS | 8.5 | 8.3 | 7.5 |
| 受影响版本 | ≥ 1.7.0 且低于修复版 | < 2.13.6；2.14.0–2.14.4；2.15.0–2.15.2 | 同路径穿越 |
| 修复 | **2.13.6**、**2.14.5**、**2.15.3**，以及 **2.16.0** 及以上 | 同左 | 同左 |
| CISA KEV | 未列入 | 未列入 | 未列入 |

---

## 三、影响范围

Harbor 由 core、jobservice、portal 等多个镜像组成。webhook 由 jobservice 发出，路径检查和认证代理落在 core 处理的 `/v2/` 上。升级时整套 `goharbor/harbor-*` 使用同一发行版本。

Docker Hub 上 `goharbor/harbor-core` 与 `goharbor/harbor-jobservice` 已有 **v2.13.6**、**v2.14.5**、**v2.15.3**。公告中的 **2.16.0** 及以上同样是修复版本。

---

## 四、修复建议

### 1. 升级到所在发行线的修复版本（推荐）

| 当前发行线 | 最低修复版本 | Hub 标签 |
|------------|--------------|----------|
| 2.13 及更早仍在维护的 2.13 线 | **2.13.6** | `v2.13.6` |
| 2.14 | **2.14.5** | `v2.14.5` |
| 2.15 | **2.15.3** | `v2.15.3` |
| 2.16 及以上 | **2.16.0** 或更高 | 以安装渠道为准 |

**轩辕镜像：** [goharbor/harbor-jobservice](https://xuanyuan.cloud/r/goharbor/harbor-jobservice) · [goharbor/harbor-core](https://xuanyuan.cloud/r/goharbor/harbor-core)

以 2.15 线为例：

```bash
docker pull docker.xuanyuan.run/goharbor/harbor-core:v2.15.3
docker pull docker.xuanyuan.run/goharbor/harbor-jobservice:v2.15.3
```

portal 等其余组件使用同一个版本标签，再按 Helm chart 或安装脚本滚动升级。

需要继续向内网发 webhook 时，升级后再按第一节打开 `HARBOR_ALLOW_PRIVATE_NETWORK_ACCESS`。云元数据地址 `169.254.169.254` 仍然不要对 jobservice 放行。

### 2. 升级后核对

1. 查看现有 webhook 目标里有没有内网地址、localhost 或 `169.254.169.254`。
2. 在代理或 nginx 访问日志里搜索含 `/../`、`/./`、`%2e` 的 `/v2/` 请求。正常客户端不会发这类请求。
3. 若使用 HTTP 认证代理，执行下面的查询，确认身份提供方里没有与这些本地管理员同名的账号，并在审计日志里核查这些用户名的推送和删除：

```sql
SELECT user_id, username FROM harbor_user WHERE sysadmin_flag = true;
```

---

## 五、临时缓解措施

在完成升级之前：

1. **把项目创建改成仅管理员**  
   这样不可信用户不能自行成为项目管理员。已经是项目管理员的账户仍然可以配置 webhook，也仍然可以在自己有推送权限的项目上触发路径穿越写入。

2. **限制 jobservice 的出站**  
   只允许它访问你真正使用的 webhook 目标。一律阻断 `169.254.169.254`。云主机上启用需要令牌的元数据接口（如 AWS IMDSv2）。

3. **在反向代理或 Ingress 上拒绝异常的 /v2/ 路径**  
   拦截路径中含 `/../`、`/./` 或百分号编码 `%2e` 的 `/v2/` 请求。不需要公开的项目改为私有。改为私有只能挡住匿名读取，挡不住已有推送权限的写入。

4. **认证代理部署先保留 admin 这个用户名**  
   不要让身份提供方签发用户名为 `admin` 的身份，并核对其余本地系统管理员是否在身份提供方里有同名账号。database、LDAP、UAA、OIDC 部署不受认证代理这一条影响。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代你对 Harbor 发行版的升级。

- 站内页：[goharbor/harbor-core](https://xuanyuan.cloud/r/goharbor/harbor-core)、[goharbor/harbor-jobservice](https://xuanyuan.cloud/r/goharbor/harbor-jobservice)。拉取命令形如 `docker.xuanyuan.run/goharbor/harbor-core:v2.15.3`。
- 加速拉取不会自动变成安全版本。整套组件固定到 **v2.13.6**、**v2.14.5** 或 **v2.15.3**。
- 配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- webhook SSRF：[GHSA-2phj-cp9f-qq6w](https://github.com/goharbor/harbor/security/advisories/GHSA-2phj-cp9f-qq6w)
- 路径穿越：[GHSA-qj39-pjf2-wmrc](https://github.com/goharbor/harbor/security/advisories/GHSA-qj39-pjf2-wmrc)
- 认证代理：[GHSA-xvh7-74g6-29xw](https://github.com/goharbor/harbor/security/advisories/GHSA-xvh7-74g6-29xw)
- 同一批修复版本中的机器人越权：[GHSA-w5fq-xrhj-j7g2](https://github.com/goharbor/harbor/security/advisories/GHSA-w5fq-xrhj-j7g2) · [GHSA-xq2m-cj8w-56v5](https://github.com/goharbor/harbor/security/advisories/GHSA-xq2m-cj8w-56v5)
- Docker Hub：[harbor-core](https://hub.docker.com/r/goharbor/harbor-core) · [harbor-jobservice](https://hub.docker.com/r/goharbor/harbor-jobservice)
- 轩辕站内镜像页：[harbor-core](https://xuanyuan.cloud/r/goharbor/harbor-core) · [harbor-jobservice](https://xuanyuan.cloud/r/goharbor/harbor-jobservice)
- 项目主页：<https://github.com/goharbor/harbor>

---

**轩辕镜像安全团队**  
2026 年 10 月 8 日


