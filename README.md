# svg-tech-diagram

一个 Claude 技能（Agent Skill）：通过**手写 SVG + cairosvg 渲染**生成高清技术示意图 PNG，内置中文字体侧载方案，解决无 CJK 字体环境下中文变方框（tofu）的问题。

适用：架构图、流程图、分层图、模块关系图、时序示意图；把 ASCII 字符画转成正式图片；为文档/PPT 生成带中文标注的插图。

## 效果示例

| 用例 | 输出 |
|---|---|
| ASCII 架构图 → 图片 | `examples/microservice_architecture.png` |
| RAG 流程图 | `examples/rag_pipeline.png` |
| Web 分层架构图 | `examples/layered-web-arch.png` |

每张图均附可编辑的 SVG 源文件，改文字/配色后可重新渲染。

## 安装

**Claude Code / Cowork**：将本仓库目录放入技能目录（如 `~/.claude/skills/svg-tech-diagram/`），或在 Cowork 中通过 `.skill` 包安装。

依赖：Python 3 + cairosvg（`scripts/setup_env.sh` 会自动安装），Node/npm（仅在需要侧载中文字体时使用）。

## 工作原理

1. **环境准备**（`scripts/setup_env.sh`，幂等）：检查 cairosvg 与中文字体；若缺字体，通过 npm 的 `@fontsource/noto-sans-sc` 获取 woff，用 fontTools 转为 ttf 注册进 fontconfig——适用于无 root 权限、apt 不可用的沙箱环境
2. **手写 SVG**：按 `references/svg-patterns.md` 的三种布局骨架（容器+卡片网格 / 纵向流程 / 分层堆叠）写 XML，含中文定宽估算规则避免文字溢出
3. **渲染**（`scripts/render_svg.py`）：cairosvg 以 2 倍显示宽度输出高清 PNG
4. **视觉校验**：渲染后必须查看 PNG，检查方框/溢出/箭头方向，迭代至通过

## 文件结构

```
svg-tech-diagram/
├── SKILL.md                  # 技能主文件（Claude 读取的指引）
├── scripts/
│   ├── setup_env.sh          # 幂等环境准备（cairosvg + 中文字体侧载）
│   └── render_svg.py         # SVG → PNG 渲染
├── references/
│   └── svg-patterns.md       # 布局模板 + 配色板 + 排版速查
└── examples/                 # 示例输出（PNG + SVG 源）
```

## 测试结果

3 个测试用例的对照实验（同一模型，有/无技能）：有技能 100% 断言通过、全部一轮渲染成功；无技能 93%、且两例首轮中文渲染失败需自行排查字体。技能在冷环境（无字体/无 cairosvg）下优势更大。

## License

MIT
