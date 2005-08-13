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

	TSMStringItem=class(TSMListItem)
	private
		voString:ansiString;
		property iString:ansistring read voString write voString;
	protected
		procedure   commonsetup;override;
	public
		property    fString:ansistring read voString;
		procedure   SetString(const ParStr:ansistring);
		constructor Create(const ParTxt:ansistring);
		function    IsEqualStr(const ParStr:ansistring):boolean;
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
		procedure  ClearList;
		function  GetNumItems:longint;
		function  IsEmpty:boolean;
	end;


	TSMStringList=class(TSMList)
	protected
		function MakeItem(const ParString : ansistring) : TSMStringItem;virtual;
	public

		function AddString(const ParString : ansistring) :TSMStringItem ;
		function GetStringByPosition(ParPosition : cardinal;var ParString : ansistring):boolean;
		function GetItemByString(ParLast:TSMStringItem;const ParString:ansistring):TSMStringItem;virtual;
	end;






implementation



{------( TSMTextList )------------------------------------------------}


function TSMStringList.AddString(const ParString : ansistring) : TSmStringItem;
var
	vlItem : TSmStringItem;
begin
	vlItem := MakeItem(ParString);
	InsertAtTop(vlItem);
	exit(vlItem);
end;


function TSmStringList.MakeItem(const ParString : ansistring) : TSMStringItem;
begin
	exit(TSmStringItem.Create(ParString));
end;

function TSmStringList.GetStringByPosition(ParPosition : cardinal;var ParString : ansistring):boolean;
var
	vlItem : TSmStringItem;
begin
	vlItem := TSmStringItem(GetPtrByNum(ParPosition));
	if (vlItem <> nil) then begin
		ParString := vlItem.fString;
	end else begin
		EmptyString(ParString);
	end;
	exit(vlItem <> nil);
end;


function TSMStringList.GetItemByString(ParLast:TSmStringItem;const ParString:ansistring):TSMStringItem;
var
	vlCurrent:TSMStringItem;
begin
	if ParLast <> nil then begin
		vlCurrent := TSmStringItem(ParLast.fNxt)
	end else  begin
		vlCurrent := TSmStringItem(iStart);
	end;
	while (vlCurrent <> nil) and not(vlCurrent.fString = ParString) do vlCurrent := TSmStringItem(vlCurrent.fNxt);
	exit(vlCurrent);
end;




{-------( TSmStringItem )-----------------------------------------------}



procedure TSmStringItem.commonsetup;
begin
	inherited commonsetup;
	EmptyString(voString);
end;

function  TSmStringItem.IsEqualStr(const ParStr:ansistring):boolean;
begin
	exit(iString = ParStr);
end;

procedure   TSmStringItem.SetString(const ParStr:ansistring);
begin
	iString := ParStr;
end;

constructor TSmStringItem.Create(const ParTxt:ansistring);
begin
	inherited Create;
	iString := ParTxt;
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
