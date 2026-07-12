---
image: selenium/node-chrome
description: "Selenium Grid节点模式（搭配Chrome浏览器）是一种分布式自动化测试组件，作为硒网格架构中的工作节点，可接收中心集线器（Hub）分配的测试任务，在本地Chrome浏览器环境中执行Web应用自动化测试，支持多版本Chrome浏览器配置与并行测试任务处理，能有效提升大规模测试场景下的执行效率与资源利用率，适用于跨环境、多任务的Web应用自动化测试流程。"
source: https://xuanyuan.cloud/zh/r/selenium/node-chrome
canonical: https://xuanyuan.cloud/zh/r/selenium/node-chrome
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/selenium/node-chrome" title="selenium/node-chrome Docker 镜像中文简介、标签列表与拉取命令">selenium/node-chrome 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# 带Chrome的Selenium Grid节点  


### 该镜像是一个带Chrome浏览器的[Selenium Grid节点] ，需配合[Selenium Grid Hub] 使用，用于实现[WebDriver测试的远程运行] 。  


## 如何运行该镜像  

Hub和节点需在同一网络中，通过容器名相互识别。第一步需创建Docker网络。  


### 1. 创建Docker网络  
```bash  
docker network create grid  
```  


### 2. 启动Hub（使用创建的网络）  
```bash  
docker run -d -p 4442-4444:4442-4444 --net grid --name selenium-hub docker.xuanyuan.run/selenium/hub:latest
```  


### 3. 启动Node（使用创建的网络）  
#### Linux/macOS系统：  
```bash  
docker run -d --net grid -e SE_EVENT_BUS_HOST=selenium-hub \  
    --shm-size="2g" \  
    -e SE_EVENT_BUS_PUBLISH_PORT=4442 \  
    -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 \  
    docker.xuanyuan.run/selenium/node-chrome:latest
```  

#### Windows PowerShell系统：  
```powershell  
docker run -d --net grid -e SE_EVENT_BUS_HOST=selenium-hub `  
    --shm-size="2g" `  
    -e SE_EVENT_BUS_PUBLISH_PORT=4442 `  
    -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 `  
    selenium/node-chrome:latest  
```  


### 4. 将WebDriver测试指向 `[]  


### 5. 完成！  


### 6. （可选）查看容器内部情况  
访问 <[]> 可查看容器内实时状态。  


#### 注意事项：  
- 运行包含浏览器的镜像时，需添加 `--shm-size=2g` 参数，以使用主机的共享内存。  
- 示例中使用 `latest` 标签，建议使用完整标签固定特定浏览器和Grid版本（详见[标签规范] ）。  
- 更多节点配置方式可参考[GitHub上的Docker-Selenium项目] 。  
- 使用完毕且容器退出后，可通过 `docker network rm grid` 删除网络。  


## 如何选择正确的镜像标签  

镜像标签结构如下，可按需选择：  

### 基础标签格式  
```  
selenium/node-chrome-<主版本>.<次版本>.<补丁版本>-<日期>  
```  

### 包含浏览器和驱动版本的标签格式  
```  
selenium/node-chrome-<浏览器版本>-<驱动名称>-<驱动版本>-<主版本>.<次版本>.<补丁版本>-<日期>  
```  


### 示例（Chrome 112、ChromeDriver 112.0、Selenium Grid 4.9.0，20230426发布）  
```  
# 简化标签（自动匹配最新版本）  
selenium/node-chrome:4  
selenium/node-chrome:4.9  
selenium/node-chrome:4.9.0  
selenium/node-chrome:4.9.0-20230426  

# 包含浏览器版本的标签  
selenium/node-chrome:112.0  
selenium/node-chrome:112.0-20230426  

# 包含浏览器+驱动版本的标签  
selenium/node-chrome:112.0-chromedriver-112.0  
selenium/node-chrome:112.0-chromedriver-112.0-20230426  
selenium/node-chrome:112.0-chromedriver-112.0-grid-4.9.0-20230426  
```  

通过上述标签格式，可灵活选择特定版本或最新版本。  


## 完整文档  

更多配置细节可参考[Docker-Selenium项目的GitHub文档] 。  


## 许可证  

该项目由志愿者贡献开发，源代码基于[Apache License 2.0] 开源。
