{    Elaya, the compiler for the elaya language
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

unit DIdentLs;

interface
uses useitem,strmbase,streams,cmp_type,stdobj,linklist,compbase,display,elacons,hashing,DDefault,DDefinit,elatypes,error;
	
type
	TIdentList=class(TList)
	private
		voDoneHashing : boolean;
		voHashing     : THashing;
		voDefaultList : TDefaultList;
		voGlobal      : boolean;
		property  iDoneHashing : boolean  read voDoneHashing     write voDoneHashing;
		property  iHashing     : THashing read voHashing         write voHashing;
		property  iDefaultList : TDefaultList read voDefaultList write voDefaultList;
		property  iGlobal      : boolean      read voGlobal    write voGlobal;
	protected
		procedure Clear;override;
	public
		property  fDoneHashing   : boolean      read voDoneHashing;
		property  fHashingObject : THashing     read voHashing;
		property  fDefaultList   : TDefaultLIst read voDefaultList;
		property  fGlobal  	     : boolean      read voGlobal    write voGLobal;
		procedure Print(ParDis:TDisplay);
		procedure SetHashingObject(ParHash:THashing);
		procedure SetHashing(ParObj:TDefinition);
		procedure AddGlobalsToHashing(ParHash:THashing);
		procedure initHashing;
		function  GetHashing(const ParName:string):TDefinition;
		procedure initDefaultList;
		procedure MoveDefaultsToList;
		procedure AddToDefaultList(ParDef:TDefinition);
		function  Addident(Parident:TDefinition):TErrorType;virtual;
		function  AddidentAt(ParAt,Parident:TDefinition):TErrorType;virtual;
		
		function  saveitem(ParWrite:TObjectStream):boolean;override;
		function  LoadItem(ParWrite:TObjectStream):boolean;override;
		function  GetPtrByName(const ParText:string;var ParOwner,ParItem:TDefinition):boolean;
		function  GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition):TObjectFindState;
		function  GetDefaultIdent(ParDefault:TDefaultTypeCode;ParSize : TSize;ParSign:boolean):TDefinition;
		function  CreateDB(PArcre:TCreator):boolean;
		function  Validate(ParDef:TDefinition):TErrorType;virtual;
		procedure  commonsetup;override;
		procedure  AddToHashing;
		procedure AddItemsToUseList(ParUse : TUseList);

	end;
	
implementation

{-----( TIdentList )-----------------------------------------------}



procedure TIdentList.AddItemsToUseList(ParUse : TUseList);
var
	vlCurrent : TDefinition;
begin
	vlCurrent := TDefinition(fStart);
	while vlCurrent <> nil do begin

		ParUse.AddItem(vlCurrent.CreateDefinitionUseItem);
		vlCurrent := TDefinition(vlCurrent.fNxt);
	end;
end;

	procedure TIdentList.Print(ParDis:TDisplay);
	var vlCurrent:TIdentBase;
	begin
		vlCurrent := TIdentBase(fStart);
		while vlCurrent <> nil do begin
			vlCurrent.Print(ParDis);
			ParDis.nl;
			vlCurrent := TIdentBase(vlCurrent.fNxt);
		end;
	end;


procedure TIdentList.SetHashingObject(ParHash:THashing);
begin
	if (fHashingObject <>nil) and (fDoneHashing) then fHashingObject.Destroy;
	iHashing     := parHash;
	iDoneHashing := (False);
end;


procedure TIdentList.initHashing;
begin
	iHashing     := THashing.Create;
	iDoneHashing := true;
end;

function  TIdentList.GetHashing(const ParName:string):TDefinition;
begin
	GetHashing := nil;
	if fHashingObject <> Nil then begin
		GetHashing := TDefinition(fHashingObject.GetHashIndex(ParName));
	end;
end;

procedure TIdentList.SetHashing(ParObj:TDefinition);
begin
	if fHashingObject <> nil then ParObj.AddToHashing(fHashingObject);
end;

procedure TIdentList.initDefaultList;
begin
	iDefaultList := TDefaultList.Create;
end;


procedure TIdentList.AddToDefaultList(ParDef:TDefinition);
begin
	iDefaultList.AddDefault(ParDef);
end;


procedure TIdentList.commonsetup;
begin
	inherited commonsetup;
	initDefaultList;
	iHashing := nil;
	iGlobal  := false;
end;

procedure TIDentList.Clear;
begin
	inherited Clear;
	if iDefaultList <> nil then iDefaultList.Destroy;
	if (fHashingObject <> nil) and (fDoneHashing) then fHashingOBject.Destroy;
end;




