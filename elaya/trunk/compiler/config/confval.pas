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


unit confval;
interface
uses stdobj,elacons,progutil;


type

	TConfigValues=class(TRoot)
	private
		voConfigFile         : TString;
		voCOnfigFileLevel    : cardinal;
		voInputFile          : TString;
		voInputFileLevel     : cardinal;
		voRunAssembler       : boolean;
		voRunAssemblerLevel  : cardinal;
		voAssemblerType      : TAssemblerType;
		voAssemblerTypeLevel : cardinal;
		voDeleteAsmFile      : boolean;
		voDeleteAsmFileLevel : cardinal;
		voRebuild            : boolean;
		voRebuildLevel       : cardinal;
		voBuild              : boolean;
		voBuildLevel         : cardinal;
		voNodeListing        : boolean;
		voNodeListingLevel   : cardinal;
		voTargetOs           : TString;
		voTargetOsLevel      : cardinal;
		voHostOs             : TString;
		voHostOsLevel        : cardinal;
		voGnuStyleErrors     : boolean;
		voGnuStyleErrorsLevel: cardinal;
		voCanUseDll          : boolean;
		voCanUseDllLevel     : cardinal;
		voOptimizeModes      : TOptimizeModes;
		voOptimizeModesLevel : cardinal;
		voVarUseCheck		   : boolean;
		voVarUseCheckLevel   : cardinal;
		voGenerateDebug      : boolean;
		voGenerateDebugLevel : cardinal;
		voAutoload           : boolean;
		voAutoloadLevel      : cardinal;
		voOutputObjectPath   : TString;
		voOutputObjectPathlevel : cardinal;
		property iRebuildLevel       : cardinal read voRebuildLevel	  write voRebuildLevel;
		property iOptimizeModesLevel : cardinal read voOptimizeModesLevel write voOptimizeModesLevel;
		property iConfigFileLevel    : cardinal read voCOnfigFIleLevel	  write voConfigFileLevel;
		property iInputFileLevel     : cardinal read voInputFileLevel	  write voInputFileLevel;
		property iRunAssemblerLevel  : cardinal read voRunAssemblerLevel  write voRunAssemblerLevel;
		property iAssemblerTypeLevel : cardinal read voAssemblerTypeLevel write voAssemblerTypeLevel;
		property iCanUseDllLevel     : cardinal read voCanUseDllLevel	  write voCanUseDllLevel;
		property iTargetOsLevel      : cardinal read voTargetOsLevel	  write voTargetOsLevel;
		property iHostOsLevel        : cardinal read voHostOsLevel	  write voHostOsLevel;
		property iDeleteAsmFileLevel : cardinal read voDeleteAsmFileLevel write voDeleteAsmFileLevel;
		property iNodeListingLevel   : cardinal read voNodeListingLevel   write voNodeLIstingLevel;
		property iBuildLevel         : cardinal read voBuildLevel            write voRebuildLevel;
		property iGnuStyleErrorsLevel: cardinal read voGnuStyleErrorsLevel write voGnuStyleErrorsLevel;
		property iVarUseCheckLevel   : cardinal read voVarUseCheckLevel    write voVarUseCheckLevel;
		property iGenerateDebugLevel : cardinal read voGenerateDebugLevel  write voGenerateDebugLevel;
		property iAutoLoadLevel      : cardinal read voAutoloadLevel       write voAutoloadLevel;
		property iOutputObjectPathLevel : cardinal read voOutputObjectPathLevel write voOutputObjectPathLevel;
	protected
		property iRebuild       : boolean        read voRebuild       write voRebuild;
		property iOptimizeModes : TOptimizeModes read voOptimizeModes write voOptimizeModes;
		property iConfigFile    : TString        read voConfigFile    write voConfigFile;
		property iInputFile     : TString        read voInputFile     write voInputFile;
		property iRunAssembler  : boolean        read voRunAssembler  write voRunAssembler;
		property iAssemblerType : TAssemblerType read voAssemblerType write voAssemblerType;
		property iCanUseDll     : boolean        read voCanUseDll     write voCanUseDll;
		property iHostOs        : TString        read voHostOs        write voHostOs;
		property iTargetOs      : TString        read voTargetOs      write voTargetOs;
		property iDeleteAsmFile : boolean        read voDeleteAsmFile write voDeleteAsmFile;
		property iNodeLIsting   : boolean        read voNodelisting   write voNodeListing;
		property ibuild         : boolean        read voBuild         write voBuild;
		property iGnuStyleErrors: boolean        read voGnuStyleErrors write voGnuStyleErrors;
		property iVarUseCheck   : boolean        read voVarUseCheck   write voVarUSeCheck;
		property iGenerateDebug : boolean        read voGenerateDebug write voGenerateDebug;
		property iAutoload      : boolean        read voAutoLoad      write voAutoload;
		property iOutputObjectPath : TString     read voOutputObjectPath write voOutputObjectPath;
		function  CreateConfigValuesObject : TConfigValues ;virtual;
		procedure Commonsetup;override;
		procedure Clear;override;


	public
		property fConfigFile    : TString        read voConfigFile;
		property fInputFile     : TString        read voInputFile;
		property fRunAssembler  : boolean        read voRunAssembler;
		property fAssemblerType : TAssemblerType read voAssemblerType;
		property fCanUseDll     : boolean        read voCanUseDll;
		property fHostOs        : TString        read voHostOs;
		property fTargetOs      : TString        read voTargetOs;
		property fOptimizeModes : TOptimizeModes read voOptimizeModes;
		property fRebuild       : boolean        read voRebuild;
		property fDeleteAsmFile : boolean        read voDeleteAsmFile;
		property fNodeListing   : boolean        read voNodeListing;
		property fBuild         : boolean        read voBuild;
		property fGnuStyleErrors: boolean        read voGnuStyleErrors;
		property fVarUSeCheck   : boolean        read voVarUseCheck;
		property fGenerateDebug : boolean        read voGenerateDebug;
		property fAutoload      : boolean        read voAutoload;


		procedure SetOutputObjectPath(const ParPath : string;ParLevel : cardinal);
		procedure GetOutputObjectPath(var ParPath : string);
		procedure SetGenerateDebug(ParGenerateDebug : boolean;ParLevel : cardinal);
		procedure SetNodeListing(ParNodeLIsting : boolean;ParLevel : cardinal);
		procedure SetRebuild(ParRebuild : boolean;ParLevel : cardinal);
		procedure SetBuild(ParBuild:boolean;ParLevel : cardinal);
		procedure SetAssemblerType(ParType : TAssemblerTYpe;ParLevel : cardinal);
		procedure SetInputFile(const ParName  : string;ParLevel : cardinal);
		procedure GetInputFileStr(var ParName : string);
		function  IsInputFileSet:boolean;
		procedure SetConfigFile(const ParName : String;ParLevel : cardinal);
		procedure GetConfigFileStr(var ParName : string);
		procedure SetRunAssembler(ParRunAssembler : boolean;ParLevel : cardinal);
		procedure SetCanUseDll(ParCanUseDll : boolean;ParLevel :cardinal);
		procedure SetHostOs(const ParOs :string;Parlevel : cardinal);
		procedure SetTargetOs(const ParOs : string;ParLevel : cardinal);
		procedure SetDeleteAsmFile(ParDeleteAsmFile : boolean;ParLevel :cardinal);
		procedure GetHostOsStr(var ParOs : string);
		procedure SetOptimizeModes(const ParOptimizeModes : TOptimizeModes;ParOnOf:boolean;ParLevel : cardinal);
		procedure SetOptimizeModes(const ParOptimizeModes : TOptimizeModes;ParLevel : cardinal);
		procedure SetGnuStyleErrors(const ParGnuStyleErrors : boolean;ParLevel : cardinal);
		procedure SetVarUseCheck(ParVarUseCheck : boolean;ParLevel : cardinal);
		procedure SetAutoLoad(ParAutoload : boolean;ParLevel : cardinal);
		procedure GetTargetOsStr(var ParOs: string);
		function  CloneValues : TCOnfigValues ;virtual;
	end;
	
	
