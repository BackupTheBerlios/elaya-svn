{    Elaya, the compiler for the elaya language;
Copyright (C) 1999-2003  J.v.Iddekinge.
web : www.elaya.org

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICLULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit FormBase;
interface
uses  Largenum,streams,elacons,elatypes,error,Pocobj,MacObj,node,stdobj,asminfo,
compbase,display,ProgUtil,DSbLsDef,ddefinit,confval,useitem;
type
	TFormulaNode=class;
	TTypeClass=class of TType;

	TFormulaDefinition=class(TSubListDef)
	public
		function   CreateReadNode(ParCre : TCreator;ParOwner : TDefinition):TFormulaNode;virtual;
		function   CreateWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue :TFormulaNode):TFormulaNode;virtual;
		function   CreatePropertyWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue :TFormulaNode):TFormulaNode;virtual;
		function   CreateObjectPointerNode(ParCre : TCreator;ParParent :TDefinition):TNodeIdent;override;
		function   CreateValuePointerNode(ParCre : TCreator;ParParent :TDefinition):TFormulaNode;virtual;
		function   CreateWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;virtual;
		function   CreatePropertyWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;virtual;

	end;

	TType=class(TFormulaDefinition)
	private
		voSize     : TSize;
	protected
		property iSize      : TSize  read voSize     write voSize;

		function    IsDirectCompatibleSelf(ParType:TType):boolean;virtual;
		function    isExactCompatibleSelf(ParType:TType):boolean;virtual;
		procedure   COmmonSetup;override;

	public
		property    fSize     : TSize   read voSize;
		function    GetSign:boolean;virtual;
		function    HasExactSameProp(ParType : TType):boolean;virtual;
		function    Can(ParCan:TCan_Types):boolean;override;
		function    CreateReadNode(parCre:TCreator;ParContext : TDefinition):TFormulaNode;override;
		constructor Create(ParSize:TSIze);
		function    IsDominant(ParType:TType):TDomType;virtual;
		procedure   SetSize(ParSize:TSize);
		procedure   PrintDefinitionType(ParDis : TDisplay);override;
		procedure   PrintDefinitionHeader(ParDis : TDisplay);override;
		procedure   PrintDefinitionEnd(ParDIs : TDisplay);override;
		function    SaveItem(ParWrite:TObjectStream):boolean;override;
		function    LoadItem(parWrite:TObjectStream):boolean;override;
		{Compatible tests}
		function    IsExactSame(ParType : TType):boolean;
		function    IsExactComp(parType:TType):boolean;
		function    IsDirectComp(ParType:TType):boolean;
		function    IsCompByIdentCode(ParCode : TIdentCode):boolean;virtual;
		function	CanWriteWith(ParExact : boolean;ParType : TType):boolean;virtual;
		function    CanCastTo(ParType :TType):boolean;virtual;
		{}
		function    IsLargeType:boolean;virtual;
		function    DependsOn(ParType : TType) : boolean; virtual;
		function    IsDefaultType(ParDefaultCode : TDefaultTypeCode;ParSize : TSize;ParSign : boolean):boolean;virtual;
		function    CreateBasedOn(ParCre : TCreator;ParSize : cardinal):TType;virtual;
		function    ValidateConstant(ParValue : TValue):TConstantValidation;virtual;
		function    GetOrgType : TType;virtual;
		function    IsLike(const ParTypeClass :TTypeClass):boolean;
		procedure   InitDotFrame(ParCre :TSecCreator;ParMac : TNodeIdent;ParContext : TDefinition);override;
		procedure   DoneDotFrame;override;
		function   CalculateSize : boolean;virtual;
		function   CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;virtual;
    	{}
		function   IsMinimum(ParValue : TValue):boolean;virtual;{TODO return YES,ERROR,FALSE}
		function   IsMaximum(ParValue : TValue):boolean;virtual;{TODO 2 implement with other types inst of number}
		function   CreateVarOfTypeUse(ParVar : TBaseDefinition): TUseItem;virtual;
	end;
	
	TFormulaList=class(TNodeList)
	private
		voFormType        : TType;
		voOptimizeMethods : TOptimizeMethods;
	protected
		property iOptimizeMethods : TOptimizeMethods read voOptimizeMethods write voOptimizeMethods;
		property iFormType        : TType            read voFormType        write voFormType;
		procedure commonsetup; override;

		procedure ValidateItem(ParCre  : TCreator;ParType : TType;parItem : TFormulaNode);virtual;
	public
		property fOptimizeMethods : TOptimizeMethods read voOptimizeMethods;
		property  fFormType : TType read voFormType;
		
		function  DetermenFormType(ParCre : TCreator;ParPrvType : TType;ParNode :TFormulaNode):TType;virtual;
		procedure  proces(ParCre :TCreator);override;
		function  Can(ParCan:TCan_Types):boolean;virtual;
		function  DetermenComplexity:cardinal;
		procedure OptimizeCpx;
		function  CanOptimizeCpx : boolean;virtual;
		function  Optimize1(ParCre:TCreator):boolean;virtual;
		function  FirstCpxOptimizeNode : TFormulaNode;virtual;
		procedure ValidateAll(ParCre : TCreator;ParType : TType);virtual;
	end;
	
	
	
	TFormulaNode=class(TNodeIdent)
	private
		voContext    : TDefinition;
		voComplexity : cardinal;
      voRecord     : TFormulaNode;
	protected
		property iContext    : TDefinition read voContext     write voContext;
		property iComplexity : cardinal    read voComplexity  write voComplexity;
      property iRecord     : TFormulaNode read voRecord write voRecord;
		procedure   Commonsetup;override;
		procedure   Clear;override;
		function    DoCreateMac(ParOption : TMacCreateOption;ParCre : TSecCreator):TMacBase;virtual;
	public
		property    fContext    : TDefinition read voContext    write voContext;
		property    fComplexity : cardinal    read voComplexity;
      property    fRecord     : TFormulaNode read voRecord write voRecord;

		{is same}
		function    IsCompByIdentCode(ParCode : TIdentCode):boolean;
		function    IsCompWithType(ParType :TType):boolean;virtual;
		function    IsDirectComp(ParNode:TFormulaNode):boolean;virtual;
		function	CanWriteWith(ParExact : boolean;ParNode : TFormulaNode):boolean;
		function	CanWriteWith(ParExact : boolean;ParType : TTYpe):boolean;
		function	CanWriteTo(ParExact : boolean;ParTYpe : TType):boolean;virtual;
		
		function    CAN(ParCan:TCan_Types):boolean;virtual;
		function    GetType:TType;virtual;
		function    GetOrgType:TType;virtual;
		function    GetSize:TSize;
		function    IsDominant(ParForm:TFormulaNode):TDomType;virtual;
		procedure   InitParts;override;
		function    GetTypeDefault:TDefaultTypeCode;
		function    IsConstant : boolean;virtual;
		function    GetValue : TValue;virtual;
		function    CreateSec(ParCre:TSecCreator):boolean;override;
		function    DoCreateSec(ParCre:TSecCreator):boolean;virtual;
		function    CreateMac(ParOption : TMacCreateOption;ParCre : TSecCreator):TMacBase;override;
		procedure   GetTypeName(var ParName : string);
		function    GetTypeSIze : TSize;
		function    GetTypeSign : boolean;
		procedure   ValidateConstant(ParCre :TCreator;ParProc : TConstantValidationProc);override;
		function    CanCastTo(ParType : TType):boolean;
		function    ConvertNodeType(ParType : TType;ParCre : TCreator;var Parnode : TFormulaNode):boolean;virtual;
		function    IsLikeType(const ParTypeClass : TTypeClass) : boolean;
		procedure   DetermenComplexity;
		procedure   OptimizeCpx;
		procedure  Optimize(ParCre : TCreator);override;
		function   Optimize1(ParCre : TCreator):boolean;virtual;
		function   OptimizeForm(ParCre :TCreator;var ParRepl : TFormulaNode):boolean;
		function   IsOptUnsave:boolean;virtual;
		procedure InitDotFrame(ParCre : TSecCreator);virtual;
		procedure DoneDotFrame;virtual;
		function CreateObjectPointerOfNode(ParCre : TCreator) : TFormulaNode;virtual;
		procedure ValidateAfter(ParCre : TCreator);override;
		function   IsMinimum(ParValue : TValue):boolean;
		function   IsMaximum(ParValue : TValue):boolean;
		function   GetFirstSubNode : TFormulaNode;
		function   RecordReadCheck : boolean;
		procedure Proces(ParCre :TCreator);override;
    	function CanSec:boolean;virtual;
  		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);override;
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);virtual;

		function  GetDefinition : TDefinition;virtual;
