# Science Curiosity / विज्ञान कुतूहल

The private home of Indrajeet Patil's **विज्ञान कुतूहल (Science Curiosity)**:
ten Marathi popular-science articles originally published in *Loksatta* in 2011.
The September 2026 edition redesigns the book and adds captions and image
acknowledgements; it preserves the historical science and forecasts. Its reading
layout uses 12.5-point Marathi text, more space around paragraphs and captions,
quiet chapter openings, running chapter titles and a dedicated rights page.

This repository owns the editable manuscript, typesetting, fonts, illustrations,
source research, recovery records and the finished [PDF](science-curiosity.pdf).
The public website repository keeps only the distributed PDF and its website
presentation. There is no dependency on the website's Astro or Node.js toolchain.

## Technology stack

- **Typst 0.15.1** typesets the book and exports tagged PDF/A-2u. Unicode `.typ`
  files are the editable master; JSON holds chapter and illustration metadata.
- **Tiro Devanagari Marathi** supplies the body typography and **Mukta** the
  supporting headings. Both font files and their SIL OFL notices are included.
  Typst's own bundled fallback fonts cover remaining characters.
- **SVG** supplies the original cover drawing. The ten raster illustrations
  retain the quality of the source PDF.
- **Make** provides common operations; **Poppler** inspects and renders PDFs.
- **Python 3.14+**, **uv** and pinned **PyMuPDF 1.28.2** support the optional
  recovery and integrity checks. uv installs the script's declared dependency
  into its cache and selects a compatible Python interpreter, downloading one
  if needed. Both scripts declare `requires-python = ">=3.14"`; no Python
  environment is needed for normal typesetting.
- **rumdl**, **typos** and **lychee** check documentation, spelling and links.

## Edit and rebuild

Use **UTF-8 Typst (`.typ`) as the master format**. It keeps the recovered Marathi
text editable and reviewable alongside the book's precise typesetting rules.
DOCX would add a second layout engine and a binary master; Markdown would need
an additional conversion layer for this book's page design. Neither is required
to edit or reproduce this edition.

