#    Elaya, the compiler for the elaya language
#    Copyright (C) 1999-2002  J.v.Iddekinge.
#    Email : iddekingej@lycos.com
#    Web   : www.elaya.org
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


root_path=../../

include $(root_path)Makefile.inc

.PHONY : all clean


all: bin/cfgc


bin/cfgc :cfgc.pas
		$(Fpc) cfgc $(Opt_Fpc) -FEbin -Fu$(Dir_Cpl_Lib)

install:
	cp bin/cfgc$(exe_ext)  $(Dir_Program)
        
clean :
	rm bin/*

