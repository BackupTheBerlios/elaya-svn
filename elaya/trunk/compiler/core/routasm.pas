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

unit routasm;
interface
uses asmdisp,elacfg,confval,objlist, progutil,elacons,stdobj,simplist;
type

	TInstructionList=class(TSMList)
		procedure print(ParDis:TAsmDisplay);
	end;


	TRoutineAsm=class(TRoot)
		
	private
		voShortName     : TString;
		voProcedureName : TString;
		voParentName    : TString;
		voFirstLine     : cardinal;
		voObjectList    : TObjectLIst;
		voInstructionList : TInstructionList;
		voIsPublic        : boolean;
		property iFirstLine       : cardinal         read voFirstLine       write voFirstLine;
		property iObjectList      : TObjectList      read voObjectList      write voObjectList;
		property iShortName       : TString          read voShortName       write voShortName;
		property iParentName      : TString          read voParentName      write voParentName;
		property iProcedureName   : TString          read voProcedureName   write voProcedureName;
		property iInstructionList : TInstructionList read voInstructionList write voInstructionList;
		property iIsPublic        : boolean          read voIsPublic        write voIsPublic;
        procedure procbegin;
    protected
		procedure  CommonSetup;override;
		procedure  clear;override;

	public
		property   fFirstLine       : cardinal read voFirstLine  write voFirstLine;
		property   fProcedureName   : TString  read voProcedureName;
		procedure  AddObject(ParItem : TRoot);
		function   GetLastInstruction : TSMListItem;
		function   GetFirstInstruction : TSMListItem;
		procedure  AddInstructionAt(ParAt,ParItem : TSMListItem);
		procedure  Print(ParDis : TAsmDisplay);
		constructor Create(const ParShortName,ParProcedureName,ParParentName : ansistring;ParFirstLine : cardinal;ParIsPublic:boolean);
		procedure  PrintPReFrame(ParDis:TAsmDisplay);
	end;
	
implementation

uses asminfo,procinst,resource,istabs;

{----( TInstructionList )----------------------------------------------}


procedure TInstructionList.print(ParDis:TAsmDisplay);
var vlCurrent : TInstruction;
begin
	ParDis.SetLeftMargin(8);
	vlCurrent := TInstruction(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.Print(ParDis);
		ParDis.nl;
		vlCurrent := TInstruction(vlCurrent.fNxt);
	end;
	PArDis.SetLEftMargin(-8);
	ParDis.nl;
	ParDis.nl;
end;


{----( TRoutineAsm )-----------------------------------------------------------}
procedure  TRoutineAsm.AddInstructionAt(ParAt,ParItem : TSMListItem);
begin
	iInstructionList.InsertAt(ParAt,ParITem);
end;


procedure TRoutineAsm.PrintPReFrame(ParDis:TAsmDisplay);
var vlRemark : char;
  	 vlName   : ansistring;
begin
	vlRemark := GetAssemblerInfo.GetRemarkChar;
	ParDis.Write(vlRemark);
	ParDis.WriteRep(79,'-');
	ParDis.nl;
	ParDis.Print([vlRemark,'Procedure :',iProcedureName]);
	ParDis.nl;
	ParDis.Write(vlRemark);
	ParDis.WriteRep(79,'-');
	ParDis.Nl;
	ParDis.Nl;
	ParDis.Print([iProcedureName,':']);
	ParDis.nl;
	ParDis.SetLEftMargin(SIZE_AsmLeftMargin);
	if iIsPublic then begin
		iProcedureName.GetString(vlName);
		ParDis.Write(GetAssemblerInfo.GetGlobalText(vlName));
		ParDis.Nl;
	end;
	ParDis.SetLeftMargin(-Size_AsmLeftMargin);
	ParDis.nl;
end;



procedure   TRoutineAsm.procbegin;
var vlName  : ansistring;
    vlShort : ansistring;
    vlParent:ansistring;
	vlLabel : ansistring;
begin
	iProcedureName.GetString(VlName);
	if GetConfig.fIsElfTarget then begin
		vlLabel := '.Lend';
		GetAssemblerInfo.AddMangling(vlLabel,vlName);
		AddInstructionAt(GetLastInstruction,TSizeInstruction.Create(vlName,vlName+','+vlLabel + '-' + vlName));
	end;
	if GetConfigValues.fGenerateDebug then begin

		iShortName.GetString(VlShort);
		if iParentName <> nil then begin
			iParentName.GetString(vlParent);
		end else begin
			EmptyString(vlParent);
		end;
		AddInstructionAt(GetLastInstruction,TProcedureStab.Create(vlShort,vlParent,vlName,iFirstLine));

	end;

end;

procedure TRoutineAsm.Print(ParDis : TAsmDisplay);
begin
	PrintPreFrame(ParDis);
	iInstructionList.Print(ParDis);
	ParDIs.nl;
end;

function  TRoutineAsm.GetLastInstruction : TSMListItem;
begin
	exit(iInstructionList.fTop);
end;

function  TRoutineAsm.GetFirstInstruction : TSMListItem;
begin
	exit(iInstructionList.fStart);
end;

constructor TROutineAsm.Create(const ParShortName,ParProcedureName,ParParentName : ansistring;ParFirstLine : cardinal;ParIsPublic:boolean);
begin
	iProcedureName := TString.Create(ParProcedureName);
	iShortName     := TString.Create(ParShortName);
	if length(ParParentName) > 0 then begin
		iParentName    := TString.Create(ParParentName);
	end else begin
		iParentName := nil;
	end;
	iFirstLIne     := ParFirstLine;
	iIsPublic      := ParIsPublic;
	inherited Create;
	procbegin;
end;

procedure TRoutineAsm.CommonSetup;
begin
	inherited CommonSetup;
	iObjectList    := TObjectList.Create;
	iInstructionList := TInstructionList.Create;
end;

procedure  TRoutineAsm.AddObject(ParItem : TRoot);
begin
	iObjectList.AddObject(ParItem);
end;


procedure TRoutineAsm.Clear;
begin
	inherited Clear;
	if iShortName     <> nil then iShortName.Destroy;
	if iProcedureNAme <> nil then iProcedureName.Destroy;
	if iObjectList    <> nil then iObjectList.Destroy;
	if iParentName   <> nil then iParentName.Destroy;
	if iInstructionList <> nil then iInstructionList.Destroy;
end;


end.