end;

	TErrorFormulaNode=class(TFormulaNode)
		function    CAN(ParCan:TCan_Types):boolean;override;
	end;

	TFailedNode=class(TFormulaNode);
	TValueNode=class(TFormulaNode);
		
		
		
	implementation
	
	
	uses ndcreat,execobj;

	{----(TErrorFormulaNode )---}

	function   TErrorFormulaNode.CAN(ParCan:TCan_Types):boolean;
	begin
		exit(false);
	end;

	
	{---( TFormulaDefinition )-----------------------------------------}


	function   TformulaDefinition.CreateWriteDotNode(ParCre : TCreator;ParLeft,ParSource  : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;
	var
		vlField : TFormulaNode;
		vlDot   : TFormulaNode;
	begin
		vlField := CreateReadNode(ParCre,ParOwner);
		vlField.fRecord := ParLeft;
		vlDot := TNDCreator(ParCre).MakeLoadNode(ParSource,vlField);
		exit(vlDot);
	end;

	function   TFormulaDefinition.CreatePropertyWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;
	begin
		exit(CreateWriteDotNode(ParCre,ParLeft,ParSource,ParOwner));
	end;

	function   TFormulaDefinition.CreateReadNode(ParCre : TCreator;ParOwner : TDefinition):TFormulaNode;
	begin
			exit(TErrorFormulaNode.Create);
	end;

	function   TFormulaDefinition.CreateWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue :TFormulaNode):TFormulaNode;
	begin
		exit(TNDCreator(ParCre).MakeLoadNodeToDef(ParValue,self,ParOwner));{TODO:vervangen door lokaal}
	end;

	function TFormulaDefinition.CreatePropertyWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue :TFormulaNode):TFormulaNode;
	begin
		exit(CreateWriteNode(ParCre,ParOwner,ParValue));
	end;

	function   TFormulaDefinition.CreateObjectPointerNode(ParCre : TCreator;ParParent :TDefinition):TNodeIdent;
	var
		vlByPtr : TNodeIdent;
	begin
		vlByPtr := CreateReadNode(ParCre,ParParent).CreateObjectPointerOfNode(ParCre);
		exit(vlByPtr);
	end;

	function   TFormulaDefinition.CreateValuePointerNode(ParCre : TCreator;ParParent :TDefinition):TFormulaNode;
	var
		vlByPtr : TFormulaNode;
	begin
		vlByPtr := TValuePointerNode.Create;
		vlByPtr.AddNode(CreateReadNode(ParCre,ParParent));
		exit(vlByPtr);
	end;
	
	{--------(TFormulaNode )--------------------------------------}

	function  TFormulaNode.GetDefinition : TDefinition;
	begin
		exit(nil);
	end;

	procedure TFormulaNode.ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
	var
		vlList : TUseList;
		vlUse  : TUseItem;
		vlDef  : TDefinition;
	begin
			vlList := ParUseList;
  			if iRecord <> nil then begin
				vlDef := iRecord.GetDefinition;
				if vlDef = nil then exit;
				vlUse := ParUseList.GetOrAddUseItem(vlDef);
				if vlUse = nil then fatal(	FAT_no_du_list_from_context,'');
				vlList := vlUse.GetSubList;
				if vlList = nil then vlList := ParUseList;{TODO hack because of strings}
			end;
		   ValidateFormulaDefinitionUse(ParCre,ParMode,vlList);
	end;

	procedure TFormulaNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
	begin
			inherited ValidateDefinitionUse(ParCre,ParMode,ParUseList);
	end;

	procedure TFormulaNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
	begin
		inherited ValidatePre(ParCre,ParIsSec);
		if(ParIsSec) and not(CanSec) then TNDCreator(ParCre).AddNodeError(self,ERR_Cant_Execute,classname);{TODO:Something better}
   end;

   function TFormulaNode.CanSec:boolean;
   begin
		exit(can([Can_Execute]));
	end;

	procedure TFormulaNode.Proces(ParCre :TCreator);
	begin
		inherited Proces(ParCre);
		if iRecord<> nil then iRecord.proces(ParCre);
	end;


	procedure TFormulaNode.Clear;
	begin
		inherited Clear;
		if iRecord <> nil then iRecord.Destroy;
	end;

   function TFormulaNode.RecordReadCheck : boolean;
	begin
		if iRecord <> nil then begin
			if not iRecord.Can([Can_Read]) then exit(true);
		end;
		exit(false);
	end;

	function TFormulaNode.GetFirstSubNode : TFormulaNode;
	begin
		exit(TFormulaNode(fParts.fStart));
	end;

	function TFormulaNode.IsMinimum(ParValue : TValue):boolean;{TODO return ERROR when type =nil}
	var
		vlType : TType;
	begin
		vlType := GetType;
		if vlType <> nil then begin
			exit(vlType.IsMinimum(ParValue));
		end;
		exit(false);
	end;

	function TFormulaNode.IsMaximum(ParValue : TValue):boolean;
	var
		vlType : TType;
	begin
		vlType := GetType;
		if vlType <> nil then begin
			exit(vlType.IsMaximum(ParValue));
		end;
		exit(false);
	end;

	function  TFormulaNode.CreateObjectPointerOfNode(ParCre : TCreator) : TFormulaNode;
	begin
		if not  Can([CAN_Pointer]) then TNDCreator(ParCre).AddNodeError(self,Err_Cant_Get_Expr_Pointer,'');
		exit(TObjectPointerNode.Create(self,nil));
	end;
	
	procedure TFormulaNode.DoneDotFrame;
	var
		vlType : TType;
	begin
		vlType := GetType;
      if iRecord <> nil then iRecord.DoneDotFrame;
		if(vlType <> nil) then vlType.DoneDotFrame;
	end;
	
	
	procedure TFormulaNode.InitDotFrame(ParCre : TSecCreator);
	var
		vlType : TType;
	begin
		vlType := GetType;
		if (vlType <> nil) then vlType.InitDotFrame(ParCre,self,fContext);
      if iRecord <> nil then iRecord.InitDotFrame(ParCre);
	end;
	
	function  TFormulaNode.IsOptUnsave:boolean;
	begin
		exit(false);
	end;
	
	procedure TFormulaNode.OptimizeCpx;
	begin
		DetermenComplexity;
		if om_complexity in TFormulaList(iParts).fOptimizeMethods then TFormulaList(iParts).OptimizeCpx;
	end;
	
	function TFormulaNode.Optimize1(ParCre : TCreator):boolean;
	var vlOpt : boolean;
	begin
		vlOpt := false;
		while TFormulaList(iParts).Optimize1(ParCre) do vlOpt := true;
		exit(vlOpt);
	end;
	
	procedure  TFormulaNode.Optimize(ParCre : TCreator);
	begin
		Optimize1(ParCre);
		OptimizeCpx;
	end;
	
	
	function TFormulaNode.OptimizeForm(ParCre : TCreator;var ParRepl : TFormulaNode):boolean;
	var
		vlOpt : boolean;
	begin
		vlOpt := Optimize1(ParCre);
		ParRepl := TFormulaNode(GetReplace(parCre));
		if (ParRepl <> Nil) then begin
			ParRepl.SetPosToNode(self);
			vlOpt := true;
		end else begin
			OptimizeCpx;
		end;
		exit(vlOpt);
	end;
	
	procedure TFormulaNode.Commonsetup;
	begin
		inherited Commonsetup;
		iComplexity := 0;
		iContext    := nil;
      iRecord     := nil;
	end;
	
	function  TFormulaNode.IsLikeType(const ParTypeClass : TTypeClass) : boolean;
	var
		vlType : TType;
	begin
		vlType := GetType;
		if (vlType <> nil) then begin
			exit(vlType.IsLike(ParTypeClass));
		end else begin
			exit(false);
		end;
	end;
	
	
	function  TFormulaNode.ConvertNodeType(ParType : TType;ParCre : TCreator;var ParNode : TFormulaNode) : boolean;
	begin
		ParNode := nil;
		exit(false);
	end;
	
	function  TFormulaNode.CanCastTo(ParType : TType):boolean;
	begin
		if GetType <>nil then begin
			exit(GetType.CanCastTo(ParType));
		end else begin
			exit(false);
		end;
	end;
	
	procedure TFormulaNode.ValidateConstant(ParCre :TCreator;ParProc : TConstantValidationProc);
	var vlValue : TValue;
	begin
		vlValue := GetValue;
		if vlValue <> nil then begin
			case ParProc(vlValue) of
				Val_Invalid        :  TNDCreator(ParCre).AddNodeError(self,Err_Invalid_Value,classname);
				Val_Out_Of_Range   : TNDCreator(ParCre).AddNodeError(self,Err_Expr_Is_Out_Of_Range,'');
			end;
			vlValue.Destroy;
		end;
	end;



