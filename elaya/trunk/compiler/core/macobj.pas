{    Elaya, the ;compilerfor the elaya language
Copyright (C) 1999-2002  J.v.Iddekinge.
Web   : www.elaya.org
Email : iddekingej@lycos.com

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

unit MacObj;
interface
uses largenum,compbase,progutil,display,elatypes,elacons,Resource,error,stdobj,lsstorag;

type
	
	TMacBase=class(TSecBase)
	private
		voSize        : TSize;
		voSign        : boolean;
		voExtraOffset : TOFfset;
		voIdentCode   : TMacIdentCode;
		property    iExtraOffset : TOffset       read voExtraOffset     write voExtraOffset;
		property    iSign        : boolean       read voSign            write voSign;
		property    iSize        : TSize         read voSize            write voSize;
		property    iIdentCode   : TMacIdentCode read voIdentCode write voIdentCode;
	protected
		procedure   CommonSetup;override;

	public
		property    fExtraOffset : TOffset  read voExtraOffset;
		property    fSign	     : boolean read voSign;
		property    fSize	     : TSize   read voSize;
		property    fIdentCode   : TMacIdentCode read voIdentCode;
		
		procedure   PrintExtraOffset(ParDIs:TDisplay);
		function    IsSameType(parMac:TSecBase):boolean;
		procedure   AddExtraOffset(ParOff:TOffset);
		procedure   SetExtraOffset(ParOff:TOffset);
		procedure   SetSign(ParSign:boolean);
		procedure   SetSize(ParSize : TSize);
		constructor Create(ParSize:TSize;ParSign:boolean);
		function    CreateInstRes(ParCre:TInstCreator):TResource;
		function    CreateResource(ParCre:TInstCreator):TResource;virtual;
		function    CreatePtrResource(ParCre : TInstCreator):TResource;virtual;
		function    CreateByPtrResource(ParSize : TSize;ParSign :boolean;ParCre:TInstCreator):TResource;virtual;
		function    IsSame(ParMac:TSecBase):boolean;override;
		procedure   Print(parDis:TDisplay);override;
		procedure   ReserveStorage(ParList:TTLVStorageList);virtual;
		procedure   FreeStorage;virtual;
		function    IsNumber(ParNum:TNumber):boolean;virtual;
		function    IsNumberInt(ParNum:longint):boolean;
	end;


TMethodPtrMac=class(TMacBase)
private
		voObject  : TMacBase;
		voRoutine : TMacBase;
protected
		property iObject  : TMacBase read voObject  write voObject;
		property iRoutine : TMacBase read voRoutine write voRoutine;
    	procedure   CommonSetup;override;

public
		property fObject : TMacBase read voObject;
		property fRoutine: TMacBase read voRoutine;
		function    IsSame(ParMac:TSecBase):boolean;override;
		function    CreateResource(ParCre:TInstCreator):TResource;override;
		procedure   Print(parDis:TDisplay);override;
		constructor create(ParObject,ParRoutine : TMacBase;ParSize : TSIze);
end;

const Mac_Num_Params=5;
type  TMacParams=array[0..Mac_Num_params-1] of TMacBase;

TMacList=class(TRoot)
private
	voParams : TMacParams;
	property iParams : TMacParams read voParams write voParams;
public
	procedure AddMac(ParNum : cardinal;ParMac:TMacBase);
	function  GetMacByNum(ParNum : cardinal):TMacBase;
	procedure GetMetric(var ParSign:boolean;var ParSize:TSize);
	procedure ReserveStorage(ParList:TTlvStorageList);
	procedure FreeStorage;
	procedure Commonsetup;override;
end;


TMemMac=class(TMacBase)
private
	voName : TString;
	property  iName : TString read voName write voName;
protected
	procedure  CommonSetup;override;
public
	property   fName : TString read voName;
	constructor Create(ParSize:TSize;ParSign:boolean;const ParName : ansistring);
	procedure  fNameStr(var ParName:ansistring);
	function   IsSame(ParMac:TSecBase):boolean;override;
	procedure  Print(parDis:TDisplay);override;
	function   CreateResource(ParCre:TInstCreator):TResource;override;
	function   CreatePtrResource(ParCre : TInstCreator):TResource;override;
	function   CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;override;
	destructor Destroy;override;
end;

TMemOfsMac=class(TMacBase)
private
	voSourceMac:TMacBase;
	property   iSourceMac : TMacBase read voSourceMac write voSourceMac;
	
public
	constructor Create(ParSourceMac : TMacBase);
	procedure   CommonSetup;override;
	function    CreateResource(ParCre:TInstCreator):TResource;override;
	function    CreatePtrResource(ParCre : TInstCreator):TResource;override;
	function    CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;override;
	procedure   Print(parDis : TDisplay);override;
	procedure   ReserveStorage(ParList : TTLVStorageList);override;
	procedure   FreeStorage;override;
end;

TNumberMac=class(TMacBase)
private
	voInt : TNumber;
	
protected
	property    iInt : TNumber read voInt write voInt;
	
public
	property    fInt : TNumber read voInt write voInt;
	function    IsSame(ParSec:TSecBase):boolean;override;
	constructor Create(ParSize:TSize;ParSign:boolean;ParInt:TNumber);
	function   CreateResource(ParCre:TInstCreator):TResource;override;
	function    CreatePtrResource(ParCre : TInstCreator):TResource;override;
	function    CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;override;
	procedure   Print(ParDis:TDisplay);override;
	procedure   CommonSetup;override;
	function    IsNumber(ParNum : TNumber):boolean;override;
	
end;

TOutputMac=class(TMacBase)
protected
	voName : longint;
	property  iName : longint read voName write voName;
	procedure CommonSetup;override;

public
	property  fName : longint read voName write voName;
	function  CreateResource(ParCre:TInstCreator):TResource;override;
	function  CreatePtrResource(ParCre : TInstCreator):TResource;override;
	function  CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;override;
	function  IsSame(ParSec:TSecBase):boolean;override;
	procedure Print(ParDIs:TDisplay);override;
end;



TCompareMac=class(TMacBase)
private
	voCompCode : TIdentCode;
	property    iCompCode : TIdentCode read voCompCode write voCompCode;
protected
	procedure   CommonSetup;override;
public
	property    fCompCode : TIdentCode read voCompCode;
	constructor Create(ParCompCode : TIdentCode ; ParSign : boolean);
	function    CreatePtrResource(ParCre : TInstCreator):TResource;override;
	function    CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;override;
	function    CreateResource(ParCre:TInstCreator):TResource;override;
	function    IsSame(ParSec:TSecBase):boolean;override;
	procedure   Print(ParDis:TDisplay);override;
end;

TResultMac =class(TMacBase)
private
	voName:Longint;
	property iName:longint read voName write voName;
public
	property  fName:longint read voname;
	function  IsSame(ParSec:TSecBase):boolean;override;
	function  CreatePtrResource(ParCre : TInstCreator):TResource;override;
	function  CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;override;
	function  CreateResource(ParCre:TInstCreator):TResource;override;
	procedure Print(ParDis:TDisplay);override;
	procedure CommonSetup;override;
end;

TByPointerMac=class(TMacBase)
private
	voPointer : TMacBase;
	property iPointer : TMacBase read voPointer write voPointer;
protected
	procedure   Commonsetup;override;

public
	property fPointer : TMacBase read voPointer;

	procedure   FreeStorage;override;
	procedure   ReserveStorage(ParList:TTLVStorageList);override;
	procedure   Print(ParDis:TDisplay);override;
	function    CreatePtrResource(ParCre : TInstCreator):TResource;override;
	function    CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;override;
	function    CreateResource(ParCre:TInstCreator):TResource;override;
	function    IsSame(ParSec:TSecBase):boolean;override;
	constructor Create(ParSize:TSize;ParSign:boolean;ParOther:TMacBase);
end;

TTLMac=class(TMacBase)
private
	voName    : cardinal;
	voStorage : TTlvStorageItem;
protected
	procedure   Commonsetup;override;

public
	property fStorage   : TTlvStorageItem read voStorage write voStorage;
	property fName	    : cardinal        read voName    write voName;
	
	function    IsSame(ParSec:TSecBase):boolean;override;
	function    CreatePtrResource(ParCre : TInstCreator):TResource;override;
	function    CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;override;
	function   CreateResource(ParCre:TInstCreator):TResource;override;
	
	procedure   Print(ParDis:TDisplay);override;
	procedure   FreeStorage;override;
	procedure   ReserveStorage(ParList:TTLVStorageList);override;
	
end;


TLabelMac=class(TMacBase)
private
	voLabelName     : TString;
	property iLabelName : TString read voLabelName write voLabelName;
public
	property fLabelName : TString read voLabelName;
	constructor Create(const  ParName:ansistring;ParSize : TSize);
	procedure   Clear;override;
	procedure   Commonsetup;override;
	procedure   Print(parDis:TDisplay);override;
	function    IsSame(PArSec:TSecBase):boolean;override;
	function    CreatePtrResource(ParCre : TInstCreator):TResource;override;
	function    CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;override;
	function   CreateResource(ParCre:TInstCreator):TResource;override;
end;

implementation

uses asminfo;

{---(TMethodPtrMac )------------------------------------------------------}
procedure   TMethodPtrMac.CommonSetup;
begin
    inherited Commonsetup;
	iIdentCode := IC_MethodPtrMac;
end;

function    TMethodPtrMac.IsSame(ParMac:TSecBase):boolean;
begin
	if ParMac.ClassType=ClassType then begin
			exit((iRoutine = TMethodPtrMac(ParMac).fRoutine) and (iObject = TMethodPtrMac(ParMac).fObject) and (iExtraOffset = TMacBase(ParMac).fExtraOffset))
	end;
end;

function    TMethodPtrMac.CreateResource(ParCre:TInstCreator):TResource;
begin
	if(fSize <> iRoutine.fSize) then begin
		writeln('Can make resource' );
		runerror(1);
	end;
	if(iExtraOffset = 0) then begin
		exit(iObject.CreateResource(ParCre));
	end else begin
        exit(iRoutine.CreateResource(ParCre));
	end;
end;

procedure   TMethodPtrMac.Print(parDis:TDisplay);
begin
	ParDis.WriteNl('METHOD PTR');
	ParDis.SetLeftMargin(4);
	ParDis.Write('OBJECT=');iObject.Print(ParDis);ParDis.Nl;
	ParDis.Write('METHOD=');iRoutine.Print(ParDis);
	ParDis.SetLEftMargin(-4);
	ParDIs.nl;
	ParDis.Write('END METHOD PTR');
end;

constructor TMethodPtrMac.create(ParObject,ParRoutine : TMacBase;ParSize : TSize);
begin
	iObject := ParObject;
	iRoutine := ParRoutine;
	inherited Create(ParSize,false);
end;

{---( TLabelMac )------------------------------------------------------}


function TLabelMac.CreatePtrResource(ParCre : TInstCreator):TResource;
var vlName : ansistring;
	vlRes  : TResource;
begin
	iLabelName.GetString(vlName);
	vlRes := TMemoryOffsetRes.Create(vlName,GetAssemblerInfo.GetSystemSize,false);
	ParCre.AddObject(vlRes);
	exit(vlRes);
end;


function   TLabelMac.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;
begin
	fatal(fat_Invalid_rec_option,'Options=By Pointer');
	exit(nil);
end;

function  TLabelMac.CreateResource(parCre:TInstCreator):TResource;
var vlName : ansistring;
	vlRes  : TResource;
begin
	iLabelName.GetString(vlName);
	vlRes := (TLabelRes.Create(vlName,fSize));
	ParCre.AddObject(vlRes);
	exit(vlRes);
end;

constructor TLabelMac.Create(const ParName : ansistring;ParSize :TSize);
begin
	inherited Create(ParSize,false);
	iLabelName := TString.Create(ParName);
end;

procedure TLabelMac.Clear;
begin
	inherited Clear;
	if iLabelName <> nil then iLabelName.Destroy;
end;

procedure TLabelMac.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_LabelMac;
end;


procedure TLabelMac.Print(ParDis:TDisplay);
begin
	ParDis.WritePst(iLabelName);
end;

function TLabelMac.IsSame(ParSec:TSecBase):boolean;
begin
	if  inherited IsSame(PArSec) then begin
		if iLabelName.IsEqual(TLabelMac(ParSec).fLabelName) then exit(true);
	end;
	exit(false);
end;

{---( TTLMac )----------------------------------------------------------}



procedure  TTLMac.ReserveStorage(ParList:TTLVStorageList);
begin
	fStorage := ParList.ReserveStorage(fName,fSize);
end;

procedure TTLMac.Print(ParDis:TDIsplay);
begin
	ParDis.print(['@LT',fname]);
	if fStorage = nil then ParDis.Write('[empty:TLvar]')
	else fStorage.Print(ParDis);
	printExtraOffset(parDis);
end;

procedure TTLmac.Commonsetup;
begin
	inherited COmmonsetup;
	iIdentCode := (IC_TLMac);
	fStorage := nil;
	fName    := 0;
end;

function  TTLMac.IsSame(ParSec:TSecBase):boolean;
begin
	IsSame := false;
	if IsSameType(ParSec) then
	IsSame :=  (fSize = TTLMAc(ParSec).fSize) and
	(fStorage.fAddress = TTLMAC(ParSec).fStorage.fAddress)
	and (fExtraOffset = TTLMac(ParSec).fExtraOffset);
end;

function   TTLmac.CreatePtrResource(ParCre : TInstCreator):TResource;
var vlRes :TResource;
begin
	vlRes := CreateResource(ParCre);
	exit(ParCre.GetOffsetOf(vlRes,GetAssemblerInfo.GetSystemSize,false));
end;

function   TTLMac.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;
begin
	exit( ParCre.GetByPtrOf(self,ParSize,ParSign));
end;

function   TTLMac.CreateResource(parCre:TInstCreator):TResource;
var vlRes  : TResource;
begin
	vlRes := ParCre.ReserveResourceByUse(self);
	if vlRes = nil then begin
		vlRes := ParCre.CreateStackVar(fStorage.fAddress,fSize,fSign);
		vlRes.SetExtraOffset(vlRes.GetExtraOffset + fExtraOffset);
	end;
	exit(vlRes);
end;


procedure TTLMac.FreeStorage;
begin
	if fStorage = nil then fatal(fat_Storage_Not_Init,'At:TlMac.FreeStorage');
	fStorage.FreeStorage;
end;

{---( TByPointerMac )---------------------------------------------------}

procedure  TByPointerMac.FreeStorage;
begin
	if iPointer <> Nil then iPointer.FreeStorage;
end;

procedure TByPointerMac.ReserveStorage(ParList:TTLVStorageList);
begin
	if iPointer <> nil then iPointer.ReserveStorage(ParList);
end;

function  TByPointermac.IsSame(ParSec:TSecBase):boolean;
var vlMac:TMacBase;
begin
	IsSame := false;
	vlMac  := TMacBase(ParSec);
	if IsSameType(vlMac) then
	IsSame :=iPointer.IsSame(TByPointerMac(vlMac).fPointer)
	and(vlMac.fSize = fSize)
	and(vlMac.fSign = fSign)
	and(fExtraOffset = TByPointerMac(vlMac).fExtraOffset);
end;


procedure TByPointerMac.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_ByPointerMac;
end;

constructor TByPointerMac.Create(ParSize:TSize;ParSign:boolean;ParOther:TMacBase);
begin
	inherited Create(ParSize,ParSign);
	iPointer := ParOther;
end;


procedure   TByPointerMac.Print(ParDis:TDisplay);
begin
	
	ParDis.Write('[');
	if(iPointer <> nil) then iPointer.Print(ParDis) else ParDis.Write('<NULL>');
	if fExtraOffset <> 0 then begin
		if fExtraOffset > 0 then ParDis.write('+');
		ParDis.WriteInt(fExtraOffset);
	end;
	ParDis.Write(']');
end;


function TByPointerMac.CreatePtrResource(ParCre : TInstCreator):TResource;
var vlRes  : TResource;
	vlRes2 : TResource;
	vlSize : TSize;
begin
	if fExtraOffset <> 0 then begin
		vlSize := GetAssemblerInfo.GetSystemSize;
		vlRes2 := ParCre.GetByPtrOf(iPointer,vlSize,false);
		vlRes2.SetExtraOffset(vlRes2.GetExtraOffset + fExtraOffset);
		vlRes := ParCre.GetOffsetOf(vlRes2,vlSize,false);
	end else begin
		vlRes := iPointer.CreateResource(ParCre);
	end;
	exit(vlRes);
end;

function TByPointerMac.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;
begin
	exit( ParCre.GetByPtrOf(self,ParSize,ParSign));
end;

function    TByPointerMac.CreateResource(parCre:TInstCreator):TResource;

var
	vlRes    : TResource;
begin
	vlRes := ParCre.ReserveResourceByUse(self);
	if vlRes = nil then begin
		vlRes := iPointer.CreateByPtrResource(fSize,fSign,ParCre);
		vlRes.SetExtraOffset(vlRes.GetExtraOffset + fExtraOffset);
	end;
	exit(vlRes);
end;

{---( TResultMac )----------------------------------------------------}


function    TResultMac.IsSame(ParSec:TSecBase):boolean;
var vlMac:TMacBase;
begin
	IsSame := false;
	vlMac := TMacBase(ParSec);
	if IsSameType(vlMac) then
	IsSame := TResultMac(vlMac).fName = iName;
end;

function TResultMac.CreatePtrResource(ParCre : TInstCreator):TResource;
var vlRes : TResource;
begin
	vlRes := CreateResource(ParCre);
	exit(ParCre.GetOffsetOf(vlRes,GetAssemblerInfo.GetSystemSize,false));
end;

function  TResultMac.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;
begin
	exit(ParCre.GetByPtrOf(self,ParSize,parSign));
end;

function    TResultMac.CreateResource(ParCre:TInstCreator):TResource;
var
	vlRes    : TResource;
begin
	vlRes := ParCre.ReserveResourceByUse(self);
	if vlRes = nil then vlRes := PArCre.ReserveRegister(fSize,fSign);
	exit(vlRes);
end;


procedure   TResultMac.CommonSetup;
begin
	inherited Commonsetup;
	iName := GetNewResNo;
	iIdentCode := IC_ResultMac;
end;

procedure   TResultMac.Print(ParDis:TDisplay);
begin
	ParDis.Print(['@R',fName]);
end;


{---( TCompareMac )-------------------------------------------------}

procedure   TCompareMac.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_CompareMac);
end;

