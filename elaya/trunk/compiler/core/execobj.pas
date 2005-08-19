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
	elatypes,pocobj,macobj,node,formbase,varbase,ndcreat,stdobj,asminfo,confval,useitem;

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
		procedure  clear;override;
	public
		constructor Create(parNum:TPointerCons);
		procedure  PrintNode(ParDis:TDisplay);override;
	end;

	TOperatorNode=class(TFormulaNode)
	protected
		function CheckCOnvertNode(ParCre : TCreator;ParType :TType;var ParNode : TFormulaNode):boolean;
		procedure PrintOperands(ParDis : TDisplay);virtual;
	public
		procedure GetOperStr(var ParOper:AnsiString);virtual;
		procedure PrintNode(ParDis:TDisplay);override;
		function  CheckConvertTest(ParType1,ParType2 : TType) : boolean;virtual;
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

	TSubListOperatorNode=class(TOperatorNode)
	private
		voParts	 :  TOperatorNodeList;
	protected
		property iParts : TOperatorNodeList read voParts write voParts;
		procedure InitParts;virtual;
		procedure clear;override;
		procedure commonsetup;override;
		function CheckCOnvertNode2(ParCre : TCreator;ParType :TType;var ParNode : TFormulaNode):boolean;
		procedure PrintOperands(ParDis : TDisplay);override;
	public
		property fParts     : TOperatorNodeList read voParts;

		procedure Proces(ParCre : TCreator);override;
		procedure Optimize(ParCre :TCreator);override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean); override;
		function  AddNode(const ParNode:TNodeIdent):boolean;
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList); override;
		procedure Get2SubNode(var ParFirst,ParSecond:TFormulaNode);
		function  DefaultNodeCheck : boolean;virtual;
		procedure Validateafter(ParCre : TCreator);override;
		function  GetType:TType;override;
		function  Can(ParCan:TCan_Types):boolean;override;
		function  GetPartByNum(ParNum:cardinal):TNodeIdent;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		function  Optimize1(ParCre : TCreator):boolean;override;
		procedure OptimizeCpx;override;
   end;

	TSingelOperatorNode=class(TOperatorNode)
	private
		voNode : TFormulaNode;
		voType : TType;
	protected
		property iType : TType        read voType write voType;
		property iNode : TFormulaNode read voNode write voNode;

		procedure Commonsetup;override;
		procedure clear;override;
	public
		constructor Create(ParNode : TFormulaNode);
		function GetType : TType;override;
		procedure proces(ParCre:TCreator);override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure ValidateAfter(ParCre : TCreator);override;
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList); override;
		procedure Optimize(ParCre : TCreator);override;
	end;
	TSingelOperatorNodeclass=class of TSingelOperatorNode;

	TArrayIndexNode=class(TSubListFormulaNode)
	private
		voNode : TFormulaNode;
	property iNode : TFormulaNode read voNode write voNode;
	protected
		procedure commonsetup;override;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		procedure Clear;override;

	public
		function GetType : TType;override;
		function  Can(ParCan:TCan_Types):boolean;override;
		procedure PrintNode(ParDis:TDisplay);override;
		procedure ValidateAfter(ParCre : TCreator);override;
		constructor Create(ParNode : TFormulaNode);
		procedure proces(ParCre:TCreator);override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList); override;
	end;

	TByPtrNode=class(TSingelOperatorNode)
	protected
		procedure commonsetup;override;
	public
		function  Can(ParCan:TCan_Types):boolean;override;
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList); override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure GetOperStr(var ParOper:AnsiString);override;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		function  IsOptUnsave:boolean;override;
	end;



	TBoolOperNode=class(TSublistOperatorNode)
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
		procedure   GetOperStr(var parOper:AnsiString);override;
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


	TDualOperNode=class(TSublistOperatorNode)
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
		procedure   GetOperStr(var ParOper:AnsiString);override;
	end;

	TShrNode=class(TOrdDualOperNode)
	protected
		procedure   commonsetup;override;

	public
		procedure   InitParts;override;
		procedure   GetOperStr(var ParOper:AnsiString);override;
	end;

	TShlNode=class(TOrdDualOperNode)
	protected
		procedure   commonsetup;override;

	public
		procedure   InitParts;override;
		procedure   GetOperStr(var ParOper:AnsiString);override;
	end;


	TDivNode=class(TOrdDualOperNode)
	protected
   		procedure   commonsetup;override;
	public
		procedure   InitParts;override;
		procedure   GetOperStr(var ParOper:AnsiString);override;
	end;

	TModNode=class(TOrdDualOperNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:AnsiString);override;
		procedure InitParts;override;

	end;



	TLogicNode=class(TSublistOperatorNode)
	protected
		function DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
	public
		procedure ValidateAfter(ParCre : TCreator);override;
	end;

	TNotNode=class(TSingelOperatorNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:AnsiString);override;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
		procedure PrintNode(ParDis:TDisplay);override;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
	end;

	TNegNode=class(TSingelOperatorNode)
	protected
		procedure commonsetup;override;

	public
		function  GetReplace(ParCre:TCreator):TNodeIdent;override;
		procedure Proces(ParCre :TCreator);override;
		procedure GetOperStr(var ParOper:AnsiString);override;
		function  DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
	end;


	TAndNode = class(TLogicNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:AnsiString);override;
		procedure InitParts;override;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
	end;


	TOrNode= class(TLogicNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:AnsiString);override;
		procedure InitParts;override;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
	end;

	TXorNode=class(TLogicNode)
	protected
		procedure commonsetup;override;

	public
		procedure GetOperStr(var ParOper:AnsiString);override;
		procedure InitParts;override;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
		function  DoCreateMac(ParOpt:TMacCreateOption;parCre:TSecCreator):TMacBase;override;
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

	TSizeOfNode=class(TSingelOperatorNode)
	protected
		procedure   commonsetup;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public
		procedure   GetOperStr(var ParOper:AnsiString);override;
		function    Can(ParCan:TCan_Types):boolean;override;
		procedure   proces(ParCre:TCreator);override;
		function    GetType:TType;override;
		function    GetValue:TValue;override;
		function    IsConstant : boolean;override;
		procedure   ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList) ;override;
		procedure   ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
	end;

	TValuePointerNode=class(TSingelOperatorNode)
	protected
		procedure   commonsetup;override;
		procedure   clear;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public

		procedure GetOperStr(var ParOper:AnsiString);override;
		function    Can(ParCan:TCan_Types):boolean;override;
		procedure  proces(ParCre:TCreator);override;
		function    GetValue:TValue;override;
		function    IsConstant : boolean;override;
	end;


	TObjectPointerNode=class(TSingelOperatorNode)
	protected
		procedure commonsetup;override;
		procedure Clear;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public

		procedure  proces(ParCre:TCreator);override;
		procedure GetOperStr(var ParOper:AnsiString);override;
		function    Can(ParCan:TCan_Types):boolean;override;
		constructor Create(ParNode : TFormulaNode;ParType :TType);

		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList); override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure ValidateAfter(ParCre : TCreator);override;
	end;

	TTypeNode=class(TSingelOperatorNode)
	protected
		procedure   Commonsetup;override;
		function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;

	public
		function   IsOptUnsave:boolean;override;
		constructor Create(parTYpe:TType;ParNode : TFormulaNode);
		function    Can(ParCan:TCan_Types):boolean;override;
		procedure   ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure   PrintNode(ParDis:TDIsplay);override;
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
		procedure  GetName(var ParName : AnsiString);
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

