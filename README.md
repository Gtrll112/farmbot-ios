# 农场助手 iOS App

WKWebView 壳应用，加载农场面板，自动登录（无需手动输入密码）。

## 功能
- 加载面板地址：`http://frp-six.com:64450`
- 自动注入登录脚本（admin / 880828）
- 全屏显示，隐藏状态栏
- 支持手势返回

## 修改配置
编辑 `FarmBotApp/ContentView.swift`：
- `targetURL`：面板地址
- `username` / `password`：登录账号密码

## 编译生成 IPA

### 方式一：GitHub Actions（推荐，不需要 Mac）
1. 将本项目推送到 GitHub 仓库
2. 进入 Actions → Build IPA → Run workflow
3. 等待编译完成（约 3-5 分钟）
4. 下载 Artifact `FarmBotApp-ipa` 中的 `FarmBotApp.ipa`

### 方式二：本地 Xcode（需要 Mac）
```bash
xcodebuild \
  -project FarmBotApp.xcodeproj \
  -scheme FarmBotApp \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -derivedDataPath build \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build

mkdir -p Payload
cp -R build/Build/Products/Release-iphoneos/FarmBotApp.app Payload/
zip -r FarmBotApp.ipa Payload
```

## 侧载安装（Sideloadly）

### 准备
- 下载 [Sideloadly](https://sideloadly.io/)（Windows / macOS 均可）
- Apple ID（免费账号即可，7天有效期；付费开发者账号1年）

### 步骤
1. 手机用数据线连接电脑
2. 打开 Sideloadly
3. IPA 文件拖入 Sideloadly
4. 输入 Apple ID（免费账号即可）
5. 点击 Start，等待安装完成
6. 手机上：设置 → 通用 → VPN与设备管理 → 信任你的 Apple ID 证书
7. 打开"农场助手"App

### 续签（免费账号每7天）
- 重新用 Sideloadly 安装一次即可（覆盖安装，数据不丢失）
- 或使用 Sideloadly 的自动续签功能

## 注意
- 免费 Apple ID 签名有效期 7 天，到期后 App 无法打开，需重新侧载
- 同一 Apple ID 最多同时安装 3 个侧载应用
- 外网穿透必须正常运行，否则 App 无法加载面板
