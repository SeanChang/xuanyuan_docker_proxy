# 【漏洞预警】Dell Container Storage Modules 多个高危与严重漏洞（DSA-2026-448）

![【漏洞预警】Dell Container Storage Modules 多个高危与严重漏洞（DSA-2026-448）](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: Dell, CSM, CVE, 安全公告, 漏洞预警, Kubernetes, CSI, Quay | 发布时间: 2026-10-07 11:30:51*

> Dell Container Storage Modules 1.18.0 之前一次披露 10 个高危或严重漏洞（DSA-2026-448）。其中 csm-authorization-storage 的 gRPC 服务没有认证，未认证攻击者可以拿到已注册存储阵列的管理员凭据（CVE-2026-63688，CVSS 10.0）。请升级到 CSM 1.18.0 及公告中的对应组件版本。官方镜像在 Quay.io。

**发布日期：** 2026 年 10 月 7 日  
**风险等级：** 严重（Critical）  
**漏洞编号：** CVE-2026-63688 · CVE-2026-63692 · CVE-2026-67269 · CVE-2026-54472 · CVE-2026-61421 · CVE-2026-67273 · CVE-2026-67270 · CVE-2026-61411 · CVE-2026-76105 · CVE-2026-70411  
**涉及镜像：** quay.io/dell/container-storage-modules/csm-authorization-proxy — [Quay](https://quay.io/repository/dell/container-storage-modules/csm-authorization-proxy)  
**CVSS：** 最高 **10.0**（Critical）  
**披露时间：** Dell 安全公告 DSA-2026-448  
**相关公告：** [Dell DSA-2026-448](https://www.dell.com/support/kbdoc/en-us/000515771/dsa-2026-448-security-update-for-dell-container-storage-modules-multiple-vulnerabilities)

---

## 一、漏洞概述

Dell Container Storage Modules（CSM）是 Dell 为 Kubernetes 提供的容器存储组件，包括 Authorization、Operator，以及 PowerFlex、PowerMax、PowerStore 等 CSI 驱动。这些组件以容器镜像部署，并掌握后端存储阵列的管理员凭据。

版本低于 1.18.0 时，Dell 在 DSA-2026-448 中一次披露 10 个高危或严重问题。风险最高的两条是：`csm-authorization-storage` 的 gRPC 服务没有认证，未认证的远程攻击者可以拿到所有已注册存储阵列的管理员凭据（CVE-2026-63688，CVSS 10.0）；另一处关键功能同样缺少认证，可导致提权（CVE-2026-63692，CVSS 10.0）。

CSM Operator 在处理自定义资源时权限管理不当，低权限用户可以拿到集群节点的 root（CVE-2026-67269，CVSS 9.9）。`csm-docs` 和 CSM Authorization 中存在硬编码凭据（CVE-2026-54472、CVE-2026-61421，均为 9.8）。其余问题包括模板注入、证书校验不当、日志写入敏感信息、随机数强度不足，以及 tenant gRPC 服务缺少认证。

使用这些组件的 Kubernetes 集群都在影响范围内。阵列管理员凭据一旦泄露，影响会超出集群，到达后端存储。

---

## 二、漏洞状态

**统计截止：** 2026 年 10 月 7 日（UTC+8）

| 项目 | 状态 |
|------|------|
| 漏洞细节 | 已由 Dell DSA-2026-448 披露 |
| 受影响版本 | CSM **低于 1.18.0** |
| 官方修复 | **CSM 1.18.0** 及公告列出的对应组件版本 |
| 官方镜像 | Quay：`quay.io/dell/container-storage-modules/` |
| CISA KEV | 未列入 |

组件版本以 [DSA-2026-448](https://www.dell.com/support/kbdoc/en-us/000515771/dsa-2026-448-security-update-for-dell-container-storage-modules-multiple-vulnerabilities) 为准，不要只升级其中一个容器。

---

## 三、影响范围

### 1. 十条漏洞

| CVE | CVSS | 问题 |
|-----|------|------|
| CVE-2026-63688 | 10.0 | `csm-authorization-storage` 的 gRPC 没有认证，可取得已注册存储阵列的管理员凭据 |
| CVE-2026-63692 | 10.0 | 关键功能缺少认证，可导致提权 |
| CVE-2026-67269 | 9.9 | CSM Operator 处理自定义资源时权限管理不当，低权限用户可获得集群节点 root |
| CVE-2026-54472 | 9.8 | `csm-docs` 中的硬编码凭据 |
| CVE-2026-61421 | 9.8 | CSM Authorization 中的硬编码凭据 |
| CVE-2026-67273 | 9.6 | 模板注入 |
| CVE-2026-67270 | 8.2 | proxy-server 证书校验不当，相邻网络内可泄露存储管理员凭据 |
| CVE-2026-61411 | 7.7 | 日志中写入敏感信息 |
| CVE-2026-76105 | 7.7 | 随机数强度不足 |
| CVE-2026-70411 | 7.1 | tenant gRPC 服务缺少认证 |

### 2. 典型受影响场景

- 集群安装了 Dell CSM Authorization、Operator 或 PowerFlex / PowerMax / PowerStore CSI 驱动，版本低于 1.18.0
- Authorization 的 gRPC 或 proxy-server 能从集群网络、相邻网络到达
- 这些 Pod 保存着后端存储阵列的管理员凭据

---

## 四、修复建议

### 1. 升级到 CSM 1.18.0 及对应组件版本（推荐）

按 Dell 公告把 CSM 升到 **1.18.0**，并逐项核对 Authorization、Operator 和各 CSI 驱动是否达到公告中的组件版本。只更换单个镜像不能覆盖全部十条。

官方镜像在 Quay，命名空间为 `dell/container-storage-modules`。示例：

[quay.io/dell/container-storage-modules/csm-authorization-proxy](https://quay.io/repository/dell/container-storage-modules/csm-authorization-proxy)

Docker Hub 上的 `dellemc/*` 镜像在 2025 年已停止更新，不能当作这次修复的来源。升级时使用 Quay 上的官方仓库，并把清单里的镜像标签改成公告要求的 1.18.0 对应版本，再滚动更新工作负载。

### 2. 升级后轮换凭据

1. 轮换已注册存储阵列的管理员凭据，以及 CSM Authorization、`csm-docs` 中可能仍在使用的内置凭据。
2. 检查阵列与集群审计日志，查看升级前是否有未经授权的管理操作。
3. 确认 Authorization 与 tenant 的 gRPC 只对预期的 Pod 网络开放。

---

## 五、临时缓解措施

在完成升级之前：

1. **限制 gRPC 与 proxy-server 的网络**  
   只允许 CSM 自身的 Pod 访问 Authorization 和 tenant 的 gRPC。proxy-server 不要暴露到相邻的不受信网段。CVE-2026-67270 的凭据泄露发生在相邻网络。

2. **收紧谁可以创建或修改 CSM 的自定义资源**  
   CVE-2026-67269 允许低权限用户借助 Operator 获得节点 root。集群 RBAC 中不要把这类 CR 交给普通租户。

3. **假定低于 1.18.0 的硬编码凭据已经公开**  
   在升级窗口之前轮换阵列管理员密码，并缩短这些凭据的使用范围。

网络隔离和轮换凭据不能代替 1.18.0 中的认证与权限修复。

---

## 六、与轩辕镜像用户的相关说明

这次修复使用 Quay 上的 Dell 官方镜像。Docker Hub 上已停止更新的 `dellemc/*` 副本不作为修复来源。

轩辕镜像的加速服务不替代 CSM 版本升级和阵列凭据轮换。其他已在站内提供详情页的镜像，配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)。

---

## 七、参考链接

- Dell：[DSA-2026-448](https://www.dell.com/support/kbdoc/en-us/000515771/dsa-2026-448-security-update-for-dell-container-storage-modules-multiple-vulnerabilities)
- Quay：[csm-authorization-proxy](https://quay.io/repository/dell/container-storage-modules/csm-authorization-proxy)
- NVD：[CVE-2026-63688](https://nvd.nist.gov/vuln/detail/CVE-2026-63688) · [CVE-2026-63692](https://nvd.nist.gov/vuln/detail/CVE-2026-63692) · [CVE-2026-67269](https://nvd.nist.gov/vuln/detail/CVE-2026-67269) · [CVE-2026-54472](https://nvd.nist.gov/vuln/detail/CVE-2026-54472) · [CVE-2026-61421](https://nvd.nist.gov/vuln/detail/CVE-2026-61421) · [CVE-2026-67273](https://nvd.nist.gov/vuln/detail/CVE-2026-67273) · [CVE-2026-67270](https://nvd.nist.gov/vuln/detail/CVE-2026-67270) · [CVE-2026-61411](https://nvd.nist.gov/vuln/detail/CVE-2026-61411) · [CVE-2026-76105](https://nvd.nist.gov/vuln/detail/CVE-2026-76105) · [CVE-2026-70411](https://nvd.nist.gov/vuln/detail/CVE-2026-70411)

---

**轩辕镜像安全团队**  
2026 年 10 月 7 日


