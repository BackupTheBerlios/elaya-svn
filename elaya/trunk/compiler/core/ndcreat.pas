{Elaya, the compiler for the elaya language
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
unit NDCreat;
interface
uses largenum,streams,sysutils,stdobj,files,compbase,idlist,DSbLsDef,node,elatypes,formbase,progutil,asminfo,ddefinit,cmp_type,
	hashing,types,elacons,cmp_base,elacfg,module,error,curitem;
	
type
	
	
	TNDCreator=class(TCreator)
	private
		voCollection      : TIdentListCollection;
		voLoader          : TObjectStream;
		voUnit            : TUnit;
		voEnumType        : TEnumType;
		voForwardList     : TForwardList;
		voCurrentItemList : TCurrentDefinitionList;
		voUnitUseList     : TUnitUseList;
		voCurrentDefAccess: TDefAccess;
		voCurrentDefModes : TDefinitionModes;
		voInPublicSection : boolean;
		voGlobalHashing   : THashing;
		property    iCollection        : TIdentListCollection   read voCollection       write voCOllection;
		property    iCurrentDefModes   : TDefinitionModes       read voCurrentDefModes  write voCurrentDefModes;
		property    iCurrentDefAccess  : TDefAccess             read voCurrentDefAccess write voCurrentDefAccess;
		property    iInPublicSection   : boolean		        read voInPublicSection  write voInPublicSection;
		property    iGlobalHashing     : THashing               read voGlobalHashing    write voGlobalHashing;
		property    iUnitUseList	   : TUnitUseList           read voUnitUseList      write voUnitUseList;
		property    iCurrentItemList   : TCurrentDefinitionList read voCurrentItemList  write voCurrentItemList;
		property    iEnumTypeType      : TEnumType              read voEnumType         write voEnumType;
	protected
		procedure   CommonSetup;override;

	public
		property    fCollection      : TIdentListCollection     read voCollection;
		property    fCurrentItemList : TCurrentDefinitionList   read voCurrentItemList;
		property    fLoader          : TObjectStream            read voLoader;
		property    fForwardList     : TForwardList             read voForwardList;
		property    fCurrentDefAccess  : TDefAccess             read voCurrentDefAccess write voCurrentDefAccess;
		property    fInPublicSection   : boolean		        read voInPublicSection  write voInPublicSection;
		property    fCurrentDefModes   : TDefinitionModes       read voCurrentDefModes  write voCurrentDefModes;
		property    fCurrentUnit       : TUnit                  read voUnit;
		procedure   SetSourceTime(ParTime:longint);
		function    GetSourceTime:longint;
		procedure   GetModuleName(var ParName:string);
		constructor Create(const ParName:string;ParCompiler:TCompiler_Base);
		function    AddDepUse(const ParUnit,ParDep:string):TErrorType;
		function    AddUnitUse(const parUnit:string;ParState:TUnitLoadStates):boolean;
		procedure   AddUnitInUse(const ParUnit:string);
		function    GetWriteProc(ParNl:boolean;var ParItem,ParOwner:TDefinition):boolean;
		function    AddUnit(const ParUnit:string;ParLevel : TUnitLevel;ParPublic:boolean):TUnit;
		procedure   AutoLoadModule;
		procedure   InitForwardList;
		procedure   InitUnitUseList;
		procedure   SetforwardList(ParList:TForwardList);
		{Aanmaken code}
		function  MakeLoadNodeByDef(ParSource : TFormulaDefinition;ParSourceContext : TDefinition;ParDestination : TFormulaDefinition;ParDestContext : TDefinition) : TNodeIdent;
		function  MakeLoadNodeToDef(ParSourceNode : TFormulaNode;ParDestination : TFormulaDefinition;ParContext :TDefinition) : TFormulaNode;
		function  MakeLoadNode(ParSource,ParDest : TFormulaNode) : TFormulaNode;
		
		{Create new constants}
		procedure   AddStringConst(ParName:TNameList;const PArStr:string);
		procedure   AddConstant(ParName:TNameList;const ParCon:TValue);
		function    AddConstant(const ParName : string;const ParCon : TValue): TDefinition;
		function    AddConstant(const ParName : string;const ParCon : TValue;ParType : TType):TDefinition;

		function    ConvertTextToNode( ParStr : TStringBaseValue) : TNodeIdent;
		
		function    AddUnion:TType;
		function    AddType(const ParNames:string;ParType:TType):TType;
		procedure   InitModule(const ParName:String);
		procedure   AddIdent(ParItem:TDefinition);
		procedure   AddToDefault(ParDef:TDefinition);
		function    SetEnumBegin:TType;
		procedure   AddVar(ParNameList:TNameList;ParType:TType);
		procedure   Bind;
		procedure   EndIdent;
		procedure   EndNode;
		procedure   EndIdentNum(ParNum : cardinal);
		procedure   EndEnum;
		function    GetNewCompiler(const ParFileName:String):TCompiler_Base;
		function    GetIntSizeByRange(const Pari1,ParI2:TNumber;var ParSize:TSize;var ParSign:boolean):boolean;
		procedure   InitLoader;
		function    LoadUnit(ParLoader:TObjectStream;const ParUnit:string;ParLevel :TUnitLevel;ParPublic:boolean):TUnit;
		procedure   Save;
		procedure   ErrorText(ParError:TErrorType;const ParText:string);
		procedure   ErrorDefText(ParError : TErrorType;const ParPre,ParAfter : string;ParDef : TDefinition);
		procedure   ErrorDef(ParError : TErrorType;ParDef : TDefinition);
		procedure   SemError(ParError:TErrorType);
		procedure   AddNodeError(ParNode:TNodeIdent;ParError:TErrorType;const partext:string);
		procedure   AddNodeListError(ParNode : TNodeList;ParError : TErrorType;const ParText : string);
		procedure   AddNodeDefError(ParNode:TNodeIdent;ParError:TErrorType;ParDef : TDefinition);
		destructor  Destroy;override;
		function    CreateRecord:TType;
		procedure   SetIsUnitFlag(ParIsUnitFlag:boolean);
		function    WriteResFile:boolean;
		function    GetIsUnitFlag:boolean;
		procedure   AddAtCurrentList(ParIdent:TDefinition);
		procedure   AddForwardBind(const ParName:string;ParBind:TPtrType);
		procedure   BindForward;
		procedure   ProcessUseClause;
		procedure   CreateSec;
		procedure   AddRoutineItem(ParCode:TDefinition);
		function    GetCurrentUnitLevelAccess :TDefAccess;
		procedure   CheckAccessLevel(ParItem : TDefinition);
		function    AddStringConst(const ParName : string;const ParStr : string) : TDefinition;
		procedure   ConsiderForward(ParIn : TDefinition;var ParOut : TDefinition);
		procedure   SetCurrentDefModes(ParModes : TDefinitionModes;ParOn : boolean);
		{get}
		function    GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition) : TObjectFindState;
		function    GetPtrByArray(const ParName : string;const ParArray : array of TRoot;var ParOwner,ParResult : TDefinition) : TObjectFindState;

		function    GetPtr(const ParName:string):TDefinition;
		function    GetIdentByName(const ParName : string;var ParOwner,ParItem : TDefinition):boolean;
		function    GetCheckitem(const ParName:string):TDefinition;
		function    GetPtrInCurrentList(const ParName:String;var ParOwner,ParItem : TDefinition):boolean;
		
		{Get Default idents}
		function    GetDefaultIdent(ParDefault:TDefaultTypeCode;ParSize:TSize;ParSign:boolean):TType;
		function    GetDefaultNew : TDefinition;
		function    GetDefaultDestroy : TDefinition;
		function    GetIntType(ParNum1,ParNum2:TNumber):TType;
		function    GetDefaultChar : TType;
		function    GetCheckDefaultType(ParDef : TDefaultTypeCode;ParSize : TSize;ParSign : boolean;const ParMsg : string) : TType;
		
		{adding current}
		
		procedure AddCurrentDefinitionEx(ParDef : TDefinition;ParIsolated,ParQuery : boolean);
		procedure AddCurrentDefinition(ParDef:TDefinition);
		procedure AddCurrentNode(ParNode:TNodeIdent);
		
		function  GetCurrentDefinition:TDefinition;
		function  GetCurrentRoutine:TDefinition;
		function  GetCurrentLoopCbNode:TNodeIdent;
		function  GetCurrentClass : TDefinition;
		function  GetCurrentInsertItem : TDefinition;
        function  GetCurrentDefinitionByNum(ParNum : cardinal) : TDefinition;

		procedure PreAdd(ParDef:TDefinition;var ParCur:TDefinition);
		function  FindRoutineByDef(ParRoutine:TDefinition;var ParOwner,ParCB:TDefinition):TCFoundResult;
		{Node function}
		function   GetPointerCons(ParPtr:pointer):TNodeIdent;
		function  ProcessOperator(const ParParameters  : array of TRoot;var   ParPrvPar      : TNodeIdent;const ParOperStr     : string;ParError : boolean):TOperatorProcessResult;

		procedure ProcessBetweenOperator( ParO1,ParO2,ParO3    : TNodeIdent; var ParPrvPar: TNodeIdent;const ParOprStr    : String);
		procedure ProcessCompOperator(ParNewPar    : TNodeIdent;var ParPrvPar: TNodeIdent;const ParOprStr    : String;ParCode	     : TIdentCode);
		procedure ProcessSingleOperator(ParNewPar    : TNodeIdent;var ParPrvPar: TNodeIdent;const ParOprStr    : String;ParOperObj   : TRefNodeIdent);
		procedure ProcessDualOperator(ParSource : TFormulaNode;var ParOut : TFormulaNode;const ParOperStr : string;ParNode : TRefNodeIdent);
		function  AddNodeTONode(ParNode1 : TNodeIDent;var ParNode2:TNodeIdent):boolean;
		function  CreateIntNode(ParNum : TNumber) : TNodeIdent;{TODO CreateNumberNode}
		function  CreateIntNodeLong(ParNUm : cardinal) : TNodeIdent;
		procedure SetNodePos(ParNode : TNodeIdent);
		procedure SetDefinitionPos(ParDef : TDefinition);

		procedure AddGlobalOnce(ParItem : TDefinition);
		procedure AddGlobal(ParItem : TDefinition);
	end;
	
	
	
