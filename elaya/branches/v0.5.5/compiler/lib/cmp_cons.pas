{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web : www.elaya.org

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit cmp_cons;
interface

TYPE
	CHARSET = SET OF CHAR;

CONST
C_TAB  = #09;
C_LF   = #10;
C_CR   = #13;
C_EF   = #0;
C_EL   = C_CR;
C_EOF  = #26;
EF     = C_EF; {voor de scanner}
LineEnds : CHARSET = [C_CR,C_LF, C_EF];


implementation

end.
