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

unit naddsub;

interface
uses formbase,largenum,elatypes,error,asminfo,
compbase,node,macobj,types,
execobj,elacons,pocobj,ndcreat,display;
type
	
	TAddNode=class(TDualOperNode)
	protected
		procedure commonsetup;override;
	public
		procedure  GetOperStr(var ParOper:string);override;
		procedure InitParts;override;
		procedure  ValidateAfter(ParCre :TCreator);override;

	end;
	
	TSubNode=class(TDualOperNode)
	protected
		procedure commonsetup;override;
	public
		procedure  ValidateAfter(ParCre :TCreator);override;
		procedure GetOperStr(var ParOper:string);override;
		procedure InitParts;override;
	end;
	
	TAddSubNodeList=class(TOperatorNodeList)
	public
		procedure GetFirstValue(var ParValue :TNumber);override;
		function  CanOptimize1:boolean;override;
		function  CanOptimizeCpx:boolean;override;
	end;
	
	TSubNodeList = class(TAddSubNodeList)
	public
		function  AddOptimizedValue(ParCre : TCreator;ParValue : TNumber):boolean;override;
		procedure CalculateOperator(ParCre : TCreator;var ParResult:TNUmber;ParPos : cardinal;ParValue:TNumber);override;
		function  DetermenFormType(ParCre : TCreator;ParPrvType : TType;ParNode :TFormulaNode):TType;override;
		function  CreateMac(ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		function  FirstCpxOptimizeNode : TFormulaNode;override;
		procedure ValidateSub(ParCre  : TCreator);
	end;
	
	TAddNodeList = class(TAddSubNodeLIst)
	public
		function  AddOptimizedValue(ParCre : TCreator;ParValue : TNumber):boolean;override;
		procedure CalculateOperator(ParCre :TCreator;var ParResult:TNumber;ParPos : cardinal;ParValue:TNumber);override;
		function  DetermenFormType(ParCre : TCreator;ParPrvType : TType;ParNode :TFormulaNode):TType;override;
		function  CreateMac(ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		procedure ValidateSub(ParCre  : TCreator);
	end;

	
	TIncDecNode = class(TNodeIdent)
	private
		voIncFlag     : boolean;
		voIncrementor : TFormulaNode;
		voValue       : TFormulaNode;
		
		property iIncFlag : boolean read voIncFlag write voIncFlag;
		property iIncrementor : TFormulaNode read voIncrementor write voIncrementor;
		property iValue       : TFormulaNode read voValue       write voValue;

	protected
		procedure Commonsetup; override;
		procedure  clear;override;
	public
		procedure Optimize(ParCre : TCreator);override;
		procedure proces(ParCre : TCreator);override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure ValidateAfter(ParCre : TCreator);override;
		constructor Create(ParIncFlag : boolean;var ParIncrementor,ParValue : TFormulaNode);
		function  CreateSec(ParCre : TSecCreator):boolean;override;
		procedure PrintNode(ParDis:TDisplay);override;
	end;
	
	
	
implementation
{---( TIncDecNode )------------------------------------------------------------}

procedure TIncDecNode.Optimize(ParCre : TCreator);
begin
	inherited Optimize(ParCre);
	if iIncrementor <> nil then iIncrementor.Optimize(ParCre);
	if iValue <> nil then iValue.Optimize(ParCre);
end;

procedure TIncDecNode.proces(ParCre : TCreator);
begin
	inherited Proces(ParCre);
	if iIncrementor <> nil then iIncrementor.Proces(ParCre);
	if iValue <> Nil then iValue.Proces(ParCre);
end;

procedure TIncDecNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	inherited ValidatePre(ParCre,ParIsSec);
	if iIncrementor = nil then exit;
	iIncrementor.ValidatePre(ParCre,false);
	if not(iIncrementor.Can([Can_write])) then TNDCreator(ParCre).AddNodeError(iIncrementor,Err_Cant_Write_To_Item,'');
   if iValue = nil then exit;
	iValue.ValidatePre(ParCre,false);
	if (iIncrementor.IsLikeType(TOrdinal)) or (iIncrementor.IsLikeType(TPtrType)) then  begin
		if  not(iValue.IsLikeType(TNumberType))  then TNDCreator(ParCre).AddNodeDefError(iValue,Err_Wrong_Type,iValue.GetType);
	end else begin
		TNDCreator(ParCre).AddNodeError(iIncrementor,Err_Ordinal_Type_Expected,'');
	end;
end;

procedure TIncDecNode.ValidateAfter(ParCre : TCreator);
begin
	inherited ValidateAfter(ParCre);
	if iValue <> nil then iValue.ValidateAfter(ParCre);
	if iIncrementor <> nil then iIncrementor.ValidateAfter(ParCre);
end;

procedure TIncDecNode.Clear;
begin
	inherited Clear;
	if iValue <> nil then iValue.Destroy;
	if iIncrementor <> nil then iIncrementor.Destroy;
end;

procedure TIncDecNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.WriteNl('<inc>');
	ParDis.WriteNl('<ident>');
	iIncrementor.Print(ParDis);
	ParDis.Write('</ident><value>');
	iValue.Print(ParDis);
	ParDis.Write('</value></inc>');
end;


procedure   TIncDecNode.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_IncDecNode;
end;

constructor TIncDecNode.Create(ParIncFlag : boolean;var ParIncrementor,ParValue : TFormulaNode);
begin
	inherited Create;
	iIncFlag := ParIncFlag;
	iIncrementor := ParIncrementor;
	iValue := ParValue;
end;

function  TIncDecNode.CreateSec(ParCre : TSecCreator):boolean;
var
	vlMacInc   : TMacBase;
	vlMacValue : TMacBase;
	vlInst     : TIncDecFor;
	vlPtrSize  : TLargeNumber;
begin
	vlMacInc := iIncrementor.CreateMac(MCO_Result,ParCre);
	vlMacValue := iValue.CreateMac(MCO_Result,ParCre);
	if (iIncrementor.IsLikeType(TPtrType)) then begin
		LoadLong(vlPtrSize,TPtrType(iIncrementor.GetType).GetSecSize);
		if(LargeCompareLong(vlPtrSize,0) = LC_Equal) then LoadLOng(vlPtrSize,1);
		vlMacValue := ParCre.MakeMulPoc(vlMacValue,vlPtrSize);
	end;
	vlInst := TIncDecFor.Create(iIncFlag);
	vlInst.SetVar(0,vlMacInc);
	vlInst.SetVar(1,vlMacValue);
	ParCre.AddSec(vlInst);
	exit(False);
end;



{------( TAddSubNodeList )-------------------------------------------------}


function TAddSubNodeList.CanOptimizeCpx:boolean;
begin
	exit(true);
end;

procedure TAddSubNodeList.GetFirstValue(var ParValue : TNumber);
begin
	LoadInt(ParValue,0);
end;

function TAddSubNodeList.CanOptimize1:boolean;
begin
	exit(true);
end;

{------(  TSubNode)----------------------------------------------}

procedure TSubNode.ValidateAfter(ParCre :TCreator);
begin
	TSubNodeList(iParts).ValidateSub(ParCre);
	inherited ValidateAfter(ParCre);
end;

procedure TSubNode.InitParts;
begin
	iParts := TSubNodeList.create(TSubFor);
end;

procedure TSubNode.GetOperStr(var ParOper:string);
begin
	ParOper := '-';
end;

procedure TSubNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_SubNode);
end;

{-----( TSubNodeList )-----------------------------------------------------}


procedure TSubNodeList.ValidateSub(ParCre  : TCreator);
var
	vlType :TType;
	isPtr1 : boolean;
	isOrd1 : boolean;
	vlCurrent : TFormulaNode;
begin
	vlCurrent := TFormulaNode(fStart);
	if vlCurrent <> nil then begin
		vlType := vlCurrent.GetType;
		if vlType = nil then exit;
		IsPtr1 := vlType.IsCompByIdentCode(IC_PtrType);
		IsOrd1 := vlType.IsCompByIdentCode(IC_Number);
		if not(IsPtr1 or IsOrd1) then TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Wrong_Type,'');
		vlCurrent := TFormulaNode(vlCurrent.fNxt);
		while vlCurrent <> nil do begin
			vlType := vlCurrent.GetType;
			if vlType <> nil then begin
				if IsPtr1 then begin
					if vlType.IsCompByIdentCode(IC_PtrType) then begin
						IsPtr1 := false;IsOrd1 := true;
					end else if not vlType.IsCompbyIdentCode(IC_Number) then begin
						TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Wrong_Type,'');
					end;
				end else if IsOrd1 then begin
					if not vlType.IsCompByIdentCode(IC_Number) then begin
						TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Wrong_Type,'');
					end;
				end;
			end;
			vlCurrent := TFormulaNode(vlCurrent.fNxt);
		end;
	end;
