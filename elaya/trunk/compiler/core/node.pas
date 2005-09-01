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


unit Node;

interface
uses largenum,compbase,linklist,error,display,elaCons,pocobj,cmp_type,
	macobj,progutil,elatypes,stdobj,objlist,strlist,useitem;
type

TConstantValidationProc=function(ParValue : TValue):TConstantValidation of object;

TNodeLIst   = class;
TSecCreator = class;
TNodeIdent  = class;

TNodeList=class(TList)
public
	procedure Optimize(ParCre : TCreator);
	function  AddNode(ParNode:TNodeIdent):boolean;
	procedure Print(ParDis:TDisplay);
	function  HandleNode(ParCre:TSecCreator;ParNode:TNodeIdent):boolean;virtual;
	function  CreateSec(ParCre:TSecCreator):boolean;virtual;
	function  CreateMac(ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;virtual;
	function  DeleteIfCan(ParCre : TCreator):boolean;
	procedure ValidateAfter(ParCre : TCreator);
	procedure AddNodeAt(ParAt,ParNode : TNodeIdent);
	procedure ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
	procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);
	procedure Proces(ParCre : TCreator);virtual;
end;

TNodeident=class(TIdentBase)
private
	voLine  : cardinal;
	voCol   : cardinal;
	voPos   : cardinal;
	voCanDelete : boolean;
	voIdentCOde : TNodeIdentCode;
protected
	procedure CommonSetup;override;
	property  iIdentCode : TNodeIdentCode read voIdentCode write voIdentCode;
public
	property fCanDelete : boolean   read voCanDelete;
	property fLine	      : cardinal  read voLine write voLine;
	property fCol         : cardinal  read voCol;
	property fPos	      : cardinal  read voPos;	property fIdentCode   : TNodeIdentCode read voIdentCode;

	procedure SetCanDelete(ParDelete:boolean);
	function  GetReplace(ParCre:TCreator):TNodeIdent;virtual;
	procedure GetPos(var ParLine,ParCol,ParPos:longint);
	procedure SetPos(ParLine,ParCol,ParPos:longint);
	procedure SetPosToNode(ParNode : TNodeIDent);
	function  CreateSec(ParCre:TSecCreator):boolean;virtual;
	procedure Print(ParDis:TDisplay);override;
	procedure PrintNode(ParDis:TDisplay);virtual;
	function  CreateMac(ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;virtual;
	procedure ValidatePre(ParCre : TCreator;ParIsSec:boolean);virtual;
	procedure ValidateAfter(ParCre : TCreator);virtual;
	procedure ValidateConstant(ParCre :TCreator;ParProc : TConstantValidationProc);virtual;
	procedure Optimize(ParCre : TCreator);virtual;
	procedure DefinitionUseStatusToError(ParCre : TSecCreator;ParStatus : TAccessStatus;ParItem : TUseItem);
	procedure ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);virtual;
	procedure Proces(ParCre : TCreator);virtual;
	procedure FinishNode(ParCre : TCreator;ParIsSec : boolean);
	function  IsSubNodesSec:boolean;virtual;
end;

	TRefNodeIdent =class of  TNodeIdent;
	TSubListStatementNode=class(TNodeIdent)
	private
		voParts	 :  TNodeList;
	protected
		property iParts : TNodeList read voParts write voParts;
		procedure InitParts;virtual;
      		procedure clear;override;
		procedure commonsetup;override;
	public
		property fParts     : TNodeList read voParts;

		procedure Proces(ParCre : TCreator);override;
		procedure Optimize(ParCre :TCreator); override;
		procedure ValidatePre(ParCre : TCreator;ParIsSec : boolean);override;
		procedure ValidateAfter(ParCre : TCreator);override;
		function  AddNode(ParPart:TNodeIdent):boolean;
   end;


