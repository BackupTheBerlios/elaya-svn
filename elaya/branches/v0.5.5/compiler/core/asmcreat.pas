{
Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
web: www.elaya.org

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


unit Asmcreat;
interface
uses AsmDisp,i386cons,display,progutil,compbase,linklist,stdobj,elatypes,node,
elacons,error,idlist,asmdata,elacfg,extAppl,cmp_base,DIdentLs,confval,cmp_type  ;
type
	
	TAsmCreator=class(TCreator)
	private
		voName  : TString;
		voLis   : TFileDisplay;
		voPoc   : TFileDIsplay;
		voAsm   : TAsmDisplay;
		voSecCre: TSecCreator;
		voData  : TAsmDefinitionList;
		voAlign : TSize;
		voLink  : boolean;
		
		property  iName : TString            read voName  write voName;
		property  iAsm  : TAsmDisplay        read voAsm   write voAsm;
		property  iLis  : TFileDIsplay       read voLis   write voLis;
		property  iPoc  : TFileDisplay       read voPoc   write voPoc;
		property  iData : TAsmDefinitionList read voData  write voData;
		property  iLink : boolean            read voLink  write voLink;
		property  iAlign: TSize		         read voAlign write voAlign;
		property  iSecCre  : TSecCreator        read voSecCre   write voSecCre;
	protected
		procedure   Clear;override;
		procedure   CommonSetup;override;

	public
		
		property  fLis   : TFileDisplay read voLis;
		property  fAsm   : TAsmDisplay  read voAsm;
		property  fName  : TString      read voName;
		property  fSecCre   : TSecCreator  read voSecCre;
		property  fPoc   : TFileDisplay read voPoc;
		procedure   GetNameStr(var ParName:String);
		function    CreateOutput(const Parname:string):boolean;
		constructor Create(ParLink : boolean;const ParName : string;ParCompiler : TCompiler_Base;var ParError:boolean);
		procedure   ChangeDataAlign(ParAll : TSize);
		procedure   PrintSection(ParDisplay : TAsmDisplay;const ParTitle : string;ParSecType : TDatType);
		function    ProduceAsm(ParList : TIdentList) : TErrorType;
		procedure   AddData(ParData : TAssemDef);
		function    RunAsm : TErrorType;
	end;
	
implementation

uses asminfo;

{------( TAsmcreator )--------------------------------------------------}


procedure   TAsmCreator.GetNameStr(var ParName : String);
begin
	iName.GetString(ParName);
end;


function TAsmCreator.RunAsm:TErrorType;
var vlAsmName : string;
	vlObjOut  : string;
	vlAsm     : TCompAppl;
	vlLdw     : TLdwAppl;
	vlErr     : TErrorType;
begin
	vlErr := Err_No_Error;
	if GetConfigValues.fRunAssembler then begin
		Verbose(VRB_what_I_do,'Starting assembler');
		GetNameStr(vlAsmName);
		GetConfig.GetOutputObjectPath(vlObjOut);
		vlAsm := GetAssemblerInfo.CreateAsmExec(vlAsmName,vlObjOut);
		if vlAsm.Execute<> ERR_No_Error then vlErr := Err_Assembler_Failed;
		vlAsm.Destroy;
		if (iLink) and (vlErr = Err_No_Error) then begin
			Verbose(VRB_What_I_Do,'Starting linker');
			vlLdw := (TLdwAppl.Create(vlAsmname,vlObjOut));
			if vlLdw.Execute <> Err_No_Error then vLErr := Err_Linker_Failed;
			vlLdw.Destroy;
		end;
	end;
	exit(vlErr);
end;

procedure TAsmCreator.ChangeDataAlign(ParAll : TSize);
var vlAlDef :TAlignDef;
begin
	if ParAll <> iAlign then begin
		iAlign  := ParAll;
		vlAlDef := TAlignDef.Create(DAT_Variables,iAlign);
		AddData(vlAlDef);
		iAlign  := ParAll;
	end;
end;


procedure   TAsmCreator.CommonSetup;
begin
	inherited commonsetup;
	iSecCre:= TSecCreator.Create(iCompiler);
	iData  := TAsmDefinitionList.Create;
	iAlign := 0;
end;

procedure  TAsmcreator.AddData(ParData:TAssemDef);
begin
	iData.AddData(PArData);
end;

constructor TAsmCreator.Create(ParLink:boolean;const ParName:string;ParCompiler:TCompiler_Base;var ParError:boolean);
var vlName : String;
begin
	vlName := ParName;
	LowerStr(vlname);
	iName := TString.Create(vlName);
	ParError := CreateOutput(vlName);
	iLink := ParLink;
	inherited Create(ParCompiler);
end;

procedure TAsmCreator.clear;
begin
	inherited clear;
	if iAsm  <> nil  then iAsm.Destroy;
	if iLis  <> nil  then iLis.Destroy;
	if iPoc  <> nil  then iPoc.destroy;
	if iData <> nil  then iData.Destroy;
	if iName <> nil  then iName.Destroy;
	if iSecCre <> nil then iSecCre.Destroy;
end;


function TAsmCreator.CreateOutput(const ParName : String):boolean;
var vlError : TErrorType;
	vlFileName : string;
begin
	iLis := nil;
	iPoc := nil;
	if GetConfigValues.fNodeListing then begin
		vlFileName := ParName + CNF_Lis_Ext;
		iLis := TFileDisplay.Create(vlFileName,vlError);
		if vlError <> 0 then begin
			AddError(Err_Cant_Open_File,0,0,0,vlFileName);
			exit(true);
		end;
		vlFileName := ParName + CNF_Poc_Ext;
		iPoc := TFileDisplay.Create(vlFIleName,vlError);
		if vlError <> 0 then begin
			AddError(Err_Cant_Open_File,0,0,0,vlFileName);
			exit(true);
		end;
	end;
	vlFileName := ParName + CNF_Assem_Ext;
	iAsm := GetAssemblerInfo.CreateAsmDisplay(vlFileName,vlError);
	if vlError <> 0 then begin
		AddError(Err_Cant_Open_File,0,0,0,vlFileName);
		exit(true);
	end;
	exit(false);
end;

procedure TAsmCreator.PrintSection(ParDisplay:TAsmDisplay;const ParTitle:string;ParSecType:TDatType);
begin
	ParDisplay.Nl;
	if length(ParTitle) <> 0 then ParDisplay.Write(GetAssemblerInfo.GetSectionText(ParTitle));
	ParDisplay.nl;
	ParDisplay.nl;
	iData.Print(ParDisplay,ParSecType);
end;


function TAsmCreator.ProduceAsm(ParList:TIdentList) : TErrorType;
var vlName : String;
begin
	if GetConfigValues.fGenerateDebug then begin
		GetNameStr(vlName);
		lowerStr(vlName);
		iAsm.Print(['.stabs "',vlname,cnf_Source_Ext,'",100,0,0,Ltext0']);
		iAsm.nl;
		iAsm.WriteNl('Ltext0:');
		iAsm.WriteNl('.stabd 72,0,1');
		iAsm.WriteNl('.stabs "void:t1=1;",128,0,47,0');
	end;
	iAsm.WriteNl(GetAssemblerInfo.GetSectionText(MN_Text));
	iAsm.Nl;
	ParList.CreateDb(self); {TODO remove ParList outside}
	iSecCre.ProduceStringConstantSection(self);
	if not fCompiler.Successful then exit(Err_No_Error); {Hack}
	iData.Print(iAsm,DAT_Text);
	PrintSection(iAsm,MN_None,DAT_Code);
	PrintSection(iAsm,MN_BSS,DAT_Variables);
	PrintSection(iAsm,MN_Data,DAT_Data);
	PrintSection(iAsm,MN_IData2,DAT_Root_Index);
	PrintSection(iAsm,MN_IData4,DAT_ext_names_Index);
	PrintSection(iAsm,MN_IData5,DAT_jump_tables);
	PrintSection(iAsm,MN_IData6,DAT_External_Names);
	PrintSection(iAsm,MN_IData7,DAT_Lib_Names);
	iAsm.nl;
	iAsm.WriteNl('#String list');

	iAsm.Destroy;
	iAsm := nil;
	exit(runasm);
	
end;

end.