end;


function TSubNodeList.FirstCpxOptimizeNode : TFormulaNode;
begin
	if fStart <> nil then begin
		exit(TFormulaNode(fStart.fNxt));
	end else begin
		exit(nil);
	end;
end;


function  TSubNodeList.DetermenFormType(ParCre : TCreator;ParPrvType : TType;ParNode :TFormulaNode):TType;
var
	vlType : TType;
begin
	if (ParNode <> nil) and (ParPrvType <> nil) then begin
		if (ParPrvType is TPtrType) then begin
			if (ParNode.GetOrgType is TPtrType) then begin
				vlType := (TNDCreator(ParCre).GetDefaultIdent(DT_Number,GetAssemblerInfo.GetSystemSize,true));
				exit(vlType);
			end;
			exit(ParPrvType);
		end;
	end;
	exit(inherited DetermenFormType(ParCre,ParPrvType,ParNode));
end;

function TSubNodeList.CreateMac(ParOption :TMacCreateOption;ParCre : TSecCreator):TMacBase;
var
	vlSec       : TSubPoc;
	vlPoc       : TSubPoc;
	vlCurrent   : TFormulaNode;
	vlMac       : TMacBase;
	vlMac2      : TMacBase;
	vlIsPtrType : boolean;
	vlPtrSize   : TLargeNumber;
	vlSize      : TSize;
	vlType      : TType;
