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
include $(root_path)/Makefile.inc

eladep_program=eladep$(exe_ext)

.PHONY : all clean copy_exe_to link_exe_to

name=eladep
outfile=bin/$(name)$(exe_ext)
all: $(outfile)


$(outfile) :eladep.pas
		$(LIB_FPC) eladep $(Opt_Fpc) -FEbin -Fu"$(Fpc_Unit_Path)"

install: copy_exe_to $(if $link_exe_to,link_exe_to)

copy_exe_to:
	cp bin/$(eladep_program) $(Dir_Program)
	
link_exe_to: copy_exe_to
	rm -f $(link_exe_to_dir)$(eladep_program)
	ln -s $(Dir_Program)$(eladep_program) $(link_exe_to_dir)$(eladep_program)

clean : 
	$(cmd_rm) $(outfile)

