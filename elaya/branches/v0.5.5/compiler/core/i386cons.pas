{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web   : www.elaya.org

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}


unit i386cons;
interface
uses elatypes;
const
	
	AT_X86_ATT 	= 1;
	AT_X86_AS86	= 2;
	AT_X86_NASM     = 3;
	
	{Register Constanten }
	
	
	Reg_DontCare	   = 65535;
	Reg_NoReg		   = 65534;
	Reg_x86_Ax	   = 0;
	Reg_x86_Bx	   = 1;
	Reg_x86_Cx	   = 2;
	
	Reg_x86_Dx       	   = 3;
	Reg_x86_Di	   = 4;
	Reg_x86_Si	   = 5;
	Reg_x86_EAx	   = 6;
	Reg_x86_EBx	   = 7;
	Reg_X86_ECx	   = 8;
	Reg_X86_EDx	   = 9;
	Reg_X86_EDi	   = 10;
	Reg_X86_ESI	   = 11;
	Reg_X86_EBP	   = 12;
	Reg_X86_ESP          = 13;
	Reg_X86_BP	   = 14;
	Reg_X86_SP  	   = 15;
	Reg_X86_ES           = 16;
	REG_X86_CS	   = 17;
	Reg_X86_DS	   = 18;
	Reg_X86_FS	   = 19;
	Reg_X86_GS	   = 20;
	
	RN_None = 0;
	RN_AL	=1;
	RN_AH	=2;
	RN_AX	=3;
	RN_EAX	=4;
	RN_BL	=5;
	RN_BH	=6;
	RN_BX	=7;
	RN_EBX	=8;
	RN_CL	=9;
	RN_CH	=10;
	RN_CX	=11;
	RN_ECX	=12;
	RN_DL	=13;
	RN_DH	=14;
	RN_DX	=15;
	RN_EDX	=16;
	RN_SI	=17;
	RN_DI	=18;
	RN_ESI	=19;
	RN_EDI	=20;
	RN_BP	=21;
	RN_EBP  =22;
	RN_SP	=23;
	RN_ESP	=24;
	
	
	IT_MN_Align	='ALIGN';
	IT_MN_DB	='DB';
	IT_MN_DW	='DW';
	IT_MN_DD	='DD';
	IT_MN_DUP	='DUP';
	IT_MN_Global	= 'GLOBAL';
	
	MS_MN_BYTE	= 'BYTE';
	NS_MN_RESB	= 'RESB';
	NS_MN_TIMES	= 'TIMES';
	MS_MN_WORD	= 'WORD';
	MS_MN_DWORD	= 'DWORD';
	ATT_BAlign	= '.BALIGN';
	ATT_Comm	= '.COMM';
	ATT_LComm	= '.LCOMM';
	ATT_MN_Ascii	= '.ASCII';
	
	MN_Aad		= 'AAD';
	MN_Add		= 'ADD';
	MN_And		= 'AND';
	MN_Ascii	= '.ASCII';
	MN_BALIGN	= '.BALIGN';
	MN_BSS		= '.bss';
	MN_Byte		= '.BYTE';
	MN_CBW		= 'CBTW';
	MN_CWD		= 'CWTD';
	MN_CDQ		= 'CDQ';
	MN_CMP          = 'CMP';
	MN_COMM		= '.COMM';
	MN_Dot_Comm	= '.COMM';
	MN_Call	        = 'CALL';
	MN_Data		= '.data';
	MN_DEC		= 'DEC';
	MN_DIV		= 'DIV';
	MN_dot_Global 	= '.GLOBL';
	MN_Global	= 'GLOBAL';
	MN_IDIV		= 'IDIV';
	MN_IDATA2       = '.idata$2';
	MN_IDATA4	= '.idata$4';
	MN_IDATA5	= '.idata$5';
	MN_IDATA6	= '.idata$6';
	MN_IDATA7	= '.idata$7';
	MN_IMUL		= 'IMUL';
	MN_INC	 	= 'INC';
	MN_JUMP		= 'JMP';
	MN_LComm	= '.LCOMM';
	MN_Lea		= 'LEA';
	MN_Long		= '.LONG';
	MN_Mov		= 'MOV';
	MN_Movs		= 'MOVS';
	MN_Movz		= 'MOVZ';
	MN_MUL		= 'MUL';
	MN_NEG		= 'NEG';
	MN_NOP		= 'NOP';
	MN_NOT		= 'NOT';
	MN_Or		= 'OR';
	MN_POP          = 'POP';
	MN_PUSH         = 'PUSH';
	MN_Ret	 	= 'RET';
	MN_N_Section	= 'SECTION';
	MN_RVA		= '.RVA';
	MN_Section	= '.section';
	MN_Short   	= '.SHORT';
	MN_SHR      = 'SHR';
	MN_SHRD		= 'SHRD';
	MN_SHL      = 'SHL';
	MN_SHLD		= 'SHLD';
	MN_Stabn	= '.stabn';
	MN_Stabs	= '.stabs';
	MN_Sub  	= 'SUB';
	MN_Text		= '.text';
	MN_Word		= '.WORD';
	MN_Xor		= 'XOR';
	
	
	
	MN_Byte_Ext = 'B';
	MN_Word_Ext = 'W';
	MN_Long_Ext = 'L';
	
	
	
	MASTER_NUMBER=8;
	
	Master_Info:array[1..MASTER_NUMBER] of TMasterInfo=
