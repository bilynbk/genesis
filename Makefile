# $Id: Makefile.dist,v 1.39 2006/03/18 00:49:35 svitak Exp $
#
#				G E N E S I S
#		    The General Neural Simulation System
#				 Version 2.3
#
# SYNOPSIS: This is the top-level Makefile for GENESIS.  
#           YOU MUST EDIT THIS FILE BEFORE RUNNING "make".
#           Please follow the procedure given below.
#
# TABLE OF CONTENTS
# A. Procedure for building and installing GENESIS
# B. Installation configuration settings
# C. Optional libraries
# D. Definitions for specific operating system and compiler in use
# E. Custom settings
# F. Beginning of non-configurable definitions
# G. Revision history
#
# ----------------------------------------------------------------------
# A. PROCEDURE FOR BUILDING AND INSTALLING GENESIS
# ----------------------------------------------------------------------
#
# 1) Examine the small block of definitions in section B which may need
#    to be modified for your architecture.
#
# 2) Look through the rest of this file for a block of definitions for
#    your particular computer operating system and compiler combination.
#    For example, the definitions suggested for Solaris 2.x when using
#    the Sun Workshop C compiler begins with lines that look like this:
#
#		# System:	Solaris 2.x (A.K.A. SunOS 5.x)
#		# Compiler:	Sun Workshop "cc"
#
#    Note that some system/compiler combinations have several variations
#    below, so look carefully at all of them before chosing one.
#
# 3) Uncomment the definitions for your operating system/compiler
#    combination. Please be sure to remove the comment character (#) as well
#    as any leading spaces.
#
#    NOTE: MAKE SURE THAT NO OTHER SYSTEM/COMPILER SECTION IS UNCOMMENTED.
#
# 4) Execute the command "make".
#
# 5) Execute the command "make install".
# 
# 6) Execute the command "make clean".
#
# 
# ADDITIONAL INFORMATION:
# If you run into problems compiling this package, consult the "CUSTOM
# SETTINGS" section below, where you may override the default settings.
# If one of the optional libraries fails to compile, comment out the
# library's macros in the "Optional libraries" section.
#
# GENESIS can also be built without the XODUS graphics libraries by
# replacing the commands in steps 2 and 3 with "make nxall" and
# "make nxinstall".  A GENESIS without any libraries can be built
# with the commands "make minall" and "make mininstall".
#

# ----------------------------------------------------------------------
# B. INSTALLATION AND MISC CONFIGURATION SETTINGS
# ----------------------------------------------------------------------

# The following variable determines where GENESIS is placed by the
# "make install" command. Substituting the full path here is preferable
# to using `pwd`.
ifndef PREFIX
	INSTALLDIR?=$(shell pwd)
else
	INSTALLDIR = $(PREFIX)/genesis
endif

$(warning GENESIS will be installed to $(INSTALLDIR))

# source directory
SRCDIR = src

# If /tmp is not big enough to contain compile-produced object files,
# choose a different location here.
TMPDIR = /tmp

# extract machine (OS) and architecture names
# (depends on POSIX-standard uname utility)
MACHINE  ?= $(shell uname -m)
ARCH     ?= $(shell uname -s)
PLATFORM ?= $(shell uname -p)

# ----------------------------------------------------------------------
# C. OPTIONAL LIBRARIES
# ----------------------------------------------------------------------
#
# The following libraries are optional.  If you comment the macros for a
# given library here the library will not be compiled or linked into the
# executable.

#
# kinetics --- Kinetic modeling library (necessary for kkit)
#

KINETICSLIB = kin
KINETICSDIR = kinetics
KINETICSOBJ = $(KINETICSDIR)/kinlib.o

#
# diskio --- Binary file format support library
#
# The diskio and related objects from this library provide a disk_in
# disk_out backward compatible interface for netCDF portable binary
# files.  Comment out the DISKIO and DISKIOLIB macros to exclude the
# diskio library.  There are currently no kits or tutorials which depend
# on this library.

# Please note that all the macros here need to be uncommented if diskio
# support is to be included.  FMT1 support is therefore included by
# default when the diskio library is linked in.

FMT1SUBDIR   = FMT1
FMT1OBJ      = $(DISKIODIR)/interface/FMT1/FMT1lib.o
FMT1FLAGS    = -DFMT1

DISKIOLIB    = diskio
DISKIODIR    = diskio
DISKIOSUBDIR = $(NETCDFSUBDIR) \
               $(FMT1SUBDIR)
DISKIOOBJ    = $(NETCDFOBJ) \
	       $(FMT1OBJ) \
	       $(DISKIODIR)/diskiolib.o
DISKIOFLAGS  = $(NETCDFFLAGS) \
	       $(FMT1FLAGS)

# Uncomment the following definitions if the netCDF file format needs to
# be supported by diskio.  netCDF is a system-independent, portable,
# binary file format.  See the directory src/diskio/interface/netcdf for
# more information.  NOTE: *only* uncomment the netCDF definitions below
# if diskio support is included above.

NETCDFSUBDIR = netcdf
NETCDFOBJ = \
	$(DISKIODIR)/interface/$(NETCDFSUBDIR)/netcdflib.o \
	$(DISKIODIR)/interface/$(NETCDFSUBDIR)/netcdf-3.4/src/libsrc/libnetcdf.a
NETCDFFLAGS = -Dnetcdf

#
# oldconn --- GENESIS 1.4 network connection compatibility library
#

# The following is only necessary for GENESIS 1.4 network models
# minimally ported to GENESIS 2.x.  NOTE: some of the tutorials/demos
# utilize this library.

OLDCONNLIB = axon synapse personal toolconn simconn
OLDCONNDIR = oldconn
OLDCONNOBJ = $(OLDCONNDIR)/axon/axonlib.o \
	     $(OLDCONNDIR)/synapse/synlib.o \
	     $(OLDCONNDIR)/personal/perlib.o \
	     $(OLDCONNDIR)/sim/simconnlib.o \
	     $(OLDCONNDIR)/tools/toolconnlib.o

# 
# SPRNG -- Improved random number generation
#

# The SPRNG library provides five random number generators.  To use
# SPRNG, you must specify SPRNG as one and only one of lfg, lcg,
# lcg64, or cmrg here.  Lagged Fibonacci is the default as it is the
# fastest and has the longest number sequence.
#
# Further information about SPRNG can be found at http://sprng.cs.fsu.edu/
# The link to the users guide to installation on various platforms
# (http://daniel.scri.fsu.edu/www/version1.0/platforms.html) may be useful
# to address compilation problems with the SPRNG 1 version used in GENESIS.
# 
# Note that lfg is the default and is the most tested.

SPRNG_LIB = lfg

