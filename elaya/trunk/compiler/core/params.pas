{ Elaya, the compiler for the elaya language
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

unit params;

interface

uses ndcreat,varuse,strmbase,streams,cmp_type,ddefinit,didentls,compbase,formbase,node,error,elatypes,display,macobj,pocobj,elacons,
	vars,stdobj,varbase,linklist,types,asminfo,frames,progutil;
	
type
	TParamNode       =class;
	TParameterMappingList=class;
	TProcParlist = class;
	TProcVar=class(TFrameVariable)
	public
		function  GetAccessSize:TSize;virtual;
		function  CreateDB(ParCre:TCreator):boolean; override;
		procedure CreateCBInit(ParCre : TNDCreator;ParAt : TNodeIdent;ParContext : TDefinition);virtual;
	end;
	TLocalVar=class(TProcVar)
	protected
		procedure COmmonSetup;override;
	end;
	
	TParameterVarClass=class of TParameterVar;
	TParameterVar=class(TProcVar)
	private
		voTranType        : TParamTransferType;
		voSourcePosition  : cardinal;
		voRealPosition    : cardinal;
		voIsVirtual       : boolean;
		voIsInherited     : boolean;
		voMainVar         : TLocalVar;
		voSecondVar       : TLocalVar;
		voRefMainVar      : boolean;
		voRefVar2         : boolean;
		voAccessType      : TType;
		voNeedVar2        : boolean;
		property iTranType       : TParamTransferType read voTranType        write voTranType;
		property iSourcePosition : cardinal  read voSourcePosition  write voSourcePosition;
		property iRealPosition   : cardinal  read voRealPosition    write voRealPosition;
		property iIsVirtual      : boolean   read voIsVirtual       write voIsVirtual;
		property iIsInherited    : boolean   read voIsInherited     write voIsInherited;
		property iSecondVar      : TLocalVar  read voSecondVar       write voSecondVar;
		property iRefMainVar     : boolean   read voRefMainVar      write voRefMainVar;
		property iRefVar2        : boolean   read voRefVar2         write voRefVar2;
		property iAccessType     : TTYpe     read voAccessTYpe      write voAccessType;
		property iMainVar        : TLocalVar read voMainVar 			write voMainVar;
		property iNeedVar2       : boolean   read voNeedVar2        write voNeedVar2;
		procedure SetupAccessVars;

	protected
		procedure   CommonSetup;override;
		procedure   Clear;override;
	public
		property    fTranType       : TParamTransferType    read voTranType;
		property    fSourcePosition : cardinal read voSourcePosition;
		property    fIsVirtual      : boolean  read voIsVirtual;
		property    fSecondVar      : TLocalVar read voSecondVar      write voSecondVar;
		property    fIsInherited    : boolean  read voIsInherited    write voIsInherited;
		property    fRealPosition   : cardinal read voRealPosition   write voRealPosition;
		property    fAccessType     : TType    read voAccessType;
		property    fNeedVar2       : boolean  read voNeedVar2;
		property    fRefMainVar     : boolean  read voRefMainVar;
		function    CheckParameterName(ParParam :TParameterVar;var PArDifText:string):boolean;
		function    IsAutomatic:boolean;virtual;
		procedure   SetPosition(ParNo : cardinal);
		
		constructor create(const ParName : String;ParFrame:TFrame;Partype:TType;ParTranType:TParamTransferType;ParVirtual : boolean);
		function    CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;override;
		procedure   Print(ParDis:TDisplay);override;
		function    SaveItem(parStream:TObjectStream):boolean;override;
		function    LoadItem(ParStream:TObjectStream):boolean;override;
		function    GetPushSize:TSize;
		function    CreateAutomaticParamNode(ParContext,ParOrgOwner : TDefinition;ParCre:TCreator;  var ParTTL:TTLVarNode):TParamNode; virtual;
		function    CreateAutomaticMac(ParContext : TDefinition;parCre:TSecCreator):TMacBase;virtual;
		procedure   DoneParameter(ParOwner : TDefinition;ParCre : TSecCreator);virtual;
		function    IsSameParameter(ParParam : TParameterVar;ParType : TParamCompareOptions):boolean;virtual;
		function    Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner:TDefinition) : TParameterVar;virtual;
		function    GetAccessSize:TSize;override;
		function    IsSame(ParVar : TVarBase):boolean;override;
		function   IsOptUnsave:boolean;override;
		function   IsCompWithParamExprType(ParExact : boolean;ParType : TType):boolean;
		function   IsCompWithParamExpr(ParExact : boolean;ParNode : TFormulaNode):boolean;
		function   CreateDefinitionUseItem: TDefinitionUseItemBase;override;
		procedure  ProduceFrame(ParCre : TSecCreator;ParContext : TDefinition);
		procedure  InitParameter(ParOwner : TDefinition);virtual;
   	procedure  SetOffset(ParOffset :TOffset);
		function   GetVar2Type : TTYpe;
		procedure  ProduceMappingCbInit(ParAt : TNodeIdent;ParCre : TCreator;ParContext:TDefinition;ParSource : TFormulaNode);

	end;
	
	TAutomaticParameter=class(TParameterVar)
	private
		voSourceContextLevel     : cardinal;
	protected
		property iSourceContextLevel : cardinal read voSourceContextLevel write voSourceContextLevel;
		
	public
		constructor create(const ParName : String;ParSourceContextLevel : cardinal;ParFrame:TFrame;Partype:TType;ParTranType:TParamTransferType;ParVirtual : boolean);
		function    IsAutomatic:boolean; override;
		function    Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner : TDefinition) : TParameterVar;override;
		function    SaveItem(parStream:TObjectStream):boolean;override;
		function    LoadItem(ParStream:TObjectStream):boolean;override;
		function    GetContextObj(ParRoutine,ParOrgOwner : TDefinition):TDefinition;
	end;
	
	
	
	TRTLParameter=class(TAutomaticParameter)
	protected
		procedure Commonsetup;override;

	public
		function  CreateAutomaticParamNode(ParContext,ParOrgOwner: TDefinition;ParCre:TCreator; var ParTTL:TTLVarNode):TParamNode;override;
		function  Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner : TDefinition) : TParameterVar;override;
	end;

	TFrameParameter=class(TAutomaticParameter)
	
	private
		voPushedFrame : TFrame;
	protected
		property    iPushedFrame : TFrame read voPushedFrame write voPushedFrame;
		procedure   Commonsetup;override;

	public
		function    SaveItem(parStream:TObjectStream):boolean;override;
		function    LoadItem(ParStream:TObjectStream):boolean;override;
		function    IsSameParameter(ParParam : TParameterVar;ParType : TParamCompareOptions):boolean;override;
		constructor create(const ParName:String;ParSourceContextLevel : cardinal;ParFrame,ParOther:TFrame;Partype:TType;ParTranType : TParamTransferType;ParVirtual : boolean);
		function    CreateAutomaticMac(ParContext : TDefinition;parCre:TSecCreator):TMacBase; override;
		function    CreateAutomaticParamNode(ParContext,ParOrgOwner : TDefinition;ParCre : TCreator ; var ParTTL:TTLVarNode):TParamNode; override;
		procedure   InitParameter(ParOwner : TDefinition);override;
		procedure   DoneParameter(ParOwner : TDefinition;ParCre : TSecCreator);override;
		function    Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOwner : TDefinition) : TParameterVar;override;
		procedure   Print(ParDis : TDisplay);override;
		
	end;
	
	TClassFrameParameter=class(TFrameParameter)
	private
		voMeta 	    : TDefinition;
		voMetaFrame  : TVarBase;
		voConstant   : boolean;   {TODO Am Hack,save to unit file}
		property iMeta : TDefinition read voMeta write voMeta;
		property iMetaFrame : TVarBase read voMetaFrame write voMetaFrame;
		property iConstant : boolean read voConstant write voConstant;
	public
		property fConstant : boolean read voConstant write voConstant;

		property fMetaFrame : TVarBase read voMetaFrame;
		constructor Create(const ParName : String;ParMeta : TDefinition;ParMetaFrame : TVarBase;ParFrame,ParOther : TFrame;ParType : TType;ParTranType : TParamTransferType;ParVirtual : boolean);
		procedure   InitParameter(ParOwner : TDefinition);override;
		procedure   DoneParameter(ParOwner : TDefinition;ParCre : TSecCreator);override;
		function    SaveItem(parStream:TObjectStream):boolean;override;
		function    LoadItem(ParStream:TObjectStream):boolean;override;
		function    Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner : TDefinition) : TParameterVar;override;
		function  	CreateAutomaticParamNode(ParContext,ParOrgOwner : TDefinition;ParCre : TCreator; var ParTTL:TTLVarNode):TParamNode;override;
	end;
	
	TFixedFrameParameter=class(TFrameParameter)
	private
		voContext : TDefinition;
		property iContext : TDefinition read voContext Write voCOntext;
	public
		constructor create(const ParName:String;ParContext : TDefinition;ParFrame,ParOther:TFrame;Partype:TType;ParVirtual : boolean);
		procedure   InitParameter(ParOwner : TDefinition);override;
		procedure   DoneParameter(ParOwner : TDefinition;ParCre : TSecCreator);override;
		function    SaveItem(parStream:TObjectStream):boolean;override;
		function    LoadItem(ParStream:TObjectStream):boolean;override;
		function    Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner : TDefinition) : TParameterVar;override;
		function  	CreateAutomaticParamNode(ParContext,ParOrgOwner : TDefinition;ParCre : TCreator; var ParTTL:TTLVarNode):TParamNode;override;
	end;
	

	
	TParamNode=class(TValueNode)
	private
		voName  : TString;
		voParam : TParameterVar;
	protected
		property iParam : TParameterVar read voParam write voParam;
		property iName  : TString   read voName  write voName;
		procedure   COmmonsetup;override;

	public
		property    fParam :TParameterVar read voParam write voParam;
		
		function    GetOffset : TOffset;
		procedure   GetNameStr(var ParName : string);
		function    GetPosition : cardinal;
		function    IsSameName(const ParParam : TParameterVar):boolean;
		function    IsSameName(const ParName : string):boolean;
		procedure   SetName(const ParName : string);
		procedure   SetParam(ParParam:TParameterVar);
		function    GetTranType:TParamTransferType;
		constructor create(ParParam:TParameterVar);
		function    CreateSec(ParCre:TSecCreator):boolean;override;
		function    IsDominant(ParForm:TFormulaNode):TDomType;override;
		procedure   PrintNode(ParDis:TDisplay);override;
		function    GetType:TType;override;
		procedure   ValidatePre(ParCre:TCreator;ParIsSec : boolean);override;
		function    IsPushByRef:boolean;
		procedure   SoftEmptyParameter;
		destructor  Destroy;override;
		function    GetParameterVarType:TType;
		function    IsCallByName : boolean;
		procedure   ValidateAfter(ParCre : TCreator);override;
		function    IsCompWithType(ParType :TType):boolean;override;
		function	 CanWriteTo(ParExact : boolean;ParTYpe : TType):boolean;override;
		procedure ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);override;
		procedure ConvertNode(ParCre : TCreator);
		function IsAutomatic : boolean;
	end;
	

	TCallNodeList=class(TFormulaList)
	private
		procedure SortParamList;
		procedure SeTParameterVars(ParCre : TCreator;ParList :TProcParList);
 		procedure ConvertNodes(ParCre : TCreator);

	public
		function  IsCallByName : boolean;
		function  GetParamByName(const ParName : string):TParamNode;
		function  IsSameParamByDef(ParList : TProcParList;ParExact : boolean) : boolean;
		procedure SoftEmptyParameters;
		function  CreateSec(ParCre:TSecCreator):boolean;override;
		function  DetermenFormType(ParCre : TCreator;ParPrvType : TType;ParNode :TFormulaNode):TType;override;
		procedure FinalizeParameters(ParCre : TCreator;ParList : TProcParList);
	end;

	TProcParList=class(TIdentList)
	private
		voParameterFrame : TFrame;
		voLocalFrame	 : TFrame;
		voParamSize      : TSize;
		voParamCnt       : cardinal;
		property  iParamCnt       : cardinal read voParamCnt       write voParamCnt;
		property  iParamSIze      : TSize  read voParamSize      write voPAramSize;
		property  iParameterFrame : TFrame   read voParameterFrame write voParameterFrame;
		property  iLocalFrame     : TFrame   read voLocalFrame     write voLocalFrame;

	protected
		procedure  CommonSetup;override;

	public
		property  fParamSize      : TSize  read voParamSize;
		property  fParamCnt       : cardinal read voParamCnt;
		property  fLocalFrame     : TFrame   read voLocalFrame     write voLocalFrame;
		property  fParameterFrame : TFrame   read voParameterFrame write voParameterFrame;
		
		procedure  CloneParameters(ParCre : TCreator;ParContext,ParNewOwner,ParOwner : TDefinition;ParToList : TProcParList;ParAutomatic : boolean);
		procedure  ChangeFrame(ParLocal,ParParam : TFrame);
		function   SaveItem(parWrite:TObjectStream):boolean;override;
		function   LoadItem(ParWrite:TObjectStream):boolean;override;

		{ Code Generation}
		
		procedure CreateCBInits(ParCre : TNDCreator;ParAt : TNodeIdent;ParContext : TDefinition);
		
		{Parameter comparing}
		function   IsSameParamType(ParLIst:TProcParList;ParType : TParamCompareOptions):boolean;
		function   IsPropertyProcComp(ParTYpe : TType) :boolean;
		
		{Adding parameters}
		function   GetCurOffsetAndInc(ParVar : TParameterVar):TOffset;
		function   GetLocalOFfsetAndInc(ParSize : TSize):TOffset;
		function   GetLocalOFfsetAndInc(Parvar : TProcVar):TOffset;
		procedure  AddRtlParameter(ParFrame : TFrame ; ParType : TType;ParVirtual : boolean);
		function   AddParam(ParCre :TCreator;const ParName : String; ParFrame : TFrame;ParType : TType;ParVar,ParConst,ParVirtual : boolean;var ParParam : TParameterVar):integer;
		function   AddParam(ParVar : TParameterVar):TErrorType;
		function   GetParamByNum(ParNum : cardinal):TParameterVar;
		
		{Parameter processing}
		PROCEDURE  SetParametersOffset(ParCre : TCreator);
		procedure  SetSecondVars(ParCre : TCreator);
		procedure  SetRealPositions;
		
		{Adding localvars}
		
		function   CreateVar(ParCre:TCreator;const ParName:String;ParType:TDefinition):TProcVar;
		procedure  InitVariables(ParDef,ParContext : TDefinition;ParFrame : TFrame);
		procedure  DOneVariables(ParDef : TDefinition;ParFrame : TFrame);
		
		{Retreving param}
		function   GetParameterByRealPosition(ParPos : cardinal) : TParameterVar;
		function   GetNextNormalParameter(ParStart : TParameterVar) : TParameterVar;
		function   GetRtlParameter:TRTLParameter;
		
		{ParamInfo}
		function   GetNumberOfParameters:cardinal;
		
		{mapping}
		procedure  AutomaticCreateMapping(ParMapping : TParameterMappingList);
		
		procedure  SetSecondVar(ParCre : TCreator;ParParam : TParameterVar);
		procedure  ProduceFrame(ParCre:TSecCreator;ParContext : TDefinition);
		function   CreateAutomaticParameterNodes(ParContext ,ParOrgOwner: TDefinition;ParCre:TCreator;ParList:TCallNodeList):TTLVarNode;
		procedure  InitParameters(ParDef : TDefinition);
		procedure  DoneParameters(ParCre : TSecCreator;ParDef : TDefinition);
		procedure  ProducePoc(ParCre : TCreator);
		{validation}
		function   CheckParameterNames(ParLIst :TProcParList;var ParDifText:string):boolean;

	end;
	
	
	TParameterMappingItem=class(TListItem)
	private
		voDefinition  : TVarBase;
		voParentParam : TParameterVar;
	protected
		property iDefinition  : TVarBase  read voDefinition write voDefinition;
		property iParentParam : TParameterVar read voParentParam write voParentParam;
	public
		property    fDefinition  : TVarBase  read voDefinition;
		property    fParentParam : TParameterVar read voParentParam write voParentParam;
		constructor Create(ParDefinition : TVarBase);
		function    IsSameMapping(ParMapping : TParameterMappingItem):boolean;virtual;
		function    IsSameKind(ParDefinition : TVarBase):boolean;virtual;
		function    SaveItem(parWrite:TObjectStream):boolean;override;
		function    LoadItem(ParWrite:TObjectStream):boolean;override;
		procedure   SetIsInherited;virtual;
		procedure   ConnectToParent(ParCre : TCreator;ParParam : TParameterVar);virtual;
		procedure   CreateCBInit(ParAt : TNodeIdent;PArCre : TNDCreator;ParContext : TDefinition);virtual;
		procedure   Print(ParDis : TDisplay);
		function    IsAutomatic : boolean; virtual;
		procedure   GetMappingText(var ParText : string);virtual;
		procedure   CheckParameterAddress(parCre : TCreator);virtual;
	end;
	
	TDefinitionParameterMappingItem=class(TParameterMappingItem)
	private
		voContextLevel : cardinal;
		voOrgOwner     : TDefinition;
		voMacOption    : TMappingOption;
		property iContextLevel : cardinal    read voContextLevel write voContextLevel;
		property iOrgOwner     : TDefinition read voOrgOwner     write voOrgOwner;
		property iMacOption    : TMappingOption read voMacOption write voMacOption;
	public
		constructor Create(ParDef : TVarBase;ParContextLevel : cardinal;ParOrgOwner : TDefinition;ParOption:TMappingOption);
		procedure   CreateCBInit(ParAt : TNodeIdent;PArCre : TNDCreator;ParContext : TDefinition);override;
		procedure   ConnectToParent(ParCre : TCreator;ParParam : TParameterVar);override;
		function    SaveItem(parWrite:TObjectStream):boolean;override;
		function    LoadItem(ParWrite:TObjectStream):boolean;override;
		function    IsSameKind(ParDefinition : TVarBase):boolean;override;

	end;
	
	TConstantParameterMappingItem=class(TDefinitionParameterMappingItem)
	public
		function    IsSameMapping(ParMapping : TParameterMappingItem):boolean;override;
		function     GetValue : TValue;
		procedure   GetMappingText(var ParText : string); override;
		
	end;
	
	TVariableParameterMappingItem=class(TDefinitionParameterMappingItem)
	public
		function    IsSameMapping(ParMapping : TParameterMappingItem):boolean;override;
		procedure   GetMappingText(var ParText : string); override;
	end;
	
	TNormalParameterMappingItem=class(TParameterMappingItem)
		procedure SetIsInherited;override;
		procedure ConnectToParent(ParCre : TCreator;ParParam : TParameterVar);override;
		function  IsSameMapping(ParMapping : TParameterMappingItem):boolean;override;
		procedure CheckParameterAddress(parCre : TCreator);override;
		function  IsAutomatic : boolean; override;
	end;
	
	TParameterMappingList=class(TList)
	private
		voParent : TParameterMappingList;
		voOwner  : TDefinition;
		property iOwner  : TDefinition read voOwner write voOwner;
		property iParent : TParameterMappingList read voParent write voParent;
	protected
		procedure Commonsetup;override;

	public
		property fParent : TParameterMappingList read voParent write voParent;
		procedure AddConstant(ParConstant : TVarBase);
		procedure AddParameter(ParParam : TVarBase);
		procedure AddVariable(ParVar : TVarBase;ParContextLevel : cardinal;ParOrgOwner : TDefinition;ParOption : TMappingOption);
		function  SaveItem(parWrite:TObjectStream):boolean;override;
		function  LoadItem(ParWrite:TObjectStream):boolean;override;
		function  IsSameKind(ParList : TProcParList) : boolean;
		procedure ConnectToParent(ParCre : TCreator;ParParams : TProcParList;ParParent : TParameterMappingList);
		procedure CheckParametersAddress(ParCre : TCreator);
		procedure CreateCBinit(ParAt : TNodeIdent;ParCre : TNDCreator;ParDestContext : TDefinition);
		function  IsSameMapping(ParMapping : TParameterMappingList) : boolean;
		procedure Print(ParDis : TDIsplay);
		constructor Create(ParOwner : TDefinition);
	end;
	
	
