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
unit asmdata;
interface
uses asmdisp,i386cons,asminfo,linklist,progutil,elaTypes,elacons,display,stdobj;
type
	
	TDataDef=class(TRoot)
		procedure Print(ParDis:TAsmDisplay);virtual;
	end;
	
	
	TLabelDataDef=class(TDataDef)
	private
		voLabel:longint;
		property iLabel : longint read voLabel write voLabel;
	public
		property fLabel : longint read voLabel;
		constructor Create(ParLabel:Longint);
		procedure   Print(ParDis:TAsmDisplay);override;
	end;
	
	
	
	TNumberDataDef=class(TDataDef)
	private
		voNumber:longint;
	public
		procedure SetNumber(ParNumber:Longint);
		function  GetNumber:longint;
		constructor Create(ParNumber:Longint);
		procedure Print(ParDis:TAsmDisplay);override;
	end;
	
	TTextDataDef=class(TDataDef)
	private
		voText:TString;
	protected
		procedure   commonsetup;override;

	public
		function    GetName:TString;
		procedure   SetName(const ParName:string);
		constructor Create(const ParName:string);
		destructor  destroy;override;
		procedure   Print(ParDis:TAsmDisplay);override;
	end;
	
	
	
	
	
	TAssemDef=class(TListITem)
	private
		voType   : TDatType;
		voPublic : boolean;
		property iType   : TDatType read voType write voType;
	protected
		property iPublic : boolean  read voPublic write voPublic;
	public
		property fType   : TDatType read voType;
		property fPublic : boolean  read voPublic;

		procedure Print(ParDis:TAsmDisplay);virtual;
		procedure GetDefName(var ParName:string);virtual;
		constructor Create(ParType : TDatType);
		procedure commonsetup;override;
	end;
	
	
	TAddressDef=class(TAssemDef)
	private
		voAddress : TString;
		property iAddress : TString read voAddress write voAddress;
	public
		constructor Create(ParType : TDatType;const ParAddress : string);
		procedure   Clear; override;
		procedure   Print(ParDis : TAsmDisplay);override;
	end;
	
	
	TOpperAssemDef=class(TAssemdef)
	private
		voOpper:TDataDef;
	public
		constructor Create(ParType : TDatType;ParOpper:TDataDef);
		procedure   commonsetup;override;
		procedure   SetOperand(ParOpper:TDataDef);
		function    GetOperand:TDataDef;
		destructor  destroy;override;
		procedure   Print(parDIs:TAsmDisplay);override;
	end;
	
	

	TalignDef=class(TAssemDef)
	private
		voalign : TSize;
	public
		constructor Create(ParType : TDatType;ParAlign : TSize);
		function  Getalign : TSize;
		procedure Setalign(Paralign : TSize);
		procedure Print(ParDis:TAsmDisplay);override;
	end;
	
	TExternalCode=class(TOpperAssemDef)
	private
		voLabel:TString;
		property iLabel : TString read voLabel write voLabel;
	public
		property fLabel : TString read voLabel;
		procedure Clear;override;
		constructor Create(Partype : TDatType;const ParLabel:string;ParOpper:TDataDef;ParPublic:boolean);
		procedure   Print(ParDis:TAsmDisplay);override;
	end;
	
	TGenLongDef=class(TOpperAssemDef)
		procedure GetDefName(var ParName : string);override;
	end;
	
	TLongDef = class(TOpperAssemDef)
		constructor Create(parType : TDatType;ParNumber:Longint);
		procedure   GetDefName(var ParName:String);override;
	end;
	
	TShortDef = class(TOpperAssemDef)
		constructor Create(parType : TDatType;ParNumber:Longint);
		procedure   GetDefName(var ParName:String);override;
	end;
	
	
	TRvaDef = class(TOpperAssemDef)
		procedure GetDefName(var ParName:string);override;
	end;
	
	
	
	TTextDef = class(TAssemDef)
	private
		voText: TString;
		property fText : TString read voText write voText;
	public
		property    GetText : TString read voText;
		constructor Create(ParType : TDatType;ParString:String);
		procedure   Clear;override;
	end;
	
	TASciiDef=class(TTextDef)
	public
		procedure   Print(ParDis :TAsmDisplay);override;
	end;
	
	TAsciizDef=class(TTextDef)
	public
		procedure   Print(ParDis :TAsmDisplay);override;
	end;
	
	
	TNamedLabelDef=class(TAssemDef)
	private
		voGlobal : boolean;
		voname   : TString;
		property iName   : TString read voName   write voName;
		property iGlobal : boolean read voGlobal write voGlobal;
	protected
		procedure   clear;override;
	public
		constructor Create(ParGlobal:boolean;ParType : TDatType;const ParName:string);
		procedure   Print(parDis:TAsmDisplay);override;
	end;
	
	TLabelDef=class(TAssemDef)
	private
		voLabel:longint;
		property iLabel : longint read voLabel write voLabel;
	public
		property fLabel : longint read voLabel;
		procedure Print(parDis:TAsmDisplay);override;
		constructor Create(ParType : TDatType;ParLabel:Longint);
	end;
	
	TVarDef=class(TAssemDef)
	private
		voVariable : TString;
		voSize     : TSIze;
		property fVariable : TString read voVariable write voVariable;
		property fSize     : TSize   read voSize     write voSize;
	protected
		property GetVariable : TString read voVariable;
		property GetSize     : TSize   read voSize;
	public
		constructor Create(Partype : TDatType;const ParName:string;ParSize:TSize;parPublic:boolean);
		procedure  Print(ParDis : TAsmDisplay); override;
		procedure   Clear;override;
	end;
	
	
	
	TAsmDefinitionList = class(TList)
		procedure AddData(PArData:TAssemDef);
		procedure Print(PArDis:TAsmDisplay;ParType : TDatType);
	end;
	
	
