
{
Elaya, the compiler for the elaya language
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

unit ExecObj;
interface
uses  classes,largenum,ddefinit,procs,nconvert,types,error,elacons,progutil,vars, display,compbase,
	elatypes,pocobj,macobj,node,formbase,varbase,ndcreat,stdobj,asminfo,confval,varuse;
	
type
		
	TDirectValueNode=class(TFormulaNode){TODO name is wrong}
	private
		voType : TType;
	protected
		property iType : TType read voType write voType;
	public
		property fType : TType read voType;
		function GetType : TType;override;
		constructor Create(ParType :TType);
	end;
	
	TReturnVarNode=class(TDirectValueNode)
	protected
		procedure Commonsetup;override;
		function DoCreateMac(ParOption : TMacCreateOption;ParCre : TSecCreator): TMacBase;override;
	public
		function  Can(ParCan  : TCan_Types) : boolean;override;
		procedure PrintNode(ParDis:TDisplay);override;
	end;
	
	TConstantValueNode=class(TDirectValueNode)
	private
		voValue : TValue;
		property  iValue : TValue read voValue write voValue;
	protected
		procedure   Commonsetup;override;
		procedure   Clear;override;

		function    DoCreateMac(ParOption : TMacCreateOption;ParCre : TSecCreator):TMacBase;override;

	public
		function    GetValue : TValue;override;
		function    IsConstant : boolean;override;
		procedure   PrintNode(ParDisplay : TDisplay);override;
		constructor Create(ParValue : TValue;ParType : TType);
		function    ConvertNodeType(ParType : TType;ParCre : TCreator;var ParNode:TFormulaNode):boolean;override;
		function    IsCompWithType(ParType :TType):boolean;override;
		function    Can(ParCan:TCan_Types):boolean;override;
	end;
	
	
	TPointerNode=class(TConstantNode)
	protected
		procedure  commonsetup;override;

	public
		constructor Create(parNum:TPointerCons);
		procedure  PrintNode(ParDis:TDisplay);override;
		destructor destroy;override;
	end;
	
	TOperatorNode=class(TFormulaNode)
	protected
		function CheckCOnvertNode(ParCre : TCreator;ParType :TType;var ParNode : TFormulaNode):boolean;
		function CheckCOnvertNode2(ParCre : TCreator;ParType :TType;var ParNode : TFormulaNode):boolean;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public
		function  Can(ParCan:TCan_Types):boolean;override;
		procedure InitParts;override;
		procedure GetOperStr(var ParOper:String);virtual;
		procedure PrintNode(ParDis:TDisplay);override;
		function  GetType:TType;override;
		procedure Get2SubNode(var ParFirst,ParSecond:TFormulaNode);
		function  CheckConvertTest(ParType1,ParType2 : TType) : boolean;virtual;
		function  DefaultNodeCheck : boolean;virtual;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList); override;
	end;
	
	TArrayIndexNode=class(TOperatorNode)
	private
		voType:TType;
		voBase:TFormulaNode;
		property iType : TType read voType write voType;
		property iBase : TFormulaNode read voBase write voBase;
	protected
		procedure commonsetup;override;
		procedure Clear;override;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public
		function  Can(ParCan:TCan_Types):boolean;override;
		procedure proces(ParCre:TCreator);override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure PrintNode(ParDis:TDisplay);override;
		function  GetType:TType;override;
		procedure SetBase(ParCre : TNDCreator;ParNode : TFormulaNode);
		procedure ValidateAfter(ParCre : TCreator);override;
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList); override;
	end;
	
	TByPtrNode=class(TOperatorNode)
	private
		voExtraOffset :TOffset;
		property iExtraOffset : TOffset read voExtraOffset write voExtraOffset;
	protected
		procedure commonsetup;override;

	public
		property fExtraOffset : TOffset read voExtraOffset write voExtraOffset;
		
		
		function  Can(ParCan:TCan_Types):boolean;override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		function  GetType:TType;override;
		procedure GetOperStr(var ParOper:string);override;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		function  IsOptUnsave:boolean;override;
	end;
	
	
	
	TBoolOperNode=class(TOperatorNode)
	private
		voBooleanType : TType;
	protected
		property iBooleanType : TType read voBooleanType write voBooleanType;
	public
		constructor Create(ParBooleanType:TType);
		function    GetType:TType;override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;

	end;
	
	TCompNode=class(TBoolOperNode)
	private
		voCompCode : TIdentCode;
		property iCompCode : TIdentCode read voCompCode write voCompCode;

	protected
		procedure   Commonsetup;override;

	public
		function	CreatePartSec(ParCre : TSecCreator;ParSecond : boolean): boolean;
		function    CreateSec(ParCre:TSecCreator):boolean;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		constructor Create(ParCode : TIdentCode ;ParBooleantype:TType);
		procedure   GetOperStr(var parOper:String);override;
		procedure   ValidateAfter(ParCre : TCreator);override;
		procedure   InitParts;override;
		function    CheckConvertTest(ParType1,ParType2 : TType) : boolean;override;
		procedure   ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
	end;

	TBetweenNode=class(TBoolOperNode)
	protected
		procedure Commonsetup;override;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public
		function  CreateSec(PArCre:TSecCreator):boolean;override;
		procedure PrintNode(ParDis:TDisplay);override;
	end;
	
	
	TDualOperNode=class(TOperatorNode)
	public
		function  GetReplace(ParCre:TCreator):TNodeIdent;override;
	end;
	
	TOrdDualOperNode=class(TDualOperNode)
	public
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
	end;
	
	TMulNode=class(TOrdDualOperNode)
	protected
		procedure   commonsetup;override;

	public
		procedure   InitParts;override;
		procedure   GetOperStr(var ParOper:string);override;
	end;
	
	TShrNode=class(TOrdDualOperNode)
	protected
		procedure   commonsetup;override;

	public
		procedure   InitParts;override;
		procedure   GetOperStr(var ParOper:string);override;
	end;

	TShlNode=class(TOrdDualOperNode)
	protected
		procedure   commonsetup;override;

	public
		procedure   InitParts;override;
		procedure   GetOperStr(var ParOper:string);override;
	end;

	
	TDivNode=class(TOrdDualOperNode)
	protected
   		procedure   commonsetup;override;
	public
		procedure   InitParts;override;
		procedure   GetOperStr(var ParOper:string);override;
	end;
	
	TModNode=class(TOrdDualOperNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:string);override;
		procedure InitParts;override;
		
	end;
	
	
	
	TNegNode=class(TOperatorNode)
	protected
		procedure commonsetup;override;

	public
		function  GetReplace(ParCre:TCreator):TNodeIdent;override;
		procedure Proces(ParCre :TCreator);override;
		procedure GetOperStr(var ParOper:string);override;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
	end;
	
	
	TLogicNode=class(TOperatorNode)
	protected
		function DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
	public
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
	end;
	
	TNotNode=class(TLogicNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:string);override;
		procedure InitParts;override;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
		procedure PrintNode(ParDis:TDisplay);override;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
	end;
	
	TAndNode = class(TLogicNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:string);override;
		procedure InitParts;override;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
	end;
	
	
	TOrNode= class(TLogicNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:string);override;
		procedure InitParts;override;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
	end;
	
	TXorNode=class(TLogicNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:string);override;
		procedure InitParts;override;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
		function  DoCreateMac(ParOpt:TMacCreateOption;parCre:TSecCreator):TMacBase;override;
	end;
	
	
	
	
	TOperatorNodeList=class(TFormulaList)
	private
		voPoc : TRefFormulaPoc;
	protected
		property    iPoc : TRefFormulaPoc read voPoc write voPoc;
		function    CreatePoc(ParCre : TSecCreator;ParMac1,ParMac2:TMacBase) : TMacBase;virtual;
	public
		property    fPoc : TRefFormulaPoc read voPoc write voPoc;
		
		function    HandleNode(ParCre:TSecCreator;ParNode:TNodeIdent):boolean;override;
		constructor Create(ParPoc : TRefFormulaPoc);
		function    CanOptimize1:boolean;virtual;
		procedure   CalculateOperator(ParCre : TCreator;var ParResult:TNumber;ParPos : cardinal;ParValue:TNumber);virtual;
		procedure   GetFirstValue(var ParValue : TNumber);virtual;
		function    AddOptimizedValue(ParCre : TCreator;ParValue : TNumber):boolean;virtual;
		function    Optimize1(ParCre:TCreator):boolean;override;
		function    CreateMac(ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		function    CheckOptimize1Method:boolean;
		procedure   DefaultValidation(ParCre : TCreator);
	end;
	
	TShrNodeList=class(TOperatorNodeList);


	TMulNodeList=class(TOperatorNodeList)
	public
		function  CanOptimize1:boolean;override;
		procedure GetFirstValue(var ParValue : TNumber);override;
		function  AddOptimizedValue(ParCre : TCreator;ParValue : TNumber):boolean;override;
		procedure CalculateOperator(ParCre :TCreator;var ParResult:TNumber;ParPos : cardinal;ParValue:TNumber);override;
		function  CanOptimizeCpx:boolean;override;
	end;
	
	
	
	TLogicList=class(TOperatorNodeList)
	private
		voWhen  : boolean;
		property iWhen : boolean read voWhen write voWhen;
	public
		constructor Create(ParPoc : TRefFormulaPoc;ParWhen:boolean);
		function    HandleNode(ParCre:TSecCreator;ParNode:TNodeIdent):boolean;override;
	end;
	
	TSizeOfNode=class(TOperatorNode)
	private
		voType      : TType;
		property iType : TType read voType write voType;
	protected
		procedure   commonsetup;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public
		procedure GetOperStr(var ParOper:string);override;
		function    Can(ParCan:TCan_Types):boolean;override;
		procedure  proces(ParCre:TCreator);override;
		function    GetType:TType;override;
		function    GetValue:TValue;override;
		function    IsConstant : boolean;override;
		function  DefaultNodeCheck : boolean;override;
		procedure   ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList) ;override;
	end;
	
	TValuePointerNode=class(TOperatorNode)
	private
		voType      : TType;
		property iType : TType read voType write voType;
	protected
		procedure   commonsetup;override;
		procedure   clear;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public

		procedure GetOperStr(var ParOper:string);override;
		function    Can(ParCan:TCan_Types):boolean;override;
		procedure  proces(ParCre:TCreator);override;
		function    GetType:TType;override;
		function    GetValue:TValue;override;
		function    IsConstant : boolean;override;
		function  DefaultNodeCheck : boolean;override;
	end;


	TObjectPointerNode=class(TOperatorNode)
	private
		voType      : TType;
		voExpression: TFormulaNode;
		property iType      : TType        read voType       write voType;
		property iExpression: TFormulaNode read voExpression write voExpression;
	protected
		procedure commonsetup;override;
		procedure Clear;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public

		procedure  proces(ParCre:TCreator);override;
		procedure  ValidateAfter(ParCre : TCreator);override;
		procedure  ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure GetOperStr(var ParOper:string);override;
		function    Can(ParCan:TCan_Types):boolean;override;
		function    GetType:TType;override;
		constructor Create(ParNode : TFormulaNode;ParType :TType);
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList); override;

	end;
	
	TTypeNode=class(TOperatorNode)
	private
		voType : TType;
	protected
		property iType : TType read voType write voType;
		procedure   Commonsetup;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public
		function   IsOptUnsave:boolean;override;
		constructor Create(parTYpe:TType);
		function    Can(ParCan:TCan_Types):boolean;override;
		procedure   ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		function    GetType:TType;override;
		procedure   PrintNode(ParDis:TDIsplay);override;
		function  DefaultNodeCheck : boolean;override;
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);override;
	end;


	TClassTypeNode=class(TTypeNode)
	public
		procedure InitDotFrame(ParCre : TSecCreator);override;
		procedure DoneDotFrame;override;
	end;

	
	TLabelNode=class(TFormulaNode)
	private
		voType      : TType;
		voDefinition: TDefinition;
		property iType      : TType   read voTYpe      write voType;
		property iDefinition: TDefinition read voDefinition write voDefinition;
	protected
    	procedure Commonsetup;override;
		function   DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public
		function   Can(ParCan : TCan_Types):boolean;override;
		procedure print(ParDis:TDisplay);override;
		constructor create(ParDef : TDefinition;ParType : TType);
		procedure  GetName(var ParName : string);
		function   GetType : TType;override;
	end;
	
	
	TStringNode=class(TConstantNode)
	protected
		procedure   Commonsetup;override;
		function    DoCreateMac(ParOpt : TMacCreateOption;ParSec :TSecCreator):TMacBase;override;

	public
		constructor Create(ParNum:TStringCons);
		procedure   PrintNode(ParDis:TDisplay);override;
		function    ConvertNodeType(ParType : TTYpe;ParCre : TCreator;var ParNode:TFormulaNode):boolean;override;
		function    IsCompWithType(ParType :TType):boolean;override;
		function	CanWriteTo(ParExact : boolean;ParType : TType):boolean;override;
	end;


