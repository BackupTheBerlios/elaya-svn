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

unit useitem;
interface
uses compbase,simplist,error,progutil;

type
{TODO AM_WRITE_READ en AM_READ_WRITE}
TDefinitionUseMode=(VM_Not,VM_Sometimes,VM_Used);
TAccessStatus=(AS_Normal,AS_No_Read,AS_Maybe_No_Read,AS_No_Write,AS_Maybe_No_Write,AC_Ident_Not_Found);
TAccessMode = (AM_Read,AM_ReadWrite,AM_Write,AM_Nothing,AM_Execute,AM_SizeOf,AM_PointerOf,AM_Silent_Read_Write,AM_Silent_Write_Read);
{TODO Instead of using TUseList everywhere, use a sort of  TDefinitionUseItem}
TUseList=class;
TUseItem=class(TSMListItem)
			private
         	voContext    : TUseItem;
			protected
            property iContext    : TUseItem read voContext    write voContext;
            procedure Commonsetup;override;
			public
            property fContext    : TUseItem read voContext write voContext;
				function IsDefinition(ParDefinition : TBaseDefinition) : boolean;
				procedure CheckUnused(ParCre : TCreator;ParOwner : TBaseDefinition);virtual;abstract;
				procedure CombineFlow(ParOther : TUseItem);virtual;abstract;
				procedure SetElseMode(ParElse :TUseItem);virtual;abstract;
				function Clone : TUseItem;virtual;abstract;
				procedure SetLike(ParItem : TUseItem);virtual;abstract;
				function GetName : ansistring;
				function SetAccess(ParMode : TAccessMode):TAccessStatus;virtual;abstract;
				procedure AssumeIsWriten;
				procedure SetDefault(ParRead :boolean);virtual;abstract;
				function IsUnused:boolean;virtual;abstract;
				procedure SetToSometimes;virtual;abstract;
            function GetSubList : TUseList;virtual;
            function IsCompleetInitialised : TDefinitionUseMode;virtual;abstract;
			   procedure CombineIfWithElseUse(ParElse : TUseItem);virtual;abstract;
            function GetDefinition : TBaseDefinition;virtual;abstract;
         end;

TUseList=class(TSMList)
		private
				voOwner      : TBaseDefinition;
            voContext     : TUseItem;

				property iOwner     : TBaseDefinition read voOwner write voOwner;
            property iContext : TUseItem read voContext write voContext;
 		protected
      		procedure commonsetup;override;
				procedure AddListTo(ParList : TUseList);

			public
            property fContext : TUseItem read voContext write voContext;

				function GetItemByDefinition(parDefinition :TBaseDefinition):TUseItem;
				function SetAccess(ParDefinition : TBaseDefinition;ParMode : TAccessMode;var ParItem : TUseItem) : TAccessStatus;virtual;
				function Clone:TUseList;
            procedure CloneIntoList(ParList : TUseList);
				procedure CombineFlow(ParTo : TUseList);
				procedure CheckUnused(ParCre : TCreator);
				constructor Create(ParDefinition : TBaseDefinition);
				procedure   SetToSometimes;
         	procedure AddItem(ParItem : TUseItem);virtual;
				function GetOrAddUseItem(ParDefinition : TBaseDefinition) : TUseItem;
       		procedure CombineIfWithElseUse(ParList : TUseList);
			end;

