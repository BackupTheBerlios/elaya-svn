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

unit stdobj;
interface
uses  strings,largenum,progutil;

const
	VT_Nothing = 1;
	VT_Pointer = 2;
	VT_Integer = 3;
	VT_String  = 4;
	VT_Char    = 5;
	VT_Boolean = 6;
	
type
	TValueType=longint;
	TCalculationStatus=(CS_Ok,CS_Invalid_Operation,CS_Out_Of_Range);
type
TBRoot=class
protected
	procedure 	Clear;virtual;
	procedure 	CommonSetup;virtual;

public
	constructor create;
	destructor	destroy;override;
end;

TRoot=class(TBRoot)
	{$ifdef malloc}
	class function NewInstance : tobject;override;
	procedure FreeInstance;override;
	{$endif}
end;


TValue=class(TRoot)
private
	voType : cardinal;
protected
	property iType : cardinal read voType write voType;
	procedure   CommonSetup;override;

public
	property fType : cardinal read voType;
	
	function    Add(ParVal:TValue):TCalculationStatus;virtual;
	function    Mul(ParVal:TValue):TCalculationStatus;virtual;
	function    ShiftLeft(ParVal:TValue):TCalculationStatus;virtual;
	function    ShiftRight(ParVal:TValue):TCalculationStatus;virtual;
	function    NotVal:TCalculationStatus;virtual;
	function    AndVal(ParVal : TValue):TCalculationStatus;virtual;
	function    OrVal(ParVal : TValue):TCalculationStatus;virtual;
	function    XorVal(ParVal : TValue) : TCalculationStatus;virtual;
	function    ModVal(ParVal : TValue) : TCalculationStatus;virtual;
	function    Neg:TCalculationStatus;virtual;
	function    Sub(ParVal:TValue):TCalculationStatus;virtual;
	function    DivVal(ParVal:TValue):TCalculationStatus;virtual;
	function    Clone:TValue;virtual;
	procedure   GetString(var ParStr:string);virtual;
	function    GetLongint(var ParInt:Longint):boolean;virtual;
	function    GetBool(var  ParBool : boolean):boolean;virtual;
	function    IsEqual(ParValue : TValue):boolean; virtual;
	function    GetPointer(var ParPtr : cardinal):boolean;virtual;
	procedure   GetAsString(var ParStr : string);virtual;
	function    GetAsNumber(var ParNum : TLargeNumber):boolean;virtual;
	function    GetNumber(var ParVal : TLargeNumber):boolean;virtual;
	function    ConvertToNumber(var ParNumber : TLargeNumber):boolean;virtual;

end;

TStringBaseValue=class(TValue)
public
	function GetLength : cardinal;virtual;
end;

TCharValue=class(TStringBaseValue)
private
	voChar : char;
	property iChar : Char read voChar write voChar;
protected

	procedure   Commonsetup;override;

public
	property fChar : Char read voChar;
	function GetLength : cardinal;override;
	constructor Create(ParChar : char);
	procedure   GetString(var ParStr : string);override;
	function    IsEqual(ParValue : TValue):boolean;override;
	function    ConvertToNumber(var ParNumber : TLargeNumber):boolean;override;
	function    Clone : TCharValue;override;
	function    GetAsNumber(var ParNum : TLargeNumber):boolean;override;
end;


TBoolean=class(TValue)
private
	voBool : boolean;
	property iBool      : boolean  read voBool      write voBool;
protected
	procedure Commonsetup;override;
public

	constructor Create(ParBool:boolean);
	procedure  SetBool(ParBool : boolean);
	function  GetBool(var  ParBool : boolean):boolean;override;
	function  NotVal:TCalculationStatus;override;
	function  AndVal(ParVal : TValue):TCalculationStatus;override;
	function  OrVal(ParVal : TValue):TCalculationStatus;override;
	function  Clone : TValue ;override;
	function  IsEqual(ParValue : TValue):boolean; override;
	procedure GetString(Var ParStr:string); override;
	function    GetAsNumber(var ParNum : TLargeNumber):boolean;override;
end;

TPointer=class(TValue)
private
	voPtr:cardinal;
	property iPtr : cardinal read voPtr write voPtr;
