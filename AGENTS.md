# AGENTS.md

Typst source for the Marathi book *Science Curiosity*. Start with the
[README](README.md) for the book, toolchain, and build architecture. Run
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

## Pull requests

Follow these rules without relying on any instructions outside this
repository:

- Write every commit message and PR title as a Conventional Commit,
  `type(scope): description`, lowercase and imperative, with an allowed type
  (`build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`,
  `revert`, `style`, `test`). Keep the PR title and body in sync with the
  net diff.

- Open every PR ready for review with `gh pr create`, never as a draft.

- Never add agent or tool attribution to commits, PRs, or comments.

- After opening or pushing, wait for hosted CI to finish. Inspect failed jobs,
  fix the cause, run the local checks (`make check lint link-check`), push,
  and repeat. Skipped, queued, or failing required checks are not success.

- If an automatic AI review (Codex, for the owner) runs on the PR, wait for
  its result instead of requesting one. Fix merited findings, reply to and
  resolve addressed threads, and continue until the review approves the
  current head with no unresolved findings. Never write `@codex` anywhere in
  a PR, even in backticks: it cancels the automatic review. Say "a Codex
  review request" instead.

- If Codex reports exhausted usage, leave the PR open and report it; no other
  reviewer or silence counts as approval. Once usage refreshes, comment
  `@codex review` once; only this case needs the comment.

- Once CI is green and the review gate is met, squash-merge, then verify the
  merged state. Recheck the head, threads, and checks immediately before
  merging, and never bypass branch protections.

- Update a PR branch from `main` only to resolve conflicts or pick up a change
  the PR depends on, never just to bring it up to date.

- Report local validation, hosted CI, review, and merge state separately. If
  an external blocker stops completion, leave the PR open and say so.
