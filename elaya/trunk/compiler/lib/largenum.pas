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
unit largenum;
interface

type
	TLargeNumber=record
		vrNumber : cardinal;
		vrSign   : boolean;
	end;

TLargeCompare=(LC_Lower:=-1,LC_Equal:=0,LC_Bigger:=1);
var
abs_max_Long     :cardinal;
abs_min_longint  :cardinal;
var vlA:TLargeNumber;


procedure LoadLong(var ParLarge : TLargeNumber;ParNum : cardinal);
procedure LoadInt(var ParLarge : TLargeNumber;ParNum : longint);
procedure LargeToString(const ParLarge : TLargeNumber;var ParStr :ansistring);
function StringToLarge(const ParStr : ansistring;var ParLarge : TLargeNumber):boolean;
function  LargeMul(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber):boolean;
function  LargeMulLong(var ParLargeOut : TLargeNumber;ParNum : cardinal):boolean;
procedure LargeDiv(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
procedure LargeMod(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
function  LargeAdd(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber):boolean;
function  LargeSub(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber):boolean;
function  LargeAddLong(var ParLargeOut : TLargeNumber;ParNUm : cardinal):boolean;
function  LargeSubLong(var ParLargeOut : TLargeNumber;ParNUm : cardinal):boolean;
function  LargeAddInt(var ParLargeOut : TLargeNumber;ParNUm : longint):boolean;
function  LargeSubInt(var ParLargeOut : TLargeNumber;ParNUm : longint):boolean;


function  LargeCompare(const ParLarge,ParTo:TLargeNumber):TLargeCompare;
function  LargeCompareInt(const ParLarge : TLargenUmber;ParTo:longint):TLargeCompare;
function  LargeCompareLong(const ParLarge : TLargenUmber;ParTo:longint):TLargeCompare;

function  LargeToCardinal(const ParLarge :TLargeNumber) : cardinal;
function  LargeToLongint(const ParLarge : TLargeNumber):longint;
procedure  LargeToNumber(const ParLarge : TLargeNumber;var ParOut : int64);

procedure  LargeNot(var ParLargeOut : TLargeNumber);
procedure  LargeXor(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNUmber);
procedure  LargeAnd(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
procedure  LargeOr(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
procedure  LargeShr(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
procedure  LargeShl(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);

procedure  LargeShlLong(var ParLargeOut : TLargeNumber;ParNum : cardinal);
function   LargeNeg(var ParLargeOut : TLargeNumber):boolean;
function   LargeIsNeg(var ParLargeOut : TLargeNumber):boolean;
function   LargeInRange(const ParLarge,ParLo,ParHi : TLargeNumber) : boolean;
function   LargeInIntRange(const ParLarge : TLargeNumber;ParLo,ParHi : longint):boolean;
function   LargeRangeInRange(const ParLargeLo,ParLargeHi,ParRangeLo,ParRangeHi : TLargeNumber):boolean;
procedure  LargeGetBytesAt(const ParIn : TLargeNumber;ParByte,ParSize : cardinal;var ParOut : cardinal);
procedure  LargeAbs(var ParLargeOut : TLargeNumber);

implementation
procedure  LargeAbs(var ParLargeOut : TLargeNumber);
begin
	ParLargeOut.vrSign := false;
end;

procedure  LargeGetBytesAt(const ParIn  : TLargeNUmber;ParByte,ParSize : cardinal;var ParOut : cardinal);
var vlSize :cardinal;
begin
	vlSize := 5 - ParByte;
	if vlSize > ParSize then vlSize := ParSize;
	ParOut := 0;
	move(pbyte(ParByte + pbyte(@ParIn.vrNUmber))^,ParOut,vlSize);
end;

function   ConvertForLog(const ParLarge : TLargeNumber):Cardinal;
begin
	if ParLarge.vrSign then exit(not(ParLarge.vrNUmbeR)+1);
	exit(ParLarge.vrNUmber);
end;

procedure  LargeMod(var ParLargeOut : TLargeNUmber;const ParLargeIn : TLargeNumber);
begin
	ParLargeOut.vrNumber :=ParLargeOut.vrNumber mod ParLargeIn.vrNumber;
end;

procedure  LargeXor(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNUmber);
begin
	ParLargeOut.vrNumber := ConvertForLog(ParLargeOut) xor ConvertForLog(ParLargeIn);
	ParLargeOut.vrSign := false;
end;

procedure  LargeNot(var ParLargeOut : TLargeNumber);
begin
	ParLargeOut.vrNumber := not(ConvertForLog(ParLargeOut));
	ParLargeOut.vrSign := false;
end;

procedure  LargeAnd(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
begin
	ParLargeOut.vrNumber := ConvertForLog(ParLargeOut) and ConvertForLog(ParLargeIn);
	ParLargeOut.vrSign := false;
	
end;

procedure  LargeOr(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
begin
	ParLargeOut.vrNumber := ConvertForLog(ParLargeOut) or ConvertForLog(ParLargeIn);
	ParLargeOut.vrSign := false;
	
end;


function   LargeInIntRange(const ParLarge : TLargeNumber;ParLo,ParHi : longint):boolean;
begin
	exit((LargeCompareInt(ParLarge,ParLo) <> LC_Lower) and (LargeCompareInt(ParLarge,ParHi) <> LC_Bigger));
end;

function   LargeRangeInRange(const ParLargeLo,ParLargeHi,ParRangeLo,ParRangeHi : TLargeNumber):boolean;
begin
	exit((LargeCompare(ParLargeLo,ParRangeLo)<> LC_Lower) and (LargeCompare(ParLargeHi,ParRangeHi) <> LC_Bigger));
end;

function   LargeInRange(const ParLarge,ParLo,ParHi : TLargeNumber) : boolean;
begin
	if LargeCompare(ParLarge,ParLo)=LC_Lower then exit(false);
	exit(LargeCompare(ParLarge,ParHi)<>LC_Bigger) ;
end;

function  LargeToCardinal(const ParLarge :TLargeNumber) : cardinal;
begin
	exit(ParLarge.vrNUmber);
end;

function  LargeToLongint(const ParLarge : TLargeNumber):longint;
var vlLi : longint;
begin
	vlLi := ParLarge.vrNUmber;
	if parLarge.vrSign then vlLi := -vlLI;
	exit(vlLi);
end;


function LargeAddInt(var ParLargeOut : TLargeNumber;ParNUm : longint):boolean;
var
	vlLi : TLargeNUmber;
begin
	LoadInt(vlLi,ParNum);
	exit(LargeAdd(ParLargeOut,vlLi));
end;

function LargeSubInt(var ParLargeOut : TLargeNumber;ParNUm : longint):boolean;
var
	vlLi : TLargeNUmber;
begin
	LOadInt(vlLi,ParNum);
	exit(LargeSub(ParLargeOut,vlLi));
end;


function LargeAddLong(var ParLargeOut : TLargeNumber;ParNUm : cardinal):boolean;
var
	vlLi : TLargeNUmber;
begin
	LOadLOng(vlLi,ParNum);
	exit(LargeAdd(ParLargeOut,vlLi));
end;

function LargeSubLong(var ParLargeOut : TLargeNumber;ParNUm : cardinal):boolean;
var
	vlLi : TLargeNUmber;
begin
	LOadLOng(vlLi,ParNum);
	exit(LargeSub(ParLargeOut,vlLi));
end;



function   LargeIsNeg(var ParLargeOut : TLargeNumber):boolean;
begin
	exit(ParLargeOut.vrSign);
end;

function  LargeCompareInt(const ParLarge : TLargenUmber;ParTo:longint):TLargeCompare;
var vlLi : TLargeNumber;
begin
	LoadInt(vlLi,ParTo);
	exit(LargeCompare(ParLarge,vlLi));
end;

function  LargeCompareLong(const ParLarge : TLargenUmber;ParTo:longint):TLargeCompare;
var vlLi : TLargeNumber;
begin
	LoadLong(vlLi,ParTo);
	exit(LargeCompare(ParLarge,vlLi));
end;

function LargeNeg(var ParLargeOut : TLargeNumber):boolean;
begin
	ParLargeOut.vrSign := not(parLargeOut.vrSign);
	exit( (ParLargeOut.vrSign) and (ParLargeOut.vrNumber > abs_min_longint));
end;

procedure  LargeShr(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
begin
	if ParLargeIn.vrSign then ParLargeOut.vrNumber := ParLargeOut.vrNumber shl ParLargeIn.vrNumber
	else ParlargeOut.vrNUmber := ParLargeOut.vrNUmber shr ParLargeIn.vrNumber;
end;

procedure  LargeShlLong(var ParLargeOut : TLargeNumber;ParNum : cardinal);
begin
	ParLargeOut.vrNumber := ParLargeOut.vrNumber shl ParNum;
end;

procedure  LargeShl(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
begin
	if ParLargeIn.vrSIgn then ParLargeOut.vrNumber := ParLargeOut.vrNumber shr ParLargeIn.vrNumber
	else ParlargeOut.vrNUmber := ParLargeOut.vrNUmber shl ParLargeIn.vrNumber;
end;

procedure  LargeToNumber(const ParLarge : TLargeNumber;var ParOut : int64);
begin
	ParOut := ParLarge.vrNumber;
	if ParLarge.vrSign then ParOut := - ParOut;
end;

function StringToLarge(const ParStr : ansistring;var ParLarge : TLargeNumber): boolean;
var vlLi : longint;
	vlCa : cardinal;
	vlii : integer;
begin
	if (length(ParStr)> 0)   and (ParStr[1] ='-') then begin
		val(ParStr,vlLI,vlii);
		LoadInt(ParLarge,vlLi);
	end else begin
		vlCa := 0;
		val(ParStr,vlCa,vlII);
		LoadLong(ParLarge,vlCa);
	end;
	exit(vlII <> 0);
end;

function LargeCompare(const ParLarge,ParTo:TLargeNumber):TLargeCompare;
begin
	if ParLarge.vrSign = ParTo.vrSign then begin
		if ParLarge.vrNumber = ParTo.vrNumber then exit(LC_Equal);
		if ParLarge.vrNumber > ParTo.vrNumber then begin
			if ParLarge.vrSign then exit(LC_Lower)
			else exit(LC_Bigger);
		end;
		if ParLarge.vrNumber < ParTo.vrNumber then begin
			if ParLarge.vrSign then exit(LC_Bigger)
			else exit(LC_Lower);
		end;
	end;
	if (ParLarge.vrNumber = 0) and (ParTo.vrNumber = 0) then exit(LC_Equal);
	if ParLarge.vrSign then exit(LC_Lower);
	exit(LC_Bigger);
end;


function  LargeSub(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber):boolean;
var vlErr : boolean;
begin
	vlErr := false;
	if (ParLargeOut.vrSign=ParLargeIn.vrSign) then begin
		if ParLargeOut.vrNumber >= ParLargeIn.vrNumber then begin
			dec(ParLargeOut.vrNumber,ParLargeIn.vrNumber);
		end else begin
			ParLargeOut.vrNumber := ParLargeIn.vrNumber - ParLargeOut.vrNumber;
			ParLargeOut.vrSign := not ParLargeOut.vrSign;
			if(ParLargeOut.vrSign) and (ParLargeOut.vrNUmber > abs_min_longint) then vlErr := true;
		end;
	end else begin
		if ParLargeOut.vrSign then begin
			if ParLargeIn.vrNumber > abs_min_longint then vlErr := true else
			if ParLargeOut.vrNumber > abs_min_longint -  ParLargeIn.vrNumber then vlErr := true;
		end else begin
			if ParLargeIn.vrNumber > abs_max_Long - ParLargeIn.vrNumber then vlErr := true;
		end;
		inc(ParLargeOut.vrNumber,ParLargeIn.vrNumber);
	end;
	exit(vlErr);
end;

function LargeAdd(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber):boolean;
var vlErr : boolean;
begin
	vlErr := false;
	if (ParLargeOut.vrSign <> ParLargeIn.vrSign) then begin
		if ParLargeOut.vrNumber >= ParLargeIn.vrNumber then begin
			dec(ParLargeOut.vrNumber,ParLargeIn.vrNumber);
		end else begin
			ParLargeOut.vrNumber := ParLargeIn.vrNumber - ParLargeOut.vrNumber;
			ParLargeOut.vrSign := not ParLargeOut.vrSign;
			if(ParLargeOut.vrSign) and (ParLargeOut.vrNUmber > abs_min_longint) then vlErr := true;
		end;
	end else begin
		if ParLargeOut.vrSign then begin
			if ParLargeIn.vrNumber > abs_min_longint then vlErr := true else
			if ParLargeOut.vrNumber > abs_min_longint -  ParLargeIn.vrNumber then vlErr := true;
		end else begin
			if ParLargeIn.vrNumber > abs_max_Long - ParLargeIn.vrNumber then vlErr := true;
		end;
		inc(ParLargeOut.vrNumber,ParLargeIn.vrNumber);
	end;
	exit(vlErr);
end;

function  LargeMulLong(var ParLargeOut : TLargeNumber;ParNum : cardinal):boolean;
var
	vlNumber : TLargeNumber;
begin
	LoadLong(vlNumber,ParNum);
	exit(LargeMul(ParLargeOut,vlNumber));
end;


function LargeMul(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber):boolean;
var vlErr : boolean;
begin
	vlErr := false;
	if (ParLargeIn.vrNumber <> 0) then begin
		if ParLargeOut.vrNumber > (abs_max_Long div ParLargeIn.vrNumber) then vlErr := true;
	end;
	ParLargeOut.vrNumber := ParLargeOut.vrNumber * ParLargeIn.vrNumber;
	ParLargeOut.vrSign := ParLargeOut.vrSign xor ParLargeIn.vrSign;
	exit(vlErr);
end;


procedure LargeDiv(var ParLargeOut : TLargeNumber;const ParLargeIn : TLargeNumber);
begin
	ParLargeOut.vrNumber := ParLargeOut.vrNumber div ParLargeIn.vrNumber;
	ParLargeOut.vrSign := ParLargeOut.vrSign xor ParLargeIn.vrSign;
end;

procedure LargeToString(const ParLarge : TLargeNumber;var ParStr :ansistring);
begin
	str(ParLarge.vrNumber,ParStr);
	if (ParLarge.vrSign) and (ParLarge.vrNumber <> 0) then ParStr := '-' + ParStr;
end;



procedure LoadLong(var ParLarge : TLargeNumber;ParNum : cardinal);
begin
	ParLarge.vrSign   := false;
	ParLarge.vrNumber := ParNum;
end;


procedure LoadInt(var ParLarge : TLargeNumber;ParNum : longint);
begin
	if ParNum < 0 then begin
		ParLarge.vrSign := true;
		ParLarge.vrNumber := -ParNUm;
	end else begin
		ParLarge.vrSign := false;
		ParLarge.vrNumber := ParNum;
	end;
end;


begin
abs_max_Long :=2147483647*2+1;
abs_min_longint :=2147483647+1;

end.