implementation
uses procs,cblkbase,classes,meta,execobj;


{----( TParameterMappingList )------------------------------------------------}

constructor TParametermappingList.Create(ParOwner : TDefinition);
begin
	inherited Create;
	iOwner := ParOwner;
end;

procedure TParameterMappingList.Print(ParDis : TDIsplay);
var
	vLCurrent : TParameterMappingItem;
begin
	vlCurrent := TParameterMappingItem(fStart);
	ParDis.Write('Paramter Mapping');
	ParDis.SetLeftMargin(4);
	while (vlCurrent <> nil) do begin
		ParDis.nl;
		vlCurrent.Print(parDis);
		vlCurrent := TParameterMappingItem(vlCurrent.fNxt);
	end;
	ParDis.nl;
	ParDis.SetLeftMargin(-4);
	ParDis.Write('End');
	ParDis.Nl;
end;



function  TParameterMappingList.IsSameMapping(ParMapping : TParameterMappingList) : boolean;
var vlCurrent1 : TParameterMappingItem;
	vlCurrent2 : TParameterMappingItem;
begin
	vlCurrent1 := TParameterMappingItem(fStart);
	vlCurrent2 := TParameterMappingItem(Parmapping.fStart);
	while (vlCurrent1 <> nil) and (vlCurrent2 <> nil) do begin
		if not vlCurrent1.IsSameMapping(vlCurrent2) then exit(false);
		vlCurrent1 := TParameterMappingItem(vlCurrent1.fNxt);
		vlCurrent2 := TParameterMappingItem(vlCurrent2.fNxt);
	end;
	exit((vlCurrent1 = nil) and (vlCurrent2 = nil));
end;

procedure TParameterMappingList.CreateCBinit(ParAt : TNodeIdent;ParCre : TNDCreator;ParDestContext : TDefinition);
var vlCurrent : TParameterMappingItem;
begin
	if iParent <> nil then iParent.CreateCBInit(ParAt,ParCre,ParDestContext);
	vlCurrent := TParameterMappingItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.CreateCBInit(ParAt,ParCre,ParDestContext);
		vlCurrent := TParameterMappingItem(vlCurrent.fNxt);
	end;
end;

procedure TParameterMappingList.CheckParametersAddress(ParCre : TCreator);
var
	vlCurrent : TParameterMappingItem;