function  SetOptionValues(ParValues : TConfigValues):TConfigValues;
function  GetOptionValues : TConfigValues ;
function  SetConfigValues(ParValues : TConfigValues):TConfigValues;
function  GetConfigValues : TConfigValues ;

implementation
var
	vgConfigValues : TConfigValues;
	vgOptionValues : TConfigValues;
	
	
	

function SetOptionValues(parValues : TConfigValues) : TConfigValues;
begin
	SetOptionValues := vgOptionValues;
	vgOptionValues  := ParValues;
end;

function GetOptionValues : TConfigValues;
begin
	exit(vgOptionValues);
end;

function SetConfigValues(ParValues : TConfigValues):TConfigValues;
begin
	SetConfigValues := vgConfigValues;
	vgConfigValues  := ParValues;
end;


function  GetConfigValues : TConfigValues;
begin
	exit(vgConfigValues);
end;


{---( TConfigValues )-------------------------------------------------------------------------------}


procedure TConfigValues.SetOutputObjectPath(const ParPath : string;ParLevel : cardinal);
begin
	if ParLevel >=iOutputObjectPathLevel then begin
		if iOutputObjectPath <> nil then iOutputObjectPath.Destroy;
		iOutputObjectPath := TString.Create(ParPath);
		iOutputObjectPathLevel := ParLevel;
	end;
