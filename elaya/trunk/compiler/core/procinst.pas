{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web : www.elaya.org

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


unit ProcInst;
interface
uses   largenum,  asmdisp,i386cons,progutil,resource,display,elacons,elatypes,Register,error,stdobj,cmp_type;
	
type
	
	TErrorInst=class(TInstruction)
	public
		procedure Print(ParDis:TAsmDisplay);override;
	end;
    {Hack}
	TSizeInstruction=class(TInstruction)
    private
		voOperand : AnsiString;
		voName    : AnsiString;
		property iOperand : AnsiString read voOperand write voOperand;
		property iName    : AnsiString read voName write voName;
	public
		constructor Create(const ParName,ParOperand : ansistring);
		procedure Print(ParDis : TAsmDisplay);override;
	end;

	TFormOperandList=class(TOperandList)
	private
		voIsSigned:boolean;
	protected
		procedure CommonSetup;override;

	Public
		procedure PreResourceListFase(ParCre:TInstCreator);override;
		function  SetSigned:boolean;
		function  Getsigned:boolean;
		function  GetInstructionSize:TSize;
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);virtual;
		procedure AtResourceListFase(ParCre:TInstCreator;ParChange:TChangeList);override;
	end;
	
	
	TOneOperandList = class(TFormOperandList)
		function  GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
	end;
	
	TPushOperandList=class(TFormOperandList)
		procedure PreResourceListFase(ParCre:TInstCreator);override;
		function  GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
		function  GetOpperSize:TSize;override;
	    procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
	end;
	
	
	
	
	TTWoBaseOperandList=class(TFormOperandList)
	private
		voCanSwap:boolean;
		
	protected
		property  iCanSwap : boolean read voCanSwap write voCanSwap;
		
	public
		property  fCanSwap : boolean read voCanSwap write voCanSwap;
		function  GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
		function  MustSwap:boolean;virtual;
		function  SwapParamOptimize:boolean;
		procedure Commonsetup;override;
	end;
	
	TMovOperandList=class(TTWoBaseOperandList)
		function GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
	end;
	
	
	
	
	TLeaOperandList=class(TFormOperandList)
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
	end;
	{TODO:there is a check if there are too many memmory refs. Must that beplaced in TSImpFormoperandlist?}
	
	TSimpFormOperandList=class(TTWoBAseOperandList)
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
	end;
	
	TCmpOperandList=class(TFormOperandList)
		function GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
		function  GetOpperSize:TSize;override;
	end;
                       

			   
	TAddSubOperandList = class(TSimpFormOperandList)
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
	end;
	
	TShrShlOperandList = class(TSimpFormOperandList)
	public
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
		function  GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
	end;


	TFactOperandList=class(TSimpFormOperandList)
		procedure ChangeNumberOpp(ParCre:TInstCreator;ParChange:TChangeList);
	end;
	
	TMulOperandList=class(TFactOperandList)
		procedure CompleteOutput(ParCre:TInstCreator);override;
		function  GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
		function  MustSwap:boolean;override;
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
	end;
	
	TDivOperandList = class(TFactOperandList)
		procedure CompleteOutput(ParCre:TInstCreator);override;
		function  GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
	end;
	
	
	
	TLabelInst=class(TInstruction)
	private
		voLabelName : AnsiString;
		property iLabelName : AnsiString read voLabelName write voLabelName;
	protected
		procedure   CommonSetup;override;

	public
		property fLabelName : AnsiString read voLabelName;
		constructor Create(const ParName:ansistring);
		procedure   Print(ParDIs:TAsmDisplay);override;
	end;

	TFormInst=class(TInstruction)
		function  GetIsSigned:boolean;
		procedure InitOperandList;override;
		procedure InstructionFase(ParCre:TInstCreator);override;
	end;
	
	TCmpInst=class(TFormInst)
	public
		procedure GetInstructionName(var ParName : ansistring);override;
		procedure InitOperandList;override;
	end;


	TMovInst=class(TFormInst)
	private
		voMovType : T386MovType;
		voOrgSize : TSize;
		property iOrgSize : TSize       read voOrgSize write voOrgSize;
		property iMovType : T386MovType read voMovType write voMovType;
	protected
		procedure CommonSetup;override;
	public
		procedure InitOperandList;override;
		procedure InstructionFase(ParCre:TInstCreator);override;
		procedure GetInstructionName(var ParName : ansistring);override;
	end;
	
	TSignExtendInstList=class(TFormOperandList)
	private
		voSize : TSize;
		property iSize : TSize read voSize write voSize;
	public
		property fSize : TSize read voSize;
		constructor create(ParSize :TSize);
		procedure CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);override;
		procedure CompleteOutput(ParCre:TInstCreator);override;
		function  GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
	End;
	
	TSignExtendInst=class(TFormInst)
	private
		voSize : TSize;
		property iSize : TSize read voSize write voSize;
	protected
		procedure Commonsetup;override;
	public
		constructor create(ParSize : TSize);
		procedure InitOperandList;override;
		procedure Print(ParDis : TAsmDisplay);override;
	end;
	
	TTwoInst=class(TFormInst)
	public
		procedure SetCanSwap(ParSwap : boolean);
		procedure InitOperandList;override;
	end;
	
	TAddSubInst=class(TTwoInst)
		procedure InitOperandList;override;
	end;
	
	TAddInst=class(TAddSubInst)
	protected
		procedure   CommonSetup;override;
	public
		procedure   GetInstructionName(var ParName : ansistring);override;
		
	end;
	
	TSubInst=class(TAddSubInst)
		procedure   COmmonSetup;override;
		procedure   GetInstructionName(var ParName : ansistring);override;
	end;
	
    TShrShlInst=class(TTwoInst)
		procedure   InitOperandList;override;
	end;

	TShrInst=class(TShrShlInst)
		procedure   CommonSetup;override;
		procedure   GetInstructionName(var ParName : ansistring);override;		
	end;

	TShlInst=class(TShrShlInst)
		procedure   CommonSetup;override;
		procedure   GetInstructionName(var ParName : ansistring);override;		
	end;

	TMulInst=class(TTWoInst)
	protected
		procedure   CommonSetup;override;
	public
		procedure   InitOperandList;override;
		procedure   GetInstructionName(var ParName : ansistring);override;		
	end;
	
	TDivInst=class(TTwoInst)
	protected
		procedure   CommonSetup;override;

	public
		procedure   InitOperandList;override;
		procedure   GetInstructionName(var ParName : ansistring);override;
	end;
	
	
	TOrInst = class(TTwoInst)
	public
		procedure CommonSetup;override;
		procedure GetInstructionName(var ParName : ansistring);override;
	end;
	
	TAndInst = class(TTwoInst)
		procedure CommonSetup;override;
		procedure GetInstructionName(var ParName : ansistring);override;
	end;
	
	TXorInst = class(  TTwoInst)
		procedure CommonSetup;override;
		procedure  GetInstructionName(var ParName : ansistring);override;
	end;
	
	TJumpInst=class(TInstruction)
	private
		voLabel:TLabelInst;
	protected
		property iLabel : TLabelInst  read voLabel write voLabel;
		procedure   CommonSetup;override;

	public
		constructor Create(const ParLabel:TLabelInst);
		procedure   GetInstructionName(var ParName : ansistring);override;
		procedure   Print(ParDis:TAsmDisplay);override;
	end;
	
	TCondJumpOperandList=class(TOperandList)
		function  GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;override;
	end;
	
	TCondJumpInst=class(TJumpInst)
		procedure InitOperandList;override;
		procedure CommonSetup;override;
		procedure Print(ParDis:TAsmDisplay);override;
	end;
	
	TRetInst = class(TInstruction)
	private
		voRetSize : TSize;
	protected
		procedure CommoNSetup;override;

	public
		constructor Create(ParSize:TSize);
		procedure Print(ParDis:TAsmDisplay);override;
		procedure SetRetSize(ParSize:TSize);
		function  GetRetSize:TSize;
		procedure   GetInstructionName(var ParName : ansistring);override;
		
	end;
	
	TStackInst=class(TInstruction)
	end;
	
	TPushInst=class(TStackInst)
	protected
		procedure CommonSetup;override;
	public
		procedure InitOperandList;override;
		procedure GetInstructionName(var ParName : ansistring);override;
		
	end;
	
	TPopInst=class(TStackInst)
	protected
		procedure CommonSetup;override;
	public
		procedure GetInstructionName(var ParName : ansistring);override;
	end;
	
	TLeaInst=class(TInstruction)
	protected
		procedure CommonSetup;override;
	public
		procedure InitOperandList;override;
		procedure GetInstructionName(var ParName : ansistring);override;
	end;
	
	TCallOperandList=class(TOperandList)
	public
		procedure AtResourceListFase(ParCre:TInstCreator;ParChange:TChangeList);override;
		procedure Print(parDis:TAsmDisplay);override;
	end;
	
	TCallInst = class(TInstruction)
		procedure   CommonSetup;override;
		procedure   Print(ParDis:TAsmDisplay);override;
		procedure   InitOperandList;override;
	end;
	
	TRegResComment=class(TInstruction)
	private
		voReg : TRegister;
		voRes : boolean;
	public
		procedure SetReg(ParReg:TRegister);
		function  GetReg:TRegister;
		procedure SetRes(ParRes:boolean);
		function  GetRes:boolean;
		procedure Print(ParDis:TAsmDisplay);override;
		constructor Create(ParReg:TRegister;ParRes:boolean);
	end;
	
	TIncDecInst=class(TInstruction)
	private
		voIncFlag:boolean;
		property  iIncFlag : boolean read voIncFlag write voIncFlag;
		
	public
		constructor Create(ParFlag:boolean);
		procedure GetInstructionName(var ParName : ansistring);override;
		procedure CommonSetup;override;
	end;
	
	TOneInst=class(TFormInst)
		procedure InitOperandList;override;
	end;
	
	TNegInst=class(TOneInst)
	protected
		procedure Commonsetup;override;
	public
		procedure GetInstructionName(var ParName : ansistring);override;
	end;
	
	TNotInst=class(TOneInst)
	protected
		procedure Commonsetup;override;
	public
		procedure GetInstructionName(var ParName : ansistring);override;
	end;
	
	TAsmInst=class(TInstruction)
	private
		voAsmText : pointer;
		voSize    : cardinal;
      property iAsmText : pointer read voAsmText write voAsmText;
		property iSize : cardinal read voSize write voSize;
	public
		property fSize : cardinal read voSize;
		property fAsmText : pointer read voAsmText;

		constructor Create(ParSize : TSize;ParText:pointer);
		procedure clear;override;
		procedure ResetText;
		procedure COmmonsetup; override;
		procedure Print(parDis:TAsmDisplay);override;
	end;
	
	TNopInst=class(TInstruction)
	public
		procedure COmmonsetup;override;
		procedure GetInstructionName(var ParName : ansistring);override;
		
	end;
	
	
