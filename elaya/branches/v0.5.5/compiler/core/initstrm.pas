{
   Elaya, the compiler for the elaya language
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

unit InitStrm;


interface
uses  ddefinit,meta,classes,elacons,streams,frames,Module,procs,types,vars,varbase,params,doperfun,cdfills,extern,cblkbase,globlist;

procedure InitStreams;
procedure DoneStreams;
implementation

procedure InitStreams;
begin
	vgObjectStreamList := TObjectStreamList.Create;
	AddObjectToStreamList(longint(IC_ParamVar),(TParameterVar));
	AddObjectToStreamList(longint(IC_LOcalVar),(TLocalVar));
	AddObjectToStreamList(longint(iC_Procedure),(TProcedureObj));
	AddObjectToStreamList(longint(IC_Function),(TFunction));
	AddObjectToStreamList(longint(IC_Constant),TConstant);
	AddObjectToStreamList(longint(IC_IntCons),(TEnumCOns));
	AddObjectToStreamList(longint(IC_Variable),(TVariable));
	AddObjectToStreamList(longint(IC_Record),(TRecordType));
	AddObjectToStreamList(longint(IC_StringType),(TStringType));
	AddObjectToStreamList(longint(IC_CharType),(TCharType));
	AddObjectToStreamList(longint(Ic_EnumType),(TEnumType));
	AddObjectToStreamList(longint(Ic_Number),(TNumberType));
	AddObjectToStreamList(longint(Ic_TypeAs),(TTypeAs));
	AddObjectToStreamList(longint(IC_PtrType),(TPtrType));
	AddObjectToStreamList(longint(IC_ArrayType),(TArrayType));
	AddObjectToStreamList(longint(Ic_Unit),(TUnit));
	AddObjectToStreamList(longint(IC_StartupProc),TStartupProc);
	AddObjectToStreamList(longint(IC_AsciizType),(TAsciizType));
	AddObjectToStreamList(longint(IC_StringCons),(TStringCons));
	AddObjectToStreamList(longint(IC_VoidType),(TVoidType));
	AddObjectToStreamList(longint(IC_RoutineType),TRoutineType);
	AddObjectToStreamList(longint(IC_Union),(TUnionType));
	AddObjectToStreamList(longint(IC_ObjectFile),(TCodeObjectItem));
	AddObjectToStreamList(longint(IC_ExternLibFileWindows),(TExternalLibraryObjectWindows));
	AddObjectToStreamList(longint(IC_ExternObjFIle),(TExternalObjectFileObject));
	AddObjectToStreamList(longint(IC_ExternLibIntWindows),(TExternalLibraryInterfaceWindows));
	AddObjectToStreamList(longint(IC_ExternObjInt),(TExternalObjectFileInterface));
	AddObjectToStreamList(longint(IC_RoutineCollection),(TRoutineCollection));
	AddObjectToStreamList(longint(IC_RTLParameter),TRTLParameter);
	AddObjectToStreamList(longint(IC_OperatorFunction),TOperatorFunction);
	AddObjectToStreamList(longint(IC_Meta),TRoutineMeta);
	AddObjectToStreamList(longint(IC_VmtList),TVmtList);
	AddObjectToStreamList(longint(IC_VmtItem),TVmtItem);
	AddObjectToStreamList(longint(IC_FrameParameter),TFrameParameter);
	AddObjectToStreamList(longint(IC_Frame),TFrame);
	AddObjectToStreamList(longint(IC_FrameVariable),TFrameVariable);
	AddObjectToStreamList(longint(IC_ConstantMapping),TConstantParameterMappingItem);
	AddObjectTOStreamList(longint(IC_VariableMapping),TVariableParameterMappingItem);
	AddObjectToStreamList(longint(IC_NormalMapping),TNormalParameterMappingItem);
	AddObjectToStreamList(longint(IC_LocalFrameVar),TLocalMetaVar);
	AddObjectToStreamList(longint(IC_GlobalItem),TGlobalItem);
	AddObjectToStreamList(longint(IC_ClassType),TClassType);
	AddObjectToStreamList(Longint(IC_ClassFrameParameter),TClassFrameParameter);
	AddObjectToStreamList(longint(IC_Constructor),TConstructor);
	AddObjectToStreamList(longint(IC_Destructor),TDestructor);
	AddObjectToStreamList(longint(IC_Class_Meta),TClassMeta);
	AddObjectToStreamList(Longint(IC_Object_Representor),TObjectRepresentor);
	AddObjectToStreamList(Longint(IC_Fixed_Frame_Parameter),TFixedFrameParameter);
	AddObjectToStreamList(longint(IC_Property),TProperty);
	AddObjectTOStreamList(longint(IC_Property_Item),TPropertyItem);
	AddObjectToStreamList(longint(IC_EnumCons),TEnumCons);
	AddObjectToStreamList(longint(IC_BooleanType),TBooleanType);
	AddObjectToStreamList(longint(IC_EnumCollection),TEnumCollection);
end;

procedure DoneStreams;
begin
	vgObjectStreamList.destroy;
end;

begin
	
end.

