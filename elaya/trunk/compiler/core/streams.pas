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
unit streams;
interface

uses strmbase,files,simplist,stdobj,progutil,listbind,error,elatypes,elacons;


type
	
	TModule       = class;
	TObjectStream = class;
	TStrAbelRoot  = class(TRoot)
	private
		voCode   : TIdentNumber;
		voModule : TModule;
	protected
		property iCode      : TIdentNumber read voCode   write voCode;
		property iModule    : TModule	   read voModule write voModule;
		
	public
		
		property    fCode   : TIdentNumber read voCode    write voCode;
		property    fModule : TModule      read voModule;
		
		constructor Create;
		constructor Load(ParWrite:TObjectStream);
		function    LoadItem(ParWrite:TObjectStream):boolean;virtual;
		function    SaveItem(ParWrite:TObjectStream):boolean;virtual;
		procedure   SetModule(ParModule:TModule);
	end;
	
	TClassStrAbelRoot = class of TStrAbelRoot;
	
	TModule=class(TStrAbelRoot)
	private
		voPtrList     : TPtrList;
		voObjectCnt   : longint;
	protected
		property    fPtrList    : TPtrList        read voPtrList    write voPtrList;
	public
		function    GetNexTIdentNumber:TIdentNumber;
		procedure   CommonSetup;override;
		procedure   GetModuleName(var ParName:String);virtual;
		procedure   doBind;
		procedure   AddToPtrList(ParCode : TIdentNumber;ParObject : TStrAbelRoot);
		procedure   AddToPtrList(ParObject:TStrAbelRoot);
		function    GetPtrByNum(ParNum:TIdentNumber):TStrAbelRoot;
		function    ConvertPtrToCode(ParObject:TStrAbelRoot):TIdentNumber;
		procedure   CleanupLoad;
		procedure   Clear;override;
		procedure   AddBind(ParCode:TIdentNumber;ParItem : Pointer);
		procedure   AddBindModule(ParItem,ParModule : TIdentNumber;ParDest : pointer);
	end;
	
	
	TObjectStreamItem=class(TSMListITem)
	private
		voType        : TIdentNumber;
		voVmtAddress  : TClassStrAbelRoot;
	public
		property    fType        : TIdentNumber        read voType;
		property    fVmtAddress  : TClassStrAbelRoot read voVmtAddress;
		
		constructor Create(ParCode : TIdentNumber;ParVmtAddress:TClassStrAbelRoot);
	end;
	
	
	TObjectStreamList=class(TSMList)
	public
		procedure   AddObject(ParType : longint;ParVmtAddress:TClassStrAbelRoot);
		function    GetIdentNumber(ParVmt:TClassStrAbeLRoot;var ParType:longint):boolean;
		function    GetPtrByType(ParCode:longint):TClassStrAbelRoot;
	end;

TModuleLoadItem=class(TSMTextItem)
private
	voModuleObj:TModule;
	property iModuleObj : TModule read voModuleObj write voModuleObj;

public
	property fModuleObj : TModule read voModuleObj;
	procedure   DoBind;
	constructor Create(const ParModuleName:string;ParModule:TModule);
end;


TModuleLoadList=class(TSMTextList)
public
	procedure DoBind;
	procedure AddModule(const ParModule:string;ParModuleObj:TModule);
end;



TStream=class(TStrAbelRoot)
private
	voBufferFile : TFile;
	voHashing    : longint;
	voName       : string;
	voOpen       : boolean;
	voOsError    : cardinal;
	voElaErr     : cardinal;
protected
	property    iHashing     : longint read voHashing write voHashing;
	property    iName        : string  read voName    write voName;
	property    iOpen		 : boolean read voOpen    write voOpen;
	property    iOsError	 : cardinal read voOsError write voOsError;

	procedure clear;override;