function TFormulaNode.GetTypeSign : boolean;
begin
	if GetType <> nil then begin
		exit(GetType.GetSign);
	end else begin
		exit(false);
	end;
end;

function    TFormulaNode.GetTypeSIze : TSize;
begin
	if GetType<> nil then begin
		exit(GetType.fSize);
	end else begin
		exit(0);
	end;
end;


procedure  TFormulaNode.GetTypeName(var  ParName : string);
begin
	if GetType = nil then begin
		ParName := 'Empty';
	end else begin
		ParName := GetType.GetErrorName;
	end;
end;

function    TFormulaNode.CreateMac(ParOption : TMacCreateOption;ParCre : TSecCreator):TMacBase;
var
	vlMac : TMacBase;
begin
	if (iRecord <> nil) and (ParOption <> MCO_Size) then	iRecord.InitDotFrame(ParCre);
	vlMac := DoCreateMac(ParOption,ParCre);
	if (iRecord <> nil) and (ParOption <> MCO_Size) then iRecord.DoneDotFrame;
	exit(vlMac);
end;

function    TFormulaNode.DoCreateMac(ParOption : TMacCreateOption;ParCre : TSecCreator):TMacBase;
var
	vlLi : TNumber;
	vlType : TTYpe;
begin
	if(ParOption =MCO_Size) then begin
		vlType := GetType;
		if vlType = nil then runerror(1);
		LoadLong(vlLi,vlType.fSize);
		exit(ParCre.CreateNumberMac(0,false,vlLi));
	end else begin
		exit(inherited CreateMac(ParOption,ParCre));
	end;
