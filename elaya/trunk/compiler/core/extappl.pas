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

unit extappl;
interface
uses sysutils,progutil,elatypes,cmp_type,error,elacons,linklist,stdobj;
	
type
	TExternalAppl = Class(TRoot)
	protected
		procedure Success;virtual;
		procedure Prepare(var ParOption:ansistring);virtual;
		procedure GetExecName(var ParName:ansistring);virtual;
		
	public
		function    Execute:TErrorType;virtual;
	end;
	
	TCompAppl = Class(TExternalAppl)
	private
		voInputFile : TString;
		voOutputDir : TString;

		property iInputFile : TString read voInputFile write voInputFile;
		property iOutputDir : TString read voOutputDir write voOutputDir;

	public
		property fInputFile : TString read voInputFile;
		property fOutputDir : TString read voOutputDir;
		constructor Create(const ParInputFile,ParOutputDir:ansistring);
		destructor Destroy;override;
	end;
	
	TAsmAppl = Class(TCompAppl)
	private
		voRemoveAsmFile : boolean;
		property iRemoveAsmFile : boolean read voRemoveAsmFile write voRemoveAsmFile;
	protected
		procedure Success;override;
		procedure GetExecName(var ParName:ansistring);override;
		procedure PrePare(var ParOptioN:ansistring);override;
	public
		constructor Create(const ParInputFile,ParOutputDir:ansistring;ParRemoveAsmFile : boolean);
	end;
	
	TAs86Appl=class(TCompAppl)
	protected
		procedure GetExecName(var ParName:ansistring);override;
		procedure PrePare(var ParOptioN:ansistring);override;
	end;
	
	TNasmAppl=class(TCompAppl)
	protected
		procedure GetExecName(var ParName:ansistring);override;
		procedure Prepare(var ParOption:ansistring);override;
	end;
	
	TLdwAppl = Class(TCompAppl)
	protected
		procedure GetExecName(var ParName:ansistring);override;
		procedure PrePare(var ParOption:ansistring);override;
	end;
	
implementation

uses elacfg;
{---( TExternalAPpl )---------------------------------------------}



procedure TExternalAppl.Success;
begin
end;


procedure   TExternalAppl.GetExecName(var ParName:ansistring);
begin
	EmptyString(ParName);
end;

procedure TExternalAppl.Prepare(var ParOption:ansistring);
begin
	EmptyString(ParOption);
end;

function TExternalAppl.Execute:TErrorType;
var vlState : ansistring;
	vlOpt   : ansistring;
	vlErr   : TErrorType;
	vlErrStr: ansistring;
begin
	GetExecName(vlState);
	Prepare(vlOpt);
	verbose(VRB_Executing,'Starting '+vlState+':'+vlOpt);
	ExecProg(vlState,vlOpt);
	vlErr :=GetdosError;
	Execute := Err_No_Error;
	if vlErr <> 0 then Execute := ERR_Program_Failed;
	if vlErr = 0 then begin
		if GetExitCode <> 0 then begin
			Str(GetExitCode,vlErrStr);
			Message('Error executing of command:'+vlErrStr);
			Execute := Err_Program_Failed;
		end;
	end
	else begin
		case GetDosError of
		0:message('Program Successful');
		2:Message('Program not found');
		3:Message('Path not found');
		5:Message('Access denied');
		6:Message('Invalid Handle');
		8:Message('Not enough Memory');
		10:Message('Invalid enviroment');
		11:Message('Invalid format');
		else
		message('Unkown error,program failed');
	end;
	Execute := Err_Program_Failed;
end;
if(Execute = ERR_No_Error) then Success;
end;


{----( TCompAppl )-------------------------------------------}

constructor TCompAppl.Create(const ParInputFile,ParOutputDir:ansistring);
begin
	inherited Create;
	iOutputDir := TString.Create(ParOutputDir);
	iInputFile := TString.Create(ParInputFile);
end;

