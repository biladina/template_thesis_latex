# USU Thesis Proposal Template

## Building

From the repo root:

```
make proposal
```

or directly:

```
cd proposal
xelatex main.tex && bibtex main && xelatex main.tex && xelatex main.tex
```

## Layout

- `proposal.cls` -- formatting/layout logic. A sibling of
  `../thesis/thesis.cls`, not a subclass of it: it's built on `report`
  rather than `book`, since proposal.md's five bagian are one flat,
  continuously-numbered sequence with none of a full thesis's
  frontmatter/mainmatter/backmatter roman-vs-arabic split.
- `main.tex` -- thin orchestrator; sets the metadata fields (see
  below) and `\input`s every bagian file in order.
- `chapters/` -- one file per bagian (proposal.md's five sections:
  Pendahuluan dan Latar Belakang Masalah, Rumusan Masalah, Tujuan
  Penelitian, Ruang Lingkup Penelitian, Metodologi Penelitian).
- `figures/` -- the cover logo (`logo.png`), kept as a local copy
  rather than referenced from `../thesis/figures/` so the proposal
  doesn't depend on the thesis directory for its own cover image.
- No local `references.bib` or bibliography style -- those are still
  reused from `../thesis/` instead of duplicated (see "Shared assets"
  below).

## What's different from the thesis template

A proposal shares the same institutional formatting standard as the
thesis (thesis.md: A4, margins, Times New Roman via Tinos, 1.5 line
spacing, top-right page numbers, author-year citations), but two
things are deliberately copied from a different source than
thesis.md:

- **Bagian headings** follow `proposal.pdf`'s look, not thesis.md
  S1.4.3's "BAB n": each bagian is a bold, numbered ("1.", "2.", ...),
  Title Case heading flush with the left margin, and -- unlike a
  thesis chapter -- bagian do **not** force their own page break. They
  flow one after another on the same page whenever they fit, exactly
  like `proposal.pdf`'s "3. Batasan Masalah" / "4. Tujuan Penelitian"
  / "5. Manfaat Penelitian" sharing one page. Daftar Pustaka is the
  one exception: it keeps thesis.cls's centered/uppercase/unnumbered
  style on its own page, since it's conventionally a fresh standalone
  section even in an otherwise continuous document.
- **The cover** (Halaman Sampul + Halaman Judul, both bold except the
  "Diajukan..." sentence) is carried over from `thesis.cls`'s
  `\maketitle` mechanism, following this project's convention of
  deriving a sibling template's cover from the thesis template rather
  than maintaining a second, drifted copy -- but the proposal prints
  only **one** cover page, not two. A proposal isn't submitted for
  the degree itself, so there's no separate Halaman Judul purpose
  page; `\maketitle` here typesets the single Halaman Sampul look
  only.
- The cover page is **excluded from page numbering** (`\c@page` isn't
  advanced by it), matching this project's explicit choice that
  "cover kedua tidak diperlukan" and the cover shouldn't count toward
  the document's own numbering sequence.

## Metadata commands

Set these in `main.tex` before `\begin{document}`. All have sensible
placeholder defaults, so the template still compiles before any of
them are filled in.

