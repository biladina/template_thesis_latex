# USU Master's Thesis Template

## Building

From the repo root:

```
make thesis
```

or directly:

```
cd thesis
latexmk -xelatex -interaction=nonstopmode -halt-on-error main.tex
```

## Layout

- `thesis.cls` -- formatting/layout logic (margins, fonts, cover,
  chapter styles, page numbering, the reusable helpers listed below).
  Edit this for anything about how the document looks, not what it
  says.
- `main.tex` -- thin orchestrator; sets the metadata fields (see
  below) and `\input`s every chapter file in order.
- `frontmatter/`, `chapters/`, `backmatter/` -- one file per
  chapter/section. Edit these for content.
- `figures/` -- image assets (e.g. `logo.svg`/`logo.png`, the USU
  faculty logo used on the cover via `\logoFakultas`).
- `references.bib` -- bibliography entries.
- `apalike-usu.bst` -- the bibliography style (see below).

## Cover (Halaman Sampul + Halaman Judul)

`\maketitle` renders **two** pages, not one: the outer Halaman Sampul
and the inner Halaman Judul (thesis.md S3.2/S3.3), sharing every
field. The only difference between them is the Halaman Judul's
"Diajukan untuk melengkapi tugas..." purpose sentence. Every other
line on both pages is bold; that sentence alone is not.

## Metadata commands

Set these in `main.tex` before `\begin{document}`. All have sensible
placeholder defaults, so the template still compiles before any of
them are filled in.

