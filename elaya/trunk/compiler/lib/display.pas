{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2002  J.v.Iddekinge.
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

unit Display;

interface
uses largenum,progutil,stdobj,files,cmp_type;
type	TDisplay=class(TRoot)
	private
		voLeftMargin : integer;
		voCol        : integer;
		voWidth      : cardinal;
	protected
		property iCol        : integer read voCol        write voCol;
		property iLeftMargin : integer read voLeftMargin write voLeftMargin;
		procedure Commonsetup;override;

	public
		property fLeftMargin : integer read voLeftMargin;
		property fCol : integer  read voCol;
		property fWidth : cardinal read voWidth write voWidth;

		procedure IntWrite(const ParStr : string);virtual;
		procedure IntNl;virtual;
		procedure WriteString(const ParStr:string);virtual;
		procedure WriteNewLine;
		procedure Write(ParPst : TValue);
		procedure Write(ParInt : longint);
		procedure Write(const ParNum : TLargeNumber);
		procedure Write(const parStr:string);
		procedure Print(const ParAr:array of const);
		procedure WritePst(ParStr:TValue);
		procedure WriteInt(ParInt:longint);
		procedure WriteNl(const ParStr:string);
		procedure Center(const ParStr:string);
		procedure WriteRep(ParN:byte;const ParStr:string);
		procedure Nl;
		procedure SetLeftMargin(ParAddLm:integer);
		procedure WriteRaw(ParBlk:pointer;ParSIze:cardinal);
end;

TFileDisplay=class(TDisplay)
private
	voOpen : boolean;
	voFile : TFile;
	property iOpen : boolean read voOpen write voOpen;
	property iFile : TFile   read voFile write voFile;
protected
	procedure clear;override;
public
	property    GetOpen : boolean read voOpen;
	constructor create(const ParName:string;var ParError:TErrorType);
	procedure   IntWrite(const ParStr:string);override;
end;


implementation

var vgFill:array[1..1024] of char;

procedure TDisplay.Print(const ParAr:array of const);
var vlCnt : cardinal;
	vlVar : PVarRec;
begin
	vlCnt := 0;
	while vlCnt <=high(ParAr) do begin
		vlVar := @(ParAr[vlCnt]);
		case vlVar^.vTYpe of
		vtInteger:Write(vlVar^.vInteger);
		vtChar   :Write(vlVar^.vChar);
		vtBoolean:if vlVar^.vBOolean then write('true') else write('false');
		vtInt64  :write(vlVar^.vInt64^);
		vtString :write(vlVar^.vString^);
		vtObject  :write(TValue(vlVar^.vObject));  {fpc hack}
	else begin write('[unkown print type]:'); writeln(cardinal(vlVar^.vType));end;
	end;
	inc(vlCnt);
end;
end;

procedure TDisplay.Center(const ParStr:string);
var vlGoto : cardinal;
begin
	vlGoto := 1;
	if length(ParStr) < fWidth then vlGoto := (fWidth - length(ParStr)) shr 1;
	if iCol < vlGoto then WriteRep(vlGoto - iCol,' ');
	Write(ParStr);
end;

procedure TDisplay.WriteRaw(ParBlk:pointer;ParSIze:cardinal);
var vlPtr  : pointer;
	vlSize : cardinal;
begin
	vlSize := ParSize;
	vlPtr := PArBlk;
	while vlSIze > 0 do begin
		writestring(char(vlPTr^));
		inc(vlPtr);
		dec(vlSize);
	end;
end;

procedure TDisplay.Commonsetup;
begin
	inherited commonsetup;
	iLeftMargin    := 0;
	iCol 	         := 0;
	fWidth	      := 80;
end;


procedure TDisplay.WritePst(ParStr:TValue);
var vlStr:string;
begin
	if ParStr <> nil then ParStr.GetString(vlStr)
	else vlStr := '<nil>';
	writeString(vlStr);
end;



procedure TDisplay.WriteString(const ParStr : string);
begin
	IntWrite(ParStr);
end;

procedure TDisplay.IntNl;
begin
	IntWrite(#13#10);
	iCol := 0;
end;

procedure TDisplay.IntWrite(const parStr:string);
begin
	
	while iCol<iLeftMargin do begin
		system.write(' ');
		iCol := iCol + 1;
	end;
	system.write(parStr);
	iCol := iCol + length(ParStr);
end;

procedure TDisplay.WriteRep(ParN:byte;const ParStr:string);
var vlStr:string;
begin
	if (length(ParStr) = 1) and (ParN < 254) then begin
		fillchar(vlStr[1],ParN,ParStr[1]);
		SetLength(vlStr,ParN);
		Write(vlStr);
	end else
While ParN > 0 do begin Write(ParStr);dec(ParN);end;
end;

procedure TDisplay.WriteNewLine;
begin
	IntNl;
end;

procedure TDisplay.Write(const ParNum : TLargeNumber);
var
	vlStr : string;
begin
	LargeToString(ParNum,vlStr);
	Write(vlStr);
end;


procedure TDisplay.Write(ParInt:longint);
begin
	WriteInt(ParInt);
end;

procedure TDisplay.Write(ParPst:TValue);
begin
	WritePst(Parpst);
end;

procedure TDisplay.write(const ParStr:string);
begin
	WriteString(ParStr);
end;

procedure TDisplay.WriteNl(const ParStr:string);
begin
	Write(ParStr);
	WriteNewLine;
end;

procedure TDisplay.WriteInt(ParInt : longint);
var vlStr:string;
begin
	str(ParInt,vlStr);
	WriteString(vlStr);
end;

procedure TDisplay.nl;
begin
	WriteNewLine;
end;


procedure TDisplay.SetLeftMargin(ParAddLm:integer);
begin
	if -ParAddlm > voLeftMargin then voLeftMargin := 0
	else inc(voLeftMargin,ParAddLm);
	WriteString('');
end;

{------( TFileDisplay )----------------------------------------------------------------------}

constructor TFileDisplay.create(const ParName:string;var ParError:TErrorType);
begin
	iFile := TFile.Create(64*512);
	iFile.CreateFile(ParName);
	ParError := iFile.fError;
	if iFile.fError <> 0 then begin
		iFile.Destroy;
		iFile := nil;
	end;
	iOpen := (ParError = 0);
	inherited create;
end;

procedure TFileDisplay.IntWrite(const ParStr:string);
var    vlCnt : longint;
begin
	vlCnt := voLeftMargin - fCol;
	if iOpen then begin
		if vlCnt > 0 then begin
			iFile.WriteToBuffer(vlCnt,vgFill);
			iCol := voLeftMargin;
		end;
		iFile.WriteToBuffer(length(ParStr),ParStr[1]);
	end;
	iCol := iCol + length(ParStr);
end;

procedure TFileDisplay.Clear;
begin
	inherited Clear;
	if iOpen then begin
		iFile.Close;
		iFile.Destroy;
	end;
end;

begin
	fillchar(vgFill,sizeof(vgFill),' ');
end.