| Command | Default | Used for |
| --- | --- | --- |
| `\title{...}`, `\author{...}` | (report.cls's own) | Title / author on the cover |
| `\nim{...}` | (empty) | Student ID on the cover |
| `\programStudi{...}` | `PROGRAM STUDI S2 TEKNIK INFORMATIKA` | Cover line (ALL CAPS) |
| `\fakultas{...}` | `FAKULTAS ILMU KOMPUTER DAN TEKNOLOGI INFORMASI` | Cover line (ALL CAPS) |
| `\universitas{...}` | `UNIVERSITAS SUMATERA UTARA` | Cover line (ALL CAPS) |
| `\kotaTerbit{...}` | `MEDAN` | Cover line |
| `\tahunTerbit{...}` | current year | Cover line |
| `\logoFakultas{path}` | placeholder box | Cover logo; falls back to the placeholder if the file doesn't exist |

There's no `\gelarMagister` here (unlike the thesis template) -- it
only exists to fill in the Halaman Judul purpose sentence, which the
proposal's single-page cover doesn't have.

### Content files must not write `\@foo` directly

Same gotcha as `../thesis/thesis.cls` (see `../thesis/thesis.md`):
`@` is only a letter while `proposal.cls` itself is being read, so a
content `.tex` file typing `\@title` literally does not reach the
title -- it silently lexes as `\@` followed by the text "title".
Content files should use the public accessors instead:
`\proposalTitle`, `\proposalAuthor`, `\proposalNim`,
`\proposalProgramStudi`, `\proposalFakultas`, `\proposalUniversitas`,
`\proposalKotaTerbit`, `\proposalTahunTerbit`.

## Shared assets

Rather than duplicating files that the thesis template already
provides, the proposal reuses some of them by relative path:

- Fonts: `../paper/fonts/` (same Tinos TTFs).
- Bibliography style: `../thesis/apalike-usu.bst` (loaded in
  `main.tex` as `\bibliographystyle{../thesis/apalike-usu}`).
- Bibliography data: `../thesis/references.bib` (a proposal cites a
  subset of the same literature the thesis will later use in full).

The cover logo (`figures/logo.png`) is the one exception -- it's a
local copy rather than a reference into `../thesis/figures/`, so the
proposal can stand alone without the thesis directory for its own
cover image.

If any of the still-shared paths above move, update the relative
paths in `main.tex` (and the `Path = ../paper/fonts/` font declaration
in `proposal.cls`) together -- there's no indirection layer between
them.

## Daftar Isi page numbering

Front matter here is small enough to be just the Daftar Isi itself:

- `\pagenumbering{roman}` starts the counter before
  `\tableofcontents`, so Daftar Isi is page "i".
- Its own entry is added to itself: `\phantomsection` +
  `\addcontentsline{toc}{chapter}{\contentsname}` run immediately
  before `\tableofcontents`, so Daftar Isi lists itself as its first
  line, using its own real anchor rather than pointing at whatever
  page/anchor happened to precede it. (`\addcontentsline` must come
  after `\pagenumbering{roman}`, so its captured page reads "i" and
  not whatever the cover left `\c@page` at.)
- `\pagenumbering{arabic}` resets the counter to 1 right after, so
  Bagian 1 starts fresh at page 1 -- matching this project's explicit
  requirement that arabic numbering only starts once Daftar Isi is
  done, not from the cover.
- The same `\clearpage` + `\phantomsection` + `\addcontentsline`
  sequence is repeated for Daftar Pustaka at the end, for the same
  reason: `\bibliography`'s own internal `\chapter*{\bibname}` is what
  actually breaks the page and creates hyperref's anchor, so the
  manual TOC entry has to force that break and a fresh anchor itself
  *before* being added, or it captures the wrong page/anchor.

## Known dead end: orphaned bagian headings

Since bagian no longer force their own page break, one can in
principle land stranded at the bottom of a page. Two automatic guards
against this were tried and reverted here (mirroring the exact same
investigation in `../thesis/thesis.cls`/`../thesis/thesis.md`) --
**don't reintroduce either**:

1. A `needspace`-based guard: its soft `\penalty -100` hint is only
   resolved once TeX sees enough *later* material to prove a break
   was needed, which left `\@sect`/`\@chapter`'s synchronous
   `\addcontentsline{toc}{...}` capturing `\thepage` before the page
   builder had caught up -- wrong Daftar Isi entries and PDF
   bookmarks.
2. An explicit `\ifdim\pagegoal-\pagetotal<...` check forcing an
   absolute `\newpage`: fixed the bookmark problem, but `\pagetotal`
   routinely overshoots `\pagegoal` as a normal transient artifact of
   TeX's lazy page-building, so reading that as "no room left" forced
   premature breaks, leaving the previous page mostly blank even
   though TeX's own algorithm would have filled it properly.

Plain `\@secpenalty` (the kernel's own bias toward breaking before a
heading rather than after it) is what bagian rely on now. If a
heading is ever genuinely orphaned in real content, fix it locally (a
manual `\clearpage` or a bit of rewording) rather than reaching for a
global mechanism again.
