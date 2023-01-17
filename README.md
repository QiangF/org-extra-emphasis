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

