basename = build_scripts

all: $(basename).pdf $(basename)_web.tar

$(basename).pdf: $(basename).tex
	pdflatex $(basename)
	pdflatex $(basename)

$(basename)_web.tar: $(basename)_web
	tar cvf $@ $<

$(basename)_web: $(basename)_web.tex
	 latex2html -local_icons -split 0 -show_section_numbers $(basename)_web

$(basename)_web.tex: $(basename).tex
	cp $(basename).tex $(basename)_web.tex

clean:
	$(RM) *.tmp *.aux *.log *.pdf *.toc *.out $(basename)_web.tar $(basename)_web.tex
	$(RM) -r $(basename)_web
