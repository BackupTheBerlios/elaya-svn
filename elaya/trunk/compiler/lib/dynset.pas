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

unit dynset;
interface
uses stdobj;
type
	TLongSet=set of cardinal;
TArr=array[0..16384] of TLongSet;
PArr=^TArr;
PLongSet=^TLongSet;
PCardinal=^Cardinal;

TDynamicSet=class(TRoot)
private
	voMax        : cardinal;
	voBufferSize : cardinal;
	voSet        : PLongset;
protected
	property iMax        : cardinal read voMax        write voMax;
	property iBufferSize : cardinal read voBufferSize write voBufferSize;
	property iSet        : PLongset read voSet        write voSet;

	procedure   Clear;override;
	procedure   commonsetup;override;

public
	property    fMax : cardinal read voMax;
	property    fBufferSize:cardinal read voBufferSize;
	constructor Create(ParMax : cardinal);
	procedure   DoSet(ParNo:cardinal);
	procedure   DoReset(ParNo:cardinal);
	function    IsSet(ParNo:cardinal):boolean;
	procedure   ResetAll;
	procedure   SetAll;
	function    GetSet(ParNo : cardinal):TLongSet;
	procedure   Include(ParSet:TDynamicSet);
	procedure   Differ(ParSet :TDynamicSet);
	procedure   Intersect(ParSet : TDynamicSet);
	function    IsDifferent(ParSet : TDynamicSet):boolean;
	function    IsSame(ParSet : TDynamicSet):boolean;
	function    NumberOfelements:cardinal;
	function    LastElement(var ParLast : cardinal):cardinal;
	function    Includes(ParSet : TDynamicSet):boolean;
	procedure   SetByArray(const ParAr :array of cardinal);
end;

implementation

const  Size_Set_shr = 5;
	Max_Set      = 1 shl size_set_shr;
	Mask_Set     = Max_Set - 1;
	Size_Bytes   = sizeof(TLongSet);
	
	{------( TDynamicSet )-------------------------------------------------------}
	
procedure   TDynamicSet.SetByArray(const ParAr :array of cardinal);
var vlCnt : cardinal;
begin
	for vlCnt :=  0 to high(ParAr) do begin
		DoSet(ParAr[vlCnt]);
	end;
end;

function    TDynamicSet.Includes(ParSet : TDynamicSet):boolean;
var vlCnt : cardinal;
	vlMax : cardinal;
	vlScan : PCardinal;
	vlVal  : cardinal;
begin
	vlMax  := iBufferSize;
	if vlMax < ParSet.fBufferSize then exit(false);
	vlCnt  := vlMax;
	vlScan := PCardinal(iset+vlMax - 1);
	while (vlCnt > 0) do begin
		vlVal := cardinal(GetSet(vlCnt));
		if (vlScan^ and vlVal) <> vlVal then exit(false);
		dec(vlScan);
		dec(vlCnt);
	end;
	exit(true);
end;

procedure   TDynamicSet.Clear;
var vlPtr :pointer;
begin
	inherited Clear;
	vlPtr := iSet;
	int_free(vlPtr,iBufferSize * Size_bytes);
end;

constructor TDynamicSet.Create(ParMax : cardinal);
begin
	iMax        := ParMax;
	iBufferSize := ParMax shr size_set_Shr;
	if (ParMax and mask_set) <> 0 then iBufferSize := iBufferSize + 1;
	inherited Create;
end;

procedure  TDynamicSet.ResetAll;
var vlPtr : pointer;
begin
	vlPtr := iSet;
	fillChar(vlPtr^,iBufferSize * Size_Bytes,0);
end;

procedure  TDynamicSet.SetAll;
var vlPtr : pointer;
begin
	vlPtr := iSet;
	fillchar(vlPtr^,iBufferSize * Size_Bytes,255);
end;


procedure TDynamicSet.Commonsetup;
var vlPtr:Pointer;
begin
	inherited commonsetup;
	vlPtr := int_malloc(iBufferSize * Size_Bytes);
	iSet :=vlPtr;
	ResetAll;
end;

procedure TDynamicSet.DoSet(ParNo : cardinal);
var vlPos: cardinal;
begin
	vlPos := ParNo shr Size_Set_Shr;
	if vlPos <= iBufferSize then cardinal((iSet + vlPos)^) := cardinal((iSet + vlPos)^) or cardinal(1 shl (ParNo and mask_set));
