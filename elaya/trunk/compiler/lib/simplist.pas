{    Elaya, the Fcompiler for the elaya language
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
unit simplist;
interface
uses   progutil,stdobj;
type
	
	
	TSMListItem=class(TRoot)
	private
		voPrv : TSMLISTITEM;
		voNxt : TSMListItem;
		property iPrv:TSMListItem read voPrv write voPrv;
		property iNxt:TSMListItem read voNxt write voNxt;

	protected
		procedure commonsetup;override;

	public
		property fPrv:TSMListItem read voPrv write voPrv;
		property fNxt:TSMListItem read voNxt write voNxt;
	end;
	
	TSMTextItem=class(TSMListItem)
	private
		voText:TString;
		property iText:TString read voText write voText;
	protected
		procedure   commonsetup;override;
		procedure   Clear;override;

	public
		property    fText:TString read voText;
		procedure   GetTextStr(var ParStr:string);
		procedure   SetText(const ParStr:string);
		constructor Create(const ParTxt:string);
		function    IsEqualStr(const ParStr:string):boolean;
	end;
	
	
	TSMList=class(TRoot)
	private
		voStart : TSMListItem;
		voTop   : TSMListItem;
		property iStart : TSMListItem read voStart write voStart;
		property iTop   : TSMListItem read voTop  write voTop;

	protected
		procedure  Clear;override;
		procedure  Commonsetup;override;
	
	public
		property fStart : TSMListItem read voStart;
		property fTop   : TSMListItem read voTop;
		
		function  CutOut(ParItem:TSMListItem):TSMListItem;
		function  InsertAt(ParAt:TSMListItem;ParItem:TSMListItem):TSMListItem;
		function  InsertAtTop(PArItem : TSMListItem) :TSMListItem;
		function  DeleteLink(ParItem:TSMListItem):TSMListItem;
		function  GetPtrByNum(ParNUm : cardinal) : TSMListItem;
		procedure DeleteAll;
		procedure  ClearList;virtual;
		function  GetNumItems:longint;
		function  IsEmpty:boolean;
	end;
	
	
	TSMTextList=class(TSMList)
		function GetPtrByName(ParStart:TSMTextItem;const ParName:string):TSMTextItem;virtual;
	end;
	
	
	
	
	
	
implementation



{------( TSMTextList )------------------------------------------------}



function TSMTextList.GetPtrByName(ParStart:TSMTextItem;const ParName:string):TSMTextItem;
var vlCurrent:TSMTextItem;
begin
	GetPtrByName := nil;
	if ParStart <> nil then vlCurrent := TSMTextItem(ParStart.fNxt)
	else vlCurrent := TSMTextItem(iStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsEqualStr(ParName)) do vlCurrent := TSMTextItem(vlCurrent.fNxt);
	GetPtrByName := vlCurrent;
end;




{-------( TSMTextItem )-----------------------------------------------}



procedure TSMTextItem.commonsetup;
begin
	inherited commonsetup;
	iText := nil;
end;

function  TSMTextItem.IsEqualStr(const ParStr:string):boolean;
begin
	if iText = nil then exit(false);
	exit(iText.IsEqualStr(ParStr));
end;


procedure TSMTextItem.GetTextStr(var ParStr:string);
begin
	iText.GetString(ParStr);
end;

procedure   TSMTextItem.SetText(const ParStr:string);
begin
	if fText <> nil then fText.Destroy;
	iText := TString.Create(ParStr);
end;

constructor TSMTextItem.Create(const ParTxt:string);
begin
	inherited Create;
	SetText(ParTxt);
end;


procedure TSMTextItem.Clear;
begin
	inherited Clear;
	if iText <> nil then iText.Destroy;
end;




{---( TSMListItem )-----------------------------------------------------------}
procedure TSMListItem.Commonsetup;
begin
	inherited Commonsetup;
	iPrv := nil;
	iNxt := nil;
end;


{---( TSMList )------------------------------------------------------------------}


function TSMList.GetPtrByNum(ParNUm : cardinal) : TSMListItem;
var
	vlCurrent : TSMListItem;
begin
	vlCurrent := iStart;
	while (vlCurrent <> nil) and (ParNum > 1) do begin
		vlCurrent := vlCurrent.fNxt;
		dec(ParNum);
	end;
	exit(vlCurrent);
end;


function TSMList.CutOut(ParItem:TSMListItem):TSMListItem;
var vlNxt:TSMListItem;
begin
	if ParItem = nil then exit(nil);
	vlNxt := ParItem.fNxt;
	CutOut := vlNxt;
	if vlNxt = nil   then iTop  := ParItem.fPrv
	else vlNxt.fPrv := parItem.fPrv;
	if ParItem.fPrv <> nil  then parItem.fPrv.fNxt := vlNxt
	else iStart := vlNxt;
end;


function TSMList.IsEmpty:boolean;
begin
	exit(iStart = nil);
end;

function TSMList.GetNumItems:longint;
var vlCnt:longint;
	vlCur:TSMListItem;
begin
	vlCur := iStart;
	vlCnt :=0;
	while vlCur <> nil do begin
		inc(vlCnt);
		vlCur := vlCur.fNxt;
	end;
	GetNumItems := vlCnt;
end;


function TSMList.InsertAtTop(PArItem : TSMListItem) :TSMListItem;
begin
	exit(InsertAt(iTop,ParItem));
end;

function TSMList.InsertAt(ParAt:TSMListItem;ParITem:TSMListItem):TSMListItem;
var vlNxt : TSMListItem;
begin
	InsertAt := ParItem;
	if ParItem = nil then exit;
	if ParAt = nil then begin
		ParItem.fPrv := nil;
		ParItem.fNxt := iStart;
		if iStart <> nil then iStart.fPrv := ParItem;
		iStart := ParItem;
	end else begin
		vlNxt := ParAt.fNxt;
		if vlNxt <> nil then vlNxt.fPrv := ParItem;
		ParItem.fPrv := ParAt;
		ParItem.fNxt := vlNxt;
		ParAt.fNxt := ParItem;
	end;
	if ParItem.fNxt =nil then iTop := ParItem;
end;

function TSMList.DeleteLink(ParItem:TSMListItem):TSMListItem;
begin
	DeleteLink := CutOut(ParItem);
	if ParItem <> nil then ParItem.Destroy;
end;


procedure TSMList.DeleteAll;
begin
	while iStart <> nil do iStart := deleteLink(iStart);
end;

procedure TSMList.Commonsetup;
begin
	inherited Commonsetup;
	iStart := nil;
	iTop   := nil;
end;

procedure TSMList.ClearList;
begin
	DeleteAll;
end;

procedure TSMList.Clear;
begin
	inherited Clear;
	ClearList;
end;


end.
