{
    Elaya, the compiler for the elaya language
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


unit i386asin;

interface
uses largenum,asmdisp,display,i386cons,asminfo,extappl,stdObj,elacons,error,confval,
elatypes,progutil,resource,procinst,pocobj,macobj,compbase,cmp_type,register,rtnenp;
	
type
	TX86AssemblerInfo=class(TAssemblerInfo)
	private
		procedure TranslateDivMod(ParCre:TInstCreator;ParPoc:TPocBase;ParInst : TInstruction);
		procedure TranslateShlShr(ParCre : TInstCreator; ParPoc : TPocBase;ParShl : boolean);

	public
		function  CreateAsmExec(const ParInputFile,ParOutputFile:string):TCompAppl;override;
		procedure TranslateRet(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateJump(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateCondJump(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateNeg(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateNot(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateAnd(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateOr(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateXor(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateIncDec(ParCre : TInstCreator;ParPoc : TIncDecFor);override;
		procedure TranslateAdd(ParCre:TInstCreator;Parpoc:TPocBase);override;
		procedure TranslateSub(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateDiv(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateMul(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateMod(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateShr(ParCre : TInstCreator; ParPoc : TPocBase);override;
		procedure TranslateShl(ParCre : TInstCreator; ParPoc : TPocBase);override;

		procedure TranslateLoad(ParCre:TInstCreator;ParPoc:TPocBase);override;
		procedure TranslateCall(ParCre : TInstcreator ; ParPoc : TPocBase) ;override;
		procedure TranslateLsMov(ParCre : TInstCreator ; ParPoc : TPocBase);override;
		procedure TranslateSetPar(ParCre : TInstCreator ; ParPoc : TPocBase);override;
		procedure CreateResources(ParCre:TInstCreator;ParPoc:TPocBase;ParInst:TInstruction);
		procedure TranslateComp(ParCre:TInstCreaTOR;ParPoc:TPocBase);override;
		procedure GetRegisterByCode(ParCode:TNormal;var ParName:string);override;
		procedure CreateRoutineInit(ParCre:TInstCreator;ParPoc:TPocBase); override;
		procedure CreateRoutineExit(ParCre:TInstCreator;ParPoc:TPocBase); override;
		procedure InitRegisterList;override;
	end;
	
	
	TX86AttAssemblerInfo=class(TX86AssemblerInfo)
	protected
		procedure Commonsetup;override;

	public
		function  HasIntelDirection:boolean;override;
		procedure GetRegisterByCode(ParCode:TNormal;var ParName:string);override;
		procedure GetInstruction(var ParInstruction:string;ParDesSize,ParSrcSize:TSize);override;
		function  GetRemarkChar:char;override;
		function  GetSectionText(const ParName:string):string;override;
		function  GetGlobalText(const ParName:string):string;override;
		function  CreateAsmDisplay(const ParFileName : string;var ParError :TErrorType) : TAsmDisplay;override;
	end;
	
	TX86IntelAssemblerInfo=class(TX86AssemblerInfo)
	public
		function  GetSectionText(const ParName:String):string;override;
		procedure GetInstruction(var ParInstruction:string;ParDesSize,ParSrcSize:TSize);override;
	end;
	
	TAs86AssemblerInfo=class(TX86IntelAssemblerInfo)
		function  CreateAsmDisplay(const ParFileName : string;var ParError :TErrorType) : TAsmDisplay;override;
		function  CreateAsmExec(const ParInputFile,ParOutputDir:string):TCompAppl;override;
		
		procedure Commonsetup;override;
		function  GetManglingCHar:Char;override;
		function  GetRemarkChar:char;override;
	end;
	
	TNasmAssemblerInfo=class(TX86IntelAssemblerInfo)
	protected
		procedure Commonsetup;override;

	public
		function  CreateAsmExec(const ParInputFile,ParOutputDir:string):TCompAppl;override;
		function  GetGlobalText(const ParName:string):string;override;
		function  CreateAsmDisplay(const ParFileName : string;var ParError :TErrorType) : TAsmDisplay;override;
		
	end;
	
	
	T386AsmDisplay=class(TAsmDisplay)
		procedure AsPrintLabel(ParLabel : cardinal);override;
	end;
	
	TATT386AsmDisplay=class(T386AsmDisplay)
	public
		procedure AsPrintNumber(ParSize : TSize;ParNumber : TNumber); override;
		procedure AsPrintVar(ParPublic:boolean;const ParName : string;ParSize : TSize);override;
		procedure AsPrintAlign(ParAlign : TSize); override;
		procedure AsPrintAscii(const ParText : string);override;
		procedure AsPrintAsciiz(const ParText : string);override;
		procedure AsPrintMemVar(ParSize : TSize;const ParText : string);override;
		procedure AsPrintOffset(const ParText : string;ParOffset : TOffset);override;
		procedure AsPrintMemIndex(const ParRegister,ParVar: string;ParIndex : TOffset;ParSize:TSize); override;
		
	end;
	
	TIntelAsmDisplay=class(T386AsmDisplay)
		procedure AsPrintVar(ParPublic:boolean;const ParName : string;ParSize : TSize);override;
		procedure AsPrintAlign(ParAlign : TSize);override;
		procedure AsPrintAscii(const ParText : string);override;
		procedure AsPrintAsciiz(const ParText : string);override;
		procedure AsPrintMemVar(ParSize : TSize;const ParText : string);override;
		procedure AsPrintOffset(const ParText : string;ParOffset : TOffset);override;
		procedure AsPrintMemIndex(const ParRegister,ParVar: string;ParIndex : TOffset;ParSize:TSize); override;
		
	end;
	
	TAs386AsmDisplay=class(TIntelAsmDisplay)
		procedure AsPrintNumber(ParSize :TSize;ParNumber : TNumber); override;
	end;
	
	TNasm386AsmDisplay=class(TIntelAsmDisplay)
		procedure AsPrintVar(ParPublic:boolean;const ParName : string;ParSize : TSize);override;
		procedure AsPrintNumber(ParSIze :TSize;ParNumber : TNumber);override;
	end;
	
implementation


{----( T386AmsDisplay )---------------------------------------------------------}

procedure T386AsmDisplay.AsPrintLabel(ParLabel : cardinal);
begin
	Print(['.L',ParLabel,':']);
end;

{----( TAtt386AsmDisplay )-------------------------------------------------------}


procedure TAtt386AsmDIsplay.AsPrintMemIndex(const ParRegister,ParVar: string;ParIndex : TOffset;ParSize:TSize);
begin
	if(ParIndex <> 0) then Write(ParIndex);
	write('(');
	if length(ParRegister) <> 0 then Write(ParRegister);
	if length(ParVar) <> 0 then begin
		if length(ParRegister)<> 0 then Write(',');
		Write(ParVar);
	end;
	Write(')');
end;

procedure TAtt386AsmDisplay.AsPrintMemVar(ParSize : TSize;const ParText : string);
begin
	write(ParText);
end;

procedure TAtt386AsmDisplay.AsPrintOffset(const ParText : string;ParOffset : TOffset);
begin
	print(['$',ParText]);
	if ParOffset > 0 then write('+');
	if ParOffset <> 0 then Print([ParOffset]);
end;

procedure TAtt386AsmDisplay.AsPrintNumber(ParSize : TSIze;ParNumber : TNumber);
begin
	write('$');
	write(ParNumber);
end;

procedure TAtt386AsmDisplay.AsPrintVar(ParPublic:boolean;const ParName : string;ParSize : TSize);
begin
	SetLeftMargin(SIZE_AsmLeftMargin);
	if ParPublic then write(ATT_Comm)
	else write(ATT_LComm);
	Print([' ',ParName,',',ParSize]);
	SetLeftMargin(-SIZE_AsmLeftMargin);
end;


procedure TAtt386AsmDisplay.AsPrintAlign(ParAlign : TSize);
begin
	SetLeftMargin(SIze_AsmLeftMargin);
	Print([Att_BAlign,' ',ParAlign]);
	SetLeftMargin(-Size_AsmLeftMargin);
end;

procedure TAtt386AsmDisplay.AsPrintAscii(const ParText : string);
var vlStr : string;
	vlLen :string;
begin
	SetLeftMargin(Size_AsmLeftMargin);
	ToAsString(ParText,vlStr);
	ToOctal(length(ParText),vlLen);
	Print([ATT_MN_Ascii,' "','\',vlLen,vlStr,'\000"']);
	SetLeftMargin(-SIze_AsmLeftMargin);
end;

procedure TAtt386AsmDisplay.AsPrintAsciiz(const ParText : string);
var vlStr : string;
begin
	SetLeftMargin(Size_AsmLeftMargin);
	ToAsString(ParText,vlStr);
	Print([ATT_MN_Ascii,' "',vlStr,'\000"']);
	SetLeftMargin(-SIze_AsmLeftMargin);
end;

{----( TAs386AsmDisplay )--------------------------------------------------------}

procedure TAs386AsmDisplay.AsPrintNumber(ParSize :TSize;ParNumber : TNumber);
begin
	Write('#');Write(ParNumber);
end;

{---( TIntelAsmDIsplay )--------------------------------------------------------}


procedure TIntelAsmDisplay.AsPrintMemIndex(const ParRegister,ParVar: string;ParIndex : TOffset;ParSize:TSize);
var vlPlus : boolean;
begin
	case ParSize of
	1:write('BYTE ');
	2:write('WORD ');
	4:write('DWORD ');
end;
vlPlus := false;
Write('[');
if length(ParRegister) <> 0 then begin
	Write(ParRegister);
	vlPlus := true;
end;
if length(ParVar) <> 0 then begin
	if vlPlus then Write('+');
	Write(ParVar);
end;
if ParIndex <> 0 then begin
	if vlPlus then write('+');
	Write(ParIndex);
end;
Write(']');
end;


procedure TIntelAsmDisplay.AsPrintMemVar(ParSize : TSize;const ParText : string);
begin
	Print(['[',ParText,']']);
end;

procedure TIntelAsmDisplay.AsPrintOffset(const ParText : string;ParOffset : TOffset);
begin
	Print(['DWORD  ',ParText]);
	if(ParOffset > 0) then write('+');
	if(ParOffset <> 0) then write(ParOffset);
end;

procedure TIntelAsmDisplay.AsPrintVar(ParPublic:boolean;const ParName : string;ParSize : TSize);
begin
	if ParPublic then begin
		Print([IT_MN_GLOBAL,' ',ParName]);
	end;
	Print([ParName,':']);
	SetLeftmargin(SIZE_AsmLeftMargin);
	nl;
	case ParSize of
	1: Print([IT_MN_DB,' ',0]);
	2: Print([IT_MN_DW,' ',0]);
	4: Print([IT_MN_DD,' ',0]);
	else Print([IT_MN_DB,' ',ParSize,' ',IT_MN_DUP,'(',0,')']);
end;
SetLeftMargin(-Size_AsmLeftMargin);
end;


procedure TIntelAsmDisplay.AsPrintAlign(ParAlign : TSize);
begin
	SetLeftMargin(Size_AsmLeftmargin);
	Print([IT_MN_Align,' ',ParAlign]);
	SetLeftMargin(-Size_AsmLeftMargin);
end;

procedure TIntelAsmDisplay.AsPrintAscii(const ParText:string);
begin
	SetLeftMargin(Size_AsmLeftMargin);
	Print([IT_MN_DB,' ',length(ParText),',"',ParText,'",0']);
	SetLeftMargin(-Size_AsmLeftMargin);
end;


procedure TIntelAsmDisplay.AsPrintAsciiz(const ParText:string);
begin
	SetLeftMargin(Size_AsmLeftMargin);
	Print([IT_MN_DB,' "',ParText,'",0']);
	SetLeftMargin(-Size_AsmLeftMargin);
end;

{---( TNasm386AsmDisplay )-------------------------------------------------------}

procedure TNasm386AsmDisplay.AsPrintVar(ParPublic:boolean;const ParName : string;ParSize : TSize);
begin
	if ParPublic then begin
		Print([IT_MN_GLOBAL,' ',ParName]);
	end;
	Print([ParName,':']);
	SetLeftmargin(SIZE_AsmLeftMargin);
	nl;
	Print([NS_MN_Resb,' ',ParSize]);
	SetLeftMargin(-Size_AsmLeftMargin);
end;


procedure TNasm386AsmDisplay.AsPrintNumber(ParSize : TSize;ParNumber : TNumber);
begin
	case ParSize of
	1:write('BYTE ');
	2:write('WORD ');
	4:write('DWORD ');
	else write('<Wrong size');
end;
write(ParNumber);
end;

{----( TX86AssemblerInfo )-------------------------------------------------------}

procedure TX86AssemblerInfo.InitRegisterList;
begin
	iRegisterList	    := TRegisterList.Create(REG_Info,Master_Info);
end;



function  TX86AssemblerInfo.CreateAsmExec(const ParInputFile,ParOutputFile:string):TCompAppl;
begin
	exit(TAsmAppl.Create(ParInputFile,ParOutputFIle,GetConfigValues.fDeleteAsmFile));
end;

procedure TX86AssemblerInfo.TranslateSetPar(ParCre : TInstCreator ; ParPoc : TPocBase);
var     vlRes    : TResource;
	vlInst   : TPushInst;
	vlSetPar : TSetParPoc;
begin
	vlSetPar := TSetParPoc(ParPoc);
	vlRes := vlSetPar.fPar.CreateInstRes(ParCre);
	vlInst := TPushInst.create;
	Parcre.AddInstAfterCur(vlInst);
	vlInst.AddOperand(vlres,In_In_1);
	vlInst.InstructionFase(ParCre);
end;

procedure TX86AssemblerInfo.TranslateComp(ParCre:TInstCreaTOR;ParPoc:TPocBase);
var
	vlCmp : TCmpInst;
begin
	vlCmp := TCmpInst.Create;
	CreateResources(ParCre,ParPoc,vlCmp);
end;


procedure TX86AssemblerInfo.CreateResources(ParCre:TInstCreator;ParPoc:TPocBase;ParInst:TInstruction);
begin
	{$ifdef showregres}
	writeln('begin className=',ParInst.ClassName);
	{$endif}
	TFormulaPoc(ParPoc).CreateAllResources(ParCre,ParInst);
	ParCre.AddInstAfterCur(ParInst);
	{$ifdef showregres}
	writeln('Instruction fase');
	{$endif}
	ParInst.InstructionFase(ParCre);
	TFormulaPoc(ParPoc).SetMacResTranslation(ParInst.fOperandList,ParCre);
	{$ifdef showregres}
	writeln('End ',ParInst.ClassName);
	{$endif}
end;


procedure TX86AssemblerInfo.CreateRoutineInit(ParCre:TInstCreator;ParPoc:TPocBase);
var vlCmd   : TInstruction;
	vlRes   : TRegisterRes;
	vlCB    : TRoutinePoc;
	vlStack : TResource;
	vlFrame : TMacBase;
	vlInst  : TPushInst;
begin
	vlCb := TRoutinePoc(ParPoc);
	if (vlCb.fNeedStackFrame) or (vlCb.GetLocalSize <>0) then begin
		vlCmd :=TPushInst.Create;
		vlRes := ParCre.GetSpecialRegister([CD_StackFrame],GetAssemblerInfo.GetSystemSize,false);
		vlCmd.AddOperand(vlRes,In_In_1);
		ParCre.AddInstAfterCur(vlCmd);
		vlStack := ParCre.AddMovFrSt(false);
		if (vlCB.GetLocalSize <> 0) then Parcre.AddSpAdd(vlCb.GetLocalSize,true);
	end else begin
		vlStack := ParCre.GetSpecialRegister([CD_StackFrame],GetAssemblerInfo.GetSystemSize,false);
		if vlStack = nil then Fatal(FAT_Cant_Get_Stack_Frame_Reg,'');
	end;
	if vlCb.fCDeclFlag then begin
		vlInst := TPushInst.Create;
		vlInst.AddOperand(ParCre.GetRegisterResByName(rn_edi),in_in_1);
		ParCre.AddInstAfterCur(vlInst);
		vlInst.InstructionFase(ParCre);
		vlInst := TPushInst.Create;
		vlInst.AddOperand(ParCre.GetRegisterResByName(rn_esi),in_in_1);
		ParCre.AddInstAfterCur(vlInst);
		vlInst.InstructionFase(ParCre);

	end;
	vlFrame := TRoutinePoc(ParPoc).fLocalFramePtr;
	ParCre.SetResourceUse(vlFrame,vlStack);
	ParCre.SetResourceResLong(vlFrame,true,true);
	
end;

procedure TX86AssemblerInfo.CreateRoutineExit(ParCre:TInstCreator;ParPoc:TPocBase);
var vlCmd   : TInstruction;
	vlSize  : TSIze;
	vlCB    : TRoutinePoc;
	vlFrame : TMacBase;
	vlStack : TResource;
	vlNsf   : boolean;
	vlName : string;
	vlMangName : string;
	vlInst : TPopInst;
begin
	vlCb := TRoutinePoc(ParPoc);
	if vlCb.fCDeclFlag then begin
		vlInst := TPopInst.Create;
		vlInst.AddOperand(ParCre.GetRegisterResByName(rn_esi),in_main_Out);
		ParCre.AddInstAfterCur(vlInst);
		vlInst.InstructionFase(ParCre);

		vlInst := TPopInst.Create;
		vlInst.AddOperand(ParCre.GetRegisterResByName(rn_edi),in_main_Out);
		ParCre.AddInstAfterCur(vlInst);
		vlInst.InstructionFase(ParCre);

	end;
	vlStack := nil;
	vlFrame := TRoutinePoc(ParPoc).fLocalFramePtr;
	vlStack := ParCre.ReserveResourceByUse(vlFrame);
	vlNsf := vlCb.fNeedStackFrame or (vlCb.GetLocalSize <> 0);
	if (vlNsf)  and (vlStack <> nil) then begin
		if (vlCb.GetLocalSize <> 0) then ParCre.AddMovFrSt(true);
		vlCmd   := TPopInst.Create;
		vlCmd.AddOperand(vlStack,In_Main_Out);
		ParCre.AddInstAfterCur(vlCmd);
	end;
	ParCre.SetResourceResLong(vlFrame,false,false);
	vlSize := 0;
	if not vlCb.fCDeclFlag then vlSize := vlCb.fParamSize;
	vlcmd := TRetInst.Create(vlSize);
	ParCre.AddInstAfterCur(vlcmd);
	vlCB.fName.GetString(vlName);
	vlMangName := '.Lend'; {Hack for .size}
	GetAssemblerinfo.AddMangling(vlMangName,vlName);
	ParCre.AddInstAfterCur(TLabelInst.create(vlMangName));
	ParCre.DeleteUnUsedUse;
end;

procedure TX86AssemblerInfo.TranslateRet(ParCre:TInstCreator;ParPoc:TPocBase);
begin
end;


procedure TX86AssemblerInfo.TranslateJump(ParCre:TInstCreator;ParPoc:TPocBase);
var  vlLabel:TLabelInst;
begin
	ParCre.DeleteUnUsedUse;
	vlLabel := TJumpPoc(ParPoc).fLabel.GetInst(ParCre);
	ParCre.AddInstAfterCur(TJumpInst.create(vlLabel));
end;


procedure TX86AssemblerInfo.TranslateCondJump(ParCre:TInstCreator;ParPoc:TPocBase);
var
	vlLabel    : TLabelInst;
	vlCondInst : TCondJumpInst;
	vlCond     : TCmpFlagRes;
begin
	vlLabel    := TCondJumpPoc(ParPoc).fLabel.GetInst(ParCre);
	vlCondInst := TCondJumpInst.create(vlLabel);
	vlCond     := TCmpFlagRes(ParCre.ReserveResourceByUse(TCondJumpPoc(ParPoc).GetMac));
	if vlLabel= nil then runerror(3);
	if vlCOnd = nil then runerror(2);{hack : fatal toevoegen}
	if not TCondJumpPoc(ParPoc).GetWhen then vlCond.NotCondition;
	vlCondInst.AddOperand(vlCOnd,In_In_1);
	ParCre.AddInstAfterCur(vlCondInst);
	vlCondInst.InstructionFase(ParCre);
end;

procedure TX86AssemblerInfo.TranslateNeg(ParCre:TInstCreator;ParPoc:TPocBase);
var vlNeg : TNegInst;
begin
	
	vlNeg := TNegInst.Create;
	CreateResources(ParCre,ParPoc,vlNeg);
end;


procedure TX86AssemblerInfo.TranslateNot(ParCre:TInstCreator;ParPoc:TPocBase);
var vlNot : TNotInst;
begin
	vlNot := TNotInst.Create;
	CreateResources(ParCre,ParPoc,vlNot);
end;

procedure TX86AssemblerInfo.TranslateAnd(ParCre:TInstCreator;ParPoc:TPocBase);
var vlAnd:TAndinst;
begin
	vlAnd := TAndInst.Create;
	CreateResources(ParCre,ParPoc,vlAnd);
end;

procedure TX86AssemblerInfo.TranslateOr(ParCre:TInstCreator;ParPoc:TPocBase);
var vlOr : TOrInst;
begin
	vlOr := TOrInst.Create;
	CreateResources(ParCre,ParPoc,vlOr);
end;

procedure TX86AssemblerInfo.TranslateXor(ParCre:TInstCreator;ParPoc:TPocBase);
var vlXor : TXorInst;
begin
	vlXor := TXorInst.Create;
	CreateResources(ParCre,ParPoc,vlXor);
end;

procedure TX86AssemblerInfo.TranslateIncDec(ParCre : TInstCreator;ParPoc : TIncDecFor);
var vlIncDec : TTWoInst;
begin
	if ParPoc.fIncFlag then vlIncDec := TAddInst.Create
	else vlIncDec := TSubInst.Create;
	CreateResources(ParCre,ParPoc,vlIncDec);
end;

procedure TX86AssemblerInfo.TranslateAdd(ParCre:TInstCreator;Parpoc:TPocBase);
var vlAdd : TAddInst;
begin
	vlAdd := TAddInst.Create;
	CreateResources(ParCre,ParPoc,vlAdd);
end;

procedure TX86AssemblerInfo.TranslateSub(ParCre:TInstCreator;ParPoc:TPocBase);
var vlSub: TSubInst;
begin
	vLSub := TSubInst.Create;
	CreateResources(ParCre,ParPoc,vlSub);
end;

procedure TX86AssemblerInfo.TranslateDiv(ParCre:TInstCreator;ParPoc:TPocBase);
var vlDiv : TDivInst;
begin
	vlDiv := TDivInst.Create;
	TranslateDivMod(ParCre,ParPoc,vlDiv);
end;

procedure TX86AssemblerInfo.TranslateDivMod(ParCre:TInstCreator;ParPoc:TPocBase;ParInst : TInstruction);
var
	vlRes  : TNumberRes;
	vlItem : TOperand;
	vlExp  : TSignExtendInst;
	vlOpp  : TOperand;
	vlRes2 : TResource;
	vlLi   : TNumber;
	vlSize : TSize;
	vLMac0 : TMacBase;
	vlMac1 : TMacBase;
	vlMac2 : TMacBase;
begin
	vlMac0 := TFormulaPoc(ParPoc).GetVar(0);
	vlMac1 := TFormulaPoc(ParPoc).GetVar(1);
	vlMac2 := TFormulaPoc(ParPoc).GetVar(2);
	vlSize := vlMac0.fSize;
	if vlMac1.fSize  > vlSize then vlSize := vlMac1.fSize;
	if vlMac2.fSize > vlSize then vlSize := vlMac2.fSize;

	if vlMac0.fSign then begin
		vlExp := TSignExtendInst.Create(vlSize);
		vlRes2 := vlMac1.CreateInstRes(ParCre);
		vlOpp := TOperand.Create(vlRes2,in_in_1);
		vlExp.AddResItem(vlOpp);
		ParCre.AddInstAfterCur(vlExp);
		vlExp.InstructionFase(ParCre);
		ParInst.AddResItem(TFormulaPoc(ParPoc).CreateResource(ParCre,2));
		ParInst.AddResItem(TFormulaPoc(ParPoc).CreateResource(ParCre,0));
		vlRes2 := vlExp.GetResByIdent(In_Main_Out);
		vlRes2.IsUsed;
		ParInst.AddResItem(TOperand.Create(vlRes2,ParPoc.GetIdentNumber(1)));
		vlRes2 := vlExp.GetResByIdent(in_High_Out);
		vlRes2.IsUsed;
		ParInst.AddResItem(TOperand.Create(vlRes2,in_div_high_in));
	end else begin
		LoadLong(vlLi,0);
		vlRes  := TNumberRes.Create(vlLi);
		ParCre.AddObject(vlRes);
		vlRes.SetSize(vlSize);
		vlItem := TOperand.Create(vlRes,In_Div_High_In);
		ParInst.AddResItem(vlItem);
		TFormulaPoc(ParPoc).CreateAllResources(ParCre,ParInst);
	end;
	ParCre.AddInstAfterCur(ParInst);
	ParInst.InstructionFase(ParCre);
	TFormulaPoc(ParPoc).SetMacResTranslation(ParInst.fOperandList,ParCre);
end;

procedure TX86AssemblerInfo.TranslateMul(ParCre:TInstCreator;ParPoc:TPocBase);
var
	vlMul : TMulInst;
begin
	vlMul := TMulInst.Create;
	CreateResources(ParCre,ParPoc,vlMul);
end;

procedure TX86AssemblerInfo.TranslateShr(ParCre : TInstCreator; ParPoc : TPocBase);
begin
	TranslateShlShr(ParCre,ParPoc,false);
end;
procedure TX86AssemblerInfo.TranslateShl(ParCre : TInstCreator; ParPoc : TPocBase);
begin
	TranslateShlShr(ParCre,ParPoc,true);
end;

procedure TX86AssemblerInfo.TranslateShlShr(ParCre : TInstCreator; ParPoc : TPocBase;ParShl : boolean);
var
	vlShr  : TInstruction;
	vlRes0 : TOperand;
	vlRes1 : TOperand;
	vlRes2 : TOperand;
	vlRes3 : TResource;
    vlNum  : TNumber;
	vlMOv  : TInstruction;
begin
	vlRes0 :=TFormulaPoc(ParPoc).CreateResource(ParCre,0);
	vlRes1 :=TFormulaPoc(ParPoc).CreateResource(ParCre,1);
	vlRes2 :=TFormulaPoc(ParPoc).CreateResource(ParCre,2);
	if(vlRes2.fResource is TNumberRes) then begin
		if(LargeCompareInt(TNumberRes(vlRes2.fResource).fNUmber,255) = LC_BIGGER) or
		  (LargeCompareInt(TNumberRes(vlRes2.fResource).fNumber,-255)=LC_Lower) then begin
            LoadLong(vlNum,0);
        	vlRes3 := ParCre.GetNumberRes(vlNum,vlRes0.GetSize,false);
			vlMov:= ParCre.AddMov(vlRes0.fResource,vlRes3,true,false);
			TFormulaPoc(ParPoc).SetMacResTranslation(vlMov.fOperandList,ParCre);
			vlRes0.Destroy;
			vlRes1.Destroy;
			vlRes2.Destroy;
			exit;
		end
	end;
	if ParShl then begin
		vlShr := TShlInst.Create;
	end else begin
		vlShr := TShrInst.Create;
	end;
	ParCre.AddInstAfterCur(vlShr);
	vlShr.AddResItem(vlRes0);
	vlShr.AddResItem(vlRes1);
	vlShr.AddResItem(vLRes2);
	vlShr.InstructionFase(ParCre);
	TFormulaPoc(ParPoc).SetMacResTranslation(vlShr.fOperandList,ParCre);
end;


procedure TX86AssemblerInfo.TranslateMod(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	TranslateDivMod(ParCre,ParPoc,TDivInst.Create);
end;

procedure TX86AssemblerInfo.TranslateLoad(ParCre:TInstCreator;ParPoc:TPocBase);
var
	vlMov : TMovInst;
	vlRes : TResource;
	vlMac : TMacBase;
	vlRes0 :  TOperand;
	vlRes1 :  TOperand;
begin
	vlRes0 :=TFormulaPoc(ParPoc).CreateResource(ParCre,1);
	vlRes1 :=TFormulaPoc(ParPoc).CreateResource(ParCre,0);
{	if vlRes0.IsSame(vlRes1)  then begin
		vlRes0.Destroy;
		vlRes1.Destroy;
	end else begin}
		vlMov := TMovInst.Create;
{		CreateResources(ParCre,ParPoc,vlMov);}
		ParCre.AddInstAfterCur(vlMov);
		vlMov.AddResItem(vlRes0);
		vlMov.AddResItem(vlRes1);
		vlMov.InstructionFase(ParCre);
		TFormulaPoc(ParPoc).SetMacResTranslation(vlMov.fOperandList,ParCre);
		vlMac := TFormulaPoc(ParPoc).GetVar(0);
		vlRes := vlMov.GetResByIdent(In_in_1);
		ParCre.AddUnUsedResourceUse(vlMac,vlRes);
	{end;           }
end;

procedure TX86AssemblerInfo.TranslateCall(ParCre : TInstcreator ; ParPoc : TPocBase);
var vlRes   : TResource;
	vlOut   : TMacBase;
	vlInst  : TCallInst;
	vlCall  : TCallPoc;
begin
	vlCall := TCallPoc(ParPoc);
	vlInst :=TCallInst.create;
	vlInst.AddOperand(vlCall.fTargetMac.CreateInstRes(ParCre),in_in_1);
	vlOut := vlCall.fReturnVar;
	ParCre.DeleteUnUsedUse;
	if (vlOut <> nil)  then begin
		vlRes := vlOut.CreateInstRes(ParCre);
		vlRes.ReserveResource;
		ParCre.SetResourceUse(vlOut,vlRes);
		vlInst.AddOperand(vlRes,In_Main_Out);
	end;
	ParCre.AddInstAfterCur(vlInst);
	vlInst.InstructionFase(ParCre);
	if vlCall.fCDecl then ParCre.AddSpAdd(vlCall.fParamSize,false);
end;


procedure TX86AssemblerInfo.TranslateLsMov(ParCre:TInstCreator;ParPoc:TPocBase);
var vlSource,vlRes2,vlMoveSize,vlDest,vlRes5,vlRes6,vlRes7,vlRes8:TResource;
	vlLab:TLabelInst;
	vlPoc      :TInstruction;
	vlName     : String;
	vlMove     : TLsMovePoc;
	vlItemSize : TSize;
	vlSize     : TSize;
	vlAddr     : cardinal;
	vlMac      : TMacBase;
	vlPrvSize  : tsize;
	vlNum	   : TNumber;
	vlNumRes   : TNumberRes;
begin
	vlMove     := TLsMovePoc(ParPoc);
	vlSize     := vlMove.fSize;
	if((vlSize = 3) or (vlSize = 8)) then begin
		vlAddr := 0;{hack size=3 could have item wich cant have a ptr resouce}
		while vlSize > 0 do begin
			if vlSize >= 4 then begin
				vlItemSize := 4;
			end else begin
				vlItemSize := 2
			end;
			if vlItemSize > vlSize then vlItemSize := vlSize;
			vlMac := vlMove.fSource;
			vlPrvSize := vlMac.fSize;
			vlMac.SetSize(vlItemSize);
			vlMac.AddExtraOffset(vlAddr);
			vlSource := vlMac.CreateInstRes(ParCre);
			vlMac.SetSize(vlPrvSIze);
			vlMac.AddExtraOffset(-vlAddr);
			vlMac := vlMove.fDest;
			vlPrvSize := vlMac.fSize;
			vlMac.SetSize(vlItemSize);
			vlMac.AddExtraOffset(vlAddr);
			vlDest   := vlMac.CreateInstRes(ParCre);
			vlMac.AddExtraOffset(-vlAddr);
			vlMac.SetSize(vlPrvSize);
			ParCre.AddMov(vlDest,vlSource,true);
			inc(vlAddr,vlItemSize);
			dec(vlSize,vlItemSize);
		end;
		exit;
	end;
	vlItemSize := 1;
	vlRes5     := vlMove.fSource.CreatePtrResource(ParCre);
	vlSource   := ParCre.GuaranteeRegister(vlRes5,RH_Pointer);
	vlRes6     := vlMove.fDest.CreatePtrResource(ParCre);
	vlDest     := ParCre.GuaranteeRegister(vlRes6,RH_Pointer);
	if(vlSize < 16) then begin
		vlAddr := 0;
		while (vlSize > 0) do begin
			if(vlSize mod 4) = 0 then begin
				vlItemSize := 4;
			end else if (vlSize mod 2)= 0 then begin
				vlItemSize := 2;
			end else begin
				vlItemSize := 1;
			end;
			vlRes7 := TByPtrRes.Create(TRegisterRes(vlSource),vlItemSize,false);
			vlRes7.SetExtraOffset(vlAddr);
			ParCre.AddObject(vlRes7);
			vlRes8 := ParCre.AddMovReg(vlRes7,true);
			vlRes7 := TByPtrRes.Create(TRegisterRes(vlDest),vlItemSize,false);
			vlRes7.SetExtraOffset(vlAddr);
			ParCre.AddObject(vlRes7);
			ParCre.AddMov(vlRes7,vlRes8,true);
			vlSource.InUse;
			vlDest.InUse;
			inc(vlAddr,vlItemSize);
			dec(vlSize,vlItemSize);
		end;
		exit;
	end;
	if(vlSize mod 4 = 0) then begin    {temp hack}
		vlItemSize := 4;
		vlSize := vlSize shr 2;
	end;
	vlRes2     := ParCre.GetNumberResLong(vlSize,GetAssemblerInfo.GetSystemSize,false);
	vlMoveSize := ParCre.AddMovReg(vlRes2,true);
	str(GetNewLabelNo,vlName);
	vlName     := 'l_'+vlName;
	vlLab      := TLabelInst.create(vlName);
	ParCre.AddInstAfterCur(vlLab);
	vlLab.InstructionFase(ParCre);
	vlRes7     := TByPtrRes.create(TRegisterRes(vlSource),vlItemSize,false);
	ParCre.AddObject(vlRes7);
	vlRes8     := Parcre.AddMovReg(vlRes7,true);
	vlRes7     := TByPtrRes.create(TRegisterRes(vlDest),vlItemSize,false);
	ParCre.AddObject(vlRes7);
	ParCre.AddMov(vlRes7,vlRes8,true);
	if vlItemSize  = 1 then begin
		vlPoc      := TIncDecInst.create(true);
		vlpoc.AddOperand(vlSource,In_Main_Out);
		ParCre.AddInstAfterCur(vlPoc);
		vlPoc.InstructionFase(Parcre);
		vlPoc := TIncDecInst.create(True);
		vlPoc.AddOperand(vlDest,In_Main_Out);
		ParCre.AddInstAfterCur(vlPoc);
		vlPoc.InstructionFase(ParCre);
	end  else begin
		LoadLong(vlNum,vlItemSize);
		vlNumRes := ParCre.GetNumberRes(vlNum,GetAssemblerInfo.GetSystemsize,false);
    	vlPoc := TAddInst.Create;
		vlPoc.AddOperand(vlSource,In_Main_Out or In_in_1);
		vlPoc.AddOperand(vlNumRes,in_in_2);
		ParCre.AddInstAfterCur(vlPoc);
    	vlPoc := TAddInst.Create;
		vlPoc.AddOperand(vlDest,In_Main_Out or In_in_1);
		vlNumRes := ParCre.GetNumberRes(vlNum,GetAssemblerInfo.GetSystemsize,false);
		vlPoc.AddOperand(vlNumRes,in_in_2);
		ParCre.AddInstAfterCur(vlPoc);
  	end;
	vlPoc := TIncDecInst.create(false);
	vlRes7     := TCmpFlagRes.create(IC_NotEq);
	ParCre.AddObject(vlRes7);
	vlPoc.AddOperand(vlMoveSize,In_Main_Out);
	vlpoc.AddOperand(vlRes7,In_Flag_Out);
	ParCre.AddInstAftercur(vlPoc);
	vlPoc      := (TCondJumpInst.create(vlLab));
	vlPoc.AddOperand(vlRes7,In_in_1);
	ParCre.AddInstAftercur(vlPoc);
	vlPoc.InstructionFase(ParCre);
	vlSource.IsUsed;
	vlMoveSize.IsUsed;
	vlDest.IsUsed;
end;

procedure TX86AssemblerInfo.GetRegisterByCode(ParCode:TNormal;var ParName:string);
var vlStr:string;
begin
	case ParCode Of
	RN_AL    : ParName := 'AL';
	RN_AH    : ParName := 'AH';
	RN_AX    : ParName := 'AX';
	RN_EAX   : ParName := 'EAX';
	RN_BL	 : ParName := 'BL';
	RN_BH    : ParName := 'BH';
	RN_BX	 : ParName := 'BX';
	RN_EBX	 : ParName := 'EBX';
	RN_CL	 : ParName := 'CL';
	RN_CH	 : ParName := 'CH';
	RN_CX	 : ParName := 'CX';
	RN_ECX	 : ParName := 'ECX';
	RN_DL	 : ParName := 'DL';
	RN_DH	 : ParName := 'DH';
	RN_DX	 : ParName := 'DX';
	RN_EDX   : ParName := 'EDX';
	RN_DI	 : ParName := 'DI';
	RN_EDI	 : ParName := 'EDI';
	RN_SI	 : ParName := 'SI';
	RN_ESI   : ParName := 'ESI';
	RN_BP	 : ParName := 'BP';
	RN_EBP   : ParName := 'EBP';
	RN_SP	 : ParName := 'SP';
	RN_ESP	 : ParName := 'ESP';
	else begin
		str(Parcode,vlStr);
		Fatal(FAT_Invalid_Register,'Code = '+vlStr+',TX86AssemblerInfo.GetRegisterByCode');
	end;
end;

end;


{----( TX86AttAssemblerInfo )-----------------------------------------------------}




function  TX86AttAssemblerInfo.CreateAsmDisplay(const ParFileName : string;var ParError :TErrorType) : TAsmDisplay;
begin
	exit(TAtt386AsmDisplay.Create(ParFileName,ParError));
end;


function TX86AttAssemblerInfo.GetGlobalText(const ParName:string):string;
begin
	exit(MN_Dot_Global + ' '+ParName);
end;

function TX86AttAssemblerInfo.GetSectionText(const ParName:string):String;
begin
	exit(MN_Section+' '+ParName);
end;

function  TX86AttAssemblerInfo.GetRemarkChar:char;
begin
	GetRemarkCHar := '#';
end;

procedure TX86AttAssemblerInfo.Commonsetup;
begin
	inherited Commonsetup;
	SetAssemblerInfoType(AT_X86Att);
end;

function TX86AttAssemblerInfo.HasIntelDirection:boolean;
begin
	HasIntelDirection := false;
end;

procedure TX86AttAssemblerInfo.GetRegisterByCode(ParCode:TNormal;var ParName:string);
begin
	Inherited GetRegisterByCode(ParCode,ParName);
	if length(ParName) > 0 then ParName := '%' +ParName;
end;


procedure TX86AttAssemblerInfo.GetInstruction(var ParInstruction:string;ParDesSize,ParSrcSize:TSize);
var
	vlSize : char;
begin
	case ParDesSize of
	0:exit;
	1:vlSize :=  'B';
	2:vlSize :=  'W';
	4:vlSize :=  'L';
	else fatal(fat_Invalid_variable_Size,['[Size=',(ParDesSize) ,'][instruction=',ParInstruction,']']);
end;
SetLength(ParInstruction,length(ParInstruction)+1);
ParInstruction[length(ParInstruction)] := vlSize;
if ParDesSize = ParSrcSize then exit;
case ParSrcSize of
0:exit;
1:vlSize := 'B';
2:vlSize :=  'W';
3:vlSize :=  'L';
else fatal(fat_Invalid_variable_Size,['[Size=',ParDesSize, '][instruction=',ParInstruction,']']);
end;
SetLength(ParInstruction,length(ParInstruction) + 1);
ParInstruction[length(ParInstruction)] := vlSize;
end;



{---( TX86IntelAssemblerInfo )----------------------------------------------------------}



function  TX86IntelAssemblerInfo.GetSectionText(const ParName:string):string;
begin
	exit(MN_N_Section+' '+ParName);
end;

procedure TX86IntelAssemblerInfo.GetInstruction(var ParInstruction : String;ParDesSize,ParSrcSize:TSize);
begin
	Inherited GetInstruction(ParInstruction,ParDesSize,ParSrcSize);
	if (ParInstruction='MOVZ') or (ParInstruction='MOVS') then ParInstruction := ParInstruction + 'X';
end;

{---( TNasmAssemblerInfo )-------------------------------------------------------}

function  TNasmAssemblerInfo.CreateAsmDisplay(const ParFileName : string;var ParError :TErrorType) : TAsmDisplay;
begin
	exit(TNasm386AsmDisplay.Create(ParFileName,ParError));
end;

function  TNasmAssemblerInfo.GetGlobalText(const ParName:string):string;
begin
	exit(MN_Global + ' '+ParName);
end;

function  TNasmAssemblerInfo.CreateAsmExec(const ParInputFile,ParOutputDir:string):TCompAppl;
begin
	exit(TNasmAppl.Create(ParInputFile,ParOutputDir));
end;

procedure TNasmAssemblerInfo.Commonsetup;
begin
	inherited Commonsetup;
	SetAssemblerInfoType(AT_Nasm86);
end;

{---( TAs86AssemblerInfo )-------------------------------------------------------}
function  TAs86AssemblerInfo.CreateAsmExec(const ParInputFile,ParOutputDir:string):TCompAppl;
begin
	exit(TAs86Appl.Create(ParInputFile,ParOutputDir));
end;


function  TAs86AssemblerInfo.CreateAsmDisplay(const ParFileName : string;var ParError :TErrorType) : TAsmDisplay;
begin
	exit(TAs386AsmDisplay.Create(ParFileName,ParError));
end;

procedure TAs86AssemblerInfo.Commonsetup;
begin
	inherited CommonSetup;
	SetAssemblerInfoType(AT_As86);
end;

function  TAs86AssemblerInfo.GetManglingCHar:Char;
begin
	GetManglingChar := '_';
end;


function  TAs86Assemblerinfo.GetRemarkChar:char;
begin
	exit(';');
end;


end.
