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


unit ElaCons;
interface
uses largenum,elaTypes,progutil;

{Object Code}
type



	TNodeIdentCode=(
      IC_UnkownNode ,
		IC_CallNode   ,
		IC_MulNode    ,
		IC_AddNode    ,
		IC_VarNode    ,
		IC_NumNode    ,
		IC_UnkNode    ,
		IC_LoadNode   ,
		IC_DivNode    ,
		IC_IfNode	  ,
		IC_ByPtrNode  ,
		IC_StringNOde ,
		IC_NotNode	  ,
		IC_ShlNode    ,
		IC_AsmNode    ,
		IC_ShrNode	  ,
		IC_IncDecNode ,
		IC_BetweenNode,
		IC_DotNode    ,
		IC_AndNode    ,
		IC_OrNode     ,
		IC_XorNode    ,
		IC_TypeNode   ,
		IC_ProcedureNode ,
		IC_LabelNode	,
		IC_BreakNode    ,
		IC_ContinueNode ,
		IC_SubNode      ,
		IC_LoadConvertNode,
		IC_NegNode      ,
	   IC_CompNode     ,
		IC_ParamNode	 ,
		IC_BlockNode
	);

	TMacIdentCode=(
        IC_UnkownMac    ,
		IC_MemMac	    ,
		IC_ParamVarMac 	,
		IC_OutputMac 	,
		IC_VarMac	    ,
		IC_NumberMac	,
		IC_ResultMac	,
		IC_ReferenceMac	,
		IC_ByPointerMac ,
		IC_StringConMac ,
		IC_CompareMac   ,
		IC_LocalVarMac  ,
		IC_ErrorMac		,
		IC_OffsetMac	,
		IC_MemOfsMac	,
		IC_LabelMac		,
		IC_TLMac		,
        IC_MethodPtrMac

	);

	TPocIdentCode=(
    IC_UnkownPoc   ,
	IC_LabelPoc    ,
	IC_JumpPoc     ,
	IC_CondJumpPoc ,
	IC_SubPoc	   ,
	IC_UnkPoc	   ,
	IC_MetaPoc	   ,
	IC_CallMetaPoc ,
	IC_DotPoc	   ,
	IC_NegPoc	   ,
	IC_CallPoc		,
	IC_SetParPoc	,
	IC_AndFor		,
	IC_OrFor		,
	IC_XorFor		,
	IC_RetPoc		,
	IC_AddFor		,
	IC_SubFor		,
	IC_MulFor		,
	IC_DIvFOr		,
	IC_StringLoadFor,
	IC_NotPoc		,
	IC_ReleasePoc   ,
	IC_ShrPoc       ,
	IC_ShlPoc		,
	IC_ModFor		,
	IC_IncDecFor    ,
	IC_OptUnSavePoc ,
    IC_LoadPoc      ,
	IC_CompPoc      ,
	IC_LOngResMetaPoc,
	IC_AsmPoc       ,
	IC_LSMove		,
	IC_Routinepoc
	);

	TIdentCode=(
	IC_Unkown    := 0,
	IC_Number    := 1,
	IC_TypeAs    := 2,
	IC_IntCons   := 3,
	IC_Enumtype  := 4,
	IC_PtrType   := 5,
	IC_UnitList  := 6,
	IC_Unit      := 7,
	IC_Variable  := 8,
	IC_Global    := 10,
	IC_Local     := 11,
	IC_Param     := 12,
	IC_None	     := 13,
	IC_Procedure := 14,
	IC_ParamVar  := 15,
	IC_Bigger	 := 23,
	IC_Lower	 := 24,
	IC_BiggerEq  := 25,
	IC_LowerEq   := 26,
	IC_Eq	     := 27,
	IC_NotEq	 := 28,
	IC_Function  := 31,
	IC_External  := 32,
	IC_Record	  := 33,
	IC_Constant       := 37,
	IC_IntConstant    := 38,
	IC_StringCons     := 39,
	IC_StringType     := 41,
	IC_CharType       := 42,
	IC_RegisterSI     := 45,
	IC_StackSI        := 46,
	IC_CHooseType     := 47,
	IC_RetAcc	        := 81,
	IC_ExtProc	:= 84,
	IC_ExtFun		:= 85,
	IC_LocalVar	:= 90,
	IC_ArrayType	:= 96,
IC_StartupProc	:= 107,
IC_AsciizType	:= 108,
IC_POinterCOns	:= 109,
IC_Union		:= 123,
IC_VoidType	:= 125,
IC_RoutineType  	    := 126,
IC_ObjectFile                 := 130,
IC_ExternLibFileWindows       := 131,
IC_ExternObjFile  	    := 133,
IC_ExternLibIntWindows        := 134,
IC_ExternObjInt   	    := 136,
IC_RoutineItem		    := 138,
IC_RoutineCollection        := 139,
iC_AsmAsm			    := 142,
IC_RTLParameter		    := 143,
IC_OperatorFunction     := 145,
IC_Current_Definition   := 151,
IC_Current_RoutineItem  := 152,
IC_Current_Node         := 153,
IC_Current_LCB          := 154,
IC_FrameParameter       := 162,
IC_VmtItem		      := 166,
IC_VmtList		      := 167,
IC_Meta		          := 168,
IC_Frame			      := 169,
IC_FrameVariable        := 170,
IC_ConstantMapping      := 171,
IC_NormalMapping        := 172,
IC_LocalFrameVar        := 173,
IC_VariableMapping      := 177,
IC_NestParameter        := 178,
IC_GlobalItem           := 186,
IC_Abstract_Dirty_Item  := 188,
IC_ClassType            := 189,
IC_ClassFrameParameter  := 190,
IC_Constructor          := 191,
IC_Destructor           := 192,
IC_Current_Class_Item	:= 193,
IC_Class_Meta           := 194,
IC_Object_Representor   := 195,
IC_Fixed_Frame_Parameter:= 196,
IC_Property				:= 197,
IC_Property_Item        := 198,
IC_ENumCons				:= 203,
IC_BooleanType          := 204,
IC_EnumCollection       := 205,
Ic_Abstract				:= 206
);

