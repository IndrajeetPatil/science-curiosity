# AGENTS.md

Typst source for the Marathi book *Science Curiosity*. Start with the
[README](README.md) for the book, toolchain and build architecture. Run
`make help` for the available commands.

## Before committing

- Run `make check lint link-check`. Inspect rendered pages (`make render`)
  after typesetting or layout changes.
- Commit source changes together with the rebuilt `science-curiosity.pdf`.
- Never edit chapter prose in `chapters/*.typ` while refactoring; the
  manuscript must stay word-for-word.

## After pull requests merge

The website distributes the PDF. Once every pull request in a batch has merged,
update local `main` and run `make export-website WEBSITE_DIR=<website
checkout>`, which copies the PDF into that checkout. If
`public/pdfs/writing/science-curiosity.pdf` changed there, deliver it through a
website pull request that follows that repository's `AGENTS.md`.
