#   Elaya,; the compiler for the elaya language
#    Copyright (C) 1999-2003  J.v.Iddekinge.
#	Web: www.elaya.org
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
include ../../Makefile.inc

.PHONY:all clean all_win32 all_linux

exe_name=$(Dir_Program)/ela$(exe_ext)

all : $(exe_name)


	
clean:
	$(cmd_rm)  $(foreach fn,$(wildcard *.pas),$(Dir_Dirt)$(Dir_Sep)$(basename $(fn)).*)
	$(cmd_rm)  $(exe_name)

	
$(exe_name) :*.pas clean
	$(EXE_FPC) ela