{---( TSingelOperatorNode )------------------------------------------------------}



procedure TSingelOperatorNode.Optimize(ParCre : TCreator);
begin
	if iNode <> nil then iNode.Optimize(ParCre);
	inherited Optimize(ParCre);
end;

function TSingelOperatorNode.GetType : TType;
begin
	exit(iType);
end;

procedure TSingelOperatorNode.commonsetup;
begin
	inherited Commonsetup;
	if iNode <> nil then begin
		iType := iNode.GetType;
	end else begin
		iType :=  nil;
	end;
end;

procedure TSingelOperatorNode.Clear;
begin
	inherited Clear;
	if iNode <> nil then iNode.Destroy;
end;

constructor TSingelOperatorNode.Create(ParNode : TFormulaNode);
begin
	iNode := ParNode;
	inherited Create;
end;

procedure TSingelOperatorNode.proces(ParCre:TCreator);
begin
	inherited Proces(ParCre);
	if iNode <> nil then iNode.Proces(ParCre);
end;

procedure TSingelOperatorNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if iNode <> nil then begin
		iNode.ValidatePre(ParCre,false);
		if not iNode.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(self,Err_Cant_Read_From_Expr,'zz');
		if iNode.GetSize = 0 then TNDCreator(ParCre).AddNodeError(self,Err_Cant_Determine_Size,'');
	end;

end;

procedure TSingelOperatorNode.ValidateAfter(ParCre : TCreator);
begin
	inherited ValidateAfter(ParCre);
	if iNode <> nil then iNode.ValidateAfter(ParCre);
end;

procedure TSingelOperatorNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
begin
	inherited ValidateFormulaDefinitionUse(ParCre,ParMode,ParUseList);
	if iNode <> nil then iNode.ValidateFormulaDefinitionUse(ParCre,ParMode,ParUseList);{TODO=>ParMode}
end;


{---( TClassTypeNode )------------------------------------------------------------}

procedure TClassTypeNode.InitDotFrame(ParCre : TSecCreator);
var                {TODO:InitDotFrame/DoneDotFrame differs}
	vlType : TTYpe;
begin

	if iNode <> nil then begin
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
	if iNode<> nil then begin
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
	vlText : AnsiString;
begin
	vlText := TStringCons(fVariable).GetString;
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
		if(vlType  is TCharType) and (vlType.fSize= 1) and (TStringCons(fVariable).GetLength = 1) then exit(true);
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
	if (vlType is TCharType) and (ParType.fSize=1) and (TStringCons(fVariable).GetLength=1) then exit(true);
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
	vlArr  := TArrayIndexNode.Create(vlNode);
	vlArr.AddNode(TNDCreator(ParCre).CreateIntNodeLong(1));
	vlVoidType := TNDCReator(ParCre).GetCheckDefaultType(DT_Void,0,false,'void');
	vlVoid     := TTypeNode.Create(vlVoidType,vlArr);
	exit(vlVoid);
