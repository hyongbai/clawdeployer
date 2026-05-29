---
name: clawdeployer-deploy
description: |
  将项目部署到 clawdeployer 多项目静态托管平台（GitHub Pages + Cloudflare Worker 子域名）。
  触发关键词：部署、deploy、发布到 clawdeployer、部署项目、静态部署、上线、部署到子域名。
  当用户要求将构建产物、静态站点、前端项目部署到 clawdeployer.cc.cd 时使用此 skill。
---

# clawdeployer 部署

## 固定工作目录

**所有操作必须在以下目录执行（不论当前 session 工作目录是什么）：**

```
/home/nami/clawdeployer
```

## 部署流程

### 1. 读取部署规则

```bash
cat /home/nami/clawdeployer/CLAUDE.md
```

严格按照 CLAUDE.md 中的规则执行。

### 2. 准备构建产物

- 将用户指定的项目构建产物放入 `/home/nami/clawdeployer/<项目目录名>/`
- 目录名即子域名前缀：`<目录名>.clawdeployer.cc.cd`
- 如果项目需要构建（如 Hugo、Vite 等），先构建再拷贝产物
- 构建时 baseURL 必须设为 `https://<目录名>.clawdeployer.cc.cd/`

### 3. 添加 Cloudflare DNS 记录

使用 config.sh 中的凭证：

```bash
source /home/nami/claw-tutorial/config.sh
```

添加 A 记录（Proxied）：

```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/f98ddbd2d400bdd9419926dd8ba049b1/dns_records" \
  -H "Authorization: Bearer $CF_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "type": "A",
    "name": "<目录名>.clawdeployer.cc.cd",
    "content": "192.0.2.1",
    "proxied": true,
    "ttl": 1
  }'
```

如果记录已存在（error code 81057），跳过此步。

### 4. 注册到首页索引

在 `/home/nami/clawdeployer/index.html` 的 `<!-- PROJECTS_END -->` 标记前插入新项目卡片：

```html
    <a class="project" href="https://<目录名>.clawdeployer.cc.cd/" target="_blank">
      <div class="project-info">
        <div class="project-name"><目录名></div>
        <div class="project-desc"><项目简短描述></div>
      </div>
      <span class="project-arrow">→</span>
    </a>
```

用 `edit` 工具在 `<!-- PROJECTS_END -->` 前插入即可。

### 5. 更新 CLAUDE.md 项目表

在「现有项目」表中添加新行。

### 6. Git 推送

```bash
cd /home/nami/clawdeployer
git add -A
git commit -m "deploy: add <目录名>"
git push origin main
```

SSH remote 已配置为 `github-claw-pub`（Deploy Key），直接 push 即可。
如果远程有更新，先 `git pull --rebase origin main` 再 push。

### 7. 完成确认

告知用户：
- 项目地址：`https://<目录名>.clawdeployer.cc.cd/`
- 首页索引：`https://clawdeployer.cc.cd/`（可查看所有已部署项目）

## 注意事项

- 不要把源码推进去，只推构建产物
- Hugo 站点需要安装 hugo 并构建
- 如果 `known_hosts` 没有 github.com，先执行 `ssh-keyscan github.com >> ~/.ssh/known_hosts`
