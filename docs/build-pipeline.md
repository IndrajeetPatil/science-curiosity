# Build pipeline

The repository owns the editable Marathi manuscript, its book assets, and the
finished PDF. GitHub Pages publishes the PDF, and the author's website links
to it.

The labelled [build-pipeline illustration](../figures/book-build-pipeline.webp)
and its [generation prompt](../figures/book-build-pipeline.prompt.txt) are kept
together in `figures/`.

## From source to PDF

1. The author edits the UTF-8 Typst files in `chapters/`, along with the book
   structure in `book.typ` and design rules in `layout.typ`.
2. `make build` checks for Typst 0.15.1 and invokes Typst with the included
   fonts and the PDF/A-2u output profile. Typst lays out the text, figures,
   captions, and front matter, then writes `science-curiosity.pdf`.
3. `tools/finalise_pdf.py` uses PyMuPDF to complete viewer metadata that Typst
   does not write. It adds the XMP keyword bag, enables the document-title
   viewer preference and writes a deterministic saved-version identifier while
   preserving the logical document identifier.
4. The final PDF is committed alongside the source. Identical source builds
   produce identical files.

Typst embeds the title, author, description, language, and edition date declared
in `layout.typ` in the PDF Info dictionary and XMP. The PDF conforms to PDF/A-2u;
the build does not claim PDF/UA certification.

## Publishing

The `Build and publish PDF` workflow runs on every pull request, where `build`
is a required check, and on pushes to `main` that touch the book. It rebuilds
the PDF, runs `make check`, and fails if the committed PDF differs from the
rebuilt one.

On `main`, it then deploys a Pages site that holds the committed PDF, a
`site/index.html` redirect to it, and the `site/social-card.png` link-preview
image. The redirect page's Open Graph tags point to that image, so shared links
to the site show the card. The book's Pages site sits under the author's
custom domain:

| Address | Serves |
| --- | --- |
| <https://www.indrapatil.com/science-curiosity/science-curiosity.pdf> | The PDF |
| <https://www.indrapatil.com/science-curiosity/> | A redirect to the PDF |
| <https://www.indrapatil.com/science-curiosity/social-card.png> | The 1280 × 640 social preview card |

The author's website links to the PDF address, so book changes need no website
change.

Run `make social-card` after changing `social-card.typ` or the cover styling
it shares, and commit the regenerated PNG. The same image serves as the
repository's GitHub social preview, which is uploaded in the repository
settings.

Use `make help` for the current command list. `make watch` is for Typst previews;
run `make build` to produce the final PDF with its metadata.