constructor TCompareMac.Create(ParCompCode : TIdentCode;ParSign:boolean);
begin
	inherited Create(1,ParSign);
	iCompCode := ParCompCode;
end;

function  TCompareMac.CreatePtrResource(ParCre : TInstCreator):TResource;
begin
	fatal(fat_Invalid_Rec_Option,'option=pointer of');
	exit(nil);
end;

function  TCompareMAc.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;
begin
	fatal(Fat_Invalid_Rec_OPtion,'option=By pointer');
	exit(nil);
end;

function    TCompareMac.CreateResource(ParCre:TInstCreator):TResource;
var vlCmpFlagRes:TCmpFlagRes;
begin
	vlCmpFlagRes := TCmpFlagRes.Create(iCompCode);
	ParCre.AddObject(vlCmpFlagRes);
	vlCMpFlagRes.SetSign(fSign);
	exit( vlCmpFlagRes);
end;

function    TCOmpareMac.IsSame(ParSec:TSecBase):boolean;
var vlMac:TMacBase;
begin
	IsSame := false;
	vlMac  := TMacBase(ParSec);
	if IsSameType(vlMac) then
	ISSame := TCompareMac(vlMac).fCompCode = icompCode;
end;

procedure   TCompareMac.Print(ParDis:TDisplay);
var vlStr : ansistring;
begin
	case iCompCode of
	IC_Eq		: vlStr := 'Fl_Equal';
	IC_Bigger	: vlStr := 'Fl_Bigger';
	IC_BiggerEq	: vlStr := 'Fl_Bigger_Eq';
	IC_Lower	: vlStr := 'FL_Lower';
	IC_LowerEq	: vlStr := 'FL_Lower_Eq';
	IC_NotEq	: vlStr := 'FL_Not_Equal';
	else		  vlStr := '???';