implementation


uses asminfo;

{-----( TSizeInstruction )-------------------------------------------------------------}

constructor TSIzeInstruction.Create(const ParName,ParOperand : ansistring);
begin
	iOperand := ParOperand;
	iName    := ParName;
	inherited Create;
end;

procedure TSIzeInstruction.Print(ParDis : TAsmDisplay);
begin
	ParDis.Print(['.size ',iOperand]);ParDIs.nl;
	ParDis.Print(['.type ',iName,',@function']);
end;


{-----( TErrorInst )--------------------------------------------------------------------}



procedure TErrorInst.Print(ParDis:TAsmDisplay);
begin
	parDis.Write('<Error>');
end;



{----( TNopInst )----------------------------------------------------}


procedure TNopInst.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_386_NopInst;
end;

procedure TNopInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Nop;
end;


{----( TAsmNode )-------------------------------------------------------------}



procedure TAsmInst.Print(parDis:TAsmDisplay);
begin
	PARDIS.WriteRaw(voAsmText,iSize);
	ParDis.writeNl('');
end;

constructor TAsmInst.Create(ParSize : TSize;ParText:pointer);
begin
	inherited Create;
	iAsmText := ParText;
	iSize := ParSize;
end;

procedure TAsmInst.clear;
begin
	inherited Clear;
	if iAsmText <> nil then FreeMem(voAsmText,iSize);
