#!/usr/bin/env bash
# 幂等环境准备：cairosvg + 中文字体（Noto Sans SC）
# 用法: bash setup_env.sh
set -u

echo "== 1/3 检查 cairosvg =="
if python3 -c "import cairosvg" 2>/dev/null; then
  echo "cairosvg 已安装"
else
  pip install cairosvg fonttools brotli --break-system-packages -q || pip install cairosvg fonttools brotli -q
  python3 -c "import cairosvg" && echo "cairosvg 安装完成"
fi
python3 -c "import fontTools" 2>/dev/null || pip install fonttools brotli --break-system-packages -q

echo "== 2/3 检查中文字体 =="
if fc-list 2>/dev/null | grep -qi "noto sans sc\|cjk\|wqy"; then
  echo "中文字体已存在"
else
  echo "未找到中文字体，开始侧载（npm @fontsource/noto-sans-sc -> woff 转 ttf -> fontconfig 注册）"
  TMPD=$(mktemp -d)
  cd "$TMPD"
  npm install @fontsource/noto-sans-sc --silent
  FDIR="$TMPD/node_modules/@fontsource/noto-sans-sc/files"
  FONTDIR="$HOME/.local/share/fonts"
  mkdir -p "$FONTDIR"
  for w in 400 700; do
    python3 - "$FDIR" "$FONTDIR" "$w" <<'PYEOF'
import sys, os
from fontTools.ttLib import TTFont
fdir, fontdir, w = sys.argv[1], sys.argv[2], sys.argv[3]
src = os.path.join(fdir, f"noto-sans-sc-chinese-simplified-{w}-normal.woff")
f = TTFont(src)
f.flavor = None
f.save(os.path.join(fontdir, f"NotoSansSC-{w}.ttf"))
print(f"weight {w} -> ttf 完成")
PYEOF
  done
  fc-cache -f >/dev/null 2>&1
fi

echo "== 3/3 可用中文字体族名（SVG font-family 用这个）=="
fc-list 2>/dev/null | grep -i "noto sans sc\|cjk\|wqy" | sed 's/.*: //;s/:style.*//' | sort -u
echo "完成。"
