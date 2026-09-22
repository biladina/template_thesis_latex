%% executivesummary.cls
%% Reusable class (template) for the Universitas Sumatera Utara (USU)
%% Fakultas Ilmu Komputer dan Teknologi Informasi "Executive Summary"
%% cover form (e.g. "Executive Summary Proposal Penelitian Tesis").
%%
%% This is a one-page institutional form, not a chaptered manuscript,
%% so it is built on `article`, not `book`/`report` -- unlike
%% thesis/thesis.cls it has no frontmatter/mainmatter split, no
%% bibliography, and no chapter numbering. Layout metrics below
%% (margins, banner/table colors, page-number position) were measured
%% directly from executive_summary_template.pdf with pdftotext -bbox
%% and pixel-sampled with Pillow, not copied from any other class in
%% this repository.
%%
%% Keep all form-specific content out of this file; write it in a
%% separate .tex file that loads this class with
%% \documentclass{executivesummary}. Compile with XeLaTeX only.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{executivesummary}[2026/09/20 v1.0 USU executive summary form template]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt,a4paper,oneside]{article}

%% ------------------------------------------------------------------
%% Engine check: this class relies on fontspec, so it must be built
%% with XeLaTeX (or LuaLaTeX).
%% ------------------------------------------------------------------
\ifdefined\XeTeXversion\else
  \ifdefined\directlua\else
    \ClassError{executivesummary}{This class requires XeLaTeX or LuaLaTeX}%
      {Compile this document with: xelatex main.tex}
  \fi
\fi

