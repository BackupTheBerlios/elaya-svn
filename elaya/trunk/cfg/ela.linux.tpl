
SECTION(Target_Platform='linux')
	Linker_Options	 := '-dynamic-linker=/lib/ld-linux.so.2';
	Assembler_Path   := '@linux_as@'
	Linker_Path := '@linux_ld@'
END;


SECTION (oprating_system = 'linux')
	Object_Path := '@Dir_Ela_Rtl_Base@/'+Rtl_Sub_Dir;
END;



SECTION(operating_system='linux')

      	Assembler_Path     := '@Dir_as@';
	Linker_Path        := '@Dir_ld@';
END;


{Error Checking}


END;
