{    Elaya, the compiler fo;r the elasya langu;age
Copyright (C) 1999-2003  J.v.Iddekinge.
Web  : www.elaya.org

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
unit procs;

interface
uses error,strmbase,streams,cblkbase,Formbase,compbase,asmdata,stdobj,ddefinit,asminfo,
elacons,display,node,params,DIdentLs,progutil,NDCreat,idlist,cmp_type,frames;

type
	
	TProcedureObj=class(TRoutine)
	protected
		procedure  CommonSetup;override;
	public
		function   CreateNewCB(ParCre : TCreator;const ParNAme : string) : TRoutine;  override;
		procedure  PrintDefinitionType(ParDIs:TDisplay);override;
		procedure  CheckIsInheritedComp(ParCre : TCreator;ParCB : TRoutine;ParHasMain : boolean);override;
		function   CreateExitNode(ParCre : TCreator;ParNode : TFormulaNode) : TNodeIdent;override;
	end;

	TReturnRoutine=class(TRoutine)
	private
		voType:TType;
		
	protected
		
		property   iType : TType  read voType write voType;
		procedure   CommonSetup;override;
		function   CreateSeperationRoutine(ParCre : TNDCreator) : TRoutine;override;

	public

		property    fType : TType read voType;

		procedure   PrintDefinitionType(ParDis : TDisplay);override;
		procedure   PrintDefinitionHeader(ParDis : TDisplay);override;
		function    SaveItem(ParStream : TObjectStream):boolean;override;
		function    LoadItem(ParStream : TObjectStream):boolean;override;
		procedure   SetFunType(ParCre : TNDCreator;ParType:TType);
		function    Can(ParCan:TCan_Types):boolean;override;
		{Comparition}
		function   IsSameRoutine(ParProc:TRoutine;ParType : TParamCompareOptions):boolean;override;
		procedure  CheckIsInheritedComp(ParCre : TCreator;ParCB : TRoutine;ParHasMain : boolean);override;
		{Parameters}
		
		procedure  AddAutomaticParameters(ParMother : TDefinition;ParCre : TNDCreator);override;
		
		{Parsen}
		function  CreateExitNode(ParCre : TCreator;ParNode : TFormulaNode) : TNodeIdent;override;
		function   IsSameAsForward(ParCB : TDefinition;var ParText : string):boolean;override;
		function   CreateReadNode(ParCre : TCreator;ParOwner : TDefinition) : TFormulaNode;override;
	end;

	TFunction=class(TReturnRoutine)
	protected
		procedure   CommonSetup;override;

    public
		procedure   ValidateCanOverrideByComp(ParCre :TNDCreator;const ParOther : TRoutine);override;
		function	CreateNewCB(ParCre : TCreator;const ParName : string) : TRoutine;override;
	end;
	

	
	TRoutineCollection=class(TFormulaDefinition)
	protected
		procedure  COmmonsetup;override;
	public
		constructor Create(const ParName : string);
		function   Can(ParCan:TCan_Types):boolean;override;
		procedure  InitParts;override;
		function   CreateExecuteNode(ParCre:TCreator;ParContext : TDefinition):TNodeIdent;override;
		function   CreateReadNode(ParCre:TCreator;ParContext : TDefinition):TFormulaNode;override;
		function   GetDefaultRoutineItemByNode(ParNode : TCallNode) : TRoutine;
		function   GetRoutineItemByNode(ParNode:TCallNode):TRoutine;
		function   CreateDB(ParCre:TCreator):boolean;override;
		function   GetByDefinition(ParDef :TRoutine):TRoutine;
		function   GetByDefinition(ParDef :TRoutine;ParType : TParamCompareOptions):TRoutine;
		function   GetPtrByObject(const ParName : string;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;override;
		procedure  PrintDefinitionHeader(ParDis:TDisplay);override;
		procedure  PrintDefinitionBody(ParDis:TDisplay);override;
		procedure  PrintDefinitionType(ParDis:TDisplay);override;
		procedure  ProducePoc(ParCre : TCreator);
		function   IsSameByObject(const ParName : string;ParObject : TRoot):TObjectFindState;override;
		function   GetFirstRoutine :TRoutine;
		function   GetRoutineByMapping(ParMapping : TParameterMappingList):TRoutine;
		function   IsOverLoaded : boolean;
		function   GetType : Ttype;
		procedure ValidatePropertyProcComp(ParCre : TNDCreator;ParWrite : boolean;ParTYpe :TType);
		function SignalCPublic : boolean;override;
		function Addident(Parident:TDefinition):TErrorType;override;
		function   CreatePropertyWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue :TFormulaNode):TFormulaNode;override;
		function   CreatePropertyWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;override;

	end;


	TRoutineCollectionList=class(TIdentList)
		function GetRoutineItemByNode(ParNode:TCallNode):TRoutine;
		function GetByDefinition(ParDef :TRoutine):TRoutine;
		function GetByDefinition(ParDef :TRoutine;ParTYpe : TParamCompareOptions):TRoutine;
		function ExistsDefinition(ParDef:TRoutine):boolean;
		function Validate(ParDef:TDefinition):TErrorType; override;
		function IsOverloadingComp(ParDef:TDefinition):boolean;
		function GetDefaultRoutineItemByNode(ParNode : TCallNode) : TRoutine;
		function GetRoutineByMapping(ParMapping : TParameterMappingList) : TRoutine;
		function  AddidentAt(ParAt ,Parident:TDefinition):TErrorType;override;
		procedure ProducePoc(ParCre : TCreator);
		function  IsOverLoaded : boolean;
		function  GetFirstRoutine : TRoutine;
	end;
	
	
	
	TStartUpProc= class(TProcedureObj)
	private
		voIsUnitFlag : boolean;
		voCollection : TIdentListCollection;
		
		property  iIsUnitFlag : boolean              read voIsUnitFlag write voIsUnitFlag;
		property  iCollection : TIdentListCollection read voCollection write voCollection;

	protected

		procedure commonsetup;override;		
	public
		
		constructor Create(ParColl:TIdentListCollection;ParUnitflag:boolean);
		procedure onMangledName(var ParName : string);override;
		procedure PreMangledName(var ParName:string);override;
		procedure CreateInitProc(ParCre:TSecCreator);override;
		function  LoadItem(ParStr:TObjectStream):boolean;override;
		function  SaveItem(ParStr:TObjectStream):boolean;override;
	end;
	
	TRoutineType=class(TType)
	private
		voDispose : boolean;
		voRoutine : TRoutine;
		voOfObject: boolean;
		voParamFrame : TFrame;
		voPushedFrame: TFrame;
		property    iRoutine : TRoutine read voRoutine write voRoutine;
		property    iDispose : boolean  read voDispose write voDispose;
		property    iOfObject: boolean  read voOfObject write voOfObject;
		property    iParamFrame : TFrame read voParamFrame write voParamFrame;
		property    iPushedFrame : TFrame read voPushedFrame write voPushedFrame;
		procedure   SetRoutine(ParDone:boolean;ParProc:TRoutine);
	protected

		function    IsExactCompatibleSelf(ParType:TType):boolean;override;
		function    IsDirectcompatibleSelf(ParType:TType):boolean;override;
		procedure   commonsetup;override;
		procedure   Clear;override;
		
	public
		property    fRoutine     : TRoutine read voRoutine;
		property    fOfObject    : boolean  read voOfObject;
		property    fPushedFrame : TFrame   read voPushedFrame;
		property    fParamFrame : TFrame read voParamFrame;
		constructor Create(ParDone:boolean;ParProc:TRoutine;ParOfObject : boolean);
		function    LoadItem(ParStream:TObjectStream):boolean;override;
		function    SaveItem(ParStream:TObjectStream):boolean;override;
		procedure   Print(ParDis:TDisplay);override;
		procedure 	RtInitDotFrame(ParNode :TFormulaNode);
		procedure 	RtDoneDotFrame;

	end;
	
	
	
implementation
uses exprdigi,execobj,stmnodes;

{---( TRoutineCollectionList )--------------------------------------------}


function TRoutineCollectionList.GetFirstRoutine : TRoutine;
begin
	exit(TRoutine(fStart));
end;

function TRoutineCollectionList.IsOverLoaded : boolean;
var vlCurrent : TRoutine;
begin
	vlCurrent := TRoutine(fTop);
	while (vlCurrent <> nil) do begin
		if vlCurrent.IsOverloaded then exit(true);
		vlCurrent := TRoutine(vlCurrent.fPrv);
	end;
	exit(false);
end;


function TRoutineCollectionList.AddidentAt(ParAt ,Parident:TDefinition):TErrorType;
var vlError   : TErrorType;
begin
	if ParIdent is TRoutine then begin
		TRoutine(ParIdent).fCollectionNo := GetNumItems;
	end;
	vlError := inherited AddIdentAt(ParAt,ParIdent);
	exit(vlError);
end;

function TRoutineCollectionList.GetRoutineByMapping(ParMapping : TParameterMappingList) : TRoutine;
var vlCurrent : TRoutine;
begin
	vlCurrent := TRoutine(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsSameByMapping(ParMapping)) do vlCurrent := TRoutine(vlCurrent.fNxt);
	exit(vlCurrent);
end;

procedure TRoutineCollectionList.ProducePoc(ParCre : TCreator);
var vlCurrent : TRoutine;
begin
	vlCurrent := TRoutine(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.ProducePoc(ParCre);
		vlCurrent := TRoutine(vLCurrent.fNxt);
	end;
end;


function TRoutineCollectionList.GetDefaultRoutineItemByNode(ParNode : TCallNode) : TRoutine;
var
	vlCurrent:TRoutine;
begin
	vlCurrent := TRoutine(fStart);
	while (vlCurrent <> nil) do begin
		if (vlCurrent.IsSameTypeByNode(ParNode)) and (vlCurrent.fDefault = DT_Routine) then break;
		vlCurrent := TRoutine(vlCurrent.fNxt);
	end;
	GetDefaultRoutineItemByNode := vlCurrent;
end;

function TRoutineCollectionList.GetRoutineItemByNode(ParNode:TCallNode):TRoutine;
var
	vlCurrent:TRoutine;
begin
	vlCurrent := TRoutine(fTop);
	while (vlCurrent <> nil)do begin
		if vlCurrent.IsSameTypeByNode(ParNode) then break;
		vlCurrent := TRoutine(vlCurrent.fPrv);
	end;
	GetRoutineItemByNode := vlCurrent;
end;



function TRoutineCollectionList.GetByDefinition(ParDef :TRoutine):TRoutine;
var
	vlCurrent : TRoutine;
begin
	vlCurrent := TRoutine(fStart);
	while (vlCurrent <> nil)
	and not(ParDef.IsSameForFind(vlCurrent)) do begin
		vlCurrent := TRoutine(vlCurrent.fNxt);
	end;
	exit(vlCurrent);
end;


function TRoutineCollectionList.GetByDefinition(ParDef :TRoutine;ParType : TParamCompareOptions):TRoutine;
var vlCurrent:TRoutine;
begin
	vlCurrent := TRoutine(fStart);
	while (vlCurrent <> nil)
	and not(vlCurrent.IsSameRoutine(ParDef,ParType)) do begin
		vlCurrent := TRoutine(vlCurrent.fNxt);
	end;
	exit(vlCurrent);
end;

function TRoutineCollectionList.ExistsDefinition(ParDef:TRoutine):boolean;
begin
	exit( GetByDefinition(ParDef) <> nil);
end;



function  TRoutineCollectionList.IsOverloadingComp(ParDef:TDefinition):boolean;
begin
	IsOverloadingComp := true;
	if fStart = nil then exit;
	IsOverloadingComp := TRoutine(fStart).IsOverLoadingComp(ParDef);
end;


function TRoutineCollectionList.Validate(ParDef:TDefinition):TErrorType;
var
	vlRoutine : TRoutine;
	vlSType   : TParamCompareOptions;
	vlOther   : TRoutine;
	
begin

	if (ParDef = nil) or not (ParDef is TRoutine) then exit(Err_No_Error);

	if not (IsEmpty) then begin
		if  not(TRoutine(ParDef).IsOverloaded) then exit( Err_Duplicate_Ident);
		if ExistsDefinition(TRoutine(ParDef)) then exit(Err_Duplicate_Ident);
	end;

	vlRoutine := GetFirstRoutine;

	if vlRoutine <> nil then begin
		if (RTM_Name_Overload in vlRoutine.fRoutineModes) and ([RTM_OverLoad,RTM_Exact_Overload] * TRoutine(ParDef).fRoutineModes <> []) then exit(Err_overload_differs);
		if ([RTM_Overload,RTM_Exact_Overload] * vlRoutine.fRoutineModes <>[]) and (RTM_Name_Overload in TRoutine(ParDef).fROutineModes) then exit(Err_Overload_Differs);
	end;
	
	
	if not(RTM_Name_Overload in TRoutine(ParDef).fRoutineModes) then begin
		
		vlSType := [PC_IgnoreName];
		if not(RTM_Exact_OverLoad in TRoutine(ParDef).fRoutineModes) then vlSType := [PC_IgnoreName,PC_Relaxed];
		
		vlOther := GetByDefinition(TRoutine(ParDef),vlSType);
		if vlOther <> nil then exit(Err_Duplicate_Ident);
		
	end;
	
	if not IsOverloadingComp(ParDef) then exit( Err_Rtn_Not_Same);
	
	if (TRoutine(ParDef).GetRoutineOwner <> nil) then begin
		if not(TRoutine(ParDef).IsVirtual) and (TRoutine(ParDef).HasAbstracts) then exit(Err_Nested_contains_abs);
	end;
	
	exit(err_no_Error);
end;

{---( TRoutineCollection )-------------------------------------------------}


function  TRoutineCollection.CreatePropertyWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;
begin
	exit(GetFirstRoutine.CreatePropertyWriteDotNode(ParCre,ParLeft,ParSource,ParOwner));
end;

function  TRoutineCollection.CreatePropertyWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue :TFormulaNode):TFormulaNode;
begin
	exit(GetFirstRoutine.CreatePropertyWriteNode(ParCre,ParOwner,ParValue));
end;

procedure TRoutineCollection.ValidatePropertyProcComp(ParCre : TNDCreator;ParWrite : boolean;ParTYpe :TType);
begin
	if isOVerloaded then ParCre.ErrorDef(Err_Property_Routine_Overl,self);
 	if GetFirstRoutine = nil then exit;
	if not GetFirstRoutine.isPropertyProcComp(ParWrite,ParType) then ParCre.ErrorDef(Err_Wrong_Kind_ident_For_Prop,self);
end;

function  TRoutineCollection.GetType : Ttype;
begin
	if GetFirstRoutine <> nil then begin
		if GetFirstRoutine is TReturnRoutine then begin
			exit(TReturnRoutine(GetFirstRoutine).fType);
		end;
	end;
	exit(nil);
end;


function TRoutineCOllection.Addident(Parident:TDefinition):TErrorType;
var
	vlErr : TErrorType;
begin
	if not(ParIdent.fText.IsEqual(fText)) then runerror(100);
	vlErr := (inherited AddIdent(ParIdent));
    exit(vlErr);
end;


function TRoutineCOllection.SignalCPublic : boolean;
begin
	inherited SignalCPublic;
	exit(false);
end;

function TRoutineCollection.IsOverLoaded : boolean;
begin
	exit(TRoutineCollectionList(iParts).IsOverLoaded);
end;

function TRoutineCollection.GetRoutineByMapping(ParMapping : TParameterMappingList) : TRoutine;
begin
	exit(TRoutineCollectionList(iParts).GetRoutineByMapping(ParMapping));
end;

function TRoutineCollection.GetFirstRoutine :TRoutine;
begin
	exit(TRoutineCollectionList(iParts).GetFirstRoutine);
end;


function  TRoutineCollection.IsSameByObject(const ParName : string;ParObject : TRoot):TObjectFindState;
begin
	if ParObject <> nil then begin
		if IsSameText(ParName) then begin
			if  (ParObject is TRoutineCollection) or (not(ParObject is TRoutine) and (ParObject is TDefinition)) then exit(Ofs_Same);
		end;
	end;
	exit(Ofs_Different);
end;

{
note:owner parameter moet nog afgehandeld worden;
Mapping kan kijkt alleen in de routines in niet in de sub routines!
}

function  TRoutineCollection.GetPtrByObject(const ParName : string;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;
var
	vlCurrent : TRoutine;
begin
	ParOwner  := fOwner;
	ParResult := nil;
	if parObject = nil then exit(OFS_Different);
	if not IsSameText(ParName) then exit;
	if not IsOverloaded then begin
		ParResult := GetFirstRoutine;
		exit(OFS_Same);
	end;
	if ParObject.ClassType=TParameterMappingList then begin
		ParResult := GetRoutineByMapping(TParameterMappingList(ParObject));
	end else if ParObject.ClassType=TIdentHookDigiItem then begin
		{TODO: move tolist}
		vlCurrent := TRoutine(iParts.fStart);
		while (vlCurrent<> niL) do begin
			if THookDigiList(ParObject).IsSameParameters(vlCurrent.GetParList,RTM_Exact_Overload in vlCurrent.fRoutineModes) then break;
			 vlCurrent := TRoutine(vlCurrent.fNxt);
		end;
		ParResult := vlCurrent;
	end else if ParObject.ClassType=TCallNode then begin
		ParResult := GetRoutineItemByNode(TCallNode(ParObject));
		if (ParResult <> nil) and (RTM_Name_Overload in TRoutine(ParResult).fRoutineModes) and not(TCallNode(ParObject).IsCallByName) then begin
			ParResult := GetDefaultRoutineItemByNode(TCallNode(ParObject));
		end;
	end else if ParObject is TRoutine then  begin
		ParResult := GetByDefinition(TRoutine(ParObject));
	end else begin
		exit(OFS_Different);
	end;
	if (ParResult = nil) then exit(OFS_Different)
	else exit(OFS_Same);
end;

procedure  TRoutineCollection.ProducePoc(ParCre : TCreator);
begin
	TRoutineCollectionList(iParts).ProducePoc(ParCre);
end;

function TRoutineCollection.GetDefaultRoutineItemByNode(ParNode : TCallNode) : TRoutine;
begin
	exit(TRoutineCollectionList(iParts).GetRoutineItemByNode(ParNode));
end;

constructor TRoutineCollection.Create(const ParName : string);
begin
	inherited Create;
	SetText(parName);
end;


function TRoutineCollection.GetByDefinition(ParDef :TRoutine):TRoutine;
begin
	exit(TRoutineCollectionList(iParts).GetByDefinition(PArDef));
end;

function TRoutineCollection.GetByDefinition(ParDef :TRoutine;ParType : TParamCompareOptions):TRoutine;
begin
	exit(TRoutineCollectionList(iParts).GetByDefinition(PArDef,ParType));
end;

function TRoutineCollection.CreateDB(ParCre:TCreator):boolean;
begin
	CreateDB := iParts.CreateDB(ParCre);
end;

function TRoutineCollection.GetRoutineItemByNode(ParNode:TCallNode):TRoutine;
begin
	GetRoutineItemByNode := TRoutineCollectionList(iParts).GetRoutineItemByNode(ParNode);
end;

function  TRoutineCollection.Can(ParCan:TCan_Types):boolean;
var
	vlRoutine : TRoutine;
begin
	vlRoutine := GetFirstRoutine;
	if vlRoutine <> nil then begin
		exit(vlRoutine.Can(ParCan));
	end;
	exit(false);
end;

function TRoutineCollection.CreateReadNode(ParCre : TCreator;ParContext : TDefinition) : TFOrmulaNode;
var vlName : string;
	vlNode : TCallNode;
begin
	GetTextStr(vlName);
	vlNode  := TCallNode.Create(vlName);
	TNDCreator(ParCre).SetNodePos(vlNode);
	if not IsOverloaded then vlNode.SetRoutineItem(TNDCreator(ParCre),GetFirstRoutine,ParContext);
	exit(vlNode);
end;

function   TRoutineCollection.CreateExecuteNode(ParCre:TCreator;ParContext : TDefinition):TNodeIdent;
begin
	exit(CreateReadNode(ParCre,ParContext));
end;

procedure TRoutineCollection.COmmonsetup;
begin
	inherited Commonsetup;
	iIdentCode :=  IC_RoutineCollection;
end;

procedure TRoutineCollection.InitParts;
begin
	iParts := TRoutineCollectionList.Create;
end;


procedure TRoutineCollection.PrintDefinitionHeader(ParDIs : TDisplay);
begin
	inherited PrintDefinitionHeader(ParDis);
end;


procedure TRoutineCollection.PrintDefinitionType(ParDis : TDisplay);
begin
	ParDis.Write('Routine');
end;

procedure TRoutineCollection.PrintDefinitionBody(ParDis:TDisplay);
begin
	PrintParts(ParDis);
end;


{----( TProcedureObj )--------------------------------------------------}

function TProcedureObj.CreateExitNode(ParCre : TCreator;ParNode : TFormulaNode) : TNodeIdent;
var vlExit : TExitNode;
begin
	if ParNode <> nil then TNDCreator(ParCre).SemError(Err_Cant_Return_Value);
	vlExit := TExitNode.Create(nil,ParNode);
	exit(vlExit)
end;



function  TProcedureObj.CreateNewCB(ParCre : TCreator;const ParName : string) : TRoutine;
begin
	exit(TProcedureObj.Create(ParName));
end;

procedure TProcedureObj.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_Procedure);
end;


procedure  TProcedureObj.CheckIsInheritedComp(ParCre : TCreator;ParCB : TRoutine;ParHasMain : boolean);
begin
	inherited CheckIsInheritedComp(ParCre,ParCb,ParHasMain);
	if (not ParHasMain) and (ParCB <> nil) then begin
		if not (ParCb is TProcedureObj) then begin
			TNDCreator(ParCRe).SemError(Err_Dif_Type_needs_main);
		end;
	end;
end;

procedure TProcedureObj.PrintDefinitionType(ParDis:TDisplay);
begin
	ParDis.Write('Procedure');
end;

{------( TRoutineType )-------------------------------------}


function  TRoutineType.IsExactCompatibleSelf(ParType:TType):boolean;
begin
	IsExactCompatibleSelf := IsDirectCompatibleSelf(parType);
end;

function  TRoutineType.IsDirectcompatibleSelf(ParType:TType):boolean;
var vlProc,vlProc2:TRoutine;
	vlType : TType;
begin
	IsDirectCOmpatibleSelf := false;
	vlProc  := iRoutine;
	if ParType = nil then exit;
	vlType := ParType.GetOrgType;
	if (vlProc <> nil) and (vlType <> nil) and (vlType is TRoutineType) then begin
		if fOfObject <> TRoutineType(vlType).fOfObject then exit;
		vlProc2 := TRoutineType(vlType).fRoutine;
		if (vlProc <> nil) and not(RTM_Isolate in vlProc.fRoutineModes) and (vlProc.GetRoutineOwner <> nil)   then exit(false);
		if (vlProc2 <> nil) and not(RTM_Isolate in vlProc2.fRoutineModes) and (vlProc2.GetRoutineOwner <> nil) then exit(false);
		IsDirectCompatibleSelf := vlProc.IsSameRoutine(vlProc2,[PC_IgnoreName]);
	end;
end;


constructor TRoutineType.Create(ParDone : boolean ; ParProc : TRoutine;ParOfObject : boolean);
var
	vlSize : cardinal;
begin
	vlSize := GetAssemblerInfo.GetSystemSize;
	if ParOfObject then vlSize := vlSize *2;
	SetRoutine(ParDone,ParProc);
	iOfObject := ParOfObject;
	inherited Create(vlSize);
	iPushedFrame := TFrame.Create(true);
	iParamFrame := TFrame.Create(true);
end;



function   TRoutineType.SaveItem(ParStream:TObjectStream):boolean;
begin
	SaveItem :=true;
	if inherited SaveItem(ParStream) then exit;
	if ParStream.WriteBoolean(iOfObject) then exit;
	if iPushedFrame.SaveItem(ParStream) then exit;
	if iParamFrame.SaveItem(ParStream) then exit;
	if iRoutine.SaveItem(parStream) then exit;
	SaveItem := false;
end;

function   TRoutineType.LoadITem(ParStream:TObjectStream):boolean;
var voProc  : TRoutine;
	vlFrame : TFrame;
begin
	LoadITem := true;
	if inherited LoadItem(parStream) then exit;
	if ParStream.ReadBoolean(voOfObject) then exit;
	if CreateObject(ParStream,TStrAbelRoot(vlFrame)) <> STS_OK then exit;
    iPushedFrame := vlFrame;
	if CreateObject(ParStream,TStrAbelRoot(vlFrame)) <> STS_OK then exit;
	iParamFrame := vlFrame;
	if CreateObject(ParStream,TStrAbelRoot(voProc)) <> STS_Ok then exit;
	SetRoutine(true,voProc);
	LoadItem := false;
end;


procedure TRoutineType.Print(ParDis:TDisplay);
begin
	Inherited Print(parDis);
	ParDis.Write('Procedure Type');
	if iOfObject then ParDis.Write(' of object');
    ParDis.nl;
	ParDis.SetLeftMargin(8);
	if iRoutine <> nil then begin
		iRoutine.Print(ParDis);
	end;
	ParDis.SetLeftMargin(-8);
end;


procedure TRoutineType.Clear;
begin
	inherited Clear;
	if (iRoutine <> nil) and (iDispose) then iRoutine.Destroy;
	if iPushedFrame <> nil then iPushedFrame.destroy;
	if iParamFrame <> nil then iParamFrame.Destroy;
end;

procedure TRoutineType.SetRoutine(ParDone:boolean;ParProc:TRoutine);
begin
	if (iRoutine <> nil) and (iDispose)  then iRoutine.Destroy;
	iRoutine := ParProc;
	iDispose   := ParDone;
end;

procedure TRoutineType.RtInitDotFrame(ParNode : TFormulaNode);
begin
	iPushedFrame.AddAddressing(self,self,ParNode,false);
end;

procedure TRoutineType.RtDoneDotFrame;
begin
	iPushedFrame.PopAddressing(self);
end;

procedure TRoutineType.commonsetup;
begin
	inherited commonsetup;
	iPushedFrame := nil;
	iParamFrame := nil;
	iIdentCode  := IC_RoutineType;
end;


{-----( TStartupProc )----------------------------------------}



function  TStartUpProc.LoadItem(ParStr:TObjectStream):boolean;
var vlIsUnitFlag:boolean;
begin
	LoadItem := true;
	if inherited LoadItem(ParStr)  then exit;
	if PArStr.ReadBoolean(vlIsUnitFlag) then exit;
	iIsUnitFlag := (vlIsUnitFlag);
	Loaditem :=false;
end;

function TStartUpProc.SaveItem(ParStr:TObjectStream):boolean;
begin
	SaveItem := true;
	if inherited SaveItem(parStr) then exit;
	if ParStr.WriteBoolean(iIsUnitFlag) then exit;
	SaveItem :=false;
end;


procedure TStartupProc.CreateInitProc(ParCre:TSecCreator);
begin
	inherited CreateInitProc(ParCre);
	if not iIsUnitFlag then iCollection.AddInitCall(ParCre);
end;


constructor TStartUpProc.Create(ParColl : TIdentListCollection;ParUnitflag : boolean);
var vlName : string;
begin
	if ParUnitFlag then begin
		vlName :=  CNF_Unit_Startup;
	end else begin
		vlName := cNF_Startup_name;
	end;
	inherited Create(vlName);
	iCollection := ParCOll;
	iIsUnitflag := ParUnitflag;
end;

procedure TStartupProc.commonsetup;
begin
	inherited commonsetup;
	iIdentCode := IC_StartupProc;
end;

procedure TStartupProc.onMangledName(var ParName : string);
var
	vlName : string;
begin
	GetTextStr(vlName);
	ParName := ParName + vlName;
end;

procedure TStartupProc.PreMangledName(var ParName:string);
begin
	if not iIsUnitFlag then begin
		ParName  := '_';
	end else begin
		inherited PreMangledName(ParName);
	end;
end;


{---( TFunction )------------------------------------------------}
procedure TFunction.CommonSetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_Function);
end;

