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

const No    := 'N';
const False := 'N';
const True  := 'Y';
const Yes   := 'Y';


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
	Is_Elf_target                := 'N' ;
	Auto_Load                    := 'core;strings;sys;classes;memory';
	Object_Path                  := '@Dir_Ela_Rtl_Base@/'+Target_Platform;
END;




SECTION(Target_Platform='linux')
	Linker_Options	 := '-dynamic-linker=/lib/ld-linux.so.2';
	Assembler_Path   := '@linux_as@';
	Linker_Path := '@linux_ld@';
END;


END;
