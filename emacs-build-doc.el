;;; emacs-build-doc.el --- Script to convert an `org' document into a PDF via a script.  -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Alexander Brown

;; Author: Alexander Brown <a01704744@usu.edu>
;; Keywords: docs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
(require 'oc nil t)
(require 'org nil t)
(require 'ox nil t)

;; Output where we are
(message "The current directory is %s" default-directory)

;;------------------------------------------------------------------------------
;; Configuration
(setq
 org-latex-hyperref-template ""
 org-latex-default-packages-alist '()
 org-cite-global-bibliography `(,(concat (getenv "HOME") "/Documents/citation-database/lit-ref.bib")
                                ,(concat (getenv "HOME") "/Documents/citation-database/lib-ref.bib"))
 org-startup-with-inline-images t                                               ; Display images by default
 org-display-remote-inline-images 'download                                     ; Download web images
 org-export-with-smart-quotes t                                                 ; Put the correct quotes
 org-export-headline-levels   5                                                 ; Max level that `org' will export a
 org-latex-prefer-user-labels 1                                                 ; Use user labels, not gereated ones
 org-confirm-babel-evaluate nil                                                 ; Just run the code
 org-image-actual-width nil                                                     ; Don't use actual image size when
                                                                                ; header to LaTeX
 search-invisible t                                                             ; Include links in `isearch'
 org-highlight-latex-and-related '(native latex script entities)
 org-latex-prefer-user-labels 1                                                 ; Use user labels, not gereated ones
 org-plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar"
 )

;; `org-babel' languages
(org-babel-do-load-languages

 'org-babel-load-languages
 '(
   (emacs-lisp . t)
   (latex      . t)
   (octave     . t)
   (plantuml   . t)
   ))

;; Create new `article' class for `org-latex-classes'
(with-eval-after-load 'org
  (add-to-list 'org-latex-classes
               '("dummy" ""
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("FrontiersinHarvard"
                 "\\documentclass[utf8]{FrontiersinHarvard}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("mdpi"
                 "\\documentclass[energies,article,submit,moreauthors]{Definitions/mdpi}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list
   'org-latex-classes
   '("usuproposal"
     "\\documentclass[ee,proposal]{usuthesis}"
     ("\\chapter{%s}" . "\\chapter*{%s}")
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
     ("\\paragraph{%s}" . "\\paragraph*{%s}")
     ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list
   'org-latex-classes
   '("usuthesis"
     "\\documentclass[ee,thesis]{usuthesis}"
     ("\\chapter{%s}" . "\\chapter*{%s}")
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
     ("\\paragraph{%s}" . "\\paragraph*{%s}")
     ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list
   'org-latex-classes
   '("usudissertation"
     "\\documentclass[ee,dissertation]{usuthesis}"
     ("\\chapter{%s}" . "\\chapter*{%s}")
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
     ("\\paragraph{%s}" . "\\paragraph*{%s}")
     ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


  (add-to-list 'org-latex-classes
               '("article"
                 "\\documentclass[11pt,a4paper,final]{article}
\\usepackage[a4paper, total={7in, 10in}]{geometry}
\\usepackage{booktabs}
\\usepackage{subcaption}
\\usepackage{graphicx}
\\usepackage{tikz}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Create new `ebook' class for `org-latex-classes'
(add-to-list 'org-latex-classes '("ebook"
                                  "\\documentclass[11pt, oneside]{memoir}
\\setstocksize{9in}{6in}
\\settrimmedsize{\\stockheight}{\\stockwidth}{*}
\\setlrmarginsandblock{2cm}{2cm}{*} % Left and right margin
\\setulmarginsandblock{2cm}{2cm}{*} % Upper and lower margin
\\checkandfixthelayout
% Much more laTeX code omitted
"
                                  ("\\chapter{%s}" . "\\chapter*{%s}")
                                  ("\\section{%s}" . "\\section*{%s}")
                                  ("\\subsection{%s}" . "\\subsection*{%s}"))))

;; Build PDF
(progn
  (find-file "main.org")
  (message "The current buffer is %s" (current-buffer))
  (org-mode)
  (org-latex-export-to-pdf))

;;; emacs-build-doc.el ends here