function  TFunction.CreateNewCB(ParCre : TCreator;const ParName : string) : TRoutine;
var
	vlNewCB : TReturnRoutine;
begin
	vlNewCb := TFunction.Create(ParName);
	TReturnRoutine(vlNewCb).SetFunType(TNDCreator(ParCre),fType);
	exit(vlNewCB);
end;


procedure  TFunction.ValidateCanOverrideByComp(ParCre :TNDCreator;const ParOther : TRoutine);
var vlType1 : TType;
	vlType2 : TTYpe;
begin
	inherited ValidateCanOverrideByComp(ParCre,ParOther);
	if  ParOther is TReturnRoutine then begin
		vlType1 := TReturnRoutine(ParOther).fType;
		vlType2 := fType;
		if (vlType1 <> nil) and (vlType2 <> nil) then begin
			if not vlType2.IsExactSame(vlType1) then begin
				ParCre.ErrorDef(Err_Ovr_Return_Type_Different,self);
			end;
		end;
	end;
end;



{----( TReturnRoutine )---------------------------------------------------}

function  TReturnRoutine.CreateReadNode(ParCre : TCreator;ParOwner : TDefinition) : TFormulaNode;
begin
	exit(TFormulaNode(CreateExecuteNode(ParCre,ParOwner)));
