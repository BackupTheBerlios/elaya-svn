.PHONY: all clean
include ../../../../Values.tpl
include ../../../../Makefile.inc

all: all_$(rtl_target)
all_win32:
	make all -Cbase

all_linux:
	make all -Cbase
	make all -Cmysql

clean:
	make clean -Cbase
	make clean -Cmysql
