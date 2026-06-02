<!-- xuanyuan-docker-images-zh
image: prom/node-exporter
source: https://xuanyuan.cloud/zh/r/prom/node-exporter
canonical: https://xuanyuan.cloud/zh/r/prom/node-exporter
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/prom/node-exporter" title="prom/node-exporter Docker 镜像中文简介、标签列表与拉取命令">prom/node-exporter — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/prom/node-exporter" title="prom/node-exporter Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/prom/node-exporter</a></p>

# Node exporter


Node exporter 是一款 Prometheus 导出器，用于收集类 Unix 内核暴露的硬件和操作系统指标，采用 Go 语言开发，支持可插拔的指标收集器。  

Windows 用户建议使用 [Windows exporter]([])，如需暴露 NVIDIA GPU 指标，可搭配使用 [prometheus-dcgm]([])。


## 安装与使用

如果您刚接触 Prometheus 和 `node_exporter`，可参考 [简易分步指南]([])。  

`node_exporter` 默认监听 HTTP 端口 9100，更多配置选项可通过 `--help` 查看。


### Ansible 自动化部署

如需通过 [Ansible]([]) 自动化安装，可使用 [Prometheus 社区角色]([])。


### Docker 部署

`node_exporter` 设计用于监控主机系统，容器化部署需特别注意避免监控容器本身。若必须容器化部署，需添加额外参数以允许 `node_exporter` 访问主机命名空间，同时需将待监控的非根挂载点绑定挂载到容器内。  

启动主机监控容器时，需指定 `path.rootfs` 参数，该参数需与主机根目录的绑定挂载路径一致，`node_exporter` 将以此为前缀访问主机文件系统。


#### Docker 命令行启动

```bash
docker run -d \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host
```


#### Docker Compose 配置

```yaml
---
version: '3.8'

services:
  node_exporter:
    image: quay.io/prometheus/node-exporter:latest
    container_name: node_exporter
    command:
      - '--path.rootfs=/host'
    network_mode: host
    pid: host
    restart: unless-stopped
    volumes:
      - '/:/host:ro,rslave'
```


部分系统中，`timex` 收集器需要额外添加 Docker 标志 `--cap-add=SYS_TIME` 以访问必要的系统调用。


## 收集器

不同操作系统对收集器的支持程度不同，以下表格列出所有收集器及其支持的系统。  

收集器通过 `--collector.<name>` 标志启用，默认启用的收集器可通过 `--no-collector.<name>` 禁用。如需仅启用特定收集器，使用 `--collector.disable-defaults --collector.<name> ...`。


### 包含与排除标志

部分收集器支持通过专用标志配置包含或排除特定模式。排除标志（exclude）表示“除…之外”，包含标志（include）表示“仅包含…”，两者在同一收集器上互斥。  

示例：  
```txt
--collector.filesystem.mount-points-exclude=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/.+)($|/)
```

支持包含/排除标志的收集器列表：  

| 收集器       | 作用范围   | 包含标志                          | 排除标志                          |
|--------------|------------|-----------------------------------|-----------------------------------|
| arp          | 设备       | --collector.arp.device-include    | --collector.arp.device-exclude    |
| cpu          | bugs       | --collector.cpu.info.bugs-include | N/A                               |
| cpu          | flags      | --collector.cpu.info.flags-include| N/A                               |
| diskstats    | 设备       | --collector.diskstats.device-include | --collector.diskstats.device-exclude |
| ethtool      | 设备       | --collector.ethtool.device-include | --collector.ethtool.device-exclude |
| ethtool      | 指标       | --collector.ethtool.metrics-include | N/A                             |
| filesystem   | 文件系统类型 | --collector.filesystem.fs-types-include | --collector.filesystem.fs-types-exclude |
| filesystem   | 挂载点     | --collector.filesystem.mount-points-include | --collector.filesystem.mount-points-exclude |
| hwmon        | 芯片       | --collector.hwmon.chip-include    | --collector.hwmon.chip-exclude    |
| hwmon        | 传感器     | --collector.hwmon.sensor-include  | --collector.hwmon.sensor-exclude  |
| interrupts   | 名称       | --collector.interrupts.name-include | --collector.interrupts.name-exclude |
| netdev       | 设备       | --collector.netdev.device-include | --collector.netdev.device-exclude |
| qdisk        | 设备       | --collector.qdisk.device-include  | --collector.qdisk.device-exclude  |
| slabinfo     | slab 名称  | --collector.slabinfo.slabs-include | --collector.slabinfo.slabs-exclude |
| sysctl       | 全部       | --collector.sysctl.include        | N/A                               |
| systemd      | 单元       | --collector.systemd.unit-include  | --collector.systemd.unit-exclude  |