TResourceIdentCode=(
RT_None	,
RT_Unkown,
RT_Register,
RT_Memory,
RT_Number,
RT_CmpFlag,
RT_StackMem,
RT_ByPtr,
RT_Stack,
RT_NumberByExp,
RT_LabelRes
);

TPropertyType=(PT_Read := 0,
               PT_Write := 1);

TSearchOption=(SO_Global,SO_Local,SO_Current_List);
TSearchOptions=set of TSearchOption;

TCFoundResult=(CF_Public,CF_NotPublic,CF_Other_Type,CF_NotFound);

{ External type}

TExternalType=(ET_Linked,ET_Dll,et_Error);

const
	Ext_Linked='LINKED';
	Ext_Dll   ='DLL';
	Ext_CDecl ='CDECL';
	Ext_Normal='NORMAL';
	
type
	
	{Parameter compare}
	
	TParamCompareOption=(PC_Relaxed,PC_IgnoreName,PC_IgnoreState,PC_CheckAll);
	TParamCompareOptions=set of TParamCompareOption;

TDefAccess=(AF_Private := 0,AF_Protected := 1,AF_Public := 2,AF_Current := 3);




{--( Assembler type )------------------------------------}
type

TAssemblerType=(AT_None,AT_X86Att,AT_As86,AT_Nasm86);

TCurrentItemCompare=(CIC_Different,CIC_Same,CIC_Quit);

TOperatorProcessResult=(OPR_Ok,OPR_Error,OPR_Not_Found);
const
{Identification numbers for Resources}

In_In_1 = 1;
In_In_2 = 2;
In_In_3 = 3;
In_Div_High_In   = 4 ;
In_Main_Out      = 64;
In_Mod_Out       = 128;
In_High_Out      = 192;
In_Flag_Out      = 256;
In_Out_Mask      = 960;
In_In_Mask       = 63;
In_Error         = 0;


{Type identifierd voor units}

IU_Byte   = 1;
IU_Word   = 2;
IU_LongInt= 3;
IU_Long   = 4;
IU_String = 5;
IU_Integer= 6;
IU_Boolean= 7;
IU_Number = 8;
IU_TString= 9;
IU_TPointer = 10;
IU_TLOngint = 11;
IU_TBoolean = 12;
{Unit State}
type
TUnitLoadState=(
US_Must_Load        := 1,
US_Must_Load_Header := 2,
US_Current_Unit	    := 3,
US_Must_Recompile   := 4,
US_Wrong_Version    := 5,
US_Wrong_Source_date:= 6
);

TUnitLoadStates=set of TUnitLoadState;



