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


unit AsmInfo;
interface
uses asmdisp,display,extappl,stdObj,elacons,error,elatypes,progutil,resource,pocobj,cmp_type,register;
	
type
	
	
	
	TAssemblerInfo=class(TRoot)
	private
		voAssemblerInfoType:TAssemblerType;
		voRegisterList:TRegisterList;
	protected
		property iRegisterList : TRegisterList read voRegisterList write voRegisterList;
		procedure Commonsetup;override;
		procedure Clear;override;

	public
		property  fRegisterList : TRegisterList read voRegisterList;
		function  CreateAsmExec(const ParInputFile,ParOutputDir:string):TCompAppl;virtual;
		procedure TranslateRet(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateJump(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateCondJump(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateNeg(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateNot(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateAnd(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateOr(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateXor(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateAdd(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateIncDec(ParCre : TInstCreator;ParPoc : TIncDecFor);virtual;
		procedure TranslateSub(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateDiv(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateMul(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateMod(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateShr(ParCre : TInstCreator; ParPoc : TPocBase);virtual;
		procedure TranslateShl(ParCre : TInstCreator; ParPoc : TPocBase);virtual;
		procedure TranslateLoad(ParCre:TInstCreator;ParPoc:TPocBase);virtual;
		procedure TranslateComp(ParCre:TInstCreaTOR;ParPoc:TPocBase);virtual;
		procedure TranslateCall(ParCre : TInstcreator ; ParPoc : TPocBase) ;virtual;
		procedure TranslateLsMov(ParCre : TInstCreator ; ParPoc : TPocBase);virtual;
		procedure TranslateSetPar(ParCre : TInstCreator ; ParPoc : TPocBase);virtual;
		procedure CreateRoutineInit(ParCre:TInstCreator;ParPoc:TPocBase);  virtual;
		procedure CreateRoutineExit(ParCre:TInstCreator;ParPoc:TPocBase);  virtual;
		function  Getsystemsize:cardinal;virtual;
		function  HasIntelDirection:boolean;virtual;
		procedure SeTAssemblerInfoType(ParType:TAssemblerType);
		function  GeTAssemblerInfoType:TAssemblerType;
		procedure InitRegisterList;virtual;
		procedure GetRegisterByCode(ParCode:TNormal;var ParName:String);virtual;
		procedure GetInstruction(var ParInstruction:string;ParDesSize,ParSrcSize:TSize);virtual;
		function  GetManglingCHar:Char;virtual;
		procedure AddMangling(var parStr:string;const ParUnit:String);virtual;
		function  GetRemarkChar:char;virtual;
		function  GetSectionText(const ParName:string):string;virtual;
		function  GetGlobalText(const ParName:string):string;virtual;
		function  CreateAsmDisplay(const ParFileName : string;var ParError :TErrorType) : TAsmDisplay;virtual;
	end;
	
function  GetAssemblerInfo:TAssemblerInfo;
procedure DoneAssemblerInfo;
procedure SetAssemblerInfo(ParInfo:TAssemblerInfo);

implementation

var vgAssemblerInfo   : TAssemblerInfo;
	
	
function GetAssemblerInfo:TAssemblerInfo;
begin
	GetAssemblerInfo := vgAssemblerInfo;
end;

procedure DoneAssemblerInfo;
begin
	if GetAssemblerInfo <> nil then GetAssemblerInfo.destroy;
	vgAssemblerInfo := nil;
end;

procedure SetAssemblerInfo(ParInfo:TAssemblerInfo);
begin
	DoneAssemblerInfo;
	vgAssemblerInfo := ParInfo;
end;




{---( TAssemblerInfo )-----------------------------------------------------}
procedure TAssemblerInfo.InitRegisterList;
begin
	iRegisterList := nil;
end;

procedure TAssemblerInfo.Clear;
begin
	inherited Clear;
	if iRegisterList <> nil then iRegisterList.Destroy;
end;


function  TAssemblerInfo.CreateAsmDisplay(const ParFileName : string;var ParError :TErrorType) : TAsmDisplay;
begin
	exit(nil);
end;

function  TAssemblerInfo.GetSectionText(const ParName:string):string;
begin
	exit(ParName);
end;

function  TAssemblerInfo.GetGlobalText(const ParName:string):string;
begin
	exit(ParName);
end;

function TAssemblerInfo.CreateAsmExec(const ParInputFile,ParOutputDir:string):TCompAppl;
begin
	exit(nil);
end;

procedure TAssemblerInfo.CreateRoutineInit(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateRoutineInit');
end;


procedure TAssemblerInfo.CreateRoutineExit(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateRoutineExit');
end;

procedure TAssemblerInfo.TranslateAnd(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateAnd');
end;

procedure TAssemblerInfo.TranslateNeg(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateNeg');
end;

procedure TAssemblerInfo.TranslateNot(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateNeg');
end;

procedure TAssemblerInfo.TranslateCondJump(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateCondJump');
end;

procedure TAssemblerInfo.TranslateJump(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateJump');
end;

procedure TAssemblerInfo.TranslateRet(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,' TAssemblerInfo.TranslateRet');
end;


procedure TAssemblerInfo.TranslateOr(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateAnd');
end;

procedure TAssemblerInfo.TranslateXor(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateXor');
end;

procedure TAssemblerinfo.TranslateAdd(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateAdd');
end;

procedure TAssemblerInfo.TranslateIncDec(ParCre : TInstCreator;ParPoc : TIncDecFor);
begin
	fatal(fat_abstract_routine,'');
end;


procedure TAssemblerInfo.TranslateSub(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateSub');
end;

procedure TAssemblerInfo.TranslateDiv(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateDiv');
end;

procedure TAssemblerInfo.TranslateMul(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateMul');
end;

procedure TAssemblerInfo.TranslateMod(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateMod');
end;

procedure TAssemblerInfo.TranslateShr(ParCre : TInstCreator; ParPoc : TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateShr');
end;


procedure TAssemblerInfo.TranslateShl(ParCre : TInstCreator; ParPoc : TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateShl');
end;


procedure TAssemblerInfo.TranslateLoad(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateLoad');
end;

procedure TAssemblerInfo.TranslateComp(ParCre:TInstCreaTOR;ParPoc:TPocBase);
begin
	fatal(Fat_abstract_routine,'TAssemblerInfo.TranslateComp');
end;

procedure TAssemblerInfo.TranslateCall(ParCre : TInstcreator ; ParPoc : TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateCall');
end;


procedure TAssemblerInfo.TranslateSetPar(ParCre : TInstCreator ; ParPoc : TPocBase);
begin
	fatal(fat_abstract_routine,'TAssemblerInfo.TranslateSetPar');
end;

procedure TAssemblerInfo.TranslateLsMov(ParCre:TInstCreator;ParPoc:TPocBase);
begin
	fatal(Fat_abstract_routine,'TAssemblerInfo.TranslateLsMov');
end;

function TAssemblerInfo.Getsystemsize:cardinal;
begin
	Getsystemsize := 4;
end;


procedure TAssemblerInfo.AddMangling(var parStr:string;const ParUnit:String);
var vlStr:String;
begin
	if length(ParUnit) = 0 then exit;
	str(length(ParUnit),vlStr);
	ParStr :=  ParStr + vlStr + ParUnit;
end;

function  TAssemblerInfo.GetRemarkChar:char;
begin
	GetRemarkChar :=';'
end;

function  TAssemblerInfo.GetManglingChar:Char;
begin
	GetManglingChar := '$';
end;

function  TAssemblerInfo.HasIntelDirection:boolean;
begin
	HasIntelDirection :=  true;
end;


procedure TAssemblerInfo.SetAssemblerInfoType(ParType:TAssemblerTYpe);
begin
	voAssemblerInfoType := ParType;
end;

function  TAssemblerInfo.GetAssemblerInfoType:TAssemblerType;
begin
	GetAssemblerInfoType := voAssemblerInfoType;
end;

procedure TAssemblerInfo.Commonsetup;
begin
	Inherited Commonsetup;
	SetAssemblerInfoType(AT_None);
	InitRegisterList;
end;

procedure TAssemblerInfo.GetRegisterByCode(ParCode:TNormal;var ParName:String);
begin
	EmptyString(ParName);
end;

procedure TAssemblerInfo.GetInstruction(var ParInstruction:string;ParDesSize,ParSrcSize:TSize);
begin
end;

begin
	vgAssemblerInfo := nil;
end.
