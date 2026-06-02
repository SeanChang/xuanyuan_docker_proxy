---
image: xyliucd/ascow
description: "基于ABHPC研发的适用于Slurm调度系统的超算用户与管理集成系统"
source: https://xuanyuan.cloud/zh/r/xyliucd/ascow
canonical: https://xuanyuan.cloud/zh/r/xyliucd/ascow
exported_at: 2026-06-02T12:21:11.987Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/xyliucd/ascow" title="xyliucd/ascow Docker 镜像中文简介、标签列表与拉取命令">xyliucd/ascow — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/xyliucd/ascow" title="xyliucd/ascow Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/xyliucd/ascow</a>

# 1 项目简介
## 1.1 声明
本项目开发和运维团队为**中国工程物理研究院成都科学技术发展中心第四研究室**，是基于[**OpenSCOW**](https://github.com/PKUHPC/OpenSCOW)和ABHPC单层RDMA网络无盘超算集群开发的用户与管理门户系统，**同时也适配于采用Slurm调度系统的集群**，旨在将该框架广泛应用于科研、教育和工程行业。

按照木兰宽松协议v2要求，本项目更名为**ASCOW**且不开源，以保障**OpenSCOW**的商标权，但发布的公共镜像允许任意用户下载并免费使用，本项目的基础配置文件和**OpenSCOW**完全兼容(可参考[**OpenSCOW的安装与配置**](https://pkuhpc.github.io/OpenSCOW/docs/deploy))，增加的部分字段可参考更新日志说明。

本系统完全沿用OpenSCOW框架，感谢**北京大学OpenSCOW开发团队**的无私贡献，向他们致敬！

> 本系统推荐使用[**ASCOW-slurm适配器**](https://github.com/abhpc/abhpc-scow-slurm-adapter)，可避免交互式作业中文乱码和GPU资源分配等问题，还可实现基于`Environment Module`的模块调用统计。

## 1.2 技术合作和研讨
本项目欢迎任意形式的技术合作和研讨，可联系四室主任刘晓毅(邮件：[xyliu@mechx.ac.cn](mailto:xyliu@mechx.ac.cn))和计算组组长徐云飞博士(邮件：[yfxu@mechx.ac.cn](mailto:yfxu@mechx.ac.cn))。

# 2 版本说明和使用方法

## 2.1 历史版本说明
**20250901版本起，ND和SAND功能均在通用版本中实现，因此这两个版本不再更新，后续只更新通用版本。**

> latest-ND：禁用下载版本(已合并到通用版本)

> latest-SAND: 单点登录且禁用下载版本(已合并到通用版本)

## 2.2 使用方法
首先拉取镜像：
```bash
docker pull xyliucd/ascow:latest
```
使用`scow-cli`生成docker-compose.yml文件：
```bash
./cli generate
```
替换为`ascow`镜像:
```bash
sed -i s "@mirrors.pku.edu.cn/pkuhpc-icode/scow:v1.6.4@xyliucd/ascow:latest@g" docker-compose.yml
```
启动容器：
```bash
docker compose up -d
```

# 3 更新日志(按日期倒序排列)
- 20251201：去掉夜晚模式。
- 20251114：优化`作业->提交作业`页面布局，新增保存为模板前的命名：<img width="1200" alt="image" src="https://github.com/user-attachments/assets/a7969c72-52e7-43e7-b5d3-ca0e9104c971" />
- 20251110：调整了`作业—>提交作业`页面的布局。
- 20251109：优化管理员界面的作业显示列表，给用户名和账户加上中文备注，方便识别用户和单位。
- 20251105：在`文件目录选择框`中新增`上传文件`和`新文件`按钮：<img width="400" alt="image" src="https://github.com/user-attachments/assets/c645602e-3dfd-4bc3-b197-8f86472c26d7" />
- 20251104：优化`用户列表`显示
- 20251101：优化`账户列表`显示
- 20251031：增加应用搜索栏。账户备注变为可编辑。
- 20251027：增加用户单位信息，需要在`auth.yml`中添加单位信息：
```yml
  ldap:
  attrs:
    uid: uid
    name: cn
    mail: mail
    affiliation: description #新加的
```
修正了修改文件时，改变文件权限的Bug
- 20251020：修复导入用户管理界面显示姓名为`userID`的问题，正常应显示为LDAP中的中文名。
- 20251011：美化界面。
- 20251009：优化NGINX的websockets超时参数，避免VNC经常断线的问题。
- 20250928：优化图标显示，增加最大作业时长统计。优化筛选时间。
- 20250924：修正了不正确显示用户登录IP的Bug。优化了应用同步页面，如下所示：<img width="800" alt="image" src="https://github.com/user-attachments/assets/853dcc08-db16-46fe-9939-0d90c46c8db2" />
- 20250923：优化应用加载页面在APP数量较多时载入缓慢的问题，采用`redis`缓存机制。
- 20250919：新增图表统计，可导出数据做详细分析。<img width="1200" alt="image" src="https://github.com/user-attachments/assets/37d19120-ee8e-486d-b6b6-4267d57beece" />优化`portal-web`的并发度，实现基于`pm2`的`Nginx`负载均衡。
- 20250917：优化`portal-web`和`portal-server`的并发度，全部采用`pm2 cluster`来实现高并发度。
- 20250916：修改最大导出条目为50000条(原来设计为10000条)。应用图标大小默认修改为小。优化计算资源统计表显示。
- 20250914：新增计算资源统计板块，可统计不同module核时情况：<img width="600" alt="image" src="https://github.com/user-attachments/assets/9a8b0f5f-f627-42f2-847c-49869d0f42f2" />
- 20250910：限制前后缀为`slm.*`、`*.slm`、`*.sh`、`*.bash`、`*.slurm`、`slurm.*`六种文件可提交，其他文件不可提交。
- 20250909：新增已完成作业应用模块的csv导出功能，以统计不同软件模块的机时占比。
- 20250906：保存用户作业调取`Environment Module`记录，便于后期做软件使用分析。如用户主节点未配置`Environment Module`记录器，则记录值为`unknown`。需要配合最新的[**abhpc-scow-slurm-adapter**](https://github.com/abhpc/abhpc-scow-slurm-adapter)使用，参见[效果图](https://github.com/abhpc/abhpc-scow-slurm-adapter/blob/main/image/README/1757250643455.png)：<img width="1200" src="https://raw.githubusercontent.com/abhpc/abhpc-scow-slurm-adapter/main/image/README/1757250643455.png" alt="Image Description" />
- 20250901：ND和SAND版本合并到通用版本中来。其中，单点登录在`auth.yml`文件中新增以下字段实现单点登录：
```yml
singleSession: on  # on为开通单点登录，off为关闭单点登录
```
通过在`portal.yml`文件中增加以下字段实现文件下载权限控制：
```yml
# 是否允许文件下载
file:
  download:
    enable: false
    #enableAccounts: account1,account2,account3
    #enableUsers: user1,user2,user3
    # enable为true的情况下，禁止哪些账户或用户下载
    #disableAccounts: account1,account2,account3
    #disableUsers: user1,user2
```
- 20250829：忽略`config/apps/*.yml`的错误配置，避免某个交互式应用配置出错时，整个集群报500错误。新增交互式应用的图标大小调整。
- 20250827：在交互式应用的`yml`文件(`config/apps/*.yml`)中增加`visible`字段，使交互式应用可设置为公开或部分账户、用户可见。
```yml
visible:
  public: no                   # 如果public值为yes，则所有用户可见
  allow_accounts: caep,mechx   # 如果public为no，allow_accounts中账户下的所有用户可见APP
  allow_users: user1,uesr2     # 如果public为no，allow_users中的用户可见APP
```
- 20250826：增加了Portal的pm2并发性能，解决交互式应用在线用户数大于20时系统崩溃的问题。修改文件和文件夹的图标，以方便区分文件夹和文件。文件选择器默认路径设置为用户家目录，而不是根目录/。ND版本：禁用文件下载，适用于特殊教学或培训场景。SAND版本：增加用户单点登录功能，禁用同一账户在不同电脑上登录，且禁止用户下载文件。VNC单点登录和分辨率优化：禁用VNC多点登录，初始分辨率设置为3840x2160以避免部分程序窗口无法放大。交互式应用新增文件和目录选择器，以支持基于后台的非交互式应用，例如：
```yml
attributes:
  - type: file
    name: input
    label: 输入文件
    required: true
    placeholder: "比如：/home/user/fds/test.fds"
```
新增目录链接识别，可在交互式应用中直接链接到用户算例目录。优化资源选择，默认CPU和GPU核数独立设置，以方便用户选择资源。
