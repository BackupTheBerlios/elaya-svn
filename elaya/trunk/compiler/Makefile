.PHONY: all clean all_main clean_main


root_path=../
include $(root_path)Makefile.inc

vpath %.ppu $(Dir_Cpl_Lib) $(Dir_Dirt)
vpath %.ppw $(Dir_Cpl_Lib) $(Dir_Dirt)

dep_lib=lib/*.pas lib/$(Cpl_Target)/*.pas 
dep_rem=base/*.pas config/*.pas core/*.pas

all: dep all_lib all_rem
dep_lib: $(dep_lib)
	$(eladep) -m lib -i objects -i dos -i strings -i sysutils -p $(dep_lib) -u $(Dir_Cpl_Lib)/ -c LIB_FPC -s .pas -e $(pp_unit_ext) >dep_lib
dep_rem: $(dep_rem)
	$(eladep) -m rem -i objects -i dos -i strings -i sysutils -p $(dep_rem) -u $(Dir_Dirt)/ -c EXE_FPC -s .pas -e $(pp_unit_ext) >dep_rem

dep: dep_lib dep_rem

clean:  clean_lib clean_rem
	$(cmd_rm) dep_lib
	$(cmd_rm) dep_rem

include dep_lib
include dep_rem
