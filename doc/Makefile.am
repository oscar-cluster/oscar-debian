# -*- makefile -*-
#
# Copyright (c) 2002-2003 The Trustees of Indiana University.  
#                         All rights reserved.
# 
# $Id$
#
# This file is part of the OSCAR distribution.  See license
# information in the top-level directory.
#

include $(top_srcdir)/dist/Makefile.options

oscar_DATA		= README
EXTRA_DIST		= $(oscar_DATA)

#
# Make the documentation.  Need special handling because these
# directories may (developer tree) or may not (distribution tree) be
# here.
#

docs_subdirs	= architecture by-laws development installation user

docs:
	set fnord $(MAKEFLAGS); amf=$$2; \
	mypwd="`pwd`"; \
	cd "$(top_srcdir)"; mytop_srcdir="`pwd`"; \
	cd "$$mypwd"; \
	cd "$(top_builddir)"; mytop_builddir="`pwd`"; \
	cd "$$mypwd"; \
	list='$(docs_subdirs)'; for subdir in $$list; do \
	  if test -d $$subdir; then \
	    echo "Making $$target in $$subdir"; \
	    (cd $$subdir && \
		$(MAKE) $(AM_MAKEFLAGS) top_srcdir="$$mytop_srcdir" top_builddir="$$mytop_builddir" docs) \
	     || case "$$amf" in *=*) exit 1;; *k*) fail=yes;; *) exit 1;; esac; \
	  fi; \
	done; 

#
# The PDF files may or may not be present (depending on what flavor
# installation this is, whether it's a development tree, etc.).  Hence,
# we can't list them directly in oscar_DATA.   So only install/uninstall 
# them if there's already here.  Leverage using the real install/uninstall
# automake target logic, but just override the oscar_DATA macro when the
# files are actually present.
#

install-data-local:
	@if test "$(oscar_DATA)" = "README"; then \
	  for file in install.pdf user.pdf; do \
	    if test -f $$file; then \
              $(MAKE) oscar_DATA=$$file install; \
	    fi; \
	  done; \
	fi

uninstall-local:
	@if test "$(oscar_DATA)" = "README"; then \
	  for file in install.pdf user.pdf; do \
	    if test -f $$file; then \
              $(MAKE) oscar_DATA=$$file uninstall; \
	    fi; \
	  done; \
	fi

clean-local:
	set fnord $(MAKEFLAGS); amf=$$2; \
	mypwd="`pwd`"; \
	cd "$(top_srcdir)"; mytop_srcdir="`pwd`"; \
	cd "$$mypwd"; \
	cd "$(top_builddir)"; mytop_builddir="`pwd`"; \
	cd "$$mypwd"; \
	list='$(docs_subdirs)'; for subdir in $$list; do \
	  if test -d $$subdir; then \
	    echo "Making $$target in $$subdir"; \
	    (cd $$subdir && \
		$(MAKE) $(AM_MAKEFLAGS) top_srcdir="$$mytop_srcdir" top_builddir="$$mytop_builddir" clean) \
	     || case "$$amf" in *=*) exit 1;; *k*) fail=yes;; *) exit 1;; esac; \
	  fi; \
	done; 