implementation

uses procs,vars,execobj,cblkbase,ela_user,classes,doperfun,stmnodes;


{---( TNDCreator )-----------------------------------------------------}


procedure TNDCreator.CheckAccessLevel(ParItem : TDefinition);
var vlDef      : TDefAccess;
	vlDef2     : TDefAccess;
	vlOwner    : TDefinition;
	vlCurrent  : TDefinition;
begin
	{if ParItem = nil then} exit;{TODO: Hugh?}
	vlDef := ParItem.fDefAccess;
	vlOwner := ParItem.fOwner;
	while (vlOwner <> nil) do begin
		VlCurrent := GetCurrentDefinition;
    	vlDef2    := AF_Public;
		while(vlCurrent <> nil) do begin
			vlDef2 := CombineAccess(vlDef,vlCurrent.fDefAccess);
			if(vlOwner = vlCurrent) or (vlOwner.IsParentOf(vlCurrent)) then begin
				if IsLessPublicAs(vlDef,vlDef2) then ErrorText(Err_More_Public,'2');
			end;
			vlCurrent := vlCurrent.GetRealOwner;
		end;
		vlDef := CombineAccess(vlDef,vlOwner.fDefAccess);
		vlOwner := vlOwner.GetRealOwner;
	end;
	if GetCurrentDefinition <> nil then begin
		if(IsLessPublicAs(vlDef,GetCurrentUnitLevelAccess)) then ErrorText(Err_More_Public,'1');
	end;

end;


procedure TNDCreator.AddGlobalOnce(ParItem : TDefinition);
begin
	fCurrentUnit.AddGlobalOnce(self,ParItem);
end;