end;


function    TFOrmulaNode.GetSize:TSize;
begin
	if GetType <> nil then exit(GetType.fSize)
	else exit(0);
end;

function    TFormulaNode.GetTypeDefault:TDefaultTypeCode;
var vlType:TType;
begin
	GetTypeDefault := DT_Nothing;
	vlType := GetOrgType;
	if vlType<> nil then GetTypeDefault := vlType.fDefault;
end;


function TFormulaNode.CanWriteTo(ParExact : boolean;ParTYpe : TType):boolean;
var
	vlType : TType;
begin
	if ParType <> nil then begin
		vlType := GetOrgType;
        if vlType <> nil then begin
			exit(ParType.CanWriteWith(ParExact,vlType));
		end;
	end;
	exit(false);
end;

function TFormulaNode.CanWriteWith(ParExact : boolean;ParNode : TFormulaNode):boolean;
begin
	exit(CanWriteWith(ParExact,ParNode.GetType));
end;


function TFormulaNode.CanWriteWith(ParExact : boolean;ParType : TTYpe):boolean;
var
	vlType1 : TType;
begin
	vlType1 := GetOrgType;
	if(vlType1 = nil) then exit(false);
	exit(vlType1.CanWriteWith(ParExact,ParType));
end;


function    TFormulaNode.IsCompByIdentCode(ParCode : TIdentCode):boolean;
begin
	IsCompByIdentcode := false;
	if GetType <> nil then 	IsCompByIdentCode := GetType.IsCompByIdentCode(ParCode);
