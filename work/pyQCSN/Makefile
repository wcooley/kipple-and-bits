#
# Makefile for pyaddvirt.  Mostly useful for installing.
#
BINDIR	=	/usr/local/sbin
LIBDIR	=	/usr/local/lib/python/pyaddvirt
BINS	=	addvirt.py
LIBS	=	$(wildcard pyaddvirt/*)

all:
	@echo "Usage: make install"

install:
	-mkdir -p $(BINDIR)
	-mkdir -p $(LIBDIR)
	cp $(BINS) $(BINDIR)
	cp -a $(LIBS) $(LIBDIR)
	
