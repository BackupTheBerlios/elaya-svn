.PHONY: all clean

root_path=../../../../
include $(root_path)Makefile.inc

all: all_$(rtl_target)
all_win32:
	make all -Cbase

all_linux:
	make all -Cbase
	make all -Cmysql

clean:
	make clean -Cbase
	make clean -Cmysql
