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
unit meta;
interface
uses vars,macobj,stdobj,varbase,asminfo,strmbase,linklist,ddefinit,elacons,elatypes,
	  formbase,streams,node,frames,compbase,asmcreat,asmdata;
type
	TVmtItem=class(TListItem)
	private
		voRoutine   : TDefinition;
		voOffset    : cardinal;
		voVmtVar    : TFrameVariable;
	protected
		property    iOffset    : cardinal       read voOffset    write voOffset;
		property    iRoutine   : TDefinition    read voRoutine   write voRoutine;
		property    iVmtVar    : TFrameVariable read voVmtVar    write voVmtVar;
	public
		property    fRoutine   : TDefinition     read voRoutine write voRoutine;
		property    fVmtVar    : TFrameVariable	read voVmtVar;
		property    fOffset    : cardinal       read voOffset;

		constructor Create(ParRoutine : TDefinition;ParOffset : TOFfset;ParMetaFrame : TFrame;ParType:TType);
		function    SaveItem(ParStream : TObjectStream):boolean;override;
		function    LoadItem(ParStream : TObjectStream):boolean;override;
		function    CreateDB(ParCre : TCreator):boolean;
		function    CreateReadNode(ParCre : TCreator;ParContext : TDefinition):TNodeIdent;
		function    CreateMac(ParContext :TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
		function    Clone(ParFrame : TFrame) : TVmtItem;
		function    HasAbstracts : boolean;
		procedure   Clear;override;
	end;
	
	TVmtList=class(TList)
	private
		voOffset    : TOffset;
		voVmtType   : TType;
		
	protected
		property  iOffset    : TOffset read voOffset    write voOffset;
		property  iVmtType   : TType   read voVmtType   write voVmtType;
		procedure   Commonsetup;override;
		
	public
		property  fOffset   : TOffset  read voOffset	write voOffset;
		property  fVmtType   : TType   read voVmtType   write voVmtType;
		
		function    AddVirtualRoutine(ParCB :TDefinition;ParFrame : TFrame):TVmtItem;
		function    SaveItem(ParStream : TObjectStream):boolean;override;
		function    LoadItem(ParStream : TObjectStream):boolean;override;
		function    CreateDB(ParCre : TCreator):boolean;
		procedure   CopyList(ParOffset : TOffset;ParList : TVmtList;ParFrame : TFrame);
		procedure   AddVmtItem(ParItem :TVmtItem);
		function    FindMetaByRoutine(ParCB : TDefinition):TVmtItem;
		function    ChangeVirtualRoutine(ParOther,ParNew : TDefinition):TVmtItem;
		function    HasAbstracts:boolean;
		constructor Create(ParOffsetBegin : TSize);
		
	end;
	
	TMeta=class(TDefinition)
	private
		voParent        : TMeta;
		voVmtList       : TVmtList;
		voRoutineName   : AnsiString;
		voMetaFrame	: TFrame;
		voAccessAddress : TVarBase;
	protected
		property    iParent          : TMeta    read voParent		 write voParent;
		property    iVmtList         : TVmtList read voVmtLIst		 write voVmtList;
		property    iRoutineName     : AnsiString  read voRoutineName 	 write voRoutineName;
		property    iMetaFrame	     : TFrame	read voMetaFrame	 write voMetaFrame;
		property    iAccessAddress	 : TVarBase read vOAccessAddress write voAccessAddress;

		procedure   Commonsetup;override;
		procedure   Clear;override;

	public
		property    fParent          : TMeta    read voParent;
		property    fVmtList         : TVmtList read voVmtLIst       write voVmtList;
		property    fMetaFrame	     : TFrame   read voMetaFrame;
		property    fAccessAddress   : TVarBase read vOAccessAddress;
		
		procedure   GetLabelName(var ParName : ansistring);
		constructor Create(ParParent : Tmeta;const ParName : ansistring;ParType : TType;ParVmtType : TType);
		function    SaveItem(ParStream : TObjectStream):boolean;override;
		function    LoadItem(ParStream : TObjectStream):boolean;override;
		function    CreateDB(ParCre : TCreator):boolean; override;
		function    AddVirtualRoutine(ParCB :TDefinition):TVmtItem;
		procedure   CopyList(ParList : TVmtList;ParFrame : TFrame);
		function    ChangeVirtualRoutine(ParOther,ParNEw : TDefinition):TVmtItem;
		procedure   CloneFromParent;
		function    HasAbstracts:boolean;override;
		function    GetVmtOffsetBegin:TOffset;virtual;
		procedure   CreatePreDB(ParCre : TCreator);virtual;
		function    GetType : TType;
		
		function    CreateObjectPointerNode(ParCre:TCreator;ParContext : TDefinition):TNodeIdent;override;
		function    CreateMac(ParContext,ParCContext :TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;virtual;
		procedure AddAddressing(ParContext : TDefinition;ParVar : TVariable;ParDone : boolean);
		procedure AddAddressing(ParContext : TDefinition;ParMac : TMacBase;ParDone:boolean);overload;
		procedure PopAddressing(ParOwner : TDefinition);
		procedure AddVmtLabel(ParCre : TCreator);override;
		
	end;
	
	
implementation

{---( TMeta )-----------------------------------------------------}
procedure TMeta.AddVmtLabel(ParCre : TCreator);
var
	vlName : ansistring;
begin
	GetLabelName(vlName);
	TAsmCreator(ParCre).AddData(TAddressDef.CREATE(DAT_Code,vlName));
end;

procedure TMeta.PopAddressing(ParOwner : TDefinition);
begin
	iMetaFrame.PopAddressing(ParOwner);
end;

procedure TMeta.AddAddressing(ParContext : TDefinition;ParVar : TVariable;ParDone : boolean);
begin
	iMetaFrame.AddAddressing(ParContext,ParContext,ParContext,ParVar,ParDone);
end;

procedure TMeta.AddAddressing(ParContext : TDefinition;ParMac : TMacBase;ParDone : boolean);overload;
begin
	iMetaFrame.AddAddressing(ParContext,ParContext,ParMac,ParDone);
end;

procedure   TMeta.GetLabelName(var ParName : ansistring);
begin
	iAccessAddress.GetMangledName(ParName);
end;

function    TMeta.CreateObjectPointerNode(ParCre:TCreator;ParContext : TDefinition):TNodeIdent;
begin
	exit(iAccessAddress.CreateObjectPointerNode(ParCre,PArContext));
end;

function    TMeta.GetType : TType;
begin
	exit(iAccessAddress.fType);
end;

function    TMeta.CreateMac(ParContext,ParCContext :TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
begin
	exit(iAccessAddress.CreateMac(ParContext,ParOption,ParCre));
end;

function  TMeta.GetVmtOffsetBegin:TOffset;
begin
	exit(OFS_ExtR_Vmt_Begin);
	end;
	
	function TMeta.ChangeVirtualRoutine(ParOther,ParNew : TDefinition):TVmtItem;
	begin
		exit(iVmtList.ChangeVirtualRoutine(ParOther,ParNew));
	end;
	
	function  TMeta.AddVirtualRoutine(ParCB :TDefinition):TVmtItem;
	var vlItem : TVmtItem;
	begin
		vlItem := iVmtList.AddVirtualRoutine(ParCb,fMetaFrame);
		exit(vlItem);
	end;
	
	procedure TMeta.CloneFromParent;
	begin
		if iParent <> nil then iParent.CopyList(iVmtList,fMetaFrame);
	end;
	
	constructor TMeta.Create(ParParent : TMeta;const ParName : ansistring;ParType : TType;ParVmtType : TType);
	begin
		inherited Create;
		iRoutineName := ParName;
		iAccessAddress := TConstantVariable.Create(name_meta,ParType);
		iAccessAddress.fOwner := self;
		iAccessAddress.fDefAccess := AF_Public;
		SetText(ParName);
		iParent    := ParParent;
		iMetaFrame := TFrame.Create(true);
		if iParent <> nil then begin
			iMetaFrame.fShare := iParent.iMetaFrame;
			CloneFromParent;
		end;
		iVmtList.fVmtType := ParVmtType;
	end;
	
	function TMeta.SaveItem(ParStream : TObjectStream):boolean;
	begin
		if inherited SaveItem(PArStream) then exit(true);
		if iVmtList.SaveItem(ParStream)  then exit(true);
		if iMetaFrame.SaveItem(ParStream) then exit(true);
		if ParStream.WritePi(iParent)    then exit(true);
		if iAccessAddress.SaveItem(ParStream) then exit(true);
		exit(false);
	end;
	
	
	function TMeta.LoadItem(ParStream : TObjectStream):boolean;
	begin
		if inherited LoadITem(ParStream) then exit(True);
		if iVmtList.LoadItem(ParStream)  then exit(True);
		if CreateObject(ParStream,TStrAbelRoot(voMetaFrame)) <> STS_OK then exit(true);
		if ParStream.ReadPi(voParent)    then exit(true);
		if CreateObject(ParStream,TStrAbelRoot(voAccessAddress)) <> STS_OK then exit(True);
		exit(False);
	end;
	
	procedure TMeta.Commonsetup;
	begin
		iParent  := nil;
		iAccessAddress  := nil;
		iVmtList := TVmtList.Create(GetVmtOffsetBegin);
		inherited Commonsetup;
		iMetaFrame := nil;
		iIdentCode := IC_Meta;
		fDefAccess := AF_Protected;
	end;
	
	procedure TMeta.Clear;
	begin
		if iVmtLIst <> nil     then iVmtList.Destroy;
		if iMetaFrame <> nil   then iMetaFrame.destroy;
		if iAccessAddress<> nil then iAccessAddress.Destroy;
		inherited Clear;
	end;
	
	
	procedure TMeta.CreatePreDB(parCre : TCreator);
	begin
	end;
	
	function TMeta.CreateDB(ParCre : TCreator) : boolean;
	var   
                vlAsm       : TAsmCreator;
		vlName      : ansistring;
		vlNameLab   : longint;
		vlParentName : ansistring;
	begin
		fDefAccess := AF_Public;
		vlNameLab :=GetNewLabelNo;
		vlAsm := TAsmCreator(ParCre);
		GetLabelName(vlName);
		vlAsm.AddData(TAlignDef.Create(DAT_Code,4));
		vlAsm.AddData(TNamedLabelDef.Create(true,DAT_Code,vlName));
		if iParent <> nil then begin
			iParent.GetLabelName(vlParentName);
		end else begin
			vlParentName := '0';
		end;
		vlAsm.AddData(TAddressDef.Create(Dat_code,vlParentName));
		vlAsm.AddData(TGenLongDef.Create(dat_code,TLabelDataDef.Create(vlNameLab)));
		CreatePreDB(ParCre);
		iVmtList.CreateDB(ParCre);
		vlAsm.AddData(TLabelDef.Create(Dat_code,vlNameLab));
		vlAsm.AddData(TAsciiDef.Create(dat_code,iRoutineName));
		exit(false);
	end;
	
	
	procedure TMeta.Copylist(ParList : TVmtList;ParFrame : TFrame);
	begin
		iVmtList.CopyList(GetVmtOffsetBegin,ParList,ParFrame);
	end;
	
	function  TMeta.HasAbstracts:boolean;
	begin
		exit(iVmtList.HasAbstracts);
	end;
	
	{---( TVmtList )--------------------------------------------------}
	
	
	
	function  TVmtList.HasAbstracts:boolean;
	var
		vlCurrent : TVmtItem;
	begin
		vlCurrent := TVmtItem(fStart);
		while (vlCurrent <> nil) do begin
			if vlCurrent.HasAbstracts then exit(true);
			vlCurrent := TVmtItem(vlCurrent.fNxt);
		end;
		exit(false);
	end;
	
	function    TVmtList.FindMetaByRoutine(ParCB : TDefinition):TVmtItem;
	var
		vlCurrent : TVmtItem;
	begin
		vlCurrent := TVmtItem(fStart);
		while (vlCurrent <> nil) and (vlCurrent.fRoutine <> ParCB) do vlCurrent := TVmtItem(vlCurrent.fNxt);
		exit(vlCurrent);
	end;
	
	function TVmtList.ChangeVirtualRoutine(ParOther,ParNEw : TDefinition):TVmtItem;
	var  vlItem : TVmtItem;
	begin
		vlItem := FindMetaByRoutine(parOther);
		if vlItem <> nil then vlItem.fRoutine := ParNew;
		exit(vlItem);
	end;
	
	procedure TVmtList.AddVmtItem(ParItem :TVmtItem);
	var vlName : ansistring;
	begin
		ParItem.fRoutine.GetMangledName(vlName);
		insertAtTop(ParItem);
		iOffset := iOffset + GetAssemblerInfo.GetSystemSize;
	end;
	
	procedure TVmtList.CopyList(ParOffset : TOffset;ParList : TVmtList;ParFrame : TFrame);
	var vlCurrent : TVmtItem;
	begin
		ParLIst.fOffset := ParOffset;
		vlCurrent := TVmtItem(fStart);
		ParList.deleteall;
		while vlCurrent <> nil do begin
			ParList.AddVmtItem(vlCurrent.Clone(ParFrame));
			vlCurrent := TVmtItem(vlCurrent.fNxt);
		end;
	end;
	
	function  TVmtList.CreateDB(ParCre : TCreator):boolean;
	var vlCurrent :TVmtItem;
	begin
		vlCurrent := TVmtItem(fStart);
		while (vLCurrent <> nil) do begin
			if vlCurrent.CreateDB(ParCre) then exit(false);
			vlCurrent := TVmtItem(vlCurrent.fNxt);
		end;
		exit(False);
	end;
	
	function  TVmtLIst.SaveItem(ParStream : TObjectStream):boolean;
	begin
		if ParStream.Writelongint(iOffset) then exit(true);
		if ParStream.WritePi(iVmtType)     then exit(true);
		if inherited SaveItem(parStream)   then exit(true);
		exit(false);
	end;
	
	function TVmtList.LoadItem(ParStream : TObjectStream):boolean;
	begin
		if ParStream.Readlongint(voOffset) then exit(true);
		if ParStream.ReadPi(voVmtType)     then exit(true);
		if inherited LoadItem(ParStream)   then exit(true);
		exit(False);
	end;
	
	
	procedure TVmtList.Commonsetup;
	begin
		iVmtType := nil;
		inherited Commonsetup;
	end;
	
	function  TVmtList.AddVirtualRoutine(ParCB :TDefinition;ParFrame : TFrame):TVmtItem;
	var vlItem : TVmtItem;
	begin
		vlItem := TVmtItem.Create(ParCb,iOffset,ParFrame,iVmtType);
		AddVmtItem(vlItem);
		exit(vlItem);
	end;
	
	constructor TVmtList.Create(ParOffsetBegin : tsize);
	begin
		inherited Create;
		iOffset := ParOffsetBegin;{OFS_Vmt_Begin;}
	end;
	
	{---( TVmtItem )--------------------------------------------------}
	
	function    TVmtItem.Clone(ParFrame : TFrame) : TVmtItem;
	begin
		exit(TVmtItem.Create(iRoutine,iOffset,ParFrame,iVmtVar.fTYpe));
	end;
	
	function    TVmtItem.HasAbstracts : boolean;
	begin
		exit( iRoutine.IsOrHasAbstracts);
	end;
	
	constructor TVmtItem.Create(ParRoutine : TDefinition;ParOffset : TOFfset;ParMetaFrame : TFrame;ParType:TType);
	begin
		inherited Create;
		iRoutine := ParRoutine;
		iOffset    := ParOffset;
		iVmtVar    := TFrameVariable.Create('',ParMetaFrame,iOffset,ParType);
	end;
	
	procedure TVmtItem.Clear;
	begin
		inherited Clear;
		if iVmtVar <> nil then iVmtVar.Destroy;
	end;
	
	function TVmtItem.LoadItem(ParStream : TObjectStream) : boolean;
	begin
		if inherited LoadItem(ParStream)      then exit(true);
		if ParStream.ReadPi(voRoutine)      then exit(true);
		if CreateObject(ParStream,TStrAbelRoot(voVmtVar)) <> STS_OK  then exit(true);
		if ParStream.ReadLong(voOffset)    then exit(true);
		exit(false);
	end;
	
	function TVmtItem.SaveItem(ParStream : TObjectStream) : boolean;
	begin
		if inherited SaveItem(ParStream)   then exit(true);
		if ParStream.WritePi(iRoutine)   then exit(true);
		if iVmtVar.SaveItem(ParStream)     then exit(true);
		if ParStream.WriteLong(iOffset) then exit(true);
		
		exit(false);
	end;
	
	
	function  TVmtItem.CreateDB(ParCre : TCreator):boolean;
	begin
		iRoutine.AddVmtLabel(ParCre);
		exit(false);
	end;
	
	
	function TVmtItem.CreateReadNode(PArCre : TCreator;ParContext : TDefinition) : TNodeIdent;
	begin
		exit(iVmtVar.CreateReadNode(parCre,ParContext));
	end;
	
	function  TVmtItem.CreateMac(ParContext :TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
	begin
		exit(iVmtVar.CreateMac(ParContext,ParOption,ParCre));
	end;
	
	
end.
