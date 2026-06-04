# Reveal PPT 视觉设计规范

## CSS 变量

```css
:root {
  --r-background-color: #0b0e17;
  --r-main-color: #c8d6e5;
  --r-heading-color: #ffffff;
  --r-link-color: #00d4ff;
  --accent: #00d4ff;
  --accent2: #ff6b35;
  --accent3: #a855f7;
  --glass: rgba(255,255,255,0.06);
  --glass-border: rgba(255,255,255,0.1);
}
```

## 字体

```css
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@300;400;500;700;900&display=swap');
.reveal { font-family: "Noto Sans SC","PingFang SC","Microsoft YaHei",sans-serif; }
```

## 全局居中（⚠️ 必须完整复制，不可省略 flex 部分）

```css
.reveal section {
  text-align: center;
  padding: 40px 60px;
  box-sizing: border-box;
  display: flex !important;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
```

**关键说明：**
- `display: flex !important` + `align-items: center` + `justify-content: center` 是水平+垂直居中的核心，**缺一不可**
- Reveal 配置必须设 `center: false`（由 CSS flex 自行控制居中，不用 Reveal 内置居中）
- 如果只写 `text-align: center` 而漏掉 flex，内容会偏移不居中
- 如果把 Reveal 的 `center` 改为 `true`，会与 flex 布局冲突，导致更严重的偏移

所有内容默认居中对齐。grid 布局内的卡片也设 `text-align: center`。

## 背景光晕

```css
.reveal .slides { background:
  radial-gradient(ellipse at 20% 50%, rgba(0,212,255,0.08) 0%, transparent 60%),
  radial-gradient(ellipse at 80% 20%, rgba(168,85,247,0.06) 0%, transparent 50%),
  radial-gradient(ellipse at 60% 80%, rgba(255,107,53,0.05) 0%, transparent 50%);
}
```

## 毛玻璃卡片

```css
.glass-card {
  background: var(--glass);
  border: 1px solid var(--glass-border);
  border-radius: 16px;
  padding: 28px 32px;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
}
```

## 渐变文字

```css
.grad-text {
  background: linear-gradient(135deg, var(--accent) 0%, var(--accent3) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.grad-text-warm {
  background: linear-gradient(135deg, var(--accent2) 0%, #fbbf24 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
```

## 网格布局

```css
.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; text-align: center; }
.grid-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; text-align: center; }
.grid-4 { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; text-align: center; }
.grid-5 { display: grid; grid-template-columns: repeat(5, 1fr); gap: 14px; text-align: center; }
```

## 功能卡片

```css
.feat-card {
  background: var(--glass);
  border: 1px solid var(--glass-border);
  border-radius: 14px;
  padding: 24px;
  transition: transform 0.3s, border-color 0.3s;
}
.feat-card:hover { transform: translateY(-4px); border-color: var(--accent); }
.feat-card .icon { font-size: 2em; margin-bottom: 12px; display: block; }
.feat-card h4 { font-size: 0.9em; color: #fff; margin: 0 0 8px 0; font-weight: 600; }
.feat-card p { font-size: 0.72em; color: #8899aa; margin: 0; line-height: 1.5; }
```

## 标签胶囊

```css
.pill {
  display: inline-block;
  padding: 4px 14px;
  border-radius: 20px;
  font-size: 0.65em;
  font-weight: 500;
  margin: 3px 4px;
}
.pill-cyan  { background: rgba(0,212,255,0.15); color: var(--accent); border: 1px solid rgba(0,212,255,0.3); }
.pill-orange { background: rgba(255,107,53,0.15); color: var(--accent2); border: 1px solid rgba(255,107,53,0.3); }
.pill-purple { background: rgba(168,85,247,0.15); color: var(--accent3); border: 1px solid rgba(168,85,247,0.3); }
```

## 数据展示块

```css
.stat-block { text-align: center; }
.stat-block .num { font-size: 2.2em; font-weight: 900; display: block; line-height: 1.1; }
.stat-block .label { font-size: 0.65em; color: #8899aa; margin-top: 4px; display: block; }
```

## 步骤指示器

```css
.step-row {
  display: flex; align-items: center; gap: 16px;
  padding: 14px 20px; margin: 8px 0;
  background: var(--glass); border-radius: 12px;
  border-left: 3px solid var(--accent);
}
.step-num {
  width: 36px; height: 36px; border-radius: 50%;
  background: linear-gradient(135deg, var(--accent), var(--accent3));
  color: #fff; font-weight: 700; font-size: 0.85em;
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.step-text { font-size: 0.8em; color: #dde; }
```

## 表格

```css
.reveal table { border-collapse: separate; border-spacing: 0; width: 100%; border-radius: 12px; overflow: hidden; }
.reveal table th {
  background: linear-gradient(135deg, rgba(0,212,255,0.2), rgba(168,85,247,0.2));
  color: #fff; font-weight: 600; font-size: 0.72em; padding: 12px 16px; text-align: center;
}
.reveal table td {
  background: var(--glass); font-size: 0.7em; padding: 10px 16px;
  border-bottom: 1px solid var(--glass-border); color: #bcc;
}
.reveal table tr:last-child td { border-bottom: none; }
```

## 章节标题页

```css
.section-title {
  text-align: center !important;
  display: flex !important; flex-direction: column; align-items: center; justify-content: center;
}
.section-title h2 { font-size: 2.2em; margin-bottom: 0.2em; }
.section-title p { font-size: 0.85em; color: #8899aa; }
```

用 `data-background-gradient` 给章节标题页加独立渐变背景：

```html
<section class="section-title" data-background-gradient="linear-gradient(135deg, #0b0e17 0%, #1a1040 50%, #0b0e17 100%)">
```

## 发光环动画（封面/Q&A页）

```css
.glow-ring {
  font-size: 4em;
  animation: pulse-glow 3s ease-in-out infinite;
}
@keyframes pulse-glow {
  0%, 100% { filter: drop-shadow(0 0 20px rgba(0,212,255,0.4)); transform: scale(1); }
  50% { filter: drop-shadow(0 0 40px rgba(0,212,255,0.8)); transform: scale(1.05); }
}
```

## Reveal.js 配置

```js
Reveal.initialize({
  hash: true,
  slideNumber: 'c/t',
  transition: 'slide',
  backgroundTransition: 'fade',
  center: false,       // 自行控制居中
  width: 1200,
  height: 700,
  margin: 0.06,
});
```

## CDN 引用

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/dist/reveal.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/dist/theme/black.css">
<script src="https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/dist/reveal.js"></script>
```
