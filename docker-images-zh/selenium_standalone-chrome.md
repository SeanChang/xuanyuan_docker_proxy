<!-- xuanyuan-docker-images-zh
image: selenium/standalone-chrome
source: https://xuanyuan.cloud/zh/r/selenium/standalone-chrome
canonical: https://xuanyuan.cloud/zh/r/selenium/standalone-chrome
exported_at: 2026-06-02T12:13:30.631Z
-->

> **轩辕镜像中文简介（在线版）：** [selenium/standalone-chrome — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/selenium/standalone-chrome "selenium/standalone-chrome Docker 镜像中文简介、标签列表与拉取命令")
>
> 含镜像标签、拉取命令、部署文档与相关推荐。
>
> https://xuanyuan.cloud/zh/r/selenium/standalone-chrome

# Selenium Grid Standalone with Chrome  


## 简介  
此镜像包含带Chrome浏览器的[Selenium Grid Standalone]([])，可直接用于[远程运行WebDriver测试]([])。  


## 如何运行镜像  

### 基本步骤  
1. **启动Standalone Chrome实例**  
   执行以下Docker命令启动服务：  
   ```bash  
   docker run -d -p 4444:4444 -p 7900:7900 --shm-size="2g" selenium/standalone-chrome:latest  
   ```  

2. **配置测试指向地址**  
   将WebDriver测试代码中的远程地址指向 `[]  

3. **完成设置**  
   至此，远程测试环境已就绪，可直接运行测试。  

4. **（可选）查看容器内实时状态**  
   若需观察浏览器运行情况，访问以下地址（默认密码：`secret`）：  
   <[]>  


### 注意事项  
- 运行包含浏览器的镜像时，需添加 `--shm-size=2g` 参数，确保使用主机的共享内存，避免性能问题。  
- 示例中使用 `latest` 标签（自动拉取最新版本），但建议使用**完整标签**固定浏览器和Grid版本，具体可参考 [标签命名规范]([])。  


## 如何选择正确的标签  

### 标签结构  
镜像标签有两种主要格式，可按需选择：  

1. 基础格式（含Grid版本和发布日期）：  
   ```  
   selenium/standalone-chrome-<主版本>.<次版本>.<修订版本>-<YYYYMMDD>  
   ```  

2. 详细格式（含浏览器、驱动、Grid版本和发布日期）：  
   ```  
   selenium/standalone-chrome-<浏览器版本>-<浏览器驱动>-<浏览器驱动版本>-<主版本>.<次版本>.<修订版本>-<YYYYMMDD>  
   ```  

此外，还支持以上格式的简化变体（如仅保留主版本或浏览器版本）。  


### 标签示例  
以2023年4月26日发布的版本为例（包含以下信息）：  
- Chrome：112.0  
- ChromeDriver：112.0  
- Selenium Grid Server：4.9.0  
- 发布日期：20230426  

对应的标签列表如下（实际镜像ID为 `e126989f151e`）：  
```  
    selenium/standalone-chrome   4  
    selenium/standalone-chrome   4.9  
    selenium/standalone-chrome   4.9.0  
    selenium/standalone-chrome   4.9.0-20230426  
    selenium/standalone-chrome   112.0                  
    selenium/standalone-chrome   112.0-20230426         
    selenium/standalone-chrome   112.0-chromedriver-112.0 
    selenium/standalone-chrome   112.0-chromedriver-112.0-20230426  
    selenium/standalone-chrome   112.0-chromedriver-112.0-grid-4.9.0-20230426  
```  

通过上述标签，可灵活选择需要的版本组合。  


## 完整文档  
Docker-Selenium项目在GitHub提供了详细的[使用说明]([])，可根据具体场景配置镜像。  


## 许可证  
项目由志愿者社区开发维护，源代码基于 [Apache License 2.0]([]) 开源。
