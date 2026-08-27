% hacked around by j for uz-exam for latex   aug 94 
% mostly stolen from Gary Nelson's uz-exam.sty for TeX
% based upon ARTICLE STANDARD DOCUMENT STYLE -- Released 14 Jan 1992
%    for LaTeX version 2.09
% Copyright (C) 1992 by Leslie Lamport

\LoadClass[12pt]{article}
\typeout{james' LaTeX2e package `uz-exame' <jul 95>.}
\newcount\@scount
	\@scount=2
\newcount\@qcount
\newcount\@pcount
\def\examskip{\bigskip}

 % boxpage.sty from latex-help
 \newdimen\PageboxWidth \PageboxWidth=170truemm
 \newdimen\PageboxHeight \PageboxHeight=250truemm
 \newdimen\PageboxOddoffset \PageboxOddoffset=28mm
 \newdimen\PageboxEvenoffset \PageboxEvenoffset=\PageboxOddoffset
 \newdimen\PageboxTopMargin \PageboxTopMargin=18mm
 \newdimen\PageboxRuleThickness \PageboxRuleThickness=1pt


\def\labelenumi{(\theenumi)}
\def\theenumi{\alph{enumi}}

\def\labelenumii{(\theenumii)}
\def\theenumii{\roman{enumii}}
\def\p@enumii{\theenumi}

\def\labelenumiii{(\theenumiii)}
\def\theenumiii{\alph{enumiii}}
\def\p@enumiii{\theenumi(\theenumii)}

\def\labelenumiv{\theenumiv.}
\def\theenumiv{\Roman{enumiv}}
\def\p@enumiv{\p@enumiii\theenumiii}

\def\labelitemi{$\m@th\bullet$}
\def\labelitemii{\bf --}
\def\labelitemiii{$\m@th\ast$}
\def\labelitemiv{$\m@th\cdot$}

\def\theequation{\arabic{equation}}
\def\marks#1{\unskip~\hfill[#1]}
\newcounter{exsec}
\setcounter{exsec}{1}
\newcounter{quest}
\setcounter{quest}{0}
\newenvironment{question}{\addtocounter{quest}{1}
\begin{description}\item[{\Alph{exsec}}{\arabic{quest}}.$\:$]}
{\end{description} \examskip }
%\newenvironment{question}{\addtocounter{quest}{1}
%{{\bf \Alph{exsec}}{\arabic{quest}}.~}}
%{\examskip}


