%% proposal.cls
%% Reusable class (template) for Universitas Sumatera Utara (USU) Program
%% Studi S2 Sains Data dan Kecerdasan Buatan thesis PROPOSAL formatting.
%%
%% A thesis proposal shares the same institutional formatting standard
%% as the thesis itself (thesis.md, the "Panduan Format Tesis" at the
%% repository root): A4, margins, Times New Roman via Tinos, 1.5 line
%% spacing, top-right page numbers, and the author-year citation
%% system. Those rules are reimplemented here rather than loaded from
%% thesis/thesis.cls (paper/intlpaper.cls and thesis/thesis.cls are
%% likewise each self-contained), because a proposal's document
%% STRUCTURE differs enough to make inheriting impractical:
%% proposal.md's five bagian are one flat, continuously-numbered
%% sequence, with none of the frontmatter/mainmatter/backmatter
%% roman-vs-arabic split thesis.md S3.1 requires for a full thesis --
%% so this uses `report`, not `book`.
%%
%% Two pieces are deliberately copied from a DIFFERENT source than
%% thesis.md, though:
%% - Bagian headings ("1. Latar Belakang", "8. Tinjauan Pustaka", ...)
%%   follow proposal.pdf's look -- bold, numbered, Title Case, flush
%%   left, and (unlike thesis.md S1.4.3's centered ALL-CAPS "BAB n")
%%   NOT forced onto their own page: proposal.pdf's numbered bagian
%%   flow one after another on the same page whenever they fit (see
%%   e.g. its "3. Batasan Masalah" / "4. Tujuan Penelitian" / "5.
%%   Manfaat Penelitian" sharing one page). Daftar Pustaka is the one
%%   exception, kept on its own page with thesis.cls's centered/
%%   uppercase/unnumbered style, since it is conventionally a fresh
%%   standalone section even in an otherwise continuous document.
%% - The cover (Halaman Sampul + Halaman Judul, both pages bold except
%%   the "Diajukan..." sentence) is carried over from thesis.cls's
%%   \maketitle mechanism, per this project's convention of deriving a
%%   sibling template's cover from the thesis template rather than
%%   maintaining a second, drifted copy.
%%
%% Section numbers quoted in comments (e.g. "thesis.md S2.1") refer to
%% thesis.md; "proposal.md" is the separate, short source for which
%% content sections ("bagian") a proposal needs; "proposal.pdf" is an
%% example proposal used as the bagian-heading layout reference.
%%
%% Keep all proposal-specific content out of this file; write it in a
%% separate .tex file that loads this class with \documentclass{proposal}.
%% Compile with XeLaTeX only.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{proposal}[2026/09/21 v2.0 USU thesis proposal template]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass[12pt,a4paper,oneside]{report}

%% ------------------------------------------------------------------
%% Engine check: this class relies on fontspec, so it must be built
%% with XeLaTeX (or LuaLaTeX).
%% ------------------------------------------------------------------
\ifdefined\XeTeXversion\else
  \ifdefined\directlua\else
    \ClassError{proposal}{This class requires XeLaTeX or LuaLaTeX}%
      {Compile this document with: xelatex main.tex}
  \fi
\fi

%% ------------------------------------------------------------------
%% Page geometry -- body margins (thesis.md S2.2 "Margin Keseluruhan
%% Naskah"). headheight/headsep are sized so the running page-number
%% header sits centered ~15mm from the paper's top edge (thesis.md
%% S2.4.4/S2.4.6), and its flush-right position lands exactly on the
%% 25mm right margin (thesis.md S2.4.4 "25 mm dari tepi kanan kertas").
%% Bagian no longer get thesis.md S2.1's enlarged 50mm chapter-opening
%% margin, since (per proposal.pdf) they don't open their own page --
%% see the bagian-heading section below.
%% ------------------------------------------------------------------
\RequirePackage{geometry}
\geometry{
  a4paper,
  top=30mm,
  bottom=25mm,
  left=38mm,
  right=25mm,
  headheight=6mm,
  headsep=12mm,
  footskip=12mm
}

%% ------------------------------------------------------------------
%% Fonts. Times New Roman is required (thesis.md S1.4.1, S1.2.7); we
%% reuse the Tinos TTFs already vendored under paper/fonts/ (metric-
%% compatible, open-source substitute -- see paper/fonts/NOTICE.md)
%% instead of duplicating the binary font files, per the project
%% convention of preferring reuse over copies.
%% ------------------------------------------------------------------
\RequirePackage{fontspec}
\setmainfont{Tinos}[
  Path         = ../paper/fonts/,
  Extension    = .ttf,
  UprightFont  = *-Regular,
  BoldFont     = *-Bold,
  ItalicFont   = *-Italic,
  BoldItalicFont = *-BoldItalic
]

%% ------------------------------------------------------------------
%% Core packages (kept to a minimum on purpose). natbib is required
%% for thesis.md S4.1.1/S5's "Sistem Pengarang-Tahun" (author-year)
%% citation system -- plain \cite alone can only number citations, and
%% hand-rolling author-year sorting/labelling in the kernel is not
%% practical, so this is the one exception to keeping citation
%% handling package-free. Use \citet{key} for a citation that reads as
%% part of the sentence ("Smith (2020) found...") and \citep{key} for
%% a parenthetical one ("...as shown previously (Smith, 2020)").
%%
%% A \needspace-based orphan-heading guard (for bagian that no longer
%% force their own page break -- see below) was tried here and
%% reverted: \@chapter/\@sect call \addcontentsline{toc}{...}
%% synchronously right after typesetting a heading, capturing \thepage
%% at that exact textual point -- but when \needspace's inserted
%% penalty actually triggers a real page break, TeX's own page builder
%% is lazy and hasn't caught up with that break yet by the time
%% \addcontentsline reads \thepage, so the Daftar Isi entry (and its
%% PDF bookmark) silently pointed at the page BEFORE the break instead
%% of the heading's real page. A wrong TOC/bookmark is worse than the
%% rare stranded heading this was meant to prevent.
%% ------------------------------------------------------------------
\RequirePackage{amsmath}
\RequirePackage{graphicx}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage[authoryear,round]{natbib}

%% ------------------------------------------------------------------
%% Line spacing: whole manuscript is 1.5 spasi (thesis.md S1.4.2);
%% \singlespaced is provided for the exceptions that rule calls out
%% (table entries, daftar pustaka entries, other lists).
%% ------------------------------------------------------------------
\AtBeginDocument{\linespread{1.5}\selectfont}
\newcommand{\singlespaced}[1]{{\linespread{1}\selectfont #1}}

%% Paragraph indentation: 6 characters (thesis.md S1.4.6). First
%% paragraph after any heading is NOT indented -- this is already the
%% LaTeX kernel default as long as the indentfirst package is never
%% loaded, so no extra code is needed for that half of the rule.
\setlength{\parindent}{1.27cm}

%% No-orphan / no-widow rule (thesis.md S2.3 b/c): forbid breaking a
%% paragraph so that only one line is left dangling at a page top or
%% bottom. Kernel penalties only, no package.
\clubpenalty=10000
\widowpenalty=10000
\brokenpenalty=10000

%% ------------------------------------------------------------------
%% Page numbering (thesis.md S2.4). Proposals don't need thesis.md
%% S3.1's roman-vs-arabic front/main/back split (there's no separate
%% "bagian muka" here, just the title page and five bagian), so page
%% numbers run arabic from 1 throughout, and -- since bagian no longer
%% open their own page (see below) -- are never hidden except on the
%% title page and on Daftar Pustaka's opening page, matching
%% proposal.pdf (its every content page, including the ones where a
%% new numbered bagian starts partway down, shows a folio).
%% ------------------------------------------------------------------
\def\ps@proposalplain{%
  \let\@mkboth\@gobbletwo
  \let\@oddfoot\@empty\let\@evenfoot\@empty
  \def\@oddhead{\hfil\normalfont\normalsize\thepage}%
  \let\@evenhead\@oddhead
}
\def\ps@plain{%
  \let\@mkboth\@gobbletwo
  \let\@oddhead\@empty\let\@evenhead\@empty
  \let\@oddfoot\@empty\let\@evenfoot\@empty
}
\AtBeginDocument{\pagestyle{proposalplain}}

%% ------------------------------------------------------------------
%% Bagian headings (proposal.pdf's look, not thesis.md S1.4.3's "BAB
%% n"): bold, numbered "<n>. Title" in Title Case, flush left, and --
%% the key structural difference from thesis.cls's chapters -- NOT
%% forced onto a fresh page. \chapter's outer wrapper normally does
%% that unconditionally (via \clearpage/\cleardoublepage before
%% \secdef), so it's redefined here without it; \@makeschapterhead
%% (unnumbered, i.e. Daftar Pustaka) re-adds \clearpage itself,
%% since that one heading IS still meant to start a fresh page.
%% ------------------------------------------------------------------
\renewcommand\thechapter{\arabic{chapter}}

%% An orphan-heading guard for bagian (since they no longer force
%% their own page break, one could otherwise land stranded at the
%% bottom of a page) was tried here via \needpage and reverted -- see
%% the \section/\subsection comment below for the full story of why
%% both that and a \needspace-based attempt before it caused worse
%% problems (wrong bookmarks, then premature page breaks) than the
%% rare orphan they were meant to prevent.
\renewcommand\chapter{%
  \global\@topnum\z@
  \@afterindentfalse
  \secdef\@chapter\@schapter}

\def\@makechapterhead#1{%
  \vspace{2\baselineskip}%
  {\parindent\z@\raggedright\normalfont\bfseries\thechapter.~#1\par}%
  \vskip 1\baselineskip
}
%% \thispagestyle{plain} hides the page number on this one opening
%% page (thesis.md S2.4.3/S2.4.5) while leaving the counter itself
%% untouched; a continuation page (if Daftar Isi or Daftar Pustaka
%% ever runs long enough to need one) reverts to the visible running
%% \ps@proposalplain style on its own, since \thispagestyle only ever
%% applies to the single page it's called on.
\def\@makeschapterhead#1{%
  \clearpage
  \thispagestyle{plain}
  {\centering\normalfont\bfseries\MakeUppercase{#1}\par}%
  \vskip 3\baselineskip
}

%% ------------------------------------------------------------------
%% Sub-bab level 1 = \section (thesis.md S1.4.4): bold, numbered
%% "<bab>.<n>.", flush with the left margin. Type the heading text in
%% Title Case (a capital on each word) when writing content -- LaTeX
%% cannot infer that automatically.
%% Sub-bab level 2 = \subsection (thesis.md S1.4.5): italic, numbered
%% "<bab>.<n>.<m>.", flush left. Type the heading text in sentence
%% case (a capital only on the first word).
%% This is the deepest level thesis.md recommends, so \subsubsection
%% is left at its report.cls default and unused in practice.
%% ------------------------------------------------------------------
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}

%% \@startsection defaults to indenting the paragraph that follows a
%% \section/\subsection heading (\@afterindenttrue in the LaTeX
%% kernel); thesis.md S1.4.6 wants that first paragraph flush.
%% \@sect runs the heading style inside its own \begingroup/\endgroup,
%% so a plain \@afterindentfalse there would be undone before
%% \@afterheading ever checks it -- it must be set \global. (report.cls
%% already does the equivalent for \chapter on its own.)
%%
%% Two different orphan-heading guards were tried here and both
%% reverted, for two different reasons rooted in the same cause --
%% TeX's page breaking is inherently asynchronous/lazy, so nothing run
%% synchronously at the heading can reliably know the final outcome:
%% 1. \needspace's soft \penalty-100 hint is only resolved once TeX
%%    sees enough LATER material to prove a break was needed there --
%%    a delayed decision that left \@sect/\@chapter's own
%%    \addcontentsline{toc}{...}, which runs synchronously right after
%%    the heading, capturing \thepage before the page builder had
%%    caught up (wrong Daftar Isi entries and PDF bookmarks).
%% 2. An explicit \ifdim\pagegoal-\pagetotal<... check (forcing an
%%    absolute \newpage instead of a soft penalty) fixed that, but
%%    \pagetotal itself is an unreliable snapshot: TeX keeps
%%    contributing material past \pagegoal while still looking for the
%%    best breakpoint, so \pagetotal routinely overshoots \pagegoal
%%    (confirmed empirically) well before TeX would actually have
%%    broken the page on its own accord. Reading that as "no room
%%    left" forced premature breaks right at the heading, leaving the
%%    previous page mostly blank even when TeX's own algorithm would
%%    have filled it properly.
%% Plain \@secpenalty (the kernel's own bias toward breaking before a
%% heading rather than after it) is what's relied on instead -- it
%% doesn't share either failure mode, because it never tries to force
%% an answer TeX itself hasn't reached yet.
\renewcommand\section{\@startsection{section}{1}{\z@}%
  {3.5ex plus 1ex minus .2ex}{1.5ex plus .2ex}%
  {\normalfont\bfseries\global\@afterindentfalse}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
  {3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}%
  {\normalfont\itshape\global\@afterindentfalse}}

%% ------------------------------------------------------------------
%% Daftar Pustaka naming and single-spaced hanging-indent entries
%% (thesis.md S3.14: "satu spasi dengan format hanging indent" -- the
%% hanging indent already falls out of \thebibliography's default
%% \list geometry, so only the spacing needs overriding).
%% ------------------------------------------------------------------
\renewcommand\contentsname{DAFTAR ISI}
\renewcommand\bibname{DAFTAR PUSTAKA}
\renewcommand\tablename{Tabel}
\renewcommand\figurename{Gambar}

\let\proposal@oldbibliography\thebibliography
\let\proposal@oldendbibliography\endthebibliography
\renewenvironment{thebibliography}[1]{%
  \begingroup\linespread{1}\selectfont
  \proposal@oldbibliography{#1}%
}{%
  \proposal@oldendbibliography
  \endgroup
}

%% ------------------------------------------------------------------
%% Title page fields (thesis.md S3.3, adapted: "PROPOSAL TESIS" in
%% place of "TESIS", the rest identical). \title is reused for the
%% research title; the rest are USU/Fasilkom-specific fields with the
%% fixed wording thesis.md prescribes, overridable per document.
%% ------------------------------------------------------------------
\newcommand{\nim}[1]{\gdef\@nim{#1}}
\newcommand{\@nim}{}
\newcommand{\programStudi}[1]{\gdef\@programStudi{#1}}
\newcommand{\@programStudi}{PROGRAM STUDI S2 TEKNIK INFORMATIKA}
\newcommand{\fakultas}[1]{\gdef\@fakultas{#1}}
\newcommand{\@fakultas}{FAKULTAS ILMU KOMPUTER DAN TEKNOLOGI INFORMASI}
\newcommand{\universitas}[1]{\gdef\@universitas{#1}}
\newcommand{\@universitas}{UNIVERSITAS SUMATERA UTARA}
\newcommand{\kotaTerbit}[1]{\gdef\@kotaTerbit{#1}}
\newcommand{\@kotaTerbit}{MEDAN}
\newcommand{\tahunTerbit}[1]{\gdef\@tahunTerbit{#1}}
\newcommand{\@tahunTerbit}{\the\year}
\newcommand{\logoFakultas}[1]{\gdef\@logoFakultas{#1}}
\newcommand{\@logoFakultas}{}

%% ------------------------------------------------------------------
%% Public read accessors for the fields above. \documentclass wraps
%% class loading in \makeatletter/\makeatother, so "@" is a letter
%% only while THIS file is being read -- every \newcommand{\@foo}{...}
%% above tokenizes fine here, but "@" is back to being an ordinary
%% (non-letter) character by the time chapters/main.tex are read.
%% Typed there, \@foo does not reach for the \@foo control word at
%% all: it lexes as the two-character sequence \@ (the "spacefactor
%% after a capital" command) followed by the literal text "foo". These
%% wrappers are what content files must use instead to read the
%% fields -- never \@foo directly outside this file. (Same fix as
%% thesis/thesis.cls; ported here since proposal.cls shares the fields
%% but is otherwise a self-contained sibling, not a subclass.)
%% ------------------------------------------------------------------
\newcommand{\proposalTitle}{\@title}
\newcommand{\proposalAuthor}{\@author}
\newcommand{\proposalNim}{\@nim}
\newcommand{\proposalProgramStudi}{\@programStudi}
\newcommand{\proposalFakultas}{\@fakultas}
\newcommand{\proposalUniversitas}{\@universitas}
\newcommand{\proposalKotaTerbit}{\@kotaTerbit}
\newcommand{\proposalTahunTerbit}{\@tahunTerbit}

%% ------------------------------------------------------------------
%% Cover (thesis.md S3.2/S3.3's fields, but a single page, matching
%% proposal.pdf -- unlike thesis.cls's thesis cover, that reference
%% has no separate Halaman Judul with a "Diajukan..." purpose
%% sentence, just one bold cover with title, PROPOSAL TESIS, name/NIM,
%% logo, and program/fakultas/universitas/kota/tahun): 60mm top/bottom
%% margins (thesis.md S1.2.1), 14pt uppercase Times New Roman
%% (thesis.md S1.2.7), everything bold. No page number is printed, and
%% -- unlike thesis.cls's cover, which stays counted per thesis.md
%% S2.4.3 -- the cover is excluded from the page count entirely here:
%% \setcounter{page}{1} below makes whatever follows \maketitle
%% (Daftar Isi) page 1, matching proposal.pdf (its numbering starts at
%% its first content page, not counting the cover).
%% ------------------------------------------------------------------
\renewcommand{\maketitle}{%
  \begingroup
  \newgeometry{top=60mm,bottom=60mm,left=38mm,right=25mm}
  \thispagestyle{empty}
  \begin{center}
    %% Reset to single spacing here: thesis.md S1.4.2's 1.5-spasi rule
    %% is for the manuscript body: on the cover, 1.5 spacing is called
    %% out only for specific multi-line elements (S1.2.2 title lines,
    %% S1.2.4 name/NIM), applied explicitly below via \\[..] instead.
    \linespread{1}\fontsize{14}{18}\selectfont
    \bfseries
    \MakeUppercase{\@title}\par
    \vfill
    PROPOSAL TESIS\par
    \vskip 1.5\baselineskip
    \MakeUppercase{\@author}\\[.5\baselineskip]
    \@nim\par
    \vfill
    \def\proposal@logoplaceholder{%
      \fbox{\parbox[c][50mm][c]{50mm}{\centering\normalfont\fontsize{9}{11}\selectfont
        Logo Fakultas\\(50\texttimes50 mm)\\place file and set\\\string\logoFakultas\{path\}}}}%
    \ifx\@logoFakultas\@empty
      \proposal@logoplaceholder
    \else
      \IfFileExists{\@logoFakultas}{%
        \includegraphics[width=50mm,height=50mm]{\@logoFakultas}%
      }{\proposal@logoplaceholder}%
    \fi\par
    \vfill
    \@programStudi\par
    \@fakultas\par
    \@universitas\par
    \@kotaTerbit\par
    \@tahunTerbit\par
  \end{center}
  \restoregeometry
  \endgroup
  \newpage
  \setcounter{page}{1}
}

%% ------------------------------------------------------------------
%% PDF metadata
%% ------------------------------------------------------------------
\AtBeginDocument{\hypersetup{pdftitle={\@title}}}

\endinput