implementation
uses cblkbase;
{---( TClassTypeNode )------------------------------------------------------------}

procedure TClassTypeNode.InitDotFrame(ParCre : TSecCreator);
var
	vlType : TTYpe;
begin
	if not iParts.IsEmpty then begin
		inherited InitDotFrame(ParCre);
	end else begin
	if iRecord <>nil then iRecord.InitDotFrame(ParCre);
		vlType := GetType;
		TClassType(vlType).InitClassDotFrame(ParCre,fContext);
	end;
end;

procedure TClassTypeNode.DoneDotFrame;
var
	vlType : TType;
begin
	if not iParts.IsEmpty then begin
		inherited DoneDotFrame;
	end else begin
		vlType := GetType;
		TClassType(vlType).DoneClassDotFrame;
		if iRecord <> nil then iRecord.DoneDotFrame;
	end;
end;




{---( TStringNode )---------------------------------------------------------------}
function  TStringNode.DoCreateMac(ParOpt : TMacCreateOption;ParSec :TSecCreator):TMacBase;
var
	vlText : string;
begin
    TStringCons(fVariable).GetString.GetString(vlText);
	ParSec.AddStringConstant(vlText);
	exit(inherited DoCreateMac(ParOpt,ParSec));
end;

function TStringNode.CanWriteTo(ParExact : boolean;ParTYpe : TType):boolean;
var
	vlType : TType;
	vlType2: TType;
begin
	if ParType <> nil then begin
		vlType := ParType.GetOrgType;
		if(vlType  is TCharType) and (vlType.fSize= 1) and (TStringCons(fVariable).GetString.fLength = 1) then exit(true);
		if vlType is TAsciizType then exit(true);
		if (vlType is TPtrType) then begin
			vlType2 := TPtrType(vlType).fTYpe;
			vlType2 := vlType2.GetOrgType;
			if (vlType2 <> nil) and (vlType2 is TAsciizType) then exit(true);
		end;
		exit(inherited CanWriteTo(ParExact,ParType));
	end;
	exit(false);
end;

function  TStringNode.IsCompWithType(ParType :TType):boolean;
var
	vlType : TTYpe;
	vlType2 : TType;
begin
	if (ParType = Nil) or (GetType = nil) then exit(false);
	vlType := ParType.GetOrgType;
	if vlType = nil then exit(false);
	if (vlType is TCharType) and (ParType.fSize=1) and (TStringCons(fVariable).GetString.fLength=1) then exit(true);
	if (vlType is TAsciizType) then exit(true);
	if (vlType is TPtrType) then begin
		vlType2 := TPtrType(vlType).fTYpe;
		vlType2 := vlType2.GetOrgType;
		if (vlType2 <> nil) and (vlType2 is TAsciizType) then exit(true);
	end;
	exit(GetType.IsDirectComp(ParType));
end;

function TStringNode.ConvertNodeType(ParType : TTYpe;ParCre : TCreator;var ParNode:TFormulaNode):boolean;
var
	vlType       : TType;
	vlType2      : TType;
	
function CreateAsciizNode : TFormulaNode;
var
	vlNode       : TStringNode;
	vlArr        : TArrayIndexNode;
	vlVOid       : TTypeNode;
	vlVoidType   : TType;
	
begin
	vlNode := TStringNode.Create(TStringCons(fVariable));
	vlArr  := TArrayIndexNode.Create;
	vlArr.SetBase(TNDCreator(ParCre),vlNode);
	vlArr.AddNode(TNDCreator(ParCre).CreateIntNodeLong(1));
	vlVoidType := TNDCReator(ParCre).GetCheckDefaultType(DT_Void,0,false,'void');
	vlVoid     := TTypeNode.Create(vlVoidType);
	vlVOid.AddNode(vlArr);
	exit(vlVoid);
end;

begin
	if ParType <> nil then begin
		vlType := ParType.GetOrgType;
		if (vlType is TCharType) and (vlType.fSize = 1) then begin
			if TStringCons(fVariablE).GetString.fLength = 1 then begin
				ParNode := TConstantValueNode.Create(TStringCons(fVariable).getString.NewString,ParType);
				exit(true);
			end;
		end else
		if (vlType is TAsciizType) then begin
			
			ParNode := (CreateAsciizNode);
			exit(true);
			
		end else if (vlType is TPtrType) then begin
			
			vlType2 := TPtrType(vlType).fType;
			if vlType2.GetOrgType is TAsciizType then begin
				ParNode :=CreateAsciizNode.CreateObjectPointerOfNode(ParCre);
				exit(true);
			end;
		end;
	end;
	ParNode := nil;
	exit(false);
end;

constructor TStringNode.Create(ParNum:TStringCons);
begin
	inherited Create(TVarBase(ParNum));
end;

procedure   TStringNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_StringNode;
end;

