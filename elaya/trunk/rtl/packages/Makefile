root_path=../../
include $(root_path)Makefile.inc


.PHONY: all debug native clean oth_linux oth_win32 eel cgi mysl gtk mysql math





all:	oth_$(rtl_target) debug native eel cgi math

math:
	$(MAKE) all -C math



eel:
	$(MAKE) all -C eel
cgi: eel
	$(MAKE) all -C cgi	


native :
	$(MAKE) all -C native

oth_linux:gtk mysql

gtk:
	$(MAKE) all -C gtk
mysql: eel 
	$(MAKE) all -C mysql

oth_win32:

install:
	$(MAKE) install -C eel
	$(MAKE) install -C cgi
	$(MAKE) install -C gtk
	$(MAKE) install -C mysql
	$(MAKE) install -C native
	$(MAKE) install -C math
   
clean:
	$(MAKE) clean -C eel
	$(MAKE) clean -C cgi
	$(MAKE) clean -C gtk
	$(MAKE) clean -C mysql
	$(MAKE) clean -C native
	$(MAKE) clean -C debug
