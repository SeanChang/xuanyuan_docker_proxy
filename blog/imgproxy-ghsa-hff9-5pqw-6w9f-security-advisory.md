# 【漏洞预警】imgproxy 爆严重漏洞，恶意图标文件可能在服务里执行代码（GHSA-hff9-5pqw-6w9f）

![【漏洞预警】imgproxy 爆严重漏洞，恶意图标文件可能在服务里执行代码（GHSA-hff9-5pqw-6w9f）](https://imgs.xuanyuan.cloud/docker/blog/docker-security-1.webp)

*分类: Docker漏洞预警 | 标签: imgproxy,GHSA,安全公告,漏洞预警 | 发布时间: 2026-10-31 15:57:44*

> imgproxy 4.0.0 至 4.0.15 的 ICO 加载器存在整数溢出，可造成堆溢出。网络可达的实例处理恶意 ICO 时可能被拒绝服务，并可能执行代码（GHSA-hff9-5pqw-6w9f，CVSS 3.1 为 9.8，暂无 CVE）。请把 darthsim/imgproxy 固定到 v4.0.20。修复从 v4.0.16 起。不要写 latest，它和 v4.0.20 不是同一份镜像。

**发布日期：** 2026 年 10 月 31 日  
**更新日期：** 2026 年 10 月 31 日  
**更新内容：** 已经固定的 **v4.0.20** 也覆盖 ICO 无界分配（GHSA-mmq5-xm89-9pfg，下限 4.0.16）和 ICO 位图头越界（GHSA-494m-4556-wf5p，下限 **4.0.17**）。不必再升更高标签。停在 **v4.0.16** 的实例第二条仍在，请改到 v4.0.20。详见 [imgproxy ICO 拒绝服务预警](https://xuanyuan.cloud/blog/imgproxy-ghsa-mmq5-494m-security-advisory)。  
**风险等级：** 严重（Critical）  
**漏洞编号：** GHSA-hff9-5pqw-6w9f（暂无 CVE）  
**涉及镜像：** darthsim/imgproxy — [轩辕镜像](https://xuanyuan.cloud/r/darthsim/imgproxy) · [Docker Hub](https://hub.docker.com/r/darthsim/imgproxy)  
**CVSS：** **9.8**（Critical，CVSS 3.1）  
**披露时间：** v4.0.16 发布于 2026 年 9 月 28 日；v4.0.20 于 2026 年 10 月 26 日推送  
**相关公告：** [GHSA-hff9-5pqw-6w9f](https://github.com/imgproxy/imgproxy/security/advisories/GHSA-hff9-5pqw-6w9f)

---

## 一、漏洞概述

imgproxy **4.0.0 至 4.0.15** 在加载 ICO 时发生整数溢出，进而造成堆溢出。只要服务能被访问到，处理一份恶意 ICO 就可能把进程打垮，并可能在服务进程里执行代码。不需要登录。CVSS 3.1 为 **9.8**。NVD 尚未分配 CVE 编号。

---

## 二、漏洞状态

**统计截止：** 2026 年 10 月 31 日（UTC+8）

| 项目 | 状态 |
|------|------|
| 漏洞细节 | 已公开（imgproxy 公告） |
| 受影响版本 | **4.0.0–4.0.15** |
| 官方补丁 | **≥ 4.0.16** |
| 镜像标签 | Hub 上已有 `v4.0.16` 与 `v4.0.20`。`latest` 与 `v4.0.20` 不是同一份镜像 |
| CISA KEV | 未列入 |

---

## 三、影响范围

公开或内网可达的 imgproxy，包括官方镜像 `darthsim/imgproxy`。调用方只要能让服务去处理 ICO 即可触发。

---

## 四、修复建议

升到 **4.0.16** 或更高。请固定当前的 **v4.0.20**，不要写 `latest`，也不要停在 v4.0.15 或更低的 4.0 标签。

```bash
docker pull docker.xuanyuan.run/darthsim/imgproxy:v4.0.20
```

**Docker Hub：** [darthsim/imgproxy](https://hub.docker.com/r/darthsim/imgproxy)

**轩辕镜像：** [darthsim/imgproxy](https://xuanyuan.cloud/r/darthsim/imgproxy)

发行说明：[v4.0.16](https://github.com/imgproxy/imgproxy/releases/tag/v4.0.16)

---

## 五、临时缓解措施

在升级之前，不要把 imgproxy 继续暴露给不可信的图片来源。限制来源不能代替 4.0.16 及以上。

---

## 六、与轩辕镜像用户的相关说明

轩辕镜像提供的是镜像加速与拉取服务，不替代 imgproxy 的版本修复。`docker pull docker.xuanyuan.run/darthsim/imgproxy:v4.0.20` 高于修复下限 v4.0.16。加速拉取 `latest` 不会锁定在 v4.0.20。基于更旧标签二次构建的，要改基础标签后重新构建。

配置与排错见 [轩辕镜像使用手册](https://xuanyuan.cloud/usage)、[镜像拉取 FAQ](https://xuanyuan.cloud/faq)。

---

## 七、参考链接

- GitHub：[GHSA-hff9-5pqw-6w9f](https://github.com/imgproxy/imgproxy/security/advisories/GHSA-hff9-5pqw-6w9f) · [v4.0.16](https://github.com/imgproxy/imgproxy/releases/tag/v4.0.16)
- Docker Hub：[darthsim/imgproxy](https://hub.docker.com/r/darthsim/imgproxy)
- 轩辕站内镜像页：[darthsim/imgproxy](https://xuanyuan.cloud/r/darthsim/imgproxy)

## 阅读原文

- [轩辕镜像官方博客](https://xuanyuan.cloud/blog/imgproxy-ghsa-hff9-5pqw-6w9f-security-advisory)

---

**轩辕镜像安全团队**  
2026 年 10 月 31 日


