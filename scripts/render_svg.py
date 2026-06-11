#!/usr/bin/env python3
"""SVG -> PNG 渲染（cairosvg）。
用法: python3 render_svg.py input.svg output.png [--width 2000]
"""
import argparse, os, sys

def main():
    p = argparse.ArgumentParser()
    p.add_argument("svg")
    p.add_argument("png")
    p.add_argument("--width", type=int, default=2000, help="输出像素宽度，建议为显示宽度的2倍")
    a = p.parse_args()

    try:
        import cairosvg
    except ImportError:
        sys.exit("cairosvg 未安装，请先运行 setup_env.sh")

    if not os.path.exists(a.svg):
        sys.exit(f"找不到输入文件: {a.svg}")

    os.makedirs(os.path.dirname(os.path.abspath(a.png)), exist_ok=True)
    cairosvg.svg2png(url=a.svg, write_to=a.png, output_width=a.width)
    size = os.path.getsize(a.png)
    print(f"已渲染: {a.png} ({size/1024:.0f} KB, 宽 {a.width}px)")
    if size < 5000:
        print("警告: 文件过小，画面可能为空白，请检查渲染结果")

if __name__ == "__main__":
    main()
