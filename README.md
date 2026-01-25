<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [`org-extra-emphasis`: Extra Emphasis markers for Emacs Org mode](#org-extra-emphasis-extra-emphasis-markers-for-emacs-org-mode)
  - [Setup](#setup)
  - [Test Run](#test-run)
  - [Screenshots](#screenshots)
    - [`org-extra-emphasis.org` as viewed in Emacs](#org-extra-emphasisorg-as-viewed-in-emacs)
    - [`org-extra-emphasis.html` as viewed in Firefox](#org-extra-emphasishtml-as-viewed-in-firefox)
    - [`org-extra-emphasis.odt` as viewed in LibreOffice](#org-extra-emphasisodt-as-viewed-in-libreoffice)
    - [`org-extra-emphasis.pdf` as exported by LibreOffice](#org-extra-emphasispdf-as-exported-by-libreoffice)
  - [Customization](#customization)
  - [Sample User Configuration](#sample-user-configuration)

<!-- markdown-toc end -->
# `org-extra-emphasis`: Extra Emphasis markers for Emacs Org mode

This library provides two additional markers `!!` and `!@` over
and above those in `org-emphasis-alist`.

- Text enclosed in `!!` is highlighted in yellow, and exported likewise
- Text enclosed in `!@` is displayed in red, and exported likewise

Following backends are supported: HTML and enhanced ODT

##  Setup

Add the following to your `user-init-file` and resetart Emacs.

```
(require 'org-extra-emphasis)
```

##  Test Run

1. Create an `org` file, say `org-export-emphasis.org` and fill it with following content.

```
	  #+TITLE: Test file for ==org-extra-emphasis== library

	  * Demo of extra emphasis markers ==!!== and ==!@==

	  !!Ea consectetur laboris adipiscing et ipsum labore esse qui minim
	  pariatur et sunt sunt nostrud anim laborum culpa.!!

	  !@Minim reprehenderit excepteur elit, dolore elit, veniam, eu.
	  Ullamco dolore elit, cupidatat sed labore ea aute.!@

	  Pariatur !!et lorem cupidatat !@minim irure!@ proident, ad.!!  Eiusmod
	  sunt et lorem labore ex aliqua aute esse.

	  Ut mollit !@duis velit est est magna in quis ipsum.  !!Aliqua aliqua
	  non laboris exercitation cupidatat aliqua incididunt.!!  Qui voluptate
	  irure aute occaecat laborum cillum est.!@  Quis magna dolor ullamco
	  magna do consectetur est laborum enim ut.

	  * !!Demo of extra emphasis markers in a styled paragraph!!

	  #+ATTR_ODT: :target "extra_styles"
	  #+begin_src nxml
	  <style:style style:name="Warn"
		       style:parent-style-name="Text_20_body"
		       style:family="paragraph">
	    <style:paragraph-properties>
	      <style:tab-stops />
	    </style:paragraph-properties>
	    <style:text-properties fo:background-color="#ff0000"
				 fo:color="#ffffff"
				 fo:font-size="20pt"
				 fo:font-style="italic"
				 fo:font-weight="bold" />
	  </style:style>
	  #+end_src

	  #+ATTR_ODT: :style "Warn"
	  Proident, duis dolore consectetur sed nisi ea pariatur.  Esse
	  proident, cillum duis qui ullamco sint cillum magna.  !!Eiusmod
	  veniam, !@sint officia!@ non consectetur laboris cillum.!!  Cillum
	  mollit consequat eu dolore ullamco qui reprehenderit anim cillum
	  in consectetur consequat sunt dolore aliquip voluptate
	  consectetur anim ea.  Voluptate nisi est incididunt aliquip
	  excepteur aliqua id do enim ut non consequat.
	  
```

2. When in `org-extra-emphasis.org` buffer, note that portions of text
   marked with `!!` and `!@` are fontified as described above.

3. Export the file to HTML with `C-c C-e h O`.

   Note that the text enclosed in the above emphasis markers are
   colorized in HTML file.

4. Export the file to ODT with `C-c C-e o O`.

   Note that the text enclosed in the above emphasis markers are
   colorized in ODT file.

##  Screenshots

### `org-extra-emphasis.org` as viewed in Emacs

![`org-extra-emphasis.org` as viewed in Emacs](https://raw.githubusercontent.com/kjambunathan/org-extra-emphasis/main/screenshots/org-extra-emphasis.org.emacs.png)

### `org-extra-emphasis.html` as viewed in Firefox

![`org-extra-emphasis.org` as viewed in Firefox](https://raw.githubusercontent.com/kjambunathan/org-extra-emphasis/main/screenshots/org-extra-emphasis.html.firefox.png)

### `org-extra-emphasis.odt` as viewed in LibreOffice

![`org-extra-emphasis.org` as viewed in
LibreOffice](https://raw.githubusercontent.com/kjambunathan/org-extra-emphasis/main/screenshots/org-extra-emphasis.odt.libreoffice.png)

### `org-extra-emphasis.pdf` as exported by LibreOffice

![`org-extra-emphasis.org` as viewed in
LibreOffice](https://raw.githubusercontent.com/kjambunathan/org-extra-emphasis/main/screenshots/org-extra-emphasis.pdf.libreoffice.png)

##  Customization

Customize `org-extra-emphasis-alist` to set the emphasis markers
and their associated faces.  When choosing your own marker, ensure
that you exercise some care.  For example, if you choose `#` as a
marker you are likely to get malformed `html` and `odt` files.

This library defines two faces `org-extra-emphasis-1`and
`org-extra-emphasis-2`.

You can use `M-x org-extra-emphasis-mode` to toggle this feature.

To add additional backends, modify `org-extra-emphasis-formatter`
and `org-extra-emphasis-build-backend-regexp`.

## Sample User Configuration

To achieve the following

![`org-extra-emphasis.org` as viewed in LibreOffice](https://raw.githubusercontent.com/kjambunathan/org-extra-emphasis/main/screenshots/custom-org-extra-emphasis.org.emacs.png)

create an ~custom-org-extra-emphasis.org~ file with the below content

```
[!NOTE]
ℹ️Highlights information that users should take into account, even when skimming.ℹ️

[!TIP]
💡​_*TIP*_: Optional information to help a user be more successful.💡

💡You can use💡

[!IMPORTANT]
🔑Crucial information necessary for users to succeed.🔑

[!WARNING]
⚠️Critical content demanding immediate user attention due to potential risks.⚠️

[!CAUTION]
🛑Negative potential consequences of an action.🛑
```

and view or edit it with following customization.

``` emacs-lisp
(use-package org-extra-emphasis
  :load-path
  "/home/kjambunathan/src/emacs-init/straight/repos/org-extra-emphasis/"
  :after
  (org)
  :init
  (defface org-extra-emphasis-note '((t (:foreground "#0969da")))
    "A face for Org Extra Emphasis [NOTE].")
  (defface org-extra-emphasis-tip '((t (:foreground "#1a7f37")))
    "A face for Org Extra Emphasis [TIP].")
  (defface org-extra-emphasis-important '((t (:foreground "#9a6700")))
    "A face for Org Extra Emphasis [IMPORTANT].")
  (defface org-extra-emphasis-warning '((t (:foreground "#8250df")))
    "A face for Org Extra Emphasis [WARNING].")
  (defface org-extra-emphasis-caution '((t (:foreground "#d1242f")))
    "A face for Org Extra Emphasis [CAUTION].")
  :custom
  (org-extra-emphasis-alist
   '(("ℹ️" org-extra-emphasis-note)
     ("💡" org-extra-emphasis-tip)
     ("🔑" org-extra-emphasis-important)
     ("⚠️" org-extra-emphasis-warning)
     ("🛑" org-extra-emphasis-caution)))
  :bind
  (:map org-mode-map
        ("M-8 M-n" . "ℹ️")
        ("M-8 M-t" . "💡")
        ("M-8 M-i" . "🔑")
        ("M-8 M-w" . "⚠️")
        ("M-8 M-c" . "🛑")
        )
  )
```

The above customization is generated with the following `emacs-lisp` snippet:

``` emacs-lisp
`(use-package org-extra-emphasis
   ,@(let* (
            ;; The 5 MARKERs that I will use.

            ;; It doesn't matter what they are as long as they don't
            ;; get in the way of `org' parser.

            (org-extra-emphasis-markers
             '("ℹ️" "💡" "🔑" "⚠️" "🛑"))

            ;; The 5 INTENTs behind the above markers

            ;; I am using the `github'-s
            ;; [Alerts](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts)
            (org-extra-emphasis-functions
             '("note" "tip" "important" "warning"  "caution"))

            ;; The 5 COLORs that I will use for above markers

            ;; The colors that I use are those used by `github' for the above `alerts'
            (org-extra-emphasis-colors
             '("#0969da" "#1a7f37" "#9a6700" "#8250df" "#d1242f"))

            ;; The 5 FACE-SPECs that I will use for above markers
            (org-extra-emphasis-face-specs
             (cl-loop for color in  '("#0969da" "#1a7f37" "#9a6700" "#8250df" "#d1242f")
                      for face-spec = `((t (:foreground ,color)))
                      collect  face-spec))

            ;; The 5 face names that I prefer for the above markers

            ;; Instead of faces like `org-extra-emphasis-01',
            ;; `org-extra-emphasis-02' etc., I am using  my own face names that capture my INTENT
            (org-extra-emphasis-faces
             (cl-loop for i from 0 to (length org-extra-emphasis-markers)
                      collect (intern (format "org-extra-emphasis-%s" (nth i org-extra-emphasis-functions))))))

       `(
         :load-path "/home/kjambunathan/src/emacs-init/straight/repos/org-extra-emphasis/"
         :after (org)
         :init
         ;; Roll out my own faces whose names match the INTENT
         ,@(cl-loop for i from 0 to (1- (length org-extra-emphasis-markers))
                    collect `(defface ,(intern (format "org-extra-emphasis-%s" (nth i org-extra-emphasis-functions)))
                               ',(nth i org-extra-emphasis-face-specs)
                               ,(format "A face for Org Extra Emphasis [%s]." (upcase (nth i org-extra-emphasis-functions)))
                               ;; :group
                               ;; 'org-extra-emphasis-faces
                               ))
         :custom
         ;; Roll out my own MARKERs which match my INTENT, map them to the correspoding FACE
         (org-extra-emphasis-alist
          ',(cl-loop for i from 0 to (1- (length org-extra-emphasis-markers))
                     collect `(,(nth i org-extra-emphasis-markers)
                               ,(intern (format "org-extra-emphasis-%s" (nth i org-extra-emphasis-functions))) )))

         ;; Create a mapping to insert the above "fancy" markers.

         ;; For example, to insert a CAUTION marker, use `M-8 M-c';
         ;; note that `c' is the first character of the intent--`CAUTION'.
         :bind (:map org-mode-map
                     ,@(cl-loop with prefix-key = "M-8"
                                for i from 0 to (1- (length org-extra-emphasis-markers))
                                for intent = (nth i org-extra-emphasis-functions)
                                for key = (substring intent 0 1)
                                collect `(,(format "%s M-%s" prefix-key key) . ,(nth i org-extra-emphasis-markers))
                                ))

         )))
```

