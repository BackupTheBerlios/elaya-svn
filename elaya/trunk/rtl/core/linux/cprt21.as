#
#   $Id: cprt21.as,v 1.1 1999/05/03 21:29:36 peter Exp $
#   This file is part of the Free Pascal run time library.
#   Copyright (c) 1993,97 by Michael Van Canneyt and Peter Vreman
#   members of the Free Pascal development team.
#
#   See the file COPYING.FPC, included in this distribution,
#   for details about the copyright.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY;without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
#**********************************************************************}
#
# Linux ELF startup code for Free Pascal
#

        .file   "prt1.as"
        .text
        .globl  _start
        .type   _start,@function
_start:
        /* First locate the start of the environment variables */
        popl    %esi
        movl    %eax,%edi

        movl    %esp,%ebx               /* Points to the arguments */
        movl    %esi,%eax
        incl    %eax
        shll    $2,%eax
        addl    %esp,%eax
        andl    $0xfffffff8,%esp        /* Align stack */

        movl    %eax,_5LINUX4ENVP    /* Move the environment pointer */
        movl    %esi,_5LINUX4ARGC    /* Move the argument counter    */
        movl    %ebx,_5LINUX4ARGP    /* Move the argument pointer    */

        xorl    %ebp,%ebp
        pushl   %edi
        pushl   %esp
        pushl   %edx
        pushl    $0   
        pushl    $0
        pushl   %ebx
        pushl   %esi
        pushl   $main
        call    __libc_start_main
        hlt

/* fake main routine which will be run from libc */
main:

        /* start the program */
        call    _8ElaStart
	
	push $0
	call _exit


	.globl geterrno
geterrno:
	movl errno,%eax
	ret
 
