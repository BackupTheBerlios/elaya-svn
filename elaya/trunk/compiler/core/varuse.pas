{
 Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web   : www.elaya.org

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
                                                       j
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
uses ddefinit,compbase,simplist,error,progutil,useitem,varbase,elatypes;

type



TStructDefinitionUseSubList=class(TUseList)
public
	procedure SetAllDefault(ParRead :boolean);
	function AreAllInitialised : TDefinitionUseMode;
	procedure SetAllAccessSilent(ParMode : TAccessMode);
	function AreAllUnused:boolean;
end;

TStructDefinitionUseItem=class(TUseItem)
private
	voSubList : TStructDefinitionUseSubList;
	voDefinition : TBaseDefinition;
	property iDefinition : TBaseDefinition read voDefinition write voDefinition;
protected
	property iSubList : TStructDefinitionUseSubList read voSubList write voSubList;
	procedure Commonsetup;override;
	procedure Clear;override;
	procedure InitSubList;virtual;
public
	property fSubList : TStructDefinitionUseSubList read voSubList;
	property fDefinition : TBaseDefinition read voDefinition;
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
	constructor create(ParDefinition : TBaseDefinition);
	function GetDefinition : TBaseDefinition;override;
end;


TUnionItemUseItem=class(TUseItem)
private
	voUseItem : TUseItem;
	voSize    : TSize;
	property iUseItem : TUseItem read voUseItem write voUseItem;
	property iSize    : TSize    read voSize    write voSize;

protected
	procedure Clear;override;

public
	property fUseItem : TUseItem read voUseItem;
	property fSize    : TSize    read voSize;


	constructor Create(ParItem : TUseItem;ParSize : TSize);
	function GetDefinition : TBaseDefinition;override;
	function IsUnused:boolean;override;
	procedure CombineIfWithElseUse(ParElse : TUseItem);override;

   function IsCompleetInitialised : TDefinitionUseMode;override;
   function Clone : TUseItem;override;
	procedure CheckUnused(ParCre : TCreator;ParOwnerBase : TBaseDefinition);override;
	function SetAccess(ParMode : TAccessMode):TAccessStatus;override;
	procedure SetToSometimes;override;
	procedure CombineFlow(ParOther : TUseItem);override;
	procedure SetDefault(ParRead:boolean);override;

end;


TUnionUseList=class(TStructDefinitionUseSubList)
public
				function SetAccess(ParDefinition : TBaseDefinition;ParMode : TAccessMode;var ParItem : TUseItem) : TAccessStatus;override;
end;

TUnionUseItem=class(TStructDefinitionUseItem)
public
	procedure InitSubList;override;
end;

implementation

{-----( TUnionUseList )-----------------------------------------------------------------}

function TUnionUseList.SetAccess(ParDefinition : TBaseDefinition;ParMode : TAccessMode;var ParItem : TUseItem) : TAccessStatus;
var
	vlMode    : TAccessStatus;
	vlNewMode : TAccessStatus;
	vlCurrent : TUnionItemUseItem;
	vlThis    : TUnionItemUseItem;
begin
	vlMode := inherited SetAccess(ParDefinition,ParMode,ParItem);
	vlCurrent := TUnionItemUseItem(fStart);
	if not(ParItem is TUnionItemUseItem) then begin
		runerror(1);
	end;
	vlThis := TUnionItemUseItem(ParItem);
	while vlCurrent<> nil do begin
		if (vlCurrent <> vlTHis) then begin
			if vlCurrent.fSize <= vlThis.fSIze then begin
				vlNewMode := vlCurrent.SetAccess(ParMode);
				case vlNewMode of
				as_no_write,AS_NO_Read : vlMode := vlNewMode;
				as_maybe_no_write,as_maybe_no_read:if vlMode=AS_Normal then vlMode := vlNewMOde;
            end;
			end;
      end;
		vlCurrent := TUnionItemUseItem(vlCurrent.fNxt);
	end;
	exit(vlMode);
end;

{---( TUnionUseItem )---------------------------------------------------------}
procedure TUnionUseItem.InitSubList;
begin
	iSubList := TUnionUseList.Create(nil);
end;

{---( TUnionItemUseItem )-----------------------------------------------------}


	procedure TUnionItemUseItem.CombineFlow(ParOther : TUseItem);
	begin
		if ParOther is TUnionItemUseItem then begin
			iUseItem.CombineFlow(TUnionItemUseItem(ParOther).fUseItem);
		end;
	end;

	procedure TUnionItemUseItem.SetToSometimes;
	begin
		iUseItem.SetToSomeTimes;
	end;

	function TUnionItemUseItem.SetAccess(ParMode : TAccessMode):TAccessStatus;
   begin
		exit(iUseItem.SetAccess(ParMode));
	end;


	procedure TUnionItemUseItem.CheckUnused(ParCre : TCreator;ParOwnerBase : TBaseDefinition);
   begin
		iUseItem.CheckUnUsed(ParCre,ParOwnerBase);
	end;

	function TUnionItemUseItem.Clone : TUseItem;
	begin
		exit(TUnionItemUseItem.Create(iUseItem.clone,iSize));
	end;

   function TUnionItemUseItem.IsCompleetInitialised : TDefinitionUseMode;
   begin
		exit(iUseItem.IsCompleetInitialised);
	end;

	procedure TUnionItemUseItem.SetDefault(ParRead:boolean);
	begin
		iUseItem.SetDefault(ParRead);
	end;

	procedure TUnionItemUseItem.CombineIfWithElseUse(ParElse : TUseItem);
	begin
		if(ParElse is TUnionItemUseItem) then begin
			iUseItem.CombineIfWithElseUse(TUnionItemUseItem(ParElse).fUseItem);
		end;
	end;

	function TUnionItemUseItem.IsUnused:boolean;
	begin
		exit(iUseItem.IsUnUsed);
	end;

constructor TUnionItemUseItem.Create(ParItem : TUseItem;ParSize :TSize);
begin
	iUseItem := ParItem;
	iSize    := ParSize;
	inherited Create;
end;

procedure TUnionItemUseItem.Clear;
begin
	if iUseItem <> nil then iUseItem.Destroy;
	inherited Clear;
end;

function TUnionItemUseItem.GetDefinition : TBaseDefinition;
begin
	exit(iUseItem.GetDefinition);
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

constructor TStructDefinitionUSeItem.create(ParDefinition : TBaseDefinition);
begin
	iDefinition := ParDefinition;
	inherited Create;
end;

function TStructDefinitionuseItem.GetDefinition : TBaseDefinition;
begin
	exit(iDefinition);
end;

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
	vlItem := TStructDefinitionUseItem.Create(fDefinition);
   iSubList.CloneIntoList(vlItem.fSubList);
   exit(vlItem);
end;

procedure TStructDefinitionUseItem.CheckUnused(ParCre : TCreator;ParOwnerBase : TBaseDefinition);{TODO}
var
	vlDef   : TBaseDefinition;
	vlOwner : ansistring;
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

procedure TStructDefinitionUseItem.InitSubList;
begin
	iSubList := TStructDefinitionUseSubList.Create(nil);
end;

procedure TStructDefinitionUseItem.Commonsetup;
begin
	inherited Commonsetup;
	InitSubList;
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









end.
