{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2002  J.v.Iddekinge.
Web  : www.elaya.org
Email: iddekingej@lycos.com

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

unit files;

interface
uses dos,cmp_type,buffers,progutil,stdobj,simplist;
	{$i-}
const
	Fer_No_Error		      = 0;
	Fer_File_Allready_Open 	= -1;
	
	
type
	
	TSearchPath=class(TSmStringItem)
		procedure GetPath(var ParPath:ansistring);
	end;
	
	TSearchPathList=class(TSMStringList)
	private
		function MakeItem(const ParString : ansistring) : TSmStringItem;override;
	public
		procedure AddPath(const parPath:ansistring);
		function  GetPathByNum(ParNum : cardinal;var ParStr:ansistring):boolean;
	end;
	
	TFIleBuffer=class(TMemoryBlock)
	end;
	
	TFile=class(TRoot)
	private
		voFile	    : File;
		voBuffer     : TFIleBuffer;
		voOpen	    : boolean;
		voBuffered   : boolean;
		voError	    : TErrorType;
		voEof        : boolean;
		voReadPos    : cardinal;
		voReadSize   : cardinal;
		voReadWrite  : boolean;
		voFileName       : TString;
		voLaCh           : char;
		voHasLa          : boolean;
		voSearchPathList : TSearchPathList;
		
		procedure SetError(ParError:TErrorType);
		procedure SetFileName(const ParName:ansistring);
		
		property  iLaCh           : char            read voLaCh           write voLaCh;
		property  iHasLa          : boolean         read voHasLa          write voHasLa;
		property  iSearchPathList : TSearchPathList read voSearchPathList write voSearchPathList;
		property  iOpen           : boolean         read voOpen           write voOpen;
		property  iFileName       : TString         read voFileName       write voFileName;
		property  iBuffer         : TFileBuffer     read voBuffer         write voBuffer;
		property  iReadPos        : cardinal		  read voReadPos        write voReadPOs;
		property  iReadSize       : cardinal        read voReadSize       write voReadSize;
		property  iBuffered       : boolean         read voBuffered       write voBuffered;

	protected
		procedure   clear;override;
		procedure   commonsetup;override;

	public
		property  fReadPos  : cardinal    read voReadPos;
		property  fReadSize : cardinal    read voReadSize;
		property  fBuffer   : TFileBuffer read voBuffer;
		property  fBuffered : boolean     read voBuffered;
		property  fFileName : TString     read voFileName;
		property  fError    : TErrorType  read voError;
		property  fOPen     : boolean     read voOpen;
		
		constructor create(ParSize : cardinal);
		procedure   DoneBuffer;
		
		
		function    GetPathByNum(ParNum :cardinal;var ParStr : ansistring):boolean;
		procedure   AddPath(const ParStr : ansistring);
		procedure   AddProgramDirToPath;
		procedure   GetFileNameStr(var ParName:ansistring);
		procedure   SetBuffer(ParSize : cardinal);
		function    OpenFile(const ParFileName:ansistring):boolean;
		function    CreateFile(const PArFileNAme:ansistring):boolean;
		function    close:boolean;
		function    ReadBlock(var ParBlk;ParSize : cardinal;var parRead : cardinal):boolean;
		function    WriteBlock(var ParBlk;ParSize : cardinal;var ParWrite : cardinal):boolean;
		function    Seek(PArPos:longint):boolean;
		
		function    GetCreateTime:longint;
		function    GetFileSize:Longint;
		function    GetfilePos:Longint;
		function    GetFileBufferPos:Longint;
		function    GetReadWrite:boolean;
		
		Function    WriteFile:boolean;
		procedure   WriteDirect(ParPos:Longint;var ParInfo;ParSIze : cardinal);
		function    ReadFile:boolean;
		function    ReadFromBuffer(ParSize:cardinal;var ParBuffer):boolean;
		function    WriteToBuffer(ParSize:cardinal;const PArBuffer):boolean;
		procedure   SetEof(ParEof:boolean);
		procedure   SetReadWrite(ParReadWrite:boolean);
		function    ReadLine(var ParStr : ansistring):boolean;
		function    ReadFromFile(var ParBuf ;ParSize : cardinal;var ParRet:cardinal):boolean;
		function    WriteFromFile(var ParBuf;ParSize : cardinal;var ParRet:cardinal):boolean;
		function    GetEof:boolean;
	end;
	
	
implementation

{----( TSearchPath )----------------------------------------------}


procedure TSearchPath.GetPath(var ParPath:ansistring);
begin
	ParPath  := fString;
end;

{----( TSearchPathList )------------------------------------------}


function TSearchPathList.MakeItem(const ParString : ansistring) : TSmStringItem;
begin
	exit(TSearchPath.Create(ParString));
end;


procedure TSearchPathList.AddPath(const ParPath:ansistring);
var vlPath : ansistring;
	vlPos  : byte;
	vlStr  : ansistring;
begin
	vlPath := ParPath;
	while (length(vlPath) <> 0) do begin
		vlPos := pos(';',vlPath);
		if vlPos = 0 then vlPos := length(vlPath) + 1;
		vlStr := copy(vlPath,1,vlPos - 1);
		AddString(vlStr);
		delete(vlPath,1,vlPos);
	end;
end;

function TSearchPathList.GetPathByNum(ParNum : cardinal;var ParStr:ansistring):boolean;
begin
	exit(not(GetStringByPosition(ParNum,ParStr)));
end;

{----( TFile )----------------------------------------------------}

function TFile.GetPathByNum(ParNum :cardinal;var ParStr : ansistring):boolean;
begin
	exit(iSearchPathList.GetPathByNum(ParNum,ParStr));
end;


procedure TFile.AddProgramDirToPath;
begin
	AddPath(GetProgramDir);
end;

procedure TFile.AddPath(const ParStr : ansistring);
var 
	vlPath : ansistring;
begin
	vlPath := ParStr;
	NativeToLinux(vlPath);
	iSearchPathList.AddPath(vlPath);
end;


constructor TFile.create(ParSize : cardinal);
begin
	inherited create;
	SetBuffer(ParSize);
end;

procedure TFile.commonsetup;
begin
	inherited commonsetup;
	iBuffered        := false;
	voOpen          := false;
	voEof           := false;
	voOpen          := false;
	iReadPos        := 0;
	iReadSize       := 0;
	iBuffer         := nil;
	iFileName       := nil;
	iHasLa          := false;
	iLaCh           := #0;
	iSearchPathList := TSearchPathList.Create;
end;



function  TFile.GetCreateTime:longint;
begin
	exit(GetFileTime(voFile));
end;

procedure TFile.SetFileName(const ParName:ansistring);
begin
	if iFIleName <> nil then iFileName.Destroy;
	iFileName := TString.Create(ParName);
end;

procedure TFIle.GetFileNameStr(var ParName:ansistring);
begin
	EmptyString(ParName);
	if iFileName <> nil then begin
		iFileName.GetString(ParName);
	end;
end;


procedure TFile.clear;
begin
	inherited clear;
	DoneBuffer;
	if iFileName <> nil       then iFileName.destroy;
	if iSearchPathList <> nil then iSearchPathList.Destroy;
end;


procedure   TFile.SetBuffer(ParSize : cardinal);
begin
	DoneBuffer;
	if ParSize > 0 then begin
		iBuffer := TFIleBuffer.Create(ParSize);
		iBuffered := true;
	end;
end;

procedure   TFile.DoneBuffer;
begin
	if iBuffer <> nil then begin
		iBuffer.destroy;
		iBuffered := false;
		iBuffer := nil;
	end;
end;


procedure TFile.SetError(ParError:TErrorType);
begin
	voError := ParError;
end;


function TFile.OpenFile(const ParFileName:ansistring):boolean;
var vlErr      : TErrorType;
	vlNum      : longint;
	vlFileName : ansistring;
	vlBaseName : ansistring;
	vlD1,vlD2,vlD3 : ansistring;
	vlDir      : ansistring;
begin
	OpenFile := true;
	vlNum    := 0;
	SetError(0);
	if iOpen then begin
		SetError(FER_File_AllReady_Open);
		exit;
	end;
	SplitFile(ParFileName,vlD1,vlD2,vlD3);
	vlBaseName := vlD2 + vlD3;
	vlFileName := ParFilename;
	repeat
		LinuxToNative(vlFileName);
		assign(voFile,vlFileName);
		filemode := 0;
		reset(voFile,1);
		vlErr := ioresult;
		if vlErr <> 2 then break;
		inc(vlNum);
		if GetPathByNum(vlNum,vlDir) then break;
		CombinePath(vlDir,vlBaseName,vlFileName);
	until false;
	if vlErr <> 0 then begin
		SetFileName(ParFileName);
		SetError(vlerr);
		exit;
	end;
	iHasLa := false;
	iLaCh  := #0;
	SetFileName(vlFIleName);
	iOpen := True;
	SetReadWrite(false);
	OpenFile := false;
end;

function  TFile.CreateFile(const PArFileNAme:ansistring):boolean;
var 	
	vlErr:TErrorTYpe;
	vlFIleName : ansistring;
begin	
	vlFileName := ParFileName;
	LinuxToNative(vlFileName);
	CreateFile := true;
	SetError(FER_No_Error);
	if iOpen then begin
		SetError(Fer_File_Allready_Open);
		exit;
	end;
	Assign(voFile,vlFileName);
	rewrite(voFile,1);
	vlErr := ioresult;
	{Hack for bug in fpc rtl}
	if vlErr = 0 then begin
		if FileRec(voFile).Handle=-1 then begin
			vlErr := 2;
		end;
	end;
	if vlErr <> 0 then begin
		SetError(vlErr);
		exit;
	end;
	iReadSize :=0;
	iReadPos  := 0;
	SetReadWrite(True);
	
	CreateFile := false;
end;


function TFile.close:boolean;
var vlErr:TErrorType;
begin
	if GetReadWrite then WriteFile;
	SetError(FER_No_Error);
	close := true;
	system.close(voFile);
	vlErr := ioresult;
	SetFileName('');
	if vlErr <> Fer_No_Error then begin
		SetError(vlErr);
		exit;
	end;
	iOpen := False;
	Close := false;
end;

function    TFile.ReadBlock(var ParBlk;ParSize:cardinal;var parRead:cardinal):boolean;
var vlErr:TErrorTYpe;
begin
	ReadBlock := true;
	SetError(FER_No_Error);
	blockread(voFile,ParBlk,ParSize,ParRead);
	vlErr := ioresult;
	if vlErr <> FER_No_Error then begin
		SetError(vlErr);
		exit;
	end;
	ReadBlock := false;
	
end;

function    TFile.WriteBlock(var ParBlk;ParSize:cardinal;var ParWrite:cardinal):boolean;
var vlErr:TErrorType;
begin
	
	SetError(FER_No_Error);
	WriteBlock:= true;
	ParWrite := 0;
	blockWrite(voFile,PArBlk,PArSIze,ParWrite);
	vlErr := ioresult;
	if vlErr <> FER_No_Error then begin
		SetError(vlerr);
		exit;
	end;
	WriteBlock := false;
end;


function    TFile.GetFileSize:Longint;
var vlErr:TErrorTYpe;
begin
	SetError(FER_No_Error);
	GetFileSize := filesize(voFile);
	vlErr := ioresult;
	if vlErr <> FER_No_Error then begin
		SetError(vlErr);
		GetFileSize := -1;
	end;
end;

function  TFile.GetfilePos:Longint;
var vLErr:TErrorType;
begin
	SetError(FER_NO_Error);
	GetFilePos := filepos(voFile);
	vlErr := ioresult;
	if vlErr <> FER_No_Error then begin
		SetError(vLErr);
		GetFilePos := -1;
	end;
end;

function  TFile.Seek(PArPos:longint):boolean;
var vlErr:TErrorType;
begin
	SetError(FER_No_Error);
	system.seek(voFile,ParPos);
	vlErr := ioresult;
	Seek := false;
	if vlErr <> FER_No_Error then begin
		SetError(vlErr);
		Seek := true;
	end;
end;

function   TFile.GetFileBufferPos:Longint;
var vlPos:Longint;
begin
	vlPos := GetFilePos;
	if vlPos = -1 then vlPos := 0;
	GetFileBufferPos := vlPos + iReadPos;
end;


procedure TFile.WriteDirect(ParPos:Longint;var ParInfo;ParSIze:cardinal);
var vlPos:longint;
	vlDm:cardinal;
begin
	WriteFile;
	vlPos := Getfilepos;
	seek(ParPos);
	Writeblock(Parinfo,ParSize,vlDm);
	seek(vlPos);
end;

Function TFile.WriteFile:boolean;
var vlWrite:cardinal;
begin
	WriteFile := false;
	if iReadPos <> 0 then WriteFile := Writeblock(iBuffer.fPtr^,iReadPos,vlWrite);
	iReadSize := 0;
	iReadPos := 0;
end;

function TFile.ReadFile:boolean;
var vlReadSize:cardinal;
begin
	ReadFile := ReadBlock(iBuffer.fPtr^,iBuffer.fSize,vlReadSize);
	if vlReadSize = 0 then ReadFile := true;
	iReadSize := vlReadSize;
	iReadPos := 0;
end;


function  TFile.ReadFromBuffer(ParSize:cardinal;var ParBuffer):boolean;
var vlSize :cardinal;
	vlCan  : longint;
	vlDest : pointer;
begin
	ReadFromBuffer := true;
	vlSize := parSize;
	vlDest := @ParBuffer;
	vlCan := iReadSize - iReadPos;
	if ParSize<vlCan then begin
		iBuffer.MoveTo(iReadPos,ParSize,@ParBuffer);
		iReadPos := iReadPos + ParSize;
		exit(false);
	end;
	while vlSize <> 0 do begin
		if iReadPos>=iReadSize then begin
			if ReadFile then exit;
		end;
		vlCan := iReadSize - iReadPos;
		if vlCan = 0 then exit;
		if vlCan > vlSize then vlCan := vlSize;
		iBuffer.MoveTo(iReadPos,vlCan,vlDest);
		dec(vlSize,vlCan);
		inc(vlDest,vlcan);
		iReadPos := iReadPos + vlCan;
	end;
	ReadFromBuffer := false;
end;


function TFile.WriteToBuffer(ParSize:cardinal;const PArBuffer):boolean;
var vlSize      : cardinal;
	vlWriteSize : cardinal;
	vlSource    : pointer;
begin
	WriteToBuffer := true;
	vlSize        := ParSize;
	vlWriteSize   := iBuffer.fSize - iReadPos;
	
	if vlSize < vlWriteSize then begin
		iBuffer.MoveFrom(iReadPos,vlSize,@ParBuffer);
		iReadPos := iReadPos + vlSize;
		exit(false);
	end;
	vlSource      := @ParBuffer;
	while vlSize > 0 do begin
		if vlWriteSize > vlSize then vlWriteSize := vlSize;
		iBuffer.MoveFrom(iReadPos,vlWriteSize,vlSource);
		iReadPos := iReadPos+vlWriteSize;
		inc(vlSource,vlWriteSize);
		Dec(vlSize,vlWriteSize);
		if iReadPos >= iBuffer.fSize then if WriteFile then exit;
		vlWriteSize := iBuffer.fSize -iReadPos;
	end;
	WriteToBuffer := false;
end;


function    TFile.ReadFromFile(var ParBuf ;ParSize : cardinal;var ParRet:cardinal):boolean;
begin
	if iBuffered then begin
		ParRet := ParSize;
		exit(ReadFromBuffer(ParSize,ParBuf));
	end else begin
		exit(ReadBlock(ParBuf,ParSize,ParRet));
	end;
end;

function    TFile.WriteFromFile(var ParBuf;ParSize : cardinal;var ParRet:cardinal):boolean;
begin
	if iBuffered then begin
		ParRet := ParSize;
		exit(WriteToBuffer(ParSize,ParBuf));
	end else begin
		exit(WriteBlock(ParBuf,ParSize,ParRet));
	end;
end;




procedure TFIle.SetReadWrite(ParReadWrite:boolean);
begin
	voReadWrite := ParReadWrite;
end;

function TFIle.GetReadWrite:boolean;
begin
	GetReadWrite := voReadWrite;
end;


procedure TFIle.SetEof(ParEof:boolean);
begin
	voeof := ParEof;
end;


function TFIle.GetEof:boolean;
begin
	GetEof := voEof and (iReadPos >= iReadSize);
end;


function TFile.ReadLine(var ParStr:ansistring):boolean;
var vlCh  : char;
	vlRet : cardinal;
	vlcnt : cardinal;
	vlMode: cardinal;
	vlEnd : boolean;
	vlRd  :boolean;
begin
	vlMode := 0;
	vlCnt  := 0;
	vlEnd    := false;
	vlRd     := false;
	repeat
		if iHasLa then begin
			vlCH := iLaCh;
		end else begin
			if ReadFromFile(vlCh,1,vlRet) then begin
				vlEnd := true;
				break;
			end;
			if vlRet <> 1 then begin
				vlEnd := true;
				break;
			end;
		end;
		vlRd   := true;
		iHasLa := false;
		case vlMode of
		0:if (vlCh=#13) then vlMode := 1
		else if (vlCh=#10) then vlMode := 2
		else if vlCnt <= 255 then begin
			inc(vlCnt);
			ParStr[vlCnt] := vlCh;
		end;
		1:begin
			if (vlCh<>#10) then begin
				iLaCh  := vlCh;
				iHasLa := true;
			end;
			break;
		end;
		2:begin
			if (vlCh <>#13) then begin
				iLaCh  := vlCh;
				iHasLa := true;
			end;
			break;
		end;
	end;
until false;
if vlCnt >255 then vlCnt := 255;
SetLength(ParStr, vlCnt);
exit(vlEnd and not vlRd);
end;

end.
