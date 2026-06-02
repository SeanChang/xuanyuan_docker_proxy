<!-- xuanyuan-docker-images-zh
image: snowdreamtech/frps
source: https://xuanyuan.cloud/zh/r/snowdreamtech/frps
canonical: https://xuanyuan.cloud/zh/r/snowdreamtech/frps
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/snowdreamtech/frps" title="snowdreamtech/frps Docker 镜像中文简介、标签列表与拉取命令">snowdreamtech/frps — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/snowdreamtech/frps" title="snowdreamtech/frps Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/snowdreamtech/frps</a></p>

# frp Docker镜像


基于Alpine和Debian系统构建的frp Docker镜像，支持多种架构：amd64、arm32v5、arm32v6、arm32v7、arm64v8、i386、mips64le、ppc64le、riscv64、s390x。


## 文档
- [英文文档]([])
- [中文文档]([])


## 使用方法

### 基础用法
```bash
# 启动（服务端）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  

# 启动（客户端）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  
```


### Alpine版本
基于Alpine系统的镜像：
```bash
# 启动（Alpine版）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :alpine

# 启动（Alpine版）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :alpine
```


### Debian版本
基于Debian系统的镜像（含bookworm版本）：
```bash
# 启动（Debian版）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :debian

# 启动（Debian版）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :debian

# 启动（Debian bookworm版）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :bookworm

# 启动（Debian bookworm版）
docker run --restart=always --network host -d -v /etc/frp/.toml:/etc/frp/.toml --name  :bookworm
```


## 快速参考

- **问题反馈**：[GitHub Issues]([])  
- **讨论交流**：[GitHub Discussions]([])  
- **维护者**：snowdream（邮箱：[邮箱已删除]）  


### 支持架构
- **Alpine**：linux/386、linux/amd64、linux/arm/v6、linux/arm/v7、linux/arm64、linux/ppc64le、linux/riscv64、linux/s390x  
- **Debian**：linux/386、linux/amd64、linux/arm/v5、linux/arm/v7、linux/arm64、linux/mips64le、linux/ppc64le、linux/s390x  


### 支持标签
- **Alpine**：latest、0.62-alpine3.21、0.64.0-alpine3.21、0.62-alpine、0.64.0-alpine、alpine3.21、alpine、0.62、0.64.0  
- **Debian**：bookworm、debian、0.62-bookworm、0.64.0-bookworm、0.62-debian、0.64.0-debian  


## 相关链接
- 腾讯云：[官网链接]([])  
- 阿里云：[官网链接]([])  
- 华为云：[官网链接]([])  
- Bandwagonhost/搬瓦工：[官网链接]([])  
- Vultr：[官网链接]([])  


## 联系方式（备注：frp）
- 邮箱：[邮箱已删除]  
- QQ：3217680847  
- QQ群：949022145  
- 微信/微信群：sn0wdr1am  


## 官方站点
1. [fatedier/frp（官方frp仓库）]([])  
2. [snowdreamtech/frp（镜像仓库）]([])  
3. [镜像（GitHub）]()  
4. [镜像（GitHub）]()  
5. [镜像（Docker Hub）]()  
6. [镜像（Docker Hub）]()  


## 许可证
MIT


## Star History
[![Star History Chart]([])]([])

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/snowdreamtech/frps" title="snowdreamtech/frps Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/snowdreamtech/frps</a></p>
