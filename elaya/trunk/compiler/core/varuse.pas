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

unit varuse;
interface
uses compbase,simplist,error,progutil,useitem;
type
TDefinitionUseItemBase=class(TUseItem)
		private
				voDefinition : TBaseDefinition;
				property iDefinition : TBaseDefinition read voDefinition write voDefinition;
		public
				property fDefinition : TBaseDefinition read voDefinition;
				function GetDefinition  : TBaseDefinition;override;
				constructor Create(ParDefinition : TBaseDefinition);
		end;

TDefinitionUseItem=class(TDefinitionUseItemBase)
            private
    			voWrite      : TDefinitionUseMode;
				voRead		 : TDefinitionUseMode;
				voRunRead    : TDefinitionUseMode;

			protected
				property iRunRead   : TDefinitionUseMode read voRunRead    write voRunRead;
				property iWrite     : TDefinitionUseMode read voWrite      write voWrite;
				property iRead      : TDefinitionUseMode read voRead       write voRead;
				procedure commonsetup;override;
				function CombineModes(ParMode1,ParMode2 : TDefinitionUseMode) : TDefinitionUseMode;
				function CombineITRRUseModes(ParPMode,ParITMode : TDefinitionUseMode) : TDefinitionUseMode;
				function SetRead : TAccessStatus;
				function SetWrite: TAccessStatus;

			public
				property fRead      : TDefinitionUseMode read voRead;
				property fRunRead   : TDefinitionUseMode read voRunRead;
				property fWrite     : TDefinitionUseMode read voWrite;
				procedure CheckUnused(ParCre : TCreator;ParOwner : TBaseDefinition); override;
				procedure CombineFlow(ParOther : TUseItem);override;
				function  Clone : TUseItem;override;
				procedure SetLike(ParItem : TUseItem);override;
				function  SetAccess(ParMode : TAccessMode):TAccessStatus;override;
				procedure SetDefault(ParRead :boolean);override;
				function  IsUnused:boolean;override;
				procedure SetToSometimes;override;
            function  IsCompleetInitialised : TDefinitionUseMode;override;
			   procedure CombineIfWithElseUse(ParElse : TUseItem);override;
				function  CombineIfAndElseUseModes(ParModeIf,ParModeElse : TDefinitionUseMode) : TDefinitionUseMode;
end;




	TStructDefinitionUseSubList=class(TUseList)
		public
				procedure SetAllDefault(ParRead :boolean);
				function AreAllInitialised : TDefinitionUseMode;
				procedure SetAllAccessSilent(ParMode : TAccessMode);
				function AreAllUnused:boolean;
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
	function GetSubList : TUseList;override;
	procedure CombineFlow(ParOther : TUseItem);override;
	procedure SetToSometimes;override;
	function SetAccess(ParMode : TAccessMode):TAccessStatus;override;
	procedure CheckUnused(ParCre : TCreator;ParOwnerBase : TBaseDefinition);override;
   function Clone : TUseItem;override;
   function IsCompleetInitialised : TDefinitionUseMode;override;
	procedure SetDefault(ParRead:boolean);override;
	procedure CombineIfWithElseUse(ParElse : TUseItem);override;
	function IsUnused:boolean;override;
end;

implementation

{----(TDefinitionUseItemBase)-----------------------------------------------------------------}

constructor TDefinitionUseItemBase.Create(ParDefinition : TBaseDefinition);
begin
	inherited Create;
	iDefinition := ParDefinition;
end;

function TDefinitionUseItemBase.GetDefinition : TBaseDefinition;
begin
	exit(iDefinition);
end;

{---( TStructDefinitionUseSubList )-----------------------------------------------------------}
procedure TStructDefinitionUseSubList.SetAllDefault(ParRead:boolean);
var
	vlCurrent : TUseItem;
begin
	vlCurrent := TUseItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.SetDefault(ParRead);
		vlCurrent  := TUseItem(vlCurrent.fNxt);
	end;
end;

procedure TStructDefinitionUseSubList.SetAllAccessSilent(ParMode : TAccessMode);
var
	vlCurrent : TUseItem;
begin
	vlCurrent := TUseItem(fStart);
	while vlCurrent <> nil do begin
			vlCurrent.SetAccess(ParMode);
			vlCurrent := TUseItem(vlCurrent.fNxt);
	end;
end;

function TStructDefinitionUseSubList.AreAllInitialised : TDefinitionUseMode;
var
	vlCurrent : TUseItem;
	vlResultStatus  : TDefinitionUseMode;
   vlStatus        : TDefinitionUseMode;
begin
	vlCurrent := TUseItem(fStart);
   vlResultStatus := VM_Used;
	while(vlCurrent <> nil) do begin
		vlStatus := vlCurrent.IsCompleetInitialised;
		if(vlStatus = VM_not) then exit(VM_Not);
		if(vlStatus = VM_SomeTimes) and (vlResultStatus=VM_Used) then vlResultStatus := VM_SomeTimes;
		vlCurrent := TUseItem(vlCurrent.fNxt);
	end;
	exit(vlResultStatus);
end;


function TStructDefinitionUseSubList.AreAllUnused : boolean;
var
	vlCurrent : TUseItem;
begin
	vlCurrent := TUseItem(fStart);
	while vlCurrent <> nil do begin

		if not(vlCurrent.IsUnused) then exit(false);
		vlCurrent := TUseItem(vlCurrent.fNxt);
	end;
	exit(true);
end;


{---( TStructDefinitionUseItem)----------------------------------------------------------------}