### 默认启用的收集器

| 名称          | 描述                                                                 | 支持系统                                      |
|---------------|----------------------------------------------------------------------|-----------------------------------------------|
| arp           | 从 `/proc/net/arp` 暴露 ARP 统计信息                                  | Linux                                         |
| bcache        | 从 `/sys/fs/bcache/` 暴露 bcache 统计信息                             | Linux                                         |
| bonding       | 暴露 Linux 绑定接口的配置和活动从设备数量                             | Linux                                         |
| btrfs         | 暴露 btrfs 文件系统统计信息                                           | Linux                                         |
| boottime      | 从 `kern.boottime` sysctl 获取系统启动时间                            | Darwin, Dragonfly, FreeBSD, NetBSD, OpenBSD, Solaris |
| conntrack     | 显示连接跟踪统计信息（无 `/proc/sys/net/netfilter/` 时不生效）        | Linux                                         |
| cpu           | 暴露 CPU 统计信息                                                     | Darwin, Dragonfly, FreeBSD, Linux, Solaris, OpenBSD |
| cpufreq       | 暴露 CPU 频率统计信息                                                 | Linux, Solaris                                |
| diskstats     | 暴露磁盘 I/O 统计信息                                                 | Darwin, Linux, OpenBSD                        |
| dmi           | 从 `/sys/class/dmi/id/` 暴露桌面管理接口（DMI）信息                   | Linux                                         |
| edac          | 暴露错误检测与纠正（EDAC）统计信息                                    | Linux                                         |
| entropy       | 暴露可用熵值                                                         | Linux                                         |
| exec          | 暴露执行统计信息                                                     | Dragonfly, FreeBSD                            |
| fibrechannel  | 从 `/sys/class/fc_host/` 暴露光纤通道信息和统计数据                   | Linux                                         |
| filefd        | 从 `/proc/sys/fs/file-nr` 暴露文件描述符统计信息                      | Linux                                         |
| filesystem    | 暴露文件系统统计信息（如磁盘使用量）                                 | Darwin, Dragonfly, FreeBSD, Linux, OpenBSD    |
| hwmon         | 从 `/sys/class/hwmon/` 暴露硬件监控和传感器数据                       | Linux                                         |
| infiniband    | 暴露 InfiniBand 和 Intel OmniPath 配置的网络统计信息                  | Linux                                         |
| ipvs          | 从 `/proc/net/ip_vs` 和 `/proc/net/ip_vs_stats` 暴露 IPVS 状态        | Linux                                         |
| loadavg       | 暴露系统负载平均值                                                   | Darwin, Dragonfly, FreeBSD, Linux, NetBSD, OpenBSD, Solaris |
| mdadm         | 从 `/proc/mdstat` 暴露 RAID 设备统计信息（无该文件时不生效）          | Linux                                         |
| meminfo       | 暴露内存统计信息                                                     | Darwin, Dragonfly, FreeBSD, Linux, OpenBSD    |
| netclass      | 从 `/sys/class/net/` 暴露网络接口信息                                 | Linux                                         |
| netdev        | 暴露网络接口统计信息（如传输字节数）                                 | Darwin, Dragonfly, FreeBSD, Linux, OpenBSD    |
| netisr        | 暴露 netisr 统计信息                                                 | FreeBSD                                       |
| netstat       | 从 `/proc/net/netstat` 暴露网络统计信息（同 `netstat -s`）            | Linux                                         |
| nfs           | 从 `/proc/net/rpc/nfs` 暴露 NFS 客户端统计信息（同 `nfsstat -c`）     | Linux                                         |
| nfsd          | 从 `/proc/net/rpc/nfsd` 暴露 NFS 内核服务器统计信息（同 `nfsstat -s`）| Linux                                         |
| nvme          | 从 `/sys/class/nvme/` 暴露 NVMe 设备信息                              | Linux                                         |
| os            | 从 `/etc/os-release` 或 `/usr/lib/os-release` 暴露操作系统版本信息     | 所有系统                                     |
| powersupplyclass | 从 `/sys/class/power_supply` 暴露电源统计信息                      | Linux                                         |
| pressure      | 从 `/proc/pressure/` 暴露压力 stall 统计信息                          | Linux（内核 4.20+ 且启用 [CONFIG_PSI]([])） |
| rapl          | 从 `/sys/class/powercap` 暴露能源相关统计信息                         | Linux                                         |
| schedstat     | 从 `/proc/schedstat` 暴露任务调度器统计信息                           | Linux                                         |
| selinux       | 暴露 SELinux 统计信息                                                | Linux                                         |
| sockstat      | 从 `/proc/net/sockstat` 暴露套接字统计信息                            | Linux                                         |
| softnet       | 从 `/proc/net/softnet_stat` 暴露软中断统计信息                        | Linux                                         |
| stat          | 从 `/proc/stat` 暴露系统统计信息（如启动时间、进程数、中断数）         | Linux                                         |
| tapestats     | 从 `/sys/class/scsi_tape` 暴露磁带设备统计信息                        | Linux                                         |
| textfile      | 从本地磁盘读取统计信息（需设置 `--collector.textfile.directory`）     | 所有系统                                     |
| thermal       | 暴露散热统计信息（如 `pmset -g therm`）                               | Darwin                                       |
| thermal_zone  | 从 `/sys/class/thermal` 暴露散热区和冷却设备统计信息                   | Linux                                         |
| time          | 暴露当前系统时间                                                     | 所有系统                                     |
| timex         | 暴露 adjtimex(2) 系统调用的部分统计信息                               | Linux                                         |
| udp_queues    | 从 `/proc/net/udp` 和 `/proc/net/udp6` 暴露 UDP 队列长度统计信息       | Linux                                         |
| uname         | 暴露 uname 系统调用返回的系统信息                                     | Darwin, FreeBSD, Linux, OpenBSD              |
| vmstat        | 从 `/proc/vmstat` 暴露虚拟内存统计信息                                | Linux                                         |
| watchdog      | 从 `/sys/class/watchdog` 暴露看门狗统计信息                           | Linux                                         |
| xfs           | 暴露 XFS 文件系统运行时统计信息                                       | Linux（内核 4.4+）                            |
| zfs           | 暴露 ZFS 性能统计信息                                                | FreeBSD, Linux (zfsonlinux), Solaris          |


