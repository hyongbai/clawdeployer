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

## 执行方式

1. 读取项目规则文件：

```bash
cat /home/nami/clawdeployer/CLAUDE.md
```

2. 严格按照 CLAUDE.md 中「新增项目步骤」执行全部步骤，不要跳过任何一步。

规则文件是唯一权威来源，本 skill 不重复定义流程细节。
