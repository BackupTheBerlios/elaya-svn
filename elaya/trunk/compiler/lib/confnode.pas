{    Elaya, the Fcompiler for the elaya language
Copyright (C) 1999-2002  J.v.Iddekinge.
Web   : www.elaya.org
Email : iddekingej@lycos.com

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

unit confnode;

interface
uses confdef,sysutils,stdobj,progutil,simplist,cfg_error;
type
	TOperatorCode=(
	OC_None,
	OC_Add,
	OC_Mul,
	OC_Sub,
	OC_Div,
	OC_Mod);
	
	EConfig=class(Exception);
		EInvalidOperation=class(EConfig)
			constructor Create(ParCol,ParLIne : cardinal);
		end;
		
		EOutOfRange=class(ECOnfig)
			constructor Create(ParCol,ParLIne : cardinal);
		end;
		
		EInvalidProgram = class(EConfig)
			constructor Create(ParCol,ParLIne : cardinal);
		end;
		
		EDuplicatedVariable=class(ECOnfig)
			constructor Create(const ParVar:string;ParCol,ParLIne : cardinal);
		end;
		
		ECantWrite=class(EConfig)
			constructor Create(ParCol,ParLIne : cardinal);
		end;
		
		EFailed=class(EConfig)
			constructor Create(ParMessage : string);
		end;
		
		TConfigNode=class(TSmListItem)
		private
			voLine : cardinal;
			voCol  : cardinal;
		protected
			property iCol  : cardinal read voCol  write voCol;
			property iLine : cardinal read voLine write voLine;

			procedure  Commonsetup;override;

		public
			property   fCol  : cardinal read voCol  write voCol;
			property   fLine : cardinal read voLine write voLine;
			procedure  Execute;virtual;
			function   GetValue : TValue;virtual;
		end;
		
		TConfigNodeLIst=Class(TSmList)
		public
			procedure  AddNode(ParNode : TConfigNode);
			procedure  Execute;virtual;
			function   GetFirstNode : TConfigNode;
		end;
		
		
		TSUbListNode=class(TConfigNode)
		private
			voSubList   : TConfigNodeList;
			property iSubList : TConfigNodeList read voSubList write voSubList;

		protected
			procedure Commonsetup;override;
			procedure Clear;override;

		public
			property fSubList : TConfigNodeList read voSubList write voSubList;
			
			function  GetNodeByNum(ParNum : cardinal) : TConfigNode;
			procedure Execute;override;
			procedure AddNode(ParNode : TConfigNode);
		end;
		
		
		TMathConfigNode=class(TSubListNode)
		end;
		
		TValueCOnfigNode=class(TMathConfigNode)
		end;
		
		TVarConfigNode=class(TValueConfigNode)
		private
			voVar   : TConfigVarItem;
			property iVar : TConfigVarItem read voVar write voVar;
		public
			constructor Create(ParVar :TConfigVarItem);
			function GetValue :TValue;override;
		end;
		
		TConstantConfigNode=class(TValueConfigNode)
		private
			voVal : TValue;
			property iVal : TValue read voVal write voVal;

		protected
			procedure   Commonsetup;override;
			procedure   clear;override;

		public
			function    GetValue : TValue; override;
			constructor Create( ParValue:TValue);
		end;
		
		
		
		TLoadConfigNode=class(TMathConfigNode)
		private
			voVar   : TConfigVarItem;
			property iVar   : TConfigVarItem   read voVar write voVar;

		public
			constructor Create(ParVar : TConfigVarItem);
			procedure   Execute;override;
		end;
		
		TDualOperConfigNode=class(TMathConfigNode)
		private
			voOperator    : TOperatorCode;
			property fOperator :TOperatorCode read voOperator write voOperator;
		public
			function    GetValue : TValue;override;
			procedure   DoOperation(ParDest,ParSrc : TValue);
			constructor create(ParOperator : TOperatorCode);
		end;
		
		
		
		TEqualConfigNode=class(TMathConfigNode)
		public
			function GetValue : TValue;override;
		end;
		
		TSectionConditionConfigNode=class(TMathConfigNode)
		public
			function GetValue : TValue;override;
		end;
		
		
		TWriteConfigNode=class(TSubListNode)
		public
			procedure Execute;override;
		end;
		
		TSectionNode=class(TSubListNode)
		private
			voCondition  : TSectionConditionConfigNode;
			property iCondition  : TSectionConditionConfigNode   read voCOndition write voCondition;
		protected
			procedure Commonsetup;override;
			procedure Clear;override;

		public
			procedure AddCondition(ParNode : TConfigNode);
			procedure Execute;override;
			function  IsSame : boolean;
		end;
		
		TFailNode=class(TSubListNode)
		public
			procedure   Execute;override;
		end;
		
		TRootConfigNode=class(TSubListNode)
		end;
		
	implementation
	
	
	constructor ECantWrite.Create(ParCol,ParLIne : cardinal);
	begin
		inherited Create('Can''t write to expression in '+IntToStr(ParCol)+'/'+IntToStr(ParLine));
	end;
	
	
	{--( EDuplicatedVariable )-----------------------------------------}
	
	constructor EDuplicatedVariable.Create(const ParVar : string;ParCol,ParLIne : cardinal);
	
	begin
		inherited Create('Duplicated Variable :' + ParVar+' in ' +IntToStr(ParCol)+'/'+IntToStr(ParLine));
	end;
	
	{--( EOutOfRange )-----------------------------------------------}
	
	constructor EOutOfRange.Create(ParCol,ParLIne : cardinal);
	begin
		inherited Create('Out of range in '+IntToStr(ParCol)+'/'+IntToStr(ParLine));
	end;
	
	
	{--( EInvalidProgram )--------------------------------------------}
	
	constructor EInvalidProgram.create(ParCol,ParLIne : cardinal);
	
	begin
		inherited Create('Invalid program  in '+IntToStr(ParCol)+'/' + IntToStr(ParLine) );
	end;
	
	{--( EInvalidOperation )-------------------------------------------}
	
	constructor EInvalidOperation.Create(ParCol,ParLIne : cardinal);
	begin
		inherited Create('Invalid operation in '+IntToStr(ParCol)+'/'+IntToStr(ParLine));
	end;
	
	{--( EFailed )-----------------------------------------------------}
	
	
	constructor EFailed.Create(ParMessage : string);
	begin
		inherited Create(ParMessage);
	end;
	
	
	{--( TFailNode )----------------------------------------------------}
	
	
	procedure TFailNode.Execute;
	var
		vlText : string;
		vlNode : TConfigNode;
		vlValue : TValue;
	begin
		inherited Execute;
		vlNode := fSubList.GetFirstNode;
		if vlNode <> nil then begin
			vlValue := vlNode.GetValue;
			if vlValue <> nil then begin
				vlValue.GetString(vlText);
				vlValue.Destroy;
			end;
		end else begin
			vlText := 'unkown';
		end;
		raise EFailed.Create(vlText);
	end;
	
	{--( TDualOperConfigNode )-----------------------------------------}
	function TDualOperConfigNode.GetValue : TValue;
	var vlDest    : TValue;
		vlCurrent : TMathConfigNode;
		vlVal     : TValue;
	begin
		vlVal := nil;
		vlCurrent := TMathConfigNode(GetNodeByNUm(1));
		if vlCurrent = nil then exit(nil);
		try
			vlDest := vlCurrent.GetValue;
			vlCurrent := TMathConfigNode(vlCurrent.fNxt);
			while vlCurrent <> nil do begin
				vlVal := nil;
				try
					vlVal := vlCurrent.GetValue;
					DoOperation(vlDest,vlVal);
				finally
					if vlVal <> nil then vlVal.Destroy;
				end;
				vlCurrent := TMathConfigNode(vlCurrent.fNxt);
			end;
		except
			on vlE:Exception do begin
				vlDest.Destroy;
				raise;
			end;
		end;
		exit(vlDest);
	end;

procedure TDualOperConfigNode.DoOperation(ParDest,ParSrc : TValue);
var vlErr : TCalculationStatus;
begin
	vlErr := CS_Ok;
	case fOperator of
	OC_Add : vlErr := ParDest.Add(ParSrc);
	OC_Sub : vlErr := ParDest.Sub(ParSrc);
	OC_Mul : vlErr := ParDest.Mul(ParSrc);
	OC_Div : vlErr := PArDest.DivVal(ParSrc);
end;
if vlErr=CS_Invalid_Operation then raise EInvalidOperation.Create(iCol,iLine);
if vlErr=CS_Out_Of_Range      then raise EOutOfRange.Create(iCol,iLine);
end;

constructor TDualOperConfigNode.create(ParOperator : TOperatorCode);
begin
	inherited Create;
	fOperator := ParOperator;
end;

{--( TConditionConfigNode )---------------------------------------}

function TSectionConditionConfigNode.GetValue:TValue;
var vlCurrent : TMathConfigNode;
	vlVal     : TValue;
	vlBool    : boolean;
	vlErr     :boolean;
begin
	vlCurrent := TMathConfigNode(fSubList.fStart);
	vlBool    := true;
	while (vlCurrent <> nil) and vlBool do begin
		vlVal := nil;
		try
			vlVal := vlCurrent.GetValue;
			vlErr :=  vlVal.GetBool(vlbool);
		finally
			if vlVal <> nil then vlVal.Destroy;
		end;
		if vlErr then raise EInvalidOPeration.Create(iCol,iLine);
		vlCurrent := TMathConfigNode(vlCurrent.fNxt);
	end;
	exit(TBoolean.Create(vlBool));
end;

{--( TEqualConfigNode )--------------------------------------------}

function TEqualConfigNode.GetValue:TValue;
var vlNode1 : TMathConfigNode;
	vlNode2 : TMathConfigNode;
	vlVal1  : TValue;
	vlVal2  : TValue;
	vlBool  : TBoolean;
begin
	vlVal1  := nil;
	vlVal2  := nil;
	vlBool  := nil;
	try
		try
			vlNode1 := TMathConfigNode(GetNodeByNum(1));
			if vlNode1= nil then raise EInvalidOperation.Create(iCol,iLine);
			vlNode2 := TMathConfigNode(GetNodeByNum(2));
			if vlNode2=nil then  raise EInvalidOperation.Create(iCol,iLine);
			vlVal1  := vlNode1.GetValue;
			vlVal2  := vlNode2.GetValue;
			vlBool  := TBoolean.Create(vlVal1.IsEqual(vlVal2));
		finally
		if vlVal1 <> nil then vlVal1.Destroy;
		if vlVal2 <> nil then vlVal2.Destroy;
	end;
	except
		if vlBool <> nil then vlBool.Destroy;
		raise;
	end;
	exit(vlBool);
end;

{--( TWriteConfigNode )---------------------------------------------}

procedure TWriteConfigNode.Execute;
var vlCurrent : TConfigNode;
	vlVal     : TValue;
	vlStr     : string;
begin
	vlCurrent := TConfigNode(fSubList.fStart);
	while vlCurrent <> nil do begin
		vlVal := nil;
		try
			vlVal := vlCurrent.GetValue;
			if vlVal <>nil then begin
				vlVal.GetString(vlStr);
				write(vlStr);
			end;
		finally
			if vlVal <> nil then vlVal.Destroy;
		end;
		vlCurrent := TConfigNode(vlCurrent.fNxt);
	end;
	writeln;
end;

{--( TConstantConfigNode )------------------------------------------}



function TConstantConfigNode.GetValue : TValue;
begin
	exit(iVal.Clone);
end;

procedure TConstantConfigNode.Commonsetup;
begin
	inherited Commonsetup;
	iVal :=nil;
end;

procedure TConstantConfigNode.clear;
begin
	inherited clear;
	if iVal <> nil then iVal.Destroy;
end;

constructor TConstantConfigNode.Create(ParValue : TValue);
begin
	inherited Create;
	iVal := ParValue;
end;



{---( TSubListNode )---------------------------------------------------}

function  TSubListNode.GetNodeByNum(ParNum : cardinal) : TConfigNode;
begin
	exit(TConfigNode(iSubList.GetPtrByNum(ParNum)));
end;

procedure TSubListNode.Commonsetup;
begin
	inherited Commonsetup;
	fSubList := TConfigNodeLIst.Create;
end;

procedure TSubListNode.Clear;
begin
	inherited clear;
	if iSubList <> nil then iSubList.Destroy;
end;

procedure TSubListNode.Execute;
begin
	iSubList.Execute;
end;

procedure TSubListNode.AddNode(ParNode : TConfigNode);
begin
	if ParNode = nil then exit;
	if ParNode.fLine = 0 then begin
		ParNode.fLine := fLine;
		ParNode.fCol  := fCol;
	end;
	iSubList.AddNode(ParNode);
end;

{---(  TConfigNode )----------------------------------------------------}

procedure  TConfigNode.Commonsetup;
begin
	inherited Commonsetup;
	iCol  := 0;
	iLine := 0;
end;


function  TConfigNode.GetValue : TValue;
begin
	raise EinvalidOperation.Create(iCol,iLine);
	exit(nil);
end;

procedure TCOnfigNode.Execute;
begin
end;

{---( TConfigNodeList )------------------------------------------------}
function   TConfigNodeList.GetFirstNode : TConfigNode;
begin
	exit(TConfigNode(fStart));
end;


procedure TConfigNodeList.AddNode(ParNode : TConfigNode);
begin
	InsertAtTop(ParNode);
end;

procedure TConfigNodeList.Execute;
var vlCurrent : TConfigNode;
begin
	vlCurrent := GetFirstNode;
	while vlCurrent <> nil do begin
		vlCurrent.Execute;
		vlCurrent := TConfigNode(vlCUrrent.fNxt);
	end;
end;

{----( TSectionNode )---------------------------------------------------------}


function  TSectionNode.IsSame : boolean;
var vlBool : TValue;
	vlSame : boolean;
	vlErr  : boolean;
begin
	vlBool := nil;
	try
		vlBool := iCondition.GetValue;
		vlErr  := vlBool.GetBool(vlSame);
	finally
		if vlBool <> nil then vlBool.Destroy;
	end;
	if vlErr then raise EInvalidOperation.Create(iCol,iLine);
	exit(vlSame);
end;

procedure TSectionNode.Execute;
begin
	if isSame then inherited Execute;
end;

procedure TSectionNode.Commonsetup;
begin
	inherited Commonsetup;
	iCondition  := TSectionConditionConfigNode.Create;
end;

procedure TSectionNode.Clear;
begin
	inherited Clear;
	if iCondition  <> nil then iCondition.Destroy;
end;


procedure TSectionNode.AddCondition(ParNode : TConfigNode);
begin
	iCondition.AddNode(ParNode);
end;

{---( TLoadNode )-------------------------------------------------------}



constructor TLoadConfigNode.Create(ParVar :TConfigVarItem);
begin
	inherited Create;
	iVar   := ParVar;
end;

procedure TLoadConfigNode.Execute;
var
	vlVal  : TValue;
	vlName : string;
	vlText : string;
	vlVar  : TMathConfigNode;
begin
	vlVal := nil;
	vlVar := TMathConfigNode(fSubList.fStart);
	if (vlVar <> nil) and (iVar <> nil) then begin
		try
			vlVal  := vlVar.GetValue;
			iVar.GetNameStr(vlName);
			vlVal.GetString(vlText);
			Verbose(VRB_Config,vlText+' => '+vlName);
			if iVar <> nil then begin
				if iVar.SetValue(vlVal) then raise ECantWrite.Create(iCol,iLine);
			end;
		except
			if vlVal <> nil then vlVal.Destroy;
			raise;
		end;
	end else begin
		raise EInvalidProgram.Create(iCol,iLine);
	end;
end;


{---( TConfigVarNode )------------------------------------------------}


constructor TVarConfigNode.Create(ParVar :TConfigVarItem);
begin
	inherited Create;
	iVar := ParVar;
end;

function TVarConfigNode.GetValue :TValue;
var vlVal : TValue;
begin
	vlVal := iVar.fValue;
	exit(vlVal.Clone);
end;


end.




