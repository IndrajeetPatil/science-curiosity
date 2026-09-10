.DEFAULT_GOAL := help

TYPST_VERSION := 0.15.1
PDF := science-curiosity.pdf
TYPST_FLAGS := --ignore-system-fonts --font-path fonts --pdf-standard a-2u
WEBSITE_DIR ?= ../indrajeetpatil.github.io

help: ## List common operations
	@awk 'BEGIN {FS = ":.*## "} /^[a-z-]+:.*## / {printf "  %-18s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

doctor: ## Check the pinned Typst version
	@command -v typst >/dev/null || { echo "Install Typst $(TYPST_VERSION); see README.md."; exit 1; }
	@test "$$(typst --version | awk '{print $$2}')" = "$(TYPST_VERSION)" || { echo "Expected Typst $(TYPST_VERSION)."; exit 1; }

build: doctor ## Typeset the distributable PDF
	typst compile $(TYPST_FLAGS) book.typ $(PDF)

pdf: build ## Alias for build

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
	rumdl check README.md provenance/rights-research.md
	typos .

link-check: ## Check maintained documentation and source links
	lychee --include-verbatim README.md figures.json book.typ rights.typ fonts/*.txt

recover: ## Decode the original PDF into build/recovery
	uv run --script tools/recover.py

export-website: build ## Copy only the PDF to the website checkout
	@test -d "$(WEBSITE_DIR)/public/pdfs/writing" || { echo "Set WEBSITE_DIR to the website checkout."; exit 1; }
	cp $(PDF) "$(WEBSITE_DIR)/public/pdfs/writing/$(PDF)"

clean: ## Remove generated previews and recovery output
	rm -rf build

.PHONY: help doctor build pdf watch render inspect check lint link-check recover export-website clean
