include ../../Values.tpl
include ../../Makefile.inc


.PHONY: all debug native clean oth_linux oth_win32 eel cgi mysl gtk mysql





all:	oth_$(rtl_target) debug native eel cgi math

math:
	$(MAKE) all -C math

debug:
	$(MAKE) all -C debug
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

clean:
	$(MAKE) clean -C eel
	$(MAKE) clean -C cgi
	$(MAKE) clean -C gtk
	$(MAKE) clean -C mysql
	$(MAKE) clean -C native
	$(MAKE) clean -C debug
