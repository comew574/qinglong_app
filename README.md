# qinglong_app

青龙面板（[Qinglong](https://github.com/whyour/qinglong)）的第三方 Android 客户端，使用 Flutter 编写。

> 本仓库基于 [qinglong_app](https://github.com/qinglongapp/qinglong_app) 二次维护，主要跟进青龙新版本的接口变化。

---

## ✨ 功能

| 模块 | 说明 |
| --- | --- |
| 任务管理 | 查看 / 新增 / 编辑 / 运行 / 停止 / 置顶定时任务，查看实时日志 |
| 环境变量 | 增删改查、启停、排序、批量操作 |
| 脚本管理 | 目录树浏览、查看 / 编辑 / 新建 / 上传 / 下载 / 重命名 / 删除，新建文件夹 |
| 配置文件 | 查看与编辑 `config.sh` 等配置文件 |
| 订阅管理 | 增删改查、启停、运行、查看日志 |
| 日志 | 任务日志、依赖日志、订阅日志、登录日志 |
| 依赖管理 | 查看、安装、重装、删除 |
| 应用授权 | 查看 / 新增 / 删除应用密钥（App Key） |
| 多账号 | 同时管理多个青龙面板实例，支持切换 |
| 登录方式 | 账号密码登录、两步验证、**应用密钥登录**（`/open/*` 接口） |

---

## 📱 下载安装

前往 [Releases](https://github.com/comew574/qinglong_app/releases) 下载最新版 APK。

| 项 | 值 |
| --- | --- |
| 包名 | `work.master.qinglongapp` |
| 最低系统 | Android 7.0（API 24） |
| 目标 SDK | 35 |
| 架构 | arm64-v8a / armeabi-v7a / x86_64 |
| 签名 | **debug 签名**（`androiddebugkey`） |

> ⚠️ **关于签名**：目前发布的是 debug 签名包，适合个人自用。若安装时提示签名冲突，
> 请先卸载旧版本再安装。卸载不会影响青龙服务端的数据。

---

## 🚀 从源码构建

### 环境要求

| 工具 | 版本 |
| --- | --- |
| Flutter | 3.47.2（stable） |
| Dart | 随 Flutter 附带 |
| JDK | 17 |
| Android SDK | compileSdk 36 / targetSdk 35 / minSdk 24 |
| NDK | 28.2.13676358 |
| Gradle | 8.14.3（随仓库 wrapper） |
| Android Gradle Plugin | 8.11.1 |

### 构建步骤

```bash
# 1. 拉取依赖
flutter pub get

# 2. 编译 release APK（仅 arm64）
flutter build apk --release --target-platform android-arm64

# 产物位置
# build/app/outputs/flutter-apk/app-release.apk
```

### 关于 `vendor/`

`pubspec.yaml` 中下列依赖使用**本地路径**引用（位于 `vendor/` 目录），改动这些库时无需发布到 pub.dev：

```
json_conversion_annotation
move_to_background
flutter_animator
icloud_storage
launch_review
json_table
```

---

## 🔧 版本兼容性

本客户端需要与青龙服务端版本配合使用。关键接口变更记录：

| 青龙版本 | 变更 | 客户端适配 |
| --- | --- | --- |
| 2.13.0+ | 日志详情接口参数变化 | 按版本自动切换 |
| 2.21 | 移除 `/api/system/log/remove` | 已适配 |
| **2.23.0** | **下线 `GET /api/scripts/<file>`、`GET /api/configs/<file>`（返回 410）；<br>新增 `/scripts/detail`、`/configs/detail`** | **3.0.5 起已适配** |
| **2.23.0** | 路径中间件 `protectedPathCase` 拒绝 `/api/`、`/open/` 下含**大写**的路径 | **3.0.5 起改为 query 传参** |

> 若使用 2.23.0 以下版本的青龙，建议使用 [3.0.0](https://github.com/comew574/qinglong_app/releases) 或更早的客户端。

---

## 📋 更新日志

见 [CHANGELOG.md](CHANGELOG.md)。

---

## 🗂 目录结构

```
lib/
├── base/                    # 基础设施
│   ├── http/                # 网络层（api.dart / url.dart / http.dart）
│   ├── ui/                  # 通用组件（树形控件等）
│   ├── routes.dart          # 路由表
│   └── theme.dart           # 主题
├── module/                  # 业务模块
│   ├── appkey/              # 应用密钥
│   ├── code_editor/         # 代码编辑器（CodeMirror 封装）
│   ├── config/              # 配置文件
│   ├── env/                 # 环境变量
│   ├── home/                # 首页
│   ├── login/               # 登录
│   ├── others/scripts/      # 脚本管理
│   ├── subscribe/           # 订阅
│   └── task/                # 任务与日志
├── utils/                   # 工具函数
└── main.dart                # 入口
vendor/                      # 本地依赖的第三方库
android/                     # Android 工程
ios/                         # iOS 工程（未维护）
```

---

## 🔐 相关链接

- 青龙主项目：<https://github.com/whyour/qinglong>
- 上游客户端：<https://github.com/qinglongapp/qinglong_app>
- 青龙接口文档：[AGHTechDoc](https://github.com/whyour/qinglong/blob/develop/AGHTechDoc.md)

---

## 📜 许可

本项目遵循 [AGPL-3.0](LICENSE) 许可协议。

---

## ⚠️ 免责声明

本项目为第三方客户端，与青龙官方无关。使用本软件产生的任何后果由使用者自行承担。
