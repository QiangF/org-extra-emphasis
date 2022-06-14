;;; org-extra-emphasis.el --- Extra Emphasis markers for Org -*- lexical-binding: t; coding: utf-8-emacs; -*-

;; Copyright (C) 2022 Jambunathan K <kjambunathan at gmail dot com>
;; Copyright (C) 2004-2022 Free Software Foundation, Inc.

;; Author: Jambunathan K <kjambunathan at gmail dot com>
;; Keywords: org
;; Homepage: https://github.com/kjambunathan/org-extra-emphasis
;; Version: 1.0
;; Package-Requires: ((ox-odt "9.5.3.467"))

;; This file is NOT part of GNU Emacs.

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Overview
;; ========
;;
;; This library provides two additional markers `!!' and `!@' over
;; and above those in `org-emphasis-alist'.'
;;
;; - Text enclosed in `!!' is highlighted in yellow, and exported likewise
;; - Text enclosed in `!@' is displayed in red, and exported likewise
;;
;; Following backends are supported: HTML and ODT. For export of extra
;; emphasis markers to the ODT side, you need
;; [[https://github.com/kjambunathan/org-mode-ox-odt][Enhanced ODT]]
;; exporter with version >= 9.5.3.467 (dtd. June 14, 2022 IST).  This
;; is the first version of the exporter that defines the user option
;; `org-odt-extra-styles'.
;;
;; Example
;; =======
;;
;; Setup
;; =====
;;
;; Add the following to your `user-init-file' and restart Emacs.
;;
;;    (requrie 'org-extra-emphasis)
;;
;; Test Run
;; ========
;;
;; 1. Create an `org' file, say `org-export-emphasis.org' and fill it
;;    with following content or you can download the file from
;;    https://raw.githubusercontent.com/kjambunathan/org-extra-emphasis/main/org-extra-emphasis.org

	  ;; #+TITLE: Test file for ==org-extra-emphasis== library

	  ;; * Demo of extra emphasis markers ==!!== and ==!@==

	  ;; !!Ea consectetur laboris adipiscing et ipsum labore esse qui minim
	  ;; pariatur et sunt sunt nostrud anim laborum culpa.!!

	  ;; !@Minim reprehenderit excepteur elit, dolore elit, veniam, eu.
	  ;; Ullamco dolore elit, cupidatat sed labore ea aute.!@

	  ;; Pariatur !!et lorem cupidatat !@minim irure!@ proident, ad.!!  Eiusmod
	  ;; sunt et lorem labore ex aliqua aute esse.

	  ;; Ut mollit !@duis velit est est magna in quis ipsum.  !!Aliqua aliqua
	  ;; non laboris exercitation cupidatat aliqua incididunt.!!  Qui voluptate
	  ;; irure aute occaecat laborum cillum est.!@  Quis magna dolor ullamco
	  ;; magna do consectetur est laborum enim ut.

	  ;; * !!Demo of extra emphasis markers in a styled paragraph!!

	  ;; #+ATTR_ODT: :target "extra_styles"
	  ;; #+begin_src nxml
	  ;; <style:style style:name="Warn"
	  ;; 	     style:parent-style-name="Text_20_body"
	  ;; 	     style:family="paragraph">
	  ;;   <style:paragraph-properties>
	  ;;     <style:tab-stops />
	  ;;   </style:paragraph-properties>
	  ;;   <style:text-properties fo:background-color="#ff0000"
	  ;; 		       fo:color="#ffffff"
	  ;; 		       fo:font-size="20pt"
	  ;; 		       fo:font-style="italic"
	  ;; 		       fo:font-weight="bold" />
	  ;; </style:style>
	  ;; #+end_src

	  ;; #+ATTR_ODT: :style "Warn"
	  ;; Proident, duis dolore consectetur sed nisi ea pariatur.  Esse
	  ;; proident, cillum duis qui ullamco sint cillum magna.  !!Eiusmod
	  ;; veniam, !@sint officia!@ non consectetur laboris cillum.!!  Cillum
	  ;; mollit consequat eu dolore ullamco qui reprehenderit anim cillum
	  ;; in consectetur consequat sunt dolore aliquip voluptate
	  ;; consectetur anim ea.  Voluptate nisi est incididunt aliquip
	  ;; excepteur aliqua id do enim ut non consequat.
