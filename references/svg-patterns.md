# SVG 布局模式与配色参考

三种常用骨架，可直接套用坐标再按内容调整。所有模板默认画布 `viewBox="0 0 1000 H"`。

## 通用头部（每张图都先写这个）

```xml
<svg width="1000" height="700" viewBox="0 0 1000 700" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
      <path d="M 0 0 L 10 5 L 0 10 z" fill="#475569"/>
    </marker>
  </defs>
  <style>
    text { font-family: 'Noto Sans SC Thin','Noto Sans SC',sans-serif; }
    .h2 { font-size: 19px; font-weight: 700; fill: #1e293b; }
    .sub { font-size: 14px; fill: #64748b; }
    .card { fill: #ffffff; stroke: #cbd5e1; stroke-width: 1.5; }
  </style>
```

## 模式 A：容器 + 卡片网格（系统架构图）

适合"一个系统内含多个模块"。结构：外层圆角容器 + 深色标题条 + N×M 卡片 + 底部外部依赖。

```xml
<!-- 容器：边距40，标题条高64 -->
<rect x="40" y="30" width="920" height="540" rx="18" fill="#f8fafc" stroke="#334155" stroke-width="2"/>
<rect x="40" y="30" width="920" height="64" rx="18" fill="#1e293b"/>
<rect x="40" y="76" width="920" height="18" fill="#1e293b"/> <!-- 补齐标题条下方圆角 -->
<text x="500" y="72" text-anchor="middle" font-size="26" font-weight="700" fill="#ffffff">系统名</text>

<!-- 3列卡片：x = 75 / 370 / 665，宽260，间距35；行 y = 130 / 330，高150 -->
<rect class="card" x="75" y="130" width="260" height="150" rx="12"/>
<rect x="75" y="130" width="260" height="8" rx="4" fill="#0ea5e9"/> <!-- 顶部彩色 accent 条 -->
<text class="h2" x="205" y="172" text-anchor="middle">模块名</text>
<text class="sub" x="205" y="200" text-anchor="middle">要点一</text>
<text class="sub" x="205" y="224" text-anchor="middle">要点二</text>
```

卡片中心 x：205 / 500 / 795。核心模块可用高亮色边框（如 `stroke="#da7756" stroke-width="2.5"` + `fill="#fff7ed"`）。

## 模式 B：纵向流程图（pipeline / 时序）

适合"步骤一 → 步骤二 → …"。每步一个横条盒子，居中纵排，箭头连接。

```xml
<!-- 步骤盒：宽520 居中(x=240)，高70，垂直间距 = 高70 + 箭头区40 -->
<rect class="card" x="240" y="40" width="520" height="70" rx="10"/>
<text class="h2" x="500" y="70" text-anchor="middle">步骤一</text>
<text class="sub" x="500" y="95" text-anchor="middle">说明文字</text>
<line x1="500" y1="110" x2="500" y2="150" stroke="#475569" stroke-width="2.5" marker-end="url(#arrow)"/>
<!-- 下一步 y = 150，依此类推；分支用两列 x=120/560 宽360 -->
```

旁注标签（解释箭头含义）：在箭头旁放小圆角胶囊 `<rect rx="16" fill="#e2e8f0">` + 14px 文字。

## 模式 C：分层架构图（layer stack）

适合"表现层/逻辑层/数据层"类。全宽横条纵向堆叠，无箭头或单向箭头。

```xml
<!-- 每层：x=80 宽840 高90，层间距25；层内左侧放层名，右侧列组件小盒 -->
<rect x="80" y="40" width="840" height="90" rx="12" fill="#eff6ff" stroke="#3b82f6" stroke-width="1.5"/>
<text class="h2" x="130" y="92" >表现层</text>
<!-- 组件小盒：宽150 高50，从 x=320 起，间距20 -->
<rect x="320" y="60" width="150" height="50" rx="8" fill="#ffffff" stroke="#93c5fd"/>
<text class="sub" x="395" y="90" text-anchor="middle">组件A</text>
```

层配色建议从上到下：#eff6ff(蓝) / #f0fdf4(绿) / #fefce8(黄) / #faf5ff(紫)，边框用对应的 500 色阶。

## 配色板（Tailwind 色系，搭配安全）

- 中性：背景 #f8fafc，卡片白，边框 #cbd5e1，深色块 #1e293b，正文 #1e293b，次要文字 #64748b
- accent（卡片顶条/类别区分）：#0ea5e9 蓝 / #10b981 绿 / #f59e0b 橙 / #8b5cf6 紫 / #ec4899 粉 / #da7756 珊瑚（高亮主角）
- 一张图 accent 不超过 6 种；同层级元素用同饱和度

## 文字排版速查

| 用途 | 字号 | 颜色 |
|---|---|---|
| 图标题/容器标题 | 24–26 bold | 白（深底）或 #1e293b |
| 模块标题 | 18–20 bold | #1e293b |
| 模块内说明 | 13–14 | #64748b |
| 旁注/图例 | 12–13 | #94a3b8 |

行距：说明文字相邻 `<text>` 的 y 差 ≥ 字号 × 1.6。中文宽度 = 字号 × 字数，确认 ≤ 盒宽 − 24（左右各留 12px）。
