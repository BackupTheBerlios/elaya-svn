{
    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.

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

unit CompBase;
interface
uses simplist,largenum,streams,linklist,progutil,display,error,elacons,elatypes,stdobj,cmp_base,cmp_type;

type

	
	TIdentBase=class(TListItem)
	public
		procedure Print(ParDis:TDisplay);virtual;
		procedure PrintName(ParDIs :TDisplay);virtual;
		procedure PrintIdent(ParDis:TDisplay;ParIdent:TIdentBase);
		procedure PrintIdentName(ParDis:TDisplay;ParIdent :TIdentBase);
	end;
	
	TTextIdent=class(TIdentBAse)
	private
		voText:TString;
	protected
		property iText:Tstring read voText write voText;
		procedure commonsetup;override;
		procedure clear;override;

	public
		property  fText:TString read voText;
		
		function  SaveItem(ParStr:TObjectStream):boolean;override;
		function  LoadItem(PArStr:TObjectStream):boolean;override;
		procedure GetTextStr(var ParStr:String);
		procedure SetText(const ParStr:string);
		function  IsSameText(const ParStr : TString):boolean;
		function  IsSameText(const ParStr : string):boolean;
	end;


	TBaseDefinition=class(TTextIdent)
	private
		voDefinitionModes : TDefinitionModes;
		voPos					: cardinal;
		voCol					: cardinal;
		voLine				: cardinal;

	protected
		property     iDefinitionModes : TDefinitionModes read voDefinitionModes write voDefinitionModes;
		procedure Commonsetup;override;
		property     iPos             : cardinal         read voPos             write voPos;
		property     iCol					: cardinal			 read voCol					write voCol;
		property     iLine				: cardinal			 read voLine				write voLine;
	
	public
		property     fPos        : cardinal         read voPos             write voPos;
		property     fCol			 : cardinal			 read voCol					write voCol;
		property     fLine		 : cardinal			 read voLine				write voLine;

		property	fDefinitionModes : TDefinitionModes read voDefinitionModes;
		function 	LoadItem(ParStream :TObjectStream) : boolean;override;
    	function    SaveItem(ParStream :TObjectStream) : boolean;override;
		function    GetDescForAnonymousIdent : string;virtual;
		function    GetErrorName : string;
	end;
	
	
	TSecBase=class(TSMListitem)
	private
		voUse       : longint;
		property   iUse       : longint   read voUse        write voUse;
	protected
		procedure  CommonSetup;override;

	public
		property   fUse       : longint    read voUse;
		
		procedure  IncUsage;
		function   DecUsage:boolean;
		function   IsSame(ParSec:TSecBase):boolean;virtual;
		function   Optimize:boolean;virtual;
		procedure  Print(ParDis : TDisplay);virtual;
		procedure  PrintIdent(ParDis : TDisplay;ParIdent : TSecBase);
	end;
	
	TCreator=class(TRoot)
	private
		voCompiler:TCompiler_Base;
	protected
		property    iCompiler  : TCompiler_Base read voCOmpiler write voCompiler;
	public
		property    fCompiler:TCompiler_Base read voCompiler;
		procedure   AddError(ParError:TErrorType;ParLine,ParCol,ParPos:Longint;const ParText:String);
		procedure   AddWarning(ParError:TErrorType;ParLine,ParCol,ParPos:Longint;const ParText:String);
		procedure 	AddDefinitionWarning(ParDef : TBaseDefinition;ParError : TErrorTYpe;const ParText:string);


		constructor Create(ParCompiler:TCompiler_Base);
		function    GetIntSize(ParInt:TNumber;var ParSize:TSize;var ParSign:boolean):boolean;
		function    Successful:boolean;
	end;
	
		TNameItem=class(TSMTextItem);
		TNameList=class(TSMTextList)
		public
			procedure AddName(const ParName:string);
		end;
		
	procedure GetNewAnonName(var ParName:string);
	function GetNewResNo:longint;
	function GetNewLabelNo:longint;
	function IsMorePublicAs(ParAc1,ParAc2 : TDefAccess):boolean;
	function IsLessPublicAs(PArAc1,ParAc2 : TDefAccess):boolean;
	function CombineAccess(ParAc1,ParAc2 : TDefAccess) : TDefAccess;
	procedure SetLabelBase(const ParName :string);
	function GetNextProcStabNo : cardinal;
	procedure AddTextToTextList(var ParName : string;ParExtra : string);
	function SizeToMax(ParSize : TSize) : cardinal;
	procedure OperatorToDesc(Const ParName : string;var ParDesc : string);
	
implementation
	uses asminfo;
	
	var vgResCnt      : longint;
		vgLabNo       : longint;
		vgHashSearch : cardinal;
		vgHashCount  : cardinal;
		vgSearches   : cardinal;
		vgLabBase    : string;
		vgProcStabNo : cardinal;
		

	function SizeToMax(ParSize : TSize) : cardinal;
	begin
		case ParSize of
		1:exit(Max_Byte.vrNumber);
		2:exit(Max_Word.vrNumber);
		4:exit(Max_Cardinal.vrNumber);
		end;
		exit(0);
	end;

	procedure AddTextToTextList(var ParName : string;ParExtra : string);
	begin
		if length(ParName) <> 0 then ParName := ParName + ',';
		ParName := ParName + ParExtra;
	end;

	function GetNextProcStabNo : cardinal;
	begin
		inc(vgProcStabNo);
		exit(vgProcStabNo);
	end;
	
	
	procedure GetNewAnonName(var ParName:string);
	begin
		str(GetNewLabelNo,ParName);
		ParName := GetAssemblerInfo.GetManglingChar + ParName;
		if length(vgLabBase) <> 0 then ParName := GetAssemblerInfo.GetManglingChar + vgLabBase + ParName;
	end;
	

{TBaseDefinition}


procedure TBaseDefinition.Commonsetup;
begin
	inherited Commonsetup;
	iDefinitionModes := [];
end;


function TBaseDefinition.SaveItem(ParStream : TObjectStream) : boolean;
begin
	if inherited SaveItem(ParStream) then exit(true);
	if ParStream.Writelong(cardinal(fDefinitionModes)) then exit(true);
	exit(false);
end;

function TBaseDefinition.LoadItem(ParStream :TObjectStream) : boolean;
begin
	if inherited LoadItem(ParStream)  then exit(true);
	if  ParStream.ReadLong(cardinal(voDefinitionModes)) then exit(true);
	exit(false);
end;



function  TBaseDefinition.GetDescForAnonymousIdent : string;
var
	vlName : string;
begin
	GetTextStr(vlName);
	exit(vlName);
end;

function  TBaseDefinition.GetErrorName : string;
var
	vlName : string;
begin
	if(DM_Anonymous in iDefinitionModes) then begin
		exit(GetDescForAnonymousIdent);
	end else begin
		GetTextStr(vlName);
		exit(vlName);
	end;
end;

	{----- (TNameList)---------------------------------------------}
	
	procedure TNamelist.AddName(const ParName:string);
	begin
		InsertAtTop(TNameItem.Create(Parname));
	end;
	
	
	
	{------( TTextIdent )-------------------------------------------------}
	
	function  TTextIdent.IsSameText(const ParStr : string):boolean;
	begin
		exit(fText.IsEqualStr(ParStr));
	end;
	
	function  TTextIdent.IsSameText(const ParStr : TString):boolean;
	begin
		exit(ParStr.IsEqual(fText));
	end;
	
	procedure TTextIdent.commonsetup;
	begin
		inherited commonsetup;
		iText := nil;
	end;
	
	function  TTextIdent.SaveItem(ParStr:TObjectStream):boolean;
	begin
		SaveItem :=true;
		if inherited SaveItem(ParStr) then exit;
		if ParStr.WritePSt(fText) then exit;
		SaveItem := false;
	end;
	
	
	function TTextIdent.LoadItem(PArStr:TObjectStream):boolean;
	var vlStr:String;
	begin
		LoadItem := true;
		if inherited LoadItem(ParStr) then exit;
		if ParStr.ReadString(vlStr) then exit;
		SetText(vlStr);
		LoadItem := false;
	end;
	
	procedure TTextIdent.GetTextStr(var ParStr:String);
	begin
		if iText <> nil then begin
			 iText.GetString(ParStr)
		end else begin
			EmptyString(ParStr);
		end;
	end;
	
	procedure TTextIdent.SetText(const ParStr:string);
	begin
		if iText <> nil then iText.Destroy;
		iText := TString.Create(ParStr);
	end;
	
	procedure TTextIdent.clear;
	begin
		inherited clear;
		if iText <> nil then iText.Destroy;
	end;
	
	{------( TCreator )---------------------------------------------------}
	

	function TCreator.Successful:boolean;
	begin
		exit(iCompiler.Successful);
	end;

	procedure TCreator.AddError(ParError:TErrorType;ParLine,ParCol,ParPos:longint;const ParText:String);
	begin
		iCompiler.Error(parError,ParLine,PArcol,ParPos,ParText);
	end;
	
	procedure TCreator.AddWarning(ParError:TErrorType;ParLine,ParCol,ParPos:longint;const ParText:String);
	begin
		iCompiler.AddWarning(parError,ParLine,PArcol,ParPos,ParText);
	end;


	procedure TCreator.AddDefinitionWarning(ParDef : TBaseDefinition;ParError : TErrorTYpe;const ParText:string);
	var
		vlLine : cardinal;
		vlCol  : cardinal;
		vlPos  : cardinal;
	begin
		vlLine := 0;
		vlPos  := 0;
		vlCol  := 0;
		if (ParDef <> nil) then begin
			vlLine := ParDef.fLine;
			vlPos  := ParDef.fPos;
			vlCol  := ParDef.fCol;
		end;

		AddWarning(ParError,vlLine,vlCol,vlPos,ParText);
	end;


	constructor TCreator.Create(ParCompiler:TCompiler_Base);
	begin
		iCompiler := ParCompiler;
		inherited Create;
	end;
	
	
	
	
	function    TCreator.GetIntSize(ParInt:TNumber;var ParSize:TSize;var ParSign:boolean):boolean;
	begin
		if LargeInRange(ParInt,Min_Byte,Max_Byte) then begin
			ParSize := 1;
			ParSign := false;
		end else
		if LargeInRange(ParInt,Max_Byte, Max_Word) then begin
			ParSize := 2;
			ParSign := false;
		end else
		if LargeInRange(ParInt ,max_word, max_cardinal) then begin
			ParSize := 4;
			ParSign := false;
		end else
		if LargeInRange(ParInt,min_short, min_byte) then begin
			ParSize := 1;
			ParSign := true;
		end else
		if LargeInRange(ParInt ,min_integer,min_short) then begin
			ParSize := 2;
			ParSign := true;
		end else begin
			ParSize := 4;
			ParSign := true;
		end;
		exit(false);
		
	end;
	


	{---( TSecBase )----------------------------------------------------}
	
	
	
	
	
	procedure TSecBase.IncUsage;
	begin
		inc(voUse);
	end;
	
	function TSecBase.DecUsage:boolean;
	begin
		dec(voUse);
		exit(voUse <= 0);
	end;
	
	
	procedure TSecBase.COmmonSetup;
	begin
		inherited CommonSetup;
		iUse := 0;
	end;
	
	procedure TSecBase.Print(ParDIs : TDisplay);
	begin
	end;
	
	procedure TSecBase.PrintIdent(ParDis : TDisplay;ParIdent : TSecBase);
	begin
		if ParIdent = nil then ParDis.write('<empty>')
		else ParIdent.Print(ParDis);
	end;
	
	function  TSecBase.Optimize:boolean;
	begin
		Optimize := false;
	end;
	
	
	function  TSecBase.IsSame(ParSec:TSecBase):boolean;
	begin
		IsSame := ( self = ParSec);
	end;
	
	
	{-----( TIdentBase )----------------------------------------------}
	
	
	procedure TIdentBase.PrintIdent(ParDis:TDisplay;ParIdent:TIdentBase);
	begin
		if ParIdent <> nil then ParIDent.Print(PArDis)
		else ParDis.Write('<empty>');
	end;
	
	procedure TIDentBase.Print(ParDis:TDisplay);
	begin
		ParDis.Write('<abstract TIdentBase>');
	end;
	
	procedure TIdentBase.PrintIdentName(ParDIs : TDisplay;ParIdent:TIdentBase);
	begin
		if ParIdent <> nil then ParIdent.PrintName(ParDis)
		else ParDis.Write('<empty>');
	end;
	
	procedure TIdentBase.PrintName(ParDis : TDisplay);
	begin
		ParDis.Write('<abstract TIdentBase>');
	end;
	
	
	
	
	
	{-----( TCompBase )-----------------------------------------------}
	
function IsMorePublicAs(ParAc1,ParAc2 : TDefAccess):boolean;
begin
	case ParAc1 of
		AF_Protected : if ParAc2 =  AF_Private then exit(true);
		AF_Public    : if ParAc2 <> AF_Public  then exit(true);
	end;
	exit(false);
end;

function IsLessPublicAs(PArAc1,ParAc2 : TDefAccess):boolean;
begin
	case ParAc1 of
		AF_Protected : if ParAc2 = AF_Public then exit(true);
		AF_Private   : if ParAc2 <> AF_Private then exit(true);
	end;
	exit(false);
end;

function CombineAccess(ParAc1,ParAc2 : TDefAccess) : TDefAccess;
var vlRet : TDefAccess;
begin
	vlRet := ParAc1;
	if isLessPublicAs(ParAc2,vlRet) then vlRet := ParAc2;
	exit(vlRet);
end;


function GetNewResNo:longint;
begin
	inc(vgResCnt);
	exit(vgResCnt);
end;

function GetNewLabelNo:longint;
begin
	inc(vgLabNo);
	exit(vgLabNo);
end;

procedure SetLabelBase(const ParName :string);
begin
	vgLabBase := ParName;
end;


procedure OperatorToDesc(Const ParName : string;var ParDesc : string);
begin
	if ParName = '#' then ParDesc := 'fence'          else
	if ParName = '=' then ParDesc := 'equal'          else
	if ParName = '>' then ParDesc := 'bigger'         else
	if ParName = '>=' then ParDesc := 'bigger_equal'  else
	if ParName = '<'  then ParDesc := 'smaller'       else
	if ParName = '<=' then ParDesc := 'smaller_equal' else
	if ParName = '<>' then ParDesc := 'notequal'      else
	if ParName = ':=' then ParDesc := 'load'          else
	if ParName = '+'  then ParDesc := 'add'           else
	if ParName = '-'  then ParDesc := 'neg'           else
	if ParName = '*'  then ParDesc := 'mul'           else ParDesc := ParName;
end;

begin
	vgResCnt     := 0;
	vgLabNo      := 0;
	vgHashCount  := 0;
	vgHashSearch := 0;
	vgSearches   := 0;
	vgProcStabNo := 0;
	EmptyString(vgLabBase);
end.
