# /// script
# requires-python = ">=3.11"
# dependencies = ["pymupdf==1.28.2"]
# ///
"""Check this historical edition's recovered manuscript and rendered PDF."""

import hashlib
import json
import re
from pathlib import Path

import pymupdf

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL_SHA256 = "edfc70f7d910edfcfb04cca61f2b62345047a6c7423e787f272998061ff4c79d"
REPAIRS = {
    "राyतो": "राहतो",
    "टुरिंगन (Turing)े": "टुरिंगने (Turing)",
    "civilization": "civilisation",
    "specialized": "specialised",
}


def require(condition, message):
    if not condition:
        raise SystemExit(message)


def normalise(text):
    for old, new in REPAIRS.items():
        text = text.replace(old, new)
    return re.sub(r"\s+", "", text)


def read_json(path):
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


def main():
    original = ROOT / "provenance/original-2011.pdf"
    require(
        hashlib.sha256(original.read_bytes()).hexdigest() == ORIGINAL_SHA256,
        "The archived original PDF has changed.",
    )
    recovered = read_json("provenance/recovered-lines.json")
    chapters = read_json("chapters.json")
    figures = read_json("figures.json")
    require(
        len(chapters) == 10 and len(figures) == 10,
        "Expected ten chapters and ten illustrations.",
    )
    for item in figures:
        require((ROOT / item["path"]).is_file(), f"Missing image: {item['path']}")
        require(
            bool(item["caption"] and item["credit"] and item["status"]),
            f"Missing caption or source status for figure {item['id']}.",
        )

    checked = 0
    for chapter in chapters:
        text = (ROOT / "chapters" / chapter["file"]).read_text(encoding="utf-8")
        source = normalise(text).replace("\\", "")
        position = 0
        first, last = chapter["pages"]
        for number in range(first, last + 1):
            for line in recovered[number - 1]:
                y = line["y"]
                # Old folios/bylines, chapter titles and the separately checked table.
                if (
                    y > 705
                    or (number == first and y < 160)
                    or (number == 22 and 290 < y < 530)
                ):
                    continue
                target = normalise(line["text"])
                found = source.find(target, position)
                require(
                    found >= 0,
                    f"Missing or reordered text from original page {number}.",
                )
                position = found + len(target)
                checked += len(target)

    pdf = pymupdf.open(ROOT / "science_curiosity.pdf")
    top_bookmarks = [entry for entry in pdf.get_toc() if entry[0] == 1]
    require(
        len(top_bookmarks) == 11, "Expected ten chapter bookmarks and acknowledgements."
    )
    require(
        sum(len(page.get_images()) for page in pdf) == 10,
        "Expected ten embedded illustrations.",
    )
    heading_pages = []
    for number, page in enumerate(pdf, start=1):
        text = page.get_text()
        require(len(text.strip()) > 20, f"Unexpected blank page {number}.")
        require("\ufffd" not in text, f"Replacement character on page {number}.")
        spans = [
            span
            for block in page.get_text("dict")["blocks"]
            if block["type"] == 0
            for line in block["lines"]
            for span in line["spans"]
        ]
        if any(abs(span["size"] - 25) < 0.1 for span in spans):
            heading_pages.append(number)
        for link in page.get_links():
            if "page" in link:
                require(
                    0 <= link["page"] < len(pdf),
                    f"Broken internal link on page {number}.",
                )
        for font in page.get_fonts():
            require(
                bool(pdf.extract_font(font[0])[3]), f"Unembedded font on page {number}."
            )
    require(
        heading_pages == [entry[2] for entry in top_bookmarks[:10]],
        "Chapter bookmark destinations do not match their rendered headings.",
    )
    print(
        f"Verified {checked:,} recovered characters in reading order, {len(pdf)} pages, "
        "10 illustrations, embedded fonts and chapter bookmarks."
    )
    print("Visual review is still required after changes to typography or layout.")


if __name__ == "__main__":
    main()