public
	constructor Create;
	
	property    fBufferFile : TFile    read voBufferFile;
	property    fHashing    : longint  read voHashing write voHashing;
	property    fName	    : string   read voName;
	property    fElaErr	    : cardinal read voElaErr;
	function    GetFilePos:longint;
	procedure   WriteDirect(parPos:Longint;var ParInfo;ParSize:cardinal);
	procedure   ReadDirect(var ParInfo;ParSize:cardinal);
	function    OpenFile(const ParName:string):boolean;
	function    CheckType(ParType:byte):boolean;
	function    WriteType(ParType:byte):boolean;
	function    CreateFile(const ParName:string):boolean;
	function    WriteLongint(ParLongint:Longint):boolean;
	function    WriteLOng(ParLong : cardinal):boolean;
	function    WriteString(const ParStr:string):boolean;
	function    WriteBoolean(ParBool : boolean):boolean;
	function    WriteNumber(ParNumber : TNumber):boolean;
	function    ReadBoolean(var ParBool : boolean):boolean;
	function    ReadNumber(var ParNumber : TNumber):boolean;
	function    ReadLongint(var ParLongint:Longint):boolean;
	function    ReadLong(var ParLongint:cardinal):boolean;
	function    ReadString(var ParStr:string):boolean;
	function    WriteToFile(const vBuf;ParSize:cardinal):boolean;
	function    ReadFromFile(var vBuf;ParSize:cardinal;var ParRead:cardinal):boolean;
	procedure   CloseFile;
	procedure   UpdateHashing(const ParBuf;ParSize:cardinal);
	procedure   GetFileNameStr(var ParName:string);
	procedure   AddPath(const ParDir : string);
end;

TObjectStream=class(TStream)
private
	voModuleLoadList : TModuleLoadList;

   property iModuleloadList :  TModuleLoadList read voModuleLoadList write voModuleLoadList;

protected
   procedure clear;override;
public

	constructor Create;
	procedure   AddModule(const ParModule:string;ParModuleObj:TModule);
	function    GetModuleLoadItemByName(const ParName:string):TModuleLoadITem;
	procedure   ConvertItemPtr(ParItem:TStrAbelRoot;var ParNum,ParModule:TIdentNumber);
	procedure   AddToPtrList(ParObject:TStrAbelROot);
	procedure   AddToPtrList(ParCode : TIdentNumber;ParObject : TStrAbelRoot);
	function    WritePI(ParPtr:TStrAbelRoot):boolean;
	function    WritePst(ParPst:TString):boolean;
	function    ReadPi(var ParPtr:TStrAbelRoot):boolean;
	function    ReadPst(var ParPst:TString):boolean;
	function    ReadValue(var ParValue : TValue) : boolean;
	function    WriteValue(ParValue : TValue) : boolean;
	procedure   DoBind;
	procedure   AddBind(ParItem,ParModule:TIdentNumber; ParDest : pointer);
	function    WriteClassHeader(ParItem : TStrAbelRoot):boolean;
	function    GetNexTIdentNumber : TIdentNumber;
end;

TModuleItemBase=class(TSMListItem)
private
	voModuleItem : TModule;
protected
	property  iModuleItem : TModule read voModuleItem write voModuleItem;
	procedure CommonSetup;override;

public
	property  fModuleItem : TModule read voModuleItem;
end;



procedure AddObjectToStreamList(ParCode : longint;ParVmtAddress:TClassStrAbelRoot);
function  GetObjectStreamType(ParVmtAddress:TClassStrAbelRoot;var ParType:TIdentNumber):boolean;
function  GetPtrByType(ParType:TIdentNumber):TClassStrAbelRoot;
function  CreateObject(ParWriter:TObjectStream;var ParObj:TStrAbelRoot):cardinal;

var     vgObjectStreamList:TObjectStreamList;
	
implementation


{-----( TModuleItemBase )----------------------------------}

procedure TModuleitemBase.Commonsetup;
begin
	inherited COmmonsetup;
	iModuleItem := nil;
end;




{-----( TModuleLoadItem )-----------------------------------}

constructor TModuleLoadItem.Create(const ParModuleName:string;ParModule:TModule);
begin
	inherited Create(ParModuleName);
	iModuleObj := ParModule;
end;

procedure TModuleLoadItem.DoBind;
begin
	iModuleObj.DoBind;
end;


{-----( TModuleLoadList )-----------------------------------}



