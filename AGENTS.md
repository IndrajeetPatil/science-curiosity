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

## Publishing

Merging to `main` publishes the committed PDF to GitHub Pages at
<https://www.indrapatil.com/science-curiosity/science-curiosity.pdf>, which the
website links to. No website change is needed when the book changes.
