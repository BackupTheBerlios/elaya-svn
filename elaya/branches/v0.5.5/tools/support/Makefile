include ../../Values.tpl

.PHONY : all clean ver

all: ver

ver	:clean ver.pas
	$(Fpc) $(Opt_Fpc) ver.pas

clean :
	$(cmd_rm) ver
	$(cmd_rm) ver.owb
	$(cmd_rm) ver.sw
	$(cmd_rm) ver.exe