### 默认禁用的收集器

以下收集器默认禁用，原因包括：高基数、收集耗时过长（超过 Prometheus 抓取间隔或超时时间）、对主机资源消耗较大等。启用时建议先在非生产环境测试，观察 `scrape_duration_seconds`（确保收集不超时）和 `scrape_samples_post_metric_relabeling`（监控基数变化）。  

| 名称               | 描述                                                                 | 支持系统                                      |
|--------------------|----------------------------------------------------------------------|-----------------------------------------------|
| buddyinfo          | 从 `/proc/buddyinfo` 暴露内存碎片统计信息                             | Linux                                         |
| cgroups            | 暴露活动和启用的 cgroups 数量摘要                                    | Linux                                         |
| cpu_vulnerabilities | 从 sysfs 暴露 CPU 漏洞信息                                          | Linux                                         |
| devstat            | 暴露设备统计信息                                                     | Dragonfly, FreeBSD                            |
| drm                | 通过 sysfs/DRM 暴露 GPU 指标（仅 `amdgpu` 驱动支持）                  | Linux                                         |
| drbd               | 暴露分布式复制块设备（DRBD）统计信息（支持至 8.4 版本）               | Linux                                         |
| ethtool            | 暴露网络接口信息和驱动统计数据（同 `ethtool`、`ethtool -S`、`ethtool -i`） | Linux                               |
| interrupts         | 暴露详细中断统计信息                                                 | Linux, OpenBSD                                |
| ksm                | 从 `/sys/kernel/mm/ksm` 暴露内核内存合并统计信息                      | Linux                                         |
| lnstat             | 从 `/proc/net/stat/` 暴露统计信息                                    | Linux                                         |
| logind             | 从 logind 暴露会话计数                                               | Linux                                         |
| meminfo_numa       | 从 `/sys/devices/system/node/` 暴露 NUMA 内存统计信息                 | Linux                                         |
| mountstats         | 从 `/proc/self/mountstats` 暴露文件系统统计信息（含 NFS 客户端详情）   | Linux                                         |
| network_route      | 暴露路由表指标                                                       | Linux                                         |
| pcidevice          | 暴露 PCI 设备信息（如链路状态、父设备）                               | Linux                                         |
| perf               | 暴露基于 perf 的指标（注意：依赖内核配置和设置）                      | Linux                                         |
| processes          | 从 `/proc` 暴露进程聚合统计信息                                      | Linux                                         |
| qdisc              | 暴露队列规则（qdisc）统计信息                                        | Linux                                         |
| slabinfo           | 从 `/proc/slabinfo` 暴露 slab 统计信息（注意文件权限通常为 0400）      | Linux                                         |
| softirqs           | 从 `/proc/softirqs` 暴露详细软中断统计信息                            | Linux                                         |
| sysctl             | 暴露 `/proc/sys` 中的 sysctl 值（需通过 `--collector.sysctl.include` 配置） | Linux                            |
| swap               | 从 `/proc/swaps` 暴露交换分区信息                                    | Linux                                         |
| systemd            | 从 systemd 暴露服务和系统状态                                        | Linux                                         |
| tcpstat            | 从 `/proc/net/tcp` 和 `/proc/net/tcp6` 暴露 TCP 连接状态信息（高负载下可能有性能问题） | Linux                       |
| wifi               | 暴露 WiFi 设备和站点统计信息                                         | Linux                                         |
| xfrm               | 从 `/proc/net/xfrm_stat` 暴露 IPsec 统计信息                          | Linux                                         |
| zoneinfo           | 暴露 NUMA 内存区域指标                                               | Linux                                         |