procedure   TStringNode.PrintNode(PArDIs:TDisplay);
begin
	ParDis.print(['<value>',#39]);
	ParDis.WritePst(TStringCons(fVariable).GetString);
	ParDis.Print([#39,'<value>']);
end;


{----( TLabelNode )--------------------------------------------------------}

procedure TLabelNode.GetName(var ParName : string);
begin
	iDefinition.GetMangledName(ParName);
end;

function TLabelNode.Can(ParCan : TCan_Types):boolean;
begin
	exit(inherited Can(ParCan - [CAN_Pointer]));
end;


function TLabelNode.GetType:TType;
begin
	exit(iType);
end;

procedure   TLabelNode.Commonsetup;
begin
	inherited commonsetup;
	iIdentCode := IC_LabelNode;
end;

procedure   TLabelNode.print(ParDis:TDisplay);
begin
	iDefinition.PrintName(ParDis);
end;

constructor TLabelNode.create(ParDef : TDefinition;ParType : TType);

begin
	inherited create;
	iType      := ParType;
	iDefinition:= ParDef;
end;



function  TLabelNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlName : string;
	vlMac : TMacBase;
begin
	if ParOpt = MCO_Result then begin
		GetName(vlName);
		vlMac := TLabelMac.Create(vlName,GetTypeSize);
		ParCre.AddObject(vlMac);
	end else if ParOpt in [mco_ValuePointer,MCO_ObjectPointer] then begin
		vlMac := TMemOfsMac.Create(DoCreateMac(MCO_Result,ParCre));
		ParCre.AddObject(vlMac);
	end else begin
		vlMac := inherited DoCreateMac(ParOpt,ParCre);
	end;
	exit(vlMac);
end;





{---(TArrayIndexNode )---------------------------------------------------------}

{TODO ArrayIndexNodeLIST?}


procedure TArrayIndexNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);
begin
	inherited ValidateFormulaDefinitionUse(ParCre,ParMode,ParUseList);
	iBase.ValidateFormulaDefinitionUse(ParCre,AM_Nothing,ParUseList);
end;

procedure TArrayIndexNode.Clear;
begin
	inherited Clear;
	if iBase <> nil then iBase.Destroy;
end;

procedure TArrayIndexNode.SetBase(ParCre : TNDCreator;ParNode : TFormulaNode);
begin
	if ParNode= nil then exit;
	if iBase <> nil then iBase.Destroy;
	iBase := ParNode;
end;

function  TArrayIndexNode.Can(ParCan:TCan_Types):boolean;
var
	vlCan : TCan_Types;
begin
	vlCan := ParCan * [Can_Size,Can_Dot];
	if vlCan <> [] then begin
		if (iType  <> nil) then begin
			if not iType.Can(vlCan) then exit(false);
		end;
		ParCan := ParCan - vlCan;
	end;
	if iBase <> nil then begin
		exit(iBase.Can(ParCan));
	end else begin
		exit(false);
	end;
end;

procedure TArrayIndexNode.commonsetup;
begin
	inherited Commonsetup;
	iType := nil;
	iBase := nil;
	iCOmplexity := CPX_Array;
end;

procedure TArrayIndexNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlNode : TFormulaNode;
   vlErr  : boolean;
   vlType : TTYpe;
begin
	inherited ValidatePre(ParCre,ParIsSec);
   vlErr := false;
   if iBase <> nil then begin
   	iBase.ValidatePre(ParCre,ParIsSec);
      vlType := iBase.GetOrgType;
      vlNode := (fParts.fStart) as TFormulaNode;
		while (vlNode <> nil) do begin
			if vlType <>nil then begin
				vlErr :=not( vlType.Can([Can_Index]));
			end else begin
				vlErr := true;
				vlType := nil;
			end;
			if vlErr then  TNDCreator(ParCre).AddNodeDefError(iBase,err_Cant_Array_Index_type,vlType);
			if vlType is TSecType then vlType := TSecType(vlType).GetOrgSecType;
			if not vlNode.IsCompByIdentCode(IC_Number) then  TNDCreator(ParCre).AddNodeDefError(vlNode,Err_Integer_Type_Expr_Exp,vlNode.GetType);
			vlNode := (vlNode.fNxt) as TFormulaNode;
		end;
	end;
end;


procedure  TArrayIndexnode.proces(ParCre:TCreator);
var
	vlType    : TType;
	vlCurrent : TNOdeIdent;
begin
	inherited Proces(ParCre);
	if iBase <> nil then begin
		iBase.Proces(ParCre);
		vlCurrent := iParts.fStart as TNodeIdent;
		vlType := iBase.GetOrgType;
		while(vlCurrent <> nil) and (vlType <> nil) do begin
			if (vlType is TSecType) and (vlType.can([Can_Index]))  then begin
				vlType := TSecType(vlType).GetOrgSecType;
			end else begin
				vlType := nil;
				break;
			end;
			vlCurrent := (vlCurrent.fNxt) as TNodeIdent;
		end;
		iType := vlType;
   end;
end;

procedure TArrayIndexNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.WriteNl('<arrayindex>');
	ParDis.writeNl('<base>');
	PrintIdent(ParDis,iBase);
	ParDis.Writenl('</base><index>');
	iParts.Print(ParDis);
	ParDis.Write('</index></arrayindex>');
end;


function  TArrayIndexNode.GetType:TType;
begin
	exit( iType);
end;

{TODO Remove IsLike ,orgtype @TArrayType(vlType).validateIndex}
procedure TArrayIndexNode.ValidateAfter(ParCre : TCreator);
var
	vlFirst   : TFormulaNode;
	vlCurrent : TFormulaNode;
	vlType    : TType;
begin
	inherited ValidateAfter(ParCre);
	if iBase = nil then exit;
	iBase.ValidateAfter(ParCre);
	vlFirst   := IBase;
	vlCurrent := TFormulaNode(GetPartByNum(1));
	vlType := vlFirst.GetType;
	if vlType <> nil then vlType :=vlType.GetOrgType;
	if vlFirst.IsLikeType(TArrayType) then begin
		while (vlType <> nil) and (vlCurrent <> nil) do begin
			if not(vlType.IsLike(TArrayType)) then break;
			vlCurrent.ValidateConstant(ParCre,@TArrayType(vlType).ValidateIndex);
			vlCurrent :=  TFormulaNode(vlCurrent.fNxt);
			vlType := TArrayType(vlType).GetOrgSecType;
		end;
	end else  begin
		if (vlCurrent <> nil) and (vlType <> nil) then begin
			if vlType is TStringBase then vlCurrent.ValidateConstant(ParCre,@TStringBase(vlType).ValidateIndex);
		end;
	end;
end;


function TArrayIndexNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlFirst  : TFormulaNode;
	vlPtr    : TMacBase;
	vlOut    : TMacBase;
	vlNode   : TFormulaNode;
	vlMin    : TArrayIndex;
	vlMAc    : TMacBase;
	vlSize   : TSize;
	vlDim    : TLargeNumber;
	vlNumOfs : TLargeNumber;
	vlCurrent: TArrayType;
	vlLi     : TLargeNumber;
	vlBaseType :TType;
begin
	if ParOpt=MCO_Size then exit( inherited DoCreateMac(MCO_Size,ParCre));
	vlFirst  := iBase;
	LoadLOng(vlNumOfs, 0);
	vlBaseType    := TArrayType(iBase.GetORGType);
	if vlBaseType = nil then exit;
	if iBase.IsLikeType(TArrayType) then begin
		vlNode    := TFormulaNode(GetPartByNum(1));
		vlSize    := 0;
		vlOut     := nil;
		vlCurrent := TArrayType(vlBaseType);
		while vlNode <> nil do begin
			vlMin := vlCurrent.fLo;
			vlDim := vlCurrent.fHi;
			LargeSub(vlDim,vlMin);
			{Num out of range wrong =>Offset out of range?}
			if LargeAddInt(vlDIm,1)     then ParCre.AddNodeError(vlNode,Err_Num_Out_Of_range,'');
			if LargeMul(vlNumOfs,vlDim) then ParCre.AddNodeError(vlNode,Err_Num_Out_Of_range,'');
			if  (vlOut <> nil)          then vlOut := ParCre.MakeMulPoc(vlOut,vlDim);
			vlMac := vlNode.CreateMac(MCO_Result,ParCre);
			if vlMac is TNumberMac then begin
				if LargeAdd(vlNumOfs ,TNumberMac(vlMac).fInt) then ParCre.AddNodeError(vlNode,Err_Num_Out_Of_range,'3');
			end else begin
				if vlOut <> nil then  vlOut := ParCre.MakeAddPoc(vlOut,vlMac)
								else  vlOut := vlMac;
			end;
			LargeSub(vlNumOFs,vlMin);
			vlNode := TFormulaNode(vlNode.fNxt);
			if vlCurrent.IsLike(TArrayType) then vlCurrent := TArrayType(vlCurrent.GetOrgSecType);
		end;
	end else begin
		vlOut   := TFormulaNode(GetPartByNum(1)).CreateMac(MCO_Result,ParCre);
		if (vlOut is TNumberMac) then begin
			vlNumOfs :=TNumberMac( vlOut).fInt;;
			vlOut := nil;
		end;
	end;
	if iType <> nil then begin
		vlSize := GetTypeSize;
		LoadLong(vlLi,vlSize);
		if LargeMul(vlNumOfs,vlLi) then ParCre.AddNodeError(vlFirst,Err_Num_out_of_Range,'');
		if(vlOut <>nil) and (vlSize <> 1) then begin
			vlMac := PArCre.CreateNumberMac(GetAssemblerInfo.GetSystemSize,false,vlLi);
			vlOut := ParCre.MakeMulPoc(vlOut,vlMac);
		end;
	end;
	if vlBaseType is TStringBase then begin
		if LargeAddInt(vlNumOfs, TStringBase(vlBaseType).GetFirstOffset) then ParCre.AddNodeError(vlNode,Err_Num_Out_Of_range,'4');
		LargeSubLong(vlNumOfs,GetTypeSize);
	end;
	if (vlOut = nil) and (ParOpt in [MCO_ValuePointer,MCO_ObjectPointer]) then begin
		vlMac := vlFirst.CreateMac(MCO_Result,ParCre);
		vlMac.SetSize(GetTypeSize);
		vlMac.SetSign(iType.GetSign);
		vlMac.AddExtraOffset(LargeToLongInt(vlNumOfs));
		vlOut := TMemOfsMac.Create(vlMac);
		ParCre.AddObject(vlOut);
	end else if (vlOut = nil) and (ParOpt=MCO_Result) then begin
		vlOut := vlFirst.CreateMac(MCO_Result,ParCre);
		vlOut.SetSize(GetTypeSize);
		vlOut.SetSign(iType.GetSign);
		vlOut.AddExtraOffset(LargeToLongInt(vlNumOfs));
	end else begin
		vlPtr := vlFirst.CreateMac(MCO_ValuePointer,ParCre);
		if vlOut <> nil then 	vlPtr := ParCre.MakeAddPoc(vlOut,vlPtr);
		if ParOpt=MCO_Result then begin
			vlOut := TByPointerMac.create(GetTypeSize,GetType.GetSign,vlPtr);
			ParCre.AddObject(vlOut);
			TByPointerMac(vlOut).AddExtraOffset(LargeToLongint(vlNumOfs));
		end else begin
			vlOut := ParCre.MakeAddPoc(vlPtr,LargeToLongint(vlNumOfs));
		end;
	end;
	exit(vlOut);
end;


{---(TTypeNode )------------------------------------------------------------------}


procedure TTypeNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);
begin
	iParts.ValidateDefinitionUse(ParCre,ParMode,ParUseList);
end;


function  TTYpeNode.DefaultNodeCheck : boolean;
begin
	exit(false);
end;

procedure TTypeNode.PrintNode(ParDis:TDIsplay);
begin
	ParDis.Write('<typeuse>');
    ParDis.Write('<type>');
	if GetType <> nil then begin
		GetType.PrintName(ParDis)
	end else begin
		ParDis.Write('$unkown');
	end;
	ParDis.Write('</type>');
	ParDis.Write('<expression>');
	iParts.Print(ParDis);
	ParDis.Write('</expression>');
    ParDis.Write('</typeuse>');
end;

function TTypeNode.Can(ParCan:TCan_Types):boolean;
var vlNode:TFormulaNode;
begin
	
	vlNode := TFormulaNode(GetPartByNum(1));
	Can := true;
	if CAN_Dot in ParCan then begin
		if (GetType <> nil) and (GetType.Can([Can_Type])) then ParCan := ParCan - [Can_Dot];
	end;
	if vlNode = nil then begin
		Can    := (ParCan - [Can_Size,Can_Type] = []);
	end else if ParCan <> [] then  begin
		Can := vlNode.Can(ParCan);
	end;
end;

function    TTypeNode.GetType:TType;
begin
	exit(iType);
end;

procedure TTypeNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var

	vlFirst : TFormulaNode;
	vlExtra : string;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	vlFirst := TFormulaNode(fParts.fStart);
	if vlFirst <> nil then begin
		if not vlFirst.Can([Can_Read])  then TNDCreator(ParCre).AddNodeError(vlFirst,Err_Cant_Read_From_Expr,'');
		if iType <> nil then begin
			if not  vlFirst.CanCastTo(GetType) then begin
				vlFirst.GetTypeName(vlExtra);
				vlExtra := vlExtra +' to ' + iType.GetErrorName;
				TNDCreator(ParCre).ErrorText(Err_Cant_Cast_To_This_Type,vlExtra);
			end;
		end;
	end;
end;

constructor TTypeNode.Create(parTYpe:TType);
begin
	inherited Create;
	iType := ParType;
end;

function  TTypeNode.IsOptUnsave:boolean;
var
	vlNode : TFormulaNode;
begin
	vlNode := TFormulaNode(GetPartByNum(1));
	if vlNode <> nil then begin
		exit(vlNode.IsOptUnsave);
	end else begin
		exit(False);
	end;
end;

function    TTypeNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlNode:TFormulaNode;
	vlMac : TMacBase;
	vlLd  : TPocBase;
	vlMac2: TMacBase;
	vlLi  : TLargeNumber;
	vlMask: cardinal;
	vlSize :TSize;
begin
	vlNode := TFormulaNode(GetPartByNum(1));
	if (vlNode = nil) or (ParOpt=MCO_Size) then begin
		if ParOpt = MCO_SIZE then begin
			LoadLOng(vlLi,GetTypeSize);
			DoCreateMac := ParCre.CreateNumberMac(0,false,vlLi)
		end else begin
			fatal(FAT_Cant_Create_Mac_type,'Mac option = '+IntToStr(cardinal(ParOpt)));
		end;
	end else begin
		vlSize := GetTypeSize;
		vlMac := vlNode.CreateMac(ParOpt,parCre);
		if ParOpt=MCO_Result then begin
			{Todo: "is TNumberMac" A terr hack, this avoids TResultmac for number
			because extra offset doesn't work on TResultmac}
			if (vlMac is TNumberMac) then begin
					vlLi := TNumberMac(vlMac).fInt;
           		if not(GetTypeSign) and (LargeCompareInt(vlLi,0) = LC_Lower) then begin
					LargeAddLong(vlLi,1);
					LargeNot(vlLi);
				end;
				vlMask := ((1 shl (vlSize *8-1)) shl 1) -1;
				 {TODO: SHould be in Largenum unit something like LargeMask()}
				vlLi.vrNumber := vlLi.vrNUmber and vlMask;
				TNumberMac(vlMac).fInt := vlLi;
				vlMac.SetSize(vlSize);
			end else if  (vlMac.fSize >= GetTypeSize) or (vlMac.fSize = 0) then begin
				vlMac.SetSize(GetTypeSize);
			end else if vlMac.fSize < GetTypeSize then begin
				vlMac2 := TResultMac.Create(GetTypeSize,GetType.GetSign);
				ParCre.AddObject(vlMac2);
				vlLd   := ParCre.MakeLoadPoc(vlMac2,vlMac);
				ParCre.AddSec(vlLd);
				vlMac := vlMac2;
			end;
			vlMac.SetSign(GetTypeSign);
		end;
		exit(vlMac);
	end;
end;

procedure   TTypeNode.COmmonSetup;
begin
	inherited commonSetup;
	iType := nil;
	iIdentCode := (IC_TypeNode);
	iComplexity := CPX_Constant;{Should set to subnode complexity}
end;


{---( TSizeOfNode )----------------------------------------------------------------}

function  TSizeOfNode.DefaultNodeCheck : boolean;
begin
	exit(false);
end;


function   TSizeOfNode.Can(ParCan:TCan_Types):boolean;
begin
	 Can := (ParCan - [CAN_Read]) = [];
end;


procedure   TSizeOfNode.CommonSetup;
begin
	inherited CommonSetup;
	iType     := nil;
	iCOmplexity := CPX_Constant;
end;

procedure TSizeOfNode.GetOperStr(var ParOper:string);
begin
	 ParOper := 'SIZEOF';
end;


function    TSizeOfNode.GetType:TType;
begin
	exit( iType);
end;


function  TSizeOfNode.IsConstant : boolean;
begin
	exit(true);
end;

function  TSizeOfNode.GetValue:TValue;
var
	vlNode : TFormulaNode;
	vlValue : TValue;
begin
	vlValue := nil;
	vlNode := TFormulaNode(GetPartByNum(1));
	if vlNode <> nil then vlValue := TLongint.Create(vlNode.GetSize);
	exit(vlValue);
end;


procedure  TSizeOfNode.proces(ParCre:TCreator);
var vlType  : TType;
	vlNode : TFormulaNode;
begin
	inherited Proces(ParCre);
	if iType <> nil then exit;
	vlNode := TFormulaNode(iParts.fStart);
	if vlNode = nil then exit;
	if vlNode.fNxt <> nil then TNDCreator(ParCre).AddNodeError(vlNode,Err_int_Too_many_Nodes,'');
	if not vlNode.Can([Can_Size]) then TNDCreator(ParCre).AddNodeError(vlNode,Err_Cant_Determine_Size,'');
	vlType := TNDCreator(PArCre).GetDefaultIDent(DT_Number,GetAssemblerInfo.GetSystemSize,false);
	iType     := vlType;
	if vlType = nil then TNDCreator(ParCre).AddNodeError(vlNode,Err_Cant_Find_type,'number');
end;


procedure TSizeOfNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);
begin
	iParts.ValidateDefinitionUse(ParCre,AM_Nothing,ParUseList);
end;


function    TSizeOfNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlNode : TFOrmulaNode;
begin
	if ParOpt = MCO_Result then begin
		vlNode := TFormulaNode(iParts.fStart);
		if vlNode <> nil then begin
			exit(vlNode.CreateMac(MCO_Size,ParCre));
		end else begin
			fatal(FAT_Node_Is_NULL,'');
		end;
	end;
	exit(inherited CreateMac(ParOpt,ParCre));
end;




{---( TValuePointerNode )----------------------------------------------------------------}

function  TValuePointerNode.DefaultNodeCheck : boolean;
begin
	exit(false);
end;


function   TValuePointerNode.Can(ParCan:TCan_Types):boolean;
begin
	Can := (ParCan - [CAN_Size , Can_Read]) = [];
end;


procedure   TValuePointerNode.CommonSetup;
begin
	inherited CommonSetup;
	iType     := nil;
	iCOmplexity := CPX_Constant;
end;

procedure TValuePointerNode.GetOperStr(var ParOper:string);
begin
	 ParOper := 'VALUE POINTER';
end;


function    TValuePointerNode.GetType:TType;
begin
	exit( iType);
end;


function  TValuePointerNode.IsConstant : boolean;
begin
	exit(false);
end;

function  TValuePointerNode.GetValue:TValue;
begin
	exit(nil);
end;


procedure  TValuePointerNode.proces(ParCre:TCreator);
var vlType  : TType;
	vlName  : string;
	vlNode : TFormulaNode;
begin
	inherited Proces(ParCre);
	if iType <> nil then exit;
	vlNode := TFormulaNode(iParts.fStart);
	if vlNode = nil then exit;
	if vlNode.fNxt <> nil then TNDCreator(ParCre).AddNodeError(vlNode,Err_int_Too_many_Nodes,'');
	vlType := nil;
	if vlNode is TCallNode then begin
		if TCallNode(vlNode).fParCnt <> 0 then TNDCreator(ParCre).AddNodeError(vlNode,Err_No_Parameters_Expected,'');
		if TCallNode(vlNode).IsOverloaded  then TNDCreator(ParCre).AddNodeError(vlNode,Err_Cant_Adr_Overl,'');
		vlType := TRoutineType.create(false,TCallNode(vlNode).fRoutineItem,false);
		TCallNode(vlNode).GetNameStr(vlName);
		vlType.SetText('Ptr to '+vlName);{TODO Check if there is a messup of MCO_VALUEPOINTER or MCO_OBJECTPOINTER}
	end else begin
		vlType := TFormulaNode(vlNode).GetType;
		if not TFormulaNode(vlNode).Can([CAN_Pointer]) then TNDCreator(ParCre).AddNodeError(vlNode,Err_Cant_Get_Expr_Pointer,'');
		if vlType = nil then begin
			vlName  := 'Unkown Type';
		end else begin
			vlType.GetTextStr(vlName);
			vlName := 'Ptr '+vlName;
		end;
		vlType := TPtrType.create(vlType,false);
		vlType.SetText(vlName);
	end;
	iType := vlType;
end;

function    TValuePointerNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlmac : TMacBase;
begin
	vlMac :=nil;
	case ParOpt of
		MCO_Result : vlMac := TFormulaNode(GetPartByNum(1)).CreateMac(MCO_ObjectPointer,ParCre);
		MCO_SIze   : vlMac := inherited DoCreateMac(MCO_Size,ParCre);
		else begin
			Fatal(Fat_Invalid_Mac_Number,['option=',cardinal(ParOpt)]);
		end;
	end;
	exit(vlMac);

end;



procedure TValuePOinterNode.clear;
begin
	inherited clear;
	if iType <> nil then iType.Destroy;
end;

{---( TObjectPointerNode )----------------------------------------------------------------}

procedure TObjectPointerNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);
begin
	inherited ValidateFormulaDefinitionUse(ParCre,ParMode,ParUseList);
	iExpression.ValidateFormulaDefinitionUse(ParCre,AM_PointerOf,ParUseList);
end;


procedure TObjectPointerNode.ValidateAfter(ParCre : TCreator);
begin
	inherited ValidateAfter(ParCre);
	if iExpression <> nil then iExpression.ValidateAfter(ParCre);
end;

procedure TObjectPointerNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean); {TODO:Duplicate error when can't get pointer }
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if iExpression <> Nil then begin
		iExpression.ValidatePRe(PArCre,false);
		if not iExpression.Can([Can_Pointer]) then TNDCreator(ParCre).AddNodeError(iExpression,Err_Cant_Get_Expr_Pointer,'');
	end;
end;

procedure TObjectPointerNode.Proces(ParCre : TCreator);
var
	vlName : string;
begin
	inherited Proces(ParCre);
	if iExpression <> nil then begin
		iExpression.Proces(ParCre);
		if iType = nil then begin{TODO: Temp hack.... can't use this for all expression because of TRoutineType}
			iExpression.GetTypeName(vlName);
			iType := TPtrType.Create(iExpression.GetTYpe,false);
			iType.SetText(vlName);
		end;
	end;
end;

function   TObjectPointerNode.Can(ParCan:TCan_Types):boolean;
begin
	 Can := (ParCan - [CAN_Size , Can_Read]) = [];
end;


procedure   TObjectPointerNode.CommonSetup;
begin
	inherited CommonSetup;
	iCOmplexity := CPX_Constant;
{TODO :identcode}
end;

procedure TObjectPointerNode.GetOperStr(var ParOper:string);
begin
	ParOper := 'OBJECT POINTER';
end;


function    TObjectPointerNode.GetType:TType;
begin
	exit( iType);
end;

constructor TObjectPointerNode.Create(ParNode : TFormulaNode;ParTYpe : TType);
begin
	iExpression := ParNode;
	iType := ParType;
	inherited Create;
end;

function    TObjectPointerNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
begin
	exit(iExpression.CreateMac(MCO_ObjectPOinter,ParCre));
end;


procedure TObjectPointerNode.Clear;
begin
	inherited Clear;
	if iExpression <> nil then iExpression.Destroy;
	if iType <> nil then iType.Destroy;
end;

{--( TDirectValueNode )-------------------------------------------------------------}


function TDirectValueNode.GetType : TType;
begin
	exit(iType);
end;

constructor TDirectValueNode.Create(ParType :TType);
begin
	inherited Create;
	iType := ParType;
end;


{---( TReturnVarNode )---------------------------------------------------------------}


function  TReturnVarNode.Can(ParCan  : TCan_Types):boolean;
begin
	exit(ParCan - [CAN_Read,Can_Size,Can_Pointer,Can_Write]= []);
end;


procedure TReturnVarNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.Write('$returnvar');
end;


procedure TReturnVarNode.Commonsetup;
begin
	inherited Commonsetup;
	iCOmplexity := (CPX_ReturnVar);
end;



function TReturnVarNode.DoCreateMac(ParOption : TMacCreateOption;ParCre : TSecCreator): TMacBase;
var
	vlMac : TMacBase;
begin
	if ParOption = MCO_Result then begin
		vlMac := TOutputMac.create(fType.fSize,fType.GetSign);
		ParCre.AddObject(vlMac);
	end else begin
		vlMac := inherited DoCreateMac(ParOption,ParCre);
	end;
	exit(vlMac);
end;

{---( TConstantValueNode )-----------------------------------------------------------}

function  TConstantValueNode.IsConstant : boolean;
begin
	exit(true);
end;

procedure TConstantValueNode.Commonsetup;
begin
	inherited Commonsetup;
	iComplexity := CPX_COnstant;
end;

function  TConstantValueNode.Can(ParCan:TCan_Types):boolean;
begin
	exit(inherited Can(ParCan));
end;


function  TConstantValueNode.IsCompWithType(ParType :TType):boolean;
begin
	if iValue <> nil then begin
		if (iValue is TString) and ((ParType is TStringBase) or (ParType is TCharType))then exit(true);
	end;
	exit(inherited IsCompWithType(ParType));
end;

function  TConstantValueNode.ConvertNodeType(ParType : TType;ParCre : TCreator;var ParNode:TFormulaNode):boolean;
var
	vlVal : TNumber;
	vlType : TType;
begin
	if iValue <> nil then begin
		vlType := ParType.GetOrgType;
		if ((iValue is TCharValue) or (iValue is TString)) and (ParType.IsLike(TStringBase) or ParType.IsLike(TCharType)
			or ((vlType.IsLike(TPtrType) and (TPtrType(vlType).fType.IsLIke(TAsciizType)))))  then begin
			iType := ParType;
			ParNode := nil;
			exit(true);
		end else if (iValue is TPointer) and (ParType.IsLike(TRoutineType)) then begin
			vlType := ParType.GetOrgType;
			if TRoutineType(vlType).fOfObject then begin
                iValue.GetAsNumber(vlVal);
				if LargeCompareLong(vlVal,0)=LC_Equal then begin
					ParNode := TConstantValueNode.Create(iValue.Clone,ParType);
					exit(True);
				end;
			end;
		end;
	end;
	ParNode := nil;
	exit(false);
end;



function    TConstantValueNode.GetValue : TValue;
begin
	GetValue := iValue.clone;
end;

procedure   TConstantValueNode.PrintNode(ParDisplay : TDisplay);
begin
	ParDisplay.write('<value>');
	if iValue = nil then begin
		ParDisplay.Write('nil')
	end else begin
		 ParDisplay.Print([iValue]);
	end;
	ParDisplay.write('</value>');
end;

constructor TConstantValueNode.Create(ParValue : TValue;ParType : TType);
begin
	inherited Create(ParType);
	iValue := ParValue;
end;

procedure   TConstantValueNode.Clear;
begin
	inherited Clear;
	if iValue <> nil then iValue.Destroy;
end;

function   TConstantValueNode.DoCreateMac(ParOption : TMacCreateOption;ParCre : TSecCreator):TMacBase;
begin
	exit(fType.CreateConstantMac(ParOption,ParCre,iValue));
end;


{-----( TOperatorNodeList )------------------------------------------}

procedure TOperatorNodeList.DefaultValidation(ParCre : TCreator);
var
	vlCurrent : TFormulaNode;
	vlType    : TTYpe;
begin
	vlCurrent := TFormulaNode(fStart);
	while vlCurrent <> nil do begin
		if not vlCurrent.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Cant_Read_From_Expr,'');
		vlType := vlCurrent.GetType;
		if (vlType = nil) or (vlType.fSize = 0) then TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Cant_Determine_Size,'');
		vlCurrent := TFormulaNode(vlCurrent.fNxt);
	end;
