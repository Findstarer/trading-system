# 支付系统架构设计

## 整体架构

### 分层架构
```
┌─────────────────────────────────────────────────────────────┐
│                    表现层 (Presentation Layer)              │
│  Web前端  │  移动端  │  管理后台  │  API网关  │  第三方集成  │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                    业务层 (Business Layer)                  │
│  用户服务  │  订单服务  │  支付服务  │  风控服务  │  通知服务  │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                    数据层 (Data Layer)                     │
│  主数据库  │  缓存  │  消息队列  │  文件存储  │  日志系统  │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                    基础设施层 (Infrastructure Layer)        │
│  负载均衡  │  容器编排  │  监控告警  │  安全防护  │  备份恢复  │
└─────────────────────────────────────────────────────────────┘
```

## 微服务架构

### 核心服务

#### 1. 用户服务 (User Service)
```yaml
职责:
  - 用户注册、登录、认证
  - 用户信息管理
  - 权限控制

技术栈:
  - 语言: Java/Spring Boot 或 Node.js/Express
  - 数据库: MySQL (用户数据)
  - 缓存: Redis (会话、权限)
  - 消息: Kafka (用户事件)

API:
  - POST /api/users/register
  - POST /api/users/login
  - GET /api/users/{id}
  - PUT /api/users/{id}
```

#### 2. 订单服务 (Order Service)
```yaml
职责:
  - 订单创建、更新、查询
  - 订单状态管理
  - 库存检查

技术栈:
  - 语言: Java/Spring Boot
  - 数据库: MySQL (订单数据)
  - 缓存: Redis (库存缓存)
  - 消息: Kafka (订单事件)

API:
  - POST /api/orders
  - GET /api/orders/{id}
  - PUT /api/orders/{id}/status
  - GET /api/orders/user/{userId}
```

#### 3. 支付服务 (Payment Service)
```yaml
职责:
  - 支付处理
  - 支付方式管理
  - 退款处理

技术栈:
  - 语言: Java/Spring Boot
  - 数据库: MySQL (交易数据)
  - 缓存: Redis (支付状态)
  - 消息: Kafka (支付事件)

API:
  - POST /api/payments
  - GET /api/payments/{id}
  - POST /api/payments/{id}/refund
  - GET /api/payments/order/{orderId}
```

#### 4. 风控服务 (Risk Service)
```yaml
职责:
  - 风险评估
  - 欺诈检测
  - 规则引擎

技术栈:
  - 语言: Python (机器学习)
  - 数据库: PostgreSQL (风控数据)
  - 缓存: Redis (规则缓存)
  - 消息: Kafka (风控事件)

API:
  - POST /api/risk/assess
  - GET /api/risk/rules
  - POST /api/risk/rules
  - GET /api/risk/alerts
```

#### 5. 通知服务 (Notification Service)
```yaml
职责:
  - 短信通知
  - 邮件通知
  - 推送通知

技术栈:
  - 语言: Node.js/Express
  - 数据库: MongoDB (通知记录)
  - 消息: Kafka (通知事件)
  - 第三方: 短信/邮件服务商

API:
  - POST /api/notifications/sms
  - POST /api/notifications/email
  - POST /api/notifications/push
  - GET /api/notifications/{id}
```

### 支持服务

#### 配置服务 (Config Service)
```yaml
职责:
  - 配置管理
  - 服务发现
  - 健康检查

技术栈:
  - 语言: Java/Spring Cloud Config
  - 存储: Git (配置存储)
  - 注册: Eureka/Consul
```

#### 网关服务 (Gateway Service)
```yaml
职责:
  - 路由转发
  - 负载均衡
  - 限流熔断
  - 认证授权

技术栈:
  - 语言: Java/Spring Cloud Gateway
  - 负载均衡: Ribbon
  - 熔断器: Hystrix
  - 限流: Sentinel
```

## 数据架构

### 数据库设计

