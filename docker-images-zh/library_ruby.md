---
image: library/ruby
description: "Ruby是一种动态的编程语言，支持动态类型与动态方法定义，具备强大的反射机制，能够在运行时获取并操作自身信息；它以面向对象思想为核心，秉持“万物皆对象”的设计理念，适用于Web开发、脚本编写、系统工具开发等多种通用场景，且作为开源软件，拥有免费使用的特性和活跃的全球开发者社区提供持续支持与维护。"
source: https://xuanyuan.cloud/zh/r/library/ruby
canonical: https://xuanyuan.cloud/zh/r/library/ruby
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/library/ruby" title="library/ruby Docker 镜像中文简介、标签列表与拉取命令">library/ruby 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Ruby Docker镜像使用指南


## 快速参考

### 维护者  
[Docker社区] 

### 获取帮助  
[Docker社区Slack] 、[Server Fault] 、[Unix & Linux]  或 [Stack Overflow] 

### 提交issue  
[[]] 

### 支持的架构  
（[更多信息] ）  
[`amd64`] 、[`arm32v5`] 、[`arm32v6`] 、[`arm32v7`] 、[`arm64v8`] 、[`i386`] 、[`mips64le`] 、[`ppc64le`] 、[`riscv64`] 、[`s390x`] 

### 镜像详情  
[repo-info仓库的`repos/ruby/`目录] （[历史记录] ）  
（包含镜像元数据、传输大小等）

### 镜像更新  
[official-images仓库的`library/ruby`标签]   
[official-images仓库的`library/ruby`文件] （[历史记录] ）

### 本描述来源  
[docs仓库的`ruby/`目录] （[历史记录] ）


## 支持的标签及对应Dockerfile链接  

### 3.5-rc（预览版）  
- [`3.5.0-preview1-trixie`, `3.5-rc-trixie`, `3.5.0-preview1`, `3.5-rc`]   
- [`3.5.0-preview1-slim-trixie`, `3.5-rc-slim-trixie`, `3.5.0-preview1-slim`, `3.5-rc-slim`]   
- [`3.5.0-preview1-bookworm`, `3.5-rc-bookworm`]   
- [`3.5.0-preview1-slim-bookworm`, `3.5-rc-slim-bookworm`]   
- [`3.5.0-preview1-alpine3.22`, `3.5-rc-alpine3.22`, `3.5.0-preview1-alpine`, `3.5-rc-alpine`]   
- [`3.5.0-preview1-alpine3.21`, `3.5-rc-alpine3.21`]   


### 3.4（稳定版，含`latest`标签）  
- [`3.4.7-trixie`, `3.4-trixie`, `3-trixie`, `trixie`, `3.4.7`, `3.4`, `3`, `latest`]   
- [`3.4.7-slim-trixie`, `3.4-slim-trixie`, `3-slim-trixie`, `slim-trixie`, `3.4.7-slim`, `3.4-slim`, `3-slim`, `slim`]   
- [`3.4.7-bookworm`, `3.4-bookworm`, `3-bookworm`, `bookworm`]   
- [`3.4.7-slim-bookworm`, `3.4-slim-bookworm`, `3-slim-bookworm`, `slim-bookworm`]   
- [`3.4.7-alpine3.22`, `3.4-alpine3.22`, `3-alpine3.22`, `alpine3.22`, `3.4.7-alpine`, `3.4-alpine`, `3-alpine`, `alpine`]   
- [`3.4.7-alpine3.21`, `3.4-alpine3.21`, `3-alpine3.21`, `alpine3.21`]   


### 3.3  
- [`3.3.9-trixie`, `3.3-trixie`, `3.3.9`, `3.3`]   
- [`3.3.9-slim-trixie`, `3.3-slim-trixie`, `3.3.9-slim`, `3.3-slim`]   
- [`3.3.9-bookworm`, `3.3-bookworm`]   
- [`3.3.9-slim-bookworm`, `3.3-slim-bookworm`]   
- [`3.3.9-alpine3.22`, `3.3-alpine3.22`, `3.3.9-alpine`, `3.3-alpine`]   
- [`3.3.9-alpine3.21`, `3.3-alpine3.21`]   