# Disable compiling of SPRNG by uncommenting the following line and
# commenting out all the other SPRNG lines below.  If GENESIS has
# already been compiled, you'll have to do "make clean" before making
# GENESIS again.
#
# SPRNG_FLAG=
#

SPRNG_FLAG = -DINCSPRNG
SPRNGDIR   = sprng
SPRNGLIB   = $(SPRNGDIR)/lib/lib$(SPRNG_LIB).a

# ----------------------------------------------------------------------
# D. DEFINITIONS FOR SPECIFIC OPERATING SYSTEM AND COMPILER IN USE
# ----------------------------------------------------------------------
#
# Settings for various system/compiler combinations can be found in the
# appropriate Makefile.$(MACHINE) files, where MACHINE is the system name
# Uncomment the appropriate macro settings for your system and compiler
# combination there.
#
# If you are planning on using math optimization flags, please see the
# README. In particular, any gcc options which set -funsafe-math-optimizations
# (e.g. -ffast-math) will break parts of GENESIS.
#


# ----------------------------------------------------------------------
# E. CUSTOM SETTINGS
#  --> moved to Makefile.BASE
# ----------------------------------------------------------------------


# ----------------------------------------------------------------------
# F. BEGINNING OF NON-CONFIGURABLE DEFINITIONS
#
# This ends the user configurable part of the Makefile.  You shouldn't
# have to change things below this point.
# ----------------------------------------------------------------------

INSTALLBIN     = $(INSTALLDIR)/bin

#
# X11 libraries
#

XLIBS =		-L$(XLIB) \
		-lXt \
		-lX11

RCSRELEASE =	DR2-2-P1

# Makefile depending on machine architecture -> finegrain later
MF = 		Makefile.$(ARCH)

# ensure that a proper Makefile for the current architecture exists
# Terminate if not
MFD = $(SRCDIR)/$(MF)
ifeq ($(wildcard $(MFD)),)
    $(error fatal error - Makefile `$(MFD)` not found for architecture $(ARCH))
endif

SHELL = 	/bin/sh

SIMLIB	=	../lib

XODUSLIB = 	Xodus

INTERP =	ss/ss.o shell/shelllib.o

BASECODE =	sim/simlib.o sys/utillib.o $(INTERP) par/parlib.o

OBJLIBS =	buffer/buflib.o \
		segment/seglib.o \
		hh/hhlib.o \
		device/devlib.o \
		out/outlib.o \
		olf/olflib.o \
		tools/toollib.o \
		concen/conclib.o \
		hines/hineslib.o \
		user/userlib.o \
		param/paramlib.o \
		pore/porelib.o \
		$(OLDCONNOBJ) \
		$(DISKIOOBJ) \
		$(KINETICSOBJ) \
		newconn/newconnlib.o

XODUS 	=	$(XODUSLIB)/_xo/xolib.o \
		$(XODUSLIB)/_widg/widglib.o \
		$(XODUSLIB)/_draw/drawlib.o \
		$(XODUSLIB)/Draw/libDraw.a \
		$(XODUSLIB)/Widg/libWidg.a \
		$(XODUSLIB)/Xo/libXo.a

EXTRALIBS =  	$(SPRNGLIB) $(TERMCAP)

SUBDIR =        sys ss sim $(SPRNGDIR) shell newconn $(OLDCONNDIR) \
		buffer concen device hh hines olf out segment \
                tools user param pore convert $(DISKIODIR) \
                $(KINETICSDIR) Xodus par

NXSUBDIR =	sys ss shell sim $(SPRNGDIR) newconn oldconn \
		buffer concen device hh hines olf out segment \
                tools user param pore convert $(DISKIODIR) \
		$(KINETICSDIR) par

MINSUBDIR =	sys ss shell sim $(SPRNGDIR) par

LIBLIST =	output \
		hh \
		devices \
		buffer \
		segment \
		user \
		xo \
		draw \
		widg \
		olf \
		tools \
		concen \
		hines \
		param \
		pore \
		newconn \
		$(DISKIOLIB) \
		$(OLDCONNLIB) \
		$(KINETICSLIB)

NXLIBLIST = 	output \
		hh \
		devices \
		buffer \
		segment \
		user \
		olf \
		tools \
		concen \
		hines \
		param \
		pore \
		newconn \
		$(DISKIOLIB) \
		$(OLDCONNLIB) \
		$(KINETICSLIB)

PARAMS = OS="$(OS)" \
		PLATFORM=$(PLATFORM)
		MACHINE=$(MACHINE) \
		CC=$(CC) \
		CPP="$(CPP)" \
		LD="$(LD)" \
		AR="$(AR)" \
		RANLIB="$(RANLIB)" \
		YACC="$(YACC)" \
		LEX="$(LEX)" \
		LEXLIB="$(LEXLIB)" \
		TMPDIR="$(TMPDIR)" \
		INSTALLDIR="$(INSTALLDIR)" \
		INSTALLBIN="$(INSTALLBIN)" \
		CFLAGS_IN="$(CFLAGS) $(DISKIOFLAGS) $(SPRNG_FLAG)" \
		IRIX_HACK="$(IRIX_HACK)" \
		LDFLAGS="$(LDFLAGS)" \
		SPRNG_LIB="$(SPRNG_LIB)" \
		XLIBS="$(XLIBS)" \
		XINCLUDE="$(XINCLUDE)" \
		LIBS="$(LIBS)" \
		TERMCAP="$(TERMCAP)" \
		TERMOPT="$(TERMOPT)" \
		MF="$(MF)" \
		SUBDIR="$(SUBDIR)" \
		DISKIOSUBDIR="$(DISKIOSUBDIR)" \
		BASECODE="$(BASECODE)" \
		OBJLIBS="$(OBJLIBS)" \
		EXTRALIBS="$(EXTRALIBS)" \
		XODUS="$(XODUS)"

$(warning TARGET=$(TARGET))

#
# all is now the default target
#

all: code_g default

genesis: all

#
# Remove kinlib.o and text.o in case the last thing made was nxgenesis.
#
default: liblist
	@rm -f kinetics/text.o kinetics/kinlib.o
	$(MAKE) -C $(SRCDIR) -f $(MF) \
	$(PARAMS) \
	libs genesis

