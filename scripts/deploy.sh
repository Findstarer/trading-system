#!/bin/bash

# 快速部署脚本
# 使用方法: ./scripts/deploy.sh

set -e

echo "🚀 开始快速部署..."

# 检查依赖
if ! command -v npm &> /dev/null; then
    echo "❌ 错误: 需要安装 Node.js 和 npm"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ 错误: 需要安装 Git"
    exit 1
fi

# 安装依赖
echo "📦 安装依赖..."
npm install --legacy-peer-deps

# 构建项目
echo "🔨 构建项目..."
npm run build

# 检查构建结果
if [ ! -d "docs/.vuepress/dist" ]; then
    echo "❌ 错误: 构建失败，未找到dist目录"
    exit 1
fi

echo "✅ 构建成功"

# 提交更改
echo "📝 提交更改..."
git add .
git commit -m "自动部署: $(date '+%Y-%m-%d %H:%M:%S')" || true

# 推送到远程
echo "📤 推送到GitHub..."
git push origin main

echo ""
echo "🎉 部署完成！"
echo ""
echo "📋 下一步操作:"
echo "1. 访问 https://github.com/Findstarer/trading-system/settings/pages"
echo "2. 在 'Source' 选择 'Deploy from a branch'"
echo "3. 选择 'gh-pages' 分支"
echo "4. 点击 'Save'"
echo ""
echo "🌐 网站地址: https://findstarer.github.io/trading-system/"
echo "" 