end;

procedure TConfigValues.GetOutputObjectPath(var ParPath : string);
begin
	if iOutputObjectPath <> nil then begin
		iOutputObjectPath.GetString(ParPath);
	end else begin
		SetLength(ParPath,0);
	end;
end;
procedure TConfigValues.SetGenerateDebug(ParGenerateDebug : boolean;ParLevel : cardinal);
begin
	if ParLevel >= iGenerateDebugLevel then begin
		IGenerateDebugLevel := ParLevel;
		iGenerateDebug := ParGenerateDebug;
	end;
end;

procedure TConfigValues.SetVarUseCheck(ParVarUseCheck : boolean;ParLevel : cardinal);
begin
	if ParLevel >= iVarUseCheckLevel then begin
        iVarUseCheck := ParVarUseCheck;
		iVarUseChecklevel := ParLevel;
	end;
end;

procedure TConfigValues.SetOptimizeModes(const ParOptimizeModes : TOptimizeModes;ParOnOf:boolean;ParLevel : cardinal);
begin
	if ParLevel >= iOptimizeModesLevel then begin
		if ParOnOf then iOptimizeModes := iOptimizeModes+ParOptimizeModes
		else iOptimizeModes := iOptimizeModes-ParOptimizeModes;
		iOptimizeModesLevel := ParLevel;
	end;
end;

procedure TCOnfigValues.SetNodeListing(ParNodeLIsting : boolean;ParLevel : cardinal);
begin
	if ParLevel >= iNodeListingLevel then begin
		iNodeListing := ParNodeLIsting;
		iNodeListingLevel := ParLevel;
	end;
end;

procedure TConfigValues.SetDeleteAsmFile(ParDeleteAsmFile : boolean;ParLevel :cardinal);
begin
	if ParLevel >= iDeleteAsmFileLevel then begin
		iDeleteAsmFileLevel := ParLevel;
		iDeleteAsmFile      := ParDeleteAsmFile;
	end;
end;

procedure TConfigValues.SetRebuild(ParRebuild : boolean;ParLevel : cardinal);
begin
	if ParLevel >= iRebuildLevel then begin
		iRebuildLevel := ParLevel ;
		iRebuild := ParRebuild;
	end;
end;

procedure TConfigValues.SetBuild(ParBuild:boolean;ParLevel : cardinal);
begin
	if ParLevel >= iBuildLevel then begin
		iBuildLevel := ParLevel;
		iBuild := ParBuild;
	end;
