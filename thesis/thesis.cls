%% thesis.cls
%% Reusable class (template) for Universitas Sumatera Utara (USU) Program
%% Studi S2 Sains Data dan Kecerdasan Buatan master's thesis formatting.
%%
%% All formatting rules implemented below are sourced from thesis.md (the
%% "Panduan Format Tesis" at the repository root). Section numbers quoted
%% in comments (e.g. "thesis.md S2.1") refer to that file so the two stay
%% traceable to each other.
%%
%% Keep all thesis-specific content out of this file; write it in a
%% separate .tex file that loads this class with \documentclass{thesis}.
%% Compile with XeLaTeX only.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2026/08/19 v1.0 USU master thesis template]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
%% book.cls gives us \frontmatter/\mainmatter/\backmatter for free, which
%% map directly onto thesis.md S3.1's "bagian muka / tubuh / belakang"
%% (roman page numbers, arabic page numbers starting at 1, arabic page
%% numbers continuing) -- see thesis.md S2.4.2 and S3.1.1-3.1.3.
\LoadClass[12pt,a4paper,oneside]{book}

%% ------------------------------------------------------------------
%% Engine check: this class relies on fontspec, so it must be built
%% with XeLaTeX (or LuaLaTeX).
%% ------------------------------------------------------------------
\ifdefined\XeTeXversion\else
  \ifdefined\directlua\else
    \ClassError{thesis}{This class requires XeLaTeX or LuaLaTeX}%
      {Compile this document with: xelatex main.tex}
  \fi
\fi

