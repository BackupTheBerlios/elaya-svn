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

othall=all_as
othclean=clean_as
rtl_out=$(Dir_Ela_Rtl_Base)/$(rtl_target)

inc_path=../../..
include $(inc_path)/Makefile.ela

all_as:$(rtl_out)/inter.o
clean_as:
	rm -f $(rtl_out)/inter.o

$(rtl_out)/inter.o: inter.as
	as inter.as -o$(rtl_out)/inter.o


