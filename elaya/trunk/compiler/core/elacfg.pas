{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2002  J.v.Iddekinge.
Email : iddekingej@lycos.com
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

unit elacfg;
interface
uses options,confval,files,progutil,elacons,stdobj,elatypes,error,config;
type
	
	
	
	TElaConfig=Class(TConfig)
	private
		voAlign                : TSize;
		voAssemblerPath        : TString;
		voLinkerPath           : TString;
		voRememberExtParamName : boolean;
		voIsElfTarget          : boolean;
		procedure SetLinkerPAth(const ParPath:ansistring);
	protected
		procedure   CommonSetup;override;
		procedure   Clear;override;
        property iIsElfTarget : boolean read voIsElfTarget write voIsElfTarget;

	public
		
		property  fAlign           : TSize   read voAlign;
		property  fIsElfTarget     : boolean read voIsElfTarget;
		procedure GetAssemblerOptions(var ParOptions : ansistring);
		procedure GetLinkerOptions(var ParOptions:ansistring);
		function  GetLinkerPAth:TString;
		procedure GetLinkerPathStr(var ParPath:ansistring);
		function  GetAutoLoad(ParNo : cardinal;var ParOut:ansistring):boolean;
		function  GetPart(const ParIn:ansistring;ParNo : cardinal;var ParOut:ansistring):boolean;
		procedure SetRememberExtParamName(ParSet:boolean);
		function  GetRememberExtParamName:boolean;
		procedure SetAssemblerPath(const ParAsm:ansistring);
		function  GetAssemblerPath:TString;
		procedure SetAlign(parAlign : TSize);
		
		function    SetValues(ParCfg : TConfigValues):boolean;
	end;
	
function  GetAlwaysStackFrame : boolean;
procedure SetAlwaysStackFrame(PArFLag : boolean);

procedure SetConfig(PArConfig:TElaConfig);
function  GetConfig:TElaConfig;
implementation
uses asminfo,i386asin;

var vgConfig:TElaConfig;
	
	vgAlwaysStackFrame  : boolean;
	

function  GetAlwaysStackFrame : boolean;
begin
	GetAlwaysStacKFrame := vgAlwaysStackFrame;
end;

procedure SetAlwaysStackFrame(PArFLag : boolean);
begin
	vgAlwaysStackFrame := ParFlag;
end;


{----( TElaConfig )----------------------------------------------------}


procedure TElaConfig.GetLinkerOptions(var ParOptions:ansistring);

begin
	emptystring(ParOptions);
	GetVarValue(CONF_Linker_Options,ParOptions);
end;


procedure TElaConfig.GetAssemblerOptions(var ParOptions : ansistring);
begin
	emptystring(ParOptions);
	GetVarValue(CONF_Assembler_Options,ParOptions);
end;

function TElaConfig.GetAutoLoad(parNo : cardinal;var ParOut:ansistring):boolean;
var vlStr:ansistring;
begin
	emptystring(ParOut);
	GetAutoLoad := true;
	if GetVarValue(CONF_Auto_Load,vlStr) then begin
		GetAutoLoad := GetPart(vlStr,ParNo,Parout);
	end;
end;


function TElaConfig.GetPart(const ParIn:ansistring;ParNo : cardinal;var ParOut:ansistring):boolean;
var vlCnt  : cardinal;
	vlLast : cardinal;
	vlNo   : cardinal;
begin
	vlCnt  := 1;
	vlLast := 1;
	vlNo   := ParNo;
	while (vlNo >0) and (vlCnt <=length(ParIn)) do begin
		if ParIn[vlCnt] =';' then begin
			dec(vlNo);
			if vlNo = 0 then break;
			vlLast:= vlCnt + 1;
		end;
		inc(vlCnt);
	end;
	Parout := copy(ParIn,vlLast,vlCnt - vLLast);
	GetPart := (vlCnt >=length(ParIn)) and ((vlNo > 1) or (length(ParIn) = 0));
end;



procedure TElaConfig.SetRememberExtParamName(ParSet:boolean);
begin
	voRememberExtParamName := ParSet;
end;

function  TElaConfig.GetRememberExtParamName:boolean;
begin
	GetRememberExtParamName := voRememberExtParamname;
end;




procedure TElaConfig.SetAssemblerPath(const ParAsm:ansistring);
begin
	if voAssemblerPath <> nil then voAssemblerPath.Destroy;
	voAssemblerPath := TString.Create(ParAsm);
end;

function  TElaConfig.GetAssemblerPath:TString;
begin
	GetAssemblerPath := voAssemblerPath;
end;


procedure   TElaConfig.SetAlign(parAlign : TSize);
begin
	voAlign := parAlign;
end;

procedure   TElaConfig.SetLinkerPath(const ParPath:ansistring);
begin
	if voLinkerPath <> nil then voLinkerPath.Destroy;
	voLinkerPath := TString.Create(ParPath);
end;

function TElaConfig.GetLinkerPath:TString;
begin
	GetLInkerPAth := voLInkerPAth;
end;

procedure TElaConfig.GetLinkerPathStr(var ParPath:ansistring);
begin
	emptystring(ParPath);
	if GetLinkerPath <> nil then GetLinkerPath.GeTString(ParPath);
end;

procedure   TElaConfig.CommonSetup;
var
	vlCnt   : cardinal;
	vlName  : ansistring;
	vlValue : ansistring;
begin
	inherited CommoNSetup;
	voAssemblerPath := nil;
	voLinkerPath    := nil;
	SetRememberExtParamName(false);
	SetAlign(1);
	AddVar(CONF_Always_Stack_Frame,'');
	AddVar(CONF_Print_Register_Res,'');
	AddVar(Conf_Object_Path,'');
	AddVar(Conf_Remember_External_Param_NAme,'');
	AddVar(Conf_Auto_LOad,'');
	AddVar(CONF_Output_Object_Path,'');
	AddVar(CONF_Output_exec_Path,'');
	AddVar(CONF_Assembler_Path,'');
	AddVar(CONF_Operating_System,'',true);
	AddVar(CONF_Linker_Path,'');
	AddVar(CONF_Linker_Options,'');
	AddVar(CONF_Assembler_Options,'');
	AddVar(CONF_SOurce_Name,'',true);
	AddVar(Conf_Source_Ext,'',true);
	AddVar(Conf_Source_Dir,'',true);
	AddVar(CONF_Target_Platform,'');
	AddVar(CONF_Run_Assembler,'');
	AddVar(CONF_Can_Use_Dll,'');
	AddVar(CONF_Compiler_Dir,'');
	AddVar(Conf_Is_Elf_Target,'');
	AddVar(Conf_Link_Information_File,'');
	vlCnt := 1;
	while GetVariableByPosition(vlCnt,vlName,vlValue) do begin
		AddOrSetVar(vlName,vlValue,false);
		inc(vlCnt);
	end;
end;


procedure  TElaConfig.clear;
begin
	inherited Clear;
	if GetAssemblerPath <> nil then GetAssemblerPath.destroy;
	if GetLinkerPAth <> nil then GetLinkerPAth.destroy;
end;

function TElaConfig.SetValues(ParCfg : TConfigValues) : boolean;
var 
	vlAsmProg       : ansistring;
	vlLinkerPath    : ansistring;
	vlNumberOfErrors: cardinal;
	vlBool	        : boolean;
	vlPath	        : ansistring;
	vlAsmPath       : ansistring;
	vlSourceName    : ansistring;
	vlExtName       : ansistring;
	vlPathName      : ansistring;
	vlCheck         : ansistring;
	vlFileName      : ansistring;
	vlHostOs        : ansistring;
	vlTargetOs      : ansistring;
	vlOutPath       : ansistring;
	vlObjectPath    : ansistring;
begin
	if ParCfg.fRunAssembler then vlCheck := 'Y' else vlCheck := 'N';
	ParCfg.GetInputFileStr(vlFileName);
	SplitFile(vlFileName,vlPathName,vlSourceName,vlExtName);
	ParCfg.GetHostOsStr(vlHostOs);
	SetVarConst(CONF_Operating_System,vlHostOs);
	ParCfg.GetTargetOsStr(vlTargetOs);
	if length(vlTargetOs) = 0 then vlTargetOs := vlHostOs;
	SetVarConst(CONF_Target_Platform,vlTargetOs);
	SetVarConst(CONF_Source_Name,vlSourceName);
	SetVarConst(CONF_Source_Ext,vlExtName);
	SetVarConst(CONF_Source_Dir,vlPathName);
	SetVarConst(CONF_Compiler_Dir,GetProgramDir);
	SetVar(CONF_Run_Assembler,vlCheck);
	Execute;
	vlAsmProg        := 'AS';
	vlLinkerPath     := 'LD';
	vlNumberOfErrors := 0;
	if GetVarValue(CONF_Linker_PAth,vlPAth) then begin
		vlLinkerPath := vlPath;
	end;
	SetLinkerPath(vlLinkerPath);
	if 	GetVarValue(CONF_Assembler_Path,vlAsmPath) then begin
		vlAsmProg := vlAsmPAth;
	end;
	SetAssemblerPAth(vlAsmProg);
	if GetAssemblerInfo = nil then begin
		case ParCfg.fAssemblerType   of
		AT_X86Att : SetAssemblerInfo(TX86AttAssemblerInfo.Create);
		AT_As86   : SetAssemblerInfo(TAs86AssemblerInfo.Create);
		AT_Nasm86 : SetAssemblerInfo(TNasmAssemblerInfo.Create);
		else begin
			message('Wrong assembler type');
			inc(vlNumberOfErrors);
		end;
	end;
end;
SetAlwaysStackFrame(true);
if GetVarValue(conf_output_object_path,vlOutPath) then ParCfg.SetOutputObjectPath(vlOutPath,cl_Conf);
if GetVarValue(conf_link_information_file,vlPathName) then begin
	if length(vlPathName) > 0 then ParCfg.AddLinkInfoFile(vlPathName);
end;


if GetVarValue(Conf_Object_Path,vlObjectPath) then ParCfg.AddObjectPath(vlObjectPath);
if GetVarUpperBool(conf_Always_Stack_Frame,vlBool) then SetAlwaysStackFrame(vlBool);
if GetVarUpperBool(CONF_Run_Assembler,vlBool) then ParCfg.SetRunAssembler(vlBool,CL_Conf);
if GetVarUpperBool(CONF_Can_Use_Dll,vlBool) then ParCfg.SetCanUseDll(vlBool,CL_Conf);
iIsElfTarget := false;
if GetVarUpperBool(CONF_Is_Elf_Target,vlBool) then begin
	iIsElfTarget := vlBool;
end;
if not GetVarUpperBool(CONF_Remember_External_Param_Name,vlBool) then vlBool := false;
SetRememberExtParamName(vlBool);
exit(vlNumberOfErrors <> 0);
end;



{----( Procedures )-------------------------------------------------}

procedure SetConfig(ParConfig : TElaCOnfig);
begin
	if vgConfig <>nil then vgConfig.Destroy;
	vgConfig := ParCOnfig;
end;

function GetConfig :TElaConfig;
begin
	exit(vgConfig);
end;

begin
	vgAlwaysStackFrame := true;
	vgCOnfig := nil;
end.

