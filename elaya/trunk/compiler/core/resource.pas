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

unit Resource;
interface
uses largenum,asmdisp,i386cons,progutil,elatypes,linklist,elacons,cmp_base,cmp_type,
	display,register,compbase,error,elacfg,routasm,stdobj,confval,simplist;
	
type
	TResource        = class;
	TResourceUse     = class;
	TRegisterRes     = class;
	TInstruction     = class;
	TCurrentInstList = class;
	TInstcreator     = class;
	TByPtrRes        = class;
	TStackRes        = class;
	TNumberRes	      = class;
	TOperand     = class;
	
	
	TChangeItem=class(TSMListItem)
	private
		voChangeRegisterCode : TChangeCode;
		voSize	             : TSize;
		voOperand            : TOperand;
		voSoftChangeSize     : boolean;
		voChangeToRegister   : TFlag;
		
		property  iChangeRegisterCode   :  TChangeCode  read voChangeRegisterCode write voChangeRegisterCode;
		property  iOperand              :  TOperand    	read voOperand        	  write voOperand;
		property  iSize	                :  TSize	    read voSize               write voSize;
		property  iSoftChangeSize       :  boolean      read voSoftChangeSize     write voSoftChangeSize;
		property  iChangeToRegister     :  TFlag	    read voChangeToRegister   write voChangeToRegister;
	protected
		procedure   Commonsetup; override;

	public
		property    fChangeRegisterCode   : TChangeCode	read voChangeRegisterCode;
		property    fOperand              : TOperand	read voOperand;
		property    fSize   	          : TSize	read voSize;
		property    fSoftChangeSize	      : boolean	read voSoftChangeSize;
		property    fChangeToRegister     : TFlag	read voChangeToRegister;
		function    GetIdentNumber        : cardinal;
		function    GetResourceTypeCode   : TResourceIdentCode;
		function    GetResourceSize : TSize;
		constructor Create(ParOperand:TOperand);
		procedure   SetChangeSize(ParSize : TSize);
		procedure   SetChangeRegisterCode(ParChange:TChangeCode);
		procedure   SetChangeRegisterCodeDirect(ParChange:TChangeCode);
		procedure   ForceToRegister(ParRegister:TFlag);
		procedure   OptimizeChange;
		function    IsOutput:boolean;
		function    TestIdentNumber(ParIdent : TFlag) : boolean;
	end;
	
	TChangeList=class(TSMList)
	public
		function  GetItemByIdentNumber(ParNo:cardinal):TChangeItem;
		procedure AddChangeRegisterCode(ParOperand:TOperand);
		function  GetItemByIdentNumberErr(ParNo:cardinal):TChangeItem;
	end;

	TResourceUse=class(TSMListItem)
	private
		voSec      : TSecBase;
		voResource : TResource;
		voResMode  : TReserveMode;
		voFixed    : boolean;
		voOutLock  : boolean;
		voUnUsed   : boolean;
		property iUnUsed     : boolean     read voUnUsed   write voUnUsed;
		property iOutLock    : boolean     read voOutLock  write voOutLock;
		property iResource   : TResource   read voResource write voResource;
		property iFixed      : boolean     read voFixed    write voFixed;
	protected
		procedure   CommonSetup;override;

	public
		property fFixed	  : boolean      read voFixed   write voFixed;
		property fResMode : TReserveMode read voResMode write voResMode;
		property fOutLock : boolean	     read voOutLock;
		property fResource: TResource    read voResource;
		property fSec     : TSecBase     read voSec;
		property fUnUsed  : boolean      read voUnUsed  write voUnUsed;
		
		function    CanRelease:boolean;
		constructor Create(ParSec:TSecBase);
		function    IsPart(ParItem:TResource):boolean;
		procedure   SetResource(ParRes:TResource);
		function    SetSec(ParSec:TSecBase):TSecBase;
		procedure   SetOutputLock(ParFlag : boolean);
		function    IsUsing(ParRes : TResource):boolean;
	end;
	
	
	
	TResourceUseList=class(TSMList)
	private
		voStackCnt:longint;
		voUnUseOpt:boolean;
		
		property  iUnUseOpt:boolean read voUnUseOpt write voUnUseOpt;
		function  GetResourceUse(ParSec:TSecBase):TResourceUse;
		procedure SetStackCnt(ParCnt:Longint);
		function  GetStackCnt:longint;
		procedure DecStackCnt;
		procedure IncStackCnt;
		function  GetResource(ParSec:TSecBase):TResource;
		function  AddResource(ParSec:TSecBase;ParRes:TResource):TResourceUse;
		
	protected
		procedure Commonsetup;override;

	public
		procedure PushOldest(ParCre:TInstCreator);
		procedure PushAll(ParCre:TInstCreator);
		function  PushRes(ParCre:TInstCreator;ParRes:TResource;ParAfter:boolean):TStackRes;
		procedure PopRes(ParCre:TInstCreator;PArStack:TStackRes;ParBy:TResource;ParAfter:boolean);
		procedure SaveResParts(ParCre:TInstCreator;ParRes:TResource); virtual;
		procedure ReleaseResource(ParRes : TResource);
		function  GetUseFromResource(ParRes:TResource):TResourceUse;
		
		function  SetResourceUse(ParSec:TSecBase;ParRes:TResource):TResourceUse;
		procedure CrashList;
		function  GetStackResItemByPos(ParPos:longint):TResourceUSe;
		function  ReplaceResource(ParOld,parNew:TResource):boolean;
		function  ReplaceUnUsedResource(ParOld,parNew:TResource):boolean;
		procedure ResourcePRLF(ParRes:TResource);
		procedure SetOutputLock(ParSec : TSecBase;ParLOck:boolean);
		procedure DumpList;
		procedure DeleteUnUsedUse;
		function  ReserveResource(ParSec : TSecBase) : TResource;
		procedure DeleteUnUsedByMac(ParSec : TSecBase;ParMode : TUnUsedDeleteMode);
		procedure DeleteUnUsedByRes(ParRes : TResource);
		procedure AddUnUsedResource(ParSec : TSecBase;ParRes : TResource);
	end;
	
	
	
	
	
	
	
	TInstCreator=class(TCreator)
	private
		voResourceUseList   : TResourceUselist;
		voRegisterList	    : TRegisterList;
		voCurrentInstList   : TCurrentInstList;
		voAlwaysStackFrame  : boolean;
		voPrintRegisterres  : boolean;
		voRoutineAsm        : TRoutineAsm;
		
		property iRoutineAsm : TROutineAsm read voRoutineAsm write voRoutineAsm;
		property iResourceUseList   : TResourceUSeList read voResourceUseList write voResourceUseList;
		property iAlwaysStackFrame  : boolean          read voAlwaysStackFrame write voAlwaysStackFrame;
	protected
		procedure   COmmonSetup;override;

	public
		property fAlwaysStackFrame  : boolean	       read voAlwaysStackFrame;
		property fResourceUseList   : TResourceUseList read voResourceUseList;
		{Instructie}
		Procedure   InitConfigs;
		procedure PushInst(ParInst:TInstruction);
		procedure PopInst;
		function  GetCurrentInst:TInstruction;
		procedure AddInstAfterCur(ParInst:TInstruction);
		procedure AddInstBeforeCur(ParInst:TInstruction);
		procedure  AddMov(ParOut,ParIn:TResource;ParAfter:boolean);
		function AddMov(ParOut,ParIn:TResource;ParAfter,ParIf:boolean): TInstruction;
		function  AddMovReg(ParIn:TResource;ParAfter:boolean):TResource;
		function  AddMovReg(ParIn:TResource;ParAfter:boolean;ParHint : TRegHint):TResource;
		function  AddMovFrSt(ParDir:boolean):TResource;
		procedure AddSpAdd(ParNo:TSize;ParNeg:boolean);
		function  CreateLabel(ParNumber:longint):TInstruction;
		{use}
		function  GetResourceUse(ParSec : TSecBase):TResourceUse;
		function  ReplaceResource(ParOld,ParNew:TResource):boolean;
		procedure ReplaceUnUsedResource(ParOld,ParNew:TResource);
		procedure SetOutputLock(ParSec : TSecBase;ParLock : boolean);
		procedure DeleteUnUsedUse;
		procedure DeleteUnusedByMac(ParSec : TSecBase;ParMode : TUnUsedDeleteMode);
		procedure DeleteUnusedByRes(ParRes : TResource);
		procedure AddUnUsedResourceUse(ParSec : TSecBase;ParRes : TResource);
		
		{Resource}
		function  CanChangeResource(ParRes:TResource):boolean;
		procedure ResourcePRLF(ParRes:TResource);
		function  ReserveRegister(ParSize : TSize;ParSign:boolean):TRegisterRes;
		function  ReserveRegisterByHint(ParSize : TSize;ParSign:boolean;ParHint : TRegHint):TRegisterRes;
		procedure ChangeResource(ParOldRes,ParNewRes:TResource);
		function  CreateStackVar(ParOffs:TOffset;ParSize:TSize;ParSign:boolean):TResource;
		procedure CrashLIst;
		function  GetNumOfUses:longint;
		function  GetSpecialRegister(PArType:TAsmStorageCanDo;ParSize : TSize;ParSign:boolean):TRegisterRes;
		function  GetAsRegister(ParReg:TRegisterRes;ParSize : TSize;ParSign:boolean):TRegisterRes;
		function  GetAsRegisterByName(ParRegister:TNormal;ParSize : TSize):TRegister;
		function  GetRegisterResByName(ParRegister : TNormal): TRegisterRes;
		function  ReserveResourceByUse(ParSec :TSecBase):TResource;
		procedure PushAll;
		function  PopRes(PArStack:TStackRes;ParAfter:boolean):TResource;
		procedure SaveResParts(ParRes:TResource);
		function  ForceReserveRegister(PArCre:TInstCreator; ParRegister:TNormal;ParSign:boolean):TRegisterRes;
		
		procedure ReleaseResource(ParRes : TResource);
		procedure SetResourceUse(ParSec:TSecBase;ParRes:TResource);
		procedure SetResourceResLong(ParSec:TSecBase;ParMode:boolean;ParFixed:boolean);
		function  GetNumberRes(ParNo:TNumber;ParSize:TSize;ParSign:boolean):TNumberRes;
		function  GetNumberResLong(ParNo:cardinal;ParSize:TSize;ParSign:boolean):TNumberRes;
		
		{Resource mg}
		function ReserveRegisterDirect(ParSize : TSize;ParSign : boolean):TRegisterRes;
		
		procedure  GetProcedureName(var parNAme : string);
		procedure  AddObject(ParITem : TRoot);
		{rest}
		procedure   Print(parDis:TAsmDisplay);
		
		function    GetPrintRegisterRes:boolean;
		constructor Create(const ParName:string;ParCompiler:TCompiler_Base;ParRoutine : TRoutineAsm);
		procedure clear;override;
		{ptr/offset}
		function    GetOffsetOf(ParRes:TResource;ParSize : TSize;ParSign:boolean):TResource;
		function    GuaranteeRegister(ParRes : Tresource):TRegisterRes;
		function    GuaranteeRegister(ParRes : Tresource;ParHint : TRegHint):TRegisterRes;
		
		function    GetByPtrOf(ParMac : TSecBase;ParSize : TSize;ParSign : boolean) : TResource;
		function    GetByPtrOf(PArRes:TResource;ParSize : TSize;ParSign:boolean) : TResource;
		{debug}
		procedure   DumpUseList;
		
	end;
	
	
	TResource=class(TRoot)
	private
		voSize     : TSize;
		voSign     : boolean;
		voMode     : TResourceMode;
		voCode     : TResourceIdentCode;
		property iMode : TResourceMode read voMode write voMode;
		property iSize : TSize         read voSize write voSize;
		property iSign : boolean       read voSign write voSign;
	protected
		property   iCode : TResourceIdentCode read voCode write voCode;
		procedure  CommonSetup;override;

	public
		property   fCode     : TResourceIdentCode read voCode;
		property   fSize     : TSize      read voSize;
		property   fSign     : boolean    read voSign;
		
		procedure  SetLockResource;virtual;
		procedure  ResetlockResource;virtual;
		procedure  ReserveResource;virtual;
		procedure  AdviceChange( ParChange:TChangeItem);virtual;
		function   GetExtraOffset:Toffset;virtual;
		procedure  SetExtraOffset(ParOffset:TOFfset);virtual;
		function   MustSave(ParRes:TResource):boolean;
		function   CanSoftChangeSize(ParSize:TSize):boolean;virtual;
		function   TryChangeSize(ParSize:TSize):TResource;virtual;
		procedure  IsUsed;
		procedure  InUse ;
		procedure  BeforeRlf(ParCre:TInstCreator);virtual;
		procedure  AfterRlf(ParCre:TInstCreator;ParAcc : TAccessSet);virtual;
		procedure  DecUse;virtual;
		procedure  IncUse;virtual;
		procedure  Print(ParDis:TAsmDisplay);virtual;
		procedure  SetSize(ParSize:TSize);
		procedure  SetSign(ParSign:boolean);
		function   IsSame(ParRes:TResource):boolean;virtual;
		function   IsPart(ParRes:TResource):boolean;virtual;
		function   IsUsing(ParRes:TResource):boolean;virtual;
		procedure  SetMode(ParMode:TResourceMode;ParSet:boolean);
		function   GetMode(ParMode:TResourceModes):boolean;
		function   KeepContents(ParAcc:TAccess):TKeepContentsState;virtual;
		function   CanReleaseFromUse : boolean;virtual;
		function   CanKeepInUse :boolean;virtual;
		procedure  BeforeRelease;virtual;
		
	end;
	
	TLabelRes=class(TResource)
	private
		voLabelName : TString;
		property iLabelName : TString read voLabelName write voLabelName;
	protected
		procedure   Commonsetup;override;

	public
		property GetLabelName : TString read voLabelName;
		
		constructor Create(const ParName:String;ParSize : TSize);
		procedure   Clear;override;
		function    IsSame(ParRes:TResource):boolean;override;
		function    IsPart(ParRes:TResource):boolean;override;
		function    IsUsing(parRes:TResource):boolean;override;
		procedure   Print(ParDis:TAsmDisplay);override;
	end;
	
	TUnkRes=class(TResource)
	protected
		procedure CommonSetup;override;
	public
		procedure Print(ParDis:TAsmDisplay);override;
	end;
	
	
	
	
	TCmpFlagRes=class(TResource)
	private
		voCmpCode:TIdentCode;
		property   iCmpCode : TIdentCode read voCmpCode write voCmpCode;
	protected
		procedure commonsetup;override;

	public
		property fCmpCode : TIdentCode read voCmpCode;
		constructor Create(ParCode : TIdentCode);
		function  IsSame(ParRes:TResource):boolean;override;
		function  IsPart(ParRes:TResource):boolean;override;
		procedure NotCondition;
		procedure print(ParDis:TAsmDisplay);override;
	end;
	
	
	TVarRes=class(TResource)
	public
		function    CanSoftChangeSize(ParSize:TSize):boolean;override;
		constructor Create(ParSize : TSize;ParSign:boolean);
	end;
	
	TStorageRes=class(TVarRes)
	private
		voExtraOffset:TOffset;
	public
		function  GetExtraOffset:Toffset;override;
		procedure SetExtraOffset(ParOffset:TOFfset);override;
	end;
	
	
	TStackRes=class(TVarRes)
	private
		voStackPos:longint;
		property iStackPos:longint read voStackPos write voStackPos;

	protected
		procedure Commonsetup;override;

	public
		property fStackPos:longint read voStackPos write voStackPos;
		function  IsSame(PArRes:TResource):boolean;override;
		function  IsPart(ParRes:TResource):boolean;override;
		function  KeepContents(ParAcc:TAccess):TKeepContentsState;override;
		function  CanReleaseFromUse : boolean;override;
		function  CanKeepInUse :boolean;override;
	end;
	
	
	
	
	TByPtrRes = class(TStorageRes)
	private
		voPointer : TRegisterRes;
		property    iPointer : TRegisterRes read voPointer write voPointer;
	protected
		procedure   Commonsetup;override;

	public
		property    GetPointer : TRegisterRes read voPointer;
		procedure   SetLockResource;override;
		procedure   ResetLockResource;override;
		procedure   ReserveResource;override;
		function   TryChangeSize(ParSize:TSize):TResource;override;
		procedure   SetPointer(ParReg:TRegisterRes);
		constructor Create(ParReg:TRegisterRes;ParSize : TSize;ParSign:boolean);
		function    IsSame(PArRes:TResource):boolean;override;
		function    IsPart(ParRes:TResource):boolean;override;
		function    IsUsing(ParRes:TResource):boolean;override;
		procedure   Print(PArDis:TAsmDisplay);override;
		procedure   BeforeRlf(ParCre:TInstCreator);override;
		procedure   AfterRlf(ParCre:TInstCreator;ParAcc:TAccessSet);override;
		procedure   DecUse;override;
		procedure   IncUse;override;
		procedure  BeforeRelease;override;
		procedure   AdviceChange(ParChange:TChangeItem);override;
		
	end;
	
	TMemoryRes=class(TStorageRes)
	private
		voName:TString;
		
	protected
		property    iName : TString read voName write voName;
		procedure   CommonSetup;override;

	public
		property    fName : TString read voName;
		function    IsSame(ParRes:TResource):boolean;override;
		function    IsPart(ParRes:TResource):boolean;override;
		constructor Create(const ParName:String;ParSize : TSize;ParSign:boolean);
		procedure   SetName(const ParName:String);
		destructor  destroy;override;
		procedure   Print(parDis:TAsmDisplay);override;
		function    CanSoftChangeSize(ParSize:TSize):boolean;override;
		function    TryChangeSize(ParSize:TSize):TResource;override;
		
	end;
	
	TMemoryOffsetRes=class(TMemoryRes)
	protected
		procedure CommonSetup;override;
	public
		procedure Print(ParDis:TAsmDisplay);override;
		function  CanSoftChangeSize(ParSize:TSize):boolean;override;
		function  TryChangeSize(ParSize:TSize):TResource;override;
	end;
	
	
	TRegisterRes=class(TVarRes)
	private
		voRegister:TRegister;
		property iRegister : TRegister read voRegister write voRegister;
	protected
		procedure   CommonSetup;override;

	public
		property fRegister : TRegister read voRegister;
		
		function    GetRegisterCode : cardinal;
		procedure   SetLockResource;override;
		procedure   ResetLockResource;override;
		procedure   ReserveResource;override;
		procedure   AdviceChange(ParChange:TChangeItem);override;
		function    IsPart(ParRes:TResource):boolean;override;
		function    CanSoftChangeSize(ParSize:TSize):boolean;override;
		procedure   SetRegister(ParReg:TRegister);
		constructor Create(ParReg:TRegister;ParSize : TSize;ParSign:boolean);
		function    IsSame(ParRes:TResource):boolean;override;
		procedure   print(parDis:TAsmDisplay);override;
		procedure   DecUse;override;
		procedure   IncUse;override;
		procedure   AfterRlf(ParCre :TInstCreator;ParAcc:TAccessSet);override;
		function    KeepContents(ParAcc:TAccess):TKeepContentsState;override;
		function   TryChangeSize(ParSize:TSize):TResource;override;
	end;
	
	
	TNumberRes=class(TResource)
	private
		voNumber: TNumber;
	protected
		property    iNumber : TNumber read voNumber write voNumber;
		procedure   CommonSetup;override;

	public
		property    fNumber : TNumber read voNumber write voNumber;
		function    CanSoftChangeSize(ParSize:TSize):boolean;override;
		function   TryChangeSize(ParSize:TSize):TResource;override;
		
		constructor Create(ParInt : TNumber);
		procedure   Print(ParDis:TAsmDisplay);override;
	end;
	
	
	
	
	TOperand = class(TSMListItem)
	private
		voResource    : TResource;
		voIdentNumber : TFlag;
		voIsFixed     : boolean;
		property    iIdentNumber   : TFlag     read voIdentNumber write voIdentNumber;
		property    iResource      : TResource read voResource    write voResource;
		property    iIsFixed       : boolean   read voIsFixed     write voIsFixed;
	protected
		procedure   Commonsetup;override;

	public
		property    fIsFixed       : boolean   read voIsFixed;
		property    fIdentNumber   : TFlag     read voIdentNumber;
		property    fResource      : TResource read voResource;
		
		
		procedure   MakeFixed;
		function    TestIdentNumber(ParIdent:TFlag):boolean;
		procedure   Combine(ParRes:TOperand);
		procedure   Print(parDis:TAsmDisplay);
		function    GetMode(ParMode:TResourceModes):boolean;
		constructor Create(ParRes:TResource;ParIdent:TFlag);
		function    GetAccess(PArAcc:TAccess):boolean;
		procedure   ReplaceResource(PArRes:TResource);
		function    GetResCode : TResourceIdentCode;
		function    GetSign:boolean;
		function    GetSize:TSize;
		procedure   IsUsed;
		function    IsSame(ParItem:TOperand):boolean;
		function    MustSave(ParRes:TResource;ParAccess:TAccessSet):boolean;
		function    GetFinalPriority:longint;virtual;
		function    KeepContents(ParAcc:TAccess):TKeepContentsState;
		procedure   BeforeRlf(ParCre : TInstCreator);
		procedure   AfterRlf(parCre : TInstCreator);
		procedure   SetIdentNumber(ParIdentNumber :TFlag);
	end;
	
	TOperandList = class(TSMList)
		procedure PopResource(ParCre : TInstCreator;ParRes : TOperand);
		procedure CompleteOutput(ParCre:TInstCreator);virtual;
		procedure HandleChange(ParCre:TInstCreator;ParChange:TChangeList);
		procedure HandleChangeItem(ParCre:TInstCreator;ParChangeItem:TChangeItem;ParResItem:TOperand);
		procedure ForceOutputToReg(ParCre:TInstCreator;ParResItem : TOperand;ParSize : TSize;ParRegister:TNormal);
		procedure ForceOutputTo(ParCre:TInstCreator;ParIdent:TFlag;const PArReg:TRegister);
		procedure ForceOutputTo(ParCre:TInstCreator;ParOperand : TOperand;const PArReg:TRegister);
		procedure DeleteInputFromUse(ParCre:TInstCreator);
		procedure PopAll(ParCre:TInstCreator);
		function  AddOperand(ParRes:TResource;ParIdent:TFlag):TOperand;
		function  CombineZO(ParCre:TInstCreator):boolean;
		function  GetResByIdent(ParIdent:TFlag):TOperand;
		function  GetIdentByRes(ParRes:TResource;ParAccess:TAccess;var ParIdent:TFlag):boolean;
		function  GetOpperSize:TSize;virtual;
		function  GetPrintPosition( ParRes:TOperand;var ParPosition : TNormal):boolean;virtual;
		procedure SetUseState(ParCre:TInstCreator); virtual;
		procedure ResourceListFase(ParCre:TInstCreator);
		procedure PreResourceListFase(ParCre:TInstCreator);virtual;
		procedure AtResourceListFase(ParCre:TInstCreator  ;ParChange:TChangeList);virtual;
		Procedure PostResourceListfase(ParCre:TInstCreator;ParChange:TChangeList);virtual;
		procedure Print(ParDis:TAsmDisplay);virtual;
		procedure SaveResParts(ParCre:TInstCreator;ParRes:TResource;ParAccess:TAccessSet);
		procedure HandleKeepContents(ParCre : TInstCreator;ParAcc : TAccess;ParRes : TResource;ParItem:TOperand);
		procedure ReplaceResource(ParCre : TInstCreator;ParRes:Tresource;ParItem : TOperand);
		procedure ReplaceResourceWithReg(ParCre : TInstCreator ; ParOperand :TOperand);
	end;
	
	
	TInstruction=class(TSMListItem)
	private
		voOperandList : TOperandList;
		voIdentCode   : T386InstructionCode;
		
	protected
		property iIdentCode   : T386InstructionCode read voIdentCode   write voIdentCode;
		property iOperandList : TOperandList        read voOperandList write voOperandList;
		procedure  CommonSetup;override;
		procedure  clear;override;

	public
		property fIdentCode   : T386InstructionCode read voIdentCode;
		property fOperandList : TOperandList        read voOperandList;
		
		procedure  AddResItem(ParRes:TOperand);
		procedure  InitOperandList;virtual;
		function   AddOperand(ParRes:TResource;ParIdent:TFlag):TOperand;
		procedure  Print(ParDis:TAsmDisplay);virtual;
		function   GetResByIdent(ParIdent :TFlag):TResource;
		procedure  InstructionFase(ParCre:TInstCreator);virtual;
		procedure  GetInstructionName(var ParName : string);virtual;
	end;
	
	
	
	
	
	TCurrentInstList=class(TSMList)
		function  GetCurrentInst:TInstruction;
		procedure PushInst(ParInst:TInstruction);
		procedure PopInst;
	end;
	
	
	TCurrentInstItem=class(TSMListItem)
	private
		voInst:TInstruction;
		property iInst : TInstruction read voInst write voInst;
	public
		property fInstruction : TInstruction read voInst;
		constructor Create(ParInst:TInstruction);
	end;
	
	
	
	
	