### 3.2  
- [`3.2.9-trixie`, `3.2-trixie`, `3.2.9`, `3.2`]   
- [`3.2.9-slim-trixie`, `3.2-slim-trixie`, `3.2.9-slim`, `3.2-slim`]   
- [`3.2.9-bookworm`, `3.2-bookworm`]   
- [`3.2.9-slim-bookworm`, `3.2-slim-bookworm`]   
- [`3.2.9-alpine3.22`, `3.2-alpine3.22`, `3.2.9-alpine`, `3.2-alpine`]   
- [`3.2.9-alpine3.21`, `3.2-alpine3.21`]   


## 什么是Ruby?  

Ruby是一种动态、反射式、面向对象的通用开源编程语言。其设计者表示，Ruby受Perl、Smalltalk、Eiffel、Ada和Lisp等语言影响，支持函数式、面向对象、命令式等多种编程范式，具备动态类型系统和自动内存管理。  

> [维基百科：Ruby（编程语言）]()  

![Ruby logo]   


## 如何使用本镜像  

### 创建Ruby应用的Dockerfile  

在Ruby项目根目录创建`Dockerfile`：  

```dockerfile
FROM docker.xuanyuan.run/ruby:3.3  # 可替换为其他标签，如ruby:3.4-slim

# 若Gemfile自Gemfile.lock后有修改，则抛出错误
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["./your-daemon-or-script.rb"]  # 替换为实际脚本路径
```  

将此文件放在项目根目录（与`Gemfile`同级），执行以下命令构建并运行：  

```console
$ docker build -t my-ruby-app .
$ docker run -it --name my-running-script my-ruby-app
```  


### 生成Gemfile.lock  

上述`Dockerfile`需项目根目录存在`Gemfile.lock`。若本地未生成，可通过以下命令生成：  

```console
$ docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:3.3 bundle install
```  

（在项目根目录执行，`ruby:3.3`可替换为实际使用的镜像标签）  


### 运行单个Ruby脚本  

对于简单的单文件项目，可直接使用Ruby镜像运行脚本，无需编写`Dockerfile`：  

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp ruby:3.3 ruby your-daemon-or-script.rb
```  

（`your-daemon-or-script.rb`替换为实际脚本文件名）  


### 编码设置  

Ruby默认继承运行环境的 locale。桌面环境通常使用`*.UTF-8`（如`en_US.UTF-8`），但Docker默认locale为`C`，可能导致编码问题。若应用需处理UTF-8，建议通过环境变量显式设置：  

```console
$ docker run -e LANG=C.UTF-8 ...  # 运行时设置
# 或在Dockerfile中添加：ENV LANG C.UTF-8
```  


### 镜像假设  

本镜像设置了多个环境变量（如`GEM_HOME`、`BUNDLE_SILENCE_ROOT_WARNING`、`BUNDLE_APP_CONFIG`），优化容器内单应用运行场景（例如避免宿主机`.bundle`目录干扰容器内依赖）。变量定义可在对应`Dockerfile`中查看。  

若需在单个容器中运行多个Ruby应用，可将这些变量设为空字符串以禁用默认行为。  


## 镜像变体  

Ruby镜像提供多种变体，适用于不同场景：  


### ruby:\<version>（默认版本）  

适合大多数用户，基于`buildpack-deps`构建，包含大量常用Debian包，减少衍生镜像的依赖安装需求。标签中含 Debian 代号（如`trixie`、`bookworm`）的变体，基于对应Debian版本，建议显式指定代号以避免Debian版本更新导致的兼容性问题。  


### ruby:\<version>-slim（精简版本）  

仅包含运行Ruby所需的最小依赖，体积小于默认版本，适合空间受限的环境。但不含默认版本中的常见工具，需自行安装额外依赖。  


### ruby:\<version>-alpine（Alpine版本）  

基于[Alpine Linux] （[`alpine`官方镜像] ），体积极小（基础镜像约5MB），适合对镜像大小敏感的场景。  

**注意**：Alpine使用`musl libc`而非`glibc`，可能存在兼容性问题；且默认不含`git`、`bash`等工具，需在`Dockerfile`中自行安装（参考[Alpine镜像文档] ）。  


## 许可证  

- Ruby语言许可证：[查看详情]   
- 镜像中其他软件（如Debian基础系统组件）可能使用其他许可证，可在[repo-info仓库的`ruby/`目录] 查看自动检测的许可证信息。  

使用前请确保遵守所有包含软件的许可证要求。
