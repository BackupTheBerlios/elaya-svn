{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.

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

unit extern;
interface
uses stdobj,streams,compbase,progutil,DSbLsDef,ddefinit,asmcreat,asmdata,elacons,display,DIdentLs;

type   TExternalObject=class(TDefinition)
	private
		voObject:TDefinition;
		property iObject : TDefinition read voObject write voObject;
	protected
		procedure   Commonsetup;override;

	public
		property fObject : TDefinition read voObject;

		constructor Create(ParName:TString;ParObject:TDefinition);
		function    SaveItem(ParStr:TObjectStream):boolean;override;
		function    LoadITem(ParStr:TObjectStream):boolean;override;
		procedure   Print(ParDIs:TDisplay);override;
		
		
	end;
	
	TExternalLibraryObject=class(TExternalObject)
		procedure   Print(parDis:TDisplay);override;
	end;
	
	TExternalLibraryObjectWindows=class(TExternalLibraryObject)
	protected
		procedure Commonsetup;override;
	public
		function  CreateDB(ParCre:TCreator):boolean;override;
	end;
	
	
	TExternalObjectFileObject=class(TExternalObject)
	protected
		procedure  Commonsetup;override;
	public
		procedure  Print(ParDis:TDisplay);override;
		function   CreateDB(ParCre:TCreator):boolean;override;
	end;
	
	
	TExternalInterface=class(TSubListDef)
	private
		voInterfaces:TIdentList;
		property iInterfaces : TIDentList read voInterfaces write voInterfaces;
	protected
		procedure CommonSetup;override;
		procedure Clear;override;

	public
		property fInterfaces : TIDentList read voInterfaces;
		constructor Create(ParName : TString);
		function  CreateDb(ParCre:TCreator):boolean;override;
		function  AddInterface(ParName : Tstring;ParProc : TDefinition): TExternalObject;virtual;
		function  SaveItem(ParStr:TObjectStream):boolean;override;
		function  LoadItem(ParStr:TObjectStream):boolean;override;
		procedure print(ParDis:TDisplay);override;
		function  MustNameAddAsOwner:boolean;override;
	end;
	
	TExternalInterfaceClass=class of TExternalInterface;
	
	TExternalObjectFileInterface=class(TExternalInterface)
	protected
		procedure Commonsetup;override;

	public
		function  AddInterface(ParName : Tstring;ParProc : TDefinition):TExternalObject;override;
	end;
	
	TExternalLibraryInterfaceWindows =class(TExternalInterface)
	protected
		procedure Commonsetup;override;
	public
		function CreateDb(ParCre:TCreator):boolean;override;
		function  AddInterface(ParName : TString;ParProc : TDefinition):TExternalObject;override;
	end;
	
implementation
{---( TExternalObject )---------------------------------------------------}

constructor TExternalObject.Create(ParName:TString;ParObject:TDefinition);
begin
	inherited Create;
	iText := ParName;
	iObject := ParObject;
	iObject.SetAllWaysSave;
end;

procedure TExternalObject.Commonsetup;
begin
	inherited Commonsetup;
	iObject := nil;
	iDefinitionModes := [DM_CPublic,DM_Interface];{Hack}
	SetAllwaysSave;
end;


function  TExternalObject.SaveItem(ParStr:TObjectStream):boolean;
begin
	SaveItem := true;
	if inherited SaveItem(ParStr) then exit;
	if ParStr.WritePI(iObject) then exit;
	SaveItem := false;
end;

function  TExternalObject.LoadItem(ParStr:TObjectStream):boolean;
begin
	LoadItem := true;
	if inherited LoadItem(parStr) then exit;
	if ParStr.ReadPI(TStrAbelRoot(voObject))   then exit;
	LoadItem := false;
end;


procedure TExternalObject.Print(ParDis:TDisplay);
begin
	if iObject <> nil then iObject.PrintName(ParDis)
	else ParDis.Write('<unkown>');
	ParDis.Write(',External interface :');
	PrintName(ParDis);
end;


{---( TExternalObjectFileObject )-----------------------------------------}

procedure TExternalObjectFileObject.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_ExternObjFile);
end;

procedure TExternalObjectFileObject.Print(ParDis:TDisplay);
begin
	ParDis.Write('class File class:');
	inherited Print(ParDis);
end;



function TExternalObjectFileObject.CreateDb(ParCre:TCreator):boolean;
var
	vlName:String;
	vlExtName:String;
begin
	GetTextStr(vlExtName);
	fObject.GetMangledName(vlName);
	TAsmCreator(PArCre).AddData(TExternalCode.Create(DAT_Text,vlExtName,vlName,IsAsmGlobal));
	exit( false);
end;


{---( TExternalLibraryObjectWindows )------------------------------------}

procedure TExternalLibraryObjectWIndows.COmmonsetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_ExternLibFileWindows);
end;


function TExternalLibraryObjectWindows.CreateDb(ParCre:TCreator):boolean;
var  vlName:string;
	vlNameLabel:longint;
	vlAdrLabel:Longint;
	vlMangName:String;
	vlLabel:string;
begin
	GetTextStr(vlName);
	fObject.GetMangledName(vlMangName);
	vlNameLabel := getNewLabelNo;
	vlAdrLabel  := GetNewLabelNo;
	TAsmCreator(ParCre).AddData(TLabelDef.Create(DAT_Jump_tables,vlAdrLabel));
	TAsmCreator(PArCre).AddData(TRvaDef.Create(DAT_jump_tables,(TLabelDataDef.Create(vlNameLabel))));
	TAsmCreator(PArCre).AddData(TRvaDef.Create(DAT_Ext_names_Index,(TLabelDataDef.Create(vlNameLabel))));
	TAsmCreator(ParCre).AddData(TLabelDef.Create(DAT_External_Names,vlNameLabel));
	TAsmCreator(ParCre).AddData(TShortDef.Create(DAT_External_Names,0));
	TAsmCreator(ParCre).AddData(TAsciizDef.Create(DAT_External_Names,vlName));
	str(vlAdrLabel,vlLabel);
	vlLabel := '*.L'+vlLabel;
	TAsmCreator(ParCre).AddData(TExternalCode.Create(DAT_Text,vlLabel,vlMangName,IsAsmGlobal));
	exit(false);
