root_path=../

include $(root_path)/Makefile.inc

.PHONY : all clean

all  :
	$(CFGC_CMD) ela.tpl $(root_path)/config/cfg_setup bin/ela.cfg
	$(CFGC_CMD) lib.tpl $(root_path)/config/cfg_setup bin/lib.cfg

install:
	mkdir -p $(Dir_Cfg)
	cp bin/*.cfg $(Dir_Cfg)

clean:

	    $(cmd_rm)  bin/*

