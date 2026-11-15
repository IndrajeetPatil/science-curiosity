# /// script
# requires-python = ">=3.15"
# dependencies = ["pymupdf==1.28.2"]
# ///
"""Check the manuscript text and the rendered PDF."""

import hashlib
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Any

import pymupdf

ROOT = Path(__file__).resolve().parents[1]
# SHA-256 of the chapter text with whitespace removed. Update it only for
# deliberate wording changes; refactoring must leave it unchanged.
CHAPTER_TEXT_SHA256 = "b7bc53d8033f0877f72806ee1ff1894d019038a7c23a3507ce61f0152670182d"
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


def read_json(path: str) -> Any:
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


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


def check_manuscript(chapters: list[dict]) -> int:
    """Check the chapter wording is unchanged; return its non-whitespace length."""
    text = "".join(
        re.sub(r"\s+", "", (ROOT / "chapters" / chapter["file"]).read_text("utf-8"))
        for chapter in chapters
    )
    require(
        hashlib.sha256(text.encode()).hexdigest() == CHAPTER_TEXT_SHA256,
        "Chapter wording has changed. Update CHAPTER_TEXT_SHA256 only if intended.",
    )
    return len(text)


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
    catalogue = pdf.pdf_catalog()
    require(
        pdf.xref_get_key(catalogue, "Lang") == ("string", "mr")
        and xmp.findtext(".//dc:language/rdf:Bag/rdf:li", namespaces=XMP_NAMESPACES)
        == "mr",
        "Expected Marathi language in the PDF catalogue and XMP.",
    )
    require(
        pdf.xref_get_key(catalogue, "ViewerPreferences/DisplayDocTitle")
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
    openings = {entry[2] for entry in top_bookmarks[:10]}
    heading_pages = []
    for number, page in enumerate(pdf, start=1):
        text = page.get_text()
        # A blank left-hand page may precede a chapter opening.
        require(
            len(text.strip()) > 20 or (number % 2 == 0 and number + 1 in openings),
            f"Unexpected blank page {number}.",
        )
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
    require(
        all(number % 2 == 1 for number in heading_pages),
        "Every chapter must open on a right-hand (odd) page.",
    )


def main() -> None:
    chapters = read_json("chapters.json")
    figures = read_json("figures.json")
    check_inventory(chapters, figures)
    checked = check_manuscript(chapters)

    with pymupdf.open(ROOT / "science-curiosity.pdf") as pdf:
        check_metadata(pdf)
        check_pages(pdf)
        page_count = len(pdf)
    print(
        f"Verified {checked:,} manuscript characters, {page_count} pages, "
        "10 illustrations, embedded fonts, chapter bookmarks and PDF metadata."
    )
    print("Visual review is still required after changes to typography or layout.")


if __name__ == "__main__":
    main()
