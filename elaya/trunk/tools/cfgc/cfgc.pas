{
    Elaya, the compiler for the elaya language
    Copyright (C) 1999,2000  J.v.Iddekinge.

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

uses progutil,stdobj,simplist;


type  TVarValuesList=class(TSMList)
          function  AddVar(const ParName, ParValue : string):boolean;
          function GetValueByName(const ParName : string;var ParValue :string):boolean;
      end;

      TVarValueItem=class(TSMListItem)
      private
             voVar : TString;
             voValue : TString;
             property iValue : TString read voValue write voValue;
             property iVar   : TString read voVar   write voVar;
      public
             function IsVarName(const ParName : string):boolean;
             function GetValueStr : string;
             constructor Create(const ParName, ParValue : string);
             procedure Clear;override;
      end;

{----( TVarValueItem )--------------------------------------------------------}

function TVarValueItem.IsVarName(const ParName : string):boolean;
begin
     exit(iVar.IsEqualStr(ParName));
end;

function TVarValueItem.GetValueStr : string;
var vlStr : string;
begin
     iValue.GetString(vlStr);
     exit(vlStr);
end;

procedure TVarValueItem.Clear;
begin
     inherited Clear;
     if iVar <> nil then iVar.Destroy;
     if iValue <> nil then iValue.Destroy;
end;

constructor TVarValueItem.Create(const ParName,ParValue : string);
begin
     inherited Create;
     iVar := TString.Create(ParName);
     iValue := TString.Create(ParValue);
end;

{---( TVarValueList )-----------------------------------------------------}

function TVarValuesList.AddVar(const ParName, ParValue : string):boolean;
var vlDummy : string;
begin
   	if GetValueByName(ParName,vlDummy) then exit(true);
	insertAt(nil,TVarValueItem.Create(ParName,ParValue));
	exit(false);
end;

function TVarValuesList.GetValueByName(const ParName : string;var ParValue :string):boolean;
var
   vlCurrent :TVarValueItem;
begin
     vlCurrent := TVarValueItem(fStart);
     while (vlCurrent <> nil) and not(vlCurrent.IsVarName(ParName)) do vlCurrent := TVarValueItem(vlCurrent.fNxt);
     if (vlCurrent <> nil) then begin
             ParValue := vlCUrrent.GetValueStr;
             exit(true);
     end else begin
             EmptyString(ParValue);
             exit(false);
     end;
end;


var
      vgTemplateFile     : text;
      vgVarListFile      : text;
      vgOutputFile       : Text;
      vgTemplateFileName : string;
      vgVarListFileName  : string;
      vgLine             : string;
      vgOutLine          : string;
      vgPos              : byte;
      vgLineCnt          : cardinal;
      vgName             : string;
      vgValue            : string;
      vgVarList          : TVarValuesList;
      vgOutputFileName   : string;


procedure VarListFail(const ParMessage : string);
begin
     writeln('Error in var list file');
     writeln('Line ',vgLineCnt);
     writeln(vgLIne);
     writeln(ParMessage);
     halt(1);
end;


procedure TemplateFail(const ParLine,ParMessage : string;ParColNum : cardinal);
begin
     writeln('Error in template file');
     writeln('Line/Pos ',vgLineCnt,'/',ParColNum);
     writeln(ParLIne);
     writeln(ParMessage);
     halt(1);
end;

function ValidateVarName(const ParVarName : string):boolean;
var
   vlCnt : cardinal;
begin
     if length(ParVarName) = 0 then exit(true);
     for vlCnt := 1 TO length(parVarName) do begin
         case ParVarName[vlCnt] of
         '_','a'..'z','A'..'Z':begin end;
         '0'..'9':if vlCnt = 1 then exit(False);
         else exit(false);
         end;
     end;
     exit(true);
end;

procedure ProcessLine(const ParLine : string;var ParOut : string);
var vgCurPos : cardinal;
    vgVarName  :string;
    vgReplace  : string;
    vgVarStart : cardinal;
begin
     vgCurPos := 1;
     EmptyString(ParOut);
     while vgCurPos <=length(ParLine) do begin
           if ParLine[vgCurPos]='@' then begin
               inc(vgCurPos);
               vgVarStart := vgCurPos;
               EmptyString(vgVarName);
               while (vgCurPos <=length(ParLine)) and (ParLine[vgCurPos] <>'@') do begin
                     vgVarName := vgVarName + ParLine[vgCurPos];
                     inc(vgCurPos);
               end;
               if(vgCurPos > length(ParLine)) then TemplateFail(ParLine,'Closing "@" missing',vgCurPos);
               if (length(vgVarName)= 0) then begin
                  vgReplace := '@';
               end else begin
                   if not validateVarName(vgVarName) then TemplateFail(ParLine,'Invalid variable name '+vgVarName,vgVarStart);
                   if not vgVarList.GetValueByName(vgVarName,vgReplace) then TemplateFail(ParLine,'Cant find variable '+vgVarName,vgVarStart);
               end;
               if length(ParOut)>=255 - length(vgReplace) then TemplateFail(ParLine,'Resulting line too long',0);
               ParOut := ParOut + vgReplace;
           end else begin
               if length(ParOut)=255 then TemplateFail(ParLine,'Resulting line too long',0);
               ParOut := ParOut + ParLine[vgCurPos];
           end;
           inc(vgCurPos);
     end;
end;


begin
     writeln('Cfgc   Version: 0.1');
     writeln('Cfgc comes with ABSOLUTELY NO WARENTY');
     writeln('This is free software, under GPL license V 2');

     vgVarList := TVarValuesList.Create;
     if paramcount <> 3 then begin
        writeln('Parameter error,usage :');
        writeln('cgc <cfg_template_file> <cfg_var_list_file> <output_file_name>');
        halt(1);
     end;
     vgTemplateFileName := Paramstr(1);
     vgVarListFileName  := paramstr(2);
     vgOutputFileName   := Paramstr(3);
     assign(vgVarListFile,vgVarListFileName);
     reset(vgVarListFile);
     if ioresult <> 0 then begin
        writeln('Can''t open file ',vgVarListFileName);
        halt(1);
     end;
     vgLineCnt := 0;
     while not(eof(vgVarListFile)) do begin
           readln(vgVarListFile,vgLine);
           inc(vgLineCnt);
           vgPos := pos('=',vgLine);
           if (vgPos = 0) then  VarListFail('Line should contain a "="');
           vgName := copy(vgLine,1,vgPos - 1);
           vgValue := copy(vgLine,vgPos + 1,length(vgLine) - vgPos);
           Trim(vgName);
           Trim(vgValue);
           if not(ValidateVarName(vgName)) then VarListFail('Invalid variabel name');
           if vgVarList.AddVar(vgName,vgValue) then VarListFail('Variable allready exists');
     end;
     close(vgVarListFile);
     vgLineCnt := 0;
     assign(vgTemplateFile,vgTemplateFileName);
     reset(vgTemplateFile);
     if ioresult <> 0 then begin
                 writeln('Can''t open file ',vgTemplateFileName);
                 halt(1);
     end;
     assign(vgOutputFile,vgOutputFileName);
     rewrite(vgOutputFile);
     if ioresult <> 0 then begin
                 writeln('Can''t open output file ',vgOutputFileName);
                 close(vgTemplateFile);
                 halt(1);
     end;
     vgLineCnt := 0;
     while not(eof(vgTemplateFile)) do begin
           readln(vgTemplateFile,vgLine);
           inc(vgLineCnt);
           ProcessLine(vgLIne,vgOutLine);
           writeln(vgOutputFile,vgOutLine);
     end;
     close(vgOutputFile);
     close(vgTemplateFile);
end.
