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

unit stmnodes;
interface
uses asminfo,elacons,types,stdobj, ddefinit,error, display,compbase,cmp_type,elatypes,pocobj,macobj,node,formbase,varbase,ndcreat,varuse,execobj,cblkbase;

type
	TExitNode=class(TNodeIdent)
	private
		voReturnType          : TType;
		voReturnInstruction   : TNodeIdent;
		property iReturnType  : TType            read voReturnType        write voReturnType;
		property iReturnInstruction : TNodeIDent read voReturnInstruction write voReturnInstruction;
	public
		
		constructor Create(ParReturnType : TType;ParReturnInstruction : TNodeIdent);
		function    CreateSec(ParCre : TSecCreator):boolean;override;
		procedure   PrintNode(ParDis : TDisplay);override;
		procedure   ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure  proces(ParCre:TCreator);override;
		procedure   ValidateAfter(parCre : TCreator);override;
		procedure   Optimize(ParCre:TCreator);override;
		procedure   clear;override;
	end;

	TLoopCBNode=class(TNodeIdent)
	private
		voBreakLabel    : TLabelPoc;
		voContinueLabel : TLabelPoc;
		property iBreakLabel    : TLabelPoc read voBreakLabel    write voBreakLabel;
		property iContinueLabel : TLabelPoc read voContinueLabel write voContinueLabel;
	protected
		function   OptimizeThisNode(ParCre : TCreator;ParNode : TFormulaNode):TFormulaNode;
		procedure Commonsetup;override;

	public

		function  GetBreakLabel : TLabelPoc;
		function  GetContinueLabel :TLabelPoc;
	end;


	TCountNode=class(TLoopCBNode)
	private
		voUp    : boolean;
		voCount : TFormulaNode;
		voBegin : TFormulaNode;
		voEnd   : TFormulaNode;
		voStep  : TFormulaNode;
		voEndCondition : TFormulaNode;
	protected
		property iUp    : boolean      read voUp    write voUp;
		property iCount : TFormulaNode read voCount write voCount;
		property iBegin : TFormulaNode read voBegin write voBegin;
		property iEnd   : TFormulaNode read voEnd   write voEnd;
		property iStep  : TFormulaNode read voStep  write voStep;
		property iEndCondition : TFormulaNode read voEndCondition write voEndCondition;
	protected
		procedure CheckNodeByType(ParCre : TCreator;ParType :TType ;ParCheck : TFormulaNode);
		procedure  commonsetup;override;

	public

		procedure  SetCount(ParCre:TNDCreator;parNode:TFormulaNode);
		procedure  SetBegin(ParCre:TNDCreator;ParNode:TFormulaNode);
		procedure  SetEnd(ParCre:TNDCreator;ParNode:TFormulaNode);
		procedure  SetStep(ParCre:TNDCreator;ParNode:TFormulaNode);
		procedure  SetEndCondition(ParCre : TNDCreator;ParNode : TFormulaNode);
		procedure  Setup(parUp:boolean);
		procedure  print(ParDis:TDisplay);override;
		function   CreateSec(parcre:TSecCreator):boolean;override;
		destructor destroy;override;
		procedure  Optimize(ParCre : TCreator);override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure Proces(ParCre : TCreator);override;
		procedure ValidateAfter(ParCre : TCreator);override;
	end;
	
	TConditionNode=class(TLoopCBNode)
	private
		voCond           : TFormulaNode;
		property iCond   : TFormulaNode read voCond write voCond;
	protected
		procedure  commonsetup;override;

	public
		property fCond : TFormulaNode read voCond;
		procedure  SetCond(ParCre :TNDCreator;ParCond:TFormulaNode);
		destructor destroy;override;
		procedure  Optimize(ParCre : TCreator);override;
		procedure  ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure  ValidateAfter(ParCre  : TCreator);override;
		procedure Proces(ParCre : TCreator);override;
		function  SetVarUseItem(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TVarUseList;var ParItem : TVarUseItem) : TAccessStatus;override;
	end;
	
	TWhileNode=class(TConditionNode)
	public
		function    CreateSec(ParCre:TSecCreator):boolean;override;
		procedure   PrintNode(ParDis:TDisplay);override;
	end;
	
	
	
	TRepeatNode=class(TConditionNode)
	public
		procedure   PrintNode(ParDis:TDisplay);override;
		function    CreateSec(ParCre:TSecCreator):boolean;override;
	end;
	
	TForNode = class(TConditionNode)
	private
		voEnd   :TFormulaNode;
		property   iEnd : TFormulaNode read voEnd write voEnd;
	protected
		procedure  commonsetup;override;

	public
		
		property   fEnd : TFormulaNode read voEnd;
		procedure  SetEnd(ParNode:TFormulaNode);
		procedure  SetBegin(ParCre:TNDCreator;parNode:TFormulaNode);
		destructor destroy;override;
		procedure  print(ParDis:TDisplay);override;
		function   CreateSec(ParCre:TSecCreator):boolean;override;
		procedure  Optimize(ParCre :TCreator);override;
		procedure  ValidateAfter(ParCre  : TCreator);override;
		procedure  ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure  Proces(ParCre : TCreator);override;
	end;


	TLoadNode=class(TOperatorNode)
	protected
		procedure Commonsetup;override;

	public
		procedure GetOperStr(var ParOper:string);override;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure ValidateAfter(ParCre : TCreator);override;
		function CheckConvertTest(ParType1,ParType2 : TType) : boolean;override;
		function  SetVarUseItem(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TVarUseList;var ParItem : TVarUseItem) : TAccessStatus;override;
		function  CanSec : boolean;override;
	end;


	
	
	TRefLoopFlowNode = class of TLoopFlowNode;

	TLoopFlowNode=class(TNodeIdent)
	private
		voLCBNode	: TLoopCBNode;
		property iLCBNode:TLoopCbNOde read voLCBNode write voLCBNode;
	protected
		property fLCBNode:TLoopCBNode read voLCBNode write voLCBNode;
	public
		constructor Create(ParNode:TLoopCbNode);
		function GetJumpLabel:TLabelPoc;virtual;
		function CreateSec(parCre:TSecCreator):boolean;override;
	end;
	
	
	TBreakNode = class(TLoopFlowNode)
	protected
		procedure Commonsetup;override;

	public
		function  GetJumpLabel:TLabelPoc;override;
		procedure Print(ParDIs:TDisplay);override;
	end;
	
	TContinueNode = class(TLoopFlowNode)
	protected
		procedure Commonsetup;override;

	public
		function  GetJumpLabel:TLabelPoc;override;
		procedure Print(ParDIs:TDisplay);override;
		
	end;


	TAsmNode=class(TNodeIdent)
	private
		voText : pointer;
		voSIze : cardinal;
		property iText:pointer read voText write voText;
		property iSize:cardinal read voSize write voSize;
	protected
		procedure   CommonSetup; override;
		procedure   clear;override;

	public
		constructor Create(ParSize : TSize;ParText:pointer);
		procedure   ResetText;
		procedure   print(ParDis:TDisplay);override;
		function    CreateSec(ParCre:TSecCreator):boolean;override;
	end;

	TLeaveNode=class(TNodeIdent)
	public
		function  CreateSec(ParCre:TSecCreator):boolean;override;
		procedure   PrintNode(ParDis:TDisplay);override;

	end;
   

