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
unit globlist;
interface
uses error,linklist,elacons,hashing,compbase,streams,ddefinit;
type TGlobalItem=class(TListItem)
	private
		voNextHash : TGlobalItem;
		voIdent    : TDefinition;
	protected
		property iNextHash : TGlobalItem read voNextHash write voNextHash;
		property iIdent    : TDefinition read voIdent    write voIdent;
	public
		property fNextHash : TGlobalItem read voNextHash write voNextHash;
		
		constructor Create(ParIdent : TDefinition);
		function SaveItem(ParRead : TObjectStream):boolean;override;
		function LoadItem(ParRead : TObjectStream):boolean;override;
		procedure GetIdentName(var ParName : string);
		function HasSameName(const ParName :String):boolean;
	end;
	
	TGlobalList=class(TList)
	private
		voHashing : THashing;
		property iHashing : THashing read voHashing write voHashing;

	public
		
		function    ExistsIdent(ParDef : TDefinition):boolean;
		procedure   AddGlobalOnce(ParCre : TCreator;ParItem : TDefinition);
		procedure   AddListToHash(ParCre :TCreator;ParHashing : THashing);
		procedure   ValidateGlobal(ParCre : TCreator;ParItem : TGlobalItem);
		procedure   AddGlobal(ParCre : TCreator;ParItem : TDefinition);
	end;
	
implementation

uses ndcreat;

{--( TGLobalList )--------------------------------------------------------------------------------------}

function  TGlobalList.ExistsIdent(ParDef : TDefinition):boolean;
var
	vlCurrent2 : TGlobalItem;
	vlThisName : string;
begin
	
	ParDef.GetMangledName(vlThisName);
	vlCurrent2 := TGlobalItem(iHashing.GetHashIndex(vlThisName));
	while(vlCurrent2 <> nil) and ( not(vlCurrent2.HasSameName(vlThisName)) ) do vlCurrent2 := vlCurrent2.fNextHash;
	exit(vlCurrent2 <> nil);
	
end;


procedure TGlobalList.AddGlobalOnce(ParCre : TCreator;ParItem : TDefinition);
begin
	if not ExistsIdent(ParItem) then begin
		AddGLobal(ParCre,ParItem);
	end;
end;

procedure TGlobalList.ValidateGlobal(ParCre : TCreator;ParItem : TGlobalItem);
var
	vlCurrent2 : TGlobalItem;
	vlThisName : string;
begin
	ParItem.GetIdentName(vlTHisName);
	vlCurrent2 := ParItem.fNextHash;
	while(vlCurrent2 <> nil) and ( not(vlCurrent2.HasSameName(vlThisName)) ) do vlCurrent2 := vlCurrent2.fNextHash;
	if(vlCurrent2 <> nil)then  begin
		TNDCreator(ParCre).ErrorText(Err_Glob_Exists_in_dep_units,vlThisName);
	end;
end;


procedure TGlobalList.AddGlobal(ParCre : TCreator;ParItem : TDefinition);
var
	vlThisName : string;
	vlCurrent  : TGlobalItem;
begin
	vlCurrent := TGLobalItem.Create(ParItem);
	vlCurrent.GetIdentName(vlThisName);
	vlCurrent.fNextHash := TGlobalItem(iHashing.SetHashIndex(vlThisName,vlCurrent));
	insertAtTop(vlCUrrent);
	ValidateGlobal(ParCre,vlCurrent);
end;


procedure TGlobalList.AddListToHash(ParCre :TCreator;ParHashing : THashing);
var
	vlCurrent : TGLobalItem;
	vlThisName : string;
begin
	vlCurrent := TGlobalItem(fStart);
	iHashing := ParHashing;
	while(vlCurrent <> nil) do begin
		vlCurrent.GetIdentName(vlThisName);
		vlCurrent.fNextHash := TGlobalItem(iHashing.SetHashIndex(vlTHisName,vlCurrent));
		ValidateGlobal(ParCre,vlCurrent);
		vlCurrent := TGlobalItem(vlCurrent.fNxt);
	end;
end;


{--( TGlobalItem )--------------------------------------------------------------------------------------}



procedure TGLobalItem.GetIdentName(var ParName : string);
begin

	iIdent.GetMangledName(ParName);
end;

function TGlobalItem.HasSameName(const ParName :String):boolean;
var
	vlName :string;
begin
	GetIdentName(vlName);
	exit(vlName=ParNAme);
end;

constructor TGlobalItem.Create(ParIdent : TDefinition);
begin
	iIdent := ParIdent;
	inherited Create;
end;

function TGlobalItem.SaveItem(ParRead : TObjectStream):boolean;
begin
	if inherited SaveItem(ParRead) then exit(true);
	if ParRead.WritePi(iIdent) then exit(true);
	exit(false);
end;

function TGlobalItem.LoadItem(ParRead : TObjectStream):boolean;
begin
	if inherited LoadItem(ParRead) then exit(true);
	if ParRead.ReadPi(voIdent) then exit(true);
	exit(False);
end;


end.