TDefinitionUseItemBase=class(TUseItem)
		private
    			voWrite      : TDefinitionUseMode;
				voRead		 : TDefinitionUseMode;
				voRunRead    : TDefinitionUseMode;
				property iRunRead   : TDefinitionUseMode read voRunRead    write voRunRead;
				property iWrite     : TDefinitionUseMode read voWrite      write voWrite;
				property iRead      : TDefinitionUseMode read voRead       write voRead;
		protected
				procedure commonsetup;override;

		public
				property fRead      : TDefinitionUseMode read voRead;
				property fRunRead   : TDefinitionUseMode read voRunRead;
				property fWrite     : TDefinitionUseMode read voWrite;


			protected
				function CombineModes(ParMode1,ParMode2 : TDefinitionUseMode) : TDefinitionUseMode;
				function CombineITRRUseModes(ParPMode,ParITMode : TDefinitionUseMode) : TDefinitionUseMode;
				function SetRead : TAccessStatus;
				function SetWrite: TAccessStatus;

			public
				procedure CheckUnused(ParCre : TCreator;ParOwner : TBaseDefinition); override;
				procedure CombineFlow(ParOther : TUseItem);override;
				function  SetAccess(ParMode : TAccessMode):TAccessStatus;override;
				procedure SetDefault(ParRead :boolean);override;
				function  IsUnused:boolean;override;
				procedure SetToSometimes;override;
            function  IsCompleetInitialised : TDefinitionUseMode;override;
			   procedure CombineIfWithElseUse(ParElse : TUseItem);override;
				function  CombineIfAndElseUseModes(ParModeIf,ParModeElse : TDefinitionUseMode) : TDefinitionUseMode;
end;

TDefinitionUseItem=class(TDefinitionUseItemBase)
private
				voDefinition : TBaseDefinition;
				property iDefinition : TBaseDefinition read voDefinition write voDefinition;
public
				property fDefinition : TBaseDefinition read voDefinition;
				function GetDefinition  : TBaseDefinition;override;
				constructor Create(ParDefinition : TBaseDefinition);
				procedure SetLike(ParItem : TUseItem);override;
				function  Clone : TUseItem;override;
end;


implementation

uses ddefinit;{TODO move some parts to TDefinitionUseItem/List=>So removing cast}

{--------------------------( TDefinitionUseItem )------------------------------------------------}

function TDefinitionUseItem.GetDefinition: TBAseDefinition;
begin
	exit(iDefinition);
end;

constructor TDefinitionuseItem.Create(ParDefinition : TBAseDefinition);
begin
	iDefinition := ParDefinition;
	inherited Create;
end;


procedure TDefinitionUseItem.SetLIke(ParItem : TUseItem);
begin
	if not(ParItem is TDefinitionUseItem) then fatal(FAT_Combine_Wrong_Type_DU,'');

	iDefinition := TDefinitionUseItemBase(ParItem).GetDefinition;
	iRead       := TDefinitionUseItemBase(ParItem).fRead;
	iWrite      := TDefinitionUseItemBase(ParItem).fWrite;
	iRunRead    := TDefinitionUseItemBase(ParItem).fRunRead;
end;

function TDefinitionUseItem.Clone : TUseItem;
var
	vlItem : TDefinitionUseItem;
begin
	vlItem := TDefinitionUseItem.Create(iDefinition);
	vlItem.SetLike(self);
	exit(vlItem);
end;



{-------------------------( VarUseList )----------------------------------------------------------}


function TDefinitionUseItemBase.IsCompleetInitialised : TDefinitionUseMode;
begin
	exit(iWrite);
end;

procedure TDefinitionUseItemBase.SetToSometimes;
begin
	if iWrite=VM_Used then iWrite := VM_SomeTimes;
	if iRead=VM_USed then iRead := VM_SomeTimes;
end;

procedure TDefinitionUseItemBase.SetDefault(ParRead :boolean);
begin
	SetWrite;
	if ParRead then SetRead;
end;

function TDefinitionUseItemBase.SetAccess(ParMode : TAccessMode):TAccessStatus;
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


function TDefinitionUseItemBase.IsUnused:boolean;
begin
	exit((iRead=VM_Not) and (iWrite=VM_Not));
end;

procedure TDefinitionUseItemBase.CheckUnused(ParCre : TCreator;ParOwner : TBaseDefinition);
var
   vlOwner : ansistring;
	vlDef   : TBaseDefinition;
begin
    if IsUnUsed then begin
      if(iContext <> nil) then begin
      	vlOwner := iContext.GetName+'.'
		end else begin
      	EmptyString(vlOwner);
      end;
		vlDef := GetDefinition;{TODO Can be better}
		if(iContext <> nil) then vlDef := iContext.GetDefinition;
		ParCre.AddDefinitionWarning(vlDef,ERR_Variable_Not_Used,vlOwner+GetName);
	end;
