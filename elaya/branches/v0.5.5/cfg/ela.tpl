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

  -------------------------------------------------------- 
 			ELAYA 
 		    CONFIGURATIE 
			-FILE-
  -------------------------------------------------------- 
}

var NO    := 'N';
const False := 'N';
var True  := 'Y';
var Yes   := 'Y';


var can_cross_compile:= '@Can_Cross_Compile@';
var Req_Cross_Compile:= 'n';
var Rtl_Sub_Dir ;
{Init}
section
	output_object_Path := '';

	write('File name :',source_name);
	write('Current OS:',Operating_System);
	write('Targe Os  :',Target_Platform);
	write('Assembel  :',run_assembler);
	write('Comp. dir :',Compiler_Dir);
	Always_Stack_Frame           := 'N';
	Print_Register_Res           := 'N';
	Remember_External_Param_name := 'Y';
	Assembler_Path               := '/usr/bin/as';
	Linker_Path		     := '/usr/bin/ld';
	Is_Elf_target		:= 'N' ;
	Auto_Load     := 'core;sys;classes;memory';
END;



var t_Is_win32:='n';
var t_os_ok:='n';

{target linux}


SECTION(Target_Platform='linux')
	Linker_Options	 := '-dynamic-linker=/lib/ld-linux.so.2';
	t_os_ok:='y';
	Is_Elf_Target := 'Y' ;
	Rtl_Sub_Dir := Target_PlatForm;
END;

{target win32 Os}

SECTION(Target_Platform='win32')
         t_Is_Win32:='y';
	Linker_options:='--subsystem console';
END;

SECTION(Target_Platform='gui32')
         t_is_win32:='y';
	Linker_options:='--subsystem windows';
END;

SECTION(Target_Platform='dll32')
	t_is_win32:='y';
	Linker_options:='--subsystem dll';
END;

SECTION(t_is_win32='y')
	t_os_ok:='y';
	Rtl_Sub_Dir := 'win32';
END;

SECTION(operating_system = 'linux')
	Object_Path := '@Dir_Ela_Rtl_Base@/'+Rtl_Sub_Dir;
END;

SECTION (operating_system='win32')
	object_Path :=Compiler_Dir +'../lib/' +Rtl_Sub_Dir;
END;
{host x target}


SECTION(operating_system='linux')


      SECTION(t_is_win32='y')
	Assembler_Path    := '/usr/local/bin/asw';
	Linker_Path       := '/usr/local/bin/ldw';
	Req_Cross_Compile := 'y';
      END;

      SECTION(Target_Platform='linux')
      	Assembler_Path     := '/usr/bin/as';
	Linker_Path        := '/usr/bin/ld';
      END;
END;

SECTION(operating_system='win32')
	SECTION(t_is_win32='y')
	 Assembler_Path := 'asw';
	 Linker_Path    := 'ldw';
	END;
	
	SECTION(Target_Platform='linux')
	  t_os_ok :='n';
	END;
END;

{Error Checking}

SECTION(t_os_ok='n')
    fail('Target operating system should be : linux,gui32,dll32 or win32, but not:'+Target_Platform);
END;

SECTION(can_cross_compile='n' Req_cross_compile='y')
    fail('Target '+Target_Platform+' not supported');
END;

END;
