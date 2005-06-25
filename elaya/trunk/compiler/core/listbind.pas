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

unit listbind;
interface
uses strmbase,error,elacons,simplist,stdobj;

type
	TPtrBindItem=class(TSMListItem)
	private
		voAddress : pointer;
		property   iAddress : pointer read voAddress write voAddress;
	public
		constructor Create(ParAddress : Pointer);
		procedure   Bind(ParObject : TRoot);
	end;

	TPtrBindList=class(TSMList)
	public
		procedure AddBind(ParPtr : pointer);
		procedure Bind(ParObject  :  TRoot);
	end;

	TPtrItem=class(TSMListItem)
	private
		voPtr	      : TRoot;
		voNum	      : TIdentNumber;
		voNextHash    : TPtrItem;
		voPtrBindList : TPtrBindList;
		voHasPtr      : boolean;
	protected
		property    iPtr         : TRoot        read voPtr         write voPtr;
		property    iNum         : TIdentNumber   read voNum         write voNum;
		property    iNextHash    : TPtrItem     read voNextHash    write voNextHash;
		property    iPtrBindList : TPtrBindList read voPtrBindList write voPtrBindList;
		property    iHasPtr      : boolean	read voHasPtr	   write voHasPtr;

		procedure   Commonsetup;override;
		procedure   Clear;override;
	public
		property    GetNum : TIdentNumber   read voNum;
		property    GetPtr : TRoot        read voPtr;
		property    fHasPtr: boolean	  read voHasPtr;
		property    fNextHash : TPtrItem read voNextHash write voNextHash;
		function    SetPtr(ParCode : TIdentNumber;ParPtr:TRoot):boolean;
		constructor Create(ParNum : TIdentNumber);
		procedure   Bind;
		procedure   AddBind(ParItem : pointer);
	end;

	TPtrList=class(TSMList)
	private
		voHashMatrix : array[0..SIZE_PtrCOnvHash] of TPtrItem;
public
	constructor Create;
	function    SetHashMatrix(ParNo : TIdentNumber;ParPtr:TPtrItem):TPtrItem;
	function    GetHashMatrix(ParNo : TIdentNumber)  : TPtrItem;
	function    GetItemByCode(ParNum :TIdentNumber ) : TPtrItem;
	function    GetPtrByNum(ParNum : TIdentNumber)   : TRoot;
	function    AddPtr(ParCode : TIdentNumber;ParPtr : TRoot)      : TIdentNumber;
	procedure   AddPtrItem(ParItem : TPtrItem);
	procedure   AddBind(ParCode : TIdentNumber;ParItem : Pointer);
	procedure   Bind;
end;

implementation

{-----( TPTrBindList )-----------------------------------------------------}


procedure TPtrBindList.Bind(ParObject:TRoot);
var vlCurrent:TPtrBindItem;
begin
	vlCurrent := TPtrBindItem(fStart);
	while (vlCurrent <> nil) do begin
		vlCurrent.Bind(ParObject);
		vlCurrent := TPtrBindItem(vlCurrent.fNxt);
	end;
end;

procedure TPtrBindList.AddBind(ParPTr:Pointer);
begin
	InsertAt(nil,TPtrBindItem.Create(ParPtr));
end;

{-----( TPtrBindItem )-----------------------------------------------------}



constructor TPtrBindItem.Create(parAddress:pointer);
begin
	inherited Create;
	iAddress := PArAddress;
end;

procedure TPtrBindItem.Bind(ParObject : TRoot);
begin
	if iAddress <> nil then  pointer(iAddress^) :=ParObject;
end;

{-----( TPtrItem )------------------------------------------------------}

procedure TPtrItem.Commonsetup;
begin
	inherited Commonsetup;
	iPtrBindList := TPtrBindList.Create;
end;

procedure TPtrItem.Clear;
begin
	inherited Clear;
	if iPtrBindList <> nil then iPtrBindList.Destroy;
end;

procedure TPtrItem.Bind;
begin
	if not iHasPtr then begin
		writeln('Ptr not bound : ',cardinal(GetNum));
	end;
	iPtrBindList.Bind(GetPtr);
end;