protected
	procedure   Commonsetup;override;
public
	function    Add(Parval:TValue):TCalculationStatus;override;
	procedure   GetString(var ParStr:string);override;
	function    GetLongint(var ParInt:Longint):boolean;override;
	procedure   SetPointer(ParInt:cardinal);
	function    Clone:TValue;override;
	function    GetPointer(var ParPtr:cardinal):boolean; override;
	function    IsEqual(ParValue : TValue):boolean; override;
	function    GetAsNumber(var ParNum : TLargeNumber):boolean;override;
end;

TLongint=class(TValue)
private
	voLongint : TLargeNumber;
protected
	procedure   CommonSetup;override;
public
	property fLOngint: TLargeNumber read voLongint;
	constructor create(const Parint:TLargeNumber);
	constructor Create(ParInt : int64);
	function    Add(ParVal:TValue):TCalculationStatus;override;
	function    Mul(ParVal:TValue):TCalculationStatus;override;
	function    ShiftLeft(ParVal:TValue):TCalculationStatus;override;
	function    ShiftRight(ParVal:TValue):TCalculationStatus;override;
	function    Neg:TCalculationStatus;override;
	function    AndVal(ParVal : TValue):TCalculationStatus;override;
	function    OrVal(ParVal  : TValue):TCalculationStatus;override;
	function    XorVal(ParVal : TValue):TCalculationStatus;override;
	function    DivVal(ParVal : TValue):TCalculationStatus;override;
	function    ModVal(ParVal : TValue):TCalculationStatus;override;
	procedure   GetString(var ParStr:string);override;
	procedure   SetLongint(ParInt:Longint);
	function    GetLongint(var ParInt:Longint):boolean;override;
	function    Clone:TValue;override;
	function    Sub(ParVal:TValue):TCalculationStatus;override;
	function    IsEqual(ParValue : TValue):boolean;override;
	function    GetNumber(var ParVal : TLargeNumber):boolean;override;
	function    ConvertToNumber(var ParNumber : TLargeNUmber):boolean;override;
	function    GetAsNumber(var ParNum : TLargeNumber):boolean;override;
    function    NotVal : TCalculationStatus;override;
end;






TString=class(TStringBaseValue)
private
	voText:pchar;
	voLength : cardinal;
	property iText : pchar read voText write voText;
	property iLength : cardinal read voLength write voLength;
protected
	procedure  CommonSetup;override;
	procedure  clear;override;

public
	property fText : pchar read voText;
	property fLength : cardinal read voLength;
	function GetLength : cardinal;override;

	function    Add(ParVal:TValue):TCalculationStatus;override;
	function    CharAt(ParPos: cardinal):char;
	function    NewString:TString;
	procedure   AppendStr(const ParString:string);
	procedure   GetString(var ParStr:string);override;
	constructor Create(const ParStr:TString);
	constructor Create(const ParStr:string);
	function    IsEqualStr(const ParStr:String):boolean;
	function    IsEqual(ParWith:TValue):boolean;  override;
	function    Clone:TValue;override;
	procedure   ToUpper;
end;


var
vgInits,vgDones:Longint;
vgsInits,vgsDones:longint;

function int_malloc(ParSize : longint):pointer;
function int_free(ParPtr :  pointer;ParSIze :longint):longint;


implementation
{$ifdef MEMLEAK}
uses memleak;
{$endif}


{---( TRoot )---------------------------------------------------}

{$ifdef malloc}
function CMalloc(ParSize : longint):pointer;cdecl;external 'libc.so' name 'malloc';
function CFree(ParPtr: pointer):longint;cdecl;external 'libc.so' name 'free';
{$endif}

function int_malloc(ParSize : longint):pointer;
{$ifndef malloc}
var
	vlPtr : pointer;
{$endif}
begin
	{$ifdef mem}
	exit(mem_reserve(ParSize));
	{$else}
	{$ifdef malloc}
	exit(CMalloc(ParSize));
	{$else}
	GetMem(vlPtr,ParSize);
	exit(vlPtr);
	{$endif}
	{$endif}
end;