end;


function TReturnRoutine.CreateExitNode(ParCre : TCreator;ParNode : TFormulaNode) : TNodeIdent;
var vlExit : TExitNode;
	vlNode : TFormulaNode;
	vlDef  : TRtlParameter;
	vlVar  : TFormulaNode;
	vlType : TType;
begin
	if ParNode= nil then begin
		TNDCreator(ParCre).SemError(Err_Must_Return_Value);
		vlType := nil;
		vlNode := parNode;
	end else begin
		vlDef := GetRtlParameter;
		vlVar := nil;
		vlType := fType;
		if vlDef <> nil then begin
			vlNode := TNDCreator(ParCre).MakeLoadNodeToDef(ParNode,vlDef,self);
		end else begin
			vlVar := TReturnVarNode.Create(vlType);
			TNDCreator(ParCre).SetNodePos(vlVar);
			vlNode := TNDCreator(ParCre).MakeLoadNode(ParNode,vlVar);
		end;
	end;
	vlExit := TExitNode.Create(vlType,vlNode);
	TNDCreator(ParCre).SetNodePos(vLExit);  {should be outside ,at parser?}
	exit(vlExit);
end;


procedure  TReturnRoutine.CheckIsInheritedComp(ParCre : TCreator;ParCB : TRoutine;ParHasMain : boolean);
var vlType : TType;
begin
	inherited CheckIsInheritedComp(ParCre,ParCb,ParHasMain);
	
	if (ParCB <> nil) and  not(ParHasMain) then begin
		if ParCB is TReturnRoutine then begin
			vlType := TReturnRoutine(ParCb).fType;
			if (fType <> nil) and (vlType <> nil) and ( not fType.IsExactComp(vlType))
			then TNDCreator(ParCre).SemError(Err_Inh_Has_Different_Type);
		end else begin
			TNDCreator(ParCre).SemError(Err_Dif_type_needs_main);
		end;
	end;