end;

function TOperatorNodeList.CheckOptimize1Method:boolean;
var vlCurrent : TFormulaNode;
	vlFirst   : boolean;
begin
	vlCurrent := TFormulaNode(fStart);
	vlFirst   := false;;
	while (vlCurrent <> nil) do begin
		if vlCurrent.IsConstant then begin
			if vlFirst then exit(true);
			vlFirst := true;
		end;
		vlCurrent := TFormulaNode(vlCurrent.fNxt);
	end;
	exit(false);
end;



function    TOperatorNodeList.CreatePoc(ParCre :TSecCreator;ParMac1,ParMac2:TMacBase) : TMacBase;
begin
	exit(ParCre.CreateThreePoc(fPoc,ParMac1,ParMac2));
end;

function TOperatorNodeList.CreateMac(ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var 	 vlCurrent   : TFormulaNode;
	vlSec       : TSubPoc;
	vlPoc       : TSubPoc;
	vlMac       : TMacBase;
	vlMac2      : TMacBase;
	vlNxt	     : TFormulaNode;
begin
	vlSec := TSubPoc.create;
	ParCre.AddSec(vlSec);
	vlPoc     := ParCre.fPoc;
	ParCre.SetPoc(vlSec);
	vlCurrent := TFormulaNode(fStart);
	vlMac := nil;
	
	if vlCurrent <> nil then begin
		vlNxt :=TFormulaNode(vlCurrent.fNxt);
		if (vlNxt <> nil) then begin
			if vlCurrent.fComplexity > vlNxt.fComplexity then begin
				vlMac := vlCurrent.CreateMac(ParOption,ParCre);
				vlMac2 := vlNxt.CreateMac(ParOption,parCre);
			end else begin
				vlMac2 := vlNxt.CreateMac(ParOption,ParCre);
				vlMac := vlCurrent.CreateMac(ParOption,parCre);
			end;
			vlMac := CreatePoc(ParCre,vlMac,vlMac2);
			vlNxt := TFormulaNode(vlNxt.fNxt);
		end else begin
			vlMac := vlCurrent.CreateMac(ParOption,ParCre);
		end;
		vlCurrent := vlNxt;
		while (vlCurrent <>  nil) and (vlMac <> nil) do begin
			vlMac2 := vlCurrent.CreateMac(ParOption,ParCre);
			vlMac := CreatePoc(ParCre,vlMac,vlMac2);
			vlCurrent := TFormulaNode(vlCurrent.fNxt);
		end;
	end;
	ParCre.SetPoc(vlPoc);
	exit(vlMac);
end;



function  TOperatorNodeList.CanOptimize1:boolean;
begin
	CanOptimize1 := false;
end;

procedure TOperatorNodeList.CalculateOperator(ParCre : TCreator;var ParResult:TNumber;ParPos : cardinal;ParValue:TNUmber);
begin
end;

function  TOperatorNodeList.Optimize1(ParCre:TCreator):boolean;
var vlCurrent      : TOperatorNode;
	vlHasOptimized : boolean;
	vlResult       : TNumber;
	vlNxt          : TOperatorNode;
	vlNum          : TNumber;
	vlValue	   : TValue;
	vlOpt	   : boolean;
	vlCan          : boolean;
	vlFound 	   : cardinal;
	vlPos	   : cardinal;
begin
	vlCurrent := TOperatorNode(fStart);
	if (vlCurrent <> nil) and (vlCurrent.fNxt = nil) then begin
		vlOpt := false;
		if not vlCurrent.fCanDelete then vlOpt := vlCurrent.Optimize1(ParCre);
		if inherited Optimize1(ParCre) then vlOpt := true;
		exit(vlOpt);
	end;
	vlHasOptimized := false;
	vlCan    := CanOptimize1;
	if CanOptimize1 then begin
		vlCan := CheckOptimize1Method;
	end;
	vlFound  := 0;
	vlPos    := 0;
	GetFirstValue(vlResult);
	if inherited Optimize1(ParCre) then vlHasOptimized  := true;
	if vlCan then begin
		while vlCurrent<> nil do begin
			inc(vlPos);
			vlNxt := TOperatorNode(vlCurrent.fNxt);
			if not vlCurrent.fCanDelete then begin
				vlValue := vlCurrent.GetValue;
				if vlValue <> nil then begin
					if not vlValue.GetNumber(vlNum) then begin
						CalculateOperator(ParCre,vlResult,vlPos,vlNum);
						inc(vlFound);
						vlCurrent.SetCanDelete(true);
					end;
					vlValue.Destroy;
				end;
			end;
			vlCurrent := vlNxt;
		end;
		if (vlFound > 0) then begin
			vlHasOptimized := (vlFound > 1);
			{ if} AddOptimizedValue(ParCre,vlResult) {then vlHasOptimized := true;}
		end;
	end;
	DeleteIfCan(ParCre);
	if inherited Optimize1(parCre) then vlHasOptimized := true;
	exit(vlHasOptimized);
end;

procedure TOperatorNodeList.GetFirstValue(var ParValue : TNumber);
begin
	LoadInt(ParValue,0);
end;

function TOperatorNodeList.AddOptimizedValue(ParCre : TCreator;ParValue : TNumber):boolean;
var vlResNode : TNodeIdent;
begin
	vlResNode := TNDCreator(ParCre).CreateIntNode(ParValue);
	if vlResNode <> nil then AddNode(vlResNode);
	exit(true);
end;

function  TOperatorNodeList.HandleNode(ParCre:TSecCreator;ParNode:TNodeIdent):boolean;
begin
	ParCre.AddSec(TUnkPoc.create(self.className));
	HandleNode := true;
end;

constructor  TOperatorNodeList.Create(ParPoc:TRefFormulaPoc);
begin
	inherited Create;
	fPoc := (ParPoc);
end;




{----( TLogicList )-----------------------------------------}


constructor TLogicList.Create(ParPoc : TRefFormulaPoc;ParWhen:boolean);
begin
	inherited Create(ParPoc);
	iWhen := ParWhen;
end;



function TLogicList.HandleNode(ParCre:TSecCreator;ParNode:TNodeIdent):boolean;
var vlLab,vlOth:TLabelPoc;
begin
	vlOth := nil;vlLab := nil;
	if not ParNode.IsLast then begin
		vlOth := ParCre.CreateLabel;
		if iWhen then vlLab := ParCre.SetLabelFalse(vlOth)
		else vlLab := Parcre.SetLabelTrue(vlOth);
	end;
	ParNode.CreateSec(ParCre);
	if not ParNode.isLast then begin
		ParCre.Addsec(vlOth);
		if iWhen then ParCre.SetLabelFalse(vlLab)
		else ParCre.SetLabelTrue(vlLab);
	end;
	HandleNode := false;
end;

{---( TLogicNode )------------------------------------------------}

function TlogicNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlLabTrue  : TLabelPoc;
	vlLabFalse : TLabelPoc;
	vlPrvTrue  : TLabelPoc;
	vlPrvFalse : TLabelPoc;
begin
	case ParOpt of
	MCO_Result:begin
		if not TFormulaNode(GetPartByNum(1)).IsLikeType(TBooleanType) then begin
			DoCreateMac := inherited DoCreateMac(ParOpt,ParCre);
		end else begin
			vlPrvTrue := ParCre.fLabelTrue;
			vlPrvFalse:= ParCre.fLabelFalse;
			vlLabTrue := parCre.CreateLabel;
			vlLabFalse:= ParCre.CreateLabel;
			ParCre.SetLabelTrue(vlLabTrue);
			ParCre.SetLabelFalse(vlLabFalse);
			CreateSec(ParCre);
			DoCreateMac := parCre.ConvJumpToBool(GetType.fSize);
			ParCre.SetLabelTrue(vlPrvTrue);
			ParCre.SetLabelFalse(vlPrvFalse);
		end;
	end
		else inherited DoCreateMac(ParOpt,ParCre);
	end;
end;


procedure TLogicNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlNode : TFormulaNode;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	vlNode := TFormulaNode(fParts.fStart);
    if vlNode <> nil then begin
		if  not (vlNode.IsCompByIdentCode(IC_Number)  or vlNode.IsLikeType(TBooleanType)) then TNDCreator(ParCre).AddNodeDefError(vlNode,Err_Wrong_Type,vlNode.GetType);
		vlNode := TFOrmulaNode(vlNode.fNxt);
		while vlNode <> nil do begin
			if not IsDirectComp(vlNode) then TNDCreator(ParCre).AddNodeDefError(vlNode,Err_Wrong_Type,vlNode.GetType);
			vlNode := TFormulaNode(vlNode.fNxt);
		end;
	end;
end;

{---( TNotNode )--------------------------------------------------}

procedure TNotNode.GetOperStr(var ParOper:String);
begin
	ParOper := 'NOT';
end;


procedure TNotNode.CommonSetup;
begin
	inherited COmmonSetup;
	iIdentCode  := IC_NotNode;
	iComplexity := CPX_Not;
end;

procedure TNotNode.InitParts;
begin
	iParts := TLogicList.create(TNotFor,false);
end;



function TNotNode.CreateSec(ParCre:TSecCreator):boolean;
begin
	ParCre.SwapLabels;
	GetPartByNum(1).CreateSec(ParCre);
	ParCre.SwapLabels;
	CreateSec := false;
end;

procedure TNotNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.writenl('<not>');
	iParts.print(ParDis);
	ParDis.writenl('</not>');
end;


function TNotNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlNotFor:TNotFor;
	vlMac   :TMacBase;
begin
	case ParOpt of
		MCO_Result:begin
			vlNotfor := TNotFor.create;
			vlNotfor.SetVar(1,iParts.CreateMac(ParOpt,Parcre));
			ParCre.AddSec(vlNotFor);
			vlMac := vlNotFor.CalcOutputMac(ParCre);
		end;
		else vlMac := inherited DoCreateMac(ParOpt,ParCre);
	end;
	exit(vlMac);
end;



{---( TAndNode )--------------------------------------------------}


procedure TAndNode.InitParts;
begin
	iParts := TLogicList.create(TAndFor,false);
end;


function  TAndNode.CreateSec(ParCre:TSecCreator):boolean;
begin
	CreatePartsSec(ParCre);
	CreateSec := false;
end;


procedure TAndNode.GetOperStr(var PArOper:string);
begin
	ParOper := 'AND';
end;


procedure TAndNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_AndNode;
	iComplexity := CPX_And;
end;


{---( TOrNode )--------------------------------------------------}

function  TOrNode.CreateSec(ParCre:TSecCreator):boolean;
begin
	CreatePartsSec(ParCre);
	CreateSec := false;
end;


procedure TOrNode.initParts;
begin
	iParts := TLogicList.create(TOrFor,true);
end;


procedure TOrNode.GetOperStr(Var ParOper:String);
begin
	ParOper := 'OR';
end;

procedure TOrNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_OrNode;
	iComplexity := CPX_Or;
end;


{---( TXorNode )--------------------------------------------------}


procedure TXorNode.initParts;
begin
	iParts := TOperatorNodeList.create(TXorFor);
end;


procedure TXorNode.GetOperStr(var ParOper:string);
begin
	ParOper := 'XOR';
end;

procedure TXorNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_XorNode;
	iComplexity := CPX_XOr;
end;

function TXorNode.DoCreateMac(ParOpt:TMacCreateOption;parCre:TSecCreator):TMacBase;
begin
	exit(iParts.CreateMac(ParOpt,ParCre));
end;


function TXorNode.CreateSec(ParCre:TSecCreator):boolean;
var vlMac  : TMacBase;
	vlComp : TCompFor;
	vlOut  : TMacBase;
	vlNum  : TLargeNumber;
begin
	vlMac := DoCreateMac(MCO_Result,ParCre);
	vlComp := TCompFor.Create(IC_NotEq);
	vlComp.SetVar(1,vlMac);
	LoadInt(vlNum,0);
	vlComp.SetVar(2,ParCre.CreateNumberMac(vlMac.fSize,false,vlNum));
	vlOut := vlComp.CalcOutputMac(ParCre);
	ParCre.AddSec(vlComp);
	ParCre.MakeJumpFromCond(vlOut);
	CreateSec:= false;
end;






{--------( TPointerNode )-------------------------------------------}


constructor TPointerNode.Create(ParNum:TPointerCons);
begin
	inherited Create(ParNum);
end;

destructor  TPointerNode.Destroy;{clear}
begin
	inherited Destroy;
	fVariable.Destroy;
end;


procedure TPointerNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_NumNode;
	iCOmplexity := CPX_Pointer;
end;


procedure TPointerNode.PrintNode(ParDis:TDisplay);
var
	vlName : string;
begin
	ParDis.Write('<pointer>');
	if fVariable <> nil then begin
		fVariable.GetTextStr(vlName);
		ParDis.Write(vlName);
	end;
	ParDis.Write('</pointer>');
end;


{--------( TBoolOperNode )--------------------------------------}

procedure TBoolOperNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlFirst  : TFormulaNode;
	vlSecond : TFormulaNode;
	vlType   : TType;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	vlFirst := TFormulaNode(iParts.fStart);
	if vlFirst <> nil then begin
		if not((vlFirst.IsCompByIdentCode(IC_Number))
		or (vlFirst.IsCompByIdentCode(IC_CHarType))
		or (vlFirst.IsCompByIdentCode(IC_PtrType))
		or (VlFirst.IsCompByIdentCode(IC_RoutineType))
		or (VlFirst.IsCompByIdentCode(IC_EnumType))
		or (vlFirst.IsLikeType(TBooleanType)))
		then begin
			TNDCreator(ParCre).AddNodeDefError(vlFirst,Err_Wrong_Type,vlFirst.GetType);
		end;
		vlSecond := TFormulaNode(vlFirst.fNxt);
		while vlSecond <> nil do begin
			vlType := vlFirst.GetType;
			if CheckCOnvertNode2(ParCre,vlType,vlSecond) then TNDCreator(ParCre).AddNodeDefError(vlSecond,Err_Wrong_Type,vlType);
			vlSecond := TFormulaNode(vlSecond.fNxt);
		end;
	end;
end;

constructor TBoolOperNode.Create(ParBooleanType:TType);
begin
	inherited Create;
	iBooleanType := ParBooleanType;
end;

function    TBoolOperNode.GetType:TType;
begin
	exit(iBooleanType);
end;


{--------( TModNode )-------------------------------------------}

procedure TModNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_DivNode);
	iComplexity := CPX_Mod;