implementation

{---( TAddress )-----------------------------------------------------}

constructor TAddressDef.Create(ParType : TDatType;const ParAddress : string);
begin
	iAddress := TString.Create(ParAddress);
	inherited Create(ParType);
end;


procedure   TAddressDef.Clear;
begin
	inherited Clear;
	if iAddress <> nil then iAddress.Destroy;
end;


procedure   TAddressDef.Print(ParDis : TAsmDisplay);
begin
	PArDis.SetLeftMargin(SIZE_AsmLeftMargin);
	ParDis.Print(['.long ',iAddress]);
	PArDis.SetLeftMargin(-SIZE_AsmLeftMargin);
end;

{----( TNamedLabelDef )---------------------------------------------}

procedure TNamedLabelDef.Print(ParDis:TAsmDisplay);
var
	vlStr:String;
begin
	if iGlobal then begin
		iName.GetString(vlStr);
		ParDis.Write(GetAssemblerInfo.GetGlobalText(vlStr));
		ParDis.nl;
	end;
	ParDis.WritePst(iName);
	ParDis.Write(':');
end;

constructor TNamedLabelDef.Create(ParGlobal:boolean;ParType : TDatType;const ParName:String);
begin
	inherited Create(ParType);
	iName   := TString.Create(ParName);
	iGlobal := ParGlobal;
end;

procedure TNamedLabelDef.clear;
begin
	inherited Clear;
	if iName <> nil then iName.destroy;
end;

{----( TalignDef )--------------------------------------------------}

function  TalignDef.Getalign : TSize;
begin
	Getalign := voalign;
end;

procedure TalignDef.Setalign(Paralign : TSize);
begin
	voalign := Paralign;
end;

constructor TalignDef.Create(ParType : TDatType ; ParAlign : TSize);
begin
	inherited Create(parType);
	Setalign(Paralign);
end;

procedure TalignDef.Print(ParDis:TAsmDisplay);
begin
	ParDis.AsPrintAlign(GetAlign);
end;



{----( TExternalCode )-----------------------------------------------}

