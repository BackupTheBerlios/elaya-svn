{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web  : www.elaya.org

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

unit ProgUtil;
interface
uses largenum,dos,platform;


type pst=^string;
	TSplit=record
	case byte of
	1:(vW1,vW2:word);
	2:(vB1,vB2,vB3,vB4:byte);
end;
TLoHi = packed record
lo,hi:byte;
end;
VRB_Display=(
VRB_Config            ,
VRB_Load_Unit         ,
VRB_Auto_Load         ,
VRB_Recomp_Reason     ,
VRB_Executing         ,
VRB_Executing_Failed  ,
VRB_Procedure_Name    ,
VRB_Source_File	      ,
VRB_What_I_Do	      ,
VRB_Timing	      ,
VRB_Object_Count );
TVerbose=set of VRB_Display;
TFlag=longint;
TPid=pTPid;

procedure SplitFile(const ParFile:String;var ParPath,ParName,ParExt:string);
procedure AppendExt(const ParExt:string;const ParFile:String;var ParOut:String);
procedure PrvDir(var ParName :string);
procedure AddProgramDir(var ParName:string);
function  GetProgramDir : string;

function  GetFileTime(var ParFile:File):longint;
procedure ToOctal(parbyte:byte;var ParOct:string);
procedure ToASString(const ParStr:string;var ParOut:String);
procedure Message(const ParMes:string);
procedure GetWordHex(ParWord:Word;var ParHex:string);
function  Max(parG1,ParG2:Longint):Longint;
function  Min(ParG1,ParG2:Longint):Longint;
function  InitStr(const ParStr:string):pst;
procedure DoneStr(ParStr:PSt);
procedure FormatDateTime(var ParTime,ParDate:string);
procedure UpperStr(var ParStr:string);
procedure LowerStr(var ParStr:string);
procedure TRim(var ParStr:string);
function  GetTimer:cardinal;
function  PtrToHex(ParPtr:pointer):string;
procedure NormFileName(var ParName:string);
function  HexToLongInt(const ParStr:string;var ParError : boolean):TLargeNumber;
function  BinToLongint(const ParStr:string;var ParError : boolean):TLargeNumber;
procedure ExecProg(const ParCmd,ParPar:string);
procedure Freemem(ParPtr:pointer;ParSize:cardinal);
procedure Verbose(ParLevel:VRB_Display;const ParText:String);
procedure Verbose(ParLevel:VRB_Display;const ParArray:Array of const);
procedure SetVerboseLevel(ParLevel:TVerbose);
procedure CombinePath(const ParDir,ParFile:string;var ParOut:string);
function  IntToStr(ParInt:Longint):String;
procedure  GetCpuCycles(var ParLo,ParHi:cardinal);
procedure GetCpuCycles64(var ParTime : int64);

function  GetExitCode:cardinal;
function  GetDosError:cardinal;
procedure ArrayToStr(const ParArray:array of const;var ParStr:String);
function  SplitWord(var ParPos : cardinal;const ParInStr:string;var ParOut:String):boolean;
procedure EmptyString(var ParStr:string);
procedure IncludeIntoString(const ParInString : string;var ParOutString:string;const ParData:array of const);
function  KillProcess(ParPid : TPid):boolean;
function  GetProcessId:TPid;
procedure LinuxTONative(var ParName : string);
procedure NativeTolinux(var ParName : string);
const
	Dir_Seperator=PDir_Seperator;
implementation

var vgVerboseLevel:TVerbose;

procedure NativeToLinux(var ParName : string);
begin
	PNativeToLinux(ParName);
end;
	

procedure LinuxTONative(var ParName : string);
begin
	PLinuxToNative(ParName);
end;

function GetProcessId:TPid;
begin
	exit(pGetPid);
end;

function  KillProcess(ParPid : TPid):boolean;
begin
	exit(pKill(ParPid));
end;

function VarRecTOstring(const ParVar : TVarRec):string;
var
	vlStr : string;
begin
	EmptyString(vlStr);
	case ParVar.vType of
		vtInteger :vlStr := IntToStr(ParVar.vInteger);
		vtChar    :vlStr := ParVar.vChar;
		vtBoolean :if ParVar.vBoolean then vlStr :=  'TRUE' else vlStr :=  'FALSE';
		vtString  :if ParVar.vString <> nil then vlStr := ParVar.vString^
		else vlStr := 'null string';
		{                vtObject,vtClass : if ParVar.vClass <> nil then vlStr := ParVar.vClass.ClassName
		else vlStr := 'null class';
		}                else vlStr := 'unkown type :' + IntToStr(ParVar.vType);
	end;
	exit(vlStr);
end;

procedure IncludeIntoString(const ParInString : string;var ParOutString:string;const ParData:array of const);
var vlCnt     : cardinal;
	vlDataCnt : cardinal;
begin
	vlcnt     := 1;
	vlDataCnt := 0;
	EmptyString(ParOutString);
	while (vlCnt<=length(ParInString)) do begin
		if ParInString[vlCnt]='%' then begin
			if vlDataCnt < high(ParData) then begin
				ParOutString := ParOutString + VarRecToString(ParData[vlDataCnt]);
				inc(vlDataCnt);
			end;
		end else begin
			ParOutString := ParOutString + ParInString[vlCnt];
		end;
		inc(vlCnt);
	end;
end;

procedure EmptyString(var ParStr : string);
begin
	SetLength(ParStr,0);
end;

function SplitWord(var ParPos : cardinal;const ParInstr : string;var ParOut : string):boolean;
var vlCnt : cardinal;
begin
	vlcnt := 0;
	EmptyString(ParOut);
	while (ParPos <= length(ParInstr)) and (ParInstr[ParPos] in [#9,#32]) do inc(ParPos);
	if ParPos > length(PArInstr) then exit(true);
	if ParInstr[ParPos] in ['a'..'z','A'..'Z','_','0'..'9'] then begin
		while (ParPos <=length(ParInstr)) and (ParInstr[ParPos] in ['a'..'z','A'..'Z','_','0'..'9']) do begin
			inc(VlCnt);
			ParOut[vlCnt] := ParInstr[ParPos];
			inc(ParPos);
		end;
	end else begin
		inc(vlCnt);
		ParOut[vlCnt] := ParInstr[ParPos];
		inc(ParPos);
	end;
	SetLength(ParOut, vlCnt);
	upperstr(ParOut);
	exit(false);
end;



procedure ArrayToStr(const ParArray:array of const;var ParStr:String);
var vlCnt : cardinal;
begin
	EmptyString(ParStr);
	vlCnt     := 0;
	while vlCnt <= high(ParArray) do begin
		ParStr := ParStr + VarRecToString(ParArray[vlCnt]);
		inc(vlCnt);
	end;
end;

function  GetExitCode:cardinal;
begin
	exit(pGetExitCode);
end;

function  GetDosError:cardinal;
begin
	exit(pGetDosError);
end;

procedure GetCpuCycles(var ParLo,ParHi:cardinal);
assembler;
asm
cpuid
xor %eax,%eax
xor %edx,%edx
rdtsc
mov ParLo,%edi
mov %eax,(%edi)
mov ParHi,%edi
mov %edx,(%edi)
end;


procedure GetCpuCycles64(var ParTime : int64);
assembler;
asm
	cpuid
	xor %eax,%eax
	xor %edx,%edx
	rdtsc
	movl ParTime,%edi
	movl %eax,(%edi)
	movl %edx,4(%edi)
end;

function IntToStr(ParInt:Longint):String;
var vlStr:string;
begin
	str(parInt,vlStr);
	IntToStr := vlStr;
end;


function  GetFileTime(var ParFile:File):longint;
var vlLi:longint;
begin
	GetFTime(ParFile,vlLi);
	GetFileTime := vlLi;
end;

procedure CombinePath(const ParDir,ParFile:string;var ParOut:string);
var vlOut : String;
	vlFIle : string;
begin
	vlOut := ParDir;
	vlFile := ParFile;
	if (length(vlOut)> 0) and (vlOut[length(PArDir)] <> '/') then vlOut := vlOut + '/';
	if (length(vlFile) > 0) and (vlFile[1] ='/') then delete(vlFIle,1,1);
	ParOut := vlOut + vlFile;
end;

procedure PrvDir(var ParName :string);
var vlCnt : byte;
begin
	vlCnt := length(ParName);
	if vlCnt > 0 then begin
		repeat
			if (vlCnt = 3) and (ParName[2]=':') and (ParName[3]='/') then break;
			dec(vlCnt);
			if (vlCnt > 0) and (ParName[vlCnt] in [':','/']) then break;
		until (vlCnt = 0);
		if ((vlCnt<>3) or (ParName[2]<>':')) and (vlCnt > 1) then dec(vlCnt);
		SetLength(ParName,vlCnt);
	end;
end;

procedure SetVerboseLevel(ParLevel:TVerbose);
begin
	vgVerboseLEvel := ParLevel;
end;

procedure Verbose(ParLevel:VRB_Display;const ParText:String);
begin
	if ParLevel in vgVerboseLevel then writeln(ParText);
end;

procedure Verbose(ParLevel:VRB_Display;const ParArray:Array of const);
var vlStr:string;
begin
	if ParLevel in vgVerboseLevel then begin
		ArrayToStr(ParArray,vlStr);
		writeln(vlStr);
	end;
end;

procedure ExecProg(const ParCmd,ParPar:string);
begin
	pExecProgram(parcmd,ParPar);
end;

procedure ToOctal(parbyte:byte;var ParOct:string);
var vlCnt  : cardinal;
	vlByte : byte;
begin
	vlByte := ParByte;
	vlCnt := 3;
	SetLength(ParOct,vlCnt);
	repeat
		ParOct[vlCnt] := chr(48 + (vlByte and 7));
		vlByte := vlByte shr 3;
		dec(vlCnt)
	until vlcnt = 0;
end;


function  BinToLongint(const ParStr:string;var ParError : boolean):TLargeNumber;
var vlCnt : cardinal;
	vlLi  : TLArgeNumber;
begin
	vlCnt := 1;
	LoadLong(vlLi, 0);
	while vlCnt <=length(ParStr) do begin
		LargeAdd(vlLi,vlLi);
		case ParStr[vlCnt] of
	'0':begin end;
		'1':LargeAddLong(vlLi,1);
		else begin
			ParError := true;
			exit;
		end;
	end;
	inc(vlcnt);
end;
ParError :=false;
exit(vlLi);
end;

function  HexToLongInt(const ParStr:string;var ParError : boolean):TLargeNumber;
var vlCnt  : cardinal;
	vlLi   : TLargeNumber;
	vlLI2  : TLargeNumber;
	vlBt   : byte;
begin
	vlCnt := 1;
	LoadLOng(vlLi,0);
	LoadLong(vlLi2, 16);
	while vlCnt <=length(ParStr) do begin
		LargeMul(vlLi,vlLi2);
		vlBt := byte(ParStr[vlCnt]);
		case parstr[vlCnt] of
			'0'..'9':dec(vlBt,48);
			'A'..'F':dec(vlBt,byte('A')-10);
			'a'..'f':dec(vlBt,byte('a')-10);
			else begin
				ParError := true;
				exit;
			end;
		end;
		if LargeAddInt(vlLi,vlBt) then ParError := true;
		inc(vlCnt);
	end;
	ParError := false;
	exit(vlLi);
end;

procedure ToASString(const ParStr:string;var ParOut:String);
var vlCnt:cardinal;
	vlStr : string;
	vlCh:char;
	vlLe :cardinal;
begin
	vlCnt := 1;
	EmptyString(ParOut);
	vlLe := length(ParStr);
	while vlCnt <= vlLe do begin
		vlCh  := ParStr[vlCnt];
		case vlCh of
		'\':ParOut := ParOut +'\'+ vlCh;
		#0..#31,#128..#255:begin
			ToOctal(byte(vlCh),vlStr);
			ParOut := ParOut+ '\'+vlStr;
		end;
		'"':ParOut :=ParOut +  '\"';
		else ParOut := ParOut + vlCh;
	end;
	inc(vlCnt);
end;
end;

procedure Message(const ParMes:string);
begin
	writeln(ParMEs);
end;

procedure Trim(var ParStr:string);
begin
	while (length(PArstr) > 0) and ((ParStr[1] =#32) or (Parstr[1] =#9)) do delete(ParStr,1,1);
	while (length(ParStr) > 0) and ((ParStr[length(ParStr)] = #32) or (ParStr[length(ParStr)] = #9)) do SetLength(ParStr,length(ParStr)-1);
end;



function  GetProgramDir : string;
var vlFIleName,vlProgDir,vlDm1,vlDm2 : string;
begin
	vlFileName := pGetProgramDir;
	SplitFile(vlFileName,vlProgDir,vlDm1,vlDm2);
	exit(vlProgDir);
end;

procedure AddPRogramDir(var ParName:string);
var vlProgDir,vlDm1,vlDm2,vlDm3:string;
begin
	vlProgDir := GetProgramDir;
	SplitFile(ParName,vlDm1,vlDm2,vlDm3);
	CombinePath(vlProgDir,vlDm1 + '.' + vlDm3,ParName);
end;

procedure SplitFile(const ParFile:String;var ParPath,ParName,ParExt:string);
var vlCnt : cardinal;
	vlCh  : char;
	vlStr : string;
	
begin
	vlCnt := length(ParFile);
	EmptyString(vlStr);
	EmptyString(ParPath);
	EmptyString(ParName);
	EmptyString(ParExt);
	while (vlCnt >= 1) and not(Parfile[vlCnt] in ['.',':','/']) do begin
		vlCh := ParFile[vlCnt];
		vlStr := vlCh + vLStr;
		dec(vlCnt);
	end;
	if vlCnt = 0 then begin
		ParName := vlStr;
		exit;
	end;
	case ParFile[vlCnt] of
	'.':begin
		ParExt := '.'+vlStr;
		EmptyString(vlStr);
		dec(vlCnt);
		while (vlCnt >= 1) and not(ParFile[vlCnt] in [':','/']) do begin
			vlCh := ParFIle[vlCnt];
			vlStr := vlCh + vLStr;
			dec(vlCnt);
			
		end;
		ParName :=vlStr;
	end;
	':','/':ParName := vlStr;
end;
ParPath := copy(ParFile,1,vlCnt);
end;


procedure AppendExt(const ParExt:string;const ParFile:String;var ParOut:String);
var
	vlS1,vlS2,vlS3:string;
begin
	SplitFile(ParFile,vlS1,vlS2,vlS3);
	ParOut := vlS1 + vlS2 + ParExt;
end;

procedure NormFileName(var ParName:string);
var vlN1,vlN2,vlN3:string;
begin
	SplitFile(ParName,vln1,vlN2,vlN3);
	LoWerStr(vlN2);
	ParName := vlN2;
end;



function PtrToHex(ParPtr:pointer):string;
var vlLi   : cardinal;
	vlStr  : string;
	vlStr2 : string;
begin
	vlLi := cardinal(ParPtr);
	GetWordHex(vlLi,vlStr);
	vlLi := vlLi shr 16;
	GetWordHex(vlLi,vlStr2);
	vlStr := vlStr2 + vlStr;
	PtrToHex:= vlStr;
end;

function GetTimer:cardinal;
begin
	exit(pGetTimer);
end;


procedure GetWordHex(ParWord:word;var ParHex:string);
var vlCnt:word;
	vlBt:byte;
begin
	vlCnt := 4;
	EmptyString(ParHex);
	while vlCnt > 0 do begin
		vlBt := 48 + (ParWord and 15);
		if vlBt >= 58 then inc(vlBt,7);
		ParHex := chr(vlBt) + ParHex;
		ParWord := PArWord shr 4;
		dec(vlcnt);
	end;
end;

function Max(parG1,ParG2:Longint):Longint;
begin
	Max := ParG1;
	if ParG2 > ParG1 then Max := ParG2;
end;

function Min(ParG1,ParG2:Longint):Longint;
begin
	Min := ParG1;
	if ParG2 < ParG1 then Min := ParG1;
end;


procedure UpperStr(var ParStr:string);
var vCnt : cardinal;
begin
	vCnt  := length(ParStr);
	while vCnt > 0 do begin
		case ParStr[vCnt] of
		'a'..'z':dec(ParStr[vCnt],32);
	end;
	dec(vCnt);
end;
end;

procedure LowerStr(var ParStr:string);
var vCnt : cardinal;
begin
	vCnt := length(ParStr);
	while vCnt > 0 do begin
		case ParStr[vCnt] of
		'A'..'Z':inc(ParStr[vCnt],32);
	end;
	dec(vCnt);
end;
end;

procedure AppendNumberToStr(ParNum:longint;ParPre:Char;var ParStr:string);
var vTmp:string;
begin
	str(ParNum,vTmp);
	ParStr := ParStr +ParPre+ vTmp;
end;

procedure FormatDateTime(var ParTime,ParDate:string);
var vhh,vmi,vss,vss100 : word;
	vYYYY,vMM,VDD,VWW : word;
begin
	getTime(vHh,vMi,Vss,VSS100);
	getDate(vYYYY,vMM,vDD,vWW);
	str(vhh,ParTime);
	ParTime := ParTime;
	AppendNumberToStr(vmi,':',ParTime);
	AppendNumberToStr(vSS,':',ParTime);
	str(vDD,ParDate);
	AppendNumberToStr(vMM,'-',ParDate);
	AppendNumberToStr(VYYYY,'-',ParDate);
end;




function InitStr(const ParStr:string):pst;
var vlTmp:pst;
begin
	getmem(vlTmp,length(ParStr) + 1);
	vlTmp^ := PArStr;
	exit(vlTmp);
end;


procedure DoneStr(ParStr:PSt);
begin
	if ParStr <> nil then freemem(ParStr,length(ParStr^)+ 1);
end;

procedure Freemem(ParPtr:pointer;ParSize:cardinal);
begin
	system.freemem(ParPtr,ParSize);
end;

begin
	
	SetVerboseLevel([VRB_Executing,vrb_Source_FIle,vrb_What_I_Do]);
end.