function int_free(ParPtr :  pointer;ParSIze :longint):longint;
begin
	{$ifdef mem}
	mem_free(ParPtr);
	exit(0)
	{$else}
	{$ifdef malloc}
	exit(CFree(ParPtr));
	{$else}
	freemem(ParPtr,ParSize);
	exit(0);
	{$endif}
	{$endif}
end;


{$ifdef malloc}




function TRoot.NewInstance : tobject;
var
	vlPtr : pointer;
begin
	{$ifdef memleak}
	IncInits(className);
	{$endif}
	vlPtr := int_Malloc(InstanceSize);
	if(vlPtr <> nil) then InitInstance(vlPtr);
	exit(TObject(vlPtr));
end;

procedure TRoot.FreeInstance;
begin
	{$ifdef memleak}
	IncDones(classname);
	{$endif}
	CleanupInstance;
	int_free(pointer(self),InstanceSize);
end;

{$endif}

constructor TBRoot.Create;
begin
	inherited create;
	commonsetup;
	inc(vgInits);
end;

procedure TBRoot.CommoNSetup;
begin
end;



procedure TBRoot.Clear;
begin
end;


destructor TBRoot.destroy;
begin
	inherited Destroy;
	clear;
	inc(vgDones);
end;

{--( TStringBaseValue )---------------------------------------}

function TStringBaseValue.GetLength : cardinal;
begin
	exit(0);
end;

{--( TChar )---------------------------------------------------}



function TCharValue.GetLength : cardinal;
begin
	exit(1);
end;

function  TCharValue.GetAsNumber(var ParNum : TLargeNumber):boolean;
begin
	LoadInt(ParNum,byte(iChar));
	exit(false);
end;

function TCharValue.Clone : TCharValue;
begin
	exit(TCharValue.Create(iChar));
end;

function TCharValue.ConvertToNumber(var ParNumber : TLargeNUmber):boolean;
begin
	LoadLong(ParNumber,byte(iChar));
	exit(false);
end;


constructor TCharValue.Create(ParChar : char);
begin
	inherited Create;
	iChar := ParChar;
end;

procedure TCharValue.Commonsetup;
begin
	inherited Commonsetup;
	iType := VT_Char;
end;

procedure   TCharValue.GetString(var ParStr : string);
begin
	ParStr := iChar;
end;

function    TCharValue.IsEqual(ParValue : TValue):boolean;
var vlStr : string;
begin
	if (ParValue is TString) or (ParValue is TCharValue) then begin
		ParValue.GetString(vlStr);
		exit(iChar=vlStr);
	end else begin
		exit(false);
	end;
end;


{---( TBoolean )-----------------------------------------------}

function  TBoolean.GetAsNumber(var ParNum : TLargeNumber):boolean;
begin
	if iBool then begin
		LoadInt(ParNum,-1);
	end else begin
		LoadInt(ParNum,0);
	end;
	exit(false);
end;


procedure TBoolean.Commonsetup;
begin
	inherited Commonsetup;
	iType      := VT_Boolean;
end;

procedure TBoolean.GetString(Var ParStr:string);
begin
	if iBool then begin
		ParStr := 'TRUE'
	end else begin
		ParStr := 'FALSE';
	end;
end;

constructor TBoolean.Create(ParBool:boolean);
begin
	inherited Create;
	iBool := ParBool;
end;

function TBoolean.IsEqual(ParValue : TValue):boolean;
var vlBool : boolean;
begin
	if ParValue.GetBool(vlBool) then exit(true);
	exit(vlBool = iBool);
end;

function  TBoolean.clone : TValue;
begin
	exit(TBoolean.Create(iBool));
end;

procedure TBoolean.SetBool(ParBool : boolean);
begin
	iBool := ParBool;
end;

function TBoolean.GetBool(var  ParBool : boolean):boolean;
begin
	Parbool := iBool;
	exit(False);
end;

function TBoolean.NotVal:TCalculationStatus;
begin
	iBool := not(iBool);
	exit(CS_Ok);
end;

function TBoolean.AndVal(ParVal : TValue):TCalculationStatus;
var vlBool : boolean;
begin
	if ParVal.GetBool(vlBool) then exit(CS_Invalid_Operation);
	iBool := iBool and vlBool;
	exit(CS_Ok);
