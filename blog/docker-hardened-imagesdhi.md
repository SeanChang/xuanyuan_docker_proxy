# 关于 Docker Hardened Images（DHI）无法拉取的说明公告

![关于 Docker Hardened Images（DHI）无法拉取的说明公告](https://img.xuanyuan.dev/docker/blog/docker-dhi.png)

*分类: Docker,公告,DHI | 标签: Docker,公告,DHI,clickhouse-server | 发布时间: 2026-02-25 03:33:29*

> 关于 Docker Hardened Images（DHI）无法拉取的说明公告

近期有部分用户反馈，尝试拉取 dhi 相关镜像时出现 404 not found 错误。经技术排查与协议层分析，现将相关情况说明如下：

## 一、现象说明

目前访问与拉取行为表现为：

- Docker Hub 上 dhi namespace 已无公开仓库；
- 执行 `docker pull dhi/clickhouse-server` 返回 not found

以上情况并非网络异常或镜像故障。

## 二、原因说明

Docker Hardened Images（简称 DHI）已被纳入 Docker 官方企业级 Hardened Images 产品体系。

根据当前访问行为与页面跳转结果：

- dhi.io 已跳转至 Docker Hardened Images Catalog 页面；
- 拉取镜像提示需开启 30 天试用或企业订阅；
- OCI Registry Token 服务拒绝向普通 Docker 账号签发访问凭证。

这表明：

DHI 已不再作为公开 Docker Hub 镜像仓库分发，其镜像访问基于商业授权机制控制。

因此，普通 Docker 账号无法匿名或直接拉取 DHI 相关镜像或 OCI 制品。

## 三、对镜像拉取与代理的影响

由于：

- 上游 Registry 不接受匿名访问；
- 未授权账号无法获取 Bearer Token；
- 镜像 Manifest 与 Blob 均需鉴权；

本服务无法对 DHI 镜像提供：

- 公共加速
- 匿名镜像代理
- 缓存同步

该限制源于上游分发策略调整，并非技术故障。

## 四、如需使用 DHI 的建议方案

如您确实需要 Docker Hardened Images：

- 建议通过 Docker 官方渠道申请试用或企业订阅；
- 确认账号具备 Hardened Images 访问权限；
- 在具备授权后，可通过自有凭证进行私有镜像同步或内部制品管理。

如仅需安全加固基础镜像，也可考虑：

- 官方 LTS 基础镜像
- Distroless 镜像
- 自行构建安全基线镜像并结合扫描工具进行加固

## 五、总结

当前 DHI 无法拉取的原因是 Docker 官方分发策略调整，已转为授权访问模式。

该问题不属于网络异常或镜像服务问题。

如后续 Docker 官方调整分发政策，我们将第一时间跟进并更新支持情况。

感谢您的理解与支持。

——
轩辕镜像技术团队