end;



function TDefinitionUseItemBase.CombineModes(ParMode1,ParMode2 : TDefinitionUseMode) : TDefinitionUseMode;
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

function TDefinitionUseItemBase.CombineITRRUseModes(ParPMode,ParITMode : TDefinitionUseMode) : TDefinitionUseMode;
begin
	if (ParITMode) = VM_Not then exit(ParPMode);
	exit(ParITMode);


end;


function TDefinitionUseItemBase.CombineIfAndElseUseModes(ParModeIf,ParModeElse : TDefinitionUseMode) : TDefinitionUseMode;
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

procedure TDefinitionUseItemBase.CombineIfWithElseUse(ParElse : TUseItem);
begin
	if not(ParElse is TDefinitionUseItemBase) then fatal(FAT_Combine_Wrong_Type_DU,ParElse.classname);
   iRead :=CombineIfAndELseUseModes(iRead,TDefinitionUseItemBase(ParElse).fRead);
	iWrite := CombineIfAndElseUseModes(iWrite,TDefinitionUseItemBase(ParElse).fWrite);
	iRunRead :=CombineITRRUseModes(iRunRead,TDefinitionUseItemBase(ParElse).fRunRead);
end;

procedure TDefinitionUseItemBase.CombineFlow(ParOther :TUseItem);
var
	vlModeR : TDefinitionUseMode;
	vlModeW : TDefinitionUseMode;
	vlModeRR : TDefinitionUseMode;
begin
	if not(ParOther is TDefinitionUseItemBase) then fatal(FAT_Combine_Wrong_Type_DU,ParOther.classname);
	vlModeR := CombineModes(iRead,TDefinitionUseItemBase(ParOther).fRead);
	vlModeW := CombineModes(iWrite,TDefinitionUseItemBase(ParOther).fWrite);
	vlModeRR := CombineITRRUseModes(iRunRead,TDefinitionUseItemBase(ParOther).fRunRead);
	iRead := vlModeR;
	iWrite := vlModeW;
	iRunRead := vlModeRR;
end;


function  TDefinitionUseItemBase.SetRead : TAccessStatus;
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

function TDefinitionUseItemBase.SetWrite :TAccessStatus;
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


procedure TDefinitionUseItemBase.Commonsetup;
begin
	inherited Commonsetup;
	iRunRead := VM_Not;
	iWrite   := VM_Not;
	iRead    := VM_Not;
end;


{---( TUseList )------------------------------------------------------------------}

procedure TUseList.CombineIfWithElseUse(ParList : TUseList);
var
	vlCurrent : TUseItem;
	vlElse    : TUseItem;
begin
	vlCurrent := TUseItem(fStart);
   while (vlCurrent <> nil) do begin
		vlElse := ParList.GetItemByDefinition(vlCurrent.GetDefinition);
		if (vlElse <> nil) then begin
			vlCurrent.CombineIfWithElseUse(vlElse);
			ParList.DeleteLink(vlElse);
		end else begin
			vlCurrent.SetToSomeTimes;
		end;
		vlCurrent := TUseItem(vlCurrent.fNxt);
	end;
	if not(ParList.IsEmpty) then begin
		ParList.SetToSomeTimes;
		ParList.AddListTo(self);
	end;
end;

procedure TUseList.AddListTo(ParList : TUseList);
var
	vlCurrent : TUseItem;
begin
	while fStart <> nil do begin
		vlCurrent := TUseItem(fStart);
		CutOut(vlCurrent);
		ParList.AddItem(vlCurrent);
	end;
end;


procedure TUseList.Commonsetup;
begin
	inherited Commonsetup;
   iContext := nil;
end;

procedure TUseList.AddItem(ParItem : TUseItem);
begin
	insertat(nil,ParItem);
   ParItem.fContext := fContext;
end;

procedure TUseList.SetToSometimes;
var
	vlCurrent : TUseItem;
