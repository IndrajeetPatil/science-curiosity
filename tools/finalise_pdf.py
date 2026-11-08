# /// script
# requires-python = ">=3.15"
# dependencies = ["pymupdf==1.28.2"]
# ///
"""Complete the viewer metadata that Typst's PDF/A export does not set."""

import hashlib
import io
import sys
import uuid
import xml.etree.ElementTree as ET
from pathlib import Path

import pymupdf

XMP_MM = "http://ns.adobe.com/xap/1.0/mm/"
DC = "http://purl.org/dc/elements/1.1/"
RDF = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"


def parse_xmp(xml: str) -> ET.Element:
    """Parse XMP while keeping Typst's namespace prefixes when serialising."""
    for _, (prefix, uri) in ET.iterparse(io.StringIO(xml), events=("start-ns",)):
        ET.register_namespace(prefix, uri)
    return ET.fromstring(xml)


def set_subject(description: ET.Element, keywords: list[str]) -> None:
    subject = description.find(f"{{{DC}}}subject")
    if subject is None:
        subject = ET.SubElement(description, f"{{{DC}}}subject")
    else:
        subject.clear()
    bag = ET.SubElement(subject, f"{{{RDF}}}Bag")
    for keyword in keywords:
        ET.SubElement(bag, f"{{{RDF}}}li").text = keyword


def main() -> None:
    path = Path(sys.argv[1])
    with pymupdf.open(path) as pdf:
        root = parse_xmp(pdf.get_xml_metadata())
        instance = root.find(f".//{{{XMP_MM}}}InstanceID")
        document = root.find(f".//{{{XMP_MM}}}DocumentID")
        description = root.find(f".//{{{RDF}}}Description")
        if (
            instance is None
            or document is None
            or not document.text
            or description is None
        ):
            raise SystemExit("Expected Typst's XMP description and identifiers.")

        set_subject(description, pdf.metadata["keywords"].split(", "))

        # A deterministic ID keeps identical builds reproducible while identifying
        # this saved version separately from the unfinalised Typst output.
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        instance_id = uuid.uuid5(
            uuid.NAMESPACE_URL, f"urn:sha256:{digest}:display-title"
        )
        instance.text = f"uuid:{instance_id}"
        pdf.set_xml_metadata(
            '<?xpacket begin="\ufeff" id="W5M0MpCehiHzreSzNTczkc9d"?>'
            + ET.tostring(root, encoding="unicode")
            + '<?xpacket end="r"?>'
        )
        pdf.xref_set_key(pdf.pdf_catalog(), "ViewerPreferences/DisplayDocTitle", "true")

        # Typst uses the same string for XMP DocumentID and the first trailer ID.
        # Keep that logical ID and pair it with the saved-version UUID; saving
        # incrementally leaves the page objects untouched.
        document_id = pymupdf.get_pdf_str(document.text)
        pdf.xref_set_key(-1, "ID", f"[{document_id}<{instance_id.hex}>]")
        pdf.save(
            path,
            incremental=True,
            encryption=pymupdf.PDF_ENCRYPT_KEEP,
            no_new_id=True,
        )


if __name__ == "__main__":
    main()
