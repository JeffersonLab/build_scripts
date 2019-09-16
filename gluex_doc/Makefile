basename = build_scripts

all: $(basename).pdf $(basename)_web.tar

packages-doc-list.tex: ../xml/packages.xml ../xml/packages_doc_list.xslt
	xsltproc ../xml/packages_doc_list.xslt ../xml/packages.xml | sed -e 's/_/\\_/g' > $@

packages-doc-homevar.tex: ../xml/packages.xml ../xml/packages_doc_homevar.xslt
	xsltproc ../xml/packages_doc_homevar.xslt ../xml/packages.xml | sed -e 's/_/\\_/g' > $@

$(basename).pdf: $(basename).tex packages-doc-list.tex packages-doc-homevar.tex
	pdflatex $(basename)
	pdflatex $(basename)

$(basename)_web.tar: $(basename)_web
	tar cvf $@ $<

$(basename)_web: $(basename)_web.tex
	 latex2html -local_icons -split 0 -show_section_numbers $(basename)_web

$(basename)_web.tex: $(basename).tex
	cp $(basename).tex $(basename)_web.tex

clean:
	$(RM) *.tmp *.aux *.log *.pdf *.toc *.out $(basename)_web.tar $(basename)_web.tex packages-doc-*.tex
	$(RM) -r $(basename)_web