end;

procedure TAsmInst.ResetText;
begin
	if voAsmText <> nil then begin
		Freemem(voAsmText,iSize);
		iSize := 0;
	end;
end;


procedure TAsmInst.commonsetup;
begin
	inherited Commonsetup;
	iAsmText := nil;
	iSize := 0 ;
	iIdentCode := (IC_386_AsmInst);
end;




{---( TOneOperandList )--------------------------------------------------}

function TOneOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
begin
	GetPrintPosition := true;
	if ParRes.TestIdentNumber(In_In_1)     then ParPosition := 1
	else if ParRes.TestIdentNumber(In_Main_Out) then ParPosition := 1
	else Fatal(Fat_Invalid_IdentNumber,['In:',ClassName]);
end;

procedure TOneOperandList.CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);
var vlChange0 : TChangeItem;
	vlChange1 : TChangeItem;
	vlRes0    : TOperand;
begin
	vlChange0 := ParChange.GetItemByIdentNumberErr(IN_Main_Out);
	vlChange1 := ParChange.GetItemByIdentNumberErr(In_in_1);
	vlRes0    := vlChange0.fOperand;
	vlChange1.SetChangeSize(vlRes0.GetSize);
	vlChange1.SetChangeRegisterCode(RC_Combine_ZO);
	HandleChange(ParCre,ParChange);
	CombineZo(ParCre);
end;


{---( TOneInst )------------------------------------------------------}

procedure TOneInst.InitOperandList;
begin
	iOperandList := TOneOperandList.Create;
end;

{---( TNegInst )------------------------------------------------------}


procedure TNegInst.Commonsetup;
begin
	inherited commonsetup;
	iIdentCode := IC_386_NegInst;
end;

procedure TNegInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Neg;
end;


{---( TNotInst )------------------------------------------------------}



procedure TNotInst.Commonsetup;
begin
	inherited commonsetup;
	iIdentCode := IC_386_NotInst;
end;

procedure TNotInst.GetInstructionName(var ParName : ansistring);
begin
	ParNAme := MN_Not;
end;


{---( TIncDecInst )---------------------------------------------------}

constructor  TIncDecInst.Create(ParFlag:boolean);
begin
	iIncFlag := ParFlag;
	inherited Create;
end;

procedure TIncDecInst.CommonSetup;
begin
	inherited commonsetup;
	if iIncFlag then iIdentCode := IC_386_IncInst
	else iIdentCode := IC_386_DecInst;
end;

procedure TIncDecInst.GetInstructionName(var ParName : ansistring);
begin
	if iIncFlag then ParName := MN_Inc
	else ParName := MN_Dec;
end;


{---( TLeaInst )--------------------------------------------------------}


procedure TLeaInst.InitOperandList;
begin
	iOperandList := TLeaOperandList.Create;
end;

procedure TLeaInst.COmmonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_386_leaInst;
end;

procedure TLeaInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Lea;
end;


{---( TLeaOperandList )-----------------------------------------------------}


procedure TLeaOperandList.CheckOperands(ParCre : TInstCreator;ParChange : TChangeList);
var vlChange1 : TChangeItem;
	vlRes1    : TOperand;
begin
	vlChange1 := ParChange.GetItemByIdentNumberErr(In_Main_Out);
	vlRes1    := vlChange1.fOperand;
	if vlRes1.GetResCode <> RT_Register then vlChange1.SetChangeRegisterCode(RC_Change_To_Reg);
	HandleChange(ParCre,ParChange);
end;


{---( TCallOperandList )---------------------------------------------------}

procedure TCallOperandList.AtResourceListFase(ParCre : TInstCreator;ParChange : TChangeList);
var vlChange1 : TChangeItem;
	vlRes1    : TOperand;
begin
	vlChange1 := ParChange.GetItemByIdentNumberErr(In_In_1);
	vlRes1    := vlChange1.fOperand;
	if vlRes1.GetResCode in [RT_Number,RT_NumberByExp] then vlChange1.SetChangeRegisterCode(RC_Change_To_Reg);
	HandleChange(ParCre,ParChange);
end;


procedure TCallOperandList.Print(parDis:TAsmDisplay);
var vlRes:TOperand;
begin
	vlRes := TOperand(fStart);
	if vlRes.GetResCode <> RT_LabelRes then ParDis.Write('*');
	vlRes.Print(parDis);
end;

{---( TCallInst )-------------------------------------------------------}


procedure TCallInst.InitOperandList;
begin
	iOperandList := (TCallOperandList.Create);
end;

procedure TCallInst.COmmonsetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_386_CallInst);
end;


procedure   TCallInst.Print(ParDis:TAsmDisplay);
begin
	ParDis.Write(MN_CALL);
	ParDis.Write(' ');
	iOperandList.Print(ParDis);
end;


{----( TRegResComment )------------------------------------}

procedure TRegResComment.SetReg(ParReg:TRegister);
begin
	voReg := ParReg;
end;

function  TRegResComment.GetReg:TRegister;
begin
	GetReg := voReg;
end;

procedure TRegResComment.SetRes(ParRes:boolean);
begin
	voRes := ParRes;
end;

function  TRegResComment.GetRes:boolean;
begin
	GetRes := voRes;
end;

constructor TRegresComment.Create(ParReg:TRegister;ParRes:boolean);
begin
	inherited Create;
	SetReg(ParReg);
	SetRes(ParRes);
end;

procedure TRegResComment.print(parDis:TAsmDisplay);
var vlName:ansistring;
begin
	ParDis.Write('#');
	if GetRes then ParDis.Write(' Reserve Register :')
	else ParDis.Write(' Release Register :');
	vlName := GetReg.GetName;
	ParDis.Write(vlName);
end;



{---( TFactOperandList )---------------------------------------}




procedure TFactOperandList.ChangeNumberOpp(ParCre : TInstCreator ; ParChange : TChangeList);
var vlOut       : TOperand;
	vlNum       : TOperand;
	vlSize      : TSize;
	vlCode      : TResourceIdentCode;
	vlOutChange : TChangeItem;
	vlNumCHange : TChangeItem;
