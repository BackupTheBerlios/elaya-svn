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

unit platform;
interface
uses dos,strings;


type pTPid= longint;
	
function  pGetExitCode:cardinal;
function  pGetDosError:cardinal;
function  pGetTimer:cardinal;
procedure pExecProgram(const ParName,ParPar:string);
function  pGetProgramDir : string;
function  pKill(const ParPid : pTPid):boolean;
function  pGetPid : pTPid;
procedure PLinuxTONative(var ParName : string);
procedure PNativeToLinux(var ParName : string);
const
	
	PDir_Seperator='/';

	type TMapInfo=record
		vgFd    : longint;
		vgAddr  : pointer;
		vgSize  : longint;
		vgMapSize : longint;
	end;
	
implementation
function readlink(const ParPath : Pchar;ParBuf:Pchar;ParSize : cardinal):longint;cdecl;external 'c' name 'readlink';
function getpid:pTPid;cdecl;external 'c' name 'getpid';
function kill(ParPid :pTPid;ParSig : longint):Longint;cdecl;external 'c' name 'kill';
function mmap(start : pointer;ParSize : longint;ParProt: longint;ParFlags : longint;ParFd :longint;offset : longint):longint;cdecl;external 'c' name 'mmap';
function munmap(start :pointer;ParSize : longint) : longint; cdecl;external 'c' name 'munmap';
function open(const ParPathName : pchar;ParFlags : longint):longint;cdecl;external 'c' name 'open';

const O_RDONLY = 0;
	   PROT_READ=1;
		MAP_SHARED=1;
		MAP_PRIVATE=2;

procedure PLinuxTONative(var ParName : string);
begin
end;

procedure PNativeToLinux(var ParName : string);
begin
end;

function  pGetPid : pTPid;
begin
	exit(GetPid);
end;

function  pKill(const ParPid : pTPid):boolean;
begin
	exit(kill(ParPid,9) <> 0);
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

procedure pExecProgram(const ParName,ParPar:string);
begin
	exec(ParName,ParPar);
end;

function  pGetExitCode:cardinal;
begin
	exit(DosExitCode);
end;

function  pGetDosError:cardinal;
begin
	exit(DosError);
end;

function pGetProgramDir : string;
var vlPid : string;
	vlLink: array[0..255] of char;
	vlName: string;
	vlRet : longint;
	vlOut : string;
begin
	str(getPid,vlPid);
	vlName := '/proc/'+vlPid+'/exe'+#0;
	vlRet := readlink(@vlName[1],@vlLink,high(vlLink));
	if(vlRet >= 0) and(vlRet < 255) then begin
		SetLength(vlOut,vlRet);
		Move(vlLink,vlOut[1],vlRet);
	end else begin
		SetLength(vlOut,0);
	end;
	exit(vlOut);
end;


end.