destructor TCompAppl.Destroy;
begin
	inherited Destroy;
	if iOutputDir <> nil then iOutputDir.Destroy;
	if iInputFile <> nil then iInputfile.Destroy;
end;



{----( TAsmAppl )--------------------------------------------}


constructor TAsmAppl.Create(const ParInputFile,ParOutputDir:ansistring;ParRemoveAsmFile : boolean);
begin
	inherited Create(ParInputFile,ParOutputDir);
	iRemoveAsmFile := ParRemoveAsmFile;
end;

procedure TAsmAppl.Success;
var
	vlAsm : ansistring;
	vlErr : longint;
begin
	if iRemoveAsmFile then begin
		iInputFile.GetString(vlAsm);
		vlAsm := vlAsm + CNF_Assem_Ext;
		vlErr := ioresult;
		DeleteFile(vlAsm);
	end;
end;

procedure TAsmAppl.GetExecName(var ParName:ansistring);
begin
	GetConfig.GetAssemblerPath.GetString(ParName);
end;

procedure TAsmAppl.PrePare(var ParOptioN:ansistring);
var
	vlAsm:ansistring;
	vlObj:ansistring;
	vlDir:ansistring;
	vlOpt:ansistring;
begin
	iInputFile.GetString(vlAsm);
	iOutputDir.GetString(vlDir);
	GetConfig.GetAssemblerOptions(vlOpt);
	CombinePath(vlDir,vlAsm,vlObj);
	vlObj     := vlObj + CNF_Object_Ext;
	vlAsm     := vlAsm + CNF_Assem_Ext;
	ParOption := vlOpt + ' ' + vlAsm + ' -o'+vlObj;
end;

{---( TAs86Appl )-----------------------------------------------}

procedure TAs86Appl.GetExecName(var ParName:ansistring);
begin
	ParName := '/usr/bin/as86';
end;

procedure TAs86Appl.PrePare(var ParOptioN:ansistring);
var
	vlAsm:ansistring;
	vlObj:ansistring;
	vlDir:ansistring;
begin
	iInputFile.GetString(vlAsm);
	iOutputDir.GetString(vlDir);
	CombinePath(vlDir,vlAsm,vlObj);
	vlObj := vlObj + CNF_Object_ext;
	vlAsm := vlAsm + cnf_Assem_ext;
	
	ParOption := '-o '+vlObj +' '+vlAsm +' -3';
end;


{----( TNasmAppl )------------------------------------------}

procedure TNasmAppl.GetExecName(var ParName:ansistring);
begin
	ParName := '/usr/bin/nasm';
end;

procedure TNasmAppl.Prepare(var ParOption:ansistring);
var
	vlAsm:ansistring;
	vlObj:ansistring;
	vlDir:ansistring;
begin
	iInputFile.GetString(vlAsm);
	iOutputDir.GetString(vlDir);
	CombinePath(vlDir,vlAsm,vlObj);
	vlObj := vlObj + CNF_Object_ext;
	vlAsm := vlAsm + cnf_Assem_ext;
	ParOption := '-o'+vlObj +' '+vlAsm +' -f elf';
end;

{----( TLdwAppl )--------------------------------------------}

procedure TLdwAppl.GetExecName(var ParName:ansistring);
begin
	GetConfig.GetLinkerPathStr(ParName);
end;

procedure TLdwAppl.PrePare(var ParOption:ansistring);
var
	 vlObj    : ansistring;
	vlDir    : ansistring;
	vlOpt    : ansistring;
	vlOutput : ansistring;
begin
	iInputfile.GetString(vlObj);
	iOutputDir.GetString(vlDir);
	vlObj := vlObj+ cnf_Exe_Ext;
	CombinePath(vlDir,vlObj,vlOutput);
	GetCOnfig.GetLinkerOptions(vlOpt);
	LowerStr(vlOutput);
	ParOption := 'LINK.RES -o'+vlOutput;
	if length(vlOpt) <> 0 then ParOption := ParOption + ' ' + vlOpt ;
end;

end.


