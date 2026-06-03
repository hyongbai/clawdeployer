# 样式参考

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

## glass-card

```css
.glass-card {
  background: var(--glass);
  border: 1px solid var(--glass-border);
  border-radius: 16px;
  padding: 28px 32px;
  backdrop-filter: blur(12px);
  text-align: left;
}
```

## pill 标签

```css
.pill {
  display: inline-block;
  padding: 4px 16px;
  border-radius: 999px;
  font-size: 0.7em;
  font-weight: 600;
  margin: 4px;
}
.pill-cyan { background: rgba(0,212,255,0.15); color: var(--accent); }
.pill-orange { background: rgba(255,107,53,0.15); color: var(--accent2); }
.pill-purple { background: rgba(168,85,247,0.15); color: var(--accent3); }
```

## stat-block 数据块

```css
.stat-block {
  text-align: center;
  padding: 20px;
}
.stat-block .num {
  font-size: 2.2em;
  font-weight: 900;
  display: block;
}
.stat-block .label {
  font-size: 0.65em;
  color: #94a3b8;
  margin-top: 4px;
  display: block;
}
```

## grad-text 渐变文字

```css
.grad-text {
  background: linear-gradient(135deg, #00d4ff, #a855f7);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
.grad-text-warm {
  background: linear-gradient(135deg, #ff6b35, #f59e0b);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
```

## glow-ring 发光环

```css
.glow-ring {
  width: 120px; height: 120px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(0,212,255,0.2), transparent 70%);
  border: 2px solid rgba(0,212,255,0.3);
  display: flex; align-items: center; justify-content: center;
  font-size: 3em;
  margin: 0 auto 20px;
  animation: pulse-glow 3s ease-in-out infinite;
}
@keyframes pulse-glow {
  0%,100% { box-shadow: 0 0 20px rgba(0,212,255,0.2); }
  50% { box-shadow: 0 0 40px rgba(0,212,255,0.4); }
}
```

## compare-table 对比表格

```css
.compare-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.7em;
}
.compare-table th {
  background: rgba(0,212,255,0.1);
  padding: 10px 14px;
  text-align: left;
  color: var(--accent);
  border-bottom: 2px solid rgba(0,212,255,0.2);
}
.compare-table td {
  padding: 8px 14px;
  border-bottom: 1px solid var(--glass-border);
}
```

## 背景渐变（用于特殊幻灯片）

```html
<!-- 渐变背景 -->
<section data-background-gradient="linear-gradient(135deg, #0b0e17 0%, #1a1040 50%, #0b0e17 100%)">

<!-- 粒子背景（纯CSS） -->
background:
  radial-gradient(ellipse at 20% 50%, rgba(0,212,255,0.08) 0%, transparent 60%),
  radial-gradient(ellipse at 80% 20%, rgba(168,85,247,0.06) 0%, transparent 50%);
```
