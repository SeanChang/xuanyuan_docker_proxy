# 【漏洞预警】Instatic 爆高危漏洞，有编辑权限就能改系统表行（GHSA-m425-wmrc-4v4v）

![【漏洞预警】Instatic 爆高危漏洞，有编辑权限就能改系统表行（GHSA-m425-wmrc-4v4v）](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: Instatic,GHSA,安全公告,漏洞预警 | 发布时间: 2026-11-03 22:32:10*

> Instatic 低于 0.0.21 时，PATCH /admin/api/cms/data/rows/:id/author 未走共享授权助手 loadRowForAccess()。只要具备 content.edit.any、没有 data.system.tables.read，就能经 getDataRow() 读取并改写系统表行，包括他人私有或未发布草稿与作者信息（GHSA-m425-wmrc-4v4v，CVSS 3.1 为 7.1；暂无 CVE）。请把 ghcr.io/corebunch/instatic 升到 0.0.21。

**发布日期：** 2026 年 11 月 3 日  
**风险等级：** 高危（High）  
**漏洞编号：** GHSA-m425-wmrc-4v4v（暂无 CVE）  
**涉及镜像：** ghcr.io/corebunch/instatic — [轩辕镜像](https://xuanyuan.cloud/ghcr.io/corebunch/instatic) · [GHCR](https://github.com/CoreBunch/Instatic/pkgs/container/instatic)  
**CVSS：** **7.1**（High，CVSS 3.1：`AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:L/A:N`）  
**披露时间：** 2026 年 11 月 3 日  
**相关公告：** [GHSA-m425-wmrc-4v4v](https://github.com/CoreBunch/Instatic/security/advisories/GHSA-m425-wmrc-4v4v)

---

## 一、漏洞概述

`PATCH /admin/api/cms/data/rows/:id/author` 没有调用共享授权助手 `loadRowForAccess()`，而是直接走 `getDataRow()`。认证用户只要角色里有 `content.edit.any`（或 `content.manage`），即使没有 `data.system.tables.read`，也能读取并改写系统表行，包括他人私有或未发布草稿，以及改写 `authorUserId`。CVSS 3.1 为 **7.1**。暂无 CVE 编号。

这绕过了此前 GHSA-x69h 在 `loadRowForAccess()` 路径上加的系统表边界。

---

## 二、漏洞状态

**统计截止：** 2026 年 11 月 3 日（UTC+8）

| 项目 | 状态 |
|------|------|
| 漏洞细节 | 已公开（GitHub Advisory） |
| 受影响版本 | **< 0.0.21** |
| 官方补丁 | **≥ 0.0.21** |
| 镜像标签 | GHCR 上已有 `ghcr.io/corebunch/instatic:0.0.21` |
| CISA KEV | 未列入 |

---

## 三、影响范围

管理面 API 可达的自托管 Instatic。需要有效账号，且角色含 `content.edit.any`（或 `content.manage`），但不含 `data.system.tables.read`。

---

## 四、修复建议

升到 **0.0.21**。`***` 换成个人中心的专属域前缀。

```bash
docker pull ***-ghcr.xuanyuan.run/corebunch/instatic:0.0.21
```

对 `*-ghcr.xuanyuan.run` **不要** 用 `docker login` 填 GitHub PAT。官方部署说明见 [Docker 镜像文档](https://github.com/CoreBunch/Instatic/blob/main/docs/deployment/docker-image.md)。

**GHCR：** [corebunch/instatic](https://github.com/CoreBunch/Instatic/pkgs/container/instatic)

**轩辕镜像：** [ghcr.io/corebunch/instatic](https://xuanyuan.cloud/ghcr.io/corebunch/instatic)

---

## 五、临时缓解措施

在升级之前：收回不必要的 `content.edit.any` / `content.manage`；限制谁能访问管理面 API。这不能代替 0.0.21。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代 Instatic 的版本修复。请固定 `0.0.21`，不要写浮动标签。基于更旧标签二次构建的，要改基础标签后重新构建。

配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- GitHub：[GHSA-m425-wmrc-4v4v](https://github.com/CoreBunch/Instatic/security/advisories/GHSA-m425-wmrc-4v4v)
- GHCR：[corebunch/instatic](https://github.com/CoreBunch/Instatic/pkgs/container/instatic)
- 轩辕站内镜像页：[ghcr.io/corebunch/instatic](https://xuanyuan.cloud/ghcr.io/corebunch/instatic)

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/instatic-ghsa-m425-wmrc-4v4v-security-advisory)

---

**轩辕镜像安全团队**  
2026 年 11 月 3 日


