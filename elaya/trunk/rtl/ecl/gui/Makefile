#   Elaya, the compiler for the ;elaya language
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

.PHONY:all clean

all:
	$(MAKE) -C base all
	$(MAKE) -C interfaces all
	$(MAKE) -C fw all
	$(MAKE) -C widgets all

install:
	$(MAKE) install -C base
	$(MAKE) install -C interfaces
	$(MAKE) install -C fw
	$(MAKE) install -C widgets

clean:
	$(MAKE) -C base clean
	$(MAKE) -C interfaces clean
	$(MAKE) -C fw clean
	$(MAKE) -C widgets clean