begin
	vlOutChange := ParChange.GetItemByIdentNumberErr(In_main_Out);
	vlOut       := vlOutChange.fOperand;
	vlSize      := vlOut.GetSize;
	vlNumChange := ParChange.GetItemByIdentNumberErr(In_In_2);
	vlNum       := vlNumChange.fOperand;
	vlCode      := vlNum.GetResCode;
	if (vlCode in [RT_LabelRes,RT_Number, RT_NumberByExp]) then begin
		vlNumChange.SetChangeSize(vlSize);
		vlNumChange.SetChangeRegisterCode(RC_Change_To_Reg);
	end;
	vlNumChange:= ParChange.GetItemByIdentNumberErr(In_In_1);
	vlNum      := vlNumChange.fOperand;
	vlCode     := vlNum.GetResCode;
	if (vlCode in [RT_LabelRes,RT_Number,RT_NumberByExp]) then begin
		vlNumChange.SetChangeSize(vlSize);
		vlNumChange.SetChangeRegisterCode(RC_Change_To_Reg);
	end;
	
end;


{----( TDivOperandList )---------------------------------------}

procedure TDivOperandList.COmpleteOutput(ParCre:TInstCreator);
var vlRes:TOperand;
	vlIdent:TFlag;
	vlReg:TRegister;
	vlName:TNormal;
begin
	vlRes  := GetResByIdent(In_Mod_Out);
	vlIdent := In_Main_Out;
	vlName := RN_EAX;
	if vlRes = nil then begin
		vlRes := GetResByIdent(In_Main_Out);
		vlIdent := In_Mod_Out;
		vlName  := RN_EDX;
	end;
	vlReg :=ParCre.GetAsRegisterByName(vlName,vlRes.GetSize);
	ForceOutputTo(ParCre,vlIdent,vlReg);
end;

procedure TDivOperandList.CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);
var  vlRegResChange : TChangeItem;
	vlOutChange	   : TChangeItem;
begin
	
	{ATT: iCanSwap  op andere plek init}
	iCanSwap       := false;
	vlOutChange    := ParChange.GetItemByIdentNumberErr(In_Main_Out);
	vlOutChange.ForceToRegister(RN_Eax);
	vlRegResChange := ParChange.GetItemByIdentNumberErr(In_Div_High_In);
	case vlRegResChange.fSize of
	1: vlRegResChange.ForceToRegister(RN_AH);
	2,4 : vlRegResChange.ForceToRegister(RN_Edx);
	else Fatal(Fat_Invalid_Operand_Size,['Size=',vlRegResChange.fSize]);
	end;
	vlRegResChange := ParChange.GetItemByIdentNumberErr(In_Mod_Out);
	vlRegResChange.ForceToRegister(RN_EDx);
	ChangeNumberOpp(ParCre,ParChange);
	inherited CheckOperands(ParCre,ParChange);
end;


function  TDivOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
var vlStr:ansistring;
begin
	ParPosition := 2;
	GetPrintPosition := false;
	if ParRes.TestIdentNumber(In_In_2) then begin
		GetPrintPosition := true;
		ParPosition := 1;
	end else
	if not( ParRes.TestIdentNumber(In_In_1)
	or  ParRes.TestIdentNumber(In_Main_Out)
	or  ParRes.TestIDentNumber(IN_Mod_Out)
	or  ParRes.TestIdentNumber(In_Div_High_In))
	then begin
		Str(ParRes.fIdentNumber,vlStr);
		fatal(Fat_Invalid_IdentNumber,'id='+vlStr+', TDivOperandList.GetPrintPosition');
	end;
end;

{---( TShrInst )------------------------------------------------}

procedure TShrInst.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_386_ShrInst;
end;

procedure TShrInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_SHR;
end;


{---( TShlInst )------------------------------------------------}

procedure TShlInst.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_386_ShrInst;
end;

procedure TShlInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_SHL;
end;


{---( TShrShlInst )---------------------------------------------}

procedure TShrShlInst.InitOperandList;
begin
	iOperandList := TShrShlOperandList.Create;
end;


{---( TShrShlOperandList )--------------------------------------}

procedure TShrShlOperandList.CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);
var
	vlChange :TChangeItem;

	vlOut    : TChangeItem;
begin
    vlChange := ParChange.GetItemByIdentNumberErr(In_In_2);
    if vlChange.GetResourceTypeCode <> RT_Number then begin
		vlChange.ForceToRegister(RN_ECx);
		vlChange.SetChangeSize(1);
	end;
	vlOut    := ParChange.GetItemByIdentNumberErr(in_Main_Out);
	vlChange := ParChange.GetItemByIdentNumberErr(In_In_1);
	vlChange.SetChangeRegisterCode(RC_Combine_ZO);
	vlChange.SetChangeSize(vlOut.fSize);
	HandleChange(ParCre,ParChange);
	CombineZo(ParCre);
end;

function  TShrShlOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
begin
	GetPrintPosition := true;
	if ParRes.TestIdentNumber(In_IN_1)     then ParPosition := 1
	else if ParRes.TestIdentNumber(In_Main_Out) then ParPosition := 1
	else if ParRes.TestIdentNumber(In_In_2)     then ParPosition := 2
	else Fatal(Fat_Invalid_IdentNumber,'In : TTwoBaseOperandList.GetPrintPosition');
end;


{----( TMulOperandList )---------------------------------------}


procedure TMulOperandList.COmpleteOutput(ParCre:TInstCreator);
var vlReg:TRegister;
	vlRes:TOperand;
begin
	vlRes := GetResByIdent(IN_Main_Out);
	vlReg := ParCre.GetAsRegisterByName(RN_EDX,vlRes.GetSize);
	ForceOutputTo(ParCre,In_High_Out,vlReg);
end;


function  TMulOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
begin
	ParPosition := 2;
	GetPrintPosition := false;
	if ParRes.TestIdentNumber(In_In_2) then begin
		GetPrintPosition := true;
		ParPosition := 1;
	end else
	if not( ParRes.TestIdentNumber(In_In_1)
	or  ParRes.TestIdentNumber(In_Main_Out)
	or  ParRes.TestIdentNumber(In_High_Out))
	then fatal(Fat_Invalid_IdentNumber,'TMulOperandList.GetPrintPosition');
