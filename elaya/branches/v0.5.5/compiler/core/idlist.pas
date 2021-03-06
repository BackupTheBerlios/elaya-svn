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

unit IDList;
interface
uses cmp_type,compbase,formbase,linklist,elacons,elatypes,stdobj,DDefInit,DIdentLs,
	display,node,config,macobj,asminfo;
type
	TIdentListCollection=class(TList)
		procedure AddToCurrentDefaultList(ParDef:TDefinition);
		procedure AddIdentList(const ParName:string;ParLevel : TUnitLevel;ParIdentList:TIdentList;ParPublic:boolean);
		function  GetPtrByName(const Partext:string;var ParOwner,ParItem:TDefinition):boolean;
		function  GetDefaultIdent(ParDefault :TDefaultTypeCode;ParSize : TSize;ParSign:boolean):TType;
		function  GetPtrInCurrentList(ParName:String;var ParOwner,ParItem : TDefinition):boolean;
		function  AddIDentToCurrentList(ParIdent:TDefinition):TErrorType;
		function  GetCurrentList:TIdentList;
		procedure AddInitCall(ParCre:TSecCreator);
		function GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition) : TObjectFindState;
	end;
	

	
implementation
uses pocobj,cblkbase,procs;

type
	
	TIdentListItem=class(TListItem)
	private
		voIdentList : TIdentList;
		voName      : TString;
		voPublic    : boolean;
		voLevel     : TUnitLevel;
		property    iName      : TString    read voName      write voName;
		property    iLevel     : TUnitLevel read voLevel     write voLevel;
		property    iIdentList : TIdentList read voIdentList write voIdentList;
		property    iPublic    : boolean    read voPublic    write voPublic;
	public
		property    fLevel  : TUnitLevel read voLevel;
		property    fPublic : boolean read voPublic;
		property    fName   : TString read voName;
		
		procedure   SetPublic(ParPub:boolean);
		procedure   Commonsetup;override;
		constructor Create(const ParName:string;ParLevel : TUnitLevel;ParIdentListItem:TIdentList);
		destructor  Destroy;override;
		function    AddIDent(parIdent:TDefinition):TErrortype;
		function    GetPtrByName(const ParText:string;var ParOwner : TDefinition;var ParItem:TDefinition):boolean;
		function    GetDefaultIdent(ParDefault:TDefaultTypeCode;ParSize : TSize;ParSign:boolean):TType;
		procedure   AddInitCall(ParCre:TSecCreator);
		function    GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition) : TObjectFindState;
		function    HasSameName(const ParName : string):boolean;
	end;


{---------( TIdentListCollection )---------------------------------------------------}

procedure TIDentListCollection.AddToCurrentDefaultList(ParDef:TDefinition);
begin
	TIdentList(GetCurrentList).AddToDefaultList(ParDef);
end;

procedure TIdentListCollection.AddInitCall(ParCre:TSecCreator);
var vlCUrrent:TIdentListITem;
begin
	vlCurrent := TIdentListITem(fStart);
	if vlCurrent <> nil then vlCurrent := TIdentListITem(vlCurrent.fNxt);
	while vlCurrent <> nil do begin
		vlCurrent.AddInitCall(ParCre);
		vlCurrent := TIdentListITem(vlCurrent.fNxt);
	end;
end;


function  TIdentListCollection.GetCurrentLIst:TIdentList;
var vlIdentListitem:TIdentListITem;
begin
	GetCurrentList := nil;
	vlIdentListItem := TIdentListITem(fTop);
	if vlIdentListitem <> nil then GetCurrentList := vlIdentListItem.iIdentList;
end;

function  TIdentListCollection.GetPtrInCurrentList(ParName:String;var ParOwner,ParItem:TDefinition):boolean;
begin
	exit(TIdentListITem(fTop).GetPtrByName(ParName,ParOwner,ParItem));
end;

procedure TIdentListCollection.AddIdentList(const ParName:string;ParLevel : TUnitLevel;ParIdentList:TIdentList;ParPublic:boolean);
var vlItem : TIdentListITem;
	vlCurrent : TIdentListItem;
begin
	ParIdentList.InitHashing;
	ParIdentList.AddToHashing;
	vlCurrent := TIdentListItem(fTop);
	if(vlCurrent <> nil) then vlCurrent := TIdentListItem(vlCurrent.fPrv);
	while (vlCurrent <> nil) and (vlCurrent.fLevel > ParLevel) do vlCurrent := TIdentListItem(vlCurrent.fPrv);
	vlItem := TIdentListItem.Create(ParName,ParLevel,ParIdentList);
	InsertAt(vlCurrent,vlItem);
	vlItem.SetPublic(ParPublic);