end;


procedure TFormulaNode.InitParts;
begin
	iParts := TFormulaList.Create;
end;


function TFormulaNode.GetOrgType:TType;
var vlType:TType;
begin
	vlType := GetType;
	if vlType <> nil then vlType :=vlType.GetOrgType;
	exit(vlType);
end;


function TFormulaNode.GetType:TType;
begin
	exit(nil);
end;

function TFormulaNode.Can(ParCan:TCan_Types):boolean;
begin
	if GetType <> nil then ParCan := ParCan - [Can_Size];
	exit(ParCan - [Can_read]=[]);
end;


function TFormulaNode.IsDominant(ParForm:TFormulaNode):TDomType;
var vlType:TType;
	vlDominant:TDomType;
begin
	if Parform = nil then begin
		IsDominant := DOM_Yes;
		exit;
	end;
	vlType := ParForm.GetType;
	vlDominant := DOM_Unkown;
	if (GetType <> nil) and (vlType<> nil) then vlDominant := GetType.IsDominant(vlType);
	IsDominant := vlDominant;
end;

function  TFormulaNode.IsCompWithType(ParType :TType):boolean;
begin
	if (ParType = Nil) or (GetType = nil) then exit(false);
	exit(GetType.IsDirectComp(ParType));
end;

function  TFormulaNode.IsDirectComp(ParNode:TFormulaNode):boolean;
begin
	IsDirectComp := false;
	if ParNode.GetType <> nil then IsDirectComp := IsCompWithType(ParNode.GetType);
end;

function TFormulaNode.CreateSec(ParCre:TSecCreator):boolean;
var
	vlFlag : boolean;
begin
	if iRecord <> nil then iRecord.InitDotFrame(ParCre);
	vlFlag := DoCreateSec(ParCre);
	if iRecord <> nil then iRecord.DoneDotFrame;
	exit(vlFlag);
end;


function TFormulaNode.DOCreateSec(ParCre:TSecCreator):boolean;
var vlMac,vlMac2:TMacBase;
	vlSec  : TCompFor;
	vlOut  : TMacBase;
	vlJmp  : TCondJumpPoc;
	vlJmp2 : TJumpPoc;
	vlLi   : TLargeNumber;