end;
ParDis.Write(vlStr);
end;



{---( TOutputMac )--------------------------------------------------}

function TOutputmac.CreatePtrResource(ParCre : TInstCreator):TResource;
begin
	fatal(fat_Invalid_Rec_Option,'Option=Pointer Of');
	exit(nil);
end;

function TOutputMac.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;
begin
	exit(ParCre.GetByPtrOf(self,ParSize,ParSign));
end;

function TOutputMac.CreateResource(parCre:TInstCreator):TResource;

var vlRes:TResource;
begin
	vlRes := ParCre.ReserveResourceByUse(self);
	if vlRes = nil then begin
		vlRes:= ParCre.GetSpecialRegister([CD_FunctionReturn],fSize,fSign);
		if vlRes = nil then Fatal(Fat_Cant_Get_Func_Ret_Reg,['[Size=',fSize,',Sign=',fSign,']']);
	end;
	CreateResource := vlRes;
end;

function TOutputMac.IsSame(ParSec:TSecBase):boolean;
var vlMac:TMacBase;
begin
	vlMac  := TMacBase(ParSec);
	IsSame := IsSameType(vlMac);
	if IsSameType(ParSec) then begin
		exit(TOutputMac(vlMac).fName  = iName);
	end else begin
		exit(false);
	end;