%% ------------------------------------------------------------------
%% Page geometry -- body margins (thesis.md S2.2 "Margin Keseluruhan
%% Naskah"). headheight/headsep are sized so the running page-number
%% header sits centered ~15mm from the paper's top edge (thesis.md
%% S2.4.4/S2.4.6), and its flush-right position lands exactly on the
%% 25mm right margin (thesis.md S2.4.4 "25 mm dari tepi kanan kertas").
%% The extra 20mm top margin required on chapter-opening pages
%% (thesis.md S2.1, 50mm vs. the normal 30mm) is added separately in
%% \@makechapterhead below, not here.
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
%% for thesis.md S4.1.1's "Sistem Pengarang-Tahun" (author-year)
%% citation system -- plain \cite alone can only number citations, and
%% hand-rolling author-year sorting/labelling in the kernel is not
%% practical, so this is the one exception to keeping citation
%% handling package-free. Use \citet{key} for a citation that reads as
%% part of the sentence ("Smith (2020) found...") and \citep{key} for
%% a parenthetical one ("...as shown previously (Smith, 2020)").
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
%% Page numbering (thesis.md S2.4).
%%
%% - \ps@thesisplain is the running style for ordinary content pages:
%%   the page number, flush right, ~15mm from the top edge.
%% - \ps@plain is emptied out. book.cls's \chapter (and \chapter*)
%%   already call \thispagestyle{plain} on the opening page of every
%%   chapter/section; emptying that style is what hides the number on
%%   chapter-opening pages and on single-page front-matter sheets like
%%   Pengesahan or Panitia Penguji (thesis.md S2.4.3, S2.4.5), while
%%   leaving the page counter itself untouched, exactly as required.
%% ------------------------------------------------------------------
\def\ps@thesisplain{%
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
\AtBeginDocument{\pagestyle{thesisplain}}

%% ------------------------------------------------------------------
%% Chapter headings (thesis.md S1.4.3): "BAB <n>" in arabic numerals,
%% centered, followed by the bold, all-caps chapter title, centered.
%% Numbered chapters (bagian tubuh, i.e. Bab 1-5) additionally get the
%% enlarged 50mm top margin from thesis.md S2.1 "Margin Awal Bab" --
%% stacked on top of the normal 30mm body top margin already set by
%% \geometry above. The 12.4mm figure below (rather than the naive
%% 20mm difference) is calibrated against TeX's \topskip handling of
%% the first box on a page, verified against the compiled PDF with
%% pdftotext -bbox so "BAB n" lands at 50mm from the paper edge.
%% Starred chapters (front-matter sheets, DAFTAR PUSTAKA, LAMPIRAN)
%% are not "Bab" under that rule, so they keep the plain 30mm margin.
%% ------------------------------------------------------------------
\renewcommand\thechapter{\arabic{chapter}}
\renewcommand\@chapapp{BAB}

%% \centering (a declaration) is used instead of the center
%% environment, which would add its own \list topsep/parskip padding
%% on top of the 20mm/0mm already placed here and overshoot the
%% required top margin.
\def\@makechapterhead#1{%
  \vspace*{12.4mm}%
  {\centering\normalfont\bfseries \@chapapp~\thechapter\par
    \vskip 1.5\baselineskip
    \MakeUppercase{#1}\par}%
  \vskip 3\baselineskip
}
\def\@makeschapterhead#1{%
  {\centering\normalfont\bfseries \MakeUppercase{#1}\par}%
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
%% is left at its book.cls default and unused in practice.
%% ------------------------------------------------------------------
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}

%% \@startsection defaults to indenting the paragraph that follows a
%% \section/\subsection heading (\@afterindenttrue in the LaTeX
%% kernel); thesis.md S1.4.6 wants that first paragraph flush.
%% \@sect runs the heading style inside its own \begingroup/\endgroup,
%% so a plain \@afterindentfalse there would be undone before
%% \@afterheading ever checks it -- it must be set \global. (book.cls
%% already does the equivalent for \chapter on its own.)
%%
%% Two different orphan-heading guards were tried here and both
%% reverted, for two different reasons rooted in the same cause --
%% TeX's page breaking is inherently asynchronous/lazy, so nothing run
%% synchronously at the heading can reliably know the final outcome:
%% 1. \needspace's soft \penalty-100 hint is only resolved once TeX
%%    sees enough LATER material to prove a break was needed there --
%%    a delayed decision that left \@sect's own \addcontentsline{toc}
%%    {...}, which runs synchronously right after the heading,
%%    capturing \thepage before the page builder had caught up (wrong
%%    Daftar Isi entries and PDF bookmarks).
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
%% Front-matter/back-matter naming (thesis.md S3.2's table of contents
%% entries), and single-spaced hanging-indent bibliography entries
%% (thesis.md S3.14: "satu spasi dengan format hanging indent" -- the
%% hanging indent already falls out of \thebibliography's default
%% \list geometry, so only the spacing needs overriding).
%% ------------------------------------------------------------------
\renewcommand\contentsname{DAFTAR ISI}
\renewcommand\listtablename{DAFTAR TABEL}
\renewcommand\listfigurename{DAFTAR GAMBAR}
\renewcommand\bibname{DAFTAR PUSTAKA}
\renewcommand\tablename{Tabel}
\renewcommand\figurename{Gambar}

\let\thesis@oldbibliography\thebibliography
\let\thesis@oldendbibliography\endthebibliography
\renewenvironment{thebibliography}[1]{%
  \begingroup\linespread{1}\selectfont
  \thesis@oldbibliography{#1}%
}{%
  \thesis@oldendbibliography
  \endgroup
}

%% ------------------------------------------------------------------
%% Title page fields (thesis.md S3.3). \title is reused for the thesis
%% title; the rest are USU/Fasilkom-specific fields with the fixed
%% wording thesis.md prescribes, overridable per document if needed.
%% ------------------------------------------------------------------
\newcommand{\nim}[1]{\gdef\@nim{#1}}
\newcommand{\@nim}{}
\newcommand{\programStudi}[1]{\gdef\@programStudi{#1}}
\newcommand{\@programStudi}{Sains Data dan Kecerdasan Buatan}
\newcommand{\fakultas}[1]{\gdef\@fakultas{#1}}
\newcommand{\@fakultas}{FAKULTAS ILMU KOMPUTER DAN TEKNOLOGI INFORMASI}
\newcommand{\fakultasNama}[1]{\gdef\@fakultasNama{#1}}
\newcommand{\@fakultasNama}{Ilmu Komputer dan Teknologi Informasi}
\newcommand{\universitas}[1]{\gdef\@universitas{#1}}
\newcommand{\@universitas}{UNIVERSITAS SUMATERA UTARA}
%% Title-case companion to \universitas, for running prose (e.g.
%% Persetujuan Publikasi) that shouldn't shout the university name in
%% full caps the way the cover page's fields do -- same reasoning as
%% \gelarMagister existing alongside \programStudi.
\newcommand{\universitasNama}[1]{\gdef\@universitasNama{#1}}
\newcommand{\@universitasNama}{Universitas Sumatera Utara}
\newcommand{\kotaTerbit}[1]{\gdef\@kotaTerbit{#1}}
\newcommand{\@kotaTerbit}{MEDAN}
\newcommand{\tahunTerbit}[1]{\gdef\@tahunTerbit{#1}}
\newcommand{\@tahunTerbit}{\the\year}
\newcommand{\logoFakultas}[1]{\gdef\@logoFakultas{#1}}
\newcommand{\@logoFakultas}{}
\newcommand{\gelarMagister}[1]{\gdef\@gelarMagister{#1}}
\newcommand{\@gelarMagister}{Sains Data dan Kecerdasan Buatan}
%% English translation of \title, used only on the Abstract page
%% (thesis.md S3.11: the abstract's English translation starts with a
%% translated title before the word ABSTRACT).
\newcommand{\titleEnglish}[1]{\gdef\@titleEnglish{#1}}
\newcommand{\@titleEnglish}{English Title Goes Here}

%% ------------------------------------------------------------------
%% Halaman Sampul + Halaman Judul (thesis.md S3.2, S3.3): the sampul
%% (outer cover) and the judul (inner title page) share every field --
%% title, TESIS, name/NIM, logo, program/fakultas/universitas/kota/
%% tahun -- at the same 60mm top/bottom margins (thesis.md S1.2.1) and
%% 14pt uppercase Times New Roman (thesis.md S1.2.7). The judul page
%% additionally states the thesis's purpose (thesis.md S3.3.C) right
%% after "TESIS". \thesis@titlepage takes that purpose text (or empty)
%% as its argument so the two pages render from one shared body
%% instead of duplicating it. Neither page prints a page number, but
%% both are still counted (sampul = cover, not paginated at all;
%% judul = page "i"; thesis.md S2.4.3).
%% ------------------------------------------------------------------
\newcommand{\thesis@titlepage}[1]{%
  \begingroup
  \newgeometry{top=60mm,bottom=60mm,left=38mm,right=25mm}
  \thispagestyle{empty}
  \begin{center}
    %% Reset to single spacing here: thesis.md S1.4.2's 1.5-spasi rule
    %% is for the manuscript body: on the cover, 1.5 spacing is called
    %% out only for specific multi-line elements (S1.2.2 title lines,
    %% S1.2.4 name/NIM), applied explicitly below via \\[..] instead.
    %% Every cover line is bold except the "Diajukan..." purpose
    %% sentence (#1 on the Halaman Judul page): \bfseries set once
    %% here carries through the whole \begin{center}...\end{center}
    %% group, and #1 locally switches to \mdseries inside its own
    %% braces so bold resumes automatically once that group ends.
    \linespread{1}\fontsize{14}{18}\selectfont
    \bfseries
    \MakeUppercase{\@title}\par
    \vfill
    TESIS\par
    #1%
    \vskip 1.5\baselineskip
    \MakeUppercase{\@author}\\[.5\baselineskip]
    \@nim\par
    \vfill
    \def\thesis@logoplaceholder{%
      \fbox{\parbox[c][50mm][c]{50mm}{\centering\normalfont\fontsize{9}{11}\selectfont
        Logo Fakultas\\(50\texttimes50 mm)\\place file and set\\\string\logoFakultas\{path\}}}}%
    \ifx\@logoFakultas\@empty
      \thesis@logoplaceholder
    \else
      \IfFileExists{\@logoFakultas}{%
        \includegraphics[width=50mm,height=50mm]{\@logoFakultas}%
      }{\thesis@logoplaceholder}%
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
}
\renewcommand{\maketitle}{%
  \thesis@titlepage{}%
  \thesis@titlepage{%
    \vskip 1.5\baselineskip
    {\mdseries Diajukan untuk melengkapi tugas dan memenuhi syarat\\[.5\baselineskip]
    memperoleh ijazah Magister \@gelarMagister\par}%
  }%
}

%% ------------------------------------------------------------------
%% People/date fields shared by the Pengesahan, Panitia Penguji, and
%% Ucapan Terima Kasih pages (thesis.md S3.4, S3.7, S3.9): supervisors,
%% examiners, and the officials who sign off on the thesis. All have
%% placeholder defaults so the template still compiles before real
%% names are filled in, the same pattern \programStudi/\fakultas use
%% above.
%% ------------------------------------------------------------------
\newcommand{\pembimbingSatu}[2]{\gdef\@pembimbingSatuNama{#1}\gdef\@pembimbingSatuNip{#2}}
\newcommand{\@pembimbingSatuNama}{Nama Pembimbing I}
\newcommand{\@pembimbingSatuNip}{NIP Pembimbing I}
\newcommand{\pembimbingDua}[2]{\gdef\@pembimbingDuaNama{#1}\gdef\@pembimbingDuaNip{#2}}
\newcommand{\@pembimbingDuaNama}{Nama Pembimbing II}
\newcommand{\@pembimbingDuaNip}{NIP Pembimbing II}
\newcommand{\kaprodi}[2]{\gdef\@kaprodiNama{#1}\gdef\@kaprodiNip{#2}}
\newcommand{\@kaprodiNama}{Nama Ketua Program Studi}
\newcommand{\@kaprodiNip}{NIP Ketua Program Studi}
\newcommand{\dekan}[2]{\gdef\@dekanNama{#1}\gdef\@dekanNip{#2}}
\newcommand{\@dekanNama}{Nama Dekan}
\newcommand{\@dekanNip}{NIP Dekan}
\newcommand{\rektor}[1]{\gdef\@rektorNama{#1}}
\newcommand{\@rektorNama}{Nama Rektor}
\newcommand{\pengujiSatu}[1]{\gdef\@pengujiSatu{#1}}
\newcommand{\@pengujiSatu}{Nama Penguji I}
\newcommand{\pengujiDua}[1]{\gdef\@pengujiDua{#1}}
\newcommand{\@pengujiDua}{Nama Penguji II}
\newcommand{\tanggalUjian}[1]{\gdef\@tanggalUjian{#1}}
\newcommand{\@tanggalUjian}{DD Bulan YYYY}
\newcommand{\tanggalPernyataan}[1]{\gdef\@tanggalPernyataan{#1}}
\newcommand{\@tanggalPernyataan}{DD Bulan YYYY}

%% Data pribadi fields for Riwayat Hidup (thesis.md S3.8).
\newcommand{\tempatTanggalLahir}[1]{\gdef\@tempatTanggalLahir{#1}}
\newcommand{\@tempatTanggalLahir}{Tempat, DD Bulan YYYY}
\newcommand{\alamatRumah}[1]{\gdef\@alamatRumah{#1}}
\newcommand{\@alamatRumah}{Alamat rumah mahasiswa}
\newcommand{\teleponMahasiswa}[1]{\gdef\@teleponMahasiswa{#1}}
\newcommand{\@teleponMahasiswa}{Nomor telepon/HP mahasiswa}
\newcommand{\emailMahasiswa}[1]{\gdef\@emailMahasiswa{#1}}
\newcommand{\@emailMahasiswa}{alamat@email.mahasiswa}

%% ------------------------------------------------------------------
%% Public read accessors for the fields above. \documentclass wraps
%% class loading in \makeatletter/\makeatother, so "@" is a letter
%% only while THIS file is being read -- every \newcommand{\@foo}{...}
%% above tokenizes fine here, but "@" is back to being an ordinary
%% (non-letter) character by the time frontmatter/chapters/backmatter
%% files are read. Typed there, \@foo does not reach for the \@foo
%% control word at all: it lexes as the two-character sequence \@
%% (the "spacefactor after a capital" command) followed by the literal
%% text "foo". These wrappers are what content files must use instead
%% to read the fields -- never \@foo directly outside this file.
%% ------------------------------------------------------------------
\newcommand{\thesisTitle}{\@title}
\newcommand{\thesisAuthor}{\@author}
\newcommand{\thesisNim}{\@nim}
\newcommand{\thesisProgramStudi}{\@programStudi}
\newcommand{\thesisFakultas}{\@fakultas}
\newcommand{\thesisFakultasNama}{\@fakultasNama}
\newcommand{\thesisUniversitas}{\@universitas}
\newcommand{\thesisUniversitasNama}{\@universitasNama}
\newcommand{\thesisKotaTerbit}{\@kotaTerbit}
\newcommand{\thesisTahunTerbit}{\@tahunTerbit}
\newcommand{\thesisGelarMagister}{\@gelarMagister}
\newcommand{\thesisTitleEnglish}{\@titleEnglish}
\newcommand{\thesisPembimbingSatuNama}{\@pembimbingSatuNama}
\newcommand{\thesisPembimbingSatuNip}{\@pembimbingSatuNip}
\newcommand{\thesisPembimbingDuaNama}{\@pembimbingDuaNama}
\newcommand{\thesisPembimbingDuaNip}{\@pembimbingDuaNip}
\newcommand{\thesisKaprodiNama}{\@kaprodiNama}
\newcommand{\thesisKaprodiNip}{\@kaprodiNip}
\newcommand{\thesisDekanNama}{\@dekanNama}
\newcommand{\thesisDekanNip}{\@dekanNip}
\newcommand{\thesisRektorNama}{\@rektorNama}
\newcommand{\thesisPengujiSatu}{\@pengujiSatu}
\newcommand{\thesisPengujiDua}{\@pengujiDua}
\newcommand{\thesisTanggalUjian}{\@tanggalUjian}
\newcommand{\thesisTempatTanggalLahir}{\@tempatTanggalLahir}
\newcommand{\thesisAlamatRumah}{\@alamatRumah}
\newcommand{\thesisTeleponMahasiswa}{\@teleponMahasiswa}
\newcommand{\thesisEmailMahasiswa}{\@emailMahasiswa}

%% ------------------------------------------------------------------
%% Layout helpers reused across the front-matter sheets above: a
%% "Label : Value" field table (Pengesahan, Persetujuan Publikasi,
%% Panitia Penguji, Riwayat Hidup's Data Pribadi), a variant with a
%% trailing "TAMAT : year" column (Riwayat Hidup's Data Pendidikan), a
%% side-by-side pair of signature blocks (Pengesahan's Pembimbing I/II
%% and Kaprodi/Dekan approval rows), and the closing "place, date +
%% signature + name/NIM" block signed at the bottom of Pernyataan
%% Orisinalitas, Persetujuan Publikasi, and Ucapan Terima Kasih.
%% ------------------------------------------------------------------
%% Starred-chapter opening for pages that need something centered
%% ABOVE the bold heading itself -- e.g. Abstract's translated title
%% before the word "ABSTRACT" (thesis.md S3.11). \chapter*{...} always
%% clears to a new page and then renders its argument as the heading
%% via \@makeschapterhead, so there is no way to slot extra content
%% before that heading through \chapter* alone; this reproduces the
%% same \clearpage + \thispagestyle{plain} + centered-bold-uppercase
%% look, with room for a preamble in front.
\newcommand{\starChapterHead}[2]{%
  % #1 = extra centered content before the heading (may be empty), #2 = heading text
  \clearpage
  \thispagestyle{plain}
  % \chapter*{...} is patched by hyperref to drop a fresh link anchor
  % at the heading automatically; bypassing it here (that's the whole
  % point of this macro) means nothing does that on its own, so a
  % \addcontentsline/bookmark entry for this page would otherwise
  % silently resolve to whatever anchor was last created -- i.e. the
  % PRECEDING \chapter*'s page. \phantomsection is hyperref's standard
  % answer for exactly this: a hyperlink target with no heading
  % command driving it.
  \phantomsection
  {\centering\normalfont
    #1%
    \bfseries \MakeUppercase{#2}\par}%
  \vskip 3\baselineskip
}

\newenvironment{fieldlist}{%
  \begin{tabular}{@{}l@{\hspace{2mm}}l@{\hspace{2mm}}p{0.6\linewidth}@{}}
}{%
  \end{tabular}
}
\newcommand{\fieldrow}[2]{#1 & : & #2\\}

%% \extracolsep{\fill} stretches to whatever is left of \linewidth, so
%% "TAMAT" always lands flush against the right margin regardless of
%% how long the school name is, instead of sitting a fixed distance
%% after it.
\newenvironment{pendidikanlist}{%
  \begin{tabular*}{\linewidth}{@{}l@{\hspace{1mm}}l@{\hspace{2mm}}p{0.42\linewidth}@{\extracolsep{\fill}}l@{}}
}{%
  \end{tabular*}
}
\newcommand{\pendidikanrow}[3]{#1 & : & #2 & TAMAT : #3\\[2mm]}

%% \par at the end is load-bearing: without it, two \twinSignatures
%% calls in a row (Pengesahan needs Pembimbing I/II, then Kaprodi/
%% Dekan) run together into a single paragraph joined by the \hfill
%% glue between minipages. TeX treats that glue as a legal line-break
%% point, so its line breaker can -- and did -- split the "paragraph"
%% so the second call's minipages land on the next page instead of
%% packing under the first on the same one.
\newcommand{\twinSignatures}[6]{%
  % #1/#4 = role labels, #2/#5 = names, #3/#6 = NIPs
  \noindent
  \begin{minipage}[t]{0.48\linewidth}
    #1\par
    \vspace{10mm}
    #2\par
    NIP. #3\par
  \end{minipage}\hfill
  \begin{minipage}[t]{0.48\linewidth}
    #4\par
    \vspace{10mm}
    #5\par
    NIP. #6\par
  \end{minipage}\par
}

\newcommand{\signOff}[2]{%
  % #1 = name, #2 = NIM. Each \par above ends the current paragraph,
  % so \noindent must be repeated on every line below -- it does not
  % carry over to the next paragraph the way it might read.
  \noindent\@kotaTerbit, \@tanggalPernyataan\par
  \vspace{15mm}
  \noindent#1\par
  \noindent NIM. #2\par
}

%% ------------------------------------------------------------------
%% Keeps a block of content on the current page even when it grows
%% (e.g. Pengesahan's Judul row wrapping to 2-3 lines for a long
%% thesis title): measures #2's natural height, and if it would
%% overflow the space left on the page, reclaims exactly that
%% shortfall -- capped at #1, so the pull-up can never eat into the
%% heading above it -- from the blank space directly above #2, before
%% typesetting it. Content that already fits is untouched, so normal-
%% length titles keep whatever spacing #2 already sets between its
%% own parts (e.g. Pengesahan's widened signature gaps).
%% ------------------------------------------------------------------
\newsavebox{\thesis@fitbox}
\newlength{\thesis@fitshortfall}
\newcommand{\fitOnPage}[2]{%
  % #1 = maximum pull-up allowed, #2 = the content to fit
  \sbox{\thesis@fitbox}{\begin{minipage}{\linewidth}#2\end{minipage}}%
  % The +10pt is a small safety margin: measuring #2 in isolation
  % like this doesn't account for the interline glue TeX adds when
  % it's actually appended to the page's main vertical list, which
  % empirically eats a few extra points beyond the box's own ht+dp.
  \setlength{\thesis@fitshortfall}{\dimexpr\ht\thesis@fitbox+\dp\thesis@fitbox-\pagegoal+\pagetotal+10\p@\relax}%
  \ifdim\thesis@fitshortfall>\z@
    \ifdim\thesis@fitshortfall>#1 \setlength{\thesis@fitshortfall}{#1}\fi
    \vspace*{-\thesis@fitshortfall}%
  \fi
  \usebox{\thesis@fitbox}%
}

%% ------------------------------------------------------------------
%% PDF metadata
%% ------------------------------------------------------------------
\AtBeginDocument{\hypersetup{pdftitle={\@title}}}

\endinput
