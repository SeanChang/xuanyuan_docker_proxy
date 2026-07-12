---
image: opendronemap/odm
description: "ODM是一个开源命令行工具包，用于处理无人机航拍图像，可将普通非量测图像转换为三维地理数据，如点云、数字表面模型、正射影像等，适用于地理信息生成与分析场景。"
source: https://xuanyuan.cloud/zh/r/opendronemap/odm
canonical: https://xuanyuan.cloud/zh/r/opendronemap/odm
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/opendronemap/odm" title="opendronemap/odm Docker 镜像中文简介、标签列表与拉取命令">opendronemap/odm 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# ODM 镜像文档

![ODM Logo](https://raw.githubusercontent.com/OpenDroneMap/OpenDroneMap/master/img/odm_image.png)

## 镜像概述和主要用途

ODM（OpenDroneMap）是一个开源命令行工具包，专注于处理无人机航拍图像。无人机通常搭载简单的傻瓜相机，其拍摄的图像虽视角独特，但本质上属于非量测图像。ODM能够将这些普通图像转化为三维地理数据，可与其他地理数据集结合使用，实现从影像到地理空间信息的转化。若需图形用户界面，可搭配[WebODM](https://github.com/OpenDroneMap/WebODM)使用。

![点云示例](https://raw.githubusercontent.com/OpenDroneMap/OpenDroneMap/master/img/tol_ptcloud.png)

简言之，ODM是一套将民用无人机原始影像处理为多种有用产品的工具链，可生成的产品包括：
- 点云
- 数字表面模型（DSM）
- 带纹理的数字表面模型
- 正射影像
- 分类点云（即将推出）
- 数字高程模型（DEM）等

ODM集成了Michael Waechter、Nils Moehrle和Michael Goesele的最新3D重建技术，相关研究成果参见[论文](http://www.gcc.tu-darmstadt.de/media/gcc/papers/Waechter-2014-LTB.pdf)。详细文档可参考快速入门及[官方文档](https://docs.opendronemap.org)。

## 核心功能和特性

- **多类型地理数据生成**：支持输出点云、数字表面模型、正射影像等多种三维地理数据产品
- **先进重建技术**：集成当前最先进的3D重建算法，确保数据精度与质量
- **开源免费**：完全开源的命令行工具，支持自定义扩展与二次开发
- **跨平台支持**：通过Docker实现全平台运行，包括Linux、macOS和Windows
- **灵活配置**：支持通过命令行参数或配置文件自定义处理流程与参数

## 使用场景和适用范围

ODM适用于需要将无人机影像转化为地理空间数据的各类场景，包括但不限于：
- **测绘与制图**：生成正射影像用于地图更新与制作
- **工程建设**：通过三维模型进行施工规划、进度监控与竣工测量
- **农业监测**：利用正射影像评估作物生长状况、计算植被覆盖度
- **环境管理**：通过数字表面模型分析地形变化、监测水土流失
- **科研调查**：获取研究区域高精度三维地理数据，支持地质、生态等领域研究

## 详细使用方法和配置说明

### Docker快速启动（所有平台）

使用Docker是运行ODM的最简单方式。首先需安装Docker（参考[Docker Ubuntu安装教程](https://docs.docker.com/engine/installation/linux/ubuntulinux/)，macOS和Windows用户可参考[Docker官方文档](https://docs.docker.com)）。安装完成后，执行以下命令运行预构建镜像，处理当前目录`images`文件夹中的影像（可修改路径，详细说明见[项目wiki](https://github.com/OpenDroneMap/OpenDroneMap/wiki/Docker)）：

```bash
docker run -it --rm \
    -v "$(pwd)/images:/code/images" \
    -v "$(pwd)/odm_orthophoto:/code/odm_orthophoto" \
    -v "$(pwd)/odm_texturing:/code/odm_texturing" \
    docker.xuanyuan.run/opendronemap/opendronemap
```

### Docker构建与高级配置

#### 构建自定义镜像

如需从源码构建镜像，执行：

```bash
docker build -t my_odm_image --no-cache .
```

若需减小镜像体积，可使用`--squash`参数（需启用Docker实验性功能）：

```bash
docker build --squash -t my_odm_image .
```

启用实验性功能：编辑`/etc/docker/daemon.json`文件，添加：

```json
{
    "experimental": true
}
```

然后重启Docker服务：

```bash
sudo service docker restart
```

#### 挂载输出目录

默认情况下，处理结果保存在容器内。通过`-v`参数挂载本地目录可持久化保存结果。如需获取所有中间输出，使用：

```bash
docker run -it --rm \
    -v "$(pwd)/images:/code/images" \
    -v "$(pwd)/odm_georeferencing:/code/odm_georeferencing" \
    -v "$(pwd)/odm_meshing:/code/odm_meshing" \
    -v "$(pwd)/odm_orthophoto:/code/odm_orthophoto" \
    -v "$(pwd)/odm_texturing:/code/odm_texturing" \
    -v "$(pwd)/opensfm:/code/opensfm" \
    -v "$(pwd)/smvs:/code/smvs" \
    docker.xuanyuan.run/opendronemap/opendronemap
```

#### 传递自定义参数

可直接在`docker run`命令后附加`run.py`脚本参数，例如调整影像分辨率和CCD尺寸：

```bash
docker run -it --rm \
    -v "$(pwd)/images:/code/images" \
    -v "$(pwd)/odm_orthophoto:/code/odm_orthophoto" \
    -v "$(pwd)/odm_texturing:/code/odm_texturing" \
    docker.xuanyuan.run/opendronemap/opendronemap --resize-to 1800 --force-ccd 6.16
```

#### 使用自定义配置文件

通过挂载本地`settings.yaml`文件传递配置：

```bash
docker run -it --rm \
    -v "$(pwd)/images:/code/images" \
    -v "$(pwd)/odm_orthophoto:/code/odm_orthophoto" \
    -v "$(pwd)/odm_texturing:/code/odm_texturing" \
    -v "$(pwd)/settings.yaml:/code/settings.yaml" \
    docker.xuanyuan.run/opendronemap/opendronemap
```

### 结果查看

处理完成后，结果文件按以下结构组织：

```
|-- images/                  # 原始影像
|-- images_resize/           # 调整尺寸后的影像
|-- opensfm/                 # OpenSfM处理结果
|   |-- depthmaps/
|       |-- merged.ply       # 非地理参考稠密点云
|-- odm_meshing/
|   |-- odm_mesh.ply         # 三维网格模型
|-- odm_texturing/
|   |-- odm_textured_model_geo.obj  # 地理参考带纹理模型
|-- odm_georeferencing/
|   |-- odm_georeferenced_model.ply # 地理参考点云
|-- odm_orthophoto/
    |-- odm_orthophoto.tif   # 正射影像（GeoTIFF格式）
```

- **三维模型与点云**：`.obj`和`.ply`文件可使用[MeshLab](http://meshlab.sourceforge.net/)查看
- **正射影像**：`.tif`文件可使用[QGIS](http://www.qgis.org/)等GIS软件打开

![带纹理模型示例](https://raw.githubusercontent.com/alexhagiopol/OpenDroneMap/feature-better-docker/toledo_dataset_example_mesh.jpg)

![正射影像示例](https://raw.githubusercontent.com/OpenDroneMap/OpenDroneMap/master/img/bellus_map.png)

## 其他信息

- **图形界面**：WebODM项目提供ODM的Web界面与API，详见[WebODM仓库](https://github.com/OpenDroneMap/WebODM)
- **视频支持**：实验性功能，可通过ORB_SLAM从视频生成带纹理网格（仅支持Ubuntu 14.04及X11环境），详见[项目wiki](https://github.com/OpenDroneMap/OpenDroneMap/wiki/Reconstruction-from-Video)
- **文档资源**：完整文档请访问[docs.opendronemap.org](https://docs.opendronemap.org)或[项目wiki](https://github.com/OpenDroneMap/OpenDroneMap/wiki)
- **开发者社区**：通过[Gitter](https://gitter.im/OpenDroneMap/OpenDroneMap)参与讨论，提交PR请确保代码简洁并提供测试结果
