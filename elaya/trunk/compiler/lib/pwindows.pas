{    Elaya, the Fcompiler for the elaya language
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
unit pwindows;

interface

type pTPid=longint;
	
function  PGetExitCode : cardinal;
function  pGetDosError : cardinal;
procedure PExecProgram(const ParName,ParParam:string);
function  pGetProgramDir :string;
function  pGetTimer:cardinal;
function  pGetPid :pTPid;
function  pKill(const ParPid : pTPid):boolean;
procedure PLinuxTONative(var ParName : string);
procedure PNativeToLinux(var ParName : string);

const
	pDir_Seperator='\';
	
implementation
uses windows,dos;


procedure PLinuxTONative(var ParName : string);
var
	vlCnt : cardinal;
begin
	vlCnt := length(ParName);
	while vlCnt > 0 do begin
		if ParName[vLCnt]='/' then ParName[vlCnt]:= pDir_Seperator;
		dec(vLCnt);
	end;
end;


function  pGetTimer:cardinal;
var vlH : word;
	vlM : word;
	vlS : word;
	vli : word;
	vlT : cardinal;
begin
	GetTime(vlH,vlM,vlS,vlI);
	vlT := vlH;
	vlT := vlT * 60 + vlM;
	vlT := vlT * 60 + vlS;
	vlT := vlT * 100 + vlI;
	exit(vlT);
end;


function PGetExitCode : cardinal;
begin
	exit(DosExitCode);
end;

function pGetDosError : cardinal;
begin
	exit(DosError);
end;

procedure PExecProgram(const ParName,ParParam:string);
var vlStr:string;
begin
	vlStr := ParName;
	PLinuxToNative(vlStr);
	vlStr := vlStr +' '+ParParam + #0;
	WinExec(@vlStr[1],0);
	sleep(250);
end;

procedure PNativeToLinux(var ParName : string);
var
	vlCnt : cardinal;
begin
	for vlCnt := 1 to length(ParName) do begin
		if ParName[vlCnt] = '\' then ParName[vlCnt] := '/';
	end;
end;

function pGetprogramDir : string;
var
	vlDir : string;
	vlCnt : cardinal;
begin
	vlDir := paramstr(0);
	PNativeToLinux(vlDir);
	exit(vlDir);
end;

function pGetPid :pTPid;
begin
	exit(0);
end;

function pKill(const ParPid : pTPid):boolean;
begin
	exit(true);
end;

end.
