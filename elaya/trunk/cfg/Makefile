root_path=../

include $(root_path)config/build_conf.gen
cfgc=../tools/cfgc/bin/cfgc



.PHONY : all lib clean

all  :ela lib

ela:
	$(cfgc) ela.base.tpl $(root_path)/config/build_conf.gen >bin/ela.cfg
	$(cfgc) ela.linux.tpl $(root_path)/config/build_conf.$(os_host).linux >>bin/ela.cfg
	$(cfgc) ela.win32.tpl $(root_path)/config/build_conf.$(os_host).win32 >>bin/ela.cfg
	echo "END;" >>bin/ela.cfg

lib:
	$(cfgc) lib.base.tpl $(root_path)/config/build_conf.gen >bin/lib.cfg
	$(cfgc) lib.linux.tpl $(root_path)/config/build_conf.$(os_host).linux >>bin/lib.cfg
	$(cfgc) lib.win32.tpl $(root_path)/config/build_conf.$(os_host).win32 >>bin/lib.cfg
	echo "END;" >>bin/lib.cfg

install:
	mkdir -p $(Dir_Cfg)
	cp bin/*.cfg $(Dir_Cfg)

clean:

	    $(cmd_rm)  bin/*