implementation

uses procinst,asminfo,macobj{remove when setoutputlock is cleanedup ?};


{----( TLabelRes )---------------------------------}

procedure TLabelRes.Commonsetup;
begin
	inherited commonsetup;
	iCode := Rt_LabelRes;
end;

constructor TLabelRes.Create(const ParName:String;ParSize : TSize);
begin
	inherited Create;
	iLabelName := TString.Create(ParName);
	SetSize(ParSize);
end;

procedure  TLabelRes.Clear;
begin
	inherited Clear;
	if iLabelName <> nil then iLabelName.Destroy;
end;

function    TLabelRes.IsSame(ParRes:TResource):boolean;
begin
	if inherited IsSame(ParRes) then begin
		if iLabelName.IsEqual(TLabelRes(ParRes).GetLabelName) then exit(true);
	end;
	exit(false);
end;


function TLabelRes.IsPart(ParRes:TResource):boolean;
begin
	exit(IsSame(parRes));
end;

function  TLabelRes.IsUsing(parRes:TResource):boolean;
begin
	exit(IsSame(ParRes));
end;

procedure TLabelRes.Print(ParDis:TAsmDisplay);
begin
	ParDis.WritePst(iLabelName);
end;

{----( TChangeItem )--------------------------------}


function  TChangeItem.TestIdentNumber(ParIdent : TFlag) : boolean;
begin
	if(iOperand <> nil) then begin
		exit(iOperand.TestIdentNumber(ParIdent));
	end else begin
		exit(false);
	end;
end;

function TChangeItem.GetResourceSize : TSize;
begin
	if(iOperand <> nil)then begin
		exit(iOperand.GetSize);
	end else begin
		exit(0);
	end;
end;


function TChangeItem.GetResourceTypeCode : TResourceIdentCode;
begin
	if(iOperand <> nil) then begin
		exit(iOperand.GetResCode);
	end else begin
		exit(RT_Unkown);
	end;
end;

procedure   TChangeItem.ForceToRegister(ParRegister:TFlag);
begin
	iChangeToRegister := ParRegister;
	SetChangeRegisterCode(RC_Force_Register);
end;

function    TChangeItem.IsOutput:boolean;
begin
	if iOperand <> nil then exit(iOperand.GetAccess(RA_Output))
	else exit(False);
end;

constructor TChangeItem.Create(ParOperand:TOperand);
begin
	iOperand := ParOperand;
	inherited Create;
end;

procedure   TChangeItem.Commonsetup;
begin
	inherited commonsetup;
	iChangeRegisterCode := RC_None;
	iSize               := iOperand.GetSize;
	iSoftChangeSize     := false;
end;

function  TChangeItem.GetIdentNumber:cardinal;
begin
	if iOperand <> nil then exit(iOperand.fIdentNumber)
	else exit(0);
end;


procedure TChangeItem.SetChangeSize(ParSize : TSize);
begin
	iSize := ParSize;
end;

procedure TChangeItem.SetChangeRegisterCode(ParChange:TChangeCode);
begin
	SetChangeRegisterCodeDirect(ParChange);
	iOperand.fResource.AdviceChange(self);
