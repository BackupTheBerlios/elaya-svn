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

unit scanbuf;
interface
uses buffers,simplist,files,cmp_type,stdobj;
	
	
type

	TScanBuffer=class(TROOT)
	private
		voBuffer		 : pointer;
		voCurrentPtr : pointer;
		voSize       : cardinal;
		voFileTime   : longint;
		voFileSize   : cardinal;
		voError      : TErrorType;
	protected
		property iError      : TErrorType      read voError      write voError;
		property iFileTime   : longint         read voFileTime   write voFileTime;
		property iFileSize   : cardinal        read voFileSize   write voFileSize;
		property iCurrentPtr : pointer         read voCurrentPtr write voCurrentPtr;
		property iBuffer     : pointer         read voBuffer     write voBuffer;
		property iSize       : cardinal        read voSize       write voSize;

		function GetBufferPos : cardinal;
		procedure commonsetup;override;
		procedure clear;override;

	public

		property fFileTime   : longint    read voFileTime;
		property fFileSize   : cardinal   read voFileSize;
		property fError      : TErrorType read voError;
		property fBufferPos  : cardinal   read GetBufferPos;

		function  GetNextByte(var ParByte:byte):boolean;
		procedure MoveTo(ParBegin,ParSize:cardinal;var ParMoved:cardinal;var ParDest);
		procedure MoveTo(ParBegin,ParSize:cardinal;var ParMOved:cardinal;ParBuffer : TMemoryBlock);
		function  ByteAt(ParPos:cardinal):byte;
		function  InitBuffer(const ParPath,ParFileName:string):boolean;virtual;
		procedure DecBufferPos;
		procedure SeekToPos(ParPos : cardinal);
		property  fCurrentPtr : pointer         read voCurrentPtr;
	end;
	
	TFileScanBuffer=class(TScanBuffer)
	public
		function InitBuffer(const ParPath,ParFileName : string):boolean;override;
	end;
	
implementation


function TFileScanBuffer.InitBuffer(const ParPath,ParFileName : string):boolean;
VAR
	vlLen      : cardinal;
	vlRead     : cardinal;
	vlError    : TErrorType;
	vlFile     : TFile;
	vlTime     : longint;
begin
	vlError := 0;
	vlFile  := TFile.Create(0);
	vlFile.AddPath(ParPath);
	if vlFile.OpenFile(ParFileName) then begin
		vlError := vlFIle.fError;
		vlFile.Destroy;
		iError := vlError;
		exit(true);
	END;
	vlTime     := vlFile.GetCreateTime;
	vlLen      := vlFile.GetFileSize;
	iFileTime := vlTime;
	iFileSize := vlLen;
	getmem(voBuffer,vlLen);
	iCurrentPtr := voBuffer;
	iSize := vlLen;
	vlFile.ReadFromFile(iBuffer^,vlLen,vlRead);
	vlFile.Destroy;
	exit(vlRead <> vlLen);
end;


{---( TScanBuffer )---------------------------------------------------------------}

procedure TScanBuffer.Clear;
begin
	inherited Clear;
	if iBuffer <> nil then freemem(voBuffer,iSize);
end;

procedure TScanBuffer.SeekToPos(ParPos : cardinal);
begin
  	if(ParPos < iSize) then begin
		iCurrentPtr := iBuffer + ParPos;
	end else begin
		iCurrentPtr := iBuffer + iSize - 1;
	end;
end;

function TScanBuffer.GetBufferPos : cardinal;
begin
	exit(iCurrentPtr - iBuffer);
end;

function TScanBuffer.InitBuffer(const ParPath,ParFileName:string):boolean;
begin
	exit(false);
end;

function TScanBuffer.GetNextByte(var ParByte:byte):boolean;
begin
	if iCurrentPtr = nil then exit(true);

	if(iCurrentPtr < iBuffer + iSize) then begin
		ParByte     := pbyte(iCurrentPtr)^;
		inc(voCurrentPtr);
		exit(false);
	end else begin
		ParByte := 0;
		exit(true);
	end;
end;


function TScanBuffer.ByteAt(ParPos:cardinal):Byte;
begin
	if iCurrentPtr = nil then exit(0);
	if(ParPos >= iSize) then exit(0);
	exit(PByte(iBuffer + ParPos)^);
end;


procedure TScanBuffer.Commonsetup;
begin
	inherited Commonsetup;
	iCurrentPtr := nil;
	iSize       := 0;
	iBuffer     := nil;
end;

procedure TScanBuffer.DecBufferPos;
begin
	if(iCurrentPtr > iBuffer) then dec(voCurrentPtr);
end;



procedure TScanBuffer.MoveTo(ParBegin,ParSize:cardinal;var ParMoved:cardinal;ParBuffer : TMemoryBlock);
var
	vlSize : cardinal;
begin
	if(ParBegin >= iSize) then begin
		ParMoved := 0;
		exit;
	end;
	vlSize := iSize - ParBegin;
	if(vlSize > ParSize) then vlSize := ParSize;
	ParBuffer.MoveFrom(0,vlSize,iBuffer + ParBegin);
	ParMoved := vlSize;
end;

procedure TScanBuffer.MoveTo(ParBegin,ParSize:cardinal;var ParMoved:cardinal;var ParDest);
var
	vlSize : cardinal;
begin
	if(ParBegin >= iSize) then begin
		ParMoved := 0;
		exit;
	end;
	vlSize := iSize - ParBegin;
	if(vlSize > ParSize) then vlSize := ParSize;
	move(pbyte(iBuffer + ParBegin)^,ParDest,vlSize);
	ParMoved := vlSize;
end;

end.