end;

procedure TOutputMac.Print(ParDIs:TDisplay);
begin
	ParDis.Print(['@OUT[',iName,']']);
end;


procedure TOutputMac.CommonSetup;
begin
	inherited CommonSetup;
	iName      := GetNewResNo;
	iIdentCode := IC_OutputMac;
end;


{---( TNumMac )------------------------------------------------------}


function   TNumberMac.IsNumber(ParNum : TNumber):boolean;
begin
	exit(LargeCompare(ParNum, fInt)=LC_Equal);
end;

function   TNumberMac.IsSame(ParSec:TSecBase):boolean;
var vlMac:TMacBase;
begin
	IsSame := false;
	vlMac := TMacBase(ParSec);
	if IsSameType(vlMac) then
	IsSame := LargeCompare(TNumberMac(vlMac).fInt , fInt) = LC_Equal;
end;

constructor TNumberMac.Create(ParSize:TSize;ParSign:boolean;ParInt : TNumber);
begin
	inherited Create(ParSize,ParSign);
	iInt := parint;
end;


function   TNumberMac.CreatePtrResource(ParCre : TInstCreator):TResource;
begin
	fatal(fat_invalid_Rec_option,'Option=Ptr To ');
	exit(nil)
end;

function   TNumberMAc.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;
begin
	exit(ParCre.GetByPtrOf(self,ParSize,ParSign));
