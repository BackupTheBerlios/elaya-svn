{    Elaya, the compiler for the elaya language
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

unit lsstorag;

interface
uses stdobj,linklist,elacons,error,elatypes,display,compbase;
type
	
	TTLVStorageItem=class(TListItem)
	private
		voAddress      : TOffset;
		voSize        : TSize;
		voReserveFlag : boolean;
		voName	      : cardinal;
	public
		property fAddress     : TOffset  read voAddress      write voAddress;
		property fSize        : TSize    read voSize        write voSize;
		property fReserveFlag : boolean  read voReserveFlag write voReserveFlag;
		property fName	      : cardinal read voName	    write voName;
		procedure Commonsetup;override;
		procedure FreeStorage;
		procedure ReserveStorage(ParName : cardinal ; ParSize : TSize);
		procedure print(ParDis:TDisplay);virtual;
		
	end;
	
	TTLVStorageList=class(TList)
	public
		procedure CalculateStorageAddress(ParFrame : TRoot);
		function  ReserveStorage(ParName : cardinal ; ParSize : TSize):TTLVStorageItem;
		function  GetTotalSize:TSize;
	end;
	
	
implementation
uses frames;

{---( TTLVStorageList )-------------------------------------------}


function TTLVStorageList.GetTotalSize:TSize;
var vlCurrent : TTLVStorageItem;
	vlTot     : TSize;
begin
	vlTot := 0;
	vlCurrent := TTLVStorageItem(fStart);
	while vlCurrent <> nil do begin
		inc(vlTot,vlCurrent.fSize);
		vlCurrent := TTLVStorageItem(vlCurrent.fNxt);
	end;
	exit(vlTot);
end;

procedure TTLVStorageList.CalculateStorageAddress(ParFrame:TRoot);
var vlTotalSize : TSize;
	vlAddress   : TOffset;
	vlCurrent   : TTLVStorageItem;
begin
	vlTotalSize := GetTotalSize;
	if vlTotalSize = 0 then exit;
	vlAddress   :=  TFrame(ParFrame).GetTotalSize;
	TFrame(ParFrame).GetNewOffset(vlTotalSize);
	vlCurrent   := TTLVStorageITem(fStart);
	while vlCurrent <>nil do begin
		inc(vlAddress,vlCurrent.fSize);
		vlCurrent.fAddress := -vlAddress;
		vlCurrent := TTLVStorageItem(vlCurrent.fNxt);
	end;
end;


function TTLVStorageList.ReserveStorage(ParName : cardinal ; ParSize:TSize):TTLVStorageItem;
var vlCurrent   : TTLVStorageItem;
	vlBigger    : TTlvStorageItem;
	vlSmaller   : TTLVStorageItem;
	vlBiggerDif : TSize;
   	vlSmallerDif: TSize;
	{    vlDif       : TSize;}
begin
	vlCurrent    := TTLVStorageItem(fStart);
	vlBiggerDif  := 65535;
	vlSmallerdif := 65535;
	vlBigger     := nil;
	vlSmaller    := nil;
	while vlCurrent <> nil do begin
		if {(vlCurrent.fReserveFlag) and} (vlCurrent.fName = ParName) then begin
			ReserveStorage := vlCurrent;
			exit;
		end;
		{	    if not vlCurrent.fReserveFlag then begin
		if vlCurrent.fSize >= parSize then begin
		vlDif := vlCurrent.fSize - ParSize;
		if vlDif < vlBiggerDif then begin
		vlBigger    := vlCurrent;
		vlBiggerDif := vlDif;
		end;
		end else begin
		vlDif := ParSize - vlCurrent.fSize;
		if vlDif < vlSmallerDif then begin
		vlSmaller    := vlCurrent;
		vlSmallerDif := vlDif;
		end;
		end;
		end; }
		vlCurrent :=TTLVStorageItem(vlCurrent.fNxt);
	end;
	if vlBigger = nil then vlBigger := vlSmaller;
	if vlBigger = nil then begin
		vlBigger := TTLVStorageITem.Create;
		InsertAtTop(vlBigger);
	end;
	vlBigger.ReserveStorage(ParName,ParSize);
	exit(vlBigger);
end;


{---( TTLVStorageItem )-------------------------------------------}


procedure TTLVStorageItem.Print(PArDIs:TDisplay);
begin
	ParDis.Print(['@TL[',cardinal(self),'/',fName,'/',fAddress,']']);
end;

procedure TTLVStorageItem.Commonsetup;
begin
	inherited commonsetup;
	fAddress      := 0;
	fSize        := 0;
	fReserveFlag := false;
	fName	     := 0;
end;

procedure TTLVStorageItem.FreeStorage;
begin
	fReserveFlag := false;
end;

procedure TTLVStorageItem.ReserveStorage(ParName : cardinal ; ParSize:TSize);
begin
	if fReserveFlag then fatal(fat_Storage_all_reserved,'At:TTLVStorageItem.ReserveStorage');
	fReserveFlag :=true;
	if ParSize > fSize then fSize := parSize;
	fName := ParName;
end;

end.
