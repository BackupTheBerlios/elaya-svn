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
	Auto_Load           := 'core;sys;classes;memory;strings';
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
	Output_Object_Path   :='@Dir_Rtl@';
	Is_Elf_Target := 'Y' ;


	SECTION(source_name='linux')
		AUto_Load := '';
	END;


	object_Path	     := Output_Object_Path;

END;



SECTION(operating_system='linux')
	SECTION(Target_Platform='linux')
		Assembler_Path  := '@Dir_as@';
	END;
	
END;




SECTION(source_name='strings') 
	Auto_Load := ''; 
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


END;