begin
	vlmac  := CreateMac(MCO_Result,ParCre);
	LoadLong(vlLi,0);
	vlMac2 := ParCre.CreateNumberMac(1,false,vlLi);
	vlSec  := TCompFor.Create(IC_Eq);
	vlSec.Setvar(1,vlMac);
	vlSec.SetVar(2,vlMAc2);
	vlSec.CalcOutputMac(ParCre);
	ParCre.addSec(vLSec);
	vlOut :=vlSec.GetVar(0);
	vlJmp := TCondJumpPoc.Create(true,vlOut,ParCre.fLabelFalse);
	vlJmp2 := TJumpPoc.Create(ParCre.fLabelTrue);
	ParCre.AddSec(vlJmp);
	ParCre.AddSec(vlJmp2);
	exit(false);
end;


function  TFormulaNode.IsConstant : boolean;
begin
	exit(false);
end;

function  TFormulaNode.GetValue : TValue;
begin
	exit(nil);
end;

procedure TFormulaNode.DetermenComplexity;
var vlCpx  : cardinal;
begin
	vlCpx := TFormulaList(iParts).DetermenComplexity;
	if vlCpx > iComplexity then iComplexity := vlCpx;
end;

procedure TFormulaNode.ValidateAfter(ParCre : TCreator);
begin
	TFormulaList(iParts).ValidateAll(ParCre,GetType);
end;

{----( TType )---------------------------------------------------}

function TType.CreateVarOfTypeUse(ParVar : TBaseDefinition): TUseItem;
begin
	exit(TDefinitionUseItem.Create(ParVar));
end;


function TType.IsMinimum(ParValue : TValue):boolean;
begin
	exit(false);
end;

function TType.IsMaximum(ParValue : TValue):boolean;
begin
	exit(false);
end;


function  TType.CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;
var
	vlMac : TMacBase;
	vlNum : TNumber;
begin
	vlMac := nil;
	if ParOption = MCO_Size then begin
		LoadLong(vlNum,fSIze);
		vlMac := ParCre.CreateNumberMac(0,false,vlNum);
	end;
	exit(vlMac);
end;


function  TType.CanWriteWith(ParExact : boolean;ParType:TType):boolean;
begin
	if ParExact then begin
		exit(IsExactComp(ParTYpe));
	end else begin
		exit(IsDirectComp(ParType));
	end;
end;

procedure TType.InitDotFrame(ParCre : TSecCreator;ParMac : TNodeIdent;ParContext :TDefinition);
begin
end;

procedure TTYpe.DoneDotFrame;
begin
end;



function TType.IsLike(const ParTypeClass :TTypeClass):boolean;
var vlType: TType;
begin
	vlType := GetOrgType;
	if (vlType <> nil) then begin
		exit(vlType is ParTypeClass);
	end else begin
		exit(false);
	end;
end;

function TType.CalculateSize:boolean;
begin
	exit(false);
end;


function  TType.CanCastTo(ParType :TType):boolean;
begin
	if ParType= nil then exit(false);
	if (ParType.fSize > fSize)  then begin
		if  (ParType.fSize > GetAssemblerInfo.GetSystemSize) then exit(false);
		exit(IsDirectComp(ParType));
	end else begin
		exit(true);
	end;
end;



function  TType.ValidateConstant(ParValue : TValue):TConstantValidation;
begin
	exit(val_Ok);
end;

function  TType.CreateBasedOn(ParCre : TCreator;ParSize : cardinal):TType;
begin
	TNDCreator(ParCre).SemError(Err_Cant_Base_Type_On_This);
	exit(nil);
end;

function TType.IsDefaultType(ParDefaultCode : TDefaultTypeCode;ParSize : TSize;ParSign : boolean):boolean;
begin
	exit((fDefault=ParDefaultCode) and ((ParSize = Size_DontCare) or (fSize = ParSize)));
end;

function TType.DependsOn(ParType : TType) : boolean;
begin
	exit(false);
end;

function TType.IsLargeType:boolean;
begin
	IsLargeType := fSize > GetAssemblerInfo.GetSystemSize;
end;

function TType.IsCompByIdentCode(ParCode : TIdentCode):boolean;
begin
	IsCompByIdentCode:= fIdentCode = ParCode;
end;


function    TType.CreateReadNode(parCre:TCreator;ParContext : TDefinition):TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	vlNode := TTypeNode.Create(self);
	vlNode.fContext := ParContext;
	exit(vlNode);
end;


function TType.GetOrgType:TType;
begin
	exit(self);
end;