end;

function TMulOperandList.MustSwap:boolean;
var vlRes1,vlRes2:TOperand;
begin
	vlRes1 := GetResByIdent(In_in_1);
	vlRes2 := GetResByIdent(In_In_2);
	if iCanSwap then begin
		if(not (vlRes1.GetResCode in [RT_LabelRes,RT_Number, RT_NumberByExp])) then begin
			if vlRes2.GetResCode in [RT_LabelRes,RT_Number,RT_NumberByExp] then exit(true);
			if vlRes2.GetResCode = RT_Register then begin
				if TRegisterRes(vlRes2.fResource).GetRegisterCode in [RN_EAX,RN_AX,RN_AL] then exit(true);
				if vlRes1.GetResCode <> RT_Register then exit(true);
			end;
		end;
	end;
	exit(false);
end;

procedure TMuLOperandList.CheckOperands(ParCre:TInstCreator;ParChange:TChangelist);
var vlOutChange:TChangeItem;
begin
	vlOutChange := ParChange.GetItemByIdentNumberErr(In_Main_Out);
	vlOutChange.ForceToRegister(RN_Eax);
	ChangeNUmberOpp(ParCre,ParChange);
	inherited CheckOperands(ParCre,ParChange);
end;


{----( TPopInst )------------------------------------------}


procedure TPopInst.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_386_PopInst);
end;


procedure TPopInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Pop;
end;


{----( TPushInst )-----------------------------------------}


procedure TPushInst.InitOperandList;
begin
	iOperandList := TPushOperandList.Create;
end;

procedure TPushInst.commonsetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_386_PushInst);
end;

procedure TPushInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Push;
end;



{----( TPushOperandList )------------------------------------------}


procedure TPushOperandList.PreResourceListFase(ParCre:TInstCreator);
var
	vlOpp : TOperand;
begin
	vlOpp := GetResByIdent(In_In_1);
	PopResource(ParCre,vlOpp);
	DeleteInputfromUse(ParCre);
	CompleteOutput(ParCre);
end;

function TPushOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
begin
	ParPosition      := 1;
	GetPrintPosition := true;
	if ParRes.TestIdentNUmber(In_Main_Out) then begin
		GetPrintPosition := false;
	end else if not ParRes.TestIDentNumber(In_In_1) then fatal(fat_Invalid_IdentNumber,'TPushOperandList.GetPrintPosition');
end;

function TPushOperandList.GetOpperSize:TSize;
var vlRes:TOperand;
begin
	GetOpperSize := 0;
	vlRes := TOperand(fStart);
	if vlRes <> nil then GetOpperSize := vlRes.GetSize;
end;

procedure TPushOperandList.CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);
var
	vlChange : TChangeItem;
begin
	vlChange := ParChange.GetItemByIdentNumberErr(In_In_1);
	if vlChange.GetResourceSize <> Size_PushSize then begin
		vlChange.SetChangeSize(Size_PushSize);
		vlChange.SetChangeRegisterCode(RC_Automatic);
	end;
	HandleChange(ParCre,ParChange);
end;

{---( TRetInst )-----------------------------------------------------}


procedure   TRetInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Ret;
end;

constructor TRetInst.Create(ParSize:TSize);
begin
	inherited Create;
	SetRetSize(ParSize);
end;


procedure TRetInst.SetRetSize(ParSize:TSize);
begin
	voRetSize := parSize;
end;

function  TRetInst.GetRetSize:TSize;
begin
	GetRetSize := voRetSize;
end;

procedure TRetInst.Print(ParDis:TAsmDisplay);
var vlNum : TNumber;
begin
	inherited print(ParDis);
	if GetRetSize <> 0 then begin
		LoadLOng(vlNum,GetRetSize);
		ParDis.AsPrintNumber(2,vlNum);
	end;
end;


procedure TRetInst.commonsetup;
begin
	inherited commonSetup;
	iIdentCode := (IC_386_RetInst);
end;


{---(TMovOperandList)-----------------------------------------------------}

function TMovOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
var vlStr:ansistring;
begin
	GetPrintPosition := true;
	if ParRes.TestIdentNumber(IN_In_1)     then ParPosition := 2 else
	if ParRes.TestIdentNumber(IN_Main_Out) then ParPosition := 1
	else begin
		Str(ParRes.fIdentNumber,vlStr);
		Fatal(Fat_Invalid_IdentNumber,'#:'+vlStr+'In:TMovOperandList.GetPrintPosition');
	end;
end;

procedure TMovOperandList.CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);
var vlRes1	: TOperand;
	vlRes2      : TOperand;
	vlChange2   : TChangeItem;
	vlType1	: TResourceIdentCode;
	vltype2     : TResourceIdentCode;
begin
	vlRes1    := GetResByIdent(In_Main_Out);
	vlChange2 := ParChange.GetItemByIdentNumberErr(In_In_1);
	vlRes2    := vlChange2.fOperand;
	vlType1   := vlres1.GetResCode;
	vlType2   := vlRes2.GetResCode;
	if  (Vltype1 in [RT_Memory,RT_ByPtr, RT_StackMem])
	and ( Vltype2 in [RT_Memory,RT_ByPtr, RT_StackMem])  then begin
		vlChange2.SetChangeRegisterCode(RC_Change_TO_Reg);
	end;
	if ((vlRes1.GetSize > vlRes2.GetSize) and ((vlType1 <> RT_Register) or (vlType2 in [RT_Number,RT_NumberByExp])))
	or (vlRes1.GetSize < vlRes2.GetSize)  then begin
		vlChange2.SetChangeSize(vlRes1.GetSize);
		vlChange2.SetChangeRegisterCode(RC_Automatic);
	end;
	HandleChange(ParCre,ParChange);
end;


{---( TCmpOperandList )--------------------------------------------------}

function TCmpOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
var vlStr:ansistring;
begin
	GetPrintPosition := true;
	if ParRes.TestIdentNumber(In_In_1) then ParPosition := 1 else
	if ParRes.TestIdentNumber(In_In_2) then ParPosition := 2 else
	if ParRes.TestIdentNUmber(In_Flag_Out) then begin
		GetPrintPosition := false;
		ParPosition := 0;
	end else begin
		str(ParRes.fIdentNumber,vlStr);
		fatal(Fat_Invalid_identNumber,'#='+   vlStr+' In :TCmpOperandList.GetPrintPosition');
	end;
end;

procedure TCmpOperandList.CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);
var vlRes2    : TOperand;
	vlType1   : TResourceIdentCode;
	vlType2   : TResourceIdentCode;
	vlSize    : TSize;
	vlSize2   : TSize;
	vlRes1    : TOperand;
	vlChange1 : TChangeItem;
	vlChange2 : TChangeItem;
begin
	inherited CheckOperands(Parcre,ParChange);
	vlChange1 := ParChange.GetItemByIdentNumberErr(In_In_1);
	vlChange2 := ParChange.GetItemByIdentNumberErr(in_In_2);
	vlRes1  := vlChange1.fOperand;
	vlRes2  := vlChange2.fOperand;
	vlType1 := vlRes1.GetResCode;
	vlType2 := vlRes2.GetResCode;
	vlSize  := vlRes1.GetSize;
	vlSize2 := vlRes2.GetSize;
	if vlSize2 > vlSize then begin
		vlSize :=vlSize2;
		vlChange1.SetChangeSize(vlSize);
		vlChange1.SetChangeRegisterCode(RC_Automatic);
	end else begin
		vlChange2.SetChangeSize(vlSize);
		vlChange2.SetChangeRegisterCode(RC_automatic);
	end;
	
	if (
	(vlType1 in [RT_Memory, RT_StackMem, RT_ByPtr])
	and
	(vlType2  in [RT_Memory, RT_StackMem, RT_ByPtr])
	)
	or
	(
	(vlType1 in [RT_LabelRes,RT_Number, RT_NumberByexp])
	)
	then begin
		vlChange1.SetChangeRegisterCode(RC_Change_To_Reg);
	end;
	HandleChange(ParCre,ParChange);
end;

function TCmpOperandList.GetOpperSize:TSize;
var vlItem1:TResource;
	vlItem2:TResource;
	vlSize:TSize;
begin
	vlSize := 0;
	vlItem1 := GetResByIdent(In_In_1).fResource;
	vlItem2 := GetResByIdent(In_In_2).fResource;
	if vlItem1 <> nil then vlSize := vlItem1.fSize;
	if vlITem2 <> nil then vlSIze := max(vlSize,vlItem2.fSize);
	exit(vlSize);
end;




{---( TJumInst )-----------------------------------------------------}

constructor TJumpInst.Create(const PArLabel:TLabelInst);
begin
	inherited Create;
	iLabel := ParLabel;
end;



procedure TJumpInst.Print(ParDis:TAsmDisplay);
begin
	inherited Print(ParDis);
	ParDis.Print([' ',iLabel.fLabelName]);
end;

procedure TJumpInst.Commonsetup;
begin
	inherited CommoNSetup;
	iIdentCode := (IC_386_JumpInst);
end;

procedure  TJumpInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_JUmp;
end;


{---( TCOndJumpOperandList )---------------------------------------------}

function  TCondJumpOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
begin
	if ParRes.TestIdentNumber(In_In_1) then ParPosition := 1
	else  fatal(Fat_Invalid_identNumber,'[Resource type='+ParRes.fResource.ClassName+'][ClassName='+className+'][#='+   IntToStr(ParRes.fIdentNumber)+'] In :GetPrintPosition');
	exit(true);
end;

{---( TCOndJumpInst)-------------------------------------------------}

procedure TCondJumpInst.InitOperandList;
begin
	iOperandList := TCondJumpOperandList.Create;
end;

procedure TCondJumpInst.commonsetup;
begin
	inherited CommoNSetup;
	iIdentCode := IC_386_CondJumpInst;
end;



procedure TCondJumpInst.Print(parDis:TAsmDisplay);
begin
	ParDis.Write('J');
	iOperandList.Print(ParDis);
	ParDis.print([' ',iLabel.fLabelName]);
end;

{---( TTwoBaseOperandList )----------------------------------------------}

procedure TTwoBaseOperandList.Commonsetup;
begin
	inherited Commonsetup;
	iCanSwap := false;
end;

function  TTwoBaseOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
begin
	GetPrintPosition := true;
	if ParRes.TestIdentNumber(In_IN_1)     then ParPosition := 1
	else if ParRes.TestIdentNumber(In_Main_Out) then ParPosition := 1
	else if ParRes.TestIdentNumber(In_In_2)     then ParPosition := 2
	else if ParRes.TestIdentNumber(In_Flag_Out) then begin
		ParPosition := 0;
		exit(false);
	end
	else Fatal(Fat_Invalid_IdentNumber,'In : TTwoBaseOperandList.GetPrintPosition');
end;

function  TTwoBaseOperandList.MustSwap:boolean;
var vlRes1,vlRes2:TOperand;
begin
	vlRes1 := GetResByIdent(In_In_1);
	vlRes2 := GetResByIdent(In_In_2);
	MustSwap := iCanswap and
	((vlRes1.GetResCode in [RT_LabelRes,RT_Number, RT_NumberByExp])
	or ((vlRes2.GetResCode=RT_Register)
	and (vlRes1.GetResCode <> RT_Register)))
end;

function  TTwoBaseOperandList.SwapParamOptimize:boolean;
var vlRes1,vlRes2:TOperand;
begin
	SwapParamOptimize := false;
	if MustSwap then begin
		SwapParamOptimize := true;
		vlRes1 := GetResByIdent(In_In_1);
		vlRes2 := GetResByIdent(In_In_2);
		vlRes1.SetIdentNumber(In_In_2);
		vlRes2.SetIdentNumber(In_in_1);
	end;
end;


{---( TCmpInst )-----------------------------------------------------}

procedure  TCmpInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Cmp;
end;


procedure TCmpInst.InitOperandList;
begin
	iOperandList := TCmpOperandList.Create;
