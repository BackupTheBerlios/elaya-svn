{
    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web    : www.elaya.org

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

unit module;
interface

uses streams,simplist,linklist,progutil,error,elaTypes,asmCreat,DIdentLS,hashing,
ddefinit,confval,elacfg,elacons,compbase,cmp_base,cdfills,stdobj,display,cmp_type,globlist;
	
type

	TUnit        = class;
	TUnitUseList = class;
	TUnitDependenceItem=class;
	TUnitDependenceList=class;

	TUnitList=class(TSMList)
		procedure   AddUnit(ParUnit:TUnit);
		procedure   AddToUseList(const ParUnitName:string;ParUnitUseList:TUnitUseList);
		function    LoadList(ParStream : TObjectStream):boolean;
		function    SaveList(ParStream : TObjectStream):boolean;
	end;
	
	TUnitItem=class(TModuleItemBase)
	private
		voNeededHash : longint;
		voName       : TString;
		property iNeededHash : longint read voNeededHash write voNeededHash;
		property    iName		: TString read voName write voName;
		procedure   SetName(const parString:String);
	protected
		procedure   Clear;override;
		procedure   COmmonsetup;override;
	public
		property    fName       : TString read voName;
		property    fNeededHash : longint read voNeededHash;
		procedure   GetUnitNameStr(var ParName : string);
		constructor Create(ParUnit:TUnit);
		function    LoadItem(ParWriter:TObjectStream):boolean;
		function    SaveItem(ParWriter:TObjectStream):boolean;
	end;
	
	TUnitUseItem=class(TSMTextItem)
	private
		voUnitDependenceList : TUnitDependenceList;
		voState              : TUnitLoadStates;
		voLevel              : TUnitLevel;
		voHash               : THashNumber;
		voUnit               : TUnit;
		voUnitSourceTime     : longint;
		property    iState  : TUnitLoadStates read voState write voState;
		property    iLevel  : TUnitLevel read voLevel write voLevel;
		property    iHash	  : THashNumber read voHash write voHash;
		property    iUnit   : TUnit read voUnit write voUnit;
		property    iUnitSourceTime : Longint read voUnitSourceTime write voUnitSourceTime;
	protected
		procedure   SetUnitLevel(ParUnitLevel:TUnitLevel);
		procedure   Clear;override;
		procedure   CommonSetup;override;

	public
		property    fLevel  : TUnitLevel  read voLevel write SetUnitLevel;
		property    fHash   : THashNumber read voHash write voHash;
		property    fUnit   : TUnit       read voUnit;
		property    fUnitSourceTime : longint read voUnitSourceTime;
		function    LoadUnitHeader(ParCre:TCreator;ParUseList:TUnitUseList):TLoadUnitState;
		procedure   SetUnitSourceTime(ParTime:Longint);
		procedure   SetUnit(ParUnit:TUnit);
		procedure   EmptyDependence;
		procedure   SetFlag(ParFlag:TUnitLoadStates;ParSet:boolean);
		function    GetFlag(ParFlag:TUnitLoadState):boolean;
		procedure   PrintName;
		procedure   Print;
		constructor Create(const ParName:string;ParState:TUnitLoadStates);
		procedure   InitUnitDependenceList;
		function    GetUnitDependenceList:TUnitDependenceList;
		function    AddDependence(ParUnit:TUnitUseItem;ParHash:THashNUmber):TErrorType;
		function    GetDependenceByName(const ParName:string):TUnitDependenceitem;
		function    IsNotdependent:boolean;
		function    TryCalculateLevel:boolean;
		procedure   CheckUnitVersions;
		procedure   GetSourceFileName(var ParFileName : string);
		procedure   GetUnitFileName(var ParFileName : string);
		function    Recompile(ParCre : TCreator):boolean;
		procedure   AddToGlobalHashing(ParCre : TCreator;ParHashing :THashing);
	end;
	
	

	TUnitUseList=class(TSMTextList)
	private
		function InsertUnit(const ParName:string;ParState:TUnitLoadStates):TUnitUseItem;
	public
		procedure CleanupLoad;
		procedure ResetUnitLevels;
		procedure CheckUnitVersions(ParCre:TCreator);
		function  GetCurrentUnit:TUnitUseItem;
		function  ProcessUnitList(ParCre:TCreator):boolean;
		procedure CheckCircularReference(ParCre:TCreator);
		procedure SetUnitLevels;
		function  LoadUnitdependence(ParCre:TCreator):boolean;
		procedure LoadUnits(ParCre:TCreator);
		function  AddUnit(const ParName:string;ParState:TUnitLoadStates):boolean;
		function  AddDependence(const ParName,ParDepend:string;ParHash:THashNumber):TErrorType;
		procedure print;
		function  Recompile(ParCre:TCreator):boolean;
		procedure AddToGlobalHashing(ParCre : TCreator;ParHashing :THashing);
	end;
	
	TUnitDependenceItem=class(TSMListItem)
	private
		voUnitUseItem      : TUnitUseItem;
		voExpectedHashing  : THashNumber;

		property iUnitUseItem    : TUnitUseItem read voUnitUseItem     write voUnitUseItem;
		property iExpectedHashing: THashNumber  read voExpectedHashing write voExpectedHashing;

	public
		function    CompareHashing:boolean;
		function    GetUnitLevel:TUnitLevel;
		function    IsUnitByName(const ParName:string):boolean;
		constructor Create(ParUnitUseItem:TUnitUseItem;ParHash:THashNumber);
		procedure   Print;
	end;
	
	
	TUnitDependenceList=class(TSMList)
	public
		function  CheckUnitVersions:boolean;
		function  GetListLevel:TUnitLevel;
		function  GetDependenceByName(const ParName:string):TUnitDependenceItem;
		procedure AddDependence(ParUnituseItem:TUnitUSeItem;Parhash:THashNumber);
		procedure Print;
	end;
	
	
	
	
	
	TUnit=class(TModule)
	private
		voItemList     :TIdentList;
		voUnitList     :TUnitList;
		voName         :TString;
		voUnitFileName :TString;
		voHashing      :Longint;
		voIsUnitFlag   :boolean;
		voSourceTime   :longint;
		voGlobalList   : TGlobalList;
		voCodeFileList : TCodeFileList;
	protected
		property  iUnitList   : TUnitList   read voUnitList   write voUnitList;
		property  iName       : TString     read voName       write voName;
		property  iUnitFileName   : TString read voUnitFileName   write voUnitFileName;
		property  iGLobalList : TGlobalList read voGlobalList write voGlobalList;
		property  iItemList   : TIdentList  read voItemList   write voItemList;
		property  iCodeFileList:TCodeFileList read voCodeFileList write voCodeFileList;
		property  iIsUnitFlag : boolean     read voIsUnitFlag write voIsUnitFlag;

		procedure   CommonSetup;override;
		procedure   Clear;override;
		
	public
		property    fName         : TString       read voName;
		property    fUnitFileName : TString       read voUnitFileName;
		property    fItemList     : TIdentList    read voItemList;
		property    fIsUnitFlag : boolean     read voIsUnitFlag write voIsUnitFlag;

		
		procedure   AddGlobalOnce(ParCre : TCreator;ParItem : TDefinition);
		procedure   AddGlobal(ParCre : TCreator;ParItem :TDefinition);
		procedure   AddListToGLobalHashing(ParCre :TCreator;ParHashing : THashing);
		procedure   InitCodeFileList;
		procedure   SetCodeFileList(ParFileList:TCodeFileList);
		procedure   SetSourceTime(ParTime:longint);
		function    GetSourceTime:longint;
		constructor Create(const ParName:string);
		procedure   AddToUseList(ParUnitUseList:TUnitUseList);
		constructor LoadHeaderOnly(ParWrite:TObjectStream;var ParError : boolean);
		procedure   GetNameStr(var ParName:string);
		procedure   AddUnit(parUnit:TUnit);
		procedure   CreateSec(ParCompiler:TCompiler_Base);
		function    GetHashing:Longint;
		procedure   GetModuleName(var ParName:string);override;
		function    LoadHeader(ParWrite:TObjectStream;var ParName:string):boolean;
		function    LoadItem(ParWrite:TObjectStream):boolean;override;
		function    WriteResLines(var ParFile:Text):boolean;
		procedure   AddCodeFile(ParCodeFile:TCodeFileItem);
		function    GetObjectName : TString;
		procedure   SetHashing(parHash:Longint);
		function    SaveItem(ParStream:TObjectStream):boolean;override;
		function    Save:TErrorType;
		procedure   SetName(const ParName:String);
		procedure   print(ParDis : TFIleDIsplay);
	end;
	
implementation
uses ndcreat;

{---( TUnitDependenceList )------------------------------}


function TUnitDependenceList.CheckUnitVersions:boolean;
var vlCurrent:TUnitDependenceItem;
begin
	CheckUnitVersions := false;
	vlCurrent := TUnitDependenceItem(fStart);
	while vlCurrent <> nil do begin
		if not vlcurrent.CompareHashing then begin
			CheckUnitVersions := true;
		end;
		vlCurrent := TUnitDependenceItem(vlCurrent.fNxt);
	end;
end;


function TUnitDependenceList.GetListLevel:TUnitLevel;
var vlCurrent : TUnitDependenceItem;
	vlMin     : TUnitLevel;
	vlLevel   : TUnitLevel;
begin
	vlCurrent := TUnitDependenceITem(fStart);
	GetListLevel:= Ul_No_Unit_Level;
	vlMin := Ul_No_Unit_Level;
	while (vlCurrent <> nil) do begin
		vlLevel := vlCurrent.GetUnitLevel;
		if vlLevel = UL_No_Unit_Level then exit;
		if vlLevel > vlMin then vlMin := vlLevel;
		vlCurrent := TUnitDependenceItem(vlCurrent.fNxt);
	end;
	GetListLevel := vlMin;
end;


procedure TUnitDependenceList.AddDependence(ParUnituseItem:TUnitUSeItem;ParHash:THashNumber);
begin
	InsertAt(nil,TUnitDependenceItem.Create(ParUnitUseItem,ParHash));
end;

function  TUnitDependenceList.GetDependenceByName(const ParName:string):TUnitDependenceItem;
var vlCurrent:TUnitDependenceItem;
begin
	vlCurrent := TUnitDependenceItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsUnitByName(ParName)) do begin
		vlCurrent := TUnitDependenceItem(vlCurrent.fNxt);
	end;
	GetDependenceByName := vlCurrent;
