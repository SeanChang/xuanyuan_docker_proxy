---
image: mcp/playwright
description: "Playwright MCP服务器是基于微软Playwright自动化测试工具的管理控制平台，主要用于跨浏览器（如Chrome、Firefox、WebKit等）的端到端测试任务调度与执行，支持用户交互模拟、多环境部署管理、测试资源分配、CI/CD流程集成及测试结果分析，能有效提升Web应用测试效率，保障应用在不同浏览器和设备上的兼容性与稳定性，助力开发团队实现高质量软件交付。"
source: https://xuanyuan.cloud/zh/r/mcp/playwright
exported_at: 2026-06-02T11:56:54.554Z
---

> **轩辕镜像中文简介（在线版）**：[mcp/playwright](https://xuanyuan.cloud/zh/r/mcp/playwright)
> 含镜像标签、拉取命令、部署文档与相关推荐。

# Playwright MCP Server  
基于Playwright的模型上下文协议（MCP）服务器。  
[什么是MCP服务器？]([])  


## 基本特性  
| 属性 | 详情 |  
|------|------|  
| **Docker镜像** | [mcp/playwright]([]) |  
| **作者** | [microsoft]([]) |  
| **代码仓库** | [] |  
| **Dockerfile** | [] |  
| **镜像构建方** | Docker Inc. |  
| **Docker Scout健康评分** | ![Docker Scout Health Score]([]) |  
| **验证签名** | `COSIGN_REPOSITORY=mcp/signatures cosign verify mcp/playwright --key [] |  
| **许可证** | Apache License 2.0 |  


## 可用工具（21个）  
| 服务器提供的工具 | 简要说明 |  
|------------------|----------|  
| `browser_click` | 点击页面元素 |  
| `browser_close` | 关闭浏览器页面 |  
| `browser_console_messages` | 获取控制台消息 |  
| `browser_drag` | 鼠标拖拽操作 |  
| `browser_evaluate` | 执行JavaScript代码 |  
| `browser_file_upload` | 上传文件 |  
| `browser_fill_form` | 填写表单字段 |  
| `browser_handle_dialog` | 处理弹窗 |  
| `browser_hover` | 鼠标悬停元素 |  
| `browser_install` | 安装配置中指定的浏览器 |  
| `browser_navigate` | 导航至URL |  
| `browser_navigate_back` | 返回上一页 |  
| `browser_network_requests` | 列出网络请求 |  
| `browser_press_key` | 模拟按键操作 |  
| `browser_resize` | 调整浏览器窗口大小 |  
| `browser_select_option` | 选择下拉框选项 |  
| `browser_snapshot` | 捕获页面可访问性快照 |  
| `browser_tabs` | 管理标签页（列出/创建/关闭/切换） |  
| `browser_take_screenshot` | 截取页面截图 |  
| `browser_type` | 在元素中输入文本 |  
| `browser_wait_for` | 等待文本出现/消失或指定时长 |  


## 工具详情  

#### 工具：**`browser_click`**  
在网页上执行点击操作  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `element` | `string` | 用于获取交互权限的元素描述（人类可读） |  
| `ref` | `string` | 页面快照中的目标元素精确引用 |  
| `button` | `string` *可选* | 点击的鼠标按键，默认左键 |  
| `doubleClick` | `boolean` *可选* | 是否执行双击（默认单击） |  
| `modifiers` | `array` *可选* | 需按下的修饰键 |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_close`**  
关闭当前页面  


---  
#### 工具：**`browser_console_messages`**  
获取所有控制台消息  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `onlyErrors` | `boolean` *可选* | 是否仅返回错误消息 |  

*此工具为只读，不修改环境。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_drag`**  
在两个元素间执行拖放操作  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `endElement` | `string` | 目标元素的人类可读描述（用于获取交互权限） |  
| `endRef` | `string` | 目标元素的精确引用（来自页面快照） |  
| `startElement` | `string` | 源元素的人类可读描述（用于获取交互权限） |  
| `startRef` | `string` | 源元素的精确引用（来自页面快照） |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_evaluate`**  
在页面或元素上执行JavaScript表达式  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `function` | `string` | 执行的代码，格式为 `() => { /* 代码 */ }`；若提供元素，格式为 `(element) => { /* 代码 */ }` |  
| `element` | `string` *可选* | 用于获取交互权限的元素描述（人类可读） |  
| `ref` | `string` *可选* | 页面快照中的目标元素精确引用 |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_file_upload`**  
上传一个或多个文件  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `paths` | `array` *可选* | 待上传文件的绝对路径（支持单个或多个文件）；若省略则取消文件选择 |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_fill_form`**  
填写多个表单字段  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `fields` | `array` | 需填写的字段列表 |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_handle_dialog`**  
处理弹窗  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `accept` | `boolean` | 是否接受弹窗 |  
| `promptText` | `string` *可选* | 若为提示框（prompt），需输入的文本 |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_hover`**  
鼠标悬停在页面元素上  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `element` | `string` | 用于获取交互权限的元素描述（人类可读） |  
| `ref` | `string` | 页面快照中的目标元素精确引用 |  

*此工具为只读，不修改环境。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_install`**  
安装配置中指定的浏览器。若遇到浏览器未安装的错误，可调用此工具。  


---  
#### 工具：**`browser_navigate`**  
导航至指定URL  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `url` | `string` | 目标URL |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_navigate_back`**  
返回上一页  


---  
#### 工具：**`browser_network_requests`**  
返回页面加载后的所有网络请求  


---  
#### 工具：**`browser_press_key`**  
模拟键盘按键  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `key` | `string` | 按键名称或字符，如 `ArrowLeft`（左箭头）或 `a` |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_resize`**  
调整浏览器窗口大小  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `height` | `number` | 窗口高度 |  
| `width` | `number` | 窗口宽度 |  

*此工具为只读，不修改环境。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_select_option`**  
选择下拉框中的选项  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `element` | `string` | 用于获取交互权限的元素描述（人类可读） |  
| `ref` | `string` | 页面快照中的目标元素精确引用 |  
| `values` | `array` | 待选择的选项值（单个或多个） |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_snapshot`**  
捕获当前页面的可访问性快照（比截图更适用于后续操作）  


---  
#### 工具：**`browser_tabs`**  
列出、创建、关闭或切换浏览器标签页  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `action` | `string` | 操作类型（如列出/创建/关闭/切换） |  
| `index` | `number` *可选* | 标签页索引（用于关闭/切换），关闭时若省略则关闭当前标签页 |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_take_screenshot`**  
截取当前页面截图（无法基于截图执行后续操作，需用 `browser_snapshot`）  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `element` | `string` *可选* | 截图元素的人类可读描述（需与 `ref` 同时提供，否则截取视口） |  
| `filename` | `string` *可选* | 截图保存文件名，默认 `page-{timestamp}.{png|jpeg}` |  
| `fullPage` | `boolean` *可选* | 是否截取整页（滚动区域），不可与元素截图同时使用 |  
| `ref` | `string` *可选* | 页面快照中的目标元素精确引用（需与 `element` 同时提供） |  
| `type` | `string` *可选* | 截图格式，默认 png |  

*此工具为只读，不修改环境。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_type`**  
在可编辑元素中输入文本  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `element` | `string` | 用于获取交互权限的元素描述（人类可读） |  
| `ref` | `string` | 页面快照中的目标元素精确引用 |  
| `text` | `string` | 输入的文本内容 |  
| `slowly` | `boolean` *可选* | 是否逐字符输入（默认一次性填入，逐字符输入可触发页面按键事件） |  
| `submit` | `boolean` *可选* | 输入后是否提交（按Enter键） |  

*此工具可能执行破坏性更新。*  
*此工具与外部实体交互。*  


---  
#### 工具：**`browser_wait_for`**  
等待文本出现/消失或指定时长  

| 参数 | 类型 | 说明 |  
|------|------|------|  
| `text` | `string` *可选* | 等待出现的文本 |  
| `textGone` | `string` *可选* | 等待消失的文本 |  
| `time` | `number` *可选* | 等待时长（秒） |  

*此工具为只读，不修改环境。*  
*此工具与外部实体交互。*  


---  
## 使用此MCP服务器  

配置示例如下：  

```json
{
  "mcpServers": {
    "playwright": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "mcp/playwright"
      ]
    }
  }
}
```  

[为什么使用Docker运行MCP服务器更安全？]([])
