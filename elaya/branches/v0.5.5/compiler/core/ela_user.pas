{    Elaya, the xcompiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web  : www.elaya.org

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

unit ela_user;
interface
uses frames,largenum,confnode,progutil,module,linklist,compbase,initstrm,cmp_base,stdobj,cblkbase,
error,types,elaTypes,node,formbase,elacfg,ddefinit,NDCreat,confval,meta,nlinenum,blknodes,
cdfills,extern,cmp_type,asminfo,cfgp,sysutils,execobj,vars,varbase,elacons,procs,classes,exprdigi,stmnodes;
	
type	TEla_User=class(TCompiler_Base)
	private
		voNdCreator       : TNDCreator;
		voOwnConfig       : boolean;
		voPrvConfigValues : TConfigValues;
		voDestroyCfgVal   : boolean;
		
	protected
		property iOwnConfig       : boolean       read voOwnConfig       write voOwnConfig;
		property iPrvConfigValues : TConfigValues read voPrvConfigValues write voPrvConfigValues;
		property iNdCreator	  : TNDCreator	  read voNDCreator	 write voNDCreator;
		property iDestroyCfgVal   : boolean	  read voDestroyCfgVal   write voDestroyCfgVal;
	procedure   clear;override;
	procedure  Commonsetup;override;

		
	private
		
	procedure OverrideRoutine(ParCurrentMeta : TMeta;ParOVMOdes : TOVModes;ParOther,ParRoutine : TRoutine);
	procedure VirtualizeRoutine(ParCurrentMeta : TMeta;ParOVMOdes : TOVMOdes;ParRoutine : TRoutine);
	
public
	function  ProcessOperator(const ParParameters  : array of TNodeIdent;
						      var   ParPrvPar      : TNodeIdent;
							  const ParOperStr     : string;
							  ParError : boolean):TOperatorProcessResult;

	property   fNDCreator : TNDCreator read voNDCreator;
	function   SetupCompiler:boolean;override;
	procedure  InitConfig;
	procedure  SetNDCreator(ParCre:TNDCreator);
	function   SetEnumBegin:TType;
	procedure  EndEnum;
	procedure  Addident(Parident:TDefinition);
	function   AddNodeToNode(ParNode1 : TNodeIdent;var ParNode2:TNodeIdent):boolean;
	procedure  AddVar(ParName:TNameList;ParType:TType);
	procedure  Bind;
	procedure  ProcessParsed;override;
	procedure  GetConfigFileName(var ParName : string); virtual;
	procedure  Save;override;
	procedure  EndIdent;
	function   CreateExternalInterface(ParName : TString;ParType :TExternalType;ParHAsAt : boolean;ParAt: longint):TExternalInterface;
	procedure  CreateExternalInterfaceObject(ParCDecl:boolean;ParRoutine :TRoutine;
	ParExt : TExternalInterface;var ParName : TString);
	function  ProcessRoutineItem(var ParRoutine   : TRoutine;
	ParIsolate      : boolean;
	ParRootCB       : boolean;
	ParInhFinal     : boolean;
	ParInherited    : boolean;
	const ParParent : string;
	ParVirtual      : TVirtualMode;
	ParOverLoad     : TOverloadMode;
	ParAbstract     : boolean
	):TRoutine;
	constructor Create(const ParFileName:string);
	
	procedure AddLoopFlowNode(var ParNode:TNodeIdent;ParType:TRefLoopFlowNode);
	procedure AddBreakNode(var ParNode : TNodeIdent);
	procedure AddContinueNode(var ParNode : TNodeIdent);
	procedure OpenFileFailed(ParError : TErrorType);override;
	function GetModule : TUnit;
	procedure  ProcessDualOperator(
	var   ParNewPar  : TNodeIdent;
	var   ParPrvPar  : TNodeIdent;
	const ParOprStr  : String;
	ParOperObj : TRefNodeIdent);
	
	procedure ProcessBetweenOperator(
	ParO1,ParO2,ParO3    : TNodeIdent;
	var ParPrvPar: TNodeIdent;
	const ParOprStr    : String);
	
	procedure ProcessSingleOperator(
	ParNewPar    : TNodeIdent;
	var ParPrvPar: TNodeIdent;
	const ParOprStr    : String;
	ParOperObj   : TRefNodeIdent);
	procedure ProcessCompOperator(
	ParNewPar    : TNodeIdent;
	var ParPrvPar: TNodeIdent;
	const ParOprStr    : String;
	ParCode	     : TIdentCode);
	
	function  CreateShortERtn(ParRoutine : TDefinition;ParDigi : TDigiItem): TRoutine;
	procedure CreateShortSubCb( ParRoutine    : TRoutine;
	const ParName  : string;
	var   ParNewCB : TRoutine;
	var   ParError : boolean);
	
	function  CreatePointerType(ParType : TType;ParConstFlag : boolean):TPtrType;
	function  CreatePointerType(const ParName : string;ParCanForward, ParConstFlag:boolean):TPtrType;
	function  CreateIntNode(ParCon : TNumber) : TFormulaNode;
	procedure ProcessShortDyRoutine(ParRoutine : TRoutine);
	function  ProcessShortSubCB(ParRoutine : TRoutine) : TRoutineNode;
	procedure CreateFormulaShortSubCb(ParRoutine : TRoutine;ParNode : TFormulaNode);
	procedure AddAnonItem(ParDef : TDefinition);
	function  CreateExitNode(ParExp : TFormulaNode) : TNodeIdent;
	procedure HandleDefaultType(var ParDt : TDefaultTypeCode;ParDef : TDefaultTypeCode;ParValid : TDefaultTypes);
	procedure WriteResFile;
	function  CreateStringType(ParType :TType;const ParLengthVarName : string;ParLengthVarType : TType;ParDefaultSize : boolean;ParSize : TSize;ParHasSize:boolean):TStringType;
	procedure AddObjectFile(ParCodeFile : TString;ParIsCurrentObject:boolean;ParHasAt : boolean;ParAt : longint);
	procedure ErrorDef(const ParError : TErrorType ;ParDef : TDefinition);
	procedure SetNodePos(ParNode : TNodeIdent);
	procedure HandleHasClause(const ParName : string);
	procedure DoIdentObject(ParLocal :TDefinition;var ParDef : TDefinition;var ParDigi : TIdentDigiItem;var ParMention : TMN_Type;const ParIdent : string);
	procedure DoInheritedOfMain(ParLevel : cardinal;var ParDigi : TIdentHookDigiItem);
	function  CalculationStatusToError(ParCs :TCalculationStatus):boolean;
	function  CreateClassType(const ParName : string;const ParParent : string;ParVirtual : TVirtualMode;ParInCompleet ,ParIsolate: boolean):  TClassType;
	procedure HandleRoutineDotName(const ParName : string);
	function  CreateCDTor(const ParName : string;ParAccess : TDefAccess;ParCDFlag : boolean) : TRoutine;
	procedure OverrideClass(ParOther : TDefinition;ParClass : TClassTYpe;ParMeta : TMeta);
	procedure SetDigiPos(ParDigi :TDigiItem);
	function CreateBooleanType(ParSize : TSize) :TType;
	function HandleDeReference(ParDigi : TDigiItem) : TIdentHookDigiItem;
	function HandleDotOperator(ParDigi : TDigiItem;const ParIdent : string) : TDotOperDigiItem;
	procedure DoPropertyDefinition(ParName : string;ParAccess : TDefAccess;ParPropertyType : TPropertyType;ParProperty :TProperty);
	procedure HandleWriteStatement(ParExpr : TFormulaNode;const ParName : string;ParRoutine,Parowner : TDefinition;ParNode : TNodeIdent);

end;

implementation


procedure TEla_User.HandleWriteStatement(ParExpr : TFormulaNode;const ParName : string;ParRoutine,ParOwner : TDefinition;ParNode : TNodeIdent);
var
	vlNode    : TCallNode;
begin
	vlNode := nil;
	if (ParRoutine <>nil) and (ParNode <> Nil)  and (ParExpr <> nil) then begin
		vlNode := TCallNode(ParRoutine.CreateExecuteNode(fNDCreator,ParOwner));
		if (vlNode = nil) or not(vlNode is TCallNode) then begin
			if (vlNode <> nil) then vlNode.Destroy;
			vlNode := nil;
			SemError(Err_Cant_Execute);
		end else begin
			if length(ParName) > 0 then begin
				vlNode.AddNodeAndName(ParExpr,ParName);
			end else begin
				vlNode.AddNode(ParExpr);
			end;
			ParNode.AddNode(vlNode);
		end;
	end;
	if (vlNode = nil) and (ParExpr <> nil) then ParExpr.Destroy;
end;

procedure TEla_User.DoPropertyDefinition(ParName : string;ParAccess : TDefAccess;ParPropertyType : TPropertyType;ParProperty :TProperty);
var
	vlOwner    : TDefinition;
	vlIdent    : TDefinition;
begin
	fNDCreator.GetPtrInCurrentList(ParName,vlOwner,vlIdent);
	if vlIdent = nil then ErrorText(Err_Unkown_Ident,ParName);
	if vlIdent = ParProperty then begin
		ErrorText(Err_cant_use_cur_property,ParName);
	end else begin
		ParProperty.AddPropertyItem(fNDCreator,ParAccess,ParPropertyType,TFormulaDefinition(vlIdent),vlOwner);
	end;
end;

function TEla_User.HandleDotOperator(ParDigi : TDigiItem;const ParIdent : string): TDotOperDigiItem;
var
	vlOut       : TIdentHookDigiItem;
	vlDotOper   : TDotOperDigiItem;
	vlFieldDigi : TNamendIdentDigiItem;
begin
	vlFieldDigi := TNamendIdentDigiItem.Create(ParIdent);
	SetDigiPos(vlFieldDigi);
	vlOut := TIdentHookDigiItem.Create(vlFieldDigi);
	SetDigiPos(vlOut);
	vlDotOper := TDotOperDigiItem.Create(ParDigi,vlOut,vlFieldDigi);
	SetDigiPos(vlDotOper);
	exit(vlDotOper);
end;

function TEla_User.HandleDeReference(ParDigi : TDigiItem) : TIdentHookDigiItem;
var
	vlDigi : TDigiItem;
	vlOut  : TIdentHookDigiItem;
begin
	vlDigi := TByPointerOperatorDigiItem.Create(ParDigi);
	SetDigiPos(vlDigi);
	vlOut := TIdentHookDigiItem.Create(vlDigi);
	SetDigiPos(vlOut);
	exit(vlOut);
end;


procedure TEla_user.SetDigiPos(ParDigi :TDigiItem);
begin
	if parDigi <> nil then begin
		ParDigi.fCol  := Col;
		ParDigi.fPos  := Pos;
		ParDigi.fLine := Line;
	end;
end;


function TEla_User.CreateBooleanType(ParSize : TSize) :TType;
begin
	if not (ParSIze in [1,2,4]) then SemError(Err_Illegal_Type_Size);
	exit(TBooleanType.Create(ParSize));
end;


function TEla_user.CreateCDTor(const ParName : string;ParAccess : TDefAccess;ParCDFlag : boolean) : TRoutine;
var
	vlDef  : TDefinition;
	vlType : TType;
	vlRes  : TCDTorsRoutine;
begin
	vlDef := fNDCreator.GetCurrentDefinition;
	
	if (vlDef= nil) or not(vlDef is TClassType) then begin
		SemError(Err_CDTor_only_in_class);
		vlType := nil;
	end else begin
		if not ParCDFlag then begin
			vlType := fNDCreator.GetCheckDefaultType(DT_Pointer,0,false,'pointer');
		end else begin
			vlType := TClassType(vlDef);
		end;
	end;
	if ParCDFlag then begin
		vlRes := TConstructor.Create(ParName);
	end else begin
		vlRes := TDestructor.Create(ParName);
	end;
	vlRes.SetFunType(fNDCreator,vlType);
	vlRes.fDefAccess := ParAccess;
	exit(vlRes);
end;




procedure TEla_User.OverrideClass(ParOther : TDefinition;ParClass : TClassTYpe;ParMeta : TMeta);
begin
	if (ParOther = nil) then begin
		ErrorDef(Err_OVr_No_virtual_found,ParClass);
	end else if not (ParOther is TClassType) then begin
		ErrorDef(Err_Ovr_different_kind_obj,ParOther);
	end else begin
		if not(TClassType(ParOther).IsVirtual) then begin
			ErrorDef(Err_Ovr_Allready_Static,ParOther);
		end else begin
			ParClass.InitVirtualMeta(ParMeta.ChangeVirtualRoutine(TClassTYpe(ParOther).fMeta,ParClass.fMeta));
			exit;
		end;
		if (ParClass.fParent = nil) or not(ParOther.IsParentOf(ParClass)) then ErrorDef(Err_Parent_not_over_ident,ParClass);
	end;
	ParClass.InitVirtualMeta(ParMeta.AddVirtualRoutine(ParClass.fMeta));
end;

function  TEla_user.CreateClassType(const ParName : string;const ParParent : String;ParVirtual : TVirtualMode;ParInCompleet,ParIsolate : boolean): TClassType;
var
	vlParent : TClassType;
	vlType   : TCLassType;
	vlCurrent : TDefinition;
	vlMeta    : TMeta;
	vlOther   : TDefinition;
	vlOvModes : TOvModes;
	vlFoundInCompleet : boolean;

	function FindIncompleet(const ParName : string;var ParType :TClassType) : boolean;
	var
		vlType : TType;
	begin
		ParType := nil;
		vlType := TType(fNDCreator.GetPtr(ParName));
		if vlType <> nil then begin
			if vlType is TClassType then begin
				if TClassType(vlType).fInCompleet then begin
					ParType := TClassType(vlType);
					exit(true);
				end;
			end;
		end;
		exit(false);
	end;

begin
	vlType := nil;
	vlFoundIncompleet := false;
	if length(ParParent) <> 0 then begin
		vlParent := TClassType(fNDCreator.GetCheckItem(ParParent));
		if vlParent <> nil then begin
			if not(vlParent is TClassType) then begin
				ErrorText(Err_Not_A_Class,ParParent);
				vlParent := nil;
			end else if vlParent.fInCompleet then begin
				ErrorText(Err_Parent_Class_Incompleet,ParParent);
				vlParent := nil;
			end;
		end;
	end else begin
		vlParent := nil;
	end;
	if not(ParInCompleet) then vlFoundIncompleet := FindInCompleet(ParName,vlType);

	if not vlFoundInCompleet then begin
		vlType   := TClassType.Create(vlParent,ParInCompleet);
		fNDCreator.AddType(ParName,vlType);
	end else begin
		vlType.fParent := vlParent;
	end;
	if not ParInCompleet then vlType.SetMetaFramePtr(fNDCreator);
	vlCurrent := fNDCreator.GetCurrentDefinition;
    if vlCurrent <>nil then begin
		if not(ParIsoLate) then ErrorText(Err_Nested_Require_Isolate,ParName);
	end;
	if ParVirtual <> Vir_None then begin
		vlMeta := nil;
		vlOther := nil;
		if vlType.fDefAccess  = AF_Private then SemError(Err_Acc_Must_atl_Protected);
		if vlCurrent <> nil then vlCurrent.GetOvData(fNDCreator,vlType,vlOther,vlOvModes,vlMeta);
		if vlMeta = nil then begin
			SemError(Err_Identifier_cant_have_vir);
		end else begin
			case ParVirtual of
				vir_virtual :begin
					if (vlOther <> nil) and (vlOther is TClassType) then begin
						if (TClassType(vlOther).IsVirtual) then ErrorDef(Err_Virt_allready_Virt,vlTYpe);
					end;
					vlType.InitVirtualMeta(vlMeta.AddVirtualRoutine(vlType.fMeta));
				end;
				vir_Override: overrideClass(vlOther,vlType,vlMeta);
			end;
		end;
	end;
	if not(ParInCompleet) then fndCreator.AddCurrentDefinition(vlType);
	vlType.fIncompleet := ParInCompleet;
	exit(vlType);
end;


function TEla_user.CalculationStatusToError(ParCs :TCalculationStatus):boolean;
var vlErr : boolean;
begin
	vlErr := true;
	case ParCs of
		CS_Ok		     : vlErr :=false;
		CS_Invalid_Operation : SemError(Err_Invalid_Operation);
		CS_Out_Of_Range      : SemError(Err_Num_Out_Of_Range);
		else begin
			SemError(Err_int_Value_Ret_Unk_Err);
		end;
	end;
	exit(vlErr);
end;



procedure TEla_User.DoInheritedOfMain(ParLevel : cardinal;var ParDigi : TIdentHookDigiItem);
var
	vlRoutine : TRoutine;
	vlLevel   : cardinal;
	vlItem    : TIdentDigiItem;
	vlName : string;
begin
	ParDigi := nil;
	vlRoutine := TRoutine(fNDCreator.GetCurrentRoutine);
	vlLevel := ParLevel;
	while (vlLevel <> 0) and (vlRoutine <> nil) do begin
		vlRoutine :=TRoutine(vlRoutine.GetParent);
		dec(vlLevel);
	end;
	if vlRoutine <> nil then begin
		if vlRoutine.fPhysicalAddress = nil then begin
			SemError(Err_Rtn_Has_No_Main);
		end else begin
			vlRoutine.fPhysicalAddress.GetTextStr(vlName);
			vlItem := TIdentDigiItem.Create(vlRoutine.fPhysicalAddress,vlRoutine);
			SetDigiPos(vlItem);
			ParDigi := TIdentHookDigiItem.Create(vlItem);
			SetDigiPos(ParDigi);
		end;
	end else begin
		SemError(err_Has_No_Parent);
	end;
end;


procedure TEla_User.DoIdentObject(ParLocal :TDefinition;var ParDef : TDefinition;var ParDigi  : TIdentDigiItem;var ParMention : TMN_Type;const ParIdent:string);
var
	vlMention : TMN_Type;
	vlDef     : TFormulaDefinition;
	vlOwner   : TFormulaDefinition;
begin
	if ParlOcal = nil then begin
		fNDCreator.GetIdentByName(ParIdent,vlOwner,TDefinition(vlDef));
	end else begin
		ParLocal.GetPtrByName(ParIdent,[SO_Local],vlOwner,TDefinition(vlDef));
	end;
	vlMention := MT_Other;
	if vlDef<> nil then begin
		if vlDef.Can([Can_Type]) then vlMention := MT_Type;
			if vlDef.Can([Can_Execute]) then vlMention := MT_Call;
	end else  begin
		vlMention := MT_Error;
		ErrorText(Err_Unkown_Ident,ParIdent);
	end;
	ParDef := vlDef;
	ParDigi := TIdentDigiItem.Create(vlDef,vlOwner);
	SetDigiPos(ParDigi);
	ParMention := vlMention;
end;

procedure TEla_User.HandleRoutineDotName(const ParName : string);
var vLDef : TDefinition;
	vlOwner : TDefinition;
	vlName  : string;
begin
	fNDCreator.GetPtrInCurrentList(ParName,vlOwner,vlDef);
	if(vlDef = nil) or ( not(vlDef is classes.TClassType)) then begin
		if vlDef = nil then begin
			ErrorText(Err_Unkown_Ident,ParName)
		end else begin
			ErrorDef(Err_ClassName_Expected,vlDef);
		end;
		GetNewAnonName(vlName);
		vlDef := TProcedureObj.Create(vlName);
		vlDef := ProcessRoutineItem(TRoutine(vlDef),false,true,false,false,'',vir_none,ovl_none,false);
	end else begin
		fNDCreator.AddCurrentDefinition(vlDef);
	end;
end;


procedure TEla_User.HandleHasClause(const ParName : string);
var vlDef : TDefinition;
	vlName : string;
	vlRoutine : TRoutine;
	vlOwner   : TRoutine;
begin
	fNDCreator.GetPtrInCurrentList(ParName,vlOwner,vlDef);
	if (vlDef = nil) or not(vlDef is TRoutineCollection) then begin
		if vlDef <> nil then ErrorText(Err_Not_A_Routine,ParName)
		else ErrorText(Err_Unkown_Ident,ParName);
		GetNewAnonName(vlName);
		vlDef := TProcedureObj.Create(vlName);
		vlDef := ProcessRoutineItem(TRoutine(vlDef),false,true,false,false,'',vir_none,ovl_none,false);
	end else begin
		if TRoutineCOllection(vlDef).IsOverloaded then ErrorText(Err_Is_Overloaded,ParName);
		vlRoutine := TRoutineCOllection(vlDef).GetFirstRoutine;
		fNDCreator.AddCurrentDefinition(TRoutineCollection(vlDef).GetFirstRoutine);
		if not(RTM_extended in vlRoutine.fRoutineModes) then ErrorText(Err_Rtn_Is_Not_extended,ParName) else
		if not (RTS_Has_Sr_Lock in vlRoutine.fRoutineStates) then ErrorText(Err_Rtn_Has_No_Forward ,ParName);
	end;
end;




procedure TEla_User.SetNodePos(ParNode : TNodeIdent);
begin
	fNDCreator.SetNodePos(ParNode);
end;

procedure TEla_user.ErrorDef(const ParError : TErrorType ;ParDef : TDefinition);
var
	vlName :string;
begin
	EmptyString(vlName);
	if (ParDef <> nil) and (ParDef is TDefinition) then ParDef.GetDisplayName(vlName);
	ErrorText(ParError,vlname);
end;

procedure  TEla_User.AddObjectFile(ParCodeFile:TString;ParIsCurrentObject:boolean;ParHasAt : boolean;ParAt : longint);
begin
	GetModule.AddCodeFile(TCodeObjectItem.Create(ParCOdefile,ParIsCurrentObject,ParHasAt,ParAt));
end;


function  TEla_user.CreateStringType(ParType :TType;const ParLengthVarName : string;ParLengthVarType : TType;ParDefaultSize : boolean;ParSize : TSize;ParHasSize:boolean):TStringType;
var vlType          : TType;
	vlLengthVarName : string;
	vlLengthVarType : TType;
	vlSize          : TSize;
	vlMaxSize       : TNumber;
begin
	vlType := ParType;
	if vlType = nil then vlType := fNDCreator.GetDefaultChar;
	if length(ParLengthVarName) = 0 then begin
		vlLengthVarType := TNumberType(fNDCreator.GetCheckDefaultType(DT_Number,1,false,'number'));
		vlLengthVarName := Name_StrLength;
	end else begin
		vlLengthVarName := ParLengthVarName;
		vlLengthVarType := ParLengthVarType;
	end;
	vlSize := 0;
	if vlLengthVarType <> nil then begin
		if  vlLengthVarType.IsLike(TNumberType) then begin
			vlMaxSize := TNumberType(vlLengthVarType).GetRangeMax;
			if ParHasSize then begin
				vlSize := ParSize;
				if ((vlSize =0) and not(ParDefaultSize)) or (LargeCompareLong(vlMaxSize,vlSIze)=LC_Lower) then SemError(Err_Illegal_Type_Size);
			end else begin
				vlSize    := 255;
				if LargeCompareLong(vlMaxSize,vlSize)=LC_Lower then vlSize :=LargeToCardinal(vlMaxSize);
			end;
		end else begin
			ErrorDef(Err_Not_A_Numeric_Type,vlLengthVarType);
			vlSize := 0;
		end;
	end;
	exit( TStringType.Create(vlType,ParDefaultSize,vlSize,vlLengthVarName,vlLengthVarType));
end;

procedure TEla_User.HandleDefaultType(var ParDt : TDefaultTypeCode;ParDef : TDefaultTypeCode;ParValid : TDefaultTypes);
begin
	case ParDT of
		DT_Nothing : exit;
		DT_Default : ParDt := ParDef;
	end;
	if not(ParDt in ParValid) then SemError(Err_Invalid_Default_Code);
end;

function  TEla_User.CreateExitNode(ParExp : TFormulaNode) : TNodeIdent;
var   vlNode : TNodeIdent;
	vlRoutine   : TRoutine;
begin
	vlRoutine   := TRoutine(fNDCreator.GetCurrentRoutine);
	if(vlRoutine = nil) then Fatal(Fat_No_Current_Routine,'');
	vlNode := vlRoutine.CreateExitNode(fNDCreator,ParExp);
	exit(vlNode);
end;

procedure TEla_User.AddAnonItem(ParDef : TDefinition);
var
	vlName : string;
begin
	if ParDef <> nil then begin
		GetNewAnonName(vlName);
		ParDef.SetText(vlName);
		fNDCreator.AddAtCurrentList(ParDef);
		ParDef.SetAnonymousIdent;
	end;
end;

procedure TEla_User.CreateFormulaShortSubCb(ParRoutine : TRoutine;ParNode : TFormulaNode);
var vlExit     : TExitNode;
	vlPrn      : TRoutineNode;
	vlLineInfo : TLineNumberNode;
begin
	vlPrn := nil;
	if (ParRoutine <> nil) and (ParNode <> nil) then begin
		vlExit := TExitNode(ParRoutine.CreateExitNode(fNDCreator,ParNode));
		vlPrn  := ParRoutine.fStatements;
	    if GetConfigValues.fGenerateDebug  then begin
    		vlLineInfo := TLineNumberNode.create;
    		vlLineInfo.fLine := ParNode.fLine;
    		AddNodeToNode(vlPrn,vlLineInfo);
    	end;
		AddNodeToNode(vlPrn,vlExit);
		vlPrn.FinishNode(fNDCreator,true);
	end;
end;

function TEla_User.ProcessShortSubCB(ParRoutine : TRoutine) : TRoutineNode;
var vlCblk : TRoutineNode;
begin
	ProcessRoutineItem(ParRoutine,false,false,false,false,'',VIR_Override,OVL_Type,false);
	vlCblk := TRoutineNode.Create(ParRoutine);
	ParRoutine.fStatements := vlCblk;
	exit(vlCblk);
end;

procedure TEla_User.ProcessShortDyRoutine(ParRoutine : TRoutine);
begin
	if ParRoutine <> nil then begin
		ParRoutine.PreNoMain(fNDCreator);
		ParRoutine.SetIsDefined;
		EndIdent;
	end;
end;


function TEla_User.CreateIntNode(ParCon : TNumber) : TFormulaNode;
var
	vlType : TType;
begin
	vlType := fNDCreator.GetIntType(ParCon,ParCon);
	if vlType = nil then begin
		SemError(Err_Cant_Find_Type);
		exit(nil);
	end;
	exit(TCOnstantValueNode.Create(TLongint.Create(ParCon),vlType));
end;


function TELa_User.CreatePointerType(const ParName : string;ParCanForward,ParConstFlag : boolean):TPtrType;
var
	vlType : TType;
	vlPtrType : TPtrType;
begin
	vlType := TTYpe(FNDCreator.GetPtr(ParName));
	if vlType <> nil then begin
		if  not(vlType is TType) then begin
			SemError(Err_Not_A_Type);
			exit(nil);
		end;
	end;
	vlPtrType := CreatePointerType(vlType,ParConstFlag);
	if vlType = nil then begin
		if not ParCanForward then begin
			ErrorText(Err_Unkown_Ident,ParName)
		end else begin
			fNDCreator.AddForwardBind(ParName,vlPtrType);
		end;
	end;
	exit(vlPtrType);
end;

function TEla_user.CreatePointerType(ParType : TType;ParConstFlag : boolean):TPtrType;
begin
	exit(TPtrType.Create(ParType,ParConstFlag));
end;


procedure TEla_user.CreateShortSubCb(ParRoutine : TRoutine;
const ParName : string;
var   ParNewCB: TRoutine;
var   ParError: boolean);

var
	vlOther   : TRoutineCollection;
	vlOtherCb : TRoutine;
	vlOwner   : TDefinition;
begin
	ParError := true;
	ParNewCB := nil;
	if ParRoutine = nil then exit;
	ParRoutine.GetPtrByName(ParName,[SO_Local],vlOwner,vlOther);
	if (vlOther = nil) then begin
		ErrorText(Err_Unkown_Ident,ParName)
	end else if not (vlOther is TRoutineCollection) then begin
		SemError(Err_Not_A_Routine);
	end else begin
		vlOtherCB :=  vlOther.GetFirstRoutine;
		ParNewCB  := vlOtherCB.CreateShortSubCb(fNDCreator);
		if ParNewCB=nil then begin
			ErrorText(Err_Int_Cant_Make_new_Sub,ParName);
		end else begin
			ParError := false;
		end;
	end;
end;


function TEla_user.CreateShortERtn(ParRoutine : TDefinition;ParDigi : TDigiItem): TRoutine;
var
	vlRoutine    : TRoutine;
	vlParent     : TRoutine;
	vlParentName : string;
	vlParentOwner: TDefinition;
begin
	vlRoutine := nil;
	vlParent  := nil;
	if ParRoutine <> nil then begin
		if not(ParRoutine.Can([CAN_Execute]) )then begin
			SemError(ERR_Cant_Execute);
		end else begin
			ParRoutine.GetTextStr(vlParentName);
			fNDCreator.GetPtrByObject(vlParentName,ParDigi,vlParentOwner,vlParent);
			if (vlParent = nil) then begin
				SemError(Err_Invalid_Parameters);
				exit(nil);
			end else begin
				if not((RTM_extended) in vlParent.fRoutineModes) then begin
					ErrorText(Err_Rtn_Is_Not_extended,vlParentName);
					exit(nil);
				end;
				vlRoutine := vlParent.CreateShortERtn(fNDCreator);
				if vlRoutine = nil then ErrorText(Err_Int_Cant_Make_new_Sub,vlParentName);
			end;
		end;
	end;
	
	if vlRoutine = nil then begin
		GetNewAnonName(vlParentName);
		vlRoutine := TProcedureObj.Create(vlParentName);
		EmptyString(vlParentName);
	end else begin
		vlParent.CloneParameters(fNDCreator,vlRoutine,TRoutine(vlParentOwner),TRoutine(fNDCreator.GetCurrentRoutine),false);
	end;
	
	vlRoutine.SetRoutineModes([RTM_ShortDCode],true);
	vlRoutine.AutoMaticCreateMapping;
	ProcessRoutineItem(vlRoutine,false,false,true,true,vlParentName,vir_none,OVL_Type,false);
	exit(vlRoutine);
end;


procedure TEla_user.OverrideRoutine(ParCurrentMeta : TMeta;ParOVModes : TOVModes;ParOther,ParRoutine : TRoutine);
var
	vlName : string;
begin
	if ParRoutine.fDefAccess=AF_Private then SemError(Err_Acc_Must_atl_Protected);
	if not(OVM_Found in ParOVModes) then begin
		ErrorDef(Err_Ovr_No_virtual_Found,ParRoutine);
	end else if not(OVM_Is_Routine in ParOVModes)  then begin
		ErrorDef(ERR_Overides_non_Routine,ParOther);
	end else begin
		ParOther.ValidateCanOverrideByComp(fNDCreator,ParROutine);
		if ParCurrentMeta <> nil then  begin
			if ParOther.IsVirtual then begin
				ParRoutine.fVmtItem := ParCurrentMeta.ChangeVirtualRoutine(ParOther,ParRoutine);
			end else begin
           		ParRoutine.fVmtItem := ParCurrentMeta.AddVirtualRoutine(ParRoutine);
			end;
			if ParRoutine.fVmtItem = nil then begin
				if not (OVM_Change_after_Lock in ParOVModes) then begin
					ParRoutine.GetTextStr(vlName);
					ErrorText(Err_Int_Cant_Change_VMT_Item,'Routine='+vlName);
				end else begin
					ParRoutine.fVmtItem := ParCurrentMeta.AddVirtualRoutine(ParRoutine);
				end;
			end;
		end;
	end;
end;

procedure TEla_User.VirtualizeRoutine(ParCurrentMeta : TMeta;ParOVModes :TOVModes;ParRoutine : TRoutine);
begin
if ParRoutine.fDefAccess=AF_Private then SemError(Err_Acc_Must_atl_Protected);
	if OVM_Found in ParOVMOdes  then begin
		if  OVM_Is_Routine in ParOVModes then begin {TODO: If ParRoutine is null, should te be here?}
			if not(OVM_Is_Virtual in ParOVModes) and not(ParRoutine is TConstructor) then begin
				SemError(Err_virt_Allready_Static)
			end else if (OVM_Is_Virtual in ParOVModes) then begin
				SemError(Err_virt_Allready_virt);
			end;
		end else begin
			ErrorDef(Err_Duplicate_Ident,ParRoutine);
		end;
	end;
	if (ParCurrentMeta <> nil) then  ParRoutine.fVmtItem := ParCurrentMeta.AddVirtualRoutine(ParRoutine);
end;

function TEla_user.ProcessRoutineItem(var ParRoutine       : TRoutine;
ParIsolate      : boolean;
ParRootCB       : boolean;
ParInhFinal     : boolean;
ParInherited    : boolean;
const ParParent : string;
ParVirtual      : TVirtualMode;
ParOverload     : TOverloadMode;
ParAbstract     : boolean
):TRoutine;
var
	vlRoutine      : TRoutine;
	vlParent        : TRoutine;
	vlMother       : TDefinition;
	vlVirtual      : TVirtualMode;
	vlMeta         : TMeta;
	vlOther        : TRoutine;
	vlName         : string;
	vlParentName   : string;
	vlAttrib       : TRoutineModes;
	vlParentOwner  : TDefinition;
	vlName2        : string;
	vlRelLevel     : cardinal;
	vlOvModes      : TOvMOdes;
	vlLevelChk     : TDefinition;
	vlOtherOwner   : TDefinition;
	vlExtended     : boolean;
begin
	{Need clean up use of vlName, was prob debugging}
	vlParent   := nil;
	vlVirtual  := ParVirtual;
	vlMother   := TRoutine(fNDCreator.GetCurrentDefinition);
	vlOtherOwner := TRoutine(fNDCreator.GetCurrentInsertItem);
	{Following line is a hack}
	if ParRoutine.fDefAccess = AF_Current then ParRoutine.fDefAccess := fNDCreator.fCurrentDefAccess;
	vlAttrib := [];
	vlExtended :=  (ParRootCB) or (ParInherited) ;
	if ParAbstract then begin

        if (vlMother <> nil) and (vlMother is TRoutine)  then begin
			if  (vlMother.GetRealOwner <> nil)  and  not(TRoutine(vlMother).IsVirtual) then  ErrorDef(Err_No_abs_nested_nonvir,ParRoutine);
    	end;

		if  not(vlExtended) and (ParVirtual <> VIR_Virtual)  then ErrorDef(Err_Routine_Is_Not_Vir_Or_Ext,ParRoutine);
		vlAttrib := vlAttrib + [RTM_Abstract];
	end;

	if vlExtended then vlAttrib := vlAttrib + [RTM_Extended];
	if ParInhFinal then vlAttrib := vlAttrib+[RTM_Inherit_Final];
	if ParIsolate  then vlAttrib := vlAttrib+[RTM_Isolate];
	if (ParRootCB) or  (ParInherited) then vlAttrib := vlAttrib + [RTM_extended];
	case ParOverload of
		OVL_Type : vlAttrib := vlAttrib + [RTM_Overload];
		OVL_Name : vlAttrib := vlAttrib + [RTM_Name_Overload];
		OVL_Exact: vlAttrib := vlAttrib + [RTM_Exact_Overload];
	end;
	case vlVirtual of
		vir_virtual  : vlAttrib := vlAttrib+[RTM_Virtual];
		vir_Override : vlAttrib := vlAttrib+[RTM_Override];
		vir_Final    : vlAttrib := vlAttrib+[RTM_Final];
	end;
	ParRoutine.SetRoutineModes(vlAttrib,true);
	if ParAbstract then begin
			ParRoutine.SetRoutineStates([RTS_HasNoMain],false);
	end;
	if (not(RTS_ForwardDefined in ParRoutine.fRoutineStates)) and
	(fNDCreator.GetCurrentDefinition = fNDCreator.GetCurrentInsertItem)  then begin
	fNDCreator.ConsiderForward(ParRoutine,TDefinition(vlRoutine));
	if (vlRoutine <> nil)  then begin
		{Should be moved to consider forward?}

		if vlRoutine.GetParentName(vlParentName) then begin
			if  ((ParParent <> vlParentName) or
			not(vlRoutine.HasSameMapping(ParRoutine))) then ErrorText(Err_Differs_From_prev_def,'Parent is different'+vlParentName+'=>'+ParParent);
		end;
{can this be moved to ndcreator becaue flags are allready set in routine, and better error message}
		if (ParRootCB or ParInherited) <> (RTM_extended in vlRoutine.fRoutineModes) then ErrorText(Err_Differs_From_Prev_def,'extende mode is not the same');
		ParRoutine.Destroy;
		fNDCreator.AddCurrentDefinition(vlRoutine);
		exit(vlRoutine);
		end;
	end;
	vlParent := nil;
	vlParentOwner := nil;
	if ParInherited then begin
		fNDCreator.GetPtrByObject(ParParent,ParRoutine.fParameterMapping,vlParentOwner,vlParent);
		if vlParent = nil then begin
			ErrorText(Err_Unkown_Ident,ParParent);
		end else begin

			vlLevelChk := vlParent.GetRoutineOwner;
			
			if(vlMother <> nil) then begin {TODO: is TRoutine test}
				if not(vlMother.GetOwnerLevelTo(vlLevelChk,vlRelLevel)) then begin
					vlMother.GetTextStr(vlName);
					if(vlLevelChk <> nil) then begin
						vlLevelChk.GetTextStr(vlName2);
					end else begin
						vlName2 := 'none, unit level routine';
					end;
					fatal(fat_not_in_Owner_list,vlName+' not in the hyrargie of the owner of '+ParParent+':'+vlName2);
				end;
			end else begin
				vlRelLevel := 0;
			end;

			if not(vlParent is TRoutine) then begin
				vlParent.GetTextStr(vlName);
				ErrorText(Err_Not_A_Routine,vlName);
				vlParent := nil;
			end else begin
				ParRoutine.fRelativeLevel := vlParent.fRelativeLEvel + vlRelLevel;
				if not vlParent.IsSameByMapping(ParRoutine.fParametermapping) then begin
					SemError(Err_param_differs_From_Parent);
				end else if RTM_Name_Overload in vlParent.fRoutineModes then begin
					vlParent.GetTextStr(vlname);
					ErrorText(err_Rtn_Is_Name_Overloaded,vlName);
				end;
			end;
		end;
	end;
	vlRoutine      := ParRoutine;
	vlOther	       := nil;
	vlMeta         := nil;
	vlOvModes       := [];
	fNDCreator.AddRoutineItem(ParRoutine);
	fNDCreator.AddCurrentDefinition(ParRoutine);
	if vlMother <> nil then vlMother.GetOvData(fNDCreator,vlRoutine,vlOther,vlOvModes,vlMeta);
	if (vlVirtual  <> vir_none) and (vlMeta = nil) then  begin
		SemError(Err_Identifier_cant_have_vir);
		vlVirtual := vir_none;
	end;
	
	vlRoutine.FinishSetup(TRoutine(vlParent),vlParentOwner,vlOtherOwner,fNDCreator,ParInherited);
	case vlVirtual of
		vir_Virtual		: VirtualizeRoutine(vlMeta,vlOvModes,vlRoutine);
		vir_Override    : OverrideRoutine(vlMeta,vlOvModes,vlOther,vlRoutine);
		vir_Final    	: OverrideRoutine(vlMeta,vlOvModes,vlOther,vlRoutine);
		vir_none        : if OVM_Found in   vlOvModes  then begin
			if OVM_is_Routine in vlOvModes then begin
				if not(vlOther is TConstructor) or not(vlRoutine is TConstructor) then ErrorDef(Err_Override_by_Static,vlRoutine)
			end else begin
				ErrorDef(Err_Duplicate_Ident,vlRoutine);
			end;
		end;
	end;
	exit(vlRoutine);
end;

procedure TEla_User.OpenFileFailed(ParError : TErrorType);
begin
	ErrorText(Err_Cant_Open_Input_File,'Os error='+IntTOStr(ParError));
end;

procedure TEla_user.GetConfigFileName(var ParName : string);
begin
	ParName := 'ELA.CFG';
end;


procedure  TEla_User.AddVar(ParName:TNameList;ParType:TType);
begin
	fNDCreator.AddVar(ParName,ParType);
end;

procedure  TEla_User.EndIdent;
begin
	fNDCreator.EndIdent;
end;


procedure TEla_User.bind;
begin
	fNDCreator.Bind;
end;

procedure TEla_User.WriteResFile;
begin
	if fNDCreator.WriteResFile then SemError(Err_Writing_Link_File_Failed);
end;

procedure TEla_User.ProcessParsed;
begin
	if Successful then fNDCreator.CreateSec;
end;

procedure TEla_User.Addident(Parident:TDefinition);
begin
	fNDCreator.Addident(Parident);
end;


function TEla_User.SetEnumBegin:TType;
begin
	exit(fNDCreator.SetEnumBegin);
end;

procedure  TEla_User.EndEnum;
begin
	fNDCreator.EndEnum;
end;



procedure TEla_User.Save;
begin
	if fNDCreator.GetIsUnitFlag then fNDCreator.Save;
end;


procedure  TEla_User.InitConfig;
var vlCOnfigFile:string;
	vlCfg       : TElaConfig;
	vlCfgParser : TCfg_Parser;
	vlError     : TErrorType;
	vlName      : string;
begin
	vlError := ERR_No_Error;
	iOwnConfig := (GetConfig = nil);
	if iOwnConfig  then begin
		InitStreams;
		GetConfigFileName(vlConfigFile);
		vlCfg       := TElaConfig.Create;
		vlCfgParser := TCfg_Parser.Create(vlConfigFile,vlCfg);
		if vlError =ERR_No_Error then begin
			vlCfgParser.Compile;
			if not vlCfgParser.successful  then vlError := Err_Reading_Config_Failed;
		end;
		if vlError <> ERR_No_Error then begin
			ErrorText(vlError,'');
		end;
		vlCfgParser.Destroy;
		Setconfig(vlCfg);
	end;
	if vlError = ERR_No_Error then begin
		try
		if GetConfig <> nil then begin
			iPrvConfigValues := SetConfigValues(GetOptionValues.CloneValues);
			iDestroyCfgVal := true;
			fFileName.GetString(vlName);
			GetConfigValues.SetInputFile(vlName,cl_manual);
			GetConfig.SetValues(GetConfigValues);
			
		end;
		except
		on vlE:EFailed do ErrorText(Err_Error,vlE.Message);
		on vlE:EConfig do ErrorText(Err_Interp_Config,vlE.Message);
	end;
end;
end;


constructor TEla_User.Create(const ParFileName:string);
begin
	fFileName := TString.Create(ParFileName);
	inherited Create;
end;

procedure TEla_user.Commonsetup;
var vlFIleName : string;
begin
	inherited commonsetup;
	fFileName.GetString(vlFileName);
	iPrvConfigValues := nil;
	iDestroyCfgVal   := false;
	InitConfig;
	SetNDCreator(TNDCreator.Create(vlFileName,self));
end;

function TEla_user.SetupCompiler:boolean;
begin
	if inherited SetupCompiler then exit(true);
	fNDCreator.SetSourceTime(fSourceFileTime);
	exit(false);
end;

procedure  TEla_User.SetNDCreator(ParCre:TNDCreator);
begin
	iNDCreator := ParCre;
end;


procedure TEla_User.Clear;
var vlOldConfigValues : TConfigValues;
begin
	inherited clear;
	if iDestroyCfgVal then begin
		vlOldConfigValues := SetConfigValues(iPrvConfigValues);
		if vlOldConfigValues <> nil then vlOldConfigValues.Destroy;
	end;
	if fNDCreator <> nil then fNDCreator.destroy;
	if (iOwnCOnfig) and (GetConfig <> nil) then begin
		SetConfig(nil);
		DoneAssemblerInfo;
		donestreams;
	end;
end;

procedure TEla_User.AddBreakNode(var ParNode:TNodeIdent);
begin
	AddLoopFlowNode(ParNode,TBreakNode);
end;

procedure TEla_user.AddContinueNode(var ParNode:TNodeIdent);
begin
	AddLoopFlowNode(ParNode,TContinueNode);
end;

procedure TEla_user.AddLoopFlowNode(var ParNode:TNodeIdent;ParType:TRefLoopFlowNode);
var
	vlLcb  : TNodeIdent;
begin
	ParNode := nil;
	vlLcb   := fNDCreator.GetCurrentLoopCbNode;
	if vlLcb = nil then begin
		SemError(err_not_in_loop_block);
	end else begin
		ParNode := ParType.Create(TLoopCBNode(vlLcb));
	end;
end;

function TELa_User.AddNodeToNode(ParNode1 : TNodeIdent;var ParNode2 : TNodeIdent): boolean;
begin
	exit(fNDCreator.AddNodeToNode(ParNode1,ParNode2));
end;

procedure TEla_User.CreateExternalInterfaceObject(ParCDecl:boolean;ParRoutine :TRoutine;
ParExt : TExternalInterface;var ParName : TString);
var vlInter : TExternalObject;
begin
	if ParExt = nil then exit;
	if (ParRoutine = nil)  then begin
		ParName.Destroy;
		ParName := nil;
		exit;
	end;
	if ParName <> nil then begin
		vlInter := ParExt.AddInterface(ParName,ParRoutine);
		vlInter.fDefAccess := fNDCreator.fCurrentDefAccess;
		if ParCDecl then ParRoutine.SetRoutineModes([RTM_CDecl],true);
		fNDCreator.AddGlobalOnce(vlInter);
	end;
	fNDCreator.AddRoutineItem(ParRoutine);
	ParRoutine.SetIsDefined;
end;

function  TELa_User.CreateExternalInterface(ParName : TString;ParType :TExternalType;ParHAsAt : boolean;ParAt: longint):TExternalInterface;
var
	vlInter : TExternalInterface;
	vlTYpe  : TExternalType;
begin
	vlInter := nil;
	vlType  := ParType;
   if ParName = nil then ParName := TString.Create('');{TODO ParName=>vlName and ''=some descriptive name}
	case ParType of
	ET_Linked : vlInter := TExternalObjectFileInterface.Create(ParName);
	ET_Dll    : if GetConfigValues.fCanUseDll then begin
		vlInter := TExternalLibraryInterfaceWindows.Create(ParName);
	   end;
    end;

    if vlInter = nil then begin
    	SemError(Err_Feature_Not_Possible);
    	vlInter := TExternalObjectFileInterface.Create(ParName);
    	vlType := ET_Linked;
     end;

     case vlType of
       ET_Linked : AddObjectFile(ParName.NewString,false,ParHasAt,ParAt);
     end;

     AddIdent(vlInter);
     fndCreator.AddCurrentDefinition(vlInter);
     exit(vlInter);
end;



function  TEla_USer.ProcessOperator(const ParParameters     : array of TNodeIdent;
									var ParPrvPar    : TNodeIdent;
									const ParOperStr : string;
									ParError : boolean):TOperatorProcessResult;
var
	vlCallNode : TCallNode;
	vlResult   : TOperatorProcessResult;
	vlCnt      :cardinal;
begin
	for vlCnt := 0 to high(ParParameters) do begin
		if ParParameters[vlCnt] <> nil then ParParameters[vlCnt].Proces(fNDCreator);
	end;
	vlCallNode := TCallNode.Create(ParOperStr);
    fNDCreator.SetNodePos(vlCallNode);
	vlCallNode.AddNodes(ParParameters);
	vlResult :=  fNDCreator.ProcessOperatorNode(vlCallNode,ParError);
	if vlResult = OPr_Ok  then begin
		SetNodePos(vlCallNode);
		ParPrvPar := vlCallNode;
	end else begin
		vlCallNode.SoftEmptyParameters;
		vlCallNode.Destroy;
	end;
	exit(vlResult);
end;


procedure  TEla_User.ProcessDualOperator(
		var   ParNewPar  : TNodeIdent;
		var   ParPrvPar  : TNodeIdent;
		const ParOprStr  : String;
		ParOperObj : TRefNodeIdent);
var
	vlNode     : TNodeIdent;
	vlClassTYpe: TRefNodeIdent;
begin
	if ParPrvPar = nil then begin
		if ParNewPar <> nil then begin
			ParNewPar.Destroy;
			ParNewPar := nil;
		end;
		exit;
	end;
	vlClassType := TRefNodeIdent(ParPrvPar.ClassType);
	case ProcessOperator([ParPrvPar,ParNewPar],ParPrvPar,ParOprStr,ParOperObj=nil) of
		Opr_Ok:begin end;
		Opr_Not_Found : begin{fatal error when paroperobj=nil ?}
				if (ParOperObj <> nil) and (vlClassType  <> ParOperObj) then begin
					vlNode := ParOperObj.Create;
					fNDCreator.SetNodePos(vlNOde);
					vlNode.AddNode(ParPrvPar);
					ParPrvPar := vlNode;
				end;
		   		ParPrvPar.AddNode(ParNewPar);
		   end;
		else begin
			if ParNewPar <> nil then ParNewPar.Destroy;
			ParNewPar := nil;
		end;
	end;
end;

function TEla_user.GetModule : TUnit;
begin
	exit(fNDCreator.fCurrentUnit);
end;


procedure TELa_User.ProcessSingleOperator(
	ParNewPar    : TNodeIdent;
	var   ParPrvPar    : TNodeIdent;
	const ParOprStr    : String;
	ParOperObj   : TRefNodeIdent);
var
	vlNode     : TNodeIdent;
begin
{TODO: better handling of return value procesopertor}
	if ProcessOperator([ParNewPar],ParPrvPar,ParOprStr,false) = Opr_Ok then exit;
	vlNode := ParOperObj.Create;
	vlNode.AddNode(ParNewPar);
	SetNodePos(vlNode);
	ParPrvPar := vlNode;
end;


procedure TEla_User.ProcessBetweenOperator(
	ParO1,ParO2,ParO3  : TNodeIdent;
	var ParPrvPar      : TNodeIdent;
	const ParOprStr    : String);
var
	vlNode     : TNodeIdent;
	vlType     : TType;
begin
	{TODO: better handling of return value procesopertor}

	if ProcessOperator([ParO1,ParO2,ParO3],ParPrvPar,ParOprStr,false)=Opr_Ok then exit;
	vlType :=fNDCreator.GetDefaultIdent(DT_Boolean,SIZE_DontCare,false);
	
	if vlType = nil then ErrorText(Err_Cant_Find_Type,'boolean');
	vlNode := TBetweenNode.Create(vlType);
	vlNode.AddNodes([ParO1,ParO2,ParO3]);
	SetNodePos(vlNode);
	ParPrvPar := vlNode;
end;

procedure TEla_User.ProcessCompOperator(
ParNewPar       : TNodeIdent;
var ParPrvPar   : TNodeIdent;
const ParOprStr : String;
ParCode	        : TIdentCode);
var
	vlNode     : TNodeIdent;
	vlType     : TType;
begin
	if ProcessOperator([ParPrvPar,ParNewPar],ParPrvPar,ParOprStr,false)=OPR_Ok then exit;
	vlType := fNDCreator.GetDefaultIdent(DT_Boolean,SIZE_DontCare,false);
	if vlType = nil then ErrorText(Err_Cant_Find_Type,'boolean');
	vlNode := TCompNode.Create(ParCode,vlType);
	vlNode.AddNodes([PArPrvPar,ParNewPar]);
	SetNodePos(vlNode);
	ParPrvPar := vlNode;
end;



end.