procedure TExternalCode.Clear;
begin
	inherited Clear;
	if iLabel <> nil then iLabel.destroy;
end;

constructor TExternalCode.Create(ParType : TDatType;const ParLabel:string;ParOpper:TDataDef;ParPublic:boolean);
begin
	inherited Create(ParType,ParOpper);
	iPublic := ParPublic;
	iLabel  := TString.Create(ParLabel);
end;

procedure   TExternalCode.Print(ParDis:TAsmDisplay);
var vlStr:string;
begin
	if iPublic then begin
		TTextDataDef(GetOperand).GetName.GetString(vlStr);
		ParDis.Writenl(GetAssemblerInfo.GetGlobalText(vlStr));
	end;;
	ParDis.WritePst(TTextDataDef(GetOperand).GetName);
	ParDis.Writenl(':');
	ParDis.Print([MN_JUMP,' ']);
	ParDis.WritePst(iLabel);
	ParDis.Nl;
end;


{----( TVarDef )-----------------------------------------}

constructor TVardef.Create(ParType : TDatType;const ParName:string;ParSize:TSize;ParPublic:boolean);
begin
	inherited Create(ParType);
	iPublic   := ParPublic;
	fVariable := TString.Create(ParName);
	fSize     := ParSize;
end;

procedure TVarDef.Print(ParDis :TAsmDisplay);
var vlStr :string;
begin
	GetVariable.GetString(vlStr);
	ParDis.AsPrintVar(iPublic,vlStr,GetSize);
end;


procedure TVarDef.Clear;
begin
	inherited Clear;
	if GetVariable <> nil then GetVariable.Destroy;
end;

{---( TGenLogDef )-----------------------------------------}

procedure TGenLongDef.GetDefName(var ParName : string);
begin
	ParName := MN_Long;
end;


{----( TLongDef )------------------------------------------}

constructor TLongDef.Create(ParType : TDatType;ParNumber:Longint);
begin
	inherited Create(ParType,(TNumberDataDef.Create(ParNUmber)));
end;

procedure   TLongDef.GetDefName(var ParName:String);
begin
	ParName := MN_Long;
end;
{----( TLongDef )------------------------------------------}

constructor TShortDef.Create(ParType : TDatType;ParNumber:Longint);
begin
	inherited Create(ParType,(TNumberDataDef.Create(ParNUmber)));
end;

procedure   TShortDef.GetDefName(var ParName:String);
begin
	ParName := MN_Short;
end;

{----( TNumberDef )------------------------------------------}

procedure    TNumberDataDef.SetNumber(ParNumber:Longint);
begin
	voNumber := ParNumber;
end;

function     TNumberDataDef.GetNumber:longint;
begin
	GetNumber := voNumber;
end;

constructor  TNumberDataDef.Create(ParNumber:Longint);
begin
	inherited Create;
	SetNumber(ParNumber);
end;

procedure    TNumberDataDef.Print(ParDis:TAsmDisplay);
begin
	ParDis.WriteInt(GetNumber);
end;

{----( TAsciiDef )----------------------------------------}

procedure  TAsciiDef.Print(ParDIs :TAsmDisplay);
var vlStr : string;
begin
	fText.GetString(vlStr);
	ParDis.AsPrintAscii(vlStr);
end;

{----( TAsciizDef )----------------------------------------}

procedure  TAsciizDef.Print(ParDIs :TAsmDisplay);
var vlStr : string;
begin
	fText.GetString(vlStr);
	ParDis.AsPrintAsciiz(vlStr);
end;

{----( TTextDef )-----------------------------------------}

constructor TTextDef.Create(ParType : TDatType;ParString:String);
begin
	inherited Create(Partype);
	fText := TString.Create(ParString);
end;


procedure TTextDef.Clear;
begin
	inherited Clear;
	if fText <>nil then fText.Destroy;
end;

{----( TTextDataDef )--------------------------------------}

function   TTextDataDef.GetName:TString;
begin
	GetName :=voText;
end;