begin
	vlSec := TSubPoc.create;
	ParCre.AddSec(vlSec);
	vlPoc       := ParCre.fPoc;
	ParCre.SetPoc(vlSec);
	vlCurrent   := TFormulaNode(fStart);
	vlMac       := nil;
	vlIsPtrType := false;
	LoadLong(vlPtrSize ,0);
	if vlCurrent <> nil then begin
		vlMac := vlCurrent.CreateMac(ParOption,ParCre);
		vlType := vlCurrent.GetType;
		if (vlType <> nil) and (vlType is TPtrType) then begin
			vlIsPtrType := true;
			vlSize := TPtrType(vlType).GetSizeOfPtrTo ;
			if vlSize = 0 then vlSize := 1;
			LoadLong(vlPtrSize, vlSize);
		end;
		vlCurrent := TFormulaNode(vlCurrent.fNxt);
		while (vlCurrent <>  nil) do begin
			vlMac2 := vlCurrent.CreateMac(ParOption,ParCre);
			
			if vlIsPtrType and not(vlCurrent.IsLikeType(TPtrType)) then begin
				vlMac2 := ParCre.MakeMulPoc(vlMac2,vlPtrSize);
			end;
			
			vlMac := CreatePoc(ParCre,vlMac,vlMac2);
			if vlMac= nil then break;
			if (vlCurrent.IsLikeType(TPtrType)) and (vlIsPtrType) then begin
				{Hack: ptr sub must be signed CalcOutputMac doesn't work here
				verry well.
				}
				vlIsPtrType := false;
				vlMac.SetSign(true);
				vlMac := ParCre.MakeDivPoc(vlMac,vlPtrSize);
			end;
			vlCurrent := TFormulaNode(vlCurrent.fNxt);
		end;
	end;
	ParCre.SetPoc(vlPoc);
	exit(vlMac);
end;

function TSubNodelIst.AddOptimizedValue(ParCre : TCreator;ParValue : TNumber):boolean;
var
	vlAt      : TNodeIdent;
	vlResNode : TNodeIdent;
begin
	vlAt := TNodeIdent(fStart);
	if vlAt.fCanDelete  then begin
		vlAt := nil;
	end else begin
		if LargeCompareLong(ParValue, 0) =LC_Equal then exit(false);
		LargeNeg(ParValue);
		vlAt := TNodeIdent(fTop);
	end;
	vlResNode := TNDCreator(ParCre).CreateIntNode(ParValue);
	if vlResNode <> nil then AddNodeAt(vlAt,vlResNode);
	exit(true);
end;

procedure TSUbNodeList.CalculateOperator(ParCre : TCreator;var ParResult:TNumber;ParPos : cardinal;ParValue:TNumber);
var
	vlErr : boolean;
begin
	vlErr := false;
	if ParPos = 1 then begin
		vlErr := LargeAdd(parResult,ParValue);
	end else begin
		vlErr := LargeSub(ParResult,ParValue);
	end;
	if vlErr then TNDCreator(ParCre).AddNodeListError(self,Err_NUM_Out_of_Range,'');
end;

{-------(TAddNOdeList )-----------------------------------------}


procedure TAddNodeList.ValidateSub(parCre :TCreator);
var
	vlType :TType;
	vlCurrent : TFormulaNode;
	isPtr1 : boolean;
	isOrd1 : boolean;