begin
	vlCurrent := TParameterMappingItem(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.CheckParameterAddress(ParCre);
		vlCurrent := TParameterMappingItem(vlCurrent.fNxt);
	end;
end;

procedure TParameterMappingList.ConnectToParent(ParCre :TCreator;ParParams : TProcParList;ParParent : TParameterMappingList);
var vlCurrent : TParameterVar;
	vlMapping : TParameterMappingItem;
begin
	vlMapping := TParameterMappingItem(fStart);
	vlCurrent := ParParams.GetNextNormalParameter(nil);
	iParent   := ParParent;
	while (vlMapping <> nil) and (vLCurrent <> nil) do begin
		if not(vlMapping.IsAutomatic) then begin
			vlMapping.ConnectToParent(ParCre,vlCurrent);
			vlCurrent := ParParams.GetNextNormalParameter(vlCurrent);
		end;
		vlMapping := TParameterMappingItem(vlMapping.fNxt);
	end;
end;

procedure TParameterMappingList.AddConstant(ParConstant : TVarBase);
begin
	InsertAtTop(TConstantParameterMappingItem.Create(parConstant,0,nil,MO_Result));{Todo: MCO_Result zettin in TConst... ,onstructor}
end;

procedure TParameterMappingList.AddParameter(ParParam : TVarBase);
begin
	InsertAtTop(TNormalParameterMappingItem.Create(ParParam));
end;

procedure TParameterMappingList.AddVariable(ParVar : TVarBase;ParContextLevel : cardinal;ParOrgOwner : TDefinition;ParOption : TMappingOption);
begin
	InsertAtTop(TVariableParameterMappingItem.Create(ParVar,ParContextlevel,ParOrgOwner,ParOption));
end;


function TParametermappingList.SaveItem(parWrite:TObjectStream):boolean;
begin
	if inherited SaveItem(ParWrite) then exit(true);
	if ParWrite.WritePi(iOwner) then exit(true);
	exit(false);
end;

function TParametermappingList.LoadItem(ParWrite:TObjectStream):boolean;
begin
	if inherited LoadItem(ParWrite) then exit(true);
	if ParWrite.ReadPi(voOwner) then exit(true);
	exit(false);
end;

function TParameterMappingLIst.IsSameKind(ParList : TProcParList) : boolean;
var vlCurrent : TParameterVar;
	vlMapping : TParameterMappingItem;
begin
	vlMapping := TParameterMappingItem(fStart);
	vlCurrent := ParList.GetNextNormalParameter(nil);
	while (vlMapping<> nil) and (vlCurrent <> nil) do begin
		if not (vlMapping.IsAutoMatic) then begin
			if not vlMapping.IsSameKind(vlCurrent) then exit(False);
			vlCurrent := ParList.GetNextNormalParameter(vlCurrent);
		end;
		vlMapping := TParameterMappingItem(vlMapping.fNxt);
	end;
	exit((vlMapping = nil) and (vlCurrent=nil));
end;


procedure TParameterMappingList.Commonsetup;
begin
	inherited commonsetup;
	iParent := nil;
end;


{----( TNormalParameterMappingItem   )----------------------------------------}


function  TNormalParameterMappingItem.IsAutomatic : boolean;
begin
	if iDefinition is TParameterVar then begin
		exit(TParameterVar(iDefinition).IsAutomatic);
	end else begin
		exit(False);
	end;
end;


procedure TNormalParameterMappingItem.CheckParameterAddress(parCre : TCreator);
var vlText : string;
begin
	if iParentParam = nil then exit;
	if iParentParam.fOffset <> TParameterVar(iDefinition).fOffset then begin
		GetMappingText(vlText);
		if not iParentParam.fIsVirtual then TNDCreator(ParCre).ErrorText(Err_non_virt_Wrong_position,vlText);
	end;
end;

procedure TNormalParameterMappingItem.SetIsInherited;
begin
	if iDefinition is TParameterVar then TParameterVar(iDefinition).fIsInherited := true;
end;


procedure  TNormalParameterMappingItem.ConnectToParent(ParCre : TCreator;ParParam : TParameterVar);
var vlErrorText : string;
begin
	inherited ConnectToParent(ParCre,ParParam);
	if iDefinition is TParameterVar then begin
		if not ParParam.IsSameParameter(TParameterVar(iDefinition),[PC_IgnoreName]) then begin
			GetMappingText(vlErrorText);
			TNDCreator(ParCre).ErrorText(Err_Param_Differs_From_Parent,vlErrorText);
		end;
		TParameterVar(iDefinition).fSecondVar := ParParam.fSecondVar;
		SetIsInherited;
	end;
end;

function  TNormalParameterMappingItem.IsSameMapping(ParMapping : TParameterMappingItem):boolean;
begin
	if ParMapping is TNormalParameterMappingItem then begin
		if iDefinition.IsSame(ParMapping.fDefinition) then exit(true);
	end;
	exit(false);
end;


{----( TDefinitionParameterMappingItem )----------------------------------------}


function    TDefinitionParameterMappingItem.SaveItem(parWrite:TObjectStream):boolean;
begin
	if inherited SaveItem(ParWrite)         then exit(true);
	if ParWrite.WriteLOng(iContextLevel) then exit(true);
	if ParWrite.WritePi(iOrgOwner)          then exit(true);
	if ParWrite.WriteLong(longint(iMacOption)) then exit(true);
	exit(false);
end;

function    TDefinitionParameterMappingItem.LoadItem(ParWrite:TObjectStream):boolean;
begin
	if inherited LoadItem(parWrite) then exit(true);
	if ParWrite.ReadLong(voContextLevel) then exit(true);
	if ParWrite.ReadPi(voOrgOwner)  then exit(true);
	if ParWrite.ReadLong(cardinal(voMacOption)) then exit(true);
	exit(false);
end;


constructor TDefinitionParameterMappingItem.Create(ParDef: TVarBase;ParContextLevel : cardinal;ParOrgOwner : TDefinition;ParOption:TMappingOption);
begin
	inherited Create(parDef);
	iContextlevel := ParContextLevel;
	iOrgOwner     := ParOrgOwner;
	iMacOption    := ParOption;
end;




procedure TDefinitionParameterMappingItem.CreateCBInit(ParAt : TNodeIdent ; PArCre : TNDCreator;ParContext : TDefinition);
var
	vlCOntext : TDefinition;
	vlBase    : TRoutine;
	vlLevel   : cardinal;
	vlSource  : TFormulaNode;
   vlTemp    : TFormulaNode;
begin
	if (iParentParam <> nil) and (iDefinition <> nil)  then begin
		vlBase := TRoutine(ParContext);
		if vlBase <> nil then vlBase := TRoutine(vlBase.GetRealOwner);
		if (vlBase <> nil) and (iOrgOwner <> nil) then begin
			vlLevel :=  iContextLevel + TRoutine(ParContext).fRelativeLEvel - TRoutine(iOrgOwner).fRelativeLevel;
			vlContext := vlBase.GetObjectByLevel(vlLevel,TROutine(iOrgOwner).GetRoutineOwner);
		end else begin
			vlContext := nil;
			vlLevel   := 0;
		end;
		if(vlContext <> nil) and (vlCOntext is TClassType) then vLContext := TClassType(vlContext).fObject;
			vlSource := TFormulaNode(iDefinition.CreateReadNode(ParCre,vlContext));
			case iMacOption of
				MO_ObjectPointer:	vlSource := vlSource.CreateObjectPointerOfNode(ParCre);
			   MO_ByPointer:begin
					vlTemp := vlSource ;
					vlSource := TByPtrNode.Create;
		         vlSource.AddNode(vlTemp);
				end;
			end;
			iParentParam.ProduceMappingCBInit(ParAt,ParCre,ParContext,vlSource)
	end;
end;


function  TDefinitionParameterMappingItem.IsSameKind(ParDefinition : TVarBase):boolean;
var vlType1 : TType;
	vlType2 : TType;
begin
	exit(true);
	if ParDefinition is TVarBase then begin
		vlType1 := iDefinition.fType;
		if vlType1 = nil then exit(false);
		vlType2 := ParDefinition.fType;
		if vlType2 = nil then exit(false);
		exit(vlType1.IsDirectComp(vlType2));
	end;
	exit(false);
end;


procedure TDefinitionParameterMappingItem.ConnectToParent(ParCre : TCreator;ParParam : TParameterVar);
var
	vlName : string;
begin
	inherited ConnectToParent(ParCre,ParParam);
	if not ParParam.fIsVirtual  then begin
		ParParam.GetTextStr(vlName);
		TNDCreator(ParCre).ErrorText(Err_PVN_Cant_Have_Constant,vlName);
	end;
end;


{----( TVariableParameterMappingItem )-------------------------------------------------------}


function TVariableParameterMappingItem.IsSameMapping(ParMapping : TPArameterMappingItem):boolean;
begin
	if ParMapping is TVariableParameterMappingItem then begin
		if iDefinition.IsSame(TVariableParameterMappingItem(ParMapping).fDefinition) then exit(true);
	end;
	exit(false);
end;

procedure TVariableParameterMappingItem.GetMappingText(var ParText : string);
var
	vlName : string;
begin
	if iParentParam <> nil then iParentParam.GetTextStr(ParText)
	else ParText := '<unkown>';
	if iDefinition  <> nil then iDefinition.GetDisplayName(vlName)
	else vlName := '<Unkown>';
	ParText := 'Mapping : (current)'+vlName+'=>'+ParText;
end;


{----( TConstantParameterMappingItem )--------------------------------------------------------}

function TConstantParameterMappingItem.GetValue : TValue;
begin
	exit(TConstant(iDefinition).fVal);
end;


procedure TConstantParameterMappingItem.GetMappingText(var ParText : string);
var
	vlText : string;
begin
	if iParentParam <> nil then iParentParam.GetTextStr(ParText)
	else ParText := '<unkown>';
	GetValue.GetAsString(vlText);
	ParText := 'Mapping : (current)'+vlText+'=>'+ParText;
end;

function  TConstantParameterMappingItem.IsSameMapping(ParMapping : TParameterMappingItem):boolean;
begin
	if ParMapping is TConstantParameterMappingItem then begin
		if GetValue.IsEqual(TConstantParameterMappingItem(ParMapping).GetValue) then exit(true);
	end;
	exit(false);
end;



{----( TParameterMappingItem )------------------------------------------------------------}

procedure TParameterMappingItem.CheckParameterAddress(parCre : TCreator);
begin
end;

procedure TParameterMappingItem.GetMappingText(var ParText : string);
var vlName : string;
begin
	iDefinition.GetTextStr(vlname);
	ParText := 'Mapping :(current)'+vlName;
	iParentParam.GetTextStr(vlName);
	ParText := ParText+'=>(parent)'+vlName;
end;


function  TParameterMappingItem.IsAutomatic : boolean;
begin
	exit(false);
end;

procedure  TParameterMappingItem.Print(ParDis : TDisplay);
var vlText : string;
begin
	
	GetMappingText(vlText);
	ParDis.Write(vlText);
end;


function  TParameterMappingItem.IsSameMapping(ParMapping : TParameterMappingItem):boolean;
begin
	exit((ParMapping <> nil) and (ClassType = ParMapping.ClassType));
end;

procedure TParametermappingItem.CreateCBInit(ParAt : TNodeIdent;ParCre : TNDCreator;ParContext : TDefinition);
begin
end;

procedure TParameterMappingItem.ConnectToParent(ParCre :TCreator;ParParam : TParameterVar);
begin
	iParentParam := ParParam;
end;

procedure TParameterMappingItem.SetIsInherited;
begin
end;

constructor TParameterMappingItem.Create(ParDefinition : TVarBase);
begin
	inherited Create;
	iDefinition := ParDefinition;
end;

function  TParametermappingItem.SaveItem(parWrite:TObjectStream):boolean;
begin
	if inherited SaveItem(ParWrite)   then exit(true);
	if ParWrite.WritePi(iParentParam) then exit(true);
	if ParWrite.WritePi(iDefinition)  then exit(true);
	exit(false);
end;

function  TParametermappingItem.LoadItem(ParWrite:TObjectStream):boolean;
begin
	if inherited LoadItem(ParWrite)   then exit(true);
	if ParWrite.ReadPi(voParentParam) then exit(true);
	if ParWrite.ReadPi(voDefinition)  then exit(true);
	exit(False);
end;

function  TParameterMappingItem.IsSameKind(ParDefinition : TVarBase):boolean;
var vlType1 : TType;
	vlType2 : TType;
begin
	if ParDefinition is TVarBase then begin
		vlType1 := iDefinition.fType;
		if vlType1 = nil then exit(false);
		vlType2 := ParDefinition.fType;
		if vlType2 = nil then exit(false);
		exit(vlType1.IsDirectComp(vlType2));
	end;
	exit(false);
end;

{----(TCallNodeList)------------------------------------------------------}


procedure TCallNodeList.FinalizeParameters(ParCre : TCreator;ParList : TProcParList);
begin
		SetParameterVars(ParCre,ParList);
		ConvertNodes(ParCre);
		SortParamList;
end;


function  TCallNodeList.DetermenFormType(ParCre : TCreator;ParPrvType : TType;ParNode :TFormulaNode):TType;
begin
	exit(nil);
end;

function  TCallNodeList.IsCallByName : boolean;
begin
	exit((fStart = nil) or (TParamNode(fStart).IsCallByName));
end;

function  TCallNodeLIst.GetParamByName(const ParName : string):TParamNode;
var vlCUrrent : TParamNode;
begin
	vlCurrent := TParamNode(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsSameName(ParName)) do vlCurrent := TParamNode(VlCurrent.fNxt);
	exit(vlCurrent);
end;


procedure  TCallNodeList.SetParameterVars(ParCre : TCreator;ParList :TProcParList);
var vlParam   :  TParameterVar;
	vlCurrent :  TParamNode;
	vlByName  :  boolean;
	vlName    :  string;
	vlCnt     : cardinal;
	vlOwner   : TDefinition;
begin
	vlCurrent := TParamNode(fStart);
	vlByName :=(vlCurrent <> nil) and   (vlCurrent.IsCallByName);
	vlParam  := nil;
	EmptyString(vlName);
	vlCnt := 0;
	while vlCurrent <> nil do begin
		
		inc(vlCnt);
		if not(vlCurrent.IsAutoMatic) then begin
			if vlByName then begin
				vlCurrent.GetNameStr(vlName);
				ParList.GetPtrByName(vlName,vlOwner,vlParam);
				if vlParam = nil then begin
					TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Cant_Find_Parameter,vlName);
				end  else 	if  not(vlParam is TParameterVar) then begin
					vlParam  := nil;
					TNDCreator(ParCre).AddNodeError(vlCurrent,Err_Ident_Not_parameter,vlName);
				end;
			end else begin
				vlParam := ParList.GetNextNormalParameter(vlParam);
				{TODO Check if all parameters are filled}
{				if vlParam = nil then fatal(fat_cant_find_parameter,'Parameter No ' + intToStr(vlCnt));}
{TODO MAKE error}
			end;
			if vlParam <> nil then vlCurrent.SetParam(vlParam);
		end;
		vlCurrent := TParamNode(vlCurrent.fNxt);
	end;
