{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web : www.elaya.org

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

unit istabs;
interface
uses progutil,compbase,i386cons,procinst,asmdisp,stdobj,resource,elacons;

const
stab_Procedure = 36;
stab_Lineinfo  = 68;

type
	TStab=class(TInstruction)
	private
		voType : cardinal;
	protected
		property fType:Cardinal read voType write voType;
	public
		constructor Create(ParType : cardinal);
	end;
	
	TStabn=class(TStab)
	private
		voCode2,voCode3:cardinal;
		property fCode2 : cardinal read voCode2 write voCode2;
		property fCode3 : cardinal read voCode3 write voCode3;
	protected
		procedure PrintLastArg(ParDis:TAsmDisplay);virtual;
	public
		procedure Print(ParDis:TAsmDisplay);override;
		constructor Create(ParType,ParCode2,ParCode3:cardinal);
	end;
	
	TStabS=class(TStab)
	private
		voCode1 : cardinal;
		voCode2 : cardinal;
		voText  : TString;
		
	protected
		property  fCode1:cardinal read voCode1 write voCode1;
		property  fCode2:cardinal read voCode2 write voCode2;
		property  iText : TString read voText write voText;
		procedure PrintLastArg(ParDis : TAsmDisplay);virtual;
	public
		constructor create(ParType:cardinal;ParText:string;ParCode1,ParCode2:cardinal);
		procedure Print(ParDis:TAsmDisplay);override;
		procedure  clear;override;
	end;

	TProcedureStab=class(TStabs)
	private
		voMangledName         : TString;
		voParentName          : TString;
   		property iParentName  : TString read voParentName write voParentName;
		property fMangledName : TString read voMangledName;
		procedure SetMangledName(const ParName:String);
	protected
		procedure PrintLastArg(ParDis:TAsmDisplay);override;
		procedure Commonsetup;override;

	public
		procedure Clear;override;
		constructor Create(const ParName,ParParentName:string;const ParMangled:string;ParLine:cardinal);
	end;
	
	TLineNumberStab=class(Tstabn)
	private
		voRefLabel              : TLabelInst;
		voProcedureName         : TString;
		property fLabel         : TLabelInst read voRefLabel write voRefLabel;
		property fProcedureName : TString read voProcedureName;
		procedure SetProcedureName(const ParStr:string);
	protected
		procedure PrintLastArg(ParDis:TAsmDisplay);override;
	public
		procedure   Clear;override;
		procedure   Commonsetup;override;
		constructor Create(ParLineNo:Cardinal;ParLabel:TLabelInst;const PArProc:String);
	end;
	
	
	
implementation

{--( TStab )--------------------------------------------------}



constructor TStab.Create(ParType : cardinal);
begin
	inherited Create;
	fType := ParType;
end;


{--( Tstabn )--------------------------------------------------}

procedure Tstabn.PrintLastArg(ParDIs:TAsmDisplay);
begin
end;

constructor Tstabn.Create(ParType,ParCode2,ParCode3:cardinal);
begin
	inherited Create(ParType);
	fCode2 := ParCode2;
	fCode3 := ParCode3;
end;

procedure Tstabn.Print(ParDis:TAsmDisplay);
begin
	ParDis.Print([MN_Stabn,' ',fType,',',fCode2,',',fCOde3,',']);
	PrintLastArg(ParDis);
end;


{---( TLineNUmberStab )--------------------------------------------------------}

constructor TLineNumberStab.Create(ParLineNo:Cardinal;ParLabel:TLabelInst;const PArProc:String);
begin
	inherited Create(Stab_LineInfo,0,ParLineNo+1);
	fLabel         := ParLAbel;
	SetProcedureName(ParProc);
end;


procedure TLineNumberStab.Clear;
begin
	inherited Clear;
	if fProcedureName <> nil then fProcedureName.destroy;
end;


procedure TLineNumberStab.PrintLastArg(ParDis:TAsmDisplay);
begin
	if fLabel <> nil then ParDis.WritePst(fLabel.fLabelName);
	ParDis.Write('-');
	ParDis.WritePst(fProcedureName);
end;

procedure TLineNumberStab.Commonsetup;
begin
	inherited commonsetup;
	iIdentCode      := (IC_LineNumberStab);
	voProcedureName := nil;
end;

procedure TLineNumberStab.SetProcedureName(const ParStr:string);
begin
	if fProcedureName <> nil then fProcedureName.destroy;
	voProcedureName := TString.Create(ParStr);
end;



{---( TStabS )--------------------------------------------------------------------}

constructor TStabs.create(ParType:cardinal;ParText:string;ParCode1,ParCode2:cardinal);
begin
	inherited Create(ParType);
	iText := TString.Create(ParText);
	fCode1 := ParCode1;
	fCode2 := ParCode2;
end;

procedure TStabs.Clear;
begin
	inherited Clear;
	if iText <> nil then iText.Destroy;
end;

procedure   TStabs.PrintLastArg(ParDis:TAsmDisplay);
begin
end;

procedure   TStabs.Print(ParDis:TAsmDisplay);
begin
	ParDis.Write(MN_Stabs);
	ParDis.Write(' "');
	ParDis.WritePSt(iText);
	ParDis.Write('",');
	ParDIs.WriteInt(fType);
	ParDis.Write(',');
	ParDis.WriteInt(fCode1);
	ParDis.Write(',');
	ParDIs.WriteInt(fCode2);
	ParDis.Write(',');
	PrintLastArg(ParDis);
end;


{---( TProcedureStab )---------------------------------------------------}

procedure TProcedureStab.SetMangledName(const ParName:String);
begin
	if fMangledName <> nil then fMangledName.Destroy;
	voMangledName := TString.Create(ParName);
end;

procedure TProcedureStab.Clear;
begin
	inherited Clear;
	if FMangledName <> nil then fMangledName.Destroy;
end;

procedure TProcedureStab.commonsetup;
begin
	inherited Commonsetup;
	iIdentCode    := (ic_procedureStab);
	voMangledName := nil;
end;

constructor TProcedureStab.Create(const ParName,ParParentName,ParMangled:string;ParLine:cardinal);
var vlExtra : string;
begin

	if length(ParParentName) = 0 then begin
		vlExtra :=','+ParName;
	end else begin
		EmptyString(vlExtra);
	end;
	if length(ParParentName) <> 0 then vlExtra := vlExtra +','+ ParParentName;
	inherited Create(stab_procedure,ParName+':F1'+vlExtra,0,ParLine);
	SetMangledName(ParMangled);
end;

procedure  TProcedureStab.PrintLastArg(ParDis:TAsmDisplay);
begin
	ParDis.WritePst(fMangledName);
end;

end.