end;



procedure TUnitDependenceList.Print;
var vlCurrent:TUnitDependenceItem;
begin
	vlCurrent := TUnitDependenceItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.Print;
		vlCurrent := TUnitDependenceItem(vlCurrent.fNxt);
	end;
end;

{---( TUnitDependenceItem )------------------------------}


function    TUnitDependenceItem.CompareHashing:boolean;
begin
	exit( iExpectedHashing = iUnitUseItem.fHash);
end;

function    TUnitDependenceItem.IsUnitByName(const ParName:string):boolean;
begin
	exit(iUnitUseItem.IsEqualStr(ParName));
end;


function    TUnitDependenceItem.GetUnitLevel:TUnitLevel;
begin
	exit(iUnitUseItem.fLevel);
end;


procedure TUnitDependenceItem.Print;
begin
	write(chr(9));
	if iUnitUseItem <> nil then iUnitUseItem.PrintName;
	writeln(' ',iUnitUseItem.fHash,'=>',iExpectedHashing);
end;

constructor TUnitDependenceItem.Create(ParUnitUseItem:TUnitUseItem;ParHash:THashNumber);
begin
	iUnitUseItem      := ParUnitUseItem;
	iExpectedHashing := ParHash;
	inherited Create;
end;


{---( TUnitUseList )------------------------------------}

