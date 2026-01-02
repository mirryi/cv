DOCKER  ?= docker
LATEXMK ?= latexmk

SOURCES = resume.tex
DEPS    = preamble.tex
TARGETS = $(patsubst %.tex,%.pdf,$(SOURCES))

%.pdf : %.tex $(DEPS)
	$(LATEXMK) $*.tex
	mv build/$*.pdf $*.pdf

.PHONY : all
all : $(TARGETS)

.PHONY : clean
clean :
	rm -f *.pdf
	rm -rf build 
