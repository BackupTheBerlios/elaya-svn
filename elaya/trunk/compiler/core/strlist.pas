{
Elaya, the compiler for theelaya language
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

unit strlist;
interface
uses simplist,stdobj,compbase;

type
	TStringListItem=class(TSMTextItem)
    private
		voLabel  : longint;
		property iLabel : longint read voLabel write voLabel;
	protected
		procedure Commonsetup;override;
	public
		property fLabel : longint read voLabel;
		function CreateDb(ParCre:TCreator):boolean;
	end;

	TStringlist = class(TSMTextList)
	public
		function AddString(const ParText : string):longint;
		function CreateDb(ParCre:TCreator):boolean;
	end;


implementation
uses asmcreat,asmdata,elacons;
{----( TStringListItem )--------------------------------------------------}
procedure TStringListItem.Commonsetup;
begin
	inherited Commonsetup;
	iLabel := GetNewLabelNo;
end;

function  TStringListItem.CreateDb(ParCre:TCreator):boolean;
var
	vlText:string;
begin
    GetTextStr(vlText);
	TAsmCreator(ParCre).AddData(TLabelDef.Create(DAT_Data,iLabel));
	TAsmCreator(ParCre).AddData(TAsciiDef.Create(DAT_Data,vlText));
	exit(false);
end;


{----( TStringList )------------------------------------------------------}

function TStringList.AddString(const ParText : string) : longint;
var
	vlItem : TStringListItem;
begin
	vlItem := TStringListItem(GetPtrByName(nil,ParText));
	if vlItem = nil then vlItem := TStringListItem(InsertAt(nil,TStringListItem.Create(ParText)));
    exit(vlItem.fLabel);
end;

function TStringList.CreateDb(ParCre:TCreator):boolean;
var
	vlItem : TStringListItem;
begin
	vlItem := TStringListItem(fStart);
	while vlItem <> nil do begin
		vlItem.CreateDB(ParCre);
		vlitem := TStringListItem(vlItem.fNxt);
	end;
	exit(false);
end;




end.