procedure TUnitUseLIst.AddToGlobalHashing(ParCre : TCreator;ParHashing :THashing);
var
	vlCurrent : TUnitUseItem;
begin
	vlCurrent := TUnitUseItem(fStart);
	while(vlCurrent <> nil) do begin
		vlCurrent.AddToGlobalHashing(ParCre,ParHashing);
		vlCurrent := TUnitUseItem(vlCurrent.fNxt);
	end;
end;


procedure TUnitUseList.ResetUnitLevels;
var vlCurrent :TUnitUseItem;
begin
	vlCurrent := TUnitUSeItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.fLevel := Ul_No_Unit_level;
		vlCurrent := TUnitUSeItem(vlCurrent.fNxt);
	end;
end;

function TUnitUseList.Recompile(ParCre:TCreator):boolean;
var vllevel      : TUnitLevel;
	vlCurrent    : TUnitUseITem;
	vlFound      : boolean;
	vlRecompiled : boolean;
	vlName       : String;
	vlFailed     : boolean;
begin
	vlLevel := UL_Minimum_Unit_Level;
	vlRecompiled := false;
	repeat
		vlCurrent := TUnitUseITem(fStart);
		vlFound := false;
		while (vlCurrent <> nil) do begin
			if vlCurrent.fLevel = vlLevel  then begin
				vlFound :=true;
				if (vlCurrent.GetFlag(US_Must_Recompile)) then begin
					vlFailed := vlCurrent.Recompile(ParCre);
					if vlFailed then  begin
						vlCurrent.GetSourceFileName(vlName);
						TNDCreator(ParCre).ErrorText(Err_Recompiling_Failed,vlName)
					end else begin
						vlRecompiled := true;
					end;
				end;
			end;
			vlCurrent := TUnitUSeItem(vlCurrent.fNxt);
		end;
		vlLevel := vlLevel + 1;
	until not vlFound;
	if vlRecompiled then begin
		LoadUnitDependence(ParCre);
		ResetUnitlevels;
	end;
	Recompile := vlRecompiled;
end;


function  TUnitUSeList.GetCurrentUnit:TUnitUseItem;
var vlCurrent :TUnituseItem;
begin
	vlCurrent := TUnitUseItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.GetFlag(US_Current_Unit)) do begin
		vlCurrent := TUnitUseItem(vlCurrent.fNxt);
	end;
	GetCurrentUnit := vlCurrent;
end;

procedure TUnitUseList.CheckCircularReference(ParCre:TCreator);
var vlCurrent:TUnitUseItem;
	vlName:string;
