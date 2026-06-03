# Sentry Web API 常用 Endpoints

> Base URL: `https://sentry.io/api/0/`
>
> 认证: `Authorization: Bearer <SENTRY_AUTH_TOKEN>`

---

## Organizations

### 列出组织

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/"
```

### 获取组织详情

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/"
```

---

## Projects

### 列出组织下的项目

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/projects/"
```

### 获取项目详情

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/"
```

### 获取项目 Client Keys (DSN)

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/keys/"
```

---

## Issues

### 列出项目 Issues

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/issues/?query=is:unresolved&statsPeriod=24h&limit=25"
```

**常用 query 参数:**
- `is:unresolved` / `is:resolved` / `is:ignored`
- `assigned:me` / `assigned:nobody`
- `level:error` / `level:warning` / `level:fatal`
- `first-release:1.0.0`
- `tag:environment:production`

### 获取 Issue 详情

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/{issue_id}/"
```

### 更新 Issue（resolve/ignore/assign）

```bash
# Resolve
curl -X PUT -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"status": "resolved"}' \
  "https://sentry.io/api/0/issues/{issue_id}/"

# Ignore
curl -X PUT -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"status": "ignored", "statusDetails": {"ignoreDuration": 60}}' \
  "https://sentry.io/api/0/issues/{issue_id}/"

# Assign
curl -X PUT -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"assignedTo": "user@example.com"}' \
  "https://sentry.io/api/0/issues/{issue_id}/"
```

### 删除 Issue

```bash
curl -X DELETE -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/{issue_id}/"
```

---

## Events

### 列出 Issue 的事件

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/{issue_id}/events/"
```

### 获取最新事件

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/{issue_id}/events/latest/"
```

### 获取事件详情

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/events/{event_id}/"
```

---

## Releases

### 列出 Releases

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/"
```

### 创建 Release

```bash
curl -X POST -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "version": "1.0.0",
    "projects": ["my-project"]
  }' \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/"
```

### 获取 Release 详情

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/1.0.0/"
```

### 更新 Release（finalize）

```bash
curl -X PUT -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"dateReleased": "2026-01-01T00:00:00Z"}' \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/1.0.0/"
```

### 删除 Release

```bash
curl -X DELETE -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/1.0.0/"
```

---

## Release Files (Source Maps)

### 列出 Release 的文件

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/1.0.0/files/"
```

### 上传文件

```bash
curl -X POST -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -F "file=@./dist/main.js.map" \
  -F "name=~/static/js/main.js.map" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/1.0.0/files/"
```

### 删除文件

```bash
curl -X DELETE -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/1.0.0/files/{file_id}/"
```

---

## Deploys

### 列出 Deploys

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/1.0.0/deploys/"
```

### 创建 Deploy

```bash
curl -X POST -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "environment": "production",
    "name": "Deploy #42"
  }' \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/releases/1.0.0/deploys/"
```

---

## Monitors (Cron)

### 列出 Monitors

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/monitors/"
```

### 获取 Monitor 详情

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/monitors/{monitor_slug}/"
```

### 创建 Monitor

```bash
curl -X POST -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Daily Backup",
    "slug": "daily-backup",
    "type": "cron_job",
    "config": {
      "schedule_type": "crontab",
      "schedule": "0 2 * * *",
      "checkin_margin": 5,
      "max_runtime": 30
    }
  }' \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/monitors/"
```

### 创建 Check-in

```bash
curl -X POST -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"status": "in_progress"}' \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/monitors/{monitor_slug}/checkins/"
```

### 更新 Check-in

```bash
curl -X PUT -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"status": "ok", "duration": 1200}' \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/monitors/{monitor_slug}/checkins/{checkin_id}/"
```

---

## Performance / Discover

### 查询事件（Discover Query）

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/events/?field=title&field=count()&field=last_seen()&statsPeriod=24h&query=event.type:error&sort=-count"
```

### 查询 Transactions 性能

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/events/?field=transaction&field=count()&field=p50(transaction.duration)&field=p95(transaction.duration)&field=failure_rate()&statsPeriod=24h&query=event.type:transaction&sort=-count"
```

### 查询特定 Transaction

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/events/?field=transaction&field=avg(transaction.duration)&field=p50()&field=p95()&field=p99()&field=count()&query=event.type:transaction+transaction:/api/users&statsPeriod=7d"
```

---

## 通用参数

| 参数 | 说明 | 示例 |
|------|------|------|
| `statsPeriod` | 相对时间范围 | `1h`, `24h`, `7d`, `14d`, `30d` |
| `start` / `end` | 绝对时间范围 (ISO 8601) | `2026-01-01T00:00:00Z` |
| `environment` | 环境过滤 | `production`, `staging` |
| `project` | 项目 ID（数字） | `12345` |
| `cursor` | 分页游标 | 从 `Link` header 获取 |
| `per_page` | 每页数量（默认 100） | `25` |

---

## 分页

Sentry API 使用 cursor-based 分页，通过响应的 `Link` header 获取下一页：

```bash
# 解析 Link header 示例
curl -sI -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/issues/?limit=10" \
  | grep -i "^link:"
```

返回格式：
```
Link: <...?cursor=abc123>; rel="next"; results="true"; cursor="abc123"
```

---

## 错误处理

| HTTP 状态码 | 含义 | 处理方式 |
|-------------|------|----------|
| 401 | Token 无效或过期 | 检查 SENTRY_AUTH_TOKEN |
| 403 | 权限不足 | 检查 token scope |
| 404 | 资源不存在 | 检查 org/project/issue ID |
| 429 | 速率限制 | 等待 Retry-After header 指定的秒数 |
