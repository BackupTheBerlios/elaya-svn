# Elaya interface and startup for linux

        .text
        .globl  _start
        .type   _start,@function
_start:
        popl    %esi
	mov	%esp,%ebx
        movl    %ebx,ElayaArgp
        push    %eax
        movl    %esi,ElayaArgc
	lea 	0x4(%ebx,%esi,4),%ebx
        andl    $0xfffffff8,%esp      
        movl    %ebx,ElayaEnvp

        xorl    %ebp,%ebp
        pushl   %esp
        pushl   %edx
        pushl    $0   
        pushl    $0
        pushl   %ebx
        pushl   %esi
        pushl   $main
        call    __libc_start_main
        hlt

main:

         call    _ElaStart
	push $0
	call _exit


	.globl inter_geterrno
	.symver errno,errno@GLIBC_2.0
inter_geterrno:
	mov errno,%eax
	ret

	.globl inter_getenvp
inter_getenvp:
	movl ElayaEnvp,%eax
	ret

         .globl inter_getargc
inter_getargc:
	mov ElayaArgc,%eax
	ret

	.globl inter_getargp
inter_getargp:
	mov ElayaArgp,%eax
	ret

.section .data

	.comm ElayaEnvp,4
	.comm ElayaArgc,4
	.comm ElayaArgp,4