end;


{---( TFormInst )----------------------------------------------------}



function  TFormInst.GetIsSigned:boolean;
begin
	GetIsSigned := TFormOperandList(iOperandList).GetSigned;
end;

procedure TFormInst.InitOperandList;
begin
	iOperandList := TFormOperandList.Create;
end;

procedure TFormInst.InstructionFase(ParCre:TInstCreator);
begin
	TFormOperandList(iOperandList).ResourceListFase(ParCre);
end;




{---( TTwoInst )-----------------------------------------------------}


procedure TTwoInst.SetCanSwap(ParSwap : boolean);
begin
	TSimpFormOperandList(iOperandList).fCanSwap := ParSwap;
end;

procedure TTwoInst.InitOperandList;
begin
	iOperandList := TSimpFormOperandList.Create;
end;



{---(TFormOperandList )---------------------------------------------------}

function TFormOperandList.GetInstructionSize:TSize;
begin
	GetInstructionSize := GetResByIdent(In_Main_Out).GetSize;
end;


procedure TFormOperandList.PreResourceListFase(ParCre:TInstCreator);
begin
	inherited PreResourceListFase(ParCre);
	SetSigned;
end;


procedure TFormOperandList.AtResourceListFase(PArcre:TInstCreator;ParChange:TChangeList);
begin
	CheckOperands(PArCre,ParChange);
	inherited AtResourceListFase(ParCre,ParChange);
end;

procedure TFormOperandList.CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);
begin
end;


procedure TFormOperandList.COmmonSetup;
begin
	inherited COmmonSetup;
	voIsSIgned := false;
end;

function TFormOperandList.GetSigned:boolean;
begin
	GetSigned := voIsSigned;
end;


function TFormOperandList.SetSigned:boolean;
var vlCurrent:TOperand;
begin
	vlCurrent := TOperand(fStart);
	voIsSigned :=false;
	while vlCurrent <> nil do begin
		if vlCurrent.fResource.fSign then begin
			voIsSigned :=true;
			break;
		end;
		vlCurrent := TOperand(vlcurrent.fNxt);
	end;
	SetSigned := voIsSigned;
end;

{---( TAddSubOperandList )-----------------------------------------------------}

procedure TAddSUbOperandList.CheckOperands(ParCre : TInstCreator;ParChange :TChangelist);
var vlChange1 : TChangeItem;
	vlChange2 : TChangeItem;
	vlChange3 : TChangeItem;
begin
	vlChange1 := ParChange.GetItemByIdentNumberErr(In_In_1);
	vlChange2 := ParChange.GetItemByIdentNumberErr(In_In_2);
	vlChange3 := ParChange.GetItemByIdentNumberErr(in_Main_Out);
	if  (vlChange1.GetResourceTypeCode in [RT_Memory,RT_ByPtr, RT_StackMem])
	and ( vlChange2.GetResourceTypeCode in [RT_Memory,RT_ByPtr, RT_StackMem])
	and ( vlChange3.GetResourceTypeCode in [RT_Memory,RT_ByPtr, RT_StackMem]) then begin
		vlChange2.SetChangeRegisterCode(RC_Change_TO_Reg);
	end;
	vlChange2.SetChangeSize(vlChange3.GetResourceSize);
	vlChange2.SetChangeRegisterCode(RC_Automatic);
	vlChange1.SetChangeSize(vlChange3.GetResourceSize);
	vlChange1.SetChangeRegisterCode(RC_Automatic);
	inherited CheckOperands(ParCre,ParChange);
end;

{---(TSimpFormOperandList )----------------------------------------------------}


procedure TSimpFormOperandList.CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);
var
	vlChange1 : TChangeItem;
	vlChange2 : TChangeItem;
	vlChange3 : TChangeItem;
begin
	
	if GetNumItems = 2 then begin
		HandleChange(ParCre,ParChange);
	end else begin
		SwapParamOptimize;
		vlChange1 := ParChange.GetItemByIdentNumberErr(In_In_1);
		vlChange2 := ParChange.GetItemByIdentNumberErr(In_In_2);
		vlChange3 := ParChange.GetItemByIdentNumberErr(In_main_Out);
		vlChange2.SetChangeSize(vlChange3.fSize);
		vlChange2.SetChangeRegisterCode(RC_automatic);
		vlChange1.SetChangeSize(vlChange3.fSize);
		vlChange1.SetChangeRegisterCode(RC_Combine_ZO);
		HandleChange(ParCre,ParChange);
		CombineZo(ParCre);
	end;
end;


{---( TSubInst )------------------------------------------------------}

procedure TSubInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Sub;
end;

procedure TSubInst.CommonSetup;
begin
	inherited CommonSetup;
	SetCanSwap(false);
	iIdentCode := (IC_386_SubInst);
end;


{---( TLabelInst )----------------------------------------------------}


constructor TLabelInst.Create(const ParName:ansistring);
begin
	inherited Create;
	iLabelName := ParName;
end;

procedure   TLabelInst.CommonSetup;
begin
	inherited COmmonSetup;
	iIdentCode := IC_386_LabelInst;
end;

procedure   TLabelInst.Print(ParDIs:TAsmDisplay);
begin
	ParDis.SetLeftMargin(-8);
	ParDis.print([iLabelName,':']);
	ParDis.SetLeftMargin(8);
end;

{---( TSignExtendInstList )---------------------------------------------}

constructor TSignExtendInstList.Create(ParSize : TSize);
begin
	iSize := ParSize;
	inherited Create;
end;

procedure TSignExtendInstList.CheckOperands(ParCre:TInstCreator;ParChange:TChangeList);
var vlChange1 : TChangeItem;
	vlChange2 : TChangeItem;
	vlRes     : TOperand;
	vlRegNo   : cardinal;