end;

procedure TModNode.GetOPerStr(var ParOper:String);
begin
	ParOper := 'MOD';
end;


procedure TModNode.InitParts;
begin
	iParts := TOperatorNodeList.Create(TModFor);
end;

{--------( TDivNode )-------------------------------------------}


procedure TDivNode.InitParts;
begin
	iParts := TOperatorNodeList.Create(TDivFor);
end;

procedure TDivNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_DivNode;
	iComplexity := CPX_Div;
end;

procedure TDivNode.GetOPerStr(var ParOper:String);
begin
	ParOper := '/';
end;



{--------( TnegNode )-------------------------------------------}


procedure TNegNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlNode : TFormulaNode;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	vlNode := TFormulaNode(iParts.fStart);
	if vlNode <> nil then begin
		if not vlNode.IsCompByIdentCode(IC_Number) then TNDCreator(ParCre).AddNodeDefError(vlNode,Err_Wrong_Type,vlNode.GetType);
    end;
end;


function  TNegNode.GetReplace(ParCre:TCreator):TNodeIdent;
var vlValue : TValue;
	vlNum   : TNumber;
	vlNode  : TFormulaNode;
	vlType  : TType;
begin
	if iParts.GetNumItems = 1 then begin
		vlNode  := TFormulaNode(iParts.fStart);
		vlValue := vlNode.GetValue;
		if (vlValue <> nil) then begin
			if not (vlValue.GetNumber(vlNum)) then begin
				vlValue.Neg;
				LargeNeg(vlNum);
				vlType := TNDCreator(ParCre).GetIntType(vlNum,vlNum);
				exit(TConstantValueNode.Create(vlValue,vlType));
			end;
			vlValue.Destroy;
		end;
	end;
	exit(nil);
