























{    Elaya, thecompiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
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

unit varbase;
interface
uses stdobj,streams,linklist,compbase,elacons,progutil,macobj,elatypes,elacfg,ddefinit,
formbase,asmcreat,asmdata,node,display,pocobj,asminfo,error,largenum,useitem;
type
	TVarBase=class(TFormulaDefinition)
	private
		voType   : TType;
		voAccess : TCan_Types;
		voAlign  : TSize;

	protected
		property   iType   : TType      read voType write voType;
		property   iAccess : TCan_Types read voAccess write voAccess;
		property   iAlign  : TSize      read voALign  write voAlign;

		procedure   CommonSetup;override;
	public
		property    fType   : TType      read voType;
		property    fAccess : TCan_Types read voAccess;
		procedure   SetType(ParType:TType);

		function    CreateDB(ParCre:TCreator):boolean;override;
		function    CreateMac(ParContext :TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;virtual;
		constructor Create(const ParName : ansistring;ParType:TType);
		function    CAN(PArCan:TCAN_Types):boolean;override;
		function    LoadItem(ParWrite:TObjectStream):boolean;override;
		function    GetPtrByName(const ParName:ansistring;ParOption : TSearchOptions;var ParOwner,ParItem:TDefinition):boolean;override;
		function    GetSize:TSize;
		function    GetSign:boolean;
		function    SaveItem(ParWrite:TObjectStream):boolean;override;
		function    CreateReadNode(ParCre:TCreator;ParContext : TDefinition):TFormulaNode;override;
		function    IsLargeType : boolean;
		function    IsSame(ParOther : TVarBase):boolean;virtual;
		function   	IsOptUnsave:boolean;virtual;
		function   	GetPtrByObject(const ParName:ansistring;ParObject : TRoot;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : TObjectFindState;override;
    	function    CreateDefinitionUseItem : TUseItem;override;
	end;
	
	TVarNode=class(TValueNode)
	private
		voVariable : TVarBase;
		property  iVariable : TVarBase read voVariable write voVariable;
	protected
		procedure   CommonSetup;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;Parcre:TSecCreator):TMacBase;override;

	public
		property    fVariable : TVarBase read voVariable;
		constructor Create(ParVar:TVarBase);
		function    GetOrgType:TType;override;
		function    Can(ParCan:TCan_Types):boolean;override;
		procedure   PrintNode(ParDis:TDisplay);override;
		function    GetType  :TType;override;
		function    IsOptUnsave:boolean;override;
		procedure   ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);override;
		function    GetDefinition : TDefinition;override;
	end;
	

	
	
implementation
uses ndcreat;




{--------( TVarNode )------------------------------------------}

function  TVarNode.GetDefinition : TDefinition;
begin
	exit(iVariable);
end;


procedure  TVarNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
var
	vlStatus : TAccessStatus;
	vlItem : TUseItem;
begin
	vlStatus := ParUSeList.SetAccess(iVariable,ParMode,vlItem);
	DefinitionUseStatusToError(ParCre,vlStatus,vlItem);
end;

function TVarNode.IsOptUnsave:boolean;
begin
	if iVariable <> nil then begin
		exit(iVariable.IsOptUnSave);
	end else begin
		exit(false);
	end;
end;

constructor TVarNode.Create(ParVar:TVarBase);
begin
	iVariable := PArVar;
	inherited Create;
end;

function  TVarNode.DoCreateMac(ParOpt:TMacCreateOption;Parcre:TSecCreator):TMacBase;
var
	vlMac : TMacBase;
begin
	vlMac :=  iVariable.CreateMac(iContext,ParOpt,ParCre);
	exit(vlMac);
end;

function TVarNode.GetType:TType;
begin
	exit( GetOrgType);
end;


function TVarNode.GetOrgType:TType;
var vlType:TType;
begin
	
	vlType := nil;
	if iVariable <> nil then vlType := iVariable.fType;
	if vlType <> nil  then   vlType := TType(vlType.GetOrgType);
	exit(vlType);
end;


procedure TVarNode.COmmonSetup;
begin
	inherited COmmonSetup;
	iIdentCode  := IC_VarNode;
	iComplexity := CPX_Variable;
end;

procedure TVarNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.Write('<variable>');
	iVariable.PrintName(ParDis);
	ParDis.Write('</variable>');
	
end;


function TVarNode.Can(ParCan:TCan_Types):boolean;
begin
	if(Can_Write in ParCan) then begin
		if iRecord <> nil then begin
			if not iRecord.can([Can_Write]) then exit(false);
		end;
	end;
	if  ([Can_Read,Can_Index,Can_Pointer] * ParCan <> []) and (iVariable.NeedReadableRecord) then begin
		if RecordReadCheck then exit(false);
	end;
	exit(iVariable.Can(PArCan));
end;


{------( TVarBase )-------------------------------------------------}


function  TVarBase.CreateDefinitionUseItem : TUseItem;
var
	vlUse : TUseItem;
begin
	vlUse := (fType.CreateVarOfTypeUse(self));
	exit(vlUse);
end;

function TVarBase.IsOptUnsave:boolean;
begin
	exit(false);
end;

function    TVarBase.IsSame(ParOther : TVarBase):boolean;
begin
	exit(self=ParOther);
end;

function    TVarBase.IsLargeType : boolean;
begin
	if iType <> nil then exit(iTYpe.IsLargeType)
	else exit(false);
end;

function  TVarBase.CreateReadNode(ParCre:TCreator;ParContext : TDefinition):TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	vlNode := TVarNode.Create(self);
	vlNode.fContext := ParContext;
	TNDCreator(ParCre).SetNodePos(vlNode);
	exit(vlNode);
end;

function    TVarBase.CreateDB(ParCre:TCreator):boolean;
var vLName:ansistring;
	vlSize:Longint;
begin
	vlSize := GetSize;
	GetMangledName(vlName);
	TAsmCreator(PArCre).ChangeDataAlign(iAlign);
	TAsmCreator(ParCre).AddData(TVarDef.Create(DAT_Variables,vlName,vlSize,IsAsmGlobal));
	CreateDb := false;
end;

function    TVarBase.CreateMac(ParContext  : TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlLi : TLargeNumber;
	vlMac : TMacBase;
begin
	vlMac :=nil; {TODO Error when Macoption <> MCO_SIZE}
	case ParOption of
		MCO_Size:begin
			LoadLong( vlLi,fType.fSIze);
			vlMac := TNumberMac.Create(GetAssemblerInfo.GetSystemSize,false,vlLi);
			ParCre.AddObject(vlMac);
		end;
	end;
	exit(vlMac);
end;

function TVarBase.CAN(PArCan:TCan_Types):boolean;
begin
	if fAccess =[] then begin message('fAccess empty');halt;end;
	if not ((ParCan * [Can_Read,Can_Write]) <= fAccess) then exit(false);
	if (Can_Dot in ParCan) and (fType <> nil) then begin
		if fType.Can([Can_Dot]) then  ParCan := ParCan - [Can_Dot];
	end;
	ParCan := ParCan -[Can_Read,CAN_Write , CAN_Size];
	exit( inherited Can(ParCan));
end;

constructor TVarBase.Create(const ParNAme : ansistring ;ParType:TType);
begin
	SetType(ParType);
	inherited Create;
	SetText(ParName);
end;

procedure TVarBase.COmmonSetup;
begin
	inherited commonsetup;
	iAccess := [];
	iAlign  := GetConfig.fAlign;
end;


procedure TVarBase.SetType(ParType:TType);
begin
	iType   := ParType;
end;


function TVarBase.SaveItem(ParWrite:TObjectStream):boolean;
begin
	SaveItem := true;
	if inherited SaveItem(parWrite) then exit;
	if ParWrite.WritePi(fType) then exit;
	SaveItem := false;
end;

function  TVarBase.LoadItem(ParWrite:TObjectStream):boolean;
begin
	LoadItem := true;
	if inherited LoadItem(ParWrite) then exit;
	if ParWrite.ReadPi(TStrAbelRoot(voType)) then exit;
	LoadItem := false;
	
end;



function    TVarBase.GetSign:boolean;
begin
	if fType <> nil then begin
		exit(fType.GetSign);
	end else begin
		exit(false);
	end;
end;

function    TVarBase.GetSize:TSize;
begin
	if fType <> nil then begin
		exit(fType.fSize);
	end else begin
		exit(0);
	end;
end;


function TVarBase.GetPtrByName(const ParName:ansistring;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : boolean;
begin
	ParItem := nil;
	ParOwner := nil;
	if fType <> nil then begin
		exit(fType.GetPtrByName(ParName,ParOption,ParOwner,ParItem));
	end;
	exit(false);
end;

function TVarBase.GetPtrByObject(const ParName:ansistring;ParObject : TRoot;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : TObjectFindState;
begin
	ParItem := nil;
	ParOwner := nil;
	if fType <> nil then begin
		exit(fType.GetPtrByObject(ParName,ParObject,ParOption,ParOwner,ParItem));
	end;
	exit(OFS_Different);
end;





end.
