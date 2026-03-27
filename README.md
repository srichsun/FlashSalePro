
# Fat Loss Pro - B2B2C Coaching SaaS

### Status: 🚧 Work In Progress (Phase 2)

### 📖 [Detailed Technical Documentation & Wiki](https://github.com/srichsun/fatloss-pro-saas/wiki)
### 📖 [詳細技術文件與開發決策請參考專案 Wiki](https://github.com/srichsun/fatloss-pro-saas/wiki)

-----

### 🚀 Project Vision (專案願景)

**English:**
Fat Loss Pro is a subscription-based management platform tailored for fitness coaches and personal studios. Utilizing a **B2B2C (Business-to-Business-to-Consumer)** architecture, it empowers coaches with independent digital classrooms to sell fat-loss programs and track student health metrics seamlessly.

**中文摘要：**
Fat Loss Pro 是一個專為「健身教練與個人工作室」打造的 B2B2C 訂閱制管理平台，協助教練建立獨立數位教室，進行課程銷售與學員數據追蹤。

---

### 🛠️ Technical Stack & Philosophy (技術選型與核心理念)

This project leverages **Rails 8 (Main Branch)**, focusing on "Minimalist Infrastructure, High Performance, and Security."
(本專案採用 Rails 8 架構，專注於極簡基礎設施、高性能與安全性。)

* **Rails 8 "Postgres-only" Stack**: Utilizes `Solid Queue` and `Solid Cache` to eliminate Redis dependencies, reducing operational complexity. (採用 Solid Queue/Cache 移除對 Redis 的依賴，降低運維複雜度。)
* **Multi-tenancy Isolation**: Implements data isolation via `tenant_id` and Controller Scoping to prevent **IDOR (Insecure Direct Object Reference)** vulnerabilities. (透過 tenant_id 實作資料隔離，杜絕 IDOR 安全漏洞。)
* **Hand-rolled Auth**: Opted for a lightweight authentication flow via `has_secure_password` over Devise for maximum control and security transparency. (捨棄套件，採用原生方式實作輕量、高掌控度的身分驗證。)
* **Modern Frontend**: Combines **Tailwind CSS** with **Hotwire (Turbo/Stimulus)** for an SPA-like user experience. (結合 Tailwind 與 Hotwire，提供如單頁式應用程式般的流暢體驗。)

-----

### 🚀 Technical Highlights (技術亮點)

#### 1. Row-Level Data Isolation (資料隔離與安全性)

* **Scoped Querying**: Encapsulated `current_tenant` logic at the controller level. All data queries originate from the tenant to prevent cross-tenant access risks at the architectural level. (在 Controller 層級封裝租戶邏輯，所有查詢皆從租戶出發，從底層杜絕跨租戶存取風險。)
* **Transactional Setup**: Utilizes **Database Transactions** during coach registration to ensure atomic creation of both `Tenant` (Organization) and `User` (Admin). (使用資料庫事務確保組織與管理員帳號同時建立成功。)

#### 2. Financial & Order Automation (金流與訂單自動化)

* **Precision Handling**: Leverages Rails `Attributes API` for monetary calculations to ensure mathematical precision. (使用 Attributes API 處理金額，確保財務運算的精確度。)
* **Idempotency & Webhooks**: Integrated **Stripe API** with Webhooks and idempotency mechanisms to ensure accurate automated billing and order status synchronization. (整合 Stripe 並實作冪等性機制，確保自動化扣款與訂單狀態同步的準確性。)

-----

### 📈 Roadmap (開發進度)

#### **Phase 1: SaaS Foundation (Completed)**
- [x] **Multi-tenant Architecture**: Tenant/User isolation walls. (實作租戶資料隔離牆)
- [x] **Custom Auth System**: Session-based lightweight logic. (輕量化驗證邏輯)
- [x] **Security Scoping**: Enforced checks in `ApplicationController` with RSpec validation. (強制執行租戶安全檢查)

#### **Phase 2: Financial Integrity (In Progress)**
- [x] **Automated Order System**: Coach invoicing & student enrollment workflows. (自動化開單與入班流程)
- [ ] **Stripe Integration**: Automated payments & Webhook listeners. (支付整合與監聽)
- [ ] **Service Objects**: Encapsulating `Orders::PlaceOrderService` for transaction atomicity. (封裝 Service Object 確保交易原子性)

#### **Phase 4: Real-time Data & Analytics (Planning)**
- [ ] **Health Dashboard**: Real-time weight tracking charts using Turbo Streams. (利用 Turbo Streams 實作無刷新數據圖表)
- [ ] **Data Visualization**: Integrating Chart.js for revenue and student progress analytics. (導入數據視覺化展示營收與進度)

-----

### 🛡️ Documentation (相關技術文件)

Deep design details are documented in the Wiki:
* [📌 Database Schema Design] (Pending: Update after Phase 2 stabilization)
* [📌 API Integration & Webhook Guide] (Pending: Update after Stripe testing)

-----

### ⚡ Quick Start (快速啟動)

#### 1. Setup Environment
Ensure PostgreSQL is installed on your local machine.

```bash
# Clone the repository
git clone [your-repo-link]
cd fat_loss_pro

# Install dependencies
bundle install

# Setup database
bin/rails db:prepare

# Start development server (Rails + Tailwind + CSS Watch)
bin/dev
```

#### 2. Running Tests
```bash
bundle exec rspec
```