TSecCreator=class(TCreator)
private
	voPoc	     : TSubPoc;
	voLabeltrue  : TLabelPoc;
	voLabelFalse : TLabelPoc;
	voCurrentProc: TPocbase;
	voObjectLIst : TObjectList;
	voStringList : TStringList;
	voBlockNodeList :TList;{TODO Recrusiv dependence with blknode=>abstract TNodeStack?}
	property iPoc           : TSubPoc       read voPoc         write voPoc;
	property iCurrentProc   : TPocBase      read voCurrentProc write voCurrentProc;
	property iObjectLIst    : TObjectLIst   read voObjectLIst  write voObjectLIst;
	property iLabelFalse    : TLabelPoc     read voLabelFalse  write voLabelFalse;
	property iLabelTrue		: TLabelPoc		read voLabelTrue   write voLabelTrue;
	property iStringList    : TStringList   read voStringList  write voStringList;
	property iBlockNodeList : TList read voBlockNodeList write voBlockNodeList;
protected
	procedure   COmmonSetup;override;
	procedure   clear;override;
public

	property fObjectLIst    : TObjectLIst    read voObjectLIst  write voObjectLIst;

	property fLabelTrue     : TLabelPoc     read voLabelTrue;
	property fLabelFalse    : TLabelPoc     read voLabelFalse;
	property fCurrentProc	: TPocBase      read voCurrentProc write voCurrentProc;
	property fPoc           : TSubPoc	read voPoc;
{block}
	function GetBlockByName(const p_Name : ansistring): TNodeIdent;
	function getCurrentBlock : TNodeIdent;
	procedure AddBlock(ParNode : TNodeIdent);
	procedure PopBlock;
{}

	function    CreateThreePoc(ParPoc:TRefFormulaPoc;ParMac1,ParMac2:TMacBase):TMacBase;

	function    MakeCompPoc(ParIn1,ParIn2 : TMacBase;ParType :TIdentCode) : TMacBase;
	function    MakeAddPoc(ParIn1,ParIn2:TMacBase):TMacBase;
	function    MakeAddPoc(ParIn:TMacBase;ParAdd:TNodeIdent;ParOpt : TMacCreateOption):TMacBase;
	function    MakeAddPoc(ParIn:TMacBase;ParAdd:longint):TMacBase;
	function    MakeMulPoc(PArIn1,ParIn2:TMacBase):TMacBase;
	function    MakeMulPoc(ParIn1 : TMacBase;ParIn2:TNumber):TMacBase;
	function    MakeDivPoc(ParIn1 : TMacBase;ParIn2:TNumber):TMacBase;
	function    MakeLoadPoc(ParTo,ParFrom : TMacBase) : TPocBase;
	function    CreateNumberMac(ParSize:TSize;PArSign:boolean;ParNUmber:TNumber):TNumberMac;
	function    ConvJumpToBool(ParSIze : TSize):TMacBase;
	procedure   MakeJumpFromCond(ParCond   : TMacBase);
	function    SetLabelTrue(ParLabel:TLabelPoc):TLabelPoc;
	function    SetLabelFalse(ParLabel:TLabelPoc):TLabelPoc;
	function    SetbooleanLoad(ParMac:TMacBase;ParNum:longint):TPocBase;
	procedure   SwapLabels;
	procedure   SetPoc(ParPoc:TSubPoc);
	procedure   AddNodeError(ParNode:TNodeIdent;ParError:TErrorType;const partext:ansistring);
	procedure   AddNodeWarning(ParNode : TNodeIdent;ParError : TErrorType;const ParText : ansistring);
	procedure   AddSec(ParSec:TSecBase);
	function    CreateLabeL:TLabelPoc;
	function    AddLabel:TLabelPoc;
	procedure   AddObject(ParItem : TRoot);
	function    AddStringConstant(const ParStr : ansistring):longint;
	procedure   ProduceStringConstantSection(ParCre : TCreator);
end;

TErrorNode=class(TNodeIdent)
private
	voMsg:TString;
protected
	procedure CommonSetup;override;

public
	procedure SetMessage(const ParMsg:ansistring);
	function  GetMessage:TString;
	constructor Create(const ParMsg:ansistring);
end;

implementation

uses asminfo,blknodes;

{------( TErrorNode )-------------------------------------------}





