{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
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

unit cdfills;
interface

uses   strmbase,streams,compbase,progutil,elacons,stdobj,linklist;

type
	TCodeFileItem=class(TTextIdent)
		voHasAt         : boolean;
		voAt	        : longint;
		property iAt    : longint read voAt   write voAt;
		property iHasAt : boolean read voHasAt write voHasAt;
	public
		property fAt    : longint read voAt;
		property fHasAt : boolean read voHasAt;
		
		constructor Create(ParFileName:ansiString);
		function    WriteResLine(var ParFile:text):boolean;virtual;
		function    SaveItem(ParStream:TObjectStream):boolean;override;
		function    LoadItem(ParStream:TObjectStream):boolean;override;
		
	end;
	
	TCodeObjectItem=class(TCodeFileItem)
	private
		voIsObjectOfUnit : boolean;
		property iIsObjectOfUnit : boolean read voIsObjectOfUnit write voIsObjectOfUnit;
		
	public
		property fIsObjectOfUnit : boolean read voIsObjectOfUnit;
		function  SaveItem(ParStream:TObjectStream):boolean;override;
		function  LoadItem(ParStream:TObjectStream):boolean;override;
		procedure Commonsetup;override;
		function WriteResLine(var ParFile:Text):boolean;override;
		constructor Create(ParName:ansiString;ParIsObjectOfUnit:boolean;ParHasAt : boolean;ParAt :longint);
	end;
	
	TCodeFileList=class(TList)
		procedure AddFile(ParItem:TCodeFileItem);
		function  WriteResLines(var ParFile:Text):boolean;
		function  FindFileByName(const ParName : AnsiString):TCodeObjectItem;
		procedure AddListToList(ParList:TCodeFileList);
		function  GetObjectOfUnit:AnsiString;
	end;
	
	
	
implementation

{-----( TCodeObjectItem) -------------------------------------}

constructor TCodeObjectItem.Create(ParName:ansiString;ParIsObjectOfUnit:boolean;ParHasAt :boolean;ParAt : longint);
begin
	inherited Create(ParName);
	iIsObjectOfUnit := ParIsObjectOfUnit;
	iHasAt := ParHasAt;
	iAt    := ParAt;
end;

procedure TCodeObjectItem.Commonsetup;
begin
	inherited commonsetup;
	iIsObjectOfUnit := false;
end;

function TCodeObjectItem.WriteResLine(var ParFile:Text):boolean;
begin
	if inherited WriteResLine(ParFile) then exit(true);
	writeln(ParFile,fText);
	exit(ioresult <> 0);
end;

function  TCodeObjectItem.SaveItem(ParStream:TObjectStream):boolean;
begin
	SaveITem := true;
	if inherited SaveItem(ParStream) then exit;
	if ParStream.WriteBoolean(iIsObjectOfUnit) then exit;
	SaveItem := false;
end;

function  TCodeObjectItem.LoadItem(ParStream:TObjectStream):boolean;
var vlBool  : boolean;
begin
	LoadItem := true;
	if inherited LoadItem(ParStream) then exit;
	if ParStream.ReadBoolean(vlBool) then exit;
	iIsObjectOfUnit := (vlBool);
	exit(false);
end;



{-----(  TCodeFileItem )---------------------------------------}

function  TCodeFileItem.SaveItem(ParStream:TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream)     then exit(true);
	if ParStream.WriteBoolean(iHasAt) then exit(true);
	if ParStream.WriteLongint(iAt) then exit(true);
	exit(false);
end;

function  TCodeFileItem.LoadItem(ParStream:TObjectStream):boolean;
var
	vlAt : longint;
	vlHAsAt : boolean;
begin
	if inherited LoadItem(parStream) then exit(true);
	if ParStream.ReadBoolean(vlHasAt) then exit(true);
	if ParStream.ReadLOngint(vlAt) then exit(true);
	iHasAt := vlHasAt;
	iAt    := vlAt;
	exit(false);
end;

constructor TCodeFileItem.Create(parFileNAme:ansiString);
begin
	inherited Create;
	iText := (ParFileName);
end;

function TCodeFileItem.WriteResLine(var ParFile:Text):boolean;
begin
	WriteResLine := false;
end;

{-----( TCodeFIleList )----------------------------------------}


procedure TCodeFileList.AddFile(ParItem:TCodeFileItem);
begin
	if FindFileByName(ParItem.fText) = nil then insertAtTop(ParItem)
	else ParItem.Destroy;
end;


function TCodeFIleList.WriteResLines(var ParFile:Text):boolean;
var vlCurrent : TCodeFileItem;
	vlMin     : longint;
	vlFoundMin:boolean;
	vlFound   : boolean;
	vlNext    : longint;
begin
	vlCurrent := TCodeFileItem(fStart);
	vlMin := 0;
	vlFoundMin := false;
	while (vlCurrent <> nil) do begin
		if (vlCurrent.fHasAt) then begin
			if not(vlFoundMin) or (vlCurrent.fAt<vlMin) then begin
				vlMin := vlCurrent.fAt;
				vlFoundMin := true;
			end;
		end;
		vlCurrent := TCodeFileItem(vlCurrent.fNxt);
	end;
	vlFound := false;
	vlNext  := 0;
	repeat
		vlCurrent := TCodeFileItem(fStart);
		vlFoundMin := false;
		while (vlCurrent <> nil) do begin
			if (vlCurrent.fHasAt) then begin
				if vlCurrent.fAt = vlMin then begin
					if vlCurrent.WriteResLine(ParFile) then exit;
					vlFound := true;
				end;
				if (vlCurrent.fAt > vlMin) and (not(vlFoundMin) or (vlCurrent.fAt < vlNext)) then begin
					vlNext := vlCurrent.fAt;
					vlFoundMin := true;
				end;
			end;
			vlCurrent := TCodeFileItem(vlCurrent.fNxt);
		end;
		vlMin := vlNext;
	until not(vlFound) or not(vlFoundMin);
	WriteResLines := true;
	vlCurrent := TCodeFileItem(fStart);
	while vlCurrent <> Nil do begin
		if not(vlCurrent.fHasAt) then begin
			if vlCurrent.WriteResLine(ParFile) then exit;
		end;
		vlCurrent :=  TCodeFileItem(vlCurrent.fNxt);
	end;
	WriteResLines := false;
end;


function TCodeFileList.GetObjectOfUnit:AnsiString;
var
	vlCurrent : TCodeObjectItem;
begin
	vlCurrent := TCodeObjectItem(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent.fIsObjectOfUnit then exit(vlCurrent.fText);
		vlCurrent := TCodeObjectItem(vlCurrent.fNxt);
	end;
	exit('');
end;


function  TCodeFileList.FindFileByName(const ParName:AnsiString):TCodeObjectItem;
var vlCurrent:TCodeObjectItem;
begin
	vlCurrent := TCodeObjectItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsSameText(ParName)) do vlCurrent := TCodeObjectItem(vlCurrent.fNxt);
	exit(vlCurrent);
end;

procedure TCodeFIleList.AddListToList(ParList:TCodeFileList);
var vlCurrent,vlNxt:TCodeObjectItem;
begin
	vlCurrent := TCodeObjectItem(ParList.fStart);
	while vlCurrent <> nil do begin
		vlNxt := TCodeObjectItem(vLCurrent.fNxt);
		ParList.CutOut(vlCurrent);
		vlCurrent.fCode:= IC_No_Code;
		vlCurrent.SetModule(nil);
		AddFile(vlCurrent);
		vlCurrent := vlNxt;
	end;
end;


end.
