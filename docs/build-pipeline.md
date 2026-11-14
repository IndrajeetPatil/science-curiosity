# Build pipeline

The repository owns the editable Marathi manuscript, its book assets and the
finished PDF. The website repository receives a copy of the final PDF and owns
its web presentation and deployment.

The labelled [build-pipeline illustration](../figures/book-build-pipeline.webp)
and its [generation prompt](../figures/book-build-pipeline.prompt.txt) are kept
together in `figures/`.

## From source to PDF

1. The author edits the UTF-8 Typst files in `chapters/`, along with the book
   structure in `book.typ` and design rules in `layout.typ`.
2. `make build` checks for Typst 0.15.1 and invokes Typst with the included
   fonts and the PDF/A-2u output profile. Typst lays out the text, figures,
   captions and front matter, then writes `science-curiosity.pdf`.
3. `tools/finalise_pdf.py` uses PyMuPDF to complete viewer metadata that Typst
   does not write. It adds the XMP keyword bag, enables the document-title
   viewer preference and writes a deterministic saved-version identifier while
   preserving the logical document identifier.
4. The final PDF is committed alongside the source. Identical source builds
   produce identical files.

Typst embeds the title, author, description, language and edition date declared
in `layout.typ` in the PDF Info dictionary and XMP. PDF/A-2u is retained; the
build does not claim PDF/UA certification.

## Distribution

`make export-website WEBSITE_DIR=<website checkout>` rebuilds and copies only
`science-curiosity.pdf` into the website checkout's
`public/pdfs/writing/` directory. Exporting
does not commit, push or deploy the website; the website change has its own
review and release process.

Use `make help` for the current command list. `make watch` is for Typst previews;
run `make build` or `make export-website` to produce the final PDF with its
metadata.