procedure TModuleLoadList.doBind;
var vlCurrent:TModuleLoadITem;
begin
	vlCurrent := TModuleLoadITem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.DoBind;
		vlCurrent := TModuleLoadITem(vlcurrent.fNxt);
	end;
end;


procedure TModuleLoadList.AddModule(const ParModule:string;ParModuleObj:TModule);
var vlCurrent:TModuleLoadITem;
begin
	vlCurrent := TModuleLoadITem(GetptrByName(nil,ParModule));
	if vlCurrent = nil then begin
		vlCUrrent := TModuleLoadItem.Create(ParModule,ParModuleObj);
		InsertAtTop(vlCurrent);
	end;
end;




{----( TStrAbelRoot )----------------------------------------------}



function TStrAbelRoot.LoadItem(ParWrite:TObjectStream):boolean;
var vlCode   : TIdentNumber;
	vlModule : TIdentNumber;
begin
	LoadItem := true;
	if ParWrite.ReadLongint(vlCode)   then exit;
	if ParWrite.Readlongint(vlModule) then exit;
	iCode := vlCode;
	SetModule(ParWrite.fModule);
	ParWrite.AddToPtrList(self);
	LoadItem := false;
end;


function TStrAbelRoot.SaveItem(ParWrite:TObjectStream):boolean;
begin
	SaveItem := true;
	if ParWrite.WriteClassHeader(self) then exit;
	SaveItem := false;
end;

procedure TStrAbelRoot.SetModule(ParModule:TModule);
begin
	iModule := ParModule;
end;

constructor TStrAbelRoot.Load(ParWrite:TObjectStream);
begin
	inherited Create;
	if loadItem(ParWrite) then begin
		clear;
		fail;
	end;
end;

constructor TStrAbelRoot.Create;
begin
	inherited Create;
	iCode   := IC_No_Code;
	iModule := nil;
end;


{---( TModule )-------------------------------------------}

procedure  TModule.AddBind(ParCode:TIdentNumber;ParItem:Pointer);
begin
	fPtrList.AddBind(ParCode,ParItem);
end;

procedure  TModule.CleanupLoad;
begin
	if fPtrList <> nil then fPtrList.destroy;
	fPtrList := nil;
end;

procedure  TModule.GetModuleName(var ParName:String);
begin
	EmptyString(ParName);
end;

function TModule.ConvertPtrToCode(ParObject:TStrAbelRoot):TIdentNumber;
begin
	if ParObject.fCode = IC_No_Code then ParObject.iCode := GetNextIdentNumber;
	ConvertPtrToCode := ParObject.fCode;
end;

procedure TModule.doBind;
begin
	fPtrList.Bind;
	fPtrList.Destroy;
	fPtrList := nil;
end;


procedure TModule.AddToPtrList(ParCode : TIdentNumber;ParObject : TStrAbelRoot);
begin
	fPtrList.AddPtr(ParCode,ParObject);
end;

procedure TModule.AddToPtrList(ParObject:TStrAbelRoot);
begin
	AddToPtrList(ParObject.fCode,ParObject);
end;

function  TModule.GetPtrByNum(ParNum:TIdentNumber):TStrAbelRoot;
begin
	GetPtrByNum := TStrAbelRoot(fPtrList.GetPtrByNum(ParNum));
end;

function TModule.GetNextIdentNumber:TIdentNumber;
begin
	inc(voObjectCnt);
	GetNexTIdentNumber := TIdentNumber(voObjectCnt);
end;


procedure TModule.CommonSetup;
begin
	inherited commonsetup;
	fPtrList      := TPtrList.Create;
	voObjectCnt   := 0;
end;

procedure TModule.Clear;
begin
	if fPtrList <> nil then fPtrList.destroy;
	inherited Clear;
end;


procedure TModule.AddBindModule(ParItem,ParModule:TIdentNumber ; ParDest : pointer);
var
	vlModule : TMOdule;
begin
	if ParModule <> IC_No_Code then begin
		vlModule := TModule(GetPtrByNum(ParModule));
		if vlModule = nil then Fatal(Fat_Invalid_Module,['Item=',cardinal(ParItem),' Module=',cardinal(ParModule)]);
	end else begin
		vlModule := self;
	end;
	vlModule.AddBind(ParItem,ParDest);