#### 主数据库 (MySQL)
```sql
-- 用户表
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 订单表
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    order_no VARCHAR(50) UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'CNY',
    status ENUM('pending', 'paid', 'cancelled', 'refunded') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 支付表
CREATE TABLE payments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    payment_no VARCHAR(50) UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('alipay', 'wechat', 'bank_card', 'balance') NOT NULL,
    status ENUM('pending', 'processing', 'success', 'failed', 'refunded') DEFAULT 'pending',
    gateway_response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);
```

#### 缓存设计 (Redis)
```yaml
缓存策略:
  - 用户会话: TTL 30分钟
  - 支付状态: TTL 5分钟
  - 风控规则: TTL 1小时
  - 系统配置: TTL 24小时

数据结构:
  - String: 配置、会话
  - Hash: 用户信息、订单详情
  - List: 消息队列
  - Set: 权限、黑名单
  - Sorted Set: 排行榜、时间序列
```

### 消息队列架构

#### Kafka 主题设计
```yaml
用户事件:
  - user.created: 用户注册
  - user.updated: 用户信息更新
  - user.login: 用户登录

订单事件:
  - order.created: 订单创建
  - order.paid: 订单支付成功
  - order.cancelled: 订单取消

支付事件:
  - payment.initiated: 支付发起
  - payment.success: 支付成功
  - payment.failed: 支付失败
  - payment.refunded: 支付退款

风控事件:
  - risk.alert: 风控告警
  - risk.block: 风控拦截
```

## 安全架构

### 网络安全
```yaml
防护措施:
  - WAF: Web应用防火墙
  - DDoS防护: 分布式拒绝服务防护
  - SSL/TLS: 传输层安全
  - VPN: 虚拟专用网络

网络隔离:
  - DMZ: 非军事区
  - 内网: 业务服务器
  - 管理网: 运维服务器
```

### 应用安全
```yaml
认证授权:
  - JWT: JSON Web Token
  - OAuth2: 开放授权
  - RBAC: 基于角色的访问控制

数据安全:
  - 加密: AES-256
  - 令牌化: 敏感数据替换
  - 脱敏: 数据脱敏处理
```

## 部署架构

### 容器化部署
```yaml
编排工具: Kubernetes
镜像仓库: Docker Registry
服务网格: Istio (可选)

部署策略:
  - 蓝绿部署: 零停机更新
  - 滚动更新: 渐进式更新
  - 金丝雀发布: 灰度发布
```

### 监控架构
```yaml
监控工具:
  - 应用监控: APM (Application Performance Monitoring)
  - 基础设施监控: Prometheus + Grafana
  - 日志聚合: ELK Stack
  - 告警通知: PagerDuty

监控指标:
  - 业务指标: 交易量、成功率、收入
  - 技术指标: 响应时间、错误率、吞吐量
  - 基础设施指标: CPU、内存、磁盘、网络
```

## 扩展性设计

### 水平扩展
```yaml
无状态服务:
  - 用户服务: 可水平扩展
  - 订单服务: 可水平扩展
  - 支付服务: 可水平扩展

有状态服务:
  - 数据库: 读写分离、分库分表
  - 缓存: Redis集群
  - 消息队列: Kafka集群
```

### 垂直扩展
```yaml
资源优化:
  - CPU: 多核处理
  - 内存: 大内存配置
  - 存储: SSD存储
  - 网络: 高带宽
```

## 灾难恢复

### 备份策略
```yaml
数据备份:
  - 全量备份: 每日凌晨
  - 增量备份: 每小时
  - 实时同步: 主从复制

备份存储:
  - 本地备份: 快速恢复
  - 异地备份: 灾难恢复
  - 云端备份: 长期存储
```

### 恢复策略
```yaml
RTO (Recovery Time Objective):
  - 关键业务: < 4小时
  - 一般业务: < 24小时

RPO (Recovery Point Objective):
  - 关键数据: < 1小时
  - 一般数据: < 24小时
```

---

*下一步：了解 [数据库设计](./database-design.md)* 