{    Elaya, the compiler for the elasya language
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

unit curItem;
interface
uses error,stdobj,elacons,elatypes,compbase,ddefinit,simplist,node;

type
	TRefRoot=class of TRoot;
type
	TCurrentItem=class(TSMListItem)
	public
		function IsDefinitionType(ParType : TRefRoot):boolean;virtual;
	end;
	
	TCurrentList =class(TSMList)
	protected
		function FindItemByType(ParType : TRefRoot) :TCurrentItem;
	public
		procedure AddItem(ParItem : TCurrentItem);
		procedure PopIdent;
	end;
	
	TCurrentNodeList=class(TCurrentLIst)
	public
	end;
	
	TCurrentNodeItem=class(TCurrentItem)
	private
		voNode : TNodeIdent;
		property    iNode : TNodeIdent read voNode write voNode;
	public
		property    fNode:TNodeIdent  read voNode;
		constructor Create(ParNode:TNodeIdent);
		function IsDefinitionType(ParType : TRefRoot):boolean;override;
		
	end;
	
	
	TCurrentDefinitionList=class(TCurrentList)
		
	public
		function  GetPtrByName(const ParName:string;var ParOwner,ParItem :TDefinition):boolean;
		function  GetDefault(ParDefault : TDefaultTypeCode;ParSIze:TSize;ParSign:boolean):TDefinition;
		function  GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition):TObjectFindState;
		procedure AddCurrentNode(ParItem : TCurrentNodeItem);
		procedure PopCurrentNode;
		function  GetNodeByType(ParType :TRefRoot) : TNodeIdent;
		function  GetDefinitionByType(ParType : TRefRoot) : TDefinition;
		function  GetCurrentInsertItem : TDefinition;
		function  GetDefinitionByNum(ParNum : cardinal) : TDefinition;
		function  GetCurrentDefinitionsAccess : TDefAccess;
	end;
	
	TCurrentDefinitionItem=class(TCurrentItem)
	private
		voIsolated     : boolean;
		voQueryOnly    : boolean;
		voDefinition   : TDefinition;
		voNodes        : TCUrrentNodeList;
		
		property iNodes        : TCurrentNodeList read voNodes        write voNodes;
		
		property iDefinition   : TDefinition      read voDefinition   write voDefinition;
		property iIsolated     : boolean          read voIsolated     write voIsolated;
		property iQueryOnly    : boolean          read voQueryOnly    write voQueryOnly;

	protected
		procedure   commonsetup;override;
		procedure   Clear;override;
		
	public
		
		property    fDefinition : TDefinition read voDefinition;
		property    fIsolated   : boolean     read voIsolated;
		property    fQueryOnly  : boolean     read voQueryOnly;
		
		constructor Create(ParDef:TDefinition;ParIsolated,ParQueryOnly : boolean);
		function    GetPtr(const ParName:string;var ParOwner, ParItem : TDefinition):boolean;
		function    GetDefault(ParDefault:TDefaultTypeCode;ParSize:TSize;ParSign:boolean):TDefinition;virtual;
		function    GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition):TObjectFindState;
		procedure   AddCurrentNode(ParItem : TCurrentNodeItem);
		procedure   PopCurrentNode;
		function    GetNodeByType(ParType :TRefRoot) : TNodeIdent;
		function    GetDefAccess :TDefAccess;
		function    IsDefinitionType(ParType : TRefRoot):boolean;override;
	end;
	
	
implementation
uses procs;

{---( TCUrrentNode )---------------------------------------------------------}



constructor TCurrentNodeItem.Create(ParNode:TNodeIdent);
begin
	inherited Create;
	iNode := ParNode;
end;

function TCurrentNodeItem.IsDefinitionType(ParType : TRefRoot):boolean;
begin
	exit(iNode is ParType);
end;


{---( TCurrentDefinitionItem)-------------------------------------------------}


function TCurrentDefinitionItem.GetDefAccess :TDefAccess;
begin
	exit(iDefinition.fDefAccess);
end;


function TCurrentDefinitionItem.IsDefinitionType(ParType : TRefRoot):boolean;
begin
	exit(iDefinition is ParType);