end;
{---( TObjectStreamList )------------------------------------------}


procedure TObjectStreamList.AddObject(ParType : longint;ParVmtAddress:TClassStrAbelRoot);
var
	vlItem : TObjectStreamItem;
	vlType : TIdentNumber;
begin
	if not GetIdentNumber(ParVmtAddress,vlType) then begin
		vlItem := TObjectStreamItem.Create(ParType,ParVmtAddress);
		insertAt(nil,vlItem);
	end;
end;

function TObjectStreamList.GetPtrByType(ParCode : longint):TClassStrAbelRoot;
var
	vlCurrent:TObjectStreamItem;
begin
	GetPtrByType := nil;
	vlCurrent := TObjectStreamItem(fStart);
	while (vlCurrent<> nil) and (vlcurrent.fType <> ParCode) do vlcurrent := TObjectStreamItem(vlCurrent.fNxt);
	if vlCurrent <> nil then GetPtrByType := vlCurrent.fVmtAddress;
end;

function TObjectStreamList.GetIdentNumber(ParVmt:TClassStrAbelRoot;var ParType : longint):boolean;
var vlCurrent:TObjectStreamItem;
begin
	GeTIdentNumber := false;
	vlCurrent := TObjectStreamItem(fStart);
	while (vlCurrent <> nil) and ((vlCUrrent.fVmtAddress) <> (ParVmt)) do vlCurrent := TObjectStreamItem(vlCurrent.fNxt);
	if vlCurrent <> nil then begin
		ParType := vlCurrent.fType;
		GetIdentNumber := true;
	end;
end;


{---( TObjectStreamItem )------------------------------------------}




constructor  TObjectStreamItem.Create(ParCode : TIdentNumber;ParVmtAddress:TClassStrAbelRoot);
begin
	inherited Create;
	voType      := ParCode;
	voVmtAddress := ParVmtAddress;
end;

{---( TStream )----------------------------------------------------}

procedure  TStream.GetFileNameStr(var ParName:string);
begin
	EmptyString(ParName);
	if fBufferFile <> nil then fBufferFile.GetFileNameStr(ParName);
end;

function   TStream.GetFilePos:longint;
begin
	GetFilePos := fBufferFile.GetFileBufferPos;
end;

procedure   TStream.WriteDirect(parPos:Longint;var ParInfo;ParSize:cardinal);
begin
	fBufferFile.WriteDirect(ParPos,ParInfo,ParSize);
end;

procedure TStream.ReadDirect(var ParInfo;ParSize:cardinal);
begin
	fBufferFile.ReadFromBuffer(ParSize,parInfo);
end;

procedure TStream.clear;
begin
	inherited clear;
	if fBufferFile <> nil then fBufferFile.destroy;
end;


procedure  TStream.AddPath(const ParDir : string);
begin
	fBufferFile.AddPath(ParDir);
end;

constructor TStream.Create;
begin
	inherited Create;
	iOpen    := false;
	iOsError  := 0;
	voElaErr  := 0;
	EmptyString(voName);
	voBufferFile:= TFile.Create(SIZE_ReadBuffer);
end;

function TStream.OpenFile(const ParName:string):boolean;
begin
	fBufferFile.OpenFile(ParName);
	iOsError := fBufferFile.fError;
	if iOsError <> 0 then voElaErr := ERR_Os_Error;
	iOpen    := (voElaErr= 0);
	iHashing := 0;
	OpenFile  := iOpen;
	iName    := ParName;
	exit(not iOpen);
end;

function TStream.WriteToFile(const vBuf;ParSize:cardinal):boolean;
begin
	updateHashing(vBuf,ParSize);
	fBufferFile.WriteTOBuffer(ParSize,vBuf);
	iOsError := fBufferFile.fError;
	if iOsError <> 0 then voElaErr:= Err_Os_Error;
	WriteToFile := voElaErr <> 0;
end;

