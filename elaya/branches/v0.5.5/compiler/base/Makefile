include ../../Values.tpl
include ../../Makefile.inc
FPC=$(Fpc) $(Opt_Fpc) -Fu$(Dir_Cpl_Lib) -FU$(Dir_Dirt)

vpath %.ppu $(Dir_Cpl_Lib) $(Dir_Dirt)
vpath %.ppw $(Dir_Cpl_Lib) $(Dir_Dirt)

files=$(subst ",,$(foreach dir,$(basename $(wildcard *.pas)),",$(dir)"))
dollar=$$

.PHONY:all
all: base.dep dummy.ppu

clean:
	$(cmd_rm) $(Dir_Dirt)/*
	$(cmd_rm) dummy.pp
	$(cmd_rm) lib.dep

dummy.pp: *.pas
	echo "uses classes$(files);" > dummy.pp
	echo "begin ">>dummy.pp
	echo "end." >>dummy.pp

base.dep: dummy.pp *.pas
	ppdep dummy -A"touch \$(dollar)(Dir_Cpl_Lib)/* && \$(dollar)(FPC)" >base.dep

	


include base.dep
