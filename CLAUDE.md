# Project: thesis

## Stack
- latex, xelatex
- bash

## Conventions
- Use camelCase for variables
- latex output in PDF format
- create pure latex as possible with less plugin or any external sources
- if font still needed, download the font ttf file and add it to project
- separate between class file (template) and tex file (actual latex)
- reuse class file (template) is preferred
- paper size use global standard A4, not american standard
- do not take template from git untracked files

## GitLab
- Main branch: master
- Always push to feature branches, not master directly

## Thesis template (thesis/)
`thesis/thesis.cls` + `thesis/main.tex` implement the Universitas
Sumatera Utara (USU) Program Studi S2 Teknik Informatika master's
thesis format defined in `thesis.md` (the "Panduan Format Tesis",
kept at the repo root as the detailed normative source). Every rule
below cites the thesis.md section that requires it; treat thesis.md
as the source of truth and this list as the quick-reference merge of
it with this file's own conventions (A4, xelatex, pure-LaTeX, class
vs. content separation, reused fonts):

- A4 paper (thesis.md S1.1.1).
- Body margins 30mm top / 25mm bottom / 38mm left / 25mm right
  (S2.2); chapter-opening pages (`\chapter{...}`, i.e. Bab 1-N) get a
  50mm top margin instead (S2.1); the cover page (`\maketitle`) gets
  60mm top/bottom (S1.2.1).
- Times New Roman 12pt body text via the Tinos TTFs already vendored
  in `paper/fonts/` (S1.4.1); the cover page is 14pt uppercase
  (S1.2.7).
- 1.5 line spacing throughout, 1 spacing for table/bibliography
  entries via `\singlespaced{...}` (S1.4.2, S2.4... see S3.14).
- Chapters print as "BAB <n>" + centered bold uppercase title
  (S1.4.3); sub-bab level 1 (`\section`) is bold, numbered, Title
  Case, flush left (S1.4.4); sub-bab level 2 (`\subsection`) is
  italic, numbered, sentence case, flush left (S1.4.5) — this is the
  deepest level thesis.md recommends.
- First paragraph after any heading is flush (no indent); later
  paragraphs indent 6 characters (S1.4.6).
- Front matter (halaman judul through daftar istilah) uses roman
  page numbers; main matter (Bab 1-5) uses arabic starting at 1; back
  matter (daftar pustaka, lampiran) continues arabic (S2.4.2,
  S3.1.1-3.1.3) — these map onto book.cls's `\frontmatter` /
  `\mainmatter` / `\backmatter`, already wired up in `main.tex`.
- Page numbers sit top-right, ~15mm from the top edge and flush with
  the 25mm right margin (S2.4.4), but are hidden (while still
  counted) on the title page and on the first page of every
  chapter/section (S2.4.3, S2.4.5).
- Document order: halaman judul, pengesahan, pernyataan orisinalitas,
  persetujuan publikasi, panitia penguji, riwayat hidup, ucapan
  terima kasih, abstrak, abstract, daftar isi, daftar tabel, daftar
  gambar, daftar istilah, Bab 1-5, daftar pustaka, lampiran (S3.2) —
  already the order used in `main.tex`.
- Daftar Pustaka uses the "Sistem Pengarang-Tahun" (author-year)
  citation system (S4.1.1): entries are sorted alphabetically by
  author's last name, not by citation order; two authors are joined
  with "&" (not "and"); book/journal titles are italic; a journal
  article's volume number is bold (S4.4); the year is the field right
  after the author (S4.1-4.9's field order, e.g. book: "Author, A.
  Year. *Title*. Publisher: Place."). This needed `natbib`
  (`[authoryear,round]`) plus a locally patched BibTeX style,
  `thesis/apalike-usu.bst` (based on `plainnat.bst`, since the
  stock `apalike.bst` has the right field order but isn't
  natbib-compatible) — the one deliberate exception to "less plugin,
  pure LaTeX" here, because hand-rolling author-year sorting/labels
  without BibTeX is impractical. Cite with `\citet{key}` when the
  author reads as the sentence's subject ("Smith (2020) found...")
  and `\citep{key}` for a parenthetical citation
  ("...as shown previously (Smith, 2020)"). Author names in
  `references.bib` should be entered `Lastname, Firstname` per
  S4.1.2's name-formatting rules (e.g. Indonesian names of two
  syllables collapse to one initial: "Rila Mandala" -> "Mandala, R.").
