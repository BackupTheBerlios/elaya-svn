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

unit memleak;
interface
uses sysutils,simplist,progutil;


procedure IncInits(const ParName : string);
procedure IncDones(const ParName : string);
procedure ListResult;

const Name_Length=20;
type TMemleak=class(TSMListItem)
	private
		voInits : cardinal;
		voDones : cardinal;
		voName  : pst;
	protected
		procedure Commonsetup; override;

	public
		procedure IncInits;
		procedure IncDones;
		procedure Print;
		constructor Create(const ParName : string);
	end;
	
	TMemList=class(TSMList)
		function GetClassByName(const ParName : string):TMemLeak;
	end;
	
implementation

var
	vgList :TMemList;
	
	
	
constructor TMemleak.Create(const ParName : string);
begin
	inherited Create;
	voName := InitStr(ParName);
end;

procedure ListResult;
var vlCurrent : TMemLeak;
begin
	{$ifdef MEMLEAK}
	vlCurrent := TMemLeak(vgList.fStart);
	while vlCurrent <> nil do begin
		vlCurrent.Print;
		vlCurrent := TMemLeak(vlCurrent.fNxt);
	end;
	{$endif}
end;

function TMemList.GetClassByName(const ParName : string):TMemLeak;
var vlCurrent : TMemLeak;
begin
	vlCurrent := TMemLeak(vgList.fStart);
	while vlCurrent <> nil do begin
		if ParName = vlCurrent.voName^ then exit(vlCurrent);
		vlCurrent := TMemLeak(vlCurrent.fNxt);
	end;
	exit(nil);
end;


procedure TMemLeak.Print;
var vlStr : string;
begin
	if voInits <> voDones then write('* ') else write('  ');
	writeln(voName^:40,' ',voInits:10,' ',voDones:10);
end;

procedure IncInits(const ParName : string);
var vlPtr : TMemLeak;
begin
	vlPtr := vgList.GetClassByName(ParName);
	if vlPtr = nil then vgList.InsertAt(nil,TMemLeak.Create(ParName))
	else vlPtr.IncInits;
end;

procedure IncDones(const ParName : string);
var vlPtr : TMemLeak;
	vxx:longint;
begin
	vlPtr := vgList.GetClassByName(ParName);
	if vlPtr = nil then  begin
		writeln('Dones without init for class :',ParName);
		vxx := 0;writeln(1/vxx);
		halt(1);
	end
	else vlPtr.IncDones;
end;


procedure TMemLeak.IncInits;
begin
	inc(voInits);
end;

procedure TMemLeak.IncDones;
begin
	inc(voDones);
end;

procedure TMemLeak.Commonsetup;
begin
	inherited Commonsetup;
	voInits := 1;
	voDones := 0;
end;

begin
	{$ifdef MEMLEAK}
	vgList := TMemList.Create;
	{$endif}
end.


