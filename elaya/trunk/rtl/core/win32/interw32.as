.text
	.globl _mainCRTStartup
	.globl _WinMainCRTStartup
	.globl inter_getinstance
	.globl inter_getprvinstance

	.lcomm v_instance,4
	.lcomm v_prvinstance,4

inter_getinstance:
	mov v_instance,%eax
	ret

inter_getprvinstance:
	mov v_prvinstance,%eax
	ret

_mainCRTStartup:
_WinMainCRTStartup:
	mov %esp,%ebp
	mov 8(%ebp),%eax
	mov %eax,v_instance
	mov 4(%ebp),%eax
	mov %eax,v_prvinstance
	call _ElaStart
	push $0
	call _10WIN32PROCS11EXITPROCESS
	ret


