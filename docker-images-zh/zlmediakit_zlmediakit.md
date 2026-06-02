---
image: zlmediakit/zlmediakit
description: "该简介涵盖网页实时通信（WebRTC）、实时流传输协议（RTSP）、实时消息传输协议（RTMP）、HTTP直播流（HLS）、HTTP-FLV流媒体协议、WebSocket-FLV流媒体协议、HTTP-TS流媒体协议、HTTP-fMP4流媒体协议、WebSocket-fMP4流媒体协议、国家标准GB/T 28181视频监控联网系统标准（GB28181）及安全可靠传输协议（SRT）等多种流媒体与实时通信相关协议。"
source: https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit
canonical: https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit
exported_at: 2026-06-02T12:23:50.672Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit" title="zlmediakit/zlmediakit Docker 镜像中文简介、标签列表与拉取命令">zlmediakit/zlmediakit — 轩辕镜像中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

<a href="https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit" title="zlmediakit/zlmediakit Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/zlmediakit/zlmediakit</a>

# ZLMediaKit：基于C++11的高性能运营级流媒体服务框架


![logo]([])

[![]([])]([])
[![]([])]([])
[![]([])]([])
[![]([])]([])

[![]([])]([])
[![]([])]([])
[![]([])]([])
[![]([])]([])

[![]([])]([])
[![]([])]([])


## 项目特点

- 基于C++11开发，代码中避免使用裸指针，确保稳定可靠，性能表现优异。
- 支持多协议接入与互转，包括RTSP/RTMP/HLS/HTTP-FLV/WebSocket-FLV/GB28181/HTTP-TS/WebSocket-TS/HTTP-fMP4/WebSocket-fMP4/MP4/WebRTC等。
- 采用多路复用、多线程、异步网络IO模式设计，并发性能突出，可支持海量客户端连接。
- 代码经过长期稳定性与性能测试，已在线上商用环境验证多年。
- 全平台支持，覆盖Linux、macOS、iOS、Android、Windows。
- 实现画面秒开与低延时传输（常规场景500毫秒内，最低可达100毫秒）。
- 提供完善的标准C API，可作为SDK使用或供其他语言调用。
- 内置完整的MediaServer服务器，无需额外开发即可直接部署为商用服务。
- 支持restful API与web hook，满足丰富业务逻辑需求。
- 融合视频监控与直播协议栈，对RTSP/RTMP协议支持完善。
- 全面兼容H265/H264/AAC/G711/OPUS编码格式。
- 功能丰富，包括集群部署、按需转协议、按需推拉流、先播后推、断连续推等。
- 性能强劲，单机支持10万级播放器连接，IO带宽可达100Gb/s级别。


## 项目定位

- 移动嵌入式跨平台流媒体解决方案
- 商用级流媒体服务器
- 网络编程二次开发SDK


## 功能清单

### 功能概览
![功能一览]([])


#### RTSP[S]
- 支持RTSP[S]服务器功能，可实现RTMP/MP4/HLS转RTSP[S]，兼容亚马逊Echo Show等设备。
- 提供RTSP[S]播放器，支持RTSP代理与静音音频生成。
- 集成RTSP[S]推流客户端与服务器，支持RTP over UDP/TCP/HTTP及组播四种传输方式。
- 服务器与客户端均支持Basic/Digest登录鉴权，提供全异步可配置鉴权接口。
- 支持H265编码，服务器支持RTP over UDP/TCP推流。
- 兼容H264/H265/AAC/G711/OPUS/MJPEG编码，其他编码可转发但不支持协议转换。


#### RTMP[S]
- 支持RTMP[S]播放与发布服务器，可录制发布流，实现RTSP/MP4/HLS转RTMP。
- 提供RTMP[S]播放器与推流客户端，支持代理与静音音频生成。
- 支持HTTP[S]-FLV与WebSocket-FLV直播。
- 兼容H264/H265/AAC/G711/OPUS编码，支持RTMP-H265与RTMP-OPUS扩展。


