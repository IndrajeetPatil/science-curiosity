# /// script
# requires-python = ">=3.15"
# dependencies = ["pymupdf==1.28.2"]
# ///
"""Check this historical edition's recovered manuscript and rendered PDF."""

import hashlib
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Any

import pymupdf

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL_SHA256 = "edfc70f7d910edfcfb04cca61f2b62345047a6c7423e787f272998061ff4c79d"
REPAIRS = {
    "राyतो": "राहतो",
    "टुरिंगन (Turing)े": "टुरिंगने (Turing)",
    "civilization": "civilisation",
    "specialized": "specialised",
}
XMP_NAMESPACES = {
    "dc": "http://purl.org/dc/elements/1.1/",
    "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    "pdf": "http://ns.adobe.com/pdf/1.3/",
}
XMP_PATHS = {
    "title": ".//dc:title/rdf:Alt/rdf:li",
    "author": ".//dc:creator/rdf:Seq/rdf:li",
    "subject": ".//dc:description/rdf:Alt/rdf:li",
    "keywords": ".//pdf:Keywords",
}
CHAPTER_HEADING_SIZE = 25


def require(condition: object, message: str) -> None:
    if not condition:
        raise SystemExit(message)


def normalise(text: str) -> str:
    for old, new in REPAIRS.items():
        text = text.replace(old, new)
    return re.sub(r"\s+", "", text)


def read_json(path: str) -> Any:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


def is_skipped(page: int, first_page: int, y: float) -> bool:
    """Skip old folios/bylines, chapter titles and the separately checked table."""
    return y > 705 or (page == first_page and y < 160) or (page == 22 and 290 < y < 530)


def check_inventory(chapters: list[dict], figures: list[dict]) -> None:
    require(
        len(chapters) == 10 and len(figures) == 10,
        "Expected ten chapters and ten illustrations.",
    )
    for figure in figures:
        require((ROOT / figure["path"]).is_file(), f"Missing image: {figure['path']}")
        require(
            figure["caption"] and figure["credit"] and figure["status"],
            f"Missing caption or source status for figure {figure['id']}.",
        )


def check_manuscript(chapters: list[dict], recovered: list[list[dict]]) -> int:
    """Check that recovered text appears in order; return the characters matched."""
    checked = 0
    for chapter in chapters:
        text = (ROOT / "chapters" / chapter["file"]).read_text(encoding="utf-8")
        source = normalise(text).replace("\\", "")
        position = 0
        first, last = chapter["pages"]
        for page in range(first, last + 1):
            for line in recovered[page - 1]:
                if is_skipped(page, first, line["y"]):
                    continue
                target = normalise(line["text"])
                found = source.find(target, position)
                require(
                    found >= 0, f"Missing or reordered text from original page {page}."
                )
                position = found + len(target)
                checked += len(target)
    return checked


def check_metadata(pdf: pymupdf.Document) -> None:
    xmp = ET.fromstring(pdf.get_xml_metadata())
    for key, path in XMP_PATHS.items():
        value = pdf.metadata[key]
        require(
            value and xmp.findtext(path, namespaces=XMP_NAMESPACES) == value,
            f"Missing or inconsistent PDF metadata: {key}.",
        )
    xmp_keywords = [
        item.text
        for item in xmp.findall(".//dc:subject/rdf:Bag/rdf:li", XMP_NAMESPACES)
    ]
    require(
        xmp_keywords == pdf.metadata["keywords"].split(", "),
        "XMP keyword entries do not match Info keywords.",
    )
    catalog = pdf.pdf_catalog()
    require(
        pdf.xref_get_key(catalog, "Lang") == ("string", "mr")
        and xmp.findtext(".//dc:language/rdf:Bag/rdf:li", namespaces=XMP_NAMESPACES)
        == "mr",
        "Expected Marathi language in the PDF catalogue and XMP.",
    )
    require(
        pdf.xref_get_key(catalog, "ViewerPreferences/DisplayDocTitle")
        == ("bool", "true"),
        "Expected the PDF viewer to display the document title.",
    )


def has_chapter_heading(page: pymupdf.Page) -> bool:
    return any(
        abs(span["size"] - CHAPTER_HEADING_SIZE) < 0.1
        for block in page.get_text("dict")["blocks"]
        if block["type"] == 0
        for line in block["lines"]
        for span in line["spans"]
    )


def check_pages(pdf: pymupdf.Document) -> None:
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
        if has_chapter_heading(page):
            heading_pages.append(number)
        for link in page.get_links():
            if "page" in link:
                require(
                    0 <= link["page"] < len(pdf),
                    f"Broken internal link on page {number}.",
                )
        for font in page.get_fonts():
            require(pdf.extract_font(font[0])[3], f"Unembedded font on page {number}.")
    require(
        heading_pages == [entry[2] for entry in top_bookmarks[:10]],
        "Chapter bookmark destinations do not match their rendered headings.",
    )


def main() -> None:
    original = (ROOT / "provenance/original-2011.pdf").read_bytes()
    require(
        hashlib.sha256(original).hexdigest() == ORIGINAL_SHA256,
        "The archived original PDF has changed.",
    )
    recovered = read_json("provenance/recovered-lines.json")
    chapters = read_json("chapters.json")
    figures = read_json("figures.json")
    check_inventory(chapters, figures)
    checked = check_manuscript(chapters, recovered)

    with pymupdf.open(ROOT / "science-curiosity.pdf") as pdf:
        check_metadata(pdf)
        check_pages(pdf)
        page_count = len(pdf)
    print(
        f"Verified {checked:,} recovered characters in reading order, {page_count} pages, "
        "10 illustrations, embedded fonts, chapter bookmarks and PDF metadata."
    )
    print("Visual review is still required after changes to typography or layout.")


if __name__ == "__main__":
    main()