implementation

{---( TExitNode )-------------------------------------------------}


procedure TExitNode.Optimize(ParCre:TCreator);
begin
	inherited Optimize(ParCre);
	if iReturnInstruction <> nil then  iReturnInstruction.Optimize(ParCre);
end;


procedure   TExitNode.proces(ParCre:TCreator);
begin
	inherited Proces(ParCre);
	if iReturnInstruction <> nil then iReturnInstruction.Proces(ParCre);
end;

procedure TExitNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if iReturnInstruction <> nil then iReturnInstruction.ValidatePre(ParCre,false);
end;

procedure   TExitNode.ValidateAfter(parCre : TCreator);
begin
	inherited ValidateAfter(ParCre);
	if (iReturnInstruction <> nil) then iReturnInstruction.ValidateAfter(ParCre);
end;


function    TExitNode.CreateSec(ParCre:TSecCreator):boolean;
var
	vlCb     : TRoutinePoc;
	vlJump   : TJumpPoc;
begin
	if iReturnInstruction <> nil then iReturnInstruction.CreateSec(ParCre);
	vlCb := TRoutinePoc(ParCre.fCurrentProc);
	if vlCb = nil then fatal(fat_RoutinePoc_Not_Set,'At:TExitNode.CreateSec');
	vlJump := TJumpPoc.Create(vlCb.CreateExitLabel);
	ParCre.AddSec(vlJump);
	CreateSec := false;
end;


constructor TExitNode.Create(ParReturnType : TType;ParReturnInstruction : TNodeIdent);
begin
	inherited Create;
	iReturnInstruction := ParReturnInstruction;
	iReturnType        := ParReturnType;
end;

procedure TExitNode.clear;
begin
	inherited Clear;
	if iReturnInstruction <> nil then iReturnInstruction.Destroy;
end;