end;

procedure TCallNodelIst.ConvertNodes(ParCre : TCreator);
var
	vlCurrent : TParamNode;
begin
	vlCurrent := TParamNode(fStart);
	while vlCurrent <> nil do begin
		vlCUrrent.ConvertNode(ParCre);
		vlCurrent := TParamNode(vlCurrent.fNxt);
	end;
end;

procedure TCallNodeList.SortParamList;
var vlCurrent: TParamNode;
	vlCheck  : TParamNode;
	vlNext   : TParamNode;
begin
	
	vlCurrent := TParamNode(fStart);
	if (vlCurrent <> nil) then vlCurrent := TParamNode(vlCurrent.fNxt);
	while (vlCurrent <> nil) do begin
		vlCheck := TParamNode(vlCurrent.fPrv);
		vlNext  := TParamNode(vlCurrent.fNxt);
		while (vlCheck <> nil) and (vlCheck.GetOffset > vlCurrent.GetOffset) do vlCheck := TParamNode(vlCheck.fPrv);
		if (vlCheck) <> TParamNode(vlCurrent.fPrv) then begin
			CutOut(vlCurrent);
			InsertAt(vlCheck,vlCurrent);
		end;
		vlCurrent := vlNext;
	end;
end;



function  TCallNodelist.IsSameParamByDef(ParList : TProcParList;ParExact:boolean):boolean;
var vlParam : TParameterVar;
	vlNode  : TParamNode;
	vlCnt   : cardinal;
	vlByName: boolean;
	vlName  : string;
	vlOwner  : TDefinition;
begin
	vlCnt    := 0;
	vlParam  := nil;
	vlNode   := TParamNode(fStart);
	vlByName := (vlNode <> nil) and (vlNode.IsCallByName);
	ISSameParamByDef := false;
	while vlNode <>nil do begin
		if not vlNode.IsAutomatic then begin
			if vlByName then begin
				vlNode.GetNameStr(vlName);
				if not ParList.GetPtrByName(vlName,vlOwner,vlParam) then exit;
				if(vlParam = nil) or not(vlParam is TParameterVar) then exit;
			end else begin
				vlParam := ParList.GetNextNormalParameter(vlParam);
				if vlParam = nil then exit;
			end;
			if  not(vlParam.IsCompWithParamExpr(ParExact,vlNode)) then exit;
		end;
		vlNode := TParamNode(vlNode.fNxt);
		inc(vlCnt);
	end;
	exit(ParList.GetParamByNum(vlCnt + 1) = nil);
end;


procedure TCallNodeLIst.SoftEmptyParameters;
var vlCurrent:TParamNode;
begin
	vlCurrent := TParamNode(fStart);
	while vlCurrent <> nil do begin
		vlCUrrent.SOftEmptyParameter;
		vlCurrent := TParamNode(vlCurrent.fNxt);
	end;
end;

function TCallNOdelIst.CreateSec(ParCre:TSecCreator):boolean;
var
	vlCurrent : TNodeIdent;
	vlSec     : TSubPoc;
	vlPoc     : TSubPoc;
begin
	
	vlSec := TSubPoc.Create;
	ParCre.AddSec(vlSec);
	vlPoc     := ParCre.fPoc;
	ParCre.SetPoc(vlSec);
	vlCurrent := TNodeIdent(fTop);
	CreateSec := true;
	while (vlCurrent <>  nil) do begin
		if HandleNode(ParCre,vlCurrent) then exit;
		vlCurrent := TNodeIdent(vlCurrent.fPrv);
	end;
	ParCre.SetPoc(vlPoc);
	exit(false);
end;



{---( TProcParList )---------------------------------------------------}