#	$(MAKE) -C $(SRCDIR) -f $(MF) CC="$(CC)" TMPDIR="$(TMPDIR)" LD="$(LD)" AR="$(AR)" RANLIB="$(RANLIB)" CPP="$(CPP)" YACC="$(YACC)" LEX="$(LEX)" LEXLIB="$(LEXLIB)" OS="$(OS)" MACHINE="$(MACHINE)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" CFLAGS_IN="$(CFLAGS) $(DISKIOFLAGS) $(SPRNG_FLAG)" IRIX_HACK="$(IRIX_HACK)" LDFLAGS="$(LDFLAGS)" SPRNG_LIB="$(SPRNG_LIB)" XLIBS="$(XLIBS)" XINCLUDE="$(XINCLUDE)" LIBS="$(LIBS)" TERMCAP="$(TERMCAP)" TERMOPT="$(TERMOPT)" MF="$(MF)" SUBDIR="$(SUBDIR)" DISKIOSUBDIR="$(DISKIOSUBDIR)" BASECODE="$(BASECODE)" OBJLIBS="$(OBJLIBS)" EXTRALIBS="$(EXTRALIBS)" XODUS="$(XODUS)"  libs genesis

#
# Remove kinlib.o and text.o in case the last thing made had X11 stuff.
#
nxdefault: nxliblist
	@rm -f kinetics/text.o kinetics/kinlib.o
	$(MAKE) -C $(SRCDIR) -f $(MF) \
	$(PARAMS) \
	nxlibs nxgenesis

#CC="$(CC)" TMPDIR="$(TMPDIR)" LD="$(LD)" AR="$(AR)" RANLIB="$(RANLIB)" CPP="$(CPP)" YACC="$(YACC)" LEX="$(LEX)" LEXLIB="$(LEXLIB)" OS="$(OS)" MACHINE="$(MACHINE)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" CFLAGS_IN="$(CFLAGS) $(DISKIOFLAGS) $(SPRNG_FLAG) -DNO_X" IRIX_HACK="$(IRIX_HACK)" LDFLAGS="$(LDFLAGS)" SPRNG_LIB="$(SPRNG_LIB)" LIBS="$(LIBS)" MF="$(MF)" TERMCAP="$(TERMCAP)" TERMOPT="$(TERMOPT)" SUBDIR="$(SUBDIR)" NXSUBDIR="$(NXSUBDIR)" MINSUBDIR="$(MINSUBDIR)" DISKIOSUBDIR="$(DISKIOSUBDIR)" BASECODE="$(BASECODE)" OBJLIBS="$(OBJLIBS)" EXTRALIBS="$(EXTRALIBS)" nxlibs nxgenesis

mindefault: minliblist
	$(MAKE) -C $(SRCDIR) -f $(MF) \
	$(PARAMS) \
	minlibs mingenesis

#CC="$(CC)" TMPDIR="$(TMPDIR)" LD="$(LD)" AR="$(AR)" RANLIB="$(RANLIB)" CPP="$(CPP)" YACC="$(YACC)" LEX="$(LEX)" LEXLIB="$(LEXLIB)" OS="$(OS)" MACHINE="$(MACHINE)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" CFLAGS_IN="$(CFLAGS) $(SPRNG_FLAG)" IRIX_HACK="$(IRIX_HACK)" LDFLAGS="$(LDFLAGS)" SPRNG_LIB="$(SPRNG_LIB)" LIBS="$(LIBS)" MF="$(MF)" TERMCAP="$(TERMCAP)" TERMOPT="$(TERMOPT)" SUBDIR="$(SUBDIR)" NXSUBDIR="$(NXSUBDIR)" MINSUBDIR="$(MINSUBDIR)" BASECODE="$(BASECODE)" OBJLIBS="$(OBJLIBS)" EXTRALIBS="$(EXTRALIBS)" minlibs mingenesis

code_g:
	$(MAKE) -C $(SRCDIR) -f $(MF) \
	$(PARAMS) \
	code_g

#CC="$(CC)" TMPDIR="$(TMPDIR)" LD="$(LD)" CPP="$(CPP)" YACC="$(YACC)" LEX="$(LEX)" LEXLIB="$(LEXLIB)" OS="$(OS)" MACHINE="$(MACHINE)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" CFLAGS_IN="$(CFLAGS)" IRIX_HACK="$(IRIX_HACK)" LDFLAGS="$(LDFLAGS)" LIBS="$(LIBS)" MF="$(MF)" TERMCAP="$(TERMCAP)" TERMOPT="$(TERMOPT)" SUBDIR="$(SUBDIR)" NXSUBDIR="$(NXSUBDIR)" MINSUBDIR="$(MINSUBDIR)" BASECODE="$(BASECODE)" OBJLIBS="$(OBJLIBS)" EXTRALIBS="$(EXTRALIBS)" code_g

nxgenesis: code_g nxdefault
nxall: code_g nxdefault

mingenesis: code_g mindefault
minall: code_g mindefault

liblist: Makefile
	@echo "# liblist - This file is generated automatically." > liblist
	@echo "#           DO NOT EDIT unless you are sure you" >> liblist
	@echo "#           know what you are doing.  Generally" >> liblist
	@echo "#           Makefile should be edited instead." >> liblist
	@echo $(LIBLIST) | tr ' ' '\012' >> liblist

nxliblist: Makefile
	@echo "# nxliblist - This file is generated automatically." > nxliblist
	@echo "#             DO NOT EDIT unless you are sure you" >> nxliblist
	@echo "#             know what you are doing.  Generally" >> nxliblist
	@echo "#             Makefile should be edited instead." >> nxliblist
	@echo $(NXLIBLIST) | tr ' ' '\012' >> nxliblist

minliblist: Makefile
	@echo "# minliblist - This file is generated automatically." > minliblist
	@echo "#              DO NOT EDIT unless you are sure you" >> minliblist
	@echo "#              know what you are doing.  Generally" >> minliblist
	@echo "#              Makefile should be edited instead." >> minliblist