end;

function TBoolean.OrVal(ParVal : TValue):TCalculationStatus;
var vlBool : boolean;
begin
	if ParVal.GetBool(vlBool) then exit(CS_Invalid_Operation);
	iBool := iBool or vlBool;
	exit(CS_Ok);
end;


{-----( TValue )--------------------------------------------}


function   TValue.GetAsNumber(var ParNum : TLargeNumber):boolean;
begin
	LoadInt(ParNum,0);
	exit(true);
end;

function TValue.ConvertToNumber(var ParNumber : TLargeNumber):boolean;
begin
	exit(true);
end;


function TValue.GetNumber(var ParVal : TLargeNumber):boolean;
begin
	LoadInt(ParVal,0);
	exit(true);
end;

procedure TValue.GetAsString(var ParStr : string);
begin
	GetString(ParStr);
end;

function TValue.GetPointer(var ParPtr : cardinal):boolean;
begin
	exit(true);
end;

function TValue.IsEqual(ParValue : TValue):boolean;
begin
	exit(true);
end;

function TValue.GetBool(var  ParBool : boolean):boolean;
begin
	exit(true);
end;

function  TValue.NotVal:TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;

function  TValue.XorVal(ParVal : TValue) : TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;

function TValue.ModVal(ParVal : TValue) : TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;


function TValue.AndVal(ParVal : TValue):TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;

function Tvalue.OrVal(ParVal : TValue):TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;

function TValue.Clone:TValue;
begin
	Clone := nil;
end;


function TValue.DivVal(ParVal:TValue):TCalculationStatus;
begin
	exit(CS_Invalid_Operation)
end;

procedure   TValue.CommonSetup;
begin
	iType := VT_Nothing;
	inherited  CommonSetup;
end;


function TValue.sub(ParVal:TValue):TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;


procedure TValue.GetString(var ParStr:String);
begin
	EmptyString(ParStr);
end;


function TValue.GetLongint(var ParInt:Longint):boolean;
begin
	GetLongint := true;
	ParInt := 0;
end;

function    TValue.Add(ParVal:TValue):TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;

function    TValue.Mul(ParVal:TValue):TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;

function    TValue.Neg:TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;

function    TValue.ShiftLeft(ParVal:TValue):TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;

function    TValue.ShiftRight(ParVal:TValue):TCalculationStatus;
begin
	exit(CS_Invalid_Operation);
end;



{-----( TPointer )----------------------------------------------}

function TPointer.GetAsNumber(var ParNum : TLargeNumber):boolean;
begin
	LoadLong(ParNum,iPtr);
	exit(false);
end;

function TPointer.IsEqual(ParValue : TValue):boolean;
var vlPtr : cardinal;
begin
	if ParValue.GetPointer(vlPtr) then exit(true);
	exit(iPtr = vlPtr);
end;

function TPointer.GetPointer(var ParPtr : cardinal):boolean;
begin
	ParPtr := iPtr;
	exit(false);
end;

procedure  TPointer.Commonsetup;
begin
	inherited COmmonsetup;
	iType :=VT_Pointer;
end;


function  TPointer.Clone:TValue;
var vlPTr:TPointer;
begin
	vlPtr := TPointer.Create;
	vlPtr.SetPointer(iPtr);
	Clone :=vlPTr;
end;



function   TPointer.Add(Parval : TValue):TCalculationStatus;
var vlI:longint;
begin
	if ParVal.GetLongint(vLi) then exit(CS_Invalid_Operation);
	inc(voPtr,vLi);
	exit(CS_OK);
end;


procedure   TPointer.GetString(var ParStr:string);
var vlI : longint;
begin
	GetLongint(vLi);
	str(vLi,ParStr);
end;

function    TPointer.GetLongint(var ParInt:Longint):boolean;
begin
	exit(true);
end;


procedure   TPointer.SetPointer(ParInt:cardinal);
begin
	voPtr := ParInt;
end;


{-----( TLongInt )------------------------------------------}

function  TLongint.GetAsNumber(var ParNum : TLargeNumber):boolean;
begin
	ParNum := voLongint;
	exit(false);
end;


