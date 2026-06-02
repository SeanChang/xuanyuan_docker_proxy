<!-- xuanyuan-docker-images-zh
image: stirlingtools/stirling-pdf
source: https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf
canonical: https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf
exported_at: 2026-06-02T12:15:43.568Z
-->

<p><strong>轩辕镜像中文简介（在线版）：</strong><a href="https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf" title="stirlingtools/stirling-pdf Docker 镜像中文简介、标签列表与拉取命令">stirlingtools/stirling-pdf — 轩辕镜像中文简介</a></p>

<p>含镜像标签、拉取命令、部署文档与相关推荐。</p>

<p><a href="https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf" title="stirlingtools/stirling-pdf Docker 镜像中文简介、标签列表与拉取命令">https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf</a></p>

# Stirling-PDF

## 镜像概述和主要用途

Stirling-PDF是一款功能强大的本地托管Web PDF处理工具，通过Docker部署。它支持对PDF文件执行多种操作，包括拆分、合并、转换、重组、添加图片、旋转、压缩等。作为本地托管的Web应用，其设计确保所有文件和PDF仅存在于客户端，或在任务执行期间暂存于服务器内存/临时文件中，用户下载后文件即从服务器删除，保障数据安全。

官网：[https://stirlingpdf.com](https://stirlingpdf.com)

## 核心功能和特性

- 支持50+种PDF操作
- 并行文件处理与下载
- 深色模式支持
- 自定义下载选项
- 自定义"管道"功能，可自动按队列运行多个操作
- 提供API，支持与外部脚本集成
- 可选登录和认证支持（详见[文档](https://docs.stirlingpdf.com/Advanced%20Configuration/System%20and%20Security)）
- 数据库备份与导入（详见[文档](https://docs.stirlingpdf.com/Advanced%20Configuration/DATABASE)）
- 企业级功能如SSO（详见[企业版文档](https://docs.stirlingpdf.com/Enterprise%20Edition)）

## PDF功能详情

### 页面操作

- 查看和修改PDF - 支持多页PDF查看，包含自定义视图、排序和搜索功能；支持页面编辑（注释、绘图、添加文本和图片）（基于PDF.js、Joxit和Liberation字体）
- 全交互式GUI用于合并/拆分/旋转/移动PDF及其页面
- 合并多个PDF为单个文件
- 按指定页码拆分PDF为多个文件，或提取所有页面为单个文件
- 重组PDF页面顺序
- 90度增量旋转PDF
- 删除页面
- 多页布局（将PDF格式化为多页布局）
- 按设定百分比缩放页面内容大小
- 调整对比度
- 裁剪PDF
- 自动拆分PDF（使用物理扫描的页面分隔符）
- 提取页面
- 将PDF转换为单页
- 叠加PDF文件
- 按章节拆分PDF

### 转换操作

- PDF与图片互转
- 将常见文件转换为PDF（使用LibreOffice）
- PDF转换为Word/PowerPoint等格式（使用LibreOffice）
- HTML转PDF
- PDF转XML
- PDF转CSV
- URL转PDF
- Markdown转PDF

### 安全与权限

- 添加和移除密码
- 修改/设置PDF权限
- 添加水印
- 认证/签名PDF
- 清理PDF
- 自动文本脱敏

### 其他操作

- 添加/生成/写入签名
- 按大小或PDF拆分
- 修复PDF
- 检测并移除空白页
- 比较两个PDF并显示文本差异
- 向PDF添加图片
- 压缩PDF以减小文件大小（使用qpdf）
- 从PDF提取图片
- 从PDF移除图片
- 从扫描件提取图片
- 移除注释
- 添加页码
- 通过检测PDF标题文本自动重命名文件
- PDF的OCR识别（使用Tesseract OCR）
- PDF/A转换（使用LibreOffice）
- 编辑元数据
- 扁平化PDF
- 获取PDF的所有信息并导出为JSON
- 显示/检测嵌入的JavaScript

## 支持语言

Stirling-PDF目前支持39种语言！

| 语言                                     | 进度                               |
|------------------------------------------|------------------------------------|
| 阿拉伯语（العربية）(ar_AR)               | ![88%](https://geps.dev/progress/88)   |
| 阿塞拜疆语（Azərbaycan Dili）(az_AZ)     | ![87%](https://geps.dev/progress/87)   |
| 巴斯克语（Euskara）(eu_ES)               | ![51%](https://geps.dev/progress/51)   |
| 保加利亚语（Български）(bg_BG)           | ![98%](https://geps.dev/progress/98)   |
| 加泰罗尼亚语（Català）(ca_CA)            | ![80%](https://geps.dev/progress/80)   |
| 克罗地亚语（Hrvatski）(hr_HR)            | ![85%](https://geps.dev/progress/85)   |
| 捷克语（Česky）(cs_CZ)                   | ![96%](https://geps.dev/progress/96)   |
| 丹麦语（Dansk）(da_DK)                   | ![84%](https://geps.dev/progress/84)   |
| 荷兰语（Nederlands）(nl_NL)              | ![84%](https://geps.dev/progress/84)   |
| 英语（English）(en_GB)                   | ![100%](https://geps.dev/progress/100) |
| 英语（美国）(en_US)                      | ![100%](https://geps.dev/progress/100) |
| 法语（Français）(fr_FR)                  | ![96%](https://geps.dev/progress/96)   |
| 德语（Deutsch）(de_DE)                   | ![98%](https://geps.dev/progress/98)   |
| 希腊语（Ελληνικά）(el_GR)                | ![96%](https://geps.dev/progress/96)   |
| 印地语（हिंदी）(hi_IN)                   | ![97%](https://geps.dev/progress/97)   |
| 匈牙利语（Magyar）(hu_HU)                | ![94%](https://geps.dev/progress/94)   |
| 印度尼西亚语（Bahasa Indonesia）(id_ID)  | ![85%](https://geps.dev/progress/85)   |
| 爱尔兰语（Gaeilge）(ga_IE)               | ![96%](https://geps.dev/progress/96)   |
| 意大利语（Italiano）(it_IT)              | ![99%](https://geps.dev/progress/99)   |
| 日语（日本語）(ja_JP)                    | ![93%](https://geps.dev/progress/93)   |
| 韩语（한국어）(ko_KR)                    | ![97%](https://geps.dev/progress/97)   |
| 挪威语（Norsk）(no_NB)                   | ![77%](https://geps.dev/progress/77)   |
| 波斯语（فارسی）(fa_IR)                   | ![93%](https://geps.dev/progress/93)   |
| 波兰语（Polski）(pl_PL)                  | ![84%](https://geps.dev/progress/84)   |
| 葡萄牙语（Português）(pt_PT)             | ![96%](https://geps.dev/progress/96)   |
| 巴西葡萄牙语（Português）(pt_BR)         | ![97%](https://geps.dev/progress/97)   |
| 罗马尼亚语（Română）(ro_RO)               | ![79%](https://geps.dev/progress/79)   |
| 俄语（Русский）(ru_RU)                   | ![96%](https://geps.dev/progress/96)   |
| 塞尔维亚语（拉丁语）(Srpski)(sr_LATN_RS)  | ![63%](https://geps.dev/progress/63)   |
| 简体中文（zh_CN）                        | ![98%](https://geps.dev/progress/98)   |
| 斯洛伐克语（Slovensky）(sk_SK)           | ![73%](https://geps.dev/progress/73)   |
| 斯洛文尼亚语（Slovenščina）(sl_SI)       | ![95%](https://geps.dev/progress/95)   |
| 西班牙语（Español）(es_ES)               | ![97%](https://geps.dev/progress/97)   |
| 瑞典语（Svenska）(sv_SE)                 | ![92%](https://geps.dev/progress/92)   |
| 泰语（ไทย）(th_TH)                       | ![84%](https://geps.dev/progress/84)   |
| 藏语（བོད་ཡིག་）(zh_BO)                  | ![93%](https://geps.dev/progress/93)   |
| 繁体中文（zh_TW）                        | ![98%](https://geps.dev/progress/98)   |
| 土耳其语（Türkçe）(tr_TR)                | ![81%](https://geps.dev/progress/81)   |
| 乌克兰语（Українська）(uk_UA)            | ![71%](https://geps.dev/progress/71)   |
| 越南语（Tiếng Việt）(vi_VN)              | ![78%](https://geps.dev/progress/78)   |

## Stirling PDF 企业版

Stirling PDF提供企业版软件，包含与基础版相同的核心功能，并增加了额外功能、支持和便利特性。查看[企业版文档](https://docs.stirlingpdf.com/Enterprise%20Edition)了解更多。

所有文档详见[https://docs.stirlingpdf.com/](https://docs.stirlingpdf.com/)

---

<p><strong>镜像详情与拉取命令（轩辕镜像）：</strong><a href="https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf" title="stirlingtools/stirling-pdf Docker 镜像中文简介、标签与拉取命令">https://xuanyuan.cloud/zh/r/stirlingtools/stirling-pdf</a></p>