Install [Typst 0.15.1](https://github.com/typst/typst/releases/tag/v0.15.1).
The Makefile checks this exact version to keep the edition reproducible.
On macOS, the supporting tools can be installed with:

```sh
brew install poppler uv rumdl typos-cli lychee
```

The bundled fonts and images make compilation work offline. From this repository:

```sh
make build
```

The result is `science-curiosity.pdf`, which is tracked alongside its source.
Typst ignores system fonts and uses the included fonts and its bundled fallbacks.
The edition date is fixed in `layout.typ`; update it deliberately for a new edition.

| Command | Operation |
| --- | --- |
| `make help` | List common operations. |
| `make doctor` | Check the pinned Typst version. |
| `make build` or `make pdf` | Rebuild the distributable PDF. |
| `make watch` | Rebuild automatically when source files change. |
| `make render` | Render every page to `build/pages/` at 120 dpi. |
| `make inspect` | Display PDF metadata and embedded fonts. |
| `make check` | Rebuild and verify text preservation, assets, bookmarks and PDF structure. |
| `make lint` | Check Markdown and spelling. |
| `make link-check` | Check maintained links; preserved research snapshots are excluded. |
| `make recover` | Re-run the legacy-font decoder into `build/recovery/`. |
| `make export-website` | Rebuild and copy only the PDF into the sibling website checkout. |
| `make clean` | Remove generated previews and recovery output under `build/`. |

To use a website checkout elsewhere:

```sh
make export-website WEBSITE_DIR=/path/to/indrajeetpatil.github.io
```

Exporting only copies a file; it does not commit, push or deploy the website.
Before committing, run `make check lint link-check`. Inspect rendered pages after
typesetting changes, and commit the source changes together with the rebuilt PDF.

## Repository contents

- `chapters/*.typ`: the canonical Unicode Marathi manuscript, in reading order.
  `=` introduces a chapter and `==` introduces a section; blank lines separate
  paragraphs.
- `book.typ`: cover, edition note, contents and chapter order.
- `layout.typ`: typography, 160 × 240 mm pages, figures and the processor table.
- `rights.typ`: the Marathi copyright and reader-use notice.
- `credits.typ`: the three-page illustration acknowledgements and font credits.
- `figures.json`: captions, credits, source links, verification status and notes.
- `figures/`: the ten illustrations extracted without re-encoding, plus the new
  vector cover drawing.
- `fonts/`: Tiro Devanagari Marathi Regular and Mukta Medium, with their original
  SIL Open Font License notices (the introductory OFL link uses its current
  HTTPS address). The font files came from Google Fonts' Tiro
  Devanagari Marathi and Mukta directories on 10 September 2026.
- `chapters.json`: original PDF page ranges for comparison.
- `provenance/original-2011.pdf`: the original PDF, retained privately for recovery
  and comparison; it is not the edition distributed on the website.
- `provenance/recovered-lines.json`: decoded lines and original coordinates used
  for the text-preservation audit.
- `provenance/image-research/`: image comparisons, source metadata and the archived
  Cool Cosmos page. This includes rejected candidates; the authoritative result
  for each illustration is its status in `figures.json`.
- `tools/recover.py`: the book-specific legacy-font decoder. Its output is an
  intermediate transcript, not a replacement for the edited Unicode chapters.
- `tools/check.py`: manuscript and PDF integrity checks.

Build previews, scratch research and Python caches are ignored by Git. The
`clean` target leaves the tracked PDF, manuscript and provenance intact.

After changes, render the whole PDF and inspect every page, especially chapter
openings, the table, captions, and the contents links. PDF text extractors vary
in their handling of Devanagari ligatures and combining marks; use the Unicode
manuscript as the authoritative text for future editing.

## Text recovery and preservation

The only manuscript available was the 54-page Word 2007 PDF. Its **BRH
Devanagari Extra** font stores Marathi as legacy Latin-encoded glyphs. The text
was converted locally using the embedded glyph shapes and their character
positions, including visual-order short-i, reph and Marathi eyelash-ra forms.
No OCR service or external manuscript conversion service was used.

All article-body lines were checked against the recovered source: **60,784
non-whitespace characters**, excluding the separately verified processor table,
chapter titles, repeated author/email lines and old page numbers. The table's
seven data rows and five columns were checked against the original page 22.
All ten original illustrations were preserved. The cover, contents, edition
note, captions and acknowledgements are new.

The chapter titles follow the headings in the articles, which sometimes differ
slightly from the old contents page. Repeated bylines and the old contents page
were replaced by front matter. Existing Marathi spelling, wording and historical
scientific claims were retained. Two local transcription repairs are explicit:

1. Original page 24: `राyतो` became `राहतो`; the legacy `y` glyph was missing.
2. Original page 25: `टुरिंगन (Turing)े` became `टुरिंगने (Turing)`; a Marathi vowel
   sign stranded after the Latin parenthesis was moved back to its word.

Two parenthetical English terms were normalised to British spelling in this
edition: `civilisation` and `specialised`.

Original PDF SHA-256:
`edfc70f7d910edfcfb04cca61f2b62345047a6c7423e787f272998061ff4c79d`.
The superseded PDF is removed from the public site. The private copy in
`provenance/original-2011.pdf` is the recovery source.

## Image-source audit

The audit was performed on 10 September 2026. Matching a subject is insufficient:
credits were assigned only after comparing the actual image or reading a credit
printed on the retained image. Full evidence and URLs are in `figures.json` and
the PDF's acknowledgements.

| Figure | Image | Result |
| --- | --- | --- |
| 1 | Dog and mirror | Exact photograph: Georgia Pinaud, *NICO looks at himself*, Wikimedia Commons; public domain. |
| 2 | Buckyballs | Exact NASA/JPL-Caltech artwork, PIA13551, *Extragalactic Space Balls*; cropped in the old book. |
| 3 | Antibodies | Science Aid credit printed on the image; independent source and licence not established. |
| 4 | Electronic circuit | Photographer, original source and licence unresolved. |
| 5 | Turing test | Exact *Turing Test version 3* by Bilby; public domain. |
| 6 | Brain scans | Creator, original study and licence unresolved. |
| 7 | Water-screw machine | Exact Böckler engraving, Wikimedia Commons; public domain. |
| 8 | Thermal comparison | Dog thermogram and lizard component matched to NASA/IPAC's Cool Cosmos collection; original composite retained. |
| 9 | Cloaking simulation | Exact creator, source and licence unresolved; similar simulations rejected. |
| 10 | Salamanders | Exact photographer, study and licence unresolved; related images rejected. |

Searches covered Wikimedia Commons, NASA's image records, institutional pages,
and archived Cool Cosmos material. Google, DuckDuckGo, Brave and TinEye presented
access challenges; Bing visual search returned a processing error. These limits
are recorded here rather than assigning speculative attributions. Credits do
not establish a blanket reuse licence for the book or its unresolved images.

## Rights

This is a private authoring repository, not an open-source licence grant for the
book. The PDF reserves the author's rights in the original articles, credits
their first publication in *Loksatta*, and identifies this as an independent
author's collection. It offers a free personal reading copy and asks readers to
share the official link. Except where law or an applicable licence permits the
use, republication, redistribution, translation and commercial reuse require
prior written permission from the relevant rights holders.

This notice does not restrict public-domain material, override third-party
licences, or establish permission for unresolved illustrations. Font licences
are in `fonts/`; illustration rights and unresolved sources are recorded
individually in `figures.json`. The public reading copy is available on
[Indrajeet Patil's writing page](https://www.indrapatil.com/writing/).

[Rights research](provenance/rights-research.md) records the official Indian
copyright guidance and the archived Loksatta website terms consulted on
10 September 2026. Website-use terms do not establish the terms of the author's
2011 freelance contributions. No publisher clearance is claimed.

## Layout decisions

Typst optimises paragraph line breaks for both body text and ragged captions.
The Marathi text retains normal shaping and ligatures, without letter spacing
or character-level justification. Typst's default widow and orphan prevention
remains enabled. Subheadings use the built-in heading block with explicit
spacing and stickiness, so a heading stays with the following text.

Figures retain their captions as a unit, with additional clearance from the
body. The processor table uses larger text, padded rows and subtle alternating
fills. Figure size and placement are adjusted where needed to avoid stranded
headings or very short final pages. The cover has independent spacing so body
typography changes cannot push its author line onto another page.
