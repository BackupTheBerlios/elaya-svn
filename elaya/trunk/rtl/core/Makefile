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

root_path=../../
include $(root_path)Makefile.inc

all:
	make all -C core  
	make all -C $(rtl_target) 
	make all -C common 

dep:
	make dep -C core  
	make dep -C $(rtl_target) 
	make dep -C common 

clean:
	make clean -C core 
	make clean -C $(rtl_target) 
	make clean -C common 
