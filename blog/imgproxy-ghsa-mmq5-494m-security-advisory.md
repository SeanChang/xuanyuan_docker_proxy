# 【漏洞预警】imgproxy 再爆高危漏洞，恶意图标能打垮工作进程（GHSA-494m-4556-wf5p）

![【漏洞预警】imgproxy 再爆高危漏洞，恶意图标能打垮工作进程（GHSA-494m-4556-wf5p）](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: imgproxy,GHSA,安全公告,漏洞预警 | 发布时间: 2026-11-01 10:49:26*

> imgproxy 3.3.0 起有两条 ICO 加载问题。一条按文件里的尺寸无界分配内存，工作进程会被打满（GHSA-mmq5-xm89-9pfg，7.5，修复 ≥4.0.16）。另一条在重建位图头时写过分配边界，工作进程崩溃（GHSA-494m-4556-wf5p，7.5，修复 ≥4.0.17）。v4.0.16 盖不住第二条。请继续固定 darthsim/imgproxy:v4.0.20。不要写 latest。

**发布日期：** 2026 年 10 月 31 日  
**风险等级：** 高危（High）  
**漏洞编号：** GHSA-494m-4556-wf5p、GHSA-mmq5-xm89-9pfg（暂无 CVE）  
**涉及镜像：** darthsim/imgproxy — [轩辕镜像](https://xuanyuan.cloud/r/darthsim/imgproxy) · [Docker Hub](https://hub.docker.com/r/darthsim/imgproxy)  
**CVSS：** **7.5**（High，CVSS 3.1，两条相同）  
**披露时间：** v4.0.17 于 2026 年 9 月 30 日推送；v4.0.20 于 2026 年 10 月 26 日推送  
**相关公告：** [GHSA-494m-4556-wf5p](https://github.com/advisories/GHSA-494m-4556-wf5p) · [GHSA-mmq5-xm89-9pfg](https://github.com/advisories/GHSA-mmq5-xm89-9pfg)

---

## 一、漏洞概述

这两条和同日早些时候那条 ICO 整数溢出不是同一项。都出在 ICO 加载器，从 **3.3.0** 起就受影响。

**GHSA-mmq5-xm89-9pfg。** 加载器按 ICO 目录里给出的尺寸直接分配内存，没有上限。一份很小的图标就能让工作进程尝试巨大的分配，把内存耗尽。受影响到 **4.0.15**，修复从 **4.0.16** 起。CVSS 3.1 为 **7.5**。

**GHSA-494m-4556-wf5p。** 图标数据比加载器假设的更短时，重建位图头的写入会越过这块内存，工作进程随后崩溃。**4.0.16** 仍受影响，修复从 **4.0.17** 起。CVSS 3.1 为 **7.5**。

---

## 二、漏洞状态

**统计截止：** 2026 年 10 月 31 日（UTC+8）

| 项目 | 状态 |
|------|------|
| 漏洞细节 | 已公开（imgproxy 公告） |
| 受影响版本 | **3.3.0 至 4.0.15**（内存耗尽）；**低于 4.0.17**（越界崩溃，含 4.0.16） |
| 官方补丁 | 两条一起要 **≥ 4.0.17** |
| 镜像标签 | Hub 上已有 `v4.0.17` 与 `v4.0.20`。`latest` 与 `v4.0.20` 不是同一份镜像 |
| CISA KEV | 未列入 |

已经按早些时候的公告固定在 **v4.0.20** 的实例，这两条也已经盖住，不必再升一个更高标签。

---

## 三、影响范围

公开或内网可达、并且会处理不可信 ICO 的 imgproxy，包括 3.3 线和 4.0.16。不需要登录。

---

## 四、修复建议

升到 **4.0.17** 或更高。请固定 **v4.0.20**。不要停在 v4.0.16，也不要写 `latest`。

```bash
docker pull docker.xuanyuan.run/darthsim/imgproxy:v4.0.20
```

**Docker Hub：** [darthsim/imgproxy](https://hub.docker.com/r/darthsim/imgproxy)

**轩辕镜像：** [darthsim/imgproxy](https://xuanyuan.cloud/r/darthsim/imgproxy)

---

## 五、临时缓解措施

在升级之前，不要把 imgproxy 继续暴露给不可信的图片来源。限制来源不能代替 4.0.17 及以上。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代 imgproxy 的版本修复。`docker pull docker.xuanyuan.run/darthsim/imgproxy:v4.0.20` 同时盖住本公告两条，也盖住早些时候那条整数溢出。加速拉取 `latest` 不会锁定在 v4.0.20。基于更旧标签二次构建的，要改基础标签后重新构建。

配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- GitHub：[GHSA-494m-4556-wf5p](https://github.com/advisories/GHSA-494m-4556-wf5p) · [GHSA-mmq5-xm89-9pfg](https://github.com/advisories/GHSA-mmq5-xm89-9pfg)
- Docker Hub：[darthsim/imgproxy](https://hub.docker.com/r/darthsim/imgproxy)
- 轩辕站内镜像页：[darthsim/imgproxy](https://xuanyuan.cloud/r/darthsim/imgproxy)

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/imgproxy-ghsa-mmq5-494m-security-advisory)

---

**轩辕镜像安全团队**  
2026 年 10 月 31 日


