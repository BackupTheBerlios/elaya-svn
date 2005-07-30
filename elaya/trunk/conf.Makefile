cmd_args=

ifdef target
	cmd_args += target=$(target)
endif

all:
	tools/config/bc $(cmd_args) dirfile=build_files/config/eladirs.db config=build_files/config/bc output=config