begin
	vlRes := GetResByIdent(In_Main_Out);
	vlChange1 := ParChange.GetItemByIdentNumberErr(In_In_1);
	case iSize of
		1:vlRegNo := RN_Al;
		2:vlRegNo := Rn_Ax;
		4:vlRegNo := RN_EAX;
		else fatal(fat_Invalid_Operand_Size,['Size=',iSize]);
	end;
	vlChange1.ForceToRegister(vlRegNo);
	vlChange1.SetChangeSize(iSize);
	vlChange2 := ParChange.GetItemByIdentNumberErr(In_Main_Out);
	vlChange2.ForceToRegister(vlRegNo);
	vlChange2.SetChangeSize(vlRes.GetSize);
	HandleChange(ParCre,ParChange);
end;


procedure TSignExtendInstList.CompleteOutput(ParCre:TInstCreator);
var
	vlReg:TRegister;
	vlRegNo : cardinal;
begin
	case iSize of
		1:vlRegNo := RN_ah;
		2:vlRegNo := Rn_dx;
		4:vlRegNo := RN_EDX;
		else fatal(fat_Invalid_Operand_Size,['Size=',iSize]);
	end;
	vlReg := ParCre.GetAsRegisterByName(vlRegNo,iSize);
	ForceOutputTo(ParCre,In_High_Out,vlReg);
	case iSize of
		1:vlRegNo := RN_Al;
		2:vlRegNo := Rn_Ax;
		4:vlRegNo := RN_EAX;
		else fatal(fat_Invalid_Operand_Size,['Size=',iSize]);
	end;
	vlReg := ParCre.GetAsRegisterByName(vlRegNo,iSize);
	ForceOutputTo(ParCre,In_Main_Out,vlReg);
end;

function  TSignExtendInstList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
begin
	if ParRes.TestIdentNUmber(in_in_1) or
	ParRes.TestIdentNumber(in_Main_Out) or
	ParRes.TestIdentNumber(in_High_Out) then begin
		ParPosition := 0;
		exit(false);
	end else begin
		Fatal(Fat_Invalid_identNumber,'');
	end;
end;

{---( TSignExtendInst )--------------------------------------------------}

constructor TSignExtendInst.Create(ParSize : TSize);
begin
	iSize := ParSize;
	inherited Create;
end;

procedure TSignExtendInst.commonsetup;
begin
	inherited commonsetup;
	iIdentCode := IC_386_SignExtendInst;
end;


procedure TSignExtendInst.InitOperandList;
begin
	iOperandList := TSignExtendInstList.Create(iSize);
end;

procedure TSignExtendInst.Print(ParDis : TAsmDisplay);
begin
	case iSize of
	1:ParDis.Write(MN_CBW);
	2:ParDis.Write(MN_CWD);
	4:ParDis.Write(MN_CDQ);
	else fatal(fat_Invalid_Operand_Size,['Size=',iSize]);
	end;
end;




{---( TMovInst )------------------------------------------------------}


procedure TMovInst.InitOperandList;
begin
	iOperandList := TMovOperandList.Create;
end;


procedure TMovInst.COmmonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_386_MovInst);
	iMovType   := mv_normal;
	iOrgSize   := 0;
end;

procedure TMovInst.GetInstructionName(var ParName : ansistring);
begin
	case iMovType of
	mv_Normal   : ParName := MN_Mov;
	mv_exp_sign : ParName := MN_Movs;
	mv_exp      : ParName := MN_Movz;
	else inherited GetInstructionName(ParName);
end;
if iOrgSize > 0 then GetAssemblerInfo.GetInstruction(ParName,iOrgSize,0);
end;

procedure   TMovInst.InstructionFase(ParCre:TInstCreator);
var
	vlRes:TOperand;
begin
	inherited InstructionFase(ParCre);
	vlRes := iOperandList.GetResByIdent(In_in_1);
	if not(vlRes.GetRescode in [RT_NUmber,RT_NumberByExp]) and
	(vlRes.GetSize < TFormOperandList(iOperandList).GetInstructionSize) then begin
		if vlRes.GetSign then iMovType  := mv_exp_sign
		else iMovType := mv_exp;
		iOrgSize := vlRes.GetSize;
	end;
end;





{---( TAddSubInst )-------------------------------------------------}
procedure TAddSubInst.InitOperandList;
begin
	iOperandList := TAddSubOperandList.Create;
end;


{---( TAddInst )------------------------------------------------------}

procedure TAddInst.COmmonSetup;
begin
	inherited CommonSetup;
	SetCanSwap(true);
	iIdentCode := (IC_386_AddInst);
end;

procedure TAddInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Add;
end;


{---( TOrInst )-------------------------------------------------------}

procedure TOrInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_OR;
end;

procedure TOrInst.CommonSetup;
begin
	inherited CommonSetup;
	SetCanSwap(true);
	iIdentCode := IC_386_OrInst;
end;

{---( TOrInst )-------------------------------------------------------}

procedure TAndInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := mn_and;
end;


procedure TAndInst.CommonSetup;
begin
	inherited CommonSetup;
	SetCanSwap(true);
	iIdentCode := (IC_386_AndInst);
end;



{---( TXorInst )------------------------------------------------------}


procedure TXorInst.CommonSetup;
begin
	inherited COmmonSetup;
	SetCanSwap(true);
	iIdentCode := (IC_386_XorInst);
end;

procedure TXorInst.GetInstructionName(var ParName : ansistring);
begin
	ParName := MN_Xor;
end;

{---( TDivInst )------------------------------------------------------}


procedure TDivInst.InitOperandList;
begin
	iOperandList := TDivOperandList.Create;
end;

procedure TDivInst.GetInstructionName(var ParName : ansistring);
begin
	if GetIsSigned then ParName := MN_IDiv
	else ParName := MN_Div;
end;

procedure TDivInst.CommonSetup;
begin
	inherited COmmonSetup;
	SetCanSwap(false);
	iIdentCode := (IC_386_DivInst);
end;

{---( TMovInst )------------------------------------------------------}


procedure TMulInst.InitOperandList;
begin
	iOperandList := TMulOperandList.Create;
end;

procedure  TMulInst.GetInstructionName(var ParName : ansistring);
begin
	if GetIsSigned then ParName := MN_IMUL
	else ParName := MN_MUL;
end;

procedure TMulInst.COmmonSetup;
begin
	inherited CommonSetup;
	SetCanSwap(true);
	iIdentCode := (IC_386_MulInst);
end;

end.