begin
	vlCurrent := TUnitUSeItem(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent.fLevel = Ul_No_Unit_level then begin
			vlCurrent.GetTextStr(vlName);
			TNDCreator(ParCre).ErrorText(Err_Circ_Unit_Reference,vlName);
			vlCurrent.SetFlag([US_Must_Load],false);
		end;
		vlCurrent := TUnitUSeItem(vlCurrent.fNxt);
	end;
end;

procedure TUnitUseList.SetUnitLevels;
var vlCurrent       : TUnitUseItem;
	vlNoLevelCnt    : TUnitLevel;
	vlPrvNoLevelCnt : TUnitLevel;
begin
	vlCurrent := TUnitUSeItem(fStart);
	while vlCUrrent <> nil do begin
		if vlCurrent.IsNotdependent then vlCurrent.fLevel := Ul_Minimum_Unit_level;
		vlcurrent := TUnitUseItem(vlCurrent.fNxt);
	end;
	vlNoLevelCnt := 0;
	repeat
		vlPrvNoLevelCnt := vlNoLevelCnt;
		vlCurrent := TUnitUseItem(fStart);
		vlNoLevelCnt := 0;
		while vlCurrent <> nil do begin
			vlCurrent.TryCalculateLevel;
			if vlCUrrent.fLevel = Ul_No_Unit_Level then inc(vlNoLevelCnt);
			vlCurrent := TUnitUseItem(vlCurrent.fNxt);
		end;
	until (vlNoLevelCnt = 0) or (vlNoLevelCnt = vlPrvNoLevelCnt);
end;



procedure TUnitUseList.LoadUnits(ParCre:TCreator);
var vlCurrent    : TUnituseItem;
	vlName       : String;
	vlCurrentUnit: TUnitUSeItem;
	vlPublic     : boolean;
	vlLevel      : TUnitLevel;
	vlFound      : boolean;
	vlUnit       : TUnit;
begin
	vlCurrentUnit := GetcurrentUnit;
	vlLevel := UL_Minimum_Unit_level;
	repeat
		vlCurrent := TUnitUSeItem(fStart);
		vlFound := false;
		while vlCurrent <> nil do begin
			vlCurrent.GetTextStr(vlName);
			if vlCurrent.fLevel = vlLevel then begin
				vlFound := true;
				if (vlCurrent.GetFlag(Us_Must_Load)) then begin
					vlPublic :=  vlCurrentUnit.GetDependenceByName(vlname) <> nil;
					vlUnit   := TNDCreator(ParCre).AddUnit(vlName,vlLevel,vlPublic);
					vlCurrent.SetUnit(vlUnit);
				end;
			end;
			vlCurrent := TUnitUseItem(vlCurrent.fNxt);
		end;
		inc(vlLevel);
	until not vlFound;
end;


procedure TUnitUSeList.CleanupLoad;
var vlCurrent:TUnitUseItem;
begin
	vlCurrent  := TUnitUseItem(fStart);
	while vlCUrrent <> nil do begin
		if vlCurrent.fUnit <> nil then vlCurrent.fUnit.CleanUpLoad;
		vlCurrent := TUnitUSeItem(vlCurrent.fNxt);
	end;
end;

function  TUnitUseList.ProcessUnitList(ParCre:TCreator):boolean;
var    vlRe:boolean;
begin
	vlRe := false;
	repeat
		processUnitList := LoadUnitDependence(ParCre);
		SetUnitLevels;
		CheckCircularReference(ParCre);
		CheckUnitVersions(ParCre);
		if GetConfigValues.fRebuild then vlRe := Recompile(ParCre);
	until not vlRe;
	ProcessUnitList :=  false;
end;


function TUnitUseList.LoadUnitdependence(ParCre:TCreator):boolean;
var vlHasLoad:boolean;
	vlCurrent:TUnitUseItem;
begin
	LoadUnitDependence := false;
	
	repeat
		vlHasLoad := false;
		vlCurrent := TUnitUseItem(fStart);
		while vlCurrent <> nil do begin
			if vlCurrent.GetFlag(US_Must_Load_Header) then begin
				if vlCurrent.LoadUnitHeader(ParCre,self)<>Lus_Ok then LoadUnitdependence := true;
				vlHasLoad := true;
			end;
			vlCurrent := TUnitUseItem(vlCurrent.fNxt);
		end;
	until not (vlhasLoad);
end;

function TUnitUseList.InsertUnit(const ParName:string;ParState:TUnitLoadStates):TUnitUseItem;
var vlUnitUse:TUnitUseItem;
begin
	vlUnitUse := (TUnitUseItem.Create(ParName,ParState));
	InsertAt(nil,vlUnitUse);
	InsertUnit := vlUnitUse;
end;

function TUnitUseList.AddUnit(const ParName:string;ParState:TUnitLoadStates):boolean;
begin
	AddUnit := true;
	if GetPtrByName(nil,ParName) <> nil then exit;
	InsertUnit(ParName,parState);
	AddUnit := false;
end;


function TUnitUseList.AddDependence(const ParName,ParDepend:string;ParHash:ThashNumber):TErrorType;
var vlUnit,vlDeTUnit:TUnitUseItem;
begin
	vlUnit := TUnitUseItem(GetPtrByName(nil,ParName));
	if vlUnit = nil then begin
		AddDependence := Err_Int_Unit_not_in_List;
		exit;
	end;
	vlDeTUnit := TUnitUSeItem(GetPTrByName(nil,ParDepend));
	if vlDeTUnit = nil then vlDeTUnit := InsertUnit(ParDepend,[US_Must_Load,US_Must_Load_Header]);
	AddDependence := vlUnit.AddDependence(vlDeTUnit,ParHash);
end;



procedure TUnitUseList.Print;
var vlCurrent:TUnitUSeItem;
begin
	vlCUrrent :=TUnitUseItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.Print;
		vlCurrent := TUnitUseItem(vlCurrent.fNxt);
	end;
end;

procedure TUnitUseList.CheckUnitVersions(ParCre:TCreator);
var vlCurrent : TUnitUseItem;
	vlName    : string;
	vlError   : TErrorTYpe;
begin
	vlCurrent := TUnitUSeItem(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent.GetFlag(US_Must_Load) then vlCurrent.CheckUnitversions;
		vlCurrent := TUnitUseItem(vlCurrent.fNxt);
	end;
	vlCurrent := TUnitUseITem(fStart);
	if not GetConfigValues.fRebuild then begin
		while vlCurrent <> nil do begin
			vlError := Err_No_Error;
			if vlCurrent.GetFlag(Us_Wrong_Version)     then vlError := Err_Unit_Version_Mismatch else
			if vlCurrent.GetFlag(US_Wrong_Source_Date) then vlError := Err_Source_Is_Later else
			if vlCurrent.GetFlag(US_Must_Recompile)    then vlError := ERR_Must_Recompile;
			if vlError <> Err_No_Error then begin
				vlCurrent.GetTextStr(vlName);
				TNDCreator(ParCre).ErrorText(vlError,vlname);
			end;
			vlCurrent := TUnitUseITem(vlCurrent.fNxt);
		end;
	end;
end;


{---( TUnitUseItem )------------------------------------}

procedure TUnitUseItem.AddToGlobalHashing(parCre :TCreator;ParHashing :THashing);
begin
	if (fUnit <> nil) then fUnit.AddListToGlobalHashing(ParCre,ParHashing);
end;

function TUnitUseItem.Recompile(ParCre : TCreator):boolean;
var vlComp   : TCompiler_Base;
	vlFailed : boolean;
	vlName   : string;
begin
	GetSourceFileName(vlName);
	vlComp   := TNDCreator(ParCre).GetNewCompiler(vlName);
	vlFailed := true;
	if (vlComp <> nil) then begin
		vlComp.Compile;
		if vlComp.SuccessFul then begin
			vlFailed     := false;
			SetFlag([Us_Must_Recompile,US_Wrong_Version,US_Wrong_Source_Date],false);
			SetFlag([Us_Must_Load,US_Must_Load_Header],true);
			EmptyDependence;
		end else begin
			vlComp.HandleErrors;
		end;
		vlComp.Destroy;
	end;
	exit(vlFailed);
end;

procedure TUnitUseItem.GetSourceFileName(var ParFileName : string);
begin
	GetTextStr(ParFileName);
	ParFileName := ParFileName + CNF_Source_Ext;
	LowerStr(ParFileName);
end;

procedure TUnitUseItem.GetUnitFileName(var ParFileName : string);
begin
	GetTextStr(ParFileName);
	ParFileName := ParFileName + CNF_Unit_Ext;
end;


function TUnitUSeItem.LoadUnitHeader(ParCre:TCreator;ParUseList:TUnitUseList):TLoadUnitState;
var vlName : string;
	vlDmy  : longint;
	vlLoad : TObjectStream;
	vlUnit : TUnit;
	vlErr  : boolean;
	vlPath : string;
begin
	LoadUnitHeader := Lus_Failed;
	GetUnitFileName(vlName);
	vlLoad := TObjectStream.Create;
	GetConfig.GetObjectPath(vlPath);
	vlLoad.AddPath(vlPath);
	if not vlLoad.OpenFile(vlName) then begin
		vlLoad.ReadLongint(vlDmy);
		vlUnit := TUnit.LoadHeaderOnly(vlLoad,vlErr);
		if not vlErr then begin
			iHash := vlUnit.GetHashing;
			SetUnitSourceTime(vlUnit.GetSourceTime);
			vlUnit.AddToUseList(ParUseLIst);
			vlLoad.CloseFile;
			vlUnit.Destroy;
			LoadUnitHeader := Lus_Ok;
		end else begin
			TNDCreator(ParCre).ErrorText(Err_Invalid_Unit,vlName);
			if vlUnit <> nil then vlUnit.Destroy;
		end;
	end else begin
		LoadUnitHeader := LUs_Not_Found;
		TNDCreator(ParCre).ErrorText(Err_Cant_Open_Unit_File,vlName);
	end;
	vlLoad.Destroy;
	SetFlag([US_Must_Load_Header],false);
end;

procedure   TUnitUseItem.SetUnitSourceTime(ParTime:Longint);
begin
	voUnitSourcetime := ParTime;
end;


procedure   TUnitUseItem.EmptyDependence;
begin
	GetUnitDependenceList.DeleteAll;
end;

procedure   TUnitUseItem.CheckUnitVersions;
var vlName : string;
	vlFile : FIle;
	vlTime : longint;
begin
	GetSourceFileName(vlName);
	if GetUnitDependenceList.CheckUnitVersions then begin
		Verbose(VRB_Recomp_Reason,vlName + ' needs to be recompiled: unit version mismatch');
		SetFlag([US_Must_Recompile,US_Wrong_Version],true);
		SetFlag([Us_Must_Load],false);
	end;
	assign(vlFile,vlName);
	reset(vlFile,1);
	if ioresult = 0 then begin
		vlTime := GetFileTime(vlFile);
		if vlTime > iUnitSourceTime then begin
			Verbose(VRB_Recomp_Reason,[vlName , ' needs to be recompiled: source changed ',
			IntToStr(iUnitSourceTime),'=>',vlTime]);
			SetFlag([US_Must_Recompile,US_Wrong_SOurce_Date],true);
			SetFlag([US_Must_Load],false);
		end;
		close(vlFile);
	end;
end;

function    TUnituseItem.TryCalculateLevel:boolean;
var
	vlLevel:TUnitLevel;
begin
	vlLevel := GetUnitDependenceList.GetListLevel;
	TryCalculateLevel := vlLevel <> UL_No_Unit_Level;
	if vlLevel <> Ul_No_Unit_level then fLevel := vlLevel + 1;
end;


function    TUnitUseITem.IsNotdependent:boolean;
begin
	IsNotdependent := GetUnitDependenceList.IsEmpty;
end;

procedure   TUnitUseItem.SetFlag(ParFlag:TUnitLoadStates;ParSet:boolean);
var vlErr:TErrorTYpe;
begin
	
	vlErr := Err_No_Error;
	if ParSet then iState := iState + ParFlag
	else iState := iState -(ParFlag);
	if ( iState * [US_Must_Load,US_Must_Load_Header] = [US_Must_Load_Header]) then vlErr := FAT_Load_header_No_Set;
	if (US_Current_Unit in iState) and ((iState * [Us_Must_Load,US_Must_Load_Header]) <> []) then vlErr := FAT_Cant_Load_Current_Unit;
	if vlErr <> 0 then Fatal(vlErr,'');
end;

function    TUnitUseItem.GetFlag(ParFlag:TUnitLoadState):boolean;
begin
	exit(ParFlag in iState);
end;



function TUnitUSeItem.AddDependence(parUnit:TUnitUseITem;ParHash:THashNumber):TErrorType;
var vlName:string;
begin
	ParUnit.GetTextStr(vlName);
	if GetDependenceByName(vlName) <> nil then begin
		AddDependence := Err_Int_Duplicate_Dep;
		exit;
	end;
	GetUnitdependenceList.AddDependence(ParUnit,Parhash);
	AddDependence := Err_no_Error;
end;


function  TUnitUseItem.GetDependenceByName(const ParName:string):TUnitDependenceitem;
begin
	GetDependenceByName := GetUnitDependenceList.GetDependenceByName(ParName);
end;


procedure TUnitUSeItem.PrintName;
var vlStr:String;
begin
	GetTextStr(vlStr);
	write(vlStr);
end;

procedure TUnitUseItem.Print;
begin
	PrintName;
	write(' ',fLevel,' ',fHash);
	if GetFlag(US_Must_Recompile) then begin
		if GetFlag(US_Wrong_Version) then write(' [V]')
		else write(' [I]');
	end;
	writeln;
	
	GetUnitDependenceList.Print;
end;


procedure TUnitUseItem.InitUnitDependenceList;
begin
	voUnitDependenceList := (TUnitDependenceList.Create);
end;

constructor TUnitUseItem.Create(const ParName:string;ParState:TUnitLoadStates);
begin
	inherited Create(ParName);
	SetFlag(ParState,true);
end;

procedure TUnitUseItem.SetUnitLevel(ParUnitLevel:TUnitLevel);
begin
	if (ParUnitLEvel <> ul_No_Unit_level) and (ParUnitLevel < ul_Minimum_Unit_level) then begin
		Fatal(FAT_Invalid_Unit_Level,'TUnitUseItem.SetUnitLevel');
	end;
	voLevel := ParUnitLevel;
end;


procedure TUnitUseItem.SetUnit(ParUnit:TUnit);
begin
	if fUnit <> nil then ParUnit.Destroy;
	voUnit := ParUnit;
end;

procedure TUnitUseItem.CommonSetup;
begin
	inherited Commonsetup;
	iState  := [];
	voUnit  := nil;
	InitUnitDependenceList;
	iLevel := UL_No_Unit_Level;
	fHash  := 0;
end;

function TUnitUseItem.GetUnitDependenceList:TUnitDependenceList;
begin
	GetUnitDependenceList := voUnitDependenceList;
end;

procedure TUnitUseItem.Clear;
begin
	inherited Clear;
	if GetUnitDependenceList <>nil then GetUnitDependenceList.Destroy;
	if fUnit <> nil then fUnit.Destroy;
end;



{----------( TUnit )-------------------------------------}

procedure  TUnit.print(ParDis : TFIleDIsplay);
begin
	ParDis.WriteNl('<unit>');
	iItemList.Print(ParDIs);
	ParDis.nl;
	ParDis.WriteNl('</unit>');
end;


function   TUnit.WriteResLines(var ParFile:Text):boolean;
begin
	WriteResLines := iCodeFileList.WriteResLines(ParFile);
end;

procedure  TUnit.AddCodeFile(ParCodeFile:TCodeFileItem);
begin
	iCodeFileList.AddFile(ParCodeFile);
end;


procedure   TUnit.InitCodeFileList;
begin
	SetCodeFileList((TCodeFileList.Create));
end;

procedure   TUnit.SetCodeFileList(ParFileList:TCodeFileList);
begin
	if iCodeFileList <> nil then iCodeFileList.Destroy;
	voCodeFileList := ParFIleList;
end;

procedure   TUnit.SetSourceTime(ParTime:longint);
begin
	voSourceTime := ParTime;
end;

function    Tunit.GetSourceTime:longint;
begin
	GetSourceTime := voSourceTime;
end;


constructor TUnit.LoadHeaderOnly(ParWrite:TObjectStream;var ParError:boolean);
var vlName:string;
begin
	inherited Create;
	ParError := LoadHeader(ParWrite,vlName);
end;

procedure   TUnit.AddToUseList(ParUnitUseList:TUnitUseList);
var vlName:string;
begin
	GetNameStr(vlname);
	iUnitList.AddToUseList(vlName,ParUnitUseList);
end;


procedure   TUnit.SetHashing(parHash:Longint);
begin
	voHashing := ParHash;
end;

function    TUnit.GetHashing:Longint;
begin
	GetHashing := vohashing;
end;

procedure   TUnit.GetModuleName(var ParName:string);
var vlStr:string;
begin
	iName.GetString(vlStr);
	UpperStr(vlStr);
	ParName := vlStr;
end;


procedure   TUnit.CreateSec(ParCompiler:TCompiler_Base);
var vlAsm  : TAsmCreator;
	vlName : string;
	vlErr  : TErrorType;
	vlError: boolean;
begin
	GetModuleName(vlName);
	lowerStr(vlName);
	vlAsm := TAsmCreator.Create(not(iIsUnitFlag),vlName,ParCompiler,vlError);
	if vlAsm.fLis <> nil then Print(vlAsm.fLis);    {TODO Move to better place}
	if not vlError then begin
		vlErr := vlAsm.ProduceAsm(iItemList);
		if vlErr <> Err_No_Error then ParCompiler.SemError(vlErr);
	end;
	vlAsm.Destroy;
end;


function TUnit.Save:TErrorType;
var vlWriter   : TObjectStream;
	vlUnitName : string;
	vlStr      : string;
	vlObjPath  : string;
	vlErr      : TErrorType;
begin
	vlWriter   := TObjectStream.Create;
	iUnitFileName.GetString(vlUnitName);
	GetConfigValues.GetOutputObjectPath(vlObjPath);
	CombinePath(vlObjPath,vlUnitName,vlStr);
	Save := Err_No_Error;
	if vlWriter.CreateFile(vlStr) then begin
		Save := Err_Fail_Create_Unit_File;
	end  else begin
		vlWriter.SetModule(self);
		if SaveItem(vlWriter) then begin
			vlErr := vlWriter.fElaErr;
			if vlErr = 0 then vLErr := Err_Fail_write_unit_File;
			Save := vlErr;
		end;
	end;
	vlWriter.Destroy;
end;


constructor TUnit.Create(const pArName:string);
var vlName:String;
begin
	inherited Create;
	vlName := ParName;
	NormFileName(vlName);
	SetName(vlName);
end;


function TUnit.LoadHeader(ParWrite:TObjectStream;var ParName:string):boolean;
var
	vlHash       : longint;
	vlTime       : Longint;
	vlIsUnitFlag : boolean;
begin
	LoadHeader := true;
	ParWrite.SetModule(self);
	if inherited LoadItem(ParWrite)    then exit;
	ParName := ParWrite.fName;
	NormFileNAme(ParName);
	SetName(ParName);
	if ParWrite.Readlongint(vlHash) then exit;
	SetHashing(vlhash);
	if parWrite.ReadBoolean(vlIsUnitFlag) then exit;
	iIsUnitFlag := vlIsUnitFlag;
	if ParWrite.ReadLongint(vlTime) then exit;
	SetSourceTime(vlTime);
	if iUnitList.LoadList(ParWrite) then exit;
	LoadHeader := false;
end;

function    TUnit.LoadItem(ParWrite:TObjectStream):boolean;
var vlName:string;
	vlFileName:string;
begin
	LoadItem :=true;
	ParWrite.GetFileNameStr(vlFileName);
	Verbose(VRB_Load_Unit,'Loading unit :'+vlFileName);
	if LoadHeader(ParWrite,vlName)        then exit;
	if iCodeFileList.LoadItem(ParWrite) then exit;
	if iItemList.LoadItem(ParWrite)      then exit;
	if iGlobalList.LoadItem(ParWrite)	  then exit;
	ParWrite.CloseFile;
	ParWrite.AddModule(vlName,self);
	LoadItem := false;
end;


function TUnit.SaveItem(ParStream:TObjectStream):boolean;
var vlPos,vlL1:longint;
begin
	SaveITem := true;
	if inherited SaveItem(ParStream) then exit;
	vlPos := ParStream.GetFilePos + 1;
	if ParStream.WriteLongint(0) 			   then exit;
	if ParStream.WriteBoolean(iIsUNitFlag)    then exit;
	if ParStream.WriteLongint(GetSourceTime)   then exit;
	if iUnitList.SaveList(ParStream)           then exit;	
	if iCodeFileList.SaveItem(parStream)       then exit;
	if iITemList.SaveItem(ParStream)          then exit;
	if iGlobalList.SaveItem(ParStream)	       then exit;
	vlL1 := ParStream.fHashing;
	ParStream.WriteDirect(vlPos,vlL1,sizeof(longint));
	ParStream.fHashing := 0;
	exit(false);
end;



procedure TUnit.Clear;
begin
	inherited Clear;
	if iITemList    <> nil then iItemList.Destroy;
	if iName         <> nil then iName.Destroy;
	if iUnitList     <> nil then iUnitList.Destroy;
	if iUnitFileName <> nil then iUnitFileName.Destroy;
	if iCodeFileList <> nil then iCodeFileList.Destroy;
	if iGlobalList     <> nil then iGlobalList.Destroy;
end;


procedure TUnit.AddGlobalOnce(ParCre : TCreator;ParItem : TDefinition);
begin
	iGlobalList.AddGlobalOnce(ParCre,ParItem);
end;


procedure TUnit.AddGlobal(ParCre :TCreator;ParItem :TDefinition);
begin
	iGlobalList.AddGlobal(ParCre,ParItem);
end;

procedure TUnit.AddListToGlobalHashing(ParCre :TCreator;ParHashing : THashing);
begin
	iGLobalList.AddListToHash(ParCre,ParHashing);
end;


procedure TUnit.COmmonSetup;
begin
	inherited commonSetup;
	voCodeFileList := nil;
	voName         := nil;
	iIsUnitFlag    := false;
	iItemList     := TIdentList.Create;
	iUnitList      := TUnitList.Create;
	iGLobalList    := TGlobalList.Create;
	InitCodeFileList;
end;

procedure TUnit.GetNameStr(var ParName:string);
begin
	iName.GetString(ParName);
end;

procedure TUnit.SetName(const ParName:String);
var vlCodeFile : string;
	vlStr      : TString;
	vlName     : string;
begin
	if iName         <> nil then iName.Destroy;
	if iUnitFileName <> nil then iUnitFIleName.Destroy;
	vlName := ParName;
	UpperStr(vlName);
	iName         := TString.Create(ParName);
	iUnitFileName := TString.Create(ParName + CNF_Unit_Ext);
	vlCodeFile    := ParName;
	LowerStr(vlCodeFile);
	vlStr := TString.Create(vlCodeFile + CNF_Object_Ext);
	AddCodeFile(TCodeObjectItem.Create(vlStr,true,false,0));
end;

procedure TUnit.AddUnit(parUnit:TUnit);
var vlObjectFileName : TString;
begin
	if ParUnit <> nil then begin
		iUnitList.AddUnit(ParUnit);
		vlObjectFileName := ParUnit.GetObjectName;
		AddCodeFile(TCodeObjectItem.Create(TString(vlObjectFileName.Clone),false,false,0));
		iCodeFileList.AddListToList(Parunit.iCodeFileList);
	end;
end;

function  TUnit.GetObjectName:TString;
begin
	exit(iCodeFileList.GetObjectOfUnit);
end;





{-----( TUnitList )--------------------------------------}


function    TUnitList.LoadList(ParStream : TObjectStream):boolean;
var vlCurrent : TUnitItem;
	vlNum     : cardinal;
begin
	if ParStream.ReadLong(vlNum) then exit(true);
	while (vlNum > 0) do begin
		vlCurrent := TUnitItem.Create(nil);
		if vlCurrent.LoadItem(ParStream) then begin
			vlCurrent.Destroy;
			exit(true);
		end;
		InsertAtTop(vlCurrent);
		dec(vlNum);
	end;
	exit(false);
end;

function  TUnitList.SaveList(ParStream : TObjectStream):boolean;
var vlCurrent : TUnitItem;
begin
	if ParStream.WriteLong(GetNumItems) then exit(true);
	vlCurrent := TUnitItem(fStart);
	while (vlCurrent <> nil) do begin
		if vlCurrent.SaveItem(ParStream) then exit(true);
		vlCurrent := TUnitItem(vlCurrent.fNxt);
	end;
	exit(false);
end;



procedure TUnitList.AddUnit(ParUnit:TUnit);
var vlUnitItem:TUnitItem;
begin
	if ParUnit <> nil then begin
		vlUnitItem := TUnitItem.Create(PArUnit);
		InsertAtTop(vlUnitItem);
	end;
end;


procedure TUnitList.AddToUseList(const ParUnitName:string;ParUnitUseList:TUnitUseList);
var vlUnitItem : TUnitItem;
	vlUnitName : string;
begin
	vlUnititem := TUnitItem(fStart);
	while vlUnitItem <> nil do begin
		vlUnitItem.GetUnitNameStr(vlUnitName);
		ParUnitUseList.AddDependence(ParUnitName,vlUnitName,vlUnitItem.fNeededHash);
		vlUnitItem := TUnitITem(vlUnitItem.fNxt);
	end;
end;




{----( TUnitItem )----------------------------------------}


procedure  TUnitItem.GetUnitNameStr(var ParName : string);
begin
	iName.GetString(ParName);
end;

procedure  TUnititem.SetName(const parString:String);
begin
	if iName <> nil then iName.Destroy;
	iName :=TString.Create(ParString);
end;

constructor TUnitItem.Create(ParUnit:TUnit);
var vlName:string;
begin
	inherited Create;
	SetModuleItem(TModule(ParUnit));
	if ParUnit <> nil then begin
		ParUnit.GetNameStr(vlName);
		iName := TString.Create(vlname);
	end;
end;

function TUnitItem.SaveItem(ParWriter:TObjectStream):boolean;
begin
	fModuleItem.fCode := ParWriter.GetNextIdentNumber;
	if ParWriter.WriteLongint(longint(fModuleItem.fCode))    then exit(true);
	if ParWriter.WritePst(TUnit(fModuleItem).fName)         then exit(true);
	if ParWriter.WriteLongint(TUnit(fModuleItem).GetHashing) then exit(true);
	exit(false);
end;



function TUnititem.LoadItem(ParWriter:TObjectStream):boolean;
var  vlName   : string;
	vlhash   : longint;
	vlItem   : TModuleLoadItem;
	vlModule : TModule;
	vlCode   : longint;
begin
	LoadItem := true;
	SetModuleItem(nil);
	if ParWriter.ReadLongint(longint(vlCode)) then exit;
	if ParWriter.ReadString(vlName) then exit;
	if ParWriter.ReadLongint(vlHash) then exit;
	SetName(vlName);
	iNeededHash := vlHash;
	vlItem:= ParWriter.GetModuleLoadItemByName(vlName);
	if vlItem <> nil then begin
		vlModule := vlItem.fModuleObj;
		SetModuleItem(vlModule);
		ParWriter.AddToPtrList(vlCode,vlModule);
	end;
	LoadItem := false;
end;


procedure TUnitItem.Clear;
begin
	inherited Clear;
	if iName<> nil then iName.Destroy;
end;

procedure   TUnititem.COmmonsetup;
begin
	inherited Commonsetup;
	iName := nil;
end;

end.