end;

begin
	if ParType <> nil then begin
		vlType := ParType.GetOrgType;
		if (vlType is TCharType) and (vlType.fSize = 1) then begin
			if  TStringCons(fVariable).GetLength = 1 then begin
				ParNode := TConstantValueNode.Create(TString.Create(TStringCons(fVariable).getString),ParType);
				exit(true);
			end;
		end else if (vlType is TAsciizType) then begin

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
	ParDis.print(['<value>',StringToXml(TStringCons(fVariable).GetString),'</value>']);

end;


{----( TLabelNode )--------------------------------------------------------}

procedure TLabelNode.GetName(var ParName : AnsiString);
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
var vlName : AnsiString;
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


procedure TArrayIndexNode.Clear;
begin
	if iNode <> nil then iNode.Destroy;
	inherited Clear;
end;

constructor TArrayIndexNode.Create(ParNode : TFormulaNode);
begin
	iNode := ParNode;
	inherited Create;
end;

procedure TArrayIndexNode.proces(ParCre:TCreator);
begin
	if iNode <> nil then iNode.Proces(ParCre);
	inherited Proces(ParCre);
end;

procedure TArrayIndexNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	if iNode <> nil then iNode.ValidatePre(ParCre,ParIsSec);
	inherited ValidatePre(ParCre,ParIsSec);
end;

procedure TArrayIndexNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
begin
	if iNode <> nil then iNode.ValidateFormulaDefinitionUse(ParCre,AM_Read,PArUSeList);
	inherited ValidateFormulaDefinitionUse(ParCre,ParMode,ParUseList);
end;


function  TArrayIndexNode.Can(ParCan:TCan_Types):boolean;
var
	vlCan : TCan_Types;
	vlType : TType;
begin
	vlCan := ParCan * [Can_Size,Can_Dot];
	if vlCan <> [] then begin
		vlType := GetType;
		if (vlType  <> nil) then begin
			if not vlType.Can(vlCan) then exit(false);
		end;
		ParCan := ParCan - vlCan;
	end;
	if iNode <> nil then begin
		exit(iNode.Can(ParCan));
	end else begin
		exit(false);
	end;
end;

procedure TArrayIndexNode.commonsetup;
begin
	inherited Commonsetup;
	iCOmplexity := CPX_Array;
end;

function TArrayIndexNode.GetType:TType;
var
	vlType    : TType;
	vlCurrent : TNOdeIdent;
begin
	vlType := nil;
	if iNode <> nil then begin
		vlCurrent := iParts.fStart as TNodeIdent;
		vlType := iNode.GetOrgType;
		while(vlCurrent <> nil) and (vlType <> nil) do begin
			if (vlType is TSecType) and (vlType.can([Can_Index]))  then begin
				vlType := TSecType(vlType).GetOrgSecType;
			end else begin
				vlType := nil;
				break;
			end;
			vlCurrent := (vlCurrent.fNxt) as TNodeIdent;
		end;
	end;
	exit(vlType);
end;

procedure TArrayIndexNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.WriteNl('<arrayindex>');
	ParDis.writeNl('<base>');
	PrintIdent(ParDis,iNode);
	ParDis.Writenl('</base><index>');
	iParts.Print(ParDis);
	ParDis.Write('</index></arrayindex>');
end;

{TODO Remove IsLike ,orgtype @TArrayType(vlType).validateIndex}
procedure TArrayIndexNode.ValidateAfter(ParCre : TCreator);
var
	vlCurrent : TFormulaNode;
	vlType    : TType;
	vlNode : TFormulaNode;
   vlErr  : boolean;
begin

	inherited ValidateAfter(ParCre);
	vlErr := false;
	if iNode <> nil then begin
	vlType := iNode.GetOrgType;
	vlNode := (fParts.fStart) as TFormulaNode;
		while (vlNode <> nil) do begin
			if vlType <>nil then begin
				vlErr :=not( vlType.Can([Can_Index]));
			end else begin
				vlErr := true;
				vlType := nil;
			end;
			if vlErr then  TNDCreator(ParCre).AddNodeDefError(iNode,err_Cant_Array_Index_type,vlType);
			if vlType is TSecType then vlType := TSecType(vlType).GetOrgSecType;
			if not vlNode.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(vlNode,Err_Cant_Read_From_Expr,'');
			if not vlNode.IsCompByIdentCode(IC_Number) then  TNDCreator(ParCre).AddNodeDefError(vlNode,Err_Integer_Type_Expr_Exp,vlNode.GetType);
			vlNode := (vlNode.fNxt) as TFormulaNode;
		end;
		vlCurrent := TFormulaNode(iParts.fStart);
		vlType := iNode.GetType;
		if vlType <> nil then vlType :=vlType.GetOrgType;
		if iNode.IsLikeType(TArrayType) then begin
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
end;

{
	Create Mac from an Array Node.
}

function TArrayIndexNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
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
	vlType   : TType;
