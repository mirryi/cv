DOCKER ?= docker
LATEXMK ?= latexmk

SOURCES = $(wildcard *.tex)
TARGETS = $(patsubst %.tex,%.pdf,$(SOURCES))

ifdef USE_DOCKER
%.pdf : %.tex
	DOCKER_BUILDKIT=1 $(DOCKER) build . --output .
else
%.pdf : %.tex
	$(LATEXMK) $*.tex
	mv target/$*.pdf $*.pdf
endif

.PHONY : all
all : $(TARGETS)

.PHONY : clean
clean :
	rm -f *.pdf
	rm -rf target