end;

function    TNumberMac.CreateResource(parCre:TInstCreator):TResource;
var vlRes:TResource;
	vlInt : TNUmber;
	vlOth : cardinal;
begin
	vlRes := ParCre.ReserveResourceByUse(self);
	vlInt := fInt;
	if vlRes = nil then begin
		if fExtraOffset <> 0 then begin
			LargeGetBytesAt(vlInt,fExtraOffset,fSize,vlOth);
			LoadLong(vlInt,vlOth);
		end;
		vlRes := ParCre.GetNumberRes(vlInt,fSize,fSign);
	end;
	exit(vlRes);
end;

procedure   TNumberMac.Print(ParDis:TDisplay);
var
	vlStr : ansistring;
begin
	LargeToString(fInt,vlStr);
	ParDis.Print([vlStr,'[',fExtraOffset,']']);
end;

procedure   TNumberMac.CommonSetup;
begin
	inherited COmmonSetup;
	iIdentCode := IC_NumberMac;
end;



{----( TMemOfsMac )----------------------------------------------}



procedure TMemOfsMac.FreeStorage;
begin
	if iSourceMac <> nil then iSourceMac.FreeStorage;
end;


procedure  TMemOfsMac.ReserveStorage(ParList:TTLVStorageList);
begin
	if iSourceMac<> nil then iSourceMac.ReserveStorage(ParList);
