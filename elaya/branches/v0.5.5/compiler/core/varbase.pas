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
formbase,asmcreat,asmdata,node,display,pocobj,asminfo,error,largenum,varuse;
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
		constructor Create(const ParName : string;ParType:TType);
		function    CAN(PArCan:TCAN_Types):boolean;override;
		function    LoadItem(ParWrite:TObjectStream):boolean;override;
		function    GetPtrByName(const ParName:string;ParOption : TSearchOptions;var ParOwner,ParItem:TDefinition):boolean;override;
		function    GetSize:TSize;virtual;
		function    GetSign:boolean;
		function    SaveItem(ParWrite:TObjectStream):boolean;override;
		function    CreateReadNode(ParCre:TCreator;ParContext : TDefinition):TFormulaNode;override;
		function    IsLargeType : boolean;
		function    IsSame(ParOther : TVarBase):boolean;virtual;
		function   	IsOptUnsave:boolean;virtual;
		function   	GetPtrByObject(const ParName:string;ParObject : TRoot;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : TObjectFindState;override;
    	procedure   AddToUseList(ParList : TVarUseList);override;
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
		function    SetVarUseItem(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TVarUseList;var ParItem : TVarUSeItem) : TAccessStatus;override;
	end;
	
	TVariable=class(TVarBase)
	protected
		procedure CommonSetup;override;
	public
		function  Can(ParCan:TCan_Types):boolean;override;
		function  CreateMac(ParContext : TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		procedure PrintDefinitionType(ParDis :TDisplay);override;
		procedure PrintDefinitionHeader(ParDIs :TDisplay);override;
		Procedure PrintDefinitionBody(ParDis :TDisplay);override;
	end;
	
	TTLVariable = class(TVariable)
	private
		voName         : cardinal;
		property iName : cardinal read voName write voName;
	protected
		procedure Commonsetup;override;

	public
		property  fName : cardinal read voName;
		function  CreateMac(ParContext : TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
	end;
	
	TTLVarNode  = class(TVarNode)
	protected
		procedure  clear;override;

	public
		constructor Create(ParType:TType);
	end;
	
	
implementation
uses ndcreat;


{--------( TTLVarNode )----------------------------------------}


constructor TTLVarNode.Create(ParType : TType);
begin
	inherited Create(TTLVariable.Create('[TRTLParameter]',ParType));
end;


procedure TTLVarNode.clear;
begin
	inherited clear;
	if fVariable <> nil then fVariable.Destroy;
end;



{--------( TTLVariable )--------------------------------------}


procedure TTLVariable.Commonsetup;
begin
	inherited commonsetup;
	iName := GetNewResNo;
end;


function    TTLVariable.CreateMac(ParContext : TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlMac : TTLMac;
begin
	if ParOption =	MCO_Result then begin
		vlMac       := TTLMac.Create(iType.fSize,iType.GetSign);
		ParCre.AddObject(vlMac);
		vlMac.fName := fName;
		exit(vlMac);
	end else begin
		exit(inherited CreateMac(ParContext,ParOption,ParCre));
	end;
end;


{--------( TVarNode )------------------------------------------}

function  TVarNode.SetVarUseItem(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TVarUseList;var ParItem : TVarUseItem) : TAccessStatus;
begin
	if iVariable is TVariable then   begin
		exit(ParUseList.SetAccess(iVariable,ParMode,ParItem));
	end else begin
		ParItem := nil;
		exit(AS_Normal);
	end;
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
	if  ([Can_Read,Can_Write,Can_Index,Can_Pointer] * ParCan <> []) and (iVariable.NeedReadableRecord) then begin
		if RecordReadCheck then exit(false);
	end;
	exit(iVariable.Can(PArCan));
end;


{------( TVarBase )-------------------------------------------------}


procedure TVarBase.AddToUseList(ParList : TVarUseList);
begin
	ParList.AddItem(self);
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
var vLName:string;
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

constructor TVarBase.Create(const ParNAme : string ;ParType:TType);
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


function TVarBase.GetPtrByName(const ParName:string;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : boolean;
begin
	ParItem := nil;
	ParOwner := nil;
	if fType <> nil then begin
		exit(fType.GetPtrByName(ParName,ParOption,ParOwner,ParItem));
	end;
	exit(false);
end;

function TVarBase.GetPtrByObject(const ParName:string;ParObject : TRoot;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : TObjectFindState;
begin
	ParItem := nil;
	ParOwner := nil;
	if fType <> nil then begin
		exit(fType.GetPtrByObject(ParName,ParObject,ParOption,ParOwner,ParItem));
	end;
	exit(OFS_Different);
end;

{------( TVariable )------------------------------------------------}



function TVariable.CreateMac(ParContext : TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlMac : TMacBase;
	vlStr : string;
begin
	Case ParOption of
	MCO_Result:begin
		GetMangledName(vlStr);
		vlMac := TMemMac.Create(fType.fSize,fType.GetSign);
		TMemMac(vlMac).SetName(vlStr);
		ParCre.AddObject(vlMac);
	end;
	MCO_ValuePointer,MCO_ObjectPointer:begin
		vlMac := TMemOfsMac.Create;
		TMemOfsMac(vlMac).SetSourceMac(CreateMac(ParContext,MCO_Result,ParCre));
		ParCre.AddObject(vlMac);
	end
	else vlMac:= inherited CreateMac(ParContext,ParOption,ParCre);
end;
exit(vlmac);
end;

procedure TVariable.COmmonSetup;
begin
	Inherited CommonSetup;
	iIdentCode := (IC_Variable);
	iAccess := [Can_Read,Can_Write];
end;


function TVariable.Can(ParCan:TCan_Types):boolean;
begin
	exit( inherited Can(ParCan - [Can_Pointer]));
end;

procedure TVariable.PrintDefinitionType(ParDis:TDisplay);
begin
	ParDis.Write('variable');
end;

procedure TVariable.PrintDefinitionHeader(ParDis:TDisplay);
begin
	inherited PrintDefinitionHeader(ParDis);
end;

procedure TVariable.PrintDefinitionBody(ParDis:TDisplay);
begin
	pardis.write('<type>');
	PrintIdentName(ParDis,fType);
	pardis.write('</type>');
end;

end.
