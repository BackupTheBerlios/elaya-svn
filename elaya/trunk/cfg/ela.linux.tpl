
SECTION(Target_Platform='linux')
	Linker_Options	 := '-dynamic-linker=/lib/ld-linux.so.2';
	Assembler_Path   := '@Dir_as@';
	Linker_Path := '@Dir_ld@';
END;


END;
