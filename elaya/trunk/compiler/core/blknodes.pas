unit blknodes;
interface
uses display,node,pocObj,useitem;
type

TBlockNode=class(TNodeIdent)
	public
		procedure Print(ParDis : TDisplay);override;
		function CreateSec(ParCre : TSecCreator):boolean;override;
	   function  IsSubNodesSec:boolean;override;
		procedure ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);override;

	end;
implementation

procedure TBlockNode.ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
begin
	fParts.ValidateDefinitionUse(ParCre,ParMode,ParUseList);
end;

function TBlockNode.IsSubNodesSec:boolean;
begin
	exit(true);
end;

function TBlockNode.CreateSec(ParCre : TSecCreator):boolean;
var
	vlLabel : TLabelPoc;
begin
	vlLabel := ParCre.fLeaveLabel;
	ParCre.fLeaveLabel := nil;
	fParts.CreateSec(ParCre);
	if ParCre.fLeaveLabel <> nil then ParCre.AddSec(ParCre.fLeaveLabel);
	ParCre.fLeaveLabel := vlLabel;
	exit(false);
end;

procedure TBlockNode.Print(ParDis : TDisplay);
begin
	ParDis.WriteNl('<block>');
	fParts.Print(ParDis);
	ParDis.WriteNl('</block>');
end;

end.
