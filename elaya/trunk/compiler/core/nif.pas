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

unit Nif;
interface
uses display,node,pocobj,elacons,varuse,stmnodes;



type
	
	TIfNode=class(TConditionNode)
	protected
		procedure   commonsetup;override;
	public
		procedure   InitParts;override;
		procedure   PrintNode(ParDis:TDisplay);override;
		function    CreateSec(ParCre:TSecCreator):boolean;override;
		procedure   ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList) ;override;

	end;
	
	TIfNodeList=class(TNodeList)
	public
		procedure GetSubPoc(var ParThen,ParElse : TNodeIdent);
	end;

	TThenElseNode=class(TNodeIdent)
	private
		voThenElse:boolean;
		property iThenElse : boolean read voThenElse write voThenElse;
	public
		function  CreateSec(ParCre:TSecCreator):boolean;override;
		procedure print(ParDis:TDisplay);override;
		constructor Create(ParThenElse:boolean);
		procedure   ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList) ;override;

	end;
	
implementation


{-----( TThenELseNode)---------------------------------------}

function  TThenElseNode.CreateSec(ParCre:TSecCreator):boolean;{TODO Can be removed}
begin
	CreateSec := CreatePartsSec(ParCre);
end;

procedure TTHenElseNode.Print(ParDis:TDisplay);
begin
	if iThenElse then begin
		ParDis.WriteNl('<then>')
	end else begin
		PArDis.WriteNl('<else>');
	end;
	iParts.Print(PArDis);
	if iThenElse then begin
		ParDis.WriteNl('</then>')
	end else begin
		PArDis.WriteNl('</else>');
	end;

end;
constructor TThenElseNode.Create(ParThenElse:boolean);
begin
	inherited Create;
	iThenElse := ParThenElse;
end;

procedure  TThenElseNode.ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);
begin
	fParts.ValidateDefinitionUse(ParCre,ParMode,ParUSeList);
end;

{-----( TIfNodeList )----------------------------------------}

procedure TIfNodeList.GetSubPoc(var ParThen,ParElse : TNodeIdent);
begin
	ParThen := TNodeIdent(fStart);
	ParElse := TNodeIdent(ParThen.fNxt);
end;


{------(  TIfNode )------------------------------------------}

function  TIfNode.CreateSec(ParCre:TSecCreator):boolean;
var  vlLabTrue       : TLabelPoc;
	vlLabFalse      : TLabelPoc;
	vlPrvLabelTrue  : TLabelPoc;
	vlPrvLabelFalse : TLabelPoc;
	vlSec           : TSubPoc;
	vlPoc           : TSubPoc;
	vlJmp           : TJumpPoc;
	vlOutLabel      : TLabelPoc;
	vlTrueBlock     : TNodeIdent;
	vlFalseBlock    : TNodeIdent;
begin
	TIfNodeLIst(iParts).GetSubPoc(vlTrueBlock,vlFalseBlock);
	vlLabTrue  := ParCre.CreateLabel;
	vlLabFalse := ParCre.CreateLabel;
	vlPrvLabelTrue  := ParCre.SetLabelTrue(vlLabTrue);
	vlPrvLabelFalse := ParCre.SetLabelFalse(vlLabFalse);
	fCond.CreateSec(ParCre);
	ParCre.SetLabelTrue(vlPrvLabelTrue);
	ParCre.SetLabelFalse(vlPrvLabelFalse);
	vlSec := TSubPoc.create;
	ParCre.AddSec(vlSec);
	vlPoc := ParCre.fPoc;
	ParCre.SetPoc(vlSec);
	ParCre.AddSec(vlLabTrue);
	vlOutLabel := vlLabFalse;
	if vlTrueBlock <> nil then begin
		if vlTrueBlock.CreateSec(ParCre) then exit(true);
		if vlFalseBlock <> nil then begin
			vlOutLabel := PArcre.CreateLabel;
			vlJmp      := TJumpPoc.create(vlOutLabel);
			ParCre.AddSec(vlJmp);
			ParCre.AddSec(vlLabFalse);
			if vlFalseBlock.CreateSec(ParCre) then exit(true);
		end;
	end;
	ParCre.AddSec(vlOutLabel);
	ParCre.SetPoc(vlPoc);
	exit(false);
end;

procedure  TIfNode.ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TDefinitionUseList);
var
	vlUse           : TDefinitionUseList;
	vlUseElse       : TDefinitionUseLIst;
	vlTrueBlock     : TNodeIdent;
	vlFalseBlock    : TNodeIdent;
begin
	if fCond <> nil then fCond.ValidateDefinitionUse(ParCre,AM_Read,ParUseList);
	vlUse := ParUseList.Clone;
	TIfNodeLIst(iParts).GetSubPoc(vlTrueBlock,vlFalseBlock);
	vlTrueBlock.ValidateDefinitionUse(ParCre,AM_Read,vlUse);
	if vlFalseBlock <> nil then  begin
		vlUseELse := ParUseList.Clone;
		vlFalseBLock.ValidateDefinitionUse(ParCre,AM_Read,vlUseElse);{todo:Is this ok? or clone TUseList=>use it and combine}
 		vlUse.CombineIfWithElseUse(vlUseElse);
		vlUseElse.Destroy;
	end;
	vlUse.CombineFlow(ParUseList);
	vlUse.Destroy;
end;

procedure TIfNode.Initparts;
begin
	SetParts (TIfNodeLIst.create);
end;

procedure TIfNode.CommonSetup;
begin
	inherited CommonSetup;
	iIdentCode := (IC_IfNode);
end;


procedure   TIfNode.PrintNode(ParDis:TDisplay);
begin
	ParDis.WriteNl('<if><condition>');
	fCond.Print(ParDis);
	ParDis.nl;
	ParDis.Writenl('</condition><code>');
	iParts.Print(ParDis);
	ParDis.nl;
	ParDis.Write('</code></if>');
end;


end.
