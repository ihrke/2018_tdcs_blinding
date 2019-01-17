PAPER=paper
SUPPLEMENT=supplement
BIBLIOGRAPHY=references.bib
TEMPLATE=templates/elsarticle-template-1-num.latex
#TEMPLATE=templates/scientific_reports.latex
PANDOC=pandoc
USE_NATBIB=--natbib #--biblatex 

export TEXINPUTS=.:./templates/dependencies//:
export BIBINPUTS=.:./templates/dependencies//:


all: ${SUPPLEMENT}.pdf ${PAPER}.pdf

${PAPER}.pdf: ${PAPER}.tex ${BIBLIOGRAPHY}
	pdflatex ${PAPER}.tex
	bibtex ${PAPER}
	pdflatex ${PAPER}.tex

${SUPPLEMENT}.pdf: ${SUPPLEMENT}.tex ${BIBLIOGRAPHY}
	pdflatex ${SUPPLEMENT}.tex
	bibtex ${SUPPLEMENT}
	pdflatex ${SUPPLEMENT}.tex

${PAPER}.tex: ${PAPER}.md ${BIBLIOGRAPHY} ${TEMPLATE}
	${PANDOC} -s -f markdown -t latex  --filter pandoc-fignos --filter filters/latex_textred.py --filter pandoc-citeproc ${USE_NATBIB} ${PAPER}.md -o ${PAPER}.tex --template ${TEMPLATE} --bibliography ${BIBLIOGRAPHY}

${SUPPLEMENT}.tex: ${SUPPLEMENT}.md ${BIBLIOGRAPHY} ${TEMPLATE}
	${PANDOC} -s -f markdown -t latex  --filter filters/latex_textred.py --filter pandoc-fignos --filter pandoc-citeproc ${USE_NATBIB} ${SUPPLEMENT}.md -o ${SUPPLEMENT}.tex --template ${TEMPLATE} --bibliography ${BIBLIOGRAPHY}


watch: $(MD_FILES) $(BIBLIOGRAPHY)
	fswatch -o $^ | xargs -n1 -I{} make