procedure TExitNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.Writenl('<exit>');
	if iReturnType <> nil then begin
		ParDis.writenl('<type>');
		iReturnType.PrintName(ParDis);
		ParDis.Writenl('</type>');
	end;
	if iReturnInstruction <> nil then begin
		ParDis.nl;
		ParDis.WriteNl('<expression>');
		ParDis.SetLeftMargin(3);
		iReturnInstruction.Print(ParDis);
		ParDis.SetLeftMargin(-3);
		ParDis.nl;
		ParDis.Writenl('</expression');
	end;
	ParDis.Writenl('</exit>');
end;




{---( TConditionNode )---------------------------------------------}


procedure TConditionNode.ValidatePre(ParCre  : TCreator;ParIsSec : boolean);
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if iCond <> nil then begin
		iCond.ValidatePre(ParCre,false);
		if not iCond.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(iCond,Err_Cant_Read_From_Expr,'');
		if not iCond.IsLikeType(TBooleanType) then TNDCreator(ParCre).AddNodeDefError(iCond,Err_Wrong_Type,iCond.GetType);
	end;
end;

function  TConditionNode.SetVarUseItem(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TVarUseList;var ParItem : TVarUseItem) : TAccessStatus;
begin
	iCond.ValidateVarUse(ParCre,ParMode,ParUseList);
	inherited SetVarUseItem(ParCre,ParMode,ParUseList,ParItem);
	exit(AS_Normal);
end;

procedure TConditionNode.ValidateAfter(ParCre  : TCreator);
begin
	inherited ValidateAfter(ParCre);
	if iCond <> nil then iCond.ValidateAfter(ParCre);
end;

procedure TConditionNode.CommonSetup;
begin
	inherited CommonSetup;
	iCond := nil;
end;

procedure  TConditionNode.Optimize(ParCre : TCreator);
begin
	inherited Optimize(ParCre);
	iCond := OptimizeThisNode(ParCre,iCond);
end;


procedure TConditionNode.SetCond(ParCre :TNDCreator;ParCond:TFormulaNode);
begin
	if iCond<> nil then iCond.Destroy;
	iCond := ParCond;
end;

procedure TConditionNode.Proces(ParCre : TCreator);
begin
	inherited Proces(ParCre);
	if iCond <> nil then iCond.Proces(ParCre);
end;

destructor TConditionNode.Destroy;
begin
	inherited Destroy;
	if iCond <> nil then iCond.Destroy;
end;


{---( TRepeatNode )-----------------------------------------------}



function    TRepeatNode.CreateSec(ParCre:TSecCreator):boolean;
var vlLabFalse,vlLabTrue:TLabelPoc;
	vlPrvFalse,vlPrvtrue:TLabelPoc;
begin
	vlLabFalse  := ParCre.AddLabel;
	vlLabTrue   := GetBreakLabel;
	CreatePartsSec(ParCre);
	vlPrvFalse := ParCre.SetLabelFalse(vlLabFalse);
	vlPrvTrue  := ParCre.SetLabelTrue(vlLabTrue);
	ParCre.AddSec(GetContinueLabel);
	iCond.CreateSec(ParCre);
	ParCre.SetLabelFalse(vlPrvFalse);
	ParCre.SetLabelTrue(vlPrvTrue);
	ParCre.AddSec(vlLabtrue);
	CreateSec := false;
end;

procedure TRepeatNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.WriteNl('<repeat><code>');
	iParts.Print(ParDis);
	ParDis.WriteNl('</code></until>');
	if iCond <> nil then begin
		iCond.PrintNode(ParDis);
		ParDis.nl;
	end;
	ParDis.Write('</until></repeat>');
end;

{----( TWhileNode )-------------------------------------------}


function    TWhileNode.CreateSec(ParCre:TSecCreator):boolean;
var vlJump1    : TJumpPoc;
	vlLab1     : TLabelPoc;
	vlLab2     : TLabelPoc;
	vlPrvTrue  : TLabelPoc;
	vlPrvFalse : TLabelPoc;
begin
	vlJump1        := TJumpPoc.create(GetContinueLabel);
	ParCre.AddSec(vlJump1);
	vlLab1         := ParCre.AddLabel;
	CreatePartsSec(ParCre);
	vlLab2         := GetBreakLabel;
	ParCre.AddSec(vlJump1.fLabel);
	vlPrvtrue      := ParCre.SetLabelTrue(vlLab1);
	vlPrvFalse     := ParCre.SetLabelFalse(vlLab2);
	iCond.CreateSec(ParCre);
	ParCre.SetLabeLTrue(vlPrvTrue);
	ParCre.SetLabelFalse(vlPrvFalse);
	ParCre.AddSec(vlLab2);
	exit(false);
end;

procedure   TWhileNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.WriteNl('<while>');
	ParDis.WriteNl('<condition>');
	iCond.Print(ParDis);
	ParDis.WriteNl('</condition><code>');
	iParts.Print(PArDis);
	ParDis.WriteNl('</code></while>');
