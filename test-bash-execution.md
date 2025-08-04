# Bash 代码执行测试

## 基础命令测试

```bash
# 显示当前目录
pwd

# 列出文件
ls -la

# 显示系统信息
uname -a
```

## Git 状态检查

```bash
# 检查 Git 状态
git status

# 检查当前分支
git branch

# 检查远程仓库
git remote -v
```

## Node.js 环境检查

```bash
# 检查 Node.js 版本
node --version

# 检查 npm 版本
npm --version

# 检查项目依赖
npm list --depth=0
```

## 文件操作测试

```bash
# 创建测试文件
echo "Hello from bash execution!" > test-output.txt

# 显示文件内容
cat test-output.txt

# 清理测试文件
rm test-output.txt
```

## 网络连接测试

```bash
# 测试网络连接
ping -c 3 google.com

# 检查端口
netstat -an | grep LISTEN
```

## 系统资源检查

```bash
# 检查磁盘使用情况
df -h

# 检查内存使用情况
free -h

# 检查 CPU 信息
top -l 1 | head -10
```

---

## 使用方法

1. **选中代码块**：点击上面的任意代码块
2. **执行代码**：
   - 按 `Cmd+Shift+R` 执行
   - 或右键选择 "Run Code"
   - 或在命令面板中输入 "Run Code"
3. **查看结果**：结果会在集成终端中显示

## 安全提醒

⚠️ **注意**：
- 只执行您信任的代码
- 某些命令可能需要管理员权限
- 建议在测试环境中先验证代码

## 快捷键

- `Cmd+Shift+R`：运行选中的代码
- `Cmd+Shift+P`：打开命令面板
- `Ctrl+`` `：打开/关闭集成终端 