procedure  TProcParList.InitParameters(ParDef : TDefinition);
var vlCurrent : TParameterVar;
begin
	vlCurrent := TParameterVar(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent is TParameterVar then vlCurrent.InitParameter(ParDef);
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
end;



function  TProcParList.GetParameterByRealPosition(ParPos : cardinal) : TParameterVar;
var
	vlCurrent : TParameterVar;
begin
	vlCurrent := TParameterVar(fStart);
	while (vlCurrent <> Nil) do begin
		if vlCurrent is TParameterVar then begin
			if vlCUrrent.fRealPosition = ParPos then break;
		end;
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
	exit(vlCurrent);
end;

procedure TProcParList.SetRealPositions;
var vlCurrent : TParameterVar;
	vlCnt     : cardinal;
begin
	vlCurrent := TParameterVar(fStart);
	vlCnt     := 0;
	while (vlCurrent <> nil) do begin
		if (vlCurrent is TParameterVar)  then begin
			vlCurrent.fRealPosition := vlCnt;
			inc(vlCnt);
			
		end;
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
end;


procedure TProcParList.InitVariables(ParDef,ParContext: TDefinition;ParFrame : TFrame);
var vlCurrent : TFrameVariable;
begin
	vlCurrent := TFrameVariable(fStart);
	while (vlCurrent <> nil) do begin
		if vlCurrent is TFrameVariable then vlCurrent.InitVariable(ParDef,ParContext,ParFrame);
		vlCurrent := TFrameVariable(VlCurrent.fNxt);
	end;
end;

procedure TProcParList.DoneVariables(ParDef : TDefinition;ParFrame : TFrame);
var vlCurrent : TFrameVariable;
begin
	vlCurrent := TFrameVariable(fStart);
	while (vlCurrent <> nil) do begin
		if vlCurrent is TFrameVariable then vlCurrent.DoneVariable(ParDef,ParFrame);
		vlCurrent := TFrameVariable(VlCurrent.fNxt);
	end;
end;


procedure TProcParList.CreateCBInits(ParCre : TNDCreator;ParAt : TNodeIdent;ParContext : TDefinition);
var vlCurrent : TProcVar;
begin
	vlCurrent :=  TProcVar(fStart);
	while (vlCurrent <> nil) do begin
		if vlCurrent is TProcVar then vlCurrent.CreateCBInit(ParCre,ParAt,ParContext);
		vlCurrent := TProcVar(vlCurrent.fNxt);
	end;
end;


procedure TProcParList.AutomaticCreateMapping(ParMapping : TParameterMappingList);
var vlCurrent : TParameterVar;
begin
	vlCurrent := GetNextNormalParameter(nil);
	while (vlCurrent <> nil) do begin
		ParMapping.AddParameter(vlCurrent);
		vlCurrent := GetNextNormalParameter(vlCurrent);
	end;
end;

function TProcParList.CreateVar(ParCre : TCreator ; const ParName : String ; ParType : TDefinition):TProcVar;
var vlVar  : TLocalVar;
begin
	vlVar := TLocalVar.Create(ParName,iLocalFrame,0,TType(ParType));
	vlVar.fOffset := GetLocalOffsetAndInc(vlVar);
	CreateVar := vlVar;
end;

procedure  TProcParlist.ChangeFrame(ParLocal,ParParam : TFrame);
var vlCurrent : TDefinition;
begin
	vlCurrent := TDefinition(fStart);
	while vlCurrent <> nil do begin
		if vlCUrrent is TFrameVariable then begin
			if TFrameVariable(vlCUrrent).fFrame = iLocalFrame     then TFrameVariable(vlCurrent).fFrame := ParLocal else
			if TFrameVariable(vlCurrent).fFrame = iParameterFrame then TFrameVariable(vlCurrent).fFrame := ParParam;
		end;
		vlCurrent :=TDefinition(vlCurrent.fNxt);
	end;
	iLocalFrame     := ParLocal;
	iParameterFrame := ParParam;
end;


procedure  TProcParList.ProducePoc(ParCre : TCreator);
var vlCurrent : TRoutineCollection;
begin
	vlCurrent := TRoutineCollection(fStart);
	while vlCurrent <> nil do begin
		if vlCUrrent is TRoutineCollection then vlCurrent.PRoducePoc(ParCre);
		vlCurrent :=TRoutineCollection(vlCurrent.fNxt);
	end;
end;


function   TProcParList.IsPropertyProcComp(ParTYpe : TType) :boolean;
var
	vlCurrent : TParameterVar;
begin
	vlCurrent := GetNextNormalParameter(nil);
	if (vlCurrent <> nil) then begin
		if ParType <> nil then begin
			if not(ParType.IsExactSame(vlCurrent.fType)) then exit(false);
		end;
		if vlCurrent.fTranType = PV_Var then exit(false);
	end;
	if GetNextNormalParameter(vlCurrent) <> nil then exit(false);
	exit(true);
end;

function  TProcParList.GetNextNormalParameter(ParStart : TParameterVar) : TParameterVar;
var
	vlCurrent : TParameterVar;
begin
	vlCurrent := ParStart;
	if vlCurrent = nil then begin
		vlCurrent := TParameterVar(fStart)
	end else begin
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
	while (vlCurrent <> nil) and (not(vlCurrent is TParameterVar) or TParameterVar(vlCurrent).IsAutomatic) do vlCUrrent := TParameterVar(vlCurrent.fNxt);
	exit(vlCurrent);
end;



function  TPRocParList.CheckParameterNames(ParList :TProcParList;var ParDifText:string):boolean;
var vlCurrent  : TParameterVar;
	vlCurrent2 : TParameterVar;
	vlCnt      : cardinal;
	vlName     : string;
begin
	EmptyString(ParDifText);
	vlCurrent  := TParameterVar(fStart);
	vlCurrent2 := TParameterVar(ParList.fStart);
	vlCnt      := 0;
	repeat
		while (vlCurrent  <>nil) and not((vlCurrent  is TParameterVar) and not(vlCurrent.IsAutomatic)) do vlCUrrent  := TParameterVar(vlCurrent.fNxt);
		while (vlCurrent2 <>nil) and not((vlCurrent2 is TParameterVar) and not(vlCurrent2.IsAutomatic)) do vlCUrrent2 := TParameterVar(vlCurrent2.fNxt);
		if (vlCurrent = nil) and (vlCurrent2 <> nil) then begin
			vlCurrent2.GetTextStr(vlName);
			AddTextToTextList(ParDifText, ' Parameter '+vlName+' not in previous definition');
			inc(vlCnt);
		end else if (vlCurrent <> nil) and (vlCurrent2 = nil) then begin
			vlCurrent.GetTextStr(vlName);
			AddTextToTextList(ParDifText, ' Parameter '+vlName+' missing');
			inc(vlCnt);
		end else if (vlCurrent = nil) and (vlCurrent2= nil) then begin
			break;
		end else begin
			if vlCurrent.CheckParameterName(vlCurrent2,ParDIfText) then inc(vlCnt);
		end;

		if vlCurrent <> nil  then vlCurrent  := TParameterVar(vlCurrent.fNxt);
		if vlCurrent2<> nil  then vlCurrent2 := TParameterVar(vlCurrent2.fNxt);
	until false;
	exit(vlCnt <>0);
end;


{
ParContext - The context (owner) of the routine
}

function  TProcParList.CreateAutomaticParameterNodes(ParContext,ParOrgOwner : TDefinition;ParCre : TCreator;ParList:TCallNodeList):TTLVarNode;
var vlParam : TParameterVar;
	vlNew   : TParamNode;
	vlTTL   : TTLVarNode;
begin
	vlParam := TParameterVar(fStart);
	vlTTL   := nil;
	while  vlParam <> nil do begin
		if vlParam is TParameterVar then begin
			vlNew := vlParam.CreateAutomaticParamNode(ParContext,ParOrgOwner,ParCre,vlTTL);
			if vlNew <> nil then ParList.InsertAtTop(vlNew);
		end;
		vlParam := TParameterVar(vlParam.fNxt);
	end;
	exit(vlTTL);
end;


procedure  TProcParList.CloneParameters(ParCre : TCreator;ParContext,ParNewOwner,ParOwner : TDefinition;ParToList : TProcParList;ParAutomatic : boolean);
var vlCurrent : TParameterVar;
	vlNew     : TParameterVar;
begin
	vlCurrent := TParameterVar(fStart);
	while (vlCurrent <> nil ) do begin
		if (vlCurrent Is TParameterVar)  then begin
			if Vlcurrent.IsAutomatic = ParAutomatic then begin
				vlNew := vlCurrent.Clone(ParToList.fParameterFrame,ParContext,ParNewOwner,ParOwner);
				if vlNew <> nil then ParToList.AddParam(vlnew);
			end;
		end;
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
end;


function  TProcParList.AddParam(ParVar : TParameterVar):TErrorType;
begin
	iParamCnt := iParamCnt + 1;
	ParVar.SetPosition(iParamCnt);
	exit(AddIdent(ParVar));
end;

function TProcParList.GetRtlParameter:TRTLParameter;
var vlCurrent : TRTLParameter;
begin
	vlCurrent := TRTLParameter(fStart);
	while (vlCurrent <> Nil)
	and (vlCurrent.fIdentCode <> IC_RtlParameter) do
	vlCurrent := TRTLParameter(vlCurrent.fNxt);
	GetRtlParameter := vlCurrent;
end;

function   TProcParList.SaveItem(parWrite:TObjectStream):boolean;
begin
	SaveItem := true;
	if inherited SaveItem(ParWrite)       then exit;
	if ParWrite.Writelong(voParamSize) then exit;
	if ParWrite.WritePi(iLocalFrame)      then exit;
	if ParWrite.WritePi(iParameterFrame)  then exit;
	if ParWrite.Writelong(iParamCnt)   then exit(true);
	SaveItem := false;
end;


function   TProcParList.LoadItem(ParWrite:TObjectStream):boolean;
begin
	LoadItem := true;
	if inherited LoadITem(ParWrite)      then exit;
	if ParWrite.ReadLong(voParamSize) then exit;
	if ParWrite.ReadPi(voLocalFrame)     then exit;
	if PArWrite.ReadPi(voParameterFrame) then exit;
	if ParWrite.ReadLOng(voParamCnt)  then exit;
	LoadItem := false;
end;




function  TProcParList.IsSameParamType(ParLIst:TProcParList;ParType : TParamCompareOptions):boolean;
var
	vlCurrent : TParameterVar;
	vlParam   : TParameterVar;
	vlCnt     : cardinal;
begin
	vlCnt :=1;
	vlCurrent := TParameterVar(fStart);
	IsSameParamType := false;
	vlParam := nil;
	if PC_CheckAll in ParType then begin
		while vlCurrent <> nil do begin
			if vlCurrent is TParameterVar then begin
				inc(vlCnt);
				vlParam := ParList.GetParameterByRealPosition(vlCurrent.fRealPosition);
				if not vlCurrent.IsSameParameter(vlParam,ParType) then  begin
					exit(false);
				end;
			end;
			vlCurrent := TParameterVar(vlCurrent.fNxt);
		end;
		IsSameParamType := ParList.GetParameterByRealPosition(vlCnt)=nil;
	end else begin
		vlCurrent := GetNextNormalParameter(nil);{TODO:moet dit hier}
		while vlcurrent <> nil do begin
			vlParam := ParList.GetNextNormalParameter(vlParam);
			if not vlCurrent.IsSameParameter(vlParam,ParType) then exit(false);
			inc(vlCnt);
			vlCurrent := GetNextNormalParameter(vlCurrent);
		end;
		IsSameParamType :=   ParList.GetParamByNum(vlCnt)=nil;
	end;
end;

function   TProcParList.GetNumberOfParameters:cardinal;
var vlCurrent : TParameterVar;
	vlCnt     : cardinal;
begin
	vlCurrent := TParameterVar(fStart);vlCnt := 0;
	while vlCUrrent <> nil do begin
		if vlCurrent is TParameterVar then inc(vlCnt);
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
	GetNumberOFParameters := vlCnt;
end;


procedure TProcParList.ProduceFrame(ParCre:TSecCreator;ParContext : TDefinition);
var
	vlCurrent : TParameterVar;
begin
	vlCurrent := TParameterVar(fStart);
	while vlCurrent <> nil do begin
		if vlCUrrent is TParameterVar  then vlCurrent.ProduceFrame(ParCre,ParContext);
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
end;

function   TProcParList.GetCurOffsetAndInc(ParVar:TParameterVar):TOffset;
begin
	GetCurOffsetAndInc := iParamSize+Size_Parambegin;
	iParamSize := iParamSize + ParVar.GetPushSize;
end;

function  TProcParList.GetLocalOFfsetAndInc(Parvar:TProcVar):TOffset;
begin
	GetLOcalOffsetAndInc := GetLocalOffsetAndInc(ParVar.GetAccessSize);
end;

function   TProcParList.GetLocalOFfsetAndInc(ParSize:TSize):TOffset;
begin
	exit(iLocalFrame.GetNewOffset(parSize));
end;

procedure  TProcParList.CommonSetup;
begin
	inherited COmmonSetup;
	iParamSize  := 0;
	iParamCnt   := 0;
	iLocalFrame := nil;
	iParameterFrame := nil;
end;


procedure  TProcParList.AddRTLParameter(ParFrame : TFrame;ParType : TType;ParVirtual : boolean);
var
	vlParameter:TRTLParameter;
	vlName:string;
begin
	if parType = nil then exit;
	GetNewAnonName(vlname);
	vlParameter := TRTLParameter.Create(vlName,1,ParFrame,ParType,Pv_Var,ParVirtual);
	vlParameter.fDefAccess := AF_Public;
	AddParam(vlParameter);
end;




function   TPRocParList.AddParam(ParCre : TCreator;const ParName :String;ParFrame:TFrame;ParType:TType;ParVar,ParConst,ParVirtual:boolean;var ParParam:TParameterVar):integer;
var
	vltranType : TParamTransferType;
	vlVar      : TParameterVar;
begin
	AddParam := Err_No_Error;
	vlTranType := PV_Value;
	if ParVar then begin
		if ParConst then 	exit(Err_Int_INvalid_Tran_Type);
   	vlTranType := PV_Var
	end else if ParConst then vltranType := PV_Const;
	vlVar := TParameterVar.Create(ParName,ParFrame,ParType,vlTranType,ParVirtual);
	vlvar.fDefAccess := AF_Public;
	ParParam := vlvar;
	if ParType <> nil then begin
			if ParType.fSIze = 0 then begin
				if ParVirtual  then TNDCreator(ParCre).ErrorText(Err_Vir_ch_Par_has_zu_Size,ParName);
				if (vlTranType= PV_Value) then  TNDCreator(ParCre).ErrorText(Err_Value_Param_Unkown_Size,ParName);
			end;
	end;
	exit(AddParam(vlVar));
end;

procedure TProcParList.SetSecondVar(ParCre : TCreator;ParParam : TParameterVar);
var
	vlName : string;
	vlVar  : TLocalVar;
	vlAcc  : TDefAccess;
begin
	GetNewAnonName(vlName);
	vlAcc :=TNDCreator(ParCre).fCurrentDefAccess;
	TNDCreator(ParCre).fCurrentDefAccess := AF_Protected;
	vlVar := TLocalVar(CreateVar(ParCre,vlName,ParParam.GetVar2Type));
	TNDCreator(ParCre).AddIdent(vlVar);
	vlVar.fDefAccess := AF_Protected;
	ParParam.fSecondVar := vlVar;
	TNDCreator(ParCre).fCurrentDefAccess := vlAcc;
end;

PROCEDURE  TProcParList.SetParametersOffset(ParCre : TCreator);
var
	vlCurrent : TParameterVar;
	vlPos     : cardinal;
	vlFound   : boolean;
begin
	SetRealPositions;
	vlPos := 0;
	repeat
		vlFound := false;
		vlCurrent := TParameterVar(fStart);
		while vlCurrent <> nil do begin{Kan beter}
			if (vlCUrrent is TParameterVar) then begin
				if vlCurrent.fRealPosition = vlPos then begin
					vlCurrent.SetOffset(GetCurOffsetAndInc(vlCurrent));
				end;
				if vlCurrent.fRealPosition > vlPos then vlFound := true;
			end;
			vlCurrent := TParameterVar(vlCurrent.fNxt)
		end;
		inc(vlPos);
	until not(vlFound);
end;

procedure TProcParList.SetSecondVars(ParCre : TCreator);
var vlCurrent : TParameterVar;
begin
	vlCurrent := TParameterVar(fStart);
	while (vlCurrent <> nil) do begin
		if vlCurrent is TParameterVar then begin
			if (vlCurrent.fNeedVar2) and (vlCurrent.fSecondVar = nil) then SetSecondVar(ParCre,vlCurrent);
		end;
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
end;


function   TProcParList.GetParamByNum(ParNum : cardinal):TParameterVar;
var vlCnt    : cardinal;
	vlCurrent: TParameterVar;
begin
	vlCnt := ParNum;
	vlCurrent := TParameterVar(fStart);
	while (vlCurrent <> nil)  do begin
		if (vlCurrent is TParameterVar) and (not(vlCurrent.IsAutomatic)) then begin
			dec(vlCnt);
			if vlCnt =0 then break;
		end;
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
	GetParamByNum := vlCurrent;
	
end;

procedure  TProcParList.DoneParameters(ParCre : TSecCreator;ParDef : TDefinition);
var vlCurrent : TParameterVar;
begin
	vlCurrent := TParameterVar(fStart);
	while vlCurrent <> nil do begin
		if vlCurrent is TParameterVar then vlCurrent.DoneParameter(ParDef,parCre);
		vlCurrent := TParameterVar(vlCurrent.fNxt);
	end;
end;


{-----(TClassFrameParameter )-------------------------------------------------------}

function    TClassFrameParameter.Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner : TDefinition) : TParameterVar;
var
	vlName       : string;
	vlNewType    : TDefinition;
	vlParam      : TClassFrameParameter;
	vlNewMeta    : TMeta;
   vlNewMetaPtr : TVarBase;