function TStructDefinitionUseItem.IsUnused:boolean;
begin
	exit(iSubList.AreAllUnUsed);
end;

procedure TStructDefinitionUseItem.CombineIfWithElseUse(ParElse : TUseItem);
begin
	if not(ParElse is TStructDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,ParElse.classname);
	iSubList.CombineIfWithElseUse(TStructDefinitionUseItem(ParElse).fSubList);
end;

procedure TStructDefinitionUseItem.SetDefault(ParRead:boolean);
begin
	iSubList.SetAllDefault(ParRead);
end;


function TStructDefinitionUseItem.IsCompleetInitialised : TDefinitionUseMode;
begin
	exit(iSubList.AreAllInitialised);
end;


function TStructDefinitionUseItem.GetSubList : TUseList;
begin
	exit(iSubList);
end;

function TStructDefinitionUseItem.Clone : TUseItem;
var
	vlItem : TStructDefinitionUseItem;
begin
	vlItem := TStructDefinitionUseItem.Create(iDefinition);
   iSubList.CloneIntoList(vlItem.fSubList);
   exit(vlItem);
end;

procedure TStructDefinitionUseItem.CheckUnused(ParCre : TCreator;ParOwnerBase : TBaseDefinition);{TODO}
var
	vlDef   : TBaseDefinition;
	vlOwner : string;
begin
	if IsUnused then begin
      if(iContext <> nil) then begin
      	vlOwner := iContext.GetName+'.'
		end else begin
      	EmptyString(vlOwner);
      end;
		vlDef := GetDefinition;
		if(iContext <> nil) then vlDef := iContext.GetDefinition;
		ParCre.AddDefinitionWarning(vlDef,ERR_Variable_Not_Used,vlOwner+GetName);
	end else begin
		iSubList.CheckUnUsed(ParCre);
	end;
end;

function TStructDefinitionUseItem.SetAccess(ParMode : TAccessMode):TAccessStatus;
var
	vlStatus : TAccessStatus;
	vlMode : TDefinitionUseMode;
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


procedure TStructDefinitionUseItem.CombineFlow(ParOther : TUseItem);
begin
	if not(ParOther is TStructDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,classname+'=>'+ParOther.className);
	iSubList.CombineFlow(TStructDefinitionUseItem(ParOther).iSubList);
end;

procedure TStructDefinitionUseItem.SetToSometimes;
begin
	iSubList.SetToSomeTimes;
end;





{-------------------------( VarUseList )----------------------------------------------------------}


function TDefinitionUseItem.IsCompleetInitialised : TDefinitionUseMode;
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
		AM_Silent_Write_Read:begin
			SetWrite;
			SetRead;
		end;
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
   vlOwner : string;
	vlDef   : TBaseDefinition;
begin
    if IsUnUsed then begin
      if(iContext <> nil) then begin
      	vlOwner := iContext.GetName+'.'
		end else begin
      	EmptyString(vlOwner);
      end;
		vlDef := iDefinition;{TODO Can be better}
		if(iContext <> nil) then vlDef := iContext.GetDefinition;
		ParCre.AddDefinitionWarning(vlDef,ERR_Variable_Not_Used,vlOwner+GetName);
	end;
end;



function TDefinitionUseItem.CombineModes(ParMode1,ParMode2 : TDefinitionUseMode) : TDefinitionUseMode;
var
	vlOut : TDefinitionUseMode;
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

function TDefinitionUseItem.CombineITRRUseModes(ParPMode,ParITMode : TDefinitionUseMode) : TDefinitionUseMode;
begin
	if (ParITMode) = VM_Not then exit(ParPMode);
	exit(ParITMode);


end;


function TDefinitionUseItem.CombineIfAndElseUseModes(ParModeIf,ParModeElse : TDefinitionUseMode) : TDefinitionUseMode;
var
	vlOut : TDefinitionUseMode;
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

procedure TDefinitionUseItem.CombineIfWithElseUse(ParElse : TUseItem);
begin
	if not(ParElse is TDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,ParElse.classname);
   iRead :=CombineIfAndELseUseModes(iRead,TDefinitionUseItem(ParElse).fRead);
	iWrite := CombineIfAndElseUseModes(iWrite,TDefinitionUseItem(ParElse).fWrite);
	iRunRead :=CombineITRRUseModes(iRunRead,TDefinitionUseItem(ParElse).fRunRead);
end;

procedure TDefinitionUseItem.CombineFlow(ParOther :TUseItem);
var
	vlModeR : TDefinitionUseMode;
	vlModeW : TDefinitionUseMode;
	vlModeRR : TDefinitionUseMode;
begin
	if not(ParOther is TDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,ParOther.classname);
	vlModeR := CombineModes(iRead,TDefinitionUseItem(ParOther).fRead);
	vlModeW := CombineModes(iWrite,TDefinitionUseItem(ParOther).fWrite);
	vlModeRR := CombineITRRUseModes(iRunRead,TDefinitionUseItem(ParOther).fRunRead);
	iRead := vlModeR;
	iWrite := vlModeW;
	iRunRead := vlModeRR;
end;



procedure TDefinitionUseItem.SetLIke(ParItem : TUseItem);
begin
	if not(ParItem is TDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,'');

	iDefinition := TDefinitionUseItem(ParItem).fDefinition;
	iRead       := TDefinitionUseItem(ParItem).fRead;
	iWrite      := TDefinitionUseITem(ParItem).fWrite;
	iRunRead    := TDefinitionUseItem(ParItem).fRunRead;
end;

function TDefinitionUseItem.Clone : TUseItem;
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