procedure   TTextDataDef.SetName(const ParName:string);
var vlStr:String;
begin
	if GetNAme <> nil then GetName.destroy;
	ToAsString(ParName,vlStr);
	voText := TString.Create(vlStr);
end;


destructor  TTextDataDef.destroy;
begin
	inherited destroy;
	if GetName <> nil then GetName.destroy;
end;

constructor TTextDataDef.Create(const ParName:string);
begin
	inherited Create;
	SetName(ParName);
end;

procedure   TTextDataDef.Print(ParDis:TAsmDisplay);
begin
	ParDis.Write('"');
	ParDis.WritePst(GetName);
	ParDis.Write('\000"');
end;

procedure   TTextDataDef.Commonsetup;
begin
	inherited COmmonSetup;
	voText := nil;
end;


{----( TRvaDef )-------------------------------------------}

procedure TRvaDef.GetDefName(var ParName:string);
begin
	ParName := MN_RVA;
end;


{-----( TOpperAssemDef )-------------------------------------}

constructor TOpperAssemDef.Create(ParType : TDatType;ParOpper:TDataDef);
begin
	inherited Create(ParType);
	SetOperand(ParOpper);
end;

procedure  TOpperAssemDef.commonsetup;
begin
	inherited COmmonsetup;
	voOpper := nil;
end;

destructor TOpperAssemDef.destroy;
begin
	inherited destroy;
	if GetOperand <>  nil then GetOperand.destroy;;
end;

procedure TOpperAssemDef.SetOperand(ParOpper:TDataDef);
begin
	voOpper := ParOpper;
end;

function  TOpperAssemDef.GetOperand:TDataDef;
begin
	GetOperand := voOpper;
end;
procedure TOpperAssemDef.Print(parDIs:TAsmDisplay);
var vlname:String;
begin
	PArDis.SetLeftMargin(SIZE_AsmLeftMargin);
	GetDefName(vlName);
	PArDis.Write(vlName);
	ParDis.Write(' ');
	if GetOperand <> nil then GetOperand.Print(ParDis);
	PArDis.SetLeftMargin(-SIZE_AsmLeftMargin);
end;



{----( TAssemDef )-----------------------------------------}



procedure   TAssemDef.Print(ParDis:TAsmDisplay);
begin
end;

constructor TAssemDef.Create(ParType : TDatType);
begin
	inherited Create;
	iType := ParType;
end;

procedure TAssemDef.GetDefName(var ParName:string);
begin
	ParName := '<Abstract>';
end;



procedure TAssemDef.CommonSetup;
begin
	inherited COmmonSetup;
	iPublic := true;
end;

{----( TLabelDataDef )-------------------------------------}



constructor TLabelDataDef.Create(ParLabel:Longint);
begin
	inherited Create;
	iLabel := ParLabel;
end;

procedure   TLabelDataDef.Print(ParDis:TAsmDisplay);
begin
	ParDis.Print(['.L',iLabel]);
end;


{----( TDataDef )------------------------------------------}

procedure TDataDef.Print(ParDis:TAsmDisplay);
begin
end;

{----( TLabelDef )-----------------------------------------}


procedure TLabelDef.Print(parDis:TAsmDisplay);
begin
	ParDis.AsPrintLabel(iLabel);
end;

constructor TLabelDef.Create(ParType : TDatType;ParLabel:Longint);
begin
	inherited Create(ParType);
	iLabel := ParLabel;
end;


{----( TAsmDefinitionList )----------------------------------------------------}

procedure TAsmDefinitionList.AddData(PArData:TAssemDef);
begin
	InsertAtTop(ParData);
end;

procedure TAsmDefinitionList.Print(PArDis:TAsmDisplay;ParType : TDatType);
var vlCurrent :TAssemDef;
begin
	vlCurrent := TAssemDef(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent.fType = ParType then begin
			vlCurrent.Print(ParDis);
			ParDis.nl;
		end;
		vlCurrent := TAssemDef(vlCurrent.fNxt);
	end;
end;

begin
	
end.