end;

procedure TChangeItem.SetChangeRegisterCodeDirect(ParChange:TChangeCode);
var
	vlReg:TChangeCode;
	vlWas:TChangeCode;
	vlCan:boolean;
begin
	vlReg := ParChange ;
	if vlReg <> RC_None then begin
		vlCan :=false;
		vlWas := iChangeRegisterCode;
		case vlWas of
			RC_Change_To_Reg  : vlCan := vlReg in [RC_Force_Register,RC_Combine_Zo];
			RC_Force_Register : vLCan := false;
			else vlCan := true;
		end;
	if vlCan then begin
		if vlReg = RC_Change_Nothing then vlReg := RC_None;
		iChangeRegisterCode :=  vlReg;
	end;
end;
end;


procedure   TChangeItem.OptimizeChange;
var 	vlNewSizeStr : String;
	vlResName    : String;
begin
	if iOperand.GetSize  = iSize then begin
		if iChangeRegisterCode = RC_Change_TO_Self then iChangeRegisterCode := RC_None;
	end else begin
		if iChangeRegisterCode in [RC_None,RC_Change_To_Self,RC_AutoMatic,RC_Combine_ZO] then begin
			if not iOperand.fResource.CanSoftChangeSize(iSize) then begin
				case iChangeRegisterCode of
					RC_None      : begin
						vlResName := '[unkown]';
						str(iSize, vlNewSizeStr);
						if iOperand.fResource <> nil then vlResName:= iOperand.fResource.ClassName;
						fatal(FAT_Cant_Change_Size,'[Size = '+vlNewSizeStr + '][Object Type = '+vlResName   + '] AT:'+ClassName+'.OptimizeChange');
					end;
					RC_automatic : iChangeRegisterCode := RC_CHange_To_Reg;
				end;
			end else begin
				iSoftChangeSize := true;
				if iChangeRegisterCode <> RC_Combine_Zo then iChangeRegisterCode  := RC_None;
			end;
		end;
	end;
end;



{---( TChangeList )-----------------------------------------}



function  TChangeList.GetItemByIdentNumberErr(ParNo:cardinal):TChangeItem;
var vlCurrent:TChangeItem;
begin
	vlCurrent := GetItemByIdentNumber(ParNo);
	if vlCurrent = nil then fatal(FAT_Change_Item_Not_found,['[ParNo=',IntTOStr(ParNo),']']);
	exit(vlCurrent);
end;

function  TChangeList.GetItemByIdentNumber(ParNo:cardinal):TChangeItem;
var vlCurrent:TChangeItem;
begin
	vlCurrent := TChangeItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.TestIdentNumber(parNo)) do vlCurrent := TChangeItem(vlCurrent.fNxt);
	exit(vlCurrent);
end;

procedure TChangeList.AddChangeRegisterCode(ParOperand:TOperand);
begin
	InsertAtTop(TChangeItem.Create(ParOperand));
end;

{----( TMemoryOffsetRes )---------------------------------}

procedure TMemoryOffsetRes.Commonsetup;
begin
	inherited commonsetup;
	iCode := RT_NumberByExp;
	SetMode([RM_Can_UnUsed_Output],false);
end;

procedure TMemoryOffsetres.Print(parDis:TAsmDisplay);
var vlStr :string;
begin
	fName.GetString(vlStr);
	ParDis.AsPrintOffset(vlStr,GetExtraOffset);
end;


function   TMemoryOffsetRes.CanSoftChangeSize(ParSize:TSize):boolean;
begin
	exit(ParSize >= fSize);
end;


function   TMemoryOffsetRes.TryChangeSize(ParSize:TSize):TResource;
var vlname : String;
	vlRes  : TResource;
begin
	vlRes := nil;
	if CanSoftChangeSize(ParSize) then begin
		fName.GetString(vlName);
		vlRes := TMemoryOffsetRes.Create(vlName,fSize,fSign);
	end;
	exit(vlRes);
end;


{----( TStorageRes )---------------------------------------}

function  TStorageRes.GetExtraOffset:Toffset;
begin
	GetExtraOffset := voExtraOffset;
end;

procedure TStorageRes.SetExtraOffset(ParOffset:TOFfset);
begin
	voExtraOffset := ParOffset;
end;


{----( TStackRes )-----------------------------------------}

function TStackRes.CanKeepInUse :boolean;
begin
	exit(false);
end;

function  TStackRes.CanReleaseFromUse : boolean;
begin
	exit(false);
end;

function TStackRes.KeepContents(ParAcc:TAccess) : TKeepContentsState;
begin
	exit(KS_Error);
end;

procedure TStackRes.Commonsetup;
begin
	inherited Commonsetup;
	iCode := RT_Stack;
	iStackPos := 0;
	SetMode([RM_Can_UnUsed_Output],false);
end;

function  TStackRes.IsSame(PArRes:TResource):boolean;
begin
	IsSame := false;
	if inherited IsSame(ParRes) then begin
		IsSame := TStackRes(ParRes).fStackPos = iStackPos;
	end;
end;

function  TStackRes.IsPart(ParRes:TResource):boolean;
begin
	exit( IsSame(ParRes));
end;

{----( TByPtrRes )-----------------------------------------}


procedure TByPtrRes.BeforeRelease;
begin
end;


procedure TByPtrRes.SetLockResource;
begin
	GetPointer.SetLockResource;
end;

procedure TByPtrRes.ResetLockResource;
begin
	GetPointer.ResetLockResource;
end;

procedure  TByPtrRes.ReserveResource;
begin
	GetPointer.ReserveResource;
end;


procedure TByPtrRes.BeforeRlf(ParCre:TInstCreator);
begin
	inherited BeforeRlf(ParCre);
	GetPointer.BeforeRlf(ParCre);
end;

procedure TByPtrRes.AdviceChange(ParChange:TChangeItem);
begin
	inherited AdviceChange(ParChange);
	if not(ParChange.fChangeRegisterCode in [RC_Combine_ZO,RC_Change_To_Reg,RC_Force_Register]) and (ParChange.fSize  <> fSize) then begin
		ParChange.SetChangeRegisterCodeDirect(RC_Change_To_Reg);
    end;
end;


function   TByPtrRes.TryChangeSize(ParSize:TSize):TResource;
var vlRes : TByPtrRes;
begin
	vlRes := nil;
	if CanSoftChangeSize(ParSize) then begin
		vlRes := TByPtrRes.Create(TRegisterRes(GetPointer),ParSize,fSign);
		vlRes.SetExtraOffset(GetExtraOFfset);
	end;
	exit(vlRes);
end;

procedure  TByPtrRes.AfterRlf(ParCre:TInstCreator;ParAcc:TAccessSet);
begin
	ParCre.ReleaseResource(self);
	GetPointer.AfterRlf(ParCre,[RA_Read]);
end;



procedure  TByPTrRes.DecUse;
begin
	GetPointer.IsUsed;
end;

procedure TByPTrRes.IncUse;
begin
	GetPointer.InUse;
end;


procedure TByPtrRes.commonsetup;
begin
	inherited CommonSetup;
	iCode := RT_ByPtr;
	iPointer := nil;
end;


procedure  TByPtrRes.Print(PArDis:TAsmDisplay);
var    vlName:string;
begin
	if GetPointer.fRegister = nil then vlName := '[unkown]'
	else vlName := iPointer.fRegister.GetName;
	ParDis.AsPrintMemIndex(vlName,'',GetExtraOffset,fSize);
end;


procedure   TByPtrRes.SetPointer(ParReg:TRegisterRes);
begin
	if iPointer <> nil then IsUsed;
	iPointer := ParReg;
	InUse;
end;



constructor TByPtrRes.Create(ParReg:TRegisterRes;ParSize : TSize;ParSign:boolean);
begin
	inherited Create(ParSize,ParSign);
	iPointer := ParReg;
end;

function    TByPtrRes.IsUsing(ParRes:TResource):boolean;
begin
	if isPart(ParRes) then exit(true);
	if iPointer.IsUsing(ParRes) then exit(true);
	exit(false);
end;



function    TByPtrRes.IsSame(PArRes:TResource):boolean;
begin
	exit(false);
end;

function    TByPtrRes.IsPart(ParRes:TResource):boolean;
begin
	exit(iPointer.IsPart(ParRes));
end;


{----( TCurrentInstItem )----------------------------------}

constructor TCurrentInstITem.Create(parInst:TInstruction);
begin
	inherited Create;
	iInst := ParInst;
end;


{----( TCurrentInstList )-----------------------------------}


function TCurrentInstList.GetCurrentInst:TInstruction;
begin
	if fStart = nil then GetCurrentInst := nil
	else GetCurrentInst := TCurrentInstItem(fStart).fInstruction;
end;

procedure TCurrentInstList.PushInst(ParInst:TInstruction);
begin
	insertAt(nil,TCurrentInstItem.Create(ParInst));
end;

procedure TCurrentInstList.PopInst;
begin
	deleteLink(fStart);
end;




{----( TCmpFlgRes)---------------------------------------------}


function TCmpflagRes.IsPart(PArres:TResource):boolean;
begin
	IsPart := IsSame(ParRes);
end;

function TCmpFlagRes.IsSame(ParRes:TResource):boolean;
var vlFlag : TIdentCode;
begin
	IsSame := false;
	vlFlag := iCmpCode;
	if Inherited IsSame(ParRes) then begin
		case TCmpFlagRes(ParRes).fCmpCode of
		IC_NotEq,IC_Eq       : IsSame := (vlFlag = IC_Eq)       or (vlFlag = IC_NotEq);
		IC_Bigger,IC_LowerEq : IsSame := (vlFlag = IC_Bigger)   or (vlFlag = IC_LowerEq);
		IC_BiggerEq,IC_Lower : IsSame := (vlFlag = IC_BiggerEq) or (vlFlag = IC_Lower);
	end;
end;
end;

constructor TCmpFlagRes.Create(ParCode : TIdentCode);
begin
	inherited Create;
	iCmpCode := parCode;
end;


procedure TCmpFlagRes.commonsetup;
begin
	inherited CommoNSetup;
	SetSize(0);
	setSign(false);
	SetMode([RM_InList],true);
	iCode := RT_CmpFlag;
	iCmpCode := IC_none;
end;

procedure TCmpFlagRes.NotCondition;
var vlCode : TIdentCode;
begin
	case iCmpCode of
		IC_Eq       : vlCode := IC_NotEq;
		IC_Bigger   : vlCode := IC_LowerEq;
		IC_BiggerEq : vlCOde := IC_Lower;
		IC_Lower    : vlCode := IC_BiggerEq;
		IC_LowerEq  : vlcode := IC_Bigger;
		IC_NotEq    : vlCode := IC_Eq;
	end;
	iCmpCode := vlCode;
end;


procedure TCmpFlagRes.print(ParDis:TAsmDisplay);
var
	vlStr:string[6];
begin
	vlStr := 'UNKOWN';
	case iCmpCode of
		IC_Eq       : vlStr := 'Z';
		IC_Bigger   : if fSign then vlStr := 'G' else vlStr := 'A';
		IC_BiggerEq : if fSign then vlStr :='GE' else vlStr := 'AE';
		IC_LOwer    : if fSign then vlStr := 'L' else vlStr := 'B';
		IC_LowerEq  : if fSign then vlStr := 'LE' else vlStr :='BE';
		IC_NotEq    : vlStr := 'NZ';
	end;
	ParDis.write(vlStr);
end;


{----(TNumberRes)-------------------------------------------------------}

function TNumberRes.TryChangeSize(ParSize:TSize):TResource;
var vLRes : TResource;
begin
	vlRes := nil;
	if CanSoftChangeSize(ParSize) then begin
		vlRes := TNumberRes.Create(fNumber);
		vlRes.SetSize(ParSize);
		vlRes.SetSign(fSign);
	end;
	exit(vlRes);
end;

function TNumberRes.CanSoftChangeSize(ParSize : TSize):boolean;
begin
	exit(true);
	exit(ParSize >= fSize);
end;


constructor TNumberRes.Create(ParInt : TNumber);
begin
	inherited Create;
	iNumber := ParInt;
end;

procedure   TNumberRes.CommonSetup;
begin
	inherited COmmonSetup;
	iCode := RT_Number;
	SetMode([RM_Can_UnUsed_Output,RM_Keep_For_UnUsed],false);
end;

procedure   TNumberRes.Print(ParDis:TAsmDisplay);
begin
	ParDis.AsPrintNUmber(fSize,fNumber);
end;


{----(TRegisterRes)-----------------------------------------------------}

function  TRegisterRes.GetRegisterCode : cardinal;
begin
	exit(fRegister.fRegisterCode);
end;

procedure TRegisterRes.SetLockResource;
begin
	fRegister.SetLock;
end;

procedure TRegisterRes.ResetLockResource;
begin
	fRegister.ResetLock;
end;


procedure  TRegisterRes.ReserveResource;
begin
	fRegister.Reserve;
end;


procedure  TRegisterRes.AfterRlf(ParCre :TInstCreator;ParAcc:TAccessSet);
begin
	if(RA_Output in ParAcc) then begin
		IsUsed;
		ReserveResource;
	end else begin
		ParCre.ReleaseResource(self);
	end;
end;

function   TRegisterRes.KeepContents(ParAcc:TAccess):TKeepContentsState;
begin
	if (ParAcc=RA_Read) then exit(KS_Move)
	else exit(KS_Replace);
end;


procedure TRegisterRes.AdviceChange(ParChange:TChangeItem);
var    vlCode : TChangeCode;
begin
	inherited AdviceChange(ParChange);
	vlCode := ParChange.fChangeRegisterCode;
	if vlCode in [RC_Automatic,RC_Change_To_Reg] then begin
		vlCode := rc_Change_Nothing;
		if ParChange.fSize  <> fSize then begin
			if CanSoftChangeSize(ParChange.fSize) then vlCode :=  RC_Change_To_Self
			else vlCode :=  RC_Change_To_Reg;
		end;
		ParChange.SetChangeRegisterCodeDirect(vlCode);
	end ;
end;

