{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web   : www.elaya.org
Email : iddekingej@lycos.com

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

unit asmdisp;

interface
uses largenum,display,elatypes;

type
	TAsmDisplay=class(TFileDisplay)
	public
		
		procedure AsPrintNumber(ParSize :TSIze;ParNumber : TNumber); virtual;
		procedure AsPrintVar(ParPublic:boolean;const ParName : string;ParSize : TSize);virtual;
		procedure AsPrintAlign(ParAlign:TSize);virtual;
		procedure AsPrintAscii(const ParText :string);virtual;
		procedure AsPrintAsciiz(const ParText :string);virtual;
		procedure AsPrintMemVar(ParSize : TSize;const ParName : string);virtual;
		procedure AsPrintOffset(const ParName : string;ParOffset : TOffset);virtual;
		procedure AsPrintMemIndex(const ParRegister,ParVar: string;ParIndex : TOffset;ParSize:TSize);virtual;
		procedure AsPrintLabel(ParNum : cardinal);virtual;
	end;
	
implementation


{---( TAsmDisplay )--------------------------------------------------------}

procedure TAsmDisplay.AsPrintLabel(ParNum : cardinal);
begin
	Print(['<Abstract Label :',ParNum,'>']);
end;


procedure TAsmDisplay.AsPrintMemIndex(const ParRegister,ParVar: string;ParIndex : TOffset;ParSize:TSize);
begin
	Print(['<Abstract Mem Index:[ ',ParVar,'+',ParRegister,'+',ParIndex ,']']);
end;

procedure TAsmDisplay.AsPrintMemVar(ParSize : TSize;const ParName : string);
begin
	Print(['<Abstract Print mem var',ParName,'>']);
end;

procedure TAsmdisplay.AsPrintOffset(const ParName : string;ParOffset : TOffset);
begin
	Print(['<abstract offset to ',ParName,'>']);
end;

procedure TAsmDisplay.AsPrintAscii(const ParText : string);
begin
	print(['<Abstract print string :',ParText,'>']);
end;

procedure TAsmDisplay.AsPrintAsciiz(const ParText : string);
begin
	print(['<Abstract print stringz :',ParText,'>']);
end;

procedure TAsmDisplay.AsPrintAlign(ParAlign : TSize);
begin
	Write('<abstract align>');
end;

procedure TAsmDisplay.AsPrintNumber(ParSize : TSize;ParNumber : TNumber);
var vlStr : string;
begin
	LargeToString(ParNumber,vlStr);
	Write(vlStr);
end;

procedure TAsmDisplay.AsPrintVar(ParPublic:boolean;const ParName : string;ParSize : TSize);
begin
	Print(['<abstract var def:',ParName,'>']);
end;


end.