end;

{---( TExternalLibraryObject )--------------------------------------------}



procedure TExternalLibraryObject.Print(ParDis:TDisplay);
begin
	ParDis.write('Library class :');
	inherited Print(ParDis);
end;

{---( TExternalInterface )------------------------------------------------}


constructor TExternalInterface.Create(ParName : TString);
begin
	inherited Create;
	iText := ParName;
end;

function    TExternalInterface.MustNameAddAsOwner:boolean;
begin
	exit(false);
end;

procedure  TExternalInterface.Commonsetup;
begin
	inherited Commonsetup;
	iInterfaces      := TIdentList.Create;
	iParts.fGlobal := true;
end;

procedure  TExternalInterface.Clear;
begin
	inherited Clear;
	if iInterfaces <> nil then iInterfaces.destroy;
end;

function TExternalInterface.CreateDb(ParCre:TCreator):boolean;
begin
	CreateDb := true;
	if iParts.CreateDB(ParCre)    then exit;
	if fInterfaces.CreateDb(ParCre) then exit;
	CreateDb := false;
end;



function  TExternalInterface.AddInterface(ParName : TString;ParProc : TDefinition): TExternalObject;
begin
	exit(TExternalObject(fInterfaces.insertAtTop(TExternalObject.Create(ParName,ParProc))));
end;



function  TExternalInterface.SaveItem(ParStr:TObjectStream):boolean;
begin
	SaveItem :=true;
	if inherited SaveItem(ParStr)      then exit;
	if fInterfaces.SaveItem(ParStr) then exit;
	SaveItem := false;
end;

function  TexternalInterface.LoadItem(ParStr:TObjectStream):boolean;
begin
	LoadItem := true;
	if inherited LoadItem(ParStr)      then exit;
	if fInterfaces.LoadItem(ParStr) then exit;
	LoadItem := false;
end;

procedure TExternalInterface.Print(ParDis:TDisplay);
begin
	PrintName(ParDis);
	ParDis.Nl;
	ParDis.SetLeftMargin(3);
	ParDis.WriteNl('Interfaced objects:');
	iParts.Print(ParDis);
	ParDis.WriteNl('Interfaces :');
	fInterfaces.Print(ParDis);
	ParDis.SetLeftMargin(-3);
end;



{---(   TExternalLibraryInterfaceWindows )-------------------------------}

procedure TExternalLibraryInterfaceWIndows.COmmonsetup;
begin
	inherited commonsetup;
	iIdentCode := (IC_ExternLibIntWIndows);
end;

function TExternalLibraryInterfaceWindows.CreateDb(ParCre:TCreator):boolean;
var vlIndLabel  : longint;
	vlJumpLabel : Longint;
	vlLibName   : Longint;
	vlLabeL     : TLabelDef;
	vlName      : string;
begin
	GetTextStr(vlName);
	vlIndLabel := GetNewLabelNo;
	vlJumpLabel := GetNewLabelNo;
	vlLibname := GetNewLabelNo;
	TAsmCreator(ParCre).AddData((TRvaDef.Create(DAT_Root_INdex,(TLabelDataDef.Create(vlJumpLabel)))));
	TAsmCreator(PArcre).AddData((TLongDef.Create(DAT_Root_Index,0)));
	TAsmCreator(PArcre).AddData((TLongDef.Create(DAT_Root_Index,0)));
	TAsmCreator(ParCre).AddData((TRvaDef.Create(DAT_Root_Index,(TLabelDataDef.Create(vlLibName)))));
	TAsmCreator(ParCre).AddData((TRvaDef.Create(DAT_Root_INdex,(TLabelDataDef.Create(vlJumpLabel)))));
	TAsmCreator(ParCre).AddData((TLabelDef.Create(DAT_Lib_names,vlLibName)));
	TAsmCreator(ParCre).AddData((TAsciizDef.Create(DAT_Lib_Names,vlname)));
	vlLabel  := (TLabelDef.Create(DAT_Ext_Names_Index,vlIndLabel));
	TAsmCreator(ParCre).AddData(vlLabel);
	TAsmCreator(ParCre).AddData((TLabelDef.Create(DAT_Jump_tables,vlJumpLabel)));
	inherited CreateDb(ParCre);
	TAsmCreator(ParCre).AddData((TLongDef.Create(DAT_ext_names_index,0)));
	TAsmCreator(ParCre).AddData((TLongDef.Create(DAT_jump_tables,0)));
	CreateDb := false;
end;

function  TExternalLibraryInterfaceWindows.AddInterface(ParName : TString;ParProc : TDefinition): TExternalObject;
begin
	exit(TExternalObject(fInterfaces.InsertAtTop(TExternalLibraryObjectWindows.Create(ParName,ParProc)))
	);
end;



{---( TExternalObjectFileInterface )-------------------------------}



procedure TExternalObjectFileInterface.COmmonsetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_ExternObjInt);
end;

function  TExternalObjectFileInterface.AddInterface(ParName :Tstring;ParProc : TDefinition): TExternalObject;
begin
	exit(TExternalObject(
	fInterfaces.InsertAtTop(TExternalObjectFileObject.Create(ParName,ParProc)))
	);
end;


end.