function TRegisterRes.IsPart(ParRes:TResource):boolean;
begin
	IsPart := false;
	if inherited IsPart(PArRes) then IsPArt := fRegister.IsPartOf(TRegisterRes(ParRes).fRegister);
end;


function TRegisterRes.CanSoftChangeSize(ParSize : TSize):boolean;
var vlReg:TRegister;
begin
	vlReg := nil;
	if ParSize <= fSize then begin
		vlReg := fRegister;
		while (vlReg <> nil) and
        	(vlReg.fSize <> ParSize)
            			do vlreg := vlreg.fSmallerSize;
		
	end;
	exit(vlReg <> nil);
end;

function TRegisterRes.TryChangeSize(ParSize:TSize):TResource;
var vlReg : TRegister;
	vlRes : TRegisterRes;
begin
	vlRes := nil;
	if (ParSize <= fSize) then begin
		vlReg := fRegister;
		while (vlReg <> nil) and (vlReg.fSize <> ParSize) do vlreg := vlreg.fSmallerSize;
		if vlReg <> nil then vlRes := TRegisterRes.Create(vlReg,ParSize,fSign);
	end;
	exit(vlRes);
end;

function TRegisterRes.IsSame(PArRes:TResource):boolean;
begin
	IsSame := false;
	if inherited IsSame(parRes)then begin
		IsSame := fRegister = TRegisterRes(parRes).fRegister;
	end;
end;


procedure   TRegisterRes.SetRegister(ParReg:TRegister);
begin
	iRegister := PArReg;
end;



procedure TRegisterRes.DecUse;
begin
	iRegister.DecUseCnt;
end;

procedure TRegisterRes.IncUse;
begin
	iRegister.IncUseCnt;
end;

constructor TRegisterRes.Create(ParReg:TRegister;parSize : TSize;parSign:boolean);
begin
	inherited Create(ParSize,ParSign);
	SetRegister(ParReg);
end;



procedure TRegisterRes.print(ParDis:TAsmDisplay);
begin
	parDis.Write(iRegister.GetName);
end;


procedure TRegisterRes.COmmonSetup;
begin
	inherited CommonSetup;
	iRegister := nil;
	iCode := RT_Register;
	SetMode([RM_InList,RM_Keep_For_Unused],true);
	SetMode([RM_Can_UnUsed_Output],false);
end;

{----(TMemoryRes )---------------------------------------------------}

function TMemoryRes.CanSoftChangeSize(ParSize : TSize):boolean;
begin
	exit(ParSize < fSize);
end;

function  TMemoryRes.IsPart(PArRes:TResource):boolean;
begin
	IsPart := false;
	if inherited IsPart(ParRes) then isPart := (fName.IsEqual(TMemoryRes(ParRes).fName));
end;


function TMemoryRes.ISSame(ParRes:TResource):boolean;
begin
	IsSame :=false;
	if inherited IsSame(ParRes) then begin
		IsSame := (fName.IsEqual(TMemoryRes(ParRes).fName))
		and(TMemoryRes(ParRes).GetExtraOffset = GetExtraOffset);
	end;
end;


function   TMemoryRes.TryChangeSize(ParSize:TSize):TResource;
var vlName : string;
	vlRes  : TMemoryRes;
begin
	vlRes := nil;
	if CanSoftChangeSize(ParSize) then begin
		iName.GetString(vlName);
		vlRes  := TMemoryRes.Create(vlName,ParSize,fSign);
		vlRes.SetExtraOffset(GetExtraOffset);
	end;
	exit(vlRes);
end;

procedure   TMemoryRes.SetName(const ParName:String);
begin
	if iName <> Nil then iName.destroy;
	iName :=TString.Create(ParName);
end;

procedure TMemoryRes.Print(ParDis:TAsmDisplay);
var vlStr,vlName : string;
begin
	str(GetExtraOffset,vlStr);
	iName.GetString(vlName);
	if GetExtraOffset= 0 then vlStr := vlName
	else vlStr := IntToStr(GetExtraOffset) + '+'+vlName;
	ParDis.AsPrintMemVar(fSize,vlStr);
end;


constructor TMemoryRes.Create(const ParName:String;ParSize : TSize;ParSign:boolean);
begin
	inherited Create(ParSize,ParSign);
	SetName(PArName);
end;

procedure   TMemoryRes.CommonSetup;
begin
	inherited COmmoNSetup;
	iName := nil;
	iCode := RT_Memory;
end;

destructor TMemoryRes.destroy;
begin
	inherited destroy;
	if iName <> nil then iName.destroy;
end;


{----(TVarRes )------------------------------------------------------}



function TVarRes.CanSoftChangeSize(ParSize : TSize):boolean;
begin
	exit(ParSize <= fSize);
end;

constructor TVarRes.Create(ParSize : TSize;ParSign:boolean);
begin
	inherited Create;
	SetSize(ParSize);
	SetSign(ParSign);
	
end;




{----( TResource )------------------------------------------------------}

procedure TResource.BeforeRelease;
begin
	IsUsed;
end;


function TResource.CanKeepInUse :boolean;
begin
	exit(True);
end;


function   TResource.CanReleaseFromUse : boolean;
begin
	exit(true);
end;


procedure TResource.ResetlockResource;
begin
end;

procedure TResource.SetLockResource;
begin
end;

procedure  TResource.ReserveResource;
begin
end;




function   TResource.KeepContents(ParAcc:TAccess):TKeepContentsState;
begin
	exit(KS_Move);
end;

procedure  TResource.BeforeRlf(ParCre:TInstCreator);
begin
	ParCre.ResourcePRLF(self);
end;


procedure TResource.AdviceChange(ParChange:TChangeItem);
begin
end;


procedure TResource.AfterRlf(ParCre:TInstCreator;ParACC:TAccessSet);
begin
	if not(RA_Output in ParAcc) then  ParCre.ReleaseResource(self);
end;

function TResource.MustSave(ParRes:TResource):boolean;
begin
	MustSave := false;
end;

function  TResource.GetExtraOffset:Toffset;
begin
	GetExtraOffset := 0;
end;
procedure TResource.SetExtraOffset(ParOffset:TOFfset);
begin
	if ParOffset <> 0 then Fatal(FAT_Extra_offset_not_allowed,['ClassName=',ClassName]);
end;


procedure TResource.SetMode(ParMode : TResourceMode;ParSet:boolean);
begin
	if ParSet then begin
		iMode := iMode + ParMode
	end else begin
		iMode := iMode - ParMode;
	end;
end;

function  TResource.GetMode(ParMode:TResourceModes):boolean;
begin
	GetMode := ParMode in iMode;
end;


function TResource.CanSoftChangeSize(ParSize : TSize):boolean;
begin
	exit(false);
end;

function  TResource.TryChangeSize(ParSize:TSize):TResource;
begin
	if CanSoftChangeSize(ParSize) then begin
		
		SetSize(ParSize);
		exit(self);
	end else exit(nil);
end;

function   TResource.IsUsing(ParRes:TResource):boolean;
begin
	exit(isPart(ParRes));
end;

function  TResource.IsPart(ParRes:TResource):boolean;
begin
	IsPart := (ParRes.fCode = fCode);
end;

function   TResource.IsSame(ParRes:TResource):boolean;
begin
	exit( (ParRes.fCode = fCode) and
	(ParRes.fSize = fSize) )
end;

procedure TResource.print(ParDis:TAsmDisplay);
begin
	ParDis.Write('<Abstract Resource>');
end;

procedure TResource.DecUse;
begin
end;


procedure TResource.IncUse;
begin
end;

procedure TResource.IsUsed;
begin
	DecUse;
end;


procedure TResource.InUse;
begin
	IncUse;
end;


procedure TResource.SetSize(ParSize:TSize);
begin
	iSize := ParSize;
end;

procedure TResource.SetSign(ParSign:boolean);
begin
	iSign := ParSign;
end;

procedure TResource.CommonSetup;
begin
	inherited CommoNSetup;
	iMode        := [RM_Can_UnUsed_Output];
	SetExtraOffset(0);
	SetMode([RM_InList],false);
	iCode := RT_None;
	
end;




{----( TUnkRes )----------------------------------------------------}

procedure TUnkRes.Print(ParDis:TAsmDisplay);
begin
	ParDis.Write('Unkown');
end;


procedure TUnkRes.CommonSetup;
begin
	inherited CommonSetup;
	iCode := RT_Unkown;
	SetSize(1);
end;




{----( TInstruction )--------------------------------------------------}
procedure  TInstruction.GetInstructionName(var ParName : string);
begin
	ParName := 'Unkown';
end;


function   TInstruction.GetResByIdent(ParIdent :TFlag):TResource;
begin
	exit(iOperandList.GetResByIdent(ParIdent).fResource);
end;

procedure TInstruction.InstructionFase(ParCre:TInstCreator);
begin
	ParCre.PushInst(self);
	voOperandList.ResourceListFase(ParCre);
	ParCre.PopInst;
end;

procedure TInstruction.InitOperandList;
begin
	voOperandList := TOperandList.Create;
end;

procedure TInstruction.CommonSetup;
begin
	inherited COmmonSetup;
	iIdentCode := IC_386_None;
	InitOperandList;
end;


procedure TInstruction.clear;
begin
	inherited clear;
	if iOperandList <> nil then iOperandList.destroy;
end;


procedure TInstruction.AddResItem(ParRes:TOperand);
begin
	iOperandList.InsertAtTop(ParRes);
end;


function TInstruction.AddOperand(ParRes:TResource;ParIdent:TFlag):TOperand;
begin
	AddOperand := iOperandList.AddOperand(ParRes,ParIdent);
end;


procedure TInstruction.Print(ParDis:TAsmDisplay);
var
	vlName : string;
begin
	GetInstructionName(vlName);
	GetAssemblerInfo.GetInstruction(vlName,iOperandList.GetOpperSize,0);
	ParDis.print([vlName,' ']);
	iOperandList.Print(ParDis);
end;


{----( TOperandList )-------------------------------------------------------}



procedure TOperandList.PreResourceListFase(ParCre:TInstCreator);
begin
	PopAll(ParCre);
	DeleteInputfromUse(ParCre);
	CompleteOutput(ParCre);
end;


procedure TOperandList.CompleteOutput(ParCre:TInstCreator);
begin
end;

function  TOperandList.GetResByIdent(ParIdent:TFlag):TOperand;
var vlCurrent:TOperand;
begin
	vlCUrrent := TOperand(fStart);
	while (vlCUrrent <> nil) and not(vlCurrent.TestIdentNumber(ParIdent)) do vlCurrent := TOperand(vlCurrent.fNxt);
	GetResByIdent := vlCurrent;
end;

procedure TOperandList.HandleChange(ParCre:TInstCreator;ParChange:TChangeList);
var vlCurrent     : TChangeItem;
begin
	vlCurrent := TChangeItem(ParChange.fStart);
	while vlCurrent <> nil do begin
		vlCurrent.OptimizeChange;
		vlCurrent := TChangeItem(vlCurrent.fNxt);
	end;
	vlCurrent := TChangeItem(ParChange.fStart);
	while vlCurrent <> Nil do begin
		if   vlCurrent.IsOutput then HandleChangeItem(ParCre,vlCurrent,vlCurrent.iOperand);
		vlCurrent := TChangeItem(vLCurrent.fNxt);
	end;
	vlCurrent := TChangeItem(ParChange.fStart);
	while vlCurrent <> Nil do begin
		if  not vlCurrent.IsOutput then HandleChangeItem(ParCre,vlCurrent,vlCurrent.iOperand);
		vlCurrent := TChangeItem(vlCurrent.fNxt);
	end;
end;

procedure TOperandList.HandleChangeItem(ParCre:TInstCreator;ParChangeItem:TChangeItem;ParResItem:TOperand);
var vlOldSize,vlNewSize:TSize;
	vlChange     : TChangeCode;
	vlRegflag    : TChangeCode;
	vlReg        : TRegisterRes;
	vlRes        : TResource;
	vlOut        : TOperand;
	vlResName    : String;
begin
	vlOldSize := ParResItem.GetSize;
	vlChange  := ParChangeItem.fChangeRegisterCode;
	vlNewSize := ParChangeItem.fSize;
	{$ifdef showregres}
		writeln('class = ',classname,' id no=',ParResItem.fIdentNumber,' OldSize=',vlOldSize,' NewSize=',vlNewSize,' Change=',cardinal(vlChange),' Change to reg=',cardinal(ParChangeItem.fChangeToRegister));
	{$endif}
	if (vlChange = RC_None)  and (vlNewSize = vlOldSize) then exit;
	vlRegflag := vlChange;
	if ParChangeItem.fSoftChangeSize then begin
		vlRes:=  ParResItem.fResource.TryChangeSize(vlNewSize);
		
		if (vlRes <> nil) and (vlOldSize <> vlNewSize) then begin
			if(ParResItem.GetAccess(RA_Output)) then ParCre.ReplaceResource(ParResItem.fResource,vlRes);
			ParCre.AddObject(vlRes);
			ParResItem.ReplaceResource(vlRes);
		end else begin
			vlResName := '[unkown]';
			if ParResItem.fResource <> nil then vlResName:= ParResItem.fResource.ClassName;
			fatal(FAT_Cant_Change_Size,['[Size = ',vlNewSize , '][Object Type = ',vlResName  ,'] AT:',ClassName,'.HandleChangeItem']);
		end;
	end;
	vlOut := GetResByIdent(In_Main_Out);
	case vlRegFlag of
	RC_Change_To_Self:if (vlOldSize <> vlNewSize) then begin
		vlReg := Parcre.GetAsRegister(TRegisterRes(ParResItem.fResource),vlNewSize,ParResItem.GetSign);
		if vlReg = nil then Fatal(Fat_Cant_Get_Register_Res,['Register =',TRegisterRes(ParResItem.fResource).fRegister.fRegisterCode,' size=',vlNewSize,' sign=',byte(ParResItem.GetSize)]);
		ReplaceResource(ParCre,vlReg,ParResItem);
	end;
	RC_Change_To_Reg :begin
		vlReg := ParCre.ReserveRegister(vlNewSize,ParResItem.GetSign);
		ReplaceResource(ParCre,vlReg,ParResItem);
	end;
	RC_Force_Register :begin
		ForceOutputToReg(ParCre,ParResItem,vlNewSize,ParChangeItem.fChangeToRegister);
	end;
	RC_Combine_Zo     :begin
		vlRes := ParResItem.fResource;
		if (vlRes.fCode = RT_Register)
		and(ParCre.CanChangeResource(vlRes))
		and not(vlOut.fIsFixed)
		and (vlRes.fSize = vlOut.GetSize) then begin
			ReplaceResource(ParCre,vlRes,vlOut);
		end else if not vlOut.IsSame(ParResItem) then begin
			vlRes := vlOut.fResource;
			SaveResParts(ParCre,vlRes,[ra_read]);
			ReplaceResource(ParCre,vlRes,ParResItem);
		end;
	end;