end;


{---( TForNode )-----------------------------------------------------------}


procedure TForNode.Proces(ParCre : TCreator);
begin
	inherited Proces(ParCre);
	if iEnd <> nil then iEnd.Proces(ParCre);
end;

procedure TForNode.ValidateAfter(ParCre  : TCreator);
begin
	inherited ValidateAfter(ParCre);
	if iEnd<> nil then iEnd.ValidateAfter(ParCre);
end;


procedure TForNode.Optimize(ParCre :TCreator);
begin
	inherited Optimize(parCre);
	iEnd := OptimizeThisNode(ParCre,iEnd);
end;


procedure  TForNode.SetBegin(ParCre:TNDCreator;ParNode:TFormulaNode);
begin
	SetCond(ParCre,ParNode);
end;

procedure  TForNode.SetEnd(ParNode:TFormulaNode);
begin
	if iEnd <> nil then iEnd.Destroy;
	iEnd := ParNode;
end;

procedure TForNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if iEnd <> nil then begin;
		iEnd.ValidatePre(ParCre,false);
		if not iEnd.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(iEnd,Err_Cant_Read_From_Expr,'');
		if not iEnd.IsLikeType(TBooleanType) then TNDCreator(ParCre).AddNodeError(iEnd,Err_Wrong_Type,'');
	end;
end;

procedure  TForNode.Commonsetup;
begin
	inherited commonsetup;
	iEnd := nil;
end;

destructor TForNode.Destroy;
begin
	inherited Destroy;
	if iEnd <> nil then iEnd.Destroy;
end;


procedure TForNode.Print(ParDis:TDisplay);
begin
	ParDis.Writenl('<for>');
    ParDis.Write('<while>');
	PrintIdent(ParDis,fCond);ParDis.nl;
	ParDis.Write('</while>');
	ParDis.WriteNl('<until>');
	PrintIdent(ParDis,iEnd);ParDis.nl;
	ParDis.WriteNl('</until>');
	ParDis.Write('<code>');
	iParts.Print(ParDis);ParDis.nl;
	ParDis.WriteNl('</code>');
	ParDis.WriteNl('</for>');
end;

function  TForNode.CreateSec(ParCre:TSecCreator):boolean;
var vlPrvTrue  : TLabelPoc;
	vlPrvFalse : TLabelPoc;
	vlLabTrue  : TLabelPoc;
	vlLabFalse : TLabelPoc;
	vlLabBegin : TLabelPoc;
	vlJmp      : TJumpPoc;
begin
	vlLabTrue  := GetContinueLabel;
	vlLabFalse := GetBreakLabel;
	vlLabBegin := TLabelPoc.Create;
	vlJmp      := TJumpPoc.Create(vlLabBegin);
	ParCre.AddSec(vlJmp);
	ParCre.AddSec(vlLabTrue);
	iParts.CreateSec(ParCre);
	vlPrvTrue  := ParCre.SetLabelTrue(vlLabFalse);
	vlPrvFalse := ParCre.SetLabelFalse(vlLabBegin);
	iEnd.CreateSec(parCre);
	ParCre.AddSec(vlLabBegin);
	ParCre.SetLabelTrue(vlLabTrue);
	ParCre.SetLabelFalse(vlLabFalse);
	fCond.CreateSec(ParCre);
	ParCre.AddSec(vlLabFalse);
	ParCre.SetLabelTrue(vlPrvTrue);
	ParCre.SetLabelFalse(vlPrvFalse);
	CreateSec := false;
end;


{-----( TCountNode )-------------------------------------------------------}

procedure TCountNode.CheckNodeByType(ParCre : TCreator;ParTYpe : TType ;ParCheck : TFormulaNode);
begin
	if (ParType <> nil) and (ParCheck <>nil) then begin
		ParCheck.ValidateAfter(ParCre);
		ParCheck.ValidateConstant(ParCre,@ParType.ValidateConstant);
	end;
end;