function TStream.CreateFile(const ParName:string):boolean;
begin
	CloseFile;
	fBufferFile.CreateFile(ParName);
	iOsError    := fBufferFile.fError;
	if iOsError <> 0 then voElaErr := Err_Os_Error;
	iOpen     := (voElaErr = 0);
	iHashing  := 0;
	iName     := ParName;
	exit(not (iOpen));
end;


function TStream.ReadFromFile(var vBuf;ParSize:cardinal;var ParRead:cardinal):boolean;
begin
	fBufferFile.ReadFromBuffer(ParSize,vBuf);
	ParRead  := ParSize;
	iOsError := fBufferFile.fError;
	if iOsError <> 0 then voElaErr := Err_Os_error;
	ReadFromFile := voElaErr <> 0;
	UpdateHashing(vBuf,ParSize);
end;




procedure TStream.CloseFile;
begin
	SetModule(nil);
	fBufferFile.Close;
	iOpen := false;
end;


function    TStream.CheckType(ParType:byte):boolean;
var vlRd   : cardinal;
	vlType : byte;
begin
	if ReadFromFile(vlType,sizeof(ParType),vlRd) then begin
			exit(true);
	end;
	if vlType <> ParType then exit(true);
	exit(false);
end;


function    TStream.WriteType(ParType:byte):boolean;
begin
	WriteType := WriteToFile(ParType,sizeof(ParType));
end;


function TStream.WriteLongint(ParLongint:Longint):boolean;
begin
	WriteLongint := true;
	if WriteType(IU_Longint) then exit;
	if WriteToFile(ParLongint,sizeof(ParLongint)) then exit;
	WriteLongint := false;
end;


function  TStream.WriteLong(ParLong : cardinal):boolean;
begin
	if WriteType(IU_Long) then exit(true);
	if WriteToFile(ParLong,sizeof(ParLong)) then exit(true);
	exit(false);
end;


function  TStream.WriteBoolean(ParBool : boolean):boolean;
begin
	if WriteType(IU_Boolean) then exit(true);
	if WriteToFile(ParBool,sizeof(ParBool)) then exit(true);
	exit(false);
end;

function  TStream.WriteNumber(ParNumber : TNumber):boolean;
begin
	if WriteType(IU_Number) then exit(true);
	if WriteToFile(ParNumber,sizeof(ParNumber)) then exit(true);
	exit(false);
end;

function TStream.WriteString(const ParStr:string):boolean;
var vlBt:byte;
begin
	WriteString := true;
	vlBt := length(ParStr);
	if WriteType(IU_String) then exit;
	if WriteToFIle(vlBt,1) then exit;
	if WriteToFile(ParStr[1],length(ParStr)) then exit;
	WriteString := false;
end;



function TStream.ReadLong(var ParLongint:cardinal):boolean;
var vRd:cardinal;
begin
	ReadLong := true;
	if CheckType(IU_Long) then exit;
	if ReadFromFile(ParLongint,sizeof(ParLongint),vRd) then exit;
	ReadLong := false;
end;

function TStream.ReadLongint(var ParLongint:longint):boolean;
var vRd:cardinal;
begin
	ReadLongint := true;
	if CheckType(IU_Longint) then exit;
	if ReadFromFile(ParLongint,sizeof(ParLongint),vRd) then exit;
	ReadLongint := false;
end;

function  TStream.ReadBoolean(var ParBool : boolean):boolean;
var vlRd :cardinal;
begin
	if CheckType(IU_Boolean) then exit(true);
	if ReadFromFile(ParBool,Sizeof(ParBool),vlRd) then exit(true);
	exit(false);
end;

function  TStream.ReadNumber(var ParNumber : TNumber):boolean;
var vlRd : cardinal;
begin
	if CheckType(IU_Number) then exit(true);
	if ReadFromFile(ParNumber,sizeof(ParNumber),vlRd) then exit(true);
	exit(false);
end;

function TStream.ReadString(var ParStr:string):boolean;
var vRd:cardinal;
	vlLe:byte;
begin
	ReadString := true;
	if CheckType(IU_String) then exit;
	if ReadFromFile(vlLe,1,vRd) then exit;
	SetLength(ParStr,vlLe);
	if ReadFromFile(ParStr[1],length(ParStr),vRd) then exit;
	ReadString := false;