end;


procedure TConfigValues.SetOptimizeModes(const ParOptimizeModes : TOptimizeModes;ParLevel : cardinal);
begin
	if ParLevel >= iOptimizeModesLevel then begin
		iOptimizeModes       := ParOptimizeModes;
		iOptimizeModesLevel := ParLevel;
	end;
end;

procedure TConfigValues.GetHostOsStr(var ParOs : string);
begin
	if iHostOs <> nil then begin
		iHostOs.GetString(ParOs);
	end else begin
		EmptyString(ParOs);
	end;
end;

procedure TConfigValues.GetTargetOsStr(var ParOs: string);
begin
	if iTargetOs <> nil then begin
		iTargetOs.GetString(ParOs);
	end else begin
		EmptyString(ParOs);
	end;
end;

procedure TConfigValues.SetHostOs(const ParOs :string;Parlevel : cardinal);
begin
	if ParLevel >=iHostOsLevel then begin
		if iHostOs <> nil then iHostOs.Destroy;
		iHostOs := TString.Create(ParOs);
	end;
end;

procedure TConfigValues.SetTargetOs(const ParOs : string;ParLevel : cardinal);
begin
	if ParLevel >= iTargetOsLevel then begin
		if iTargetOs <> nil then iTargetOs.Destroy;
		iTargetOs := TString.Create(parOs);
	end;
end;

procedure TConfigValues.SetAssemblerType(ParType : TAssemblerTYpe;ParLevel : cardinal);
begin
	if ParLevel >= iAssemblerTypeLevel then begin
		iAssemblerType      := ParType;
		iAssemblerTypeLevel := ParLevel;
	end;
end;

procedure TConfigValues.SetGnuStyleErrors(const ParGnuStyleErrors : boolean;ParLevel : cardinal);
begin
	if ParLevel >= iGnuStyleErrorsLevel then begin
		iGnuStyleErrors      := ParGnuStyleErrors;
		iGnuStyleErrorsLevel := ParLevel;
	end;
end;


function  TConfigValues.CreateConfigValuesObject : TConfigValues;
begin
	exit(TCOnfigValues.Create);
end;

function  TConfigValues.CloneValues : TConfigValues;
var vlStr : string;
	vlVal : TConfigValues ;
begin
	vlVal := CreateConfigValuesObject;
	GetConfigFileStr(vlStr);
	vlVal.SetConfigFile(vlStr,iConfigFilelevel);
	if IsInputFileSet then begin
		iInputFile.GetString(vlStr);
		vlVal.SetInputFile(vlStr,iInputFileLevel);
	end;
	vlVal.SetRunAssembler(iRunAssembler,iRunAssemblerLevel);
	vlVal.SetAssemblerType(iAssemblerType,iAssemblerTypeLevel);
	vlVal.SetCanUseDll(iCanUseDll,iCanUseDllLevel);
	GetHostOsStr(vlStr);
	vlVal.SetHostOs(vlStr,iHostOsLevel);
	GetTargetOsStr(vlStr);
	vlVal.SetTargetOs(vlStr,iTargetOsLevel);
	vlVal.SetOptimizeModes(iOptimizeModes,iOptimizeModesLevel);
	vlVal.SetDeleteAsmFile(iDeleteAsmFIle,iDeleteAsmFileLevel);
	vlVal.SetRebuild(iRebuild,iRebuildLevel);
	vlVal.SetNodeListing(iNodeListing,iNodeListingLevel);
	vlVal.SetGnuStyleErrors(iGnuStyleErrors,iGnuStyleErrorsLevel);
	vlVal.SetVarUseCheck(iVarUseCheck,iVarUseChecklevel);
	vlVal.SetGenerateDebug(iGenerateDebug,iGenerateDebugLevel);
	vlVal.SetAutoload(iAutoload,iAutoloadlevel);
	GetOutputObjectPath(vlStr);
	vlVal.SetOutputObjectPath(vlStr,iOutputObjectPathLevel);
	exit(vlVal);
end;