procedure TCountNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	inherited ValidatePre(PArCre,ParIsSec);
	if  iEndCondition <> Nil then begin
		iEndCondition.ValidatePre(ParCre,false);
		if not iEndCondition.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(iEndCondition,Err_Cant_Read_From_Expr,'');
        if not iEndCondition.IsCOmpByIdentCode(IC_BooleanType) then TNDCreator(ParCre).AddNodeDefError(iEndCondition,Err_Wrong_Type,iEndCOndition.GetType);
	end;
	if iBegin <> Nil then begin
		iBegin.ValidatePre(ParCre,false);
		if not iBegin.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(iBegin,Err_Cant_Read_From_Expr,'');
		if not iBegin.IsCompByIDentCode(IC_NUmber) then TNDCreator(ParCre).AddNodeDefError(iBegin,Err_Wrong_Type,iBegin.GetType);
	end;
	if iEnd <> nil then begin
		iEnd.ValidatePre(ParCre,false);
		if not iEnd.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(iEnd,Err_Cant_Read_From_Expr,'');
		if not iEnd.IsCompByIdentCode(IC_Number) then TNDCreator(ParCre).AddNodeDefError(iEnd,Err_Wrong_Type,iEnd.GetType);
	end;
	if iStep <> nil then begin
		iStep.ValidatePre(ParCre,false);
		if not iStep.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(iStep,Err_Cant_Read_From_Expr,'');
		if not iStep.IsCompByIdentCode(IC_Number) then TNDCreator(ParCre).AddNodeDefError(iStep,Err_Wrong_Type,iStep.GetType);
	end;
	if iCount <> nil then begin
		iCount.ValidatePre(ParCre,false);
   	if not iCount.Can([Can_Write]) then TNDCreator(ParCre).AddNodeError(iCOunt,Err_Cant_Write_To_Item,'');
		if not iCount.IsCompByIdentCode(IC_Number) then TNDCreator(ParCre).AddNodeDefError(iCount,Err_Wrong_Type,iCount.GetType);
	end;

end;

procedure TCountNode.Proces(ParCre : TCreator);
begin
	inherited Proces(ParCre);
	if iEndCOndition <> nil then iEndCondition.Proces(ParCre);
	if iBegin <> nil then iBegin.Proces(ParCre);
	if iEnd <> nil then iEnd.Proces(ParCre);
	if iStep <> nil then iStep.Proces(ParCre);
   if iCount <> nil then iCount.Proces(ParCre);
end;



procedure TCountNode.ValidateAfter(ParCre : TCreator);
var
	vlType :TType;
begin
	inherited ValidateAfter(parCre);

	if iBegin <> Nil then iBegin.validateAfter(ParCre);
	if iEnd <> nil then iEnd.ValidateAfter(ParCre);
	if iStep <> nil then iStep.ValidateAfter(ParCre);
	if iEndCondition <> nil then iEndCondition.ValidateAfter(ParCre);

	if iCount <> nil then begin
		iCount.ValidateAfter(ParCre);
		vlType := iCount.GetType;
		CheckNodeByType(ParCre,vlType,iBegin);
		CheckNodeByType(ParCre,vlType,iEnd);
		CheckNodeByType(ParCre,vlType,iStep);
	end;
end;

procedure  TCountNode.Optimize(ParCre : TCreator);
begin
	inherited Optimize(parCre);
	iBegin := OptimizeThisNode(ParCre,iBegin);
	if iEnd <> nil then iEnd   := OptimizeThisNode(ParCre,iEnd);
	iCount := OptimizeThisNode(ParCre,iCount);
	if iEndCondition <> nil then iEndCOndition := OptimizeThisNode(ParCre,iEndCondition);
	if iStep <> nil then iStep := OptimizeThisNode(ParCre,iStep);
end;


procedure  TCountNode.SetEndCondition(ParCre : TNDCreator;ParNode : TFormulaNode);
begin
	if iEndCOndition <> nil then iEndCondition.Destroy;
	iEndCondition := ParNode;
end;


procedure TCountNode.SetCount(ParCre:TNDCreator;ParNode:TFormulaNode);
begin
	if iCount <> nil then iCount.Destroy;
	iCount := ParNode;
end;

procedure TCountNOde.SetBegin(ParCre:TNDCreator;ParNode:TFormulaNode);
begin
	if iBegin <> nil then iBegin.Destroy;
	iBegin := ParNode;
end;

procedure TCountNode.SetEnd(ParCre:TNDCreator;PArNode:TFormulaNode);
begin
	if iEnd <> nil then iEnd.Destroy;
	iEnd := ParNode;
end;

procedure TCountNode.SetStep(ParCre:TNDCreator;ParNode:TFormulaNode);
begin
	if iStep <> nil then iStep.Destroy;
	iStep := ParNode;
end;


procedure TCountNode.SetUp(ParUp:boolean);
begin
	iUp := ParUp;
end;


procedure TCountNode.Commonsetup;
begin
	inherited Commonsetup;
	iCount := nil;
	iBegin := nil;
	iEnd   := nil;
	iStep  := nil;
	iUp    := false;
end;

destructor TCountNode.Destroy;
begin
	inherited Destroy;
	if iCount <> nil then iCount.Destroy;
	if iBegin <> nil then iBegin.Destroy;
	if iEnd   <> nil then iEnd.Destroy;
	if iStep  <> nil then iStep.Destroy;
	if iEndCondition <> nil then iEndCondition.Destroy;
