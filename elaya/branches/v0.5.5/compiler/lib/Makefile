#   Elaya,; the compiler for the ;elaya language
#    Copyright (C) 1999,2001  J.v.Iddekinge.
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

include ../../Values.tpl


vpath %.ppu $(Dir_Cpl_Lib)
vpath %.ppw $(Dir_Cpl_Lib)

FPC=$(Fpc) $(Opt_Fpc)  -FU$(Dir_Cpl_Lib)
.PHONY:all plat clean clean_linux clean_win32 stdobj display cfgp cmp_base

files=$(subst ",,$(foreach dir,$(basename $(wildcard *.pas)),",$(dir)"))
dollar=$$

all: plat lib.dep dummy.ppu

plat:
	make -C$(Cpl_Target)

$Unit_Ext:=".ppu"
ifeq ($(Cpl_Target),win32)
$Unit_Ext:=".ppw"
endif

clean:
	$(cmd_rm) $(Dir_Cpl_Lib)$(Dir_Sep)*
	$(cmd_rm) dummy.pp
	$(cmd_rm) lib.dep

dummy.pp: *.pas
	echo "uses classes$(files);" > dummy.pp
	echo "begin ">>dummy.pp
	echo "end." >>dummy.pp

lib.dep: dummy.pp *.pas
	ppdep dummy -A"touch \$(dollar)(Dir_Cpl_Lib)/* && \$(dollar)(FPC)" >lib.dep

include lib.dep
