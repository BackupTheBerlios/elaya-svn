{
Elaya,; the compiler for the ;elaya language
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

unit linklist;
{$i-}

interface
uses   strmbase,streams,stdobj,progutil,elacons;


type
	
	
	
	TListItem=class(TStrAbelRoot)
	private
		voPrv : TListItem;
		voNxt : TListItem;
		property iPrv   : TListItem read voPrv write voPrv;
		property iNxt   : TListItem read voNxt write voNxt;
		
	public
		property fPrv   : TListItem read voPrv write voPrv;
		property fNxt   : TListItem read voNxt write voNxt;
		
		procedure   Commonsetup;override;
		function    IsLast:boolean;
		function    IsFirst:boolean;
	end;
	
	
	TObjectItem=class(TListItem)
	private
		voObject:TRoot;
		property  iObject : TRoot read voObject write voObject;
	public
		property  fObject:TRoot read voObject;
		
		constructor Create(parObj:TRoot);
	end;
	
	TList=class(TStrAbelRoot)
	private
		voStart : TListItem;
		voTop   : TListItem;
		property iStart  : TListItem read voStart write voStart;
		property iTop    : TListItem read voTop   write voTop;
	protected
		procedure  Commonsetup;override;
   	procedure  Clear;override;
	public
		property fStart : TListItem read voStart;
		property fTop : TListItem read voTop;
		
		function   InsertAt(ParAt:TListItem;ParItem:TListItem):TListItem;
		function   DeleteLink(ParItem:TListItem):TListItem;
		procedure  DeleteAll;
		function   GetNumItems:cardinal;
		function   SaveItem(ParWriter:TObjectStream):boolean;override;
		function   LoadItem(parWriter:TObjectStream):boolean;override;
		function   CutOut(ParItem:TListItem):TListItem;
		function   IsEmpty:boolean;
		function   InsertAtTop(ParItem:TListItem):TListItem;
		function   GetItemByNum(parNum : cardinal):TListItem;
		procedure  SoftEmptyList;
	end;
	
	
implementation


{-----( TObjectItem )---------------------------------------}

constructor TObjectItem.Create(ParObj:TRoot);
begin
	inherited Create;
	iObject := ParObj;
end;


{-----( TListItem )----------------------------------------------}


function TListItem.IsLast:boolean;
begin
	exit( fNxt = nil);
end;

function TListITem.IsFirst:boolean;
begin
	exit(fPrv = nil);
end;

procedure TListItem.commonsetup;
begin
	inherited CommonSetup;
	fPrv := nil;
	fNXt := nil;
end;



{-----( TList )---------------------------------------------------}

procedure  TList.SoftEmptyList;
begin
	iStart := nil;
end;


function TList.GetItemByNum(parNum : cardinal):TListItem;
var vlCurrent : TListItem;
	vlNum     : cardinal;
begin
	vlNum := ParNum;
	vlCurrent := TListITem(iStart);
	while (vlNum>1) and (vlCurrent <> nil) do begin
		vlCUrrent := TListItem(vlCurrent.fNxt);
		dec(vlNum);
	end;
	exit( vlCurrent);
end;

function TList.IsEmpty:boolean;
begin
	IsEmpty := (iStart = nil);
end;

function TList.GetNumItems:cardinal;
var vlCnt : cardinal;
	vlCur : TListItem;
begin
	vlCur := iStart;
	vlCnt := 0;
	while vlCur <> nil do begin
		vlCur := vlCur.fNxt;
		inc(vlCnt);
	end;
	exit( vlCnt);
end;

function TList.CutOut(ParItem:TListItem):TListItem;
var vlNxt:TListItem;
begin
	if ParItem = nil then begin
		exit(nil);
	end;
	vlNxt := ParItem.fNxt;
	CutOut := vlNxt;
	if vlNxt = nil   then begin
		iTop  := ParItem.fPrv;
		CutOut := iTop;
	end else vlNxt.fPrv := parItem.fPrv;
	if ParItem.fPrv <> nil  then parItem.fPrv.fNxt := vlNxt
	else iStart := vlNxt;
end;

function TList.SaveItem(ParWriter:TObjectStream):boolean;
var vlCurrent:TListItem;
begin
	vlCurrent := iStart;
	while vlCurrent <> nil do begin
		if vlCurrent.SaveItem(ParWriter) then exit(true);
		vlCurrent := vlCurrent.fNxt;
	end;
	if ParWriter.WriteLongint(longint(IC_End_Mark)) then exit(true);
	exit(false);
end;

function  TList.LoadItem(parWriter:TObjectStream):boolean;
var
	vlCurrent:TListItem;
begin
	vlCurrent := nil;
	repeat
		case CreateObject(ParWriter,TStrAbelRoot(vlCurrent)) of
			STS_OK:InsertAtTop(vlCurrent);
			STS_Error,STS_Unkown_Object:exit(true);
			STS_End_Mark:break;
		end;
	until false;
	exit(false);
end;


function TList.InsertAtTop(ParItem:TListItem):TListItem;
begin
	exit( InsertAt(iTop,ParITem));
end;


function TList.InsertAt(ParAt:TListItem;ParITem:TListItem):TListItem;
begin
	if ParItem <> nil then begin
		if ParAt = nil then begin
			ParItem.fPrv :=  nil;
			ParItem.fNxt := (iStart);
			if iStart <> nil then iStart.fPrv := ParItem;
			iStart := ParItem;
		end else begin
			ParItem.fPrv := ParAt;
			ParItem.fNxt := ParAt.fNxt;
			if ParAt.fNxt <> nil then ParAt.fNxt.fPrv := ParItem;
			ParAt.fNxt := ParItem;
		end;
		if ParAt = iTop then iTop := ParItem;
	end;
	exit(Paritem);
end;

function TList.DeleteLink(ParItem:TListItem):TListItem;
begin
	DeleteLink := CutOut(ParItem);
	if ParItem <> nil then ParItem.destroy;
end;


procedure TList.DeleteAll;
var vlCurrent : TListItem;
	vlThis    : TListItem;
begin
	vlCurrent := iStart;
	while vlCurrent <> nil do begin
		vlThis := vlCurrent;
		vlCurrent := vlThis.fNxt;
		vlThis.Destroy;
	end;
	iTop   := nil;
	iStart := nil;
end;

procedure TList.Clear;
begin
	inherited Clear;
	DeleteAll;
end;

procedure TList.commonsetup;
begin
	inherited COmmonsetup;
	iTop   := nil;
	iStart := nil;
end;


end.