constructor TLongint.Create(ParInt : int64);
begin
	
	inherited Create;
	LoadLong(voLongint,ParInt);
end;


function TLongint.ConvertToNumber(var ParNumber : TLargeNumber):boolean;
begin
	ParNumber := voLongint;
	exit(false);
end;


function TLongint.GetNumber(var ParVal :TLargeNumber):boolean;
begin
	ParVal := voLongint;
	exit(false);
end;




function TLongint.IsEqual(ParValue : TValue):boolean;
begin
	if not(ParValue is TLongint) then exit(false);
	exit(LargeCompare(voLongint,TLongint(ParValue).voLongint) = LC_Equal);
end;

function  TLongint.NotVal : TCalculationStatus;
begin
	LargeNot(voLongint);
	exit(CS_Ok);
end;

function    TLongint.AndVal(ParVal : TValue) : TCalculationStatus;
begin
	if not(ParVal is TLongint) then exit(CS_Invalid_Operation);
	LargeAnd(voLongint,TLongint(ParVal).voLongint);
	exit(CS_Ok);
end;

function TLongint.OrVal(ParVal :TValue) : TCalculationStatus;
begin
	if not(ParVal is TLongint) then exit(CS_Invalid_Operation);
	LargeOr(voLongint,TLongint(ParVal).voLongint);
	exit(CS_Ok);
end;


function    TLongint.XorVal(ParVal : TValue) : TCalculationStatus;
begin
	if not(ParVal is TLongint) then exit(CS_Invalid_Operation);
	LargeXor(voLongint,TLongint(ParVal).voLongint);
	exit(Cs_OK);
end;


function    TLongint.ModVal(ParVal : TValue) : TCalculationStatus;
begin
	if not(ParVal is TLOngint) then exit(CS_Invalid_Operation);
	LargeMod(voLongint,TLongint(ParVal).voLongint);
	exit(CS_OK);
end;


function    TLongint.ShiftLeft(ParVal:TValue):TCalculationStatus;
begin
	if  not(ParVal is TLongint) then exit(CS_Invalid_Operation);
	LargeShl(voLongint,TLongint(ParVal).voLongint);
	exit(CS_OK);
end;

function    TLongint.ShiftRight(ParVal:TValue):TCalculationStatus;
begin
	if not(ParVal is TLongint) then exit(CS_Invalid_Operation);
	LargeShr(voLongint,TLongint(parVal).voLongint);
	exit(CS_Ok);
end;

procedure TLongint.SetLongint(ParInt:Longint);
begin
	LoadInt(voLOngint,ParInt);
end;

function    TLongint.Clone:TValue;
begin
	exit(TLongint.create(voLongint));
end;

function TLongint.Sub(ParVal:TValue):TCalculationStatus;
begin
	if not(ParVal is TLongint) then exit(CS_Invalid_Operation);
	if LargeSub(voLongint,TLongint(ParVal).voLongint) then exit(CS_Out_Of_Range);
exit(CS_Ok);
end;


procedure   TLongint.CommonSetup;
begin
	inherited COmmonSetup;
	iType := VT_Integer;
	
end;

constructor TLongint.create(const Parint : TLargeNumber);
begin
	inherited create;
	voLongint := ParInt;
end;

function    TLongint.Add(ParVal:TValue):TCalculationStatus;
begin
	if not(ParVal is TLongint) then exit(CS_Invalid_Operation);
	if LargeAdd(voLongint,TLongint(ParVal).voLongint) then exit(CS_Out_Of_Range);
exit(CS_Ok);
end;

function    TLongint.Mul(ParVal:TValue):TCalculationStatus;
begin
	if not(ParVal is TLongint) then exit(CS_Invalid_Operation);
	if LargeMul(voLongint,TLongInt(ParVal).voLongint) then exit(CS_Out_Of_Range);
exit(CS_Ok);
end;


function    TLongint.Neg:TCalculationStatus;
begin
	if LargeNeg(voLongint) then exit(CS_Out_Of_Range);
exit(CS_Ok);
end;