end;

procedure  TNegNode.Proces(ParCre:TCreator);
var vlType    : TType;
	vlOrgType : TType;
	vlNode    : TFormulaNode;
	vlNewNode : TFormulaNode;
begin
	inherited Proces(ParCre);
	vlNode := TFormulaNode(fParts.fStart);
	if (vlNode <> Nil) and (vlNode is TFormulaNode) then begin
		vlOrgType := vlNode.GetType;
		if vlOrgType <> nil then begin
			if not  vlOrgType.GetSign then begin
				vlType := TNDCreator(ParCre).GetDefaultIdent(DT_Number,vlOrgType.fSize * 2,true);
				if vlType <> nil then begin
					vlNewNode := TLoadConvert.Create(vlType);
					vlNewNode.SetPosToNode(self);
					vlNewNode.AddNode(vlNode);
					iParts.CutOut(vlNode);
					iParts.AddNode(vlNewNode);
				end;
			end
		end;
	end;
end;


procedure TNegNode.GetOperStr(var ParOper:string);
begin
	ParOper := 'NEG';
end;

procedure TNegNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_NegNode);
	iComplexity := CPX_Neg;
end;


function TNegNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlNegFor:TNegFor;
	vlMac   :TMacBase;
begin
	case ParOpt of
		MCO_Result:begin
			vlNegfor := TNegFor.create;
			vLnegfor.SetVar(1,iParts.CreateMac(ParOpt,Parcre));
			ParCre.AddSec(vlNegFor);
			vlMac := vlNegFor.CalcOutputMac(ParCre);
		end;
		else vlMac := inherited DoCreateMac(ParOpt,ParCre);
	end;
	exit(vlMac);