procedure   TErrorNode.Commonsetup;
begin
	inherited CommonSetup;
	voMsg := nil;
end;

procedure   TErrorNode.SetMessage(const ParMsg:ansistring);
begin
	if GetMessage<> nil then GetMessage.Destroy;
	voMsg := TString.Create(ParMsg);
end;

function    TErrorNode.GetMessage:TString;
begin
	GetMessage := voMsg;
end;

constructor TErrorNode.Create(const ParMsg:ansistring);
begin
	inherited Create;
	SetMessage(ParMsg);
end;

{---------( TSecCreator )---------------------------------------}


function  TSecCreator.MakeLoadPoc(ParTo,ParFrom : TMacBase) : TPocBase;
var
	vlLoad : TLoadFor;
begin
	if (ParTo.fSize = 3) or (ParTO.fSize > GetAssemblerInfo.GetSystemSize) then begin
		exit(TLsMovePoc.Create(ParFrom,ParTo,ParTo.fSize));
	end else begin
		vlLoad := TLoadFor.Create;
		vlLoad.SetVar(0,ParTo);
		vlLoad.SetVar(1,ParFrom);
		exit(vlLOad);
	end;
end;

function  TSecCreator.AddStringConstant(const ParStr : ansistring):longint;
begin
	exit(iStringList.AddStringItem(ParStr));
end;

procedure TSecCreator.ProduceStringConstantSection(ParCre : TCreator);
begin
	iStringList.CreateDb(ParCre);
end;


procedure   TSecCreator.AddObject(ParItem : TRoot);
begin
	iObjectList.AddObject(ParItem);
end;


{Create jump from compare result}

procedure   TSecCreator.MakeJumpFromCond(ParCond   : TMacBase);
var
	l_Jump: TPocBase;
	
begin

	if(iLabelTrue <> nil) then begin
		l_jump := TCondJumpPoc.create(True,ParCond,iLabelTrue);
		AddSec(l_jump);
	end;
	if(iLabelFalse <> nil) then begin
		if(iLabelTrue = nil) then begin
			l_jump := TCondJumpPoc.create(false,ParCond,iLabelFalse);
			
		end else begin
			l_jump := TJumpPoc.create(iLabelFalse);
			
		end;
		AddSec(l_jump);
	end;
end;

{ Error handling special for nodes}

procedure TSecCreator.AddNodeError(ParNode:TNodeIdent;ParError:TErrorType;const partext:ansistring);
var
	vlLine,vlCol,vlPos:Longint;
begin
	ParNode.GetPos(vlLine,vlCol,vlPos);
	AddError(ParError,vlLine,vlCol,vlPos,ParText);
end;


procedure  TSecCreator.AddNodeWarning(ParNode : TNodeIdent;ParError : TErrorType;const ParText : ansistring);
var
	vlLine,vlCol,vlPos:Longint;
begin
	ParNode.GetPos(vlLine,vlCol,vlPos);
	AddWarning(ParError,vlLine,vlCol,vlPos,ParText);
end;

{creates a number mac}

function TSecCreator.CreateNumberMac(ParSize:TSize;PArSign:boolean;ParNUmber:TNumber):TNumberMac;
var vlSize : TSIze;
	vlSign : boolean;
	vlMac  : TNumberMac;
begin
	vlSize := ParSIze;
	vlSign := ParSign;
	if vlSize = 0 then GetIntSize(ParNumber,vlSize,vlSign);
	vlMac := TNumberMac.create(vlSize,vlSign,ParNumber);
	AddObject(vlMac);
	exit(vlMac);
end;

function TSecCreator.ConvJumpToBool(ParSize : TSize):TMacBase;
var vlMac1   : TMacBase;
	vlJmp    : TJumpPoc;
	vlLabEnd : TLabelPoc;
begin
	vlMac1 := TResultMac.create(ParSize,false);
	AddObject(vlMac1);
	AddSec(iLabelTrue);
	SetbooleanLoad(vlMac1,bv_true);
	vlLabEnd := CreateLabel;
	vlJmp    := TJumpPoc.create(vlLabEnd);
	AddSec(vlJmp);
	AddSec(iLabelFalse);
	SetbooleanLoad(vlMac1,bv_false);
	AddSec(vlLabEnd);
	exit(vlMac1);
