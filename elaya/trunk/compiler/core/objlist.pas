
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

unit objlist;
interface
uses simplist,stdobj;
const
	Max_Item_Num=64;
type
	TObjectArray=array[1..Max_Item_Num] of TRoot;

TObjectItem=class(TSMListItem)
private
	voItem : TObjectArray;
	voCnt  : cardinal;
	property iCnt  : cardinal      read voCnt  write voCnt;
	property iItem : TObjectArray  read voItem write voItem;
protected
	procedure commonsetup;override;
	procedure Clear;override;

public
	function AddItem(ParItem : TRoot):boolean;
	function ExistsItem(ParITem : TRoot):boolean;
end;

TObjectList = class(TSMList)
protected
	function ExistsItem(ParItem : TRoot) : boolean;
public
	procedure AddObject(ParObject : TRoot);
end;

implementation

{----( TObjectItem )-------------------------------------------------------------------------}

function TObjectItem.ExistsItem(ParITem : TRoot):boolean;
var
	vlCnt : cardinal;
begin
	for vlCnt := 1 to iCnt do if(iItem[vlCnt] =  ParItem) then begin
		writeln('Found : ',iItem[vlCnt].classname,' Ptr = ',cardinal(ParItem),' at ',vlCnt);
		exit(true);
	end;
	exit(false);
end;

procedure TObjectItem.commonsetup;
begin
	inherited Commonsetup;
	iCnt := 0;
end;

function TObjectItem.AddItem(ParItem : TRoot):boolean;
begin
	if iCnt >= max_item_num then exit(false);
	iCnt := iCnt + 1;
	iItem[iCnt] := ParItem;
	exit(true);
end;

procedure TObjectItem.Clear;
begin
	inherited Clear;
	while iCnt > 0 do begin
		iItem[iCnt].Destroy;
		iCnt := iCnt -1;
	end;
end;

{---( TObjectList )-----------------------------------------------------------------------------}
function TObjectList.ExistsItem(ParItem : TRoot) : boolean;
var
	vlItem : TObjectItem;
	vlCnt  : cardinal;
begin
	vlItem := TObjectItem(fStart);
	vlCnt := 0;
	while(vlItem <> nil) do begin
		inc(vlCnt);
		if vlItem.ExistsItem(ParItem) then begin
			 writeln(' ObjectItem no=',vlCnt,' of ',GetNumItems);
			 exit(true);
		end;
		vlItem := TObjectItem(vlItem.fNxt);
	end;
	exit(false);
end;


procedure TObjectLIst.AddObject(ParObject : TRoot);
var
	vlItem : TObjectItem;
begin
	vlItem := TObjectItem(fTop);
{	if ExistsItem(ParObject) then fatal(FAT_Obj_Allready_In_Obj_List,['Classname=',ParObject.ClassName]);}
	if(vlItem <> nil) then begin
		if vlItem.AddItem(ParObject) then exit;
	end;
	vlItem := TObjectItem(insertAtTop(TObjectItem.Create));
	vlItem.AddItem(ParObject);
end;

end.

