# Makefile - build PDFs for the LaTeX documents in this repository.
#
# Each document lives in its own subdirectory with a main.tex entry
# point (paper/main.tex, thesis/main.tex). To add another document,
# append its directory name to DOCS below - no other changes are
# needed, as long as that directory has its own main.tex; everything
# else (make <name>, clean, distclean) works automatically via the
# pattern rules.

DOCS := paper thesis proposal executivesummary

LATEXMK := latexmk -xelatex -interaction=nonstopmode -halt-on-error

.PHONY: all clean distclean help $(DOCS)

all: $(DOCS)

help:
	@echo "Targets:"
	@echo "  make            build all documents ($(DOCS))"
	@echo "  make <name>     build one document, e.g. make paper"
	@echo "  make clean      remove build artifacts, keep PDFs"
	@echo "  make distclean  remove build artifacts and PDFs"
	@echo ""
	@echo "  make -B <name>  force a rebuild even if the PDF looks up to date"

# make paper -> paper/main.pdf, make thesis -> thesis/main.pdf, etc.
$(DOCS): %: %/main.pdf

%/main.pdf: %/main.tex
	$(LATEXMK) -cd $<

clean: $(patsubst %,clean-%,$(DOCS))

clean-%:
	$(LATEXMK) -c -cd $*/main.tex

distclean: $(patsubst %,distclean-%,$(DOCS))

distclean-%:
	$(LATEXMK) -C -cd $*/main.tex
