{    Elaya, the compiler for the elasya language
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

unit varuse;
interface
uses compbase,simplist,error,progutil;
type
{TODO AM_WRITE_READ en AM_READ_WRITE}
TVarUseMode=(VM_Not,VM_Sometimes,VM_Used);
TAccessStatus=(AS_Normal,AS_No_Read,AS_Maybe_No_Read,AS_No_Write,AS_Maybe_No_Write,AC_Ident_Not_Found);
TAccessMode = (AM_Read,AM_ReadWrite,AM_Write,AM_Nothing,AM_Execute,AM_SizeOf,AM_PointerOf,AM_Silent_Read_Write);
{TODO Instead of using TDefinitionUseList everywhere, use a sort of  TDefinitionUseItem}
TDefinitionUseList=class;
TDefinitionUseItemBase=class(TSMListItem)
			private
				voDefinition : TBaseDefinition;
         	voContext    : TDefinitionUseItemBase;
			protected
				property iDefinition : TBaseDefinition        read voDefinition write voDefinition;
            property iContext    : TDefinitionUseItemBase read voContext    write voContext;
            procedure Commonsetup;override;
			public
				property fDefinition : TBaseDefinition        read voDefinition ;
            property fContext    : TDefinitionUseItemBase read voContext write voContext;
				constructor Create(ParDefinition : TBaseDefinition);
				function IsDefinition(ParDefinition : TBaseDefinition) : boolean;
				procedure CheckUnused(ParCre : TCreator;ParOwner : TBaseDefinition);virtual;abstract;
				procedure CombineFlow(ParOther : TDefinitionUseItemBase);virtual;abstract;
				procedure SetElseMode(ParElse :TDefinitionUseItemBase);virtual;abstract;
				function Clone : TDefinitionUseItemBase;virtual;abstract;
				procedure SetLike(ParItem : TDefinitionUseItemBase);virtual;abstract;
				function GetName : string;
				function SetAccess(ParMode : TAccessMode):TAccessStatus;virtual;abstract;
				procedure SetDefault(ParRead :boolean);virtual;abstract;
				function IsUnused:boolean;virtual;abstract;
				procedure SetToSometimes;virtual;abstract;
            function GetSubList : TDefinitionUseList;virtual;
            function IsCompleetInitialised : TVarUseMode;virtual;abstract;
			   procedure CombineIfWithElseUse(ParElse : TDefinitionUseItemBase);virtual;abstract;
         end;

TDefinitionUseItem=class(TDefinitionUseItemBase)
            private
    			voWrite      : TVarUseMode;
				voRead		 : TVarUseMode;
				voRunRead    : TVarUseMode;

			protected
				property iRunRead   : TVarUseMode read voRunRead    write voRunRead;
				property iWrite     : TVarUseMode read voWrite      write voWrite;
				property iRead      : TVarUseMode read voRead       write voRead;
				procedure commonsetup;override;
				function CombineModes(ParMode1,ParMode2 : TVarUseMode) : TVarUseMode;
				function CombineITRRUseModes(ParPMode,ParITMode : TVarUseMode) : TVarUsemOde;
				function SetRead : TAccessStatus;
				function SetWrite: TAccessStatus;

			public
				property fRead      : TVarUseMode read voRead;
				property fRunRead   : TVarUseMode read voRunRead;
				property fWrite     : TVarUseMode read voWrite;
				procedure CheckUnused(ParCre : TCreator;ParOwner : TBaseDefinition); override;
				procedure CombineFlow(ParOther : TDefinitionUseItemBase);override;
				function  Clone : TDefinitionUseItemBase;override;
				procedure SetLike(ParItem : TDefinitionUseItemBase);override;
				function  SetAccess(ParMode : TAccessMode):TAccessStatus;override;
				procedure SetDefault(ParRead :boolean);override;
				function  IsUnused:boolean;override;
				procedure SetToSometimes;override;
            function  IsCompleetInitialised : TVarUseMode;override;
			   procedure CombineIfWithElseUse(ParElse : TDefinitionUseItemBase);override;
				function  CombineIfAndElseUseModes(ParModeIf,ParModeElse : TVarUseMode) : TVarUseMode;
end;



TDefinitionUseList=class(TSMList)
		private
				voOwner      : TBaseDefinition;
            voContext     : TDefinitionUseItembase;

				property iOwner     : TBaseDefinition read voOwner write voOwner;
            property iContext : TDefinitionUseItemBase read voContext write voContext;
 		protected
      		procedure commonsetup;override;
				procedure AddListTo(ParList : TDefinitionUseList);

			public
            property fContext : TDefinitionUseItemBase read voContext write voContext;

				function GetItemByDefinition(parDefinition :TBaseDefinition):TDefinitionUseItemBase;
				function SetAccess(ParDefinition : TBaseDefinition;ParMode : TAccessMode;var ParItem : TDefinitionUseItemBase) : TAccessStatus;
				function Clone:TDefinitionUseList;
            procedure CloneIntoList(ParList : TDefinitionUseList);
				procedure CombineFlow(ParTo : TDefinitionUseList);
				procedure CheckUnused(ParCre : TCreator);
				constructor Create(ParDefinition : TBaseDefinition);
				procedure   SetToSometimes;
         	procedure AddItem(ParItem : TDefinitionUseItemBase);
				function GetOrAddUseItem(ParDefinition : TBaseDefinition) : TDefinitionUseItemBase;
       		procedure CombineIfWithElseUse(ParList : TDefinitionUseList);
			end;

	TStructDefinitionUseSubList=class(TDefinitionUseList)
		public
				procedure SetAllDefault(ParRead :boolean);
				function AreAllInitialised : TVarUseMode;
				procedure SetAllAccessSilent(ParMode : TAccessMode);
	end;

TStructDefinitionUseItem=class(TDefinitionUseItemBase)
private
	voSubList : TStructDefinitionUseSubList;
protected
	property iSubList : TStructDefinitionUseSubList read voSubList write voSubList;
	procedure Commonsetup;override;
	procedure Clear;override;
public
	property fSubList : TStructDefinitionUseSubList read voSubList;
	function GetSubList : TDefinitionUseList;override;
	procedure CombineFlow(ParOther : TDefinitionUseItemBase);override;
	procedure SetToSometimes;override;
	function SetAccess(ParMode : TAccessMode):TAccessStatus;override;
	procedure CheckUnused(ParCre : TCreator;ParOwnerBase : TBaseDefinition);override;
   function Clone : TDefinitionUseItemBase;override;
   function IsCompleetInitialised : TVarUseMode;override;
	procedure SetDefault(ParRead:boolean);override;
	procedure CombineIfWithElseUse(ParElse : TDefinitionUseItemBase);override;

end;

implementation
uses ddefinit;


{---( TStructDefinitionUseSubList )-----------------------------------------------------------}
procedure TStructDefinitionUseSubList.SetAllDefault(ParRead:boolean);
var
	vlCurrent : TDefinitionUseItemBase;
begin
	vlCurrent := TDefinitionUseItemBase(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.SetDefault(ParRead);
		vlCurrent  := TDefinitionUseItemBase(vlCurrent.fNxt);
	end;
end;

procedure TStructDefinitionUseSubList.SetAllAccessSilent(ParMode : TAccessMode);
var
	vlCurrent : TDefinitionUseItemBase;
begin
	vlCurrent := TDefinitionUseItemBase(fStart);
	while vlCurrent <> nil do begin
			vlCurrent.SetAccess(ParMode);
			vlCurrent := TDefinitionUseItemBase(vlCurrent.fNxt);
	end;
end;

function TStructDefinitionUseSubList.AreAllInitialised : TVarUseMode;
var
	vlCurrent : TDefinitionUseItemBase;
	vlResultStatus  : TVarUseMode;
   vlStatus        : TVarUseMode;
begin
	vlCurrent := TDefinitionUseItemBase(fStart);
   vlResultStatus := VM_Used;
	while(vlCurrent <> nil) do begin
		vlStatus := vlCurrent.IsCompleetInitialised;
		if(vlStatus = VM_not) then exit(VM_Not);
		if(vlStatus = VM_SomeTimes) and (vlResultStatus=VM_Used) then vlResultStatus := VM_SomeTimes;
		vlCurrent := TDefinitionUSeItemBase(vlCurrent.fNxt);
	end;
	exit(vlResultStatus);
end;



{---( TStructDefinitionUseItem)----------------------------------------------------------------}

procedure TStructDefinitionUseItem.CombineIfWithElseUse(ParElse : TDefinitionUseItemBase);
begin
	if not(ParElse is TStructDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,ParElse.classname);
	iSubList.CombineIfWithElseUse(TStructDefinitionUseItem(ParElse).fSubList);
end;

procedure TStructDefinitionUseItem.SetDefault(ParRead:boolean);
begin
	iSubList.SetAllDefault(ParRead);
end;


function TStructDefinitionUseItem.IsCompleetInitialised : TVarUSeMode;
begin
	exit(iSubList.AreAllInitialised);
end;


function TStructDefinitionUseItem.GetSubList : TDefinitionUseList;
begin
	exit(iSubList);
end;

function TStructDefinitionUseItem.Clone : TDefinitionUseItemBase;
var
	vlItem : TStructDefinitionUseItem;
begin
	vlItem := TStructDefinitionUseItem.Create(iDefinition);
   iSubList.CloneIntoList(vlItem.fSubList);
   exit(vlItem);
end;

procedure TStructDefinitionUseItem.CheckUnused(ParCre : TCreator;ParOwnerBase : TBaseDefinition);{TODO}
begin
	iSubList.CheckUnUsed(ParCre);
end;

function TStructDefinitionUseItem.SetAccess(ParMode : TAccessMode):TAccessStatus;
var
	vlStatus : TAccessStatus;
	vlMode : TVarUseMode;
begin
	vlStatus := AS_Normal;
	vlMode := IsCompleetInitialised;
	case ParMode of
	   AM_Read:  begin
			case vlMode of
				VM_Sometimes : vlStatus := AS_Maybe_No_Write;
				VM_Not       : vlStatus := AS_No_Write;
			end;
		end;
	end;
	iSubList.SetAllAccessSilent(ParMode);
	exit(vlStatus);
end;


procedure TStructDefinitionUseItem.Commonsetup;
begin
	inherited Commonsetup;
	iSubList := TStructDefinitionUseSubList.Create(nil);
   iSubList.fContext := self;
end;

procedure TStructDefinitionUseItem.Clear;
begin
	inherited Clear;
	if iSubList <> nil then iSubList.Destroy;
end;


procedure TStructDefinitionUseItem.CombineFlow(ParOther : TDefinitionUseItemBase);
begin
	if not(ParOther is TStructDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,classname+'=>'+ParOther.className);
	iSubList.CombineFlow(TStructDefinitionUseItem(ParOther).iSubList);
end;

procedure TStructDefinitionUseItem.SetToSometimes;
begin
	iSubList.SetToSomeTimes;
end;


{---( TDefinitionUseListBase )------------------------------------------------------------------}

procedure TDefinitionUseList.CombineIfWithElseUse(ParList : TDefinitionUseList);
var
	vlCurrent : TDefinitionUseItemBase;
	vlElse    : TDefinitionUseItemBase;
begin
	vlCurrent := TDefinitionUseItemBase(fStart);
   while (vlCurrent <> nil) do begin
		vlElse := ParList.GetItemByDefinition(vlCurrent.fDefinition);
		if (vlElse <> nil) then begin
			vlCurrent.CombineIfWithElseUse(vlElse);
			ParList.DeleteLink(vlElse);
		end else begin
			vlCurrent.SetToSomeTimes;
		end;
		vlCurrent := TDefinitionUseItemBase(vlCurrent.fNxt);
	end;
	if not(ParList.IsEmpty) then begin
		ParList.SetToSomeTimes;
		ParList.AddListTo(self);
	end;
end;

procedure TDefinitionUseList.AddListTo(ParList : TDefinitionUseList);
var
	vlCurrent : TDefinitionUseItemBase;
begin
	while fStart <> nil do begin
		vlCurrent := TDefinitionUseItemBase(fStart);
		CutOut(vlCurrent);
		ParList.AddItem(vlCurrent);
	end;
end;


procedure TDefinitionUseList.Commonsetup;
begin
	inherited Commonsetup;
   iContext := nil;
end;

procedure TDefinitionUseList.AddItem(ParItem : TDefinitionUseItemBase);
begin
	insertat(nil,ParItem);
   ParItem.fContext := fContext;
end;

procedure TDefinitionUseLIst.SetToSometimes;
var
	vlCurrent : TDefinitionUseItemBase;
begin
	vlCurrent := TDefinitionUseItemBase(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.SetToSomeTimes;
		vlCurrent := TDefinitionUseItemBase(vlCurrent.fNxt);
	end;
end;



constructor TDefinitionUseList.Create(ParDefinition : TBaseDefinition);
begin
	iOwner := ParDefinition;
	inherited Create;
end;

procedure TDefinitionUseList.CheckUnused(ParCre : TCreator);
var
	vlCurrent : TDefinitionUseItemBase;
begin
	vlCurrent := TDefinitionUseItem(fStart);

	while vlCurrent <> nil do begin
		vlCurrent.CheckUnused(ParCre,iOwner);
		vlCUrrent := TDefinitionUseItem(vlCurrent.fNxt);
	end;
end;


procedure TDefinitionUseList.CombineFlow(ParTo : TDefinitionUseList);
var
	vlCurrent1 : TDefinitionUseItemBase;
	vlCurrent3 : TDefinitionUseItemBase;
	vlCurrent2 : TDefinitionUseITemBase;
begin
	vlCurrent1 := TDefinitionUseItem(fStart);
	while vlCurrent1 <> nil do begin
		vlCurrent3 := ParTo.GetItemByDefinition(vlCurrent1.fDefinition);
		if vlCurrent3 <> nil then begin
			 vlCurrent3.CombineFlow(vlCurrent1);
		end else begin
			vlCurrent2 := vlCurrent1.clone;
			vlCurrent2.SetToSomeTimes;
			ParTo.AddItem(vlCurrent2);
		end;
		vlCurrent1 := TDefinitionUseItem(vlCurrent1.fNxt);
	end;
end;

function TDefinitionUseList.Clone:TDefinitionUseList;
var
	vlCurrent : TDefinitionUseItemBase;
	vlList :TDefinitionUseList;
begin
	vlCurrent := TDefinitionUseItemBase(fStart);
	vlList := TDefinitionUseList.Create(iOwner);
	while vlCurrent <> nil do begin
		vlList.AddItem(vlCurrent.Clone);
		vlCurrent := TDefinitionUseItemBase(vlCUrrent.fNxt);
	end;
	exit(vlList);
end;

procedure TDefinitionUseList.CloneIntoList(ParList : TDefinitionUseList);
var
	vlCurrent : TDefinitionUseItemBase;
begin
	vlCurrent := TDefinitionUseItemBase(fStart);
	while vlCurrent <> nil do begin
		ParList.AddItem(vlCurrent.Clone);
		vlCurrent := TDefinitionUseItemBase(vlCUrrent.fNxt);
	end;
end;


function TDefinitionUseList.GetItemByDefinition(parDefinition :TBaseDefinition):TDefinitionUseItemBase;
var
	vlCurrent : TDefinitionUseItem;
begin
	vlCurrent := TDefinitionUseItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsDefinition(ParDefinition)) do vlCurrent := TDefinitionUseItem(vlCurrent.fNxt);
	exit(vlCurrent);
end;


function TDefinitionUseList.GetOrAddUseItem(ParDefinition : TBaseDefinition) : TDefinitionUseItemBase;
var
	vlItem : TDefinitionUseItemBase;
begin
	vlItem := GetItemByDefinition(ParDefinition);
	if vlItem = nil then begin
		vlItem := TDefinition(ParDefinition).CreateDefinitionUseItem;{TODO remove casting}
		AddItem(vlItem);
	end;
   exit(vlItem);
end;

function TDefinitionUseList.SetAccess(ParDefinition : TBaseDefinition;ParMode :TAccessMode; var ParItem : TDefinitionUseItemBase) : TAccessStatus;
var
	vlItem : TDefinitionUseItemBase;
	vlStatus : TAccessStatus;
begin
   vlItem := GetOrAddUseItem(ParDefinition);
	vlStatus := vlItem.SetAccess(ParMode);
   ParItem := vlItem;
	exit(vLStatus);
end;




{---------------------( TDefinitionUseItemBase )------------------------------------------}


procedure TDefinitionUseItemBase.Commonsetup;
begin
	inherited Commonsetup;
   iContext := nil;
end;

function TDefinitionUseItemBase.IsDefinition(ParDefinition : TBaseDefinition) : boolean;
begin
	exit(iDefinition = ParDefinition);
end;

constructor TDefinitionUseItemBase.Create(ParDefinition : TBaseDefinition);
begin
	iDefinition := ParDefinition;
	inherited Create;
end;

function TDefinitionUseItemBase.GetName : string;
begin
	exit(iDefinition.GetErrorName);
end;


function TDefinitionUseItemBase.GetSubList : TDefinitionUseList;
begin
	exit(nil);
end;



{-------------------------( VarUseList )----------------------------------------------------------}


function TDefinitionUseItem.IsCompleetInitialised : TVarUSeMode;
begin
	exit(iWrite);
end;

procedure TDefinitionUseItem.SetToSometimes;
begin
	if iWrite=VM_Used then iWrite := VM_SomeTimes;
	if iRead=VM_USed then iRead := VM_SomeTimes;
end;

procedure TDefinitionUseItem.SetDefault(ParRead :boolean);
begin
	SetWrite;
	if ParRead then SetRead;
end;

function TDefinitionUseItem.SetAccess(ParMode : TAccessMode):TAccessStatus;
var
	vlStatus : TAccessStatus;
begin
	vlStatus := AS_Normal;
	case ParMode of
		AM_Read      : vlStatus := SetRead;
		AM_Write     : vlStatus := SetWrite;
		AM_Silent_Read_Write:begin
			SetRead;
         SetWrite;
		end;
		AM_ReadWrite : begin
			vlStatus := SetRead;
			SetWrite;
		end;
		AM_Nothing   : begin end;
	end;
	exit(vlStatus);
end;


function TDefinitionUseItem.IsUnused:boolean;
begin
	exit((iRead=VM_Not) and (iWrite=VM_Not));
end;

procedure TDefinitionUseItem.CheckUnused(ParCre : TCreator;ParOwner : TBaseDefinition);
var
	vlName : string;
   vlOwner : string;
	vlDef   : TBaseDefinition;
begin
    if (iRead=VM_Not) and (iWrite=VM_Not) then begin
		if ParOwner <> nil then begin
			vlName := ParOwner.GetErrorName;
		end else begin
			EmptyString(vlName);
		end;
      if(iContext <> nil) then begin
      	vlOwner := iContext.GetName+'.'
		end else begin
      	EmptyString(vlOwner);
      end;
		vlDef := iDefinition;
		if(iContext <> nil) then vlDef := iContext.fDefinition;
		ParCre.AddDefinitionWarning(vlDef,ERR_Variable_Not_Used,vlName+'/'+vlOwner+GetName);
	end;
end;



function TDefinitionUseItem.CombineModes(ParMode1,ParMode2 : TVarUseMode) : TVarUseMode;
var
	vlOut : TVarUseMode;
begin
	if (ParMode1 = VM_Used) or (ParMode2 = VM_Used) then begin
		vlOut := VM_Used;
	end else if (ParMode1 <> VM_Not) or (ParMode2 <> VM_Not) then begin
		vlOut := VM_Sometimes;
	end else begin
		vlOut := vm_Not;
	end;
	exit(vlOut);
end;

function TDefinitionUseItem.CombineITRRUseModes(ParPMode,ParITMode : TVarUseMode) : TVarUsemOde;
begin
	if (ParITMode) = VM_Not then exit(ParPMode);
	exit(ParITMode);


end;


function TDefinitionUseItem.CombineIfAndElseUseModes(ParModeIf,ParModeElse : TVarUseMode) : TVarUseMode;
var
	vlOut : TVarUseMode;
begin
	if (ParModeIf = VM_Used) and (ParModeElse=VM_Used) then begin
		vlOut := VM_Used;
	end else if (ParModeIf <> VM_Not) or (ParModeElse <> VM_Not) then begin
		vlOut := VM_Sometimes;
	end else begin
		vlOut := vm_Not;
	end;
	exit(vlOut);
end;

procedure TDefinitionUseItem.CombineIfWithElseUse(ParElse : TDefinitionUseItemBase);
begin
	if not(ParElse is TDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,ParElse.classname);
   iRead :=CombineIfAndELseUseModes(iRead,TDefinitionUseItem(ParElse).fRead);
	iWrite := CombineIfAndElseUseModes(iWrite,TDefinitionUseItem(ParElse).fWrite);
	iRunRead :=CombineITRRUseModes(iRunRead,TDefinitionUseItem(ParElse).fRunRead);
end;

procedure TDefinitionUseItem.CombineFlow(ParOther :TDefinitionUseItemBase);
var
	vlModeR : TVarUseMode;
	vlModeW : TVarUseMode;
	vlModeRR : TVarUSeMode;
begin
	if not(ParOther is TDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,ParOther.classname);
	vlModeR := CombineModes(iRead,TDefinitionUseItem(ParOther).fRead);
	vlModeW := CombineModes(iWrite,TDefinitionUseItem(ParOther).fWrite);
	vlModeRR := CombineITRRUseModes(iRunRead,TDefinitionUseItem(ParOther).fRunRead);
	iRead := vlModeR;
	iWrite := vlModeW;
	iRunRead := vlModeRR;
end;



procedure TDefinitionUseItem.SetLIke(ParItem : TDefinitionUseItemBase);
begin
	if not(ParItem is TDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,'');

	iDefinition := TDefinitionUseItem(ParItem).fDefinition;
	iRead       := TDefinitionUseItem(ParItem).fRead;
	iWrite      := TDefinitionUseITem(ParItem).fWrite;
	iRunRead    := TDefinitionUseItem(ParItem).fRunRead;
end;

function TDefinitionUseItem.Clone : TDefinitionUseItemBase;
var
	vlItem : TDefinitionUseItem;
begin
	vlItem := TDefinitionUseItem.Create(iDefinition);
	vlItem.SetLike(self);
	exit(vlItem);
end;

function  TDefinitionUseItem.SetRead : TAccessStatus;
var
	vlStatus : TAccessStatus;
begin

	case iWrite of
		VM_Not      : vlStatus := AS_No_Write;
		VM_Sometimes: vlStatus := AS_Maybe_No_Write;
		else begin
			vlStatus := AS_Normal;
		end;
	end;
	iRead := VM_USed;
	iRunRead := VM_Used;
	exit(vlStatus);
end;

function TDefinitionUseItem.SetWrite :TAccessStatus;
var
	vlStatus : TAccessStatus;
begin
	case iRunRead of
		VM_Not       : begin
			if iWrite <>VM_Not then begin
				vlStatus := AS_No_Read; {TODO: + Set also AS_Maybe_No_Read in some cases}
			end else begin
				vlStatus := AS_Normal;
			end;
		end;
		VM_SomeTimes : vlStatus := AS_Maybe_No_Read;
		else begin
			vlStatus := AS_Normal;
		end;
	end;
	iWrite := VM_Used;
	iRunRead := VM_Not;
	exit(vlStatus);
end;



procedure TDefinitionUseItem.Commonsetup;
begin
	inherited Commonsetup;
	iRunRead := VM_Not;
	iWrite   := VM_Not;
	iRead    := VM_Not;
end;





end.