end;
end;

procedure TOperandList.ForceOutputToReg(ParCre : TInstCreator ; ParResItem : TOperand ;ParSize :TSize; ParRegister : TNormal);
var vlRegister : TRegister;
begin
	vlRegister := parCre.GetAsRegisterByName(ParRegister,ParSize);
	if vlRegister = nil then  Fatal(Fat_Cant_Get_Func_Ret_Reg,'AT:TOperandList.ForceOutputToReg');
	ForceOutputTo(ParCre,ParResItem,vlRegister);
end;

procedure TOperandList.DeleteInputFromUse(ParCre:TInstCreator);
var vlCurrent:TOperand;
begin
	vlCurrent := TOperand(fStart);
	while vlCurrent <> nil do begin
		if not (vlCurrent.GetAccess(RA_Output)) then begin
			vlCurrent.fResource.BeforeRlf(ParCre);
		end;
		vlCurrent := TOperand(vlCurrent.fNxt);
	end;
end;

procedure TOperandList.PopAll(ParCre:TInstCreator);
var vlMaxPop  : TOperand;
	vlMaxRes  : TResource;
	vlCurrent : TOperand;
	vlMaxPos  : longint;
	vlPos     : longint;
	vlCnt     : cardinal;
begin
	repeat
		vlMaxPos  := 0;
		vlCurrent := TOperand(fStart);
		vlMaxPop  := nil;
		vlCnt     := 0;
		while vlCurrent <> nil do begin
			if vlCurrent.GetResCode = RT_Stack then begin
				vlPos := TStackRes(vlCurrent.fResource).fStackPos;
				if vlPos > vlMaxPos then begin
					vlMaxPos := vlPos;
					vlMaxPop := vlCurrent;
				end;
			end;
			if vlCurrent.GetResCode = RT_ByPtr then begin
				vlMaxRes := TByPtrRes(vlCurrent.fResource).GetPointer;
				if vlMaxRes.fCode = RT_Stack then begin
					vlPos := TStackRes(vlMaxRes).fStackPos;
					if vlPos > vlMaxPos then begin
						vlMaxPos := vlPos;
						vlMaxPop := vlCurrent;
					end;
				end;
			end;
			vlCurrent := TOperand(vlCurrent.fNxt);
			inc(vlCnt);
		end;
		if vlMaxPop <> nil then begin
			PopResource(ParCre,vlMaxPop);
		end;
	until vlMaxPop =nil;
end;


procedure TOperandList.PopResource(ParCre : TInstCreator;ParRes : TOperand);
var
	vlRes : TResource;
begin
	if ParRes.GetResCode = RT_Stack then begin
		vlRes := ParCre.PopRes(TStackRes(ParRes.fResource),false);
		ParCre.ChangeResource(ParRes.fResource,vlRes);
		ParRes.ReplaceResource(vlRes);
	end else if(ParRes.GetResCode = RT_ByPtr) and
		(TByPtrRes(ParRes.fResource).GetPointer.fCode =RT_Stack) then begin
		vlRes := ParCre.PopRes(TStackRes(TByPtrRes(ParRes.fResource).GetPointer),false);
		ParCre.ChangeResource(TByPtrRes(ParRes.fResource).GetPointer,vlRes);
		TByPtrRes(ParRes.fResource).SetPointer(TRegisterRes(vlres));
	end;
end;




function TOperandList.CombineZO(ParCre:TInstCreator):boolean;
var voRi1 : TOperand;
	voRi2 : TOperand;
begin
	voRi1 := GetResByIdent(In_Main_Out);
	voRi2 := GetResByIdent(In_In_1);
	CombineZO := false;
	if voRi1.IsSame(voRi2) then begin
		CombineZo := true;
		ParCre.DeleteUnusedByRes(voRi2.fResource);
		voRi1.Combine(voRi2);
		voRi2.IsUsed;
		deletelink(voRi2);
	end;
	
end;


procedure TOperandList.SaveResParts(ParCre:TInstCreator;ParRes:TResource;ParAccess:TAccessSet);
var vlCurrent : TOperand;
	vlItem    : TOperand;
begin
	vlCurrent :=TOperand(fStart);
	while vlCurrent<> nil do begin
		vlItem := TOperand(vlCurrent.fNxt);
		if vlCurrent.MustSave(ParRes,ParAccess) then begin
			ReplaceResourceWithReg(ParCre,vlCurrent);
		end;
		vlCurrent :=vlItem;
	end;
end;

function TOperandList.AddOperand(ParRes:TResource;ParIdent:TFLag):TOperand;
var vlRes:TOperand;
begin
	if ParIdent = 0 then Fatal(Fat_Invalid_IdentNUmber,'AT:TOperandList.AddOperand');
	vlRes := TOperand.Create(ParRes,ParIdent);
	InsertAtTop(vlRes);
	AddOperand := vlRes;
end;

procedure TOperandList.SetUseState(ParCre:TInstCreator);
var vlCurrent : TOperand;
	vlMax    : longint;
	vlCur    : Longint;
	vlPrio   : longint;
begin
	vlMax := 1;
	vlCur := 0;
	repeat
		vlCurrent := TOperand(fStart);
		while vlCurrent <> nil do begin
			vlPrio := vlCurrent.GetFinalPriority;
			if vlPrio > vlMax then vlMax := vlPrio;
			if vlCur = vlPrio then vlCurrent.AfterRlf(ParCre);
			vlCurrent := TOperand(vlCurrent.fNxt);
		end;
		inc(vlCur);
	until vlcur > vlMax;
end;


procedure TOperandList.AtResourceListFase(Parcre:TInstCreator;ParChange:TChangeList);
begin
end;

Procedure TOperandList.PostResourceListfase(ParCre:TInstCreator;ParChange:TChangeList);
begin
	SetUseState(ParCre);
end;


procedure TOperandList.ResourceListFase(ParCre:TInstCreator);
var vlCurrent : TOperand;
	vlChange  : TChangeList;
begin
	PreResourceListfase(ParCre);
	vlCurrent := TOperand(fStart);
	vlChange  := TChangeList.Create;
	while vlCurrent <> nil do begin
		vlChange.AddChangeRegisterCode(vlCurrent);
		vlCurrent := TOperand(vlCurrent.fNxt);
	end;
	AtResourceListFase(ParCre,vlChange);
	PostResourceListFase(ParCre,vlChange);
	vlChange.Destroy;
end;



function TOperandList.GetOpperSize:TSize;
var vlItem:TOperand;
begin
	GetOpperSize := 0;
	vlItem := GetResByIdent(In_main_Out);
	if vlItem <> nil then begin
		GetOpperSize := vlItem.GetSize;
		exit;
	end;
end;

procedure TOperandList.Print(ParDis:TAsmDisplay);
var vlItem      : TResource;
	vlFirst     : boolean;
	vlCnt       : longint;
	vlCurrent   : TOperand;
	vlPos       : TNormal;
	vlMustPrint : boolean;
	vlIntel     : boolean;
	vlNum	: longint;
begin
	vlFirst := true;
	vlIntel := GetAssemblerInfo.HasIntelDirection;
	vlNum   := GetNumItems;
	if vlIntel then vlCnt := 1
	else vlCnt := vlNum;
	while vlNum <> 0 do begin
		vlCurrent := TOperand(fStart);
		while (vlCurrent<> nil) do begin
			vlMustPrint := GetPrintPosition(vlCurrent,vlPos);
			if vlPos = vlCnt then break;
			vlCurrent := TOperand(vlCurrent.fNxt);
		end;
		if (vlCurrent <> Nil) and vlMustPrint then begin
			vlItem := vlCurrent.fResource;
			if not vlFirst then ParDis.write(',');
			vlItem.Print(ParDis);
			vlFirst := false;
		end;
		if vlIntel then inc(vlCnt)
		else Dec(vlCnt);
		dec(vlNum);
	end;
end;

procedure TOperandList.HandleKeepContents(ParCre : TInstCreator;ParAcc : TAccess;ParRes : TResource;ParItem:TOperand);
var vlRes  : TResource;
	vlRes2 : TResource;
	vlRes3 : TResource;
begin
	case ParItem.KeepContents(ParAcc) of
	KS_Not   : begin     end;
	KS_Replace : begin
		if ParAcc = RA_Output then ParCre.ReplaceResource(ParItem.fResource,ParRes);
	end;
	KS_Move  : begin
		vlRes := ParItem.fResource;
		vlRes3 := ParRes;
		if ParAcc = RA_Output then begin
			vlRes2 := vlRes3;
			vlRes3 := vlRes;
			vlRes  := vlRes2;
		end;
		if (vlRes.fSize > vlRes3.fSize) and (vlRes3 is TRegisterRes) then begin
			vlRes3 := Parcre.GetAsRegister(TRegisterRes(vlRes3),vlRes.fSize,vlRes.fSign);
			if vlRes3 = nil then Fatal(Fat_Cant_Get_Register_Res,'');
		end;
		ParCre.AddMov(vlRes3,vlRes,(ParAcc = RA_Output));
		if ParAcc <> RA_Output then ParCre.ReplaceUnUsedResource(ParItem.fResource,vlRes3);
	end;
	KS_Error : fatal(fat_Cant_Change_Resource,'At '+className+'.HandleKeepContents, From : '+ParItem.fResource.ClassName+'to :'+ParRes.ClassName);
end;
end;


procedure TOperandList.ReplaceResourceWithReg(ParCre : TInstCreator ; ParOperand : TOperand);
var
	vlNewRes   : TResource;
begin
	vlNewRes := ParCre.ReserveRegister(ParOperand.GetSize,ParOperand.GetSign);
	ReplaceResource(ParCre,vlNewRes,ParOperand);
end;


procedure TOperandList.ReplaceResource(ParCre : TInstCreator;ParRes:Tresource;ParItem : TOperand);
begin
	HandleKeepContents(ParCre,RA_Read,ParRes,ParItem);
	HandleKeepContents(ParCre,RA_Output,ParRes,ParItem);
	ParItem.ReplaceResource(ParRes);
end;



procedure TOperandList.ForceOutputTo(ParCre:TInstCreator;ParIdent:TFLag;const PArReg:TRegister);
var vlOperand  : TOperand;
	vlRegName  : TNormal;
	vlRegRes   : TRegisterRes;
	vlOpp      : TOperand;
begin
	vlOperand := GetResByIdent(ParIdent);
	if vlOperand <> nil then begin
		ForceOutputTo(ParCre,vlOperand,ParReg);
	end else begin
		vlRegName := ParReg.fRegisterCode;
		vlRegRes  := ParCre.ForceReserveRegister(ParCre,vlRegName,false);
		vlOpp := AddOperand(vlRegRes,ParIdent);
		vlOpp.MakeFixed;
	end;
end;

procedure TOperandList.ForceOutputTo(ParCre:TInstCreator;ParOperand : TOperand;const PArReg:TRegister);
var vLOut    : TOperand;
	vlRegRes : TRegisterRes;
	vlSign   : boolean;
	vlRegName: TNormal;
begin
	vlOut := ParOperand;
	if (vlOut <> nil) and (vLOut.GetResCode <> RT_Register) and (vlOut.GetAccess(RA_Output))  then fatal(FAT_Out_Is_Not_Register,'AT:TOperandList.ForceOutputTo');
	if ( TRegisterRes(vlOut.fResource).fRegister <> ParReg) then begin
		vlSign    := vlOut.GetSign;
		vlRegName := ParReg.fRegisterCode;
		vlRegRes  := Parcre.ForceReserveRegister(ParCre,vlRegName,vlSign);
		if (vlOut.GetAccess(RA_Read)) then begin
			SaveResParts(ParCre,vlRegRes,[Ra_Read]);
			ReplaceResource(ParCre,vlRegRes,vlOut);
		end else begin
			ParCre.ChangeResource(vlOut.fResource,vlRegRes);
			ReplaceResource(ParCre,vlRegRes,vlOut);
		end;
	end;
	vlOut.MakeFixed;
end;


function  TOperandList.GetIdentByRes(ParRes:TResource;ParAccess:TAccess;var ParIdent:TFlag):boolean;
var vlCurrent:TOperand;
begin
	vlCurrent := TOperand(fStart);
	GetIdentByRes := false;
	while vlCurrent <> nil do begin
		if vlCurrent.GetAccess(ParAccess) then begin
			if vlCUrrent.fResource.IsPart(ParRes) then begin
				GetIdentByRes := true;
				ParIdent := vlCurrent.fIdentNumber;
				exit;
			end;
		end;
		vlCurrent := TOperand(VlCurrent.fNxt);
	end;
end;


function  TOperandList.GetPrintPosition(ParRes:TOperand;var ParPosition:TNormal):boolean;
var vlStr:string;
begin
	GetPrintPosition := true;
	if ParRes.TestIdentNumber(In_In_1)     then ParPosition := 2
	else if ParRes.TestIdentNumber(In_Main_Out) then ParPosition := 1
	else if ParRes.TestIdentNumber(In_Flag_Out) then begin
		GetPrintPosition := false;
	end
	else begin
		str(ParRes.fIdentNumber,vlStr);
		Fatal(FAT_Invalid_IdentNumber,'[ID='+vlStr+'] In: TOperandList.GetPrintPosition');
	end;
end;

{----( TOperand )-------------------------------------------------}



procedure TOperand.SetIdentNumber(ParIdentNumber :TFlag);
var
	vlFlag : cardinal;
