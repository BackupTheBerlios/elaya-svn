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
unit ela_comp;

interface
uses cmp_cons,elacfg,confval,progutil,stdobj,options,error,elap,elacons,cmp_base,cmp_type;
type
	TElaCompiler=class(TEla_Parser)
	public
		voSaveTicksLo : int64;
		voSaveTicksHi : int64;
		voCompTicksLo : int64;
		voCompTicksHi : int64;
		voSaveTime    : cardinal;
		voCompTime    : cardinal;
		voPrvErrLine  : longint;
		voPrvErrCol   : longint;
	protected
		procedure   Commonsetup;override;
	public
		property iPrvErrCol   : longint read voPrvErrCol  write voPrvErrCol;
		property iPrvErrLine  : longint read voPrvErrLine write voPrverrLine;
		property fSaveTime    : cardinal read voSaveTime  write voSaveTime;
		property fCompTime    : cardinal read voCompTime  write voCompTime;
		property fSaveTicksLo : int64 read voSaveTicksLo write voSaveTicksLo;
		property fSaveTicksHi : int64 read voSaveTicksHi write voSaveTicksHi;
		property fCompTicksLo : int64 read voCompTicksLo write voCompTicksLo;
		property fCompTicksHi : int64 read voCompTicksHi write voCompTicksHi;
		procedure   GetConfigFileName(var ParName : ansistring);override;
		PROCEDURE   PrintErr (const ParLine : ansistring;  ParCol: INTEGER);
		procedure   GetErrorDescr(ParErr : TErrorType;var ParText:string);
		function    NewCompiler(const ParFile:ansistring):TCompiler_Base;override;
		procedure   ErrorHeader;override;
		procedure   ErrorMessage(ParItem : TErrorItem);override;
		Procedure   ErrorFooter(ParNum : cardinal);override;
		procedure   PreProcessParsed;override;
		procedure   PostProcessParsed;override;
		procedure   PreSave;override;
		procedure   PostSave;override;
		procedure   PostCompile;override;
		procedure   PreParse;override;
		procedure   PostParse;override;
		procedure   WhenError;override;
		procedure   WhenSuccess;override;
		procedure   CalculateTimes;
	end;
	
	
	
implementation

procedure TElaCompiler.Commonsetup;
begin
	inherited Commonsetup;
	fSaveTicksLo := 0;
	fSaveTicksHi := 0;
	fCompTicksLo := 0;
	fCompTicksHi := 0;
	fSaveTime    := 0;
	fCompTime    := 0;
	iPrvErrLine := -1;
	iPrvErrCol  := -1;
end;

procedure  TElaCompiler.GetConfigFileName(var ParName : ansistring);
begin
	GetCOnfigValues.GetConfigFIleStr(ParName);
end;

procedure TElaCompiler.WhenError;
begin
	CalculateTimes;
	writeln('Compiling file failed');
end;

procedure TElaCompiler.WhenSuccess;
begin
	writeln('Compiling success');
end;

procedure TElaCompiler.PreParse;
var 
	vlLo   : cardinal;
	vlHi   : cardinal;
begin
	verbose(vrb_source_file,fFileName);
	verbose(vrb_what_I_Do,'Starting parser');
	fCompTime := GetTimer;
	GetCpuCycles(vlLo,vlHi);
	fCompTicksLo := vlLo;
	fCompTicksHi := vlHi;
end;

procedure TElaCompiler.PostParse;
begin
end;


procedure TELaCOmpiler.CalculateTimes;
var     vlLo : cardinal;
	vlHi : cardinal;
begin
	fCompTime := GetTimer - fCompTime;
	GetCpuCycles(vlLo,vlHi);	
	fCompTicksHi := vlHi - fCompTicksHi;
	fCompTicksLo := vlLo - fCompTicksLo;
end;


procedure   TElaCompiler.PreProcessParsed;
begin
	verbose(vrb_what_I_Do,'Processing parsed data');
end;

procedure   TElaCompiler.PostProcessParsed;
begin
	CalculateTimes;
end;

procedure   TElaCompiler.PreSave;
var vlLo : cardinal;
	vlHi : cardinal;
