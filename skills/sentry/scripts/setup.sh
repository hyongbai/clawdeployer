#!/usr/bin/env bash
# Sentry CLI 一键安装与验证脚本
set -euo pipefail

echo "=== Sentry CLI Setup ==="
echo ""

# 检测已安装
if command -v sentry-cli &>/dev/null; then
    echo "[✓] sentry-cli 已安装: $(sentry-cli --version)"
else
    echo "[*] 正在安装 sentry-cli..."

    # 按平台选择安装方式
    if command -v npm &>/dev/null; then
        echo "    使用 npm 安装..."
        npm install -g @sentry/cli
    elif command -v brew &>/dev/null; then
        echo "    使用 brew 安装..."
        brew install getsentry/tools/sentry-cli
    else
        echo "    使用 curl 安装..."
        curl -sL https://sentry.io/get-cli/ | bash
    fi

    if command -v sentry-cli &>/dev/null; then
        echo "[✓] 安装成功: $(sentry-cli --version)"
    else
        echo "[✗] 安装失败，请手动安装"
        echo "    参考: https://docs.sentry.io/cli/installation/"
        exit 1
    fi
fi

echo ""

# 检查环境变量
echo "=== 环境变量检查 ==="
MISSING=0

if [ -z "${SENTRY_AUTH_TOKEN:-}" ]; then
    echo "[!] SENTRY_AUTH_TOKEN 未设置"
    MISSING=1
else
    echo "[✓] SENTRY_AUTH_TOKEN 已设置 (${SENTRY_AUTH_TOKEN:0:10}...)"
fi

if [ -z "${SENTRY_ORG:-}" ]; then
    echo "[!] SENTRY_ORG 未设置"
    MISSING=1
else
    echo "[✓] SENTRY_ORG = $SENTRY_ORG"
fi

if [ -z "${SENTRY_PROJECT:-}" ]; then
    echo "[!] SENTRY_PROJECT 未设置"
    MISSING=1
else
    echo "[✓] SENTRY_PROJECT = $SENTRY_PROJECT"
fi

echo ""

# 检查 .sentryclirc
if [ -f ".sentryclirc" ]; then
    echo "[✓] .sentryclirc 配置文件存在"
elif [ -f "$HOME/.sentryclirc" ]; then
    echo "[✓] ~/.sentryclirc 配置文件存在"
else
    echo "[i] 未找到 .sentryclirc 配置文件（可选）"
fi

echo ""

# 验证认证
if [ $MISSING -eq 0 ] || [ -f ".sentryclirc" ] || [ -f "$HOME/.sentryclirc" ]; then
    echo "=== 验证认证 ==="
    if sentry-cli info 2>/dev/null; then
        echo ""
        echo "[✓] 认证验证通过！"
    else
        echo "[✗] 认证验证失败，请检查 token 和配置"
        exit 1
    fi
else
    echo "[!] 跳过认证验证（缺少必要配置）"
    echo ""
    echo "请设置以下环境变量后重新运行："
    echo "  export SENTRY_AUTH_TOKEN=\"sntrys_xxxxx\""
    echo "  export SENTRY_ORG=\"your-org\""
    echo "  export SENTRY_PROJECT=\"your-project\""
    exit 1
fi

echo ""
echo "=== 设置完成 ==="
echo "可用命令："
echo "  sentry-cli info              — 查看配置信息"
echo "  sentry-cli projects list     — 列出项目"
echo "  sentry-cli releases list     — 列出 releases"
echo "  sentry-cli send-event -m 'test' — 发送测试事件"