begin
	vlCurrent := TFormulaNode(fStart);
	if vLCurrent <> nil then begin
    	vlType := vlCurrent.GetType;
		if vlType = nil then exit;
		IsPtr1 := vlType.IsCompByIdentCode(IC_PtrType);
		IsOrd1 := vlType.IsCompByIdentCode(IC_Number);
		if not(IsPtr1 or IsOrd1) then TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Wrong_Type,'');
		vlCurrent := TFormulaNode(vlCurrent.fNxt);
		while vlCurrent <> nil do begin
			vlType := vlCurrent.GetType;
			if vlType <> nil then begin
				if IsPtr1 then begin
					if not(vlType.IsCompByIdentCode(IC_Number)) then begin
						TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Wrong_Type,'');
					end;
				end else if IsOrd1 then begin
					if vlType.IsCompByIdentCode(IC_PtrType) then begin
						IsPtr1 := true;
						IsOrd1 := false;
					end else if not(vlType.IsCompByIdentCode(IC_Number)) then begin
                        TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Wrong_Type,'');
					end;
				end;
			end;
			vlCurrent := TFormulaNode(vlCurrent.fNxt);
		end;
	end;
end;

function TAddNodeList.CreateMac(ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlCurrent     : TFormulaNode;
	vlSec         : TSubPoc;
	vlPoc         : TSubPoc;
	vlMac         : TMacBase;
	vlMac2        : TMacBase;
	vlIsPointer   : boolean;
	vlPtrTypeSize : TLargeNumber;
	
begin
	vlSec := TSubPoc.create;
	ParCre.AddSec(vlSec);
	vlPoc     := ParCre.fPoc;
	ParCre.SetPoc(vlSec);
	vlCurrent := TFormulaNode(fStart);
	vlMac     := nil;
	vlIsPointer   := false;
	LoadLong(vlPtrTypeSize ,0);
	if vlCurrent <> nil then begin
		vlMac := vlCurrent.CreateMac(ParOption,ParCre);
		if vlCurrent.GetType is TPtrType then begin
			LoadLong(vlPtrTypeSIze ,TPtrType(vlCurrent.GetType).fType.fSize);
			if LargeCompareLong(vlPtrTypeSize,0)=LC_Equal then LoadLong(vlPtrTypeSize,1);
			vlIsPointer := true;
		end;
		vlCurrent := TFormulaNode(vlCurrent.fNxt);
		while (vlCurrent <>  nil) do begin
			vlMac2 := vlCurrent.CreateMac(ParOption,ParCre);
			if (vlCurrent.GetType is TPtrType) then begin
				if  not(vlIsPointer) then begin
					LoadLong(vlPtrTypeSIze,TPtrType(vlCurrent.GetType).fType.fSize);
					if LargeCompareLong(vlPtrTypeSize,0)=LC_Equal then LoadLong(vlPtrTypeSize,1);
					vlMac := ParCre.MakeMulPoc(vlMac,vlPtrTypeSize);
					vlIsPointer := true;
				end;
			end else begin
				if vlIsPointer then begin
					vlMac2 := ParCre.MakeMulPoc(vlMac2,vlPtrTypeSize);
				end;
			end;
			vlMac2 := CreatePoc(ParCre,vlMac,vlMac2);
			if vlMac2= nil then break;
			vlMac := vlMac2 ;
			vlCurrent := TFormulaNode(vlCurrent.fNxt);
		end;
	end;
	ParCre.SetPoc(vlPoc);
	exit(vlMac);
end;


function TAddNodelIst.AddOptimizedValue(ParCre : TCreator;ParValue : TNumber):boolean;
var
	vlAdd : boolean;
begin
	vlAdd := false;
	if LargeCompareLong(ParValue , 0) <> LC_Equal then vlAdd := inherited AddOptimizedValue(ParCre,PArValue);
	exit(vlAdd);
end;

procedure TAddNodeList.CalculateOperator(ParCre :TCreator;var ParResult : TNumber;ParPos : cardinal;ParValue : TNumber);
begin
	if LargeAdd(ParResult,ParValue) then TNDCreator(ParCre).AddNodeListError(Self,Err_Num_Out_Of_Range,'');
end;

function  TAddNodeList.DetermenFormType(parCre : TCreator;ParPrvType : TType;ParNode :TFormulaNode):TType;
begin
	if (ParNode <> nil) and (ParNode.GetType <> nil)  then begin
		if ParNode.GetType is TPtrType then exit(parNode.GetType);
		if(ParPRvtype<> nil) and (PArPrvType is TPtrType) then exit(ParPrvType);
	end ;
	exit(inherited DetermenFormType(ParCre,ParPrvType,ParNode));
end;



{-------( TAddNode )---------------------------------------------}

procedure TAddNode.ValidateAfter(ParCre : TCreator);
begin
	TAddNodeList(iPArts).ValidateSub(ParCre);
	inherited ValidateAfter(ParCre);
end;

procedure TAddNode.InitParts;
begin
	iParts := TAddNodeList.create(TAddFor);
end;

procedure TAddNode.GetOperStr(var ParOper:string);
begin
	ParOper := '+';
end;

procedure TAddNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_AddNode;
end;

end.
