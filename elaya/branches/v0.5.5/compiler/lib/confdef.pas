{    Elaya, the Fcompiler for the elaya language
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
unit confdef;
interface
uses progutil,simplist,stdobj;
type
	TConfigVarItem=Class(TSMListItem)
	private
		voName     : TString;
		voValue    : TValue;
		voReadOnly : boolean;
		
		property   iName     : TString read voName      write voName;
		property   iValue    : TValue  read voValue     write voValue;
		property   iReadOnly : boolean read voReadOnly  write voReadOnly;
	protected
		procedure   Clear;override;
		procedure   CommonSetup;override;

	public
		property    fName   : TString read voName;
		property    fValue  : TValue  read voValue;
		property    fReadOnly : boolean read voReadOnly;
		
		procedure   GetNameStr(var ParNAme : string);
		function    IsName(const ParName:string):boolean;
		procedure   SetName(const ParName:String);
		function    SetValueUnchecked(ParValue : TValue):boolean;
		function    SetValue(ParValue : TValue):boolean;
		constructor Create(const ParName :string;ParValue : TValue;ParReadOnly:boolean);
		function    IsSame(ParValue : TValue) :boolean;
		
	end;
	
	TConfigVarList= Class(TSMList)
		function AddVar(const ParName,ParValue : string;ParReadOnly:boolean):TConfigVarItem;virtual;
		function GetPtrByName(const ParName : string):TConfigVarItem;
		function GetValueByName(const ParName:String;var ParValue : string):boolean;
	end;
	
implementation

{----( TConfigVarItem )--------------------------------------}

procedure TConfigVarItem.GetNameStr(var ParNAme : string);
begin
	iName.GetString(ParName);
end;

function TConfigVarItem.IsSame(ParValue : TValue) :boolean;
begin
	exit(iValue.IsEqual(ParValue));
end;

procedure TConfigVarItem.commonsetup;
begin
	inherited CommonSetup;
	iName     := nil;
	iValue    := nil;
	iReadOnly := false;
end;

function TConfigVarItem.IsName(const ParName : string):boolean;
begin
	exit(iName.IsEqualStr(ParName));
end;


procedure   TConfigVarItem.SetName(const ParName:String);
var vlName : string;
begin
	vlName := ParName;
	UpperStr(vlName);
	if iName <> nil then iName.destroy;
	iName := TString.Create(vlName);
end;


function   TConfigVarItem.SetValueUnchecked(ParValue : TValue):boolean;
begin
	if iValue <> nil then iValue.destroy;
	iValue := ParValue;
	exit(False);
end;

function   TConfigVarItem.SetValue( ParValue:TValue):boolean;
begin
	if fReadOnly then exit(true);
	if SetValueUnchecked(ParValue) then exit(true);
	exit(false);
end;

constructor TConfigVarItem.Create(const ParName     : string;
ParValue    : TValue;
ParReadOnly : boolean);
begin
	inherited Create;
	SetValue(ParValue);
	SetName(ParName);
	iReadOnly := ParReadOnly;
end;

procedure  TConfigVarItem.Clear;
begin
	inherited clear;
	if iName <> nil  then iName.destroy;
	if iValue <> nil then iValue.destroy;
end;

{----( TLoadNodeList )------------------------------------------------------}

function TConfigVarList.AddVar(const ParName,ParValue:string;ParReadOnly:boolean) :TConfigVarItem;
begin
	exit(TConfigVarItem(InsertAtTop(TCOnfigVarItem.Create(ParName,TString.Create(ParValue),ParReadOnly))));
end;


function TConfigVarList.GetPtrByName(const ParName:string):TConfigVarItem;
var vlCurrent : TConfigVarItem;
	vlName    : string;
begin
	vlName := ParName;
	UpperStr(vlName);
	vlCurrent := TConfigVarItem(fStart);
	while (vlCurrent <> Nil) and not(vlCurrent.IsName(vlName)) do vlCurrent := TConfigVarItem(vlCurrent.fNxt);
	exit( vlCurrent);
end;

function TConfigVarList.GetValueByName(const ParName:String;var ParValue: string):boolean;
var vlCurrent : TConfigVarItem;
	vlValue   : TValue;
begin
	EmptyString(ParValue);
	vlCurrent := GetPtrByName(ParName);
	if vlCurrent <> nil then begin
		vlValue := vlCurrent.fValue;
		vlValue.GetString(ParValue);
		vlValue.Destroy;
	end;
	exit (vlCurrent = nil);
end;

end.
