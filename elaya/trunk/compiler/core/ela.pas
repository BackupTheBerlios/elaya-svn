{    Elaya, the compiler for the elasya language
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

program ela;

USES  sysutils,stdobj,confval,elacfg,ela_comp,compbase,elacons,progutil,options{$ifdef memleak},memleak{$endif}
;
var
	vgSourceName  : STRING;
	vgCompiler    : TElaCompiler;
	vgSuccess	: boolean;

begin
	writeln('Elaya Compiler   Version:',VER_NO);
	writeln(ver_date);
	writeln(ver_Head);
	writeln('Elaya comes with ABSOLUTELY NO WARENTY');
	writeln('This is free software, under GPL license V 2');
	InitOptions;
	GetConfigValues.GetInputFileStr(vgSourceName);
	verbose(vrb_what_I_do,'Initialising compiler');
	vgSuccess :=false;
	vgCompiler := TElaCompiler.Create(vgSourceName);
	verbose(vrb_what_I_do,'Compileing');
	vgCompiler.Compile;
	vgSuccess := vgCompiler.SuccessFul;
	verbose(vrb_what_I_do,'Dispose memory');
	vgCompiler.Destroy;
	if GetConfigValues <> nil then GetConfigValues.Destroy;
	if GetOptionValues <> nil then GetOptionValues.Destroy;
	DoneOptions;
	verbose(vrb_Object_Count,'Object Count :');
	verbose(vrb_Object_Count,'Inits..........:'+IntTOStr(vgInits));
	verbose(vrb_Object_Count,'Dones..........:'+IntToStr(vgDones));
	if vgInits > vgDones then writeln('Warning : Memoryleak detected : ', vgInits-vgDones, ' objects not disposed');
	if vgInits < vgDones then writeln('Warning : More object deleted as created :',vgDOnes - vgInits);
	{$ifdef memleak}
	ListResult;
	{$endif}
	if not vgSuccess then halt(1)
	else halt(0);
end.

