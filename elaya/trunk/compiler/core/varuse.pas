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
TAccessMode = (AM_Read,AM_ReadWrite,AM_Write,AM_Nothing);
TVarUseItem=class(TSMListItem)
            private
				voDefinition : TBaseDefinition;
    			voWrite      : TVarUseMode;
				voRead		 : TVarUseMode;
				voRunRead    : TVarUseMode;
			protected
				property iDefinition: TBaseDefinition read voDefinition write voDefinition;
				property iRunRead   : TVarUseMode read voRunRead    write voRunRead;
				property iRead      : TVarUseMode read voRead       write voRead;
				property iWrite     : TVarUseMode read voWrite      write voWrite;
				procedure commonsetup;override;
				function CombineITUseModes(ParMode1,ParMode2 : TVarUseMode) : TVarUseMode;
				function CombinePITUseModes(ParPrevMode,ParMode :TVarUSeMOde) : TVarUseMode;
				function CombinePITRRUseModes(ParPMode,ParITMode : TVarUseMode) : TVarUsemOde;
			public
            	property fDefinition : TBaseDefinition  read voDefinition;
				property fRead      : TVarUseMode read voRead;
				property fRunRead   : TVarUseMode read voRunRead;
				property fWrite     : TVarUseMode read voWrite;
				function IsDefinition(ParDefinition : TBaseDefinition) : boolean;
				constructor Create(ParDefinition : TBaseDefinition);
				function SetRead : TAccessStatus;
				function SetWrite: TAccessStatus;
				procedure CheckUnused(ParCre : TCreator;ParOwner : TBaseDefinition);
				procedure CombineFlow(ParOther : TVarUseItem);
				procedure SetElseMode(ParElse :TVarUseItem);
				function Clone : TVarUseItem;
				procedure SetLike(ParItem : TVarUseItem);
				function GetName : string;
            end;


TVarUseList=class(TSMList)
				voOwner      : TBaseDefinition;
				property iOwner     : TBaseDefinition read voOwner write voOwner;
			public
				function AddItem(ParDefinition : TBaseDefinition) : TVarUseItem;
				function GetItemByDefinition(parDefinition :TBaseDefinition):TVarUseItem;
				function SetAccess(ParDefinition : TBaseDefinition;ParMode : TAccessMode;var ParItem : TVarUseItem) : TAccessStatus;
				function Clone:TVarUseList;
				procedure CombineFlow(ParTo : TVarUSeList);
       			function  GetNextUnUsedItem(ParItem : TVarUseItem):TVarUSeItem;
				procedure CheckUnused(ParCre : TCreator);
				constructor Create(ParDefinition : TBaseDefinition);

			end;

implementation


{---( TVarUseList )------------------------------------------------------------------}
constructor TVarUseList.Create(ParDefinition : TBaseDefinition);
begin
	iOwner := ParDefinition;
	inherited Create;
end;

procedure TVarUseList.CheckUnused(ParCre : TCreator);
var
	vlCurrent : TVarUseItem;
begin
	vlCurrent := TVarUseItem(fStart);
    while vlCurrent <> nil do begin
		vlCurrent.CheckUnused(ParCre,iOwner);
		vlCUrrent := TVarUseItem(vlCurrent.fNxt);
	end;
end;

function  TVarUseList.GetNextUnUsedItem(ParItem : TVarUseItem):TVarUSeItem;
var
	vlCurrent :TVarUseItem;
begin
	vlCurrent := TVarUseItem(fStart);
	while (vlCurrent <> nil) and ((vlCurrent.fWrite <> VM_Used) and (vlCurrent.fRunRead <> VM_Used)) do begin
		vlCurrent := TVarUseItem(vlCurrent.fNxt);
	end;
	exit(vlCurrent);
end;

procedure TVarUseList.CombineFlow(ParTo : TVarUseList);
var
	vlCurrent1 : TVarUseItem;
	vlCurrent3 : TVarUSeItem;
begin
	vlCurrent1 := TVarUseItem(fStart);
	while vlCurrent1 <> nil do begin
		vlCurrent3 := ParTo.GetItemByDefinition(vlCurrent1.fDefinition);
		if vlCurrent3 <> nil then vlCurrent3.CombineFlow(vlCurrent1);
		vlCurrent1 := TVarUseItem(vlCurrent1.fNxt);
	end;
end;

function TVarUseList.Clone:TVarUseList;
var
	vlCurrent : TVarUSeItem;
	vlList :TVarUSeList;
begin
	vlCurrent := TVarUseItem(fStart);
	vlList := TVarUseList.Create(iOwner);
	while vlCurrent <> nil do begin
		vlList.InsertAt(nil,vlCurrent.Clone);
		vlCurrent := TVarUseItem(vlCUrrent.fNxt);
	end;
	exit(vlList);
end;

function TVarUseList.AddItem(ParDefinition : TBaseDefinition) : TVarUseItem;
var
	vlItem : TVarUseItem;
begin
	vlItem := TVarUseItem.Create(ParDefinition);
	insertAt(nil,vlItem);
	exit(vlItem);
end;