end;


function TSecCreator.SetbooleanLoad(ParMac:TMacBase;ParNum:longint):TPocBase;
var   vlLod : TPocBase;
	vlMac : TMacBase;
	vlLi  : TNumber;
begin
	LoadInt(vlLi,ParNum);
	vlMac := TNumberMac.create(ParMac.fSize,false,vlLi);
	AddObject(vlMac);
	vlLod := MakeLOadPoc(ParMac,vlMac);
	AddSec(vlLod);
	exit(vlLod);
end;



function TSecCreator.SetLabelTrue(ParLabel:TLabelPoc):TLabelPoc;
begin
	SetLabelTrue := iLabelTrue;
	voLabelTrue := ParLabel;
end;

procedure TSecCreator.SwapLabels;
var vlTmp:TLabelPoc;
begin
	vlTmp := SetLabelTrue(iLabelFalse);
	SetLabelFalse(vlTmp);
end;



function TSecCreator.SetLabelFalse(ParLabel:TLabelPoc):TLabelPoc;
begin
	SetLabelFalse := iLabelFalse;
	iLabelFalse := ParLabel;
end;


function  TSecCreator.AddLabel:TLabelPoc;
begin
	AddLabel := iPoc.fPocList.AddLabel;
end;



function TSecCreator.CreateLabel:TLabelPoc;
begin
	exit(TLabelPoc.Create);
end;


procedure TSecCreator.AddSec(ParSec:TSecBase);
begin
	iPoc.fPocList.AddSec(parSec);
end;

procedure TSecCreator.clear;
begin
	inherited Clear;
	if iStringList <> nil then iStringList.Destroy;
	if iBlockNodeList <> nil then iBlockNodeList.Destroy;
end;

function TSecCreator.GetBlockByName(const p_Name : ansistring): TNodeIdent;
begin
	exit(TBlockNodeList(iBlockNodeList).GetBlockByName(P_Name));
end;

function TSecCreator.getCurrentBlock : TNodeIdent;
begin
	exit(TBlockNodeLIst(iBlockNodeList).GetCurrentBlock);
end;

procedure TSecCreator.AddBlock(ParNode : TNodeIdent);
begin
	TBlockNodeList(iBlockNodelIst).AddNode(TBlockNode(parNode));
end;

procedure TSecCreator.PopBlock;
begin
	TBlockNodelIst(iBlockNodeList).PopBlock;
end;

procedure TSecCreator.commonSetup;
begin
	inherited CommonSetup;
	iCurrentProc := nil;
	iLabelTrue  := nil;
	iLabelFalse := nil;
	iStringList  := TStringList.Create;
	iPoc         := nil;
	iBlockNodelist := TBlockNodeList.Create;
end;


procedure  TSecCreator.SetPoc(ParPoc:TSubPoc);
begin
	iPoc     := ParPoc;
end;


function   TSecCreator.CreateThreePoc(ParPoc:TRefFormulaPoc;ParMac1,ParMac2:TMacBase):TMacBase;
var vlFormula:TFormulaPoc;
begin
	vlFormula := ParPoc.Create;
	AddSec(vlFormula);
	vlFormula.SetVar(1,ParMac1);
	vlFormula.SetVar(2,ParMac2);
	exit(vlFormula.CalcOutputMac(self));
end;

function    TSecCreator.MakeMulPoc(ParIn1 : TMacBase;ParIn2:TNumber):TMacBase;
var vlOtherNum : TNumber;
begin
	if LargeCompareLong(ParIn2, 1) = LC_Equal then exit(ParIn1);
	if(ParIn1 is TNumberMac) then begin
		vlOtherNum := TNumberMac(ParIn1).fInt;
		LargeMul(vlOtherNum,ParIn2);
		exit(CreateNumberMac(0,false,vlOtherNum));
	end;
	exit(MakeMulPoc(ParIn1,CreateNumberMac(0,false,ParIn2)));
