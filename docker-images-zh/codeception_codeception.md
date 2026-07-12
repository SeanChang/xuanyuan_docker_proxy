---
image: codeception/codeception
description: "Codeception官方Docker镜像，提供现代化PHP全栈测试框架，支持验收测试、功能测试及单元测试，简化PHP应用测试流程，受BDD启发提供直观测试编写方式。"
source: https://xuanyuan.cloud/zh/r/codeception/codeception
canonical: https://xuanyuan.cloud/zh/r/codeception/codeception
exported_at: 2026-07-12T16:36:12.930Z
---

**轩辕镜像中文简介（在线版）：** <a href="https://xuanyuan.cloud/zh/r/codeception/codeception" title="codeception/codeception Docker 镜像中文简介、标签列表与拉取命令">codeception/codeception 中文简介</a>

含镜像标签、拉取命令、部署文档与相关推荐。

# Codeception

**面向所有人的现代PHP测试框架**

Codeception是一款现代化的PHP全栈测试框架。受BDD（行为驱动开发）启发，它提供了一种全新的方式来编写验收测试、功能测试甚至单元测试。

## 核心功能与特性

- **多测试类型支持**：统一支持验收测试、功能测试和单元测试
- **直观的测试描述**：使用PHP编写测试场景，语法简洁易懂
- **PHPUnit兼容性**：可运行传统PHPUnit单元测试
- **详细测试报告**：执行测试时展示详细操作步骤和结果
- **数据库交互验证**：直接在测试中验证数据库状态

## 使用场景

- PHP Web应用的功能验证与回归测试
- 用户行为流程的验收测试
- 单元测试与集成测试的自动化执行
- 开发团队的持续集成测试流程

## 使用方法

### 初始化配置

通过以下命令初始化测试配置文件和默认目录结构：

```sh
docker container run --rm -v $(pwd):/project/ --user $(id -u):$(id -g) codeception/codeception:latest bootstrap
```

### 生成测试文件

生成首个测试文件：

```sh
docker container run --rm -v $(pwd):/project/ --user $(id -u):$(id -g) codeception/codeception:latest generate:cest Functional First
```

### 运行测试

编辑生成的测试文件 `tests/Functional/FirstCest.php` 后，执行测试：

```sh
docker container run --rm -v $(pwd):/project/ --user $(id -u):$(id -g) codeception/codeception:latest run
```

## 示例测试

```php
$I->amOnPage('/');
$I->click('Pages');
$I->click('New');
$I->see('New Page');
$I->submitForm('form#new_page', ['title' => 'Movie Review']);
$I->see('page created'); // 验证通知生成
$I->see('Movie Review','h1'); // 验证页面标题
$I->seeInCurrentUrl('pages/movie-review'); // 验证URL slug
$I->seeInDatabase('pages', ['title' => 'Movie Review']); // 验证数据库存储
```

## 文档与资源

[查看完整文档](https://codeception.com/docs/Introduction)

## 贡献指南

Codeception欢迎社区贡献。如欲提交代码或文档的补充与修复，请查看[贡献指南](https://github.com/Codeception/Codeception/blob/5.0/CONTRIBUTING.md)。

## 许可证

MIT

(c) [Codeception团队](https://codeception.com/credits) 2011-2022
