root_path=../

include $(root_path)/Makefile.inc

.PHONY : all clean

all  :
	$(CFGC_CMD) ela.tpl $(root_path)/config/build_conf.$(os_host).$(rtl_target) bin/ela.cfg
	$(CFGC_CMD) lib.tpl $(root_path)/config/build_conf.$(os_host).$(rtl_target) bin/lib.cfg

install:
	cp bin/*.cfg $(Dir_Program)

clean:

	    $(cmd_rm)  bin/*

