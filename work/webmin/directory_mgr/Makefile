#
# Makefile for directory_mgr
#
# $Id$
#

all: help

help:
	@echo "Makefile targets:"
	@echo "  test:       Perform test compilations on all source"
	@echo "  fulltest:   Perform test compilations with extra warnings"
	@echo "  textdoc:    Generate text pod docs"
	@echo "  htmldoc:    Generate HTML pod docs"

test:
	-@for i in *.pl *.cgi; do perl -c $$i 2>&1 ; done

fulltest:
	-@for i in *.pl *.cgi; do perl -wc $$i 2>&1 ; done

doc: textdoc

textdoc:
	@echo "Generating text pod docs..."
	-@for i in *.pl *.cgi; do echo $$i; pod2text -c $$i > doc/$$i.txt; done

htmldoc:
	@echo "Generating html pod docs..."
	-@for i in *.pl *.cgi; do echo $$i; pod2html --infile=$$i --title=$$i > doc/html/$$i.html; done

# vim: noexpandtab