end;


procedure   TReturnRoutine.AddAutomaticParameters(ParMother : TDefinition;ParCre:TNDCreator);
begin                                                     {TODO,HACK, until size=3 handeling is better}
	if  (fType <> nil) and ((fType.IsLargeType) or (fType.fSize=3)) and ((iParent = nil) or (iParent.GetRtlParameter = nil)) then begin
		TProcParList(iParts).AddRtlParameter(iParameterFrame,fType,RTM_extended in fRoutineModes);
	end;
	Inherited AddAutomaticParameters(ParMother,ParCre);
end;

procedure TReturnRoutine.CommonSetup;
begin
	inherited CommonSetup;
	iType      := nil;
end;

function  TReturnRoutine.CreateSeperationRoutine(ParCre : TNDCreator): TRoutine;
var
	vlFUn : TFUnction;
	vlName : string;
begin
	GetNewAnonName(vlName);
	vlFun := TFunction.Create(vlName);
	vlFun.SetFunType(ParCre,fType);
	exit(vlFun);
end;


procedure TReturnRoutine.SetFunType(ParCre : TNDCreator;ParType:TType);
begin
	
	if(ParType <> nil) then begin
		if (ParType.fSize = 0) then ParCre.ErrorDef(Err_Cant_Determine_Size,self);
	end;
	iType := ParType;
