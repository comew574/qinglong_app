# 更新日志

本项目的版本记录。历史改动见 [Release](https://github.com/comew574/qinglong_app/releases)。

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
