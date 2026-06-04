---
name: revealjs-ppt
description: |
  基于 Reveal.js 生成精美在线 PPT 并部署到公网。当用户需要"做PPT"、"在线演示"、"幻灯片"、"Reveal.js PPT"、"部署PPT"时使用此 skill。
  触发场景：(1) 用户提供大纲/文档要求生成在线PPT (2) 用户要求修改已有在线PPT (3) 用户说"帮我做个演示文稿"、"生成幻灯片"
---

# Reveal PPT — 在线演示文稿生成与部署

## 工作流

1. **理解大纲** → 区分"幻灯片内容"与"演讲者备注"
2. **生成 HTML** → 单文件 Reveal.js，写入 `<project>/dist/index.html`
3. **部署** → 用 nami-static-deploy 发布到公网
4. **迭代** → 用户反馈 → 修改 → 重新部署

## 关键规则

### 内容筛选（最重要）

大纲中以下内容 **不要** 写进幻灯片：
- `话术：` / `可以说：` — 演讲者口头说的话
- `演示步骤：` / `操作：` — 现场演示动作
- `> 提示` / `> 注意` — 备注提醒
- `建议：` / `Tips：` — 给演讲者的建议
- 括号内的说明性文字如 `（现场演示）`、`（录屏备份）`

幻灯片只放 **关键词、短句、数据、图表**，给观众看的视觉辅助。

### 视觉设计规范

参考 [references/design-spec.md](references/design-spec.md) 获取完整 CSS 模板。核心要点：

- **全局居中（⚠️ 最易出错）**：`.reveal section` 必须同时包含 `text-align: center` **和** `display: flex !important; flex-direction: column; align-items: center; justify-content: center;`。只写 `text-align: center` 会导致内容不居中。Reveal 配置中 `center` 必须为 `false`。
- **暗色科技风**：深色背景 `#0b0e17`，渐变光晕装饰
- **毛玻璃卡片**：`backdrop-filter: blur(12px)` + 半透明边框
- **渐变文字**：标题用 `background-clip: text` 渐变
- **卡片网格**：内容用 `.grid-2` / `.grid-3` 等网格布局，替代纯列表
- **悬浮交互**：卡片 hover 上浮 + 边框发光
- **章节标题页**：每章有独立渐变背景的过渡页
- **表格样式**：圆角、渐变表头、玻璃底色

### 结构规范

- **章节标题页必须带原始序号**：如 "2. 🎯 快速认识"、"7. 🆚 为什么必须是龙虾"
- **封面后第一张必须是"整体结构"页**：用列表展示所有章节的序号和名称，给观众全局视角（不用九宫格/grid）
- 横向 = 章节，纵向 = 子页面（`<section>` 嵌套）

### 技术规范

- 单个 HTML 文件，CDN 加载 Reveal.js 5.x
- 字体：Noto Sans SC（Google Fonts CDN）
- Reveal 配置：`center: false`（自行控制居中）、`slideNumber: 'c/t'`、`hash: true`
- 横向 = 章节，纵向 = 子页面（`<section>` 嵌套）

### 部署

使用 nami-static-deploy skill 的流程：
```bash
cd <project>/dist
rm -f ../dist.zip
7z a -tzip ../dist.zip .
python3 <nami-deploy-script> ../dist.zip
```

部署脚本路径见 `nami-static-deploy` skill。

## 修改流程

当用户要求修改已有 PPT 时：

1. 先更新本 skill（如果修改涉及通用规范）
2. 读取当前 `dist/index.html`
3. 用 `edit` 工具做精确修改（而非整文件重写）
4. 重新打包部署

## ⚠️ 重写/重建流程

当需要大幅重写 PPT 内容时（如换大纲、重新生成）：

1. **先 diff 当前正常工作的版本**，提取 `<style>` 块和 `Reveal.initialize` 配置
2. **完整保留原有 CSS 和配置**，只替换 `<section>` 内容
3. **写完后校验**：`.reveal section` 必须包含 `display: flex !important; align-items: center; justify-content: center;`，`center` 必须为 `false`
4. 出现居中问题时，**先 diff 上一个正确版本**，不要凭猜测修
