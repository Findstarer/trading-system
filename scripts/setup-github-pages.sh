#!/bin/bash

# GitHub Pages 自动设置脚本
# 使用方法: ./scripts/setup-github-pages.sh

set -e

echo "🚀 开始设置 GitHub Pages..."

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    exit 1
fi

# 检查Git仓库
if [ ! -d ".git" ]; then
    echo "❌ 错误: 当前目录不是Git仓库"
    exit 1
fi

# 获取仓库信息
REPO_URL=$(git remote get-url origin)
REPO_NAME=$(basename -s .git "$REPO_URL")
USERNAME=$(echo "$REPO_URL" | sed -n 's/.*github\.com[:/]\([^/]*\)\/.*/\1/p')

echo "📋 仓库信息:"
echo "  用户名: $USERNAME"
echo "  仓库名: $REPO_NAME"
echo "  仓库URL: $REPO_URL"

# 检查远程仓库是否存在
if ! git ls-remote --exit-code origin >/dev/null 2>&1; then
    echo "❌ 错误: 无法访问远程仓库，请检查网络连接和权限"
    exit 1
fi

echo "✅ 远程仓库连接正常"

# 检查当前分支
CURRENT_BRANCH=$(git branch --show-current)
echo "📝 当前分支: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  警告: 当前分支不是main，建议切换到main分支"
    read -p "是否切换到main分支? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git checkout main
        echo "✅ 已切换到main分支"
    fi
fi

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  发现未提交的更改"
    git status --short
    read -p "是否提交更改? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
        git commit -m "自动提交: 准备部署到GitHub Pages"
        echo "✅ 已提交更改"
    fi
fi

# 推送到远程仓库
echo "📤 推送到远程仓库..."
git push origin main

echo "✅ 代码已推送到GitHub"

# 提供手动设置指南
echo ""
echo "🎯 下一步操作指南:"
echo ""
echo "1. 访问 GitHub 仓库设置页面:"
echo "   https://github.com/$USERNAME/$REPO_NAME/settings/pages"
echo ""
echo "2. 在 'Source' 部分选择 'GitHub Actions'"
echo ""
echo "3. 点击 'Save' 保存设置"
echo ""
echo "4. 等待自动部署完成 (通常需要2-5分钟)"
echo ""
echo "5. 访问您的网站:"
echo "   https://$USERNAME.github.io/$REPO_NAME/"
echo ""

# 检查GitHub CLI是否可用
if command -v gh &> /dev/null; then
    echo "🔧 检测到GitHub CLI，可以尝试自动设置..."
    read -p "是否尝试使用GitHub CLI自动设置Pages? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "正在尝试自动设置GitHub Pages..."
        # 这里可以添加GitHub CLI命令
        echo "⚠️  注意: GitHub CLI的Pages设置功能可能有限制"
    fi
fi

echo ""
echo "📚 其他有用的命令:"
echo "  npm run dev     # 启动本地开发服务器"
echo "  npm run build   # 构建项目"
echo "  git status      # 查看Git状态"
echo ""

echo "🎉 设置完成！请按照上述指南手动启用GitHub Pages" 