procedure  TNDCreator.ConsiderForward(ParIn : TDefinition;var ParOut : TDefinition);
var
	vlDef        : TDefinition;
	vlDefinition : TDefinition;
	vlDifText    : string;
	vlOwner      : TDefinition;
	vlName       : string;
begin
	
	ParOut := nil;
	vlDef := GetCurrentDefinition;
	ParIn.GetTextStr(vlName);
	
	if vlDef = nil then begin
		
		FindRoutineByDef(ParIn,vlOwner,vlDefinition);
		
		if (vlDefinition <> nil) and vlDefinition.GetForwardDefined then begin
			if not (vlDefinition.IsCompleet) then begin
				
				ParIn.fDefAccess := AF_Public;
				
				if not vlDefinition.IsSameAsForward(TRoutine(ParIn),vlDifText) then begin
					
					ErrorText(Err_Differs_From_Prev_Def,':'+vlDifText);
					
				end;
				
				ParOut := vlDefinition;
				
			end;
		end;
		
	end else begin
		
		vlDef.ConsiderForward(self,ParIn,ParOut);
		
	end;
	
end;




function TNDCreator.GetCurrentUnitLevelAccess :TDefAccess;
var
	vlAcc : TDefAccess;
begin
	vlAcc := fCurrentDefAccess;
	if vlAcc=AF_Private then exit(vlAcc);
    vlAcc := CombineAccess(vlAcc,iCurrentItemList.GetCurrentDefinitionsAccess);
	exit(vlAcc);
end;

function   TNDCreator.GetPointerCons(ParPtr:pointer):TNodeIdent;
var vlType : TType;
	vlCons : TPointerCons;
	vlPtr  : TPointer;
begin
	TDefinition(vlType) := GetDefaultIdent(DT_Pointer,0,false);
	if vlType = nil then ErrorText(Err_Cant_Find_type,'pointer');
	vlPtr  := TPointer.Create;
	vlPtr.SetPointer(longint(ParPtr));
	vlCons := TPointerCons.Create('',vlType);
	vlCons.SetValue(vlPtr);
	exit( TPointerNode.Create(vlCons));
end;


function  TNDCreator.ProcessOperator(const ParParameters  : array of TRoot;var   ParPrvPar      : TNodeIdent;const ParOperStr     : string;ParError : boolean):TOperatorProcessResult;
begin
	exit(TELa_user(fCompiler).ProcessOperator(ParParameters,ParPrvPar,ParOperStr,ParError));
end;

procedure TNDCreator.ProcessBetweenOperator( ParO1,ParO2,ParO3    : TNodeIdent; var ParPrvPar: TNodeIdent;const ParOprStr    : String);
begin
	TEla_User(fCOmpiler).ProcessBetweenOPerator(ParO1,ParO2,ParO3,ParPrvPar,ParOprStr);
end;

procedure TNDCreator.ProcessCompOperator(ParNewPar    : TNodeIdent;var ParPrvPar: TNodeIdent;const ParOprStr    : String;ParCode	     : TIdentCode);
begin
	TEla_User(fCompiler).ProcessCompOperator(ParNewPar,ParPrvPar,ParOprStr,ParCode);
end;

procedure TNDCreator.ProcessSingleOperator(ParNewPar : TNodeIdent;var ParPrvPar: TNodeIdent;const ParOprStr    : String;ParOperObj   : TRefNodeIdent);
begin
	TEla_user(fCompiler).ProcessSingleOperator(ParNewPar,ParPrvPar,ParOprStr,ParOperObj);
end;

procedure TNDCreator.ProcessDualOperator(ParSource : TFormulaNode;var ParOut : TFormulaNode;const ParOperStr : string;ParNode : TRefNodeIdent);
begin
	TEla_User(fCompiler).ProcessDualOperator(ParSource,ParOut,ParOperStr,ParNode);
end;

function TNDCreator.MakeLoadNode(ParSource,ParDest : TFormulaNode) : TFormulaNode;
var vlLoad : TFormulaNode;
begin
	vlLoad := ParDest;
	ProcessDualOperator(ParSource,vlLoad,':=',TLoadNode);
	exit(vlLoad);
end;


function TNDCreator.MakeLoadNodeToDef(ParSourceNode : TFormulaNode;ParDestination : TFormulaDefinition;ParContext : TDefinition) : TFormulaNode;
var vlDestNode : TFOrmulaNode;
begin
	vlDestNode := TFormulaNode(ParDestination.CreateReadNode(self,ParContext));
	SetNodePos(vlDestNode);
	exit(MakeLoadNode(ParSourceNode,vlDestNode));
end;

function TNDCreator.MakeLoadNodeByDef(ParSource : TFormulaDefinition;ParSourceContext : TDefinition;ParDestination : TFormulaDefinition;ParDestContext : TDefinition) : TNodeIdent;
var vlSourceNode : TFormulaNode;
begin
	vlSourceNode := TFormulaNode(ParSource.CreateReadNode(self,ParSourceContext));
	SetNodePos(vlSourceNode);
	exit(MakeLoadNodeToDef(vlSourceNode,ParDestination,ParDestContext));
end;

procedure  TNDCreator.SetDefinitionPos(ParDef : TDefinition);
begin
	if ParDef <> nil then begin
		ParDef.fPos := fCOmpiler.pos;
		ParDef.fLine := fCompiler.line;
		ParDef.fCOl := fCompiler.col;
	end;
end;


procedure TNDCreator.SetNodePos(ParNode : TNodeIdent);
begin
	if ParNode <> nil then  ParNode.SetPos(fCompiler.line,fCompiler.col,fCompiler.pos);
end;

function  TNDCreator.AddNodeTONode(ParNode1 : TNodeIDent;var ParNode2:TNodeIdent):boolean;
begin
	AddNodeToNode := false;
	if ParNode2 <> nil then begin
		if ParNode1 <> nil then begin
			AddNodeToNode := ParNode1.AddNode(ParNode2);
			SetNodePos(ParNode2);
		end else begin
			ParNode2.Destroy;
			ParNode2 := nil;
		end;
	end;
end;



