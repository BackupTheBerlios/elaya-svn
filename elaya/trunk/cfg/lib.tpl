{    Elaya, the compiler for the elaya language
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

{
# -------------------------------------------------------- 
#			ELAYA 
#		    CONFIGURATIE 
#			-FILE 
# -------------------------------------------------------- 
}

const No    := 'N';
const False := 'N';
const Yes   := 'Y';
const True  := 'Y';

var Object_Path_Base := '@Dir_Ela_Rtl_Base@';
var Can_Cross_Compile:= '@Can_Cross_Compile@';
var Req_Cross_Compile:= 'n';
section

	write('File name :',source_name);
	write('Targe Os  :',Target_Platform);
	Always_Stack_Frame           := 'N';
	Print_Register_Res           := 'N';
	Remember_External_Param_name := 'Y';	
	Is_Elf_Target := 'N';
	Auto_Load           := 'core;sys;classes;memory';
END;

var MySql_Lib_Type := '';
var MySql_Lib_Name := '';
var MySql_Lib_CallType := '';
var Kernel_Lib_Type := '';
var Kernel_Lib_Name := '';
var Kernel_Lib_CallType := '';
var t_os_Ok   :='n';
var t_Is_win32:='n';


SECTION(Target_Platform='linux')
	MySql_Lib_Type     := 'LINKED';
	MySql_Lib_Name     := 'libmysqlclient.so';
	MySql_Lib_CallType := 'CDecl';
	Can_Use_Dll	 := 'N';
	Output_Object_Path   := Object_Path_base+'/linux';
	Is_Elf_Target := 'Y' ;


	SECTION(source_name='linux')
		AUto_Load := '';
	END;


	object_Path	     := Output_Object_Path;

         t_os_ok:='y';
END;


SECTION(Target_Platform='win32')
	t_is_Win32:='y';
END;

SECTION(Target_Platform='gui32')
         Linker_options:='--subsystem windows';
	t_is_Win32:='y';
END;

SECTION(Target_Platform='dll32')
	Linker_options:='-subsystem dll';
         t_is_Win32:= 'y';
END;

SECTION(operating_system='linux')
	SECTION(Target_Platform='linux')
		Assembler_Path  := '/usr/bin/as';
	END;
	
	SECTION(t_is_win32='y')
		Assembler_Path := '/usr/local/bin/asw';
		Req_Cross_Compile := 'y';
	END;
END;

SECTION(operating_system='win32')
	SECTION(t_is_win32='y')
		Assembler_Path := 'asw';
	END;
	
	SECTION(Target_Platform='linux')
		t_os_ok := 'n';
	END;
END;


SECTION(t_is_Win32='y')
	Output_Object_Path   := Object_Path_base+'/win32';
	object_Path	     := Output_Object_Path;

	MySql_Lib_Type      := 'DLL';
	MySql_Lib_Name      := 'mysql.dll';
	MySql_Lib_CallType  := 'normal';
	Kernel_Lib_Type     := 'DLL';
	Kernel_Lib_Name	  := 'kernel32.dll';
	Kernel_Lib_CallType := 'normal';
	Can_Use_Dll         := 'Y';

        SECTION(source_Name='win32op')
		Auto_LOad := '';
	END;

	SECTION(source_name='win32procs')
		Auto_Load := '';
	END;
	SECTION(source_name='win32types')
		Auto_Load := '';
	END;

	SECTION(source_name='win32gui')
		Auto_Load := '';
	END;

        t_os_Ok:='y';
END;


SECTION(source_name='sys_int') 
	Auto_Load := ''; 
END; 

SECTION(source_name='sys')
	Auto_Load := '';
END;

SECTION(source_name='core')
	Auto_Load := '';
END;

SECTION(source_name='classes')
	Auto_Load := '';
END;

SECTION(source_name='memory')
	Auto_Load := '';
END;

SECTION(source_name='sockets')
	Auto_Load := '';
END;

SECTION(t_os_ok='n')
	fail('Target operating system must be:linux or for windows win32,gui32 or dll32');
END;

SECTION(Can_Cross_Compile='n'  Req_Cross_Compile='y')
	fail('Target '+Target_Platform+' not supported');
END;

END;