end;

function    TSecCreator.MakeDivPoc(ParIn1 : TMacBase;ParIn2:TNumber):TMacBase;
var vlMac2 : TMacBase;
	vlNum  : TNUmber;
begin
	if (LargeCompareLong(ParIn2 , 1)=LC_Equal) or (ParIn1.IsNumberInt(0)) then exit(ParIn1);
	if (ParIn1 is TNumberMac) then begin
		vlNum := TNumberMac(ParIn1).fInt;
		LargeDiv(vlNum,ParIn2);
		exit(CreateNumberMac(0,false,vlNum));
	end;
	vlMac2 := CreateNumberMac(0,false,ParIn2);
	exit(CreateThreePoc(TDivFor,ParIn1,vlMac2));
end;



function    TSecCreator.MakeMulPoc(PArIn1,ParIn2:TMacBase):TMacBase;

begin
	if (ParIn1.IsNumberInt(0)) or (ParIn2.IsNumberInt(1)) then begin
		exit(ParIn1);
	end;
	if (ParIn1.IsNumberInt(1)) or (ParIn2.IsNumberInt(0)) then begin
		exit(ParIn2);
	end;
	exit(CreateThreePoc(TMulFor,ParIn1,ParIn2));
end;


function    TSecCreator.MakeAddPoc(ParIn1,ParIn2:TMacBase):TMacBase;
begin
	if ParIn1.IsNumberInt(0) then begin
		exit(ParIn2);
	end;
	if ParIn2.IsNumberInt(0) then begin
		exit(ParIn1);
	end;
	exit(CreateThreePoc(TAddFor,ParIn1,ParIn2));
end;

function TSecCreator.MakeAddPoc(ParIn:TMacBase;ParAdd:TNodeIdent;ParOpt:TMacCreateOption):TMacBase;
var vlMac:TMacBase;
begin
	vlMac := ParAdd.CreateMac(ParOpt,self);
	vlMac := MakeAddPoc(ParIn,vlMac);
	exit(vlMac);
end;

{Should be TNUmber?}

function TSecCreator.MakeAddPoc(ParIn:TMacBase;ParAdd:longint):TMacBase;
var vlMac : TMacBase;
	vlLi  : TLargeNumber;
begin
	vlMac := ParIn;
	if ParAdd <> 0 then begin
		LoadInt(vlLi,ParAdd);
		vlMac := CreateNumberMac(0,false,vlLi);
		vlMac := MakeAddPoc(ParIn,vlMac);
	end;
	exit(vlMac);
end;


function TSecCreator.MakeCompPoc(ParIn1,ParIn2 : TMacBase;ParType :TIdentCode) : TMacBase;
var vlPoc : TCompFor;
	vlOut : TMacBAse;
begin
	vlPoc  := TCompFor.Create(ParType);
	vlPoc.SetVar(1,ParIn1);
	vlPoc.SetVar(2,ParIn2);
	vlOut := vlPoc.CalcOutputMac(self);
	AddSec(vlPoc);
	exit(vlOut);
end;


{---------( TNodeList )-----------------------------------------}

procedure TNodeLIst.Proces(ParCre : TCreator);
var
	vlCurrent : TNodeIdent;
