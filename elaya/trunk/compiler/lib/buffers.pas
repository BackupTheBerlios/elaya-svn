{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2002  J.v.Iddekinge.
Email :iddekingej@lycos.com
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

unit buffers;
interface
uses progutil,stdobj;

type    TMemoryBlock=class(TRoot)
	private
		voSize : cardinal;
		voPtr  : Pointer;
		property    iSize  : cardinal read voSize write voSize;
		property    iPtr   : pointer  read voPtr  write voPtr;
	protected
		procedure   Clear;override;
		procedure   Commonsetup;override;

	public
		property   fSize : cardinal read voSize;
		property   fPtr  : pointer  read voPtr;
		
		function    GetPtrAt(ParPos:cardinal):Pointer;
		constructor create(ParSize : cardinal);
		function    GetByteAt(ParPos:cardinal):byte;
		function    ScanMoveTo(ParPos,ParReqSize : cardinal ;  ParPtr : pointer):cardinal;
		procedure   MoveTo(ParPos,ParSize : cardinal ; ParPtr : Pointer);
		procedure   MoveFrom(ParPos,ParSize : cardinal;ParPtr : Pointer);
	end;
	
implementation

{----( TMemoryBLock )----------------------------------------------------}


procedure   TMemoryBlock.MoveFrom(ParPos,ParSize : cardinal ; ParPtr : Pointer);
begin
	move(ParPtr^,(iPtr+ParPos)^,ParSize);
end;

function   TMemoryBlock.ScanMoveTo(ParPos,ParReqSize : cardinal ; ParPtr : pointer):cardinal;
var vlSize : cardinal;
begin
	vlSize := iSize - ParPos;
	if vlSIze > ParReqSize then vlSize := ParReqSize;
	if vlSize > 0          then MoveTo(ParPos,vlSize,ParPtr);
	exit(vlSize);
end;


procedure   TMemoryBlock.MoveTo(ParPos,ParSize:cardinal;ParPtr:Pointer);
begin
	move((iPtr+ParPos)^,ParPtr^,ParSize);
end;

function    TMemoryBlock.GetByteAt(ParPos:cardinal):byte;
begin
	exit( byte((iPtr + ParPos)^))
end;

procedure  TMemoryBlock.COmmonsetup;
begin
	inherited Commonsetup;
	iPtr  := nil;
	iSize := 0;
end;

constructor TMemoryBlock.create(ParSize : cardinal);
var vlPtr : pointer;
begin
	inherited create;
	getmem(vlPtr,ParSize);
	iPtr  := vlPtr;
	iSize := ParSize;
end;

procedure   TMemoryBlock.Clear;
begin
	inherited Clear;
	if iPtr <> nil then freemem(iPtr,iSize);
end;

function    TMemoryBlock.GetPtrAt(ParPos:cardinal):Pointer;
begin
	exit(iPtr + ParPos);
end;

end.
