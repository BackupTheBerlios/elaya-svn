{ 5~5~                                                   5;3~
    Elaya, the compiler for the elasya language
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

unit classes;
interface
uses meta,varbase,elacfg,confval,elatypes,params,strmbase,macobj,
	node,frames,elacons,compbase,cblkbase,types,display,formbase,streams,
	asminfo,error,ddefinit,ndcreat,procs,largenum,stdobj,asmcreat,asmdata,
	linklist;
	
type
	
	TClassMeta=class(TMeta)
	private
		voClassSize : TSize;
		voVmtItem   : TVmtItem;
		
		property iVmtItem   : TVmtItem read voVmtItem write voVmtItem;
		property iClassSize : TSize read voClassSize write voClassSize;
	protected
		procedure   Commonsetup;override;

	public
		property fVmtItem   : TVmtItem read voVmtItem write voVmtItem;
		property fClassSize : TSize read voClassSize write voClassSize;
		
		function    GetVmtOffsetBegin:TOffset;override;
		procedure   CreatePreDB(ParCre : TCreator);override;
		function    CreateObjectPointerNode(ParCre:TCreator;ParContext : TDefinition):TNodeIdent;override;
		function    CreateMac(ParContext,ParCContext :TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		function 	SaveItem(ParStream : TObjectStream):boolean;override;
		function    LoadItem(ParStream : TObjectStream):boolean;override;
		procedure   InitVirtual(ParMetaContext : TDefinition;ParVmtItem : TVmtItem);
	end;
	
	TObjectRepresentor=class;
	
	TClassType=class(TTYpe)
	private
		voParent    : TClassType;
		voMeta      : TClassMeta;
		voFrame     : TFrame;
		voMetaFrame : TFrame;
		voObject    : TObjectRepresentor;
		voIncompleet: boolean;
		voPtrType   : TType;
	protected
		property iParent    : TClassType         read voParent     write voParent;
		property iMeta      : TClassMeta         read voMeta       write voMeta;
		property iFrame     : TFrame             read voFrame      write voFrame;
		property iMetaFrame : TFrame             read voMetaFrame  write voMetaFrame;
		property iObject    : TObjectRepresentor read voObject     write voObject;
		property iIncompleet: boolean			     read voIncompleet write voIncompleet;
		property iPtrType   : TType              read voPtrType    write voPtrType;
		procedure SetParent(ParType :TClassTYpe);virtual;
	protected
		procedure Commonsetup;override;
		procedure Clear;override;

	public
		property fParent    : TClassType         read voParent write SetParent;
		property fMeta      : TClassMeta         read voMeta;
		property fFrame     : TFrame             read voFrame;
		property fMetaFrame : TFrame             read voMetaFrame;
		property fObject    : TObjectRepresentor read voObject;
		property fInCompleet: boolean            read voInCompleet write voInCompleet;

		procedure Print(ParDis : TDisplay);override;
		function SaveItem(ParStream : TObjectStream):boolean;override;
		function LoadItem(PArStream : TObjectStream):boolean;override;
		function  GetPtrByName(const ParName:string;ParOption : TSearchOptions;var ParOwner,ParItem:TDefinition):boolean;override;
		function  Can(ParCan : TCan_Types):boolean;override;
		procedure DoneDotFrame;override;
		procedure DoneClassDotFrame;
		procedure InitClassDotFrame(ParCre : TSecCreator;ParContext : TDefinition);
		function  CreateVar(ParCre:TCreator;const ParName:string;ParType:TDefinition):TDefinition;override;
		function  GetPtrInCurrentList(const ParName : string;var ParOwner,ParItem :TDefinition):boolean;override;
		function  CreateDB(ParCre:TCreator):boolean;override;
		procedure GetOVData(ParCre :TCreator;ParRoutine : TDefinition;var ParOther :TDefinition;var ParModes : TOVModes;var ParMeta : TDefinition);override;
		procedure ConsiderForward(ParCre : TCreator;ParIn : TDefinition;var ParOut : TDefinition);override;
		procedure SetMetaFramePtr(ParCre : TCreator);virtual;
		function MustNameAddAsOwner : boolean;override;
		function GetClassSize : TSize;
		function GetParent : TDefinition;override;
		function CreateReadNode(parCre:TCreator;ParContext : TDefinition):TFormulaNode;override;
		function GetPtrByObject(const ParName : string;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;override;
		procedure FinishClass;
		function CanWriteWith(ParExact : boolean;ParType : TType):boolean;override;
		function GetRelativeLevel : cardinal;override;
		function SearchOwner:boolean;override;

		constructor Create(ParSize : TSize;ParParent : TClassType;ParInCompleet : boolean);

		{Is functions}
		function  IsVirtual:boolean;
		function  IsIsolated : boolean;override;
		procedure InitVirtualMeta(ParVmtItem : TVmtItem);
		procedure PrintDefinitionBody(ParDis : TDisplay);override;
	end;

	TValueClassType=class(TClassType)
	protected
		procedure Commonsetup;override;
		procedure SetParent(ParType : TClassTYpe);override;

	public
		procedure AddParameterToNested(ParCre : TCreator;ParNested :TDefinition);override;
		procedure InitDotFrame(ParCre : TSecCreator;ParNode : TNodeIdent;ParContext :TDefinition);override;
		constructor Create(ParParent : TClassType;ParInCompleet : boolean);
		function  CreateVar(ParCre:TCreator;const ParName:string;ParType:TDefinition):TDefinition;override;
		function LoadItem(ParStream : TObjectStream) : boolean;override;
		function SaveItem(ParStream : TObjectStream) : boolean;override;

   end;

	TObjectClassType=class(TClassType)
	private
		voMetaPtr   : TFrameVariable;
	protected
		property iMetaPtr   : TFrameVariable     read voMetaPtr    write voMetaPtr;

		procedure Commonsetup;override;
	public

		property fMetaPtr   : TFrameVariable     read voMetaPtr;

		function  SaveItem(ParStream : TObjectStream):boolean;override;
		function  LoadItem(PArStream : TObjectStream):boolean;override;
		procedure InitDotFrame(ParCre : TSecCreator;ParNode : TNodeIdent;ParContext :TDefinition);override;
		procedure AddParameterToNested(ParCre : TCreator;ParNested :TDefinition);override;
		procedure SetMetaFramePtr(ParCre : TCreator);override;
		constructor Create(ParParent : TClassType;ParInCompleet : boolean);
	end;
	
	TObjectRepresentor=class(TVariable)
	private
		voClass :TClassType;
		property iClass : TClassType read voClass write voClass;
	public
		property fClass : TClasstype read voClass;
		constructor create(const ParName : string;ParClass :TClassType);
		function SaveItem(ParStream : TObjectStream):boolean;override;
		function LoadItem(PArStream : TObjectStream):boolean;override;
		function GetParent : TObjectRepresentor;override;
		function GetAccessLevelTo(ParOther : TDefinition) : TDefAccess;override;
        function GetPtrByName(const ParName:string;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : boolean;override;
		function GetPtrByObject(const ParName:string;ParObject : TRoot;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : TObjectFindState;override;
	end;
	
	TCDTorsRoutine = class(TReturnRoutine)
	public
		procedure ValidateSelf(ParCre : TNDCreator);override;
	end;

	TConstructor = class(TCDTorsRoutine)
	protected
		procedure ValidateOverrideVirtTest(ParCre : TNDCreator;ParOther : TRoutine);override;
		procedure Commonsetup;override;

	public
		procedure CreatePreCode(ParCre : TNDCreator);override;
		procedure CreatePostCode(ParCre : TNDCreator);override;
		function  CreateNewCB(ParCre : TCreator;const ParName : string) : TRoutine;override;
      function    NeedReadableRecord : boolean;override;
	end;
	
	TDestructor = class(TCDTorsRoutine)
	protected
		procedure Commonsetup;override;
	public
		function MustSeperateInitAndMain : boolean;override;
		function GetInheritedAddress : TRoutine;override;
		procedure CreatePostCode(ParCre : TNDCreator);override;
		
	end;
	

	TPropertyItem=class(TListItem)
	private
		voAccess	   : TDefAccess;
		voPropertyType : TPropertyType;
		voIdent		   : TFormulaDefinition;
		voOwner		   : TDefinition;
	protected
		property iAccess       : TDefAccess    read voAccess write voAccess;
		property iPropertyType : TPropertyType read voPropertyType write voPropertyType;
		property iIdent        : TFormulaDefinition   read voIdent        write voIdent;
		property iOwner        : TDefinition   read voOwner 	   write voOwner;
	public
		property fAccess 	   : TDefAccess    read voAccess;
		constructor Create(ParAccess : TDefAccess;ParPropertyType : TPropertyType;ParIdent :TFormulaDefinition;ParOwner : TDefinition);
		function IsItem(parAccess : TDefAccess;ParPropertyType : TPropertyType) : boolean;
		function CreateReadNode(ParCre : TNDCreator;ParOWner : TDefinition) : TFormulaNode;
		function CreateWriteNode(ParCre : TNDCreator;ParOwner : TDefinition;ParValue : TFormulaNode):TFormulaNode;
		function CreateWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;
		function SaveItem(ParStream : TObjectStream):boolean;override;
		function LoadItem(ParStream : TObjectStream):boolean;override;
	end;

	TPropertyItemList=class(TList)
	public
		function GetItem(ParAccess : TDefAccess;ParType : TPropertyType) :TPropertyItem;
		procedure AddItem(ParCre :TNDCreator;ParAccess : TDefAccess;ParType : TPropertyType;ParIdent : TFormulaDefinition;ParOwner : TDefinition);
	end;

	TProperty=class(TVarBase)
	private
		voItemList : TPropertyItemList;
	protected
		property iItemList : TPropertyItemList read voItemList write voItemList;
		function GetItem(ParAccess : TDefAccess;ParType : TPropertyType) :TPropertyItem;
		procedure Commonsetup;override;
		procedure Clear;override;
	public
		procedure AddPropertyItem(ParCre : TNDCreator;ParAccess : TDefAccess;ParType : TPropertyType;ParIdent:TFormulaDefinition;ParOwner : TDefinition);
		function  CreateReadNode(ParCre : TCreator;ParOWner : TDefinition) : TFormulaNode;override;
		function  CreateWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue : TFormulaNode):TFormulaNode;override;
		function  CreateWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;override;
		function  SaveItem(ParStream : TObjectStream):boolean;override;
		function  LoadItem(ParStream : TObjectStream):boolean;override;
	end;





implementation

uses nif,execobj,stmnodes;




{---( TProperty )-----------------------------------------------------------------------}


function TProperty.SaveItem(ParStream : TObjectStream):boolean;
begin
	if Inherited SaveItem(ParStream) then exit(true);
	if iItemList.SaveItem(ParStream) then exit(true);
	exit(false);
end;

function TProperty.LoadItem(ParStream : TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if iItemList.LoadItem(ParStream) then exit(true);
	exit(false);
end;

procedure TProperty.Commonsetup;
begin
	inherited Commonsetup;
	iItemList := TPropertyItemList.Create;
	iAccess := [Can_Read,CAN_Write];
end;

procedure TProperty.Clear;
begin
	inherited Clear;
	if iItemList <> nil then iItemList.Destroy;
end;

procedure TProperty.AddPropertyItem(ParCre : TNDCreator;ParAccess : TDefAccess;ParType : TPropertyType;ParIdent : TFormulaDefinition;ParOwner : TDefinition);
var
	vlType : TType;
begin
	if ParIdent <> nil then begin
		ParIdent.SetAllwaysSave;
		if ParIdent is TVarBase then begin
			vlType := TVarBase(ParIdent).fType;
		end else if (ParIdent is TRoutineCollection) then begin

			vlType := TRoutineCollection(ParIdent).GetType;
			TRoutineCollection(ParIdent).ValidatePropertyProcComp(ParCre,ParType = PT_Write,fTYpe);
		end else begin
			ParCre.ErrorDef(Err_Wrong_Kind_ident_for_prop,ParIdent);
			vlType := nil;
		end;

		if (vlType <> nil) and not(vlTYpe.IsExactSame(fType)) then ParCre.ErrorDef(Err_Type_Differes_from_prop,vlType);
	end;

	iItemList.AddItem(ParCre,ParAccess,ParType,parIdent,ParOwner);
end;

function TProperty.Getitem(ParAccess:TDefAccess;ParType : TPropertyType):TPropertyItem;
begin
	exit(iItemList.GetItem(ParAccess,ParType));
end;

function TProperty.CreateReadNode(ParCre : TCreator;ParOWner : TDefinition) : TFormulaNode;
var
	vlItem  : TPropertyItem;
	vlLevel : TDefAccess;
begin
	if ParOwner = nil then begin
		vlLevel := AF_Public;
	end else begin
		vlLevel := ParOwner.GetAccessLevelTo(TNDCreator(ParCre).GetCurrentDefinition);
	end;
	vlItem := GetItem(vlLevel,PT_Read);
	if (vlItem <> nil) then begin
        exit(vlItem.CreateReadNode(TNDCreator(ParCre),ParOwner));
	end else begin
		TNDCreator(ParCre).SemError(Err_Cant_Read_From_Expr);
		exit(nil);
	end;
end;

{TODO: destroy of value not}
function TProperty.CreateWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue : TFormulaNode):TFormulaNode;
var
	vlItem  : TPropertyItem;
	vlNode  : TFormulaNode;
	vlLEvel : TDefAccess;
begin
	if ParOwner = nil then begin
		vlLevel := AF_Public;
	end else begin
		vlLevel := ParOwner.GetAccessLevelTo(TNDCreator(ParCre).GetCurrentDefinition);
	end;
	vlItem := GetItem(vlLevel,PT_Write);
	if (vlItem <> nil) then begin
        vlNode := vlItem.CreateWriteNode(TNDCreator(ParCre),ParOwner,ParValue);
	end else begin
		TNDCreator(ParCre).ErrorDef(Err_Cant_Write_To_Item,self);
		vlNode := nil;
	end;
	if vlNode =nil then begin
		if ParValue <> nil then ParValue.Destroy;
	end;
	exit(vlNode);
end;

function   TProperty.CreateWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;
var
	vlItem  : TPropertyItem;
	vlNode  : TFormulaNode;
	vlLEvel : TDefAccess;
begin
	if ParOwner = nil then begin
		vlLevel := AF_Public;
	end else begin
		vlLevel := ParOwner.GetAccessLevelTo(TNDCreator(ParCre).GetCurrentDefinition);
	end;
	vlItem := GetItem(vlLevel,PT_Write);
	if (vlItem <> nil) then begin
        vlNode := vlItem.CreateWriteDotNode(TNDCreator(ParCre),ParLeft,ParSource,ParOwner);
	end else begin
		TNDCreator(ParCre).ErrorDef(Err_Cant_Write_To_Item,self);
		vlNode := nil;
	end;
	if vlNode =nil then begin
		if ParSource <> nil then ParSource.Destroy;
	end;
	exit(vlNode);
end;


{---( TPropertyItem )---------------------------------------------------------------}


function 	TPropertyItem.SaveItem(ParStream : TObjectStream):boolean;
begin
    if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WriteLong(cardinal(iAccess)) then exit(true);
	if ParStream.Writelong(cardinal(iPropertyType)) then exit(true);
	if ParStream.WritePi(iIdent) then exit(true);
	if ParStream.WritePi(iOwner) then exit(true);
	exit(false);
end;

function TPropertyItem.LoadItem(ParStream : TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadLong(cardinal(voAccess)) then exit(true);
	if ParStream.ReadLong(cardinal(voPropertyType)) then exit(true);
	if ParStream.ReadPi(voIdent) then exit(true);
	if ParStream.ReadPi(voOwner) then exit(true);
	exit(false);
end;


constructor TPropertyItem.Create(ParAccess : TDefAccess;ParPropertyType : TPropertyType;ParIdent: TFormulaDefinition;ParOwner : TDefinition);
begin
	inherited Create;
	iAccess       := ParAccess;
	iPropertyType := ParPropertyType;
	iIdent        := ParIdent;
	iOwner        := ParOwner;
end;


function TPropertyItem.IsItem(parAccess : TDefAccess;ParPropertyType : TPropertyType) : boolean;
begin
	exit(((iAccess = ParAccess) or IsLessPublicAs(ParAccess,iAccess)) and (iPropertyType = ParPropertyType));
end;

function TPropertyItem.CreateReadNode(ParCre : TNDCreator;ParOWner : TDefinition) : TFormulaNode;
var
	vlNode   : TFormulaNode;
	vlCur    : TDefinition;

begin
	vlNode := nil;
	if iIdent <> nil then begin
		vlNode := iIdent.CreateReadNode(ParCre,ParOwner);
		if (vlNode is TCallNode) then begin
			vlCur := ParCre.GetCurrentDefinition;
			if  (vlCur <> nil) and vlCur.HasOwner(iIdent) then ParCre.ErrorDef(Err_Recrusive_Call_in_prop,iIdent);
		end;
	end;
	exit(vlNode);
end;

function TPropertyItem.CreateWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;
var
	vlNode : TFormulaNode;
	vlCur  : TDefinition;
begin
	if(iIdent = nil) then exit(nil);
	vlNode := iIdent.CreatePropertyWriteDotNode(ParCre,ParLeft,ParSource,ParOwner);
	vlCur := TNDCreator(ParCre).GetCurrentDefinition;
	if  (vlCur <> nil) and vlCur.HasOwner(iIdent) then TNDCreator(ParCre).ErrorDef(Err_Recrusive_Call_in_prop,iIdent);
	exit(vlNode);
end;


function TPropertyItem.CreateWriteNode(ParCre : TNDCreator;ParOwner : TDefinition;ParValue : TFormulaNode) : TFormulaNode;
var
	vlNode : TFormulaNode;
	vlCur  : TDefinition;
begin
	if(iIdent = nil) then exit(nil);
	vlNode := iIdent.CreatePropertyWriteNode(ParCre,ParOwner,ParValue);
	vlCur := ParCre.GetCurrentDefinition;
	if  (vlCur <> nil) and vlCur.HasOwner(iIdent) then ParCre.ErrorDef(Err_Recrusive_Call_in_prop,iIdent);
	exit(vlNode);
end;


{---( TPropertyList )---------------------------------------------------------------}
function TPropertyItemList.GetItem(ParAccess : TDefAccess;ParType : TPropertyType) : TPropertyItem;
var
	vlCurrent : TPropertyItem;
begin
	vlCurrent := TPropertyItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsItem(ParAccess,ParType)) do vlCurrent := TPropertyItem(vlCurrent.fNxt);
	exit(vlCurrent);
end;

procedure TPropertyItemList.AddItem(ParCre :TNDCreator;ParAccess : TDefAccess;ParType : TPropertyType;ParIDent : TFormulaDefinition;ParOwner : TDefinition);
var
	vlAt   : TPropertyItem;
begin
	vlAt := GetItem(ParAccess,ParType);
	if vlAt <> nil then begin
		if vlAt.fAccess = ParAccess then ParCre.SemError(Err_Duplicate_Ident);
		vlAt := TPropertyItem(vlAt.fPrv);
	end;
	if vlAt = nil  then vlAt := TPropertyItem(fTop);
	InsertAt(vlAt,TPropertyItem.Create(ParAccess,ParType,ParIdent,ParOwner));
end;

{---( TObjectRepresentator )-------------------------------------------------------------}

function TObjectRepresentor.GetParent : TObjectRepresentor;
var
	vlParentClass : TClassType;
begin
	if fType <> nil then begin
		vlParentClass := TClassType(fType).fParent;
		if vlParentClass <> nil then begin
			exit(vlParentClass.fObject);
		end;
	end;
	exit(Nil);
end;


constructor TObjectRepresentor.create(const ParName : string;ParClass :TClassType);
begin
	inherited Create(ParName,ParClass);
	iClass := ParClass;
end;

function TObjectRepresentor.SaveItem(ParStream : TObjectStream):boolean;
begin
	if inherited SaveItem(parStream) then exit(true);
	if ParStream.WritePi(iClass) then exit(true);
	exit(false);
end;

function TObjectRepresentor.LoadItem(PArStream : TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadPi(voClass) then exit(true);
	exit(false);
end;


function TObjectRepresentor.GetAccessLevelTo(ParOther : TDefinition) : TDefAccess;
begin
	exit(fType.GetAccessLevelTo(ParOther));
end;


function TObjectRepresentor.GetPtrByName(const ParName:string;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : boolean;
var
	vlFlag : boolean;
begin
	ParOwner := nil;
	ParItem  := nil;
	vlFlag  := false;
	if fType <> nil then begin
		vlFlag := (fType.GetPtrByName(ParName,ParOption,ParOwner,ParItem));
	end;
	if fType = parOwner then ParOwner := self;
	exit(vlFlag);
end;

function TObjectRepresentor.GetPtrByObject(const ParName:string;ParObject : TRoot;ParOption  : TSearchOptions;var ParOwner,ParItem : TDefinition) : TObjectFindState;
var
	vlFlag : TObjectFindState;
begin
	ParOwner := nil;
	ParItem  := nil;
	vlFlag   := OFS_Different;
	if fType <> nil then begin
		vlFlag := (fType.GetPtrByObject(ParName,ParObject,ParOption,ParOwner,ParItem));
	end;
	if fType = parOwner then ParOwner := self;
	exit(vlFlag);
end;

{---( TCDTorsRoutine )--------------------------------------------------------------------}

procedure TCDTorsRoutine.ValidateSelf(ParCre : TNDCreator);
begin
	if RTM_Isolate in fRoutineModes then ParCre.ErrorDef(Err_CD_Cant_be_isolated,self);
	if(RTS_ForwardDefined in fRoutineStates) and (fDefAccess <> AF_Public) then ParCre.ErrorDef(Err_CD_Must_Be_Public,self);
end;



{---( TClassMeta )---------------------------------------------------------------------------------}


function TClassMeta.SaveItem(ParStream : TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WritePi(iVmtITem) then exit(true);
	exit(False);
end;

function TClassMeta.LoadItem(ParStream : TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadPi(voVmtItem) then exit(true);
	exit(False);
end;

procedure  TClassMeta.Commonsetup;
begin
	inherited Commonsetup;
	iVmtItem := nil;
end;

function    TClassMeta.GetVmtOffsetBegin:TOffset;
begin
	exit(OFS_CLass_Vmt_Begin);
end;
	
procedure TClassMeta.CreatePreDB(ParCre : TCreator);
begin
	TAsmCreator(ParCre).AddData(TGenLongDef.Create(Dat_code,TNumberDataDef.Create(iClassSize)));
end;

function  TClassMeta.CreateObjectPointerNode(ParCre:TCreator;ParContext : TDefinition):TNodeIdent;
begin
	if iVmtItem = nil then begin
		exit(inherited CreateObjectPointerNode(ParCre,PArContext));
	end else begin
		exit(TFormulaNode(iVmtItem.CreateReadNode(ParCre,ParContext.GetRealOwner)));
	end;
end;
	
procedure TClassMeta.InitVirtual(ParMetaContext : TDefinition;ParVmtItem : TVmtItem);
begin
	iVmtItem := parVmtItem;
	iMetaFrame.AddAddressing(MCO_ValuePointer,ParMetaContext,TClassType(ParMetaContext).fObject,ParMetaContext,iAccessAddress,false);
end;

function  TClassMeta.CreateMac(ParContext,ParCContext :TDefinition;ParOption:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlByPtr  : TMacBase;
begin
	if (iVmtItem = nil)   then begin
		exit(inherited CreateMac(ParContext,ParCContext,ParOption,ParCre));
	end else begin
		if (ParOption <> MCO_ObjectPointer) and (ParOption <> MCO_Valuepointer) then fatal(FAT_Invalid_Rec_Option,['Value=',cardinal(ParOption)]);
		vlByPtr := iVmtItem.CreateMac(ParCContext,MCO_Result,ParCre);
		vlByPtr.SetSize(GetAssemblerInfo.GetSystemSize);
		exit(vlByPtr);
	end;
end;

{---( TObjectClassType )---------------------------------------------------------------------------}

procedure TObjectClassType.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_ObjectClassType;
	iMetaPtr   := nil;
end;

procedure  TObjectClassType.InitDotFrame(ParCre : TSecCreator;ParNode : TNodeIdent;ParContext :TDefinition);
var
	vlMac : TMacBase;
begin
	vlMac := ParNode.CreateMac(MCO_Result,ParCre);
	iFrame.AddAddressing(self,self,vlMac,true);
	if not IsVirtual then iMetaFrame.AddAddressing(self,self,iMeta.CreateMac(self,ParContext,MCO_ValuePointer,ParCre),true);
	iMeta.AddAddressing(self,iMetaPtr,false);
end;

procedure TObjectClassType.AddParameterToNested(ParCre : TCreator;ParNested :TDefinition);
var
	vlParameter : TFrameParameter;
	vlParameterMeta : TFrameParameter;
	vlRoutine   : TRoutine;
	vlPtrType   : TType;
	vlTranType  : TParamTransferType;
	vlPtr       : TVarBase;
	vlMeta      : TMeta;
	vlFrame     : TFrame;
begin
	vlRoutine := TRoutine(ParNested);
	if not vlRoutine.IsInheritedInHyr(self) then begin
		if(ParNested is TConstructor) then begin
			vlPtrType := TNDCReator(ParCre).GetCheckDefaultType(DT_Pointer,0,false,'pointer');
         vlFrame := iMetaFrame;
			vlParameterMeta := TFrameParameter.Create(Name_MetaPtr,1,vlRoutine.fParameterFrame,vlFrame,vlPtrType,PV_Value,RTM_extended in vlRoutine.fRoutineModes);

			vlRoutine.AddParam(vlParameterMeta);
		end;
		vlPtr      := iMetaPtr;
		vlTranType := PV_Value;
		vlMeta     := fMeta;
		vlParameter := TClassFrameParameter.Create(Name_Self,vlMeta,vlPtr,vlRoutine.fParameterFrame,fFrame,self,vlTranType,RTM_extended in vlRoutine.fRoutineModes);
		vlRoutine.AddParam(vlParameter);
	end;
end;

procedure TObjectClassType.SetMetaFramePtr(ParCre : TCreator);
var
	vlMfType     : TType;
begin
	inherited SetMetaFramePtr(ParCre);
	if(iParent = nil) then begin
		vlMfType := TNDCReator(ParCre).GetCheckDefaultType(DT_Pointer,0,false,'pointer');
		iMetaPtr := TFrameVariable(CreateVar(ParCre,Name_Meta,vlMfType));
		iMetaPtr.fDefAccess := AF_Public;
		AddIdent(iMetaptr);
	end else begin
		iMetaPtr := TObjectClassType(iParent).iMetaPtr; {TODO::MUST check parent is objectclass}
	end;
end;


function TObjectClassType.SaveItem(ParStream : TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.Writepi(iMetaPtr) then exit(true);
	exit(false);
end;

function TObjectClassType.LoadItem(PArStream : TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadPi(voMetaPtr) then exit(true);
	exit(false);
end;


constructor TObjectClassTYpe.Create(ParParent : TClassType;ParInCompleet:boolean);
begin
	inherited Create(GetAssemblerInfo.GetSystemSize,ParParent,ParInCompleet);
end;

{---( TValueClassType )----------------------------------------------------------------------------}

procedure TValueClassType.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_ValueClassType;
	iPtrType   := nil;
end;

procedure TValueClassType.AddParameterToNested(ParCre : TCreator;ParNested :TDefinition);
var
	vlParameter : TFrameParameter;
	vlClassParam : TClassFrameParameter;
	vlRoutine   : TRoutine;
	vlPtrType   : TType;
begin
	vlRoutine := TRoutine(ParNested);
	if not vlRoutine.IsInheritedInHyr(self) then begin
		vlPtrType := TNDCReator(ParCre).GetCheckDefaultType(DT_Pointer,0,false,'pointer');
		vlParameter := TFrameParameter.Create(Name_MetaPtr,1,vlRoutine.fParameterFrame,fMeta.fMetaframe,vlPtrType,PV_Value,RTM_extended in vlRoutine.fRoutineModes);
		vlRoutine.AddParam(vlParameter);
		if(iPtrType=nil) then begin
			iPtrType := TPtrType.Create(self,not(RTM_Write_mode in vlRoutine.fRoutineModes));
		end;
		vlClassParam := TClassFrameParameter.Create(Name_Self,nil,nil,vlRoutine.fParameterFrame,fFrame,iPtrType,PV_Value,RTM_extended in vlRoutine.fRoutineModes);
		vlClassParam.fConstant := not(RTM_Write_Mode in vlRoutine.fRoutineModes);
		vlRoutine.AddParam(vlClassParam);
	end;
end;

function TValueClassType.SaveItem(ParStream : TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
   if ParStream.WriteBoolean(iPtrType <> nil) then exit(true);
	if iPtrType <> nil then begin
		if iPtrType.SaveItem(ParStream) then exit(true);
	end;
	exit(false);
end;

function TValueClassType.LoadItem(ParStream : TObjectStream) : boolean;
var
	vlBool : boolean;
	vlType : TType;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadBoolean(vlBool) then exit(true);
	if vlBool then begin
		if CreateObject(ParStream,vlType) <> STS_Ok then exit(true);
		iPtrType := vlType;
	end;
end;

procedure  TValueClassType.InitDotFrame(ParCre : TSecCreator;ParNode : TNodeIdent;ParContext :TDefinition);
var
	vlMac : TMacBase;
	vlOfs  : TMemOfsMac;
begin
	vlMac := ParNode.CreateMac(MCO_Result,ParCre);
   vlOfs := TMemOfsMac.Create(vlMac);
	ParCre.AddObject(vlOfs);
	iFrame.AddAddressing(self,self,vlOfs,true);
	if not IsVirtual then iMetaFrame.AddAddressing(self,self,iMeta.CreateMac(self,ParContext,MCO_ValuePointer,ParCre),true);
	iMeta.AddAddressing(self,iMeta.CreateMac(ParContext,ParContext,MCO_ValuePointer,ParCre),true);
end;


constructor TValueClassTYpe.Create(ParParent : TClassType;ParInCompleet:boolean);
begin
	inherited Create(0,ParParent,ParInCompleet);
end;

function TValueClassType.CreateVar(ParCre:TCreator;const ParName:string;ParType:TDefinition):TDefinition;
var
	vlVar : TDefinition;
begin
	vlVar := inherited CreateVar(ParCre,ParName,ParType);
	iSize := iFrame.fFrameSize;
	exit(vlVar);
end;


procedure TValueClassType.SetParent(ParType : TClassTYpe);
begin
	inherited SetParent(ParType);
   if ParType <> nil then iSize := ParType.GetClassSize;
end;


{---( TClassType )---------------------------------------------------------------------------------}


procedure TClassType.SetParent(ParType : TClassTYpe);
begin
	iParent := ParType;
	if iParent <> nil then begin
		iFrame.fPrevious := iParent.fFrame;
		iMetaFrame := iParent.fMetaFrame;
	end else begin
		iMetaFrame := TFrame.Create(true);
	end;
end;


procedure TClassType.PrintDefinitionBody(ParDis : TDisplay);
begin
	PrintParts(ParDis);
end;


procedure TClassType.InitVirtualMeta(ParVmtItem : TVmtItem);
begin
	iMeta.InitVirtual(self,ParVmtItem);
end;


function TClassType.IsIsolated : boolean;
begin
	exit(true);
end;

function TClassType.IsVirtual:boolean;
begin
	exit(iMeta.fVmtItem <> nil);
end;

function TClassType.SearchOwner:boolean;
begin
	exit(false);
end;

function TClassType.GetRelativeLevel : cardinal;
begin
	exit(1);
end;

function TClassType.CanWriteWith(ParExact : boolean;ParType : TType):boolean;
var
	vlType  : TType;
	vlPtr   : TPtrType;
begin
	if ParType = nil then exit(false);
	vlType := ParType.GetOrgType;
	if(vlType is TClassType) then begin
		while((vlType <> nil) and (vlType <> self)) do vlType := TClassType(vlType).fParent;
		exit(vlType<> nil);
	end else if TType(vlType) is TPtrType then begin
		vlPtr := TPtrType(vLType);
		exit( vlPtr.GetSecondDefault = DT_VOID);
	end;
	exit(vlType.fDefault = DT_Void);
end;


procedure TClassType.FinishClass;
begin
	iMeta.fClassSize := GetClassSize;
end;

function TClassType.GetParent : TDefinition;
begin
	exit(iParent);
end;

function TClassType.GetClassSize : TSize;
begin
	exit(iFrame.GetTotalSize);
end;

function TClassType.MustNameAddAsOwner:boolean;
begin
	exit(true);
end;


function  TClassType.GetPtrByObject(const ParName : string;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;
var	vlCurrent : TClassType;
	vlState   : TObjectFindState;
begin
	vlState := inherited GetPtrByObject(ParName,ParObject,ParOption,ParOwner,ParResult);
	if(ParOwner = fParent) then ParOwner := self;
	if(SO_Current_List in ParOption) then begin
		if (ParOwner <> nil) and  (ParOwner = self) then ParOwner := iObject;
	end;
	if vlState <> OFS_Different then exit(vlState);
	if ParResult = nil then begin
		vlCurrent := fParent;
		while (vlCurrent <> nil) do begin
			vlState := vlCurrent.GetPtrByObject(ParName,ParObject,ParOption - [SO_Current_List] ,ParOwner,ParResult);
			if (ParResult <> nil) then begin
			if(vlState = OFS_Same) and (((SO_Local in ParOption) and (ParResult.fDefAccess <> AF_Private))
			or (ParResult.fDefAccess = AF_Public))   then begin
					
					if(ParOwner = vlCurrent) then ParOwner := self;
					if(SO_Current_List in ParOption) then begin
						if (ParOwner <> nil) and (ParOwner = vlCurrent.fObject) or (ParOwner = self) then ParOwner := iObject;
					end;
					exit(vlState);
				end;
				vlState:= OFS_Different;
				break;
			end;
			vlCurrent := vlCurrent.fParent;
		end;
	end;
	ParResult := nil;
	exit(vlState);
end;


procedure  TClassType.ConsiderForward(ParCre : TCreator;ParIn : TDefinition;var ParOut : TDefinition);
var  vlDef    : TRoutine;
	vlName    : string;
	vlDifText : string;
	vlOwner   : TDefinition;
begin
	ParOut := nil;
	if ParIn = nil then exit;
	ParIn.GetTextStr(vlName);
	inherited GetPtrByObject(vlName,ParIn,[SO_Local],vlOwner,TDefinition(vlDef));
	if (vlDef <> nil) and (vlDef is TRoutine) and vlDef.GetForwardDefined then begin
		if not( vlDef.IsCompleet) then begin
			ParIn.fDefAccess := vlDef.fDefAccess;
			if not vlDef.IsSameAsForward(TRoutine(ParIn),vlDifText) then begin
				TNDCreator(ParCre).ErrorText(Err_Differs_From_Prev_Def,vlDifText);
				if vlDef.IsSameRoutine(TRoutine(ParIn),[PC_CheckALl,PC_IgnoreState]) then begin
					ParOut := vlDef;
					exit;
				end;
			end;
			ParOut := vlDef;
			exit;
		end;
	end;
	TNDCreator(ParCre).ErrorText(Err_Methode_Expected,vlName);
end;

procedure TClassType.SetMetaFramePtr(ParCre : TCreator);
var
	vlParentMeta : TClassMeta;
	vlName       : string;
	vlType       : TType;
	vlVmtType    : TTYpe;
	vlMfType     : TType;
begin
	GetTextStr(vlName);
	fObject.SetText(vlName+'_representor');
	vlParentMeta := nil;
	if iParent <> nil then vlParentMeta := iParent.fMeta;
	vlType := TNDCreator(ParCre).GetDefaultIdent(DT_Meta,0,false);
	vlVmtType := TNDCreator(ParCre).GetDefaultIdent(DT_Pointer,0,false);
	if vlType    = nil then TNDCreator(ParCre).SemError(Err_No_Meta_Data_type);
	if vlVmtType = nil then TNDCreator(ParCre).SemError(Err_Cant_Find_Ptr_type);
	iMeta        := TClassMeta.Create(vlParentMeta,vlName,vlType,vlVmtType);
	iMeta.SetModule(fModule);
	iMeta.fOwner := self;
	iMeta.fDefAccess := AF_Public;
end;


procedure TClassType.GetOVData(ParCre :TCreator;ParRoutine : TDefinition;var ParOther :TDefinition;var ParModes : TOVModes;var ParMeta : TDefinition);
var
	vlMeta 		    : TMeta;
	vlMotherParent  : TDefinition;
	vlName          : string;
	vlOther		    : TRoutine;
	vlOwner		    : TDefinition;
begin
	ParModes       := [];
	vlMeta         := fMeta;
	vlMotherParent := fParent;
	ParOther	      := nil;
	
	if vlMotherParent <> nil then begin
		
		ParRoutine.GetTextStr(vlName);
		
		vlMotherParent.GetPtrByObject(vlName,ParRoutine,[SO_Local],vlOwner,vlOther);
		if (vlOther <> nil) then begin
			
			ParModes := ParModes + [OVM_Found];
			if(vlOther is TRoutine) then begin
				
				ParModes := ParModes + [OVM_Is_Routine];
				if vlOther.IsVirtual then ParModes := ParModes + [OVM_Is_Virtual];
				if vlOther is TConstructor then ParModes := ParModes + [OVM_Constructor];
			end;
			
		end;
		ParOther := vlOther;
	end;
	ParMeta  := vlMeta;
end;


function  TClassType.CreateDB(ParCre:TCreator):boolean;
begin
	if iInCompleet then  TNDCreator(ParCre).ErrorDef(	Err_Def_Class_Incompleet ,self);
	if iMeta <> nil then iMeta.CreateDB(ParCre);
	fParts.CreateDB(ParCre);
	exit(false);
end;

function   TClassType.GetPtrInCurrentList(const ParName : string;var ParOwner,ParItem :TDefinition):boolean;
begin
	exit(inherited GetPtrByName(ParName,[SO_Local],ParOwner,Paritem));
end;


function TClassType.CreateVar(ParCre:TCreator;const ParName:string;ParType:TDefinition):TDefinition;
var vlSize : TSize;
	vlAll  : TSize;
	vlRes  : TSize;
	vlVar :TFrameVariable;
begin
	vlVar := TFrameVariable.Create(ParName,iFrame,iFrame.fFrameSize,TType(ParType));
	vlSize := vlVar.GetSize;
	vlAll  := GetConfig.fAlign;
	vlRes := vlSize mod vlAll;
	if vlRes <> 0 then vlSize := vlSIze + vlAll - vlRes;
	iFrame.GetNewOffset(vlSize);
	exit(vlVar);
end;

function TClassType.CreateReadNode(parCre:TCreator;ParContext : TDefinition):TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	vlNode := TClassTypeNode.Create(self);
	vlNode.fContext := ParContext;
	exit(vlNode);
end;



procedure TClassType.DoneDotFrame;
begin
	if not isVirtual then iMetaFrame.PopAddressing(self);
	iMeta.PopAddressing(self);
	iFrame.PopAddressing(self);
end;



procedure TClassType.DoneClassDotFrame;
begin
	iMetaFrame.PopAddressing(self);
	iMeta.PopAddressing(self);
	iFrame.PopAddressing(self);
end;


procedure TClassType.InitClassDotFrame(ParCre : TSecCreator;ParContext : TDefinition);
var
	vlMac : TMacBase;
	vlLi  : TNumber;
begin
	LoadLong(vlLi,0);
	vlMac := TNumberMac.Create(1,false,vlLi);
	ParCre.AddObject(vlMac);
	iFrame.AddAddressing(self,self,vlMac,true);
	iMeta.AddAddressing(self,iMeta.CreateMac(ParContext,ParContext,MCO_ValuePointer,ParCre),true);
	iMetaFrame.AddAddressing(self,self,iMeta.CreateMac(ParContext,ParContext,MCO_ValuePointer,ParCre),true);
end;



function TClassType.Can(ParCan : TCan_Types):boolean;
begin
	exit(inherited Can(ParCan - [Can_Dot]));
end;



procedure TClassType.Print(ParDis : TDisplay);
begin
	ParDis.write('CLASS');
	if iParent <> nil then begin
		ParDis.Write(' INHERIT ');
		PrintIdentName(ParDis,iParent);
		fParts.Print(ParDis);
	end;
	ParDis.nl;
	PrintDefinitionBody(ParDis);
	ParDis.writenl('END');
end;

constructor TClassTYpe.Create(ParSize : TSize;ParParent : TClassType;ParInCompleet:boolean);
begin
	inherited Create(ParSize);
	iInCompleet := ParInCompleet;
	if not(ParInCompleet) then SetParent(ParParent);
end;


function TClassType.SaveItem(ParStream : TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WritePi(iParent) then exit(true);
	if ParStream.WriteBoolean(iParent <> nil) then exit(true);
	if iMeta.SaveItem(ParStream) then exit(true);
	if iFrame.SaveItem(ParStream) then exit(true);
	if iParent  = nil then begin
		if iMetaFrame.SaveItem(ParStream) then exit(true);
	end else begin
		if ParStream.WritePi(iMetaFrame) then exit(true);
	end;
	if iObject.SaveItem(ParStream) then exit(true);
	exit(false);
end;

function TClassType.LoadItem(ParStream : TObjectStream) : boolean;
var
	vlHasParent : boolean;
begin
	iFrame.Destroy;
	iObject.Destroy;
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadPi(voPArent) then exit(true);
	if ParStream.ReadBoolean(vlHasParent) then exit(true);
	if CreateObject(ParStream,voMeta) <> STS_OK then exit(true);
	if CreateObject(ParStream,voFrame) <> STS_OK  then exit(true);
	if vlHasParent then begin
		if ParStream.ReadPi(voMetaFrame)  then exit(true);
	end else begin
		if CreateObject(ParStream,voMetaFrame) <> STS_OK then exit(true);
	end;
	if CreateObject(ParStream,voObject) <> STS_OK then exit(true);
	iMeta.InitVirtual(self,iMeta.fVmtItem);
	exit(false);
end;

procedure TClassType.Commonsetup;
begin
	
	inherited Commonsetup;
	
	iMeta       := nil;
	iFrame      := TFrame.Create(true);
	iIdentCode  := IC_ClassType;
	iObject     := TObjectRepresentor.Create('Representor',self);
	IinCompleet := false;
	iMetaFrame  := nil;
end;

procedure TClassType.Clear;
begin
	inherited Clear;
	if iMeta <> nil then iMeta.Destroy;
	if iFrame <> nil then iFrame.Destroy;
	if iObject <> nil then iObject.Destroy;
	if (iParent = nil) and (iMetaFrame <> nil) then iMetaFrame.Destroy;
end;


function   TClassType.GetPtrByName(const ParName:string;ParOption : TSearchOPtions;var ParOwner,ParItem:TDefinition):boolean;
var vlRes     : boolean;
	vlCurrent : TClassType;
begin
	vlRes := inherited GetPtrByName(ParName,ParOption,ParOwner,ParItem);
	if not(SO_Local in ParOption) and (ParItem <> nil) then begin
	if ParItem.fDefAccess <> AF_Public then begin
			ParItem := nil;
			ParOwner := nil;
			exit(false);
		end;
	end;
	if not(vlRes) then begin
		vlCurrent := fParent;
		ParOwner  := nil;
		ParItem   := nil;
		while (vlCurrent <> nil) do begin
			vlRes := vlCurrent.GetPtrByName(ParName,ParOption - [SO_Current_List],ParOwner,ParItem);
		if(vlRes) and (((SO_LOcal in ParOption) and (ParItem.fDefAccess <> AF_Private))
		or (ParItem.fDefAccess = AF_Public)) then begin
				if(ParOwner =vlCurrent) then ParOwner := self;
				if(SO_Current_List in ParOption) then begin
					if (ParOwner <> nil) and  (ParOwner = vlCurrent.fObject) or (ParOwner = self) then ParOwner := iObject;
				end;
				
				break;
			end;
			vlCurrent := vlCurrent.fParent;
			ParOwner := nil;
			ParItem  := nil;
			vlRes    := false;
		end;
	end;
	
	if(SO_Current_List in ParOption) and (ParOwner = self) then ParOwner := iObject;
	
	exit(vlRes);
end;

{---( TCOnstructor )---------------------------------------------------------}


function  TConstructor.NeedReadableRecord : boolean;
begin
	exit(false);
end;


procedure TConstructor.ValidateOverrideVirtTest(ParCre : TNDCreator;ParOther : TRoutine);
begin
end;


function  TConstructor.CreateNewCB(ParCre : TCreator;const ParName : string) : TRoutine;
var
	vlRoutine : TConstructor;
begin
	vlRoutine := TConstructor.Create(ParName);
	vlRoutine.SetFunType(TNDCreator(ParCre),fType);
	exit(vlRoutine);
end;

procedure TConstructor.CreatePostCode(ParCre : TNDCreator);
var
	vlVar   : TVariable;
	vlExit  :TExitNode;
	vlOwner : TDefinition;
begin
	if  not(GetPtrByName(Name_Self,[SO_Local],vlOwner,vlVar)) then begin
		ParCre.ErrorText(err_Cant_Find_parameter,Name_Self);
		exit;
	end;
	vlExit := TExitNode(CreateExitNode(ParCre,vlVar.CreateReadNode(ParCre,self)));
	fStatements.AddNode(vlExit);
end;


procedure TConstructor.CreatePreCode(ParCre : TNDCreator);
var
	vlNew      : TRoutineCollection;
	vlVar      : TVariable;
	vlOwner    : TClassType;
	vlCall     : TCallNode;
	vlSelfNode : TFormulaNode;
	vlMetaPtr  : TVariable;
	vlIf       : TIfNode;
	vlThenElse : TThenElseNode;
	vlExitNode : TExitNode;
	vlComp     : TCompNode;
begin
	if  not(GetPtrByName(Name_Self,[SO_Local],vlOwner,vlVar)) then begin
		ParCre.ErrorText(err_Cant_Find_parameter,Name_Self);
		exit;
	end;
	if not(GetPtrByName(Name_MetaPtr,[SO_Local],vlOwner,vlMetaPtr)) then begin
		ParCre.ErrorText(err_Cant_Find_Parameter,Name_MetaPtr);
		exit;
	end;
	vlNew := TRoutineCollection(ParCre.GetDefaultNew);
	if vlNew = nil then begin
		ParCre.SemError(Err_Cant_Find_Routine);
		exit;
	end;
	
	vlOwner := TClassType(GetRealOwner);
	vlCall := TCallNode(vlNew.CreateExecuteNode(ParCre,nil));
	vlSelfNode := TFormulaNode(vlVar.CreateReadNode(ParCre,self));
	vlCall.AddNode(vlSelfNode);
	vlCall.AddNode(vlMetaPtr.CreateReadNode(ParCre,self));
	ParCre.SetNodePos(vlCall);
	fStatements.AddNode(vlCall);
	vlComp := TCompNode.create(IC_Eq,ParCre.GetCheckDefaultType(DT_Boolean,0,false,'boolean'));
	vlComp.AddNode(vlVar.CreateReadNode(ParCre,self));
	vlComp.AddNode(ParCre.GetPointerCons(nil));
	ParCre.SetNodePos(vlComp);
	vlIf := TIfNode.Create;
	ParCre.SetNodePos(vlIf);
	vlIf.SetCond(vlComp);
	vlThenElse := TThenElseNode.Create(true);
	ParCre.SetNodePos(vlThenElse);
	vlIf.AddNode(vlThenElse);
	vlExitNode := TExitNode(CreateExitNode(ParCre,TFormulaNode(ParCre.GetPointerCons(nil))));
	ParCre.SetNodePos(vlExitNode);
	vlThenElse.AddNode(vlExitNode);
	fStatements.AddNode(vlIf);
end;

procedure TConstructor.COmmonsetup;
begin
	inherited COmmonsetup;
	iIdentCode := IC_COnstructor;
end;

{----( TDestructor )-------------------------------------------------------------------}


procedure TDestructor.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := IC_Destructor;
end;

function TDestructor.MustSeperateInitAndMain : boolean;
begin
	exit(false);
end;

function TDestructor.GetInheritedAddress : TRoutine;
begin
	exit(fPhysicalAddress);
end;

procedure TDestructor.CreatePostCode(ParCre : TNDCreator);
var
	vlVar   : TVariable;
	vlExit  :TExitNode;
	vlOwner : TDefinition;
	vlCast  : TTypeNode;
begin
	if  not(GetPtrByName(Name_Self,[SO_Local],vlOwner,vlVar)) then begin
		ParCre.ErrorText(err_Cant_Find_parameter,Name_Self);
		exit;
	end;
	vlCast := TTypeNode.Create(ParCre.GetCheckDefaultType(DT_Pointer,0,false,'pointer'));{TODO}
	vlCast.AddNode(vlVar.CreateReadNode(ParCre,self));
	vlExit := TExitNode(CreateExitNode(ParCre,vlCast));
	fStatements.AddNode(vlExit);
end;
	
end.