begin
	verbose(vrb_what_I_Do,'Saving...');
	fSaveTime := GetTimer;
	GetCpuCycles(vlLo,vlHi);
	fSaveTicksHi := vlHi;
	fSaveTicksLo := vlLo;
end;

procedure   TElaCompiler.PostSave;
var vlLo : cardinal;
	vlHi : cardinal;
begin
	fSaveTime := GetTimer - fSaveTime;
	GetCpuCycles(vlLo,vlHi);
	fSaveTicksHi := vlHi - fSaveTicksHi;
	if fSaveTicksLo > vlLo then fSaveTicksHi := fSaveTicksHi - 1;
	fSaveTicksLo := vlLO - fSaveTicksLo;
end;

procedure  TElaCompiler.PostCompile;
begin	
	verbose(vrb_Timing,'Compile Time....:'+IntToStr(fCompTime));
	verbose(vrb_Timing,'Compile Ticks...:'+IntToStr((fCompTicksLo div 1000000) +fCompTicksHi*4294) + ' MTicks');
	verbose(vrb_Timing,'Save Time.......:'+IntToStr(fSaveTime));
	verbose(vrb_Timing,'Save Ticks......:'+IntToStr((fSaveTicksLo div 1000) + fSaveTicksHi*4294967- fSaveTicksHi div 3) + ' KTicks');
end;

function TElaCompiler.NewCompiler(const ParFile:ansistring):TCompiler_Base;
begin
	NewCompiler := (TElaCompiler.Create(ParFile));
end;


procedure TElaCompiler.GetErrorDescr(ParErr : TErrorType;var ParText:string);
var 
	vlString : ansistring;
begin
	SetLength(ParText,0);
	GetErrorText(ParErr,Partext);
	if length(partext) = 0 then begin
		GetError(ParErr,vlString);
		ParText := vlString;{TODO clean up use of string when GetErrorText=ansistring}
	end;
end;

PROCEDURE TElaCompiler.PrintErr (const ParLine : ansistring; ParCol: INTEGER);
var
	vlCnt : cardinal;
BEGIN
	vlCnt := 1;
	WHILE (vlCnt < ParCol) and (vlCnt<=length(ParLine)) DO BEGIN
		IF ParLine[vlCnt] = C_TAB tHEN Write(C_TAB) ELSE Write(' ');
		inc(vlCnt);
	END;
	Writeln( '^');
END;


procedure TElaCompiler.ErrorHeader;
begin
	writeln;
	writeln;
	writeln('  Errors :');
	writeln;
end;

procedure  TElaCompiler.ErrorMessage(ParItem : TErrorItem);
var
	vlErrorPos  : longint;
	vlErrorLine : longint;
	vlErrorCol  : longint;
	vlErrorCode : TErrorType;
	vLExtra     : ansistring;
	vlError     : string;
	vlLine      : ansistring;
	vlFileName  : ansistring;
begin
	ParItem.GetInfo(vlFileName,vlErrorCode,vlErrorLine,vlErrorCol,vlErrorPos,vlExtra);
	GetLine(vlErrorPos,vlLine);
	writeln;
	if GetConfigValues.fGnuStyleErrors then begin
		write(vlFileName,':',vlErrorLine,': [',vlErrorCol,']')
	end else begin
		if iPrvErrLine <> vlErrorLine then writeln(vlLine);
		if((iPrvErrLine <> vlErrorLine) or (iPrvErrCol <> vlErrorCol)) then PrintErr(vlLine, vlErrorCol);
		write('line ',vlErrorLine,' position ',vlErrorCol,', ');
		iPrvErrLine := vlErrorLine;
		iPrvErrCol  := vlErrorCol;
	end;
	GetErrorDescr(vlErrorCode,vlError);
	Write(vlErrorCode,'/',vlError);
	if length(vlExtra)> 0 then write('(',vlExtra,')');
end;

Procedure  TElaCompiler.ErrorFooter(ParNum : cardinal);
begin
	writeln;
	write(ParNum,' Error');
	if ParNum <> 1 then write('s');
	writeln;
	writeln;
end;


end.