**Cover / title page** (`\title`, `\author` are book.cls's own):

| Command | Default | Used for |
| --- | --- | --- |
| `\nim{...}` | (empty) | Student ID on the cover |
| `\programStudi{...}` | `Sains Data dan Kecerdasan Buatan` | Cover line (ALL CAPS) |
| `\fakultas{...}` | `FAKULTAS ILMU KOMPUTER DAN TEKNOLOGI INFORMASI` | Cover line (ALL CAPS) |
| `\universitas{...}` | `UNIVERSITAS SUMATERA UTARA` | Cover line (ALL CAPS) |
| `\kotaTerbit{...}` | `MEDAN` | Cover line |
| `\tahunTerbit{...}` | current year | Cover line |
| `\logoFakultas{path}` | placeholder box | Cover logo (50x50mm); falls back to the placeholder if the file doesn't exist |
| `\gelarMagister{...}` | `Teknik Informatika` | The "Magister ..." phrase in the Halaman Judul purpose sentence (natural case, not ALL CAPS) |
| `\titleEnglish{...}` | `English Title Goes Here` | The translated title above "ABSTRACT" (thesis.md S3.11) |

**People/dates** (feed Pengesahan, Panitia Penguji, Ucapan Terima
Kasih/Kata Pengantar):

| Command | Fields |
| --- | --- |
| `\pembimbingSatu{Nama}{NIP}` / `\pembimbingDua{Nama}{NIP}` | Pembimbing I/II |
| `\kaprodi{Nama}{NIP}` | Ketua Program Studi |
| `\dekan{Nama}{NIP}` | Dekan |
| `\rektor{Nama}` | Rektor |
| `\pengujiSatu{Nama}` / `\pengujiDua{Nama}` | Penguji I/II |
| `\tanggalUjian{DD Bulan YYYY}` | Panitia Penguji's exam date |
| `\tanggalPernyataan{DD Bulan YYYY}` | Sign-off date on Pernyataan Orisinalitas, Persetujuan Publikasi, Ucapan Terima Kasih |

**Riwayat Hidup**: `\tempatTanggalLahir{...}`, `\alamatRumah{...}`,
`\teleponMahasiswa{...}`, `\emailMahasiswa{...}`.

`\universitasNama{...}` / `\fakultasNama{...}` are Title-Case
companions to `\universitas`/`\fakultas` (which are ALL CAPS, meant
for cover-page lines), for running prose that shouldn't shout --
Persetujuan Publikasi uses them, defaulting to `Universitas Sumatera
Utara` / `Ilmu Komputer dan Teknologi Informasi`.

### Content files must not write `\@foo` directly

`\documentclass` wraps class loading in `\makeatletter`/`\makeatother`,
so `@` is a letter only while `thesis.cls` itself is being read.
Typed literally in a `.tex` content file, `\@title` does **not**
reach for the `\@title` control word -- it lexes as the two-character
sequence `\@` (the "spacefactor after a capital" command) followed by
the literal text "title", silently printing the word "title" instead
of the actual value (this was a real, previously-shipped bug in this
template). Every field above has a public accessor for content files
to use instead: `\thesisTitle`, `\thesisAuthor`, `\thesisNim`,
`\thesisProgramStudi`, `\thesisFakultas`, `\thesisFakultasNama`,
`\thesisUniversitas`, `\thesisUniversitasNama`, `\thesisKotaTerbit`,
`\thesisTahunTerbit`, `\thesisGelarMagister`, `\thesisTitleEnglish`,
`\thesisPembimbingSatuNama`/`Nip`, `\thesisPembimbingDuaNama`/`Nip`,
`\thesisKaprodiNama`/`Nip`, `\thesisDekanNama`/`Nip`,
`\thesisRektorNama`, `\thesisPengujiSatu`/`Dua`, `\thesisTanggalUjian`,
`\thesisTempatTanggalLahir`, `\thesisAlamatRumah`,
`\thesisTeleponMahasiswa`, `\thesisEmailMahasiswa`.

## Layout helpers (for writing frontmatter content)

- **`fieldlist` environment + `\fieldrow{Label}{Value}`** -- a
  "Label : Value" table (Pengesahan, Persetujuan Publikasi, Panitia
  Penguji, Riwayat Hidup's Data Pribadi).
- **`pendidikanlist` environment + `\pendidikanrow{Jenjang}{Sekolah}{Tahun}`**
  -- like `fieldlist`, plus a `TAMAT : <year>` column flushed to the
  right margin (Riwayat Hidup's Data Pendidikan).
- **`\twinSignatures{Label1}{Nama1}{NIP1}{Label2}{Nama2}{NIP2}`** -- a
  side-by-side pair of signature blocks (Pengesahan's Pembimbing I/II
  row and its Kaprodi/Dekan approval row).
- **`\signOff{Nama}{NIM}`** -- the closing "place, date + signature +
  name/NIM" block (Pernyataan Orisinalitas, Persetujuan Publikasi,
  Ucapan Terima Kasih).
- **`\starChapterHead{preamble}{HEADING}`** -- for a page that needs
  something centered *above* the bold heading itself (Abstract's
  translated title before "ABSTRACT"). `\chapter*{...}` can't do this
  itself, since it always renders its own argument as the heading with
  nothing in front of it; this reproduces the same
  `\clearpage`+`\thispagestyle{plain}`+centered-bold-uppercase look
  with room for a preamble, including its own `\phantomsection` (see
  below).
- **`\fitOnPage{maxPullUp}{content}`** -- measures `content`'s natural
  height and, only if it would overflow the space left on the page,
  reclaims the shortfall (capped at `maxPullUp`) from the blank space
  above it before typesetting. Used by Pengesahan so a long thesis
  title (wrapping the Judul row to 2-3 lines) still fits on one page
  without ever touching its signature-block spacing.

## Bookmarks and the Daftar Isi/Daftar Pustaka page numbers

Any front-matter page that doesn't go through a plain `\chapter{...}`/
`\chapter*{...}` call (Panitia Penguji's layout, and `\starChapterHead`
above) never gets a hyperref link anchor automatically -- without an
explicit `\phantomsection` right before its `\addcontentsline`, its
PDF bookmark silently resolves to whichever page's `\chapter*` ran
*last*, not its own page. The same applies to `\tableofcontents` and
`\bibliography` in `main.tex`: their own internal `\chapter*` is what
actually breaks the page and drops the anchor, so the manual
`\addcontentsline{toc}{chapter}{...}` entries for Daftar Isi and
Daftar Pustaka have to force `\clearpage` + `\phantomsection`
themselves *first* -- calling `\addcontentsline` before that point
captures the wrong (pre-break) page, and calling it after
`\tableofcontents` returns captures wherever a multi-page listing
happened to *end*, not where it started. If you add another page like
this, follow the same `\clearpage` + `\phantomsection` +
`\addcontentsline` order.

## Known dead end: orphaned `\section`/`\subsection` headings

Two different automatic guards against a heading landing alone at the
bottom of a page were tried and reverted -- **don't reintroduce
either**, they both cause worse problems than the rare orphan they
prevent:

1. A `needspace`-based guard: `needspace`'s soft `\penalty -100` hint
   is only resolved once TeX sees enough *later* material to prove a
   break was needed there. That delay left `\@sect`'s own
   `\addcontentsline{toc}{...}`, which runs synchronously right after
   the heading, capturing `\thepage` before the page builder had
   caught up -- silently wrong Daftar Isi entries and PDF bookmarks.
2. An explicit `\ifdim\pagegoal-\pagetotal<...` check forcing an
   absolute `\newpage`: this fixed the bookmark problem, but
   `\pagetotal` is itself an unreliable snapshot -- TeX keeps
   contributing material past `\pagegoal` while still looking for the
   best breakpoint, so `\pagetotal` routinely overshoots `\pagegoal`
   well before TeX would actually break the page on its own. Reading
   that as "no room left" forced premature breaks right at the
   heading, leaving the previous page mostly blank even though TeX's
   own algorithm would have filled it properly.

Plain `\@secpenalty` (the kernel's own bias toward breaking before a
heading rather than after it) is what `\section`/`\subsection` rely on
now -- it doesn't share either failure mode, because it never tries to
force an answer before TeX itself has reached one. If a heading is
ever genuinely orphaned in real content, fix it locally (a manual
`\clearpage` or a bit of rewording) rather than reaching for a global
mechanism again.

## `apalike-usu.bst`

This is **not** regenerated or patched at build time. `make`/`bibtex`
use it exactly as it sits in this directory, the same as any other
source file -- there is no build step that touches it.

It is a hand-patched copy of TeX Live's `plainnat.bst`, needed
because thesis.md's citation rules (S4/S5, "Sistem Pengarang-Tahun")
don't match either stock style: `apalike.bst` has the right field
order but isn't natbib-compatible (compiling with it throws
"Bibliography not compatible with author-year citations"), while
`plainnat.bst` is natbib-compatible but prints fields in the wrong
order. `apalike-usu.bst` is `plainnat.bst` with three changes, each
documented in its own header comment:

1. Two authors are joined with "&" instead of "and" (S4.1.1(f)/(g)).
2. The year is moved to print right after the author, not near the
   end of the entry (S4.1-4.9's field order).
3. A journal article's volume number is bold (S4.4).

If TeX Live ever ships an updated `plainnat.bst` and you want to pick
up upstream changes, reproduce the patch by hand rather than copying
the new file over `apalike-usu.bst` outright (that would silently
drop these changes):

```
cp $(kpsewhich plainnat.bst) thesis/apalike-usu.bst
```

then reapply the three changes above -- the full instructions for
each are in `apalike-usu.bst`'s own header comment, and the exact
edits are visible in the git history of this file.