const
{Unit Level}

UL_No_Unit_level       = 0;
UL_Minimum_Unit_Level  = 1;

{Mac creation option}
type
TNodeCreateOption=(
NCO_Read,
NCO_Write,
NCO_PointerOf,
NCO_ByPointer
) ;

TMacCreateOption=(
MCO_Result        := 1,
MCO_Size          := 2,
MCO_ValuePointer  := 3,
MCO_ObjectPointer := 4,
MCO_Decision      := 5
);

TMappingOption=(
	MO_Result := 1,
	MO_ByPointer := 2,
	MO_ObjectPointer := 3
);

{Operands Size difference}
const
SD_None       = 0;
SD_DestLower  = 1;
SD_DestBigger = 2;
SD_Complex    = 3;

{Resource Flag}

RT_Nothing  = 0;
RT_Used     = 1;
RT_InUse    = 2;
RT_TempRes  = 8;
RT_Forced   = 16;

{Resource access}

type
TAccess=(RA_Read,RA_Output);
TAccessSet=set of TAccess;

TKeepContentsState=(KS_Not,KS_Replace,KS_Move,KS_Error);

{Resource Use}

TResourceState=(
RU_Nothing := 0,
RU_Using   := 1,
RU_Free    := 2
);

TREC_Option=(REC_Result,REC_Pointer,REC_ByPointer);



{Procedure Variable}

TParamTransferType=(
PV_Unkown    := 0,
PV_Value     := 1,
PV_Var       := 2,
PV_Const     := 3
);


TOptimizeMethod=(
OM_Complexity,
OM_Evaluate_Constants
);

TOptimizeMethods = set of TOptimizeMethod;

TParamTransferTypeDescType=string[10];

const
ParamTransferTypeDesc:array[PV_Unkown..PV_Const] of TParamTransferTypeDescType=
('Unkown','By value','By Var','Constant');

{complexity}
CPX_Constant=1;
CPX_Dot=1;
CPX_Type_Casting=1;
CPX_ReturnVar=1;
CPX_Variable=1;
CPX_Address=1;
CPX_Pointer=2;
CPX_BYPointer=2;
CPX_AND = 2;
CPX_OR =2;
CPX_XOR=2;
CPX_NEG=2;
CPX_NOT=2;
CPX_ADD=2;
CPX_SUB=2;
CPX_COMP=2;
CPX_BETWEEN=3;
CPX_MUL=3;
CPX_ARRAY=3;
CPX_DIV=3;
CPX_MOD=3;
CPX_CALL=4;


type


{Can codes}

TCan_Type=(CAN_Read,CAN_Write,Can_Execute,Can_Type,Can_Size,Can_Pointer,Can_Index,Can_Dot);
TCan_Types=set of TCan_Type;
TMN_Type=(MT_Call,MT_Type,MT_Other,MT_Error);
{optimazation modes}
TOptimizeMode=(
OPT_Jump,
OPT_Keep_Relaxed_Contents
);

TUnusedDeleteMode=(
UDM_Output,
UDM_All
);

TOptimizeModes=set of TOptimizeMode;
const
COPT_Keep_Contents =[OPT_Keep_Relaxed_Contents];
type
{Dominant constanten}
TDomType=(
DOM_Not	  ,
DOM_Yes	  ,
DOM_Unkown  ,
DOM_Failed
);

{Definition modes}

TDefinitionMode=( DM_CPublic := 1,DM_Interface := 2,DM_Anonymous := 3);
TDefinitionModes=set of TDefinitionMode;

{ Routine modes}

TOverloadMode=(
OVL_None,
OVL_Type,
OVL_Name,
OVL_Exact
);

TRoutineMode=(
RTM_CDecl             := 0,
RTM_extended          := 1,
RTM_Virtual           := 2,
RTM_Override          := 3,
RTM_Final             := 4,
RTM_ShortDCode        := 5,
RTM_Overload          := 6,
RTM_Name_Overload     := 7,
RTM_Change_After_Lock := 8,
RTM_Inherit_Final     := 9,
RTM_Isolate           := 10,
RTM_Abstract          := 11,
RTM_Exact_Overload    := 12
);
TRoutineModes=set of TRoutineMode;