procedure TPtrItem.AddBind(ParItem:Pointer);
begin
	if iPtr <> nil then begin
		TRoot(ParItem^) := iPtr
	end else begin
		iPtrBindList.AddBind(ParItem);
	end;
end;

function  TPtrItem.SetPtr(ParCode : TIdentNumber;ParPtr:TRoot):boolean;
begin
	if (ParPtr<>nil) and (iPtr =  nil) and (GetNum = ParCode) then begin
		iPtr   := ParPtr;
		iHasPtr := true;
		exit(false);
	end;
	exit(true);
end;



constructor TPtrItem.Create( Parnum : TIdentNumber);
begin
	inherited Create;
	iPtr      := nil;
	iHasPtr   := false;
	iNum      := ParNum;
	iNextHash := nil;
end;

{-----( TPtrList )---------------------------------------------------------}


procedure TPtrList.Bind;
var vlCurrent : TPtrItem;
begin
	vlCurrent := TPtrItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.BInd;
		vlCurrent := TPtrItem(vlCurrent.fNxt);
	end;
end;


function TPtrList.SetHashMatrix(ParNo : TIdentNumber ; ParPtr : TPtrItem):TPtrItem;
var vlHash:cardinal;
begin
	vlhash := cardinal(ParNo) and SIze_PtrConvHash;
	SetHashMatrix := voHashMatrix[vlhash];
	vohashMatrix[vlHash] := ParPtr;
end;

function TPtrList.GetHashMatrix(ParNo : TIdentNumber):TPtrItem;
var vlhash:cardinal;
begin
	vlHash := cardinal(ParNo) and Size_PtrConvHash;
	GetHashMatrix := voHashMatrix[vlHash];
end;

constructor TPTrList.Create;
begin
	inherited Create;
	fillchar(voHashMatrix,sizeof(VoHashMatrix),0);
end;

function TPtrList.GetItemByCode(ParNum : TIdentNumber):TPtrItem;
var
	vlCurrent : TPtrItem;
begin
	vlCurrent := GetHashMatrix(ParNum);
	while (vlCurrent <> nil) and (vlCurrent.GetNum <> ParNum)  do vlCurrent := TPtrItem(vlCurrent.fNextHash);
	exit(vlCurrent);
end;


function TPtrList.GetPtrByNum(ParNum : TIdentNumber):TRoot;
var vlCurrent:TPtrItem;
begin
	vlCurrent := GetItemByCode(ParNum);
	if vlCurrent = nil then exit(nil)
	else exit(vlCurrent.GetPtr);
end;


function TPtrList.AddPtr(ParCode : TIdentNumber;ParPtr : TRoot) : TIdentNumber;
var 	vlCurrent : TPtrItem;
	vlNum     : TIdentNumber;
begin
	vlNum  := ParCode;
	AddPtr := IN_No_Code;
	if vlNum <> IN_No_Code then begin
		vlCurrent := GetItemByCode(vlNum);
		if vlCurrent = nil then begin
			vlCurrent := TPtrItem.Create(vlNum);
			vlCurrent.SetPtr(vlNum,ParPtr);
			AddPtrItem(vlCurrent);
			AddPtr    := vlCurrent.GetNum;
		end else begin
			if vlCurrent.GetPtr = nil then begin
				if  vlCurrent.SetPtr(ParCode,ParPtr) then fatal(fat_Ptr_Item_Invalid,'TPtrList.AddPtr');
			end;
		end;
	end;
end;

procedure TPtrList.AddPtrItem(ParItem : TPtrItem);
var vlHashNext : TPtrItem;
begin
	vlHashNext        := SetHashMatrix(ParItem.GetNum,ParItem);
	ParItem.fNextHash := vlHashNext;
	insertAt(nil,ParItem);
end;

procedure TPtrList.AddBind(ParCode:TIdentNumber; ParItem : pointer);
var vlItem : TPtrItem;
begin
	vlItem := GetItemByCode(ParCode);
	if vlItem  = nil then begin
		vlItem := TPtrItem.Create(ParCode);
		AddPtrItem(vlItem);
	end;
	vlItem.AddBind(ParItem);
end;


end.
