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

unit nconvert;

interface
uses useitem,stdobj,node,elacons,formbase,macobj,pocobj,compbase,error,display;

type   TConvertnode=class(TSublistFormulaNode)
	end;
	
	TLoadConvert=class(TConvertNode)
	private
		voType         : TType;
		property itype : TType read voType write voType;
	protected
		procedure   Commonsetup;override;
	public
		constructor Create(ParConvToType:TType);
		function    CreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		function    GetType : TType;override;
		procedure   Print(ParDis:TDIsplay); override;
		function    GetValue : TValue;override;
		function    Can(ParCan : TCan_Types):boolean;override;
		procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);override;

	end;
	
implementation

{--( TLoadConvert )----------------------------------------------------------------}
procedure TLoadConvert.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
begin
	iParts.ValidateDefinitionUse(ParCre,ParMode,ParUseList);
end;


function  TLoadConvert.Can(ParCan : TCan_Types):boolean;
var vlNode : TFormulaNode;
begin
	vlNode := TFormulaNode(iParts.fStart);
	if vlNode <> nil then begin
		exit(vlNode.Can(ParCan));
	end else begin
		exit(false);
	end;
end;

function  TLoadConvert.GetValue : TValue;
var vlNode : TFOrmulaNode;
begin
	vlNode := TFormulaNode(iParts.fStart);
	writeln('3)',vlNode.ClassName);
	if vlNode <> nil then exit(vlNode.GetValue)
	else exit(nil);
end;


constructor TLoadConvert.Create(ParConvToType:TType);
begin
	if (PArConvToType = nil) or (ParConvToType.IsLargeType) then Fatal(fat_conv_type_to_Large,'At:TLoadCover.Create');
	inherited Create;
	iType := ParConvToType;
end;


function TLoadConvert.CreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlMac:TResultMac;
	 vlPoc:TPocBase;
begin
	Case ParOpt of
	MCO_Result: begin
		vlMac := TResultMac.Create(iType.fSize,iType.GetSign);
      ParCre.AddObject(vlMac);
		vlPoc := PArCre.MakeLoadPoc(vlMac,TNodeIdent(fParts.fStart).CreateMac(MCO_Result,ParCre));
		ParCre.AddSec(vlPoc);
		exit(vlMac);
	end;
	else CreateMac := inherited CreateMac(ParOpt,ParCre);
end;
end;

function TLoadConvert.GetType:TType;
begin
	GetType := iType;
end;

procedure TLoadConvert.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_LoadConvertNode);
end;

procedure TLoadConvert.Print(ParDIs:TDisplay);
var vlNode:TNodeIdent;
begin
	ParDis.Writenl('Convert');
	ParDis.SetLeftMArgin(3);
	vlNode := TNodeIdent(iParts.fStart);
	vlNode.Print(ParDis);
	ParDis.SetLeftMargin(-3);
	ParDIs.Nl;
	ParDis.Writenl('To type:');
	ParDis.SetLeftMargin(3);
	if iType <> nil then iType.PrintName(ParDis);
	ParDis.SetLeftMargin(-3);
	ParDis.nl;
	ParDis.Write('End convert');
end;

end.

