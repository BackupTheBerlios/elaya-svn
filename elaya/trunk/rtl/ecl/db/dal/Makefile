.PHONY: all clean

root_path=../../../../
include $(root_path)Makefile.inc

all: all_$(rtl_target)
all_win32:
	$(MAKE) all -Cbase

all_linux:
	$(MAKE) all -Cbase
#	$(MAKE) all -Cmysql

install: install_$(rtl_target)
install_linux:
	$(MAKE) install -Cbase
#	$(MAKE) install -Cmysql
install_win32:
	$(MAKE) install -Cbase
clean:
	$(MAKE) clean -Cbase
#	$(MAKE) clean -Cmysql
