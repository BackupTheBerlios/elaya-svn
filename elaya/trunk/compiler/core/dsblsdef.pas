{    Elaya, the compiler for the elaya language                                   Root                                                                                                                              j
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

unit DSbLsDef;
interface
uses streams,stdobj,cmp_type,elatypes,display,elacons,ddefinit,error,hashing,didentls;
type
	
	TSublistDef = class(TDefinition)
	private
		voParts     : TIdentList;
    protected
      property   iParts : TIdentList read voParts write voParts;
		procedure   Commonsetup;override;
		procedure   clear;override;
		procedure   initParts;virtual;


	public
		property   fParts:TIdentList read voParts;
		
		procedure   SetHashingObject(Parhash:THashing);override;
		{function    Validate(ParIdent : TDefinition):TErrorType;}
		function    Addident(Parident:TDefinition):TErrorType;override;
		function    SearchOwner:boolean;virtual;
		function    GetDefaultIdent(ParCode : TDefaultTypeCode;ParSize:TSize;ParSign:boolean):TDefinition;
		procedure   PrintParts(ParDis:TDisplay);
		function    loaditem(ParWrite:TObjectStream):boolean;override;
		function    saveitem(ParWrite:TObjectStream):boolean;override;
		procedure   AddGlobalsToHashing(ParHash:THashing);override;
		function    GetPtrByName(const ParName:string;ParOption :TSearchOptions;var ParOwner,ParItem:TDefinition):boolean;override;
		function    GetPtrByObject(const ParName : string;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;override;
		function    GetPtrByArray(const ParName : string;const ParArray : array of TRoot;ParOption :TSearchOptions;var PArOwner,ParResult : TDefinition) : TObjectFindState;override;
		function    HasGlobalParts : boolean;override;
	end;
	
	
	
implementation

{-----(TSubListDef )---------------------------------------------}

function  TSubListDef.HasGlobalParts : boolean;
begin
	exit(iParts.fGlobal);
end;


function TSubListDef.SearchOwner:boolean;
begin
	exit(true);
end;

function TSubListDef.GetPtrByObject(const ParName : string;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;
begin
	
	if  iParts.fGlobal or not(SO_Global in ParOption) then begin
		if iParts <> nil then begin
			if (iParts.GetPtrByObject(ParName,ParObject,ParOwner,ParResult)<> Ofs_Different) then begin
				if ParOwner = nil then ParOwner := self;
				exit(OFS_Same);
			end;
		end;
	end;
	ParResult := nil;
	ParOwner := nil;
	exit(Ofs_Different);
end;

function TSubListDef.GetPtrByArray(const ParName : string;const ParArray : Array of TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;
begin
	
	if  iParts.fGlobal or not(SO_Global in ParOption) then begin
		if iParts <> nil then begin
			
			if (iParts.GetPtrByArray(ParName,ParArray,ParOwner,ParResult)<> Ofs_Different) then begin
				if ParOwner = nil then ParOwner := self;
				exit(OFS_Same);
			end;
		end;
	end;
	ParResult := nil;
	ParOwner := nil;
	exit(Ofs_Different);
end;


procedure TSubListDef.SetHashingObject(Parhash:THashing);
begin
	if iParts <> nil then iParts.SetHashingObject(ParHash);
end;


procedure TSubListDef.COmmonsetup;
begin
	inherited Commonsetup;
	iParts := nil;
	initParts;
	
end;

procedure TSubListDef.initParts;
begin
	iParts := TIdentList.Create;
end;

function TSubListDef.GetDefaultIdent(ParCode:TDefaultTypeCode;ParSize:TSize;ParSign:boolean):TDefinition;
begin
	if iParts <> nil then begin
		exit(iParts.GetDefaultIdent(ParCode,ParSize,parSign));
	end else begin
		if (iOwner <> nil) and (searchOwner) then exit(iOwner.GetDefaultIdent(ParCode,ParSize,ParSign));
	end;
end;


function TSubListDef.GetPtrByName(const ParName:string;ParOption : TSearchOptions;var ParOwner,ParItem:TDefinition):boolean;
begin
	
	if (iParts <> nil) and (not(SO_Global in ParOption) or iParts.fGlobal) then begin
		if iParts.GetPtrByName(ParName,ParOwner,ParItem) then begin
			if ParOwner = nil then ParOwner := self;
			exit(true);
		end;
	end;
	ParOwner := nil;
	ParItem  := nil;
	exit(false);
end;


{function TSubListDef.Validate(ParIdent : TDefinition):TErrorType;
begin
	exit(Err_No_Error);
end;                                                           }

function TSubListDef.Addident(Parident:TDefinition):TErrorType;
begin
	if iParts = nil then initParts;
	exit(iParts.Addident(Parident));
end;


procedure TSubListDef.PrintParts(ParDis:TDisplay);
begin
	iParts.Print(ParDis);
end;


procedure TSubListDef.Clear;
begin
	inherited Clear;
	if iParts <> nil then iParts.Destroy;
end;

function TSubListDef.SaveItem(ParWrite:TObjectStream):boolean;
begin
	SaveItem :=true;
	if inherited SaveItem(ParWrite)     then exit;
	if (iParts <> nil) then begin
		if  (iParts.saveitem(ParWrite)) then exit;
	end;
	SaveITem := false;
end;


procedure   TSubListDef.AddGlobalsToHashing(ParHash:THashing);
begin
	if iParts <> nil then iParts.AddGlobalsToHashing(ParHash);
end;


function TSubListDef.LoadITem(ParWrite:TObjectStream):boolean;
begin
	LoadItem := true;
	if inherited LoadItem(ParWrite) then exit;
	if (iParts <> nil) and (iParts.LoadItem(Parwrite)) then exit;
	LoadItem := false;
end;


end.