procedure TConfigValues.SetConfigFile(const ParName : String;ParLevel : cardinal);
var
	vlName : string;
begin
	vlName := ParName;
	if  ParLevel >= iConfigFileLevel then begin
		if iConfigFile <> nil then iConfigFile.Destroy;
		iConfigFile      := TString.Create(vlName);
		iConfigFileLevel := ParLevel;
	end;
end;


procedure TConfigValues.GetConfigFileStr(var ParName : string);
begin
	if iConfigFile <> nil then iConfigFile.GetString(ParName)
	else EmptyString(ParNAme);
end;

procedure TConfigValues.SetInputFile(const ParName  : string;ParLevel : cardinal);
var vlName : string;
begin
	vlName := ParName;
	if ParLevel >= iInputFileLevel then begin
		if iInputFile <> nil then iInputFile.Destroy;
		iInputFile      :=   TString.Create(vlName);
		iInputFileLevel :=   ParLevel;
	end;
end;

function  TConfigValues.IsInputFileSet:boolean;
begin
	exit(iInputFile <> nil);
end;

procedure TConfigValues.GetInputFileStr(var ParName : string);
begin
	if iInputFile <> nil then iInputFile.GetString(ParName)
	else EmptyString(ParName);
end;


procedure TConfigvalues.SetCanUseDll(ParCanUseDll : boolean;ParLevel :cardinal);
begin
	if ParLevel >=iCanUseDllLevel then begin
		iCanUseDllLevel := ParLevel;
		iCanUseDll      := ParCanUseDll;
	end;
end;

procedure TConfigValues.SetRunAssembler(ParRunAssembler : boolean;ParLevel : cardinal);
begin
	if ParLevel >= iRunAssemblerLevel then begin
		iRunAssembler      := ParRunAssembler;
		iRunAssemblerLevel := ParLevel;
	end;
end;

procedure TConfigValues.SetAutoLoad(ParAutoload : boolean;ParLevel : cardinal);
begin
	if ParLevel >= iAutoloadLEvel then begin
		iAutoload := ParAutoload;
		iAutoLoadLevel := ParLevel;
	end;
end;


procedure TConfigValues.Commonsetup;
begin
	inherited Commonsetup;
	iConfigFileLevel    := CL_None;
	iInputFileLevel     := CL_None;
	iAssemblerTypeLevel := CL_None;
	iCanUseDllLevel	  := CL_None;
	iOptimizeModesLevel := CL_None;
	iDeleteAsmFileLevel := CL_None;
	iRebuildLevel       := CL_None;
	iNodeListingLevel   := CL_None;
	iBuildLevel         := CL_None;
	iGnuStyleErrorsLevel:= CL_None;
	iVarUseCheckLevel   := CL_None;
	iGenerateDebugLevel := CL_None;
	iAutoLoadLevel      := CL_None;
	iOutputObjectPathLevel := CL_None;
	iConfigFile         := nil;
	iInputFile          := nil;
	iHostOs             := TString.Create(DEF_Operating_System);
	iTargetOs           := nil;
	iOutputObjectPath   := nil;
	iRunAssembler       := true;
	iAssemblerType      := AT_X86ATT;
	iOptimizeModes      := [];
	iCanUseDll          := false;
	iRebuild            := false;
	iDeleteAsmFile      := false;
	iNodeListing	    := false;
	iBuild              := false;
	iGnuStyleErrors     := false;
	iVarUseCheck        := false;
	iGenerateDebug      := false;
	iAutoload           := true;
end;


procedure TConfigValues.Clear;
begin
	inherited Clear;
	if iConfigFile <> nil then iConfigFile.Destroy;
	if iInputFile  <> nil then iInputFile.Destroy;
	if iTargetOs   <> nil then iTargetOs.Destroy;
	if iHostOs     <> nil then iHostOs.Destroy;
	if iOutputObjectPath <> nil then iOutputObjectPath.Destroy;
end;

begin
	vgConfigValues := nil;
	vgOptionValues := nil;
end.


