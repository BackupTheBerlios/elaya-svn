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

unit vars;
interface
uses varbase,Formbase,streams,elacons,compbase,types,asmcreat,progutil,stdobj,
	display,elaTypes,macObj,asmdata,elacfg,node,ddefinit,asminfo,largenum,dsblsdef;
	
type
	
	TConstant=class(TVarBase)
	private
		voVal:TValue;
	protected
		property iVal : TValue read voVal write voVal;
		procedure  CommonSetup;override;
		procedure  Clear;override;

	public
		function   CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		procedure  SetValue(ParVal:TValue);
		property   fVal : TValue read voVal write SetValue;
		procedure  PrintDefinitionBody(ParDis : TDisplay);override;
		procedure  PrintDefinitionType(ParDis : TDisplay);override;
		function   Can(ParCan:TCan_Types):boolean;override;
		function   CreateReadNode(ParCre : TCreator;ParContext : TDefinition):TFormulaNode;override;
		function  CreateDb(ParCre:TCreator):boolean;override;
		function  LoadItem(parWrite:TObjectStream):boolean;override;
		function  SaveItem(ParWrite:TObjectStream):boolean;override;
      function    NeedReadableRecord : boolean;override;
	end;
	
	TPointerCons=class(TConstant)
	public
		function  CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;PArCre:TSecCreator):TMacBase;override;
		procedure Commonsetup;override;
	end;
	
	TStringCons=class(TConstant)
	public
		function  CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		function  Can(ParCan : TCan_Types):boolean;override;
		function  CreateDb(ParCre:TCreator):boolean;override;
		procedure CommonSetup;override;
		constructor Create(const ParName : string;const ParString : string;ParType:TType);
		function  GetString:TString;
		function  GetLength:cardinal;
		function  CreateReadNode(ParCre : TCreator;ParContext : TDefinition):TFormulaNode;override;
	end;
	
	
	TEnumCons=class(TConstant)
	protected
		procedure commonsetup; override;
	public
		constructor Create(const ParName:string;ParVal:TValue);
		function GetNumber : TNumber;
	end;
	
	TConstantNode = class(TVarNode)
	public
		function IsConstant : boolean;override;
		function GetValue : TValue;override;
	end;

	TEnumCollection=class(TSubListDef)
	protected
		procedure Commonsetup;override;
	public
		procedure SetEnumType(ParType : TEnumType);
	end;
	
	
implementation

uses execobj,ndcreat;


{---( TConstantNode )-----------------------------------------------------------}

function TConstantNode.IsConstant : boolean;
begin
	exit(true);
end;


function  TConstantNode.GetValue : TValue;
begin
	exit(TConstant(fVariable).fVal.Clone);
end;



{---( TPointerCons )------------------------------------------------}
procedure TPointerCons.Commonsetup;
begin
 	inherited Commonsetup;
	iIdentCOde := (IC_PointerCons);
end;

function  TPointerCons.CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;PArCre:TSecCreator):TMacBase;
var vlInt:cardinal;
	vlLi : TLargeNUmber;
	vlMac : TMacBase;
begin
	case ParOpt of
		MCO_Result:begin
			TPointer(fVal).GetPointer(vlInt);
			LoadLong(vlLi,vlInt);
			vlMac := ParCre.CreateNumberMac(GetAssemblerInfo.GetSystemSize,false,vlLi);
		end;
		else vlMac := inherited ;CreateMac(ParContext,Paropt,ParCre);
	end;
	exit(vlMac);
end;


{---( TStringCons)--------------------------------------------------}

function  TStringCons.Can(ParCan : TCan_Types):boolean;
begin
	exit(inherited Can(ParCan - [Can_Pointer]));
end;

function  TStringCons.CreateReadNode(ParCre : TCreator;ParContext : TDefinition):TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	vlNode := TStringNode.Create(self);
	vlNode.fContext := ParContext;
	TNDCreator(ParCre).SetNodePos(vlNode);
	exit(vlNode);
end;

function  TStringCons.CreateDb(ParCre:TCreator):boolean;
var vlname:String;
	vlText:string;
begin
	GetMangledName(vlName);
	fVal.GetString(vlText);
	TAsmCreator(ParCre).AddData(TNamedLabelDef.Create(IsAsmGlobal,DAT_Data,vlname));
	TAsmCreator(ParCre).AddData(TAsciiDef.Create(DAT_Data,vlText));
	CreateDB := false;
end;

procedure TStringCons.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := Ic_StringCons;
	iVal      := nil;
end;