end;

constructor TMemOfsMAc.Create(ParSourceMac : TMacBase);
begin
	inherited Create(GetAssemblerInfo.GetSystemSize,false);
	iSourceMac := ParSourceMac;
end;

procedure TMemOfsMac.Print(parDis:TDisplay);
begin
	ParDis.Write('Addr(');
	if iSourceMac <> nil then iSourceMac.Print(parDis);
	ParDis.Write(')');
end;

procedure TMemOfsMac.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_MemOfsMac);
end;

function TMemOfsMac.CreateResource(parCre:TInstCreator):TResource;
var
	vlRes : TResource;
begin
	vlRes := ParCre.ReserveResourceByUse(self);
	if vlRes = nil then begin
		vlRes := iSourceMac.CreatePtrResource(ParCre);
	end;
	exit(vlRes);
end;


function TMemOfsMac.CreatePtrResource(ParCre : TInstCreator):TResource;
begin
	fatal(fat_Invalid_Rec_Option,'Option=IC_Pointer')
	;
	exit(nil);
end;

function TMemOfsMac.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator):TResource;
var vlMac : TResource;
begin
	vlMac := iSourceMac.CreateResource(ParCre);
	vlMac.SetSize(ParSize);
	vlMac.SetSign(ParSign);
	exit(vlMac);