function    TType.IsExactComp(parType:TType):boolean;
begin
	if (ParType <> nil) then begin
		if ParType.IsExactCompatibleSelf(self) then exit(true);
	end;
	exit(IsExactCompatibleSelf(ParType));
end;

function    TType.IsDirectComp(ParType:TType):boolean;
begin
	if (parType <> nil) then begin
		if ParType.IsDirectCompatibleSelf(self) then exit(true);
	end;
	exit(IsDirectCompatibleSelf(ParType));
end;

function    TType.IsDirectCompatibleSelf(ParType:TType):boolean;
var vlType:TType;
begin
	IsDirectcompatibleSelf :=false;
	If PartYpe = nil then exit;
	vlType := ParType.GetOrgType;
	IsDirectCompatibleSelf := IsSameIdentCode(vlType);
end;


procedure   TType.SetSize(PArSize:TSize);
begin
	iSize := ParSize;
end;

constructor TType.Create(PArSize:TSize);
begin
	inherited Create;
	SetSize(ParSize);
end;

function TType.IsDominant(ParType:TType):TDomType;
begin
	IsDominant := DOM_Not;
	if not IsSameIdentCode(ParType) then IsDominant := DOM_Unkown;
end;

function TType.GetSign:boolean;
begin
	GetSign := false;
end;

function TType.Can(ParCan:TCan_Types):boolean;
begin
	ParCan -= [Can_Type ,Can_Size];
	exit(inherited Can(ParCan));
end;
	
procedure TType.COmmonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (ic_abstract);
	SetDefault(DT_Nothing);
end;

procedure TType.PrintDefinitionType(ParDis:TDisplay);
begin
	ParDis.Write('Type ');
end;

procedure TType.PrintDefinitionHeader(ParDis:TDisplay);
begin
	inherited PrintDefinitionHeader(ParDis);
	pARdIS.WRITE(' = ');
end;

procedure TType.PrintDefinitionEnd(ParDis:TDisplay);
var vldef : TDefaultTypeCode;
begin
	vlDef :=fDefault;
	if vlDef <> DT_Nothing then ParDis.Print([' default ',DT_Description[vlDef]]);
end;

function TType.SaveItem(ParWrite:TObjectStream):boolean;
begin
	SaveITem := true;
	if inherited SaveItem(ParWrite)      then exit;
	if ParWrite.WriteLong(fSize)	     then exit;
	if ParWrite.Writelong(cardinal(fDefault))   then exit;
	SaveItem := false;
end;


function TType.LoadItem(parWrite:TObjectStream):boolean;
var vlDefault : TDefaultTypeCode;
	vlSize    : TSize;
begin
	LoadItem := true;
	if inherited LoadItem(parWrite)    then exit;
	if ParWrite.Readlong(vlSize)       then exit;
	if ParWrite.Readlong(cardinal(vlDefault)) then exit;
	SetSize(vlSize);
	SetDefault(vlDefault);
	LoadItem  := false;
end;

function   TType.IsExactSame(ParType : TType):boolean;
begin
	if (ParType = Self) then exit(true);
	if ParType <> nil then begin
		if (DM_Anonymous in fDefinitionModes) and(DM_Anonymous in ParType.fDefinitionModes) then begin
			if HasExactSameProp(ParType) then exit(true);
		end;
	end;
	exit(false);
end;

function    TType.HasExactSameProp(ParType : TType):boolean;
begin
	exit(IsExactCompatibleSelf(ParType));
end;


function    TType.isExactCompatibleSelf(ParType:TType):boolean;
begin
	IsExactCompatibleSelf := IsDirectComp(ParType) and (fSize = ParType.fSize);
end;


{---( TFormulaList )----------------------------------------------}
function TFormulaList.Optimize1(ParCre:TCreator):boolean;
var vlCurrent : TFormulaNode;
	vlOpt     : boolean;
	vlRepl    : TFormulaNode;
	vlNxt     : TFormulaNode;
begin
	vlCurrent := TFormulaNode(fStart);
	vlOpt := false;
	while vlCurrent <> nil do begin
		vlNxt := TFormulaNode(vlCurrent.fNxt);
		if not vlCurrent.fCanDelete then begin
			vlRepl := TFormulaNode(vlCurrent.GetReplace(ParCre));
			if vlRepl <> nil then begin
				vlCUrrent.SetCanDelete(true);
				AddNodeAt(vlCurrent,vlRepl);
				vlOpt := true;
			end;
		end;
		vlCurrent := vlNxt;
	end;
	vlCurrent := TFormulaNode(fStart);
	while vlCurrent <> nil do begin
		if not(vlCurrent).fCanDelete then begin
			if vlCurrent.Optimize1(ParCre) then vlOpt := true;
		end;
		vlCurrent := TFormulaNode(vlCurrent.fNxt);
	end;
	if DeleteIfCan(ParCre) then vlOpt := true;
	Optimize1 := vlOpt;