begin
	if ParOpt=MCO_Size then exit( inherited DoCreateMac(MCO_Size,ParCre));
	LoadLOng(vlNumOfs, 0);
	vlBaseType    := iNode.GetORGType;
	if vlBaseType = nil then exit;
	vlNode    := TFormulaNode(iParts.fStart);
	if vlBaseType.IsLike(TArrayType) then begin
		vlSize    := 0;
		vlOut     := nil;
		vlCurrent := TArrayType(vlBaseType);
		while vlNode <> nil do begin
			vlMin := vlCurrent.fLo;
			vlDim := vlCurrent.fHi;
			LargeSub(vlDim,vlMin);
			{TODO rename Num out of range wrong =>Offset out of range?}
			if LargeAddInt(vlDIm,1)     then ParCre.AddNodeError(vlNode,Err_Num_Out_Of_range,'');
			if LargeMul(vlNumOfs,vlDim) then ParCre.AddNodeError(vlNode,Err_Num_Out_Of_range,'');
			if  (vlOut <> nil)          then vlOut := ParCre.MakeMulPoc(vlOut,vlDim);
			vlMac := vlNode.CreateMac(MCO_Result,ParCre);
			if vlMac is TNumberMac then begin
				if LargeAdd(vlNumOfs ,TNumberMac(vlMac).fInt) then ParCre.AddNodeError(vlNode,Err_Num_Out_Of_range,'3');
			end else begin
				if vlOut <> nil then begin
					vlOut := ParCre.MakeAddPoc(vlOut,vlMac)
				end else begin
					vlOut := vlMac;
				end;
			end;
			LargeSub(vlNumOFs,vlMin);
			vlNode := TFormulaNode(vlNode.fNxt);
			vlType := vlCurrent.GetOrgSecType;
			if vlType is TArrayType then vlCurrent := TArrayType(vlType);
		end;
	end else begin
		vlOut   := vlNode.CreateMac(MCO_Result,ParCre);
		if (vlOut is TNumberMac) then begin
			vlNumOfs :=TNumberMac( vlOut).fInt;;
			vlOut := nil;
		end;
	end;
	vlType := GetType;
	if vlType <> nil then begin
		vlSize := vlType.fSize;
		LoadLong(vlLi,vlSize);
		if LargeMul(vlNumOfs,vlLi) then ParCre.AddNodeError(iNode,Err_Num_out_of_Range,'');
		if(vlOut <>nil) and (vlSize <> 1) then begin
			vlMac := PArCre.CreateNumberMac(GetAssemblerInfo.GetSystemSize,false,vlLi);
			vlOut := ParCre.MakeMulPoc(vlOut,vlMac);
		end;
	end;
	if vlBaseType is TStringBase then begin
		if LargeAddInt(vlNumOfs, TStringBase(vlBaseType).GetFirstOffset) then ParCre.AddNodeError(vlNode,Err_Num_Out_Of_range,'4');
		LargeSubLong(vlNumOfs,GetTypeSize);
	end;
	if vlOut = nil then begin
		vlOut := iNode.CreateMac(MCO_Result,ParCre);
		vlOut.SetSize(GetTypeSize);
		vlOut.SetSign(vlType.GetSign);
		vlOut.AddExtraOffset(LargeToLongInt(vlNumOfs));

		if (ParOpt in [MCO_ValuePointer,MCO_ObjectPointer]) then begin
			vlOut := TMemOfsMac.Create(vlOut);
			ParCre.AddObject(vlOut);
		end;
	end else begin
		vlPtr := iNode.CreateMac(MCO_ValuePointer,ParCre);
		if vlOut <> nil then 	vlPtr := ParCre.MakeAddPoc(vlOut,vlPtr);
		if ParOpt=MCO_Result then begin
			vlOut := TByPointerMac.create(GetTypeSize,vlType.GetSign,vlPtr);
			ParCre.AddObject(vlOut);
			TByPointerMac(vlOut).AddExtraOffset(LargeToLongint(vlNumOfs));
		end else begin
			vlOut := ParCre.MakeAddPoc(vlPtr,LargeToLongint(vlNumOfs));
		end;
	end;
	exit(vlOut);
end;


{---(TTypeNode )------------------------------------------------------------------}

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
	PrintIdent(ParDis,iNode);
	ParDis.Write('</expression>');
	ParDis.Write('</typeuse>');
end;

function TTypeNode.Can(ParCan:TCan_Types):boolean;
begin
	Can := true;
	if CAN_Dot in ParCan then begin
		if (iType <> nil) and (iType.Can([Can_Dot])) then ParCan := ParCan - [Can_Dot];
	end;
	if iNode = nil then begin
		Can    := (ParCan - [Can_Size,Can_Type])= [];
	end else if ParCan <> [] then  begin
		Can := iNode.Can(ParCan);
	end;
end;

procedure TTypeNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlExtra : AnsiString;
begin
	if iNode <> nil then begin
		iNode.ValidatePre(ParCre,false);
		if(ParIsSec) and not(CanSec) then TNDCreator(ParCre).AddNodeError(self,ERR_Cant_Execute,classname);{TODO:Something better}
		if not iNode.Can([Can_Read])  then TNDCreator(ParCre).AddNodeError(iNode,Err_Cant_Read_From_Expr,'');
		if iType <> nil then begin
			if not  iNode.CanCastTo(GetType) then begin
				iNode.GetTypeName(vlExtra);
				vlExtra := vlExtra +' to ' + iType.GetErrorName;
				TNDCreator(ParCre).ErrorText(Err_Cant_Cast_To_This_Type,vlExtra);
			end;
		end;
	end;