end;


procedure TStream.UpdateHashing(const ParBuf;ParSize:cardinal);
var
	vlPtr     : Pointer;
begin
	vlPtr :=@ParBuf;
	while ParSize > 0 do begin
		iHashing := iHashing xor ((iHashing shl 8) or byte(vlPtr^));
		dec(ParSize);
		inc(vlPtr);
	end;
end;


{---( TObjectStream )-----------------------------------------------}


function TObjectStream.GetNexTIdentNumber : TIdentNumber;
begin
	exit(fModule.GetNexTIdentNumber);
end;

function  TObjectStream.WriteClassHeader(ParItem : TStrAbelRoot):boolean;
var vlCode : TIdentNumber;
begin
	if not streams.GetObjectStreamType(TClassStrabelRoot(ParItem.ClassType),vlCode) then begin
		voElaErr := Err_Int_Object_not_Reg;
		exit(true);
	end;
	if WriteLongint(vlCode) then exit(true);
	if WritePI(ParItem) then exit(true);
	exit(false);
end;

procedure TObjectStream.AddBind(ParItem,ParModule : TIdentNumber ; ParDest : pointer);
begin
	fModule.AddBIndModule(ParItem,ParModule,ParDest);
end;


function    TObjectStream.GetModuleLoadItemByName(const ParName:string):TModuleLoadITem;
begin
	exit(TModuleLoadITem(iModuleLoadList.GetPtrByName(nil,ParName)));
end;

constructor TObjectStream.Create;
begin
	iOpen := false;
	inherited Create;
	iModuleLoadList := TModuleLoadList.Create;
	voHashing	     := 0;
end;


procedure TObjectStream.Clear;
begin
	CloseFile;
	inherited clear;
	iModuleLoadList.destroy;
end;


function   TObjectStream.ReadValue(var ParValue : TValue) : boolean;
var
	vlType : byte;
	vlRd   : cardinal;
	vlLong : TNumber;
	vlBool : boolean;
	vlStr  : string;
	vlPtr  : cardinal;
begin
	ParValue := nil;
	if ReadFromFile(vlType,sizeof(vlType),vlRd) then exit(true);
	case vlType of
    IU_TLongint : begin
		if ReadNumber(vlLong) then exit(true);
		ParValue := TLongint.Create(vlLong);
	end;
	IU_TString : begin
		if ReadString(vlStr) then exit(true);
		ParValue := TString.Create(vlStr);
	end;
	IU_TBoolean : begin
		if ReadBoolean(vlBool) then exit(true);
		ParValue := TBoolean.Create(vlBool);
	end;
    IU_TPointer : begin
		if ReadLong(vlPtr) then exit(true);
		ParValue := TPointer.Create;
		TPointer(ParValue).SetPointer(vlPtr);
	end;
	else exit(true);
	end;
	exit(false);
end;

function    TObjectStream.WriteValue(ParValue : TValue) : boolean;
var
	vlBool : boolean;
	vlLong : TNumber;
	vlStr  : string;
begin
	if(ParValue is TLongint) then begin
		ParValue.GetNumber(vlLong);
		if WriteType(IU_TLongint) then exit(true);
		if WriteNumber(vlLong) then exit(true);
	end else if (ParValue is TString) then begin
		ParValue.GetString(vlStr);
		if WriteType(IU_TString) then exit(true);
		if WriteString(vlStr) then exit(true);
	end else if (ParValue is TBoolean) then begin
		ParValue.GetBool(vlBool);
		if  WriteType(IU_TBoolean) then exit(true);
	 	if WriteBoolean(vlBool) then exit(true);
	end else if (ParValue is TPointer) then begin
		ParValue.GetAsNumber(vlLong);
		if WriteType(IU_TPointer) then exit(true);
		if WriteLong(vlLong.vrNumber) then exit(true);
	end else exit(true);{Todo : seterror ?}
	exit(false);
end;

function TObjectStream.WritePI(ParPtr:TStrAbelRoot):boolean;
var vlItem,vlModule:TIdentNumber;
begin
	WritePi := true;
	ConvertItemPtr(ParPtr,vlItem,vlModule);
	if writeLongint(vlItem) then exit;
	if WriteLongint(vlModule) then exit;
	WritePi := false;
