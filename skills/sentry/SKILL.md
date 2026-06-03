# Sentry CLI Skill

> **description:** Sentry 错误监控平台的 CLI 操作技能，覆盖 release 管理、sourcemap 上传、issue 查询、错误上报、cron 监控等全流程。
>
> **触发关键词:** sentry, sentry-cli, sourcemap, release, error tracking, 错误监控, 崩溃上报, dsym, debug symbols, cron monitor

---

## 1. 安装与配置

### 安装 sentry-cli

```bash
# npm (推荐 Node 项目)
npm install -g @sentry/cli

# brew (macOS)
brew install getsentry/tools/sentry-cli

# curl (Linux/CI)
curl -sL https://sentry.io/get-cli/ | bash
```

### 环境变量

```bash
export SENTRY_AUTH_TOKEN="sntrys_xxxxx"   # API token
export SENTRY_ORG="my-org"                # 组织 slug
export SENTRY_PROJECT="my-project"        # 项目 slug
export SENTRY_URL="https://sentry.io/"    # 自托管时修改
```

### .sentryclirc 配置文件

项目根目录创建 `.sentryclirc`：

```ini
[defaults]
url = https://sentry.io/
org = my-org
project = my-project

[auth]
token = sntrys_xxxxx
```

> ⚠️ 将 `.sentryclirc` 加入 `.gitignore`，避免泄露 token。

---

## 2. 认证

### 创建 Token

1. 访问 `https://sentry.io/settings/account/api/auth-tokens/`
2. 创建 token，勾选所需 scope：
   - `project:releases` — release 管理
   - `project:write` — sourcemap 上传
   - `org:read` — 组织/项目列表
   - `event:read` — 事件查询

### 验证认证

```bash
sentry-cli info
```

成功输出示例：
```
Sentry Server: https://sentry.io/
Default Organization: my-org
Default Project: my-project
```

---

## 3. 项目管理

### 列出组织

```bash
sentry-cli organizations list
```

### 列出项目

```bash
sentry-cli projects list
```

### 列出指定组织的项目

```bash
sentry-cli --org my-org projects list
```

---

## 4. Release 管理

### 创建 Release

```bash
# 使用版本号
sentry-cli releases new "1.0.0"

# 使用 git commit SHA
sentry-cli releases new "$(sentry-cli releases propose-version)"
```

### 关联 Commits

```bash
# 自动关联（需配置 repo integration）
sentry-cli releases set-commits "1.0.0" --auto

# 手动指定范围
sentry-cli releases set-commits "1.0.0" --commit "my-org/my-repo@from_sha..to_sha"
```

### 上传 Source Maps

```bash
sentry-cli releases files "1.0.0" upload-sourcemaps ./dist \
  --url-prefix "~/static/js" \
  --rewrite
```

### Finalize Release

```bash
sentry-cli releases finalize "1.0.0"
```

### 一步完成（推荐 CI 用法）

```bash
VERSION=$(sentry-cli releases propose-version)
sentry-cli releases new "$VERSION"
sentry-cli releases set-commits "$VERSION" --auto
sentry-cli releases files "$VERSION" upload-sourcemaps ./dist --url-prefix "~/static/js" --rewrite
sentry-cli releases finalize "$VERSION"
```

### 删除 Release

```bash
sentry-cli releases delete "1.0.0"
```

### 列出 Releases

```bash
sentry-cli releases list
```

---

## 5. Issues 查询

### 通过 API 查询 Issues 列表

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/issues/?query=is:unresolved&statsPeriod=24h"
```

### 查询 Issue 详情

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/{issue_id}/"
```

### 查询 Issue 的最新事件

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/{issue_id}/events/latest/"
```

### 查询事件详情

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/events/{event_id}/"
```

### 常用 query 过滤参数

| 参数 | 说明 | 示例 |
|------|------|------|
| `query` | 搜索条件 | `is:unresolved`, `assigned:me`, `level:error` |
| `statsPeriod` | 时间范围 | `24h`, `7d`, `14d` |
| `sort` | 排序 | `date`, `new`, `freq`, `priority` |
| `limit` | 返回数量 | `10`, `25`, `100` |

---

## 6. 崩溃/错误上报

### 使用 sentry-cli 发送测试事件

```bash
# 发送一个错误事件
sentry-cli send-event -m "Test error from CLI" -l error

# 附带额外信息
sentry-cli send-event \
  -m "Deploy failed" \
  -l error \
  --tag environment:production \
  --tag service:api \
  --extra deploy_id:12345
```

### DSN 配置

DSN 格式：`https://<public_key>@o<org_id>.ingest.sentry.io/<project_id>`

在 SDK 中使用：

```javascript
Sentry.init({
  dsn: "https://abc123@o456.ingest.sentry.io/789",
  release: "1.0.0",
  environment: "production",
});
```

获取 DSN：`Settings > Projects > [Project] > Client Keys (DSN)`

---

## 7. Source Maps

### 上传 Source Maps

```bash
sentry-cli releases files "1.0.0" upload-sourcemaps ./dist \
  --url-prefix "~/static/js" \
  --rewrite \
  --validate
```

### 使用 sourcemaps 子命令（新版推荐）