end;

constructor TTypeNode.Create(parTYpe:TType;ParNode : TFormulaNode);
begin
	inherited Create(ParNode);
	iType := ParType;
end;

function  TTypeNode.IsOptUnsave:boolean;
begin
	if iNode <> nil then begin
		exit(iNode.IsOptUnsave);
	end else begin
		exit(False);
	end;
end;

function    TTypeNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlMac : TMacBase;
	vlLd  : TPocBase;
	vlMac2: TMacBase;
	vlLi  : TLargeNumber;
	vlMask: cardinal;
	vlSize :TSize;
begin
	if (iNode = nil) or (ParOpt=MCO_Size) then begin
		if ParOpt = MCO_SIZE then begin
			LoadLOng(vlLi,GetTypeSize);
			DoCreateMac := ParCre.CreateNumberMac(0,false,vlLi)
		end else begin
			fatal(FAT_Cant_Create_Mac_type,'Mac option = '+IntToStr(cardinal(ParOpt)));
		end;
	end else begin
		vlSize := GetTypeSize;
		vlMac := iNode.CreateMac(ParOpt,parCre);
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
	iIdentCode := (IC_TypeNode);
	iComplexity := CPX_Constant;{Should set to subnode complexity}
end;


{---( TSizeOfNode )----------------------------------------------------------------}


procedure TSizeOfNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	if iNode <> nil then begin
		iNode.ValidatePre(parCre,false);{TODO sec check}
		if not iNode.Can([Can_Size]) then TNDCreator(ParCre).AddNodeError(Self,Err_Cant_Determine_Size,'');
		if(ParIsSec) and not(CanSec) then TNDCreator(ParCre).AddNodeError(self,ERR_Cant_Execute,classname);{TODO:Something better}
	end;
end;

function   TSizeOfNode.Can(ParCan:TCan_Types):boolean;
begin
	 exit( (ParCan - [CAN_Read]) = []);
end;


procedure   TSizeOfNode.CommonSetup;
begin
	inherited CommonSetup;
	iType     := nil;
	iCOmplexity := CPX_Constant;
end;

procedure TSizeOfNode.GetOperStr(var ParOper:AnsiString);
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
	vlNode := iNode;
	if vlNode <> nil then vlValue := TLongint.Create(vlNode.GetSize);
	exit(vlValue);
end;


procedure  TSizeOfNode.proces(ParCre:TCreator);
begin
	inherited Proces(ParCre);
	if iType <> nil then exit;
	if iNode = nil then exit;
	iType := TNDCreator(PArCre).GetDefaultIDent(DT_Number,GetAssemblerInfo.GetSystemSize,false);
	if iType = nil then TNDCreator(ParCre).AddNodeError(iNode,Err_Cant_Find_type,'number');
	{TODO replace GetDefaulIdent by GetCheckDefaultIdent}
end;


procedure TSizeOfNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
begin
	iNode.ValidateDefinitionUse(ParCre,AM_Nothing,ParUseList);
end;


function    TSizeOfNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
begin
	if ParOpt = MCO_Result then begin
		if iNode <> nil then begin
			exit(iNode.CreateMac(MCO_Size,ParCre));
		end else begin
			fatal(FAT_Node_Is_NULL,'');
		end;
	end;
	exit(inherited CreateMac(ParOpt,ParCre));
end;




{---( TValuePointerNode )----------------------------------------------------------------}

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

procedure TValuePointerNode.GetOperStr(var ParOper:AnsiString);
begin
	 ParOper := 'VALUE POINTER';
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
	vlName  : AnsiString;
begin
	inherited Proces(ParCre);
	if iType <> nil then exit;
	vlType := nil;
	if iNode is TCallNode then begin
		if TCallNode(iNode).fParCnt <> 0 then TNDCreator(ParCre).AddNodeError(iNode,Err_No_Parameters_Expected,'');
		if TCallNode(iNode).IsOverloaded  then TNDCreator(ParCre).AddNodeError(iNode,Err_Cant_Adr_Overl,'');
		vlType := TRoutineType.create(false,TCallNode(iNode).fRoutineItem,false);
		vlName := TCallNode(iNode).fName;
		vlType.SetText('Ptr to '+vlName);{TODO Check if there is a messup of MCO_VALUEPOINTER or MCO_OBJECTPOINTER}
	end else begin
		vlType := iNode.GetType;
		if not iNode.Can([CAN_Pointer]) then TNDCreator(ParCre).AddNodeError(iNode,Err_Cant_Get_Expr_Pointer,'');
		if vlType = nil then begin
			vlName  := 'Unkown Type';
		end else begin
			vlName := vlType.fText;
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
		MCO_Result : vlMac := iNode.CreateMac(MCO_ObjectPointer,ParCre);
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


procedure TObjectPointerNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	if iNode <> nil then begin
		iNode.ValidatePre(parCre,false);{TODO sec check}
		if(ParIsSec) and not(CanSec) then TNDCreator(ParCre).AddNodeError(self,ERR_Cant_Execute,classname);{TODO:Something better}
	end;
end;

