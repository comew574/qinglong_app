# 更新日志

本项目的版本记录。历史改动见 [Release](https://github.com/comew574/qinglong_app/releases)。

## 3.0.5 (2026-10-18 更新)

本版在原 3.0.5 基础上，进一步修复青龙 2.23.0 接口变更带来的问题，并补齐新接口。

### 修复

* **查看任务日志详情报「接口已下线，请使用 /logs/detail 接口」**
  青龙 2.23.0 下线 `GET /api/logs/<文件名>?path=<目录>`（返回 410）。
  **改为** `GET /api/logs/detail?file=<文件名>&path=<目录>`。
  ⚠️ 注：版本判断阈值必须用 `022300`（`2.23.0` → `"0"+"23"+"0"` → `022300`），
  写成 `23000` 会导致判断永远为 false。

* **清除日志频率设置失效**
  青龙 2.23.0 下线 `/api/system/log/remove`。
  **读取**改为 `GET /api/system/config`（字段 `info.logRemoveFrequency`）；
  **修改**改为 `PUT /api/system/config/log-remove-frequency`，body `{"logRemoveFrequency": n}`。

### 新增

补充青龙 2.23.0 新增接口（均带版本保护，低于 2.23 返回 `code: 426`，不发请求）：

* 脚本：历史版本列表/详情/恢复、重命名、运行、停止、下载
* 任务：详情、运行实例列表、停止实例
* 环境变量：重命名、置顶、取消置顶
* 系统：系统日志、时区、语言、面板标题、日志下载
* Dashboard：概览、趋势
* 用户：登出、IP 黑名单
* 配置：示例配置

## 3.0.5 (2026-10-17)

本版为**兼容青龙 2.23.0+** 的适配版本，修复了「查看脚本内容」「查看配置文件」「新增文件夹」三处报错。

### 修复

* **查看脚本内容报 `Invalid path format`**
  青龙 2.23.0 起，`/api/scripts/<文件名>` 这类「把文件名拼进 URL 路径」的写法会被后端的
  `protectedPathCase` 中间件拦截——因为部分脚本名含大写字母（如 `LaoWang_v05_87.py`），
  而该中间件要求 `/api/`、`/open/` 下的路径必须全小写。
  **改为** `GET /api/scripts/detail?file=<文件名>&path=<目录>`，文件名走 query 参数，不再触发该限制。

* **查看配置文件报 `接口已下线，请使用 /scripts/detail 接口`**
  青龙 2.23.0 下线了 `GET /api/configs/<文件名>`（返回 `410`）。
  **改为** `GET /api/configs/detail?path=<文件名>`。

* **新增文件夹报 `Validation failed`**
  后端 `POST /api/scripts` 的 Joi 校验要求 `filename` 为必填字段，App 原来只提交了
  `directory` 和 `path`，因此校验不通过。
  **改为**同时提交 `filename`（取文件夹名）+ `directory`，与官方 Web 前端行为一致。

### 其它

* 密钥登录模式（`/open/*` 前缀）同步适配：`/open/*` 会被后端重写为 `/api/*`，
  上述改动同样生效。
* 统一构建工具链：`compileSdk 36`、NDK 28.2.13676358，兼容 AGP 8.11.1 / Gradle 8.14.3。

### 说明

* 本版 APK 使用 **debug 签名**（`androiddebugkey`），可直接覆盖安装同签名的旧版本。
* 目标 SDK 35，最低 SDK 24。

## 2.6.3

* 修改环境变量最后一条可能无法展示完整的问题
* 修改首页可能会出现大量空白的问题
* 移除App内的消息推送功能
* Android端部分机型输入法选择文本可能会崩溃，这是框架的问题，等官方解决了再更新吧