TRoutineState=(
RTS_HasNeverStackFrame := 0,
RTS_Has_Forwards       := 1,
RTS_Require_Main       := 2,
RTS_Has_Sr_Lock        := 3,
RTS_ForwardDefined     := 4,
RTS_ProcCreated        := 5,
RTS_IsDefined          := 6,
RTS_HasNoMain          := 7,
RTS_SharedLocalFrame   := 8,
RTS_HasVirtualParams   := 9,
RTS_Abstract_Dirty     := 10,
RTS_forward_has_Main   := 11,
RTS_forward_No_Main    := 12
);
TRoutineStates=set of TRoutineState;

TVirtualMode=(Vir_None,vir_virtual,vir_override,vir_Final);

const
Mac_Output   = 0;

{Is Same Params }
Type TIsSame=( IS_Reads, IS_Modifies, IS_Uses);
THowType=set of TIsSame;
{Object find}
TObjectfindState=(OFS_Same:=0,OFS_Different:=1);

{Default type}
TDefaultTypeCode=(
DT_Nothing   := 0,
DT_Boolean   := 1,
DT_Char	   := 2,
DT_String    := 3,
DT_Number	   := 4,
DT_Asciiz	   := 5,
DT_Void	   := 6,
DT_Pointer   := 7,
DT_Routine   := 8,
DT_Meta	   := 9,
DT_Ptr_Meta  := 10,
DT_Default   := 11,
DT_New	   := 12      );
TDefaultTypes=set of TDefaultTypeCode;
const
DT_Description:array[DT_Nothing..DT_Default] of string[15]
=('Nothing','Boolean','Char','String','Number','asciiz','Void','Pointer','Routine','Meta','Ptr Meta','Defualt');

type      TDatType=(
DAT_Abstract	    := 0,
DAT_Variables 	    := 1,
DAT_External_Names  := 2,
DAT_Ext_Names_Index := 3,
DAT_Jump_Tables     := 4,
DAT_Root_Index      := 5,
DAT_Lib_names       := 6,
DAT_Text	    := 7,
DAT_Data            := 8,
DAT_Code	    := 9
);
const
SIZE_PLT_Ptr_IDX   = 1023;
SIZE_OSL_Ptr_IDx   = 1023 ;
SIZE_PtrConvHash	 = 255;
SIZE_ReadBuffer	 =8194;

SIZE_Align        = 4;
SIZE_Pushsize      = SIZE_Align;
SIZE_ParamBegin    = 8;
SIZE_AsmLeftMargin = 8;
SIZE_DontCare  = 0;


{  Resource Modes}

type
TResourceModes=(RM_InList,RM_Keep_Contents,RM_Can_UnUsed_Output,RM_Keep_for_UnUsed);
TResourceMode=set of TResourceModes;

{ Resource Change }
TChangeCode=(
RC_None	 	  := 0,
RC_Change_To_Reg  := 1,
RC_Force_Register := 2,
RC_Combine_ZO	  := 4,
RC_Automatic	  := 5,
RC_Change_Nothing := 6,
RC_Change_To_Self := 7);


const
{Try change flag }
Try_Not		 = 0;
Try_Try		 = 1;
Try_Must	 = 2;

{labels}
Lab_Newname	 = -1;

{Routineitem opzoek State}

STAT_Cf_Ok              = 0;
STAT_Cf_CB_Not_Found    = 1;
STAT_CF_Param_not_Found = 2;

{Speciale Resource numbering}


{---( Boolean constanten )--------}

BV_False = 0;
BV_True  = -1;

{----( TMeta )---------------------}
const
	Ofs_ExtR_Vmt_Begin	= 8;
	Ofs_Class_Vmt_Begin = 12;
	{----( Versie )--------------------}
	
	VER_Date  = 'Build '+{$i %FPCTARGET%}+' '+{$i %DATE%}+' '+{$i %TIME%};
	VER_Head  = 'Copyright (C) 1998-2003 J.v.Iddekinge';
	VER_No    = '0.5.5';
	
	{---( Validation )-----------------}
	
	type TConstantValidation=(Val_Ok,Val_Invalid,Val_Out_Of_Range);
	
	{--( OVModes )-------------------}
	
	TOVMode = (OVM_IS_Virtual,OVM_Found,OVM_Is_Routine,OVM_Change_After_Lock,OVM_Constructor);
	TOVModes = set of TOVMode;

{=====( COnfiguratie )=====================================================}


{--( Config level )-------------------------------------}
const

CL_None    = 0;
CL_Default = 0;
CL_Conf	   = 1;
CL_Options = 2;
CL_Manual  = 10;

