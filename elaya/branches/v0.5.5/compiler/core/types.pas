{
    Elaya, the compiler for the el;aya language
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

unit types;

interface
uses frames,largenum,varbase,strmbase,streams,compbase,linklist,display,error,elacons,stdobj,ddefinit,
elatypes,pocobj,macobj,node,formbase,progutil,asminfo,cmp_type,elacfg,simplist;
	
type
	
	TVoidType = class(TType)
	protected
		function    IsExactCompatibleSelf(ParType:TType):boolean;override;
		function    IsDirectcompatibleSelf(ParType:TType):boolean;override;
    	procedure   commonsetup;override;

	public
		constructor Create;
		procedure   PrintDefinitionBody(ParDis:TDisplay);override;
		function    IsDominant(ParOther:TType):TDomType;override;
		function    IsCompByIdentCode(ParCode : TIdentCode):boolean;override;
	end;
	
	
	TOrdinal=class(TType)
		function CanCastTo(ParTYpe : TType):boolean;override;
		function   CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;override;
	end;
	
	TCharType = class(TOrdinal)
	protected
		function    IsDirectCompatibleSelf(ParType:TType):boolean;override;
		function    isExactCompatibleSelf(ParType:TType):boolean;override;
		procedure commonsetup;override;

	public
		function IsDominant(ParOther:TType):TDomType;override;
		procedure PrintDefinitionBody(ParDis:TDisplay);override;
		function CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;override;

	end;
	
	TSecType =class(TType)
	private
		voType:TType;
	protected
		property iType : TType read voType write voType;
	public
		property    fType : TType read voType;
		constructor Create(Partype:TType;ParSize :TSize);
		function    GetSecSize : TSize;
		function    GetOrgSecType : TType;
		procedure   SetType(ParType:TType);virtual;
		function    SaveType(ParStream:TObjectStream):boolean;virtual;
		function    LoadType(ParStream:TObjectStream):boolean;virtual;
		function    SaveItem(ParStream:TObjectStream):boolean;override;
		function    LoadItem(ParStream:TObjectStream):boolean;override;
		function    DependsOn(ParType : TType) : boolean; override;
		function    GetSecondDefault : TDefaultTypeCode;
	end;
	
	
	TStringBase= class(TSecType)
	private
		voNumElements : cardinal;
		property    iNumElements : cardinal read voNumElements write voNumElements;
	protected
		function    IsExactCompatibleSelf(ParType:TType):boolean;override;
		function    IsDirectcompatibleSelf(ParType:TType):boolean;override;
	public
		function    HasExactSameProp(ParType : TType):boolean;override;
		property    fNumElements : cardinal read voNumElements;
		function    GetFirstOffset : TOffset;virtual;
		function   CalculateSize:boolean;override;
		constructor Create(ParType : TType;ParNumElements : cardinal);
		function    Can(ParCan:TCan_Types):boolean;override;
		function    IsDominant(ParType:TType):TDomType;override;
		procedure   PrintDefinitionBody(ParDis:TDisplay);override;
		function   ValidateIndex(ParValue : TValue) : TConstantValidation;virtual;
		function    SaveItem(ParStream : TObjectStream):boolean;override;
		function    LoadItem( ParStream : TObjectStream):boolean;override;
		function   CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;override;
	end;
	
	
	
	TStringType= class(TStringBase)
	private
		voHasDefaultSize : boolean;
		voFrame : TFrame;
		
		property iFrame : TFrame read voFrame write voFrame;
		
	protected
		property iHasDefaultSize : boolean read voHasDefaultSize write voHasDefaultSize;
		function    IsDirectcompatibleSelf(ParType:TType):boolean;override;
		procedure   commonsetup;override;
		procedure   Clear;override;

	public
		
		function    GetIndexType : TType;
		function    GetFirstOffset : TOffset;override;
		function    Can(ParCan : TCan_Types) : boolean;override;
		procedure   PrintDefinitionBody(ParDis:TDisplay);override;
		constructor Create(ParType : TType;ParDefaultSize:boolean;ParNumElements : cardinal;const ParLengthVarName : string;ParLengthVarType :TType);
		function    CreateBasedOn(ParCre : TCreator;ParNewSize : TSize) : TTYpe;override;
		function    GetIndexTypeMax : cardinal;
		function    IsLargeType:boolean;override;
		function    SaveItem(ParStream : TObjectStream):boolean;override;
		function    LoadItem( ParStream : TObjectStream):boolean;override;
		function    ValidateConstant(ParValue : TValue):TConstantValidation;override;
		procedure   InitDotFrame(ParCre : TSecCreator;ParNode : TNodeIdent;ParContext : TDefinition);override;
		procedure   DoneDotFrame;override;
		function    GetDescForAnonymousIdent : string;override;
	end;
	
	TAsciizType=class(TStringBase)
	protected
		procedure commonsetup;override;

	public
		function  GetFirstOffset : TOffset;    override;
		function  CalculateSize : boolean;override;
		procedure PrintDefinitionBody(ParDis:TDisplay);override;
		function  ValidateIndex(ParValue : TValue) : TConstantValidation;override;
		function   CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;override;
	END;
	
	TNumberType = class(TOrdinal)
	private
		voSign:boolean;
	protected
		property iSign:boolean read voSign write voSign;
		function    IsExactCompatibleSelf(ParTYpe:TType):boolean;override;
		procedure   commonsetup;override;

	public
		function    GetSign:boolean;override;
		function    IsDominant(ParType:TType):TDOmType;override;
		constructor Create(ParSize : TSize;ParSign:boolean);
		procedure   PrintDefinitionBody(parDis:TDisplay);override;
		function    SaveItem(ParWrite:TObjectStream):boolean;override;
		function    LoadItem(ParWrite:TObjectStream):boolean;override;
		procedure   GetRangeBySize(ParSize : TSize;ParSign:boolean;var ParMax, ParMin:TNumber);
		function    GetRangeMax : TNumber;
		function    GetRangeMin : TNumber;
		function    IsDefaultType(ParDefaultCode : TDefaultTypeCode;ParSize : TSize;ParSign : boolean):boolean;override;
		function    ValidateConstant(ParValue : TValue):TConstantValidation;override;
		function   IsMinimum(ParValue : TValue):boolean;override;
		function   IsMaximum(ParValue : TValue):boolean;override;		
	end;
	
	
	
	
	
	TArrayType=class(TSecType)
	private
		voTop  : TArrayType;
		voLo   : TArrayIndex;
		voHi   : TArrayIndex;
		voLast : boolean;
		
		property iLo   : TArrayIndex  read voLo   write voLo;
		property iHi   : TArrayIndex  read voHi   write voHi;
		property iTop  : TArrayType   read voTop  write voTop;
		property iLast : boolean      read voLast write voLast;
	protected
		function   IsDirectCompatibleSelf(PArType:TType):boolean;override;
		procedure  commonsetup;override;
		procedure  Clear;override;

	public
		property  fLo   : TArrayIndex read voLo;
		property  fHi   : TArrayIndex read voHi;
		property  fTop  : TArrayType  read voTop;
		property  fLast : boolean     read voLast write voLast;
		property  fType : TType       read voType write voType;

		function  CalculateSize : boolean;override;
		procedure  AddType(ParType : TArrayType);
		
		function   GetNumberOfDim:cardinal;
		procedure  PrintDefinitionBody(ParDis:TDisplay);override;
		function   SaveType(ParStream:TObjectStream):boolean;override;
		function   LoadType(ParStream:TObjectStream):boolean;override;
		function   SaveItem(ParStream:TObjectStream):boolean;override;
		function   LoadItem(ParStream:TObjectStream):boolean;override;
		procedure  SetTopType(ParType : TType);
		function   ValidateIndex(ParValue : TValue) : TConstantValidation;
		constructor Create(parLo,ParHi : TArrayIndex);
		function    Can(ParCan : TCan_Types) : boolean;override;
	end;
	
	
	TTypeAs  = class(TSecType)
	protected
		function    IsDirectCompatibleSelf(ParType:TType):boolean;override;
		procedure   commonsetup;override;

	public
		function    IsCompByIdentCode(ParCode : TIdentCode):boolean;override;
		constructor Create(const ParName: string;ParType : TType);
		function    IsDominant(ParType:TType):TDomType;override;
		procedure   PrintDefinitionBody(ParDis:TDisplay);override;
		function    GetBaseType:TType;
		function    GetSign : boolean;override;
		function    can(ParCan : TCan_Types):boolean;override;
		function    GetPtrByName(const ParName:string;ParOption : TSearchOptions ;var ParOwner,ParItem:TDefinition):boolean;override;
		function    GetOrgType : TType;override;
		procedure   InitDotFrame(ParCre : TSecCreator;ParNode : TNodeIdent;ParContext : TDefinition);override;
		procedure   DoneDotFrame;override;
		function    GetPtrByObject(const ParName : string;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;override;
		function	CanWriteWith(ParExact : boolean;ParType : TType):boolean;override;
		function    CreateReadNode(parCre:TCreator;ParContext : TDefinition):TFormulaNode;override;
		function CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;override;
		function   IsMinimum(ParValue : TValue):boolean;override;
		function   IsMaximum(ParValue : TValue):boolean;override;
	end;
	
	TPtrType=class(TSecType)
	private
		voConstFlag : boolean;
	protected
		property iConstFlag : boolean read voConstFlag write voConstFlag;
		function    IsExactCompatibleSelf(ParTYpe:TType):boolean;override;
		function    IsDirectCompatibleSelf(ParTYpe:TType):boolean;override;
		procedure   Commonsetup;override;

	public
		property fConstFlag : boolean read voConstFlag;
		constructor Create(ParType:TType;ParConstFlag : boolean);
		function    SaveItem(ParStream:TObjectStream):boolean;override;
		function    LoadItem(ParStream:TObjectStream):boolean;override;
		function    IsDominant(ParType:TType):TDomType;override;
		procedure   PrintDefinitionBody(ParDis:TDisplay);override;
		function    GetSizeofPtrTo : TSize;
		function   CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;override;
	end;
	
	TEnumType= class(TNumberType)
	protected
		function    IsDirectCompatibleSelf(Partype:TType):boolean;override;
		procedure   commonsetup;override;

	public
		procedure   SetSign(ParSign : boolean);
		function    IsDominant(ParType:TType):TDomType;override;
		constructor Create;
	end;
	
	TForwardList=class(TSMTextList)
		procedure AddBind(const ParName:string;ParBind:TPtrType);
		procedure Bind(ParCreat:TCreator);
	end;
	
	TForwardBindList=class(TSMList)
	public
		procedure AddBind(ParPtr:TPtrType);
		procedure Bind(ParCre : TCreator;ParDef:TType);
	end;
	
	
	TForwardBindItem=class(TSMListItem)
	private
		voBind : TPtrType;
		property iBind : TPtrType read voBind write voBind;
	public
		procedure   Bind(ParCre : TCreator;ParObj:TType);
		constructor Create(ParPtr:TPtrType);
	end;
	
	TForwardItem=class(TSMTextItem)
	private
		voBindList:TForwardBindList;
		property iBindList : TForwardBindList read voBindList write voBindList;
		procedure   commonsetup;override;
		procedure   Clear;override;

	public
		constructor Create(const parName:string;ParPtr : TPtrType);
		procedure   Bind(ParCre : TCreator);
		procedure   AddBind(ParPtr:TPtrType);
	end;
	
	TVarStructType=class(TType)
	private
		voFrame : TFrame;
		property iFrame : TFrame read voFrame write voFrame;
	protected
		function  IsDirectcompatibleSelf(ParType:TType):boolean;override;
	public
		property fFrame : TFrame read voFrame;
		
		function Can(ParCan:TCan_Types):boolean;override;
		function CreateVar(ParCre:TCreator;const ParName:string;ParType:TDefinition):TDefinition;override;
		procedure Commonsetup;override;
		procedure Clear;override;
		function  SaveItem(parStream:TObjectStream):boolean;override;
		function  LoadItem(ParStream:TObjectStream):boolean;override;
		procedure InitDotFrame(ParCre : TSecCreator;ParNode : TNodeIdent;ParContext :TDefinition);override;
		procedure DoneDotFrame;override;
	end;
	
	TUnionType =class(TVarStructType)
		function  AddIdent(ParItem:TDefinition):TErrorType;override;
		procedure CommonSetup;override;
		procedure Print(ParDis:TDisplay);override;
	end;
	
	TRecordType=class(TVarStructType)
		function  AddIdent(ParItem:TDefinition):TErrorTYpe;override;
		procedure CommonSetup;override;
		procedure Print(ParDis:TDisplay);override;
	end;


	TBooleanType=class(TType)
	protected
		procedure CommonSetup;override;
		function  GetSign : boolean;override;
	end;

	
implementation

uses NdCreat,procs,classes;
{---( TType )------------------------------------------------------}

procedure TBooleanType.CommonSetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_BooleanType;
end;

function  TBooleanType.GetSign : boolean;
begin
	exit(true);
end;


{---( TOrderinal )-------------------------------------------------}

function TOrdinal.CanCastTo(ParTYpe : TType):boolean;
begin
	if ParType = nil then exit(False);
	if ParType.fSize > fSize then begin
		exit(ParType.IsLike(TOrdinal));
	end;
	exit(true);
end;

function TOrdinal.CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;
var
	vlNUm : TNUmber;
	vlMac : TMacBase;
begin
	if ParOption = MCO_Result then begin
		ParValue.ConvertToNumber(vlNum);
		vlMac := ParCre.CreateNumberMac(0,LargeIsNeg(vlNum),vlNum);
    end else begin
		vlMac := inherited CreateConstantMac(ParOption,parCre,ParValue);
	end;
	exit(vlMac);
end;


{---( TVarStructType )----------------------------------------------}

procedure TVarStructTYpe.DoneDotFrame;
begin
	fFrame.PopAddressing(self);
end;

procedure  TVarStructTYpe.InitDotFrame(ParCre :TSecCreator;ParNode : TNodeIdent;ParContext :TDefinition);
begin
	fFrame.AddAddressing(self,self,ParNode,false);
end;

function  TVarStructType.SaveItem(parStream:TObjectStream):boolean;
begin
	iFrame.SetModule(fModule);
	if inherited SaveItem(ParStream) then exit(true);
	if iFrame.SaveItem(ParStream) then exit(true);
	exit(false);
end;

function  TVarStructType.LoadItem(ParStream:TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	iFrame.Destroy;
	if CreateObject(ParStream,voFrame) <> STS_OK then exit(true);
	exit(false);
end;

procedure TVarStructType.Commonsetup;
begin
	inherited Commonsetup;
	iFrame := TFrame.Create(true);
end;

procedure TVarStructType.Clear;
begin
	inherited Clear;
	if iFrame <> nil then iFrame.Destroy;
end;


function TVarStructtype.Can(ParCan:TCan_Types):boolean;
begin
	Parcan := ParCan - [CAN_Dot];
	Can := inherited Can(ParCan);
end;


function TVarStructType.CreateVar(ParCre:TCreator;const ParName:string;ParType:TDefinition):TDefinition;
var vlVar :TFrameVariable;
begin
	vlVar := TFrameVariable.Create(ParName,iFrame,iFrame.fFrameSize,TType(ParType));
	exit(vlVar);
end;

function  TVarStructType.IsDirectcompatibleSelf(ParType:TType):boolean;
begin
	if ParType <> nil then begin
		exit(self=ParType.GetOrgType);
	end else begin
		exit(false);
	end;
end;

{----( TUnionType )-----------------------------------------------------}

function  TUnionType.AddIdent(ParItem:TDefinition):TErrorType;
var vlSize:TSize;
begin
	if not(ParItem is TFrameVariable) then AddIdent := ERR_Not_A_Var
	else begin
		vlSize := TVariable(ParItem).GetSize;
		if vlSize >fSize then SetSize(vlSize);
	end;
	exit(inherited AddIdent(ParItem));
end;

procedure TUnionType.CommonSetup;
begin
	inherited Commonsetup;
	iIdentCode:= (IC_Union);
end;

procedure TUnionType.Print(ParDis:TDisplay);
begin
	inherited Print(PArDis);
	ParDis.Writenl('<Union>');
	PrintParts(ParDis);
	ParDis.setLeftMargin(-3);
	ParDis.Write('</union>');
end;




{------( TRecordType )--------------------------------------------------}



procedure TRecordType.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_Record;
end;



function TRecordType.AddIdent(ParItem:TDefinition):TErrorType;
var vlSize : TSize;
	vlAll  : TSize;
	vlRes  : TSize;
begin
	if not(ParItem is TFrameVariable) then begin
		AddIdent := Err_Not_A_Var;
	end else  begin
		vlSize := TVariable(PArItem).GetSize;
		vlAll  := GetConfig.fAlign;
		vlRes := vlSize mod vlAll;
		if vlres <> 0 then vlSize := vlSIze + vlAll - vlRes;
		iFrame.GetNewOffset(vlSize);
		SetSize(iFrame.fFrameSize);
	end;
	exit(inherited AddIdent(ParItem));
end;


procedure TRecordType.Print(ParDis:TDisplay);
begin
	inherited Print(PArDis);
	ParDis.Writenl('<record>');
	PrintParts(ParDis);
	ParDis.Write('<record>');
	
end;


{----( TForwardBindList )--------------------------------------------------}


procedure TForwardBindList.AddBind(ParPtr : TPtrType);
begin
	InsertAtTop(TForwardBindItem.Create(ParPtr));
end;

procedure TForwardBindList.Bind(ParCre : TCreator;ParDef:TType);
var vlCurrent:TForwardBindItem;
begin
	vlCurrent := TForwardBindItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.Bind(ParCre,ParDef);
		vlCurrent := TForwardBindItem(vlCurrent.fNxt);
	end;
end;


{----( TForwardBindItem )--------------------------------------------------}

procedure TForwardBindItem.bind(ParCre :TCreator;ParObj:TType);
var vlName : string;
begin
	if ParObj.DependsOn(iBind) then begin
		iBind.GetTextStr(vlName);
		TNDCreator(ParCre).ErrorText(Err_Circular_Type_dep,vlName);
	end else begin
		iBind.SetType(ParObj);
	end;
end;

constructor TForwardBindItem.Create(parPtr : TPtrType);
begin
	inherited Create;
	iBind := (parPtr);
end;

{----( TForwardList )-------------------------------------------------------}

procedure TForwardList.Bind(ParCreat:TCreator);
var vlCurrent : TForwardItem;
begin
	vlCurrent := TForwardItem(fStart);
	while vlcurrent <> nil do begin
		vlCurrent.Bind(ParCreat);
		vlCurrent := TForwardItem(vlCurrent.fNxt);
	end;
	DeleteAll;
end;

procedure TForwardList.AddBind(const ParName:string;ParBind : TPtrType);
var vlBind:TForwardItem;
begin
	vlBind := TForwardItem(GetPTrByName(nil,ParName));
	if vlBind  = nil then begin
		vlBind :=TForwardItem.Create(ParName,ParBind);
		InsertAtTop(vlBind);
	end else vlBind.AddBind(ParBind);
end;

{----( TForwardItem )------------------------------------------------------}

procedure  TForwardItem.Bind(ParCre : TCreator);
var  vlName : string;
	vlDef  : TType;
begin
	GetTextStr(vlname);
	vlDef := TType(TNDCreator(PArCre).GetPtr(vlName));
	if vlDef <> nil then begin
		iBindList.Bind(ParCre,vlDef);
	end else begin
		TNDCreator(ParCre).ErrorText(Err_forwarded_not_found,vlName);
	end;
end;

procedure TForwardItem.AddBind(ParPtr : TPtrType);
begin
	iBindList.AddBind(ParPtr);
end;

procedure TForwardItem.commonsetup;
begin
	inherited Commonsetup;
	iBindList := TForwardBindList.Create;
end;

constructor TForwardItem.Create(const ParName:string;ParPtr: TPtrType);
begin
	inherited Create(ParName);
	AddBind(ParPtr);
end;

procedure TForwardItem.clear;
begin
	inherited clear;
	if iBindList <> nil then iBindList.Destroy;
end;

{---( TVoidType )-----------------------------------------------------}

constructor TVoidType.Create;
begin
	inherited Create(0);
end;

procedure   TVoidType.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_VoidType);
end;

function    TVoidType.IsDominant(ParOther:TType):TDomType;
begin
	IsDominant := DOM_Not;
end;

function    TVoidType.IsExactCompatibleSelf(ParType:TType):boolean;
begin
	IsExactCompatibleSelf := true;
end;

function    TVoidType.IsDirectcompatibleSelf(ParType:TType):boolean;
begin
	IsDirectCompatibleSelf := true;
end;

function    TVoidType.IsCompByIdentCode(ParCode : TIDENTCODE):boolean;
begin
	IsCompByIdentCode := true;
end;


procedure TVoidType.PrintDefinitionBody(ParDis:TDisplay);
begin
	ParDis.Write('<typedef>voidtype</typedef>');
end;



{---(TArrayType)-----------------------------------------------------}


function  TArrayType.Can(ParCan : TCan_Types) : boolean;
begin
	exit(inherited Can(ParCan - [Can_Index]));
end;

function  TArrayType.ValidateIndex(ParValue : TValue) : TConstantValidation;
var vlInt : TNumber;
begin
	if ParValue <> nil then begin
		if ParValue.GetNumber(vlInt) then exit(Val_Invalid);
		if (LargeCompare(vlInt,iLo)=LC_Lower) or (LargeCompare(vlInt,iHi)=LC_Bigger) then exit(val_Out_Of_range);{TODO There is a range check in Largenum unit}
	end;
	exit(val_Ok);
end;

procedure TArrayType.SetTopType(ParType : TType);
begin
	fTop.fType := ParType;
	fTop.fLast := true;
end;


function  TArrayType.SaveType(ParStream:TObjectStream):boolean;
begin
	if ParStream.WriteBoolean(iLast) then exit;
	if iLast then begin
		if parStream.WritePi(iType) then exit(true);
	end else begin
		if fType.SaveItem(ParStream) then exit(true);
	end;
	exit(false);
end;

function  TArrayType.LoadType(ParStream:TObjectStream):boolean;
begin
	if ParStream.ReadBoolean(voLast) then exit;
	if iLast then begin
		if ParStream.ReadPi(voType) then exit(true);
	end else begin
		if CreateObject(ParStream,voType)<>STS_OK then exit(true);
	end;
	exit(False);
end;

function TArrayType.SaveItem(ParStream:TObjectStream):boolean;
begin
	SaveItem := true;
	if inherited SaveITem(parStream)    then exit;
	if ParStream.WriteNumber(iLo)      then exit;
	if ParStream.WriteNumber(iHi)      then exit;
	SaveItem := false;
end;

function TArrayType.LoadItem(ParStream:TObjectStream):boolean;
var vlCurrent : TArrayType;
begin
	LoadItem := true;
	if inherited LoadItem(ParStream) then exit;
	if ParStream.ReadNumber(voLo)    then exit;
	if ParStream.ReadNumber(voHi)    then exit;
	vlCurrent := TArrayType(iType);
	while (vlCurrent <> nil) and (vlCurrent.IsLike(TArrayType)) and (not(iLast)) do vlCurrent := TArrayTYpe(vlCurrent.fType);
	if vlCurrent.IsLike(TArrayType) then iTop := vlCurrent;
	LoadItem := false;
end;

function TArrayType.IsDirectCompatibleSelf(ParType:TType):boolean;
begin
	if ParType <> nil then begin
		exit(self= ParType.GetOrgType);
	end else begin
		exit(false);
	end;
end;

procedure TArrayType.clear;
begin
	inherited Clear;
	if (not iLast) and (iType <> nil) then iType.Destroy;
end;

function TArrayType.CalculateSize : boolean;
var vlSize: TSize;
	vlTmp : TLargeNUmber;
begin
	vlSize := 0;
	
	if fType <> nil then begin
		if fType.CalculateSize then exit(true);
		vlTmp := iHi;
		if LargeSub(vlTmp,iLo)then exit(true);
		if LargeAddInt(vlTmp,1) then exit(true);
		if LargeMulLong(vlTmp,fType.fSize) then exit(true);
		vlSize := LargeToCardinal(vlTmp);
	end;
	SetSize(vlSize);
	exit(false);
end;


procedure TArrayType.CommonSetup;
begin
	inherited COmmonSetup;
	iIdentcode := (IC_ArrayType);
	iTop       := self;
end;

procedure TArrayType.AddType(ParType : TArrayType);
begin
	iTop.fType := (ParType);
	iTop       := ParType;
end;


constructor TArrayType.Create(parLo,ParHi : TArrayIndex);
begin
	iLo := ParLo;
	iHi := ParHi;
	inherited Create(nil,0);
end;

function  TArrayType.GetNumberOfDim:cardinal;
var
	vlCNt  : Cardinal;
begin
	vlCnt  := 1;
	if (iType <> niL) and (iType.IsLike(TArrayType)) then inc(vlCnt,TArrayType(iType).GetNumberOfDim);
	exit(vlCnt);
end;


procedure TArrayType.PrintDefinitionBody(parDis:TDisplay);
begin
	ParDis.WriteNl('<arraydef>');
	ParDis.WriteNl('<low>');
	ParDis.Write(iLo);
	ParDis.WriteNl('</low><high>');
	ParDis.Write(iHi);
	ParDis.Write('</high>');
	ParDis.WriteNl('<type>');
	if fType <> nil then begin
		if iLast then fType.PrintName(ParDis)
		else ftype.Print(ParDis);
	end;
	ParDis.WriteNl('</type>');
	ParDis.WriteNl('</arraydef>');
end;

{----(TPtrType)-----------------------------------------------}


function  TPtrType.CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;
var
	vlMac : TMacBase;
	vlOfs : TMemOfsMac;
begin
	vlMac := nil;
	if fType <> nil then begin
		if ParOption = MCO_Result then begin
			vlOfs := TMemOfsMac.Create;
			vlOfs.SetSourceMac(fType.CreateConstantMac(MCO_Result,ParCre,ParValue));
			ParCre.AddObject(vlOfs);
			vlMac := vlOfs;
		end else begin
			vlMac := inherited CreateConstantMac(ParOption,ParCre,ParValue);
		end;
	end;
	exit(vlmac);
end;


function TPtrType.GetSizeofPtrTo : TSize;
begin
	if fType <> nil then begin
		exit(fType.fSize);
	end else begin
		exit(0);
	end;
end;

function TPtrType.IsExactCompatibleSelf(ParTYpe:TType):boolean;
var vlType : TType;
begin
	if ParType =nil then exit(false);
	vlType := ParType.GetOrgTYpe;
	if vlType = nil then exit(false);
	if((vlType is TRoutineType) or (vlType is TClassType)) then begin
		exit(GetSecondDefault = DT_Void);
	end;
	exit(Inherited IsExactCompatibleSelf(ParType));
end;

function TPtrType.IsDirectCompatibleSelf(ParTYpe:TType):boolean;
var vlType   : TType;
	vlMyType : TType;
begin
	IsDirectcompatibleSelf := false;
	if ParType = nil then exit;
	vlType    := Partype.GetOrgType;
	if vlType = nil then exit;
	vlMyType  := fType;
	if vlMyType = nil then exit;
	vlMyType  := vlMyType.GetOrgType;
	if vlMyType = nil then exit;
	if ((vlType is TRoutineType) or (vlType is TClassType)) and (vlMyType is TVoidType)  then exit(true);
	if (inherited IsDirectCompatibleSelf(vlType)) then begin
		IsDirectCOmpatibleSelf := vlMyType.IsExactComp(TPtrType(vlType).fType);
	end;
end;


constructor TPtrType.Create(ParType:TType;ParConstFlag : boolean);
begin
	inherited Create(ParType,GetAssemblerInfo.GetSystemSize);
	iConstFlag := ParConstFlag;
end;


function    TPtrType.ISDominant(ParType:TType):TDomType;
begin
	case parType.fIdentCode of
	IC_PtrType : IsDominant := DOM_Not;
	IC_Number  : IsDOminant := DOM_Yes;
	else	     IsDominant := DOM_Unkown;
end;
end;

procedure TPtrType.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := ic_PtrType;
end;

function    TPtrType.LoadItem(ParStream:TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadBoolean(voConstFlag) then exit(true);
	exit(false);
end;

function   TPtrType.SaveItem(ParStream:TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WriteBoolean(iConstFlag) then exit(true);
	exit(false);
end;


procedure TPtrType.PrintDefinitionBody(ParDis:TDisplay);
begin
	ParDis.Write('<ptrdef>');
	ParDis.Write('<constflag>');
	if iConstFlag then ParDis.Write('yes');
	ParDis.Write('</constflag><refersto>');
	PrintIdentName(ParDis,fType);
	ParDis.Write('</refersto>');
	ParDis.Write('</ptrdef>');
end;



{----(TSecType)-----------------------------------------------}


function  TSecType.GetSecondDefault : TDefaultTypeCode;
var vlType :TType;
begin
	vlType := GetOrgSecType;
	if(vlType = nil) then exit(dt_nothing);
	exit(vlType.fDefault);
end;


function TSecType.GetOrgSecType : TType;
begin
	if fTYpe = nil then exit(nil);
	exit(fType.GetOrgType);
end;

function TSecType.DependsOn(ParType : TType) : boolean;
var vlType : TSecType;
begin
	vlType := self;
	while (vlType <> nil) do begin
		if (vlType =ParType) then exit(true);
		if not (vlType is TSecType) then break;
		vlType := TSecType(vlType.fType);
	end;
	exit(false);
end;

function  TSecType.GetSecSize : TSize;
begin
	if fType <> nil then exit(fType.fSize)
	else exit(0);
end;

constructor TSecType.Create(Partype:TType;ParSize : TSize);
begin
	inherited Create(ParSize);
	iType := ParType;
end;

procedure TSecType.SetType(ParType:TType);
begin
	iType := ParType;
end;

function  TSecType.SaveType(ParStream:TObjectStream):boolean;
begin
	exit(ParStream.WritePi(iType));
end;

function  TSecType.LoadType(ParStream:TObjectStream):boolean;
begin
	exit(ParStream.ReadPi(voType));
end;

function TSecType.SaveItem(ParStream:TObjectStream):boolean;
begin
	SaveItem := true;
	if inherited SaveItem(ParStream) then exit;
	if SaveType(ParStream) then exit;
	SaveItem := false;
end;

function TSecType.LoadItem(ParStream:TObjectStream):boolean;
begin
	LoadItem := true;
	if inherited LoadItem(ParStream) then exit;
	if LoadType(ParStream) then exit;
	LoadItem := false;
end;


{----( TCharType )------------------------------------------------}


function TCharType.CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;
var
	vlNUm : TNUmber;
	vlStr : string;
	vlMac : TMacBase;
begin
	if ParOption = MCO_Result then begin
		ParValue.GetAsString(vlStr);
		LoadLong(vlNum,byte(vlStr[1]));
		vlMac := ParCre.CreateNumberMac(0,LargeIsNeg(vlNum),vlNum);
    end else begin
		vlMac := inherited CreateConstantMac(ParOption,parCre,ParValue);
	end;
	exit(vlMac);
end;

procedure TCharType.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_CharType);
end;

function  TCharType.IsDominant(ParOther:TType):TDomType;
begin
	IsDominant := DOM_Unkown;
	case parOther.fIdentCode of
	ic_StringType : IsDominant := DOM_Not;
	IC_CharType   : IsDominant := Dom_Yes;
end;
end;

function  TCharType.IsDirectCompatibleSelf(ParType:TType):boolean;
begin
	if ParType <> nil then begin
		exit( inherited IsDirectCompatibleSelf(ParType) and
		(ParType.fSize = fSize)
		);
	end else begin
		exit(false);
	end;
end;

function  TCharType.isExactCompatibleSelf(ParType:TType):boolean;
begin
	if ParType <> nil then begin
		exit( inherited IsExactCompatibleSelf(ParType) and
		(ParType.fSize = fSize)
		);
	end else begin
		exit(false);
	end;
end;

procedure TCharType.PrintDefinitionBody(ParDis:TDisplay);
begin
	ParDis.Print(['<chardef><Size>',fSize,'<size></chardef>']);
end;

{----( String Base )----------------------------------------------}

function  TStringBase.CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;
var
	vlStr : string;
	vlMac : TMacBase;
	vlMac2: TMemOfsMac;
	vlLab : longint;
	vlName: string;
begin
	vlMac := nil;
	ParValue.GetString(vlStr);
	vlLab := ParCre.AddStringConstant(vlStr);
	case ParOption of
	MCO_Result:begin
		str(vlLab,vlName);vlName := '.L'+vlName;
		vlMac := TMemMac.Create(fSize,false);
		TMemMac(vlMac).SetName(vlName);
		ParCre.AddObject(vlMac);
    end;
	MCO_ValuePointer,MCO_ObjectPointer:begin
		vlMac2 := TMemOfsMac.Create;
		vlMac2.SetSourceMac(CreateConstantMac(MCO_Result,ParCre,ParValue));
		ParCre.AddObject(vlMac2);
		vlMac := vlMac2;
	end else begin
		vlMac := inherited CreateConstantMac(ParOption,ParCre,ParValue);
	end;
	end;
	exit(vlMac);
end;

function  TStringBase.HasExactSameProp(ParType : TType):boolean;
begin
	if ParType <> nil then begin
		if IsExactComp(ParType) then begin
			if iNumElements = TStringBase(ParType).fNumElements then exit(true);
		end;
	end;
	exit(false);
end;


function  TStringBase.ValidateIndex(ParValue : TValue) : TConstantValidation;
var vlInt : TNumber;
begin
	if ParValue<> nil then begin
		if ParValue.GetNumber(vlInt) then exit(val_Invalid);
		if (LargeCompareLong(vlInt , 1)=LC_Lower) or (LargeCompareLong(vLInt ,iNumElements)=LC_Bigger) then exit(val_Out_Of_range);{TODO there is a range check in largenum unit}
	end;
	exit(val_Ok);
end;

function    TStringBase.GetFirstOffset : TOffset;
begin
	exit(1);
end;

function TStringBase.CalculateSize:boolean;
begin
	if fType <> nil then begin
		iSize := fType.fSize * iNumElements + GetFirstOffset;
	end;
	exit(false);
end;

constructor TStringBase.Create(ParType : TType;ParNumElements : cardinal);
begin
	inherited Create(ParType,0);
	iNumElements := ParNumElements;
	CalculateSize;
end;

function  TStringBase.Can(ParCan:TCan_Types):boolean;
begin
	ParCan := ParCan -[CAN_Index];
	Can := inherited Can(ParCan);
end;


function  TStringBase.IsDirectcompatibleSelf(ParType:TType):boolean;
var vlType:TType;
	vlTypeElement1 : Ttype;
	vlTypeElement2 : TType;
begin
	if (ParType <> nil) then begin
		vlTYpe := TType(ParType.GetOrgType);
		if(vlType <> nil) and (IsCompByIdentCode(vlType.fIdentCode)) then begin
			vlTypeElement1 := TSecType(vlType).fType;
			vlTypeElement2 := fType;
			if vlTypeElement2 <> nil then exit(vlTypeElement2.IsDirectComp(vlTypeElement1));
		end;
	end;
	exit(false);
end;

function  TStringBase.IsExactCompatibleSelf(ParType:TType):boolean;
begin
	IsExactCOmpatibleSelf := inherited IsDirectCompatibleSelf(PArType);
end;

{Hack: Remove IC_CharType Not nec. because of operator use}

function TStringBase.IsDominant(ParType:TType):TDomType;
var vlType:TType;
begin
	vlTYpe := TType(ParType.GetOrgType);
	if vlType.fIdentCode = IC_CharType then IsDOminant := DOM_Yes
	else if vlType.fIdentCode = fIdentCode then IsDominant := DOM_Not
	else IsDominant := DOM_Unkown;
end;

procedure TStringBase.PrintDefinitionBody(ParDis:TDisplay);
begin
	ParDis.Write(' of ');
	PrintIdentName(ParDis,fType);
	ParDis.Print([' Size=',iNumElements]);
end;


function  TStringBase.SaveItem(ParStream:TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WriteLong(iNumElements) then exit(true);
	exit(false);
end;

function  TStringBase.LoadItem(ParStream:TObjectStream):boolean;
var
	vlNumElements : cardinal;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadLong(vlNumElements) then exit(true);
	iNumElements := vlNumElements;
	exit(false);
end;


{----( TStringType)-----------------------------------------------}

function   TStringType.GetDescForAnonymousIdent : string;
var
	vLName : string;
begin
	if iType <> nil then begin
		vlName := iType.GetErrorName;
	end else begin
		vlName := '<unkown type>';
	end;
	vlName := 'String size '+IntToStr(iNumElements) + ' of type '+vlName;
	exit(vlName);
end;




procedure TStringType.Clear;
begin
	inherited Clear;
	if iFrame <> nil then iFrame.Destroy;
end;

procedure TStringType.DoneDotFrame;
begin
	iFrame.PopAddressing(self);
end;

procedure  TStringType.InitDotFrame(ParCre : TSecCreator;ParNode : TNodeIdent;ParContext : TDefinition);
var
	vlMac : TMacbase;
begin
	vlMac := ParNode.CreateMac(MCO_ValuePointer,ParCre);
	iFrame.AddAddressing(self,self,vlMac,false);
end;

function TStringType.ValidateConstant(ParValue : TValue):TConstantValidation;
var vlTYpe: TType;
begin
	vlType := fType;
	if vlType= nil then exit(Val_Ok);
	if (vlType.IsLike(TCharType)) and (ParValue <> nil) then begin
		if not((ParValue is TString)) then exit(Val_Invalid);
		if iNumElements < TString(ParValue).flength then exit(Val_Out_Of_Range);
	end;
	exit(Val_Ok);
end;

function TStringTYpe.LoadItem( ParStream : TObjectStream):boolean;
var
	vlHasDefaultSize : boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if  ParStream.ReadBoolean(vlHasDefaultSize) then exit(true);
	iFrame.Destroy;
	if CreateObject(ParStream,voFrame) <> STS_OK then exit(true);
	iHasDefaultSIze := vlHasDefaultSize;
	exit(False);
end;

function TStringType.SaveItem(ParStream : TObjectStream):boolean;
begin
	iFrame.SetModule(fModule);
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WriteBoolean(iHasDefaultSize) then exit(true);
	if iFrame.SaveItem(ParStream) then exit(true);
	exit(False);
end;

function    TStringType.IsDirectcompatibleSelf(ParType:TType):boolean;
var vlType1,vlType2 : TType;
begin
	if inherited IsDirectCompatibleSelf(ParType) then begin
		vlType1 := GetIndexType;
		if vlType1 <> nil then vlType1 := TType(vlType1.GetOrgType);
		vlTYpe2 := TStringType(ParType).GetIndexType;
		if vlType2 <> nil then vlType2 := TType(vlType2.GetOrgType);
		if (vlType1 <> nil) and (vlType2 <> nil) then begin
			if vlType1.IsExactComp(vlType2) then exit(true);
		end;
	end;
	exit(false);
end;

constructor TStringType.Create(ParType : TType;ParDefaultSize:boolean;ParNumElements : cardinal;const ParLengthVarName : string;ParLengthVarType :TType);
var
	vlIndex : TFrameVariable;
begin
	inherited Create(ParType,ParNumElements);
	vlIndex := TFrameVariable.Create(ParLengthVarName,iFrame,0,ParLengthVarType);
	vlIndex.fDefAccess := AF_Public;
	AddIdent(vlIndex);
	iSize := iSize + vlIndex.GetSize;
	iHasDefaultSize := ParDefaultSize;
	{Hack: Because index var is unkown firstoffset=0
	and size of index must be added. Should be
	AddIdent -> Inc(Size)
	}
end;

function   TStringType.CreateBasedOn(ParCre : TCreator;ParNewSize : TSize) : TTYpe;
var vlVar     : TVariable;
	vlName    : string;
	vlType    : TType;
begin
	if not(iHasDefaultSize) and (iParts = nil) then begin
		TNDCreator(ParCre).SemError(Err_Cant_Base_Type_On_This );
		exit(nil);
	end;
	vlVar := TVariable(iParts.fStart);
	if (vLVar <> nil) then begin
		vlVar.GetTextStr(vlName);
		vlType := vlVar.fType;
		if ParNewSize > GetIndexTypeMax then TNDCreator(ParCre).SemError(Err_Num_Out_Of_Range);
		exit(TStringType.Create(iType,false,ParNewSize,vlName,vlType));
	end else begin
		TNDCreator(ParCre).SemError(Err_Cant_Base_Type_On_This);
		exit(nil);
	end;
end;

function    TStringType.IsLargeType:boolean;
begin
	exit(true);
end;



function    TStringType.GetIndexTypeMax : cardinal;
var
	vlType :TType;
begin
	vlType := GetIndexType;
	if (vlType <> nil) and (vlType.IsLike( TNumberType)) then begin
		exit(LargeToCardinal(TNumberTYpe(vlType).GetRangeMax));
	end else begin
		exit(0);
	end;
end;

function    TStringType.GetIndexType : TType;
var vlVar : TVariable;
begin
	if iParts  = nil then exit(nil);
	vlVar := TVariable(iParts.fStart);
	if (vlVar <> nil) and (vlVar is TVariable) then begin
		exit(vlVar.fType);
	end else begin
		exit(nil);
	end;
end;

function    TStringType.GetFirstOffset : TOffset;
var vlType : TType;
begin
	vlType := GetIndexType;
	if (vlType <> nil) then begin
		exit(vlType.fSize);
	end else begin
		exit(0);
	end;
end;


function  TStringTYpe.Can(ParCan : TCan_Types) : boolean;
begin
	ParCan := ParCan - [Can_Dot];
	exit(inherited Can(ParCan));
end;

procedure TStringType.commonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (Ic_StringType);
	iFrame     := TFrame.Create(true);
end;

procedure TStringType.PrintDefinitionBody(ParDis:TDisplay);
begin
	ParDis.Write('String');
	inherited PrintDefinitionBody(ParDis);
end;



{----( TAsciiz )---------------------------------------------------}
function  TAsciizType.CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;
var
	vlMac : TMacBase;
begin
	vlMac := inherited CreateConstantMac(ParOption,ParCre,ParValue);
	if ParOption = MCO_Result then vlMac.AddExtraOffset(1);
	exit(vlMac);
end;


function  TAsciizType.ValidateIndex(ParValue : TValue) : TConstantValidation;
var vlNum : TNumber;
begin
	if (iNumElements=0) and (ParValue <> nil) then begin
		ParValue.GetNumber(vlNum);
		if LargeCompareLong(vlNum,0)=LC_Bigger then exit(Val_Ok);
		exit(Val_Out_Of_Range);
end;
exit(inherited ValidateIndex(ParValue));
end;

function  TAsciizType.GetFirstOffset : TOffset;
begin
	exit(0);
end;

procedure TAsciizType.commonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (Ic_AsciizType);
end;

procedure TAsciizType.PrintDefinitionBody(ParDis:TDisplay);
begin
	ParDis.Write('Asciiz');
	inherited PrintDefinitionBody(ParDis);
end;

function TAsciizType.CalculateSize : boolean;
begin
	if fType <> nil then begin
		iSize := fType.fSize * (iNumElements + 1);
	end;
	exit(false);
end;



{----( TNumberType )-------------------------------------------------}

function   TNumberType.IsMinimum(ParValue : TValue):boolean;
var
	vlNum : TNumber;
begin
	if ParValue = nil then exit(false);
	if ParValue.GetNumber(vlNum) then exit(false);
	exit(LargeCompare(GetRangeMin,vlNum) <> LC_Bigger);
end;

function   TNumberType.IsMaximum(ParValue : TValue):boolean;
var
	vlNum : TNumber;
begin
	if ParValue = nil then exit(false);
	if ParValue.GetNumber(vlNum) then exit(false);
	exit(LargeCompare(GetRangeMax,vlNum) <> LC_Lower);
end;

function  TNumberType.ValidateConstant(ParValue : TValue):TConstantValidation;
var
	vlInt : TNUmber;
begin
	if ParValue <>nil then begin
		if ParValue.GetNumber(vlInt) then exit(Val_Invalid);
		if (LargeCompare(vlInt, GetRangeMin)=LC_Lower) or (LargeCompare(vlInt, GetRangeMax)=LC_Bigger) then exit(Val_Out_Of_Range);
end;
exit(val_Ok);
end;

function  TNumberType.IsDefaultType(ParDefaultCode : TDefaultTypeCode;ParSize : TSize;ParSign : boolean):boolean;
begin
	exit((fDefault  = ParDefaultCode) and (iSign = ParSign) and  ((ParSize = size_DontCare) or (fSize >= ParSize)))
end;

function TNumberType.IsExactCompatibleSelf(PArType:TType):boolean;
begin
	if inherited IsExactCompatibleSelf(ParType) then begin
		exit( GetSign = (ParType.GetSign));
	end;
	exit(false);
end;

function TNumberType.GetSign:boolean;
begin
	exit(iSign);
end;


constructor TNumberType.Create(ParSize : TSize;ParSign:boolean);
begin
	inherited Create(ParSize);
	iSign := ParSign;
end;

procedure TNumberType.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (ic_Number);
end;

function TNumberType.IsDominant(ParType:TType):TDOmType;
begin
	IsDominant := DOM_Unkown;
	if IsSameIdentCode(ParType) then begin
		IsDominant := DOM_Not;
		if (fSize > ParType.fSize)
		and (fSize = ParType.fSize)
		and (GetSign or not(TNumberType(ParType).GetSign)) then IsDominant := DOM_Yes;
	end;
end;


function TNumberType.SaveItem(ParWrite:TObjectStream):boolean;
begin
	SaveItem := true;
	if inherited SaveItem(ParWrite) then exit;
	if ParWrite.WriteBoolean(iSign)  then exit;
	SaveItem := false;
end;


function TNumberType.LoadItem(ParWrite:TObjectStream):boolean;
var vlSIgn:boolean;
begin
	LoadItem := true;
	if inherited LoadItem(ParWrite) then exit;
	if ParWrite.ReadBoolean(vlSign) then exit;
	iSign := vlSign;
	LoadItem := false;
end;

procedure TNumberType.PrintDefinitionBody(parDis:TDisplay);
begin
	ParDis.Print(['<numberdef><size>',fSize,'</size><signed>']);
	if GetSign then ParDis.Write('yes');
	ParDis.WriteNl('</signed></numberdef>');
end;


procedure TNumberType.GetRangeBySize(ParSize : TSize;ParSign:boolean;var ParMax, ParMin:TNumber);
var
	vlNum : TNumber;
begin
	LoadLong(ParMAx, 0);
	LoadLong(ParMin, 0);
	case ParSize of
		1 : ParMax := MAX_Byte;
		2 : ParMax := Max_Word;
		4 : ParMax := Max_Cardinal;
	end;
	if ParSign then begin
		LoadLong(vlNum,2);
		LargeDiv(ParMax,vlNum);
		ParMin := ParMax;
		LargeAddLong(ParMin,1);
		LargeNeg(ParMIn);
	end;
end;

function  TNumberType.GetRangeMax : TNumber;
var vlMax : TNumber;
	vlMin : TNumber;
begin
	GetRangeBySize(fSize,iSign,vlMax,vlMin);
	exit(vlMax);
end;

function  TNumberType.GetRangeMin : TNumber;
var vlMax : TNumber;
	vlMin : TNumber;
begin
	GetRangeBySize(fSize,iSign,vlMax,vlMin);
	exit(vlMin);
end;

{-----( TTypeAs )----------------------------------------------------}


function TTypeAs.IsMinimum(ParValue : TValue):boolean;
begin
	if fType <> nil then begin
		exit(fType.IsMinimum(ParValue));
	end;
	exit(false);
end;

function TTypeAs.IsMaximum(ParValue : TValue):boolean;
begin
	if fType <> nil then begin
		exit(fType.IsMaximum(ParValue));
	end;
	exit(false);
end;


function TTypeAs.CreateConstantMac(ParOption : TMacCreateOption;ParCre : TSecCreator;ParValue : TValue):TMacBase;
begin
	if fType <> nil then begin
		exit(fType.CreateConstantMac(PArOption,ParCre,ParValue));
	end else begin
		exit(nil);
	end;
end;

function  TTypeAs.CreateReadNode(parCre:TCreator;ParContext : TDefinition):TFormulaNode;
begin
	if fType <> nil then begin
		exit(fType.CreateReadNode(ParCre,ParContext));
	end else begin
		exit(nil);
	end;
end;

function  TTypeAs.CanWriteWith(ParExact : boolean;ParType : TType):boolean;
begin
	if fType <> nil then begin
		exit(fType.CanWriteWith(ParExact,ParType));
	end else begin
		exit(False);
	end;
end;


function  TTypeAs.GetPtrByName(const ParName:string;ParOption :TSearchOptions;var ParOwner,ParItem:TDefinition):boolean;
begin
	if fType <> nil then begin
		exit(fType.GetPtrByName(ParName,ParOption,ParOwner,ParItem));
	end else begin
		exit(false);
	end;
end;


function  TTypeAs.GetPtrByObject(const ParName : string;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;
begin
	if fType <> nil then begin
		exit(fType.GetPtrByObject(ParName,ParObject,ParOption,parOwner,ParResult));
	end else begin
		exit(OFS_Different);
	end;
end;

procedure   TTypeAs.InitDotFrame(ParCre : TSecCreator;ParNode : TNodeIdent;ParContext : TDefinition);
begin
	if fType <> nil then begin
		fType.InitDotFrame(ParCre,ParNode,ParContext);
	end;
end;

procedure   TTypeAs.DoneDotFrame;
begin
	if fTYpe <> nil then begin
		fType.DoneDotFrame;
	end;
end;


function TTypeAs.can(ParCan : TCan_Types):boolean;
begin
	if fType <> nil then begin
		exit(fType.Can(ParCan));
	end else begin
		exit(false);
	end;
end;

function TTypeAs.GetSign : boolean;
begin
	if fType <> nil then begin
		exit(fType.GetSign);
	end else begin
		exit(false);
	end;
end;


constructor TTypeAs.Create(const ParName:String;ParType :TTYpe);
var vlSize : TSize;
begin
	vlSize := 0;
	if ParType <> nil then vlSize := ParType.fSize;
	inherited Create(ParType,vlSize);
	SetText(ParName);
end;



function TTypeAs.IsCompByIdentCode(ParCode : TIdentCode):boolean;
var vlType : TType;
begin
	vlType := GetBaseType;
	if vlType <> nil then begin
		exit(GetBaseType.IsCompByIDentCode(ParCode));
	end else begin
		exit(false);
	end;
end;


function TTypeAs.IsDirectCompatibleSelf(ParType:TType):boolean;
var vlType1,vlType2:TType;
begin
	if ParType = nil then exit(false);
	vlType1 := GetBaseType;
	if vlType1 = nil then exit(false);
	vlType2 := TType(ParType.GetOrgType);
	exit(vlType1.IsDirectCompatibleSelf(vlType2));
end;

function TTypeAs.GetOrgType : TType;
begin
	exit(GetBaseType);
end;

procedure   TTypeAs.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (ic_TypeAs);
end;

function TTypeAs.IsDominant(ParType:TType):TDomType;
var vlBaseType:TType;
begin
	vlBaseType := GetBaseType;
	IsDominant := DOM_Not;
	if not Partype.IsSameIdentCode(vlBaseType) then IsDominant := DOM_Unkown;
end;


function  TTypeAs.GetBaseType:TType;
var vlType:TType;
begin
	
	vlType := fType;
	while (vlType <> nil) and (vlType.fIdentCode = ic_typeAs) do begin
		vlType := TTypeAs(vlType).fType;
	end;
	GetBaseType := vlType;
end;


procedure TTypeAs.PrintDefinitionBody(ParDis:TDisplay);
begin
	PrintIdentName(ParDis,GetBaseType);
end;



{-------( TEnumType )--------------------------------------------------}


procedure TEnumType.SetSign(ParSign : boolean);
begin
	iSign := ParSign;
end;

function TEnumType.IsDirectCompatibleSelf(ParType:TType):boolean;
var vLType:TType;
begin
	IsDirectCompatibleSelf := false;
	if ParType = nil then exit;
	vlType := TType(ParType.GetOrgType);
	IsDirectCompatibleSelf := self = vlType;
end;

function TEnumType.IsDominant(ParType:TType):TDomType;
begin
	IsDominant := DOM_Not;
	if not isDirectComp(ParType) then IsDominant := DOM_Unkown;
end;

procedure TEnumType.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_EnumType;
end;

constructor TEnumType.Create;
begin
	inherited Create(0,false);
end;


end.
