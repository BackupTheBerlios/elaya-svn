include ../Values.tpl
include ../Makefile.inc

.PHONY : all clean

all  :
	$(Dir_Program)/cfgc ela.tpl ../Values.tpl $(Dir_Program)/ela.cfg
	$(Dir_Program)/cfgc lib.tpl ../Values.tpl $(Dir_Program)/lib.cfg

clean:

	    $(cmd_rm)  $(Dir_Program)$(Dir_Sep)ela.cfg
	    $(cmd_rm)  $(Dir_Program)$(Dir_Sep)lib.cfg