begin
	vlFlag := ParIdentNumber and in_In_mask;
	if(vlFlag <> 0) then iIdentNumber  := (iIdentNumber and not(in_in_mask)) or vlFlag;
	vlFlag := ParIdentNumber and  in_Out_Mask;
	if(vlFlag <> 0) then iIdentNumber  := (iIdentNumber and not(in_Out_Mask)) or vlFlag;
end;

procedure TOperand.MakeFixed;
begin
	iIsFixed := true;
end;
procedure TOperand.BeforeRlf(ParCre :TInstCreator);
begin
	if not GetAccess(RA_Output) then fResource.BeforeRlf(ParCre);
end;

procedure TOperand.AfterRlf(ParCre : TInstCreator);
var vlAcc:TAccessSet;
begin
	vlAcc := [];
	if GetAccess(ra_output) then begin
		vlAcc := vlAcc + [ra_output];
		ParCre.DeleteUnusedByRes(fResource);
	end;
	if GetAccess(RA_Read)   then vlAcc := vlAcc + [RA_Read];
	fResource.AfterRlf(ParCre,vlAcc);
end;


function TOperand.KeepContents(ParAcc:TAccess):TKeepCOntentsState;
var vlRes   : TKeepContentsState;
begin
	if(GetAccess(ParAcc)) then begin
		vlRes := fResource.KeepContents(ParAcc);
	end else begin
		vlRes := KS_Not;
	end;
	exit(vlRes);
end;


function  TOperand.GetFinalPriority:longint;
begin
	if GetAccess(RA_Output) then exit(2);
	exit(1);
end;

function   TOperand.TestIdentNumber(ParIdent:TFlag):boolean;
var
	vlFlag :TFlag;
begin
	vlFlag := ParIdent and in_In_Mask;
	if(vlFlag <> 0) and ((fIdentNumber and In_In_Mask) <> vlFlag) then exit(false);
	vlFlag := ParIdent and in_Out_Mask;
	exit((vlFlag = 0) or ((fIdentNumber and In_Out_Mask) = vlFlag));
end;




function  TOperand.MustSave(ParRes:TResource;ParAccess:TAccessSet):boolean;
begin
	if fResource.IsUsing(ParRes) then begin
		if (RA_Output in ParAccess) and GetAccess(RA_Output) then exit(true);
		if (RA_Read   in ParAccess) and GetAccess(RA_Read) then exit(true);
	end;
	exit(false);
end;

procedure TOperand.commonsetup;
begin
	inherited commonsetup;
	iResource   :=  nil;
	iIsFixed    :=  false;
end;

procedure TOperand.Combine(ParRes:TOperand);
var vlMother:TFLag;
	vlChild:TFLag;
begin
	vlMother := fIdentNumber;
	vlChild  := ParRes.fIdentNumber;
	if ((vlMother and In_In_Mask <> 0) xor (vlChild and In_In_Mask <> 0))
	or ((vlMother and In_Out_Mask <> 0) xor (vlChild and In_Out_Mask <> 0))
	then begin
		iIdentNumber := vlMother or vlChild;
	end else begin
		Fatal(FAT_Cant_Combine_Resources,['Id:',vlMother,'/',vlChild]);
	end;
end;

function  TOperand.GetMode(ParMode:TResourceModes):boolean;
begin
	exit( fResource.GetMode(PArMode));
end;

procedure TOperand.print(ParDis:TAsmDisplay);
begin
	fResource.Print(ParDis);
end;

constructor TOperand.Create(parRes:TResource;ParIdent:TFlag);
begin
	inherited Create;
	ReplaceResource(ParRes);
	iIdentNumber := ParIdent;
end;


procedure TOperand.ReplaceResource(ParRes:TResource);
begin
	if fResource <> nil then fResource.IsUsed;
	voResource := ParRes;
	if ParRes <> nil then ParRes.InUse;
end;

procedure  TOperand.IsUsed;
begin
	fResource.IsUsed;
end
;
function   TOperand.GetAccess(ParAcc:TAccess):boolean;
begin
	case ParAcc of
	RA_Read   : exit ( (fIdentNumber and In_In_Mask) <> 0);
	RA_Output : exit ( (fIdentNumber and In_Out_Mask) <> 0);
	else   Fatal(Fat_Invalid_Access_Flag,'At: TOperand.GetAccess');
end;
end;

function   TOperand.IsSame(ParItem:TOperand):boolean;
begin
	IsSame := fResource.IsSame(ParItem.fResource);
end;

function   TOperand.GetResCode : TResourceIdentCode;
begin
	GetResCode := fResource.fCode;
end;

function   TOperand.GetSign:boolean;
begin
	GetSign := fResource.fSign;
end;

function   TOperand.GetSize:TSize;
begin
	GetSize := fResource.fSize;
end;


{----( TResourceUse )-------------------------------------------------}

function TResourceUSe.CanRelease:boolean;
begin
	exit((fResMOde <> RSM_Long_Reservation));
end;


function TResourceUse.IsPart(PArItem:TResource):boolean;
begin
	IsPArt := fResource.IsPart(PArItem);
end;


constructor TResourceUse.Create(ParSec:TSecBase);
begin
	inherited Create;
	SetSec(ParSec);
end;

procedure    TResourceUse.SetResource(ParRes:TResource);
begin
	if fFixed then fatal(Fat_Cant_Change_Resource,'class='+ParRes.ClassName);
	if fResMode = RSM_Long_Reservation then ParRes.SetLockResource;
	voResource := ParRes;
end;

function    TResourceUse.SetSec(ParSec:TSecBase):TSecBase;
begin
	SetSec := fSec;
	voSec  := ParSec;
end;


procedure  TResourceUse.SetOutputLock(ParFlag : boolean);
begin
	iOutLock := ParFlag;
end;

function    TResourceUse.IsUsing(ParRes : TResource):boolean;
begin
	exit(iResource.IsUsing(ParRes));
end;


procedure   TResourceUse.CommonSetup;
begin
	inherited COmmonSetup;
	iResource  := nil;
	iOutLock   := false;
	fResMode   := RSM_Release_On_Use;
	iFixed     := false;
	iUnUsed    := false;
end;


{----( TInstCreator )--------------------------------------------}


procedure  TInstCreator.GetProcedureName(var parNAme : string);
begin
	iRoutineAsm.fProcedureName.GetString(ParName);
end;


procedure TInstCreator.AddObject(ParITem : TRoot);
begin
	iRoutineAsm.AddObject(ParItem);
end;

procedure TInstCreator.AddUnUsedResourceUse(ParSec : TSecBase;ParRes : TResource);
begin
	fResourceUseList.AddUnUsedResource(ParSec,ParRes);
end;

function  TInstCreator.GetResourceUse(ParSec : TSecBase):TResourceUse;
begin
	exit(fResourceUseList.GetResourceUse(ParSec));
end;

procedure TInstCreator.DeleteUnusedByRes(ParRes : TResource);
begin
	fResourceUseList.DeleteUnusedByRes(ParRes);
end;

procedure TInstCreator.DeleteUnusedByMac(ParSec : TSecBase;ParMode : TUnUsedDeleteMode);
begin
	fResourceUseList.DeleteUnusedByMac(ParSec,ParMode);
end;




procedure TInstCreator.DeleteUnUsedUse;
begin
	fResourceUseList.DeleteUnUsedUse;
end;

function  TInstCreator.ReplaceResource(ParOld,ParNew:TResource):boolean;
begin
	exit(fResourceUseList.ReplaceResource(ParOld,ParNew));
end;

procedure  TInstCreator.ReplaceUnUsedResource(ParOld,ParNew:TResource);
begin
	fResourceUseList.ReplaceUnUsedResource(ParOld,ParNew);
end;

procedure TInstCreator.DumpUseList;
begin
	fResourceUseList.DumpList;
end;

function TInstCreator.GetByPtrOf(ParMac : TSecBase;ParSize : TSize;ParSign : boolean) : TResource;
var
	vlRes   : TRegisterRes;
	vlByPtr : TResource;
begin
	vlRes := GuaranteeRegister(TMacBase(ParMac).CreateResource(self),RH_Pointer);
	AddUnusedResourceUse(ParMac,vlRes);
	vlByPtr := TByPtrRes.Create(vlRes,ParSize,ParSign);
	AddObject(vlByPtr);
	exit(vlByPtr);
end;

function   TInstCreator.GetByPtrOf(ParRes:TResource;ParSize : TSize;ParSign:boolean) : TResource;
var vlRes   : TRegisterRes;
	vlByPtr : TResource;
begin
	vlRes := GuaranteeRegister(ParRes,RH_Pointer);
	vlByPtr := TByPtrRes.Create(vlRes,ParSize,ParSign);
	AddObject(vlByPtr);
	exit(vlByPtr);
end;


function   TInstCreator.GuaranteeRegister(ParRes : Tresource):TRegisterRes;
var
	vlRes      : TRegisterRes;
begin
	if ParRes.fCode <> RT_Register then begin
		vlRes := TRegisterRes(AddMovReg(ParRes,true));
		exit(vlRes);
	end else begin
		exit(TRegisterRes(ParRes));
	end;
end;


function   TInstCreator.GuaranteeRegister(ParRes : Tresource;ParHint : TRegHint):TRegisterRes;
var
	vlRes      : TRegisterRes;
begin
	if ParRes.fCode <> RT_Register then begin
		vlRes := TRegisterRes(AddMovReg(ParRes,true,ParHint));
		exit(vlRes);
	end else begin
		exit(TRegisterRes(ParRes));
	end;
end;

function  TInstCreator.GetOffsetOf(ParRes:TResource;ParSize : TSize;ParSign:boolean):TResource;
var vlInst : TLeaInst;
	vlRes  : TResource;
begin
	vlRes := ReserveRegisterByHint(ParSIze,ParSign,RH_Pointer);
	ParRes.SetSize(0);
	vlInst := TLeaInst.Create;
	vlInst.AddOperand(ParRes,IN_In_1);
	vlInst.AddOperand(vlRes,IN_Main_Out);
	AddInstAfterCur(vlInst);
	vlInst.InstructionFase(self);
	exit(vlRes);
end;


function  TInstCreator.CanChangeResource(parRes:TResource):boolean;
var vlUse:TResourceUse;
begin
	vlUse := fResourceUseList.GetUseFromResource(ParRes);
	if (vlUse = nil)  then exit(true);
	if vlUse.fUnUsed then exit(true);
	exit(vlUse.CanRelease);
end;

procedure TInstCreator.ResourcePRLF(ParRes:TResource);
begin
	fResourceUseList.ResourcePRLF(ParRes);
end;

function TInstCreator.CreateLabel(ParNumber:longint):TInstruction;
var vlName:Longint;
	vlNameStr:string;
begin
	vlName := ParNUmber;
	if vlName = lab_NewName then vlName := GetNewLabelNo;
	str(vlName,vlNameStr);
	vlNameStr := '.L'+vlNameStr;
	exit(TLabelInst.Create(vlNameStr));
	
end;



function TInstCreator.GetNumberResLong(ParNo:cardinal;ParSize:TSize;ParSign:boolean):TNumberRes;
var vlLi : TNumber;
begin
	LoadLong(vlLi,ParNo);
	exit(GetNumberRes(vlLi,ParSize,ParSign));
end;

function TInstCreator.GetNumberRes(ParNo:TNumber;ParSize:TSize;ParSign:boolean):TNumberRes;
var vlSize:TSize;
	vlSign:boolean;
	vlRes:TNumberRes;
begin
	vlSize := ParSize;
	vlSIgn := ParSign;
	if vlSize = 0 then GetIntSize(ParNo,vlSize,vlSign);
	vlRes := TNumberRes.Create(ParNo);
	vlRes.SetSize(vlSize);
	vlRes.SetSign(vlSign);
	AddObject(vlRes);
	GetNumberRes := vlRes;
end;

procedure   TInstCreator.SaveResParts(ParRes:TResource);
begin
	fResourceUseList.SaveResParts(self,ParRes);
end;

Procedure   TInstCreator.InitConfigs;
var vlASF:boolean;
begin
	iAlwaysStackFrame := true;
	voPrintRegisterRes := true;
	if GetConfig.GetVarUpperBool(CONF_Always_Stack_Frame,vlASF) then iAlwaysStackFrame := vlAsf;
	if GetConfig.GetVarUpperBool(CONF_Print_Register_Res,vlASF) then voPrintRegisterRes := vlAsf;
end;


function    TInstCreator.GetPrintRegisterRes:boolean;
begin
	GetPrintRegisterRes := voPrintRegisterRes;
end;


procedure TInstCreator.SetResourceResLong(ParSec:TSecBase;ParMode,ParFixed:boolean);
var vlRes:TResourceUse;
begin
	vlRes := fResourceUseList.GetResourceUse(ParSec);
	if vlRes <> nil then begin
		if ParMode then begin
			vlRes.fResMode := RSM_Long_Reservation;
			vlRes.fFixed   := ParFixed;
			vlRes.fResource.SetLockResource;
		end else begin
			vlRes.fResMode := RSM_Release_On_Use;
			vlRes.fResource.ResetlockResource;
			fResourceUseList.ReleaseResource(vlRes.fResource);
		end;
	end;
end;

constructor TInstCreator.Create(const ParName:string;ParCompiler:TCompiler_Base;ParRoutine : TRoutineAsm);
begin
	iRoutineAsm := ParRoutine;
	inherited Create(ParCompiler);
end;

function TInstCreator.ReserveRegisterDirect(ParSize : TSize;ParSign : boolean):TRegisterRes;
var
	vlRegister : TRegister;
	vlRes      : TRegisterRes;
begin
	vlRegister := voRegisterList.GetFreeRegister(ParSize);
	if vlRegister = nil then exit(nil);
	vlRes := TRegisterRes.Create(vlRegister,ParSize,ParSign);
	AddObject(vlRes);
	DeleteUnUsedByRes(vlRes);
	exit(vlRes);
end;

function TInstCreator.ReserveRegister(ParSize : TSize;ParSign:boolean):TRegisterRes;
var vlRegister : TRegister;
	vlRes      : TRegisterRes;