end;

procedure TCountNode.Print(ParDis:TDisplay);
begin
	ParDis.WriteNl('<count>');
	ParDis.Write('<counter>');PrintiDent(ParDis,iCount);ParDis.WriteNl('</counter>');
	ParDis.Write('<begin>');PrintIdent(ParDis,iBegin);ParDis.WriteNl('</begin>');
	ParDis.Write('<direction>');
	if iUp then begin
		ParDis.Write('UP')
	end else begin
		ParDis.Write('DOWNTO');
	end;
	ParDis.WriteNl('</direction>');
	if iEnd <> nil then begin
		ParDis.write('<end>');PrintiDent(ParDis,iEnd);ParDis.WriteNl('</end>');
	end;
	if iEndCondition <> nil then begin
		ParDis.Write('<until>');PrintIdent(ParDis,iEndCondition);ParDIs.WriteNl('</until>');
	end;
	ParDis.WriteNl('<code>');
	iParts.Print(ParDis);
	ParDis.WriteNl('</code>');
end;

function  TCountNode.CreateSec(parcre:TSecCreator):boolean;
var vlLod     :TLoadFor;
	vlCOunt   :TMacBase;
	vlBegin   :TMacBase;
	vlEnd     :TMacBase;
	vlLab     :TLabelPoc;
	vlFlag    :TMacBase;
	vlJmp 	  :TJumpPoc;
	vlCode    :TIdentCode;
	vlAddFor  :TFormulaPoc;
	vlPrvTrue : TLabelPoc;
	vlPrvFalse : TLabelPoc;
	vlTrue     : TLabelPoc;
	vlTestFirst : boolean; {Test first and then decrement}
	vlValue     : TValue;
	vlCheckLab  : TLabelPoc;
begin
	vlCount := iCount.CreateMac(MCO_Result,ParCre);
	vlBegin := iBegin.CreateMac(MCO_Result,ParCre);
	vlLod := (TLoadFor.create);
	vlLod.SetVar(0,vlCount);
	vlLod.SetVar(1,vlBegin);
	ParCre.AddSec(vlLod);
	vlLab := ParCre.AddLabel;
	if iEndCondition <>nil then begin
		vlTrue := ParCre.CreateLabel;
		vlPrvTrue := ParCre.SetLabelTrue(GetBreakLabel);
		vlPrvFalse := ParCre.SetLabelFalse(vlTrue);
		iEndCondition.CreateSec(ParCre);
		ParCre.SetLabelTrue(vlPrvTrue);
		ParCre.SetLabelFalse(vlPrvFalse);
		ParCre.AddSec(vltrue);
	end;
	iParts.CreateSec(ParCre);
	ParCre.AddSec(GetContinueLabel);
	vlAddFor := TIncDecFor.Create(iUp);
	vlAddFor.SetVar(0,iCount.CreateMac(MCO_Result,ParCre));
	vlAddFor.SetVar(1,iStep.CreateMac(MCO_Result,ParCre));
    vlTestFirst := true;

	if iEnd <>nil then begin
		vlValue := iEnd.GetValue;
		if vlValue <> nil then begin
			if iUp then begin
				vlTestFirst := iCount.IsMaximum(vlValue);
			end else begin
				vlTestFirst := iCount.IsMinimum(vlValue);
			end;
			vlValue.Destroy;
		end;
	end;

	if not vlTestFirst then PArCre.AddSec(vlAddFor);
	if iEnd <>nil then begin
		if vlTestFirst then begin
			vlCode := IC_Eq;
			vlCheckLab := GetBreakLabel;
		end else begin
			vlCode := IC_LowerEq;
			if not iUp then vlCode := IC_BiggerEq;
			vlCheckLab := vlLab;
		end;
		vlEnd  := iEnd.CreateMac(MCO_Result,ParCre);
		vlFlag := ParCre.MakeCompPoc(iCount.CreateMac(MCO_Result,ParCre),vlEnd,vlCOde);
		vlJmp := TCondJumpPoc.create(true,vlFlag,vlCheckLab);
	end else begin
		vlJmp := TJumpPoc.Create(vlLab);
	end;

	ParCre.AddSec(vlJmp);
	if vlTestFirst then begin
		PArCre.AddSec(vlAddFor);
		vlJmp := TJumpPoc.Create(vlLab);
		ParCre.AddSec(vlJmp);
	end;
	ParCre.AddSec(GetBreakLabel);
	exit( false);
end;

{-------( TLoadNode )---------------------------------------------}

function  TLoadNode.CanSec : boolean;
begin
	exit(true);
end;

function TLoadNode.CheckConvertTest(ParType1,ParType2 :TType) : boolean;
begin
	if ParType1 <> nil then begin
		exit(ParType1.CanWriteWith(false,ParType2));
	end else begin
		exit(false);
	end;