#### HLS/TS/fMP4
- HLS：支持HLS文件生成与内置HTTP文件服务，通过Cookie追踪模拟长连接，实现按需拉流与播放统计；支持HLS播放器，可转RTSP/RTMP/MP4。
- TS：支持HTTP[S]-TS与WebSocket-TS直播，兼容主流编码格式。
- fMP4：支持HTTP[S]-fMP4与WebSocket-fMP4直播，兼容H264/H265/AAC/G711/OPUS/MJPEG编码。


#### HTTP[S]与WebSocket
- 服务器支持目录索引生成、文件下载、表单提交请求。
- 客户端提供文件下载器（支持断点续传）、接口请求器、文件上传器。
- 内置完整HTTP API服务器，可作为Web后台开发框架。
- 支持跨域访问、Cookie管理、WebSocket服务端与客户端，以及HTTP文件访问鉴权。


#### GB28181与RTP推流
- 支持UDP/TCP RTP（PS/TS/ES）推流服务器，可转换为RTSP/RTMP/HLS等协议。
- 提供RTSP/RTMP/HLS转RTP推流客户端，支持TCP/UDP模式，提供restful API与主动/被动推拉流方式。
- 兼容H264/H265/AAC/G711/OPUS编码，支持海康EHOME推流与GB28181主动拉流。


#### MP4点播与录制
- 支持录制为FLV/HLS/MP4格式。
- RTSP/RTMP/HTTP-FLV/WS-FLV支持MP4文件点播与seek操作，兼容主流编码。


#### WebRTC
- 支持WebRTC推流与转协议，以及其他协议转WebRTC播放。
- 支持双向回声测试、Simulcast推流、上下行RTX/NACK丢包重传。
- 实现单端口多线程与客户端网络连接迁移（开源界唯一支持）。
- 支持TWCC RTCP动态码率调整、REMB/PLI/SR/RR RTCP、RTP扩展解析、GOP缓冲（实现秒开）、DataChannel及WebRTC over TCP模式。


#### 其他功能
- 提供丰富的restful API与web hook事件通知。
- 支持Telnet调试、配置文件热加载、流量统计与推拉流鉴权。
- 支持虚拟主机、按需拉流（无人观看时自动关闭拉流）、先播放后推流（提升画面打开率）。
- 提供C API SDK，支持FFmpeg拉流代理任意格式流，通过HTTP API生成实时截图。
- 支持按需解复用与转协议（仅在有观看时启动转协议，降低CPU占用）。
- 支持溯源模式集群部署，溯源方式包括RTSP/RTMP/HLS/HTTP-TS，边沿站支持HLS，源站支持多节点轮询。
- RTSP/RTMP/WebRTC推流异常断开后，支持超时重连，播放器无感知。


## 编译与测试

**编译前请务必参考wiki文档《[快速开始]([])》操作。**


## 如何使用

根据需求选择以下使用方式：

1. **作为SDK使用**：通过标准[C API]([])集成到项目，或供其他语言调用。  
2. **直接部署服务器**：使用内置的[MediaServer]([])，无需开发即可部署，参考[restful API]([])与[web hook]([])实现业务逻辑。  
3. **二次开发**：基于源码扩展功能，参考[测试程序]([])了解开发方式。


## Docker镜像

可直接从Docker Hub拉取镜像并启动：

```bash
# 镜像与master分支代码同步，由GitHub CI自动编译推送
docker run -id -p 1935:1935 -p 8080:80 -p 8443:443 -p 8554:554 -p 10000:10000 -p 10000:10000/udp -p 8000:8000/udp -p 9000:9000/udp zlmediakit/zlmediakit:master
```

或通过Dockerfile自行编译：

```bash
bash build_docker_images.sh
```


## 合作项目

