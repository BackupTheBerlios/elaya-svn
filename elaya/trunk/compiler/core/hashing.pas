{
   Elaya, the compiler for the elaya language
Copyright (C) 1999-2005  J.v.Iddekinge.
web : www.elaya.org

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

unit Hashing;
interface
uses progutil,linklist,stdobj;
const Hash_Max=32767;
type


	THashing = class(TRoot)
	private
		voHashIndex:array[0..Hash_Max] of TListItem;
	protected
    	procedure commonsetup;override;
	public
		function SetHashIndex(const ParStr:ansistring;ParItem:TListItem):TListItem;
		function SetHashIndexPtr(ParPTr:Pointer;ParITem:TListItem):TListItem;
		function GetHashIndex(const Parstr:ansistring):TListItem;
		function GetHashIndexPtr(ParPTr:Pointer):TListItem;
		function StrToHash(const ParStr:ansistring):cardinal;
		function PtrToHash(ParPtr:pointer):cardinal;
	end;

implementation




{---( THashing )-------------------------------------------------}

procedure THashing.CommonSetup;
begin
	inherited COmmonsetup;
	fillchar(voHashIndex,sizeof(voHashIndex),0)
end;


function THashing.GetHashIndex(Const ParStr:ansistring):TListItem;
begin
	exit( voHashIndex[StrToHash(parStr)]);
end;

function THashing.GetHashIndexPtr(ParPTr:Pointer):TListItem;
begin
	exit(voHashIndex[PtrToHash(ParPTr)]);
end;


function THashing.SetHashIndex(const ParStr:ansiString;ParItem:TListItem):TListItem;
var vlIndex : cardinal;
begin
	vlIndex := StrToHash(Parstr);
	SetHashIndex := voHashIndex[vlIndex];
	voHashIndex[vlIndex] :=ParITem;
end;

function THashing.SetHashIndexPtr(ParPtr:pointer;ParITem:TListItem):TListItem;
var vlIndex : cardinal;
begin
	vlIndex := PtrToHash(ParPtr);
	SetHashIndexPtr := voHashIndex[vlIndex];
	voHashIndex[vlINdex] := ParItem;
end;


function THashing.PtrToHash(ParPtr:Pointer):cardinal;
begin
	exit( TSplit(ParPTr).vW1 xor TSplit(Parptr).vW2);
end;

function THashing.StrToHash(const ParStr:ansistring):cardinal;
var
	vlHash1 :longint;
	vlHash2 :longint;
	vlCnt   :cardinal;
	vlLe	:cardinal;	
	vlBt    : longint;
begin
	if length(ParStr) > 0 then begin
		vlCnt := length(ParStr);
		vlHash1 :=12354;
		vlhash2 :=34321	;
		while vlCnt > 0 do begin
	
				vlHash1 := (vlHash1 shr 4+vlHash1 shl 28) xor (vlHash2 * byte(ParStr[vlCnt]));
				vlHash2 := vlHash2 xor vlHash1;
		
			dec(vlCnt);
		end;
	end else begin
		vlHash1 := 0;
	end;
	exit(vlHash1 and Hash_Max);
end;

end.