end;


function  TFormulaList.CanOptimizeCpx : boolean;
begin
	exit(false);
end;

function TFormulaList.DetermenComplexity:cardinal;
var
	vlCurrent : TFormulaNode;
	vlCpx	  : cardinal;
	vlMustOpt : boolean;
	vlFirst   : boolean;
begin
	vlCurrent := TFormulaNode(fStart);
	vlFirst   := true;
	vlCpx     := 0;
	vlMustOpt := false;
	while vlCurrent <> nil do begin
		vlCurrent.DetermenComplexity;
		if vlCurrent.fComplexity > vlCpx then begin
			if not vlFirst then begin
				vlMustOpt := true;
			end else begin
				vlFirst := false;
			end;
			vlCpx := vlCurrent.fComplexity;
		end;
		vlCurrent := TFormulaNode(vlCUrrent.fNxt);
	end;
	if vlMustOpt then iOptimizeMethods := iOptimizeMethods + [OM_Complexity];
	exit(vlCpx);
end;

function  TFormulaList.FirstCpxOptimizeNode : TFormulaNode;
begin
	exit(TFormulaNode(fStart));
end;

procedure TFormulaList.OptimizeCpx;
var
	vlMax     : TFormulaNode;
	vlCurrent : TFormulaNode;
	vlAt      : TFormulaNode;
begin
	vlMax := FirstCpxOptimizeNode;
	vlCurrent := vlMax;
	while(vlCurrent <> nil) do begin
		vlCurrent.OptimizeCpx;
		vlCurrent := TFormulaNode(vlCurrent.fNxt);
	end;
	
	if not CanOptimizeCpx then exit;
	vlAt := nil;
	if vlMax <> nil then vlAt := TFormulaNode(vlMax.fPrv);
	
	while vlMax <> nil do begin
		vlCurrent := TFormulaNode(vlMax.fNxt);
		while vlCurrent <> nil do begin
			if vlCurrent.fComplexity > vlMax.fComplexity then vlMax := vlCurrent;
			vlCurrent := TFormulaNode(vlCurrent.fNxt);
		end;
		CutOut(vlMax);
		InsertAt(vlAt,vlMax);
		vlAt := vlMax;
		vlMax := TFormulaNode(vlMax.fNxt);
	end;
end;


procedure TFormulaList.commonsetup;
begin
	inherited commonsetup;
	iFormType        := nil;
	iOptimizeMethods := [];
end;

function TFormulaList.DetermenFormType(ParCre :TCreator;ParPrvType : TType;ParNode :TFormulaNode):TType;
var vlType    : TType;
	vlRetType : TType;
begin
	vlRetType := ParPrvType;
	if ParNode <>nil then begin
		vlType := ParNode.GetType;
		if vlType <> nil then begin
			if vlRetType <> nil then begin
				if vlRetType.IsDominant(vlType) = DOM_Yes then vlRetType := vlType;
			end else begin
				vlRetType := vlType;
			end;
		end;
	end;
	exit(vlRetType);
end;


procedure  TFormulaList.proces(ParCre : TCreator);
var
	vlNode : TFormulaNode;
begin
	inherited Proces(ParCre);
    vlNode := TFormulaNode(fStart);
	while vlNode <> nil do begin
		if vlNode is TFormulaNode then iFormType := DetermenFormType(ParCre,iFormType,vlNode);
		vlNode := TFormulaNode(vlNode.fNxt);
	end;
end;

function TFormulaList.Can(ParCan:TCan_Types):boolean;
var
	vlCurrent:TFormulaNode;
begin
	vlcurrent := TFormulaNode(fStart);
	while (vlCurrent <> nil) and (vlCurrent.Can(ParCAN)) do vlCurrent := TFormulaNode(vlcurrent.fNxt);
	Can := (vlCurrent = nil);
end;


procedure TFormulaList.ValidateAll(ParCre : TCreator;ParType : TType);
var
	vlCurrent : TFormulaNode;
begin
	vlCurrent := TFormulanode(fStart);
	while vlCurrent <> nil do begin
		ValidateItem(ParCre,ParType,vlCurrent);
		vlCurrent.ValidateAfter(ParCre);
		vlCurrent := TFormulaNode(vlCUrrent.fNxt);
	end;
end;


procedure TFormulaList.ValidateItem(ParCre  : TCreator;ParType : TType;parItem : TFormulaNode);
begin
end;

end.