function  TNDCreator.FindRoutineByDef(ParRoutine:TDefinition;var ParOwner,ParCB:TDefinition): TCFoundResult;
var vlDef   : TDefinition;
	vlName  : string;
	vlOwner : TDefinition;
begin
	ParCb  := nil;
	ParRoutine.GetTextStr(vlName);
	if not GetPtrInCurrentList(vlName,vlOwner,vlDef) then exit(CF_NotFound);
	if not(vlDef is TRoutineCollection) then exit(CF_Other_Type);
	vlDef.GetPtrByObject(vlName,TRoutine(ParRoutine),[],ParOwner,ParCB);
	if vlDef.fDefAccess <> AF_Public then exit(CF_Public)
	else exit(CF_NotPublic);
end;


procedure TNDCreator.AddCurrentDefinitionEx(ParDef : TDefinition;ParIsolated,ParQuery : boolean);
begin
	if ParDef <> nil then fCurrentItemList.AddItem(TCurrentDefinitionItem.Create(ParDef,ParIsolated,ParQuery));
end;

procedure TNDCreator.AddCurrentDefinition(ParDef:TDefinition);
begin
	if ParDef <> nil then fCurrentItemList.AddItem(TCurrentDefinitionItem.Create(ParDef,ParDef.IsIsolated,false));
end;

procedure TNDCreator.AddCurrentNode(ParNode:TNodeIdent);
begin
	if ParNode <> nil then fCurrentItemList.AddCurrentNode(TCUrrentNodeItem.Create(ParNode));
end;

function  TNDCreator.GetCurrentInsertItem : TDefinition;
begin
	exit(iCurrentItemList.GetCurrentInsertItem);
end;

function  TNDCreator.GetCurrentDefinitionByNum(ParNum : cardinal) : TDefinition;
begin
	exit(iCurrentItemList.GetDefinitionByNum(parNum));
end;


function  TNDCreator.GetCurrentDefinition:TDefinition;
begin
	exit(iCurrentItemList.GetDefinitionByType(TDefinition));
end;


function TNDCreator.GetCurrentClass :TDefinition;
begin
	exit(iCurrentItemList.GetDefinitionByType(TClassType));
end;

function TNDCreator.GetCurrentRoutine:TDefinition;
begin
	exit(iCurrentItemList.GetDefinitionByType(TRoutine));
end;

function  TNDCreator.GetCurrentLoopCbNode:TNodeIdent;
begin
	exit(iCurrentItemList.GetNodeByType(TLoopCBNode));
end;


procedure TNDCreator.AddRoutineItem(ParCode:TDefinition);
var vlRoutine : TRoutineCollection;
	vlName    : string;
	vlAnon    : string;
	vlOwner   : TDefinition;
begin
	ParCode.GetTextStr(vlName);
	if GetPtrInCurrentList(vlName,vlOwner,vlRoutine) then begin
		if not(vlRoutine is TRoutineCollection) then begin
			GetNewAnonName(vlAnon);
			vlRoutine := TRoutineCollection.Create(vlName);
			AddIdent(vlRoutine);
		end;
	end else begin
		vlRoutine         := TRoutineCollection.Create(vlName);
		AddIdent(vlRoutine);
	end;
	AddCurrentDefinition(vlRoutine);
	AddIdent(ParCode);
	EndIdent;
end;

function  TNDCreator.GetPtrInCurrentList(const ParName:String;var ParOwner,ParItem : TDefinition):boolean;
var
	vlDef : TDefinition;
begin
	vlDef := GetCurrentDefinition;
	if vlDef <> nil then begin
		exit(vlDef.GetPtrInCurrentList(ParName,ParOwner,ParItem));
	end else begin
		exit(iCollection.GetPtrInCurrentList(ParName,ParOwner,ParItem));
	end;
end;

procedure   TNDCreator.SetSourceTime(ParTime:longint);
begin
	fCurrentUnit.SetSourceTime(ParTime);
end;

function    TNDCreator.GetSourceTime:longint;
begin
	GetSourceTime := fCurrentUnit.GetSourceTime;
end;

function   TNDCreator.GetNewCompiler(const ParFileName:String):TCompiler_Base;
begin
	GetNewCompiler := fCompiler.NewCompiler(ParFileName);
end;

procedure  TNDCreator.ProcessUseClause;
begin
	
	iUnitUseList.ProcessUnitList(self);
	if SuccessFul then begin
		iUnitUseList.LoadUnits(self);
		if SuccessFul then begin
			fCurrentUnit.AddListToGlobalHashing(self,iGlobalHashing);
			iUnitUseList.AddToGlobalHashing(self,iGlobalHashing);
		end;
	end;
end;

procedure  TNDCreator.GetModuleName(var ParName:string);
begin
	fCurrentUnit.GetNameStr(ParName);
end;


function   TNDCreator.GetWriteProc(ParNl:boolean;var ParItem,ParOwner:TDefinition):boolean;
var vlStr : string;
begin
	if ParNl then
	vlStr := Cnf_Write_Nl
	else begin
		vlStr := CNF_Write;
	end;
	
	if not GetIdentByName(vlStr,ParOwner,ParItem) then begin
		ErrorText(Err_Cant_Find_Write_Proc,vlStr);
		exit(false);
	end else begin
		if not(ParItem.Can([Can_Execute])) then begin
			ErrorText(Err_Cant_Execute,vlStr);
			exit(false);
		end;
	end;
	exit(true);
end;


function  TNDCreator.AddUnit(const ParUnit:string;ParLevel : TUnitLevel;ParPublic:boolean):TUnit;
var    vlUnit:TUnit;
begin
	verbose(vrb_load_unit,'Load unit :'+ParUnit);
	vlUnit := TUnit(LoadUnit(fLoader,ParUnit,ParLevel,ParPublic));
	fCurrentUnit.AddUnit(vlUnit);
	AddUnit := vlUnit;
end;


procedure  TNDCreator.AutoLoadModule;
var vlCnt:cardinal;
	vlStr:String;
