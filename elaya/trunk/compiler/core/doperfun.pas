{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2002  J.v.Iddekinge.

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

unit DOperFun;
interface
uses compbase,asminfo,stdobj,procs,elacons,error,display,ndcreat,formbase,node;

type TOperatorFunction=class(TFunction)
	protected
		procedure Commonsetup;override;
	public
		procedure PrintDefinitionHeader(ParDis:TDisplay);override;
		procedure PrintDefinitionType(ParDis : TDisplay);override;
		procedure GetTextName(var ParName : string);override;
		function  CreateExitNode(ParCre : TCreator;ParNode : TFormulaNode) : TNodeIdent;override;
	end;
	
	
implementation


{--( TOperatorFunction )----------------------------------------------}

procedure TOperatorFunction.PrintDefinitionType(ParDis:TDisplay);
begin
	ParDis.write('Operator ');
end;

procedure TOperatorFunction.PrintDefinitionHeader(ParDis : TDisplay);
begin
	inherited PrintDefinitionHeader(ParDis);
	if fType <> nil then 	ParDis.print([':' ,fType.fText,' ',cardinal(fType)]);
end;

procedure TOperatorFUnction.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_OPeratorFunction);
end;


function  TOperatorFunction.CreateExitNode(ParCre : TCreator;ParNode : TFormulaNode) : TNodeIdent;
begin
	if (fType=nil)  and (ParNode <> nil) then TNDCreator(ParCre).SemError(Err_Cant_Return_Value);
	exit(inherited CreateExitNode(ParCre,ParNode));
end;

procedure TOperatorFunction.GetTextName(var ParName:String);
var
	vlStr  : string;
begin
	GetTextStr(vlStr);
	OperatorToDesc(vlStr,ParName);
end;

end.
