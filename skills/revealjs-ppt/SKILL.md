---
name: revealjs-ppt
description: |
  基于 reveal.js 制作网页版 PPT 幻灯片（单文件 HTML，零本地依赖）。
  触发场景：用户要求制作PPT、幻灯片、演示文稿、slides、presentation、网页PPT。
  支持从大纲/文档/markdown 生成完整的 reveal.js 幻灯片，深色科技主题，glass morphism 风格。
  也支持修改、迭代已有的 reveal.js PPT。
---

# reveal.js 网页 PPT 制作

## 设计规范

- **单文件 HTML**：所有 CSS 内联，JS 仅引用 reveal.js CDN
- **主题**：深色科技风（`#0b0e17` 背景），glass morphism 卡片
- **字体**：Noto Sans SC（Google Fonts CDN）
- **配色**：`--accent: #00d4ff`（青）、`--accent2: #ff6b35`（橙）、`--accent3: #a855f7`（紫）

## 依赖（CDN，不需要本地安装）

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/dist/reveal.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/dist/theme/black.css">
<script src="https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/dist/reveal.js"></script>
```

## 模板

完整参考模板在 `assets/template.html`。新建 PPT 时：

1. 读取 `assets/template.html` 了解完整的 CSS 样式和 HTML 结构
2. 保留 `<style>` 部分（glass-card、pill、stat-block、glow-ring 等组件样式）
3. 替换 `<section>` 内容为新大纲的幻灯片

## 幻灯片结构

```html
<div class="reveal">
  <div class="slides">
    <!-- 每个 <section> 是一页幻灯片 -->
    <section>标题页</section>

    <!-- 嵌套 section = 垂直子幻灯片（按↓翻页展开详情） -->
    <section>
      <section>章节封面</section>
      <section>详情1</section>
      <section>详情2</section>
    </section>
  </div>
</div>
```

## 常用组件（参见模板）

| 组件 | class | 用途 |
|------|-------|------|
| 毛玻璃卡片 | `glass-card` | 内容容器 |
| 药丸标签 | `pill pill-cyan/orange/purple` | 标签/关键词 |
| 数据块 | `stat-block` | 大数字+说明 |
| 渐变文字 | `grad-text` / `grad-text-warm` | 强调文字 |
| 发光环 | `glow-ring` | 装饰性图标容器 |
| 对比表格 | `compare-table` | 功能对比 |

## 内容拆分原则

- 每个章节 2-5 页幻灯片
- 每页不超过 6 个要点
- 大段文字拆成多页，用垂直子幻灯片
- 数据用 stat-block，对比用表格，流程用编号列表

## reveal.js 初始化

```javascript
Reveal.initialize({
  hash: true,
  slideNumber: 'c/t',
  transition: 'slide',
  backgroundTransition: 'fade',
  center: false,
  width: 1200,
  height: 700,
  margin: 0.06
});
```

## 样式参考

详细的 CSS 变量、动画和组件样式见 `references/styles.md`。
