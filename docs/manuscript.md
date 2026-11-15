# Manuscript

The ten chapters in `chapters/` are the canonical Unicode Marathi text of the
book. Each article keeps its published wording, spelling, and historical
scientific claims. Chapter titles follow the article headings. The
parenthetical English terms `civilisation` and `specialised` use British
spelling.

The cover, contents, copyright notice, captions, and image acknowledgements
frame the articles. `chapters.json` lists the chapter files in reading order.

## Text check

`make check` removes whitespace from the chapter text and compares its SHA-256
with `CHAPTER_TEXT_SHA256` in `tools/check.py`. Layout and refactoring changes
must leave the fingerprint unchanged. A deliberate wording change updates the
fingerprint in the same commit.