```bash
sentry-cli sourcemaps upload ./dist \
  --release "1.0.0" \
  --url-prefix "~/static/js"
```

### 列出已上传文件

```bash
sentry-cli releases files "1.0.0" list
```

### 删除已上传文件

```bash
# 删除单个
sentry-cli releases files "1.0.0" delete "~/static/js/main.js.map"

# 删除所有
sentry-cli releases files "1.0.0" delete --all
```

### 验证 Source Maps

```bash
sentry-cli sourcemaps explain --release "1.0.0" --org my-org --project my-project
```

### 常见问题排查

1. **url-prefix 不匹配** — 检查浏览器中 js 文件的实际 URL 路径
2. **文件未上传** — 确认 build 产物目录正确，包含 `.map` 文件
3. **release 不匹配** — 确认 SDK init 中的 release 与上传时一致

---

## 8. Debug Files

### 上传 dSYM (iOS)

```bash
sentry-cli debug-files upload --include-sources path/to/dSYMs/
```

### 上传 Proguard mappings (Android)

```bash
sentry-cli debug-files upload --type proguard path/to/mapping.txt
```

### 上传 ELF/DWARF debug symbols (Linux/Native)

```bash
sentry-cli debug-files upload path/to/debug/symbols/
```

### 检查 debug 文件

```bash
sentry-cli debug-files check path/to/file
```

### 列出已上传的 debug 文件

```bash
sentry-cli debug-files list
```

---

## 9. Deploys

### 创建 Deploy 记录

```bash
sentry-cli releases deploys "1.0.0" new \
  -e production \
  -n "Deploy #42"
```

### 带时间范围的 Deploy

```bash
sentry-cli releases deploys "1.0.0" new \
  -e production \
  --started "$(date -u -d '10 minutes ago' +%s)" \
  --finished "$(date -u +%s)"
```

### 列出 Deploys

```bash
sentry-cli releases deploys "1.0.0" list
```

---

## 10. Monitors (Cron)

### 监控 Cron Job 执行

```bash
# 包裹你的 cron 命令
sentry-cli monitors run <monitor-slug> -- <your-command>

# 示例
sentry-cli monitors run daily-backup -- ./scripts/backup.sh
```

### 手动上报 Check-in

```bash
# 开始
CHECK_IN_ID=$(sentry-cli monitors checkins <monitor-slug> create --status in_progress)

# 完成
sentry-cli monitors checkins <monitor-slug> update $CHECK_IN_ID --status ok

# 失败
sentry-cli monitors checkins <monitor-slug> update $CHECK_IN_ID --status error
```

### 列出 Monitors

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/monitors/"
```

---

## 11. Dashboard / 性能查询

### 查询 Transactions（性能数据）

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/events/?field=transaction&field=count()&field=p95(transaction.duration)&statsPeriod=24h&project=$SENTRY_PROJECT&query=event.type:transaction"
```

### 查询特定 Transaction 的性能

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/events/?field=transaction&field=avg(transaction.duration)&field=p50()&field=p95()&field=p99()&query=transaction:/api/users&statsPeriod=7d"
```

### 查询项目统计

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/stats/?stat=received&resolution=1h&since=$(date -d '24 hours ago' +%s)"
```

---

## 12. 常用排查流程

### 流程一：线上报错排查

```bash
# 1. 查看最近未解决的 issues
curl -s -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/issues/?query=is:unresolved&sort=date&limit=10" | jq '.[].title'

# 2. 获取某个 issue 详情（替换 ISSUE_ID）
curl -s -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/ISSUE_ID/" | jq '{title, count, firstSeen, lastSeen, level}'

# 3. 获取最新事件的 stack trace
curl -s -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/ISSUE_ID/events/latest/" | jq '.entries[] | select(.type=="exception")'

# 4. 检查 sourcemap 是否正常（有无原始文件名）
# 如果 stack trace 中只有压缩后的文件名，检查 sourcemap 上传
```

### 流程二：新版本发布

```bash
# 1. 构建
npm run build

# 2. 创建 release + 上传 sourcemaps
VERSION=$(sentry-cli releases propose-version)
sentry-cli releases new "$VERSION"
sentry-cli releases set-commits "$VERSION" --auto
sentry-cli sourcemaps upload ./dist --release "$VERSION" --url-prefix "~/static/js"
sentry-cli releases finalize "$VERSION"

# 3. 部署完成后记录 deploy
sentry-cli releases deploys "$VERSION" new -e production

# 4. 验证
sentry-cli releases list | head -5
```

### 流程三：Source Map 排查

```bash
# 1. 确认 release 存在
sentry-cli releases list | grep "1.0.0"

# 2. 确认文件已上传
sentry-cli releases files "1.0.0" list

# 3. 使用 explain 命令诊断
sentry-cli sourcemaps explain --release "1.0.0"

# 4. 核对 url-prefix
# 浏览器中 js 的 URL: https://example.com/static/js/main.abc123.js
# 则 url-prefix 应为: ~/static/js
```

---

## 参考

- [Sentry CLI 官方文档](https://docs.sentry.io/cli/)
- [Sentry Web API 文档](https://docs.sentry.io/api/)
- 本 skill 的 API 参考: [references/api.md](./references/api.md)
- 安装脚本: [scripts/setup.sh](./scripts/setup.sh)
