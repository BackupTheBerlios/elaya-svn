{
    Elaya, the compiler for the elaya language
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

unit procinfo;
interface
uses objlist,compbase,progutil,elacons,stdobj;
type
	
	TProcInfo=class(TRoot)
		
	private
		voShortName     : TString;
		voProcedureName : TString;
		voParentName    : TString;
		voFirstLine     : cardinal;
		voObjectList    : TObjectLIst;
		property iObjectList    : TObjectList read voObjectList write voObjectList;
		property fShortName     : TString read voShortName     write voShortName;
		property fProcedureName : TString read voProcedureName write voProcedureName;

		procedure  CommonSetup;override;

	public
		property   fFirstLine       : cardinal read voFirstLine write voFirstLine;
		property   fParentName      : TString  read voParentName write voParentName;
		property   GetShortName     : TString  read voShortName;
		property   GetProcedureName : TString  read voProcedureName;
		procedure  SetShortName( const ParStr:String);
		procedure  SetProcedureName(const ParStr:string);
		procedure  AddObject(ParItem : TRoot);
		destructor destroy;override;
	end;
	
implementation

{uses asminfo;}



{----( TProcInfo )-----------------------------------------------------------}


procedure TPRocInfo.CommonSetup;
begin
	inherited CommonSetup;
	fProcedureName := nil;
	fShortName     := nil;
	fParentName    := nil;
	iObjectList    := TObjectList.Create;
end;

procedure  TProcInfo.AddObject(ParItem : TRoot);
begin
	iObjectList.AddObject(ParItem);
end;


procedure  TProcInfo.SetShortName(const ParStr:String);
begin
	if fShortName <> nil then fShortName.Destroy;
	fShortName := TString.Create(ParStr);
end;

procedure  TProcInfo.SetProcedureName(const ParStr:String);
begin
	if fProcedureName <> nil then fProcedureName.Destroy;
	fProcedureName := TString.Create(ParStr);
end;


destructor TProcInfo.destroy;
begin
	inherited destroy;
	if fShortName     <> nil then fShortName.Destroy;
	if fProcedureNAme <> nil then fProcedureName.Destroy;
	if iObjectList    <> nil then iObjectList.Destroy;
	if fParentName   <> nil then fParentName.Destroy;
end;


end.
