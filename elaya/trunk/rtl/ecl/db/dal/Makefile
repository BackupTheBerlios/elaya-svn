.PHONY: all clean

root_path=../../../../
include $(root_path)Makefile.inc

all: all_$(rtl_target)
all_win32:
	$(MAKE) all -Cbase

all_linux:
	$(MAKE) all -Cbase
	$(MAKE) all -Cmysql

install:
	$(MAKE) install -Cbase
	$(MAKE) install -Cmysql

clean:
	$(MAKE) clean -Cbase
	$(MAKE) clean -Cmysql
