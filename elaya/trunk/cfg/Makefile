root_path=../

include $(root_path)/Makefile.inc

.PHONY : all clean

all  :
	$(Dir_Program)/cfgc ela.tpl $(root_path)/config/build_conf.$(os_host).$(rtl_target) $(Dir_Program)/ela.cfg
	$(Dir_Program)/cfgc lib.tpl $(root_path)/config/build_conf.$(os_host).$(rtl_target) $(Dir_Program)/lib.cfg

clean:

	    $(cmd_rm)  $(Dir_Program)$(Dir_Sep)ela.cfg
	    $(cmd_rm)  $(Dir_Program)$(Dir_Sep)lib.cfg