;;
;; 2. Note that portions of text marked with `!!' and `!@' are fontified as described above.
;;
;; 3. Export the file to HTML with `C-c C-e h O'.
;;
;;    Note that the text enclosed in the above emphasis markers are
;;    colorized in HTML file.
;;
;; 4. Export the file to ODT with `C-c C-e o O'.
;;
;;    Note that the text enclosed in the above emphasis markers are
;;    colorized in ODT file.
;;
;; The HTML, ODT, PDF generated in steps (3) and (4) above are
;; available at https://github.com/kjambunathan/org-extra-emphasis and
;; the screenshots can be seen in https://github.com/kjambunathan/org-extra-emphasis/tree/main/screenshots
;;
;; Customization
;; =============

;; Customize `org-extra-emphasis-alist' to set the emphasis markers
;; and their associated faces.  When choosing your own marker, ensure
;; that you exercise some care.  For example, if you choose `#' as a
;; marker you are likely to get malformed `html' and `odt' files.
;;
;; This library defines two faces `org-extra-emphasis-1'and
;; `org-extra-emphasis-2'.
;;
;; You can use `M-x org-extra-emphasis-mode' to toggle this feature.
;;
;; To add additional backends, modify `org-extra-emphasis-formatter'
;; and `org-extra-emphasis-build-backend-regexp'.

;;; Code:

(require 'org)
(require 'ox-odt)
(require 'rx)
(require 'htmlfontify)

;;; Internal Variables

(defvar org-extra-emphasis-backends
  '(html odt))

(defvar org-extra-emphasis-info
  (list :enabled nil))

;; Helper snippets to convert a Emacs Face to Inine CSS and ODT Text Properties
;;
;; (defun org-extra-emphasis-emacs-face->inline-css (face)
;;   (let ((s (cdr (hfy-face-to-css-default face))))
;;     (when (string-match (rx-to-string '(and "{" (group (zero-or-more any)) "}")) s)
;;       (format "<span style=\"%s\">%%s</span>" (match-string 1 s)))))
;;
;; (org-extra-emphasis-emacs-face->inline-css 'hi-yellow)
;; (org-extra-emphasis-emacs-face->inline-css 'hi-red-b)
;;
;; (defun org-extra-emphasis-emacs-face->odt-text-properties (face)
;;   (org-odt--lisp-to-xml
;;    (assoc 'style:text-properties
;;	  (org-odt--xml-to-lisp
;;	   (cdr (org-odt-hfy-face-to-css face))))))
;;
;; (org-extra-emphasis-emacs-face->odt-text-properties 'hi-yellow)
;; (org-extra-emphasis-emacs-face->odt-text-properties 'hi-red-b)

(defun org-extra-emphasis-update (&rest _ignored)
  "Workhorse function that responds to configuration changes.

Current state is maintined in `org-extra-emphasis-info', a plist."
  ;; When `org-extra-emaphasis' is ON, override use
  ;; `org-extra-emphasis-org-do-emphasis-faces'.
  ;; Otherwise, use `org-do-emphasis-faces'.
  (cond
   ((plist-get org-extra-emphasis-info :enabled)
    (advice-add 'org-do-emphasis-faces :override
		'org-extra-emphasis-org-do-emphasis-faces))
   (t
    (advice-remove 'org-do-emphasis-faces
		   'org-extra-emphasis-org-do-emphasis-faces)))
  ;; `org-extra-emphasis-alist' is effective only if
  ;; `org-extra-emphasis' is enabled.
  (plist-put org-extra-emphasis-info :work-alist
	     (when (plist-get org-extra-emphasis-info :enabled)
	       (plist-get org-extra-emphasis-info :alist)))
  ;; Set properties that control fontification.
  ;; The property names and their values mimics the corresponding
  ;; variables in `org-set-emph-re'.
  (plist-put org-extra-emphasis-info :org-emphasis-alist
	     (when (and (boundp 'org-emphasis-regexp-components)
			org-emphasis-alist org-emphasis-regexp-components)
	       (append (plist-get org-extra-emphasis-info :work-alist)
		       org-emphasis-alist)))
  (plist-put org-extra-emphasis-info :org-emph-re-template
	     (when (and (boundp 'org-emphasis-regexp-components)
			org-emphasis-alist org-emphasis-regexp-components)
	       (pcase-let*
		   ((`(,pre ,post ,border ,body ,nl) org-emphasis-regexp-components)
		    (body (if (<= nl 0) body
			    (format "%s*?\\(?:\n%s*?\\)\\{0,%d\\}" body body nl))))
		 (format (concat "\\([%s]\\|^\\)" ;before markers
				 "\\(\\(%%s\\)\\([^%s]\\|[^%s]%s[^%s]\\)\\3\\)"
				 "\\([%s]\\|$\\)") ;after markers
			 pre border border body border post))))
  (plist-put org-extra-emphasis-info :org-emph-re
	     (format (plist-get org-extra-emphasis-info :org-emph-re-template)
		     (rx-to-string
		      `(or ,@(mapcar #'car
				     (cl-remove-if (lambda (l)
						     (eq 'verbatim (nth 2 l)))
						   (plist-get org-extra-emphasis-info :org-emphasis-alist)))))))
  (plist-put org-extra-emphasis-info :org-verbatim-re
	     (format (plist-get org-extra-emphasis-info :org-emph-re-template)
		     (rx-to-string
		      `(or ,@(mapcar #'car
				     (cl-remove-if-not (lambda (l)
							 (eq 'verbatim (nth 2 l)))
						       (plist-get org-extra-emphasis-info :org-emphasis-alist)))))
		     (rx-to-string
		      `(or ,@(mapcar #'car
				     (cl-remove-if-not (lambda (l)
							 (eq 'verbatim (nth 2 l)))
						       (plist-get org-extra-emphasis-info :org-emphasis-alist)))))))
  ;; Set properties that control Export backends
  ;; - Regexp to search for in the final exported document
  (plist-put org-extra-emphasis-info :export-alist
	     (org-extra-emphasis-build-backend-regexp))

  ;; - Generate ODT character styles for the extra emphasis faces and
  ;;   dump those in `org-odt-extra-styles'.
  (plist-put org-extra-emphasis-info :odt-extra-styles
	     (let* ((odt-styles
		     (concat (mapconcat #'identity
					(cl-loop for (_marker face) in (plist-get org-extra-emphasis-info :alist)
						 collect (cdr (org-odt-hfy-face-to-css face)))
					"\n\n"))))
	       (with-no-warnings
		 (unless (boundp 'org-odt-extra-styles)
		   (message "`org-odt-extra-styles' not found.  Upgrade to `ox-odt-9.5.3.467' or later.")
		   (sleep-for 2)
		   (setq org-odt-extra-styles nil))
		 (setq org-odt-extra-styles
		       (concat (or org-odt-extra-styles "")
			       "\n\n"
			       odt-styles))
		 (message "`org-odt-extra-styles' is updated for this session")
		 (sleep-for 1))
	       odt-styles))
  ;; Re-fontify all Org buffers based on current configuration.
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when (derived-mode-p 'org-mode)
	(font-lock-flush)))))

;;; Fontify Extra Emphasis Markers

(defun org-extra-emphasis-org-do-emphasis-faces (limit)
  "Workhorse function that does fontification This function is
based on `org-do-emphasis-faces'.  The property names and values
correspond to the variables used in `org-do-emphasis-faces'.  Key
differences are:

    - `:org-emphasis-alist' includes entries for both standard
      emphasis markers and extra emphasis markers.

    - The regexes used for search-based fontification allow for
      the possibility that the emphasis markers _in all
      likelihood_ are multi-char strings, as opposed to single
      chars."
  (let* ((quick-re (format "\\([%s]\\|^\\)\\(%s\\)"
			   (car org-emphasis-regexp-components)
			   (rx-to-string
			    `(or ,@(mapcar #'car (plist-get org-extra-emphasis-info :org-emphasis-alist)))))))
    (catch :exit
      (while (re-search-forward quick-re limit t)
	(let* ((marker (match-string 2))
	       (verbatim? (member marker '("~" "="))))
	  (when (save-excursion
		  (goto-char (match-beginning 0))
		  (and
		   ;; Do not match table hlines.
		   (not (and (equal marker "+")
			     (org-match-line
			      "[ \t]*\\(|[-+]+|?\\|\\+[-+]+\\+\\)[ \t]*$")))
		   ;; Do not match headline stars.  Do not consider
		   ;; stars of a headline as closing marker for bold
		   ;; markup either.
		   (not (and (equal marker "*")
			     (save-excursion
			       (forward-char)
			       (skip-chars-backward "*")
			       (looking-at-p org-outline-regexp-bol))))
		   ;; Match full emphasis markup regexp.
		   (looking-at (if verbatim? (plist-get org-extra-emphasis-info :org-verbatim-re)
				 (plist-get org-extra-emphasis-info :org-emph-re)))
		   ;; Do not span over paragraph boundaries.
		   (not (string-match-p org-element-paragraph-separate
					(match-string 2)))
		   ;; Do not span over cells in table rows.
		   (not (and (save-match-data (org-match-line "[ \t]*|"))
			     (string-match-p "|" (match-string 4))))))
	    (pcase-let ((`(,_ ,face ,_) (assoc marker (plist-get org-extra-emphasis-info :org-emphasis-alist)))
			(m (if org-hide-emphasis-markers 4 2)))
	      (font-lock-prepend-text-property
	       (match-beginning m) (match-end m) 'face face)
	      (when verbatim?
		(org-remove-flyspell-overlays-in
		 (match-beginning 0) (match-end 0))
		(remove-text-properties (match-beginning 2) (match-end 2)
					'(display t invisible t intangible t)))
	      (add-text-properties (match-beginning 2) (match-end 2)
				   '(font-lock-multiline t org-emphasis t))
	      (when (and org-hide-emphasis-markers
			 (not (org-at-comment-p)))
		(add-text-properties (match-end 4) (match-beginning 5)
				     '(invisible t))
		(add-text-properties (match-beginning 3) (match-end 3)
				     '(invisible t)))
	      (throw :exit t))))))))

;; There is no `:set' function for `deffaces'.  So, when the extra
;; faces `org-extra-emphasis-1', `org-extra-emphasis-2' reconfigured,
;; we don't get a notification.  The following export hook ensures
;; that `org-extra-emphasis-info' is in sync with user configuration.
(add-hook 'org-export-before-processing-hook 'org-extra-emphasis-update)

;;; Export Extra Emphasis Markers

(defun org-extra-emphasis-formatter (marker text backend)
  "Style TEXT in the same font face as the face MARKER is mapped to.
Note that TEXT is in BACKEND format.

This currently supports HTML and ODT backends.

See `org-extra-emphasis-alist' for MARKER to face mappings."
  (let* ((face (car (assoc-default marker (plist-get org-extra-emphasis-info :work-alist)))))
    (cl-case backend
      (odt
       (format "<text:span text:style-name=\"%s\">%s</text:span>"
	       (car (org-odt-hfy-face-to-css face)) text))
      (html
       (let ((s (cdr (hfy-face-to-css-default face))))
	 (when (string-match (rx-to-string '(and "{" (group (zero-or-more any)) "}")) s)
	   (format "<span style=\"%s\">%s</span>" (match-string 1 s) text))))
      (_ text))))

(defun org-extra-emphasis-build-backend-regexp ()
  "Regexp to search for emphasized text in exported file.
This function transcode an emphasis MARKER which is in plain text
format, to the BACKEND format.  That is, if you use `<<' as an
emphasis marker, you need to search for `&lt;&lt;' in the
exported HTML file.

See `org-extra-emphasis-alist' for more information"
    (cl-loop for (marker . spec) in (plist-get org-extra-emphasis-info :work-alist) collect
	   (cons marker
		 (cl-loop for backend in org-extra-emphasis-backends collect
			  (cons backend
				(rx-to-string `(and ,(org-export-data-with-backend marker backend nil)
						    (group (minimal-match
							    (zero-or-more (or any "\n"))))
						    ,(org-export-data-with-backend marker backend nil))))))))

(defun org-extra-emphasis-plain-text-filter (text backend _info)
  "Transcode TEXT in to BACKEND format.
Uses `org-extra-emphasis-formatter' to do the transcoding.

Search TEXT for one or more transcoded MARKERs, and mark it up as
specified in `org-extra-emphasis-alist'."
  (with-temp-buffer
    (insert text)
    (cl-loop for (marker . spec) in (plist-get org-extra-emphasis-info :export-alist)
	     for regex = (assoc-default backend spec)
	     do (goto-char (point-min))
	     (if (not regex) text
	       (while (re-search-forward regex nil t)
		 (let* ((contents (match-string 1))
			(emphasized-contents (save-match-data
					       (org-extra-emphasis-formatter
						marker contents backend))))
		   (replace-match emphasized-contents t t)))))
    (buffer-substring-no-properties (point-min) (point-max))))

;; Install export filter for transcoding extra emphasis markers.
(add-to-list 'org-export-filter-plain-text-functions
	     'org-extra-emphasis-plain-text-filter)

;;; User Options & Commands

;;;; Custom Groups

(defgroup org-extra-emphasis nil
  "Options for highlighting and exporting extra emphasis markers in Org files."
  :tag "Org Extra Emphasis"
  :group 'org)

(defgroup org-extra-emphasis-faces nil
  "Faces for Org Extra Emphasis."
  :group 'org-extra-emphasis
  :group 'faces)

;;; Custom Faces

(defface org-extra-emphasis-1
  '((t (:background "yellow")))
  "A face for Org Extra Emphasis."
  :group 'org-extra-emphasis)

(defface org-extra-emphasis-2
  '((t (:foreground "red")))
  "A Face for Org Extra Emphasis."
  :group 'org-extra-emphasis)

;;;; Useful Org Setting

(setcar (last org-emphasis-regexp-components) 5)

(defcustom org-extra-emphasis-alist
  '(("!!" org-extra-emphasis-1)
    ("!@" org-extra-emphasis-2))
  "Alist of emphasis marker and its associated face."
  :group 'org-extra-emphasis
  :type '(repeat
	  (list
	   (string :tag "Emphasis Marker")
	   (face :tag "Face")))
  :set (lambda (var val)
	 (set var val)
	 (plist-put org-extra-emphasis-info :alist val)
	 (org-extra-emphasis-update)))

(defcustom org-extra-emphasis t
  "When non-nil, enable Org Extra Emphasis."
  :group 'org-extra-emphasis
  :type '(boolean "Org Extra Emphasis")
  :set (lambda (var val)
	 (set var val)
	 (plist-put org-extra-emphasis-info :enabled val)
	 (org-extra-emphasis-update)))

;;;; Command

(defun org-extra-emphasis-mode (&optional arg)
  "Enable / Disable Org Extra Emphasis.

If called interactively, toggle Extra Emphasis.

When called non-interactively, enable Extra Emphasis if ARG is
positive; disable otherwise."
  (interactive "p")
  (cond
   ;; Called interactively; Toggle
   ((called-interactively-p 'any)
    (setq org-extra-emphasis (not org-extra-emphasis)))
   ;; Called programatically; enable if arg >= 1
   ((and (numberp arg)
	 (>= arg 1))
    (setq org-extra-emphasis t))
   ;; Otherwise, disable
   (t
    (setq org-extra-emphasis nil)))
  (plist-put org-extra-emphasis-info :enabled org-extra-emphasis)
  (org-extra-emphasis-update))

(provide 'org-extra-emphasis)