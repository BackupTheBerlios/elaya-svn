{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web : www.elaya.org

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

unit cfg_user;
interface
uses largenum,display,progutil,stdobj,config,cmp_type,cfg_error,cmp_base,confdef,confnode;
	
type  TCFG_User=class(TCOmpiler_Base)
	private
		voConfig : TConfig;
		property iConfig: TConfig read voConfig write voConfig;

	protected
		property fConfig: TConfig read voConfig;

		procedure AddVar(const ParName,ParValue  : string;ParReadOnly:boolean);
		function GetVar(const ParName : string) : TConfigVarItem;
		function  GetVarNode(const ParName : string) : TVarConfigNode;
		function  GetCheckVar(const ParName :string) : TCOnfigVarItem;
		function  CreateLoadNode(const ParName : string) : TLoadConfigNode;
		function  CreateStringConstantNode(const ParVal :string) : TConstantConfigNode;
		function  CreateIntConstantNode(const ParVal :string) : TConstantConfigNode;
		procedure   AddDualNode(var ParPrvCode : TOperatorCode;var ParNode : TSubListNode;ParCode : TOperatorCode;ParParam : TMathConfigNode);
		procedure   Commonsetup;override;
	public
		constructor Create(const ParName : string;ParCfg : TConfig);
		procedure   ErrorMessage(ParItem : TErrorItem);override;
		procedure   GetOwnError(ParCode : TErrorType;var ParText:string);
		procedure   GetErrorDescr(ParCode :TErrorType;var ParText:string);
		procedure   ErrorHeader;override;
		function    SetVar(const ParVar,ParValue : string):boolean;
		procedure   GetSourcePath(var ParPath : string);  override;
		procedure   SetNodePos(ParNode : TConfigNode);
		procedure   Execute;
		procedure   AddNodeToNode(ParTo : TSubListNode;var ParNode : TConfigNode);
		procedure   OpenFileFailed(ParError : TErrorType);override;
	end;
	
	
implementation

{---( TConfig_User )---------------------------------------------------}

procedure  TCfg_User.OpenFileFailed(ParError : TErrorType);
begin
	ErrorText(Err_Cant_Open_file,'OS Error='+IntToStr(ParError));
end;


procedure  TCfg_User.AddNodeToNode(ParTo : TSubListNode;var ParNode : TConfigNode);
begin
	if ParNode <> Nil then begin
		if ParTo <> nil then begin
			ParTo.AddNode(ParNode);
		end else begin
			ParNode.Destroy;
			ParNode := nil;
		end;
	end;
end;

procedure  TCfg_User.GetSourcePath(var ParPath : string);
begin
	ParPatH := GetProgramDir;
end;

procedure TCfg_User.SetNodePos(ParNode : TConfigNode);
begin
	ParNode.fCol := col;
	ParNode.fLine := line;
end;

procedure TCfg_User.AddDualNode(var ParPrvCode : TOperatorCode;var ParNode : TSubListNode;ParCode:TOperatorCode;ParParam:TMathConfigNode);
var vlNew : TDualOperConfigNode;
begin
	if ParPrvCode <> ParCode then begin
		vlNew := TDualOperConfigNode.Create(ParCode);
		SetNodePos(vlNew);
		vlNew.AddNode(ParNode);
		ParNode := vlNew;
	end;
	ParPrvCode :=  ParCode;
	ParNode.AddNode(ParParam);
end;

function TCfg_User.CreateStringConstantNode(const ParVal :string) : TConstantConfigNode;
var vlNode : TConstantConfigNode;
begin
	vlNode := TConstantConfigNode.Create(TString.Create(ParVal));
	SetNodePos(vlNode);
	exit(vlNode);
end;

function TCfg_User.CreateIntConstantNode(const ParVal :string) : TConstantConfigNode;
var
	vlLi : TLargeNumber;
	vlNode : TConstantConfigNode;
begin
	StringToLarge(ParVal,vlLi);
	vlNode := TConstantConfigNode.Create(TLongint.Create(vlLi));
	SetNodePos(vlNode);
	exit(vlNode);
end;

function  TCfg_user.GetVarNode(const ParName : string) : TVarConfigNode;
var vlVar : TConfigVarItem;
	vlNode : TVarConfigNode;
begin
	vlVar := GetCheckVar(ParName);
	vlNode := TVarConfigNode.Create(vlVar);
	SetNodePos(vlNode);
	exit(vlNode);
end;

function  TCfg_User.CreateLoadNode(const ParName : string) : TLoadConfigNode;
var vlVar  : TConfigVarItem;
	vlNode : TLoadConfigNode;
begin
	vlVar  := GetCheckVar(ParName);
	vlNode := TLoadConfigNode.Create(vlVar);
	SetNodePos(vlNode);
	exit(vlNode);
end;

function  TCfg_User.GetCheckVar(const ParName : string) : TConfigVarItem;
var
	vlItem : TConfigVarItem;
begin
	vlItem := GetVar(ParName);
	if vlItem = nil then ErrorText(Err_Unkown_Ident,ParNAme);
	exit(vlItem);
end;


procedure TCfg_User.AddVar(const ParName,ParValue  : string;ParReadOnly : boolean);
begin
	if GetVar(ParName)<> nil then ErrorText(Err_Duplicate_ident,ParName)
	else begin
		iConfig.AddVar(ParName,ParValue,ParReadOnly);
	end;
end;

function    TCfg_User.SetVar(const ParVar,ParValue : string):boolean;
begin
	exit(iConfig.SetVar(ParVar,ParValue));
end;

procedure   TCfg_USer.Execute;
begin
	iConfig.Execute;
end;


function TCfg_User.GetVar(const ParName : string) : TConfigVarItem;
begin
	exit(iConfig.GetVar(ParName));
end;

procedure   TCFG_User.ErrorHeader;
begin
	writeln;
	writeln('Errors :');
end;

procedure   TCfg_User.GetOwnError(ParCode : TErrorType;var ParText:string);
begin
	CfgGetErrorText(ParCode,ParText);
end;

procedure   TCfg_User.GetErrorDescr(ParCode :TErrorType;var ParText:string);
begin
	Emptystring(ParText);
	GetErrorText(ParCode,ParText);
	if length(ParText) = 0 then GetOwnError(ParCode,ParText);
end;


constructor TCfg_User.Create(const ParName : string;ParCfg : TConfig);
begin
	inherited Create;
	iFileName := TString.Create(ParName);
	iConfig   := ParCfg;
end;


procedure TCfg_User.Commonsetup;
begin
	inherited Commonsetup;
	iConfig   := nil;
end;

procedure TCfg_User.ErrorMessage(ParItem : TErrorItem);
var
	vlCode     : TErrorType;
	vlLine     : longint;
	vlPos      : longint;
	vlCol      : longint;
	vlExtra    : string;
	vlLineText : string;
	vlError    : string;
	vlFileName : string;
begin
	ParItem.GetInfo(vlFileName,vlCode,vlLine,vlCol,vlPos,vlExtra);
	GetLine(vlPos,vlLineText);
	GetErrorDescr(vlCode,vlError);
	write(vlError);
	if length(vlExtra) <> 0 then write('(',vlExtra,')');
	writeln(' At :',vlFileName,'/',vlLine,'/',vlCol);
	writeln(vlLineText);
end;

end.
