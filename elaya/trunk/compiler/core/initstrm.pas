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
uses  meta,classes,elacons,streams,frames,Module,procs,types,vars,varbase,params,doperfun,cdfills,extern,cblkbase,globlist;

procedure InitStreams;
procedure DoneStreams;
implementation

procedure InitStreams;
begin
	vgObjectStreamList := TObjectStreamList.Create;
	AddObjectToStreamList(IC_ParamVar,(TParameterVar));
	AddObjectToStreamList(IC_LOcalVar,(TLocalVar));
	AddObjectToStreamList(iC_Procedure,(TProcedureObj));
	AddObjectToStreamList(IC_Function,(TFunction));
	AddObjectToStreamList(IC_Constant,TConstant);
	AddObjectToStreamList(IC_IntCons,(TEnumCOns));
	AddObjectToStreamList(IC_Variable,(TVariable));
	AddObjectToStreamList(IC_Record,(TRecordType));
	AddObjectToStreamList(IC_StringType,(TStringType));
	AddObjectToStreamList(IC_CharType,(TCharType));
	AddObjectToStreamList(Ic_EnumType,(TEnumType));
	AddObjectToStreamList(Ic_Number,(TNumberType));
	AddObjectToStreamList(Ic_TypeAs,(TTypeAs));
	AddObjectToStreamList(IC_PtrType,(TPtrType));
	AddObjectToStreamList(IC_ArrayType,(TArrayType));
	AddObjectToStreamList(Ic_Unit,(TUnit));
	AddObjectToStreamList(IC_StartupProc,TStartupProc);
	AddObjectToStreamList(IC_AsciizType,(TAsciizType));
	AddObjectToStreamList(IC_StringCons,(TStringCons));
	AddObjectToStreamList(IC_VoidType,(TVoidType));
	AddObjectToStreamList(IC_RoutineType,TRoutineType);
	AddObjectToStreamList(IC_Union,(TUnionType));
	AddObjectToStreamList(IC_ObjectFile,(TCodeObjectItem));
	AddObjectToStreamList(IC_ExternLibFileWindows,(TExternalLibraryObjectWindows));
	AddObjectToStreamList(IC_ExternObjFIle,(TExternalObjectFileObject));
	AddObjectToStreamList(IC_ExternLibIntWindows,(TExternalLibraryInterfaceWindows));
	AddObjectToStreamList(IC_ExternObjInt,(TExternalObjectFileInterface));
	AddObjectToStreamList(IC_RoutineCollection,(TRoutineCollection));
	AddObjectToStreamList(IC_RTLParameter,TRTLParameter);
	AddObjectToStreamList(IC_OperatorFunction,TOperatorFunction);
	AddObjectToStreamList(IC_Meta,TRoutineMeta);
	AddObjectToStreamList(IC_VmtList,TVmtList);
	AddObjectToStreamList(IC_VmtItem,TVmtItem);
	AddObjectToStreamList(IC_FrameParameter,TFrameParameter);
	AddObjectToStreamList(IC_Frame,TFrame);
	AddObjectToStreamList(IC_FrameVariable,TFrameVariable);
	AddObjectToStreamList(IC_ConstantMapping,TConstantParameterMappingItem);
	AddObjectTOStreamList(IC_VariableMapping,TVariableParameterMappingItem);
	AddObjectToStreamList(IC_NormalMapping,TNormalParameterMappingItem);
	AddObjectToStreamList(IC_LocalFrameVar,TLocalMetaVar);
	AddObjectToStreamList(IC_GlobalItem,TGlobalItem);
	AddObjectToStreamList(IC_ObjectClassType,TObjectClassType);
	AddObjectToStreamList(IC_ValueClassType,TValueClassType);
	AddObjectToStreamList(IC_ClassFrameParameter,TClassFrameParameter);
	AddObjectToStreamList(IC_Constructor,TConstructor);
	AddObjectToStreamList(IC_Destructor,TDestructor);
	AddObjectToStreamList(IC_Class_Meta,TClassMeta);
	AddObjectToStreamList(IC_Object_Representor,TObjectRepresentor);
	AddObjectToStreamList(IC_Fixed_Frame_Parameter,TFixedFrameParameter);
	AddObjectToStreamList(IC_Property,TProperty);
	AddObjectTOStreamList(IC_Property_Item,TPropertyItem);
	AddObjectToStreamList(IC_EnumCons,TEnumCons);
	AddObjectToStreamList(IC_BooleanType,TBooleanType);
	AddObjectToStreamList(IC_EnumCollection,TEnumCollection);
	AddObjectToStreamList(IC_ConstantVariable,TConstantVariable);
	AddObjectToStreamList(IC_UnionFrameVariable,TUnionFrameVariable);
	AddObjectToStreamList(IC_NamendCodeBlock,TNamendCodeBlock);
end;

procedure DoneStreams;
begin
	vgObjectStreamList.destroy;
end;

begin

end.

