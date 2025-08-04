# GitHub Pages 部署流程图

## 完整部署流程

```mermaid
graph TD
    %% 维护人操作
    A[维护人] --> B[本地编辑文档]
    B --> C[本地构建测试]
    C --> D[Git提交]
    D --> E[推送到GitHub]
    
    %% GitHub Actions流程
    E --> F[GitHub接收代码]
    F --> G[触发GitHub Actions]
    G --> H[自动构建项目]
    H --> I[生成静态文件]
    I --> J[部署到GitHub Pages]
    
    %% 查看人访问
    J --> K[GitHub Pages服务]
    K --> L[查看人访问网站]
    L --> M[显示支付系统学习资源]
    
    %% 反馈循环
    M --> N[查看人反馈]
    N --> O[维护人接收反馈]
    O --> A
    
    %% 样式定义
    classDef maintainer fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef github fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef viewer fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef process fill:#fff3e0,stroke:#e65100,stroke-width:2px
    
    class A,B,C,D,E,O maintainer
    class F,G,H,I,J,K github
    class L,M,N viewer
    class C,H,I process
```

## 详细流程说明

### 1. 维护人操作阶段

#### 本地开发
```mermaid
sequenceDiagram
    participant M as 维护人
    participant L as 本地环境
    participant G as Git
    
    M->>L: 编辑Markdown文档
    M->>L: 运行 npm run dev
    M->>L: 预览效果
    M->>G: git add .
    M->>G: git commit -m "更新内容"
    M->>G: git push origin main
```

#### 自动化脚本
```bash
# 快速部署脚本
./scripts/deploy.sh

# 或手动操作
npm install --legacy-peer-deps
npm run build
git add .
git commit -m "部署更新"
git push origin main
```

### 2. GitHub Actions 自动化流程

#### 构建和部署
```mermaid
graph LR
    A[代码推送] --> B[触发Actions]
    B --> C[检出代码]
    C --> D[安装依赖]
    D --> E[构建项目]
    E --> F[生成静态文件]
    F --> G[部署到Pages]
    
    classDef github fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    class A,B,C,D,E,F,G github
```

#### 详细步骤
```yaml
# .github/workflows/static-pages.yml
name: Deploy Static Pages
on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
        
    - name: Install dependencies
      run: npm ci --legacy-peer-deps
      
    - name: Build
      run: npm run build
      
    - name: Setup git user
      run: |
        git config --global user.name "github-actions[bot]"
        git config --global user.email "github-actions[bot]@users.noreply.github.com"

    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./docs/.vuepress/dist
        force_orphan: true
```

### 3. 查看人访问流程

#### 网站访问
```mermaid
sequenceDiagram
    participant V as 查看人
    participant B as 浏览器
    participant G as GitHub Pages
    participant C as CDN
    
    V->>B: 输入网址
    B->>C: DNS解析
    C->>G: 请求页面
    G->>B: 返回HTML/CSS/JS
    B->>V: 显示网站内容
```

#### 访问地址
```
🌐 网站地址: https://findstarer.github.io/trading-system/
📚 文档内容: 支付系统学习资源
🔍 功能特性: 搜索、导航、响应式设计
```

## 时间线分析

### 各阶段耗时
```mermaid
gantt
    title 部署时间线
    dateFormat  X
    axisFormat %s
    
    section 维护人操作
    本地编辑    :done, edit, 0, 300
    本地测试    :done, test, 300, 600
    代码推送    :done, push, 600, 900
    
    section GitHub处理
    触发Actions  :done, trigger, 900, 1200
    构建项目    :done, build, 1200, 1800
    部署Pages   :done, deploy, 1800, 2400
    
    section 查看人访问
    网站可访问  :done, available, 2400, 3000
```

### 关键时间点
- **0-5分钟**: 维护人完成代码推送
- **5-10分钟**: GitHub Actions自动构建和部署
- **10分钟后**: 查看人可访问更新后的网站

## 参与方职责

### 维护人 (Maintainer)
```mermaid
graph TD
    A[维护人] --> B[内容创作]
    A --> C[技术维护]
    A --> D[版本管理]
    A --> E[问题修复]
    
    B --> F[编写文档]
    B --> G[更新教程]
    B --> H[添加示例]
    
    C --> I[依赖更新]
    C --> J[配置优化]
    C --> K[性能调优]
    
    D --> L[Git管理]
    D --> M[分支策略]
    D --> N[发布流程]
    
    E --> O[Bug修复]
    E --> P[功能增强]
    E --> Q[安全更新]
```

### GitHub 平台
```mermaid
graph TD
    A[GitHub] --> B[代码托管]
    A --> C[CI/CD服务]
    A --> D[静态托管]
    A --> E[协作平台]
    
    B --> F[版本控制]
    B --> G[分支管理]
    B --> H[代码审查]
    
    C --> I[Actions执行]
    C --> J[构建环境]
    C --> K[部署自动化]
    
    D --> L[Pages服务]
    D --> M[CDN分发]
    D --> N[SSL证书]
    
    E --> F
    E --> O[Issue管理]
    E --> P[PR协作]
```

### 查看人 (Viewer)
```mermaid
graph TD
    A[查看人] --> B[内容消费]
    A --> C[反馈提供]
    A --> D[知识学习]
    
    B --> E[阅读文档]
    B --> F[查看示例]
    B --> G[搜索信息]
    
    C --> H[提交Issue]
    C --> I[提出建议]
    C --> J[报告问题]
    
    D --> K[学习支付系统]
    D --> L[实践应用]
    D --> M[技能提升]
```

## 技术架构

### 部署架构
```mermaid
graph TB
    subgraph "本地环境"
        A[维护人] --> B[本地Git]
        B --> C[本地构建]
    end
    
    subgraph "GitHub平台"
        D[GitHub仓库] --> E[GitHub Actions]
        E --> F[构建环境]
        F --> G[静态文件生成]
        G --> H[GitHub Pages]
    end
    
    subgraph "全球访问"
        H --> I[CDN节点]
        I --> J[查看人浏览器]
    end
    
    C --> D
    J --> K[支付系统学习资源]
```

### 文件流转
```mermaid
graph LR
    A[Markdown文档] --> B[VuePress构建]
    B --> C[HTML/CSS/JS]
    C --> D[静态文件]
    D --> E[GitHub Pages]
    E --> F[全球CDN]
    F --> G[用户浏览器]
```

## 监控和反馈

### 部署状态监控
```mermaid
graph TD
    A[代码推送] --> B[Actions触发]
    B --> C{构建成功?}
    C -->|是| D[部署Pages]
    C -->|否| E[发送通知]
    D --> F[更新完成]
    E --> G[维护人修复]
    G --> A
```

### 反馈循环
```mermaid
graph TD
    A[查看人访问] --> B[内容消费]
    B --> C[发现问题]
    C --> D[提交反馈]
    D --> E[维护人接收]
    E --> F[分析问题]
    F --> G[修复更新]
    G --> H[重新部署]
    H --> A
```

---

*这个流程图展示了从维护人编辑到查看人访问的完整GitHub Pages部署流程，涵盖了所有参与方的职责和交互过程。* 