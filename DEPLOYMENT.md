# 自动化部署指南

## 🚀 快速部署

### 方法一：使用自动化脚本

```bash
# 运行设置脚本
./scripts/setup-github-pages.sh

# 或运行快速部署脚本
./scripts/deploy.sh
```

### 方法二：手动部署

```bash
# 1. 安装依赖
npm install --legacy-peer-deps

# 2. 构建项目
npm run build

# 3. 提交并推送
git add .
git commit -m "部署更新"
git push origin main
```

## 📋 启用GitHub Pages

### 自动部署方式（推荐）

1. 访问 https://github.com/Findstarer/trading-system/settings/pages
2. 在 "Source" 部分选择 "GitHub Actions"
3. 点击 "Save"

### 静态文件方式（备选）

1. 访问 https://github.com/Findstarer/trading-system/settings/pages
2. 在 "Source" 部分选择 "Deploy from a branch"
3. 选择 "gh-pages" 分支
4. 点击 "Save"

## 🔧 部署配置

### GitHub Actions 工作流

- **主工作流**: `.github/workflows/pages.yml` - 使用最新的GitHub Pages Actions
- **备选工作流**: `.github/workflows/static-pages.yml` - 使用peaceiris/actions-gh-pages

### 构建配置

- **构建命令**: `npm run build`
- **输出目录**: `./docs/.vuepress/dist`
- **Node.js版本**: 18.x

## 🌐 访问地址

部署成功后，您的网站将可以通过以下地址访问：

**https://findstarer.github.io/trading-system/**

## 📝 故障排除

### 常见问题

1. **构建失败**
   ```bash
   # 清理并重新安装依赖
   rm -rf node_modules package-lock.json
   npm install --legacy-peer-deps
   npm run build
   ```

2. **GitHub Actions失败**
   - 检查仓库权限设置
   - 确保GitHub Pages已启用
   - 查看Actions日志获取详细错误信息

3. **页面无法访问**
   - 等待部署完成（通常需要2-5分钟）
   - 检查GitHub Pages设置是否正确
   - 确认域名配置

### 调试命令

```bash
# 本地测试构建
npm run build

# 本地启动开发服务器
npm run dev

# 检查Git状态
git status

# 查看远程仓库
git remote -v
```

## 🔄 持续部署

每次推送到 `main` 分支时，GitHub Actions会自动：

1. 安装依赖
2. 构建项目
3. 部署到GitHub Pages

## 📚 相关文档

- [VuePress官方文档](https://v2.vuepress.vuejs.org/)
- [GitHub Pages文档](https://docs.github.com/en/pages)
- [GitHub Actions文档](https://docs.github.com/en/actions) 