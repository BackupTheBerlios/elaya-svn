
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

unit config;

interface
uses confdef,confnode,sysutils,stdobj,progutil;
type
	
	TConfig=class(TRoot)
	private
		voProgram              : TRootCOnfigNode;
		voVariables            : TConfigVarList;
		
		property  iProgram     : TRootConfigNode read voProgram write voProgram;
		property  iVariables   : TConfigVarList  read voVariables  write voVariables;
	protected
		procedure Clear;override;
		procedure Commonsetup;override;
	public
		property  fProgram   : TRootConfigNode read voProgram;
		function  AddVar(const ParVar,ParValue:ansistring):TConfigVarItem;
		function  AddVar(const ParVar,ParValue:ansistring;ParReadOnly:boolean):TCOnfigVarItem;
		function  GetVar(const ParVar :ansistring) : TConfigVarItem;
		function  GetVarValue(const ParVar : ansistring;var ParValue : ansistring):boolean;
		function  GetVarUpperValue(const ParVar : ansistring;var ParValue : ansistring):boolean;
		function  GetVarUpperBool(const ParVar : ansistring;var ParValue : boolean):boolean;
		function  GetVarInt(const ParVar : ansistring;var ParValue : longint):boolean;
		function  SetVarConst(const ParVar,ParValue:ansistring):boolean;
		function  SetVar(const ParVar,ParValue : ansistring) : boolean;
		procedure Execute;
		procedure AddOrSetVar(const ParName,ParValue : ansistring;ParReadOnly : boolean);
	end;
	
implementation
procedure TConfig.AddOrSetVar(const ParName,ParValue : ansistring;ParReadOnly : boolean);
begin
	if GetVar(ParName) <> nil then begin
		SetVar(ParName,ParValue);
	end else begin
		AddVar(ParName,ParValue,ParReadOnly);
	end;
end;

function TConfig.GetVarUpperValue(const ParVar : ansistring;var ParValue : ansistring):boolean;
var
	vlCheck : boolean;
begin
	vlCheck := GetVarValue(ParVar,ParValue);
	UpperStr(ParValue);
	exit(vlCheck);
end;

function  TConfig.GetVarUpperBool(const ParVar : ansistring;var ParValue : boolean):boolean;
var vlStr   : ansistring;
	vlCheck : boolean;
begin
	vlCheck := GetVarUpperValue(ParVar,vlStr);
	ParValue := (vlStr='Y') or (vlStr='YES') or (vlStr='TRUE');
	exit(vlCheck);
end;

function TCOnfig.GetVarInt(const ParVar : ansistring; var ParValue : longint):boolean;
var  vlStr   : ansistring;
	vlCheck : boolean;
	vlErr   : integer;
begin
	vlCheck := GetVarValue(ParVar,vlStr);
	val(vlStr,ParValue,vlErr);
	vlCheck := vlCheck and (vlErr = 0);
	exit(vlCHeck);
end;



function TConfig.SetVarConst(const ParVar,ParValue:ansistring):boolean;
var vlVar : TConfigVarItem;
begin
	vlVar := GetVar(ParVar);
	if vlVar <> nil then vlVar.SetValueUnchecked(TString.Create(ParValue));
	exit(vlVar <> nil);
end;


function TConfig.SetVar(const ParVar,ParValue : ansistring):boolean;
var vlVar : TConfigVarItem;
begin
	vlVar := GetVar(ParVar);
	if vlVar <> nil then vlVar.SetValue(TString.Create(ParValue));
	exit(vlVar <> nil);
end;




procedure  TConfig.Commonsetup;
begin
	inherited Commonsetup;
	iProgram          := TRootConfigNode.Create;
	iVariables        := TConfigVarList.Create;
	
end;

procedure TConfig.Clear;
begin
	inherited Clear;
	if iProgram     <> nil then iProgram.Destroy;
	if iVariables  <> nil then iVariables.Destroy;
end;


procedure TConfig.Execute;
begin
	iProgram.Execute;
end;


function  TConfig.AddVar(const ParVar,ParValue:ansistring):TConfigVarItem;
begin
	exit(AddVar(ParVar,ParValue,false));
end;

function  TConfig.AddVar(const ParVar,ParValue:ansistring;ParReadOnly:boolean):TConfigVarItem;
begin
	if GetVar(ParVar) <> nil then raise EDuplicatedVariable.Create(ParVar,0,0);
	exit( iVariables.AddVar(ParVar,ParValue,ParReadOnly));
end;

function  TConfig.GetVar(const ParVar :ansistring) : TConfigVarItem;
var vlStr:ansistring;
begin
	vlStr := ParVar;
	UpperStr(vlStr);
	exit( iVariables.GetPtrByName(vlStr));
end;

function  TConfig.GetVarValue(const ParVar : ansistring;var ParValue : ansistring):boolean;
var vlVar : TConfigVarItem;
	vlVal : TValue;
	vLStr : ansistring;
begin
	vlVar := GetVar(ParVar);
	if vlVar <> nil then begin
		vlVal := vlVar.fValue;
		vlVal.GetString(vlStr);
	end
	else EmptyString(vlStr);
	ParValue := vlStr;
	exit(vlVar <> nil);
end;


end.