end;

{--------( TShrNode )-------------------------------------------}


procedure TShrNode.InitParts;
begin
	iParts := TShrNodeList.Create(TShrFor);
end;

Procedure TShrNode.GetOperStr(var ParOper : string);
begin
	ParOper := 'SHR';
end;


procedure TShrNode.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_ShrNode;
end;

{--------( TShlNode )-------------------------------------------}


procedure TShlNode.InitParts;
begin
	iParts := TShrNodeList.Create(TShlFor);
end;

Procedure TShlNode.GetOperStr(var ParOper : string);
begin
	ParOper := 'SHL';
end;


procedure TShlNode.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_ShlNode;
end;

{--------( TMulNode )-------------------------------------------}


procedure TMulNode.InitParts;
begin
	iParts := TMulNodeList.create(TMulFor);
end;

procedure TMulNode.GetOperStr(var ParOper:String);
begin
	ParOper := '*';
end;

procedure TMulNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_MulNode;
	iComplexity:= CPX_Mul;
end;


{------( TMulNodeLIst )-----------------------------------------}


function TMulNodeList.CanOptimizeCpx:boolean;
begin
	exit(true);
end;

function TMulNodeList.AddOptimizedValue(ParCre : TCreator;ParValue : TNumber):boolean;
var vlAdd : boolean;
begin
	vlAdd := false;
	if LargeCompareLong(ParValue,1)<> LC_Equal then vlAdd := inherited AddOptimizedValue(ParCre,ParValue);
	exit(vlAdd);
end;

procedure  TMulNodeList.GetFirstValue(var ParValue : TNumber);
begin
	LoadInt(ParValue,1);
end;

function  TMulNodeList.CanOptimize1:boolean;
begin
	CanOptimize1 := true;
end;

procedure TMulNodeList.CalculateOperator(ParCre : TCreator;var ParResult:TNumber;ParPos : cardinal;ParValue:TNumber);
begin
	if LargeMul(ParResult,ParValue) then TNDCreator(ParCre).AddNodeListError(self,Err_NuM_Out_Of_range,'');
end;


{------( TOrdDualOperNode )------------------------------------}

procedure TOrdDualOperNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlNode 	   : TFormulaNode;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	vlNode := TFormulaNode(fParts.fStart);
	while(vlNode <> nil) do begin
		if not(vlNode.IsCompByIdentcode(IC_Number)) then begin
			TNDCreator(ParCre).AddNodeDefError(vlNode,Err_Wrong_Type,vlNode.GetType);
		end;
		vlNode := TFormulaNode(vlNode.fNxt);
	end;
end;


{------( TDualOperNode )----------------------------------------}



function TDualOperNode.GetReplace(ParCre:TCreator):TNodeIdent;
var
	vlItem:TNodeIdent;
begin
	vlItem := TNodeIdent(iParts.fStart);
	if (vlItem <> nil) then begin
		if vlItem.fNxt = nil then begin
			iParts.CutOut(vlItem);
			SetCanDelete(true);
		end else begin
			vlItem := nil;
		end;
	end;
	exit(vlItem);
end;


{----( TByPtrNode )-----------------------------------------}

function TByPtrNode.IsOptUnsave:boolean;
begin
	exit(true);
end;


function TByPTrNode.Can(ParCan:TCan_Types):boolean;
var
	vlNode  : TFormulaNode;
	vlType  : TPtrType;
	vlFlags : TCan_Types;
	vlDestType : TType;
begin
	vlFlags := ParCan * [CAN_Size, Can_Dot,Can_Type,Can_Execute,Can_Index];
	if vlFlags <> [] then begin
		vlDestType := GetOrgType;
		if (vlDestType = nil) or not(vlDestType.Can(vlFlags)) then exit(false);
		ParCan := ParCan - vlFlags;
	end;
	vlNode := TFormulaNode(GetPartByNum(1));
	if(vlNode <> nil) then begin
		vlType :=  TPtrType(vlNode.GetOrgType);
		if(vlType <> nil) then begin
			if (vlType is TPtrType) and not vltype.fConstFlag then ParCan := ParCan - [Can_Write];
		end;
	end;
	exit( inherited Can(ParCan - [CAN_Pointer]));
end;


procedure TByPtrNode.GetOperStr(var ParOper:string);
begin
	ParOper := 'ByPtr';
end;

procedure TByPtrNode.commonsetup;
begin
	inherited Commonsetup;
	iIdentCode   := IC_ByPtrNode;
	iExtraOffset := 0;
	iCOmplexity  := CPX_ByPointer;
end;


function TByPtrNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlMac  : TMacBase;
	vlNode : TNodeIdent;
	vlType : TType;
	vlRef  : TMacBase;
	vlPtrType:TType;
begin
	case ParOpt of
	MCO_Result:begin
		vlNode    := GetPartByNum(1);
		vlType    := TFormulaNode(vlNode).GetType;
		vlMac     := TNodeIdent(vlNode).CreateMac(MCO_Result,ParCre);
		vlPtrType := TPtrTYpe(vltype).fType;
		vlRef     := TByPointerMac.create(vlPtrType.fSize,vlPtrType.GetSign,vlMac);
		ParCre.AddObject(vlRef);
		vlRef.AddExtraOffset(iExtraOffset);
		DoCreateMac := vlRef;
	end;
	MCO_ValuePointer,MCO_ObjectPointer:DoCreateMac := TNodeIdent(GetPartByNum(1)).CreateMac(MCO_Result,ParCre);
	else DoCreateMac := inherited DoCreateMac(ParOpt,ParCre);
end;
end;

procedure TByPTrNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlType : TType;
	vlNode : TFormulaNode;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	vlNode := TFormulaNode(fParts.fStart);
	if vlNode <>nil then begin
		vlType := vlNode.GetOrgType;
		if vlType <> nil then begin
			if not (vlType is TPtrType) then begin
				TNDCreator(ParCre).AddNodeDefError(vlNode,Err_Not_A_Pointer_Type,vlNode.GetType);
			end  else  begin
				if TPtrType(vlType).GetSecSize = 0 then TNDCreator(PArCre).AddNodeDefError(vlNode,Err_Cant_Determine_Size,vlNode.GetType);
			end;
		end;
	end;
end;


function TByPtrNode.GetType:TType;
var
	vlOther:TFormulaNode;
	vlType : TType;
begin
	vlOther := TFormulaNode(iParts.fStart);
	vlType  := nil;
	if vlOther <> nil then begin
			vlType := vlOther.GetOrgType;
			if (vlType <> nil) and (vlType is TPtrType) then begin
				vlType := TPtrType(vlType).fType;
			end else begin
				vlType := nil;
			end;
	end;
	exit(vlType);
end;



{----( TOperatorNode )------------------------------------------}



procedure TOperatorNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);
begin
	iParts.ValidateDefinitionUse(ParCre,AM_Read,ParUseList);
end;

function TOperatorNode.CheckConvertTest(ParType1,ParType2 : TType) : boolean;
begin
	exit(ParType1.IsDirectComp(ParType2));
end;

function TOperatorNode.CheckConvertNode(ParCre :TCreator;ParType :TType;var ParNode : TFormulaNode):boolean;
var vlType : TType;
	vlNode2 : TFormulaNode;
begin
	vlType := ParNode.GetType;
	if parNode = nil then exit(false);
	if (vlType <> nil) and (ParType <> nil) then begin
		if not CheckConvertTest(ParType,vlType) then begin
			if ParNode.ConvertNodeType(ParType,ParCre,vlNode2) then begin
				if vlNode2 <> nil then begin
					ParNode.Destroy;
					ParNode := vlNode2;
				end;
				exit(false);
			end;
			exit(true);
		end;
	end;
	exit(false);
end;


function TOperatorNode.CheckConvertNode2(ParCre :TCreator;ParType :TType;var ParNode : TFormulaNode):boolean;
var vlType : TType;
	vlNode2 : TFormulaNode;
begin
	vlType := ParNode.GetType;
	if parNode = nil then exit(false);
	if (vlType <> nil) and (ParType <> nil) then begin
		if not CheckConvertTest(ParType,vlType) then begin
			if ParNode.ConvertNodeType(ParType,ParCre,vlNode2) then begin
				if vlNode2 <> nil then begin

					fParts.InsertAt(ParNode,vlNode2);
					fParts.CutOut(ParNode);
					ParNode.Destroy;
					ParNode := vlNode2;
				end;
				exit(false);
			end;
			exit(true);
		end;
	end;
	exit(false);
end;

procedure TOperatorNode.Get2SubNode(var ParFirst,ParSecond:TFormulaNode);
begin
	ParFirst := TFormulaNode(iParts.fStart);
	if ParFirst <> nil then begin
		ParSecond := TFormulaNode(ParFirst.fNxt)
	end else begin
		ParSecond := nil;
	end;
end;

function  TOperatorNode.DefaultNodeCheck : boolean;
begin
	exit(true);
end;

procedure TOperatorNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if DefaultNodeCheck then TOperatorNodeList(fParts).DefaultValidation(ParCre);
end;

procedure TOperatorNode.GetOperStr(var ParOper:string);
begin
	ParOper := '<unkown>';
end;

procedure TOperatorNode.InitParts;
begin
	iParts := TOperatorNodeList.create(nil);
end;

function  TOperatorNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
begin
	if ParOpt=MCO_Result then begin
		exit( iParts.CreateMac(ParOpt,ParCre));
	end else begin
		exit(inherited DoCreateMac(ParOpt,ParCre));
	end;
end;

procedure TOperatorNode.PrintNode(ParDis:TDisplay);
var
	vlStr  : string;
	vlName : string;
begin
	GetOperStr(vlStr);
	OperatorToDesc(vlStr,vlName);
	ParDis.print(['<operator><kind>',vlName,'</kind><operands>']);
	iParts.Print(ParDis);
	ParDis.print(['</operands></operator>']);
end;



function TOperatorNode.Can(ParCan:TCan_Types):boolean;
var vlCan:boolean;
begin
	vlCan := true;
	if (Can_Read in ParCan)then begin
		vlCan := TFormulaList(iParts).Can([Can_Read]);
		ParCan := PArCan - [CAN_Read];
	end;
	Can := vlCan and inherited Can(ParCan);
end;



function TOperatorNode.GetType:TType;
begin
	GetType :=TFormulaList(iParts).fFormType;
