---
image: devicefarmer/stf
description: "STF（Smartphone Test Farm）是一个Web应用，允许用户通过浏览器远程调试智能手机、智能手表等设备，支持实时屏幕查看、远程控制、应用安装、日志管理及设备 inventory 监控等功能，适用于多设备测试与管理场景。"
source: https://xuanyuan.cloud/zh/r/devicefarmer/stf
canonical: https://xuanyuan.cloud/zh/r/devicefarmer/stf
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/devicefarmer/stf" title="devicefarmer/stf Docker 镜像中文简介、标签列表与拉取命令">devicefarmer/stf 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# STF (Smartphone Test Farm) 镜像文档

## 镜像概述

STF（Smartphone Test Farm）是一个开源Web应用，旨在通过浏览器远程调试智能手机、智能手表及其他智能设备。用户可实时查看设备屏幕、控制设备操作、安装应用、执行Shell命令并监控设备状态，适用于构建设备测试农场或多设备集中管理平台。

![设备架特写](https://raw.githubusercontent.com/DeviceFarmer/stf/master/doc/shelf_closeup_790x.jpg)

![使用演示](https://raw.githubusercontent.com/DeviceFarmer/stf/master/doc/7s_usage.gif)

## 核心功能与特性

### 设备支持范围
- **Android系统**
  - 支持版本：2.3.3（SDK 10）至10（SDK 29）
  - 支持Wear 5.1（不支持5.0，因权限缺失）
  - 兼容Fire OS、CyanogenMod等基于Android的衍生系统
  - 无需设备root权限

### 远程控制功能
- **实时屏幕视图**：刷新率可达30-40 FPS（取决于设备规格与Android版本），支持屏幕旋转
- **键盘输入映射**：支持元键、复制粘贴（部分旧设备需手动长按粘贴）
- **多触控支持**：通过minitouch实现触摸屏多触控；普通屏幕可按住Alt键拖拽实现双指缩放/旋转
- **应用安装**：拖放APK文件至界面即可安装并启动（需Manifest指定主活动）
- **反向端口转发**：通过minirev实现设备访问本地服务器（跨网络环境）
- **浏览器快捷打开**：自动检测设备已安装浏览器，支持一键打开指定网址
- **Shell命令执行**：实时查看命令输出结果
- **日志查看与过滤**：支持设备日志实时显示与筛选
- **ADB远程连接**：通过`adb connect`将远程设备映射为本地连接，支持Android Studio调试及Chrome远程调试工具

### 设备管理功能
- **设备状态监控**：显示设备连接状态（在线/离线/未授权）、当前使用者、电池电量与健康状态
- **设备搜索**：支持按手机号、IMEI、Android版本、运营商、设备名称等属性查询
- **物理定位**：触发设备显示红色标识屏幕，便于物理查找设备
- **硬件信息展示**：显示设备详细硬件规格
- **Play Store账户管理**：列出/移除/添加账户（添加功能可能不适用于部分设备）

### 分组与预约系统
- **分组功能**（管理员权限）：将设备分配给不同项目/组织，支持长期分配
- **预约功能**：允许用户在指定时间段（如5天内每天3:00-4:00）预约设备集
- **分组管理**：创建/编辑/删除分组，设置成员、设备与时间规则，搜索与联系分组所有者

### 用户与权限管理（管理员权限）
- 用户创建（姓名与邮箱）、搜索与删除
- 设置用户的分组配额（默认配额与特定用户配额）
- 批量操作设备（按条件筛选并移除设备）

### 其他特性
- 提供REST API接口，支持二次开发与集成
- 实验性VNC支持（开发中）

## 使用场景

- **移动应用测试团队**：集中管理测试设备，实现远程调试与自动化测试
- **设备维修中心**：远程协助用户诊断设备问题，无需物理接触设备
- **教学/培训场景**：演示设备操作流程，学员可远程跟随练习
- **多设备兼容性测试**：同时在不同品牌、系统版本的设备上验证应用功能

## 使用方法与配置说明

### 前提条件

- 需外部RethinkDB数据库（≥2.2版本）
- 设备需开启USB调试模式
- 网络环境需允许设备与STF服务间的通信

### Docker部署示例

#### 1. 启动RethinkDB容器

```bash
docker run -d \
  --name rethinkdb \
  -p 28015:28015 \
  -p 8080:8080 \
  docker.xuanyuan.run/rethinkdb:2.4
```

#### 2. 启动STF服务

```bash
docker run -d \
  --name stf \
  --link rethinkdb:rethinkdb \
  -p 7100:7100 \
  -e STF_ADMIN_NAME="admin" \
  -e STF_ADMIN_EMAIL="admin@example.com" \
  docker.xuanyuan.run/devicefarmer/stf \
  stf local \
  --public-ip <your-server-ip> \
  --rethinkdb-host rethinkdb
```

#### 3. 访问STF界面

打开浏览器访问 `http://<your-server-ip>:7100`，使用默认管理员账户登录：
- 用户名：`administrator`（或通过`STF_ADMIN_NAME`环境变量自定义）
- 邮箱：`administrator@fakedomain.com`（或通过`STF_ADMIN_EMAIL`环境变量自定义）

### 关键配置参数

| 环境变量                | 说明                                  | 默认值                          |
|-------------------------|---------------------------------------|---------------------------------|
| `STF_ROOT_GROUP_NAME`   | 根设备分组名称                        | `Common`                        |
| `STF_ADMIN_NAME`        | 管理员用户名                          | `administrator`                 |
| `STF_ADMIN_EMAIL`       | 管理员邮箱                            | `administrator@fakedomain.com`  |
| `--public-ip`           | 服务公网IP（允许外部访问时需指定）    | 自动检测                        |
| `--rethinkdb-host`      | RethinkDB主机地址                     | `localhost`                     |
| `--rethinkdb-port`      | RethinkDB端口                         | `28015`                         |

### 扩展部署

对于生产环境，建议参考官方[部署文档](https://github.com/DeviceFarmer/stf/blob/master/doc/DEPLOYMENT.md)，将STF各组件（API服务、设备代理、Web前端等）拆分部署，并使用systemd等工具管理进程。

## 注意事项

- **安全性**：STF各组件间通信未加密，设备在多用户使用间不会完全重置，可能残留敏感数据，建议仅在可信环境中部署
- **性能优化**：设备屏幕刷新率受硬件与网络影响，建议使用有线网络连接设备与服务器
- **设备维护**：长时间运行需定期更换设备电池（建议2年更换一次），设置屏幕自动关闭超时（如30秒）以延长设备寿命
- **依赖要求**：Docker部署需确保RethinkDB服务正常运行，设备需开启USB调试并授权连接

## 常见问题

### 设备无法显示在列表中？
- 检查USB调试是否开启，尝试切换MTP/PTP模式
- 确认ADB服务正常运行（`adb start-server`）
- 检查设备是否授权ADB密钥（设备屏幕可能显示授权弹窗）
- 排查USB集线器供电不足或端口故障，尝试更换线缆或集线器

### 远程ADB连接频繁断开？
- 本地开发时，通过`stf local <device-serial>`指定允许的设备序列号，避免STF识别重复设备
- 确保IDE（如Android Studio）仅连接目标设备，避免多设备JDWP连接冲突
- 检查网络稳定性，避免ADB服务被IDE或设备管理器重启

### 支持iOS设备吗？
- 目前暂不支持，iOS支持为长期开发目标

## 状态与发展

STF处于持续开发中，短期目标包括性能优化、VNC功能UI集成、用户数据重置（Android 4.0+）及设备定时重启；长期计划支持iOS设备。开发主要依赖社区贡献，欢迎参与代码提交与功能改进。