end;

{----( TMemMac )-------------------------------------------------}


function TMemMac.IsSame(ParMac:TSecBase):boolean;
var vlMac:TMacBase;
begin
	IsSame := false;
	vlMac := TMacBase(ParMAc);
	if IsSameType(vlMac) then
	IsSame := fName.IsEqual(TMemMac(vlMac).fName) and
	(vlmac.fSize = fSize) and
	(vlMac.fSign = fSign) and
	(TMemMac(vlMac).fExtraOffset = fExtraOffset);
end;


procedure TMemMac.CommonSetup;
begin
	inherited COmmonSetup;
	iIdentCode := IC_MemMac;
end;

constructor TMemMac.Create(ParSize:TSize;ParSign:boolean;const ParName : ansistring);
begin
	inherited Create(ParSize,ParSign);
	iName := TString.Create(ParName);
end;

procedure TMemMac.fNameStr(var ParName:ansistring);
begin
	iName.GetString(ParName);
end;

procedure TMemMac.Print(parDis:TDisplay);
begin
	ParDis.WritePst(fName);
	if fExtraOffset >0  then ParDis.Write('+');
	if fExtraOffset <>0 then ParDis.Write(fExtraOffset);
end;

function TMemMac.CreatePtrResource(ParCre : TInstCreator):TResource;
var vlname : ansistring;
	vlRes  : TResource;
begin
	fNameStr(vlName);
	vlRes := TMemoryOffsetRes.Create(vlName,GetAssemblerInfo.GetSystemSize,false);
	vlRes.SetExtraOffset(fExtraOffset);
	ParCre.AddObject(vlRes);
	exit(vlRes);
end;

function TMemMac.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre : TInstCreator):TResource;
var vlRes : TResource;
begin
	vlRes := ParCre.GetByPtrOf(self,ParSize,ParSign);
	exit(vlRes);
end;

function TMemMac.CreateResource(parCre:TInstCreator):TResource;
var vlRes  : TResource;
	vlName : ansistring;
begin
	vlRes := ParCre.ReserveResourceByUse(self);
	if vlRes = nil then begin
		fNameStr(vlName);
		vlRes := TMemoryRes.Create(vlName,fSize,false);
		ParCre.AddObject(vlRes);
		vlRes.SetSize(fSize);
		vlRes.SetSign(fSign);
		vlRes.SetExtraOffset(fExtraOffset);
	end;
	exit(vlRes);
end;


destructor TMemMac.Destroy;
begin
	inherited Destroy;
	if fName <> nil then fName.Destroy;
end;

{----( TMacBase )-----------------------------------------------}

function    TMacBase.IsNumberInt(ParNum:longint):boolean;
var vlLi : TLargeNumber;
begin
	LoadInt(vlLi,ParNum);
	exit(IsNumber(vlLi));
end;

function    TMacBase.CreatePtrResource(ParCre : TInstCreator) : TResource;
var vlRes : TResource;
begin
	vlRes := TUnkRes.Create;
	ParCre.AddObject(vlRes);
	exit(vlRes);
end;

function    TMacBase.CreateByPtrResource(ParSIze : TSIze;ParSign :boolean;ParCre:TInstCreator): TResource;
var vlRes : TResource;
begin
	vlRes := TUnkRes.Create;
	ParCre.AddObject(vlRes);
	exit(vlRes);
