{
    Elaya, the compiler for the elaya language
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
unit DDefinit ;
interface
uses useitem,streams,cmp_type,elacons,progutil,compbase,hashing,display,node,stdobj,elatypes,error,asmdata;
type
	TDefinition=class(TBaseDefinition)
	private
		voDefault         : TDefaultTypeCode;
		voHashNext        : TDefinition;
		voOwner           : TDefinition;
		voDefAccess       : TDefAccess;
		voAllwaysSave     : boolean;
		voIdentCode       : TIdentCode;
	protected

		property     iAllwaysSave     : boolean          read voAllwaysSave     write voAllwaysSave;
		property     iOwner           : TDefinition      read voOwner           write voOwner;
		property     iDefAccess       : TDefAccess       read voDefAccess       write voDefAccess;
		property     iIdentCode       : TIdentCode       read voIdentCode       write voIdentCode;
		procedure    CommonSetup;override;

	public
		property     fHashNext   : TDefinition      read voHashNext;
		property     fDefault    : TDefaultTypeCode read voDefault;
		property     fOwner      : TDefinition      read voOwner     write voOwner;
		property     fDefAccess  : TDefAccess       read voDefAccess write voDefAccess;
		property     fIdentCOde  : TIdentCode       read voIdentCode;

		
		function     IsAsmGlobal : boolean;
		function     MustSaveItem : boolean;
		function     GetForwardDefined : boolean;virtual;
		procedure    SignalInPublicSection;virtual;
		
		procedure    AddToHashing(ParHash:THashing);
		procedure    SetDefault(ParDefault : TDefaultTypeCode);
		procedure    SetHashingObject(ParHash:THashing);virtual;
		procedure    SetHashNext(ParDef:TDefinition);
		
		function     Addident(Parident:TDefinition):TErrorType;virtual;
		function     Can(ParCan:TCan_Types):boolean;virtual;
		function     CreateDB(ParCre:TCreator):boolean;virtual;
		function     CreateVar(ParCre:TCreator;const ParName:ansistring;ParDef:TDefinition):TDefinition;virtual;
		function     GetDefaultIdent(ParCode:TDefaultTypeCode;ParSize:TSize;ParSign:boolean):TDefinition;
		
		procedure    GetTextName(var ParName : ansistring);virtual;
		procedure    GetForParentMangleName(var ParName : ansistring);virtual;
		function     GetPtrByName(const ParName:ansistring;ParOption : TSearchOptions;var ParOwner,ParItem:TDefinition):boolean;virtual;
		function      MustNameAddAsOwner:boolean; virtual;
		procedure    GetMangledName(var ParName:ansistring);
		procedure    PreMangledName(var Parname:ansistring); virtual;
		procedure    OnMangledName(var ParName:ansistring); virtual;
		procedure    PostMangledName(var ParName:ansistring);virtual;
		
		function     loaditem(ParWrite:TObjectStream):boolean;override;
		function     Saveitem(ParWrite:TObjectStream):boolean;override;
		function     GetAccessLevelTo(ParOther : TDefinition) : TDefAccess;virtual;

		procedure    SetAllwaysSave;
		{Validate}
		function     CheckDuplicate(ParDef : TDefinition):boolean;
		{print}
		procedure    Print(ParDis:TDisplay);override;
		procedure    PrintName(ParDis:TDisplay);override;
		procedure    PrintDefinitionType(ParDis : TDisplay);virtual;
		procedure    PrintDefinitionHeader(ParDis : TDisplay);virtual;
		procedure    PrintDefinitionName(ParDis : TDisplay);virtual;
		procedure    PrintDefinitionBody(ParDis : TDisplay);virtual;
		procedure    PrintDefinitionEnd(ParDis : TDisplay);virtual;
		{get}
		function     GetRealOwner:TDefinition;virtual;
		function     GetPtrByObject(const ParName : ansistring;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;virtual;
		function     GetPtrByArray(const ParName : ansistring;const ParArray:array of TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;virtual;

		function     GetAccessTo(ParDef : TDefinition): TDefAccess;
		function     GetUnitLevelAccess : TDefAccess;
		procedure    GetDisplayName(var ParName :ansistring);virtual;
		function     GetPtrInCurrentList(const ParName : ansistring;var ParOwner,ParItem :TDefinition):boolean;virtual;

		{Is function}
		function     IsSameByObject(const ParName : ansistring;ParObject : TRoot):TObjectFindState;virtual;
		function     IsCompleet:boolean;virtual;
		function     IsIsolated : boolean;virtual;
		procedure    AddGlobalsToHashing(ParHash:THashing);virtual;
		procedure    ConsiderForward(ParCre : TCreator;ParIn : TDefinition;var ParOut : TDefinition);virtual;
		function     IsSameAsForward(ParCB : TDefinition;var ParText : ansistring):boolean;virtual;
		procedure    SetDefinitionModes(ParMode : TDefinitionModes;ParOn : boolean);
		function     SignalCPublic:boolean;virtual;
		procedure    GetOVData(ParCre :TCreator;ParRoutine : TDefinition;var ParOther : TDefinition;var ParModes : TOVModes;var ParMeta : TDefinition);virtual;
		procedure    AddParameterToNested(ParCre : TCreator;ParNested :TDefinition);virtual;
		function     GetParent : TDefinition;virtual;
		function     GetOwnerLevelTo(ParItem : TDefinition;var ParLevel : cardinal):boolean;
		function     GetRelativeLevel : cardinal;virtual;
		function     IsParentOf(ParIdent : TDefinition):boolean;
		function     GetObjectByLevel(ParLevel : cardinal;ParOrg : TDefinition):TDefinition;
		function     HasAbstracts : boolean;virtual;
		function     IsOrHasAbstracts:boolean;
		function     HasGlobalParts : boolean;virtual;

		{Set Modes}
        	procedure  SetAnonymousIdent;
		function   CreateExecuteNode(ParCre:TCreator;ParParent : TDefinition):TNodeIdent;virtual;
		function   CreateObjectPointerNode(ParCre : TCreator;ParParent :TDefinition):TNodeIdent;virtual;
		{Address stuf}
		procedure    AddVmtLabel(ParCre : TCreator);virtual;
		procedure   InitDotFrame(ParCre :TSecCreator;ParMac : TNodeIdent;ParContext : TDefinition);virtual;
		procedure   DoneDotFrame;virtual;
		function    HasOwner(ParIdent : TDefinition) : boolean;
		function    IsSameIdentCode(ParIdent:TDefinition):boolean;
      		procedure   AddToUseList(ParUse : TUseList);virtual;
		function    CreateDefinitionUseItem : TUseItem;virtual;
		function    NeedReadableRecord : boolean;virtual;
		function    AssumeInitDU(ParIdent : TDefinition):boolean;virtual;
	   	function   IsSameParamByNodesArray(const ParNodes :array of TRoot;ParExact : boolean):boolean;virtual;
		procedure  CheckAfter(ParCre : TCreator);virtual;
	end;

	TRefDefinition=class of TDefinition;
	
implementation

uses asminfo,asmcreat,ndcreat;

{-----( TDefinition )-------------------------------------------------------------------}
procedure  TDefinition.CheckAfter(ParCre : TCreator);
begin
end;

function TDefinition.IsSameParamByNodesArray(const ParNodes :array of TRoot;ParExact : boolean):boolean;
begin
	exit(false);
end;

function TDefinition.AssumeInitDU(ParIdent : TDefinition):boolean;
begin
	exit(ParIdent.GetRealOwner <> self);
end;

function  TDefinition.CreateDefinitionUseItem : TUseItem;
begin
	exit(TDefinitionUseItem.Create(self));
end;


function  TDefinition.NeedReadableRecord : boolean;
begin
	exit(true);
end;

function  TDefinition.HasGlobalParts : boolean;
begin
	exit(false);
end;

procedure TDefinition.AddToUseList(ParUse : TUseList);
begin
	ParUse.InsertAt(nil,CreateDefinitionUseItem);
end;

function TDefinition.IsSameIdentCode(ParIdent:TDefinition):boolean;
begin
	exit( (PArIdent <> nil) and (ParIdent.fIdentCode = fIdentCode));
end;



function  TDefinition.CheckDuplicate(ParDef : TDefinition):boolean;
begin
	exit(ParDef <> nil);
end;


procedure TDefinition.SetAnonymousIdent;
begin
	iOwner := nil;
	iDefAccess := AF_Public;
	iDefinitionModes := iDefinitionModes+[DM_Anonymous];
end;

function TDefinition.GetAccessLevelTo(ParOther : TDefinition) : TDefAccess;
begin
	while (ParOther <> nil) do begin
		if self = parother then exit(AF_Private);
		if IsParentOf(ParOther) then exit(AF_Protected);
		ParOther := ParOther.GetRealOwner;
	end;
	exit(AF_Public);
end;

function TDefinition.HasOwner(ParIdent :TDefinition) : boolean;
var
	vlCurrent  :TDefinition;
begin
	vlCurrent := self;
	while (vlCUrrent <> nil) and (vlCurrent <> ParIdent) do vlCurrent := vlCurrent.GetRealOwner;
	exit(vlCurrent <> nil);
end;

function  TDefinition.IsIsolated : boolean;
begin
	exit(false);
end;


procedure  TDefinition.InitDotFrame(ParCre :TSecCreator;ParMac : TNodeIdent;ParContext : TDefinition);
begin
end;

procedure  TDefinition.DoneDotFrame;
begin
end;


function  TDefinition.IsOrHasAbstracts:boolean;
begin
	exit(HasAbstracts);
end;


function  TDefinition.HasAbstracts : boolean;
begin
	exit(false);
end;

procedure TDefinition.AddVmtLabel(ParCre : TCreator);
var
	vlName : ansistring;
begin
	GetMangledName(vlName);
	TAsmCreator(ParCre).AddData(TAddressDef.CREATE(DAT_Code,vlName));
end;

function TDefinition.GetObjectByLevel(ParLevel : cardinal;ParOrg : TDefinition):TDefinition;
var
	vlContext  : TDefinition;
	vlOrgOwner : TDefinition;
	vlLevel    : cardinal;
	vlPm       : cardinal;
begin
	vlLevel    := ParLevel;
	vlContext  := self;
	vlOrgOwner := ParOrg;
	while (vlLevel >1) and (vlContext <> nil) and (vLOrgOwner <> nil) do begin
		if(vlContext.GetRelativeLevel < vlOrgOwner.GetRelativeLevel) then fatal(FAT_Can_Match_Owner_hyr,'');
		vlPm      := vlContext.GetRelativeLevel - vlOrgOwner.GetRelativeLevel;
		while(vlContext <> nil) and (vlPm > 0) do begin
			vlContext := vlContext.GetRealOwner;
			dec(vlPm);
		end;
		if(vlContext = nil) then begin
			fatal(FAT_Can_Match_Owner_hyr,'');
		end;
		vlContext  := vlContext.GetRealOwner;
		vlOrgOwner := vlOrgOwner.GetRealOwner;
		dec(vlLevel);
	end;
	exit(vlContext);
end;


function   TDefinition.IsParentOf(ParIdent : TDefinition):boolean;
var vlIdent : TDefinition;
begin
	vlIdent := ParIdent;
	while (vlIdent <> nil) and (self <> vlIdent) do vlIdent := vlIdent.GetParent;
	exit(vlIdent <> nil);
end;

function TDefinition.GetRelativeLevel : cardinal;
begin
	exit(0);
end;

function TDefinition.GetOwnerLevelTo(ParItem : TDefinition;var ParLevel : cardinal):boolean;
var
	vlCur   : TDefinition;
	vlLevel : cardinal;
begin
	vlCur := self;
	vlLevel := 0;
	while (vlCur <> nil) and (vlCur <> ParItem) do begin
		if(ParItem <> nil) then begin
			if ParItem.IsParentOf(vlCur) then break;
		end;
		inc(vlLevel);
		vlCur := vlCur.GetRealOwner;
	end;
	ParLevel := vlLevel;
	exit((vlCur = ParItem) or (vlCur <> nil))
end;



function TDefinition.GetParent : TDefinition;
begin
	exit(nil);
end;

procedure TDefinition.AddParameterToNested(ParCre : TCreator;ParNested :TDefinition);
begin
end;

procedure TDefinition.GetOVData(ParCre : TCreator;ParRoutine : TDefinition;var ParOther : TDefinition;var ParModes : TOVModes;var ParMeta : TDefinition);
begin
	ParMeta := nil;
	ParModes := [];
end;

function TDefinition.GetRealOwner:TDefinition;
begin
	exit(fOwner);
end;

function TDefinition.SignalCPublic:boolean;
begin
	SetDefinitionModes([DM_CPublic],true);
	exit(true);
end;

procedure   TDefinition.SetDefinitionModes(ParMode : TDefinitionModes;ParOn : boolean);
begin
	if ParOn then iDefinitionModes := iDefinitionModes + ParMode
	else iDefinitionModes := iDefinitionModes - ParMode;
end;


procedure   TDefinition.GetDisplayName(var ParName :ansistring);
begin
	ParName := fText;
end;

function  TDefinition.IsCompleet:boolean;
begin
	exit(true);
end;


function  TDefinition.IsSameAsForward(ParCB : TDefinition;var ParText : ansistring):boolean;
begin
	exit(true);
end;

procedure TDefinition.ConsiderForward(ParCre : TCreator;ParIn : TDefinition;var ParOut : TDefinition);
begin
	ParOut := nil;
end;

function  TDefinition.GetUnitLevelAccess : TDefAccess;
begin
	exit(GetAccessTo(nil));
end;


function  TDefinition.GetAccessTo(ParDef : TDefinition): TDefAccess;
var vlDef      : TDefAccess;
	vlOwner    : TDefinition;
	vlDefOwner : TDefinition;
begin
	vlDef := fDefAccess;
	vlOwner := fOwner;
	vlDefOwner := nil;
	if ParDef <> nil then vlDefOwner := ParDef.fOwner;
	while (vlOwner <> nil) do begin
		if(vlOwner = vlDefOwner) or (vlOwner.IsParentOf(vlDefOwner)) then break;
		vlDef := CombineAccess(vlDef,vlOwner.fDefAccess);
		vlOwner := vlOwner.GetRealOwner;
	end;
	exit(vlDef);
end;

function TDefinition.GetPtrByArray(const ParName : ansistring;const ParArray:array of TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;
begin
	ParResult := nil;
   ParOwner  := nil;
   exit(ofs_Different);
end;


function  TDefinition.GetPtrByObject(const ParName : ansistring;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;
begin
	ParResult := nil;
	ParOwner  := nil;
	exit(ofs_Different);
end;

function  TDefinition.IsSameByObject(const ParName : ansistring;ParObject : TRoot):TObjectFindState;
begin
	if IsSameText(ParName) then exit(OFS_Same);
	exit(OFS_Different);
end;

procedure TDefinition.SignalInPublicSection;
begin
end;

function TDefinition.GetForwardDefined : boolean;
begin
	exit(false);
end;

function TDefinition.MustSaveItem : boolean;
begin
exit((fDefAccess in [AF_Public,AF_Protected]) or (iAllwaysSave));
end;

function TDefinition.IsAsmGlobal : boolean;
begin
exit((fDefAccess in [AF_Public,AF_Protected]) or iAllwaysSave);
end;

procedure TDefinition.PrintDefinitionType(ParDis : TDisplay);
begin
	ParDis.Write('<abstract>');
end;

procedure TDefinition.PrintDefinitionHeader(ParDis : TDisplay);
begin
	ParDis.Write('<access>');
	case fDefAccess of
		AF_Public    : ParDis.Write('PUBLIC ');
		AF_Private   : ParDis.Write('PRIVATE ');
		AF_Protected : ParDis.Write('PROTECTED ');
		AF_Current   : ParDis.Write('Error : CURRENT');
	end;
	ParDis.Write('</access><kind>');
	PrintDefinitionType(ParDis);
	ParDis.writeNl('</kind><name>');
	PrintDefinitionName(ParDis);
	ParDis.WriteNl('</name>');
end;

procedure TDefinition.PrintDefinitionName(ParDis : TDisplay);
begin
	PrintName(ParDis);
end;

procedure TDefinition.PrintDefinitionBody(ParDis : TDisplay);
begin
end;

procedure TDefinition.PrintDefinitionEnd(ParDIs : TDisplay);
begin
end;


procedure TDefinition.GetForParentMangleName(var ParName : ansistring);
begin
	ParName := fText;
end;

procedure TDefinition.GetTextName(var ParName : ansistring);
begin
	ParName := fText;
end;


function    TDefinition.MustNameAddAsOwner:boolean;
begin
	exit(false);
end;

procedure   TDefinition.AddToHashing(ParHash:THashing);
var
	vlDef  : TDefinition;
begin
	if ParHash <> nil then begin
		vlDef := TDefinition(ParHash.SetHashIndex(fText,self));
		AddGlobalsToHashing(ParHash);
		if vlDef = self then runerror(253);
		SetHashNext(vlDef);
	end;
end;

procedure   TDefinition.SetHashingObject(ParHash:THashing);
begin
end;

procedure   TDefinition.AddGlobalsToHashing(ParHash:THashing);
begin
end;

procedure   TDefinition.SetHashNext(ParDef:TDefinition);
begin
	voHashNext := ParDef;
end;

procedure   TDefinition.OnMangledName(var ParName:ansistring);
var vlName : ansistring;
begin
	GetTextName(vlName);
	GetAssemblerInfo.AddMangling(ParName,vlName);
end;

procedure   TDefinition.PreMangledName(var Parname:ansistring);
var
	vlName : ansistring;
	vlDef  : TDefinition;
begin
	Setlength(ParName,1);
	ParName[1] := '_';
	vlDef := self;
	while (vlDef.fModule = nil) and (vlDef.fOwner <> nil) do vlDef := vlDef.fOwner;
	if (vlDef.fModule <> nil) and (IsAsmGlobal) then begin
		TModule(vlDef.fModule).GetModuleName(vlName);
		GetAssemblerInfo.AddMangling(ParName,vlName);
	end;
	vlDef := fOwner;
	while vlDef <> nil do begin
		if vlDef.MustNameAddAsOwner then begin
			vlDef.GetForParentMangleName(vlName);
			GetAssemblerInfo.AddMangling(ParName,vlName);
		end;
		vlDef := vlDef.GetRealOwner;
	end;
	
end;

function TDefinition.CreateVar(ParCre:TCreator;const ParName:ansistring;ParDef:TDefinition):TDefinition;
begin
	CreateVar := nil;
	TNDCreator(ParCre).SemError(Err_Cant_Define_Vars);
end;


procedure  TDefinition.PostMangledName(var ParName:ansistring);
begin
end;

procedure TDefinition.GetMangledName(var parName:ansistring);
begin
	if not (dm_CPublic in fDefinitionModes)  then begin
		PreMangledName(ParName);
		onMangledName(ParName);
		PostMangledName(ParName)
	end else begin
		GetTextName(ParName);
		if not(dm_interface in fDefinitionModes) then LowerStr(ParName);
		{Hack: to avoid lowestr on a interface}
	end;
end;



function  TDefinition.CreateExecuteNode(ParCre:TCreator;ParParent : TDefinition):TNodeIdent;
begin
	fatal(	FAT_Cant_Create_Nodes_here,'');
end;

function  TDefinition.CreateObjectPointerNode(ParCre : TCreator;ParParent :TDefinition):TNodeIdent;
begin
	exit(nil);
end;



function TDefinition.CreateDB(ParCre:TCreator):boolean;
begin
	CreateDB:= false;
end;

procedure TDefinition.SetDefault(ParDefault : TDefaultTypeCode);
begin
	voDefault   := Pardefault;
end;



function TDefinition.GetDefaultIdent(ParCode:TDefaultTypeCode;ParSize:TSize;ParSign:boolean):TDefinition;
begin
	GetDefaultIdent := nil;
end;


procedure TDefinition.SetAllwaysSave;
begin
	iAllwaysSave := true;
end;


procedure TDefinition.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := IC_Unkown;
	SetDefault(DT_Nothing);
	SetHashNext(nil);
	fDefAccess := AF_Current;
	fOwner     := nil;
	iLine      := 0;
	iCol       := 0;
	iPos       := 0;
	iAllwaysSave     := false;
	iIdentCode       := IC_Unkown;
end;

function TDefinition.loaditem(ParWrite:TObjectStream):boolean;
begin
	loaditem := true;
	if inherited loaditem(ParWrite) then exit;
	if  ParWrite.ReadPi(voOwner) then exit;
	if  ParWrite.ReadLOng(cardinal(voDefAccess)) then exit(true);
	loaditem := false;
end;

function TDefinition.SaveItem(ParWrite : TObjectStream) : boolean;
begin
	if inherited SaveItem(ParWrite) then exit(true);
	if ParWrite.WritePi(fOwner) then exit(true);
	if PArWrite.WriteLong(cardinal(fDefAccess)) then exit(true);
	exit(false);
end;



function TDefinition.GetPtrByName(const ParName:ansistring;ParOption : TSearchOptions;var ParOwner,ParItem : TDefinition):boolean;
begin
	ParOwner := nil;
	ParItem  := nil;
	exit(false);
end;


function   TDefinition.GetPtrInCurrentList(const ParName : ansistring;var ParOwner,ParItem :TDefinition):boolean;
begin
	exit(GetPtrByName(ParName,[SO_Local],ParOwner,ParItem));
end;

function TDefinition.Addident(Parident:TDefinition):TErrorType;
begin
	Fatal(Fat_abstract_routine,'At:TDefinition.AddIdent');
	AddIdent := err_no_error;
end;


procedure TDefinition.Print(ParDis:TDisplay);
begin
	ParDis.write('<identdef>');
	PrintDefinitionHeader(ParDis);
	ParDis.Write('<block>');
	PrintDefinitionBody(ParDis);
	ParDis.Write('</block><end>');
	PrintDefinitionEnd(ParDis);
	ParDis.Write('</end>');
	ParDis.write('</identdef>');
end;

procedure TDefinition.PrintName(ParDis:TDisplay);
var
	vlName : ansistring;
begin
	GetDisplayName(vlName);
	ParDis.Write(vlName);
end;


function TDefinition.Can(ParCan:TCan_Types):boolean;
begin
	exit(ParCan = []);
end;


end.
