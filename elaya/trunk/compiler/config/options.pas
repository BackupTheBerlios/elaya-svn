{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
web : www.elaya.org

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

unit options;
interface
uses progutil,confval,stdobj,elatypes,elacons,simplist;


procedure InitOptions;
procedure DoneOptions;
function GetVariableByPosition(ParNum : cardinal;var ParName,ParValue : string) : boolean;
implementation
{uses elacfg,i386asin,asminfo;}

type  TOptionConfigVariable=class(TSMListItem)
	  private
		voVariable : TString;
		voValue    : TString;
		property iVariable : TString read voVariable write voVariable;
		property iValue    : TString read voValue write voValue;
	  protected
		procedure clear;override;
	  public
		property fVariable : TString read voVariable;
		property fValue    : TString read voValue;
		constructor Create(const ParVariable,ParValue : string);
		function IsVariable(const ParVariable : string) : boolean;
		procedure SetValue(const ParValue : string);
		function  GetValue : string;
		function  GetName  : string;
	  end;

      TOptionConfigVariableList=class(TSMList)
		function  GetVariable(const ParName : string) : TOptionConfigVariable;
		function  GetVariableByPosition(ParNum : cardinal;var ParName,ParValue : string) : boolean;
	   	procedure AddVariable(const ParName,ParValue : string);
	  end;

var vgOptionVariableList : TOptionConfigVariableList;


function  TOptionConfigVariableList.GetVariableByPosition(ParNum : cardinal;var ParName,ParValue : string) : boolean;
var
	vlOption : TOptionConfigVariable;
begin
	vlOption := TOptionConfigVariable(GetPtrByNum(ParNum));
	if vlOption <> nil then begin
		ParValue := vlOption.GetValue;
		ParName  := vlOption.GetName;
	end else begin
		EmptyString(ParValue);
		EmptyString(ParName);
	end;
	exit(vlOptioN <> nil);
end;

function  TOptionConfigVariableList.GetVariable(const ParName : string) : TOptionConfigVariable;
var
	vlCurrent : TOptionConfigVariable;
begin
	vlCurrent := TOptionConfigVariable(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsVariable(ParName)) do vlCurrent := TOptionConfigVariable(vlCurrent.fNxt);
	exit(vlCurrent);
end;

procedure TOptionConfigVariableList.AddVariable(const ParName,ParValue : string);
var
	vlVar : TOptionCOnfigVariable;
begin
	vlVar := GetVariable(ParName);
	if vlVar <> nil then begin
		vlVar.SetValue(ParValue);
	end else begin
		vlVar := TOptionCOnfigVariable.Create(ParName,ParValue);
		insertAtTop(vlVar);
	end;
end;



procedure TOptionConfigVariable.Clear;
begin
	inherited Clear;
	if iVariable <> nil then iVariable.Destroy;
	if iValue <> nil then iValue.Destroy;
end;

constructor TOptionConfigVariable.Create(const ParVariable,ParValue : string);
begin
	inherited Create;
	iVariable := TString.Create(ParVariable);
	iValue    := TString.Create(ParValue);
end;

function TOptionConfigVariable.IsVariable(const ParVariable : string) : boolean;
begin
	exit(iVariable.IsEqualStr(ParVariable));
end;

procedure TOptionConfigVariable.SetValue(const ParValue : string);
begin
	iValue.Destroy;
	iValue := TString.Create(ParValue);
end;

function TOptionConfigVariable.GetValue : string;
var
	vlStr :string;
begin
	iValue.GetString(vlStr);
	exit(vlStr);
end;

function TOptionConfigVariable.GetName  : string;
var
	vlStr : string;
begin
	iVariable.GetString(vLStr);
	exit(vlStr);
end;

function GetVariableByPosition(ParNum : cardinal;var ParName,ParValue : string) : boolean;
begin
    exit(vgOptionVariableList.GetVariableByPosition(ParNum,ParName,ParValue));
end;

procedure PrintOptions;
begin
	writeln;
	writeln('Configuring elaya:');
	writeln(' It is possible to configurate Elaya with the config file.');
	writeln(' These options are overwritten by the commandline options.');
	writeln(' For more information : www.elaya.org');
	writeln;
	writeln('Elaya command-line options');
	writeln;
	writeln('-a[ndD]        = Always run assembler (Default) ');
	writeln('                 n = Don''t run assembler');
	writeln('                 d = Delete assembler file (Default)');
	writeln('                 D = Don''t delete Assembler file');
	writeln('-c<filename>   = Configuration Filename(default ''ela.cfg'')');
	writeln('-C[u]          = checks');
	writeln('				     u = Trace variable use');
	writeln('-d             = Generate debug info');
	writeln('-D<name>=<value>=define config variable an value');
	writeln('-e             = GNU style errors');
	writeln('-h	            = Print options help');
	writeln('-l[nN]         = Generate lis file');
	writeln('	              n=Print node/POC list file');
	writeln('	              N=Turnoff printing node/POC list file');
	writeln('-O[k]          = Optimize');
	writeln('		           k=Optimize register use:');
	writeln('  		          k1=Reuse register contents');
	writeln('-r      = rebuild, when source has changed or unit versions dont match');
	{	writeln('	          b = Rebuild all programs'); }
	writeln('-u             =Unit options');
	writeln('                n=don''''autoload units');
	writeln('-o <path>      = set output object path');
	writeln('-v[clarefpAswotEB]= set verbose level');
	writeln('		  c = Used config file   s = Source file');
	writeln('		  l = Loading unit	 w = What I do');
	writeln('		  a = Autoloading unit   o = object count  init/deinit');
	writeln('		  r = Recompile reason   t = compile timing');
	writeln('		  e = Program execution  ');
	writeln('		  f = Failed execution   ');
	writeln('		  p = Parsing procedure  E = Extra (s+w+e+o+t)');
	writeln('		  A = All verbose        B = Basic verbose(=s+w+e)');
	writeln('-t<type>       = Set target');
	writeln('	        allowed types are:Linux, Win32, GUI32');
	{	writeln('-t<type>       = target:');
	writeln('		a=32 bit X86 Att&t  (Default) ');
	writeln('		8=32 bit X86 As86             ');
	writeln('		n=32 Bit Nasm		      ');
	writeln;
	}
end;

function GetNextParamStr(var ParCnt:cardinal;var ParStr:string):boolean;
begin
	inc(ParCnt);
	if ParCnt > ParamCount then GetNextParamStr := true
	else  begin
		GetNextParamstr := false;
		ParStr := ParamStr(ParCnt);
	end;
end;


function GetVerboseLEvel(const ParStr:string):boolean;
var vlCnt    : cardinal;
	vlLevel : TVerbose;
begin
	vlCnt 		:= length(ParStr);
	vlLevel 	:= [];
	while vlCnt > 0 do begin
		case ParStr[vlCnt] of
		'c':vlLevel := vlLevel + [vrb_config];
		'l':vlLevel := vlLevel + [vrb_Load_Unit];
		'a':vlLevel := vlLevel + [vrb_Auto_Load];
		'r':vlLevel := vlLevel + [vrb_Recomp_Reason];
		'e':vlLevel := vlLevel + [vrb_Executing];
		'f':vlLevel := vlLevel + [vrb_Executing_Failed];
		'p':vlLevel := vlLevel + [vrb_Procedure_Name];
		's':vlLevel := vlLevel + [vrb_Source_file];
		'w':vlLevel := vlLevel + [vrb_What_I_Do];
		'o':vlLevel := vlLevel + [vrb_Object_Count];
		't':vlLevel := vlLevel + [vrb_Timing];
		'A':vlLevel := vlLevel + [vrb_Config,vrb_Load_Unit,vrb_auto_Load ,vrb_Recomp_Reason,
		vrb_executing,vrb_executing_Failed,vrb_procedure_Name,vrb_Source_file,Vrb_What_I_Do,
		vrb_Object_Count,vrb_Timing];
		'B':vlLevel := vlLevel + [vrb_Source_File,vrb_What_I_Do,vrb_executing];
		'E':vlLevel := vlLevel + [vrb_Source_File,vrb_What_I_Do,vrb_executing,vrb_Object_count,vrb_Timing];
		else exit(true);
	end;
	dec(vlCnt);
end;
SetVerboseLevel(vlLevel);
exit(false);
end;


function HandleNodeListing(const ParStr:String):boolean;
var vlCnt : cardinal;
begin
	HandleNodeLIsting := false;
	vlCnt := 1;
	while (vlCnt<=length(ParStr)) do begin
		case ParStr[vlCnt] of
		'n':GetOptionValues.SetNodeListing(true,CL_Options);
		'N':GetOptionValues.SetNodelIsting(False,CL_Options);
		else HandleNodeListing := true;
	end;
	inc(vlCnt);
end;
end;

function ScanAsmOption(const ParStr:string):boolean;
var vlCnt : cardinal;
begin
	ScanAsmOption := false;
	GetOptionValues.SetRunAssembler(true,CL_Options);
	for vlCnt := 1 to length(ParStr) do begin
		case ParStr[vlCnt] of
		'n':GetOptionValues.SetRunAssembler(False,CL_Options);
		'd':GetOptionValues.SetDeleteAsmFile(true,CL_Options);
		'D':GetOptionValues.SetDeleteAsmFile(false,CL_Options);
		else ScanAsmOption   := true;
	end;
end;
end;

function GetParParameter(var ParParam : cardinal;var ParParameter:string):boolean;
var vlParam:string;
begin
	EmptyString(ParParameter);
	GetParParameter := false;
	vlParam := ParamStr(ParParam);
	if length(vlParam) >2 then begin
		ParParameter := copy(vlParam,3,length(vlParam) - 2);
		exit;
	end else begin
		if not  GetNextParamStr(ParParam,vlParam) then begin
			if vlParam[1] <> '-' then ParParameter :=vlParam
			else dec(ParParam);
		end else GetParParameter := true;
		exit;
	end;
	GetParParameter := true;
end;


function GetAssemblerType(const ParParam:string):boolean;
begin
	if length(ParPAram) > 1 then exit(true);
	if GetConfigValues.fAssemblerType <> AT_None then exit(true);
	case ParParam[1] of
		'a':GetConfigValues.SetAssemblerTYpe(AT_X86Att,CL_Options);
		'8':GetConfigValues.SetAssemblerType(AT_As86,CL_Options);
		'n':GetConfigValues.SetAssemblerTYpe(AT_Nasm86,CL_Options);
		else begin
			exit(true);
		end;
	end;
	exit(false);
end;



function HandleKeepOpt(var ParCnt : cardinal;const ParParam : string):boolean;
var
	vlCH : char;
	vlFl : char;
begin
	while ParCnt <= length(ParParam) do begin
		vlCh := ParParam[ParCnt];
		inc(ParCnt);
		case vlCh of
		'+','-':begin
			GetOptionValues.SetOptimizeModes(COPT_Keep_Contents,vlCh='+',CL_Options);
			exit(false);
		end;
		'1':begin
			
			if ParCnt > length(ParParam) then exit(true);
			vlFl := ParParam[ParCnt];
			inc(ParCnt);
			if(vlFl <> '+') and  (vlFl <> '-') then exit(true);
			case vlCh of
			'1':GetOptionValues.SetOptimizeModes([OPT_Keep_Relaxed_Contents],vlFl='+',CL_Options);
			else exit(true);
		end;
	end;
	else exit(true);
end;
end;
exit(false);
end;

function HandleCheck(const ParParam : string) : boolean;
var
	vlCnt : cardinal;
begin
	vlCnt := 1;
	while vlCnt <= length(ParParam) do begin
		case ParParam[vlCnt] of
			'u':GetOptionValues.SetVarUseCheck(true,CL_Options);
			else begin
				exit(true);
			end;
		end;
		inc(vlCnt);
	end;
	exit(false);
end;

function HandleOptimize(const ParParam : string):boolean;
var
	vlCnt : cardinal;
	vlCh  : char;
begin
	vlCnt := 1;
	while vlCnt <= length(ParParam) do begin
		vlCh := ParParam[vlCnt];
		inc(vlCnt);
		case vlCh of
		'k':if HandleKeepOpt(vlCnt,ParParam) then exit(true);
		else exit(true);
	end;
end;
exit(false);
end;

function HandleOptionConfigVariables(const ParParameter : string ) : boolean;
var
	vlIsPos : cardinal;
	vlName  : string;
	vlValue : string;
begin
	vlIsPos := pos('=',ParParameter);
	if vlIsPos = 0 then exit(true);
	vlName  := copy(ParParameter,1,vlIsPos -1);
	vlValue := copy(ParParameter,vlIsPos +1,length(ParParameter) - vlIsPos);
	trim(vlName);
	trim(vlValue);
    vgOptionVariableList.AddVariable(vlName,vlValue);
	exit(false);
end;


function HandleUnitOptions(const ParParameter: string) : boolean;
var
	vlCnt : cardinal;
begin
	vlCnt := 1;
	if length(ParParameter) = 0 then exit(true);
   while (vlCnt <= length(ParParameter)) do begin
		case ParParameter[vlCnt] of
		'n':GetOptionValues.SetAutoLoad(false,CL_Options);
		else exit(true);
		end;
		inc(vlCnt);
	end;
	exit(false);
end;

function GetParameters:boolean;
var vlCnt   : cardinal;
	vStr    : string;
	vlParam : String;
	vlTarget: string;
begin
	GetParameters := false;
	vlCnt         := 0;
	repeat
		if GetNextParamStr(vlCnt,vStr) then break;
		if vstr[1]='-' then begin
			vlParam := copy(vStr,3,length(vStr) - 2);
			case vStr[2] of
				'o':begin
						if GetParParameter(vlCnt,vlParam) then exit(true);
						GetOptionValues.SetOutputObjectPath(vlParam,CL_Options);
         		end;
				'O':if HandleOptimize(vlParam) then GetParameters := true;
				'C':if HandleCheck(vlParam) then GetParameters := true;
				't':begin
					GetParameters := true;
					if GetParParameter(vlCnt,vlParam) then exit;
					GetOptionValues.SetTargetOs(vlParam,CL_Options);
					GetParameters := false;
				end;
				'd':GetOptionValues.SetGenerateDebug(True,CL_Options);
				'D':begin
					if GetParParameter(vlCnt,vlParam) then exit(true);
					if HandleOptionConfigVariables(vlParam) then exit(true);
				end;
				'e':GetOptionValues.SetGnuStyleErrors(True,cl_options);
				'c':begin
					if  GetParParameter(vlCnt,vlParam) then exit(true);
					NativeToLinux(vlParam);
					GetOptionValues.SetConfigFile(vlParam,cl_options);
				end;
				'a':if ScanAsmOption(vlParam) then begin
					GetParameters := true;
				end;
				'v':if GetVerboseLevel(vlParam) then begin
					GetParameters := true;
				end;
				'h':PrintOptions;
				'l':if HandleNodeListing(vlParam) then GetParameters := true;
				'u':if HandleUnitOptions(vlParam) then begin
					GetParameters := true;
				end;
				'r':begin
					GetOptionValues.SetRebuild(true,CL_Options);
					GetParameters := length(vStr)>3;
					if length(vStr) = 3 then begin
						case vStr[3] of
						'b':GetOptionValues.SetBuild(true,CL_Options);
					end;
					
				end;
			end;
			else begin
				GetParameters := true;
				exit;
			end;
		end;
	end else begin
		if GetOptionValues.IsInputFileSet then begin
			GetParameters := true;
			exit;
		end;
		NativeToLinux(vStr);
		GetOptionValues.SetInputFile(vStr,Cl_Options);
	end;

	until vlCnt > paramcount;
	if (not GetOptionValues.IsInputfileSet) and (vlCnt <> 0) then exit(true);
	if GetOptionValues.fConfigFIle    = nil then begin
		GetOptionValues.GetTargetOsStr(vlTarget);
		if length(vlTarget) = 0 then vlTarget:=DEF_Operating_System;
		GetOptionValues.SetConfigFIle('ela'+vlTarget+'.cfg',cl_Options);
	end;
end;


procedure DoneOptions;
begin
	if vgOptionVariableList <>nil then vgOptionVariableList.Destroy;
end;

procedure InitOptions;
begin
	vgOptionVariableList := TOptionConfigVariableList.Create;
	if ParamCount = 0 then begin
		PrintOptions;
		Halt(0);
	end;
	SetOptionValues(TConfigValues.Create);
	if GetParameters then begin
		writeln;
		writeln('Error : wrong option(s)');
		if GetOptionValues <> nil  then GetOptionValues.Destroy;
		PrintOptions;
		DoneOptions;
		halt(1);
	end;
	SetConfigValues(GetOptionValues.CloneValues);
end;


begin
	vgOptionVariableList := nil;
end.