%% ------------------------------------------------------------------
%% Page geometry. Measured from executive_summary_template.pdf (A4,
%% 595.44 x 841.92 pt): the green section banners run from x=55.2pt to
%% x=525.4pt, i.e. a left margin of ~19.5mm and a right margin of
%% ~24.7mm. Rounded to 20mm left, 25mm right. Top margin is tightened
%% to 12mm (from the source PDF's ~21mm) since this template omits the
%% form-ID stamp that the top margin used to leave room for.
%% ------------------------------------------------------------------
\RequirePackage[a4paper,top=12mm,bottom=20mm,left=20mm,right=25mm]{geometry}

%% ------------------------------------------------------------------
%% Fonts. Times New Roman is the institutional body font; we reuse the
%% Tinos TTFs already vendored under paper/fonts/ (metric-compatible,
%% open-source substitute -- see paper/fonts/NOTICE.md) instead of
%% duplicating the binary font files, per the project convention of
%% preferring reuse over copies.
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
%% Core packages, kept to a minimum. array/colortbl are needed for the
%% gold-ruled student-info table; xcolor for the banner/rule/table
%% colors sampled from the source PDF.
%% ------------------------------------------------------------------
\RequirePackage{xcolor}
\RequirePackage{array}
\RequirePackage{colortbl}
\RequirePackage{multirow}
\RequirePackage{graphicx}
\RequirePackage{enumitem}
\RequirePackage[hidelinks]{hyperref}

%% Colors pixel-sampled from executive_summary_template.pdf: the
%% section banners/heading text are a solid RGB(0,86,59) dark green,
%% the student-info table rules are RGB(228,168,35) gold.
\definecolor{esgreen}{RGB}{0,86,59}
\definecolor{esgold}{RGB}{228,168,35}

\setlength{\parindent}{0pt}
\setlength{\parskip}{4pt}

%% Indonesian caption prefixes, matching thesis/thesis.cls -- so a
%% \begin{table}/\begin{figure} float here (e.g. copied from the
%% thesis table template) captions the same way as it would there.
\renewcommand\tablename{Tabel}
\renewcommand\figurename{Gambar}

%% ------------------------------------------------------------------
%% Page numbering: bottom-right on every page, ~17mm from the bottom
%% edge, matching the "6" / "7" folio position measured in the source
%% PDF (no running header otherwise).
%% ------------------------------------------------------------------
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[R]{\normalfont\normalsize\thepage}

%% ------------------------------------------------------------------
%% Institutional header fields, overridable per document.
%% ------------------------------------------------------------------
\newcommand{\summaryTitle}[1]{\gdef\es@summarytitle{#1}}
\newcommand{\es@summarytitle}{EXECUTIVE SUMMARY}
\newcommand{\summarySubtitle}[1]{\gdef\es@summarysubtitle{#1}}
\newcommand{\es@summarysubtitle}{PROPOSAL PENELITIAN TESIS}
\newcommand{\programStudi}[1]{\gdef\es@programstudi{#1}}
\newcommand{\es@programstudi}{Program Studi Magister Sains Data \& Kecerdasan Buatan}
\newcommand{\fakultas}[1]{\gdef\es@fakultas{#1}}
\newcommand{\es@fakultas}{Fakultas Ilmu Komputer \& Teknologi Informasi}
\newcommand{\universitas}[1]{\gdef\es@universitas{#1}}
\newcommand{\es@universitas}{Universitas Sumatera Utara}

\newcommand{\es@printheader}{%
  \begin{center}
    {\bfseries\large\color{esgreen}\es@summarytitle\par\es@summarysubtitle\par}
    \vspace{8pt}
    {\bfseries\es@programstudi\par\es@fakultas\par\es@universitas\par}
  \end{center}
  \vspace{4pt}
  {\color{esgreen}\rule{\linewidth}{2pt}}
  \vspace{10pt}
}

%% ------------------------------------------------------------------
%% Student-info table (Nama Mahasiswa / NIM / Calon Dosen Pembimbing),
%% gold-ruled, matching the source PDF. \calonPembimbing takes the two
%% names as its arguments; pass an empty string for a blank line to be
%% filled in by hand.
%% ------------------------------------------------------------------
\newcommand{\namaMahasiswa}[1]{\gdef\es@nama{#1}}
\newcommand{\es@nama}{}
\newcommand{\nim}[1]{\gdef\es@nim{#1}}
\newcommand{\es@nim}{}
\newcommand{\calonPembimbing}[2]{\gdef\es@pembimbingsatu{#1}\gdef\es@pembimbingdua{#2}}
\newcommand{\es@pembimbingsatu}{}
\newcommand{\es@pembimbingdua}{}

\newcommand{\es@printstudenttable}{%
  % \arraystretch is scoped by this group like any other macro, but
  % colortbl's \arrayrulecolor is documented as a global setting that
  % \begingroup/\endgroup can't undo -- it has to be reset back to
  % black explicitly below, or every \hline typeset later in main.tex
  % (e.g. a results/data table using the plain thesis table template)
  % would otherwise keep drawing gold rules for the rest of the page.
  \begingroup
  \arrayrulecolor{esgold}
  \renewcommand{\arraystretch}{1.6}
  \noindent\begin{tabular}{|l|p{0.55\linewidth}|}
    \hline
    \bfseries Nama Mahasiswa & \es@nama \\
    \hline
    \bfseries NIM & \es@nim \\
    \hline
    \multirow{2}{*}{\bfseries Calon Dosen Pembimbing}
      & 1. \es@pembimbingsatu \\
    \cline{2-2}
      & 2. \es@pembimbingdua \\
    \hline
  \end{tabular}
  \endgroup
  \arrayrulecolor{black}
  \vspace{10pt}
}

%% ------------------------------------------------------------------
%% Numbered section banners: full-width filled bar (esgreen background,
%% white bold text), auto-numbered "<n>. <title>", matching the source
%% PDF's "1. Judul Penelitian" style headers.
%% ------------------------------------------------------------------
\newcounter{essection}
\newcommand{\essection}[1]{%
  \par\vspace{8pt}%
  \refstepcounter{essection}%
  \noindent\colorbox{esgreen}{%
    \parbox[c][20pt]{\dimexpr\linewidth-2\fboxsep\relax}{%
      \color{white}\bfseries\theessection.~#1}}\par
  \vspace{6pt}%
}

%% Bracketed placeholder instructions, italicized as in the source PDF.
\newenvironment{esinstruction}{\itshape}{\par\vspace{4pt}}

%% Bold-lead sub-points within a section (e.g. "Konteks Masalah:"),
%% each followed by an italicized instruction, as an unordered list.
\newenvironment{espoints}{%
  \sloppy
  \begin{itemize}[leftmargin=14pt,itemsep=6pt,topsep=2pt]
}{%
  \end{itemize}\vspace{4pt}%
}
\newcommand{\espoint}[2]{\item \textbf{#1:} \textit{#2}}

%% ------------------------------------------------------------------
%% Assemble the fixed header (title block, rule, student table)
%% automatically at \begin{document}, so main.tex only supplies the
%% six numbered sections.
%% ------------------------------------------------------------------
\AtBeginDocument{%
  \es@printheader
  \es@printstudenttable
}

%% ------------------------------------------------------------------
%% PDF metadata
%% ------------------------------------------------------------------
\AtBeginDocument{\hypersetup{pdftitle={\es@summarytitle\ -- \es@summarysubtitle}}}

\endinput