{Name}
Name_ExtCBMain 	= 'main';
Name_Meta       = 'META';
Name_MetaPtr    = 'METAPTR';
Name_Self       = 'SELF';
Name_OwnerMeta	= 'OWNERMETA';
Name_StrLength	= 'LENGTH';
Name_New        = 'INIT_OBJECT';
Name_Destroy    = 'DONE_OBJECT';
{config Error}

CE_No_Error           = 0;
CE_Double_Definition  = 1;
CE_Unkown_Config      = 2;


{config constanten}


CONF_Assembler_Options		 = 'ASSEMBLER_OPTIONS';
CONF_Always_Stack_Frame          = 'ALWAYS_STACK_FRAME';
CONF_Print_Register_Res          = 'PRINT_REGISTER_RES';
CONF_Assembler_Path   	         = 'ASSEMBLER_PATH';
CONF_Mangle_Names	         = 'MANGLE_NAMES';
CONF_Object_Path                 = 'OBJECT_PATH';
CONF_Remember_External_Param_Name='REMEMBER_EXTERNAL_PARAM_NAME';
CONF_Auto_Load		         = 'AUTO_LOAD';
CONF_Output_Object_Path	         = 'OUTPUT_OBJECT_PATH';
CONF_Output_Exec_Path            = 'OUTPUT_EXEC_PATH';
CONF_Target_Platform             = 'TARGET_PLATFORM';
CONF_Linker_Path		 = 'LINKER_PATH';
CONF_Linker_Options	         = 'LINKER_OPTIONS';
CONF_Source_Name		 = 'SOURCE_NAME';
CONF_Operating_System		 = 'OPERATING_SYSTEM';
CONF_Source_Ext			 = 'SOURCE_EXTENTION';
CONF_Source_Dir			 = 'SOURCE_DIR';
CONF_Version			 = 'VERSION';
CONF_Run_Assembler		 = 'RUN_ASSEMBLER';
CONF_Can_Use_DLL		 = 'CAN_USE_DLL';
CONF_Compiler_Dir		 = 'COMPILER_DIR';
CONF_Is_Elf_Target       = 'IS_ELF_TARGET';
CNF_Lis_Ext		  		   = '_node.xml';
CNF_Poc_Ext                = '_poc.xml';
CNF_Assem_Ext              = '.asm';
CNF_Object_Ext             = '.obj';
CNF_Unit_Ext               = '.emd';
CNF_Source_Ext             = '.ela';


CNF_Unit_Startup           = '$STARTUP';
CNF_General_MOVE           = '_SYS$MOVE';
CNF_Write                  = 'PUT';
CNF_Write_Nl               = 'PUTNL';
CNF_Startup_Name           = 'ElaStart';


{Hashing}

Hash_Max		= 4091;

{ System afhankelijke constanten }

MN_None = '';

{$ifdef win32}

DEF_Operating_system    = 'win32';
CNF_Exe_Ext		= '.exe';
{$endif}

{$ifdef linux}
DEF_Operating_system    = 'linux';
CNF_Exe_Ext		= '';
{$endif}
var
Min_LOngint :TNumber;
Max_Longint :TNumber;
Min_Cardinal:TNumber;
Max_Cardinal:TNumber;
Min_Short   :TNumber;
Max_Short   :TNumber;
Max_Byte    :TNumber;
Min_Byte    :TNumber;
Max_Word    :TNumber;
Min_Word    :TNumber;
Max_Integer :TNumber;
Min_Integer :TNumber;

type
TLoadUnitState=(Lus_Ok,Lus_Failed,Lus_Not_Found);
TReserveMode=(RSM_Release_On_Use,
RSM_Long_Reservation);


implementation
begin
	LoadInt(Min_LOngint,-2147483647);
	LargeSubLong(Min_Longint,1);
	Loadlong(Max_Longint, 2147483647);
	LoadLong(Min_Cardinal, 0);
	LoadLong(Max_Cardinal,2147483647 * 2+ 1);
	LoadInt(min_Short, -127);
	LoadInt(Max_Short, 128);
	Loadint(Max_Byte ,255);
	LoadInt(Max_Word ,65535);
	LoadInt(Min_Byte , 0);
	LoadInt(Min_Word , 0);
	LoadInt(Min_integer,-32768);
	LoadInt(Max_Integer, 32767);
	
end.