end;


procedure TReturnRoutine.PrintDefinitionType(ParDis : TDisplay);
begin
	ParDis.Write('function');
end;

procedure TReturnRoutine.PrintDefinitionHeader(ParDis:TDisplay);
begin
	inherited PrintDefinitionHeader(ParDis);
	if fType <> nil then begin
		ParDis.Write('<returntype>');
		PrintIdentName(ParDis,fType);
		ParDis.writenl('</returntype>');
	end;
end;

function TReturnRoutine.SaveItem(ParStream:TObjectStream):boolean;
begin
	SaveItem := true;
	if inherited SaveItem(parStream) then exit;
	if ParStream.WritePi(iType) then exit;
	SaveItem := false;
end;

function TReturnRoutine.LoadItem(ParStream:TObjectStream):boolean;
begin
	LoadItem := true;
	if inherited LoadItem(ParStream) then exit;
	if ParStream.ReadPi(TStrAbelRoot(voType)) then exit;
	LoadItem := false;
end;

function TReturnRoutine.Can(ParCan:TCan_Types):boolean;
var
	vlCan : TCan_Types;
begin
	if Can_Dot in ParCan then begin
		if (iType = nil) or not(iType.Can([Can_Dot])) then exit(false);
	end;
	vlCan := ParCan - [Can_Read , Can_Dot];
	if vlCan <> [] then begin
		exit(inherited Can(vlCan));
	end else begin
		exit(true);
	end;
end;

function TReturnRoutine.IsSameAsForward(ParCB : TDefinition;var ParText : string):boolean;
var
	vlType : TType;
begin
	if not(Inherited IsSameAsForward(ParCb,ParText)) then exit(false);
	vlType := TReturnRoutine(ParCb).fType;
	if (iType = nil) or (vlType = nil) then exit(iType = vlType);
	if not(iType.IsExactSame(vlType)) then begin
		ParText := 'Return type is not the same';
		exit(false);
	end;
	exit(true);
end;


function TReturnRoutine.IsSameRoutine(ParProc:TRoutine;ParType : TParamCompareOptions):boolean;
var
	vlType : TType;
begin
	if inherited IsSameRoutine(ParProc,ParType) then begin
		vlType := TReturnRoutine(ParProc).fType;
		if (iType = nil) or (vlType = nil) then begin
			exit(vlType = iType);
		end else begin
			exit( iType.HasExactSameProp(vlType));
		end;
	end;
	exit(false);
end;



end.