begin
	vlCnt :=1;
	while not GetConfig.GetAutoLoad(vlCnt,vlStr) do begin
		if length(vlStr) <> 0 then begin
			AddUnitInUse(vlStr);
			verbose(VRB_Auto_Load,'Auto loading :'+vlStr);
		end;
		inc(vlCnt);
	end;
	if vlCnt = 1  then verbose(VRB_Auto_Load,'No autoload units');
end;



procedure  TNDCreator.AddForwardBind(const ParName:string;ParBind:TPtrType);
begin
	
	fForwardList.addBind(ParName,ParBind);
end;

procedure  TNDCreator.BindForward;
begin
	fForwardList.Bind(self);
end;


procedure TNDCreator.SetforwardList(ParList:TForwardList);
begin
	if fForwardList <> nil then fForwardList.Destroy;
	voForwardList := ParList;
end;


procedure TNDCreator.InitForwardList;
begin
	SetForwardList(TForwardList.Create);
end;

procedure  TNDCreator.AddToDefault(ParDef:TDefinition);
var vlDef:TDefinition;
begin
	vlDef := GetCurrentDefinition;
	if vlDef <> nil then TSubListDef(vlDef).fParts.AddToDefaultList(ParDef) {Todo Add  AddToDefault to TDefinition}
	else iCollection.AddToCurrentDefaultList(ParDef);
end;

function TNDCreator.WriteResFile:boolean;
var vlCnt  : cardinal;
	vlPath : string;
	vlFile : text;
	vlList : TSearchPathList;
begin
	assign(vlFile,'LINK.RES');
	rewrite(vlFile);
	if ioresult <> 0 then exit(true);
	vlCnt := 1;
	GetConfig.GetObjectPath(vlPath);
	vlList := TSearchPathList.Create;
	vlList.AddPath(vlPath);
	while not vlList.GetPathByNum(vlCnt,vlPath) do begin
		writeln(vlFile,'SEARCH_DIR('+vlPath+')');
		if ioresult <> 0 then exit(true);
		inc(vlCnt);
	end;
	vlList.Destroy;
	writeln(vlFile,'INPUT(');
	if ioresult <> 0 then exit(true);
	if fCurrentUnit.WriteResLines(vlFile) then exit(true);
	writeln(vlfile,')');
	if ioresult <> 0 then exit(true);
	close(vlFile);
	if ioresult <> 0 then exit(true);
	exit(false);
end;


procedure  TNDCreator.SetIsUnitFlag(ParIsUnitFlag:boolean);
begin
	fCurrentUnit.fIsUnitflag := ParIsUnitflag;
end;

function   TNDCreator.GetIsUnitFlag:boolean;
begin
	GetIsUnitFlag := fCurrentUnit.fIsUnitFlag;
end;

function TNDCreator.AddUnion:TType;
var vlType:TType;
begin
	vlType := TUnionType.Create(0);
	AddCurrentDefinition(vlType);
	AddUnion := vlType;
end;

function   TNDCreator.CreateRecord:TType;
var vLType :TType;
begin
	vlType :=  TType(TRecordType.Create(0));
	AddCurrentDefinition(vltype);
	exit(vlType);
end;


procedure TNDCreator.EndIdentNum(ParNum : cardinal);
var
	vlCnt:cardinal;
begin
	vlCnt := ParNum;
	while vlCnt > 0 do begin
		EndIdent;
		dec(vlCnt);
	end;
end;

procedure TNDCreator.EndNode;
begin
	fCurrentItemList.PopCUrrentNode;
end;


procedure TNDCreator.EndIdent;
begin
	fCurrentItemList.PopIdent;
end;


function   TNDCreator.SetEnumBegin :TType;
var
	vlType:TType;
begin
	vltype 		  := TEnumType.Create;
	iEnumTypeType := TEnumType(vlType);
	exit(vlType);
end;

procedure TNDCreator.EndEnum;
var vlMin,vlMax : TLargeNumber;
	vlSize      : TSize;
	vlSign      : boolean;
	vlCurrent   : TEnumCons;
	vlNum       : TLargeNumber;
	vlCollection: TEnumCollection;
begin
	if (iEnumTypeType = nil) or (iEnumTypeType.fIdentCode <> Ic_EnumType) then begin
		SemError(Err_Int_No_Enum_Type);
		exit;
	end;

	vlCollection := TEnumCollection(GetCurrentDefinition);
	if not(vlCollection is TEnumCollection) then begin
		SemError(	Err_Int_Cur_Ident_No_EC);
		exit;
	end;

	vlCurrent := TEnumCons(vlCollection.fParts.fStart);
	Loadint(vlMin,0);
	LoadInt(vlMax,0);
	if vlCurrent <> nil then begin
		if vlCurrent.fIdentCode <> ic_enumcons then begin
			SemError(Err_Int_not_A_enum_const);
			exit;
		end;
		vlMin := vlCurrent.GetNumber;
		vlMax := vlMin;
		vlCurrent := TEnumCons(vlCurrent.fNxt);
		while (vlCurrent<> nil) do begin
			if vlCurrent.fIdentCode <> ic_EnumCons then begin
				SemError(Err_Int_not_A_enum_const);
				exit;
			end;
			vlNum := vlCurrent.GetNumber;
			if LargeCompare(vlNum, vlMax)=LC_Bigger then vlMax := vlNum else
			if LargeCompare(vlNum, vlMin)=LC_Lower  then vlMin := vlNum;
			vlCurrent := TEnumCons(vlCurrent.fNxt);
		end;
		if GetIntSizeByRange(vlMin,vlMax,vlSize,vlSign) then SemError(Err_Num_Out_Of_Range);
		iEnumTypeType.SetSign(vlSign);
		iEnumTypeType.SetSize(vlSize);
		vlCollection.SetEnumType(iEnumTypeType);
	end;
    EndIdent;
end;

function TNDCreator.GetCheckitem(const ParName:string):TDefinition;
var
	vlItem : TDefinition;
begin
	vlitem := TDefinition(GetPtr(Parname));
	GetCheckitem := nil;
	if vlitem = nil then begin
		ErrorText(Err_Unkown_Ident,ParName);
		exit;
	end;
	CheckAccessLevel(vlItem);
	GetCheckitem := vlitem;