end;

procedure   TMacBase.PrintExtraOffset(ParDIs:TDisplay);
begin
	if fExtraOffset <> 0 then begin
		ParDis.print(['[',fExtraOffset,']']);
	end;
end;

procedure   TMacBase.FreeStorage;
begin
end;


procedure   TMacBase.ReserveStorage(ParList:TTLVStorageList);
begin
end;

procedure   TMacBase.SetSize(ParSize:TSize);
begin
	iSize := ParSize;
end;

procedure   TMAcBase.SetSign(ParSign:boolean);
begin
	iSign := ParSign;
end;

function  TMacBase.IsSameType(ParMac:TSecBase):boolean;
begin
	exit(  ClassType = ParMac.ClassType);
end;

procedure TMacBase.SetExtraOffset(ParOff:TOffset);
begin
	iExtraOffset := ParOff;
end;

procedure TMacBase.AddExtraOffset(ParOff:TOffset);
begin
	iExtraOffset := iExtraOffset + ParOff;
end;


function  TMacBase.IsSame(ParMac:TSecBase):boolean;
begin
	IsSame := false;
end;


function  TMacBase.CreateInstRes(ParCre:TInstCreator):TResource;
begin
	exit( CreateResource(ParCre));
end;

function  TMacBase.CreateResource(parCre:TInstCreator):TResource;
var
	vlRes : TResource;
begin
	vlRes :=  TUnkRes.Create;
	ParCre.AddObject(vlRes);
	exit(vlRes);
end;

constructor TMacBase.Create(PArSize:TSize;ParSign:boolean);
begin
	inherited Create;
	iSize := ParSize;
	iSign := ParSign;
end;

procedure TMacBase.CommonSetup;
begin
	inherited CommonSetup;
	iExtraOffset := 0;
	iSize         := 0;
	iSign         := false;
	iIdentCOde    := IC_UnkownMac;
end;



procedure TMacBase.Print(ParDis:TDisplay);
begin
	
	if fSign then ParDis.Write('@S')
	else ParDis.Write('@U');
	ParDis.print([fSize,'.']);
end;

function TMacBase.IsNumber(ParNum : TNumber):boolean;
begin
	exit(false);
end;



{----( TMacList )-------------------------------------------}



procedure   TMacList.ReserveStorage(ParList:TTlvStorageList);
var vlCnt:cardinal;
begin
	for vlCnt := 0 to Mac_Num_Params -1  do if iParams[vlCnt] <> nil then iParams[vlCnt].ReserveStorage(ParList);
end;

procedure   TMacList.FreeStorage;
var vlCurrent : TMacBase;
	vlCnt     : cardinal;
begin
	for vlCnt := 0 to Mac_Num_Params -1 do begin
		vlCurrent := iParams[vlCnt];
		if(vlCurrent <> nil) then begin
			if vlCnt <> 0 then vlCurrent.FreeStorage;
		end;
	end;
end;



procedure TMacList.GetMetric(var ParSign:boolean;var ParSize:TSize);
var vlCUrrent : TMacBase;
	vlCnt : cardinal;
begin
	ParSize  := 0;
	ParSign  := false;
	for vlCnt := 0 to Mac_Num_params -1 do begin
		vlCurrent := iParams[vlCnt];
		if vlCurrent <> nil then begin
			if vlCurrent.fSize > ParSize then ParSize := vlCurrent.fSize;
			ParSign := ParSign or vlCurrent.fSign;
		end;
	end;
end;

procedure TMAcList.AddMac(ParNum : cardinal;ParMac:TMacBase);
begin
	
	if ParNum >= Mac_Num_params then fatal(Fat_Mac_num_to_high,'');
	iParams[ParNum] := ParMac;
end;


function TMacList.GetMacByNum(ParNum : cardinal):TMacBase;
begin
	if ParNum >= Mac_Num_params then fatal(Fat_Mac_num_to_high,'');
	exit(iParams[ParNum]);
end;

procedure TMacList.Commonsetup;
begin
	inherited Commonsetup;
	fillchar(voParams,sizeof(voParams),0);
end;



end.

