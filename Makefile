###############################################################################
# Makefile — Book Archive Project
###############################################################################

# ─────────────────────────────── 変数 ───────────────────────────────
# URL設定
BASE_URL       ?= https://www.u.tsukuba.ac.jp/~s2513929/
CGI_BASE_URL   ?= https://cgi.u.tsukuba.ac.jp/~s2513929/

XSLTPROC       := xsltproc --stringparam base_url "$(BASE_URL)" --stringparam cgi_base_url "$(CGI_BASE_URL)"
XML_SRC        := ./data0421.xml
XSLT_BASE_DIR  := ./src/xslt
XSLT_PAGE_DIR  := $(XSLT_BASE_DIR)/page
XSLT_SCRIPT_DIR:= $(XSLT_BASE_DIR)/script
WWW_DIR        := ./www
CSS_SRC_DIR    := ./src/css
CSS_DEST_DIR   := $(WWW_DIR)/css

# XPath の book を item に修正
TOTAL_BOOKS_NUM    := $(shell xmllint --xpath "count(//item)" $(XML_SRC))
BOOKS_PER_PAGE_NUM := 50
PAGES              := $(shell seq 1 $$(( ($(TOTAL_BOOKS_NUM) + $(BOOKS_PER_PAGE_NUM) - 1) / $(BOOKS_PER_PAGE_NUM) )))


# ──────────────────────── 生成されるファイル一覧 ───────────────────────
MAIN_HTML          := $(WWW_DIR)/index.html

BOOKS_INDEX        := $(WWW_DIR)/books/index.html
BOOK_PAGES         := $(patsubst %,$(WWW_DIR)/books/page_%.html,$(PAGES))
BOOK_DETAIL_PAGES  := \
	$(patsubst %,$(WWW_DIR)/books/detail_%.html,\
		$(shell xmllint --xpath "//item/isbn/text()" $(XML_SRC) \
			| tr ' ' '\n' | sort -u | tr '\n' ' '))

AUTHORS_INDEX      := $(WWW_DIR)/authors/index.html
AUTHOR_HASHES_XML  := $(WWW_DIR)/authors/hashes.xml
AUTHORS_DONE       := $(WWW_DIR)/authors/.generated   # sentinel

CSS_FILES          := $(wildcard $(CSS_SRC_DIR)/*.css)
COPIED_CSS_FILES   := $(patsubst $(CSS_SRC_DIR)/%,$(CSS_DEST_DIR)/%,$(CSS_FILES))

# ───────────────────────────── 便利ターゲット ────────────────────────────
.PHONY: all clean setup

all: setup $(COPIED_CSS_FILES) $(MAIN_HTML) $(BOOKS_INDEX) $(BOOK_PAGES) $(BOOK_DETAIL_PAGES) \
     $(AUTHOR_HASHES_XML) $(AUTHORS_INDEX) $(AUTHORS_DONE)
	@echo "✅ Build complete. All files are up to date in '$(WWW_DIR)'."

clean:
	@echo "🧹 Cleaning up generated files..."
	@rm -rf $(WWW_DIR)

setup:
	@echo "🛠 Setting up directories..."
	@mkdir -p $(WWW_DIR) $(WWW_DIR)/books $(WWW_DIR)/authors $(CSS_DEST_DIR)

# ───────────────────────────── CSS コピー ──────────────────────────────
# CSSコピーのルールを修正
$(CSS_DEST_DIR)/%.css: $(CSS_SRC_DIR)/%.css setup
	@echo "🎨 Copying CSS: $< → $@"
	@cp $< $@

# ──────────────────────── HTML 生成（メイン & Books） ───────────────────────
$(MAIN_HTML): $(XML_SRC) $(XSLT_PAGE_DIR)/index.xsl setup
	@echo "🏠 Generating main index: $@"
	@$(XSLTPROC) $(XSLT_PAGE_DIR)/index.xsl $< > $@

$(BOOKS_INDEX): $(XML_SRC) $(XSLT_PAGE_DIR)/books.xsl $(AUTHOR_HASHES_XML) setup
	@echo "📖 Generating books index: $@"
	@$(XSLTPROC) --stringparam page 1 --stringparam hashes_xml_path "file://$(shell pwd)/$(AUTHOR_HASHES_XML)" $(XSLT_PAGE_DIR)/books.xsl $< > $@

$(WWW_DIR)/books/page_%.html: $(XML_SRC) $(XSLT_PAGE_DIR)/books.xsl $(AUTHOR_HASHES_XML) setup
	@echo "📄 Generating book page: $@"
	@$(XSLTPROC) --stringparam page $* --stringparam hashes_xml_path "file://$(shell pwd)/$(AUTHOR_HASHES_XML)" $(XSLT_PAGE_DIR)/books.xsl $< > $@

$(WWW_DIR)/books/detail_%.html: $(XML_SRC) $(XSLT_PAGE_DIR)/book_detail.xsl $(AUTHOR_HASHES_XML) setup
	@echo "📗 Generating book detail page: $@"
	@$(XSLTPROC) --stringparam isbn_param $* --stringparam hashes_xml_path "file://$(shell pwd)/$(AUTHOR_HASHES_XML)" $(XSLT_PAGE_DIR)/book_detail.xsl $< > $@

# ───────────────────────────── Authors ────────────────────────────────
$(AUTHORS_INDEX): $(XML_SRC) $(XSLT_PAGE_DIR)/authors.xsl $(AUTHOR_HASHES_XML) setup
	@echo "👥 Generating authors index: $@"
	@$(XSLTPROC) --stringparam hashes_xml_path "file://$(shell pwd)/$(AUTHOR_HASHES_XML)" \
	            $(XSLT_PAGE_DIR)/authors.xsl $(XML_SRC) > $@

$(AUTHOR_HASHES_XML): $(XML_SRC) $(XSLT_SCRIPT_DIR)/author_vs_hash.xsl src/script/generator_creator_hash.rb src/script/generate_author_hashes.sh setup
	@echo "🔗 Generating author hash map..."
	@./src/script/generate_author_hashes.sh "$(XML_SRC)" "$(XSLT_BASE_DIR)" "./src/script/generator_creator_hash.rb" "$@"

$(AUTHORS_DONE): $(XML_SRC) $(XSLT_SCRIPT_DIR)/author_vs_hash.xsl $(XSLT_PAGE_DIR)/author_detail.xsl src/script/generator_creator_hash.rb src/script/generate_author_pages.sh setup
	@echo "👤 Generating individual author pages..."
	@./src/script/generate_author_pages.sh "$(XML_SRC)" "$(XSLT_BASE_DIR)" "./src/script/generator_creator_hash.rb" "$(WWW_DIR)" "$(BASE_URL)"
	@touch $@   # sentinel
