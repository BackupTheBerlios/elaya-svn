{
    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
web : www.elaya.org

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

unit plinenum;
interface
uses pocobj,display,resource,elacons,istabs;

type  TLineNumberPoc=class(TPocBase)
	private
		voLine:cardinal;
		property iLine:Cardinal read voLine write voLine;
	public
		constructor Create(ParLine:cardinal);
		procedure   Print(ParDis:TDisplay);override;
		function    CreateInst(ParCre:TInstCreator):boolean;override;
	end;
	
	
implementation

uses procinst;
{---( TLineNumMac )-------------------------------------------------}


constructor TLineNumberPoc.Create(ParLine:cardinal);
begin
	inherited Create;
	iLine := ParLine;
end;


procedure TLineNUmberPoc.Print(ParDis:TDisplay);
begin
	ParDis.Write('NewLine : Line = ');
	ParDis.WriteInt(iLine);
end;

function TLineNumberPoc.CreateInst(ParCre:TInstCreator):boolean;
var vlLabel:TLabelInst;
	vlName : string;
begin
	vlLabel := TLabelInst(ParCre.CreateLabel(Lab_NewName));
	ParCre.AddInstAfterCur(vlLabel);
	ParCre.GetProcedureName(vlname);
	ParCre.AddInstAfterCur(TLineNumberStab.Create(iLine,vlLabel,vlName));
	CreateInst := false;
end;

end.