end;

function TIDentListCollection.AddIDentToCurrentList(ParIdent:TDefinition):TErrorType;
begin
	AddIdentTocurrentList := TIdentListITem(fTop).AddIdent(ParIdent);
end;



function TIdentListCOllection.GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition) : TObjectFindState;
var vlCurrent : TIDentListItem;
	vlState  : TObjectFindState;
begin
	vlCurrent := TIdentListItem(fTop);
	while (vlCurrent <> nil) do begin
		if vlCurrent.iPublic then begin
			vlState := vlCurrent.GetPtrByObject(ParName,ParObject,ParOwner,ParResult);
			if vlState <> OFS_Different then exit(vlState);
		end;
		vlCurrent := TIDentListItem(vlCurrent.fPrv);
	end;
	ParResult := nil;
	exit(OFS_Different);
end;

function TIDentListCollection.GetPtrByName(const ParText:string;var ParOwner,ParItem:TDefinition):boolean;
var vlCurrent : TIdentListITem;
begin
	vlCurrent := TIdentListITem(fTop);
	ParOwner := nil;
	ParItem  := nil;
	while vlCurrent <> nil do begin
		if vlCurrent.fPublic then begin
			if vlCurrent.GetPtrByName(ParText,ParOwner,ParItem) then exit(true);
		end;
		vlCurrent := TIdentListITem(vlCurrent.fPrv);
	end;
	exit(false);
end;


function TIDentListCollection.GetDefaultIdent(ParDefault:TDefaultTypeCode;ParSize : TSize;ParSign:boolean):TType;
var vlCurrent :TIdentListITem;
	vlFound :TDefinition;
begin
	vlCurrent := TIdentListITem(fTop);
	vlFound := nil;
	while vlCurrent <> nil do begin
		vlFound := vlCurrent.GetDefaultIdent(ParDefault,ParSize,ParSign);
		if vlFound <> nil then break;
		vlCurrent := TIdentListITem(vlCurrent.fPrv);
	end;
	GetDefaultIdent := TType(vlfound);
end;


{---------( TIdentListItem )---------------------------------------------------------}


function TIdentListItem.HasSameName(const ParName : string):boolean;
begin
	exit(iName.IsEqualStr(ParName));
end;

procedure TIdentListItem.SetPublic(ParPub:boolean);
begin
	voPublic := ParPub ;
end;

procedure TIdentListItem.Commonsetup;
begin
	inherited commonsetup;
	iPublic :=false;
end;


constructor TIdentListItem.Create(const ParName:string;ParLevel : TUnitLevel;ParIdentListItem:TIdentList);
begin
	inherited Create;
	iIdentList := ParIdentlistItem;
	iName      := TString.Create(ParName);
	iLevel     := ParLevel;
end;

function TIdentListItem.GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition) : TObjectFindState;
begin
	exit(iIdentList.GetPtrByObject(ParName,ParObject,ParOwner,ParResult));
end;

function TIdentListItem.GetPtrByName(const ParText:string;var ParOwner : TDefinition; var ParItem:TDefinition):boolean;
begin
	exit( iIdentList.GetPtrByName(ParText,ParOwner,ParItem));
end;

function TIdentListItem.GetDefaultIdent(ParDefault:TDefaultTypeCode;ParSize : TSize;ParSign:boolean):TType;
begin
	GetDefaultIdent := TType(iIdentList.GetDefaultident(ParDefault,ParSize,ParSign));
end;

function  TIdentListITem.AddIDent(parIdent:TDefinition):TErrortype;
begin
	AddIdent := iIdentList.AddIdent(ParIdent);
end;


procedure TIdentListitem.AddInitCall(ParCre:TSecCreator);
var vlDef   : TRoutineCollection;
	vlRtn   : TRoutine;
	vlProc  : TCallPoc;
	vlName  : string;
	vlOwner : TDefinition;
	vlMac   : TLabelMac;
begin
	if GetPtrByName(CNF_UNit_Startup,vlOwner,vlDef) then begin
		vlRtn := vlDef.GetFirstRoutine;
		if vlRtn <> nil then begin
			vlRtn.GetMangledName(vlName);
			vlMac := TLabelMac.Create(vlname,GetAssemblerInfo.GetSystemSize);
			ParCre.AddObject(vlMac);
			vlProc := TCallPoc.Create(vlMac,false,0);
			ParCre.AddSec(vlProc);
		end;
	end;
end;

destructor  TIdentListItem.Destroy;
begin
	inherited Destroy;
	if iName <> nil then iName.Destroy;
end;

end.
