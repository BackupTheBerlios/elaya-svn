{    Elaya, the comp[5~iler for the elaya language
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
		property iNumber : longint read voNumber write voNumber;{TODO: to TNumber?}
	public
		constructor Create(ParNumber:Longint);
		procedure Print(ParDis:TAsmDisplay);override;
	end;
	
	TTextDataDef=class(TDataDef)
	private
		voText:TString;
		property iText : TString read voText write voText;
		procedure clear;override;

	public
		property fText : TString read voText;
		constructor Create(const ParName:string);
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
	
	
	TOperAssemDef=class(TAssemdef)
	private
		voOperand:TDataDef;
		property iOperand : TDataDef read voOperand Write voOperand;
	protected
		procedure   clear;override;
		property fOperand : TDataDef read voOperand Write voOperand;

	public
		constructor Create(ParType : TDatType;ParOper:TDataDef);
		procedure   Print(parDIs:TAsmDisplay);override;
	end;
	
	

	TalignDef=class(TAssemDef)
	private
		voalign : TSize;
		property iAlign : TSIze read voAlign write voAlign;
	public

		constructor Create(ParType : TDatType;ParAlign : TSize);
		procedure Print(ParDis:TAsmDisplay);override;
	end;
	
	TExternalCode=class(TAssemDef)
	private
		voLabel:TString;
		voName : TString;
		property iLabel : TString read voLabel write voLabel;
		property iName  : TString  read voName  write voName;
	protected
		procedure Clear;override;
	public
		constructor Create(Partype : TDatType;const ParLabel,ParName:string;ParPublic:boolean);
		procedure   Print(ParDis:TAsmDisplay);override;
	end;
	
	TGenLongDef=class(TOperAssemDef)
		procedure GetDefName(var ParName : string);override;
	end;
	
	TLongDef = class(TOperAssemDef)
		constructor Create(parType : TDatType;ParNumber:Longint);
		procedure   GetDefName(var ParName:String);override;
	end;
	
	TShortDef = class(TOperAssemDef)
		constructor Create(parType : TDatType;ParNumber:Longint);
		procedure   GetDefName(var ParName:String);override;
	end;
	
	
	TRvaDef = class(TOperAssemDef)
		procedure GetDefName(var ParName:string);override;
	end;
	
	
	
	TTextDef = class(TAssemDef)
	private
		voText: TString;
		property iText : TString read voText write voText;
	public
		property fText : TString read voText;

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

constructor TalignDef.Create(ParType : TDatType ; ParAlign : TSize);
begin
	inherited Create(parType);
	iAlign := ParAlign;
end;

procedure TalignDef.Print(ParDis:TAsmDisplay);
begin
	ParDis.AsPrintAlign(iAlign);
end;



{----( TExternalCode )-----------------------------------------------}

procedure TExternalCode.Clear;
begin
	inherited Clear;
	if iLabel <> nil then iLabel.destroy;
	if iName <> nil then iName.Destroy;
end;

constructor TExternalCode.Create(ParType : TDatType;const ParLabel,ParName : string;ParPublic:boolean);
begin
	inherited Create(ParType);
	iName   := TString.Create(ParName);
	iLabel  := TString.Create(ParLabel);
end;

procedure   TExternalCode.Print(ParDis:TAsmDisplay);
var
	vlName:string;
begin
	iName.GetString(vlName);
	if iPublic then ParDis.Writenl(GetAssemblerInfo.GetGlobalText(vlName));
	ParDis.Write(vlName);
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
	inherited Create(ParType,TNumberDataDef.Create(ParNUmber));
end;

procedure   TLongDef.GetDefName(var ParName:String);
begin
	ParName := MN_Long;
end;
{----( TLongDef )------------------------------------------}

constructor TShortDef.Create(ParType : TDatType;ParNumber:Longint);
begin
	inherited Create(ParType,TNumberDataDef.Create(ParNUmber));
end;

procedure   TShortDef.GetDefName(var ParName:String);
begin
	ParName := MN_Short;
end;

{----( TNumberDef )------------------------------------------}


constructor  TNumberDataDef.Create(ParNumber:Longint);
begin
	inherited Create;
	iNumber := ParNumber;
end;

procedure    TNumberDataDef.Print(ParDis:TAsmDisplay);
begin
	ParDis.WriteInt(iNumber);
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
	iText := TString.Create(ParString);
end;


procedure TTextDef.Clear;
begin
	inherited Clear;
	if iText <>nil then iText.Destroy;
end;

{----( TTextDataDef )--------------------------------------}


procedure TTextDataDef.Clear;
begin
	inherited clear;
	if iText <> nil then iText.destroy;
end;

constructor TTextDataDef.Create(const ParName:string);
var
	vlStr : string;
begin
	inherited Create;
	ToAsString(ParName,vlStr);
	iText := TString.Create(vlStr);
end;

procedure   TTextDataDef.Print(ParDis:TAsmDisplay);
begin
	ParDis.Write('"');
	ParDis.WritePst(iText);
	ParDis.Write('\000"');
end;


{----( TRvaDef )-------------------------------------------}

procedure TRvaDef.GetDefName(var ParName:string);
begin
	ParName := MN_RVA;
end;


{-----( TOperAssemDef )-------------------------------------}

constructor TOperAssemDef.Create(ParType : TDatType;ParOper:TDataDef);
begin
	inherited Create(ParType);
	iOperand := ParOper;
end;

procedure TOperAssemDef.Clear;
begin
	inherited Clear;
	if iOperand <> nil then iOperand.destroy;
end;

procedure TOperAssemDef.Print(parDIs:TAsmDisplay);
var
	vlName:String;
begin
	PArDis.SetLeftMargin(SIZE_AsmLeftMargin);
	GetDefName(vlName);
	PArDis.Write(vlName);
	ParDis.Write(' ');
	if iOperand <> nil then iOperand.Print(ParDis);
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

