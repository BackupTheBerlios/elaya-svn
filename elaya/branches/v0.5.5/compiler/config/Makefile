include ../../Values.tpl
include ../../Makefile.inc

vpath %.ppu $(Dir_Cpl_Lib) $(Dir_Dirt)
vpath %.ppw $(Dir_Cpl_Lib) $(Dir_Dirt)

.PHONY:all clean 

options_dep=progutil confval stdobj elatypes elacons simplist
confval_dep=stdobj elatypes elacons progutil

all: options$(pp_unit_ext) confval$(pp_unit_ext)
clean:		
		$(cmd_rm) $(foreach fn,$(patsubst %.pas,%.*,$(wildcard *.pas)),$(Dir_Cpl_Lib)$(Dir_Sep)$(fn))
	
options$(pp_unit_ext): $(foreach fn,$(options_dep),$(fn)$(pp_unit_ext)) options.pas
		$(EXE_FPC) options.pas

confval$(pp_unit_ext): $(foreach fn,$(confval_dep),$(fn)$(pp_unit_ext)) confval.pas
		$(EXE_FPC) confval.pas


