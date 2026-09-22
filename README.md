# thesis

LaTeX sources for a Universitas Sumatera Utara (USU) Program Studi S2
Sains Data dan Kecerdasan Buatan master's program: the thesis itself,
its proposal, a conference-style paper, and a one-page executive
summary form. Every document is built with XeLaTeX and follows the
same house style (A4, Times New Roman via the vendored Tinos fonts,
1.5 line spacing) implemented as a separate `.cls` file per document,
kept deliberately free of external LaTeX packages beyond what each
format genuinely needs.

## Requirements

- A TeX Live installation with `xelatex` and `latexmk` on `PATH`.
- `bibtex` (used by `thesis/` and `proposal/` for their bibliographies).

## Usage

Everything is driven by the root `Makefile`; run these from the repo
root:

```
make               # build every document (paper, thesis, proposal, executivesummary)
make thesis        # build one document -> thesis/main.pdf
make paper         # -> paper/main.pdf
make proposal      # -> proposal/main.pdf
make executivesummary  # -> executivesummary/main.pdf
make -B thesis     # force a rebuild even if the PDF looks up to date, change thesis to paper/proposal/executivesummary
make clean         # remove build artifacts (.aux, .log, ...), keep the PDFs
make distclean     # remove build artifacts AND the PDFs
make help          # print this list
```

Each target just runs `latexmk -xelatex -interaction=nonstopmode
-halt-on-error` inside that document's directory, so a document can
also be built directly without `make`:

```
cd {thesis/paper/proposal/executivesummary} && latexmk -xelatex -interaction=nonstopmode -halt-on-error main.tex
```

## Layout

Directories are documents; files at the repo root are shared
reference material that isn't itself a LaTeX document.

```
.
├── CLAUDE.md               project conventions for editing this repo (stack, formatting rules, GitLab workflow)
├── Makefile                the `make`/`make <doc>`/`make clean`/`make distclean` targets described above
├── thesis.md               "Panduan Format Tesis" -- the normative thesis-formatting spec thesis.cls implements
├── proposal.md             the normative proposal-formatting spec proposal.cls implements
├── pedoman_akademik.pdf    USU academic guideline reference (not a build input)
├── executive_summary_template.pdf   the official executive-summary form, used as a layout reference for executivesummary.cls
│
├── paper/                  a conference/journal-style paper (international format)
│   ├── intlpaper.cls           formatting/layout logic -- margins, fonts, section styles
│   ├── main.tex                the paper's actual content (title, authors, abstract, sections)
│   ├── references.bib          bibliography entries
│   ├── figures/                image assets referenced by main.tex
│   └── fonts/                  vendored Tinos TTFs (metric-compatible Times New Roman substitute) + NOTICE.md
│
├── proposal/                the thesis proposal ("Proposal Tesis")
│   ├── proposal.cls             formatting/layout logic
│   ├── main.tex                 thin orchestrator; \input's each bagian in order
│   ├── chapters/                one file per proposal.md "bagian" (pendahuluan, rumusan masalah, tujuan, batasan, metodologi)
│   └── figures/                 image assets
│
├── thesis/                  the thesis itself
│   ├── thesis.cls               formatting/layout logic (margins, fonts, chapter styles, page numbering)
│   ├── main.tex                  thin orchestrator; \input's every chapter/section file in order
│   ├── thesis.md                 build/layout notes for this directory (class vs. content split, apalike-usu.bst rationale)
│   ├── apalike-usu.bst            hand-patched bibliography style (author-year, USU field order) -- see thesis/thesis.md
│   ├── references.bib             bibliography entries
│   ├── frontmatter/               halaman judul through daftar istilah (pengesahan, pernyataan orisinalitas, abstrak, ...)
│   ├── chapters/                  Bab 1-5
│   ├── backmatter/                lampiran
│   └── figures/                   image assets (e.g. logo.svg/logo.png used on the cover)
│
└── executivesummary/        one-page "Executive Summary Proposal Penelitian Tesis" form
    ├── executivesummary.cls     formatting/layout logic (this is an `article`, not chaptered like the others)
    ├── main.tex                  the form's field values and six section answers, plus an example table/figure
    └── figures/                  image assets (e.g. contoh-gambar.png used by main.tex's example figure)
```

Within each document directory, `.cls` files hold formatting/layout
logic and `.tex` files hold content -- keep that split when editing:
change how something looks in the `.cls`, change what it says in the
`.tex`/`chapters`/`frontmatter`/`backmatter` files. See `CLAUDE.md`
for the full set of project conventions, and each document's own
`thesis.md`/`README.md`-equivalent notes (currently only
`thesis/thesis.md`) for details specific to that document.

## License

Licensed under the GNU General Public License v3.0 -- see
[LICENSE](LICENSE) for the full text.
