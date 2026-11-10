"""Convert brand PNGs to lossless SVG paths, without embedded raster images.

Preserves the original pixel geometry, including antialiasing and transparency.
Requires Pillow; these dependencies are only used for asset maintenance.
"""

from collections import defaultdict
from pathlib import Path

from PIL import Image


def convert(source: Path) -> None:
    image = Image.open(source).convert("RGBA")
    width, height = image.size
    pixels = image.load()
    colors = defaultdict(list)
    for y in range(height):
        x = 0
        while x < width:
            color = pixels[x, y]
            end = x + 1
            while end < width and pixels[end, y] == color:
                end += 1
            if color[3]:
                colors[color].append(f"M{x} {y}h{end-x}v1h{x-end}z")
            x = end
    lines = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" '
        f'height="{height}" viewBox="0 0 {width} {height}">',
        '<!-- Original geometry and RGBA preserved as vector paths. -->',
        '<g shape-rendering="crispEdges">',
    ]
    for (r, g, b, a), paths in colors.items():
        opacity = f' fill-opacity="{a / 255:.12f}"' if a != 255 else ""
        lines.append(f'<path fill="#{r:02x}{g:02x}{b:02x}"{opacity} d="{"".join(paths)}"/>')
    lines.extend(["</g>", "</svg>"])
    target = source.with_suffix(".svg")
    target.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"{target.name}: {target.stat().st_size:,} bytes")


if __name__ == "__main__":
    brand = Path(__file__).resolve().parents[1] / "docs/assets/images/brand"
    for source in sorted(brand.glob("*.png")):
        convert(source)
