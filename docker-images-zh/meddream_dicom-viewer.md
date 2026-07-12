---
image: meddream/dicom-viewer
description: "MedDream DICOM Viewer是一款支持PACS系统手动配置的HTML5零客户端医学影像查看器，厂商中立，可集成至医疗信息系统，CE认证且FDA批准用于诊断，支持本地、虚拟环境及云端部署。"
source: https://xuanyuan.cloud/zh/r/meddream/dicom-viewer
canonical: https://xuanyuan.cloud/zh/r/meddream/dicom-viewer
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/meddream/dicom-viewer" title="meddream/dicom-viewer Docker 镜像中文简介、标签列表与拉取命令">meddream/dicom-viewer 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# MedDream DICOM Viewer（用于PACS系统手动配置）

## 概述
MedDream是一款HTML5零客户端DICOM查看器，具备厂商中立特性，可集成至PACS、HIS/RIS/EHR/EMR、远程医疗、患者门户、国家系统、CAD及AI算法中。该通用企业级查看器支持本地部署、虚拟环境部署或云端部署，旨在辅助医疗专业人员日常决策。产品已通过CE认证并获得FDA批准，作为Class 2医疗设备用于诊断，是软件供应商、集成商、OEM及国家系统提供商的经济高效认证解决方案。

## 支持的PACS系统
- PacsOne
- Orthanc
- Dcm4chee2
- Dcm4chee5
- ConQuest
- ClearCanvas
- FileSystem
- DicomWeb
- QueryRetrieve

## 文档资源
[MedDream官方文档](https://www.meddream.com/documentation/)

[MedDream与PACS系统集成指南](https://www.meddream.com/files/meddreamviewer/doc/MedDream-DICOM-Viewer-Install-Manual.pdf#page=11)

## Docker部署与配置
### MedDream Viewer与Orthanc PACS系统手动配置示例
可通过-v参数传递自定义查看器配置文件（application.properties）：

```
docker run --restart=always --name meddream -itd -p 80:8080 -v /home/meddream/application.properties:/opt/meddream/application.properties docker.xuanyuan.run/meddream/dicom-viewer:8.7.0
```

默认application.properties文件（用于-v /home/meddream/application.properties挂载）：
```
server.port=8080
logging.file.name=mdjavacore
logging.level.com.softneta=INFO
com.softneta.meddream.loginEnabled=true
com.softneta.license.licenseFileLocation=./license

spring.profiles.include=auth-inmemory,auth-his
authentication.inmemory.users[0].userName=demo
authentication.inmemory.users[0].password=demo
authorization.users[0].userName=demo
authorization.users[0].role=SEARCH,EXPORT_ISO,EXPORT_ARCH,FORWARD,REPORT_VIEW,REPORT_UPLOAD,PATIENT_HISTORY,UPLOAD_DICOM_LIBRARY,ADMIN,DOCUMENT_VIEW,FREE_DRAW_VIEW,FREE_DRAW_EDIT,BOUNDING_BOX_VIEW,BOUNDING_BOX_EDIT,SMART_DRAW_VIEW,SMART_DRAW_EDIT,COPY_TO_DICOM
authentication.his.valid-his-params=study
authorization.defaultHisPermissions=SEARCH,EXPORT_ISO,EXPORT_ARCH,FORWARD,REPORT_VIEW,REPORT_UPLOAD,PATIENT_HISTORY,UPLOAD_DICOM_LIBRARY,DOCUMENT_VIEW,FREE_DRAW_VIEW,FREE_DRAW_EDIT,BOUNDING_BOX_VIEW,BOUNDING_BOX_EDIT,SMART_DRAW_VIEW,SMART_DRAW_EDIT,COPY_TO_DICOM
authorization.defaultLoginPermissions=SEARCH,EXPORT_ISO,EXPORT_ARCH,FORWARD,REPORT_VIEW,REPORT_UPLOAD,PATIENT_HISTORY,UPLOAD_DICOM_LIBRARY,DOCUMENT_VIEW,FREE_DRAW_VIEW,FREE_DRAW_EDIT,BOUNDING_BOX_VIEW,BOUNDING_BOX_EDIT,SMART_DRAW_VIEW,SMART_DRAW_EDIT,COPY_TO_DICOM


com.softneta.meddream.pacs.configurations[0].type=Orthanc
com.softneta.meddream.pacs.configurations[0].id=Orthanc
com.softneta.meddream.pacs.configurations[0].baseUrl=http://orthanc:8042
com.softneta.meddream.pacs.configurations[0].username=orthanc
com.softneta.meddream.pacs.configurations[0].password=orthanc
com.softneta.meddream.pacs.configurations[0].pythonPlugin=true
com.softneta.meddream.pacs.configurations[0].searchApiEnabled=true
com.softneta.meddream.pacs.configurations[0].imageApiEnabled=true
#com.softneta.meddream.pacs.configurations[0].dicomCacheDirectory={Path to DICOM files}
#com.softneta.meddream.pacs.configurations[0].storeScuAet={Remote AE Title for uploading annotations and KOs}
#com.softneta.meddream.pacs.configurations[0].storeScuIp={IP of remote AE for uploading annotations and KOs}
#com.softneta.meddream.pacs.configurations[0].storeScuPort={Port of remote AE for uploading annotations and KOs}
```

### 容器管理
停止运行中的容器：
```
docker stop meddream
```

删除容器：
```
docker rm meddream
```

## 许可证
MedDream DICOM Viewer基于商业许可协议。请联系info@meddream.com获取试用许可证。

许可证需通过许可证序列号注册，许可证文件夹必须通过-v /home/meddream/license:/opt/meddream/license挂载，并在application.properties中配置：
```
com.softneta.license.licenseFileLocation=./license
```

若在Docker上运行多个MedDream DICOM Viewer实例，每个实例必须使用唯一的许可证序列号和唯一的meddream.lic文件。
