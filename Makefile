basename = gluex_build

all: $(basename).pdf $(basename)_web.tar

$(basename).pdf: $(basename).tex
	pdflatex $(basename)
	pdflatex $(basename)

$(basename)_web.tar: $(basename)_web
	tar cvf $@ $<

$(basename)_web: $(basename)_web.tex
	 latex2html -local_icons $(basename)_web

$(basename)_web.tex: $(basename).tex
	cp $(basename).tex $(basename)_web.tex
	gsr.pl \\\\tableofcontents %\\\tableofcontents $(basename)_web.tex

clean:
	$(RM) *.tmp *.aux *.log *.pdf *.toc *.out gluex_build_web.tar gluex_build_web.tex
	$(RM) -r gluex_build_web
