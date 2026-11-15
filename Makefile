.DEFAULT_GOAL := help

TYPST_VERSION := 0.15.1
PDF := science-curiosity.pdf
TYPST_FLAGS_BASE := --ignore-system-fonts --font-path fonts
TYPST_FLAGS := $(TYPST_FLAGS_BASE) --pdf-standard a-2u

help: ## List common operations
	@awk 'BEGIN {FS = ":.*## "} /^[a-z-]+:.*## / {printf "  %-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

doctor: ## Check the pinned Typst version
	@command -v typst >/dev/null || { echo "Install Typst $(TYPST_VERSION); see README.md."; exit 1; }
	@test "$$(typst --version | awk '{print $$2}')" = "$(TYPST_VERSION)" || { echo "Expected Typst $(TYPST_VERSION)."; exit 1; }

build: doctor ## Typeset the distributable PDF
	typst compile $(TYPST_FLAGS) book.typ $(PDF)
	uv run --script tools/finalise_pdf.py $(PDF)

pdf: build ## Alias for build

social-card: doctor ## Render the 1280 × 640 social preview card
	typst compile $(TYPST_FLAGS_BASE) --ppi 144 social-card.typ site/social-card.png

watch: doctor ## Rebuild automatically while editing
	typst watch $(TYPST_FLAGS) book.typ $(PDF)

render: build ## Render every page to build/pages at 120 dpi
	@command -v pdftoppm >/dev/null || { echo "Install Poppler; see README.md."; exit 1; }
	@mkdir -p build/pages
	@rm -f build/pages/page-*.png
	pdftoppm -r 120 -png $(PDF) build/pages/page

inspect: build ## Display PDF metadata and embedded fonts
	pdfinfo $(PDF)
	pdffonts $(PDF)

check: build ## Check manuscript preservation and PDF integrity
	uv run --script tools/check.py

lint: ## Check Markdown and spelling
	rumdl check AGENTS.md README.md docs/*.md
	typos .

link-check: ## Check maintained documentation and source links
	lychee --include-verbatim --cache=false .

clean: ## Remove generated previews
	rm -rf build

.PHONY: help doctor build pdf social-card watch render inspect check lint link-check clean
