{    Elaya, the compilerF for the elaya language     ;
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

unit register;
interface
uses simplist,i386cons,linklist,elacons,progutil,elatypes,error,objects,cmp_type;
	
type
	
	TRegisterMaster=class(TSMListItem)
	private
		voUseCnt      : array[0..3] of cardinal;
		voState       : array[0..3] of TResourceState;
		voLocks	      : array[0..3] of cardinal;
		voMinimalSize : cardinal;
		voMaximalSize : cardinal;
		voCode        : cardinal;
		voLastUsed    : cardinal;

	protected
		property iMinimalSize : cardinal read voMinimalsize write voMinimalsize;
		property iMaximalSize : cardinal read voMaximalsize write voMaximalsize;
		property iCode	      : cardinal read voCode	    write voCode;
		property iLastUsed    : cardinal read voLastUsed    write voLastUsed;
	public
		property  fCode     : cardinal read voCode;
		property fLastUsed    : cardinal read voLastUsed    write voLastUsed;

		procedure   SetLock(ParBegin,ParEnd : cardinal);
		procedure   ResetLock(ParBegin,ParEnd : cardinal);
		constructor Create(ParCode,ParMinimalSize,ParMaximalSize : cardinal);
		procedure   IncUseCnt(ParBegin,ParEnd : cardinal);
		procedure   DecUseCnt(ParBegin,ParEnd : cardinal);
		procedure   SetState(ParBegin,ParEnd : cardinal;ParState : TREsourceState);
		function    GetState(ParBegin,ParEnd : cardinal):TResourceState;
		procedure   Commonsetup;override;
		procedure   ResetState;
	end;


TRegisterMasterList=class(TSMList)
	procedure AddStorageMaster(ParCode,ParMinimalSize,ParMaximalSize : cardinal);
	function  GetRegisterMasterByCode(ParCode : cardinal):TRegisterMaster;
	procedure ResetStates;

end;

TRegister=class(TSMListitem)
private
	voStorageMaster : TRegisterMaster;
	voRegisterCode  : TNormal;
	voCanDoflag     : TAsmStorageCanDo;
	voLargerSize    : TRegister;
	voSmallerSize   : TRegister;
	voMainRegister  : TRegister;
	voSize	   	    : TSize;
	voHints		    : TRegHints;
	voPartBegin        : cardinal;
	voPartEnd       : cardinal;
	function GetLastUsed : cardinal;
	procedure SetLastUSed(ParUsed : cardinal);
protected
	property  iPartBegin     : cardinal          read voPartBegin     write voPartBegin;
	property  iPartEnd       : cardinal			 read voPartEnd       write voPartEnd;
	property  iStorageMaster : TRegisterMaster   read voStorageMaster write voStorageMaster;
	property  iSize          : TSize             read voSize          write voSize;
	property  iCanDoFlag	 : TAsmStorageCanDo  read voCanDoFlag     write voCanDoFlag;
	property  iHints         : TRegHints         read voHints	      write voHints;
	property  iRegisterCode  : TNormal           read voRegisterCode  write voRegisterCode;
	property  iMainRegister  : TRegister         read voMainRegister  write voMainRegister;
public
	property  fSize           : TSize     read voSize;
	property  fMainRegister   : TRegister read voMainRegister;
	property  fRegisterCode   : TNormal   read voRegisterCode;
	property  fLargerSize     : TRegister read voLargerSize;
	property  fSmallerSize    : TRegister read voSmallerSize;
	property  fHints	      : TRegHints read voHints;
	property  fLastUsed       : cardinal read GetLastUsed write SetLastUsed;
	property  fPartBegin      : cardinal  read voPartBegin;
	property  fPartEnd        : cardinal read voPartEnd;
	
	procedure   SetLock;
	procedure   ResetLock;
	procedure   Reserve;
	procedure   Release;
	procedure   SetUse(ParUse:TResourceState);
	function    GetUse:TResourceState;
	procedure   IncUseCnt;
	procedure   DecUseCnt;
	function    GetCanDoFlag(ParFlag:TAsmStorageCanDo):boolean;
	procedure   SetOtherSize(ParLarger,ParSmall:TRegister);
	function    IsPartOf(ParRegister:TRegister):boolean;
	constructor Create(ParMaster : TRegisterMaster;ParRegisterCode:TNormal;ParSize : TSize;ParRegHints : TRegHints;ParCanDo : TAsmStorageCanDo;ParPartBegin,ParPartEnd : cardinal);
	procedure   CommonSetup;override;
	function    GetName:String;
end;




TRegisterList=class(TSMList)
private
	voStorageMasterList : TRegisterMasterList;
	voUseCnt            : cardinal;
protected
	property iUseCnt : cardinal read voUseCnt write voUseCnt;
	property iStorageMasterList : TRegisterMasterList read voStorageMasterList write voStorageMasterList;
public
	procedure AddStorageMaster(ParCode,ParMinimalSize,ParMaximalSize : cardinal);
	function  GeTRegisterMasterByCode(ParCode : cardinal):TRegisterMaster;
	procedure COmmonsetup;override;
	procedure Clear;override;
	constructor Create(const ParRegInfo:Array of TRegisterInfo;const ParMaster:Array of TMasterInfo);
	function  GetRegisterByCode(ParRegisterCode:TNormal):TRegister;
	function  GetFreeRegister(ParSize:TSize):TRegister;
	function  GetFreeRegisterByHint(ParSize:TSize;ParHint : TRegHint):TRegister;
	function  GetAsRegister(ParReg:TRegister;ParSize : TSize):TRegister;
	function  GetSpecialRegister(ParType:TAsmStorageCanDo;ParSize : TSize):TRegister;
	procedure AddItem(const ParRegister:TRegister);
	procedure    ResetStates;

end;

implementation

uses asminfo;


{---( TRegisterMasterList )-----------------------------------------------}

procedure  TRegisterMasterList.ResetStates;
var
    vlCurrent : TRegisterMaster;
begin
	vlCurrent := TRegisterMaster(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.ResetState;
		vlCurrent := TRegisterMaster(vlCurrent.fNxt);
	end;
end;


procedure TRegisterMasterList.AddStorageMaster(ParCode,ParMinimalSize,ParMaximalSize : cardinal);
begin
	InsertAt(nil,TRegisterMaster.Create(ParCode,ParMinimalSize,ParMaximalSize));
end;

function  TRegisterMasterList.GetRegisterMasterByCode(ParCode : cardinal):TRegisterMaster;
var vlCUrrent : TRegisterMaster;
begin
	vlCurrent := TRegisterMaster(fStart);
	while (vlCurrent <> nil) and (vlCurrent.fCode <> ParCode) do vlCurrent := TRegisterMaster(vlCurrent.fNxt);
	exit(vlCurrent);
end;

{---( TRegisterMaster )--------------------------------------------------}

function  TRegisterMaster.GetState(ParBegin,ParEnd : cardinal):TResourceState;
var
	vlStat : TResourceState;
	vlCnt  : cardinal;
begin
	if (ParBegin > ParEnd) or (ParBegin < iMInimalSize) or (ParEnd > iMaximalSize) then fatal(fat_Invalid_Byte_Pos,['code=',iCode,'Range=(',ParBegin,'-',ParEnd,') Min=',iMinimalSize,' Max=',iMaximalSize]);
	vlCnt := ParBegin;
	vlStat := RU_Nothing;
	while vlCnt <= ParEnd do begin
		case voState[vlCnt] of
			RU_Using  :vlStat := RU_Using;
			RU_Free   :if vlStat = RU_Nothing then vlStat := RU_Free;
		end;
		inc(vlCnt);
	end;
	exit(vlStat);
end;

procedure  TRegisterMaster.ResetState;
var
	vlCnt : cardinal;
begin
	fillchar(voUseCnt,sizeof(voUseCnt),0);
	fillchar(voLocks,sizeof(voLocks),0);
	vlCnt := 0;
	iLastUsed := 0;
	while vlCnt <=3 do begin
		voState[vlCnt] := RU_Nothing;
		inc(vlCnt);
	end;
end;

procedure TRegisterMaster.Commonsetup;
begin
	inherited Commonsetup;
	ResetState;
end;


procedure  TRegisterMaster.SetLock(ParBegin,ParEnd : cardinal);
var vlCnt :cardinal;
begin
	if  (ParEnd < ParBegin) or (ParEnd > iMaximalSize) or (ParBegin < iMinimalSize) then fatal(fat_Invalid_Byte_Pos,['Pos=',ParBegin,'-',ParEnd]);
	vlCnt := ParBegin;
	while vlCnt <=ParEnd  do begin
		inc(voLocks[vlCnt]);
		inc(vlCnt);
	end;
end;

procedure TRegisterMaster.ResetLock(parBegin,ParEnd:cardinal);
var vlCnt : cardinal;
begin
	if (ParEnd < ParBegin) or (ParEnd > iMaximalSize) or (ParBegin < iMiniMalSize) then fatal(fat_Invalid_Byte_Pos,['Range=',ParBegin,'-',ParEnd]);
	vlCnt := ParBegin;
	while vlCnt <= ParBegin do begin
		if voLocks[vlCnt] = 0 then fatal(fat_Master_not_locked,['Code = ',iCode,' Range=',ParBegin,'-',ParEnd]);
		dec(voLocks[vlCnt]);
		dec(vlCnt);
	end;
end;

constructor TRegisterMaster.Create(ParCode,ParMinimalSize,ParMaximalSize : cardinal);
begin
	inherited Create;
	iCode := ParCode;
	iMinimalSize := ParMinimalSize;
	iMaximalSize := ParMaximalSize;
end;

procedure TRegisterMaster.IncUseCnt(ParBegin,ParEnd : cardinal);
var vlCnt:cardinal;
begin
	if (ParBegin > ParEnd) or (ParBegin < iMInimalSize) or (ParEnd > iMaximalSize) then fatal(fat_Invalid_Byte_Pos,['Range=',ParBegin,'-',ParEnd]);
	vlCnt := ParBegin;
	{$ifdef showregres}
	write('I)',iCode,' ',ParBegin,'-',ParEnd,'/');
	{$endif}
	while vlCnt <= ParEnd do begin
		inc(voUseCnt[vlCnt]);
		voState[vlcnt]:=(RU_Using);
		{$ifdef showregres}
		write(vlCnt,' (',voUseCnt[vlCnt],'/',cardinal(voState[vlCnt]),')');
		{$endif}
		inc(vlCnt);
	end;
	{$ifdef showregres}
	writeln;
	{$endif}
end;


procedure TRegisterMaster.DecUseCnt(ParBegin,ParEnd : cardinal);
var vlCnt:cardinal;
begin
	if (ParBegin > ParEnd) or (ParBegin < iMInimalSize) or (ParEnd > iMaximalSize) then fatal(fat_Invalid_Byte_Pos,['Code=',iCode,' Range=',ParBegin,'-',ParEnd]);
	vlCnt := ParBegin;
	{$ifdef showregres}
	write('D)',iCode,' ',ParBegin,'-',ParEnd,'/');
	{$endif}
	
	while vlCnt <= ParEnd do begin
		if voUseCnt[vlCnt]>0 then dec(voUseCnt[vlCnt])
		else if voState[vlCnt] <> RU_Using then Fatal(FAT_Try_DEC_Reg_Zero_UseCnt,['Master ',iCode,'No:',vlCnt,'/(',ParBegin,'-',ParEnd]);
		if (voUseCnt[vlCnt] = 0) and (voLocks[vlCnt]= 0 ) then voState[vlCnt] := RU_Free;
		{$ifdef showregres}
		write(vlCnt,' (',voUseCnt[vlCnt],'/',cardinal(voState[vlCnt]),')');
		{$endif}
		
		inc(vlCnt);
	end;
	{$ifdef showregres}
	writeln;
	{$endif}
	
end;


procedure TRegisterMaster.SetState(ParBegin,ParEnd : cardinal;ParState : TResourceState);
var vlCnt:cardinal;
begin
	{$ifdef showregres}
	writeln('State ',ParBegin,'-',ParEnd,' to ',cardinal(ParState));
	{$endif}
	if (ParBegin > ParEnd) or (ParBegin < iMInimalSize) or (ParEnd > iMaximalSize) then fatal(fat_Invalid_Byte_Pos,['Range=',ParBegin,'-',ParEnd]);
	vlCnt := ParBegin;
	case ParState of
		RU_Free:begin
			while vlCnt <=ParEnd do begin
				if (voUseCnt[vlCnt] = 0) and (voLocks[vlCnt]=0) then voState[vlCnt] := RU_Free
				else exit;
				inc(vlCnt);
			end;
		end;
		RU_Using:begin
			while vlCnt <= ParEnd do begin
				voState[vlCnt] := ParState;
				inc(vlCnt);
			end;
		end;
	end;
end;

{---( TRegister )-------------------------------------------------------}


function TRegister.GetLastUsed : cardinal;
begin
	exit(iStorageMaster.fLastUsed);
end;

procedure TRegister.SetLastUSed(ParUsed : cardinal);
begin
	iStorageMaster.fLastUsed := Parused;
end;

procedure   TRegister.SetLock;
begin
	iStorageMaster.SetLock(iPartBegin,iPartEnd);
end;

procedure TRegister.ResetLock;
begin
	iStorageMaster.ResetLock(iPartBegin,iPartEnd);
end;

procedure   TRegister.Reserve;
begin
	SetUse(RU_Using);
end;

procedure   TRegister.Release;
begin
	SetUse(RU_Free);
end;

function   TRegister.GetcanDoFlag(ParFlag:TAsmStorageCanDO):boolean;
begin
	exit( (ParFlag * iCanDoFlag)=Parflag);
end;


procedure TRegister.SetOtherSize(ParLarger,ParSmall:TRegister);
begin
	voSmallerSize  := parSmall;
	voLargerSize   := ParLarger;
	voMainRegister := self;
	while voMainRegister.fLargerSize <> nil do voMainRegister := voMainRegister.fLargerSize;
end;


procedure TRegister.IncUseCnt;
begin
	iStorageMaster.IncUSeCnt(iPartBegin,iPartEnd);
end;

procedure TRegister.DecUseCnt;
begin
	iStorageMaster.DecUseCnt(iPartBegin,iPartEnd);
end;


constructor TRegister.Create(ParMaster : TRegisterMaster;ParRegisterCode:TNormal;ParSize:TSize;ParRegHints:TRegHints;ParCanDo:TAsmStorageCanDo;ParPartBegin,ParPartEnd:cardinal);
begin
	inherited Create;
	iRegisterCode  := PArRegisterCode;
	iSize          := ParSize;
	iStorageMaster := PArMaster;
	iHints         := ParRegHints;
	iCanDoFlag     := ParCanDo;
	iPartBegin     := ParPartBegin;
	iPartEnd       := ParPartEnd;
end;

function  TRegister.IsPartOf(ParRegister:TRegister):boolean;
begin
	exit((ParRegister.fMainRegister = iMainRegister) and (ParRegister.fPartBegin <= iPartEnd) and (ParRegister.fPartEnd >= iPartBegin))
end;


function TRegister.GetUse:TResourceState;
begin
	exit( iStorageMaster.GetState(iPartBegin,iPartEnd));
end;


procedure TRegister.SetUse(ParUse:TResourceState);
begin
	iStorageMaster.SetState(iPartBegin,iPartEnd,ParUse);
end;

procedure TRegister.CommonSetup;
begin
	inherited CommonSetup;
	iCanDoFlag := [];
	iHints   := [];
	SetOtherSize(nil,nil);
end;


function TRegister.GetName:String;
var vlDummy:String;
begin
	GetAssemblerInfo.GetRegisterByCode(fRegisterCode,vlDummy);
	exit( vlDummy);
end;


{-----( TRegisterList )------------------------------------------------}


procedure TRegisterList.ResetStates;
begin
	iStorageMasterList.ResetStates;
end;

procedure TRegisterList.AddStorageMaster(ParCode,ParMinimalSize,ParMaximalSize : cardinal);
begin
	iStorageMasterList.AddStorageMaster(PArCode,ParMinimalSize,ParMaximalSize);
end;

function  TRegisterList.GeTRegisterMasterByCode(ParCode : cardinal):TRegisterMaster;
begin
	exit(iStorageMasterList.GeTRegisterMasterByCOde(ParCode));
end;

procedure TRegisterList.Commonsetup;
begin
	inherited Commonsetup;
	iUseCnt := 0;
	iStorageMasterList := TRegisterMasterList.Create;
end;

procedure TRegisterList.Clear;
begin
	inherited Clear;
	if iStorageMasterList <> nil then iStorageMasterList.Destroy;
end;

constructor TRegisterList.Create(const ParRegInfo:Array of TRegisterInfo;const ParMaster:Array of TMasterInfo);
var vlCnt    : cardinal;
	vlReg    : TRegister;
	vlMaster : TRegisterMaster;
begin
	inherited Create;
	for vlCnt := 0 to high(ParMaster) do AddStorageMaster(ParMaster[vlCnt].cod,ParMaster[vlCnt].Srg,ParMaster[vlCnt].Lrg);
	for vlCnt := 0 to high(ParRegInfo) do begin
		vlMaster   := GeTRegisterMasterByCode(ParRegInfo[vlCnt].mrg);
		if vlmaster = nil then fatal(FAT_Cant_Find_Master,['Reg=',vlCnt]);
		vlReg := TRegister.Create(vlMaster,ParRegInfo[vlCnt].reg,ParReginfo[vlcnt].siz,ParRegInfo[vlCnt].rhi,ParRegInfo[vlCnt].CDO,ParRegInfo[vlCnt].PRT,ParRegInfo[vlCnt].Pre);
		AddItem(vlReg);
	end;
	for vlCnt := 0  to high(ParRegInfo) do begin
		vlReg := GetRegisterByCode(ParREGInfo[vlCnt].ReG);
		vlReg.SetOtherSize(GetRegisterByCode(ParREGInfo[vlCnt].Lrg),GetRegisterByCode(PArREGInfo[vlCnt].sRg));
	end;
end;

function  TRegisterList.GetSpecialRegister(ParType:TAsmStorageCanDo;ParSize : TSize):TRegister;
var vlCurrent:TRegister;
begin
	vlCurrent := TRegister(fStart);
	while (vlCurrent<> nil) and ( (vlCurrent.fSize <> ParSize) or not(vlCurrent.GetCanDoFlag(ParType))) do
	vlCurrent := TRegister(vlCurrent.fNxt);
	exit(vlCurrent);
end;

function  TRegisterList.GetRegisterByCOde(ParRegisterCode:TNormal):TRegister;
var vlCurrent:TRegister;
begin
	vlCurrent := TRegister(fTop);
	while (vlCurrent <> nil) and (vlCurrent.fRegisterCode <> ParRegisterCode) do begin
		vlCurrent := TRegister(vlCurrent.fPrv);
	end;
	exit( vlCurrent);
end;

procedure TRegisterList.AddItem(const ParRegister:TRegister);
begin
	insertAtTop(ParRegister);
end;

function  TRegisterList.GetFreeRegisterByHint(ParSize:TSize;ParHint : TRegHint):TRegister;
var
	vlCurrent  : TRegister;
	vlSizeOk   : boolean;
	vlFree     : TRegister;
begin
	vlCurrent  := TRegister(fStart);
	vlFree     := nil;
	vlSizeOk   := false;
	iUseCnt    := iUseCnt + 1;
	{$ifdef showregres}
	writeln('Reserve Size=',ParSize);
	{$endif}
	while vlCurrent <> nil do begin
		if (vlCurrent.fSize = PArsize) and
		vlCurrent.GetCanDOFlag([CD_Reserve]) then begin
			vlSizeOk := true;
			if ParHint in vlCurrent.fHints then begin
				case vlCurrent.GetUse of
					RU_Free,RU_Nothing    : begin

						if (vlFree = nil) or (vlCurrent.fLastUSed < vlFree.fLastUsed) then begin
							vlFree := vlCurrent;
							if vlFree.fLastUsed = 0 then break;
						end;
					end;
				end;
			end;
		end;
		vlCurrent := TRegister(vlCurrent.fNxt);
	end;
	if vlFree <> nil then begin
		vlFree.SetUse(RU_USING);
		vlFree.fLastUsed := iUseCnt;

	end else begin
		if not vlSizeOk then fatal(FAT_Invalid_Variable_Size,['Size=',ParSize]);
	end;
	exit(vlFree);
end;

function  TRegisterList.GetFreeRegister(ParSize:TSize):TRegister;
var vlNotInUse : TRegister;
	vlCurrent  : TRegister;
	vlSizeOk   : boolean;
begin
	vlCurrent  := TRegister(fStart);
	vlNotInUse := nil;
	vlSizeOk := false;
	iUseCnt := iUseCnt + 1;
	{$ifdef showregres}
	writeln('Reserve Size=',ParSize);
	{$endif}
	while vlCurrent <> nil do begin
		if (vlCurrent.fSize = PArsize) and vlCurrent.GetCanDOFlag([CD_Reserve]) then begin
			vlSizeOk := true;

			case vlCurrent.GetUse of
				RU_Nothing,RU_Free: begin
					if (vlNotInuse = nil) or (vlCurrent.fLastUsed<vlNotInUse.fLastUsed) then begin
						vlNotInUse := vlCurrent;
						if(vlCurrent.fLastUsed = 0) then break;
					end;
				end;
			end;
		end;
		vlCurrent := TRegister(vlCurrent.fNxt);
	end;
	if vlNotInUse <> nil then begin
		vlNotinUse.SetUse(RU_USING);
		vlNotInUse.fLastUsed := iUseCnt;
	end else begin
		if not vlSizeOk then fatal(FAT_Invalid_Variable_Size,['Size=',ParSize]);
	end;
	{$ifdef showregres}
	if vlNotInUse <> nil then writeln('Reserved(unused) :',cardinal(vlNotInUse.fRegisterCode));
	{$endif}
	exit(vlNotInUse);
end;


function TRegisterList.GetAsRegister(ParReg:TRegister;ParSize : TSize):TRegister;
var vlMainReg,vlCUrrent:TRegister;
begin
	vlMainReg := ParReg.fMainRegister;
	vlCurrent := TRegister(fStart);
	while vlCurrent <> nil do  begin
		if (vlCurrent.fMainRegister = vlMainReg) and (vlCurrent.fPartBegin  = ParReg.fPartBegin)  and (vlCurrent.fSize = ParSize) then begin
			exit(vlCurrent);
		end;
		vlCurrent := TRegister(vlCurrent.fNxt);
	end;
	exit(nil);
end;

end.
