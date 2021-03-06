# Time-stamp: <10/06/02 14:12:58 ptr>
#
# Copyright (c) 1997-1999, 2002, 2003, 2005-2008
# Petr Ovtchenkov
#
# This material is provided "as is", with absolutely no warranty expressed
# or implied. Any use is at your own risk.
#
# Permission to use or copy this software for any purpose is hereby granted
# without fee, provided the above notices are retained on all copies.
# Permission to modify the code and to distribute modified code is granted,
# provided the above notices are retained, and a notice that the code was
# modified is included with the above copyright notice.
#

.SUFFIXES:
.SCCS_GET:
.RCS_GET:

PHONY ?=

RULESBASE ?= $(SRCROOT)/Makefiles

# include file, generated by configure, if available
-include ${RULESBASE}/gmake/config.mak

ifndef COMPILER_NAME
# gcc is default compiler, others specify explicitly;
COMPILER_NAME := gcc
endif

ifndef LDFLAGS
LDFLAGS :=
endif

ifndef ALL_TAGS

ifndef _NO_SHARED_BUILD
ALL_TAGS := release-shared
else
ALL_TAGS :=
endif

ifdef _STATIC_BUILD
ALL_TAGS += release-static
endif

ifndef _NO_DBG_BUILD
ifndef _NO_SHARED_BUILD
ALL_TAGS += dbg-shared
endif
ifdef _STATIC_BUILD
ALL_TAGS += dbg-static
endif
endif

ifndef _NO_STLDBG_BUILD
ifndef WITHOUT_STLPORT
ifndef _NO_SHARED_BUILD
ALL_TAGS += stldbg-shared
endif
ifdef _STATIC_BUILD
ALL_TAGS += stldbg-static
endif
endif
endif

endif

all:	$(OUTPUT_DIRS) $(ALL_TAGS)

ifndef WITHOUT_STLPORT
all-static:	release-static	dbg-static	stldbg-static
all-shared:	release-shared	dbg-shared	stldbg-shared
else
all-static:	release-static	dbg-static
all-shared:	release-shared	dbg-shared
endif

ifdef WITHOUT_STLPORT
NOT_USE_NOSTDLIB := 1
endif

ifndef OSNAME
# identify OS and build date
include ${RULESBASE}/gmake/sysid.mak
endif
# OS-specific definitions, like ln, install, etc. (guest host)
include ${RULESBASE}/gmake/$(BUILD_OSNAME)/sys.mak
# target OS-specific definitions, like ar, etc.
include ${RULESBASE}/gmake/$(OSNAME)/targetsys.mak
# Extern projects for everyday usage and settings for ones
include ${RULESBASE}/gmake/extern.mak
# compiler, compiler options
include ${RULESBASE}/gmake/$(COMPILER_NAME).mak
# rules to make dirs for targets
include ${RULESBASE}/gmake/targetdirs.mak

# os-specific local rules (or other project-specific definitions)
-include specific.mak

LDFLAGS += ${EXTRA_LDFLAGS}

# derive common targets (*.o, *.d),
# build rules (including output catalogs)
include ${RULESBASE}/gmake/targets.mak
# dependency
include ${RULESBASE}/gmake/depend.mak

# general clean
include ${RULESBASE}/gmake/clean.mak

# if target is library, rules for library
ifdef LIBNAME
include ${RULESBASE}/gmake/lib/top.mak
endif

# if target is program, rules for executable
ifdef PRGNAME
include ${RULESBASE}/gmake/app/top.mak
else
ifdef PRGNAMES
include ${RULESBASE}/gmake/app/top.mak
endif
endif

.PHONY: $(PHONY)