end;

procedure  TNDCreator.InitModule(const ParName:string);
var vlName : string;
	vlUnitName : string;
begin
	vlName:= ParName;
	NormFileName(vlName);
	voUnit := TUnit.Create(ParName);
	voUnit.GetNameStr(vlUnitName);
	SetLabelBase(vlUnitName);
	iCollection.AddIDentList(vlname,0,voUnit.fItemList,true);
	AddUnitUse(vlName,[US_Current_Unit]);
end;

procedure TNDCreator.Bind;
begin
	fLoader.DoBind;
	iUnitUseList.CleanupLoad;
end;

procedure TNDCreator.InitLoader;
var
	vlPath : string;
begin
	voLoader :=TObjectStream.Create;
	GetConfig.GetObjectPath(vlPath);
	voLoader.AddPath(vlPath);
end;

function TNDCreator.GetDefaultDestroy : TDefinition;
begin
	exit(GetPtr(Name_Destroy));
end;

function TNDCreator.GetDefaultNew : TDefinition;
var
	vlIdent : TDefinition;
begin
	vlIdent := GetPtr(Name_New);
	exit(vlIdent);
end;

function TNDCreator.GetDefaultIDent(ParDefault:TDefaultTypeCode;ParSize:TSize;ParSign:boolean):TType;
var vlIdent:TType;
begin
	vlIdent := TType(fCurrentItemList.GetDefault(ParDefault,ParSize,ParSign));
	if vlIdent=nil then vlIdent := iCollection.GetDefaultIdent(ParDefault,ParSize,ParSign);
	GetDefaultIdent := vlIdent;
end;

function   TNDCreator.AddType(const ParNames:string;ParType:TType):TType;
begin
	if (ParType <> nil)  then begin
		ParType.SetText(ParNames);
		AddIdent(ParType);
	end;
	exit(ParType);
end;

procedure  TNDCreator.ErrorText(ParError:TErrorType;const ParText:string);
begin
	if (ParError <> Err_No_Error) and (fCompiler <> nil) then fCompiler.ErrorText(ParError,ParText);
end;


procedure   TNDCreator.ErrorDef(ParError : TErrorType;ParDef : TDefinition);
begin
	ErrorDefText(ParError,'','',ParDef);
end;

procedure  TNDCreator.ErrorDefText(ParError : TErrorType;const ParPre,ParAfter : string;ParDef : TDefinition);
var
	vlText :string;
begin
	if ParDef <> nil then begin
		vlText := ParDef.GetErrorName;
	end else begin
		vlText := '<NULL Definition>';
	end;
	ErrorText(ParError,ParPre+' ' + vlText +' '+ ParAfter);
end;



procedure  TNDCreator.AddNodeListError(ParNode : TNodeList;ParError : TErrorType;const ParText : string);
begin
	AddNodeError(TNodeIdent(ParNode.fStart),ParError,ParText);
end;


procedure TNDCreator.AddNodeError(ParNode:TNodeIdent;ParError:TErrorType;const partext:string);
var vlLine,vlCol,vlPos:Longint;
begin
	ParNode.GetPos(vlLine,vlCol,vlPos);
	if vlLine = 0 then begin
		writeln(ParNode.ClassName);
		runerror(1);
	end;
	AddError(ParError,vlLine,vlCol,vlPos,ParText);
end;

procedure TNDCreator.AddNodeDefError(ParNode:TNodeIdent;ParError:TErrorType; ParDef : TDefinition);
var
	vlText : string;
begin
	if ParDef <> nil then begin
		vlText := ParDef.GetErrorName;
	end else begin
		vlText := '<NULL Definition>';
	end;
    AddNOdeError(ParNode,ParError,vlText);
end;


procedure TNDCreator.SemError(ParError:TErrorType);
begin
	ErrorText(ParError,'');
end;

procedure  TNDCreator.InitUnitUseList;
begin
	iUnitUseList := TUnitUseList.Create;
end;

function TNDCreator.AddDepUse(const ParUnit,ParDep:string):TErrorType;
begin
	AddDepUse := iUnitUseList.AddDependence(ParUnit,ParDep,0);
end;


procedure TNDcreator.AddUnitInUse(const ParUnit:string);
var vlName:string;
	vlErr:TErrorType;
begin
	GetModuleName(vlName);
	vlErr := AddDepUse(vlName,ParUnit);
	if vlErr <> Err_No_Error then SemError(vlErr);
end;


function TNDCreator.AddUnitUse(const parUnit:string;ParState:TUnitLoadStates):boolean;
begin
	AddUnitUse := iUnitUseList.AddUnit(ParUnit,ParState);
end;

procedure TNDCreator.CommonSetup;
begin
	inherited CommonSetup;
	voForwardList := nil;
	iUnitUseList := nil;
	voCollection      := TIdentListCollection.Create;
	voCurrentItemList := TCurrentDefinitionList.Create;
	iGLobalHashing    := THashing.Create;
	iCurrentDefAccess := AF_Private;
	iInPublicSection  := false;
	iCurrentDefModes  := [];
	initforwardList;
	InitUnitUseList;
	InitLoader;
end;

function TNDCreator.GetPtrByObject(const ParName : string;ParObject : TRoot;var ParOwner,ParResult : TDefinition) : TObjectFindState;
var vlState : TObjectFindState;
begin
	vlState := fCurrentItemList.GetPtrByObject(ParName,ParObject,ParOwner,ParResult);
	if vlState = OFS_Different then begin
		vlState := iCollection.GetPtrByObject(ParName,ParObject,ParOwner,ParResult);
	end;
	exit(vlState);
end;

function TNDCreator.GetPtrByArray(const ParName : string;const ParArray : array of TRoot;var ParOwner,ParResult : TDefinition) : TObjectFindState;
var vlState : TObjectFindState;
begin
	vlState := fCurrentItemList.GetPtrByArray(ParName,ParArray,ParOwner,ParResult);
	if vlState = OFS_Different then begin
		vlState := iCollection.GetPtrByArray(ParName,ParArray,ParOwner,ParResult);

	end;
	exit(vlState);