end;


function  TCurrentDefinitionItem.GetNodeByType(ParType :TRefRoot) : TNodeIdent;
var
	vlItem :TCurrentNodeItem;
begin
	vlItem := TCurrentNodeItem(iNodes.FindItemBytype(ParType));
	if vlItem <> nil then begin
		exit(vlItem.fNode);
	end else begin
		exit(nil);
	end;
end;


procedure TCurrentDefinitionItem.PopCurrentNode;
begin
	iNodes.PopIdent;
end;


procedure TCurrentDefinitionItem.AddCurrentNode(ParItem : TCurrentNodeItem);
begin
	iNodes.AddItem(parItem);
end;

function TCurrentDefinitionItem.GetPtr(const ParName:string;var ParOwner,ParItem:TDefinition):boolean;
begin
	exit(iDefinition.GetPtrByName(ParName,[SO_Local,SO_Current_List],ParOwner,ParItem));
end;


function TCurrentDefinitionItem.GetDefault(ParDefault : TDefaultTypeCode;ParSize:TSize;ParSign:boolean):TDefinition;
begin
	exit(iDefinition.GetDefaultIdent(ParDefault,ParSize,ParSign));
end;

constructor TCurrentDefinitionItem.Create(ParDef:TDefinition;ParIsolated,ParQueryOnly : boolean);
begin
	inherited Create;
	iIsolated   := ParIsolated;
	iDefinition := ParDef;
	iQueryOnly  := ParQueryOnly;
end;

procedure   TCurrentDefinitionItem.commonsetup;
begin
	inherited Commonsetup;
	iNodes     := TCurrentNodeList.Create;
end;


function  TCurrentDefinitionItem.GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition):TObjectFindState;
begin
	exit(iDefinition.GetPtrByObject(ParName,ParObject,[SO_Local,SO_Current_List],ParOwner,ParResult));
end;


procedure TCurrentDefinitionItem.Clear;
begin
	inherited Clear;
	if iNodes <> nil then iNodes.Destroy;
end;



{---( TCurrentItem )-----------------------------------------------------------}


function TCurrentItem.IsDefinitionType(ParType : TRefRoot):boolean;
begin
	exit(false);
end;


{---( TCurrentItemList )-----------------------------------------------}


procedure TCurrentList.AddItem(ParItem : TCurrentItem);
begin
	InsertAt(nil,ParItem);
end;


function TCurrentList.FindItemByType(ParType : TRefRoot) :TCurrentItem;
var
	vlCurrent :TCurrentItem;
begin
	vlCurrent := TCurrentItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsDefinitionType(ParType)) do vlCurrent := TCurrentItem(vlCurrent.fNxt);
	exit(vlCurrent);
end;

procedure TCurrentList.PopIdent;
begin
	if fStart <> nil then begin
		DeleteLink(fStart);
	end  else begin
		fatal(fat_Current_List_empty,className);
	end;
end;


{---( TCurrentDefinitionList )---------------------------------------}


function  TCurrentDefinitionList.GetCurrentDefinitionsAccess : TDefAccess;
var
	vlAcc : TDefAccess;
	vlAcc2 : TDefAccess;
	vlCurrent : TCurrentDefinitionItem;
begin
    vlCurrent := TCurrentDefinitionItem(fStart);
	vlAcc := AF_PUblic;
	while vlCurrent <> nil do begin
		vlAcc2 := vlCurrent.GetDefAccess;
        if vLAcc2 = AF_Current then vlAcc := CombineAccess(vlAcc2,vlAcc);
		vlCurrent := TCurrentDefinitionItem(vlCurrent.fNxt);
	end;
	exit(vLAcc);
end;


function  TCurrentDefinitionList.GetDefinitionByNum(ParNum : cardinal) : TDefinition;
var
	vlCnt : cardinal;
	vlCurrent :TCurrentDefinitionItem;