function TIdentList.CreateDB(PArcre:TCreator):boolean;
var vLCurrent:TDefinition;
begin
	vlCurrent := TDefinition(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent.CreateDB(Parcre) then exit(true);
		vlCurrent := TDefinition(vlCurrent.fNxt);
	end;
	exit(false);
end;



procedure TIdentList.MoveDefaultsToList;
var vlCurrent:TDefinition;
begin
	vlCurrent := TDefinition(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent.fDefault <> DT_Nothing then AddTODefaultList(vlCurrent);
		vlCurrent := TDefinition(vlCurrent.fNxt);
	end;
end;


function TIdentList.LoadItem(ParWrite:TObjectStream):boolean;
var vlGlobal : boolean;
begin
	LoadItem := true;
	if ParWrite.ReadBoolean(vlGlobal) then exit;
	iGlobal := vlGlobal;
	if inherited LoadItem(parWrite) then exit;
	MoveDefaultsToList;
	LoadItem := false;
end;


function TIdentList.saveitem(ParWrite:TObjectStream):boolean;
var vlCurrent:TDefinition;
begin
	vlCurrent := TDefinition(fStart);
	saveitem := true;
	if ParWrite.WriteBoolean(iGlobal) then exit;
	while vlCurrent <> nil do begin
		if vlCurrent.MustSaveItem then begin
			if vlCurrent.saveitem(ParWrite) then exit;
		end;
		vlCurrent := TDefinition(vlCurrent.fNxt);
	end;
	if ParWrite.WriteLongint(IC_End_Mark) then exit;
	SaveItem := false;
end;



function TIdentList.GetDefaultIdent(ParDefault:TDefaultTypeCode;ParSize : TSize;ParSign:boolean):TDefinition;
begin
	GetDefaultIdent :=iDefaultList.GetDefaultBySize(ParDefault,ParSize,ParSign);
	if ParDefault = DT_Nothing then begin
		GetDefaultIdent := nil;
		exit;
	end;
end;

function TIdentList.AddidentAt(ParAt ,Parident:TDefinition):TErrorType;
var
	vlError : TErrorType;
begin
	vlError := Err_No_Error;
	if ParIdent <>nil then begin
		if ParIdent.fDefAccess=AF_Current then begin
			fatal(FAT_Prot_Is_Current,['class=',ParIdent.ClassName]);
		end;
		vlError := Validate(ParIdent);
		insertAt(ParAt,Parident);
		if (fHashingObject<> nil) and (fDoneHashing or fGlobal) then SetHashing(ParIdent);
		ParIdent.SetHashingObject(fHashingobject);
		if ParIdent.fDefault <> DT_Nothing then AddToDefaultList(ParIdent);
	end;
    exit(vlError);
end;

function TIdentList.AddIdent(ParIdent :TDefinition) : TErrorType;
begin
	exit(AddIdentAt(TDefinition(fTop),ParIDent));
end;


function TIdentList.Validate(ParDef:TDefinition):TErrorType;
var
	vlStr   : string;
	vlPtr   : TDefinition;
	vlOwner : TDefinition;
begin
	ParDef.GetTextStr(vlStr);
	Validate := Err_No_Error;
	if GetPtrByObject(vlStr,ParDef,vlOwner,vlPtr) = OFS_Same then Validate := Err_Duplicate_Ident;
end;



function TIdentList.GetPtrByName(const ParText:string;var ParOwner,ParItem:TDefinition):boolean;
var
 vlCurrent : TDefinition;
begin
	ParOwner := nil;
	if (fHashingObject <> nil) and (fDoneHashing) then begin
		vlCurrent := GetHashing(ParText);
		while (vlCurrent <> nil) and Not(vlCurrent.fText.IsEqualStr(ParText))
		do begin
			vlCurrent := vlCurrent.fHashNext;
		end;
	end else begin
		vlCurrent := TDefinition(fStart);
		while (vlCurrent<> nil) and not(vlCurrent.IsSameText(ParText)) do begin
			if vlCurrent.GetPtrByName(ParText,[SO_Global],ParOwner,ParItem) then exit(true);
			vlCurrent := TDefinition(vlCurrent.fNxt);
		end;
	end;
	ParOwner := nil;
	ParItem  := vlCurrent;
	exit(vlCurrent <> nil);
end;

function TIdentList.GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition):TObjectFindState;
var vlDef : TDefinition;
	vlOwner : TDefinition;
	vlName  :string;
begin
	ParOwner := nil;
	if  GetPtrByName(ParName,vlOwner,vlDef) then begin
		if vlDef.IsSameByObject(ParName,ParObject) =OFS_Same then begin
			ParResult := vlDef;
			vlDef.GetTextStr(vlName);
			exit(OFS_Same);
		end;
		exit(vlDef.GetPtrByObject(ParName,ParObject,[SO_Global],ParOwner,ParResult));
	end;
	ParResult := nil;
	exit(Ofs_Different);
end;


procedure TIdentList.AddToHashing;
var vlCurrent:TDefinition;
begin
	vlCurrent := TDefinition(fStart);
	while vlCurrent <> nil do begin
		SetHashing(vlCurrent);
		vlCurrent := TDefinition(vlCurrent.fNxt);
	end;
end;

procedure TIdentList.AddGlobalsToHashing(ParHash:THashing);
var vlCurrent:TDefinition;
begin
	vlCurrent := TDefinition(fStart);
	if fGlobal then begin
		while vlCurrent <> nil do begin
			vlCurrent.AddTOHashing(ParHash);
			vlCurrent := TDefinition(vlCurrent.fNxt);
		end;
	end;
end;



end.