((COD:RN_EAX; SRG:0;LRG:3)
,(COD:RN_EBX; SRG:0;LRG:3)
,(COD:RN_ECX; SRG:0;LRG:3)
,(COD:RN_EDX; SRG:0;LRG:3)
,(COD:RN_EDI; SRG:0;LRG:1)
,(COD:RN_ESI; SRG:0;LRG:1)
,(COD:RN_EBP; SRG:0;LRG:0)
,(COD:RN_ESP; SRG:0;LRG:0)
);

REG_NUMBER=22;
REG_INFO:array[0..REG_Number-1] of TRegisterInfo=
((REG:RN_EAX; SIZ:4; PRT:0; PRE:3 ;MRG:RN_EAX          ;LRG:RN_None    ;SRG:RN_AX;CDO:[CD_Reserve , CD_Math , CD_Pointer , CD_FunctionReturn];rhi:[RH_Math])
,(REG:RN_AX ; SIZ:2; PRT:0; PRE:1 ;MRG:RN_EAX;LRG:RN_EAX;SRG:RN_AL      ;CDO:[CD_Reserve , CD_Math , CD_FunctionReturn];rhi:[RH_Math])
,(REG:RN_AL ; SIZ:1; PRT:0; PRE:0 ;MRG:RN_EAX;LRG:RN_AX ;SRG:RN_None    ;CDO:[CD_Reserve , CD_Math , CD_FunctionReturn];rhi:[RH_Math])
,(REG:RN_AH ; SIZ:1; PRT:1; PRE:1 ;MRG:RN_EAX;LRG:RN_AX ;SRG:RN_None    ;CDO:[];rhi:[RH_Math])
,(REG:RN_EBX; SIZ:4; PRT:0; PRE:3 ;MRG:RN_EBX          ;LRG:RN_None    ;SRG:RN_BX;CDO:[CD_Reserve , CD_Math , CD_Pointer];rhi:[RH_Math])
,(REG:RN_BX ; SIZ:2; PRT:0; PRE:1 ;MRG:RN_EBX;LRG:RN_EBX;SRG:RN_BL      ;CDO:[CD_Reserve , CD_Math ];rhi:[RH_Math])
,(REG:RN_BL ; SIZ:1; PRT:0; PRE:0 ;MRG:RN_EBX;LRG:RN_BX ;SRG:RN_None    ;CDO:[CD_Reserve , CD_Math ];rhi:[RH_Math])
,(REG:RN_BH ; SIZ:1; PRT:1; PRE:1 ;MRG:RN_EBX;LRG:RN_BX ;SRG:RN_None    ;CDO:[ ];rhi:[RH_Math])
,(REG:RN_ECX; SIZ:4; PRT:0; PRE:3 ;MRG:RN_ECX          ;LRG:RN_None    ;SRG:RN_CX;CDO:[CD_Reserve , CD_Math , CD_Pointer ];rhi:[RH_Math,RH_Pointer])
,(REG:RN_CX ; SIZ:2; PRT:0; PRE:1 ;MRG:RN_ECX;LRG:RN_ECX;SRG:RN_CL      ;CDO:[CD_Reserve , CD_Math ];rhi:[RH_Math])
,(REG:RN_CL ; SIZ:1; PRT:0; PRE:0 ;MRG:RN_ECX;LRG:RN_CX ;SRG:RN_None    ;CDO:[CD_Reserve , CD_Math ];rhi:[RH_Math])
,(REG:RN_CH ; SIZ:1; PRT:1; PRE:1 ;MRG:RN_ECX;LRG:RN_CX ;SRG:RN_None    ;CDO:[];rhi:[RH_Math])
,(REG:RN_EDX; SIZ:4; PRT:0; PRE:3 ;MRG:RN_EDX          ;LRG:RN_None    ;SRG:RN_DX;CDO:[{CD_Reserve , CD_Math , CD_Pointer} ];rhi:[RH_POINTER])
,(REG:RN_DX ; SIZ:2; PRT:0; PRE:1 ;MRG:RN_EDX;LRG:RN_EDX;SRG:RN_DL      ;CDO:[CD_Reserve , CD_Math ];rhi:[])
,(REG:RN_DL ; SIZ:1; PRT:0; PRE:0 ;MRG:RN_EDX;LRG:RN_DX ;SRG:RN_None    ;CDO:[CD_Reserve , CD_Math ];rhi:[])
,(REG:RN_DH ; SIZ:1; PRT:1; PRE:1 ;MRG:RN_EDX;LRG:RN_DX ;SRG:RN_None    ;CDO:[];rhi:[])
,(REG:RN_EDI; SIZ:4; PRT:0; PRE:1 ;MRG:RN_EDI          ;LRG:RN_None    ;SRG:RN_DI;CDO:[CD_Reserve , CD_Math , CD_Pointer];rhi:[RH_Pointer] )
,(REG:RN_DI ; SIZ:2; PRT:0; PRE:0 ;MRG:RN_EDI;LRG:RN_EDI;SRG:RN_None    ;CDO:[CD_Reserve , CD_Math ];rhi:[])
,(REG:RN_ESI; SIZ:4; PRT:0; PRE:1 ;MRG:RN_ESI          ;LRG:RN_None    ;SRG:RN_SI;CDO:[CD_Reserve , CD_Math , CD_Pointer];rhi:[RH_Pointer])
,(REG:RN_SI ; SIZ:2; PRT:0; PRE:0 ;MRG:RN_ESI;LRG:RN_ESI;SRG:RN_None    ;CDO:[CD_Reserve , CD_Math];rhi:[])
,(REG:RN_EBP; SIZ:4; PRT:0; PRE:0 ;MRG:RN_EBP          ;LRG:RN_None    ;SRG:RN_None   ;CDO:[CD_StackFrame];rhi:[])
,(REG:RN_ESP; SIZ:4; PRT:0; PRE:0 ;MRG:RN_ESP          ;LRG:RN_None    ;SRG:RN_None   ;CDO:[CD_StackPointer];rhi:[]));


type
T386MovType=(
mv_normal,
mv_exp_sign,
mv_exp
);
T386InstructionCode=(
IC_386_None		,
IC_386_LabelInst	,
IC_386_MovInst	,
IC_386_DivInst	,
IC_386_MulInst	,
IC_386_JumpInst	,
IC_386_CondJumpInst   ,
IC_386_RetInst	,
IC_386_SubInst	,
IC_386_AddInst	,
IC_386_PushInst	,
IC_386_PopInst	,
IC_386_XorInst	,
IC_386_LeaInst	,
IC_386_IncInst	,
IC_386_DecINst	,
IC_386_NegInst	,
IC_386_NotInst        ,
IC_386_AndInst	,
IC_386_NopInst        ,
IC_386_CallInst	,
IC_386_OrInst         ,
IC_386_AsmInst       ,
IC_386_SignExtendInst      ,
IC_386_ShlInst,
IC_386_ShrInst,
IC_LineNumberStab,
IC_ProcedureStab
);


implementation


end.