begin
	vlNewType := ParNewOwner;
   vlNewMeta := nil;
	vlNewMetaPtr := nil;
	while (vlNewType <> nil) and not(iType.IsParentof(vlNewType)) do vlNewType := vlNewType.GetRealOwner;
   if(iMeta <> nil) then vlNewMeta := TClassType(vlNewType).fMeta;
	{TODO: Avoid 'is' test'}
	if(vlNewType <> nil) then begin
		if vlNewType is TObjectClassType then vlNewMetaPtr := TObjectClassType(vlNewType).fMetaPtr;
	end;
	GetTextStr(vlName);
	vlParam := TClassFrameParameter.Create(vlName,vlNewMeta,vlNewMetaPtr,ParFrame,TClassType(vlNewType).fFrame,TType(vlNewType),fTranType,fIsVirtual);
	vlParam.SetPosition(iSourcePosition);
	vlParam.fRealPosition := iRealPosition;
	vlParam.fIsInherited  := true;
	vlParam.fSecondVar    := iSecondVar;
	exit(vlParam);
end;

constructor TClassFrameParameter.Create(const ParName : String;ParMeta : TDefinition;ParMetaFrame : TVarBase;ParFrame,ParOther : TFrame;ParType : TType;ParTranType : TParamTransferType;ParVirtual :boolean);
begin
	inherited Create(ParName,1,ParFrame,ParOther,ParType,ParTranType,ParVirtual);
	iMeta 	   := ParMeta;
	iMetaFrame := ParMetaFrame;
end;

procedure   TClassFrameParameter.InitParameter(ParOwner : TDefinition);
var
	vlContext : TDefinition;
begin
	vlContext := ParOwner.GetRealOwner;
	if(vlContext <> nil) then begin
		if vlContext is TClassType then vlContext := TClassType(vlContext).fObject;
	end;
	iPushedFrame.AddAddressing(ParOwner,vlContext,ParOwner,self,false);
	if iMeta <> nil then TMeta(iMeta).fMetaFrame.AddAddressing(vlContext,vlContext,vlContext,iMetaFrame,false);
end;

procedure   TClassFrameParameter.DoneParameter(ParOwner : TDefinition;ParCre : TSecCreator);
var
	vlContext : TDefinition;
begin
	vlContext := ParOwner.GetRealOwner;
	if(vlContext <> nil) then begin
		if vlContext is TClassType then vlContext := TClassType(vlContext).fObject;
	end;
	if iMeta <> nil then TMeta(iMeta).PopAddressing(vlContext);
	iPushedFrame.PopAddressing(ParOwner);
end;

function  TClassFrameParameter.SaveItem(parStream:TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WritePi(iMeta) then exit(true);
	exit(false);
end;

function  TClassFrameParameter.LoadItem(ParStream:TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadPi(voMeta) then exit(true);
	exit(false);
end;

function  TClassFrameParameter.CreateAutomaticParamNode(ParContext,ParOrgOwner : TDefinition;ParCre : TCreator; var ParTTL:TTLVarNode):TParamNode;
var
	vlParam : TParamNode;
	vlCurrent : TDefinition;
begin
	vlCurrent := parContext;
	while (vlCurrent <> nil) and not((vlCurrent is TClassType) or (vlCurrent is TObjectRepresentor)) do vlCUrrent := vlCurrent.fOwner;
	
	if (ParContext is TRoutine) and not(vlcurrent is TObjectRepresentor) then vlCurrent := TClassTYpe(vlCurrent).fObject;
	vlParam := TParamNode.Create(nil);
	vlParam.SetParam(self);
	vlParam.fContext := vlCurrent;
	exit(vlParam);
	
end;

{-----( TFixedFrameParam )----------------------------------------}
constructor TFixedFrameParameter.create(const ParName:String;ParContext : TDefinition;ParFrame,ParOther:TFrame;Partype:TType;ParVirtual : boolean);
begin
	inherited Create(ParName,1,ParFrame,ParOther,ParType,PV_Value,ParVirtual);
	iContext := ParContext;
end;

procedure   TFixedFrameParameter.InitParameter(ParOwner : TDefinition);
begin
	iPushedFrame.AddAddressing(ParOwner,iContext,ParOwner,self,false);
end;

procedure   TFixedFrameParameter.DoneParameter(ParOwner : TDefinition;ParCre : TSecCreator);
begin
	iPushedFrame.PopAddressing(ParOwner);
end;

function    TFixedFrameParameter.SaveItem(parStream:TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WritePi(iContext) then exit(true);
	exit(false);
end;

function    TFixedFrameParameter.LoadItem(ParStream:TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadPi(voContext) then exit(true);
	exit(false);
end;

function    TFixedFrameParameter.Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner : TDefinition) : TParameterVar;
var vlName  : string;
	vlParam : TParameterVar;
begin
	GetTextStr(vlName);
	vlParam := TFixedFrameParameter.Create(vlname,iContext,ParFrame,iPushedFrame,fType,fIsVirtual);
	vlParam.SetPosition(iSourcePosition);
	vlParam.fIsInherited  := true;
	vlParam.fSecondVar := fSecondVar;
	exit(vlParam);
end;

function  TFixedFrameParameter.CreateAutomaticParamNode(ParContext,ParOrgOwner : TDefinition;ParCre : TCreator; var ParTTL:TTLVarNode):TParamNode;
var
	vlParam : TParamNode;
begin
	vlParam := TParamNode.Create(nil);
	vlParam.SetParam(self);
	vlParam.fContext := iContext;
	exit(vlParam);
end;
{-----(TFrameParameter )----------------------------------------------}

function   TFrameParameter.SaveItem(parStream:TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WritePi(iPushedFrame) then exit(true);
	exit(false);
end;

function TFrameParameter.LoadItem(ParStream:TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream)   then exit(true);
	if ParStream.ReadPi(voPushedFrame) then exit(true);
	exit(false);
end;

function    TFrameParameter.IsSameParameter(ParParam : TParameterVar;ParType : TParamCompareOptions):boolean;
begin
	if not inherited IsSameParameter(ParParam,ParType) then exit(false);
	if (ParParam is TFrameParameter) and not( iPushedFrame.HasPrevious(TFrameParameter(ParParam).iPushedFrame) or
	TFrameParameter(ParParam).iPushedFrame.HasPrevious(iPushedFrame))
	then exit(false);
	exit(true);
end;

procedure TFrameParameter.Print(ParDis : TDisplay);
begin
	inherited Print(ParDis);
	ParDis.Print([' Pushed Frame=',cardinal(iPushedFrame)]);
end;


constructor TFrameParameter.create(const ParName : string;ParSourceContextLevel : cardinal;ParFrame,ParOther : TFrame;Partype : TType;ParTranType : TParamTransferType;ParVirtual : boolean);
begin
	inherited Create(ParName,ParSourceContextLevel,ParFrame,ParType,ParTranType,ParVirtual);
	iPushedFrame := ParOther;
end;

procedure TFrameParameter.InitParameter(ParOwner : TDefinition);
var
	vlOwner : TDefinition;
	vlContext : TDefinition;
begin
	vlOwner := ParOwner.GetRealOwner;
	if vlOwner is TRoutine then begin
		vlContext := GetContextObj(vlOwner,vlOwner);
	end else begin
		vlContext :=vlOwner;
	end;
	if(vlContext <> nil) and (vlContext is TClassType) then vlContext := TClassType(vlContext).fObject;
	iPushedFrame.AddAddressing(ParOwner,vlContext,ParOwner,self,false);
end;

procedure TFrameParameter.DoneParameter(ParOwner : TDefinition;ParCre : TSecCreator);
begin
	iPushedFrame.PopAddressing(ParOwner);
end;


function  TFrameParameter.CreateAutomaticParamNode(ParContext,ParOrgOwner : TDefinition;ParCre : TCreator; var ParTTL:TTLVarNode):TParamNode;
var
	vlParam   : TParamNode;
	vlContext : TDefinition;
begin
	if ParContext is TRoutine then begin
		vlCOntext := GetContextObj(ParContext,ParOrgOwner);
	end else begin
		vlContext := ParContext;
	end;
	vlParam := TParamNode.Create(nil);
	vlParam.SetParam(self);
	vlParam.fContext := vlContext;
	exit(vlParam);
end;


function  TFrameParameter.CreateAutomaticMac(ParContext : TDefinition;ParCre:TSecCreator):TMacBase;
begin
	exit(iPushedFrame.CreateFramePointerMac(ParContext,ParCre));
end;

procedure TFrameParameter.Commonsetup;
begin
	inherited Commonsetup;
	iIdentCode := Ic_FrameParameter;
end;


function TFrameParameter.Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOwner : TDefinition) : TParameterVar;
var
	vlName    : string;
	vlParam   : TParameterVar;
	vlContext : TRoutine;
	vlNewCl   : cardinal;
	vlOrgOwner: TRoutine;
	vlCnt     : cardinal;
	vlPm      : cardinal;
begin
	vlNewCl := 1;
	vlContext := TRoutine(ParNewOwner);
	if (ParNewOwner <> nil) and (ParNewOwner is TClassType) then vlContext := nil;{TODO=>Contextlevel}
	while (vlContext <> ParContext) and (vlContext <> nil) do begin
		vlContext := TRoutine(vlContext.GetRoutineOwner);
		inc(vlNewCl);
	end;
	vlCnt := iSourceContextLevel;
	vlOrgOwner := TRoutine(ParOwner);
	while (vlCnt >1) and (vlContext <> nil) and (vlOrgOwner <> nil) do begin
		
		if(vlContext.fRelativeLevel < vlOrgOwner.fRelativeLevel) then fatal(FAT_Can_Match_Owner_hyr,'');
		vlPm := vlContext.fRelativeLevel - vlOrgOwner.fRelativeLevel+1;
		inc(vlNewCl,vlPm);
		while(vlContext <> nil) and (vlPm > 0) do begin
			vlContext := TRoutine(TRoutine(vlContext).GetRoutineOwner);
			dec(vlPm);
		end;
		
		if(vlContext = nil) then  fatal(FAT_Can_Match_Owner_hyr,'');
		dec(vlCnt);
		vlOrgOwner := TRoutine(vlOrgOwner.GetRoutineOwner);
	end;
	GetTextStr(vlName);
	vlParam := TFrameParameter.Create(vlName,vlNewCl,ParFrame,iPushedFrame,fType,fTranType,fIsVirtual);
	vlParam.SetPosition(iSourcePosition);
	vlParam.fRealPosition := iRealPosition;
	vlParam.fIsInherited  := true;
	vlParam.fSecondVar    := iSecondVar;
	exit(vlParam);
end;




{--------( TRTLParameter )--------------------------------------}


function TRtlParameter.Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner : TDefinition) : TParameterVar;
var
	vlName  : string;
	vlParam : TParameterVar;
begin
	GetTextStr(vlName);
	vlParam := TRtlParameter.Create(vlName,iSourceContextlevel,ParFrame,fType,fTranType,fIsVirtual);
	vlParam.SetPosition(iSourcePosition);
	vlParam.fRealPosition := iRealPosition;
	vlParam.fIsInherited  := true;
	vlParam.fSecondVar    := iSecondVar;
	exit(vlParam);
end;



function TRtlParameter.CreateAutomaticParamNode(ParContext,ParOrgOwner : TDefinition;ParCre : TCreator; var ParTTL:TTLVarNode):TParamNode;
var vlNode : TParamNode;
	vlVar  : TTLVarNode;
begin
	vlNode  := TParamNode.Create(nil);
	vlNode.SetParam(self);
	vlNode.fContext := ParContext;
	vlVar  := TTLVarNode.Create(fType);
	ParTTL := vlVar;
	vlVar.fContext := ParContext;
	vlNode.AddNode(vlVar);
	exit(vlNode);
end;

procedure TRTLParameter.Commonsetup;
begin
	inherited commonsetup;
	iIdentCode := (IC_RTLParameter);
end;

{--------( TParamNode )----------------------------------------}

function TParamNode.IsAutomatic : boolean;
begin
	if fParam = nil then exit(false);
	exit(fParam.IsAutomatic);
end;

procedure TParamNode.ConvertNode(ParCre : TCreator);
var
	vlNode : TFormulaNode;
	vlNew  : TFormulaNode;
begin
	vlNode := TFormulaNode(iParts.fStart);
	if (vlNode <> nil) and (fParam <>nil) then begin
		if vlNode.ConvertNodeType(fParam.fType,ParCre,vlNew) then begin
			if (vlNew <> nil) then begin
				iParts.DeleteLink(vlNode);
				iParts.InsertAtTop(vlNew);
			end;
		end;
	end;
end;


procedure  TParamNode.ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);
var
	vlMode :TAccessMode;
begin
{TODO:Set var parameters according to VaruseList of routine}
	if(fParam <> nil) then begin
		vlMode := AM_Read;
		if fParam.fTranType =PV_Var then vlMode := AM_Silent_Read_Write;
		iParts.ValidateDefinitionUse(ParCre,vlMode,ParUseList);
	end;
end;

function  TParamNode.IsCompWithType(ParType :TType):boolean;
var
	vlPart : TFormulaNode;
begin
	vlPart := TFormulaNode(iParts.fStart);
	if vlPart <> nil then begin
		exit(vlPart.IsCompWithType(ParType));
	end;
	exit(false);
end;


function TParamNode.CanWriteTo(ParExact : boolean;ParTYpe : TType):boolean;
var
	vlPart :TFormulaNode;
begin
	vlPart := TFormulaNode(iParts.fStart);
	if vlPart <> nil then begin
		exit(vlPart.CanWriteTo(ParExact,ParType));
	end;
	exit(false);
end;



function   TParamNode.GetOffset : TOffset;
begin
	if fParam <> nil then begin
		exit(fParam.fOffset);
	end else begin
		exit(0);
	end;
end;


procedure   TParamNode.ValidateAfter(ParCre : TCreator);
var
	vlType : TType;
	vlNode : TFormulaNode;
begin
	inherited ValidateAfter(ParCre);
	if fParam <> nil then begin
		vlType := fParam.fType;
		vlNode := TFormulaNode(iParts.fStart);
		if (vlType <> nil) and (vlNode <> nil)  then begin
			if vlNode.fNxt = nil then vlNode.ValidateConstant(ParCre,@vlType.ValidateConstant);
		end;
	end;
end;

procedure  TParamNode.GetNameStr(var ParName : string);
begin
	if iName <> nil then begin
		iName.GetString(ParName)
	end else begin
		EmptyString(ParName);
	end;
end;


function  TParamNode.IsCallByName : boolean;
begin
	exit(iName <> nil);
end;


function  TParamNode.IsSameName(const ParName : string):boolean;
begin
	if iName = nil then exit(false);
	exit(iName.IsEqualStr(ParName));
end;

destructor TParamNode.Destroy;
begin
	inherited Destroy;
	if iName <> nil then iName.Destroy;
end;

procedure  TParamNode.COmmonsetup;
begin
	inherited Commonsetup;
	iIdentCode := (IC_ParamNode);
	iName      := nil;
	iComplexity := CPX_Variable;
	if IsPushByRef then iComplexity := CPX_Pointer;
end;

function  TParamNode.IsSameName(const ParParam : TParameterVar):boolean;
begin
	if iName = nil then exit(true);
	exit(ParParam.IsSameText(iName));
end;

procedure TParamNode.SetName(const ParName : string);
begin
	if iName <> nil then iName.Destroy;
	iName := TString.Create(ParName);
end;

function TParamNode.GetPosition:cardinal;
begin
	if fParam <> nil then begin
		exit(fParam.fSourcePosition);
	end;
	exit(cardinal(-1));
end;

function TParamNode.GetTranType:TParamTransferType;
begin
	GetTranType := PV_Value; {moet Pv_Unkown worden of fatal}
	if fParam <> nil then GetTranType := fParam.fTranType;
end;


function  TParamNode.IsPushByRef:boolean;
begin
	isPushByRef := false;
	if fParam <> nil then IsPushByRef := fParam.fRefMainVar;
end;


function TParamNode.GeTParameterVarType:TType;
begin
	GeTParameterVarType := nil;
	if fParam <> nil then GeTParameterVarType := fParam.fType;
end;


procedure TParamNode.SetParam(ParParam:TParameterVar);
begin
	fParam := parParam;
end;

function    TParamNode.CreateSec(ParCre:TSecCreator):boolean;
var
	vlMac  : TMacBase;
	vlPush : TSetParPoc;
	vlMode : TMacCreateOption;
begin
	vlMode := MCO_Result;
	vlMac  := nil;
	if fParam.IsAutomatic then begin
		vlMac := fParam.CreateAutomaticMac(iContext,ParCre);
	end;
	if vlMac = nil then begin
		if fParam.fRefMainVar then vlMode := MCO_ValuePointer;
		if iParts.fStart <> nil then vlMac := TFormulaNode(iParts.fStart).CreateMac(vlMode,ParCre);
	end;
	vlPush := TSetParPoc.create(vlMac);
	ParCre.AddSec(vlPush);
	CreateSec := false;
end;

constructor TParamNode.create(ParParam:TParameterVar);
begin
	SetParam(ParParam);
	inherited create;
end;

function TParamNode.GetType:TType;
begin
	if iParts.fStart <> nil then begin
		exit( TFormulaNode(iParts.fStart).GetType);
	end else begin
		exit(nil);
	end;
end;

procedure   TParamNode.SoftEmptyParameter;
begin
	iParts.SoftEmptyList;
end;



procedure   TParamNode.ValidatePre(ParCre : TCreator;ParIsSec : boolean);
var
	vlType      : TType;
	vlOtherTYpe : TType;
	vlPass      : boolean;
	vlName      : string;
	vlName2     : string;
begin
	inherited ValidatePre(ParCre,ParIsSec);
	vlType := GeTParameterVarType;
	if fParam = nil       then exit;
	if fParam.IsAutomatic then exit;
	if (vlType<> nil) then begin
		vlOtherType := GetType;
		if vlOtherType = nil then exit;
		vlPass      := IsPushByRef;
		if (GetTranType = pv_var) and not(TFormulaList(iParts).Can([CAN_Write])) then begin
			TNDCreator(ParCre).AddNodeError(self,Err_Cant_Write_To_Item,'Expression at parameter :'+fParam.GetErrorName);
		end;
		if not(fParam.IsCOmpWithParamExprType(vlPass,vlOtherType)) then begin
				vlName := vlOtherType.GetErrorName;
				vlName2 := vlType.GetErrorName;
				TNDCreator(ParCre).AddNodeError(self,Err_Wrong_Type,'Expression of type '+vlName+' at parameter :'+fParam.GetErrorName+', wich has type '+vlName2);
		end;
		if not(TFormulaList(iParts).Can([CAN_Read])) then begin
			TNDCreator(ParCre).AddNodeError(self,Err_Cant_Read_From_Expr,'Expression at parameter :'+fParam.GetErrorName);
		end;
	end;
end;

function TParamNode.IsDominant(ParForm:TFormulaNode):TDomType;
var
	vlDom:TDomType;
begin
	vlDom := inherited IsDominant(ParForm);
	if vlDom <> DOM_Unkown then vlDom := DOM_Yes;
	IsDominant := vlDom;
end;

procedure TParamNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.write('Param ');
	ParDis.Write(GetPosition);
	if IsCallByName then ParDis.Write(iName);
	ParDis.SetLeftmargin(3);
	iParts.Print(ParDis);
	ParDis.SetLeftMargin(-3);
	ParDis.nl;
	ParDis.Write('End param');
end;

{---( TProcVar )----------------------------------------------------}


procedure TProcVar.CreateCBInit(ParCre : TNDCreator;ParAt : TNodeIdent;ParContext : TDefinition);
begin
end;

function  TProcVar.CreateDB(ParCre : TCreator):boolean;
begin
	exit(false);
end;

function TProcVar.GetAccessSize:TSize;
var
	vlRest:TSize;
begin
	vlRest := GetSize mod SIZE_PushSize;
	if vlRest <> 0 then vlRest := SIZE_PushSize - vlRest;
	GetAccessSize := GetSize + vlRest;
end;

{------( TAutomaticParameter )-------------------------------------}

function TAutomaticParameter.GetContextObj(ParRoutine,ParOrgOwner : TDefinition):TDefinition;
var
	vlContext  : TDefinition;
begin
	
	vlContext := TRoutine(ParRoutine).GetObjectByLevel(iSourceContextLevel,ParOrgOwner);
	exit(vlContext);
	
end;


constructor TAutomaticParameter.create(const ParName : String;ParSourceContextLevel : cardinal;ParFrame:TFrame;Partype:TType;ParTranType:TParamTransferType;ParVirtual : boolean);
begin
	inherited Create(ParName,ParFrame,ParType,ParTranType,ParVirtual);
	iSourceContextLevel := ParSourceContextLevel;
end;

function  TAutoMaticParameter.Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner : TDefinition) : TParameterVar;
begin
	exit(nil);
end;


function TAutomaticParameter.IsAutomatic:boolean;
begin
	exit(true);
end;

function TAutomaticParameter.SaveItem(parStream:TObjectStream):boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.WriteLong(iSourceContextLevel) then exit(true);
	exit(false);
end;

function TAutomaticParameter.LoadItem(ParStream:TObjectStream):boolean;
begin
	if inherited LoadItem(ParStream) then exit(true);
	if ParStream.ReadLong(voSourceContextLevel) then exit(true);
	exit(false);
end;


{------( TParameterVar )-----------------------------------------------}


procedure TParameterVar.ProduceMappingCbInit(ParAt : TNodeIdent;ParCre : TCreator;ParContext:TDefinition;ParSource : TFormulaNode);
var
	vlNode   : TNodeIdent;
	vlSource : TFormulaNode;
begin
	if iSecondVar <> nil then begin
         if iRefVar2 then begin
				vlSource := TValuePointerNode.Create;
            vlSource.AddNode(ParSource);
			end else begin
				vlSource := ParSource;
			end;
			vlNode := TNDCreator(ParCre).MakeLoadNodeToDef(vlSource,fSecondVar,ParContext);
			ParAt.AddNode(vlNode);
	end else begin
			ParSource.Destroy;{TODO:Chage system such that this is not nec. anymore}
	end;
end;


function TParameterVar.GetVar2Type : TTYpe;
begin
	if iRefVar2 then begin
		exit(fAccessType);
	end else begin
		exit(fType);
	end;
end;


procedure TParameterVar.SetOffset(ParOffset :TOffset);
begin
	fOffset := ParOffset;
	iMainVar.fOffset := ParOffset;
end;

procedure TParameterVar.InitParameter(ParOwner : TDefinition);
begin
end;

procedure TParameterVar.ProduceFrame(ParCre : TSecCreator;ParContext : TDefinition);
var
   vlPoc : TPocBase;
	vlOpt : TMacCreateOption;
	vlMacS : TMacBase;
	vlLoad :  TLoadFor;
	vlMacD : TMacBase;
begin
		if (fSecondVar <> nil)  then begin

			vlMacS := iMainVar.CreateMac(ParContext,MCO_Result,ParCre);
			vlMacD := iSecondVar.CreateMac(ParContext,MCO_Result,ParCre);

			if iRefMainVar then begin
				if not(iRefVar2) then begin
					vlMacS := TByPointerMac.create(GetSize,GetSign,vlMacS);
					ParCre.AddObject(vlMacS);
				end;
			end else begin
				if iRefVar2 then runerror(200);{TODO fatal error}
			end;

			vlPoc := ParCre.MakeLoadPoc(vlMacD,vlMacS);
			ParCre.AddSec(vlPoc);
	end;
end;

function TParameterVar.CreateDefinitionUseItem: TDefinitionUseItemBase;
var
	vlItem : TDefinitionUseItemBase;
begin
	vlItem := inherited CreateDefinitionUseItem;
	vlItem.SetDefault(fTranType = PV_Var);
	exit(vlItem);
end;

function TParameterVar.IsCompWithParamExpr(ParExact : boolean;ParNode : TFormulaNode):boolean;
begin
	if fType = nil then exit(false);
	if fRefMainVar then begin
		exit(ParNode.CanWriteWith(ParExact,fType));
	end else begin
		exit(ParNode.CanWriteTo(ParExact,fType));
	end;
end;

function TParameterVar.IsCompWithParamExprType(ParExact : boolean;ParType : TType):boolean;
begin
	if fType = nil then exit(false);
	if fRefMainVar then begin
		exit(ParType.CanWriteWith(ParExact,fType));
	end else begin
		exit(fType.CanWriteWith(ParExact,ParType));
	end;
end;


function TParameterVar.IsOptUnsave:boolean;
begin
	exit(( iTranType = PV_Var) and not(IsAutomatic));
end;

function  TParameterVar.IsSame(ParVar : TVarBase):boolean;
begin
	if (ParVar = nil) then exit(false);
	if not (ParVar is TParameterVar) then exit(false);
	if fSourcePosition = TParameterVar(ParVar).fSourcePosition then exit(true);
	exit(false);
end;

function  TParameterVar.IsSameParameter(ParParam : TParameterVar;ParType : TParamCompareOptions):boolean;
var vlType1,vlType2:TType;
begin
	if ParParam = nil then exit(false);
	vlType1 := ParParam.fType;
	if vlType1 = nil then exit(false);
	vlType2 :=fType;
	if vlType2 = nil then exit(false);
	
	if not(IsAutomatic) then begin
		if PC_Relaxed in ParType then begin
			if not vlType1.IsDirectComp(vlType2) then exit(false);
		end else begin
			if  not vlType1.IsExactComp(vlType2) then exit(false);
		end;
	end;
	if not(PC_IgnoreState in ParType) then begin
		if ParParam.fIdentCode <> fIdentCode    then exit(false);
		if ParParam.fTranType <> fTranType      then exit(false);
		if ParParam.fIsVirtual <> fIsVirtual    then exit(false);
	end;
	if PC_IgnoreName in ParType             then exit(true);
	if (IsSameText(ParParam.fText))       then exit(true);
	exit(false);
end;


function TParameterVar.CheckParameterName(ParParam :TParameterVar;var ParDifText:string):boolean;
var
	vlStr1  : string;
	vlStr2  : string;
	vlName  : string;
	vlType1 : TType;
	vlType2 : TType;
begin
	CheckParameterName := false;
	if IsAutomatic then exit;
	if not(fText.IsEqual(ParParam.fText)) then begin
		GetTextStr(vlStr1);
		ParParam.GetTextStr(vlStr2);
		AddTextToTextList( ParDifText,' Name differs '+vlStr1+' => '+vlStr2);
		CheckParameterName := true;
	end;
	if ParParam.fTranType <> fTranType then begin
		GetTextStr(vlStr1);
		AddTextToTextList(ParDifText, ' Pass type of parameter '+vlStr1+' differs :'+ParamTransferTypeDesc[fTranType]+'=>'+ParamTransferTypeDesc[ParParam.fTranType]);
		CheckParameterName := true;
	end;
	if fIsVirtual <> ParParam.fIsVirtual then begin
		GetTextStr(vlStr1);
		AddTextToTextList(ParDifText ,' Virtual mode of parameter '+vlStr1+' is different');
		CheckParameterName := true;
	end;
	vlType1 := fType;
	vlType2 := ParParam.fType;
	if (vlType1 <> nil) and (vlType2 <> nil) then begin
		if not vlType1.IsExactSame(vlType2) then begin
			vlType1.GetDisplayName(vlStr1);
			vlType2.GetDisplayName(vlStr2);
			GetTextStr(vlName);
			AddTextToTextList(ParDifText , ' Parameter '+vlName+' has different type '+vlStr1+' => '+vlStr2);
			CheckParameterName := true;
		end;
	end;
end;


procedure TParameterVar.SetPosition(ParNo:cardinal);
begin
	iSourcePosition := ParNo;
end;


procedure TParameterVar.DoneParameter(ParOwner : TDefinition;ParCre : TSecCreator);
begin
end;

function TParameterVar.CreateAutomaticMac(ParContext : TDefinition;parCre:TSecCreator):TMacBase;
begin
	exit(nil);
end;

function TParameterVar.CreateAutomaticParamNode(ParContext,ParOrgOwner : TDefinition;ParCre : TCreator;var ParTTL:TTLVarNode):TParamNode;
begin
	exit(Nil);
end;

function  TParameterVar.IsAutomatic:boolean;
begin
	exit(false);
end;

function  TParameterVar.GetAccessSize:TSize;
begin
	exit(iMainVar.GetAccessSize);
end;

function TParameterVar.CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var
	vlVar    : TLocalVar;
	vlByRef  : boolean;
	vlMac    : TMAcBase;
	vlNewOpt : TMacCreateOption;
begin
	if(ParOpt = MCO_Size) then begin
		vlMac :=inherited
 CreateMac(ParContext,ParOpt,ParCre);
	end else begin
		if iSecondVar = nil then begin
			vlVar := iMainVar;
			vlByRef := iRefMainVar;
		end else begin
			vlVar := iSecondVar;
			vlByRef := iRefVar2;
		end;
		if (ParOpt in [MCO_ValuePointer,MCO_ObjectPointer]) and (vlByRef) then begin
			vlNewOpt := MCO_Result;
		end else begin
			vlNewOpt := ParOpt;
		end;
		vlMac := vlVar.CreateMac(ParContext,vlNewOpt,ParCre);
		if (ParOpt = MCO_Result) and (vlByref) then begin
			vlMac := TByPointerMac.Create(fType.fSize,fType.GetSign,vlMac);
			ParCre.AddObject(vlMac);
		end;
	end;
	exit(vlMac);
end;

function  TParameterVar.GetPushSize:TSize;
var
	vlRest : TSize;
	vlSize : TSize;
begin
	vlSIze := iMainVar.GetSize;
	vlRest := vlSize mod SIZE_PushSize;
	if vlRest <> 0 then inc(vlSize, SIZE_PushSize - vlRest);
	exit(vlSize );
end;


function   TParameterVar.Clone(ParFrame : TFrame;ParContext,ParNewOwner,ParOrgOwner : TDefinition) : TParameterVar;
var vlParam : TParameterVar;
	vlName  : string;
begin
	GetTextStr(vlName);
	vlParam := TParameterVar.Create(vlName,ParFrame,fType,fTranType,iIsVirtual);
	vlParam.SetPosition(iSourcePosition);
	vlParam.fRealPosition := iRealPosition;
	exit(vlParam);
end;


procedure TParameterVar.Clear;
begin
	inherited Clear;
	if iAccessTYpe <> nil then iAccessType.Destroy;
	if iMainVar <> nil then iMainVar.Destroy;
end;


constructor TParameterVar.create(const ParName : String;ParFrame : TFrame;Partype:TType;ParTranType : TParamTransferType;ParVirtual : boolean);
begin
	iTranType  := ParTranType;
	iIsVirtual := ParVirtual;
	inherited create(ParName,ParFrame,0,ParType);
	SetupAccessVars;
end;

procedure TParameterVar.SetupAccessVars;
var
	vlSpecialType : boolean;
	vlType        : TType;
begin
	if fTYpe = nil then runerror(1);
	if fType <> nil then begin
		vlSpecialType :=(fType.fSize = 0) or (fType.fSize=3) or (fTYpe.IsLargeType);
	end else begin
		vlSpecialType := false;
	end;
	iNeedVar2   := (vlSpecialType and (iTranType = PV_Value))  or iIsVirtual;
	iRefMainVar := vlSpecialType or (iTranType = PV_Var);
	iRefVar2    := ((iTranType = PV_Var) or ((iTranType=PV_COnst) and vlSpecialType)) and iIsVirtual;
	if iRefMainVar or iRefVar2 then begin
		iAccessType := TPtrType.Create(fType,false);
		vlType := iAccessType;
	end else begin
		iAccessType := nil;
		vlType := iType;
	end;
	iMainVar := TLocalVar.Create('',fFrame,0,vlType);
end;

procedure   TParameterVar.Print(ParDis:TDisplay);
begin
	ParDis.Print(['Par#',iRealPosition,'/',iSourcePosition,' ']);
	if iIsInherited then ParDis.Write('inherited ');
	if iIsVirtual   then ParDis.Write('virtual ');
	case iTranType of
	PV_Var   : ParDis.Write('Var ');
	PV_Const : ParDis.Write('Const ');
	end;
	if iRefMainVar then ParDis.Write('@');
	inherited Print(ParDis);
	ParDis.Print(['  (',fOffset,')']);
end;

function    TParameterVar.SaveItem(parStream : TObjectStream):boolean;
begin
	SaveItem := true;
	if inherited SaveItem(ParStream)               then exit;
	if ParStream.Writelongint(longint(iTranType))  then exit;
	if ParStream.Writelongint(iSourcePosition)     then exit;
	if ParStream.WriteBoolean(iIsVirtual)          then exit;
	if ParStream.WriteBoolean(iIsInherited)        then exit;
	if ParStream.WritePi(iSecondVar)	   	   	  then exit;
	if ParStream.WriteLong(iRealPosition)          then exit;
	if ParStream.WriteBoolean(iNeedVar2)           then exit;
	if ParStream.WriteBoolean(iRefMainVar)         then exit;
	if ParStream.WriteBoolean(iRefVar2)            then exit;
	if ParStream.WriteBoolean(iAccessType <> nil)   then exit;
   if iAccessType <> nil then begin
		if iAccessType.SaveItem(ParStream) then exit;
   end;
	if iMainVar.SaveItem(ParStream) then exit;
	SaveItem := false;
end;

function    TParameterVar.LoadItem(ParStream : TObjectStream):boolean;
var vlTranType   : TParamTransferType;
	vlParamNo    : longint;
	vlIsVirtual  : boolean;
	vlIsInherited: boolean;
	vlRealPos    : cardinal;
	vlNeedVar2   : boolean;
	vlMainVar : TLocalVar;
	vlRefMainVar : boolean;
	vlRefVar2    : boolean;
	vlHasAccType : boolean;
	vlAccType   : TTYpe;
begin
	LoadItem := true;
	if inherited LoadItem(ParStream)              then exit;
	if ParStream.ReadLongint(longint(vlTranType)) then exit;
	if ParStream.ReadLongint(vlParamNo)           then exit;
	if ParStream.ReadBoolean(vlIsVirtual)         then exit;
	if ParStream.ReadBoolean(vlIsInherited)       then exit;
	if ParStream.ReadPi(voSecondVar)              then exit;
	if ParStream.ReadLong(vlRealPos)	             then exit;
	if ParStream.ReadBoolean(vlNeedVar2)          then exit;
	if ParStream.ReadBoolean(vlRefMainVar)        then exit;
	if parStream.ReadBOolean(vlRefVar2)           then exit;
	if ParStream.ReadBoolean(vlHasAccType)        then exit;
	vlAccType := nil;
	if vlhasAccType then begin
		if Createobject(ParStream,TStrAbelRoot(vlAccTYpe)) <> sts_ok then exit;
	end;
	if CreateObject(ParStream,TStrAbelRoot(vlMainVar)) <> sts_ok then exit;
	iTranType       := vlTranType;
	iSourcePosition := vlParamNo;
	iIsVirtual      := vlIsVirtual;
	iIsInherited    := vlIsInherited;
	iRealPosition   := vlRealPos;
	iNeedVar2 := vlNeedVar2;
	iRefMainVar := vlRefMainVar;
	iRefVar2    := vlRefVar2;
	iAccessType := vlAccType;
	iMainVar    := vlMainVar;
	exit(false);
end;


procedure TParameterVar.CommonSetup;
var vlAcc : TCan_Types;
begin
	inherited CommonSetup;
	iIdentCode      := IC_ParamVar;
	iIsInherited	:= false;
	iSecondVar      := nil;
	vlAcc           := [Can_Read,Can_Write];
	iRealPosition   := 0;
	if fTranType = PV_COnst then vlAcc := [CAN_Read];
	iAccess := vlAcc;
	fDefAccess := AF_Public;
		{Access is first set to AF_Current, but parameter should allways be public}
end;
	
	
{------( TLocalVar )------------------------------------------------}
	
procedure TLocalvar.CommonSetup;
begin
	inherited COmmonSetup;
	iIdentCode  := IC_LocalVar;
end;

end.