begin
	vlRegister := voRegisterList.GetFreeRegister(ParSize);
	if vlRegister = nil then begin
		fResourceUseList.PushOldest(self);
		vlRegister := voRegisterList.GetfreeRegister(ParSize);
		if vlRegister = nil then fatal(Fat_Out_Of_Registers,['[Size=',ParSize,']'] );
	end;
{if GetPrintRegisterRes then begin
voRegRes := PRegResComment.Create(voRegister,true);
AddInstAfterCur(voRegRes);
end; }
	vlRes := TRegisterRes.Create(vlRegister,ParSize,ParSign);
	AddObject(vlRes);
	DeleteUnUsedByRes(vlRes);
	ReserveRegister := vlRes;
end;

function TInstCreator.ReserveRegisterByHint(ParSize : TSize;ParSign:boolean;ParHint : TRegHint):TRegisterRes;
var vlRegister : TRegister;
	vlRes      : TRegisterRes;
begin
	vlRegister := voRegisterList.GetFreeRegisterByHint(ParSize,ParHint);
	if vlRegister = nil then begin
		fResourceUseList.PushOldest(self);
		vlRegister := voRegisterList.GetfreeRegister(ParSize);
		if vlRegister = nil then fatal(Fat_Out_Of_Registers,['[Size=',ParSize,']'] );
end;
{if GetPrintRegisterRes then begin
voRegRes := PRegResComment.Create(voRegister,true);
AddInstAfterCur(voRegRes);
end; }
vlRes := TRegisterRes.Create(vlRegister,ParSize,ParSign);
AddObject(vlRes);
DeleteUnUsedByRes(vlRes);
ReserveRegisterByHint := vlRes;
end;


function  TInstCreator.GetCurrentInst:TInstruction;
var vlInst:TInstruction;
begin
	vlInst := voCurrentInstList.GetCurrentInst;
	if vlInst = nil then vlInst := TInstruction(iRoutineAsm.GetLastInstruction);
	GetCurrentInst := vlInst;
end;



procedure TInstCreator.AddInstAfterCur(ParInst:TInstruction);
begin
	iRoutineAsm.AddInstructionAt(GetCurrentInst,parInst);
end;


procedure TInstCreator.AddInstBeforeCur(ParInst:TInstruction);
var vlInstr:TInstruction;
begin
	vlInstr := GetCurrentInst;
	if vlInstr <> nil then vlInstr  := TInstruction(vlInstr.fPrv);
	iRoutineAsm.AddInstructionAt(vlInstr,ParInst);
end;



procedure TInstCreator.PushInst(ParInst:TInstruction);
var vlStr:string;
begin
	if (Parinst.fNxt=nil) and (ParInst.fPrv=nil)
	and (ParInst <> TInstruction(iRoutineAsm.GetFirstInstruction)) then begin
		vlStr := 'AT:TInstCreator.PushInst, [Type='+ParInst.ClassName+']';
		Fatal(FAT_Pushed_inst_Not_In_List,vlStr);
		
	end;
	voCurrentInstList.PushInst(ParInst);
end;

procedure TInstCreator.PopInst;
begin
	voCurrentInstList.PopInst;
end;

procedure TInstCreator.Clear;
begin
	inherited Clear;
	fResourceUseList.destroy;
	iRoutineAsm.Destroy;
	voCurrentInstList.destroy;
end;



procedure TInstCreator.PushAll;
begin
	fResourceUseList.PushAll(self);
end;

function TInstCreator.PopRes(ParStack:TStackRes;ParAfter:boolean):TResource;
var vlRes:TRegisterRes;
	vlSIze : cardinal;
begin
	vlSize := ParStack.fSize;
	if vlSIze <> Size_PushSize then vlSize := size_PushSize;    {Todo: THis is a ugly hack, should be in POPinst}
	vlRes := ReserveRegister(vlSize,ParStack.fSign);
	fResourceUseList.PopRes(self,ParStack,vlRes,parAfter);
	PopRes := vlRes;
end;


function  TInstCreator.CreateStackVar(ParOffs:Toffset;ParSize:TSize;ParSign:boolean):TResource;
var vlRes:TByPtrRes;
	vlReg:TRegister;
	vlPointer :TRegisterRes;
begin
	vlReg := voRegisterList.GetSpecialRegister([CD_StackFrame],GetAssemblerInfo.GetSystemSize);
	if vlReg= nil then begin
		Fatal(Fat_Cant_Get_Stack_Frame_Reg,'At creating local variable');
	end;
	vlPointer := TRegisterRes.Create(vlReg,vlReg.fSize,false);
	AddObject(vlPointer);
	vlRes := TByPtrRes.Create(vlPointer,ParSize,ParSign);
	AddObject(vlRes);
	vlRes.SetExtraOffset(ParOffs);
	createStackVar := TResource(vlRes);
end;

procedure TInstCreator.CrashLIst;
begin
	fResourceUseList.CrashList;
end;


function  TInstCreator.GetNumOfUses:longint;
begin
	GetNumOfUses := fResourceUseList.GetNumItems;
end;


function  TInstCreator.GetRegisterResByName(ParRegister : TNormal): TRegisterRes;
var
	vlRes : TRegisterRes;
	vlReg : TRegister;
begin
	vlReg := voRegisterList.GetRegisterByCode(ParRegister);
    vlRes := TRegisterRes.Create(vlReg,vlReg.fSize,false);
	AddObject(vlRes);
	exit(vlRes);
end;


function TInstCreator.GetAsRegisterByName(ParRegister:TNormal;ParSize : TSize):TRegister;
var vlReg:TRegister;
begin
	vlReg := voRegisterList.GetRegisterByCode(ParRegister);
	GetAsRegisterByName := vlReg;
	if (vlreg <> nil) and (vlReg.fSize <> ParSize) then begin
		GetAsRegisterByName := voRegisterList.GetAsRegister(vlReg,ParSize);
	end;
end;


function TInstCreator.GetAsRegister(ParReg:TRegisterRes;ParSize : TSize;ParSign:boolean):TRegisterRes;
var vlReg : TRegister;
	vlRes : TRegisterRes;
begin
	vlRes := nil;
	vlReg := voRegisterList.GetAsRegister(Parreg.fRegister,ParSize);
	if vlReg <> nil then begin
		vlRes := TRegisterRes.Create(vlReg,ParSize,ParSign);
		AddObject(vlRes);
	end;
	exit(vlRes);
end;


function  TInstCreator.ForceReserveRegister(ParCre:TInstCreator;parRegister:TNormal;ParSign:boolean):TRegisterRes;
var vlRes : TRegisterRes;
	vlReg : TRegister;
	vlStr : String;
begin
	vlreg := voRegisterList.GetRegisterByCOde(ParRegister);
	if vlReg = nil then begin
		str(ParRegister,vlStr);
		Fatal(FAT_Cant_Find_Register,'At:ForceReserveRegister [Reg='+vlStr+']');
	end;
	vlRes := TRegisterRes.Create(vlReg,vlReg.fSize,ParSign);
	AddObject(vlRes);
	fResourceUseList.SaveResParts(ParCre,vlRes);
	DeleteUnUsedByRes(vlRes);
	ForceReserveRegister := vlRes;
end;

{Contains hack for .size assembler instruction}



function  TInstCreator.GetSpecialRegister(PArType:TAsmStorageCanDo;ParSize : TSize;ParSign:boolean):TRegisterRes;
var
    vlReg : TRegister;
	vlRes : TRegisterRes;
begin
	vlReg := voRegisterList.GetSpecialRegister(ParType,ParSize);
	vlRes := nil;
	if vlReg <> nil then begin
		vlRes := TRegisterRes.Create(vlReg,vlReg.fSize,ParSign);
		AddObject(vlRes);
	end;
	exit(vlRes);
end;

procedure TInstCreator.AddSpAdd(ParNo:TSize;ParNeg:boolean);
var
	vlStack : TRegisterRes;
	vlNum   : TNumberRes;
	vlSub   : TTwoInst;
begin
	if ParNO = 0 then exit;
	vlStack := getSpecialRegister([CD_StackPointer],GetAssemblerInfo.GetSystemSize,false);
	vlNum   := GetNumberResLong(ParNo,vlStack.fSize,false);
	if ParNEg then vlSub   := TSubInst.Create
	else vlSub   := TAddInst.Create;
	vlSub.AddOperand(vlStack,In_Main_Out or In_In_1);
	vlSub.AddOperand(vlNum,In_In_2);
	AddInstAfterCur(vlSub);
end;


function TInstCreator.AddMovFrSt(ParDir:boolean):TResource;
var vlStack:TRegisterRes;
	vlFrame:TRegisterRes;
	vlMov:TMovInst;
	vlN1,vlN2: TFlag;
begin
	vlStack := GetSpecialRegister([CD_StackPointer],GetAssemblerInfo.GetSystemSize,false);
	if vlStack = nil then Fatal(FAT_Cant_Get_Stack_Pointer,'');
	vlFrame := GetSpecialRegister([CD_StackFrame],GetAssemblerInfo.GetSystemSize,false);
	if vlFrame = nil then Fatal(FAT_Cant_Get_Stack_Frame_Reg,'');
	vlMov := TMovInst.Create;
	vlN1 := In_In_1;vlN2 := IN_Main_out;
if ParDir then begin vlN1 := In_Main_Out ;vln2 := In_In_1;end;
	vlMov.AddOperand(vlStack,vlN1);
	vlMov.AddOperand(vlFrame,vlN2);
	AddInstAfterCur(vlMov);
	exit(vlFrame);
end;


procedure TInstCreator.SetOutputLock(ParSec : TSecBase;ParLock : boolean);
begin
	fResourceUseList.SetOutputLock(ParSec,ParLock);
end;

procedure TInstCreator.ChangeResource(ParOldRes,ParNewRes:TResource);
begin
	fResourceUseList.ReplaceResource(ParOldRes,ParNewRes);
end;




procedure TInstCreator.print(parDis:TAsmDisplay);
begin
	iRoutineAsm.Print(ParDis);
end;

procedure TInstCreator.CommonSetup;
begin
	inherited CommonSetup;
	InitConfigs;
	iResourceUseList    := TResourceUseList.Create;
	voRegisterList	    := GetAssemblerInfo.fRegisterList;
	voRegisterList.ResetStates;
	voCurrentInstList   := TCurrentInstList.Create;
end;


function  TInstCreator.AddMovReg(ParIn:TResource;ParAfter:boolean):TResource;
var vlNewRes:TResource;
begin
	vlNewRes := ReserveRegister(ParIn.fSize,ParIn.fSign);
	AddMov(vlNewRes,ParIn,ParAfter);
	exit( vlNewRes);
end;

function  TInstCreator.AddMovReg(ParIn:TResource;ParAfter:boolean;ParHint : TRegHint):TResource;
var vlNewRes:TResource;
begin
	vlNewRes := ReserveRegisterByHint(ParIn.fSize,ParIn.fSign,ParHint);
	AddMov(vlNewRes,ParIn,ParAfter);
	exit(vlNewRes);
end;

function TInstcreator.AddMov(ParOut,ParIn:TResource;ParAfter,ParIf:boolean) :TInstruction;
var vlInst : TInstruction;
begin
	vlInst := TMovInst.Create;
	if ParAfter then AddInstAfterCur(vlInst)
	else AddInstBeforeCur(vlInst);
	pushInst(vlInst);
	vlInst.AddOperand(ParOut,In_Main_Out);
	vlInst.AddOperand(ParIn,In_In_1);
	if ParIf then vlInst.InstructionFase(self);
	popInst;
	exit(vlInst);
end;


procedure TInstcreator.AddMov(ParOut,ParIn:TResource;ParAfter : boolean);
begin
	AddMov(ParOut,ParIn,ParAfter,true);
end;

procedure TInstCreator.ReleaseResource(ParRes:TResource);
begin
	fResourceUseList.ReleaseResource(parRes);
end;


function TInstCreator.ReserveResourceByUse(ParSec:TSecBase):TResource;
begin
	exit( fResourceUseList.ReserveResource(ParSec));
end;

procedure TInstCreator.SetResourceUse(ParSec:TSecBase;ParRes:TResource);
begin
	fResourceUseList.SetResourceUse(ParSec,ParRes);
end;


{----( TResourceUseList )--------------------------------------------}



procedure TResourceUseLIst.PushOldest(ParCre:TInstCreator);
var vlCurrent:TResourceUSe;
begin
	vlCurrent := TResourceUse(fStart);
	while vlCurrent <> nil do begin
		if (vlCurrent.fResource.fCode <> RT_Stack)and not(vlCurrent.fOutLock) and not(vlCurrent.fFixed) and not(vlCurrent.fUnUsed) then begin
			PushRes(ParCre,vlCurrent.fResource,false);
			break;
		end;
		vlCurrent := TResourceUse(vlCurrent.fNxt);
	end;
end;

function  TResourceUseList.GetStackResItemByPos(ParPos:longint):TResourceUse;
var vlCurrent:TResourceUse;
	vlRes:TResource;
begin
	vlCurrent := TResourceUse(fStart);
	while vlCurrent<> nil do begin
		vlRes:= vlCurrent.fResource;
		if (vlRes.fCode = RT_Stack) then begin
			if TStackRes(vLRes).fStackPos = ParPos then break;
		end;
		vlCurrent := TResourceUse(vlCurrent.fNxt);
	end;
	GetStackResItemByPos := vlCurrent;
end;


procedure TResourceUSeList.CrashList;
var vlRes:TResourceUSe;
begin
	vlRes := TResourceUSe(fStart);
	while vlRes <> nil do begin
		vlRes.fResource.IsSame(vlRes.fResource);
		vlRes := TResourceUSe(vlRes.fNxt);
	end;
end;


procedure  TResourceUseList.SaveResParts(ParCre:TInstCreator;ParRes:TResource);
var vlUse     : TResourceUse;
	vlItemRes : TResource;
	vlNewRes  : TResource;
	vlInst    : TInstruction;
	vlItem    : TResourceUse;
