{    Elaya, the Fcompilesr for the elaya language
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

unit cmp_base;

interface
uses largenum,cmp_cons,simplist,cmp_type,stdobj,progutil,scanbuf,dynset,{files,}buffers;
const   minErrDist  = 5;
	Size_BUffered_Read = 65000;

type


	TErrorItem=class(TSMListItem)
	private
		voCode     : TErrorType;
		voLine     : longint;
		voCol      : Longint;
		voPos      : longint;
		voExtra    : TString;
		voFileName : TString;
		voWarning: boolean;
		procedure   SetInfo(ParCode:TErrorType;
		ParLine,ParCol,ParPos:Longint;
		const ParExtra:string);
		property iWarning  : boolean   read voWarning  write voWarning;
		property iFileName : TString   read voFileName write voFileName;
		property iExtra    : TString   read voExtra    write voExtra;
   	property iLine     : longint   read voLine     write voLine;
		property iCol      : longint   read voCol      write voCol;
		property iCode     : TErrorType read voCode    write voCode;
		property iPos      : longint   read voPos      write voPos;
	protected
		procedure   Commonsetup;override;

	public
		property    fLine    : longint    read voLine;
		property    fCol     : longint    read voCol;
		property    fCode    : TErrorType read voCode;
		property    fWarning : boolean    read voWarning;

		procedure   GetInfo(var ParFileName : string;
		var ParCode:TErrorType;
		var ParLine,ParCol,ParPos:Longint;
		var ParExtra:string);

		constructor create(const  ParFileName : string;
		ParCode:TErrorType;
		ParLine,ParCol,ParPos:Longint;
		const ParExtra:string);

		procedure   SetWarning;
		function    IsBefore(ParCol,ParLine:Longint):boolean;
		destructor  destroy;override;
	end;
	
	
	TErrorList =class(TSMList)
		function AddError(
		const ParFileName : string;
		ParCode : TErrorType;
		ParLine,ParCol,ParPos : Longint;
		const ParExtra:string) : TErrorItem;
		FUNCTION    Successful : boolean;
	end;
	
	TCompiler_Base=class(TRoot)
		line, col  : longint;      {line and column of current symbol}
		len        : LONGINT;      {length of current symbol}
		pos        : LONGINT;      {file position of current symbol}
		curLine    : longint;    {current input line (may be higher than line)}
		lineStart  : LONGINT;    {start position of current line}
		voLastLineStart :longint;
		apx        : LONGINT;    {length of appendix (CONTEXT phrase)}
		oldEols    : INTEGER;    {number of _EOLs in a comment}
		bp0        : LONGINT;    {current position in buf}
		{ (bp0: position of current token)}
		errDist    : cardinal;   { number of symbols recognized since last error }
		nextLine   : LongInt;      {line of lookahead symbol}
		nextCol    : cardinal;      {column of lookahead symbol}
		nextLen    : Longint;      {length of lookahead symbol}
		nextPos    : Longint;      {file position of lookahead symbol}
		lastCh     : Char;
		MaxT				 : cardinal;

private
	voErrorList        : TErrorList;
	voInputLen         : longint;
	voSourceFileTime   : longint;
	voInitialised      : boolean;
	voScanBuffer       : TScanBuffer;
	voCurrentChar      : char;
	voCurrentSym       : integer;
	voOwnDynSet        : boolean;
	voFileName         : TString;
	voCase             : boolean;

	procedure SetInitialised(ParOpend:boolean);
	
protected
	property fScanBuffer  : TScanBuffer read voScanBuffer write voScanBuffer;
	
	property iSourceFileTime : longint read voSourceFileTime write voSourceFileTime;
	property iFileName       : TString read voFileName    write voFileName;
	property fCurrentSym     : integer read voCurrentSym  write voCurrentSym;
	property Ch              : char    read voCurrentChar write voCurrentChar;
	property GetSym          : integer read voCurrentSym;
	property fOwnDynSet      : boolean read voOwnDynSet   write voOwnDynSet;
	property iErrorList      : TErrorList read voErrorList write voErrorList;
	property iCase           : boolean read voCase         write voCase;

	procedure Commonsetup;override;
	procedure   Clear;override;

public
	property  fSourceFileTime    : longint read voSourceFileTime;
	property  fFileName          : TString read voFileName    write voFileName;
	property  GetCurrentPosition : longint read pos;
	property  fInitialised       : boolean read voInitialised;
	
	
	
	function    GetBufferPos:longint;
	procedure   SetReadBufferData(ParPos:cardinal);
	procedure   DecCurrentPos;
	function	   GetLineStart(ParPos:longint):longint;
	procedure   SetSourceFileTime(ParTime:longint);
	procedure   InitErrorList;virtual;
	function    Error(ParErr:TErrorType;ParLine, ParCol,parPos:longint; const ParText:string):TErrorItem;virtual;
	PROCEDURE   NextCh;
	FUNCTION    CharAt (ParPos: LONGINT): CHAR;
	PROCEDURE   ExpectWeak (ParN : integer; ParFollow: TDynamicSet);
	FUNCTION    WeakSeparator (ParN :integer;ParSet0, ParSyFol, ParRepFol: TDynamicSet): boolean;
	PROCEDURE   Expect (ParN: INTEGER);
	procedure   Pragma;virtual;
	PROCEDURE   Get;
	PROCEDURE   SynError (ParErrNo: TErrorType);virtual;
	PROCEDURE   SemError (ParErrNo: TErrorType);virtual;
	function    ErrorText(ParErr:TErrorType;const ParText:string):TErrorItem;virtual;
	procedure   AddWarning(ParErrNo : TErrorType;const ParText : String);
	procedure   AddWarning(ParErrNo : TErrorTYpe);
	procedure   AddWarning(ParErrNo : TErrorType;ParLine,ParCol,ParPos:longint;const ParText : string);
	
	procedure   Symget(var ParSym:integer);virtual;
	PROCEDURE   GetName (ParPos: LONGINT; ParLen: INTEGER; var ParStr: STRING);
	PROCEDURE   GetString (ParPos: LONGINT; ParLen: INTEGER; VAR ParStr: STRING);
	procedure   GetBufString(ParPos:longint;ParSize : cardinal;var ParStr:string);
	function    SetupCompiler:boolean;virtual;
	PROCEDURE   LexName (VAR Lex : STRING);
	PROCEDURE   LexString (VAR Lex : STRING);
	PROCEDURE   LookAheadName (VAR Lex : STRING);
	PROCEDURE   LookAheadString (VAR Lex : STRING);
	function    HasMessages : boolean;
	FUNCTION    Successful : boolean;virtual;
	function    NewCompiler(const ParFileName:string):TCompiler_Base;virtual;
	procedure   Compile;virtual;
	procedure   GetBufBlock(ParPos:longint;ParSize : cardinal;var ParPtr:pointer);
	procedure   GetBufBlock(ParPos:longint;ParSize : cardinal;ParBuf : TMemoryBlock);
	procedure   NewLine(ParLine:cardinal);virtual;
	procedure   GetErrorText(ParNo:longint;var ParErr:string);virtual;
	procedure   HandleErrors;
	procedure   ErrorHeader;virtual;
	procedure   ErrorMessage(ParItem : TErrorItem);virtual;
	Procedure   ErrorFooter(ParNum : cardinal);virtual;
	procedure   ProcessParsed;virtual;
	procedure   Save;virtual;
	procedure   WhenError;virtual;
	procedure   WhenSuccess;virtual;
	procedure   Parse;virtual;
	procedure   PreProcessParsed;virtual;
	procedure   PostProcessParsed;virtual;
	procedure   PreSave;virtual;
	procedure   PostSave;virtual;
	procedure   PostCompile;virtual;
	procedure   PreParse;virtual;
	procedure   PostParse;virtual;
	procedure    GetSourcePath(var ParPath:string);virtual;
	procedure   GetLine(ParPos : longint;var ParLine : string);
	procedure   CreateDynSet(var ParSets : array of TDynamicSet);
procedure   DestroyDynSet(var ParSets : array of TDynamicSet);
procedure   OpenFileFailed(ParError :TErrorType);virtual;
procedure   SetupScanBuffer;virtual;
end;


implementation
{----( TErrorList )--------------------------------------------------}




FUNCTION  TErrorList.Successful : boolean;
var vlCurrent : TErrorItem;
begin
	vlCurrent := TErrorItem(fStart);
	while vlCurrent <> nil do begin
		if not vlCurrent.fWarning then exit(false);
		vlCurrent := TErrorItem(vlCurrent.fNxt);
	end;
	exit(true);
end;


function TErrorList.AddError(const ParFileName : string;
ParCode     : TErrorType;
ParLine     : longint;
ParCol      : longint;
ParPos      : Longint;
const ParExtra     : string):TErrorItem;
var vlCurrent:TErrorItem;
begin
	vlCurrent := TErrorItem(fStart);
	while (vlCUrrent <> nil) and (vlCurrent.IsBefore(ParCol,ParLine)) do vlCurrent := TErrorItem(vlCurrent.fNxt);
	if vlCurrent = nil then vlCurrent := TErrorItem(fTop)
	else vlCurrent := TErrorItem(vlCurrent.fPrv);
	exit(TErrorItem(insertAt(vlCurrent,TErrorItem.create(ParFileName,ParCode,ParLine,ParCol,ParPos,ParExtra))));
	
end;

{----( TErrorItem )--------------------------------------------------}

function  TErrorItem.IsBefore(ParCol,ParLine:Longint):boolean;
begin
	exit((iLine < ParLine) or ((iLine = ParLine)  and (iCol < ParCol)));
end;

destructor TErrorITem.destroy;
begin
	inherited destroy;
	if iExtra <> nil    then iExtra.destroy;
	if iFileName <> nil then iFileName.Destroy;
end;

procedure  TErrorItem.SetInfo(ParCode:TErrorType;ParLine,ParCol,ParPos:Longint;const ParExtra:string);
begin
	iCode := ParCode;
	iLine := ParLine;
	iPos  := ParPos;
	iCOl  := ParCol;
	if iExtra <> nil then iExtra.destroy;
	iExtra := TString.Create(ParExtra);
end;



procedure  TErrorItem.GetInfo(
var ParFileName  : string;
var ParCode:TErrorType;
var ParLine,ParCol,ParPos:Longint;
var ParExtra:string);
begin
	iFileName.GetString(ParFileName);
	ParCode     := iCode;
	ParLine     := iLine;
	ParCol      := iCol;
	ParPos      := iPos;
	voExtra.GetString(ParExtra);
end;

constructor TErrorITem.create(
const ParFileName : string;
ParCode     : TErrorType;
ParLine     : longint;
ParCol      : longint;
ParPos      : Longint;
const ParExtra:string);
begin
	inherited create;
	SetInfo(ParCode,ParLine,ParCol,ParPos,ParExtra);
	iFileName := TString.Create(ParFileName);
end;


procedure   TErrorItem.SetWarning;
begin
	iWarning := true;
end;


procedure   TErrorItem.Commonsetup;
begin
	inherited Commonsetup;
	voExtra   := nil;
	iFileName := nil;
	iWarning  := false;
end;


{-----( TCompiler_Base )-----------------------------------------------}


procedure   TCompiler_Base.AddWarning(ParErrNo : TErrorType;ParLine,ParCol,ParPos:longint;const ParText : string);
var
	vlError :TErrorItem;
begin
	vlError := Error(ParErrNo,ParLine,ParCol,ParPos,ParText);
	if vlError <> nil then vlError.SetWarning;
end;

procedure   TCompiler_Base.AddWarning(ParErrNo : TErrorType;const ParText : string);
var
	vlError : TErrorItem;
begin
	vlError := ErrorText(ParErrNo,ParText);
	if vlError <> nil then vlError.SetWarning;
end;

procedure   TCompiler_Base.AddWarning(ParErrNo : TErrorTYpe);
begin
	AddWarning(ParErrNo,'');
end;


procedure  TCompiler_Base.CreateDynSet(var ParSets : array of TDynamicSet);
var
	vlCnt : cardinal;
begin
	if ParSets[0] <> nil then exit;
	fOwnDynSet := true;
	for vlCnt := 0 to high(ParSets) do ParSets[vlCnt] := TDynamicSet.Create(maxT+1);
end;

procedure  TCompiler_Base.DestroyDynSet(var ParSets : array of TDynamicSet);
var vlCnt : cardinal;
begin
	if not fOwnDynset then exit;
	for vlCnt := 0 to high(ParSets) do begin
		ParSets[vlCnt].Destroy;
		ParSets[vlCnt]:= nil;
	end;
end;

procedure  TCompiler_Base.GetLine(ParPos : longint;var ParLine : string);
var
	vlCnt : cardinal;
	vlPos : longint;
	vlCh  : char;
begin
	vlPos := ParPos;
	vlCnt := 0;
	while(true) do begin
		vlCh := charat(vlPos);
		if(vlCh in LineEnds) then break;
		inc(vlCnt);
		ParLine[vlCnt] := vlCh;
		if vlCnt = 255 then break;
		inc(vlPos);
	end;
	SetLength(ParLine,vlCnt);
end;


procedure TCOmpiler_Base.GetSourcePath(var ParPath:string);
begin
	EmptyString(ParPath);
end;

procedure  TCompiler_Base.PreParse;
begin
end;

procedure   TCompiler_Base.PostParse;
begin
end;

procedure  TCompiler_base.Parse;
begin
end;

procedure  TCompiler_Base.Compile;
begin
	if SuccessFul then begin
		PreParse;
		Parse;
		PostParse;
	end;
	if SuccessFul then begin
		PreProcessParsed;
		ProcessParsed;
		PostProcessParsed;
		if SuccessFul then begin
			PreSave;
			Save;
			PostSave;
		end;
	end;
	if HasMessages then begin
		WhenError;
		HandleErrors;
	end;
	PostCompile;
end;

procedure  TCompiler_Base.PreProcessParsed;
begin
end;

procedure  TCompiler_Base.ProcessParsed;
begin
end;

procedure  TCompiler_Base.PostProcessParsed;
begin
end;

procedure  TCompiler_Base.PreSave;
begin
end;

procedure TCompiler_Base.PostSave;
begin
end;

procedure  TCompiler_Base.Save;
begin
end;

procedure  TCompiler_Base.WhenError;
begin
end;

procedure  TCompiler_Base.WhenSuccess;
begin
end;

procedure  TCompiler_Base.PostCompile;
begin
end;

procedure  TCompiler_Base.ErrorHeader;
begin
end;

procedure  TCompiler_Base.ErrorMessage(ParItem : TErrorItem);
begin
end;

Procedure  TCompiler_Base.ErrorFooter(ParNum : cardinal);
begin
end;

procedure TCompiler_Base.GetErrorText(ParNo:longint;var ParErr:string);
begin
end;

procedure TCompiler_Base.OpenFileFailed(ParError : TErrorType);
begin
end;


procedure TCompiler_Base.SetInitialised(ParOpend:boolean);
begin
	voInitialised := ParOpend;
end;

function  TCOmpiler_Base.GetLineStart(ParPos:longint):longint;
var
	vlCnt:longint;
begin
	vlCnt := ParPos;
	while(vlCnt>0) do begin
		case CharAt(vlCnt) of
			#10,#13:exit( vlCnt + 1);
		end;
		dec(vlCnt);
	end;
	GetLineStart := vlCnt ;
end;

procedure TCompiler_Base.SetSourceFileTime(ParTime:longint);
begin
	voSourceFileTime := ParTime;
end;



function  TCompiler_base.NewCompiler(const ParFileName:string):TCompiler_Base;
begin
	NewCompiler := nil;
end;

procedure TCompiler_Base.GetBufString(ParPos:longint;ParSize : cardinal;var ParStr:string);
var
	vlMovedSize : cardinal;
	vlSize      : cardinal;
begin
	vlSize := ParSize;
	if vlSize > 255 then vlSize := 255;
	fScanBuffer.MoveTo(ParPos,vlSize,vlMovedSize,ParStr[1]);
	if vlMovedSize < vlSize then vlSize := vlMovedSize;
	SetLength(PArStr,vlSize);
end;

procedure  TCompiler_Base.GetBufBlock(ParPos:longint;ParSize : cardinal;ParBuf : TMemoryBlock);
var vlSize :cardinal;
begin
	fScanBuffer.MoveTo(ParPos,ParSIze,vlSize,ParBuf);
end;

procedure TCompiler_Base.GetBufBlock(ParPos:longint;ParSize : cardinal;var ParPtr:pointer);
var vlSize:cardinal;
begin
	ParPtr := int_malloc(ParSize);
	fScanBuffer.MoveTo(ParPos,ParSize,vlSize,ParPtr^);
end;



PROCEDURE TCompiler_Base.GetString (ParPos: LONGINT; ParLen: INTEGER; VAR ParStr: STRING);
begin
	if ParLen > 255 then ParLen :=255;
	GetBufString(ParPos,ParLen,ParStr);
end;

PROCEDURE TCompiler_base.GetName (ParPos: LONGINT; ParLen: INTEGER; VAR ParStr: STRING);
begin
	IF ParLen > 255 THEN ParLen := 255;
	GetBufString(ParPos,ParLen,ParStr);
	if not voCase then UpperStr(ParStr);
end;



procedure TCompiler_Base.NewLIne(ParLine:cardinal);
begin
end;

procedure TCompiler_Base.symget(var ParSym:Integer);
begin
	voLastLinestart := LineStart;
	if line <> nextLine then NewLine(line);
end;


PROCEDURE  TCompiler_base.SynError (ParErrNo: TErrorType);
begin
	if ErrDist >= minErrDist then  Error(ParErrNo,NextLine,NextCol,NextPos,'');
	ErrDist := 0;
end;

PROCEDURE  TCOmpiler_base.SemError (ParErrNo: TErrorType);
BEGIN
	ErrorText(ParErrNo,'');
END;


function   TCOmpiler_Base.ErrorText(ParErr:TErrorType;const ParText:string):TErrorItem;
var
	vlItem      : TErrorItem;
begin
	vlItem :=  Error(ParErr,Line,Col,pos,ParText);
	exit(vlItem);
end;


function  TCompiler_BAse.Error(ParErr:TErrorType;ParLine, ParCol,ParPos:longint; const ParText:string):TErrorItem;
var
	vlFIleName  : string;
	vlCol       : TNormal;
	vlLineStart : longint;
begin
	fFileName.GetString(vlFileName);
	vlLineStart := GetLineStart(ParPos);
	vlCol := ParPos-vlLineStart + 1;
	exit(iErrorList.AddError(vlFileName,ParErr,ParLine,vlCol,vlLineStart,ParText));
end;

procedure TCompiler_base.Clear;
begin
	inherited clear;
	if iErrorList  <> nil then iErrorList.destroy;
	if fScanBuffer <> nil then fScanBuffer.Destroy;
	if iFileName   <> nil then iFileName.Destroy;
end;



function  TCompiler_Base.GetBufferPos:longint;
begin
	exit(longint(fScanBuffer.fBufferPos)-1); {Todo: Remove type casting}
end;

procedure   TCompiler_Base.SetReadBufferData(ParPos:cardinal);
begin
	fScanBuffer.SeekToPos(ParPos);
end;


procedure TCompiler_Base.DecCurrentPos;
begin
	fScanBuffer.DecBufferPos;
end;


PROCEDURE TCompiler_base.NextCh;
BEGIN
	LastCh := Ch;
	if fScanBuffer.GetNextByte(byte(voCurrentChar)) then begin
		Ch := C_Ef;
		exit;
	end;
	if not voCase then ch := upcase(ch);
	IF (ch in [C_EL, C_LF]) AND (lastCh <> C_EL) THEN BEGIN
		INC(curLine); lineStart := GetBufferPos;
	END
END;

FUNCTION TCompiler_base.CharAt (ParPos: LONGINT): CHAR;
var
	vlCh : CHAR;
begin
	IF ParPos >= voInputLen THEN exit(C_EF);
	vlCh :=char( fScanBuffer.ByteAt(ParPos));
	if not voCase then vlCh := upcase(vlCh);
	IF vlCh <> C_Eof THEN exit(vlCh)
	ELSE exit(C_EF)
end;

PROCEDURE  TCompiler_Base.ExpectWeak (ParN : integer; ParFollow: TDynamicSet);
BEGIN
	IF fCurrentSym = ParN  THEN Get
	ELSE BEGIN
		SynError(ParN);
		WHILE NOT ParFollow.IsSet(fCurrentSym) DO Get;
	END
END;

FUNCTION  TCompiler_base.WeakSeparator (ParN : integer;ParSet0, ParsyFol, ParRepFol: TDynamicSet): boolean;
BEGIN
	IF fCurrentSym = ParN THEN BEGIN
		Get;
		WeakSeparator := TRUE;
		EXIT;
	END ELSE
	IF ParRepFol.isSet(fCurrentSym) THEN BEGIN
		WeakSeparator := FALSE;
		exit
	END ELSE BEGIN
		SynError(ParN);
		WHILE NOT (ParSet0.IsSet(fCurrentSym) or ParSyFol.IsSet(fCurrentSym) or ParRepFol.IsSet(fCurrentSym)) DO Get;
		WeakSeparator := ParSyFol.IsSet( fCurrentSym)
	END
END;

PROCEDURE  TCompiler_base.Expect (ParN: INTEGER);
begin
	IF fCurrentSym = ParN THEN Get ELSE SynError(ParN);
end;

procedure TCompiler_base.Pragma;
begin
end;


PROCEDURE  TCompiler_base.Get;
var vlSym : integer;
BEGIN
	symget(vlSym);
	if vlSym >maxT then begin
		while vlSym >MaxT do begin
			pragma;
			symget(vlSym);
		end;
	end;
	fCurrentSym := vlSym;
	inc(errDist);
end;

function TCompiler_Base.SetupCompiler:boolean;
VAR
	vlFileName : string;
	vlPath     : string;
begin
	iFileName.GetString(vlFileName);
	GetSourcePath(vlPath);
	if fScanBuffer.InitBuffer(vLPath,vlFileName) then begin
		OpenFileFailed(fScanBuffer.fError);
		exit(true);
	END;
	voInputLen := fScanBuffer.fFileSize;
	SetSourceFileTime(fScanBuffer.fFileTime);
	SetReadBufferData(0);
	SetInitialised(true);
	NextCh;
	exit(false);
END;

PROCEDURE TCompiler_Base.LexName (VAR Lex : STRING);
BEGIN
	GetName(pos, len, Lex)
END;

PROCEDURE TCompiler_Base.LexString (VAR Lex : STRING);
BEGIN
	GetString(pos, len, Lex)
END;

PROCEDURE TCompiler_Base.LookAheadName (VAR Lex : STRING);
BEGIN
	GetName(nextPos, nextLen, Lex)
END;

PROCEDURE TCompiler_Base.LookAheadString (VAR Lex : STRING);
BEGIN
	GetString(nextPos, nextLen, Lex)
END;


function TCompiler_Base.HasMessages : boolean;
begin
	exit(not(iErrorList.IsEmpty));
end;

FUNCTION TCompiler_Base.Successful : boolean;
BEGIN
	Successful := iErrorList.SuccessFul;
END;

procedure TCompiler_Base.InitErrorList;
begin
	iErrorList := TErrorLIst.create;
end;


procedure TCompiler_Base.HandleErrors;
var
	vlNextErr : TErrorItem;
	vlErrC    : TNormal;
BEGIN
	vlNextErr := TErrorItem(iErrorList.fStart);
	vlErrC := 0;
	if vlNextErr <> nil then begin
		ErrorHeader;
		WHILE (vlNextErr <> NIL)  DO BEGIN
			ErrorMessage(vlNextErr);
			INC(vlErrC);
			vlNextErr := TErrorItem(vlNextErr.fNxt);
		END;
		ErrorFooter(vlErrC);
	end;
END;

procedure TCompiler_base.Commonsetup;
begin
	inherited Commonsetup;
	InitErrorList;
	errDist     := MinErrDist;
	lastCh      := C_EF;
	curLine     := 1;
	lineStart   := -2;
	oldEols     := 0;
	apx         := 0;
	pos         := 0;
	voLastLineStart := 0;
	SetupScanBuffer;
	fOwnDynSet      := false;
	SetSourceFileTime(0);
end;


procedure TCompiler_Base.SetupScanBuffer;
begin
	fScanBuffer := TFileScanBuffer.Create;
end;

end.



