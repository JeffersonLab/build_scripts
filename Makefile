basename = gluex_build

$(basename).pdf: $(basename).tex
	pdflatex $(basename)
