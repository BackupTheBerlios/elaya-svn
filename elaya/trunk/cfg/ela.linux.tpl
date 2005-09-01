
SECTION(Target_Platform='linux')
	Linker_Options	 := '-dynamic-linker=/lib/ld-linux.so.2';
	Assembler_Path   := '@Dir_as@';
	Linker_Path := '@Dir_ld@';
	SECTION('@enabled@'='n')
		fail('Linux not enabled');
	END;
END;



