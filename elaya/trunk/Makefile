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




.PHONY:all clean rtl tools cfg compiler

include Values.tpl

all :setup eladep compiler tools cfg rtl 

setup : Values.tpl


Values.tpl: configure param.*
	./configure $(Os_Host)

compiler: eladep
	$(MAKE) all -C compiler

eladep : setup
	$(MAKE) all -C tools/eladep

tools  : compiler
	$(MAKE) all -C tools

cfg    : compiler tools
	$(MAKE) all -C cfg

rtl    :  compiler tools cfg
	$(MAKE) all -C rtl

clean  : 
	  $(MAKE) clean -C compiler
	  $(MAKE) clean -C rtl
	  $(MAKE) clean -C cfg
	  $(MAKE) clean -C tools