constructor TStringCons.Create(const ParName : string;const ParString : string;ParType:TType);
begin
	inherited Create(ParName,ParType);
	SetValue(TString.Create(ParString));
end;

function TStringCons.GetString:TString;
begin
	exit(TString(fVal));
end;


function TStringCons.GetLength:cardinal;
begin
	GetLength := 0;
	if GetString <> nil then GetLength := GetString.fLength;
end;

function TStringCons.CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlMac:TMacBase;
	vlStr:string;
begin
	Case ParOpt  of
		MCO_Result:begin
			GetMangledName(vlStr);
			vlMac := TMemMac.Create(iType.fSize,iType.GetSign,vlStr);
			ParCre.AddObject(vlMac);
		end;
		MCO_ValuePointer,MCO_ObjectPointer:begin
			vlMac := TMemOfsMac.Create(CreateMac(ParContext,MCO_Result,ParCre));
			ParCre.AddObject(vlMac);
		end
		else vlMac := inherited CreateMac(ParContext,ParOpt,ParCre);
	end;
	exit(vlMac);
end;

{------( TConstant )------------------------------------------------}


function  TConstant.NeedReadableRecord : boolean;
begin
	exit(false);
end;


function  TConstant.LoadItem(parWrite:TObjectStream):boolean;
var
	vlValue : TValue;
begin
	if inherited LoadItem(ParWrite) then exit(true);
	if ParWrite.ReadValue(vlValue) then exit(true);
	iVal  := vlValue;
	exit(false);
end;

function  TConstant.SaveItem(ParWrite:TObjectStream):boolean;
begin
	if inherited SaveItem(ParWrite) then exit(true);
	if ParWrite.WriteValue(iVal) then exit(true);
	exit(false);
end;


function TConstant.CreateDB(ParCre:TCreator):boolean;
begin
	exit(false);
end;


function TConstant.CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlMac:TMacBase;
	vlNum : TNumber;
begin
	case ParOpt of
	MCO_Result : begin
			iVal.GetAsNumber(vlNum);{TODO when function returns true}
			vlMac := TNumberMac.Create(iType.fSize,iType.GetSign,vlNum);
			ParCre.AddObject(vlMac);
		end
		else vlMac := inherited CreateMac(ParContext,ParOpt,ParCre);
	end;
	exit(vlMac);
end;

function   TConstant.CreateReadNode(ParCre : TCreator;ParContext : TDefinition):TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	vlNode := TConstantNode.Create(self);
	vlNode.fContext := ParContext;
	TNDCreator(ParCre).SetNodePos(vlNode);
	exit(vlNode);
end;

procedure TConstant.SetValue(ParVal:TValue);
begin
	if fVal <> nil then fVal.destroy;
	iVal := ParVal;
end;

procedure TConstant.PrintDefinitionType(ParDis : TDisplay);
begin
	ParDis.Write('constant');
end;

procedure TConstant.PrintDefinitionBody(ParDis:TDisplay);
begin
	ParDis.Write('<type>');
	if fType <> nil then fType.PrintName(ParDis);
	ParDis.Write('</type><value>');
	ParDis.Print([fVal]);
	ParDis.Write('</value>');
end;


function  TConstant.Can(ParCan:TCan_Types):boolean;
begin
	ParCan := ParCan - [Can_Size];
	if (CAN_Write in ParCan) then exit(false);
	exit( inherited Can(ParCan));
end;


procedure TConstant.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (ic_Constant);
	iAccess := [Can_Read];
end;

procedure TConstant.clear;
begin
	inherited clear;
	if fVal <> nil then fVal.destroy;
end;




{-------( TEnumCons )-----------------------------------------------}
constructor TEnumCons.Create(const ParName:string;ParVal:TValue);
begin
	SetValue(ParVal);
	inherited Create(ParName,nil);
end;

function TENumCons.GetNumber : TNumber;
var
	vlNum :TNumber;
begin
	fVal.GetNumber(vlNum);
	exit(vlNum);
end;

procedure TEnumCons.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_EnumCons;
end;
{-------( TEnumCollection )------------------------------------------}

procedure TEnumCollection.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode     := IC_EnumCollection;
	fParts.fGlobal := true;
end;

procedure TEnumCollection.SetEnumType(ParType : TEnumType);
var
	vlCurrent : TEnumCons;
begin
	vlCurrent := TEnumCons(fParts.fStart);
	while vlCurrent <> nil do begin
		vlCurrent.SetType(ParType);
		vlCurrent := TEnumCons(vlCurrent.fNxt);
	end;
end;


end.

