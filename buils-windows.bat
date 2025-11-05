@echo off
setlocal EnableDelayedExpansion
:: 此脚本用于 Windows 平台，编译 Go 程序为不同平台的可执行文件。
:: 参数：
:: %1: Go 文件名（默认: aigo.go）
:: %2: 版本号（默认: v1.03）
:: %3: 输出文件名前缀（默认: proxy-checker）
:: %4: 配置文件名（默认: config.ini，将复制到每个平台的构建目录，如果存在）

set GO_FILE=%1
if "%GO_FILE%"=="" set GO_FILE=aigo.go

set VERSION=%2
if "%VERSION%"=="" set VERSION=v1.0.3

set PREFIX=%3
if "%PREFIX%"=="" set PREFIX=s5代理批量检测

set CONFIG_FILE=%4
if "%CONFIG_FILE%"=="" set CONFIG_FILE=config.ini

echo --- 开始为不同平台编译可执行程序 ---
echo 使用 Go 文件: %GO_FILE%
echo 使用版本号: %VERSION%
echo 使用前缀: %PREFIX%
echo 使用配置文件: %CONFIG_FILE% (如果存在，将复制一个模板版本以避免隐私泄露)

:: 如果 builds 目录不存在，则创建它
if not exist builds (
    mkdir builds
    echo 创建 'builds' 目录
)

:: 创建一个空的 config.ini 模板以避免复制用户隐私数据
set TEMPLATE_CONFIG=builds\config_template.ini
echo [telegram] > %TEMPLATE_CONFIG%
echo bot_token= >nul >> %TEMPLATE_CONFIG%
echo chat_id= >nul >> %TEMPLATE_CONFIG%
echo [settings] >nul >> %TEMPLATE_CONFIG%
echo preset_proxy= >nul >> %TEMPLATE_CONFIG%
echo fdip_dir=fdip >nul >> %TEMPLATE_CONFIG%
echo output_dir=output >nul >> %TEMPLATE_CONFIG%
echo check_timeout=10 >nul >> %TEMPLATE_CONFIG%
echo max_concurrent=100 >nul >> %TEMPLATE_CONFIG%
echo 创建 config.ini 模板完成。

:: Windows 64-bit
echo 编译 Windows (amd64)...
set GOOS=windows
set GOARCH=amd64
set PLATFORM=windows-amd64
mkdir builds\%PLATFORM%
go build -o builds\%PLATFORM%\%PREFIX%-%PLATFORM%-%VERSION%.exe %GO_FILE%
copy %TEMPLATE_CONFIG% builds\%PLATFORM%\%CONFIG_FILE%
echo Windows 编译完成。

:: Linux 64-bit (most desktops/servers)
echo 编译 Linux (amd64)...
set GOOS=linux
set GOARCH=amd64
set PLATFORM=linux-amd64
mkdir builds\%PLATFORM%
go build -o builds\%PLATFORM%\%PREFIX%-%PLATFORM%-%VERSION% %GO_FILE%
copy %TEMPLATE_CONFIG% builds\%PLATFORM%\%CONFIG_FILE%
echo Linux 编译完成。

:: macOS 64-bit (Intel)
echo 编译 macOS (Intel)...
set GOOS=darwin
set GOARCH=amd64
set PLATFORM=darwin-amd64
mkdir builds\%PLATFORM%
go build -o builds\%PLATFORM%\%PREFIX%-%PLATFORM%-%VERSION% %GO_FILE%
copy %TEMPLATE_CONFIG% builds\%PLATFORM%\%CONFIG_FILE%
echo macOS (Intel) 编译完成。

:: macOS ARM64 (Apple Silicon)
echo 编译 macOS (Apple Silicon)...
set GOOS=darwin
set GOARCH=arm64
set PLATFORM=darwin-arm64
mkdir builds\%PLATFORM%
go build -o builds\%PLATFORM%\%PREFIX%-%PLATFORM%-%VERSION% %GO_FILE%
copy %TEMPLATE_CONFIG% builds\%PLATFORM%\%CONFIG_FILE%
echo macOS (Apple Silicon) 编译完成。

:: Linux ARM64 (e.g., Raspberry Pi 4, Termux on modern phones)
echo 编译 Linux (ARM64)...
set GOOS=linux
set GOARCH=arm64
set PLATFORM=linux-arm64
mkdir builds\%PLATFORM%
go build -o builds\%PLATFORM%\%PREFIX%-%PLATFORM%-%VERSION% %GO_FILE%
copy %TEMPLATE_CONFIG% builds\%PLATFORM%\%CONFIG_FILE%
echo Linux (ARM64) 编译完成。

:: Android ARM64 (e.g., Termux on Android devices)
echo 编译 Android (arm64) for Termux...
set GOOS=android
set GOARCH=arm64
set PLATFORM=android-arm64
mkdir builds\%PLATFORM%
go build -o builds\%PLATFORM%\%PREFIX%-%PLATFORM%-%VERSION% %GO_FILE%
copy %TEMPLATE_CONFIG% builds\%PLATFORM%\%CONFIG_FILE%
echo Android (arm64) 编译完成。

:: Android ARM (e.g., Termux on older Android devices)
echo 编译 Android (arm) for Termux...
set GOOS=android
set GOARCH=arm
set PLATFORM=android-arm
mkdir builds\%PLATFORM%
go build -o builds\%PLATFORM%\%PREFIX%-%PLATFORM%-%VERSION% %GO_FILE%
copy %TEMPLATE_CONFIG% builds\%PLATFORM%\%CONFIG_FILE%
echo Android (arm) 编译完成。

:: 删除临时模板文件
del %TEMPLATE_CONFIG%

echo. :: 添加空行以提高可读性
echo --- 所有编译完成！文件已存放在 builds\ 目录下的子目录中，每个平台包含可执行文件和配置文件模板。---
endlocal