%  The double backslash \\ may occur between two course numbers, as in
%  HMT225\\MT305.  In the upper right corner of the first page, it means
%  the first number should occur on top of the second.  (The definition 
%  below is inelegant, but it's the best I could think of, and it works.)
%

\def\@splitcoursenumbers{\def\\{\break\phantom{}\hfill}}
	\@qcount=-5
	\def\lastA#1{\@qcount=#1}
\@pcount=-5
\def\lastpage#1{\@pcount=#1}
\def\qskip{\filbreak\bigskip\bigskip}

\relpenalty=1000 \binoppenalty=1400
%  Option to prevent line breaks in the middle of equations
\def\noeqbreaks{\relpenalty=10000 \binoppenalty=10000}

%   ***************
%   *   Heading   *
%   ***************
%
%  This is how the definitions SHOULD be made for inputing needed information:
%
\def\coursenumber#1{\gdef\@coursenumber{#1}}
\def\examtitle#1{\gdef\@examtitle{#1}}
\def\coursename#1{\gdef\@coursename{#1}}
\def\examdate#1{\gdef\@examdate{#1}}
\def\hours#1{\gdef\@hours{#1}}
\def\rubric#1{\gdef\@rubric{#1}}

\long\def\@ifundefined#1#2#3{\expandafter\ifx\csname
  #1\endcsname\relax#2\else#3\fi}
%
\@ifundefined{coursenumber}{\def\coursenumber#1{\gdef\@coursenumber{#1}}}
  {\gdef\@coursenumber{}}
\@ifundefined{examtitle}{\def\examtitle#1{\gdef\@examtitle{#1}}}{}
\@ifundefined{coursename}{\def\coursename#1{\gdef\@coursename{#1}}}{}
\@ifundefined{examdate}{\def\examdate#1{\gdef\@examdate{#1}}}{}
\@ifundefined{hours}{\def\hours#1{\gdef\@hours{#1\ HOURS}}}{}
\@ifundefined{rubric}{\def\rubric#1{\gdef\@rubric{#1}}}{}

%
%  First decide what to do if various parameters are not defined by the user.
%
  \def\@nocoursenumber{
    \write{===UZ=Exam===> Warning: Don't forget the course number.}}
  \def\@noexamtitle{{\tt$\backslash$examtitle} {\sl MISSING} !!!%
    \write16{===UZ=Exam===> Warning: Don't forget the exam title.}}
  \def\@nocoursename{%
    \write16{===UZ=Exam===> Warning: No course name; did you want one?}}
  \def\@noexamdate{{\tt$\backslash$examdate} {\sl MISSING} !!!
    \write16{===UZ=Exam===> Warning: Don't forget the exam date.}}
  \def\@nohours{???\write16{===UZ=Exam===> Warning: Don't forget the hours.}}
 \def\@norubric{{\tt$\backslash$rubric} {\sl MISSING} !!!
    \write16{===UZ=Exam===> Warning: Don't forget the rubric.}}

%
%  Now make the heading.
%
\def\makeheading{
 \centerline{\hfill{\LARGE UNIVERSITY OF ZIMBABWE}\hfill\llap{%
    \vbox{\hfill\@ifundefined{@coursenumber}
      {\@nocoursenumber}
      {\@splitcoursenumbers\@coursenumber} }}}
   \bigskip
  \centerline{\underbar{%
    \@ifundefined{@examtitle}{\@noexamtitle}{\@examtitle}}}
  \@ifundefined{@coursename}
    {\@nocoursename}
    {\bigskip\centerline{\sc\@coursename}}
   \bigskip\medskip
   \noindent
  \@ifundefined{@examdate}{\@noexamdate}{\@examdate} \\
   %\medskip
   \noindent%
  {\small Time : \@ifundefined{@hours}{\@nohours}{\@hours} hours}
   \vskip1truecm
   \noindent
  \@ifundefined{@rubric}{\@norubric}{\@rubric}
   \bigskip
 

 \@tempdima=\PageboxOddoffset
		\advance\@tempdima by -1in
		\moveleft\@tempdima \vbox to 1pt{
 \hsize=\PageboxWidth\parindent=0pt\parfillskip=0pt\parskip=0pt
 \hrule height \PageboxRuleThickness width \PageboxWidth }              
   \bigskip
  \let\makeheader=\relax
    \gdef\@examtitle{} \gdef\@coursename{}  \gdef\@examdate{}
    \gdef\@time{}      \gdef\@rubric{} }
    

%  Macro to end the exam paper
%
\def\endexam{
   \vfill
  \centerline{\bf END OF QUESTION PAPER}
  \medskip
    \ifnum\number\@pcount<\thepage
    {\write16{===UZ=Exam===>  
       Warning: The last page number is wrong!}}\fi
  \ifnum\number\@pcount>\thepage
    {\write16{===UZ=Exam===>  
       Warning: The last page number may be wrong!}}\fi
 }

%  ************************
%  *   Standard Rubrics   *
%  ************************
%
\def\enginI{Candidates may attempt at most SIX questions.  Full marks can be 
  obtained for complete solutions to FIVE questions.  Candidates are advised 
  that it is in their own interest to concentrate on obtaining complete 
  solutions to questions rather than producing fragmentary answers to a larger 
  number of questions.}
\def\enginII{Candidates may attempt ALL questions from Section A and 
  one question from each of the sections B to E. Each question should 
  start on a fresh page.}
\def\enginIIo{Candidates may attempt at most THREE questions from each section, 
  i.e.\ at most six questions altogether.  Full marks can be obtained for 
  complete solutions to FIVE questions.  Candidates are advised 
  that it is in their own interest to concentrate on obtaining complete 
  solutions to questions rather than producing fragmentary answers to a larger 
  number of questions.}
\def\honold{Candidates may attempt ALL questions.  Full marks can be obtained 
  for complete solutions to FOUR questions.  Candidates are advised 
  that it is in their own interest to concentrate on obtaining complete 
  solutions to questions rather than producing fragmentary answers to a larger 
  number of questions.}
\def\honoursold{Candidates may attempt ALL questions.  Full marks will be
  awarded for well-presented complete answers to about FOUR questions.}
\def\honours{Candidates may attempt AT MOST FOUR questions.}
\def\mscol{Candidates may attempt ALL questions.  Full marks will be
  awarded for well-presented complete answers to about FOUR questions.}
\def\msc{Candidates may attempt AT MOST FOUR questions.}
\def\mscold{Candidates may attempt ALL questions.  Full marks can be 
obtained for complete solutions to THREE questions.  Candidates are advised
  that it is in their own interest to concentrate on obtaining complete 
  solutions to questions rather than producing fragmentary answers to a larger 
  number of questions.}
\def\science{Candidates may attempt ALL questions in Section A and at most 
  TWO questions in Section B.  Each question should start on a fresh page.}
\def\scienceo{Candidates may attempt ALL questions in Section A and at most 
  THREE questions in Section B.  Each question should start on a fresh page.}
\def\acho{Candidates may attempt BOTH questions in Section A and at most 
  THREE questions in Section B.\newline N.B. All the symbols have their usual 
meanings.}
\def\cw{We shall attempt ALL questions on this sheet!}

  % The science rubric also redefines \sectionA and \sectionB

\newcommand{\multsec}[1]{
    \setcounter{exsec}{\number\@scount} 
    \centerline{\bf SECTION \Alph{exsec}: #1}
    \advance\@scount by 1 
    \setcounter{quest}{0}
  \bigskip\bigskip}
  
\def\sectionA{
  \centerline{\bf SECTION A}
    \setcounter{exsec}{1}
   \bigskip\bigskip}

\gdef\sectionB{
%   \ifdim\lastskip=0pt \qskip\bigskip \else\bigskip \fi
   \setcounter{exsec}{2}
   \centerline{\bf SECTION B}
   \bigskip\bigskip}

\def\sectionAscience{
  \centerline{{\bf SECTION A} \ (40 marks)}
   \setcounter{exsec}{1}
   \medskip
    \noindent%
  Candidates may attempt ALL questions being careful to number them A1 to 
  A{\ifnum\@qcount>0{\number\@qcount}\else ?\fi}.  
%Each question A1 to 
%  A{\ifnum\@qcount>0{\number\@qcount}\else ?
%%    \write16{===UZ=Exam===> Warning: lastA missing or negative.}
%\fi   }
%  should start on a fresh page.
   \bigskip}

\gdef\sectionBscience{
   %\ifdim\lastskip=0pt \qskip\bigskip \else\bigskip \fi
   \bigskip 
  \centerline{{\bf SECTION B} \ (60 marks)}
   \medskip
  \setcounter{exsec}{2} 
  \noindent%
  Candidates may attempt TWO questions being careful to number them 
    \advance\@qcount by 1
  B{\ifnum\@qcount>0{\number\@qcount}\else ?\fi} to 
    \advance\@qcount by 3
  B{\ifnum\@qcount>0{\number\@qcount}\else ?\fi}.
   \bigskip}

\def\@redefinesections{
  \global\let\sectionA=\sectionAscience
  \global\let\sectionB=\sectionBscience}


%\def\sectionAscience{
%  \centerline{{\bf SECTION A} \ (40 marks)}
%  \vskip .5cm
%  Candidates may attempt ALL questions being careful to number them A1 to 
%  A{\@lastA}.  Each question A1 to A{\@lastA}
%  should start on a fresh page.
% }

%\def\sectionBscience{
%  \centerline{{\bf SECTION B} \ (60 marks)}
%   \vskip .5cm
%  
%  Candidates may attempt THREE questions being careful to number them 
% B{\arabic{\value{firstB}}} to B\arabic{\value{lastB}}.
%}

% Save file as: FULLPAGE.STY           Source: FILESERV@SHSU.BITNET  
% This is FULLPAGE.STY by H.Partl, Version 2 as of 15 Dec 1988.
% Document Style Option to fill the paper just like Plain TeX.
     
% \typeout{Style Option FULLPAGE Version 2 as of 15 Dec 1988}
     
\topmargin 0pt
\advance \topmargin by -\headheight
\advance \topmargin by -\headsep
     
\textheight 238mm
\oddsidemargin 0pt
\evensidemargin \oddsidemargin
\marginparwidth 0.5in     
\textwidth 6.5in

 
 \def\@outputpage{\begingroup\catcode`\ =10
      \let\-\@dischyph \let\'\@acci \let\`\@accii \let\=\@acciii
     \if@specialpage
      \global\@specialpagefalse\@nameuse{ps@\@specialstyle}\fi
      \if@twoside
	\ifodd\count\z@ \let\@thehead\@oddhead \let\@thefoot\@oddfoot
	     \let\@themargin\oddsidemargin
	   \else \let\@thehead\@evenhead
	   \let\@thefoot\@evenfoot \let\@themargin\evensidemargin
      \fi\fi
      \shipout
      \vbox{\reset@font %% RmS 91/08/15
	    \normalsize \baselineskip\z@ \lineskip\z@
	    \let\par\@@par %% 15 Sep 87
 %%
		\ifodd\count0 \@tempdima=\PageboxOddoffset \else \@tempdima=\PageboxEvenoffset \fi
		\advance\@tempdima by -1in
		\moveleft\@tempdima\vbox to 0pt{\vskip -1in\vskip\PageboxTopMargin
			\hsize=\PageboxWidth\parindent=0pt\parfillskip=0pt\parskip=0pt
			\hrule height \PageboxRuleThickness
			\leavevmode
			\hbox to\PageboxWidth{\vrule width \PageboxRuleThickness height \PageboxHeight
				\hfill
				\vrule width \PageboxRuleThickness}%
			\hrule height \PageboxRuleThickness\vss}%
 %%
	    \vskip \topmargin \moveright\@themargin
	    \vbox{\setbox\@tempboxa
		    \vbox to\headheight{\vfil \hbox to\textwidth
					{\let\label\@gobble \let\index\@gobble
					 \let\glossary\@gobble %% 21 Jun 91
					  \@thehead}}% %% 22 Feb 87
		  \dp\@tempboxa\z@
		  \box\@tempboxa
		  \vskip \headsep
		  \box\@outputbox
		  \baselineskip\footskip
		  \hbox to\textwidth{\let\label\@gobble
			    \let\index\@gobble  %% 22 Feb 87
			    \let\glossary\@gobble %% 21 Jun 91
			    \@thefoot}}}\global\@colht\textheight
	    \endgroup\stepcounter{page}\let\firstmark\botmark}


\def\ps@myheadings{\let\@mkboth\@gobbletwo
\def\@nosplitcoursenumber{\def\\{/}}
\def\@oddhead{
\ifnum\count0>1
    \@ifundefined{@coursenumber}{}
{\hfill {\footnotesize 
    \@nosplitcoursenumber\@coursenumber}}
\fi

\ifnum\count0=1 {\hfill}\fi
}
\def\@oddfoot{ \hfill page~\thepage~of~{\number\@pcount}}
}

\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}

\ps@myheadings
\pagenumbering{arabic}
\if@twoside\else\raggedbottom\fi
\if@twocolumn
 \@@input twocolum.sty\relax
\else
 \onecolumn
\fi
\endinput