end;

procedure TDynamicSet.DoReset(ParNo:cardinal);
var vlPos : cardinal;
begin
	vlPos := ParNo shr Size_Set_Shr;
	if vlPos <= iBufferSize then cardinal((iSet + vlPos)^) := cardinal((iSet + vlPos)^) and not(cardinal(1 shl (ParNo and Mask_Set)));
end;

function TDynamicSet.IsSet(ParNo : cardinal):boolean;
begin
	if ParNo >= iMax then exit(false);
	exit((ParNo and Mask_Set) in PArr(iSet)^[ ParNo shr Size_Set_Shr]);
end;



function   TDynamicSet.GetSet(ParNo : cardinal):TLongSet;
begin
	if ParNo <iBufferSize then exit((iSet + ParNo)^)
	else exit([]);
end;

procedure  TDynamicSet.Include(ParSet:TDynamicSet);
var vlCnt : cardinal;
	vlMax : cardinal;
	vlSet : cardinal;
begin
	vlMax := iBufferSize;
	if ParSet.iBufferSize < vlMax then  vlMax := ParSet.fBufferSize;
	vlCnt := 0;
	while (vlCnt < vlMax) do begin
		vlSet := cardinal(ParSet.GetSet(vlCnt));
		cardinal((iSet + vlCnt)^):=cardinal((iSet + vlCnt)^) or vlSet;
		inc(vlCnt);
	end;
end;

procedure  TDynamicSet.Differ(ParSet :TDynamicSet);
var vlCnt : cardinal;
	vlMax : cardinal;
	vlSet : cardinal;
begin
	vlMax := iBufferSize;
	if ParSet.fBufferSize < vlMax then  vlMax := ParSet.fBufferSize;
	vlCnt := 0;
	while (vlCnt < vlMax) do begin
		vlSet := cardinal(ParSet.GetSet(vlCnt));
		cardinal((iSet + vlCnt)^):=cardinal((iSet + vlCnt)^) and  not(vlSet);
		inc(vlCnt);
	end;
end;


procedure  TDynamicSet.Intersect(ParSet : TDynamicSet);
var vlCnt : cardinal;
	vlMax : cardinal;
begin
	vlMax := iBufferSize;
	if ParSet.fBufferSize < vlMax then  vlMax := ParSet.fBufferSize;
	vlCnt := 0;
	while (vlCnt < vlMax) do begin
		cardinal((iSet + vlCnt)^):=cardinal((iSet + vlCnt)^) and cardinal( ParSet.GetSet(vlCnt));
		inc(vlCnt);
	end;
end;

function   TDynamicSet.IsDifferent(ParSet : TDynamicSet):boolean;
var vlCnt : Cardinal;
	vlMax : cardinal;
begin
	vlMax := iBufferSize;
	if vlMax <> ParSet.fBufferSize then exit(true);
	vlCnt := 0;
	while vlCnt < vlMax do begin
		if (iSet + vlCnt)^ <> ParSet.GetSet(vlCnt) then exit(True);
		inc(vlCnt);
	end;
	exit(False);
end;


function   TDynamicSet.IsSame(ParSet : TDynamicSet):boolean;
begin
	exit(not IsDifferent(Parset));
end;

function   TDynamicSet.NumberOfelements:cardinal;
var vlCnt  : cardinal;
	vlSet  : cardinal;
	vlSIze : cardinal;
begin
	vlCnt  := iBufferSize - 1;
	vlSize := 0;
	while vlCnt > 0 do begin
		dec(vlCnt);
		vlSet := cardinal((iSet + vlCnt)^);
		if vlSet <> 0 then begin
			while (vlSet > 0) do begin
				inc(vlSize,(vlSet and 1));
				vlSet := vlSet Shr 1;
			end;
		end;
	end;
	exit(vlSize);
end;

function   TDynamicSet.LastElement(var ParLast : cardinal):cardinal;
var vlCnt  : cardinal;
	vlMax  : cardinal;
	vlSize : cardinal;
begin
	vlCnt  := 0;
	vlMax  := iMax;
	vlSize := 0;
	while vlCnt < vlMax do begin
		if IsSet(vlCnt) then begin
			ParLast := vlCnt;
			inc(vlSize);
		end;
		inc(vlCnt);
	end;
	exit(vlSize);
end;

end.

