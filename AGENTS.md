# AGENTS.md

Typst source for the Marathi book *Science Curiosity*. Start with the
[README](README.md); it documents the toolchain, every `make` target and the
layout decisions.

## Before committing

- Deliver changes through a pull request, ready for review.
- Run `make check lint link-check`. Inspect rendered pages (`make render`)
  after typesetting or layout changes.
- Commit source changes together with the rebuilt `science-curiosity.pdf`.
- Never edit chapter prose in `chapters/*.typ` while refactoring; the
  manuscript must stay word-for-word.

## After pull requests merge

The website distributes the PDF, so refresh its copy once all pull requests
in a batch have merged:

1. Update local `main`: `git switch main && git pull --ff-only`.
2. Rebuild and copy the PDF: `make export-website`.
3. Check the website checkout with `git -C ../indrajeetpatil.github.io status`.
   If `public/pdfs/writing/science-curiosity.pdf` changed, deliver it through a
   website pull request that follows that repository's `AGENTS.md`. If the file
   is unchanged, there is nothing more to do.

`make export-website` resolves the website checkout as the sibling directory
`../indrajeetpatil.github.io` relative to this repository's root (the
`Makefile`'s directory), not the shell's current directory. Run it with
`make -C <path-to-this-repository> export-website` from elsewhere. Override
the location with `WEBSITE_DIR=/path/to/indrajeetpatil.github.io` only when
the website is checked out somewhere else.
