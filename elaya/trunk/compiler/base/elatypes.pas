{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2002  J.v.Iddekinge.
Email : iddekingej@lycos.com
Web   : www.elaya.org

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

unit ElaTypes;
interface
uses largenum,cmp_type,progutil;
type
	TUNormal    = cardinal;
	TNumber     = TLargeNumber;
	TIntType    = TNormal;
	THardType   = cardinal;
	TSignedSIze = longint;
	TSize       = THardType;
	TOffset     = longint;
	TUnitLevel  = TNormal;
	THashNumber = TNormal;
	TStatus     = cardinal;
	TOption     = longint;
	TArrayIndex = TLargeNumber;
	TMasterInfo =record
	Cod:TUNormal;
	Srg:TUNormal;
	Lrg:TUNormal;
end;

TAsmStorageCanDoCode=(CD_Reserve,CD_Math,CD_Pointer,CD_StackFrame,CD_StackPointer,CD_FunctionReturn);
TAsmStorageCanDo=set of TAsmStorageCanDoCode;

{----( RegisterHint )---------------------------------------------------------}

type  TRegHint  = (RH_Math,RH_Pointer);
TRegHints = set of TRegHint;


TRegisterInfo=record
	Reg:TUNormal;
	Siz:TUNormal;
	prt:TUNormal;
	pre:TUNormal;
	Mrg:TUNormal;
	Lrg:TUNormal;
	Srg:TUNormal;
	CDo:TAsmStorageCanDo;
	rhi:TRegHints;
end;


implementation
end.