begin
	vlCurrent := TCurrentDefinitionItem(fStart);
	vlCnt := ParNum;
	while (vlCurrent <> nil) and (vlCnt > 0) do begin
		if not(vlCurrent.fDefinition is TRoutineCollection) then dec(vLCnt);
		if vlCurrent.fIsolated then exit(nil);
		vlCurrent := TCurrentDefinitionItem(vlCurrent.fNxt);
	end;
	if vlCurrent <> nil then begin
		exit(vlCurrent.fDefinition);
	end else begin
		exit(nil);
	end;
end;

function TCurrentDefinitionList.GetCurrentInsertItem : TDefinition;
var
	vlItem : TCurrentDefinitionItem;
begin
	vlItem := TCurrentDefinitionItem(fStart);
	while (vlItem <> nil) and (vlItem.fQueryOnly) do vlItem := TCurrentDefinitionItem(vlitem.fNxt);
	if vlItem  <> nil then begin
		exit(vlItem.fDefinition);
	end else begin
		exit(nil);
	end;
end;

function TCurrentDefinitionList.GetDefinitionByType(ParType : TRefRoot) : TDefinition;
var
	vlFound : TCurrentDefinitionItem;
begin
	
	vlFound := TCurrentDefinitionItem(FindItemByType(ParType));
	if vlFound = nil then begin
		exit(nil);
	end else begin
		exit(vlFound.fDefinition);
	end;
end;

function  TCurrentDefinitionList.GetNodeByType(ParType :TRefRoot) : TNodeIdent;
var
	vlStart : TCurrentDefinitionItem;
begin
	vlStart := TCurrentDefinitionItem(fStart);
	if vlStart = nil then fatal(FAT_No_Current_definition,'' );
	exit(vlStart.GetNodeByType(ParType));
end;

procedure TCurrentDefinitionList.AddCurrentNode(ParItem : TCurrentNodeItem);
var
	vlStart : TCurrentDefinitionItem;
begin
	vlStart := TCurrentDefinitionItem(fStart);
	if vlStart = nil then fatal(FAT_No_Current_definition,'' );
	vlStart.AddCurrentNode(ParItem);
end;

procedure TCurrentDefinitionList.PopCurrentNode;
var
	vlStart : TCurrentDefinitionItem;
begin
	vlStart := TCurrentDefinitionItem(fStart);
	if vlStart = nil then fatal(FAT_No_Current_definition,'' );
	vlStart.PopCurrentNode;
end;

function  TCurrentDefinitionList.GetPtrByName(const ParName:string;var ParOwner,ParItem:TDefinition):boolean;
var vlCurrent : TCurrentDefinitionItem;
begin
	vlCurrent := TCurrentDefinitionItem(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent.GetPtr(ParName,ParOwner,ParItem) then exit(true);
		if vlCurrent.fIsolated then break;
		vlCurrent := TCurrentDefinitionItem(vlCurrent.fNxt);
	end;
	ParOwner:= nil;
	ParItem := nil;
	exit(false);
end;



function  TCurrentDefinitionList.GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition):TObjectFindState;
var vlCurrent : TCurrentDefinitionItem;
begin
	vlCurrent := TCurrentDefinitionItem(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent.GetPtrByObject(ParName,ParObject,ParOwner,ParResult) <> OFS_Different  then exit(OFS_Same);
		if vlCurrent.fIsolated then break;
		vlCurrent := TCurrentDefinitionItem(vlCurrent.fNxt);
	end;
	ParResult := nil;
	ParOwner := nil;
	exit(Ofs_Different);
end;


function  TCurrentDefinitionList.GetDefault(ParDefault : TDefaultTypeCode;ParSIze:TSize;ParSign:boolean):TDefinition;
var vlCurrent  : TCurrentDefinitionItem;
	vlItem     : TDefinition;
begin
	vlCurrent := TCurrentDefinitionItem(fStart);
	while vlCurrent <> nil do begin
		vlItem := vlCurrent.GetDefault(ParDefault,ParSize,ParSign);
		if vlItem<> nil then exit(vlItem);
		if vlCurrent.fIsolated then break;
		vlCurrent := TCurrentDefinitionItem(vlCurrent.fNxt);
	end;
	exit(nil);
end;

end.
