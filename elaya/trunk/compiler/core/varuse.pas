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
uses compbase,simplist,error,progutil,useitem,varbase;

type

TVarUseItem=class(TUseItem)
		private
				voDefinition : TVarBase;
				property iDefinition : TVarBase read voDefinition write voDefinition;
		public
				property fDefinition : TVarBase read voDefinition;
				function GetDefinition  : TBaseDefinition;override;
				constructor Create(ParDefinition : TVarBase);
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


{----( TVarUseItem )--------------------------------------------------------------------------}
constructor TVarUseItem.Create(ParDefinition : TVarBase);
begin
		iDefinition := ParDefinition;
		inherited Create;
end;

function TVarUseItem.GetDefinition : TBaseDefinition;
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
	vlItem := TStructDefinitionUseItem.Create(fDefinition);
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









end.