end;


procedure TLoadNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var vlFirst     : TFormulaNode;
	vlSecond    : TFormulaNode;
	vlType      : TType;
	vlName1     : string;
	vlName2     :string;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	vlFirst  := TFormulaNode(GetPartByNUm(1));
	vlSecond := TFormulaNode(GetPartByNum(2));
	vlType := GetType;
	if (vlFirst <> nil) and (vlSecond <> nil) then begin
		if vlFirst.GetSize = 0 then TNDCreator(ParCre).AddNodeError(vlFirst,Err_Cant_Determine_Size,'2');
		if vlSecond.GetSize = 0 then TNDCreator(ParCre).AddNodeError(vlSecond,Err_Cant_Determine_Size,'3');
		if not vlFirst.Can([Can_Write]) then TNDCreator(ParCre).AddNodeError(vlFirst,Err_Cant_Write_To_Item,'');
		if not vlSecond.Can([Can_Read]) then TNDCreator(ParCre).AddNodeError(vlSecond,Err_Cant_Read_From_expr,'');
		if (vlType <> nil) then begin
			if CheckConvertNode2(ParCre,vlType,vlSecond) then begin
				vlName1 := 'unkown';
				vlName2 := 'unkown';
				vlSecond := TFormulaNode(GetPartByNum(2));
				if vlType <>nil then  vlName1 := vlType.GetErrorName;
				if vlSecond.GetType <> nil then  vlName2 := vlSecond.GetType.GetErrorName;
				TNDCreator(ParCre).AddNodeError(vlFirst,Err_Incompatible_types,'Expression '+vlName2+' loaded into '+vlName1);
			end;
		end;
	end;
end;

procedure TLOadNode.ValidateAfter(ParCre : TCreator);
var vlFirst  : TFormulaNode;
	vlSecond : TFormulaNode;
	vlType   : TType;
begin
	inherited ValidateAfter(ParCre);
	vlFirst  := TFormulaNode(fParts.fStart);
	if vlFirst <> nil then begin
		vlSecond := TFormulaNode(vlFirst.fNxt);
		if vlSecond <> nil then begin
			vlType := vlFirst.GetType;
			if (vlTYpe <> nil)  then vlSecond.ValidateConstant(ParCre,@vlType.ValidateConstant);
		end;
	end;
end;

function  TLoadNode.SetVarUseItem(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TVarUseList;var ParItem : TVarUseItem) : TAccessStatus;
var
	vlFirst  : TFormulaNode;
	vlSecond : TFormulaNode;
begin
	vlFirst  := TFormulaNode(GetPartByNUm(1));
	vlSecond := TFormulaNode(GetPartByNum(2));
	vlSecond.ValidateVarUse(ParCre,AM_Read,ParUseList);
	vlFirst.ValidateVarUse(ParCre,AM_Write,ParUseList);
	ParItem := nil;
	exit(AS_Normal);
end;

function TLoadNode.CreateSec(ParCre:TSecCreator):boolean;
var vlPoc    : TLoadFor;
	vlFirst  : TFormulaNode;
	vlSecond : TFormulaNode;
	vlSource : TMacBase;
	vlDest   : TMacBase;
	vlMac1   : TMacBase;
	vlMac2   : TMacBase;
begin
	vlFirst  := TFormulaNode(GetPartByNUm(1));
	vlSecond := TFormulaNode(GetPartByNum(2));
	if (vlFirst.GetSize >GetAssemblerInfo.GetSystemSize) or (vlFirst.GetSize = 3)  then begin
		vlDest   := vlFirst.CreateMac(MCO_Result,ParCre);
		vlSource := vlSecond.CreateMac(MCO_Result,ParCre);
		vlPoc    := TLoadFor(TLSMovePoc.Create(vlSource,vlDest,vlFirst.GetSize));
		ParCre.AddSec(vlPoc);
	end else begin
		vlPoc := TLoadFor.create;
		if (vlSecond.fComplexity > vlFirst.fComplexity) then begin
			vlMac1 := vlSecond.CreateMac(MCO_Result,ParCre);
			vlMAc2 := vlFirst.CreateMac(MCO_Result,ParCre);
		end else begin
			vlMAc2 := vlFirst.CreateMac(MCO_Result,ParCre);
			vlMac1 := vlSecond.CreateMac(MCO_Result,ParCre);
		end;
		vlPoc.SetVar(1,vlMac1);
		vlPoc.SetVar(Mac_Output,vlMac2);
		ParCre.AddSec(vlPoc);
	end;
	if vlFirst.IsOptUnsave then ParCre.AddSec(TOptUnSavePoc.Create);
	CreateSec := false;