### 已弃用的收集器

以下收集器已弃用，将在下次大版本更新中移除：  

| 名称        | 描述                                  | 支持系统   |
|-------------|---------------------------------------|------------|
| ntp         | 暴露本地 NTP 守护进程健康状态（建议使用 time 收集器） | 所有系统   |
| runit       | 从 runit 暴露服务状态                 | 所有系统   |
| supervisord | 从 supervisord 暴露服务状态           | 所有系统   |


### Perf 收集器

`perf` 收集器在部分 Linux 系统中可能因内核配置或安全设置无法直接使用，需调整 `sysctl` 参数：  
```bash
sysctl -w kernel.perf_event_paranoid=X
```
- 2：仅允许用户空间测量（Linux 4.6+ 默认）  
- 1：允许内核和用户空间测量（Linux 4.6 前默认）  
- 0：允许访问 CPU 特定数据，但不允许原始跟踪点采样  
- -1：无限制  

多数场景下 `0` 可提供最完整指标，更多信息见 [`man 2 perf_event_open`]([])。  

默认情况下，`perf` 收集器仅收集 `node_exporter` 运行的 CPU（通过 `runtime.NumCPU` 获取）。如需指定其他 CPU，使用 `--collector.perf.cpus` 标志，例如：  
```bash
--collector.perf --collector.perf.cpus=2-6  # 收集 CPU 2-6 的指标
--collector.perf --collector.perf.cpus=1-10:5  # 收集 CPU 1、5、10（步长 5）
```

`perf` 收集器还支持通过 `--collector.perf.tracepoint` 标志收集跟踪点（tracepoint）计数，例如：  
```bash
--collector.perf.tracepoint="sched:sched_process_exec"
```


### Sysctl 收集器

通过 `--collector.sysctl` 启用，支持通过 `--collector.sysctl.include` 暴露数值型 sysctl 值为指标，通过 `--collector.sysctl.include-info` 暴露字符串型值为 info 指标（可重复指定）。多值 sysctl 可通过映射自定义指标名，否则使用 `index` 标签区分。  


####

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/prom/node-exporter" title="prom/node-exporter Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/prom/node-exporter</a></p>
