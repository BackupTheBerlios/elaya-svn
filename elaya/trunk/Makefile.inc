#    Elaya, the compiler for the elaya language
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

include $(root_path)config/build_conf.gen

ifndef rtl_target
      rtl_target=$(os_host)
endif

include $(root_path)config/build_conf.$(os_host).$(rtl_target)

ifeq ($(Cpl_Target),win32)
	a=$(shell rename *.PAS *.pas)
	a=$(shell rename *.ELA *.ela)
endif

Fpc_Unit_Path=$(Fpc_Opt_Unit_Path);$(Dir_Cpl_Lib)

LIB_ELA=$(ELA) -c lib.cfg $(Opt_Ela)
LIB_FPC=$(Fpc) -Fu"$(Fpc_Unit_Path)" -FU$(Dir_Cpl_Lib) $(Opt_Fpc) 
EXE_FPC=$(Fpc) -Fu"$(Fpc_Unit_Path);$(Dir_Dirt)" -FU$(Dir_Dirt) -FE$(Dir_Program) $(Opt_Fpc) 
