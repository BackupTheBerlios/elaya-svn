{    Elaya, the compiler for the elaya language
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


unit Pocobj;
interface
uses simplist,display,compbase,procinst,elacons,macobj,elaTypes,progUtil,resource,error,stdobj,lsStorag,cmp_type;

type
	TPocBase    = class;
	TRefPocBase = class of TPocBase;
	TLabelPoc = class;
	TSubPocList  = class(TSmList)
	private
		fMacCnt : longint;
	public
		procedure AddSec(ParSec:TSecBase);
		function  CreateLabel:TLabelPoc;
		function  AddLabel:TLabelPoc;
		procedure CommonSetup;override;
		function  Optimize:boolean;virtual;
		procedure Linearize(ParLIst:TSubPocList);
		function  CreateInst(ParCre:TInstCreator):boolean;virtual;
		procedure AssignTlStorage(ParList:TTlvStorageList);
		procedure Print(ParDis:TDisplay);
	end;
	
	
	TPocBase=class(TSecBase)
	private
		voMeta   : boolean;
		voIgnore : boolean;
		voDelete : boolean;
		voIdentCode : TPocIdentCOde;
		property    iMeta   : boolean read voMeta   write voMeta;
		property    iIgnore : boolean read voIgnore write voIgnore;
	protected
		property    iDelete : boolean read voDelete write voDelete;
		property    iIdentCode : TPocIdentCode read voIdentCode write voIdentCode;

	public
		property    fIgnore:boolean read voIgnore ;
		property    fMeta  :boolean read voMeta;
		property    fIdentCode : TPocIdentCode read voIdentCode;

		function    CanDelete : boolean;virtual;
		function    GetIdentNumber(ParMacPos:TNormal):TFlag;virtual;
		procedure   SetDelete;virtual;
		function    CreateInst(ParCre:TInstCreator):boolean;virtual;
		function    IsUsingSec(ParSec:TSecBase;ParHow:THowType):boolean;virtual;
		function    GetNextNonMeta : TPocBase;
		function    GetNextNi:TPocBase;
		procedure   Print(ParDis:TDisplay);override;
		procedure   commonSetup;override;
		procedure   ReserveStorage(ParList:TTlvStorageList);virtual;
		procedure   FreeStorage; virtual;
	end;
	
	TUnkPoc=class(TPocBase)
	public
		voClassName : TString;
		procedure  SetClassName(const ParClassName:string);
		property  fClassName:TString read voClassName write voClassName;
	public
		procedure   Print(ParDis:TDisplay);override;
		function    CreateInst(ParCre:TInstCreator):boolean;override;
		procedure   Commonsetup;override;
		constructor Create(const ParName:string);
		destructor  destroy;override;
	end;
	
	TSubPoc=class(TPocBase)
	private
		voPocList : TSubPocList;
		property iPocList :TSubPocList read voPocList write voPocList;
	public
		property    fPocList:TSubPocList read voPocList;
		destructor  Destroy;override;
		procedure   CommonSetup;override;
		procedure   Print(parDis:TDisplay);override;
		function    Optimize:boolean;override;
		function    CreateInst(ParCre:TInstCreator):boolean;override;
		procedure   ReserveStorage(ParList:TTlvStorageList);override;
		procedure   LinearizeSubList;
	end;
	
	TLabelPoc=class(TPocBase)
	private
		voLabelNo : longint;
		voInst    : TLabelInst;
	protected
		property iLabelNo : longint    read voLabelNo write voLabelNo;
		property iInst    : TLabelInst read voInst    write voInst;
	public
		constructor Create;
		procedure GetName(var ParName:string);
		procedure CommonSetup;override;
		procedure Print(ParDis:TDisplay);override;
		function  Optimize:boolean;override;
		function  GetInst(ParCre:TInstCreator):TLabelInst;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
		function    CanDelete : boolean;override;
	end;
	
	TJumpPoc = class(TPocBase)
	private
		voLabel : TLabelPoc;
		property iLabel : TLabelPoc read voLabel write voLabel;
	protected
		procedure SetLabel(parLabel:TLabelPoc);
	public
		property   fLabel:TLabelPoc read voLabel;
		function   IsUsingSec(ParSec:TSecBase;ParHow:THowType):boolean;override;
		procedure  CommonSetup;override;
		function   Optimize:boolean;override;
		procedure  Print(ParDis:TDisplay);override;
		function   CreateInst(PArCre:TInstCreator):boolean;override;
		function   OptimizeFollowingLabels:boolean;
		constructor Create(ParLabel : TLabelPoc);
		procedure  SetDelete;override;
	end;
	
	TCondJumpPoc=class(TJumpPoc)
	private
		voMac  : TMacBase;
		voWhen : boolean;
		property   iMac  : TMacBase read voMac  write voMac;
		property   iWhen : boolean  read voWhen write voWhen;
	protected
		procedure   CommonSetup;override;
	public
		property GetMac  : TMacBase read voMac  write voMac;
		property GetWhen : boolean  read voWhen write voWhen;
		constructor Create(ParWhen:boolean;ParCond : TMacBase;ParLabel :TLabelPoc);
		function    Optimize:boolean;override;
		procedure   Print(PArDis:TDisplay);override;
		function    CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	TFormulaPoc=class(TPocBase)
	private
		voMacList:TMacList;
		property iMacList : TMacList read voMacList write voMacList;
	protected
		procedure   CommonSetup;override;
	public
		property    GetMacList:TMacList read voMacList ;
		procedure   CreateList;
		destructor  Destroy;override;
		procedure   ReserveStorage(ParList:TTlvStorageList);override;
		procedure   FreeStorage; override;
		procedure   SetMacResTranslation(ParList:TOperandList;ParCre:TInstCreator);
		function    CreateResource(ParCre:TInstCreator;ParNo:TNormal):TOperand;
		procedure   CreateAllResources(ParCre:TInstCreator;ParInst:TInstruction);virtual;
		function    CreateInst(PArCre:TInstCreator):boolean;override;
		function     SetVar(ParNo : cardinal;ParVar:TMacBase):boolean;
		function     GetVar(ParNo : cardinal):TMacBase;
		function     CalcOutputMac(ParCre : TCreator):TMacBAse;virtual;
	end;
	TRefFormulaPoc=class of TFormulaPoc;
	
	
	TTwoFor=class(TFormulaPoc)
		procedure CreateAllResources(ParCre:TInstCreator;ParInst:TInstruction);override;
		function  GetIdentNumber(ParMacPos:TNormal):TFlag;override;
		function  IsUsingSec(ParSec:TSecBase;ParHow:THowTYpe):boolean;override;
	end;
	
	
	TThreePoc=class(TTwoFor)
		procedure CreateAllResources(ParCre:TInstCreator;ParInst:TInstruction);override;
		function  GetIdentNumber(ParMacPos:TNormal):TFlag;override;
		function  IsUsingSec(ParSec:TSecBase;ParHow:THowTYpe):boolean;override;
		procedure Print(ParDis:TDisplay);override;
	end;
	
	TSimpleThreeFor = class(TThreePoc)
	end;
	
	TDivTypeFor = class(TThreePoc)
	end;
	
	TNegfor= class(TTwoFor)
		function  CreateInst(ParCre:TInstCreator):boolean;override;
		procedure Print(parDis:TDisplay);override;
		procedure commonsetup;override;
	end;
	
	TNotfor= class(TTwoFor)
	protected
		procedure commonsetup;override;
	public
		function  CreateInst(ParCre:TInstCreator):boolean;override;
		procedure Print(parDis:TDisplay);override;
	end;
	
	TIncDecFor=class(TTwoFor)
	private
		voIncFlag : boolean;
		property iIncFlag : boolean read voIncFlag write voIncFlag;
	public
		property fIncFlag : boolean read voIncFlag;
		constructor Create(ParIncFlag : boolean);
 		function  GetIdentNumber(ParMacPos:TNormal):TFlag;override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
		procedure Print(parDis:TDisplay);override;
		procedure commonsetup;override;
	end;
	
	TAddFor=class(TSimpleThreeFor)
	protected
		procedure  Commonsetup;override;

	public
		procedure Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	TSubFor=class(TSimpleThreeFor)
	protected
		procedure  Commonsetup;override;

	public
		procedure  Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	
	
	
	TAndFor=class(TSImpleThreeFor)
	protected
		procedure Commonsetup;override;

	public
		function  CreateInst(ParCre:TInstCreator):boolean;override;
		procedure Print(ParDis:TDisplay);override;
	end;
	
	TOrFor=class(TSimpleThreeFor)
	protected
		procedure Commonsetup;override;

	public
		function  CreateInst(ParCre:TInstCreator):boolean;override;
		procedure Print(ParDis:TDisplay);override;
	end;
	
	TXorFor=class(TSimpleThreeFor)
	public
		procedure Commonsetup;override;

	protected
		function  CreateInst(ParCre:TInstCreator):boolean;override;
		procedure Print(ParDis:TDisplay);override;
	end;

	TShrFor=class(TTHreePoc)
	public
		procedure Commonsetup;override;

	protected
		procedure Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
	end;

	TShlFor=class(TTHreePoc)
	protected
   	procedure Commonsetup;override;

	public
		procedure Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
	end;


	TMulFor=class(TThreePoc)
	protected
		procedure Commonsetup;override;

	public
		procedure Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	TDivFor=class(TDivTypeFor)
	protected
		procedure Commonsetup;override;

	public
		procedure Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	TModFor=class(TDivTypeFor)
	protected
		procedure Commonsetup;override;

	public
		function  GetIdentNumber(ParMacPos:TNormal):TFlag;override;
		procedure Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	
	TLoadFor=class(TTwoFor)
	protected
		procedure CommonSetup;override;
	public
		function  CalcOutputMac(ParCre :TCreator):TMacbase;override;
		procedure Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	TCompFor = class(TThreePoc)
	private
		voCompCode : TIdentCode;
		property fCompCode :TIdentCode read voCompCode write voCompCode;
	protected
		procedure   CommonSetup;override;
		
	public
		property    GetCompCode:TIdentCode read voCompCode;
		
		function    GetIdentNumber(ParMacPos:TNormal):TFlag;override;
		constructor Create(ParCompCode : TIdentCode);
		procedure   print(ParDis:TDisplay);override;
		function    CalcOutputMac(ParCre : TCreator):TMacBAse;override;
		function    CreateInst(PArCre:TInstCreator):boolean;override;
		
	end;
	
	TSetParPoc = class(TPocBase)
	private
		voPar              : TMacBase;
		voRtlParameterFlag : boolean;
		procedure SetRtlParameterFlag(ParFlag : boolean);
		property  iPar : TMacBase read voPar write voPar;
	protected
		procedure  Commonsetup;override;

	public
		property   fPar:TMacBase read voPar;
		property   fRtlParameterFlag:boolean read voRtlParameterFlag write SetRtlParameterFlag;
		
		procedure  ReserveStorage(ParTLVList:TTLvStorageList);override;
		procedure  FreeStorage;override;
		function   CreateInst(PArCre:TInstCreator):boolean;override;
		procedure  Print(ParDIs:TDisplay);override;
		constructor Create(ParParam : TMacBase);
	end;
	
	TCallPoc = class(TPocBase)
	private
		voCDecl     : boolean;
		voPAramSize : TSize;
		voReturnVar : TMacBase;
		voTargetMac : TMacBase;
		property iTargetMac : TMacBase read voTargetMac write voTargetMac;
		property iParamSize : TSIze    read voParamSize write voPAramSize;
		property iCDecl     : boolean  read voCDecl	write voCDecl;
		property iReturnVar : TMacBase read voReturnVar write voReturnVar;
	protected
		procedure   CommonSetup;override;

	public
		property    fTargetMac : TMacBase read voTargetMac;
		property    fParamSize : TSize    read voParamSize;
		property    fCDecl	 : boolean  read voCDecl;
		property    fReturnVar : TMacBase read voReturnVar;
		
		procedure   SetReturnVar(PArVar:TMacBase);
		function    CreateInst(ParCre:TInstCreator):boolean;override;
		constructor Create(ParTarget:TMacBase;ParCDecl:boolean;ParSize:TSize);
		procedure   Print(ParDis:TDisplay);override;
	end;
	
	TMetaPoc = class(TPocBase)
	private
		voGroupEnd   : TMetaPoc;
		voGroupBegin : TMetaPoc;
	protected
		property  iGroupEnd   : TMetaPoc read voGroupEnd write voGroupEnd;
		property  iGroupBegin : TMetaPoc read voGroupBegin write voGroupBegin;
		procedure CommonSetup;override;

	public
		property  fGroupEnd   : TMetaPoc read voGroupEnd write voGroupEnd;
		property  fGroupBegin : TMetaPoc read voGroupBegin write voGroupBegin;
		procedure Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	TLongResListItem=class(TSMListITem)
	private
		voMac : TTLMac;
		property iMac : TTlMac read voMac write voMac;
	public
		property fMac : TTlMac read voMac;
		constructor Create(ParMac:TTLMac);
		procedure   Print(ParDIs : TDisplay);
		procedure   ReserveStorage(ParList:TTlvStorageList);
		procedure   FreeStorage;
		
	end;
	
	TLongresList=class(TSMList)
		procedure SetMacsLOngRes(ParCre:TInstCreator;ParOnOf:boolean);
		procedure AddMac(ParMac:TTLMac);
		procedure Print(ParDis : TDisplay);
		procedure Check;
		procedure   ReserveStorage(ParList:TTlvStorageList);
		procedure   FreeStorage;
		
	end;
	
	TLongResMetaPoc=class(TMetaPoc)
	private
		voMacList : TLongResList;
	protected
		procedure CommonSetup;override;

	public
		property fMacList : TLongResList read voMacList write voMacList;
		procedure CreateList;
		function   AddMac(ParCre :TCreator;ParMac:TMacBase):TMacBase;
		procedure SetMacsLongRes(PArCre:TInstCreator;ParFlag:boolean);
		function  CreateInst(ParCre:TInstCreator):boolean;override;
		procedure Print(ParDis : TDisplay);override;
		destructor Destroy;override;
		procedure Check;
		procedure   ReserveStorage(ParList:TTlvStorageList);override;
		procedure   FreeStorage; override;
	end;
	
	TCallMetaPoc = class(TMetaPoc)
		procedure Print(ParDis:TDisplay);override;
		function  CreateInst(ParCre:TInstCreator):boolean;override;
		procedure CommonSetup;override;
	end;
	
	TLSMovePoc = class(TPocBase)
	private
		voSource : TMacBase;
		voDest	 : TMacBase;
		voSize   : TSize;
		
		property iSource : TMacBase read voSource write voSource;
		property iDest   : TMacBase read voDest   write voDest;
		property iSize   : TSize    read voSize   write voSize;
	public
		property fSource :TMacBase read voSource;
		property fDest   :TMacBase read voDest;
		property fSize   :TSize    read voSize;

		constructor Create(ParSource,ParDest:TMacBase;ParSize:TSize);
		procedure   CommonSetup;override;
		function    CreateInst(ParCre:TInstCreator):boolean;override;
		procedure   Print(ParDis:TDisplay); override;
		procedure   ReserveStorage(ParList:TTlvStorageList);override;
		procedure   FreeStorage; override;
	end;
	
	TAsmPoc=class(TPocBase)
	private
		voText    : pointer;
		voSIze    : cardinal;
		procedure   SetText(ParSize:cardinal;ParText:Pointer);
		function    GetText:Pointer;
		function    GetSize:TSize;virtual;
	public
		constructor Create(ParSize : cardinal;ParText:pointer);
		procedure   clear;override;
		procedure   ResetText;
		procedure   COmmonsetup; override;
		procedure   Print(parDis:TDisplay);override;
		function    CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	TOptUnSavePoc=class(TPocBase)
	public
		procedure Commonsetup; override;
		function    CreateInst(ParCre:TInstCreator):boolean;override;
		procedure   Print(parDis:TDisplay);override;
	end;
	
implementation
uses asminfo,node;

{----( TOptUnSavePoc )-------------------------------------------------------}

procedure   TOptUnSavePoc.Commonsetup;
begin
	inherited COmmonsetup;
	iIdentCode := Ic_OptUnSavePoc;
end;

function   TOptUnSavePoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	ParCre.DeleteUnUsedUse;
	exit(false);
end;

procedure TOptUnSavePoc.Print(parDis:TDisplay);
begin
	ParDis.Write('Unsave-Unused-Resource');
end;

{----( TAsmPoc )-------------------------------------------------------------}

function  TAsmPoc.CreateInst(ParCre:TInstCreator):boolean;
var
	vlPtr : pointer;
begin
	ParCre.DeleteUnUsedUse;
	GetMem(vlPtr,GetSize);
	move(GetText^,vlPtr^,GetSize);
	ParCre.AddInstAfterCur(TAsmInst.Create(GetSize,vlPtr));
	voText     := nil;
	CreateInst := false;
end;

procedure TAsmPoc.Print(parDis:TDisplay);
begin
	ParDis.Writenl('ASM');
	ParDis.SetLeftMargin(4);
	PARDIS.WriteRaw(GetText,GetSize);
	ParDis.SetLeftMargin(-4);
	ParDis.nl;
	ParDis.Writenl('END');
end;

constructor TAsmPoc.Create(ParSize : cardinal;ParText:pointer);
begin
	inherited Create;
	SetText(parSize,ParText);
end;

procedure TAsmPoc.clear;
begin
	inherited Clear;
	SetText(0,nil);
end;

procedure TAsmPoc.ResetText;
begin
	voText := nil;
end;


procedure TAsmPoc.SetText(ParSize:Cardinal;ParText:Pointer);
begin
	if voText <> nil then freemem(voText,GetSize);
	voText := parText;
	voSize := PArSize;
	
end;

function  TAsmPoc.GetText:Pointer;
begin
	GetText := voText;
end;

function  TAsmPoc.GetSize:TSize;
begin
	GetSize := voSize;
end;

procedure TAsmPoc.commonsetup;
begin
	inherited Commonsetup;
	voText := nil;
	voSize := 0 ;
	iIdentCode := (IC_AsmPoc);
end;




{---( TLongResListItem )---------------------------------------------}


constructor TlongResListItem.Create(ParMac:TTLMac);
begin
	inherited Create;
	iMac := ParMac;
end;


procedure TLongResLIstItem.Print(parDis : TDisplay);
begin
	iMac.Print(ParDis);
end;


procedure TLongresListItem.ReserveStorage(ParList:TTlvStorageList);
begin
	iMac.ReserveStorage(ParList);
end;

procedure TLongResListItem.FreeStorage;
begin
	iMac.FreeStorage;
end;


{---( TLongResMacList )----------------------------------------------}

procedure TLongResList.SetMacsLOngRes(ParCre:TInstCreator;ParOnOf:boolean);
var vlCurrent:TLongResListItem;
begin
	vlCurrent := TLongResListITem(fStart);
	while vlCurrent <> nil do begin
		ParCre.SetResourceResLong(vlCurrent.fMac,ParOnOf,false);
		vlCurrent := TLongResListITem(vlCurrent.fNxt);
	end;
end;

procedure TLongResList.AddMac(ParMac:TTLMac);
begin
	InsertAtTop(TLongResListItem.Create(ParMac));
end;


procedure TLongResList.Print(parDis : TDisplay);
var vlCurrent : TLongResListItem;
begin
	vlCurrent := TLongResListItem(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.Print(ParDis);
		ParDis.nl;
		vlCurrent := TLongResListItem(vLCurrent.fNxt);
	end;
end;

procedure TLongResList.check;
var vlCurrent : TLongResListItem;
begin
	vlCurrent := TLongResListItem(fStart);
	while (vlCurrent <> nil) do begin
		write(vlCurrent.ClassName);
		vlCurrent := TLongResListItem(vLCurrent.fNxt);
	end;
end;


procedure TLongResList.ReserveStorage(ParList:TTlvStorageList);
var vlCurrent : TLongResListItem;
begin
	vlCurrent := TLongResListItem(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.ReserveStorage(ParList);
		vlCurrent := TLongReslistItem(vlCurrent.fNxt);
	end;
end;

procedure TLongResList.FreeStorage;
var vlCurrent : TLongResListItem;
begin
	vlCurrent := TLongResListItem(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.FreeStorage;
		vlCurrent := TLongReslistItem(vlCurrent.fNxt);
	end;
end;

{---( TLongResMetaPoc )------------------------------------------------}


procedure TLongResMetaPoc.Check;
begin
	fMacList.Check;
end;


procedure TLongResMetaPoc.Print(ParDis : TDisplay);
begin
	ParDis.WriteNl('Long Res ');
	if iGroupBegin = nil then ParDis.Write('begin')
	else ParDis.Write('end');
	ParDis.nl;
	ParDis.SetLeftMargin(3);
	fMacList.Print(ParDis);
	ParDis.SetLeftMargin(-3);
	ParDis.Write('End');
end;


procedure TLongResMetaPoc.CreateList;
begin
	fMacList := (TLongResList.Create);
end;

function TLongResMetaPoc.AddMac(ParCre : TCreator;ParMac:TMacBase):TMacBase;
var vlMac : TTLMac;
	vlLod : TPocBase;
begin
	vlMac :=  TTLMac.Create(ParMac.fSize,ParMac.fSign);
	TSecCreator(ParCre).AddObject(vlMac);
	fMacList.AddMac(vlMac);
	vlLod := TSecCreator(ParCre).MakeLoadPoc(vlMac,ParMac);
	TSecCreator(ParCre).AddSec(vlLod);
	exit(vlMac);
end;


destructor TLongResMetaPoc.Destroy;
begin
	inherited Destroy;
	fMacList.Destroy;
end;


procedure  TLongResMetaPoc.SetMacsLongRes(ParCre:TInstCreator;ParFlag:boolean);
begin
	{	fMacList.SetMacsLongRes(ParCre,ParFlag);}
end;

procedure TLongResMetaPoc.COmmonsetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_LongResMetaPoc;
	CreateList;
end;

function TLongResMetaPoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	{	if iGroupBegin <> nil then TLongResMetaPoc(iGroupBegin).SetMacsLongRes(ParCre,false)
	else SetMAcsLongRes(ParCre,true);
	}	CreateInst := false;
end;


procedure  TLongResMetaPoc.ReserveStorage(ParList:TTlvStorageList);
begin
	if iGroupBegin = nil then fMacList.ReserveStorage(ParList);
end;

procedure   TLongResMetaPoc.FreeStorage;
begin
	if iGroupBegin <> nil then TLongResMetaPoc(iGroupBegin).fMacList.FreeStorage;
end;

{-----( TCallMetaPoc )-----------------------------------------------}

procedure TCallMetaPoc.Print(ParDis:TDisplay);
begin
	ParDis.Write('Call group');
	if iGroupBegin = nil then ParDis.Write(' begin')
	else ParDis.Write(' end');
end;

function  TCallMetaPoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	if iGroupBegin = nil then begin
		ParCre.PushAll;
		CreateInst :=false;
	end;
	CreateInst := false;
end;


procedure TCallMetaPoc.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_CallMetaPoc;
end;


{---- ( TMetaPoc )-----------------------------------------------------}


procedure TMetaPoc.CommonSetup;
begin
	inherited CommonSetup;
	iGroupBegin := nil;
	iGroupEnd   := nil;
	iIdentCode  := Ic_MetaPoc;
	iMeta := true;
end;


procedure TMetaPoc.Print(ParDis:TDisplay);
begin
	ParDis.Write('Group');
end;

function  TMetaPoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	CreateInst := false;
end;




{---( TUnkPoc )-------------------------------------------------------------------}



destructor TUnkPoc.Destroy;
begin
	inherited destroy;
	if fClassName <> nil then fClassName.Destroy;
end;

procedure TUnkPoc.SetClassName(const ParClassName:string);
begin
	if fClassName <> nil then fClassName.Destroy;
	fClassName := TString.Create(parClassName);
end;

constructor TUnkPoc.Create(const ParNAme:string);
begin
	inherited Create;
	SetClassName(ParName);
end;
function  TUnkPoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	ParCre.AddInstAfterCur(TErrorInst.Create);
	exit(false);
end;

procedure TUnkPoc.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_UnkPoc;
	fClassName := nil;
end;

procedure TUnkPoc.Print(ParDis:TDisplay);
var vlStr:String;
begin
	fClassName.GetString(vlStr);
	ParDis.Write('Error, node className=' + vlStr);
end;

{---( TSubPoc )--------------------------------------------------------------------}


procedure TSubPoc.LinearizeSubList;
var
	vlOut : TSubPocList;
begin
	vlOut := TSubPocList.Create;
	vlOut.Linearize(fPocList);
	iPocList.Destroy;
	iPocList := vlOut;
end;


procedure TSubPoc.ReserveStorage(ParList:TTlvStorageList);
begin
	iPocList.AssignTlStorage(ParList);
end;

function TSubPoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	exit(iPocList.CreateInst(ParCre));
end;

function   TSubPoc.Optimize:boolean;
begin
	exit(iPocList.Optimize);
end;


destructor TSubPoc.Destroy;
begin
	inherited Destroy;
	iPocList.Destroy;
end;

procedure   TSubPoc.CommonSetup;
begin
	inherited COmmonSetup;
	iPocList  := TSubPocList.Create;
	iIdentCode := IC_SubPoc;
end;


procedure   TSubPoc.Print(parDis:TDisplay);
begin
	ParDis.Write('Sub List');
	ParDis.nl;
	ParDis.SetLEftMargin(3);
	iPocList.Print(ParDis);
	ParDis.SetLeftMargin(-3);
end;

{-----( TLSMovePOC )----------------------------------------------------------}


procedure   TLsMovePoc.ReserveStorage(ParList:TTlvStorageList);
begin
	iSource.ReserveStorage(ParList);
	iDest.ReserveStorage(ParList);
end;

procedure   TLsMovePoc.FreeStorage;
begin
	iSource.FreeStorage;
	iDest.FreeStorage;
end;

procedure TLSMovePoc.Print(parDis:TDisplay);
begin
	ParDis.Write('LSMOVE');
	ParDis.nl;
	ParDis.SetLeftMargin(6);
	if iSource <> nil then iSource.Print(parDis)
	else ParDis.write('[unkown]');
	ParDis.SetLeftMargin(-3);
	ParDis.Nl;
	ParDis.Write('To');
	ParDis.Nl;
	ParDis.SetLEftMargin(3);
	if iDest <> nil then iDest.Print(ParDis)
	else ParDis.write('[unkown]');
	ParDis.Nl;
	ParDis.SetLeftMargin(-6);
	ParDis.Write('END LSMOVE');
end;

function    TLSMovePoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateLsMov(ParCre,self);
	exit(false);
end;

constructor TLSMovePoc.Create(ParSource,ParDest:TMacBase;ParSize:TSize);
begin
	inherited Create;
	iSource := ParSource;
	iDest   := ParDest;
    iSize   := ParSIze;
end;

procedure TLSMovePoc.commonsetup;
begin
	inherited commonsetup;
	iIdentCode := IC_LSMove;
end;

{-----( TCallPoc )---------------------------------------------------------}



procedure TCallPoc.SetReturnVar(PArVar:TMacBase);
begin
	iReturnVar := ParVar;
end;

procedure TCallPoc.CommonSetup;
begin
	inherited COmmonSetup;
	iTargetMac := nil;
	iReturnVar := nil;
	iIdentCode := IC_CallPoc;
	iCDecl     := False;
	iParamSize := 0;
end;


function  TCallPoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateCall(ParCre,self);
	exit(false);
end;


constructor TCallPoc.Create(ParTarget:TMacBase;ParCDecl:boolean;ParSize:TSize);
begin
	inherited Create;
	iTargetMac := ParTarget;
	iCDecl     := ParCDecl;
	iParamSize := parSize;
end;

procedure TCallPoc.Print(ParDis:TDisplay);
begin
	ParDis.write('Call ');
	if iTargetMac <> nil then iTargetMac.Print(parDis);
	if iReturnVar <> nil then begin
		ParDis.Write(' Return=');
		iReturnVar.Print(ParDis);
	end;
end;

{-----( TSetParPoc )-------------------------------------------------------}


procedure TSetParPoc.ReserveStorage(ParTLVList:TTLvStorageList);
begin
	fPar.ReserveStorage(ParTLVList);
end;

procedure TSetParPoc.FreeStorage;
begin
	fPar.FreeStorage;
end;


procedure TSetParPoc.SetRtlParameterFlag(ParFlag : boolean);
begin
	voRtlPArameterFlag := ParFlag;
end;

function  TSetParPoc.CreateInst(PArCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateSetPAr(ParCre,self);
	CreateInst:= false;
end;

procedure TSetParPoc.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_SetParPoc;
	SetRtlParameterFlag(false);
end;

constructor TSetParPoc.Create(ParParam : TMacBase);
begin
	iPar := ParParam;
	inherited Create;
end;

procedure TSetParPoc.Print(ParDIs:TDisplay);
begin
	ParDis.Write('Setpar ');
	PrintiDent(ParDis,fPar);
end;


{-----( TAndFor )--------------------------------------------------------}

procedure TAndFor.Print(parDis:TDisplay);
begin
	ParDis.Write('AND ');
	inherited Print(ParDis);
end;

procedure TAndFor.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_AndFor;
end;


function TAndFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateAnd(ParCre,self);
	CreateInst := false;
end;

{-----( TOrFor )--------------------------------------------------------}


function TOrFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateOr(ParCre,self);
	CreateInst := false;
end;


procedure TOrFor.Print(parDis:TDisplay);
begin
	ParDis.Write('OR ');
	inherited Print(ParDis);
end;


procedure TOrFor.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_OrFor;
end;


{-----( TXorFor )--------------------------------------------------------}

procedure TXorFor.Print(parDis:TDisplay);
begin
	ParDis.Write('XOR ');
	inherited Print(ParDis);
end;


function TXOrFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateXor(ParCre,self);
	CreateInst := false;
end;


procedure TXorFor.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_XorFor;
end;

{-----( TCondJumpPoc )---------------------------------------------------}


constructor TCondJumpPoc.Create(ParWhen:boolean;ParCond : TMacBase;ParLabel : TLabelPoc);
begin
	iWhen := ParWhen;
	iMac  := ParCond;
	inherited Create(ParLabel);
end;

procedure   TCondJumpPoc.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_CondJumpPoc;
end;


procedure   TCondJumpPoc.Print(PArDis:TDisplay);
var vlLabel : TLabelPoc;
	vlName  : string;
begin
	ParDis.Write('jump when ');
	PrintIdent(ParDis,iMac);
	ParDis.Write('=');
	if iWhen then PArDis.Write('TRUE')
	else ParDis.Write('FALSE');
	PArDis.Write(' to ');
	vlLabel := fLabel;
	if vlLabel <> nil then begin
		vlLabel.GetName(vlname);
		ParDis.Write(vlName)
	end
	else ParDis.Write('<empty>');
	
end;

function TCondJumpPoc.Optimize:boolean;
var
	vlNxt1 : TPocBase;
	vlNxt2 : TPocBase;
begin
	Optimize := false;
	vlnxt1 := GetNextNonMeta;
	if(vlNxt1 <> nil) and (vlNxt1.fIdentCode = IC_JumpPoc) and not(vlNxt1.CanDelete)  then begin
		vlNxt2 := vlNxt1.GetNextNonMeta;
		if(fLabel = vlNxt2) then begin
			iWhen := not(iWhen);
			SetLabel(TJumpPoc(vlNxt1).fLabel);
			TJumpPoc(vlNxt1).SetDelete;
			Optimize := true;
		end;
	end;
	if OptimizeFollowingLabels then Optimize := true;
end;


function TCondJUmpPoc.Createinst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateCondJump(ParCre,self);
	CreateInst := false;
end;

{-----( TJumpPoc )-------------------------------------------------------}

procedure  TJumpPoc.SetDelete;
begin
	if not(iDelete) then iLabel.DecUsage;
	inherited SetDelete;
end;

constructor TJumpPoc.Create(ParLabel : TLabelPoc);
begin
	inherited Create;
	iLabel := ParLabel;
	iLabel.IncUsage;
end;

function  TJumpPoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateJump(ParCre,self);
	CreateInst := false;
end;

function  TJumpPoc.IsUsingSec(ParSec:TSecBase;parHow:THowType):boolean;
begin
	IsUsingSec := true;
	if (IS_Reads in ParHow) and (fLabel.IsSame(ParSec)) then exit;
	IsUsingSec := inherited IsUsingSec(parSec,ParHow);
end;

function  TJumpPoc.Optimize:boolean;
var vJmp      : TJumpPoc;
	vIc       : TPocIdentCode;
	vlCurrent : TPocBase;
begin
	Optimize := false;
	vJmp := TJumpPoc(fLabel.GetNextNi);
	if Pointer(fNxt) = pointer(fLabel) then begin
		SetDelete;
		Optimize := true;
		exit;
	end;
	if vJmp <> nil then begin
		vIc := vJmp.fIdentCode;
		if (vIc = IC_JumpPoc) or (vIc = IC_CondJumpPoc) then begin
			if fLabel <>vJmp.fLabel then begin
				SetLabel(vJmp.fLabel);
				Optimize := true;
			end;
		end;
	end;
	vlCurrent := TPocBase(fNxt);
	while (vlCurrent <> nil) and ((vlCurrent.fIdentCode  <> IC_LabelPoc)
	and (vlCurrent.fIdentCode <> ic_SubPoc)) do begin
		vlCurrent.SetDelete;
		vlCurrent := TPocBase(vlCurrent.fNxt);
		Optimize := true;
	end;
	if OptimizeFollowingLabels then Optimize := true;
end;


function  TJumpPoc.OptimizeFollowingLabels:boolean;
var
	vlPoc : TLabelPoc;
	vlPrv : TLabelPoc;
begin
	OptimizeFollowingLabels := false;
	vlPoc := fLabel;
	vlPrv := fLabel;
	while (vlPoc <> nil) do begin
		if  not (vlPoc is TLabelPoc) then break;
		vlPrv := vlPoc;
		vlPoc := TLabelPoc(vlPoc.fPrv);
	end;
	if vlPrv <> fLabel then SetLabel(vlPrv);
end;


procedure TJumpPoc.CommonSetup;
begin
	inherited CommonSetup;
	voLabel := nil;
	iIdentCode := IC_JumpPoc;
end;

procedure TJumpPoc.SetLabel(parLabel:TLabelPoc);
begin
	if fLabel <> nil then fLabel.DecUsage;
	iLabel   := ParLabel;
	if fLabel <> nil then fLabel.IncUsage;
end;



procedure TJumpPoc.Print(ParDis:TDisplay);
var vLabName:string;
begin
	fLabel.GetName(vLabName);
	ParDis.write('jump ');
	PArDis.Write(vLabName);
end;


{---( TLabelPoc)---------------------------------------------------------}


function  TLabelPoc.CanDelete : boolean;
begin
	exit(fUse = 0);
end;


function  TLabelPoc.GetInst(ParCre:TInstCreator):TLabelInst;
begin
	if iInst = nil then   iInst :=TLabelInst( ParCre.CreateLabel(voLabelNo));
	exit(iInst)
end;


function  TLabelPoc.CreateInst(ParCre:TInstCreator):boolean;
begin
	ParCre.DeleteUnusedUse;
	ParCre.AddInstAfterCur(GetInst(ParCre));
	CreateInst := false;
end;


Function  TLabelPoc.Optimize:boolean;
begin
	Optimize := false;
	if fUse = 0 then begin
		SetDelete;
		Optimize :=true;
	end;
end;



constructor TLabelPoc.Create;
begin
	voLabelNo := GetNewLabelNo;;
	inherited Create;
end;


procedure TLabelPoc.GetName(var ParName:string);
begin
	
	str(voLabelNo,ParName);
	ParName := '.l'+ParName;
end;

procedure TLabelPoc.Print(ParDis:TDisplay);
var vlStr:string;
begin
	GetName(vlStr);
	ParDis.SetLeftMargin(-12);
	ParDis.Write(vlStr);
	ParDis.Write(':');
	ParDis.SetLeftMargin(12);
end;


procedure TLabelPoc.CommonSetup;
begin
	inherited CommonSetup;
	iInst      := nil;
	iIdentCode := IC_LabelPoc;
	iIgnore    := true;
end;

{---( TCOmpFor  )--------------------------------------------------------}

function  TCompFor.GetIdentNumber(ParMacPos:TNormal):TFlag;
begin
	if ParMacPos = 0 then GetIdentNUmber := In_Flag_out
	else GetIdentNumber := inherited GetIdentNumber(ParMacPos);
end;

function  TCOmpFor.CreateInst(PArCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateComp(ParCre,self);
	CreateInst :=false;
end;

constructor TCompFor.Create(PArCompCode : TIdentCode);
begin
	fCompCode := ParCompCode;
	inherited Create;
end;

procedure TCompFor.Print(ParDis:TDisplay);
begin
	ParDis.Write('comp ');
	inherited Print(ParDis);
end;

function TCOmpFor.CalcOutputMac(ParCre : TCreator):TMacBase;
var
	vlMac:TCompareMAc;
	vlP1:TMacBase;
	vlP2:TMacBase;
begin
	vlP1 := GetVar(1);
	vlP2 := GetVar(2);
	vlMac := TCompareMAc.create(fCompCode,vlP1.fSign or vLP2.fSign);
	TSecCreator(ParCre).AddObject(vlMac);
	SetVar(Mac_Output,vlMac);
	exit(vlMac);
end;

procedure TCompFor.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_CompPoc;
end;

{---( TTwoFor )------------------------------------------------}


procedure TTwoFor.CreateAllResources(ParCre:TInstCreator;ParInst:TInstruction);
begin
	ParInst.AddResItem(CreateResource(ParCre,1));
	ParInst.AddResItem(CreateResource(ParCre,0));
end;

function TTwoFor.GetIdentNumber(ParMacPos:TNormal):TFlag;
begin
	case ParMacPos of
	0:GetIdentNumber := In_Main_Out;
	1:GetIdentNumber := In_In_1;
	else GetIdentNumber := inherited GetIdentNumber(ParMacPos);
end;
end;

function TTWoFor.IsUsingSec(ParSec:TSecBase;ParHow:THowTYpe):boolean;
var vlP1:TMacBase;
begin
	IsUsingSec :=true;
	if (IS_Reads in ParHow) then begin
		vlP1 := GetVar(1);
		if vlP1.IsSame(ParSec) then exit;
	end;
	IsUsingSec := inherited IsUsingSec(parSec,ParHow);
end;



{---( TThreePoc )--------------------------------------------------------}
procedure TThreePoc.CreateAllResources(ParCre:TInstCreator;ParInst:TInstruction);
begin
	ParInst.AddResItem(CreateResource(ParCre,2));
	inherited CreateAllResources(ParCre,ParInst);
end;

function TThreePoc.GetIdentNumber(ParMacPos:TNormal):TFlag;
begin
	if ParMacPos = 2 then GetIdentNumber := In_In_2
	else GetIdentNumber := Inherited GetidentNUmber(ParMacPos);
end;


procedure TThreePoc.Print(ParDis:TDisplay);
var vlP1,vlP2,vlOut:TMacBase;
begin
	vlOut := GetVar(0);
	vlP1 := GetVar(1);
	vlP2 := GetVar(2);
	PrintIdent(ParDis,vlP1);
	ParDis.Write(',');
	PrintIdent(ParDis,vlP2);
	ParDis.Write('-->');
	PrintIdent(ParDis,vlOut);
end;

function TThreePoc.IsUsingSec(ParSec:TSecBase;ParHow:THowTYpe):boolean;
var vlP2:TMacBase;
begin
	IsUsingSec := true;
	vlP2 := GetVar(2);
	if (IS_Reads in ParHow) and (vlP2.IsSame(ParSec)) then exit;
	IsUsingSec := inherited IsUsingSec(parSec,ParHow);
end;


{---( TFormulaPoc )------------------------------------------------------}


procedure   TFormulaPoc.ReserveStorage(ParList:TTlvStorageList);
begin
	iMacList.ReserveStorage(ParList);
end;

procedure   TFormulaPoc.FreeStorage;
begin
	iMacList.FreeStorage;
end;

procedure TFormulaPoc.CreateList;
begin
	iMacList := (TMacList.create);
end;


procedure   TFormulaPoc.CommonSetup;
begin
	inherited CommonSetup;
	CreateList;
end;


destructor  TFormulaPoc.Destroy;
begin
	inherited Destroy;
	iMacList.Destroy;
end;


procedure TFormulaPoc.SetMacResTranslation(ParList:TOperandList;ParCre:TInstCreator);
var
	vlMac  :TMacBase;
begin
	vlMac   := GetVar(0);
	if vlMac <> nil then ParCre.SetOutputLock(vlMac,false);
end;

procedure TFormulaPoc.CreateAllResources(ParCre:TInstCreator;ParInst:TInstruction);
begin
	Fatal(Fat_abstract_routine,'In :TFormulaPOc.CreateAllResources');
end;

function  TFormulaPoc.CreateResource(ParCre:TInstCreator;ParNo:TNormal):TOperand;
var vlMac   : TMacBase;
	vlRes   : TResource;
	vlIdent : TFlag;
	vlOper  : TOperand;
begin
	vlMac   := GetVar(ParNo);
	if vlMac = nil then begin
		Fatal(Fat_Mandatory_Mac_Not_Found,['[Number=',ParNo,']']);
	end;
	if ParNo = 0 then  ParCre.DeleteUnusedByMac(vlMac,UDM_Output); {hack avoids output=unused resource}
	vlRes   := vlMac.CreateInstRes(ParCre);
	if(vlRes.fSize > GetAssemblerInfo.GetSystemSize) then fatal(FAT_Operant_To_big,['Type = ',vlMac.ClassName,' size=',vlRes.fSize]);
	vlIdent := GetIdentNumber(ParNo);
	vlOper  := TOperand.create(vlRes,vlIdent);
	if vlOper.GetAccess(RA_Output)  then begin
		ParCre.SetResourceUse(vlMac,vlRes);
		ParCre.SetOutputLock(vlMac,true);
	end else begin
		ParCre.AddUnUsedResourceUse(vlMac,vlRes);
	end;
	exit(vlOper);
end;

function  TFormulaPoc.CreateInst(PArCre:TInstCreator):boolean;
begin
	fatal(fat_abstract_routine,'abstract function call');
	CreateInst := false;
end;


function TFormulaPoc.CalcOutputMac(ParCre : TCreator):TMacBase;
var vlSize : TSize;
	vlSign : boolean;
	vlVar  : TMacBase;
begin
	iMacList.GetMetric(vlSign,vlSize);
	vlVar := TResultMac.create(vlSize,vlSign);
	TSecCreator(ParCre).AddObject(vlVar);
	SetVar(Mac_Output,vlVar);
	exit(vlVar);
end;

function TFormulaPoc.SetVar(ParNo : cardinal;ParVar:TMacBase):boolean;
begin
	if (ParVar.fNxt <>  nil) or (ParVar.fPrv <> nil) then begin
		fatal(FAT_Item_Duplicated_inserted,'AT:TFormulaPoc.SetVar');
	end;
	iMacList.AddMac(ParNo,ParVar);
	exit(true);
end;

function TFormulaPoc.GetVar(ParNo : cardinal):TMacBase;
begin
	exit(iMacList.GetMacByNum(ParNo));
end;

{---( TPocBase )---------------------------------------------------------}


function  TPocBase.CanDelete : boolean;
begin
	exit(iDelete);
end;


procedure TPocBase.ReserveStorage(ParList:TTlvStorageList);
begin
end;

procedure TPocBase.FreeStorage;
begin
end;

function  TPocBase.GetIdentNumber(ParMacPos:TNormal):TFlag;
begin
	GetIDentNumber := 0;
	fatal(fat_Invalid_Mac_Number,'TPocBasel.GetIdentNumber');
end;

function  TPocBase.CreateInst(ParCre:TInstCreator):boolean;
begin
	fatal(fat_abstract_routine,'TPocBAse.CreateInst');
	CreateInst := false;
end;

procedure TPocBase.Print(ParDis:TDisplay);
begin
	ParDis.WriteNl('Abstract');
end;

function TPocBase.GetNextNonMeta : TPocBase;
var
	vlCurrent : TPocBase;
begin
	vlCurrent := TPocBase(fNxt);
	while (vlCurrent <> nil) and (vlCurrent.fMeta) do vlCurrent:= TPocBase(vlCurrent.fNxt);
	exit(vlCurrent);
end;

function TPocBase.GetNextNi:TPocBase;
var vlCurrent :TPocBase;
begin
	vlCurrent := TPocBase(fNxt);
	while (vlcurrent <> nil) and (vlCurrent.fIgnore) do vlCurrent := TPocBase(vlCurrent.fNxt);
	GetNextNI := vlCurrent;
end;

procedure TPocBase.SetDelete;
begin
	iDelete := true;
end;

procedure TPocBase.CommonSetup;
begin
	iIgnore := false;
	iDelete := false;
	iMeta   := false;
	iIdentCode := IC_UnkownPoc;
	inherited CommonSetup;
end;


function  TPocBase.IsUsingSec(ParSec:TSecBase;ParHow:THowType):boolean;
begin
	IsUsingSec :=false;
end;

{---( TNegFor )--------------------------------------------}

function TNegFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateNeg(ParCre,self);
	CreateInst := false;
end;

procedure TNegFor.Print(parDis:TDisplay);
begin
	PArDis.Write('NEG ');
	GetVar(1).Print(PArDis);
end;

procedure TNegFor.commonsetup;
begin
	inherited COmmonsetup;
	iIdentCode := ic_NegPoc;
end;



{---( TNotFor )--------------------------------------------}

function TNotFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateNot(ParCre,self);
	CreateInst := false;
end;

procedure TNotFor.Print(parDis:TDisplay);
begin
	PArDis.Write('NOT ');
	GetVar(1).Print(PArDis);
end;

procedure TNotFor.commonsetup;
begin
	inherited COmmonsetup;
	iIdentCode := ic_NotPoc;
end;


{--( TIncDecFor )-------------------------------------------}

function  TIncDecFor.GetIdentNumber(ParMacPos:TNormal):TFlag;
begin
	case ParMacPos of
	0:GetIdentNumber := In_Main_Out or In_In_1;
	1:GetIdentNumber := In_In_2;
	else GetIdentNumber := inherited GetIdentNumber(ParMacPos);
end;
end;

function  TIncDecFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateIncDec(ParCre,self);
	exit(false);
end;

procedure TIncDecFor.Print(parDis:TDisplay);
begin
	if iIncFlag then ParDis.Write('INC ')
	else ParDis.Write('DEC ');
	GetVar(0).Print(ParDis);
	ParDis.Write(',');
	GetVar(1).Print(ParDis);
end;


constructor TIncDecFor.Create(ParIncFlag : boolean);
begin
	inherited Create;
	iIncFlag := ParIncFlag;
end;

procedure TIncDecFor.commonsetup;
begin
	inherited COmmonsetup;
	iIdentCode := ic_incdecfor;
end;




{---( TAddFor )-------------------------------------------------}



function  TAddFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateAdd(ParCre,self);
	CreateInst := false;
end;

procedure TAddFor.Print(ParDis:TDisplay);
begin
	ParDis.Write('Add ');
	inherited Print(PArDis);
end;

procedure TAddFor.Commonsetup;
begin
	inherited COmmonsetup;
	iIdentCode := IC_AddFor;
end;


{---( TSubFor )-------------------------------------------------}



function  TSubFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateSub(ParCre,self);
	CreateInst := false;
end;



procedure TSubFor.Print(ParDis:TDisplay);
begin
	ParDis.Write('Sub ');
	inherited Print(PArDis);
end;


procedure TSubFor.Commonsetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_SubFor;
end;

{----( TShrFor )------------------------------------------------}

procedure TShrFor.Print(ParDis:TDisplay);
begin
	ParDis.Write('SHR ');
	inherited Print(ParDis);
end;

procedure TShrFor.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_ShrPoc;
end;


function  TShrFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateShr(ParCre,self);
	exit(false);
end;

{----( TShlFor )------------------------------------------------}

procedure TShlFor.Print(ParDis:TDisplay);
begin
	ParDis.Write('SHR ');
	inherited Print(ParDis);
end;

procedure TShlFor.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_ShlPoc;
end;


function  TShlFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateShl(ParCre,self);
	exit(false);
end;

{---( TMulFor )-------------------------------------------------}

function  TMulFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateMul(parCre,self);
	CreateInst :=false;
end;



procedure TMulFor.Print(ParDis:TDisplay);
begin
	ParDis.Write('Mul ');
	inherited Print(ParDis);
end;


procedure TMulFor.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_MulFor;
end;

{---( TModFor )----------------------------------------------------}

function TModFor.GetIdentNumber(ParMacPos:TNormal):TFlag;
begin
	if ParMacPos = 0 then GetIdentNumber := In_Mod_Out
	else GetIdentNUmber := inherited GetIdentNumber(ParMacPos);
end;

function  TModFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateMod(ParCre,self);
	CreateInst :=false;
end;



procedure TModFor.Print(ParDis:TDisplay);
begin
	ParDis.Write('DIV ');
	inherited Print(ParDis);
end;



procedure TModFor.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_ModFor;
end;



{---------( TDivFor )--------------------------------------------------}



function  TDivFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateDiv(ParCre,self);
	exit(false);
end;



procedure TDivFor.Print(ParDis:TDisplay);
begin
	ParDis.Write('DIV ');
	inherited Print(ParDis);
end;


procedure TDivFor.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_DivFor;
end;


{---( TLOadFor )------------------------------------------------}


function TLoadFor.CalcOutputMac(ParCre : TCreator):TMacBase;
var vlmac:TMacBase;
begin
	vlMac := TResultMac.create(GetVar(1).fSize,GetVar(1).fSign);
	TSecCreator(ParCre).AddObject(vlMac);
	Setvar(0,vlMac);
	exit(vlMac);
end;


function  TLoadFor.CreateInst(ParCre:TInstCreator):boolean;
begin
	GetAssemblerInfo.TranslateLoad(ParCre,self);
	exit(false);
end;

procedure TLoadFor.Print(ParDis:TDisplay);
begin
	PrintIdent(ParDis,GetVar(0));
	ParDis.Write(' := ');
	PrintIdent(ParDis,GetVar(1));
end;


procedure TLoadFor.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_LoadPoc;
end;


{---( TSubPocList )---------------------------------------------------------}


	
procedure TSubPocList.Print(ParDis:TDisplay);
var vlCurrent:TSecBase;
begin
	vlCurrent := TSecBase(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.Print(ParDis);
		ParDis.nl;
		vlCurrent := TSecBase(vlCurrent.fNxt);
	end;
end;


{ Assigns a TStorageObject to a TLMac
Is Called  after the poclist is created from te nodelist.
}

procedure TSubPocList.AssignTlStorage(ParList:TTlvStorageList);
var vlCurrent:TPocBase;
begin
	vlCurrent := TPocBase(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.ReserveStorage(ParList);
		vlCurrent := TPocBase(vlCurrent.fNxt);
	end;
	vlCurrent := TPocBase(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.FreeStorage;
		vlCurrent := TPocBase(vlCurrent.fNxt);
	end;
end;

{ Linearize PocList}

procedure TSubPocList.Linearize(ParLIst:TSubPocList);
var vlCurrent:TPocBase;
	vlNxt:TPocBase;
begin
	vlCurrent := TPocBase(ParList.fStart);
	while vlCurrent <> nil do begin
		ParList.CutOut(vlCurrent);
		vlNXt := TPocBase(vlCurrent.fNxt);
		if vlCurrent.fIdentCode = IC_SubPoc then begin
			Linearize(TSubPoc(vlCurrent).fPocList);
			vlCurrent.Destroy;
		end
		else InsertAtTop(vlCurrent);
		vlCurrent := vlNxt;
	end;
end;


procedure TSubPocList.CommonSetup;
begin
	fMacCnt   := 0;
	inherited CommonSetup;
end;


procedure TSubPocList.AddSec(ParSec:TSecBase);
begin
	if ParSec.fNxt <> nil then runerror(254);
	InsertAtTop(ParSec);
end;

{ create a label
Verplaatsen naar SecCreate?
}

function TSubPocList.CreateLabel:TLabelPoc;
begin
	exit(TLabelPoc.Create);
end;

function TSubPocList.AddLabel:TLabelPoc;
var
	vlLab:TLabelPoc;
begin
	if (fTop <> nil) and ( TPocBase(fTop).fIdentCode = IC_LabelPoc)then begin
		vlLab := TLabelPoc(fTop)
	end else begin
		vlLab := CreateLabel;
		AddSec(vlLab);
	end;
	exit(vlLab);
end;

function  TSubPocList.Optimize:boolean;
var
	vlHasChanges:boolean;
	vlCurrent:TPocBase;
begin

	repeat
		vlHasChanges := false;
		vlCurrent    := TPocBase(fStart);
		while vlCurrent <> nil do begin
			
			if vLCurrent.CanDelete then begin
				vlCurrent := TPocBase(DeleteLink(vlCurrent));
				vlHasChanges := true;
			end else begin
				if vlCurrent.Optimize then vlHasChanges := true;
				vlCurrent := TPocBase(vlCurrent.fNxt);
			end;
			
		end;
	until not vlHaschanges;
	exit(vlHasChanges);
end;


function TSubPocList.CreateInst(ParCre:TInstCreator):boolean;
var vlCurrent :TPocBase;
begin
	vlCurrent  := TPocBase(fStart);
	CreateInst := true;
	while (vLCurrent <> nil)  do begin
		{$ifdef showregres}
			writeln(vlCurrent.ClassName);
		{$endif}
		if vlCurrent.CreateInst(ParCre) then exit;
		vlCurrent := TPocBase(vlCurrent.fNxt);
		
	end;
	CreateInst := false;
end;


end.