begin
	vlCUrrent := TNodeIdent(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.proces(ParCre);
		vlCurrent := TNodeIdent(vlCurrent.fNxt);
	end;
end;

procedure TNodeList.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlCurrent : TNodeIdent;
begin
	vlCUrrent := TNodeIdent(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.ValidatePRE(ParCre,ParIsSec);
		vlCurrent := TNodeIdent(vlCurrent.fNxt);
	end;
end;


procedure TNodeList.Optimize(ParCre : TCreator);
var
	vlCurrent : TNodeIdent;
begin
	vlCurrent := TNodeIDent(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.Optimize(ParCre);
		vlCurrent := TNodeIdent(vlCurrent.fNxt);
	end;
end;



procedure TNodeList.ValidateAfter(ParCre : TCreator);
var
	vlCurrent : TNodeIdent;
begin
	vlCurrent := TNodeIdent(fStart);
	while (vlCurrent<> nil) do begin
		vlCurrent.ValidateAfter(parCre);
		vlCurrent := TNodeIdent(vlCurrent.fNxt);
	end;
end;

function TNodeList.DeleteIfCan(ParCre : TCreator):boolean;
var vlCurrent : TNodeIdent;
	vlNext    : TNodeIdent;
	vlHas     : boolean;
begin
	vlCurrent := TNodeIdent(fStart);
	vlHas := false;
	while vlCurrent <> nil do begin
		vlnext := TNodeIdent(vlCurrent.fNxt);
		if vlCurrent.fCanDelete then begin
			DeleteLink(vlCurrent);
			vlhas := true;
		end;
		vlCurrent := vlnext;
	end;
	exit(vlHas);
end;




function TNodeList.CreateSec(ParCre:TSecCreator):boolean;
var 	 vlCurrent : TNodeIdent;
	vlSec     : TSubPoc;
	vlPoc     : TSubPoc;
begin
	vlSec := TSubPoc.create;
	ParCre.AddSec(vlSec);
	vlPoc     := ParCre.fPoc;
	ParCre.SetPoc(vlSec);
	vlCurrent := TNodeIdent(fStart);
	CreateSec := true;
	while (vlCurrent <>  nil) do begin
		if HandleNode(ParCre,vlCurrent) then exit;
		vlCurrent := TNodeIdent(vlCurrent.fNxt);
	end;
	CreateSec:=false;
	ParCre.SetPoc(vlPoc);
end;


function  TNodeList.CreateMac(ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
begin
	fatal(fat_abstract_routine,'');
	exit(nil);
end;

function TNodeList.HandleNode(ParCre:TSecCreator;ParNode:TNodeIdent):boolean;
begin
	handleNode := ParNode.CreateSec(parcre);
end;

procedure TNodeList.AddNodeAt(ParAt,ParNode : TNodeIdent);
var vlPn:TNodeIdent;
begin
	if ParNode.fPos=0 then begin
		vlPn := ParAt;
		if vlPn = nil then vlPn := TNodeIdent(fTop);
		if vlPn <> nil then ParNode.SetPos(vlPn.fLine,vlPn.fCol,vlPn.fPos);
	end;
	InsertAt(ParAt,ParNode);
end;





function TNodeList.AddNode(ParNode:TNodeIdent):boolean;
begin
	AddNodeAt(TNodeIDent(fTop),ParNode);
	exit(false);
end;

procedure TNodeList.Print(ParDis:TDisplay);
var vlCurrent:TNodeIdent;
begin
	vlCurrent := TNodeIdent(fStart);
	while vlCurrent <> nil do begin
		ParDis.nl;
		vlCurrent.print(PArDis);
		vlCurrent := TNodeIdent(vlCurrent.fNxt);
	end;
end;

procedure TNodeList.ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
var
	vlCurrent:TNodeIdent;
begin
	vlCurrent := TNodeIdent(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.ValidateDefinitionUse(ParCre,ParMode,ParUseList);
		vlCurrent := TNodeIdent(vlCurrent.fNxt);
	end;
end;



{---------( TNodeident )------------------------------------------}



function TNodeIdent.IsSubNodesSec:boolean;
begin
	exit(false);
end;


procedure TNodeIdent.FinishNode(ParCre : TCreator;ParIsSec : boolean);
begin
	Proces(ParCre);
	ValidatePre(ParCre,ParIsSec);
	Optimize(ParCre);
	ValidateAfter(ParCre);
end;


procedure TNodeIdent.ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList  : TUseList);
begin
end;

procedure TNodeIdent.DefinitionUseStatusToError(ParCre : TSecCreator;ParStatus : TAccessStatus;ParItem : TUseItem);

var vlStatus : TAccessStatus;
	 vlErr : TErrorType;
	 vlItem : TUseItem;
	 vlName : ansistring;
begin
		vlStatus :=ParStatus;
		vlItem := ParItem;

		if vlStatus <> AS_Normal then begin
			vlErr := ERR_No_Error;
			case vlStatus of
         	AS_NO_Write       : vlErr := Err_Read_Without_Write;
				AS_MayBe_No_Write : vlErr := Err_Read_Some_without_Write;
		   	AS_NO_Read        : vlErr := Err_Write_Without_Read;
				AS_Maybe_No_Read  : vlErr := Err_Write_Some_Without_Read;
			end;
			if vlErr <> ERR_No_Error then begin
				EmptyString(vlName);
				if vlItem <> nil then vlName := vlItem.GetName;
				ParCre.AddNodeWarning(self,vlErr,vlName);
			end;
		end;
end;



procedure TNodeIdent.ValidateConstant(ParCre : TCreator;ParProc : TConstantValidationProc);
begin
end;

procedure TNodeIdent.Proces(ParCre : TCreator);
begin
end;

procedure TNodeIdent.Optimize(ParCre :TCreator);
begin
end;

procedure TNodeIdent.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
end;

procedure TNodeIdent.ValidateAfter(ParCre : TCreator);
begin
end;

procedure TNodeIdent.SetCanDelete(ParDelete:boolean);
begin
	voCanDelete := PArDelete;
end;

function TNodeIdent.GetReplace(ParCre:TCreator):TNodeIdent;
begin
	GetReplace := nil;
end;

function  TNodeIDent.CreateSec(ParCre:TSecCreator):boolean;
begin
	CreateSec := false;
	ParCre.AddSec(TUnkPoc.create(className));
end;

function TNodeIdent.CreateMac(ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
begin
	fatal(fat_abstract_routine,['option=',cardinal(ParOption)]);
end;


procedure TNodeIDent.GetPos(Var ParLine,ParCol,parPos:Longint);
begin
	ParCol  := fCol;
	ParLine := fLine;
	ParPos  := fPos;
end;

procedure TNodeIdent.SetPosToNode(ParNode : TNodeIDent);
begin
	if ParNode <> nil then SetPos(ParNode.fLine,ParNode.fCol,ParNode.fPos);
end;

procedure TNodeIdent.SetPos(ParLine,ParCol,ParPos:longint);
begin
	voCol  := ParCol;
	voLine := ParLine;
	voPos  := PArPos;
end;

procedure TNodeident.CommonSetup;
begin
	Inherited CommonSetup;
	iIdentCode := IC_UnkownNode;
	SetPos(0,0,0);
	SetCanDelete(false);
end;


procedure TNodeident.print(ParDis:TDisplay);
begin
	PrintNode(ParDis);
end;

procedure TNodeident.PrintNode(ParDis:TDisplay);
begin
	ParDis.Write('<errabstract><routine>PrintNode</routine><classname>'+classname+'</classname></errabstract>');
end;

{-----( TSubListStatementNode )-----------------------------------------------------}




procedure TSubListStatementNode.Commonsetup;
begin
	InitParts;
	inherited Commonsetup;
end;

procedure TSubListStatementNode.Clear;
begin
	inherited Clear;
	if iParts <> nil then iParts.Destroy;
end;

procedure TSubListStatementNode.InitParts;
begin
	iParts := TNodeList.Create;
end;

procedure TSubListStatementNode.Proces(ParCre : TCreator);
begin
	fParts.Proces(ParCre);
end;

procedure TSubListStatementNode.Optimize(ParCre :TCreator);
begin
	iParts.Optimize(ParCre);
	iParts.Proces(ParCre);
end;

procedure TSubListStatementNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
begin
	iParts.ValidatePre(ParCre,IsSubNodesSec);
end;

procedure TSubListStatementNode.ValidateAfter(ParCre : TCreator);
begin
	iParts.ValidateAfter(ParCre);
end;

function TSubListStatementNode.AddNode(ParPart:TNodeIdent):boolean;
begin
	if ParPart <> nil then begin
		exit(iParts.AddNode(ParPart));
	end else begin
		exit(true);
	end;
end;



end.