begin
	vlUse := TResourceUse(fStart);
	while vlUse <> nil do begin
		vlItem := TResourceUse(vlUse.fNxt);
		if (vlUse.IsPart(ParRes)) and not(vlUse.fOutLock) then begin
			if vlUse.fUnUsed then begin
				deletelink(vlUse);
			end else begin
				vlItemRes := vlUse.fResource;
				vlNewRes  := ParCre.ReserveRegisterDirect(vlItemRes.fSize,vlItemRes.fSign);
				if vlNewRes = nil then begin
					PushOldest(ParCre);
					vlItem := TResourceUse(fStart);
				end else begin
					vlUse.SetResource(vlNewRes);
					vlInst := TMovInst.Create;
					vlInst.AddOperand(vlNewRes,In_Main_Out);
					vlInst.AddOperand(vlItemRes,In_In_1);
					vlItemRes.IsUsed;
					vlNewRes.IsUsed;
					vlNewRes.ReserveResource;
					ParCre.AddInstBeforeCur(vlInst);
				end;
			end;
		end;
		vlUse := vlItem;
	end;
end;

function TResourceUseList.AddResource(ParSec:TSecBase;ParRes:TResource):TResourceUse;
var vlUse:TResourceUse;
begin
	vlUse := TResourceUse.Create(ParSec);
	vlUse.SetResource(ParRes);
	insertAtTop(vlUse);
	exit(vlUse);
end;

procedure TResourceUseList.ReleaseResource(PArRes:TResource);
var
	vlUse:TResourceUse;
	vlNext:TResourceUse;
begin
	vlUse := GetUseFromResource(ParRes);
	if (vlUse = nil) or ((vlUse.CanRelease) and not(vlUse.fOutLock)) then begin
		if not ParRes.CanReleaseFromUse then fatal(fat_try_rel_res_from_use,ParRes.ClassName);
		ParRes.BeforeRelease;
		if vlUse <> nil then begin
			if iUnUseOpt and  ParRes.CanKeepInUse then begin
				vlUse.fUnUsed := true;
			end else begin
				deletelink(vlUse);
				if iUnUseOpt then begin
					vlUse := TResourceUse(fStart);
					while (vlUse <> nil) do begin
						vlNext := TResourceUse(vlUse.fNxt);
						if vlUse.IsUsing(ParRes) then begin
							if not vlUse.fUnUsed then fatal(FAT_Dep_Res_In_Use,'');
							deletelink(vlUse);
						end;
						vlUse := vlNext;
					end;
				end;
			end;
		end;
	end;
end;




function  TResourceUseList.GetUseFromResource(ParRes:TResource):TResourceUse;
var vlCurrent:TResourceUse;
begin
	vlCurrent := TResourceUse(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.fResource = ParRes) do begin
		vlCurrent := TResourceUse(vlCurrent.fNxt);
	end;
	exit(vlCurrent);
end;


procedure TResourceUseList.ResourcePRLF(ParRes:TResource);
var
	vlUse : TResourceUse;
begin
	vlUse := GetUSeFromResource(PArRes);
	if  ( not ParRes.CanReleaseFromUse) then Fatal(FAT_Try_Rel_Res_From_Use,ParRes.ClassName);
	if (vlUse <> nil) and (vlUse.CanRelease)  then begin
		if iUnUseOpt then begin
			vlUse.fUnUsed := true;
		end else begin
			DeleteLInk(vlUse);
		end;
	end;
end;


function  TResourceUseList.GetResourceUse(ParSec:TSecBase):TResourceUse;
var vlCurrent:TResourceUSe;
begin
	vlCurrent := TResourceUSe(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.fSec.IsSame(ParSec)) do vlCurrent := TResourceUse(vlCurrent.fNxt);
	exit(vLCurrent);
end;


function TResourceUseList.GetResource(ParSec:TSecBase):TResource;
var vlCurrent:TResourceUse;
begin
	GetResource := nil;
	vlCurrent := GetResourceUse(parSec);
	if vlCurrent <> nil then GetResource := vlCurrent.fResource;
end;

function TResourceUseList.ReserveResource(ParSec : TSecBase) : TResource;
var vlUse      : TResourceUse;
	vlResource : TResource;
begin
	vlResource := nil;
	vlUse := GetResourceUse(ParSec);
	if vlUse <> nil then begin
		if vlUse.fUnUsed then begin
			CutOut(vlUse);
			InsertAt(nil,vlUse);
		end;
		vlUse.fUnUsed  := false;
		vlResource    := vlUse.fResource;
	end;
	exit(vlResource);
end;


function TResourceUseList.SetResourceUse(ParSec:TSecBase;ParRes:TResource):TResourceUse;
var
	vlCurrent : TResourceUse;
begin
	vlCurrent :=nil;
	if (ParSec<> nil) and (ParRes.GetMode(RM_InList)) then begin
		vlCurrent := GetResourceUse(parSec);
		if (vlCurrent <> nil) and (vlCurrent.CanRelease)  then begin
			vlCurrent.SetResource(ParRes);
			{     if vlCurrent.fUnUsed then fatal(FAT_Try_Change_UnUsed_Res,'');}
			
		end else begin
			vlCurrent := AddResource(ParSec,ParRes);
		end;
		ParRes.ReserveResource;
		
	end;
	exit(vlCurrent);
end;

procedure TResourceUseList.AddUnUsedResource(ParSec : TSecBase;ParRes : TResource);
var
	vlUse : TResourceUse;
begin
	if iUnUseOpt and (GetResourceUse(ParSec) = nil) and (ParRes.CanKeepInUse)  then begin
		vlUse := AddResource(ParSec,ParRes);
		vlUse.fUnUsed := true;
	end;
end;

procedure TResourceUseList.PushAll(ParCre:TInstCreator);
var vlCurrent:TResourceUse;
	vlNxt  : TResourceUse;
	vlRes: TResource;
begin
	vlCurrent := TResourceUse(fStart);
	while vlCurrent <> nil do begin
		vlNxt := TResourceUse(vlCurrent.fNxt);
		if not vlCurrent.fUnUsed then begin
			if (vlCurrent.fResource.fCode <> RT_Stack)and not(vlCurrent.fOutLock) and not(vlCurrent.fFixed)  then begin
				if vlCurrent.fResource is TByPtrRes then begin {THis is a hack}
					if not(TByPtrRes(vlCurrent.fResource).GetPointer.fCode <> RT_Stack) then begin
						vlRes := PushRes(ParCre,TByPtrRes(vlCurrent.fResource).GetPointer,true);
						TByPtrRes(vlCurrent.fResource).SetPointer(TRegisterRes(vlRes));
					end;
				end else begin
					PushRes(ParCre,vlCurrent.fResource,true);
				end;
			end;
		end;
		vlCurrent := vlNxt;
	end;
end;


function TResourceUseList.PushRes(ParCre:TInstCreator;ParRes:TResource;ParAfter:boolean):TStackRes;
var vlStack : TStackRes;
	vlLev   : longint;
	vlPush  : TPushInst;
	vlUse   : TResourceUse;
	vlPrvMd : TReserveMode;
begin
	IncStackCnt;
	vlUse   := GetUseFromResource(ParRes);
	
	if vlUse <> nil then begin
		if vlUse.fUnUsed then fatal(FAT_Try_Change_UnUsed_Res,'');
		
		vlPrvMd:=vlUse.fResMode;
		vlUse.fResMode := RSM_Long_Reservation;
	end;
	vlLev   := GetStackCnt;
	vlStack := TStackRes.Create(ParRes.fSize,ParRes.fSign);
	ParCre.AddObject(vlStack);
	vlStack.fStackPos := vlLev;
	if(vlUse <> nil) then vlUse.SetResource(vlStack);
	vlPush := TPushInst.Create;
	vlPush.AddOperand(ParRes,In_In_1);
	vlPush.AddOperand(vlStack,In_Main_Out);
	if ParAfter then ParCre.AddInstAfterCur(vlPush)
	else ParCre.AddInstBeforeCur(vlPush);
	vlPush.InstructionFase(ParCre);
	if vlUse <> nil then begin
		vlUse.fResMode := vlPrvMd;
	end;
	exit(vlStack);
end;

procedure TResourceUseList.PopRes(ParCre:TInstCreator;ParStack:TStackRes;ParBy:TResource;ParAfter:boolean);
var vlUse : TResourceUse;
	vlPop : TPopInst;
	vlRes : TResource;
begin
	if ParStack.fStackPos <> GetStackCnt then fatal(FAT_Pop_Not_At_Top,'');
	if GetStackCnt = 0 then fatal(FAT_At_Temp_Stack_Bottom,'');
	vlUse := GetStackResItemByPos(GetStackCnt);
	if vlUse = nil then Fatal(Fat_Cant_Find_stack_Resource,['Stack pos=',GetStackCnt]);
	vlRes := ParBy;
	vlUse.SetResource(vlRes);
	vlPop := TPopInst.Create;
	vlPop.AddOperand(vlRes,In_Main_Out);
	if ParAfter then ParCre.AddInstAfterCur(vlPop)
	else ParCre.AddInstBeforeCur(vlPop);
	vlPop.InstructionFase(ParCre);
	DecStackCnt;
end;

procedure TResourceUseList.IncStackCnt;
begin
	inc(voStackCnt);
end;

procedure TResourceUseList.SetStackCnt(ParCnt:Longint);
begin
	voStackCnt :=ParCnt;
end;

function  TResourceUSeList.GetStackCnt:longint;
begin
	GetStackCnt := voStackCnt;
end;

procedure TResourceUseList.DecStackCnt;
begin
	if voStackCnt > 0 then dec(voStackCnt);
end;


procedure TResourceUseList.Commonsetup;
begin
	inherited CommonSetup;
	SetStackCnt(0);
	iUnUseOpt :=  opt_keep_relaxed_contents in GetConfigValues.fOptimizeModes;
end;

procedure TResourceUseList.SetOutputLock(ParSec : TSecBase;ParLOck:boolean);
var
	vlUse : TResourceUse;
begin
	vlUse := GetResourceUse(ParSec);
	if (vlUse <> nil) then begin
		vlUse.SetOutputLock(ParLock);
		if ParLOck then vlUse.fUnUsed := false;
		if not ParLock then begin
			{hack this routine is called from formbasepoc after resource list fase
			the use count should be decremented. Has nothing todo with Setoutput lock
			but it is conviniend}
			if ParSec is TOutputmac then begin {also an hack because of exit statement}
				ReleaseResource(vlUse.fResource);
			end else begin
				if not(vlUse.fResource is TByPtrRes) then begin
					if (not vlUse.fResource.GetMode(RM_InList))
					and (not vlUse.fResource.GetMode(RM_Keep_For_UnUsed))
					then begin
						deletelink(vlUse);
					end else begin
						vlUse.fResource.IsUsed;
						vlUse.fResource.ReserveResource;
					end;
				end else begin
					vlUse.fUnused := true;
				end;
			end;
		end;
	end;
end;


function  TResourceUseList.ReplaceResource(ParOld,ParNew:TResource):boolean;
var vlUse:TResourceUse;
begin
	vlUse := GetUseFromResource(ParOld);
	ReplaceResource := true;
	if vlUse <> nil then begin
		if vlUse.fUnUsed then fatal(FAT_Try_Change_UnUsed_Res,'');
		if vlUse.fFixed  then fatal(FAT_Try_To_Push_Fixed,['[Old=',ParOld.ClassName,'][',ParNew.ClassName,']']);
		ReplaceResource := false;
		vlUse.SetResource(ParNew);
	end;
end;


function  TResourceUseList.ReplaceUnUsedResource(ParOld,ParNew:TResource):boolean;
var
	vlUse:TResourceUse;
begin
	vlUse := GetUseFromResource(ParOld);
	ReplaceUnUsedResource := true;
	if (vlUse <> nil) and (vlUse.fUnUsed) then begin
		if not ParNew.CanKeepInUse then begin
			deletelink(vlUse);
		end else begin
			if  (vlUse.fFixed) then fatal(FAT_Try_To_Push_Fixed,['[Old=',ParOld.ClassName,'][',ParNew.ClassName,']']);
			ReplaceUnUsedResource := false;
			vlUse.SetResource(ParNew);
		end;
	end;
end;

procedure TResourceUseList.DeleteUnusedByRes(ParRes : TResource);
var
	vlUse : TResourceUSe;
	vlNxt : TResourceUse;
begin
	
	vlUse := TResourceUse(fStart);
	while (vlUse <> nil) do begin
		vlNxt := TResourceUse(vlUse.fNxt);
		if (vlUse.IsPart(ParRes)) then begin
			if vlUse.fUnUsed then DeleteLink(vlUse);
		end;
		vlUse := vlNxt;
	end;
	
end;


procedure TResourceUseList.DeleteUnusedByMac(ParSec : TSecBase;ParMode : TUnUsedDeleteMode);
var
	vLCurrent :TResourceUse;
begin
	vlCurrent := GetResourceUse(ParSec);
	if vlCurrent <> nil then begin
		if (vLCurrent.fUnUsed) and ((ParMode<> UDM_Output) or not (vlCurrent.fResource.GetMode(RM_Can_UnUsed_Output))) then deleteLink(vlCurrent);
	end;
end;

procedure TResourceUseList.DeleteUnusedUse;
var
	vlNxt : TResourceUse;
	vlCurrent :TResourceUse;
begin
	vlCurrent := TResourceUSe(fStart);
	while (vlCurrent <> nil) do begin
		vlNxt := TResourceUse(vlCurrent.fNxt);
		if (vlCurrent.fUnUsed)  then DeleteLink(vlCurrent);
		vlCurrent := vlNxt;
	end;
end;

procedure TResourceUseList.DumpList;
var
	vlCurrent : TResourceUse;
begin
	vlCurrent := TResourceUse(fStart);
	while (vlCurrent <> nil) do begin
		writeln(cardinal(vlCUrrent.fSec),' ',vlCurrent.fSec.ClassName,' ',vlCurrent.fResource.classname,' ',vlCurrent.fUnUsed);
		if vlCurrent.fResource is TRegisterRes then begin
			writeln('Reg:',TRegisterRes(vlCurrent.fResource).GetRegisterCode);
		end;
		vlCurrent := TResourceUse(vlCurrent.fNxt);
	end;
end;

end.
