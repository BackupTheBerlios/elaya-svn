
SECTION(Target_Platform='linux')
	Linker_Options	 := '-dynamic-linker=/lib/ld-linux.so.2';
	Assembler_Path   := '@linux_as@';
	Linker_Path := '@linux_ld@';
END;