begin
	vlCurrent := TUseItem(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.SetToSomeTimes;
		vlCurrent := TUseItem(vlCurrent.fNxt);
	end;
end;



constructor TUseList.Create(ParDefinition : TBaseDefinition);
begin
	iOwner := ParDefinition;
	inherited Create;
end;

procedure TUseList.CheckUnused(ParCre : TCreator);
var
	vlCurrent : TUseItem;
begin
	vlCurrent := TUseItem(fStart);

	while vlCurrent <> nil do begin
		vlCurrent.CheckUnused(ParCre,iOwner);
		vlCUrrent := TUseItem(vlCurrent.fNxt);
	end;
end;


procedure TUseList.CombineFlow(ParTo : TUseList);
var
	vlCurrent1 : TUseItem;
	vlCurrent3 : TUseItem;
	vlCurrent2 : TUseItem;
begin
	vlCurrent1 := TUseItem(fStart);
	while vlCurrent1 <> nil do begin
		vlCurrent3 := ParTo.GetItemByDefinition(vlCurrent1.GetDefinition);
		if vlCurrent3 <> nil then begin
			 vlCurrent3.CombineFlow(vlCurrent1);
		end else begin
			vlCurrent2 := vlCurrent1.clone;
			vlCurrent2.SetToSomeTimes;
			ParTo.AddItem(vlCurrent2);
		end;
		vlCurrent1 := TUseItem(vlCurrent1.fNxt);
	end;
end;

function TUseList.Clone:TUseList;
var
	vlCurrent : TUseItem;
	vlList :TUseList;
begin
	vlCurrent := TUseItem(fStart);
	vlList := TUseList.Create(iOwner);
	while vlCurrent <> nil do begin
		vlList.AddItem(vlCurrent.Clone);
		vlCurrent := TUseItem(vlCUrrent.fNxt);
	end;
	exit(vlList);
end;

procedure TUseList.CloneIntoList(ParList : TUseList);
var
	vlCurrent : TUseItem;
begin
	vlCurrent := TUseItem(fStart);
	while vlCurrent <> nil do begin
		ParList.AddItem(vlCurrent.Clone);
		vlCurrent := TUseItem(vlCUrrent.fNxt);
	end;
end;


function TUseList.GetItemByDefinition(parDefinition :TBaseDefinition):TUseItem;
var
	vlCurrent : TUseItem;
begin
	vlCurrent := TUseItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsDefinition(ParDefinition)) do vlCurrent := TUseItem(vlCurrent.fNxt);
	exit(vlCurrent);
end;


function TUseList.GetOrAddUseItem(ParDefinition : TBaseDefinition) : TUseItem;
var
	vlItem : TUseItem;
begin
	vlItem := GetItemByDefinition(ParDefinition);
	if vlItem = nil then begin
		vlItem := TDefinition(ParDefinition).CreateDefinitionUseItem;{TODO remove casting}
		AddItem(vlItem);
	end;
	if(iOwner <> nil) and (TDefinition(iOwner).AssumeInitDu(TDefinition(ParDefinition))) then begin {TODO remove casting}
		vlItem.AssumeIsWriten;
	end;
   exit(vlItem);
end;

function TUseList.SetAccess(ParDefinition : TBaseDefinition;ParMode :TAccessMode; var ParItem : TUseItem) : TAccessStatus;
var
	vlItem : TUseItem;
	vlStatus : TAccessStatus;
begin
   vlItem := GetOrAddUseItem(ParDefinition);
	vlStatus := vlItem.SetAccess(ParMode);
   ParItem := vlItem;
	exit(vLStatus);
end;




{---------------------( TUseItem )------------------------------------------}

procedure TUseItem.AssumeIsWriten;
begin
	SetAccess(AM_Silent_Write_Read);
end;

procedure TUseItem.Commonsetup;
begin
	inherited Commonsetup;
   iContext := nil;
end;

function TUseItem.IsDefinition(ParDefinition : TBaseDefinition) : boolean;
begin
	exit(GetDefinition = ParDefinition);
end;

function TUseItem.GetName : ansistring;
begin
	exit(GetDefinition.GetErrorName);
end;


function TUseItem.GetSubList : TUseList;
begin
	exit(nil);
end;

end.
