basename = build_scripts

all: $(basename).pdf $(basename)_web.tar

packages-doc-list.tex: ../xml/packages.xml ../xml/packages_doc_list.xslt
	xsltproc ../xml/packages_doc_list.xslt ../xml/packages.xml | sed -e 's/_/\\_/g' > $@

packages-doc-homevar.tex: ../xml/packages.xml ../xml/packages_doc_homevar.xslt
	xsltproc ../xml/packages_doc_homevar.xslt ../xml/packages.xml | sed -e 's/_/\\_/g' > $@

$(basename).pdf: $(basename).tex packages-doc-list.tex packages-doc-homevar.tex
	pdflatex $(basename)
	pdflatex $(basename)
	pdflatex $(basename)

$(basename)_web.tar: $(basename)_web
	tar cf $@ $<
	@echo ===============================================
	@echo Make sure that the link on https://halldweb.jlab.org/wiki/index.php/Setting_Up_the_GlueX_Environment is still viable 
	@echo ===============================================

$(basename)_web: $(basename)_web.tex
	$(RM) -r $@
	latex2html -local_icons -split 4 -show_section_numbers $(basename)_web

$(basename)_web.tex: $(basename).tex
	$(RM) $@
	grep -v tableofcontents $< > $@

clean:
	$(RM) *.tmp *.aux *.log *.pdf *.toc *.out $(basename)_web.tar $(basename)_web.tex packages-doc-*.tex
	$(RM) -r $(basename)_web
