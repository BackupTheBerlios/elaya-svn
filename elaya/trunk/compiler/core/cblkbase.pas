{Copyright (C) 1999-2004  J.v.Iddekinge.
Web   : www.elaya.org

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
a
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit cblkbase;
interface
uses vars,rtnenp,confval,meta,objlist,largenum,strmbase,ndcreat,routasm,frames,compbase,resource,display,asmdisp,streams,lsstorag,cmp_type,asmcreat,asmdata,
	useitem,progutil,params,node,elacons,pocobj,stdobj,macobj,formbase,varbase,asminfo,elatypes,error,elacfg,ddefinit;

type


	TRoutine	   = class;
	TRoutineMeta=class(TMEta);



		TCallNode=class(TSubListFormulaNode)
		private
			voParCnt      : cardinal;
			voTLVarNode	  : TTlVarNode;
			voCallAddress : TNodeIdent;
			voName        : ansistring;
			voType        : TType;
			voRoutineItem : TRoutine;
			voIsPtrOf     : boolean; {Hack for checking @routine}
			voDotFrame    : TMacBase;
			voFrame       : TFrame;
			voIsProcessed : boolean;
		protected
			property  iIsPtrOf     : boolean	read voIsPtrOf     write voIsPtrOf;
			property  iCallAddress : TNodeIdent read voCallAddress write voCallAddress;
			property  iTLVarNode   : TTlVarNode read voTLVarNode   write voTLVarNode;
			property  iName        : ansistring    read voName        write voName;
			property  iType        : TType      read voType        write voType;
			property  iRoutineItem : TRoutine   read voRoutineItem write voRoutineItem;
			property  iDotFrame    : TMacBase   read voDotFrame write voDotFrame;
			property  iFrame       : TFrame     read voFrame      write voFrame;
			property  iParCnt      : cardinal   read voParCnt     write voParcnt;
			property  iIsProcessed : boolean    read voIsProcessed write voIsProcessed;
			procedure SetType(parType : TTYpe);
			procedure   CommonSetuP;override;
			procedure   Clear;override;

		public
			property    fRoutineItem : TRoutine read voRoutineItem ;
			property    fParCnt      : cardinal read voParCnt;
			property    fType        : TType      read voType        write voType;
			property    fFrame       : TFrame     read voFrame      write voFrame;
			property    fName        : ansistring read voName;

			function CanUseInherited : boolean;
			procedure ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);override;
			procedure   SetRoutineName(const ParName : ansistring);
			constructor Create(const ParName : ansistring);
			procedure   SetRoutineItem(ParCre : TNDCreator;PArProc:TRoutine;ParContext :TDefinition);
			function    IsCallByName : boolean;
			function    IsSameParamByDef(ParList :TProcParList;ParExact : boolean):boolean;
			procedure   SetCallAddress(ParCre :TNDCreator;ParNode:TNodeIdent);
			function    Can(ParCan:TCan_Types):boolean;override;
			function    CreateCallSec(ParCre:TSecCreator):TCallPoc;
			function    GetType:TType;override;
			function    AddNode(ParNode:TNodeIdent):boolean;override;
			function    AddNodeAndName(ParNode:TFormulaNode;const ParName : ansistring):boolean;
			function    DoCreateSec(ParCre:TSecCreator):boolean;override;
			function    DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
			procedure   PrintNode(ParDis:TDisplay);override;
			procedure   InitParts;override;
			procedure   SetParameters(ParContext : TDefinition;ParCre:TNDCreator;ParCB : TRoutine);
			procedure   SoftEmptyParameters;
			function    GetParamByName(const ParName : ansistring):TParamNode;
			function    IsOverloaded : boolean;
			procedure    Optimize(ParCre : TCreator);override;
			procedure   ValidateAfter(ParCre : TCreator);override;
			function 	CreateObjectPointerOfNode(ParCre : TCreator) : TFormulaNode;override;
			procedure 	DoInitDotFrame(ParCre : TSecCreator);
			procedure 	DoDoneDotFrame;
			procedure 	ValidatePre(ParCre : TCreator;ParIsSec:boolean);override;
			procedure	proces(ParCre : TCreator);override;   {TODO IsSubSec?}
		end;

		TRoutineNode=class(TSubListStatementNode)
		private
			voProcedure      : TRoutine;
			property  iRoutine : TRoutine read voProcedure write voProcedure;
			procedure SetProcedureObj(ParProc:TRoutine);
		public
			property    fRoutine : TRoutine read voProcedure;
			constructor Create(ParProc:TRoutine);
			function    CreateSec(ParCre:TSecCreator):boolean;override;
			procedure   PrintNode(ParDis:TDisplay);override;
			procedure   DoneRoutine(ParCre : TSecCreator);
		   function  IsSubNodesSec:boolean;override;
			procedure ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);override;

		end;



		TRoutine = class(TFormulaDefinition)
		private
			voStatements         : TRoutineNode;
			voStorageList        : TTLVStorageList;
			voRoutinePoc         : TRoutinePoc;
			voLocalFrame         : TFrame;
			voParameterFrame     : TFrame;
			voPhysicalAddress    : TRoutine;
			voRoutineModes       : TRoutineModes;
			voParent             : TRoutine;
			voMeta               : TRoutineMeta;
			voVmtItem            : TVmtItem;
			voParameterMapping   : TParameterMappingList;
			voCollectionNo       : cardinal;
			voRoutineStates      : TRoutineStates;
			voRelativeLevel      : cardinal;

			procedure  InitStorageList;virtual;
			function   CheckAccessLevel(ParParent : TRoutine):boolean;
			function   CreateRoutineAsm : TRoutineAsm;
			procedure  SeperateInitAndMain(ParCre : TNDCreator;var ParNewCB : TRoutine);

		protected
			property  iParent	           : TRoutine              read voParent             write voParent;
			property  iPhysicalAddress   : TRoutine              read voPhysicalAddress    write voPhysicalAddress;
			property  iParameterFrame    : TFrame		           read voParameterFrame     write voParameterFrame;
			property  iLocalFrame	     : TFrame	              read voLocalFrame         write voLocalFrame;
			property  iRoutineModes      : TRoutineModes         read voRoutineModes       write voRoutineModes;
			property  iRoutineStates     : TRoutineStates        read voRoutineStates      write voRoutineStates;
			property  iMeta	           : TRoutineMeta          read voMeta		          write voMeta;
			property  iVmtItem	        : TVmtITem              read voVmtItem            write voVmtItem;
			property  iParameterMapping  : TParameterMappingList read voParameterMapping   write voParameterMapping;
			property  iCollectionNo      : cardinal              read voCollectionNo	    write voCollectionNo;
			property  iRelativeLevel     : cardinal              read voRelativeLevel      write voRelativeLevel;
			property  iStatements        : TRoutineNode          read voStatements         write voStatements;
			procedure ValidateOverrideVirtTest(ParCre : TNDCreator; ParOther : TRoutine);virtual;
			procedure  CreateInitCode(ParCre :TNDCreator);
		{seperation}
			function   CreateSeperationRoutine(ParCre : TNDCreator) : TRoutine;virtual;

		public
			property   fRelativeLevel      : cardinal        read voRelativeLevel     write voRelativeLevel;
			property   fParameterFrame     : TFrame	  	    read voParameterFrame;
			property   fLocalFrame	       : TFrame	 	    read voLocalFrame;
			property   fParent	           : TRoutine       read voParent;
			property   fPhysicalAddress    : TRoutine        read voPhysicalAddress;
			property   fRoutinePoc         : TRoutinePoc     read voRoutinePoc        write voRoutinePoc;
			property   fCollectionNo       : cardinal        read voCollectionNo	     write voCollectionNo;
			property   fStorageList        : TTLVStorageList read voStorageList;
			property   fRoutineModes	   : TRoutineModes    read voRoutineModes;
			property   fRoutineStates      : TRoutineStates  read voRoutineStates;
			property   fMeta               : TRoutineMeta    read voMeta;
			property   fVmtItem            : TVmtItem	       read voVmtItem           write voVmtItem;
			property   fParameterMapping   : TParameterMappingList read voParameterMapping;
			property   fStatements         : TRoutineNode          read voStatements write voStatements;



			{Address}
			function   CreateMentionAddress(ParCre : TCreator;ParContext :TDefinition) : TNodeIdent;
			function   CreateInheritAddress(ParCre : TCreator) : TNodeIdent;

			function   GetRoutineOwner : TDefinition;
			procedure  ShareLocalFrame(ParCb : TRoutine);
			function   GetForwardDefined : boolean;override;
			procedure  ProcessInherited(ParCre : TCreator;ParCB : TRoutine);
			procedure  AddVmtLabel(ParCre :TCreator);override;
			{Parameter list}
			function   GetParList : TProcParList;

			{info}
			function   GetRealOwner:TDefinition;override;

			{Searching}
			function   GetPtrByName(const ParName:ansistring;ParOption :TSearchOptions;var ParOwner,ParItem:TDefinition):boolean;override;
			function   GetPtrInCurrentList(const ParName : ansistring;var ParOwner,Paritem :TDefinition):boolean;override;
			function    GetPtrByObject(const ParName : ansistring;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;override;
 			function    GetPtrByArray(const ParName : ansistring;const ParArray : Array of TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;override;

			function   GetPtrByObjectInCurrentList(const ParName:ansistring;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult :TDefinition):TObjectFIndState;
			function    SearchOwner:boolean;override;

			{Is function}
			function   IsIsolated : boolean;override;
			function   CanUseInherited :boolean;virtual;

			{Is/Copare}
			function   IsSameAsForward(ParCB : TDefinition;var ParText : ansistring):boolean;override;
			function   IsSameRoutine(ParProc:TRoutine;ParType : TParamCompareOptions):boolean;virtual;
			function   IsSameTypeByNode(ParNode:TCallNode):boolean;
			function   IsSameForFind(ParProc :TRoutine):boolean;
			function   IsPropertyProcComp(ParWrite : boolean;ParTYpe : TType) :boolean;
  			function   IsSameParamByNodesArray(const ParNodes :array of TRoot;ParExact : boolean):boolean;override;

			{seperation}
			procedure  PostMangledName(var ParName:ansistring);override;
			function   SaveItem(ParStream:TObjectStream):boolean;override;
			function   LoadItem(ParStream:TObjectStream):boolean;override;
			function   GetNumberOfParameters:cardinal;
			function   CreateExecuteNode(ParCre:TCreator;ParContext : TDefinition):TNodeIdent;override;
			procedure  InitParts;override;
			procedure  CreateInitProc(ParCre:TSecCreator);virtual;
			function   CreateDB(ParCre:TCreator):boolean;override;
			procedure  CommonSetup;override;
			procedure  PrintDefinitionEnd(ParDis:TDisplay);override;
			procedure  PrintDefinitionBody(ParDis:TDisplay);override;
			procedure  Clear;override;
			function   Can(ParCan:TCan_Types):boolean;override;
			function   CreateVar(ParCre:TCreator;const ParName:ansistring;ParTYpe:TDefinition):TDefinition;override;
			function   IsOverloadingComp(ParIdent:TDefinition):boolean;virtual;
			constructor Create(const ParName : ansistring);
			procedure  ProducePoc(ParCre : TCreator);
			function   GetLocalSize : TSize;
			procedure  BeforeCall(ParCre : TNDCreator);

			{mode}
			procedure  FinishNode(ParCre : TNDCreator);
			function  HasAbstracts:boolean;override;
			function   IsVirtual : boolean;
			function   CanInherit : boolean;
			function   SignalCPublic : boolean;override;
			function   IsOverloaded : boolean;
			{routine name}
			function   GetParentName(var ParName :ansistring):boolean;
			procedure  GetDisplayName(var ParName :ansistring);override;

			{routine mode/states}
			procedure  SetRoutineStates(ParStates : TRoutineStates;ParOn : boolean);
			procedure  SetRoutineModes(Parmode : TRoutineModes;ParOn : boolean);

			{Init}
			procedure CreateVarCBInits(ParCre : TNDCreator;ParNode : TSubListStatementNode;ParContext : TDefinition);
			procedure InitVariables(ParFrame : TFrame;ParContext : TDefinition);
			procedure DoneVariables(ParFrame : TFrame);
			procedure InitAllVariables;
			procedure DoneAllVariables;

			{Parsing}

			function   CreateNewCB(ParCre : TCreator;const ParName : ansistring) : TRoutine;virtual;
			function   CreateShortSubCB(ParCre : TCreator) : TRoutine;
			function   CreateSHortERtn(ParCre : TCreator)   : TRoutine;
			procedure  SetIsDefined;
			procedure  SignalForwardDefined; {TODO Signal change to set}
			procedure  SignalHasForward(ParCre : TNDCreator);
			procedure  SignalInPublicSection;override;
			function   CreateExitNode(ParCre : TCreator;ParNode : TFormulaNode) : TNodeIdent;virtual;
			function   CreatePropertyWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue :TFormulaNode):TFormulaNode;override;
			function   CreatePropertyWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;override;
			procedure  ConsiderForward(ParCre : TCreator;ParIn : TDefinition;var ParOut : TDefinition);override;
			function   IsCompleet:boolean;override;
			procedure  PreBlockOfCode(ParCre : TNDCreator);
			procedure  PreNoMain(ParCre : TNDCreator);
			function   IsExecutableRoutine :boolean;
			procedure  CheckAfter(ParCre : TCreator);override;

			{Parameters}
			function   IsSameByMapping(ParMapping : TParameterMappingList) : boolean;
			procedure  CloneParameters(ParCre : TNDCreator;ParToCb :TRoutine;ParContext,ParNewOwner : TDefinition;ParAutomatic : boolean);
			function   GetParamSize : TSize;
			procedure  InitParameters;
			procedure  DoneParameters(ParCre : TSecCreator);
			function   CheckParameterNames(ParItem :TRoutine;var ParDifText:ansistring):boolean;
			function   GetRTLParameter:TRTLParameter;
			function   CreateAutomaticParameterNodes(ParContext : TDefinition;ParCre:TNDCreator;ParList:TCallNodeList):TTLVarNode;
			procedure  AddAutomaticParameters(ParParentContext : TDefinition;ParCre : TNDCreator);virtual;
			procedure  PreProcessParameterList(ParParentContext,ParOtherOwner : TDefinition;ParCre:TNDCreator);

			{comparision}
			function   IsSameParamType(ParParam:TProcParList;ParType:TParamCompareOptions):boolean;
			function   GetParamByNum(ParNum : cardinal):TParameterVar;
			procedure  CheckIsInheritedComp(ParCre : TCreator;ParCB : TRoutine;ParHasMain : boolean);virtual;
			procedure  ValidateCanOverrideByComp(ParCre :TNDCreator;const ParOther : TRoutine);virtual;

			{param}
			procedure  AddParam(ParCre : TNDCreator;ParName:TNameList;ParType:TType;ParVar,ParConst,ParVirtual:boolean);
			procedure  AddParam(ParVar : TParameterVar);
			procedure  AddNormalParameterMapping(ParCre : TNDCreator;Const ParName : ansistring;ParOption : TMappingOption);
			procedure  AddConstantParameterMapping(ParCre : TNDCreator;ParVal : TValue);
			{mapping}
			procedure  AutomaticCreateMapping;
			function   HasSameMapping(ParRoutine : TRoutine):boolean;
			{Meta}
			procedure  CloneVmtFromParent;
			procedure  SetupMeta(ParCre :TCreator);

			function   MustNameAddAsOwner:boolean; override;
			procedure  GetForParentMangleName(var ParName : ansistring);override;
			procedure  DoneRoutine(ParCre : TSecCreator);
			{setup}
			procedure FinishSetup(ParParent : TRoutine;ParParentContext,ParOtherOwner: TDefinition;ParCre : TNDCreator;ParInherited:boolean);
			procedure GetOVData(ParCre :TCreator;ParRoutine : TDefinition;var ParOther : TDefinition;var ParModes : TOVModes;var ParMeta : TDefinition);override;
			procedure AddParameterToNested(ParCre : TCreator;ParNested :TDefinition);override;
			procedure CreatePreCode(ParCre : TNDCreator);virtual;
			procedure CreatePostCode(ParCre : TNDCreator);virtual;
			function MustSeperateInitAndMain : boolean;virtual;
			procedure ValidateSelf(ParCre : TNDCreator);virtual;
			{Addresses}

			function GetRelativeLevel : cardinal;override;

			{Parent relation}
			function IsInheritedInHyr(ParFrom :TDefinition) : boolean;
			function GetParent : TDefinition;override;
			function IsMethod: boolean;
			procedure PreRoutine;
			procedure AfterRoutine;
		end;

		TLocalMetaVar=class(TLocalVar)
		private
			voMeta : TMeta;
			property iMeta : TMeta read voMeta write voMeta;
		protected
			procedure   Commonsetup; override;
		public
			procedure   DoneVariable(ParOwner : TDefinition;ParFrame : TFrame);override;
			procedure   InitVariable(ParOwner ,ParContext: TDefinition;PArFrame : TFrame);override;
			constructor Create(const ParName : ansistring;ParFrame:TFrame;ParOffset : TOffset;ParMeta : TMeta;ParType:TType);
			procedure   CreateCBInit(ParCre : TNDCreator;ParAt : TSubListStatementNode;ParContext : TDefinition);override;
			function    SaveItem(ParStream:TObjectStream):boolean;override;
			function    LoadItem(ParStream:TObjectStream):boolean;override;
		end;

	implementation
	uses execobj,procs,classes;



	{----( TLocalMetaVar )-------------------------------------------------------}


	procedure TLocalMetaVar.DoneVariable(ParOwner : TDefinition;ParFrame : TFrame);
	begin
		ParFrame.PopAddressing(ParOwner);
	end;

	procedure TLocalMetaVar.InitVariable(ParOwner,ParContext: TDefinition;ParFrame : TFrame);
	begin
		ParFrame.AddAddressing(ParOwner,ParContext,ParContext,self,false);     {ParFrame is a hack,poss}
	end;


	procedure TLocalMetaVar.COmmonsetup;
	begin
		inherited Commonsetup;
		iIdentCode := IC_LOcalFrameVar;
	end;

	procedure TLocalMetaVar.CreateCBInit(ParCre : TNDCreator;ParAt : TSubListStatementNode;ParContext : TDefinition);
	var
		vlByPtr : TFormulaNode;
	begin
		vlByPtr    := TFormulaNode(TRoutine(ParContext).iMeta.CreateObjectPointerNode(ParCre,ParContext)); (*Very Ugly hack, or???*)
		ParAt.AddNode(CreateWriteNode(ParCre,ParContext,vlByPtr));
	end;

	constructor TLocalMetaVar.Create(const ParName : ansistring;ParFrame:TFrame;ParOffset : TOffset;ParMeta : TMeta;ParType:TType);
	begin
		inherited Create(ParName,ParFrame,Paroffset,ParType);
		iMeta := ParMeta;
	end;

	function   TLocalMetaVar.SaveItem(ParStream:TObjectStream):boolean;
	begin
		if inherited SaveItem(ParStream) then exit(true);
		if ParStream.WritePi(iMeta) then exit(true);
		exit(false);
	end;

	function   TLocalMetaVar.LoadItem(ParStream:TObjectStream):boolean;
	begin
		if inherited LoadItem(ParStream) then exit(true);
		if ParStream.ReadPi(voMeta) then exit(true);
		exit(false);
	end;


	{---( TRoutine )-------------------------------------------------}



	procedure  TRoutine.FinishNode(ParCre : TNDCreator);
   	begin
   		if fStatements <> nil then fStatements.FinishNode(ParCre,true);
	end;


        function TRoutine.IsMethod : boolean;
	var
		vlOwner : TDefinition;
	begin
		vlOwner := GetRealOwner;
		if (vlOwner <> nil) then begin
			exit(vlOwner is TClassType);
		end;
		exit(false);
	end;

	procedure TRoutine.PreRoutine;
	begin
		GetParList.PreNode;
	end;

	procedure TRoutine.AfterRoutine;
	begin
		GetParList.AfterNode;
	end;


	function  TRoutine.IsPropertyProcComp(ParWrite : boolean;ParTYpe : TType) :boolean;
	begin
		if can([can_read]) = ParWrite then exit(false);
		if ParWrite then begin
			exit(GetParList.IsPropertyProcComp(ParType));
		end else begin
			exit( GetParList.GetNextNormalParameter(nil) = nil);
		end;
	end;

	procedure TRoutine.AddParam(ParVar : TParameterVar);
	begin
		GetParList.AddParam(ParVar);
		ParVar.fOwner := self;
	end;

	function TRoutine.IsIsolated : boolean;
	begin
		exit(RTM_Isolate in fRoutineModes);
	end;

	function  TRoutine.SearchOwner : boolean;
	begin
		exit(not(RTM_Isolate in fRoutineModes));
	end;

	procedure TRoutine.ValidateSelf(ParCre : TNDCreator);
	begin
	end;


	function TRoutine.GetParent : TDefinition;
	begin
		exit(iParent);
	end;


	procedure TRoutine.CreatePostCode(ParCre : TNDCreator);
	begin
	end;

	procedure TRoutine.CreatePreCode(ParCre : TNDCreator);
	begin
	end;

	procedure TRoutine.GetOVData(ParCre :TCreator;ParRoutine : TDefinition;var ParOther :TDefinition;var ParModes : TOVModes;var ParMeta : TDefinition);
	var
		vlMeta 		: TMeta;
		vlMotherParent  : TDefinition;
		vlOther		: TRoutine;
		vlOwner		: TDefinition;
	begin
		ParModes       := [];
		vlMeta	       := fMeta;
		ParOther       := nil;
		if RTM_Change_After_Lock in fRoutineModes then ParModes := [OVM_Change_After_Lock];
		vlMotherParent := fParent;

		if vlMotherParent <> nil then begin

			vlMotherParent.GetPtrByObject(ParRoutine.fText,ParRoutine,[SO_Local],vlOwner,vlOther);

			if (vlOther <> nil) then begin

				ParModes := ParModes + [OVM_Found];
				if(vlOther is TRoutine) then begin

					ParModes := ParModes + [OVM_Is_Routine];
					if vlOther.IsVirtual then ParModes := ParModes + [OVM_Is_Virtual];

				end;

			end;
			ParOther := vlOther;

		end;

		ParMeta  := vlMeta;
	end;

	procedure TRoutine.FinishSetup(ParParent : TRoutine;ParParentContext,ParOtherOwner : TDefinition;ParCre : TNDCreator;ParInherited:boolean);
	begin
		ValidateSelf(TNDCreator(ParCre));
		if ParInherited then begin
			SetRoutineModes([RTM_extended],true);
			ProcessInherited(ParCre,ParParent);
		end;
		if (RTM_extended in fRoutineModes) then begin
			SetupMeta(ParCre);
			CloneVmtFromParent;
		end else begin
			if RTS_HasVirtualParams in fRoutineStates then ParCre.SemError(err_virt_Only_in_Ext_Rtn);
		end;
		PreProcessParameterList(ParParentContext,ParOtherOwner,ParCre);
	end;

	function   TRoutine.IsOverloaded : boolean;
	begin
		exit(([RTM_Overload,RTM_Name_Overload,RTM_Exact_Overload] * fROutineModes) <> []);
	end;


	function TRoutine.HasAbstracts:boolean;
	begin
		if RTM_Abstract in fROutineModes then begin
			exit(true);
		end;
		if iMeta <> nil then begin
			exit(iMeta.HasAbstracts);
		end else begin
			exit(false);
		end;
	end;


	function TRoutine.SignalCPublic:boolean;
	begin
		inherited SignalCPublic;
		SetRoutineModes([RTM_CDecl],true);
		exit(true);
	end;

	procedure TRoutine.AddVmtLabel(ParCre : TCreator);
	begin

		if Rtm_Abstract in fRoutineModes then begin

			TAsmCreator(ParCre).AddData(TLongDef.Create(Dat_Code,0));

		end else begin

			inherited AddVmtLabel(ParCre);

		end;

	end;

	function TROutine.IsExecutableRoutine : boolean;
	begin
		exit(((Rtm_Abstract in fRoutineModes) and IsVirtual) or (iPhysicalAddress <> nil));
    end;

	procedure TRoutine.BeforeCall(ParCre : TNDCreator);
	var vlOwner : TRoutine;
	begin
		vlOwner :=TRoutine( GetRoutineOwner);
		if (vlOwner =nil) or not(RTM_extended in vlOwner.fRoutineModes) then begin
			if (RTM_Abstract in fRoutineModes) then ParCre.ErrorDef(Err_abstract_routine,self);
			if HasAbstracts then ParCre.ErrorDef( Err_Routine_Has_Abstracts ,self);
		end;
		if not IsExecutableRoutine then ParCre.ErrorDef(Err_Rtn_Has_No_Main,self); {Split is 'is abstract' and 'has no main'}
	end;

	function TRoutine.GetRelativeLevel : cardinal;
	begin
		exit(fRelativeLevel);
	end;


	procedure TRoutine.SignalHasForward(ParCre : TNDCreator);
	begin
		if RTS_Has_Forwards in fRoutineStates then begin
			ParCre.ErrorDef(Err_Routine_Has_Allready_forw,self);
		end;
		SetRoutineStates([RTS_Has_Forwards],true);
	end;

	procedure TRoutine.GetDisplayName(var ParName :ansistring);
	var
		vlCurrent : TDefinition;
	begin
		vlCurrent := self;
		EmptyString(ParName);
		while (vlCurrent <> Nil) do begin
			if(length(ParName) <> 0) then ParName := '/'+ParName;
			ParName := vlCurrent.fText+ParName;
			vlCurrent := vlCurrent.GetRealOwner
		end;
	end;

	function TRoutine.GetParentName(var ParName :ansistring):boolean;
	begin
		if iParent = nil then exit(false);
		ParName := iParent.fText;
		exit(true);
	end;

	function  TRoutine.IsCompleet:boolean;
	begin
		exit(RTS_IsDefined in fRoutineStates);
	end;


	procedure  TRoutine.ConsiderForward(ParCre : TCreator;ParIn : TDefinition;var ParOut : TDefinition);
	var
		vlDef    : TRoutine;
		vlDifText : ansistring;
		vlOwner   : TDefinition;
	begin
		ParOut := nil;
		if ParIn = nil then exit;
		GetPtrByObjectInCurrentList(ParIn.fText,ParIn,[SO_Local],vlOwner,TDefinition(vlDef));
		if (vlDef <> nil) and (vlDef is TRoutine) and vlDef.GetForwardDefined then begin
			if not( vlDef.IsCompleet) then begin
				if not vlDef.IsSameAsForward(TRoutine(ParIn),vlDifText) then begin
					TNDCreator(ParCre).ErrorText(Err_Differs_From_Prev_Def,vlDifText);
					if IsSameRoutine(TRoutine(ParIn),[PC_CheckALl,PC_IgnoreState]) then ParOut := vlDef;
					exit;
				end;
				ParOut := vlDef;
			end;
			exit;
		end;
		if (RTS_Has_Sr_Lock in fRoutineStates) then begin
			if (RTM_extended in fRoutineModes) and not(RTM_ShortDCode in TRoutine(ParIn).fRoutineModes) then begin
				TNDCreator(ParCre).ErrorDef(Err_Def_Not_In_Forward,ParIn);
				SetRoutineModes([RTM_CHange_After_Lock],true);
				{Should be set when item is added to sub list, this is a weak link between this
				event and the other}
			end;
		end;
	end;


  function   TRoutine.IsSameParamByNodesArray(const ParNodes :array of TRoot;ParExact : boolean):boolean;
  begin
  		exit(GetParList.IsSameParamByNodesArray(ParNodes,ParExact));
  end;

	function   TRoutine.GetParList : TProcParList;
	begin
		exit(TProcParList(iParts));
	end;

	function  TRoutine.CheckAccessLevel(ParParent : TRoutine):boolean;
	var vlParentOwner : TRoutine;
		vlCurrent     : TRoutine;
		vlAccess      : TDefAccess;
	begin
		vlParentOwner := TRoutine(ParParent.GetRoutineOwner);
		if (vlParentOwner = nil) then begin
			exit( IsLessPublicAs(ParParent.fDefAccess,GetUnitLevelAccess));
		end else begin
			vlCurrent :=  self;
			vlAccess := vlCurrent.fDefAccess;
			while (vlCurrent <> nil) do begin
				vlAccess := CombineAccess(vlCurrent.fDefAccess,vlAccess);
				if vlParentOwner.IsParentOf(vlCurrent) then begin
					exit(IsLessPublicAs(ParParent.fDefAccess,vlAccess));
				end;
				vlCurrent := TRoutine(vlCurrent.GetRoutineOwner);
			end;
			exit(IsLessPublicAs(ParParent.GetUnitLevelAccess,vlAccess));
		end;
	end;

	function  TRoutine.GetRealOwner:TDefinition;
	var vlOwn : TDefinition;
	begin
		vlOwn := fOwner;
		if (vlOwn <> nil) then vlOwn := vlOwn.fOwner;
		exit(vlOwn);
	end;


	function  TRoutine.GetRoutineOwner : TDefinition;
	var vlOwn : TDefinition;
	begin
		vlOwn := fOwner;
		if vlOwn <> nil then vlOwn := vlOwn.fOwner;
		if vlOwn <> nil then begin
			if not(vlOwn is TRoutine) then vlOwn := nil;
		end;
		exit(vlOwn);
	end;

	procedure TRoutine.CreateVarCBInits(ParCre : TNDCreator;ParNode : TSubListStatementNode;ParContext : TDefinition);
	begin
		if iParent <> nil then iParent.CreateVarCbInits(ParCre,ParNode,ParContext);
		GetParList.CreateCBInits(ParCre,ParNode,ParContext);
	end;

	procedure  TRoutine.GetForParentMangleName(var ParName : ansistring);
	begin
		GetTextName(ParName);
		PostMangledName(ParName);
	end;

	function  TRoutine.HasSameMapping(ParRoutine : TRoutine):boolean;
	begin
		if ParRoutine = nil then exit(false);
		if iParameterMapping = nil then exit(ParRoutine.fParameterMapping = nil);
		exit(iParameterMapping.IsSameMapping(ParRoutine.fParameterMapping));
	end;

	procedure TRoutine.AutomaticCreateMapping;
	begin
		GetParList.AutoMaticCreateMapping(iParameterMapping);
	end;

	function  TRoutine.IsSameByMapping(ParMapping : TParameterMappingList) : boolean;
	begin
		exit(ParMapping.IsSameKind(GetParList));
	end;

	procedure TRoutine.AddNormalParameterMapping(ParCre : TNDCreator;Const ParName : ansistring;ParOption : TMappingOption);
	var vlDefinition : TVarBase;
		vlLocal      : boolean;
		vlOwner      : TDefinition;
		vlLevel      : cardinal;
	begin
		vlLocal := true;
		if not(GetPtrInCurrentList(ParName,vlOwner,vlDefinition)) then begin
			ParCre.GetIdentByName(ParName,vlOwner,vlDefinition);
			vlLocal := false;
		end;


		if(vlDefinition = nil) then begin
			ParCre.ErrorText(Err_unkown_ident,ParName);
		end else if (vlDefinition is TParameterVar) and (vlLocal) then begin
			iParameterMapping.AddParameter(vlDefinition{,ParOption});
		end else if (vlDefinition is TVarBase) then begin
			ParCre.CheckAccessLevel(vlDefinition);
			if vlOwner <> nil then vlOwner := vlOwner.GetRealOwner;
			GetOwnerLevelTo(vlOwner,vlLevel);{TODO: error handeling when level not found}
			iParameterMapping.AddVariable(vlDefinition,vlLevel,self,ParOption)
		end else begin
			ParCre.ErrorText(Err_Not_A_Var,ParName);
			exit;
		end;
	end;

	procedure  TRoutine.AddConstantParameterMapping(ParCre : TNDCreator;ParVal : TValue);
	var vlStr   : ansistring;
		vlName  : ansistring;
		vlConst : TVarBase ;
	begin
		if ParVal= nil then exit;
		GetNewAnonName(vlName);
		vlConst := nil;
		if ParVal.fType= VT_ansistring then begin
			ParVal.GetString(vlStr);
			vlConst := TVarBase(ParCre.AddStringConst(vlName,vlStr));
		end else  begin
			vlConst := TVarBase(ParCre.AddConstant(vlName,ParVal));
		end;
		if vlConst <> nil then iParameterMapping.AddConstant(vlConst);
		ParVal.Destroy;
	end;


	procedure  TRoutine.CloneParameters(ParCre : TNDCreator;ParToCb : TRoutine;ParContext,PArNewOwner : TDefinition;ParAutomatic : boolean);
	begin
		GetParList.CloneParameters(ParCre,ParContext,ParNewOwner,GetRealOwner,TProcParList(ParToCb.iParts),ParAutomatic);
	end;


	function TRoutine.CreateExitNode(ParCre : TCreator;ParNode : TFormulaNode) : TNodeIdent;
	begin
		TNDCreator(ParCre).ErrorText(err_int_Abstract_call,'CreateEditNode');
		exit(nil);
	end;


	function TRoutine.GetLocalSize : TSize;
	begin
		if RTS_HasNeverStackFrame in iRoutineStates then begin
			exit(0);
		end else begin
			exit(iLocalFrame.GetTotalSize);
		end;
	end;


	function TRoutine.CreateNewCB(ParCre : TCreator;const ParName : ansistring) : TRoutine;
	begin
		exit(nil);
	end;

	function TRoutine.CreateShortSubCB(ParCre : TCreator) : TRoutine;
	begin
		exit(CreateNewCB(ParCre,fText));
	end;


	function  TRoutine.CreateSHortERtn(ParCre : TCreator)   : TRoutine;
	var vlName : ansistring;
	begin
		GetNewAnonName(vlName);
		exit(CreateNewCB(ParCre,vlName));
	end;

	procedure TRoutine.CloneVmtFromParent;
	begin
		if iMeta <> nil then iMeta.CloneFromParent;
	end;

	function TRoutine.CanInherit : boolean;
	begin
		exit(RTM_extended in iRoutineModes);
	end;

	function TRoutine.IsVirtual : boolean;
	begin
		exit([RTM_Virtual,RTM_Override] * iRoutineModes <> []);
	end;


	function TRoutine.CanUseInherited :boolean;
	begin
		exit(CanInherit or ([RTM_Virtual,RTM_OVerride,RTM_Final] * iRoutineModes <> []));
	end;

	function    TRoutine.MustNameAddAsOwner:boolean;
	begin
		exit(true);
	end;

	procedure  TRoutine.SetupMeta(ParCre : TCreator);
	var
		vlParent : TMeta;
		vlType   : TType;
		vlVmtType:TType;
		vlName : ansistring;
	begin
		vlName := fText;
		PostMangledName(vlName);
		vlParent := nil;
		if fParent <> nil then vlParent := fParent.fMeta;
		vlType := TNDCreator(ParCre).GetDefaultIdent(DT_Meta,0,false);
		vlVmtType := TNDCreator(ParCre).GetDefaultIdent(DT_Pointer,0,false);
		if vlType    = nil then TNDCreator(ParCre).SemError(Err_No_Meta_Data_type);
		if vlVmtType = nil then TNDCreator(ParCre).SemError(Err_Cant_Find_Ptr_type);
		iMeta := TRoutineMeta.Create(vlParent,vlName,vlType,vlVmtType);
		iMeta.SetModule(fModule);
		iMeta.fOwner := self;
	end;

	procedure  TRoutine.CheckIsInheritedComp(ParCre : TCreator;ParCB : TRoutine;ParHasMain : boolean);
	begin
	end;

	function   TRoutine.GetPtrInCurrentList(const ParName : ansistring;var ParOwner,ParItem :TDefinition):boolean;
	begin
		exit(inherited GetPtrByName(ParName,[SO_Local],ParOwner,Paritem));
	end;

	function   TRoutine.GetPtrByName(const ParName:ansistring;ParOption : TSearchOptions;var ParOwner,ParItem:TDefinition):boolean;
	var
		vlRes     : boolean;
		vlCurrent : TRoutine;
	begin
		vlRes := inherited GetPtrByName(ParName,ParOption,ParOwner,ParItem);
		if not(vlRes) then begin
			vlCurrent := fParent;
			ParOwner  := nil;
			ParItem   := nil;
			while (vlCurrent <> nil) do begin
				vlRes := vlCurrent.GetPtrByName(ParName,ParOption ,ParOwner,ParItem);
				if(vlRes) and (((SO_Local in ParOption) and (ParItem.fDefAccess <> AF_Private))
					or (ParItem.fDefAccess = AF_Public))   then begin
						if(ParOwner =vlCurrent) then ParOwner := self;
						break;
				end;
				vlCurrent := vlCurrent.fParent;
				ParOwner := nil;
				ParItem  := nil;
				vlRes    := false;
			end;
		end;
		exit(vlRes);
	end;

	function TRoutine.GetPtrByObjectInCurrentList(const ParName:ansistring;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult :TDefinition):TObjectFIndState;
	begin
		exit( inherited GetPTrByObject(ParName,ParObject,ParOption,ParOwner,ParResult));
	end;

	function  TRoutine.GetPtrByObject(const ParName : ansistring;ParObject : TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;
	var vlCurrent : TRoutine;
		vlState   : TObjectFindState;
	begin
		vlState := inherited GetPtrByObject(ParName,ParObject,ParOption,ParOwner,ParResult);
		if vlState <> OFS_Different then exit(vlState);
		if ParResult = nil then begin
			vlCurrent := fParent;
			while (vlCurrent <> nil) do begin
				vlState := vlCurrent.GetPtrByObject(ParName,ParObject,ParOption,ParOwner,ParResult);
				if (ParResult <> nil) then begin
				if(vlState = OFS_Same) and (((SO_Local in ParOption) and (ParResult.fDefAccess <> AF_Private))
				or (ParResult.fDefAccess = AF_Public))   then begin

						if(ParOwner = vlCurrent) then ParOwner := self;
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

	function TRoutine.GetPtrByArray(const ParName : ansistring;const ParArray : Array of TRoot;ParOption : TSearchOptions;var ParOwner,ParResult : TDefinition):TObjectFindState;
	var vlCurrent : TRoutine;
		vlState   : TObjectFindState;
	begin
		vlState := inherited GetPtrByArray(ParName,ParArray,ParOption,ParOwner,ParResult);
		if vlState <> OFS_Different then exit(vlState);
		if ParResult = nil then begin
			vlCurrent := fParent;
			while (vlCurrent <> nil) do begin
				vlState := vlCurrent.GetPtrByArray(ParName,ParArray,ParOption,ParOwner,ParResult);
				if (ParResult <> nil) then begin
				if(vlState = OFS_Same) and (((SO_Local in ParOption) and (ParResult.fDefAccess <> AF_Private))
				or (ParResult.fDefAccess = AF_Public))   then begin

						if(ParOwner = vlCurrent) then ParOwner := self;
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



	procedure  TRoutine.ShareLocalFrame(ParCB : TRoutine);
	var vlLocalFrame : TFrame;
		vlParameterFrame : TFrame;
	begin
		vlLocalFrame     := ParCb.fLocalFrame;
		vlParameterFrame := ParCB.fParameterFrame;
		if (vlLocalFrame <> iLocalFrame) and (vlParameterFrame <> iParameterFrame) then begin
			SetRoutineStates([RTS_SharedLocalFrame],true);
			GetParList.ChangeFrame(vlLocalFrame,vlParameterFrame);
			iLocalFrame.Destroy;
			iParameterFrame.Destroy;
			iLocalFrame     := vlLocalFrame;
			iParameterFrame := vlParameterFrame;
		end;
	end;


	procedure  TRoutine.ProcessInherited(ParCre : TCreator;ParCB : TRoutine);
	var
		vlText : ansistring;
		vlName : ansistring;
	begin
		if ParCB = nil then exit;
		if (RTM_Isolate in fRoutineModes) and (ParCB.GetRoutineOwner <> nil) and not(RTM_Isolate in ParCB.fRoutineModes) then TNDCreator(ParCre).SemError(Err_Parent_is_not_isolated);
		if not(RTM_Isolate in fRoutineModes) and (Rtm_Isolate in ParCB.fRoutineModes) then  TNDCreator(ParCre).SemError(Err_Must_Isolate);

		if GetLocalSize <> 0 then fatal(fat_Proc_has_Allready_Locals,'');
		if not(RTM_extended in (ParCB.fRoutineModes)) then TNDCreator(ParCre).SemError(Err_Rtn_Is_not_extended);
		if RTM_Inherit_Final in ParCB.fRoutineModes then TNDCreator(ParCre).SemError( Err_Parent_inh_Final);
		iLocalFrame.fPrevious := ParCb.fLocalFrame;
		iParent := ParCb;
		if  CheckAccessLevel(ParCB) then begin
			if iParent <> nil then begin
				vlName := iParent.fText
			end else  begin
				vlName := '<unkown>';
			end;
			vlText:= vlName+'=>'+fText;
			TNDCreator(ParCre).ErrorText(Err_Child_More_public,vlText);
		end;
	end;

	function  TRoutine.IsSameAsForward(ParCB : TDefinition;var ParText : ansistring):boolean;
	var
		vlCB :TROutine;
		vlDiff : TRoutineModes;
	begin
		EmptyString(ParText);
		if (ParCB = nil) or not(ParCB is TRoutine) then exit(false);
		vlCB := TRoutine(ParCb);
		if vlCb.ClassType <> ClassType then begin
			ParText := ParText+'Different kind of Routine';
			exit(false);
		end;
		if vlCb.fDefAccess <> fDefAccess then begin
			ParText := 'Access is different';
			exit(false);
		end;
		if CheckParameterNames(vlCB,ParText) then exit(false);
		if not iParameterMapping.IsSameMapping(vlCb.fParameterMapping) then begin
			ParText := 'Mapping is different';
			exit(false);
		end;


		if vlCB.fRoutineModes - [RTM_Abstract] <> fRoutineModes - [RTM_Abstract] then begin
			vlDiff := (vlCb.fRoutineModes - fRoutineModes) + (fRoutineModes - vlCb.fRoutineModes);
			ParText := 'Following routine modes are different : ';
			if RTM_Abstract in vlDiff then ParText := ParText + ' Abstract mode';
			if [RTM_Virtual,RTM_Final,RTM_Override] * vlDiff <> [] then ParText := ParText + '  virtual mode' ;
			if [RTM_Overload,RTM_Name_Overload,RTM_Exact_Overload] * vlDiff <> [] then ParText := ParText + ' overload mode';
			if RTM_Write_Mode in vlDiff then parText := ParText + ' write mode';
			if RTM_CDecl in vlDiff then ParText := ParText + ' cdecl mode';
			exit(false);
		end;
		exit(true);
	end;



	procedure  TRoutine.SetRoutineStates(ParStates : TRoutineStates;ParOn : boolean);
	begin
		if ParOn then iRoutineStates := iRoutineStates + ParStates
		else iRoutineStates := iRoutineStates - ParStates;
	end;


	procedure TRoutine.SetRoutineModes(Parmode : TRoutineModes;ParOn : boolean);
	begin
		if ParOn then iRoutineModes := iRoutineModes + ParMode
		else iRoutineModes := iRoutineModes - ParMode;
	end;

	function TRoutine.MustSeperateInitAndMain : boolean;
	begin
		exit(RTM_extended in fRoutineModes);
	end;



	procedure TRoutine.PreBlockOfCode(ParCre : TNDCreator);
	var
		vlMainCB: TRoutine;
		vlPrvAccess : TDefAccess;
	begin
		if (RTM_Abstract) in fRoutineModes  then begin
			 ParCre.ErrorDef(Err_Abs_cant_have_main ,self);
		end else if(iStatements = nil) then begin

			vlPrvAccess := ParCre.fCurrentDefAccess;
		    ParCre.fCurrentDefAccess := AF_Protected;
			vlMainCb := iPhysicalAddress;

			if  MustSeperateInitAndMain then begin
				SeperateInitAndMain(ParCre,vlMainCB);
			end else begin
				iStatements := TRoutineNode.Create(vlMainCB);
			end;

			if vlMainCb <> nil then begin
				vlMainCB.CreatePreCode(ParCre);
				vlMainCb.SetIsDefined;
			end;

			if(RTS_Forward_No_Main in fRoutineStates) then ParCre.ErrorDef(Err_Forward_No_Main,self);
			ParCre.fCurrentDefAccess := vlPrvAccess;
			SetRoutineStates([RTS_Forward_Has_Main],true);

		end;
    end;

	procedure  TRoutine.PreNoMain(ParCre : TNDCreator);
	var
		 vlProc     : TRoutineNode;
    begin
		if(iStatements = nil) then begin
			vlProc   := TRoutineNode.Create(self);
			iStatements := vlProc;
			if not(RTM_Abstract in fRoutineModes) and not(RTM_Extended in fRoutineModes) then begin
				ParCre.SemError(Err_Non_Ext_Abs_Needs_Main);
				exit;
			end;
			iPhysicalAddress := nil;
			if fParent <> nil then begin
				iPhysicalAddress := fParent.fPhysicalAddress;
				if iPhysicalAddress <> nil then CreateInitCode(ParCre);
			end;
			SetRoutineStates([RTS_HasNoMain],true);
			CheckIsInheritedComp(ParCre,iParent,false);

		end;
		if (RTS_forward_Has_Main in fRoutineStates) and (iPhysicalAddress = nil) and (RTS_Require_Main in fRoutineStates) then begin
			ParCre.ErrorDef(Err_Rtn_Requires_Main,self);
		end;
		SetRoutineStates([RTS_Forward_No_Main],true);
		iStatements.FinishNode(ParCre,true);
		SetIsDefined;
	end;

	procedure  TRoutine.CreateInitCode(ParCre :TNDCreator);
	var
		vlCall : TCallNode;
	begin
			CreatePreCode(ParCre);
			CreateVarCBInits(TNDCreator(ParCre),iStatements,self);
			if iParameterMapping <> nil then iParameterMapping.CreateCBInit(iStatements,ParCre,self);
			vlCall   := TCallNode.Create(iPhysicalAddress.fText);
			vlCall.SetRoutineItem(ParCre,iPhysicalAddress,self);
			iStatements.AddNode(vlCall);
			CreatePostCode(ParCre);
	end;

	function   TROutine.CreateSeperationRoutine(ParCre : TNDCreator) : TRoutine;
	var
		vlName : ansistring;
	begin
		GetNewAnonName(vlName);
		exit(TProcedureObj.Create(vlName));
	end;


	procedure  TRoutine.SeperateInitAndMain(ParCre : TNDCreator;var ParNewCB : TRoutine);
	var vlProc     : TRoutineNode;
		vlPrn      : TRoutineNode;
		vlCall     : TCallNode;
     	vlName     :ansistring;
	begin
		ParNewCB   := nil;
		vlProc   := TRoutineNode.Create(self);
		iStatements := vlProc;
		ParNewCb := CreateSeperationRoutine(ParCre);
		ParCre.AddRoutineItem(ParNewCB);
		ParNewCB.ShareLocalFrame(self);
		vlPrn := TRoutineNode.Create(ParNewCB);
		ParNewCB.fDefAccess := AF_Protected;
		ParNewCB.SetRoutineStates([RTS_HasNeverStackFrame,RTS_IsDefined],true);
		ParNewCb.fStatements := vlPrn;
		iPhysicalAddress   :=ParNewCb;
		CreatePreCode(ParCre);
		CreateVarCBInits(TNDCreator(ParCre),vlProc,self);
		if iParameterMapping <> nil then iParameterMapping.CreateCBInit(vlProc,ParCre,self);
		ParNewCb.GetTextName(vlName);
		vlCall   := TCallNode.Create(vlName);
		vlCall.SetRoutineItem(ParCre,ParNewCB,self);
		vlProc.AddNode(vlCall);
		CreatePostCode(ParCre);
		iStatements.FinishNode(ParCre,true);
		SetRoutineStates([RTS_HasNoMain],false);
		CheckIsInheritedComp(ParCre,iParent,true);
	end;


	procedure TRoutine.SignalForwardDefined;
	begin
		SetRoutineStates([RTS_ForwardDefined,RTS_Has_Sr_Lock],true);
	end;

	procedure TRoutine.SignalInPublicSection;
	begin
		SignalForwardDefined;
	end;

	function TRoutine.GetForwardDefined : boolean;
	begin
		exit(RTS_ForwardDefined in fRoutineStates);
	end;

	function TRoutine.CreateInheritAddress(ParCre : TCreator) : TNodeIdent;
	var
		vlType     : TType;
	begin
		CreateInheritAddress := nil;
		if iVmtItem <> nil then begin
			CreateInheritAddress := iVmtItem.CreateReadNode(ParCre,self);
		end else begin
			vlType := TNDCreator(ParCre).GetDefaultIdent(dt_pointer,size_dontcare,false);
			if vlType = nil then begin
				TNDCreator(ParCre).ErrorText(Err_Cant_Find_ptr_Type,'void pointer for proc '+fText);
			end;
			CreateInheritAddress :=  TLabelNode.Create(iPhysicalAddress,vlType);
		end;
	end;

	function TRoutine.CreateMentionAddress(ParCre:TCreator;ParContext : TDefinition) : TNodeIdent;
	var vlAddressNode  : TNodeIdent;
		vlType          : TType;
	begin
		if iVmtItem <> nil then begin
			vlAddressNode := iVmtItem.CreateReadNode(ParCre,ParContext);
		end else begin
			vlType := TNDCreator(ParCre).GetDefaultIdent(dt_pointer,size_dontcare,false);
			if vlType = nil then begin
				TNDCreator(ParCre).ErrorText(Err_Cant_Find_ptr_Type,'void pointer for proc '+fText);
			end;
			vlAddressNode := TLabelNode.Create(self,vlType);
		end;
		exit(vlAddressNode);
	end;

		function  TRoutine.CheckParameterNames(ParItem : TRoutine ; var ParDifText : ansistring):boolean;
	begin
		exit(GetParList.CheckParameterNames(TProcParList(ParItem.iParts),ParDifText));
	end;

	procedure  TRoutine.InitVariables(ParFrame : TFrame;ParContext : TDefinition);
	begin
		GetParList.InitVariables(self,ParContext,ParFrame);
	end;

	procedure TRoutine.DoneVariables(ParFrame : TFrame);
	begin
		GetParList.DoneVariables(self,ParFrame);
	end;


	procedure TRoutine.DoneAllVariables;
	var vlCurrent : TRoutine;
		vlFrame   : TFrame;
	begin
		vlCurrent := self;
		if fMeta <> nil then begin
			vlFrame := fMeta.fMetaFrame;
			while vlCurrent <> nil do begin
				vlCurrent.DoneVariables(vlFrame);
				vlCurrent := vlCurrent.fParent;
			end;
		end;
	end;

	procedure TRoutine.InitAllVariables;
	var vlCurrent : TRoutine;
		vlFrame   : TFrame;
	begin
		vlCurrent := self;
		vlFrame   := nil;
		if fMeta <> nil then vlFrame := fMeta.fMetaFrame;
		while (vlCurrent <> nil) do begin
			vlCurrent.InitVariables(vlFrame,self);
			vlCurrent := vlCurrent.fParent;
		end;
	end;

	procedure  TRoutine.InitParameters;
	begin
		GetParList.InitParameters(self);
		InitAllVariables;
	end;

	procedure  TRoutine.DoneParameters(ParCre : TSecCreator);
	begin
		DoneAllVariables;
		GetParList.DoneParameters(ParCre,self);
	end;


	function TRoutine.CreateAutomaticParameterNodes(ParContext :TDefinition;ParCre:TNDCreator;ParList:TCallNodeList):TTLVarNode;
	begin
		exit(GetParList.CreateAutomaticParameterNodes(ParContext,GetRoutineOwner,parCre,ParList));
	end;


	function TRoutine.IsInheritedInHyr(ParFrom : TDefinition) : boolean;
	var
		vlParentOwn : TDefinition;
	begin
		if fParent = nil then exit(false);
		if ParFrom = nil then exit(true);
		vlParentOwn := fParent.GetRealOwner;
		if vlParentOwn = nil then exit(false);
		exit(vlParentOwn.IsParentOf(ParFrom));
	end;


	procedure TROutine.AddParameterToNested(ParCre : TCreator;ParNested :TDefinition);
	var
		vlRoutine   : TRoutine;
		vlPtrType   : TType;
		vlNeedNest  : boolean;
		vlParameter : TFrameParameter;
		vlNestName  : ansistring;
		vlMetaName  : ansistring;
		vlNestMeta  : TRoutineMeta;
		vlVirtual   : boolean;
	begin
		vlRoutine := TRoutine(ParNested);
		vlPtrType := TNDCreator(ParCre).GetDefaultIdent(DT_Pointer,0,false);
		vlNeedNest := not vlRoutine.IsInheritedInHyr(self);
		vlVirtual :=  RTM_extended in TRoutine(ParNested).fRoutineModes;
		if vlNeedNest then begin
			GetNewAnonName(vlNestName);
			vlNestName := vlNestName+'_nest';
			if self <> vlRoutine.GetRealOwner then begin
				vlParameter := TFixedFrameParameter.Create(vlNestName,self,vlRoutine.fParameterFrame,fLocalFrame,vLPtrType,vlVirtual);
			end else begin
				vlParameter := TFrameParameter.Create(vlNestName,1,vlRoutine.fParameterFrame,fLocalFrame,vlPtrType,PV_Value,vlVirtual);
			end;
			vlRoutine.AddParam(vlParameter);
			vlNestMeta := fMeta;
			if (vlNestMeta <> nil) then begin

				vlPtrType   := TNDCreator(ParCre).GetDefaultIdent(DT_Ptr_Meta,Size_DontCare,false);
				if vlPtrType = nil then begin

					TNDCreator(ParCre).SemError(err_No_Meta_data_type);

				end else begin

					if vlRoutine.fMeta <> nil then begin
						vlMetaName := Name_OwnerMeta+'_'+fText;
					end else begin
						vlMetaName := Name_Meta;
					end;

				end;
				if self <> vlRoutine.GetRealOwner then begin
					vlParameter := TFixedFrameParameter.Create(vlNestName,self,vlRoutine.fParameterFrame,fLocalFrame,vLPtrType,vlVirtual);
				end else begin
					vlParameter := TFrameParameter.Create(vlMetaName,1,vlRoutine.fParameterFrame,vlNestMeta.fMetaFrame,vlPtrType,PV_Value,vlVirtual);
				end;
				vlRoutine.AddParam(vlParameter);
			end;
		end;

	end;

	procedure  TRoutine.AddAutomaticParameters(ParParentContext : TDefinition;ParCre : TNDCreator);
	var
		vlPtrType    : TType;
		vlDefAccess  : TDefAccess;
		vlOwner      : TDefinition;
	begin
		vlOwner := GetRealOwner;
		if fParent <> nil then begin
			fParent.CloneParameters(ParCre,self,ParParentContext,vlOwner,true);
		end;
		if (vlOwner <> nil) and not(RTM_Isolate in fRoutineModes) then begin
			vlOwner.AddParameterToNested(ParCre,self);
		end;
		if (fMeta <> nil) and (fParent=nil)  then begin
			vlPtrType   :=ParCre.GetDefaultIdent(DT_Ptr_meta,Size_DontCare,False);
			if vlPtrType = nil then begin
				ParCre.SemError(Err_No_Meta_Data_type);
			end else begin
				vlDefAccess := ParCre.fCurrentDefAccess;
				ParCre.fCurrentDefAccess := AF_Protected;
				ParCre.AddIdent(TLocalMetaVar.Create(Name_Meta,iLocalFrame,iLocalFrame.GetNewOffset(vlPtrType.fSize),fMeta,vlPtrType));
				ParCre.fCurrentDefAccess := vlDefAccess;
			end;
		end;
	end;

	procedure  TRoutine.PreProcessParameterList(ParParentContext,ParOtherOwner : TDefinition;ParCre:TNDCreator);
	begin
		AddAutomaticParameters(ParParentContext,ParCre);
		if (ParOtherOwner <> nil) and (GetRealOwner <> ParOtherOwner) and not(RTM_Isolate in fRoutineModes) then begin
			ParOtherOwner.AddParameterToNested(ParCre,self);
		end;
		if iParent <> nil then iParameterMapping.ConnectToParent(ParCre,TProcParList(iParent.iParts),iParent.fParameterMapping);
		GetParList.SetParametersOffset(ParCre);
		GetParLIst.SetSecondVars(ParCre);
		if iParent <> nil then iParameterMapping.CheckParametersAddress(ParCre);
	end;

	function TRoutine.GetRTLParameter:TRTLParameter;
	begin
		GetRTLParameter := GetParList.GetRTLParameter;
	end;


	procedure TRoutine.InitStorageList;
	begin
		voStorageList := TTLVStorageList.Create;
	end;

	function TRoutine.IsOverloadingComp(ParIdent:TDefinition):boolean;
	begin
		IsOverloadingComp := IsSameIdentCode(ParIdent);
	end;


	procedure  TRoutine.PostMangledName(var ParName:ansistring);
	begin
		if iCollectionNo <> 0 then GetAssemblerInfo.AddMangling(ParName,'_'+IntToStr(iCollectionNo));
	end;

	function TRoutine.GetParamSize:TSize;
	begin
		exit(GetParList.fParamSize);
	end;



	function TRoutine.SaveItem(ParStream:TObjectStream):boolean;
	begin
		SaveItem := true;
		if inherited SaveItem(ParStream)              then exit;
		if ParStream.WritePi(iPhysicalAddress)        then exit;
		if ParStream.WriteLong(cardinal(fRoutineModes)) then exit;
		if ParStream.WriteLong(cardinal(fRoutineStates)) then exit;
		if ParStream.WritePi(iParent)                 then exit;
		if ParStream.WriteLong(iRelativeLevel)     then exit;
		if RTS_SharedLocalFrame in iRoutineStates then begin
			if ParStream.WritePi(iLocalFrame)      then exit;
			if ParStream.WritePi(iParameterFrame)  then exit;
		end else begin
			if iLocalFrame.SaveItem(ParStream)     then exit;
			if iParameterFrame.SaveItem(ParStream) then exit;
		end;
		if (RTM_extended in fRoutineModes)  then begin
			if iMeta.SaveItem(ParStream)         then exit;
		end;
		if ParStream.WritePi(iVmtItem)               then exit;
		if iParameterMapping.SaveItem(ParStream)     then exit;
		if ParStream.WriteLong(iCollectionNo)     then exit;
		SaveItem := false;
	end;

	function TRoutine.LoadItem(ParStream:TObjectStream):boolean;
	var
		vlCBFlags	     : TRoutineModes;
		vlRoutineStates  : TRoutineStates;
	begin
		LoadItem := true;
		if inherited LoadItem(ParStream)              then exit;
		if ParStream.ReadPi(voPhysicalAddress)        then exit;
		if ParStream.ReadLong(cardinal(vlCBFlags)) then exit;
		if ParStream.ReadLong(cardinal(vlRoutineStates)) then exit;
		if ParStream.ReadPi(voParent)                 then exit;
		if ParStream.ReadLong(voRelativeLevel)     then exit;
		iLocalFrame.Destroy;
		iParameterFrame.Destroy;
		if RTS_SharedLocalFrame in vlRoutineStates then begin
			if ParStream.ReadPi(voLocalFrame)     then exit;
			if ParStream.ReadPi(voParameterFrame) then exit;
		end else begin
			if CreateObject(ParStream,TStrabelRoot(voLocalFrame)) <> sts_ok    then exit;
			if CreateObject(ParStream,TStrAbelRoot(voParameterFrame)) <> sts_ok then exit;
		end;
		if (RTM_extended in vlCBFlags) then begin
			if CreateObject(ParStream,TStrabelRoot(voMeta)) <> STS_Ok then exit;
		end;
		if ParStream.Readpi(voVmtItem)             then exit;
		if iParameterMapping.LoadItem(ParStream)   then exit;
		if ParStream.ReadLong(voCollectionNo)   then exit;
		if iParent <> nil then iParameterMapping.fParent := iParent.fParameterMapping;

		iRoutineModes  := vlCBFlags;
		iRoutineStates := vlRoutineStates;
		exit(false);
	end;

	procedure TRoutine.CreateInitProc(ParCre:TSecCreator);
	begin
		GetParList.ProduceFrame(ParCre,self);
	end;

	function  TRoutine.CreateExecuteNode(ParCre:TCreator;ParContext : TDefinition):TNodeIdent;
	var
		vlNode : TCallNode;
	begin
		vlNode :=TCallNode(TRoutineCollection(fOwner).CreateExecuteNode(ParCre,ParContext));
		vlNode.SetRoutineItem(TNDCreator(ParCre),self,ParContext);
		exit(vlNode);
	end;



	function   TRoutine.CreatePropertyWriteDotNode(ParCre : TCreator;ParLeft,ParSource : TFormulaNode;ParOwner : TDefinition) : TFormulaNode;

	var
		vlNode : TFormulaNode;
	begin
		vlNode := CreatePropertyWriteNode(ParCre,ParOwner,ParSource);
		vlNode.fRecord := ParLeft;
		exit(vlNode);
	end;

	function  TRoutine.CreatePropertyWriteNode(ParCre : TCreator;ParOwner : TDefinition;ParValue :TFormulaNode):TFormulaNode;
	var
		vlNode : TCallNode;
	begin
		vlNode := TCallNode(CreateExecuteNode(ParCre,ParOwner));
		vlNode.AddNode(ParValue);
		exit(vlNode);
	end;


	function TRoutine.CreateRoutineAsm : TRoutineAsm;
	var
		vlProcName  : ansistring;
		vlShortName :ansistring;
		vlParentName : ansistring;
		vlInst : TRoutineAsm;
	begin
		GetMangledName(vlProcName);
		GetTextName(vlShortName);
		EmptyString(vlParentName);
		if GetRealOwner <> nil then GetRealOwner.GetMangledName(vlParentName);
		vlInst := TRoutineAsm.Create(vlShortName,vlProcName,vlParentName,iStatements.fLine,IsAsmGlobal);
		exit(vlInst);
	end;

	procedure TRoutine.InitParts;
	begin
		iParts := TProcParList.Create;
	end;

	Function TRoutine.GetNumberOfParameters: cardinal;
	begin
		GetNumberOfParameters := GetParList.GetNumberOfParameters;
	end;

{TODO: varuse check in seperator itirator}
	procedure  TRoutine.ProducePoc(ParCre : TCreator);
	var vlCre  : TSecCreator;
		vlName : ansistring;
		vlList : TUseList;
	begin
		if iStatements = nil then exit;

		vlCre := TAsmCreator(ParCre).fSecCre;

		if GetConfigValues.fVarUseCheck then begin
			vlList := TUseList.Create(self);
			GetParList.AddItemsToUseList(vlList);
			iStatements.ValidateDefinitionUse(vlCre,AM_Execute,vlList);
			vlList.CheckUnused(vlCre);
			vlList.Destroy;
		end;

		if (ParCre.SuccessFul) and not( RTS_ProcCreated in iRoutineStates) then begin
			if iParent <> nil then iParent.ProducePoc(ParCre);
			GetMangledName(vlName);
			verbose(VRB_Procedure_Name,'** creating code,name :'+vlName);
			if ParCre.SuccessFul then begin
				iStatements.CreateSec(vlCre);
				fRoutinePoc := TRoutinePoc(vlCre.fPoc);
				GetParList.ProducePoc(ParCre);
				DoneRoutine(vlCre);
			end;
			verbose(VRB_Procedure_Name,'End '+vlName);
			if ParCre.SuccessFul then begin
				fRoutinePoc.ProcessPocList(fStorageList);
				SetIsDefined;
			end;
		end;
		SetRoutineStates([RTS_IsDefined,RTS_ProcCreated],true);
	end;

	procedure TROutine.CheckAfter(ParCre : TCreator);
	begin
		inherited CheckAfter(ParCre);
		if  not( RTM_Abstract in iRoutineModes) then begin
			 if not (RTS_IsDefined in iRoutineStates)   then begin
				TNDCreator(ParCre).ErrorDef(Err_forward_not_resolved,self);
			end;

		end;
	end;

	function  TRoutine.CreateDB(ParCre:TCreator):boolean;
	var
		vlOperCre : TInstCreator;
		vlPoc     : TFileDIsplay;
		vlAsm     : TAsmDisplay;
		vlName    :ansistring;
		vlRoutine : TRoutineAsm;
	begin
		if  not( RTM_Abstract in iRoutineModes) then ProducePoc(ParCre);
		if iMeta <> nil then iMeta.CreateDB(ParCre);
		iParts.CreateDB(ParCre);
		if fStatements <> nil then begin
			vlPoc := TAsmCreator(ParCre).fPoc;
			vlasm := TAsmCreator(ParCre).fAsm;
			if (fRoutinePoc <> nil) and (ParCre.SuccessFul) then begin
				if vlPoc <> nil then fRoutinePoc.Print(vlPoc);
				GetMangledName(vlName);
				vlRoutine := CreateRoutineAsm;
				vlOperCre := TInstCreator.Create(vlName,ParCre.fCompiler,vlRoutine);
				fRoutinePoc.CreateInst(vlOpercre);
				vlOperCre.Print(vlAsm);
				vlOperCre.Destroy;
			end;
			if fRoutinePoc <> nil then fRoutinePoc.Destroy;
			fRoutinePoc := nil;
		end;
		exit(false);
	end;

	procedure TRoutine.CommonSetup;
	begin
		inherited CommonSetup;
		iPhysicalAddress    := self;

		iIdentCode          := IC_RoutineItem;
		InitStorageList;
		iRoutineModes       := [];
		iRoutineStates      := [];
		iMeta               := nil;
		iVmtItem	      	:= nil;
		iParent	      	:= nil;
		iCollectionNo	:= 0;
		iRelativeLevel      := 0;
		iParameterFrame     := TFrame.Create(true);
		iLocalFrame	      	:= TFrame.Create(false);
		iLocalFrame.fShare  := iParameterFrame;
		iParametermapping   := TParameterMappingList.Create(self);
		iAllWaysSave    := true;
		GetParList.fLocalFrame     := iLOcalFrame;
		GetParList.fParameterFrame := iParameterFrame;
	end;



	procedure TRoutine.AddParam(ParCre : TNDCreator;ParName:TNameList;ParType:TType;ParVar,ParConst,ParVirtual:boolean);
	var vlCurrent : TNameItem;
		vlParam   : TParameterVar;
		vlName    : ansistring;
		vlError   : TErrorType;
	begin
		if ParType =nil then exit;
		vlCurrent := TNameItem(ParName.fStart);
		if ParVirtual then  SetRoutineStates([RTS_HasVirtualParams],true);
		while vlCurrent <> nil do begin
			vlName := vlCurrent.fString;
			vlError := GetParList.AddParam(ParCre,vlName,iParameterFrame,ParType,ParVar,Parconst,ParVirtual,vlParam);
			if vlError <> Err_No_Error then ParCre.ErrorText(vlError,vlName);
			vlCurrent := TNameItem(vlCurrent.fNxt);
		end;
	end;



	procedure TRoutine.PrintDefinitionBody(ParDis:TDisplay);
	begin
		ParDis.nl;
		ParDis.WriteNl('<localframe>');
		fLocalFrame.Print(ParDis);
		ParDIs.Write('</localframe><paramframe>');
		fParameterFrame.Print(PArDis);
		ParDis.Write('</paramframe>OP');
		iParameterMapping.Print(ParDis);
		ParDis.Write('<mode>');
		if RTM_extended in fRoutineModes then ParDis.WriteNl('extended');
		if fParent <> nil then begin
			ParDis.Write('inherited ');
			if RTM_Inherit_Final in fROutineModes then ParDis.WriteNl('final ');
			fParent.PrintName(ParDis);
			ParDis.nl;
		end;
		ParDis.Write('</mode><contains>');
		PrintParts(ParDis);
		ParDis.Write('</contains><code>');
		if fStatements <> nil then fStatements.Print(ParDis);
		ParDis.Write('</code>');
	end;

	procedure TRoutine.PrintDefinitionEnd(ParDis : TDisplay);
	begin
		ParDis.Write('End');
	end;

	procedure TRoutine.Clear;
	begin
		inherited CLear;
		if fStatements <> nil     then fStatements.Destroy;
		if fStorageList  <> nil     then fStorageList.Destroy;
		if fRoutinePoc <> nil     then fRoutinePoc.Destroy;
		if iMeta         <> nil     then iMeta.Destroy;
		if iParameterMapping <> nil then iParameterMapping.Destroy;
		if  not(RTS_SharedLocalFrame in iRoutineStates)  then begin
			iLocalFrame.Destroy;
			iParameterFrame.Destroy;
		end;
	end;

	function TRoutine.Can(ParCan:TCan_Types):boolean;
	begin
		if IsExecutableRoutine then ParCan := ParCan - [Can_Execute];
		exit( inherited Can(ParCan-[Can_Pointer]));
	end;


	function   TRoutine.IsSameParamType(ParParam:TProcParList;ParType : TParamCompareOptions):boolean;
	begin
		exit( GetParList.IsSameParamType(ParParam,ParType));
	end;



	function TRoutine.GetParamByNum(ParNum : cardinal):TParameterVar;
	begin
		exit( GetParList.GetParamByNum(ParNum));
	end;

	function   TRoutine.IsSameTypeByNode(ParNode:TCallNode):boolean;
	begin
		IsSametypeByNode := false;
		if ParNode <> nil then IsSameTypeByNode := ParNode.IsSameParamByDef(GetParList,RTM_Exact_Overload in fRoutineModes);
	end;

	procedure TRoutine.ValidateOverrideVirtTest(ParCre : TNDCreator; ParOther : TRoutine);
	begin
		if not IsVirtual then ParCre.ErrorDef(Err_virt_Allready_Static,ParOther);
	end;

	procedure   TRoutine.ValidateCanOverrideByComp(ParCre :TNDCreator;const ParOther : TRoutine);
	var vlOpt : TParamCompareOptions;
	begin
		if ParOther = nil then exit;
		ValidateOverrideVirtTest(ParCre,ParOther);
		if ParOther.ClassType <> ClassType then ParCre.ErrorText(Err_Ovr_Dif_Routine_Type,className+'=>'+ParOther.ClassName);
		vlOpt :=  [PC_IgnoreName,PC_CheckAll,PC_Relaxed];
		if (RTM_Overload in fRoutineModes) or (RTM_Exact_Overload in fRoutineModes) then begin
			if not(RTM_Overload in ParOther.fRoutineModes) then begin
				ParCre.ErrorDef(Err_Ovr_Need_Overl,self);
			end;
		end;

		if (RTM_Name_Overload in fRoutineModes) and not(RTM_Name_Overload in ParOther.fRoutineModes) then begin
			ParCre.ErrorDef(Err_Ovr_Need_Name_Overl,self);
		end else begin
			vlOpt := vlOpt + [PC_IgnoreName];
		end;

		if not(RTM_Extended in fRoutineModes) and (RTM_Extended in ParOther.fRoutineModes) then begin
			ParCre.ErrorDef(Err_Cant_Override_ext_by_non,self);
		end else if (RTM_Extended in fRoutineModes) and not(Rtm_Extended in ParOther.fRoutineModes) then begin
			ParCre.ErrorDef(Err_Cant_Override_non_by_ext,self);
		end else if not IsSameParamType(TProcParList(ParOther.iParts),vlOpt) then begin
			ParCre.ErrorDef(Err_Ovr_Param_Different,self);
		end;
		if fDefAccess <> ParOther.fDefAccess then ParCre.ErrorDef(Err_Wrong_Access_Level,ParOther);

	end;


	function   TRoutine.IsSameForFind(ParProc :TRoutine):boolean;
	var vlType : TParamCompareOptions;
	begin
		vlType := [PC_Relaxed];
		if RTM_Exact_Overload in fRoutineModes then vlType := [];
		exit(IsSameRoutine(ParProc,vlType));
	end;


	function   TRoutine.IsSameRoutine(ParProc:TRoutine;ParType :TParamCompareOptions):boolean;
	var vlIsSame : boolean;
		vlProc   : TRoutine;
		vlType   : TParamCompareOptions;
	begin
		IsSameRoutine := true;
		vlProc     := ParProc;
		vlIsSame   := IsSameIdentCode(vlProc);
		vlType     := ParType;
		if IsVirtual then vlType := vlType + [PC_IgnoreName];  {TODO: Must be moved to IsSameForFind?}
		if (ParProc <>nil) and vlIsSame then begin
			if IsSameParamType(TProcParList(ParProc.iParts),vlType) then exit;
		end;
		exit(false);
	end;


	function TRoutine.CreateVar(ParCre:TCreator;const ParName:ansistring;ParType:TDefinition):TDefinition;
	begin
		exit(GetParList.CreateVar(ParCre,ParName,ParType));
	end;


	procedure  TRoutine.SetIsDefined;
	begin
		SetRoutineStates([RTS_IsDefined,RTS_Has_Sr_Lock],true);
	end;

	constructor TRoutine.Create(const ParName : ansistring);
	begin
		inherited Create;
		SetText(ParName);
	end;

	procedure TRoutine.DoneRoutine(ParCre : TSecCreator);
	begin
		iLocalFrame.PopAddressing(self);
		DoneParameters(ParCre);
	end;

	{----( TRoutineNode )--------------------------------------------}


	procedure TROutineNode.ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
	begin
		iParts.ValidateDefinitionUse(ParCre,ParMode,ParUseList);
	end;

	function  TROutineNode.IsSubNodesSec:boolean;
	begin
		exit(true);
	end;


	procedure   TRoutineNode.SetProcedureObj(ParProc:TRoutine);
	begin
		voProcedure := ParProc;
	end;

	constructor TRoutineNode.Create(ParProc:TRoutine);
	begin
		inherited Create;
		SetProcedureObj(ParProc);
	end;

	function  TRoutineNode.CreateSec(ParCre:TSecCreator):boolean;
	var
		vlRoutinePoc : TRoutinePoc;
		vlName         : ansistring;
		vlOwnerPoc    : TRoutinePoc;
		vlResult       : boolean;
	begin
		iRoutine.InitParameters;
		vlOwnerPoc := nil;
		if fRoutine.GetRoutineOwner <> nil then begin
			vlOwnerPoc := TRoutine(fRoutine.GetRoutineOwner).fRoutinepoc;
		end;
		fRoutine.GetMangledName(vlName);
		vlRoutinePoc   := TRoutinePoc.Create(vlName,
		RTM_CDecl in fRoutine.fRoutineModes,
		vlOwnerPoc,
		RTS_SharedLocalFrame in fRoutine.fRoutineStates,
		fRoutine.fLocalFrame,
		fRoutine.GetParamSize);
		fRoutine.fLocalFrame.AddAddressing(fRoutine,fRoutine,vlRoutinePoc.fLocalFramePtr,false);
		ParCre.fObjectList := vlRoutinePoc.fObjectList;
		if (fRoutine.GetLocalSize <> 0) or (fRoutine.GetParamSize<>0) then begin
			if RTS_HasNeverStackFrame in fRoutine.fRoutineStates then begin
				vlName := fRoutine.fText;
				Fatal(fat_No_Stack_Frame_Invalid,'Routine='+vlName);
			end;
		end else begin
			if RTS_hasNeverStackFrame in fRoutine.fRoutineStates then begin
				vlRoutinePoc.fHasNeverStackFrame := true;
				vlRoutinePoc.fNeedStackFrame     := false;
			end;
			if  not(GetAlwaysStackFrame) then vlRoutinePoc.fNeedStackFrame := false;
		end;
		ParCre.fCurrentProc := vlRoutinePoc;
		ParCre.SetPoc(vlRoutinePoc);
		iRoutine.fRoutinePoc := vlRoutinePoc;
		fRoutine.CreateInitProc(ParCre);
		vlResult := iParts.CreateSec(ParCre);
		ParCre.fObjectList := nil;
		exit(vlResult);
	end;


	procedure   TRoutineNode.DoneRoutine(ParCre : TSecCreator);
	begin
		iRoutine.DoneParameters(ParCre);
	end;

	procedure TRoutineNode.PrintNode(ParDis:TDisplay);
	var
		vlName :AnsiString;
	begin
		ParDis.nl;

		if fRoutine <> nil then  begin
			vlName := fRoutine.fText;
		end else begin
			EmptyString(vlName);
		end;
		ParDis.print(['Procedure ',vlName]);
		ParDis.Nl;
		ParDis.SetLeftMargin(6);
		iParts.Print(ParDis);
		ParDis.SetLeftMargin(-6);
		ParDis.nl;
	end;

	{-----( TCallNode )-------------------------------------------}

	function TCallNode.CanUseInherited : boolean;
	begin
		if iRoutineItem <> nil then begin
			exit(iRoutineItem.CanUseInherited);
		end ;
		exit(false);
	end;

	procedure TCallNode.ValidateFormulaDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
	begin
			inherited ValidateFormulaDefinitionUse(ParCre,AM_Execute,ParUseList);
			fParts.ValidateDefinitionUse(ParCre,AM_Nothing,ParUseList);
			if iCallAddress <> nil then iCallAddress.ValidateDefinitionUse(ParCre,AM_Read,ParUseList);
	end;



    procedure TCallNOde.proces(ParCre : TCreator);
	var
	vlDef        : TRoutine;
	vlOwner      : TRoutine;
	vlCur        : TRoutineCollection;


	begin
		inherited Proces(ParCre);
		if not iIsProcessed then begin
			vlOwner := nil;

			if fRoutineItem= nil then begin

				if fRecord <> nil then begin
					if fRecord.GetType <> nil then begin
						fRecord.GetType.GetPtrByObject(fName,self,[SO_Local],vlOwner,vlDef);
					end else begin
						vlDef := nil;
					end;
				end else begin
					TNDCreator(ParCre).GetPtrByObject(fName,self,vlOwner,vlDef);
				end;
				if (vlDef <> nil) then begin
					if not (vlDef is TRoutine) then begin
						TNDCreator(ParCre).AddNodeError(self,err_not_a_Routine,fName);
						vlDef := nil;
						exit;
					end;
				end else  begin
					vlCur := TRoutineCollection(TNDCreator(ParCre).GetPtr(fName));
					if vlCur = nil then begin
						TNDCreator(ParCre).AddNodeError(self,err_unkown_ident,fName);
						vlDef := nil;
						exit;
					end;
					if (iParts.fStart <> nil) then begin
						TNDCreator(ParCre).AddNodeError(self,Err_Invalid_Parameters,fName);
					end else begin
						vlDef := TRoutine(vlCur.fParts.fStart);
						if vLDef.fDefAccess = AF_Private then TNDCreator(ParCre).AddNodeError(self,Err_Unkown_ident,fName);
					end;
				end;
				if (not IsCallByName) and (vlDef <> nil) and (RTM_Name_Overload in vlDef.fRoutineModes) and (vlDef.fDefault<>DT_Routine) then begin
					TNDCreator(ParCre).AddNodeError(self,Err_Need_Named_parameters,fName);
				end;
				SetRoutineItem(TNDCreator(ParCre),vlDef,vlOwner);
			end;
			if fRoutineItem <> nil then begin
				iTLVarNode := iRoutineItem.CreateAutomaticParameterNodes(fContext,TNDCreator(ParCre),TCallNodeList(iParts));
				TCallNodeList(iParts).FinalizeParameters(TNDcreator(ParCre),fROutineItem.GetParList);
		      	end;
			iIsProcessed := true;

		end;
	end;

procedure TCallNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlNOde            : TParamNode;
	vlCurrent         : TParamNode;
	vlNumberOfDefPar  : cardinal;
	vlNumberOfUsedPar : cardinal;
	vlError           : TErrorType;
	vlName            : ansistring;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	vlNode := TParamNode(fParts.fStart);
	{should be in list?}
	if not can([Can_Execute]) then TNDCreator(ParCre).AddNodeError(self,Err_Cant_Execute,fName);
	while vlNode <> nil do begin
		vlName := vlNode.fName;
		if length(vlName) > 0 then begin
			vlCurrent :=  TParamNode(vlNode.fPrv);
			while (vlCurrent <> nil) do begin
				if vlCurrent.IsSameName(vlName) then  begin
					TNDCreator(ParCre).AddNodeError(vlNode,Err_Duplicate_Ident,vlName);
					break;
				end;
				vlCurrent := TParamNode(vlCurrent.fPrv);
			end;
		end;

		vlNode := TParamNode(vlNode.fNxt);
	end;
	if iRoutineItem <> nil then begin
		if iCallAddress <> nil then begin
			if (iCallAddress is TFormulaNode) and ( TFormulaNode(iCallAddress).GetType <> nil) then begin
				if TFormulaNode(iCallAddress).GetType  is TRoutineType then begin
					if (iRoutineItem.GetRealOwner is TRoutine) and not(RTM_Isolate in fRoutineItem.fRoutineModes) then begin
						TNDCreator(ParCre).AddNodeError(self,Err_Cant_Execute,fName);
					end;
				end;
			end;
		end;

		iRoutineItem.BeforeCall(TNDCreator(ParCre));
		if (iParts.fStart <> nil) and (not iRoutineItem.IsSameTypeByNode(self)) then	begin
			TNDCreator(ParCre).AddNodeError(self,Err_invalid_parameters,fName);
		end;
		if iRoutineItem is TConstructor then begin
			if iRecord <> nil then begin
				if not iRecord.Can([Can_Type]) then TNDCreator(ParCre).AddNodeError(self,Err_Not_A_Class_Method,fName);
			end;
		end;
		if not(iIsPtrOf) then begin
			vlNumberOfDefPar  := iRoutineItem.GetNumberOfParameters;
			vlNumberOfUsedPar := iParts.GetNumItems;
			if vlNumberofDefPar <>  vlNumberOfUSedPar then begin
				vlName := iRoutineItem.fText;
				vlError := Err_Too_Many_Parameters;
				if vlNumberOfDefPar > vlNumberOfUsedPar then vlError := Err_Param_Expected;
				TNDCreator(ParCre).AddNodeError(self,vlError,'to '+vlName+' requires '+IntToStr(vlNumberOfDefPar) +' parameters instead of '+IntTOStr(vlNUmberOfUsedPar));
			end;
		end;

	end;
end;


	function TCallNode.CreateObjectPointerOfNode(ParCre : TCreator) : TFormulaNode;
	var
		vlType : TType;
		vlIsMethod : boolean;
	begin
		if fParCnt <> 0 then TNDCreator(ParCre).AddNodeError(self,Err_No_Parameters_Expected,'');
		if IsOverloaded  then TNDCreator(ParCre).AddNodeError(self,Err_Cant_Adr_Overl,'');
		if iRoutineItem = nil then exit(nil);
		vlIsMethod := iRoutineItem.IsMethod;
		vlType := TRoutineType.create(false,iRoutineItem,vlIsMethod);

		vlType.SetText('Ptr to '+fName);
		iIsPtrOf :=true;
		exit(TObjectPointerNode.Create(self,vlType));
	end;


	procedure TCallNode.Optimize(ParCre : TCreator);
	begin
		inherited Optimize(ParCre);
		if iCallAddress <> nil then iCallAddress.Optimize(ParCre);{should be optimizethisnode}
	end;

	procedure  TCallNode.ValidateAfter(ParCre : TCreator);
	begin
		inherited ValidateAfter(ParCre);
		if iCallAddress <>nil then 	iCallAddress.ValidateAfter(ParCre);
	end;


	function    TCallNode.IsOverloaded : boolean;
	begin
		if iRoutineItem <> nil then begin
			exit( iRoutineItem.IsOverloaded);
		end;
		exit(false);
	end;


	procedure  TCallNode.SetType(parType : TTYpe);
	begin
		iType := ParTYpe ;
	end;

	procedure TCallNode.SetRoutineName(const ParName : ansistring);
	begin
		iName := ParName;
	end;

	constructor TCallNode.Create(const ParName : ansistring);
	begin
		inherited Create;
		iName := ParName;
	end;

	function  TCallNode.IsCallByName : boolean;
	begin
		exit(TCallNodeList(iParts).IsCallByName);
	end;

	function  TCallNode.GetParamByName(const ParName : ansistring):TParamNode;
	begin
		exit(TCallNodeLIst(iParts).GetParamByName(ParName));
	end;

	function  TCallNOde.IsSameParamByDef(ParList :TProcParList;ParExact : boolean):boolean;
	begin
		exit(TCallNodeLIst(iParts).IsSameParamByDef(ParList,ParExact));
	end;

	procedure TCallNode.Clear;
	begin
		inherited Clear;
		if iCallAddress <> nil then iCallAddress.Destroy;
	end;

	procedure TCallNode.SetCallAddress(ParCre : TNDCreator;ParNode:TNodeIdent);
	begin
		if iCallAddress <> nil then iCallAddress.Destroy;
		iCallAddress := ParNode;
	end;

	procedure   TCallNode.SoftEmptyParameters;
	begin
		TCallNodeLIst(iParts).SoftEmptyParameters;
	end;

	procedure TCallNode.SetParameters(ParContext :TDefinition;ParCre:TNDCreator;ParCB : TRoutine);
	begin
		if ParCB <> nil then begin
			iTLVarNode := ParCB.CreateAutomaticParameterNodes(ParContext,ParCre,TCallNodeList(iParts));
			TCallNodeList(iParts).FinalizeParameters(ParCre,iRoutineItem.GetParList);
		end;
	end;



	procedure TCallNode.SetRoutineItem(ParCre:TNDCreator;ParProc:TRoutine;ParContext : TDefinition);
	begin
		if ParProc = nil then exit;
		SetCallAddress(ParCre,ParProc.CreateMentionAddress(ParCre,ParContext));
		ParProc.SetRoutineStates([RTS_Require_Main],true);
		if ParProc is TReturnRoutine then iType := TReturnRoutine(ParProc).fType;
		{TODO Why not directly use RoutineItem.Can?}
		{TODO Move SetType to identifier}
		iRoutineItem := ParProc;
		iContext     := ParContext;
	end;

	procedure TCallNode.InitParts;
	begin
		iParts := TCallNodeList.Create;
	end;


	function TCallNode.Can(ParCan:TCan_Types):boolean;
	begin
		if iRoutineItem <> nil then begin
			if (ParCan  *[Can_Execute,Can_Read,Can_Write,Can_Pointer] <> []) and (iRoutineItem.NeedReadableRecord) then begin
					if RecordReadCheck then exit(false);
			end;
			exit(iRoutineItem.Can(ParCan));
		end;
		exit(false);
	end;


	function TCallNode.GetType:TType;
	begin
		if iRecord <> nil then begin
			if iRoutineItem <> nil then begin
				if iRoutineItem is TCOnstructor then begin
					exit(iRecord.GetType);
				end;
			end;
		end;
		exit(iType);
	end;

	procedure TCallNode.DoInitDotFrame(ParCre : TSecCreator);        {TODO can be changed is Node.initcalladdres?}
	var
		vlType : TType;
		vlMac  : TMacBase;
	begin
		if iCallAddress is TFormulaNode then begin
			vlType:= TFormulaNode(iCallAddress).GetType;
			if  (vlType is TRoutineType) and (TRoutineType(vlType).fOfObject) then begin
				if iDotFrame = nil then begin
					vlMac := iCallAddress.CreateMac(MCO_Result,ParCre);
					vlMac.SetSize(GetAssemblerInfo.GetSystemSize);
					iDotFrame := vlMac;
				end;
				iFrame.AddAddressing(iRoutineItem,vlType,iDotFrame,false);
			end;
		end;
	end;

	procedure TCallNode.DoDoneDotFrame;
	begin
		if iDotFrame <> nil then begin
			iFrame.Popaddressing(iRoutineItem);
		end;
	end;


	{todo:finish}
	function TCallNode.DoCreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
	var
		vlMac    : TMacBase;
		vlCall   : TCallPoc;
		vlType   : TType;
		vlOfsMac : TMemOfsMac;
		vlName   : ansistring;
		vlMco    : TMacCreateOption;
		vlPar    : TParameterVar;
		vlObject : TMacBase;
		vlOwner  : TDefinition;
	begin
		DoInitDotFrame(ParCre);
		CASE ParOpt of
		MCO_Result:begin
			vlCall := CreateCallSec(parCre);
			vlType := GetType.GetOrgType;
			if iTLVarNode<>nil then begin
				vlMac := iTLVarNode.CreateMac(MCO_Result,ParCre)
			end  else begin
				vlMac  := TOutputMac.Create(vlType.fSize,vlType.GetSign);
				ParCre.AddObject(vlMac);
				vlCall.SetReturnVar(vlMac);
			end;
		end;
		MCO_ValuePointer:begin
			if iTLVarNode= nil then begin
				iRoutineItem.GetMangledName(vlName);
				Fatal(FAT_Can_Get_Value_Pointer,['Routine=',vlName]);
			end;
			vlCall    := CreateCallSec(parCre);
			vlType    := GetType.GetOrgType;
			vlMac     := iTLVarNode.CreateMac(MCO_Result,ParCre);
			vlOfsMac  := TMemOfsMac.Create(vlMac);
			ParCre.AddObject(vlOfsMac);
			vlMac := vlOfsMac;
		end;
		MCO_ObjectPointer:begin
			vlMco := MCO_ValuePointer;
			if not(iCallAddress is TLabelNode) then vlMco := MCO_Result; {Todo:Hack: because different meaning of macoption}
			vlMac := iCallAddress.CreateMac(vlMco,ParCre);
			if iRoutineItem.IsMethod then begin
				if iRoutineItem.GetPtrByName(name_self,[SO_Local],vlOwner,TDefinition(vlPar)) then begin
					if iRecord = nil then begin
		            			vlObject := TFrameParameter(vlPar).CreateAutomaticMac(TClassType(iRoutineItem.GetRealOwner).fObject,ParCre);
					end else begin
						vlObject := iRecord.CreateMac(MCO_Result,ParCre);
					end;
					vlMac := TMethodPtrMac.Create(vlObject,vlMac,GetAssemblerInfo.GetSystemSize);
					ParCre.AddObject(vlMac);
				end else begin
					writeln('self not found in',iRoutineItem.GetErrorName);{TODO fatal error}
					runerror(1);
				end;
			end;
		end else begin
			vlMac := nil;
		end;
	end;
	DoDoneDotFrame;
	exit(vlMac);
end;


function TCallNode.DoCreateSec(ParCre:TSecCreator):boolean;
var
	vlMac  : TMacBase;
	vlMac2 : TMacBase;
	vlSec  : TCompFor;
	vlOut  : TMacBase;
	vlJmp  : TCondJumpPoc;
	vlJmp2 : TJumpPoc;
	vlUsed : boolean;
	vlLi   : TLargeNumber;
begin
	DoInitDotFrame(ParCre);
	vlUSed := false;
	if Can([CAN_Read]) then begin
		if (GetType<> nil ) and (GetType.fDefault = DT_Boolean) then begin
			if (ParCre.fLabelTrue <> nil) and (ParCre.fLabelFalse <> nil) then begin
				vlMac := CreateMac(MCO_Result,ParCre);
				LoadInt(vlLi,bv_True);
				vlMac2 := ParCre.CreateNumberMac(1,false,vlLi);
				vlSec  := TCompFor.Create(IC_NotEq);
				vlSec.Setvar(1,vlMac);
				vlSec.SetVar(2,vlMAc2);
				vlOut := vlSec.CalcOutputMac(ParCre);
				ParCre.addSec(vLSec);
				vlJmp := TCondJumpPoc.Create(true,vlOut,ParCre.fLabelFalse);
				vlJmp2 := TJumpPoc.Create(ParCre.fLabelTrue);
				ParCre.AddSec(vlJmp);
				ParCre.AddSec(vlJmp2);
				vlUsed :=true;
			end;
		end;
	end;
	if not vlUsed then CreateCallSec(ParCre);
	DoDoneDotFrame;
	exit(false);
end;

function TCallNode.CreateCallSec(ParCre:TSecCreator):TCallPoc;
var	vlCall            : TCallPoc;
	vlCallGroup1      : TCallMetaPoc;
	vlCallGroup2      : TCallMetaPoc;
	vlMac 		  : TMacBase;
	vlType		  : TType;

begin

	vlcallGroup1 := TCallMetaPoc.Create;
	vlCallGroup2 := TCallMetaPoc.Create;
	vlCallGroup1.fGroupEnd := vlCallGroup2;
	vlcallGroup2.fGroupBegin := vlCallGroup1;
	ParCre.AddSec(vlCallGroup1);
	iParts.CreateSec(Parcre);
	vlMac := iCallAddress.CreateMac(MCO_Result,ParCre);
	if iCallAddress is TFormulaNode then begin
		vlType := TFormulaNode(iCallAddress).GetType;
		if (vlType is TRoutineType) and (TRoutineType(vlType).fOfObject) then begin
			vlMac.SetSize(GetAssemblerInfo.GetSystemSize);
			vlMac.AddExtraOffset(GetAssemblerInfo.GetSystemSize);
		end;
	end;
	vlCall := TCallPoc.Create(vlMac,RTM_CDecl in iRoutineItem.fRoutineModes,iRoutineItem.GetParamSize);
	ParCre.AddSec(vlCall);
	ParCre.AddSec(vlCallGroup2);
	exit(vlCall);
end;




function  TCallNode.AddNodeAndName(ParNode:TFormulaNode;const ParName : ansistring):boolean;
var
	vlPnd:TParamNode;
begin
	iParCnt := iParCnt + 1;
	AddNodeAndName := false;
	vlPnd    := TParamNode.Create(nil);
	vlPnd.SetPosToNode(ParNode);
	vlPnd.fName := ParName;
	if Inherited AddNode(vlPnd) then AddNodeAndName := true;
	vlPnd.SetExpression(ParNode);
end;



function  TCallNode.AddNode(ParNode:TNodeIdent):boolean;
begin
	exit(AddNodeAndName(TFormulaNode(ParNode),''));
end;



procedure TCallNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode     := (IC_ProcedureNode);
	iParCnt        := 0;
	iTLVarNode     := nil;
	iCallAddress   := nil;
	iRoutineItem   := nil;
	iType		   := nil;
	iIsPtrOf	   := false;
	iComplexity    := CPX_Call;
	iDotFrame      := nil;
	iFrame         := nil;
	iIsProcessed     := false;
end;

procedure TCallNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.WriteNl('<call><adres>');

	if iCallAddress <> nil then begin
		iCallAddress.Print(parDis);
	end;
	ParDis.writeNl('</adres><parameters>');
	iParts.Print(ParDis);
	ParDis.WriteNl('</parameters></call>');
end;

end.
