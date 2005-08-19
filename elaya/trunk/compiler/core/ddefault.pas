 {
    Elaya, the compiler for the elaya language
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
unit DDefault;
interface
uses linklist,elacons,elatypes,DDefinit;
type
	TDefaultList = class(TList)
	public
		procedure AddDefault(ParDef:TDefinition);
		function  GetDefaultBySize(ParDefault:TDefaultTypeCode;ParSize:TSize;ParSign:boolean):TDefinition;
	end;

	TDefaultItem = class(TObjectItem)
	public
		function IsDefault(ParDefault:TDefaultTypeCode;ParSize:TSize;ParSign:boolean):boolean;
	end;

implementation
uses formbase;

{------( TDefaultList )-----------------------------------------------------}

procedure TDefaultList.AddDefault(ParDef:TDefinition);
begin
	InsertAtTop(TDefaultItem.Create(Pardef));
end;


function  TDefaultList.GetDefaultBySize(ParDefault:TDefaultTypeCode;ParSize:TSIze;ParSign:boolean):TDefinition;
var vlDef:TDefaultItem;
begin
	vlDef := TDefaultItem(fStart);
	while (vlDef <> nil) and not(vlDef.IsDefault(ParDefault,ParSize,ParSign)) do vlDef := TDefaultItem(vlDef.fNxt);
	GetDefaultBySize := nil;
	if vlDef <> nil then GetDefaultBySize := TDefinition(vlDef.fObject);;
end;



{------( TDefaultItem )------------------------------------------------------}

function TDefaultItem.IsDefault(ParDefault : TDefaultTypeCode ; ParSize:TSize;ParSign:boolean):boolean;
var
	vlType:TType;
	vlDef : TDefinition;
begin
	IsDefault := false;

	vlDef := TDefinition(fObject);
	if TDefinition(fObject).fDefault = ParDefault then begin

		if fObject is TType then begin

			vlType := TType(fObject);
			if  vlType.IsDefaultType(ParDefault,ParSize,ParSign)  then IsDefault := true;

		end else begin

			isDefault := true;

		end;

	end;
end;

end.

