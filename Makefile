LATEXMK ?= latexmk
ENTR ?= entr

SOURCES = $(wildcard *.tex)
TARGETS = $(patsubst %.tex,%.pdf,$(SOURCES))

.PHONY : clean clean-aux

%.pdf : %.tex
	$(LATEXMK) $*.tex
	mv target/$*.pdf $*.pdf

all : $(TARGETS)

clean : clean-aux
	rm -f *.pdf

clean-aux :
	rm -rf target
