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
		property iNumber : longint read voNumber write voNumber;{TODO: to TNumber?}
	public
		constructor Create(ParNumber:Longint);
		procedure Print(ParDis:TAsmDisplay);override;
	end;
	
	TTextDataDef=class(TDataDef)
	private
		voText:AnsiString;
		property iText : AnsiString read voText write voText;
		

	public
		property fText : AnsiString read voText;
		constructor Create(const ParName:ansistring);
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
		procedure GetDefName(var ParName:ansistring);virtual;
		constructor Create(ParType : TDatType);
		procedure commonsetup;override;
	end;
	
	
	TAddressDef=class(TAssemDef)
	private
		voAddress : AnsiString;
		property iAddress : AnsiString read voAddress write voAddress;
	public
		constructor Create(ParType : TDatType;const ParAddress : ansistring);
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
		voLabel:ansistring;
		voName : ansistring;
		property iLabel : AnsiString read voLabel write voLabel;
		property iName  : AnsiString  read voName  write voName;
	public
		constructor Create(Partype : TDatType;const ParLabel,ParName:ansistring;ParPublic:boolean);
		procedure   Print(ParDis:TAsmDisplay);override;
	end;
	
	TGenLongDef=class(TOperAssemDef)
		procedure GetDefName(var ParName : ansistring);override;
	end;
	
	TLongDef = class(TOperAssemDef)
		constructor Create(parType : TDatType;ParNumber:Longint);
		procedure   GetDefName(var ParName:ansistring);override;
	end;
	
	TShortDef = class(TOperAssemDef)
		constructor Create(parType : TDatType;ParNumber:Longint);
		procedure   GetDefName(var ParName:ansistring);override;
	end;
	
	
	TRvaDef = class(TOperAssemDef)
		procedure GetDefName(var ParName:ansistring);override;
	end;
	
	
	
	TTextDef = class(TAssemDef)
	private
		voText: AnsiString;
		property iText : AnsiString read voText write voText;
	public
		property fText : AnsiString read voText;

		constructor Create(ParType : TDatType;ParString:ansistring);	
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
		voname   : AnsiString;
		property iName   : AnsiString read voName   write voName;
		property iGlobal : boolean read voGlobal write voGlobal;

	public
		constructor Create(ParGlobal:boolean;ParType : TDatType;const ParName:ansistring);
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
		voVariable : ansistring;
		voSize     : TSIze;
		property iVariable : AnsiString read voVariable write voVariable;
		property iSize     : TSize   read voSize     write voSize;
	protected
		property fVariable : AnsiString read voVariable;
		property fSize     : TSize   read voSize;
	public
		constructor Create(Partype : TDatType;const ParName:ansistring;ParSize:TSize;parPublic:boolean);
		procedure  Print(ParDis : TAsmDisplay); override;
	end;
	
	
	
	TAsmDefinitionList = class(TList)
		procedure AddData(PArData:TAssemDef);
		procedure Print(PArDis:TAsmDisplay;ParType : TDatType);
	end;
	
	
implementation

{---( TAddress )-----------------------------------------------------}

constructor TAddressDef.Create(ParType : TDatType;const ParAddress : ansistring);
begin
	inherited Create(ParType);
	iAddress := ParAddress;
end;

procedure   TAddressDef.Print(ParDis : TAsmDisplay);
begin
	PArDis.SetLeftMargin(SIZE_AsmLeftMargin);
	ParDis.Print(['.long ',iAddress]);
	PArDis.SetLeftMargin(-SIZE_AsmLeftMargin);
end;

{----( TNamedLabelDef )---------------------------------------------}

procedure TNamedLabelDef.Print(ParDis:TAsmDisplay);

begin
	if iGlobal then begin
		ParDis.Write(GetAssemblerInfo.GetGlobalText(iName));
		ParDis.nl;
	end;
	ParDis.Print([iName,':']);
end;

constructor TNamedLabelDef.Create(ParGlobal:boolean;ParType : TDatType;const ParName:ansistring);
begin
	inherited Create(ParType);
	iName   := ParName;
	iGlobal := ParGlobal;
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

constructor TExternalCode.Create(ParType : TDatType;const ParLabel,ParName : ansistring;ParPublic:boolean);
begin
	inherited Create(ParType);
	iName   := ParName;
	iLabel  := ParLabel;
end;

procedure   TExternalCode.Print(ParDis:TAsmDisplay);
begin
	if iPublic then ParDis.Writenl(GetAssemblerInfo.GetGlobalText(iName));
	ParDis.Print([iName,':']);
	ParDis.Nl;
	ParDis.Print([MN_JUMP,' ',iLabel]);
	ParDis.Nl;
end;


{----( TVarDef )-----------------------------------------}

constructor TVardef.Create(ParType : TDatType;const ParName:ansistring;ParSize:TSize;ParPublic:boolean);
begin
	inherited Create(ParType);
	iPublic   := ParPublic;
	iVariable := ParName;
	iSize     := ParSize;
end;

procedure TVarDef.Print(ParDis :TAsmDisplay);
begin
	ParDis.AsPrintVar(iPublic,iVariable,iSize);
end;

{---( TGenLogDef )-----------------------------------------}

procedure TGenLongDef.GetDefName(var ParName : ansistring);
begin
	ParName := MN_Long;
end;


{----( TLongDef )------------------------------------------}

constructor TLongDef.Create(ParType : TDatType;ParNumber:Longint);
begin
	inherited Create(ParType,TNumberDataDef.Create(ParNUmber));
end;

procedure   TLongDef.GetDefName(var ParName:ansistring);
begin
	ParName := MN_Long;
end;
{----( TLongDef )------------------------------------------}

constructor TShortDef.Create(ParType : TDatType;ParNumber:Longint);
begin
	inherited Create(ParType,TNumberDataDef.Create(ParNUmber));
end;

procedure   TShortDef.GetDefName(var ParName:ansistring);
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
begin
	ParDis.AsPrintAscii(fText);
end;

{----( TAsciizDef )----------------------------------------}

procedure  TAsciizDef.Print(ParDIs :TAsmDisplay);
begin
	ParDis.AsPrintAsciiz(fText);
end;

{----( TTextDef )-----------------------------------------}

constructor TTextDef.Create(ParType : TDatType;ParString:ansistring);
begin
	inherited Create(Partype);
	iText := ParString;
end;



{----( TTextDataDef )--------------------------------------}


constructor TTextDataDef.Create(const ParName:ansistring);
var
	vlStr : ansistring;
begin
	inherited Create;
	ToAsString(ParName,vlStr);
	iText := vlStr;
end;

procedure   TTextDataDef.Print(ParDis:TAsmDisplay);
begin
	ParDis.Write('"');
	ParDis.WriteString(iText);
	ParDis.Write('\000"');
end;


{----( TRvaDef )-------------------------------------------}

procedure TRvaDef.GetDefName(var ParName:ansistring);
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
	vlName:ansistring;
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

procedure TAssemDef.GetDefName(var ParName:ansistring);
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

