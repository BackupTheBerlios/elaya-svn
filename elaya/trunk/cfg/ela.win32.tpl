SECTION(Target_Platform='win32')
	Can_Use_Dll := 'Y';
    	Assembler_Path := '@Dir_as@';
	Linker_Path    := '@Dir_ld@';
	Linker_Options	 := '--subsystem=console';
END;

SECTION(Target_Platform='gui32')
	Can_Use_Dll := 'Y';
    	Assembler_Path := '@Dir_as@';
	Linker_Path    := '@Dir_ld@';
	Linker_Options	 := '--subsystem=windows';
END;
