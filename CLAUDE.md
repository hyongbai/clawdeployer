# clawdeployer

多项目静态部署仓库。通过 GitHub Pages + Cloudflare Worker 提供固定访问链接，每个项目可绑定独立子域名。

## 规则

- 每个部署项目占一个独立的顶层目录
- 根目录不放任何项目文件（只放本说明和通用配置）
- 目录名即子域名：`https://<目录名>.clawdeployer.cc.cd/`
- 各项目互相独立，互不影响

## 部署方式

将构建产物放入对应目录，push 到 `main` 分支即自动生效（GitHub Pages 从 main 分支根目录部署）。

## 子域名路由架构

```
用户访问 <子域名>.clawdeployer.cc.cd
  ↓
DNS A 记录（Proxied）→ Cloudflare
  ↓
Worker Route: *.clawdeployer.cc.cd/*
  ↓
Worker 从 hostname 提取子域名，拼成 GitHub Pages 路径
  ↓
请求 https://hyongbai.github.io/clawdeployer/<子域名>/ 并返回
```

## 新增项目步骤

1. 在仓库根目录创建新目录，放入构建产物
   - 只放构建产物，不放源码
   - 如需构建（Hugo、Vite 等），baseURL 设为 `https://<目录名>.clawdeployer.cc.cd/`
2. 在 Cloudflare DNS 添加一条 A 记录：
   - Name: `<目录名>.clawdeployer.cc.cd`
   - Content: `192.0.2.1`（任意 IP，Proxied 模式下不生效）
   - Proxy: 开启（橙色云朵）
   - 凭证：`source /home/nami/claw-tutorial/config.sh`，用 `$CF_TOKEN`
   - 如果记录已存在（error code 81057），跳过
3. 注册到首页索引：在根目录 `index.html` 的 `<!-- PROJECTS_END -->` 标记前插入新项目卡片：
   ```html
   <a class="project" href="https://<目录名>.clawdeployer.cc.cd/" target="_blank">
     <div class="project-info">
       <div class="project-name"><目录名></div>
       <div class="project-desc"><简短描述></div>
     </div>
     <span class="project-arrow">→</span>
   </a>
   ```
4. 更新下方「现有项目」表，添加新行
5. Push 到 main 分支
   - SSH remote 已配置为 `github-claw-pub`（Deploy Key）
   - 如远程有更新，先 `git pull --rebase origin main`

Worker 会自动将子域名路由到对应目录，无需其他配置。
首页索引：`https://clawdeployer.cc.cd/`

## 现有项目

| 目录 | 子域名 | 说明 |
|------|--------|------|
| clawtutorial | clawtutorial.clawdeployer.cc.cd | OpenClaw & 安全龙虾教程 PPT |
| ai-hot | ai-hot.clawdeployer.cc.cd | AI热榜导航站 (laolaoshiren/ai-hot) |
| worldcup | worldcup.clawdeployer.cc.cd | 历届FIFA世界杯奖牌榜 |
| winter2026 | winter2026.clawdeployer.cc.cd | 2026米兰冬奥会奖牌榜 |

## 相关资源

- **GitHub 仓库**: https://github.com/hyongbai/clawdeployer
- **Cloudflare Worker**: `clawdeployer`（Account ID: 8d77b33eec7ead444d296835e2733fda）
- **Cloudflare Zone**: `clawdeployer.cc.cd`（Zone ID: f98ddbd2d400bdd9419926dd8ba049b1）
- **Cloudflare DNS 管理**: https://dash.cloudflare.com/f98ddbd2d400bdd9419926dd8ba049b1/dns
- **Cloudflare Worker 管理**: https://dash.cloudflare.com/8d77b33eec7ead444d296835e2733fda/workers