function TVarUseList.GetItemByDefinition(parDefinition :TBaseDefinition):TVarUseItem;
var
	vlCurrent : TVarUseItem;
begin
	vlCurrent := TVarUseItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsDefinition(ParDefinition)) do vlCurrent := TVarUSeItem(vlCurrent.fNxt);
	exit(vlCurrent);
end;

function TVarUseList.SetAccess(ParDefinition : TBaseDefinition;ParMode :TAccessMode;var ParItem :TVarUseItem) : TAccessStatus;
var
	vlItem : TVarUseItem;
	vlStatus : TAccessStatus;
begin
	vlItem := GetItemByDefinition(ParDefinition);
	if vlItem = nil then vlItem := AddItem(ParDefinition);
	case ParMode of
		AM_Read      : vlStatus := vlItem.SetRead;
		AM_Write     : vlStatus := vlItem.SetWrite;
		AM_ReadWrite : begin
			vlStatus := vlItem.SetRead;
			vlItem.SetWrite;
		end;
		AM_Nothing   : begin end;
	end;
	ParItem := vlItem;
	exit(vLStatus);
end;

{-------------------------( VarUseList )----------------------------------------------------------}


procedure TVarUseItem.CheckUnused(ParCre : TCreator;ParOwner : TBaseDefinition);
var
	vlName : string;
begin
    if (iRead=VM_Not) and (iWrite=VM_Not) then begin
		if ParOwner <> nil then begin
			vlName := ParOwner.GetErrorName;
		end else begin
			EmptyString(vlName);
		end;
		ParCre.AddWarning(ERR_Variable_Not_Used,0,0,0,vlName+'/'+GetName);
	end;
end;

function TVarUseItem.GetName : string;
begin
	exit(iDefinition.GetErrorName);
end;


function TVarUseItem.CombineITUseModes(ParMode1,ParMode2 : TVarUseMode) : TVarUseMode;
begin
	if (ParMode1 = VM_Used) and (ParMode2 = VM_Used) then begin
		exit(VM_Used);
	end else if (ParMode1 <> VM_Not) or (ParMode2 <> VM_Not) then begin
		exit(VM_Sometimes);
	end else begin
		exit(vm_Not);
	end;
end;

function TVarUseItem.CombinePITUseModes(ParPrevMode,ParMode :TVarUSeMOde):TVarUseMode;
begin
	if ParPrevMode = VM_Used then exit(VM_Used);
	if ParMode <> VM_Not then exit(VM_SomeTimes);
	exit(VM_Not);
end;

function TVarUseItem.CombinePITRRUseModes(ParPMode,ParITMode : TVarUseMode) : TVarUsemOde;
begin
	if (ParITMode) = VM_Not then exit(ParPMode);
	exit(ParITMode);
end;

procedure TVarUseItem.CombineFlow(ParOther :TVarUseItem);
var
	vlModeR : TVarUseMode;
	vlModeW : TVarUseMode;
	vlModeRR : TVarUSeMode;
begin
	vlModeR := CombinePITUseModes(iRead,ParOther.fRead);
	vlModeW := CombinePITUseModes(iWrite,ParOther.fRead);
	vlModeRR := CombinePITRRUseModes(iRunRead,ParOther.fRunRead);
	iRead := vlModeR;
	iWrite := vlModeW;
	iRunRead := vlModeRR;
end;

procedure TVarUseITem.SetElseMode(ParElse :TVarUseItem);
begin
	iRead := COmbinePITUseModes(iRead,ParElse.fRead);
    iWrite := CombinePITUseModes(iWrite,ParElse.fWrite);
	iRunRead := CombinePITRRUseModes(iRunRead,ParElse.fRunRead);
end;


procedure TVarUseItem.SetLIke(ParItem : TVarUseItem);
begin
	iDefinition := ParItem.fDefinition;
	iRead       := ParItem.fRead;
	iWrite      := ParItem.fWrite;
	iRunRead    := ParItem.fRunRead;
end;

function TVarUseItem.Clone : TVarUseItem;
var
	vlItem : TVarUseItem;
begin
	vlItem := TVarUseItem.Create(iDefinition);
	vlItem.SetLike(self);
	exit(vlItem);
end;

function  TVarUseItem.SetRead : TAccessStatus;
var
	vlStatus : TAccessStatus;
	vlName   : string;
begin
	iDefinition.GetTextStr(vlname);

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

function TVarUseItem.SetWrite :TAccessStatus;
var
	vlStatus : TAccessStatus;
	vlName : string;
begin
	iDefinition.GetTextStr(vlname);
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

constructor TVarUseItem.Create(ParDefinition : TBaseDefinition);
begin
	iDefinition := ParDefinition;
	inherited Create;
end;


function TVarUseItem.IsDefinition(ParDefinition : TBaseDefinition) : boolean;
begin
	exit(iDefinition = ParDefinition);
end;

procedure TVarUseItem.Commonsetup;
begin
	inherited Commonsetup;
	iRunRead := VM_Not;
	iWrite   := VM_Not;
	iRead    := VM_Not;
end;





end.
