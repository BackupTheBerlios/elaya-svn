SECTION(operating_system='linux')
	SECTION(Target_Platform='linux')
		Assembler_Path  := '@Dir_as@';
		SECTION('@enabled@'='n')
			fail('Linux not enabled');
		END;
	END;

END;






