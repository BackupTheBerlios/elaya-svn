.PHONY: dep all clean all_main clean_main


root_path=../
include $(root_path)Makefile.inc


dep_files=lib/*.pas lib/$(Cpl_Target)/*.pas base/*.pas config/*.pas core/*.pas

all: dep all_lib

dep:dep_info

dep_info:  $(dep_files)
	$(ELADEP_CMD) -m lib -i objects -i dos -i strings -i sysutils -p $(dep_files) -u bin/ -c LIB_FPC -s .pas -e $(pp_unit_ext) >dep_info


clean:
	rm -f bin/*

install:
	cp $(addprefix bin/,$(addsuffix .*,$(notdir $(basename $(wildcard lib/*.pas lib/*.PAS)))))  $(Dir_Cpl_Lib)
	cp $(wildcard bin/ela) $(wildcard bin/ela.exe) $(Dir_Program)

include dep_info

