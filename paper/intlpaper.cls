%% intlpaper.cls
%% Reusable class (template) for international research papers.
%% Two-column, IEEE-style layout. Compile with XeLaTeX only.
%%
%% Keep all paper-specific content out of this file; write it in a
%% separate .tex file that loads this class with \documentclass{intlpaper}.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{intlpaper}[2026/08/15 v1.0 International research paper template]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[10pt,twocolumn,a4paper]{article}

%% ------------------------------------------------------------------
%% Engine check: this class relies on fontspec, so it must be built
%% with XeLaTeX (or LuaLaTeX).
%% ------------------------------------------------------------------
\ifdefined\XeTeXversion\else
  \ifdefined\directlua\else
    \ClassError{intlpaper}{This class requires XeLaTeX or LuaLaTeX}%
      {Compile this document with: xelatex main.tex}
  \fi
\fi

%% ------------------------------------------------------------------
%% Page geometry (A4, the international standard; matches common
%% IEEE conference/journal margins)
%% ------------------------------------------------------------------
\RequirePackage{geometry}
\geometry{
  a4paper,
  top=19mm,
  bottom=25mm,
  left=14.3mm,
  right=14.3mm,
  columnsep=4.2mm,
  headheight=0mm,
  headsep=0mm
}

%% ------------------------------------------------------------------
%% Fonts (Tinos = metric-compatible, open-source Times New Roman
%% substitute, shipped in fonts/ alongside this class)
%% ------------------------------------------------------------------
\RequirePackage{fontspec}
\setmainfont{Tinos}[
  Path         = fonts/,
  Extension    = .ttf,
  UprightFont  = *-Regular,
  BoldFont     = *-Bold,
  ItalicFont   = *-Italic,
  BoldItalicFont = *-BoldItalic
]
\setmonofont{Latin Modern Mono}[Scale=0.92]
\frenchspacing

%% ------------------------------------------------------------------
%% Core packages (kept to a minimum on purpose)
%% ------------------------------------------------------------------
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage[hidelinks]{hyperref}

\pagestyle{plain}

%% ------------------------------------------------------------------
%% Section headings: centered, bold, small caps, roman-numbered --
%% built with the LaTeX kernel's own \@startsection, no titlesec.
%% ------------------------------------------------------------------
\renewcommand\thesection{\Roman{section}}
\renewcommand\thesubsection{\Alph{subsection}}
\renewcommand\thesubsubsection{\arabic{subsubsection}}

\renewcommand\section{\@startsection
  {section}{1}{0pt}
  {3.0ex plus 1ex minus .2ex}
  {1.2ex plus .2ex}
  {\centering\normalfont\bfseries\MakeUppercase}}

\renewcommand\subsection{\@startsection
  {subsection}{2}{0pt}
  {2.2ex plus 1ex minus .2ex}
  {0.8ex plus .2ex}
  {\normalfont\bfseries\itshape}}

\renewcommand\subsubsection{\@startsection
  {subsubsection}{3}{0pt}
  {1.8ex plus .8ex minus .2ex}
  {0.5ex plus .2ex}
  {\normalfont\itshape}}

%% ------------------------------------------------------------------
%% Captions: "Fig. N." below figures, "TABLE N" above tables,
%% centered when short, hanging when long -- no caption package.
%% ------------------------------------------------------------------
\renewcommand\figurename{Fig.}
\renewcommand\tablename{TABLE}
\renewcommand\thetable{\Roman{table}}

\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\footnotesize #1.\ #2}%
  \ifdim\wd\@tempboxa>\hsize
    {\footnotesize #1.\ #2\par}%
  \else
    \global\@minipagefalse
    \hbox to\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

%% ------------------------------------------------------------------
%% Title block
%% ------------------------------------------------------------------
\newcommand{\@paperauthors}{}
\newcommand{\paperauthors}[1]{\gdef\@paperauthors{#1}}

%% Building block for a single author entry: name, affiliation
%% (multi-line via \\), and email/ORCID. Meant to be placed inside a
%% minipage row passed to \paperauthors.
\newcommand{\authorblock}[3]{%
  \begin{minipage}[t]{0.30\textwidth}
    \centering
    {\large #1}\\[2pt]
    {\normalsize\itshape #2}\\[2pt]
    {\normalsize\ttfamily #3}
  \end{minipage}%
}

\renewcommand{\maketitle}{%
  \twocolumn[{%
    \begin{center}
      {\LARGE\bfseries \@title \par}
      \vskip 2em
      \@paperauthors
      \vskip 1.5em
    \end{center}
  }]%
  \saythanks
}
\newcommand{\saythanks}{}

%% ------------------------------------------------------------------
%% Abstract and keywords: styled as a lead-in paragraph, IEEE-style,
%% not article.cls's default boxed/quote abstract.
%% ------------------------------------------------------------------
\renewenvironment{abstract}{%
  \noindent\textbf{\textit{Abstract---}}\ignorespaces
}{%
  \par\vskip 0.8em
}

\newenvironment{keywords}{%
  \noindent\textbf{\textit{Keywords---}}\ignorespaces
}{%
  \par\vskip 1em
}

%% ------------------------------------------------------------------
%% PDF metadata, filled in from \title/\author at load time
%% ------------------------------------------------------------------
\AtBeginDocument{%
  \hypersetup{pdftitle={\@title}}
}

\endinput
