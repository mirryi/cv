DOCKER  ?= docker
LATEXMK ?= latexmk

SOURCES = resume.tex
DEPS 		= preamble.tex
TARGETS = $(patsubst %.tex,%.pdf,$(SOURCES))

ifdef USE_DOCKER
%.pdf : %.tex $(DEPS)
	DOCKER_BUILDKIT=1 $(DOCKER) build . --output .
else
%.pdf : %.tex $(DEPS)
	$(LATEXMK) $*.tex
	mv target/$*.pdf $*.pdf
endif

.PHONY : all
all : $(TARGETS)

.PHONY : clean
clean :
	rm -f *.pdf
	rm -rf target