end;



function TNDCreator.GetIdentByName(const ParName :string;var ParOwner,ParItem : TDefinition):boolean;
begin
	if fCurrentItemList.GetPtrByName(ParName,parOwner,ParItem) then begin
		exit(true);
	end;
	exit(iCollection.GetPtrByName(ParName,ParOwner,ParItem));
end;

function TNDCreator.GetPtr(const ParName:string):TDefinition;
var vlOwner :  TDefinition;
	vlRes   :  TDefinition;
begin
	GetIdentByName(ParName,vlOwner,vlRes);
	exit(vlRes);
end;

destructor TNDCreator.Destroy;
begin
	inherited Destroy;
	if fCurrentUnit       <> Nil then fCurrentUnit.Destroy;
	if iCollection      <> nil then iCollection.Destroy;
	if fLoader          <> nil then fLoader.Destroy;
	if fForwardList     <> nil then fForwardList.Destroy;
	if iUnitUseList       <> nil then iUnitUseList.Destroy;
	if fCurrentItemList   <> nil then fCurrentItemList.Destroy;
	if iGlobalHashing     <> nil then iGlobalHashing.Destroy;
end;

procedure  TNDCreator.SetCurrentDefModes(ParModes : TDefinitionModes;ParOn : boolean);
begin
	if ParOn then begin
		fCurrentDefModes := fCurrentDefModes + ParModes
	end else begin
		fCurrentDefModes := fCurrentDefModes - ParModes;
	end;
end;

procedure TNDCreator.AddGlobal(ParItem : TDefinition);
begin
	fCurrentUnit.AddGlobal(self,ParItem);
end;

procedure  TNDCreator.PreAdd(ParDef:TDefinition;var ParCur:TDefinition);
begin
	ParCur            := GetCurrentInsertItem;
	if ParDef.fDefAccess = AF_Current then ParDef.fDefAccess := fCurrentDefAccess;
	ParDef.fOwner     := GetCurrentDefinition;
	ParDef.SetModule(fCurrentUnit);
	if DM_CPublic in fCurrentDefModes then begin
		if (ParDef.SignalCPublic) {and ((ParCur = nil) or (ParCur.HasGlobalParts))} then fCurrentUnit.AddGlobal(self,ParDef);
	end;
	if fInPublicSection then ParDef.SignalInPublicSection;
end;

procedure  TNDCreator.AddAtCurrentList(ParIdent:TDefinition);
var vlErr : longint;
	vlCur : TDefinition;