function   TLongint.DivVal(ParVal:TValue):TCalculationStatus;
begin
	if not(ParVal is TLongint) then exit(CS_Invalid_Operation);
	if LargeCompareint(TLongint(ParVal).voLongint,0)=LC_Equal then exit(CS_Invalid_Operation);
	LargeDiv(voLongint,TLongint(PArVal).voLongint);
	exit(CS_OK);
end;

procedure   TLongint.GetString(var ParStr:string);
begin
	LargeToString(voLongint,ParStr);
end;

function    TLongint.GetLongint(var ParInt:Longint):boolean;
begin
	ParInt := voLongint.vrNUmber;
	if voLongint.vrSign then ParInt := -ParInt;
	exit(false);
end;



{----( TString )--------------------------------------------}


function TString.GetLength : cardinal;
begin
	exit(fLength);
end;

procedure TString.ToUpper;
begin
	StrUpper(voText);
end;

function  TString.Clone:TValue;
begin
	exit(NewString);
end;


procedure TString.CommonSetup;
begin
	inherited commonsetup;
	iType := VT_String;
	iText := nil;
end;

function  TString.Add(ParVal:TValue):TCalculationStatus;
var
	vlText2 : pchar;
	vlLength: cardinal;
begin
	if (ParVal = nil) or not(ParVal is TString) then exit(CS_Invalid_Operation);
	vlLength := fLength + TString(ParVal).fLength;
	vlText2 := int_Malloc(vlLength+1);
	StrCopy(vlText2,iText);
	StrCat(vlText2,TString(ParVal).fText);
	int_free(voText,fLength+1);
	iText := vlText2;
	iLength := vlLength;
	exit(CS_Ok);
end;

constructor TString.create(const ParStr:string);
begin
	inherited create;
	iLength := Length(ParStr);
	iText := int_Malloc(voLength + 1);
	StrPCopy(voText,ParStr);
end;

constructor TString.Create(const ParStr : TString);
begin
	inherited Create;
	iLength := ParStr.fLength;
	iText := int_Malloc(voLength + 1);
	strcopy(voText,ParStr.fText);
end;

procedure TString.GetString(var ParStr:string);
var
	vlLength : cardinal;
begin
	vlLength := fLength;
	if(vlLength > 255) then vlLength := 255;
	SetLength(ParStr, vlLength);
	move(voText^,ParStr[1],vlLength);
end;

function TString.IsEqual(ParWith:TValue):boolean;
var
	vlP1 :pchar;
	vlP2 : pchar;
begin
	if(ParWith = nil) or not(ParWith is TString) then exit(false);
	vlP1 := voText;
	vlP2 := TString(ParWith).fText;
	while (vlP1^ <> #0) and (vlP2^ <> #0) and (vlP1^ = vlP2^) do begin
		inc(vLp1);
		inc(vlP2);
	end;
	exit(vlP1^ = vlP2^);
end;


function TString.IsEqualStr(const ParStr:String):boolean;
var
	vlP1 :pchar;
	vlP2 : pchar;
	vlLength : cardinal;
begin
	vlLength := length(ParStr);
	if(vlLength <> iLength) then exit(false);
	vlP1 := voText;
	vlP2 := @ParStr[1];
	while (vlLength > 0) and (vlP1^ = vlP2^) do begin
		inc(vLp1);
		inc(vlP2);
		dec(vlLength);
	end;
	exit(vlLength = 0);
end;


function  TString.CharAt(ParPos : cardinal):char;
begin
	CharAt := voText[ParPos];
end;


procedure TString.AppendStr(const ParString:string);
var
	vlText2 : pchar;
	vlLength: cardinal;
begin
	vlLength := fLength + length(ParString) ;
	vlText2 := int_Malloc(vlLength+1);
	StrCopy(vlText2,iText);
	StrLCat(vlText2,@ParString[1],length(ParString));
	vlText2[vlLength] := char(0);
	int_free(voText,fLength+1);
	iText := vlText2;
	iLength := vlLength;
end;



function  TString.NewString:TString;
begin
	exit(TString.Create(self));
end;


procedure TString.Clear;
begin
	inherited clear;
	if(voText <> nil) then int_free(voText,iLength+1);
end;


begin
	vgInits := 0;
	vgDones := 0;
	vgsInits := 0;
	vgsDones := 0;
end.