- When editing the thesis, put formatting/layout logic in
  `thesis.cls`, per this file's "separate class file from tex file"
  convention. Actual content lives one chapter per file under
  `frontmatter/`, `chapters/`, and `backmatter/`; `main.tex` only
  `\input`s them in order and should stay a thin orchestrator.

## Proposal template (proposal/)
`proposal/proposal.cls` + `proposal/main.tex` implement the thesis
*proposal* (Proposal Tesis) for the same USU program, using
`proposal.md` as the source for which content sections ("bagian") a
proposal needs, and a filled-in example proposal kept at the repo
root as `proposal.pdf` as the layout reference for how those bagian
should look. It shares thesis.md's general manuscript rules (same
institution, same standard: A4, margins, Tinos/Times New Roman, 1.5
spacing, top-right page numbers, author-year citations) but departs
from thesis.md S1.4.3's "BAB n" chapter style for its bagian headings
specifically, following proposal.pdf's look instead (see below). It's
a sibling of `thesis.cls`, not a subclass of it — reimplemented
rather than loaded from `thesis/thesis.cls`, because a proposal's
structure is simpler (`report`, not `book`: proposal.md's five bagian
are one flat, continuously-numbered sequence, with none of thesis.md
S3.1's frontmatter/mainmatter/backmatter roman-vs-arabic split),
matching how `paper/intlpaper.cls` and `thesis/thesis.cls` are
already each self-contained rather than sharing a base class.

- proposal.md's five bagian (Pendahuluan dan latar belakang masalah,
  Rumusan masalah, Tujuan penelitian, Ruang lingkup penelitian,
  Metodologi penelitian) are five numbered `\chapter`s, one per file
  under `chapters/`, `\input`ed in order by `main.tex`.
- Bagian headings follow proposal.pdf's look, not thesis.md's: bold,
  numbered "`<n>. Title`" in Title Case, flush left, and — unlike
  thesis.cls's chapters — NOT forced onto their own page. proposal.pdf's
  numbered bagian flow one after another on the same page whenever
  they fit (e.g. its "3. Batasan Masalah" / "4. Tujuan Penelitian" /
  "5. Manfaat Penelitian" share one page), so `\chapter`'s automatic
  page break is disabled for numbered bagian in `proposal.cls`.
  Daftar Pustaka is the one exception, kept on its own page with
  thesis.cls's centered/uppercase/unnumbered style, since it's
  conventionally a fresh standalone section even in an otherwise
  continuous document.
- The cover (Halaman Sampul + Halaman Judul, both bold except the
  "Diajukan..." sentence) is carried over from `thesis.cls`'s
  `\maketitle` mechanism rather than kept as a separately-maintained
  copy, printing "PROPOSAL TESIS" instead of "TESIS" and adjusting the
  purpose line, since a proposal isn't submitted for the degree
  itself.
- Genuinely shared assets are reused via relative path instead of
  duplicated: fonts from `../paper/fonts/`, the bibliography style from
  `../thesis/apalike-usu.bst`, and the bibliography data from
  `../thesis/references.bib` (a proposal cites a subset of the same
  literature the thesis will later use in full). The cover logo is the
  one exception: it's a local copy at `proposal/figures/logo.png`
  rather than a reference into `../thesis/figures/`, so the proposal
  can stand alone without the thesis directory for its own cover
  image.