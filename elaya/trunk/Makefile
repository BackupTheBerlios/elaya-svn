#   Elaya,; the compiler for the ;elaya language
#    Copyright (C) 1999-2003  J.v.Iddekinge.
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA




.PHONY:all clean rtl tools cfg compiler config



all :eladep compiler tools cfg rtl

config:tools/config/bin/bc
	$(MAKE) all -f conf.Makefile

config/build_conf.gen:build_files/config/bc.*
	$(MAKE) all -f conf.Makefile

tools/config/bin/bc:tools/config/bc.pas
	$(MAKE) all -C tools/config


compiler: eladep
	$(MAKE) all -C compiler

eladep : config/build_conf.gen
	$(MAKE) all -C tools/eladep

tools  : compiler
	$(MAKE) all -C tools

cfg    : compiler tools
	$(MAKE) all -C cfg

rtl    :  compiler tools cfg
	$(MAKE) all -C rtl

install:
	$(MAKE) install -C compiler
	$(MAKE) install -C rtl
	$(MAKE) install -C tools/eladep
	$(MAKE) install -C cfg

distclean:clean
	$(cmd_rm) config/*
	$(cmd_rm) -f cfg/ela.tpl
	$(rmd_rm) -r cfg/lib.tpl

clean  :
	$(MAKE) clean -C compiler
	$(MAKE) clean -C rtl
	$(MAKE) clean -C cfg
	$(MAKE) clean -C tools
