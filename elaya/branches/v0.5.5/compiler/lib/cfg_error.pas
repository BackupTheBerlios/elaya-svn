{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2002  J.v.Iddekinge.
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

unit cfg_error;
interface

uses cmp_type;
procedure CfgGetErrorText(ParError : TErrorTYpe;var ParMessage:string);
procedure CfgFatal(ParError : TErrorType);
const Err_Cfg_No_Error=0;
	Err_No_Config_Section = 9000;
	Err_Invalid_Os        = 9001;
	ERR_Unkown_Ident      = 9002;
	Err_Duplicate_Ident   = 9003;
	Err_Cant_Write        = 9004;
	Err_Cant_Open_File    = 9005;
implementation

procedure CfgFatal(ParError :TErrorTYpe);
var vlStr : string;
begin
	CfgGetErrorText(ParError,vlStr);
	writeln('Fatal error :');
	writeln(vlStr);
	RunError(255);
end;




procedure CfgGetErrorText(ParError : TErrorTYpe;var ParMessage:string);
begin
	case ParError of
	Err_Cfg_No_Error      : ParMessage := 'No Error';
	Err_Invalid_Os        : ParMessage := 'Invalid Os Code';
	Err_No_Config_Section : ParMessage := 'No config section';
	ERR_Unkown_Ident      : ParMessage := 'Unkown identifier';
	Err_Duplicate_Ident   : ParMessage := 'Duplicate identifier';
	Err_Cant_Write        : ParMessage := 'Can''t write to expression';
	Err_Cant_Open_File	   : ParMessage := 'Can''t open file';
	else begin
		Str(ParError,ParMessage);
		ParMessage := 'Unkown error : '+ParMessage;
	end;
end;
end;


end.
