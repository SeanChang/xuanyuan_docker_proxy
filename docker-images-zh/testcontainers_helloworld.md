---
image: testcontainers/helloworld
description: "Testcontainers是一款帮助开发者在测试环境中便捷集成并使用真实依赖服务（如数据库、消息队列、缓存等）的工具，而此Docker镜像专门用于支持Testcontainers自身的自测套件运行，可确保其核心功能（包括容器生命周期管理、跨平台兼容性、服务模拟准确性等）在不同测试场景下均能得到稳定验证，为Testcontainers的持续迭代优化和整体质量保障提供关键技术支撑。"
source: https://xuanyuan.cloud/zh/r/testcontainers/helloworld
canonical: https://xuanyuan.cloud/zh/r/testcontainers/helloworld
exported_at: 2026-06-02T12:04:49.546Z
---

**轩辕镜像中文简介（在线版）：** [testcontainers/helloworld — 轩辕镜像中文简介](https://xuanyuan.cloud/zh/r/testcontainers/helloworld)

含镜像标签、拉取命令、部署文档与相关推荐。

[testcontainers/helloworld Docker 镜像中文简介、标签列表与拉取命令](https://xuanyuan.cloud/zh/r/testcontainers/helloworld)

# Testcontainers Helloworld Docker镜像  


## 用途说明  
此Docker镜像专为Testcontainers项目的自测试套件设计，不建议在Testcontainers项目外使用。  


## 核心特性  
其内置小型HTTP服务器，具备以下特性，用于辅助测试验证：  

- **多端口服务**：在两个端口（8080和8081）提供服务，可用于测试Docker容器多端口暴露功能。  
- **HTML根页面**：提供包含基础元素的HTML根页面，用于验证基于浏览器的测试工具能否正常访问容器。  
- **/ping端点**：在/ping路径提供非HTML格式响应，用于基础HTTP协议测试。  
- **/uuid端点**：在/uuid路径返回当前容器实例唯一的UUID，可用于测试多容器实例部署或容器启停行为。  
- **启动延迟配置**：支持通过环境变量`DELAY_START_MSEC`设置启动延迟（单位：毫秒），用于测试启动等待策略（TCP或HTTP-based）。当该变量设为非零值时，容器启动流程为：  
  1. 等待指定时长；  
  2. 启动8080端口服务器；  
  3. 再次等待相同时长；  
  4. 启动8081端口服务器。  
- **启动日志输出**：服务器启动完成后输出基础日志消息，可用于测试基于日志的等待策略。  


## 示例使用  
运行容器时需映射端口并按需配置环境变量，示例命令及输出如下：  

```bash
$ docker run -p 8080:8080 -p 8081:8081 -e DELAY_START_MSEC=2000 testcontainers/helloworld

2020/09/26 08:50:55 DELAY_START_MSEC: 2000
2020/09/26 08:50:55 Sleeping for 2000 ms
2020/09/26 08:50:57 Starting server on port 8080
2020/09/26 08:50:57 Sleeping for 2000 ms
2020/09/26 08:50:59 Starting server on port 8081
2020/09/26 08:50:59 Ready, listening on 8080 and 8081
```  


## 许可证  
参见[LICENSE](./LICENSE)。  


## 版权信息  
版权所有 (c) 2020 Richard North及其他作者。