cleandist: clean
	-(mv Makefile Makefile.bak)
	-(rm -rf $(INSTALLDIR)/bin)
	-(rm -f  $(INSTALLDIR)/Libmake)
	-(rm -f  $(INSTALLDIR)/Usermake)
	-(rm -rf $(INSTALLDIR)/startup/*)
	-(rm -rf $(INSTALLDIR)/startup/.*simrc)
	-(rm -rf $(INSTALLDIR)/startup)
	-(rm -rf $(INSTALLDIR)/lib/*)
	-(rm -rf $(INSTALLDIR)/lib)
	-(rm -rf $(INSTALLDIR)/include/*)
	-(rm -rf $(INSTALLDIR)/include)
	-(rm -f  $(INSTALLDIR)/genesis)
	-(rm -f  $(INSTALLDIR)/nxgenesis)
	-(rm -f  $(INSTALLDIR)/mingenesis)
	-(rm -rf $(INSTALLDIR)/.*simrc)
	-(rm -rf $(INSTALLDIR)/man/man1)
	-(rm -f  $(INSTALLBIN)/convert)
	-(rm -f  liblist nxliblist minliblist)
	-(rm -f  make.out nxmake.out minmake.out)
	-(rm -f  install.out nxinstall.out mininstall.out)
	-(rm -rf ../distributions)
	-(rm -f TAGS)
	-(find . -name '*~' -exec rm -f {} ';')
	@echo "Done with full clean"


clean:
	@$(MAKE) -C $(SRCDIR) -f $(MF) MF="$(MF)" DISKIOSUBDIR="$(DISKIOSUBDIR)" SUBDIR="$(SUBDIR)"  SPRNG_LIB="$(SPRNG_LIB)" clean

rcsclean:
	@$(MAKE) -C $(SRCDIR) -f $(MF) MF="$(MF)" SUBDIR="$(SUBDIR)"  rcsclean

makedirs:
	-@mkdir -p $(INSTALLDIR)
	-@mkdir -p $(INSTALLBIN)
	-@mkdir -p $(INSTALLDIR)/Doc
	-@mkdir -p $(INSTALLDIR)/Hyperdoc
	-@mkdir -p $(INSTALLDIR)/Scripts
	-@mkdir -p $(INSTALLDIR)/Tutorials
	-@mkdir -p $(INSTALLDIR)/lib
	-@mkdir -p $(INSTALLDIR)/include
	-@mkdir -p $(INSTALLDIR)/startup
	-@mkdir -p $(INSTALLDIR)/src

tags:
	etags `find . /usr/include/X11/ -name '*.[chg]' ! -name '*@*'`
	etags -a `find /usr/include -name '*.h'`

install: makedirs
	@$(MAKE) -C $(SRCDIR) -f $(MF) MF="$(MF)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" DISKIOSUBDIR="$(DISKIOSUBDIR)" SPRNG_LIB="$(SPRNG_LIB)" SUBDIR="$(SUBDIR)" RANLIB="$(RANLIB)" install

nxinstall: makedirs
	@$(MAKE) -C $(SRCDIR) -f $(MF) MF="$(MF)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" DISKIOSUBDIR="$(DISKIOSUBDIR)" SPRNG_LIB="$(SPRNG_LIB)" NXSUBDIR="$(NXSUBDIR)" RANLIB="$(RANLIB)" nxinstall

mininstall: makedirs
	@$(MAKE) -C $(SRCDIR) -f $(MF) MF="$(MF)" INSTALLDIR="$(INSTALLDIR)" INSTALLBIN="$(INSTALLBIN)" SPRNG_LIB="$(SPRNG_LIB)" MINSUBDIR="$(MINSUBDIR)" RANLIB="$(RANLIB)" mininstall

VERSNAME="genesis-2.3"
bindist: genesis nxgenesis
	make INSTALLDIR="`pwd`/../distributions/$(VERSNAME)/genesis" install
	cp nxgenesis "../distributions/$(VERSNAME)/genesis"
	(cd ..; \
	cp AUTHORS CONTACTING.GENESIS COPYRIGHT GPLicense LGPLicense \
		README README.bindist binsetup "distributions/$(VERSNAME)/genesis";)
	(cd ../distributions; \
	cp $(VERSNAME)/genesis/src/startup/*simrc $(VERSNAME)/genesis/startup;\
	rm -f $(VERSNAME)/genesis/startup/\.*simrc;\
	rm -rf $(VERSNAME)/genesis/src; \
	tar czf $(VERSNAME)-$(MACHINE)-bin.tar.gz -X ../src/excludeFromBinary $(VERSNAME);\
	tar cjf $(VERSNAME)-$(MACHINE)-bin.tar.bz2 -X ../src/excludeFromBinary $(VERSNAME);\
	rm -rf $(VERSNAME))

#
# make separate source dists for genesis and pgenesis.
# cvs export must be used so that empty directories are pruned.
#
srcdist: 
	-@mkdir -p ../distributions
	(CVSROOT=$(USER)@cvs.sf.net:/cvsroot/genesis-sim; \
	CVS_RSH=ssh; \
	cd ../distributions; \
	cvs export -D now genesis2 > /dev/null; \
	mv genesis2 $(VERSNAME); \
	tar cZf $(VERSNAME)-src.tar.Z -X ../src/excludeFromSrc $(VERSNAME)/genesis; \
	md5sum $(VERSNAME)-src.tar.Z > $(VERSNAME)-src.tar.Z.md5; \
	tar czf $(VERSNAME)-src.tar.gz -X ../src/excludeFromSrc $(VERSNAME)/genesis; \
	md5sum $(VERSNAME)-src.tar.gz > $(VERSNAME)-src.tar.gz.md5; \
	tar cjf $(VERSNAME)-src.tar.bz2 -X ../src/excludeFromSrc $(VERSNAME)/genesis; \
	md5sum $(VERSNAME)-src.tar.bz2 > $(VERSNAME)-src.tar.bz2.md5; \
	tar cZf p$(VERSNAME)-src.tar.Z -X ../src/excludeFromSrc $(VERSNAME)/pgenesis; \
	md5sum p$(VERSNAME)-src.tar.Z > p$(VERSNAME)-src.tar.Z.md5; \
	tar czf p$(VERSNAME)-src.tar.gz -X ../src/excludeFromSrc $(VERSNAME)/pgenesis; \
	md5sum p$(VERSNAME)-src.tar.gz > p$(VERSNAME)-src.tar.gz.md5; \
	tar cjf p$(VERSNAME)-src.tar.bz2 -X ../src/excludeFromSrc $(VERSNAME)/pgenesis; \
	md5sum p$(VERSNAME)-src.tar.bz2 > p$(VERSNAME)-src.tar.bz2.md5; \
	rm -rf $(VERSNAME))
	-cp README ../distributions/README.$(VERSNAME)
	-cp ChangeLog ../distributions/ChangeLog.$(VERSNAME)

TestSuite:
	(cd ..; \
		tar czf TestSuite.tar.gz --exclude CVS TestSuite; \
		tar cjf TestSuite.tar.bz2 --exclude CVS TestSuite)

		

# ----------------------------------------------------------------------
# G. REVISION HISTORY
# ----------------------------------------------------------------------

# $Log: Makefile.dist,v $
# Revision 1.39  2006/03/18 00:49:35  svitak
# Removed rename of README in bindist target.
#
# Revision 1.38  2006/03/17 17:47:00  svitak
# Some minor changes to srcdist and bindist targets.
#
# Revision 1.37  2006/03/16 21:59:29  svitak
# Changes to reflect new location of excludeFrom<Src|Binary>.
# Modified comments for OSX.
#
# Revision 1.36  2006/03/01 19:44:57  svitak
# Changed path to cpp for Solaris using Sun WS compilers.
#
# Revision 1.35  2006/02/17 06:44:10  svitak
# Added md5sums to srcdist target.
#
# Revision 1.34  2006/02/17 06:35:18  svitak
# Removed extra bindist target.
#
# Revision 1.33  2006/01/17 17:28:37  svitak
# Added warning comment about math optimizations.
#
# Revision 1.32  2006/01/17 17:22:00  svitak
# Removed cleandist of tests/TestSuite since it is now a separate package.
#
# Revision 1.31  2006/01/11 06:25:53  svitak
# Added Tutorials to list of things installed.
#
# Revision 1.30  2005/12/16 12:37:46  svitak
# Added more files to bindist target directory.
#
# Revision 1.29  2005/12/16 09:21:59  svitak
# Added targets for developers to create source and binary distributions and a
# separate TestSuite.
#
# Revision 1.28  2005/11/21 02:11:29  svitak
# Changed version from 2.2.1 to 2.3
#
# Revision 1.27  2005/10/23 17:34:32  svitak
# Remove kinetics/kinlib.o kinetics/text.o before every make to avoid
# conflicts between X and nonX variants.
#
# Revision 1.26  2005/10/20 22:09:06  svitak
# New comments re: cygwin compilation.
#
# Revision 1.25  2005/10/16 21:05:36  svitak
# Attempt to clean .out (e.g. make.out) and liblist files for cleandist
# target.
#
# Revision 1.24  2005/10/16 20:57:52  svitak
# Makefile moved to Makefile.bak for cleandist target.
#
# Revision 1.23  2005/10/16 20:49:27  svitak
# Comment updates.
#
# Revision 1.22  2005/10/14 17:15:00  svitak
# Comment updates.
#
# Revision 1.21  2005/10/06 22:12:40  svitak
# Comment updates.
#
# Revision 1.20  2005/10/06 17:52:18  svitak
# Comment additions. SPRNGLIB now references SPRNGDIR.
#
# Revision 1.19  2005/09/29 21:16:34  ghood
# added section for Cray XT3
#
# Revision 1.18  2005/09/21 01:23:05  svitak
# Minor comment change for Linux.
#
# Revision 1.17  2005/08/24 03:14:56  ghood
# -I is now contained within XINCLUDE; renamed platform alpha to decalpha
#
# Revision 1.16.2.1  2005/08/23 17:41:52  svitak
# Added Makefile to cleandist target.
#
# Revision 1.16  2005/08/12 20:00:17  svitak
# More complete cleanup for make cleandist.
#
# Revision 1.15  2005/08/12 01:14:52  ghood
# Added par library to list of libraries to be linked in.
#
# Revision 1.14  2005/08/08 13:12:21  svitak
# Added Xeon to list of Linux hware supported.
#
# Revision 1.13  2005/08/08 10:42:23  svitak
# Changed full path $(TEST) to unpathed test.
#
# Revision 1.12  2005/07/29 15:47:10  svitak
# Relocated common targets to Makefile.BASE. Some architectures were making
# in sys and shell, then all the subdirs. If you find this needs to be done
# for your architecture, please submit a bug report at:
# http://sourceforge.net/tracker/?func=add&group_id=141069&atid=748364
#
# Eliminated use of COPT in favor of CFLAGS_IN.
#
# Added architecture-dependent flags for compilation of SPRNG libraries to
# corresponding Makefiles.
#
# Changed INSTALL to INSTALLDIR to avoid confusion with INSTALL executable.
#
# Added TEST variable to allow different location of 'test' executable.
#
# Made TMPDIR setting more prominent.
#
# Updated instructions for making genesis.
#
# Revision 1.11  2005/07/19 21:53:02  svitak
# Some comment changes for Darwin and some encouragement to NOT use
# lcg64 as it is a different rng and will produce different results
# than lfg.
#
# Revision 1.10  2005/07/11 08:59:02  svitak
# Added some comments to make it easier to compile on modern Solaris with GCC.
#
# Revision 1.9  2005/07/11 06:21:21  svitak
# Removed references to PARSER since it is no longer used.
#
# Revision 1.8  2005/07/10 06:05:20  svitak
# Removed comments encouraging use of lcg64 on 64bit Linuxes. It does not
# work!
#
# Revision 1.7  2005/07/07 20:34:20  svitak
# Just some comment changes.
#
# Revision 1.6  2005/06/29 18:04:55  svitak
# Added some comments for building on 64-bit Linux machines.
#
# Revision 1.5  2005/06/24 20:32:48  svitak
# Removed defines of __GLIBC from compile lines. This is never used. The
# correct macro, __GLIBC__, is defined by the precompiler when appropriate.
#
# Revision 1.4  2005/06/18 18:16:15  svitak
# Added section for MacOSX Darwin PPC-based systems.
#
# Revision 1.3  2005/06/17 21:54:51  svitak
# Files within directories Xo & xo, Draw & draw, and widg & Widg ended up
# in the same place on case-insensitive file systems. To remedy this,
# xo was renamed to _xo, draw was renamed to _draw, and widg was renamed to _widg.
# The XODUS variable in this file was changed to reflect the new directory names.
#
# Revision 1.2  2005/06/17 20:16:54  svitak
# Added a section with Cygwin definitions.
#
# Revision 1.1.1.1  2005/06/14 04:38:27  svitak
# Import from snapshot of CalTech CVS tree of June 8, 2005
#
# Revision 1.148  2003/05/29 22:07:29  gen-dbeeman
# Changes to fix compilation problems for Irix and Solaris (gcc)
#
# Revision 1.147  2003/03/28 20:42:23  gen-dbeeman
#
# Changes provided by Malcom Tobias to allow IRIX 32 or 64 bit compilation
# flags to be passed down from the main genesis/src/Makefile.
#
# Revision 1.146  2001/07/22 17:53:18  mhucka
# Final updates for 2.2 release.
#
# Revision 1.145  2001/06/29 22:03:21  mhucka
# Updates for more systems.
#
# Revision 1.144  2001/05/10 16:13:56  mhucka
# More work on LinuxPPC.
#
# Revision 1.143  2001/05/10 16:12:03  mhucka
# First version of PPC support, based on work by Alfonso Delgado-Reyes.
#
# Revision 1.142  2001/05/09 15:16:02  mhucka
# Changes for IBM AIX and DEC Alpha.
#
# Revision 1.141  2001/03/30 05:20:00  mhucka
# Updates for FreeBSD.
#
# Revision 1.140  2000/10/12 22:06:22  mhucka
# Added minor comment to AIX section, and made the "makedirs" directive
# ignore errors.
#
# Revision 1.139  2000/10/10 16:55:06  mhucka
# Turns out that compiling with optimization settings higher than -xO1 with
# the Solaris Workshop 5.0 cc compiler causes some widgets in Xodus to fail
# to work properly.  So had to revise the compiler flags for Solaris case.
#
# Revision 1.138  2000/10/09 23:55:02  mhucka
# More updates to several platforms.
#
# Revision 1.137  2000/09/21 19:39:58  mhucka
# 1) Now using -O2 for gcc.
# 2) Updated definitions for AIX
#
# Revision 1.136  2000/09/11 21:46:05  mhucka
# nxinstall and mininstall weren't running the makedirs directive.
#
# Revision 1.135  2000/09/11 16:24:45  mhucka
# Moved where TERMCAP is used, to EXTRALIBS.
#
# Revision 1.134  2000/07/12 08:52:02  mhucka
# Fixed IRIX config to work for 6.5.8.
# Added INSTALL/src to directories created by makedirs directive.
#
# Revision 1.133  2000/07/03 21:10:07  mhucka
# Made a number of changes to the IRIX compilation flags, including changing
# from using -cckr to -xansi.  The previous combination of flags didn't turn
# out to work properly for both n32 and o32 and non-GNU make on the SGI.
# Making it all work required changes to a lot of other files too.
#
# Revision 1.132  2000/06/23 04:18:48  mhucka
# Added partial AIX support from Giri Chukkpalli and Chuck Charman @ SDSC.
#
# Revision 1.131  2000/06/21 23:44:02  mhucka
# Fixed up some of the make clean directives.
#
# Revision 1.130  2000/06/21 23:43:07  mhucka
# Additional changes to the ld flags under IRIX, plus some comments for the
# IRIX section.
#
# Revision 1.129  2000/06/12 04:01:42  mhucka
# 1) Added IRIX_HACK defines that were missing from previous check-in.
# 2) Updated cc compiler options for irix.
# 3) Made "make cleandist" remove TAGS file, made "make clean" leave it.
#
# Revision 1.128  2000/06/12 03:57:37  mhucka
# Added an awful, bletcherous hack.  The variable IRIX_HACK is used in only two
# places, ss/Makefile and convert/Makefile, to pass the -w option to the IRIX
# cc compiler when y.tab.c is being compiled.  The reason is to avoid getting
# two hundred warnings under the IRIX cc compiler.  The warnings are generated
# for things like "statement is unreachable", but it's in code (y.tab.c) that's
# generated by lex, so there's nothing we can do.  I wish there was a cleaner
# way of supplying a flag selectively like this, without resorting to passing
# IRIX_HACK all over the place just for this one thing.
#
# Revision 1.127  2000/06/07 05:51:04  mhucka
# 1) Changed LINKFLAGS to LDFLAGS.
# 2) Fixed IRIX flags to work with current version of GENESIS.
# 3) Not using MACH_DEP_FLAGS anymore.
# 4) Added missing param library to definition of LIBLIST.
# 5) Don't delete liblist after all.
#
# Revision 1.126  2000/05/26 23:39:09  mhucka
# Added new INSTALLBIN for things like the convert program (and other
# utilities in the future).
#
# Revision 1.125  2000/05/26 22:42:12  mhucka
# The target for genesis should make "all", not just "default".
#
# Revision 1.124  2000/05/26 22:18:55  mhucka
# 1) Solaris needs -DBIGENDIAN in CFLAGS.
# 2) There was an -I in the CFLAGS for Solaris.
# 3) Added genesis, nxgenesis, mingenesis as make targets.
# 4) Added more directories to make makedirs actions.
#
# Revision 1.123  2000/05/25 03:11:41  mhucka
# Fixed a comment in the linux section.
#
# Revision 1.122  2000/05/25 03:07:50  mhucka
# 1) Minor clean up of make clean actions.
# 2) Added /usr/include/X11 to list of directories used for make tags
# 3) Added SPRNG_LIB to list of vars passed for make install, so that
#    the SPRNG library is installed.
#
# Revision 1.118  2000/04/19 07:34:13  mhucka
# Added a remove of liblist; made the makedirs use -p.
#
# Revision 1.117  1999/12/31 08:30:06  mhucka
# Tons of updates -- more than I can remember.
#
# Revision 1.113  1999/10/13 02:27:02  mhucka
# Added changes for Red Hat 6.0.
# Added changes for SGI IRIX.
# Did major overhaul of comments througout file in an attempt
# to improve clarity and visual impact.
#
# Revision 1.112  1999/08/22 04:42:13  mhucka
# Various fixes, mostly for Red Hat Linux 6.0
#
# Revision 1.111  1999/08/22 03:22:09  mhucka
# Tiny comment about where one of the Sun Solaris sections ends.
#
# Revision 1.110  1999/05/06 01:03:06  mhucka
# Changed the configuration for SGI IRIX to match what I used to successfully
# compile GENESIS 2.1 under IRIX 6.5.3 using SGI's C compiler version 7.2.1.
#
# Revision 1.109  1999/04/26 03:45:59  mhucka
# Added a section for Solaris 2.x using GCC 2.8.1.  This seemed reasonable
# to have in addition to the existing section for Solaris 2.x using the
# SunPro C compiler.
#
# Revision 1.108  1998/08/28 17:11:02  dhb
# Added comments for working around libtermcap.a not in /usr/lib for
# some Linux variants.
#
# DR2-2-P1
#
# Revision 1.107  1998/07/22 06:03:34  dhb
# Fix for conditional diskio library flags; prevents empty -D
# options on compile lines
#
# Revision 1.106  1998/07/22  05:31:25  dhb
# DR2-2
#
# Revision 1.105  1998/04/21  22:41:46  dhb
# Support for excluding SPRNG
#
# Revision 1.104  1998/01/20 02:40:31  venkat
# Cleaned up settings for SGI 5.x and 6.x . Used CFLAGS and LINKFLAGS instead of
# crowding up the CC macro.
#
# Revision 1.103  1998/01/20 01:50:31  venkat
# Added the -32 flag to CC for O32 settings on the SGI.
# This is needed on later 6.x systems to explicitly
# compile for 32-bit.
#
# Revision 1.102  1998/01/20  01:38:20  venkat
# Removed extra tab in a blank line.
#
# Revision 1.101  1998/01/20  01:04:19  venkat
# SGI Irix settings changes for 32 and 64-bit executables
#
# Revision 1.100  1998/01/15  01:16:28  venkat
# Added the missing DISKIOSUBDIR macro in the default and nxdefault
# command lines
#
# Revision 1.99  1998/01/14  23:27:40  venkat
# Fixed error in addition of diskio specific flag settings in CFLAGS
# for default and nxdefault targets.
#
# Revision 1.98  1998/01/14 21:52:33  venkat
# diskio library enhancements to include FMT1 support. User can as before
# opt to exclude the diskio library entirely. If included, FMT1 support
# is incorporated by default. netcdf support is optional.
#
# Revision 1.97  1998/01/08  23:54:52  dhb
# Support for SPRNG random number library.  User can select
# which of the SPRNG generators is used.  All default SPRNG
# generators are compiled and installed.
#
# Revision 1.96  1997/10/03 00:05:11  dhb
# REL2-1-P1
#
# Revision 1.95  1997/08/12 22:04:39  dhb
# Moved -lcurses from LIBS to LEXLIB to get code_g to link.
#
# Revision 1.94  1997/08/12 19:08:55  dhb
# Additional comments at top to suggest commenting optional libraries
# when having compile problems.
#
# Removed Linux a.out from diskio problem systems.
#
# Added -lcurses for aix compiles.
#
# Revision 1.93  1997/08/11 22:23:55  dhb
# REL2-1
#
# Revision 1.92  1997/08/08 21:43:15  dhb
# Added comments about requiring bison and flex for 64-bit IRIX
#
# Revision 1.91  1997/08/08 21:39:33  dhb
# Added IRIX 6.x 64-bit settings from Elliot Menschik.
#
# Revision 1.90  1997/08/08 19:30:59  dhb
# DR2-1-P4
#
# Revision 1.89  1997/08/01 18:54:25  dhb
# Added comments on diskio compile problems for Paragon and T3E.
#
# Revision 1.88  1997/07/31 20:18:19  dhb
# Fix to nxliblist actions so that comments appear in nxliblist
#
# Revision 1.87  1997/07/31 19:16:09  dhb
# DR2-0-P3
#
# Revision 1.86  1997/07/25 23:36:14  dhb
# Moved addtional oldconn library names to OLDCONNLIB (i.e.
# axon synapse and personal).
#
# Revision 1.85  1997/07/25 01:33:52  dhb
# Added kinetics and diskio as optional libraries
# Added automatic generation of liblist files
#
# Revision 1.84  1997/07/18 19:02:13  dhb
# Support for Cray T3E.
#
# Fix to paragon MACHINE macro setting
#
# Small comment changes
#
# Revision 1.83  1997/07/18 14:41:25  dhb
# Simplified Makefile configuration by creating complete sets of
# macro sets for various systems and compilers.  Corresponding
# changes to make instructions.
#
# Revision 1.82  1997/06/30 18:50:21  dhb
# Updated to DR2-1
#
# Revision 1.81  1997/06/12 23:57:56  dhb
# Removed -traditional from several gcc CFLAGS lines and added
# prominent comment about trying -traditional if a compile fails
#
# Revision 1.80  1997/06/12 23:47:26  dhb
# Added -P to CPP defines in machine specific sections.
#
# Separated CPP define and explanation about finding cpp and
# setting the CPP macro from the main Linux specific settings
#
# Made the all target the default so users can just type "make"
#
# Revision 1.79  1997/06/12 22:37:23  dhb
# Added machine specific section for IRIX 6.x
#
# Revision 1.78  1996/11/01 23:53:15  dhb
# REL2-0-P2
#
# Revision 1.77  1996/10/28  23:36:16  dhb
# DR2-0-P7
#
# Added a new target called "nodefault" which is actually the default
# Makefile target.  Prints a message that there is no default target
# and to use "make all" instead.
#
# Revision 1.76  1996/10/07  21:25:25  dhb
# DR2-0-P6
#
# Revision 1.75  1996/10/05  17:49:21  dhb
# Added comments regarding use of ncurses on Linux systems.
#
# Revision 1.74  1996/08/10  22:36:04  dhb
# DR2-0-P5
#
# Revision 1.73  1996/07/29  23:14:59  dhb
# DR2-0-P4
#
# Revision 1.72  1996/07/09  06:30:29  dhb
# Added PARSER=yacc as default value of PARSER; avoids empty
# -D compiler argument
#
# Revision 1.71  1996/06/28  22:53:18  dhb
# Additional mods for Paragon.
#
# DR2-0-P3
#
# Revision 1.70  1996/06/26  18:20:09  venkat
# Added the PARSER macro to identify the parser (yacc / bison) used and passedf
# it along with the COPTS macro to the sub-makes.
#
# Revision 1.69  1996/06/18  07:07:08  dhb
# Support for AR macro.
#
# Revision 1.68  1996/05/24  22:44:38  dhb
# Changed RCSRELEASE to DR2-0-P2
#
# Revision 1.67  1996/05/23  23:13:55  dhb
# Added -P to default cpp command line.
#
# Removed t3d specific settings for LD and LDFLAGS as these are
# handled in the lower level makefile.
#
# Revision 1.66  1996/05/17  21:14:04  dhb
# T3D changes
#
# Revision 1.65  1995/12/13  23:18:08  dhb
# REL2-0-P2
#
# Revision 1.64  1995/11/10  23:17:54  dhb
# Updated RCSRELEASE for REL2-0-P1
#
# Revision 1.63  1995/11/08  00:10:44  dhb
# Added -P option to cpp for hpux.
#
# Revision 1.62  1995/11/04  18:57:24  dhb
# Additional comments for Solaris 2.4 yacc problem
#
# CCTMPDIR is added to the CFLAGS by passing it with the CFLAGS
# macro via COPT macro on the sub make command line.
#
# Revision 1.61  1995/11/03  01:59:37  dhb
# Added TMPDIR macro to allow setting an alternate temp directory
# during the compile.
#
# Added instructions for:
# 	SunOS 4.1.[234] unresolved X11 symbols problem
#
# 	Solaris 2.4 yacc problem
#
# Now we pass down LEXLIB on make code_g so we don't hardcode the
# lex library in sys/Makefile.
#
# Revision 1.60  1995/09/27  20:35:05  dhb
# DR2-0-P1
#
# Revision 1.59  1995/08/09  17:30:56  dhb
# REL2-0
#
# Revision 1.58  1995/08/05  18:26:58  dhb
# Small changes to flex comments regarding SGIs.
#
# Revision 1.57  1995/08/05  02:35:42  dhb
# BETA2-0-P18
#
# Revision 1.56  1995/08/03  20:15:30  dhb
# BETA2-0-P17
#
# Revision 1.55  1995/08/02  01:55:41  dhb
# BETA2-0-P16
#
# Revision 1.54  1995/07/29  17:50:21  dhb
# Added comments about using flex for SGI machines.
#
# BETA2-0-P15
#
# Revision 1.53  1995/07/21  19:47:06  dhb
# HPUX changes.  Old comments regarding the need for special X11
# libraries removed.  Machine specific settings added.
#
# BETA2-0-P14
# /
#
# Revision 1.52  1995/07/08  19:28:40  dhb
# Removed X11R3 support as Xodus will no longer compile with
# anything less than X11R4.
#
# BETA2-0-P13
#
# Revision 1.51  1995/06/24  00:19:01  dhb
# Addition FreeBSD related changes.
#
# Revision 1.50  1995/06/23  23:49:49  venkat
# BETA2-0-P12
#
# Revision 1.49  1995/06/16  23:35:11  venkat
# BETA2-0-P11
#
# Revision 1.48  1995/06/16  17:11:27  dhb
# Added support for FreeBSD.
#
# Revision 1.47  1995/06/12  17:16:25  dhb
# BETA2-0-P10
#
# Revision 1.46  1995/06/03  00:20:12  dhb
# BETA2-0-P9
#
# Revision 1.45  1995/05/31  01:10:29  dhb
# BETA2-0-P8
#
# Revision 1.44  1995/05/26  17:01:44  dhb
# Additional comments about XLIB for Linux systems.
# BETA2-0-P7
#
# Revision 1.43  1995/05/17  21:30:07  dhb
# BETA2-0-P6
#
# Revision 1.42  1995/05/11  20:41:48  dhb
# Changed install targets to pass RANLIB value down to system makefiles
# as RANLIB_IN.
#
# Revision 1.41  1995/05/08  22:43:03  dhb
# Additional comments for Solaris using gcc.
# BETA2-0-P5
#
# Revision 1.40  1995/04/29  01:11:24  dhb
# Added handling of YACC, LEX and LEXLIB macros to define the
# yacc and lex programs and the lex libraries respectively.
#
# Revision 1.39  1995/04/28  19:43:38  dhb
# Various system dependent suggestion changes.
# BETA2-0-P4
#
# Revision 1.38  1995/04/16  01:22:37  dhb
# Modified suggested alpha macro settings to use cc -std0 -DGETOPT_PROBLEM
# which hopefullly will be portable across alpha platforms.
#
# Revision 1.37  1995/04/13  20:55:22  dhb
# Added info about the -DGETOPT_PROBLEM define.
#
# BETA2-0-P3
#
# Revision 1.36  1995/04/11  23:09:53  dhb
# Removed -lICE and -lSM suggestion for Linux compiles.
#
# Revision 1.35  1995/04/07  22:42:17  dhb
# BETA2-0-P2
#
# Revision 1.34  1995/04/05  00:55:00  dhb
# Added stuff for MACHINE=aix
#
# Revision 1.33  1995/04/01  17:11:13  dhb
# BETA2-0-P1
#
# Revision 1.32  1995/03/29  16:45:20  dhb
# BETA2-0
#
# Revision 1.31  1995/03/28  18:29:38  dhb
# Added CPP macro setting for Solaris SUNPro cc.
#
# Revision 1.30  1995/03/27  18:41:41  dhb
# Added DEC Alpha as an option for MACHINE with compiler
# specific macro settings.
#
# Revision 1.29  1995/03/27  18:23:28  dhb
# Missing backslash in XLIBS macro definition.
# DEVREL2-0-9-P5
#
# Revision 1.28  1995/03/24  22:00:20  dhb
# - Changed X11 libraries from full path specs to use -L and -l
# - Added additional comments for Linux settings
# - DEVREL2-0-9-P4
#
# Revision 1.27  1995/03/23  18:31:18  dhb
# Modified suggested macro setting for SGI and Decstation.
#
# Revision 1.26  1995/03/21  21:12:58  dhb
# DEVREL2-0-9-P3
#
# Revision 1.25  1995/03/02  18:46:16  dhb
# DEVREL2-0-9-P2
#
# Revision 1.24  1995/02/23  00:15:54  dhb
# Updated to DEVREL2-0-9-P1
#
# Revision 1.23  1995/02/22  19:04:53  dhb
# Linux support.
#
# Revision 1.22  1995/02/14  01:08:28  dhb
# cleandist now removed convert and X1compat scripts
#
# Revision 1.21  1995/02/11  06:49:12  dhb
# Added convert to the SUBDIRS and NXSUBDIRS.
#
# Revision 1.20  1995/02/11  06:35:15  dhb
# Updated RCSRELEASE to DEVREL2-0-9.
#
# Revision 1.19  1995/01/25  02:24:09  dhb
# Updated for X11R6.
#
# Revision 1.18  1995/01/18  01:49:46  dhb
# 2.0.8 patch 3 update
#
# Revision 1.17  1995/01/14  01:02:46  dhb
# Update to 2.0.8 patch 2
#
# Revision 1.16  1995/01/09  23:04:55  dhb
# Made the default XINCLUDE directory . instead of nothing.  Some
# compilers will complain if given an empty -I option.
#
# Revision 1.15  1995/01/09  19:34:38  dhb
# RCSRELEASE macro change in 1.14 was wrong.
#
# Revision 1.14  1995/01/09  18:31:11  dhb
# Changed inconsistent instructions at end of user changable part of
# Makefile.
#
# Updated RCSRELEASE macro to reflect current release.
#
# Revision 1.13  1994/12/21  00:36:05  dhb
# Moved RCS log information to the end of the file.
#
# Revision 1.12  1994/12/20  23:23:26  dhb
# Added all, nxall and minall targets and updated instructions in
# Makefile to use the all targets.
#
# Revision 1.11  1994/12/06  01:45:40  dhb
# Added the XINCLUDE macro
#
# Revision 1.10  1994/09/23  17:09:28  dhb
# Added a 'make code_g' to the users instruction comments.
#
# Revision 1.9  1994/09/23  16:22:04  dhb
# Changes for move of connections out of main libraries into oldconn.
#
# Revision 1.8  1994/04/14  14:51:50  dhb
# Now passes RANLIB macro down in install targets
#
# Revision 1.7  1994/04/13  20:07:39  dhb
# Changed the makefile comments for compiler dependent options
#
# Revision 1.6  1994/04/04  21:25:45  dhb
# Added RANLIB macro to handle systems without ranlib.
#
# Moved compiler depended macro settings to src/Makefile.
#
# Revision 1.5  1994/03/23  00:23:11  dhb
# Changes for Xodus version 2 and the newconn library.
#
# Revision 1.4  1994/03/22  23:56:31  dhb
# Changed codeg target to code_g (the actual program name).
#
# Revision 1.3  1994/03/21  18:25:36  dhb
# Changes to make code_g program
#
# Revision 1.2  1993/10/19  18:53:27  dhb
# RCS changes and libsh --> ./libsh
#