end;



{---( TBetweenNode )----------------------------------------------}


procedure TBetweenNode.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode  := IC_BetweenNode;
	iComplexity := CPX_Between;
end;

procedure   TBetweenNode.PrintNode(ParDis:TDisplay);
var vlPar :TNodeIdent;
begin
	vlPar := GetPArtByNum(1);
	ParDis.Writenl('<between>');
	ParDis.WriteNl('<ident>');
	if vlPar <> nil then vlPar.PrintNode(ParDis);
	ParDis.Nl;
	ParDis.Writenl('</ident>');
	ParDis.WriteNl('<low>');
	vlPar := TNodeIdent(vlPar.fNxt);
	if (vlPar <>nil) then vlPar.PrintNode(ParDis);
	ParDis.Nl;
	ParDis.Writenl('</low>');
	ParDis.WriteNl('<high>');
	vlPar := TNodeIdent(vlPar.fNxt);
	if (vlPar <>nil) then vlPar.PrintNode(ParDis);
	ParDis.Nl;
	ParDis.Writenl('</high>');
	ParDis.Writenl('</between>');
end;


function  TBetweenNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlPrvLabelTrue,vlPrvLabelFalse: TLabelPoc;
	vlLabelTrue,vlLabelFalse      : TLabelPoc;
	VLRESULT 			  : TMacBase;
begin
	if ParOpt <> MCO_Result then exit(inherited DoCreateMac(ParOpt,ParCre));

	vlPrvLabelTrue  := ParCre.fLabelTrue;
	vlPrvLabelFalse := ParCre.fLabelFalse;
	vlLabelTrue     := ParCre.CreateLabel;
	vlLabelFalse    := ParCre.CreateLabel;
	ParCre.SetLabelTrue(vlLabelTrue);
	ParCre.SetLabelFalse(vlLabelFalse);
	CreateSec(ParCre);
	vlResult := ParCre.ConvJumpToBool(GetTypeSize);
	ParCre.SetLabelTrue(vlPrvLabelTrue);
	ParCre.SetLabelFalse(vlPrvLabelFalse);
	exit(vlResult);
end;

function TBetweenNode.CreateSec(PArCre:TSecCreator):boolean;
var vlMac1         : TMacBase;
	vlMac2         : TMacBase;
	vlMac3         : TMacBase;
	vlMac4         : TMacBase;
	vlJmp          : TCondJumpPoc;
	vlJmp2         : TJumpPoc;
	vlLongResBEgin : TLOngResMetaPoc;
	vlLongResEnd   : TLongResMetaPoc;
	vlPar          : TFormulaNode;
	vlExp1         : TFormulaNode;
	vlExp2         : TFormulaNode;
	vlComp2        : TMacBase;
begin
	vlPar  := TFormulaNOde(GetPartByNum(1));
	vlExp1 := TFormulaNode(GetPartByNum(2));
	vlExp2 := TFormulaNode(GetPartByNum(3));
	vlLongResBegin := TLongResMetaPoc.create;
	vlLongResEnd   := TLongResMetaPoc.create;
	vlLongResBegin.fGroupEnd := vlLongResEnd;
	vlLongResEnd.fGroupBegin := vlLongResBegin;
	vlMac1 := vlPar.CreateMac(MCO_Result,ParCre);
	vlMac1 := vlLongResBegin.AddMac(ParCre,vlMac1);
	vlmac2 := vlExp1.CreateMac(MCO_Result,ParCre);
	PArCre.AddSec(vlLOngResBegin);
	vlMac3 := ParCre.MakeCompPoc(vlMac1,vlMac2,IC_Lower);
	vlJmp := TCondJumpPoc.create(true,vlMac3,ParCre.fLabelFalse);
	ParCre.AddSec(vlJmp);
	vlMac4  := vlExp2.CreateMac(MCO_Result,ParCre);
	vlComp2 := vlMac1;
	vlMac3 := ParCre.MakeCompPoc(vlComp2,vlMac4,IC_Bigger);
	vlJmp := TCondJumpPoc.create(True,vlMac3,ParCre.fLabelFalse);
	ParCre.AddSec(vlJmp);
	vljmp2 := TJumpPoc.create(ParCre.fLabelTrue);
	ParCre.AddSec(vlLongResEnd);
	ParCre.AddSec(vlJmp2);
	CreateSec := false;
end;

{----( TCompNode )--------------------------------------------}

procedure TCompNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlType1 : TType;
	vlfirst : TFormulaNode;
	vlSecond : TFormulaNode;
begin
	vlFirst := TFormulaNode(iParts.fStart);
	if vlFirst = nil then exit;
	vlSecond := TFormulaNode(vlFirst.fNxt);
	if vlSecond <> Nil then begin
		if vlSecond.IsLikeType(TClassType) or vlFirst.IsLikeType(TClassType) then begin
			if vlFirst.CanWriteWith(false,vlSecond) then exit;
			if vlSecond.CanWriteWith(false,vlFirst) then exit;
			TNDCreator(PArCre).AddNodeError(vlFirst,Err_Incompatible_Types,'');
		end;
		if vlFirst.IsLikeType(TRoutineType) or vlSecond.IsLikeType(TRoutineTYpe) then begin
			vlType1 :=vlFirst.GetOrgType;{TODO! Both vlFirst and vlSecond must be done}
			if (TRoutineType(vlType1).fOfObject) and not(iCompCode in [IC_Eq,IC_NotEq]) then begin
				TNDCreator(ParCre).AddNodeError(vlFirst,Err_Invalid_Operation,'');
			end;
		end;
		inherited ValidatePre(ParCre,ParIsSec);
	end;
end;

function TCompNode.CheckConvertTest(ParType1,ParType2 : TType) : boolean;
begin
	if inherited CheckConvertTest(ParType1,ParType2) then exit(true);
	if (parType1 is TClassType) or (ParType2 is TClassType) then begin
		if ParType1.CanWriteWith(false,ParType2) then exit(true);
		if ParType2.CanWriteWith(false,ParType1) then exit(true);
	end;
	exit(false);
end;


procedure TCompNode.Commonsetup;
begin
	inherited Commonsetup;
	iComplexity :=CPX_Comp;
end;

procedure TCompNode.InitParts;
begin
	iParts := TFormulaList.Create;
end;


procedure TCompNode.ValidateAfter(ParCre : TCreator);
var
	vlNode1 : TFormulaNode;
	vlNode2 : TFormulaNode;
	vlType1 : TType;
	vlType2 : TType;
begin
	inherited ValidateAfter(ParCre);
	Get2SubNode(vlNode1,vlNode2);
	if vlNode1 = nil then exit;
	vlType1 := vlNode1.GetType;
	if vlType1 = nil then exit;
	if vlNode2 = nil then exit;
	vlType2 := vlNode2.GetType;
	if vlType2 = nil then exit;
	vlNode1.ValidateConstant(ParCre,@vlType2.ValidateConstant);
	vlNode2.ValidateConstant(ParCre,@vlType1.ValidateConstant);
end;

function TCompNode.CreatePartSec(ParCre : TSecCreator;ParSecond : boolean): boolean;
var
	vlMac  : TMacBase;
	vlMac1 : TMacBase;
	vlMac2 : TMacBase;
	vlNode1 : TFormulaNode;
	vlNode2 : TFormulaNode;
	vlPoc  : TFormulaPoc;
	vlBig  : boolean;
	vlSSize : TSIze;
begin
	vlSSize := GetAssemblerInfo.GetSystemSize;
	vlNode1 := TFormulaNode(iParts.fStart);
	if vlNode1 = nil then exit(true);
	vlNode2 := TFormulaNode(vlNode1.fNxt);
	if vlNode2= nil then exit(true);
	if vlNode1.fComplexity > vlNode2.fComplexity then begin
		vlMac1 := vlNode1.CreateMac(MCO_Result,ParCre);
		vlMac2 := vlNode2.CreateMac(MCO_Result,ParCre);
	end else begin
		vlMac2 := vlNode2.CreateMac(MCO_Result,ParCre);
		vlMac1 := vlNode1.CreateMac(MCO_Result,ParCre);
	end;
	vlBig := false;
	if vlMac1.fSize > vlSSize then begin
		vlMac1.SetSize(vlSSize);
		vlMac2.SetSize(vlSSize);
		if ParSecond then begin
			vlMac1.AddExtraOffset(vlSSize);
			vlMac2.AddExtraOffset(vlSSize);
		end;
		vlBig := true;
	end;
	vlPoc := TCompFor.Create(iCompCode);
	ParCre.AddSec(vlPoc);
	vlPoc.SetVar(1,vlMac1);
	vlPoc.SetVar(2,vlMac2);
	vlMac := vlPoc.CalcOutputMac(ParCre);
	if vlBig and not (ParSecond) then begin
		ParCre.AddSec(TCondJumpPoc.Create(false,vlMac,ParCre.fLabelFalse));
	end else begin
		ParCre.MakeJumpFromCond(vlMac);
	end;
	exit(vlBig);
end;
function TCompNode.CreateSec(ParCre:TSecCreator):boolean;
begin
    if CreatePartSec(ParCre,false) then begin
		CreatePartSec(ParCre,true);
	end;
	exit(true);
end;

function TCompNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlLabelTrue  : TLabelPoc;
	vlLabelFalse : TLabelPoc ;
begin
	if ParOpt=MCO_Result then begin
		vlLabelTrue  := ParCre.fLabelTrue;
		vlLabelFalse := ParCre.fLabelFalse;
		ParCre.SetLabelTrue(PArCre.CreateLabel);
		ParCre.SetLabelFalse(ParCre.CreateLabel);
		CreateSec(ParCre);
		DoCreateMac := ParCre.ConvJumpToBool(GetTypeSize);
		ParCre.SetLabelTrue(vlLabelTrue);
		ParCre.SetLabelFalse(vlLabelFalse);
	end else begin
		DoCreateMac := inherited DoCreateMac(Paropt,parCre);
	end;
end;


constructor TCompNode.Create(ParCode : TIdentCode;ParBooleanType:TType);
begin
	iCOmpCode := ParCode;
	inherited Create(ParBooleanType);
	iIdentCode := IC_CompNode;
end;


procedure TCOmpNode.GetOperStr(var ParOper:String);
var vlTxt:pchar;
begin
	case iCompCode of
		IC_Bigger   :vlTxt := '>';
		IC_BiggerEq :vlTxt := '>=';
		IC_Lower    :vlTxt := '<';
		IC_LowerEq  :vlTxt := '<=';
		IC_Eq       :vlTxt := '=';
		IC_NotEq    :vlTxt := '<>';
		else         vlTxt := '??';
	end;
	ParOper := strpas(vlTxt);
end;





end.