### 可视化管理网站
- [AKStreamNVR]([])：前后端分离Web项目，支持WebRTC与H265播放  
- [MediaServerUI]([])：基于ZLMediaKit主线的管理界面  
- [ZLMediaKit_NVR_UI]([])：基于ZLMediaKit分支的管理界面  
- [ZLMediaServerManagent]([])：可视化后台管理系统  


### 流媒体管理平台
- [wvp-GB28181-pro]([])：GB28181完整解决方案，支持WebRTC与H265  
- [AKStream]([])：流媒体控制管理接口平台，支持GB28181  
- [gosip]([])：Go语言实现的GB28181服务器  
- [GB28181_Node_Http]([])：Node.js版本GB28181平台  
- [FreeEhome]([])：Go语言实现的海康EHOME服务器  


### 客户端与播放器
- [ZLMediaKit.Autogen]([])：C SDK的C#包装库  
- [ZLM_ApiDemo]([])：基于C SDK的推流客户端  
- [ZLMediaKit.HttpApi]([])：C#版本HTTP API与Hook  
- [ZLMediaKit.DotNetCore.Sdk]([])：DotNetCore RESTful客户端  
- [h265web.js]([])：基于WebAssembly的H265播放器  
- [wsPlayer]([])：基于MSE的WebSocket-FMP4播放器  
- [metaRTC]([])：国产WebRTC SDK  


## 授权协议

项目自有代码采用MIT协议，保留版权信息即可自由用于商用或非商业项目。但项目依赖部分第三方[开源代码]([])，商用时需自行评估并处理第三方依赖的版权问题。因使用本项目产生的商业纠纷或侵权行为与项目及开发者无关，使用者需自行承担法律风险。使用时应在授权协议中注明本项目依赖的第三方库协议。


## 联系方式

- 邮箱：[邮箱已删除]（项目相关问题请通过issue反馈，非项目问题恕不回复）  
- QQ群：群号见项目wiki，建议阅读wiki后加入  


## 提问指引

若有疑问，建议按以下步骤处理：  
1. 先查阅README、wiki及已有issue，确认问题是否已解决。  
2. 未解决可提交新issue。  
3. 非普遍性问题可在QQ群交流。  
4. 不建议QQ私聊咨询（原因参考[《为什么不提倡QQ私聊》]([])）。  


## 特别感谢

项目复用了解复用模块依赖[老陈]([])的[media-server]([])库，其TS/FMP4/MP4/PS容器格式的复用解复用功能均基于该库实现。开发过程中，老陈提供了关键技术支持，特此致谢。


## 致谢

感谢以下贡献者（排名不分先后）对项目的代码贡献、问题反馈与资金支持：  
[老陈]([])、[Gemfield]([])、[南冠彤]([])、[凹凸慢]([])、[chenxiaolei]([])、[史前小虫]([])、[清涩绿茶]([])、[3503207480]([])、[DroidChow]([])、[阿塞]([])、[火宣]([])、[γ瑞γミ]([])、[linkingvision]([])、[茄子]([])、[好心情](mailto:[邮箱已删除])、[浮沉]([])、[Xiaofeng Wang]([])、[doodoocoder]([])、[qingci]([])、[swwheihei]([])、[KKKKK5G]([])、[Zhou Weimin](mailto:[邮箱已删除])、[Jim Jin]([])、[西瓜丶](mailto:[邮箱已删除])、[MingZhuLiu]([])、[chengxiaosheng]([])、[big panda](mailto:[邮箱已删除])、[tanningzhong]([])、[hctym1995]([])、[hewenyuan]([])、[sunhui](mailto:[邮箱已删除])、[mirs](mailto:[邮箱已删除])、[Kevin Cheng](mailto:[邮箱已删除])、[Liu Jiang](mailto:[邮箱已删除])、[along]([])、[qingci](mailto:[邮箱已删除])、[lyg1949](mailto:[邮箱已删除])、[zhlong](mailto:[邮箱已删除])、[大裤衩](mailto:[邮箱已删除])、[droid.chow](mailto:[邮箱已删除])、[陈晓林]([]
