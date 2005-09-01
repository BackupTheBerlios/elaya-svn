.PHONY: dep all clean all_main clean_main


root_path=../
include $(root_path)Makefile.inc

ela_program=ela$(exe_ext)



dep_files=lib/*.pas lib/$(Cpl_Target)/*.pas base/*.pas config/*.pas core/*.pas

all: dep all_lib

dep:dep_info

dep_info:  $(dep_files)
	$(ELADEP_CMD) -m lib -i objects -i dos -i strings -i sysutils -p $(dep_files) -u bin/ -c LIB_FPC -s .pas -e $(pp_unit_ext) -o dep_info


clean:
	rm -f bin/*

install:copyfiles $(if $link_exe_to,link_exe_to)
copyfiles:
	mkdir -p $(Dir_Program)
	mkdir -p $(Dir_Cpl_Lib)
	cp $(addprefix bin/,$(addsuffix .*,$(notdir $(basename $(wildcard lib/*.pas lib/*.PAS)))))  $(Dir_Cpl_Lib)
	cp $(wildcard bin/$(ela_program)) $(Dir_Program)

link_exe_to:
	$(cmd_rm) $(link_exe_to_dir)$(ela_program)
	ln -s  $(Dir_Program)ela$(exe_ext) $(link_exe_to_dir)$(ela_program)
include dep_info