end;


procedure TLoadNode.getOperStr(Var ParOper:string);
begin
	ParOper := ':=';
end;


procedure TLoadNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_LoadNode);
end;

{----( TBreakNode )---------------------------------------------------------}


procedure TBreakNode.Print(parDis:TDisplay);
begin
	ParDis.Writenl('<Break></break>');
end;

procedure TBreakNode.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_BreakNode;
end;

function  TBreakNode.GetJumpLabel:TLabelPoc;
begin
	if fLCBNode = nil then exit(nil);
	exit(fLCBNode.GetBreakLabel);
end;


{----( TContinueNode )---------------------------------------------------------}

procedure TContinueNode.PRint(parDis:TDisplay);
begin
	ParDis.write('<Continue></continue>');
end;

procedure TContinueNode.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_BreakNode);
end;

function  TContinueNode.GetJumpLabel:TLabelPoc;
begin
	if fLCBNode = nil then exit(nil);
	exit(fLCBNode.GetContinueLabel);
end;


{----( TLoopFlowNode )-------------------------------------------------------}


constructor TLoopFlowNode.Create(ParNode:TLoopCbNode);
begin
	iLcbNode := ParNode;
	inherited create;
end;

function TLoopFlowNode.GetJumpLabel:TLabelPoc;
begin              ;
	exit(nil);
end;

function TLoopFlowNode.CreateSec(ParCre:TSecCreator):boolean;
var vlLabel : TLabelPoc;
	vlJump  : TJumpPoc;
begin
	CreateSec := false;
	vlLabel := GetJumpLabel;
	if vlLabel <> nil then begin
		vlJump := TJumpPoc.Create(vlLabel);
		ParCre.AddSec(vlJump);
	end else begin
		fatal(Fat_Cant_Det_Jump_Label,'TLoopFlowNode.CreateSec');
	end;
end;

{----( TLoopCBNode )---------------------------------------------------------}

function TLoopCBNode.OptimizeThisNode(ParCre : TCreator;ParNode : TFormulaNode) : TFormulaNode;
var vlRepl : TFormulaNode;
	
begin
	if ParNode = nil then exit(nil);
	ParNode.OptimizeForm(ParCre,vlRepl);
	if vlRepl <> nil then begin
		ParNode.Destroy;
	end else begin
		vlRepl := ParNode;
	end;
	exit(vlRepl);
end;

function  TLoopCBNode.GetBreakLabel : TLabelPoc;
begin
	if iBreakLabel = nil then iBreakLabel := TLabelPoc.Create;
	exit(iBreakLabel);
end;

function  TLoopCbNode.GetContinueLabel :TLabelPoc;
begin
	if iContinueLabel = nil then iContinueLabel := TLabelPoc.Create;
	exit(iContinueLabel);
end;

procedure TLoopCbNode.Commonsetup;
begin
	inherited Commonsetup;
	iBreakLabel    := nil;
	iContinueLabel := nil;
end;

{---( TLEaveNode )---------------------------------------------------------------}

function  TLeaveNode.CreateSec(ParCre:TSecCreator):boolean;
var
	vlLabel : TLabelPoc;
	vlJmp   : TJumpPoc;
begin
	vlLabel := ParCre.NewLeaveLabel;
	vlJmp := TJumpPoc.Create(vlLabel);
	ParCre.AddSec(vlJmp);
	exit(false);
end;

procedure TLeaveNOde.PrintNode(ParDis:TDisplay);
begin
	ParDis.Write('<leave>');
	ParDis.Writenl('</lave>');
end;
{----( TAsmNode )-------------------------------------------------------------}

function  TAsmNode.CreateSec(ParCre:TSecCreator):boolean;
begin
	CreateSec := false;
	ParCre.addSec((TAsmPoc.create(iSize,iText)));
	ResetText;
end;


procedure TAsmNode.Print(parDis:TDisplay);
begin
	ParDis.writeNl('<ASM>');
	ParDis.SetLeftMargin(4);
	PARDIS.WriteRaw(iText,iSize);
	ParDis.SetLeftMargin(-4);
	ParDis.writeNl('<END>');
end;

constructor TAsmNode.Create(ParSize : TSize;ParText:pointer);
begin
	inherited Create;
	iSize := ParSize;
	iText := ParText;
end;

procedure TAsmNode.clear;
var
	vlPtr : pointer;
begin
	inherited Clear;
	if iText <> nil then begin
		vlPtr := iText;
		Freemem(vlPtr,iSize);
	end;
end;

procedure TAsmNode.ResetText;
begin
	iText := nil;
end;

procedure TAsmNode.commonsetup;
begin
	inherited Commonsetup;
	iIdentcode := IC_AsmNode;
end;



end.
