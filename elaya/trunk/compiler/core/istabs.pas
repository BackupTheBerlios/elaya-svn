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
uses progutil,i386cons,procinst,asmdisp,stdobj,resource,elacons;

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
		voText  : AnsiString;
		
	protected
		property  fCode1:cardinal read voCode1 write voCode1;
		property  fCode2:cardinal read voCode2 write voCode2;
		property  iText :AnsiString read voText write voText;
		procedure PrintLastArg(ParDis : TAsmDisplay);virtual;

	public
		constructor create(ParType:cardinal;ParText:ansistring;ParCode1,ParCode2:cardinal);
		procedure Print(ParDis:TAsmDisplay);override;
	end;

	TProcedureStab=class(TStabs)
	private
		voMangledName         : AnsiString;
		voParentName          : AnsiString;
   		property iParentName  : AnsiString read voParentName write voParentName;
		property iMangledName : AnsiString read voMangledName write voMangledName;
	protected
		procedure PrintLastArg(ParDis:TAsmDisplay);override;
		procedure Commonsetup;override;

	public
		constructor Create(const ParName,ParParentName:ansistring;const ParMangled:ansistring;ParLine:cardinal);
	end;
	
	TLineNumberStab=class(Tstabn)
	private
		voRefLabel              : TLabelInst;
		voProcedureName         : AnsiString;
		property iLabel         : TLabelInst read voRefLabel write voRefLabel;
		property iProcedureName : AnsiString read voProcedureName write voProcedureName;

	protected
		procedure PrintLastArg(ParDis:TAsmDisplay);override;
		procedure   Commonsetup;override;

	public
		constructor Create(ParLineNo:Cardinal;ParLabel:TLabelInst;const PArProc:ansistring);
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

constructor TLineNumberStab.Create(ParLineNo:Cardinal;ParLabel:TLabelInst;const PArProc:ansistring);
begin
	inherited Create(Stab_LineInfo,0,ParLineNo+1);
	iLabel         := ParLAbel;
	iProcedureName := ParProc;
end;



procedure TLineNumberStab.PrintLastArg(ParDis:TAsmDisplay);
begin
	if iLabel <> nil then ParDis.Write(iLabel.fLabelName);
	ParDis.Write('-');
	ParDis.Write(iProcedureName);
end;

procedure TLineNumberStab.Commonsetup;
begin
	inherited commonsetup;
	iIdentCode      := IC_LineNumberStab;
end;

{---( TStabS )--------------------------------------------------------------------}

constructor TStabs.create(ParType:cardinal;ParText:ansistring;ParCode1,ParCode2:cardinal);
begin
	inherited Create(ParType);
	iText := ParText;
	fCode1 := ParCode1;
	fCode2 := ParCode2;
end;


procedure   TStabs.PrintLastArg(ParDis:TAsmDisplay);
begin
end;

procedure   TStabs.Print(ParDis:TAsmDisplay);
begin
	ParDis.Write(MN_Stabs);
	ParDis.Write(' "');
	ParDis.WriteString(iText);
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


procedure TProcedureStab.commonsetup;
begin
	inherited Commonsetup;
	iIdentCode    := (ic_procedureStab);
end;

constructor TProcedureStab.Create(const ParName,ParParentName,ParMangled:ansistring;ParLine:cardinal);
var 
	vlExtra : ansistring;
begin

	if length(ParParentName) = 0 then begin
		vlExtra :=','+ParName;
	end else begin
		EmptyString(vlExtra);
	end;
	if length(ParParentName) <> 0 then vlExtra := vlExtra +','+ ParParentName;
	inherited Create(stab_procedure,ParName+':F1'+vlExtra,0,ParLine);
	iMangledName := ParMangled;
end;

procedure  TProcedureStab.PrintLastArg(ParDis:TAsmDisplay);
begin
	ParDis.Write(iMangledName);
end;

end.