begin
	if ParIdent = nil then exit;
	PreAdd(ParIdent,vlCur);
	ParIdent.fOwner := nil;{Hack, Ident at currentlist shouldn't have a owner ,this is Set in PreAdd}
	{Set of Owner to AddIdent? or at AddIdent of ident where ident is added to}
	vlErr := iCollection.AddIdentToCurrentList(parIDent);
	if vlErr <> ERR_No_Error then SemError(vLErr);
end;

procedure TNDCreator.AddIdent(ParItem:TDefinition);
var
	 vlErr     : TErrorType;
 	 vlCur     : TDefinition;
begin
	PreAdd(ParItem,vlCur);
	if vlCur <> nil then begin
		vlErr := vlCur.AddIdent(Paritem);
	end else begin
		vlErr := iCollection.AddIdentToCurrentList(ParItem);
	end;
	if vlErr <> ERR_No_Error then begin
		ErrorDef(vlErr,ParItem);
	end;
end;


function    TNDCreator.GetIntSizeByRange(const Pari1,ParI2:TNumber;var ParSize:TSize;var ParSign:boolean):boolean;
var
	vlMax   : TNumber;
	vlMin   : TNumber;
begin
	if LargeCompare(ParI1,ParI2) =LC_Lower then begin
		vlMax := ParI2;
		vlMin := ParI1;
	end else begin
		vlMax := ParI1;
		vlMin := ParI2;
	end;
	if LargeRangeInRange(vlMin,vlMax,Min_Byte,Max_Byte) then begin
		ParSize := 1;
		ParSign := false;
	end else
	if LargeRangeInRange(vlMin,vlMax,Min_Word,Max_Word) then begin
		ParSize := 2;
		ParSign := false;
	end else
	if LargeRangeInRange(vlMin,vlMax,Min_Cardinal,Max_Cardinal) then begin
		ParSize := 4;
		ParSign := false;
	end else
	if LargeRangeInRange(vlMin,vlMax,Min_Short,Max_Short) then begin
		ParSize := 1;
		ParSign := true;
	end else
	if LargeRangeInRange(vlMin,vlMax,Min_Integer,Max_Integer) then begin
		ParSize :=2 ;
		ParSign := true;
	end else
	if LargeRangeInRange(vlMIn,vlMax,Min_Longint,Max_Longint) then begin
		ParSize := 4;
		ParSign := true;
	end else begin
		ParSize:=0;
		ParSign := false;
		exit(true);
	end;
	exit(false);
end;


function TNDCreator.GetCheckDefaultType(ParDef : TDefaultTypecode;ParSize : TSize;ParSign : boolean;const ParMsg : string) : TType;
var vlType : TType;
begin
	vlType := GetDefaultIdent(ParDef,ParSize,ParSign);
	if vlType = nil then ErrorText(Err_Cant_Find_Type,ParMsg);
	exit(vlType);
end;

function TNDCreator.GetDefaultChar : TType;
begin
	exit(GetCheckDefaultType(DT_Char,0,false,'char'));
end;

function    TNDCreator.GetIntType(ParNum1,ParNum2:TNumber):TType;
var vlSize : TSize;
	vlSign : boolean;
	vlType : TType;
begin
	vlType := nil;
	if not GetIntSizebyRange(ParNum1,PArNum2,vlSize,vlSign) then begin
		vlType := GetCheckDefaultType(DT_Number,vlSize,vlSign,'number');
	end;
	exit(vlType);
end;

function  TNDCreator.CreateIntNodeLong(ParNUm : cardinal) : TNodeIdent;
var vlNum : TNumber;
begin
	LoadLong(vlNum,ParNum);
	exit(CreateIntNode(vlNum));
end;


function TNDCreator.CreateIntNode(ParNum : TNumber) : TNodeIdent;
var vlVal  : TLongint;
	vlNode : TNodeIdent;
	vlType : TType;
begin
	vlNode := nil;
	vlType := GetIntType(ParNum,ParNum);
	if vlType <> nil then begin
		vlVal  := TLongInt.create(ParNum);
		vlNode := TConstantValueNode.create(vlVal,vlType);
	end else begin
		SemError(Err_Cant_Find_Type);
	end;
	exit(vLNode);
end;


function TNDCreator.ConvertTextToNode(ParStr : TStringBaseValue) : TNodeIdent;
var
	vlType : TType;
	vlDefType : TDefaultTypeCode;
begin
	vlDefType := DT_String;
{	if ParStr.GetLength=1 then vlDefType := DT_Char;}
	vlType := GetDefaultIdent(vlDefType,0,false);
	if vlType = nil then SemError(Err_Cant_Find_Type);
	exit(TConstantValueNode.Create(ParStr,vlType));
end;


function TNDCreator.AddStringConst(const ParName : string;const ParStr : string) : TDefinition;
var vlType        : TType;
	vlStringConst : TStringCons;
begin
	vlType :=GetDefaultIdent(DT_String,0,false);
	if vlType =nil then begin
		SemError(Err_Cant_Find_Type);
		exit;
	end;
	vlStringConst := TStringCons.Create(ParName,ParStr,vlType);
	AddIdent(vlStringConst);
	exit(vlStringConst);
end;

procedure TNDCreator.AddStringConst(ParName:TNameList;const PArStr:string);
var vlCurrent : TNameItem;
	vlName    : string;
begin
	vlCurrent := TNameItem(ParName.fStart);
	while vlCurrent <> nil do begin
		vlCurrent.GetTextStr(vlName);
		AddStringConst(vlName,ParStr);
		vlCurrent := TNameItem(vlCUrrent.fNxt);
	end;
end;


function  TNDCreator.AddConstant(const ParName : string;const ParCon : TValue;ParType : TType):TDefinition;
var
	vlIntConst : TConstant;
begin
	vlIntConst := TConstant.Create(ParName,ParType);
	vlIntConst.SetValue(ParCon.clone);
	AddIdent(vlIntConst);
	exit(vlIntConst);
end;

function  TNDCreator.AddConstant(const ParName : string;const ParCon : TValue):TDefinition;
var vlType     : TType;
	vlNum      : TNumber;
begin
	vlType := nil;
	if (ParCon is TLongint) then begin
		ParCon.GetNumber(vlNum);
		vlType :=GetIntType(vlNum,vlNum);
	end else if (ParCon is TBoolean) then begin
		vlType := GetCheckDefaultType(DT_Boolean,0,false,'boolean');
	end else if (ParCon is TPointer) then begin
		vlType := GetCheckDefaultType(DT_Pointer,0,false,'pointer');
	end else begin
	{Todo else}
		writeln('Todo else');runerror(1);
	end;
	if vlType =nil then begin
		SemError(Err_Cant_Find_Type);
		exit;
	end;
	exit(AddConstant(ParName,ParCon,vlType));
end;

procedure TNDCreator.AddConstant(ParName:TNameList;const ParCon:TValue);
var vlCurrent  : TNameItem;
	vlName     : string;
begin
	vlCurrent := TNameItem(ParName.fStart);
	while vlCurrent <> nil do begin
		vlCurrent.GetTextStr(vlName);
		AddConstant(vlName,ParCon);
		vlCurrent := TNameItem(vlCUrrent.fNxt);
	end;
end;

procedure TNDCreator.AddVar(ParNameList:TNameList;ParType:TType);
var vlCurrent : TNameItem;
	vlStr     : string;
	vlVar     : TVariable;
	vlCurDef  : TDefinition;
begin
	if (ParType <> nil) then begin
		if(ParType.fSize = 0) then ErrorDef(Err_Cant_Determine_Size,ParType);
		vlCurrent := TNameItem(ParNameList.fStart);
		vlCurDef := GetCurrentDefinition;
		while vlCurrent <> nil do begin
			vlCurrent.GetTextStr(vlStr);
			if vlCurDef <> nil then begin
				vlVar := TVariable(vlCurDef.CreateVar(self,vlStr,ParType))
			end else begin
				 vlVar := TVariable.Create(vlStr,ParType);
			end;
			SetDefinitionPos(vlVar);
			vlVar.fDefAccess := AF_Current;
			AddIdent(vlVar);
			vlCurrent := TNameItem(vlCurrent.fNxt);
		end;
		
	end;
end;


function TNDCreator.LoadUnit(ParLoader:TObjectStream;const ParUnit:string;ParLevel : TUnitLevel;ParPublic:boolean):TUnit;
var vlUnit:TUnit;
begin
	LoadUnit := nil;
	if ParLoader.OpenFile(ParUnit+CNF_Unit_Ext) then begin
		ErrorText(Err_Cant_Open_Unit_File,ParUnit + CNF_Unit_Ext);
		exit;
	end;
	CreateObject(ParLoader,TStrAbelRoot(vlUnit));
	if vlUnit = nil then begin
		ErrorText(Err_invalid_Unit,ParUnit)
	end else begin
		iCollection.AddIDentList(ParUnit,ParLevel,vlUnit.fItemList,ParPublic);
	end;
	LoadUnit:= vlUnit;
	ParLoader.CloseFile;
end;

procedure TNDCreator.Save;
var vlErr:TErrortype;
begin
	vlErr := fCurrentUnit.Save;
	if vlErr <> err_No_Error then SemError(vlErr);
end;

constructor TNDCreator.Create(const ParName:String;ParCompiler:TCompiler_Base);
begin
	inherited Create(ParCompiler);
	InitModule(ParName);
end;

procedure TNDCreator.CreateSec;
begin
	fCurrentUnit.CreateSec(fCompiler);
end;




end.