procedure TObjectPointerNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
begin
	inherited ValidateFormulaDefinitionUse(ParCre,ParMode,ParUseList);
	iNode.ValidateFormulaDefinitionUse(ParCre,AM_PointerOf,ParUseList); {TODO is also called in inherited}
end;


procedure TObjectPointerNode.ValidateAfter(ParCre : TCreator);
begin
	inherited ValidateAfter(ParCre);
	if iNode <> nil then begin
		if not iNode.Can([Can_Pointer]) then TNDCreator(ParCre).AddNodeError(iNode,Err_Cant_Get_Expr_Pointer,'');
	end;
end;

procedure TObjectPointerNode.Proces(ParCre : TCreator);
var
	vlName : AnsiString;
begin
	inherited Proces(ParCre);
	if iNode <> nil then begin
		if iType = nil then begin{TODO: Temp hack.... can't use this for all expression because of TRoutineType}
			iNode.GetTypeName(vlName);
			iType := TPtrType.Create(iNode.GetTYpe,false);
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

procedure TObjectPointerNode.GetOperStr(var ParOper:AnsiString);
begin
	ParOper := 'OBJECT POINTER';
end;


constructor TObjectPointerNode.Create(ParNode : TFormulaNode;ParTYpe : TType);
begin
	inherited Create(ParNode);
	iType := ParType;
end;

function    TObjectPointerNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
begin
	exit(iNode.CreateMac(MCO_ObjectPOinter,ParCre));
end;


procedure TObjectPointerNode.Clear;
begin
	inherited Clear;
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
var
	vlValueStr : ansistring;
begin
	ParDisplay.write('<value>');
	if iValue <> nil then begin
		ivalue.GetAsString(vlValueStr);
		 ParDisplay.Print([stringToXml(vlValueStr)]);
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
var     vlCurrent      : TFormulaNode;
	vlHasOptimized : boolean;
	vlResult       : TNumber;
	vlNxt          : TFormulaNode;
	vlNum          : TNumber;
	vlValue        : TValue;
	vlOpt          : boolean;
	vlCan          : boolean;
	vlFound        : cardinal;
	vlPos          : cardinal;
begin
	vlCurrent := TFormulaNode(fStart);
	if (vlCurrent <> nil) and (vlCurrent.fNxt = nil) then begin
		vlOpt := false;
		if not vlCurrent.fCanDelete then vlOpt := vlCurrent.Optimize1(ParCre);
		if inherited Optimize1(ParCre) then vlOpt := true;
		exit(vlOpt);
	end;
	vlHasOptimized := false;
	vlCan    := false;
	if CanOptimize1 then vlCan := CheckOptimize1Method;
	vlFound  := 0;
	vlPos    := 0;
	GetFirstValue(vlResult);
	if inherited Optimize1(ParCre) then vlHasOptimized  := true;
	if vlCan then begin
		while vlCurrent<> nil do begin
			inc(vlPos);
			vlNxt := TFormulaNode(vlCurrent.fNxt);
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


procedure TLogicNode.ValidateAfter(ParCre : TCreator);
var
	vlNode : TFormulaNode;
begin
	inherited ValidateAfter(ParCre);
	vlNode := TFormulaNode(fParts.fStart);
    if vlNode <> nil then begin
		if  not (vlNode.IsCompByIdentCode(IC_Number)  or vlNode.IsLikeType(TBooleanType)) then begin
			TNDCreator(ParCre).AddNodeDefError(vlNode,Err_Wrong_Type,vlNode.GetType);
		end;
		vlNode := TFOrmulaNode(vlNode.fNxt);
		while vlNode <> nil do begin
			if not IsDirectComp(vlNode) then begin
				TNDCreator(ParCre).AddNodeDefError(vlNode,Err_Wrong_Type,vlNode.GetType);
			end;
			vlNode := TFormulaNode(vlNode.fNxt);
		end;
	end;
end;

{---( TNotNode )--------------------------------------------------}

procedure TNotNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if iNode <> nil then begin
		if not (iNode.IsLikeType(TNumberType) or iNode.isLikeTYpe(TBooleanType)) then TNDCreator(ParCre).AddNodeDefError(iNode,Err_Wrong_Type,iNode.GetType);
	end;
end;


procedure TNotNode.GetOperStr(var ParOper:AnsiString);
begin
	ParOper := 'NOT';
end;


procedure TNotNode.CommonSetup;
begin
	inherited COmmonSetup;
	iIdentCode  := IC_NotNode;
	iComplexity := CPX_Not;
end;

function TNotNode.CreateSec(ParCre:TSecCreator):boolean;
begin
	ParCre.SwapLabels;
	iNode.CreateSec(ParCre);
	ParCre.SwapLabels;
	CreateSec := false;
end;

procedure TNotNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.writenl('<not>');
	iNode.print(ParDis);
	ParDis.writenl('</not>');
end;


function TNotNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlNotFor:TNotFor;
	vlMac   :TMacBase;
begin
	case ParOpt of
		MCO_Result:begin
			vlNotfor := TNotFor.create;
			vlNotfor.SetVar(1,iNode.CreateMac(ParOpt,Parcre));
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
	iParts.CreateSec(ParCre);
	exit(false);
end;


procedure TAndNode.GetOperStr(var PArOper:AnsiString);
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
	iParts.CreateSec(ParCre);
	CreateSec := false;
end;


procedure TOrNode.initParts;
begin
	iParts := TLogicList.create(TOrFor,true);
end;


procedure TOrNode.GetOperStr(Var ParOper:AnsiString);
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


procedure TXorNode.GetOperStr(var ParOper:AnsiString);
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

procedure TPointerNode.Clear;
begin
	inherited clear;
	fVariable.Destroy;
end;


procedure TPointerNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_NumNode;
	iCOmplexity := CPX_Pointer;
end;


procedure TPointerNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.Write('<pointer>');
	if fVariable <> nil then begin
		ParDis.Write(fVariable.fText);
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

procedure TModNode.GetOPerStr(var ParOper:AnsiString);
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

procedure TDivNode.GetOPerStr(var ParOper:AnsiString);
begin
	ParOper := '/';
end;



{--------( TnegNode )-------------------------------------------}


procedure TNegNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if iNode <> nil then begin
		if not iNode.IsCompByIdentCode(IC_Number) then TNDCreator(ParCre).AddNodeDefError(iNode,Err_Wrong_Type,iNode.GetType);
	end;
end;


function  TNegNode.GetReplace(ParCre:TCreator):TNodeIdent;
var vlValue : TValue;
	vlNum   : TNumber;
	vlType  : TType;
begin
	if iNode <> nil then begin
		vlValue := iNode.GetValue;
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
var
	vlType    : TType;
	vlNewNode : TLoadConvert;
begin
	inherited Proces(ParCre);
	if (iNode <> Nil) then begin
		iType := iNode.GetType;
		if iType <> nil then begin
			if not  iType.GetSign then begin
				vlType := TNDCreator(ParCre).GetDefaultIdent(DT_Number,iType.fSize * 2,true);
				if vlType <> nil then begin
					iType := vlType;
					vlNewNode := TLoadConvert.Create(iType);
					vlNewNode.SetPosToNode(self);
					vlNewNode.AddNode(iNode);
					iNode := vlNewNode;
				end;
			end
		end;
	end;
end;


procedure TNegNode.GetOperStr(var ParOper:AnsiString);
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
			vLnegfor.SetVar(1,iNode.CreateMac(ParOpt,Parcre));
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

Procedure TShrNode.GetOperStr(var ParOper : AnsiString);
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

Procedure TShlNode.GetOperStr(var ParOper : AnsiString);
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

procedure TMulNode.GetOperStr(var ParOper:AnsiString);
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
		if not(vlNode.IsCompByIdentCode(IC_Number)) then begin
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


procedure TByPtrNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
begin
	iNode.ValidateFormulaDefinitionUse(ParCre,AM_Read,ParUseList);
end;


function TByPtrNode.IsOptUnsave:boolean;
begin
	exit(true);
end;


function TByPTrNode.Can(ParCan:TCan_Types):boolean;
var
	vlType     : TType;
	vlFlags    : TCan_Types;
	vlDestType : TType;
begin
	vlFlags := ParCan * [CAN_Size, Can_Dot,Can_Type,Can_Execute,Can_Index];
	if vlFlags <> [] then begin
		vlDestType := GetOrgType;
		if (vlDestType = nil) or not(vlDestType.Can(vlFlags)) then exit(false);
		ParCan := ParCan - vlFlags;
	end;
	if Can_Write in ParCan then begin
		if(iNode <> nil) then begin
			vlType :=  iNode.GetOrgType;
			if(vlType <> nil) then begin
				if (vlType is TPtrType) then begin
					if not TPtrType(vltype).fConstFlag then ParCan := ParCan - [Can_Write];
				end;
			end;
		end;
	end;
	exit( inherited Can(ParCan - [CAN_Pointer]));
end;


procedure TByPtrNode.GetOperStr(var ParOper:AnsiString);
begin
	ParOper := 'ByPtr';
end;

procedure TByPtrNode.commonsetup;
var
	vlType : TType;
begin
	inherited Commonsetup;
	iIdentCode   := IC_ByPtrNode;
	iCOmplexity  := CPX_ByPointer;
	vlType  := nil;
	if iNode <> nil then begin
			vlType := iNode.GetOrgType;
			if (vlType <> nil) and (vlType is TPtrType) then begin
				vlType := TPtrType(vlType).fType;
			end else begin
				vlType := nil;
			end;
	end;
	iType := vlType;
end;

function TByPtrNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlMac  : TMacBase;
	vlType : TType;
	vlRef  : TMacBase;
	vlPtrType:TType;
begin
	case ParOpt of
	MCO_Result:begin
		vlType    := iNode.GetType;
		vlMac     := iNode.CreateMac(MCO_Result,ParCre);
		vlPtrType := TPtrTYpe(vltype).fType;
		vlRef     := TByPointerMac.create(vlPtrType.fSize,vlPtrType.GetSign,vlMac);
		ParCre.AddObject(vlRef);
		DoCreateMac := vlRef;
	end;
	MCO_ValuePointer,MCO_ObjectPointer:DoCreateMac := iNode.CreateMac(MCO_Result,ParCre);
	else DoCreateMac := inherited DoCreateMac(ParOpt,ParCre);
end;
end;

procedure TByPTrNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlType : TType;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if iNode <>nil then begin
		vlType := iNode.GetOrgType;
		if not iNode.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(iNode,Err_Cant_read_from_expr,'');
		if vlType <> nil then begin
			if not (vlType is TPtrType) then begin
				TNDCreator(ParCre).AddNodeDefError(iNode,Err_Not_A_Pointer_Type,iNode.GetType);
			end  else  begin
				if TPtrType(vlType).GetSecSize = 0 then TNDCreator(PArCre).AddNodeDefError(iNode,Err_Cant_Determine_Size,iNode.GetType);
			end;
		end;
	end;
end;


{---( TSubListOperatorNode )-------------------------------------}


	procedure TSubListOperatorNode.OptimizeCpx;
	begin
		DetermenComplexity;
		if om_complexity in TFormulaList(iParts).fOptimizeMethods then TFormulaList(iParts).OptimizeCpx;
	end;


	function TSublistOperatorNode.Optimize1(ParCre : TCreator):boolean;
	var
		vlOpt : boolean;
	begin
		vlOpt := iParts.Optimize1(ParCre);
		if inherited Optimize1(ParCre) then vlOpt := true;
		exit(vlOpt);
	end;


procedure TSubListOperatorNode.COmmonsetup;
begin
	InitParts;
	inherited Commonsetup;
end;

procedure TSubListOperatorNode.Clear;
begin
	if iParts <> nil then iParts.Destroy;
	inherited Clear;
end;

procedure TSublistOperatorNode.Proces(ParCre : TCreator);
begin
	fParts.Proces(ParCre);
	inherited Proces(ParCre);
end;

procedure TSublistOperatorNode.Optimize(ParCre :TCreator);
begin
	iParts.Optimize(ParCre);
	inherited Optimize(ParCre);
	iParts.Proces(ParCre);
end;

procedure TSublistOperatorNode.ValidateAfter(ParCre : TCreator);
begin
	iParts.ValidateAfter(ParCre);
end;

function  TSubListOperatorNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
begin
	if ParOpt=MCO_Result then begin
		exit( iParts.CreateMac(ParOpt,ParCre));
	end else begin
		exit(inherited DoCreateMac(ParOpt,ParCre));
	end;
end;


function TSubListOperatorNode.GetPartByNum(ParNum:cardinal):TNodeIdent;
begin
	exit(TNodeIdent(iParts.GetItemByNum(ParNum)));
end;

function TSubListOperatorNode.AddNode(const ParNode : TNodeIdent):boolean;
begin
	iParts.insertAtTop(ParNode);
	exit(false);
end;

procedure TSublistOperatorNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
begin
	iParts.ValidateDefinitionUse(ParCre,AM_Read,ParUseList);
end;

function TSubListOperatorNode.CheckConvertNode2(ParCre :TCreator;ParType :TType;var ParNode : TFormulaNode):boolean;
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

procedure TSublistOperatorNode.Get2SubNode(var ParFirst,ParSecond:TFormulaNode);
begin
	ParFirst := TFormulaNode(iParts.fStart);
	if ParFirst <> nil then begin
		ParSecond := TFormulaNode(ParFirst.fNxt)
	end else begin
		ParSecond := nil;
	end;
end;


function  TSubListOperatorNode.DefaultNodeCheck : boolean;
begin
	exit(true);
end;

procedure TSubListOperatorNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	fParts.ValidatePre(ParCre,false);
	inherited ValidatePre(ParCre,ParIsSec);
	if DefaultNodeCheck then TOperatorNodeList(fParts).DefaultValidation(ParCre);
end;

procedure TSubListOperatorNode.InitParts;
begin
	iParts := TOperatorNodeList.create(nil);
end;

procedure TSubListOperatorNode.PrintOperands(ParDis : TDisplay);
begin
	iParts.Print(ParDis);
end;

function TSubListOperatorNode.Can(ParCan:TCan_Types):boolean;
var vlCan:boolean;
begin
	vlCan := true;
	if (Can_Read in ParCan)then begin
		vlCan := TFormulaList(iParts).Can([Can_Read]);
		ParCan := PArCan - [CAN_Read];
	end;
	Can := vlCan and inherited Can(ParCan);
end;



function TSublistOperatorNode.GetType:TType;
begin
	exit(TFormulaList(iParts).fFormType);
end;


{----( TOperatorNode )------------------------------------------}


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


procedure TOperatorNode.GetOperStr(var ParOper:AnsiString);
begin
	ParOper := '<unkown>';
end;



procedure TOperatorNode.PrintOperands(ParDis : TDisplay);
begin
end;

procedure TOperatorNode.PrintNode(ParDis:TDisplay);
var
	vlStr  : AnsiString;
	vlName : AnsiString;
begin
	GetOperStr(vlStr);
	OperatorToDesc(vlStr,vlName);
	ParDis.print(['<operator><kind>',vlName,'</kind><operands>']);
	PrintOperands(ParDis);
	ParDis.print(['</operands></operator>']);
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
	iParts := TOperatorNodeList.Create(TCompFor);
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


procedure TCOmpNode.GetOperStr(var ParOper:AnsiString);
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