end;


procedure TObjectStream.AddToPtrList(ParCode : TIdentNumber;ParObject : TStrAbelRoot);
begin
	if fModule = nil then begin
		voElaErr := Err_Invalid_Unit;
		exit;
	end;
	TModule(fModule).AddToPtrList(ParCode,ParObject);
end;

procedure TObjectStream.AddToPtrList(ParObject:TStrAbelRoot);
begin
	if fModule = nil then begin
		voElaErr := Err_Invalid_Unit;
		exit;
	end;
	TModule(fModule).AddToPtrList(ParObject);
end;

function TObjectStream.ReadPi(var ParPtr:TStrAbelRoot):boolean;
var vlItem,vlModule:TIdentNumber;
	
begin
	ReadPi := true;
	ParPtr := nil;
	if ReadLongint(vlItem)   then exit;
	if ReadLongint(vlModule) then exit;
	if vlItem <> IC_No_Code then AddBind(vlItem,vlModule,@ParPtr)
	else ParPtr := nil;
	ReadPi := false;
end;



procedure TObjectStream.ConvertItemPtr(ParItem:TStrAbelRoot;var ParNum,ParModule:TIdentNumber);
var
	vlModule : TModule;
begin
	ParNum    := IC_No_Code;
	ParModule := IC_No_Code;
	
	if ParItem = nil then exit;

	vlModule := TModule(ParItem.fModule);

	if vlModule = nil then vlModule := TModule(fModule);

	if (vlModule <> nil) and (ParItem <> vlModule) then begin
		vlModule.ConvertPtrToCode(ParItem);
		ParModule := vlModule.fCode;
	end;

	ParNum := ParItem.fCode;
end;

procedure TObjectStream.AddModule(const ParModule:string;PArModuleObj:TModule);
begin
	iModuleLoadList.AddModule(parModule,ParModuleObj);
end;

function TObjectStream.WritePst(ParPst:TString):boolean;
var vlStr:string;
begin
	if ParPst <> nil then begin
		ParPst.GetString(vlStr);
	end else begin
		EmptyString(vlStr);
	end;
	exit(WriteString(vlStr));
end;

function TObjectStream.ReadPst(var ParPst:TString):boolean;
var
	vlStr:string;
begin
	if ReadString(vlStr) then exit(true);
	ParPst  := TString.Create(vlStr);
	exit(false);
end;

procedure TObjectStream.DoBind;
begin
	iModuleLoadList.DoBind;
end;



{----( CallObject )---------------------------------------------------}


function  CreateObject(ParWriter:TObjectStream;var ParObj:TStrAbelRoot):cardinal;
var vlVmtAddress : TClassStrAbelRoot;
	vlType       : TIdentNumber;
	vlStatus     : cardinal;
begin
	ParObj := nil;
	if ParWriter.ReadLongint(vlType) then exit(STS_ERROR);
	vlStatus := STS_Ok;
	if vlType = IC_End_Mark then exit(STS_End_Mark);
	vlVmtAddress  := GetPtrByType(vlType);
	if vlVmtAddress <> nil then begin
		ParObj := vlVmtAddress.Load(ParWriter);
		if ParObj <> nil then begin
			ParObj.SetModule(ParWriter.fModule);
		end else begin
			vlStatus := STS_Error;
		end;
	end else begin
		vlStatus := STS_Unkown_Object;
	end;
	exit(vlStatus);
end;


procedure AddObjectToStreamList(ParCode : longint;ParVmtAddress : TClassStrAbelRoot);
begin
	vgObjectStreamList.AddObject(parCode,ParVmtAddress);
end;


function  GetObjectStreamType(ParVmtAddress : TClassStrAbelRoot;var ParType : TIdentNumber):boolean;
begin
	GetObjectStreamType := vgObjectStreamList.GeTIdentNumber(ParVmtAddress,ParType);
end;


function GetPtrByType(ParType:TIdentNumber):TClassStrAbelRoot;
begin
	exit(vgObjectStreamList.GetPtrByType(ParType));
end;

end.

