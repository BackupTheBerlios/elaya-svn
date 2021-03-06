unit blknodes;
interface
uses stmnodes,display,node,pocObj;
type

TBlockNode=class(TNodeIdent)
	public
		procedure Print(ParDis : TDisplay);override;
		function CreateSec(ParCre : TSecCreator):boolean;override;
	   function  IsSubNodesSec:boolean;override;

	end;
implementation

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
	if ParCre.fLeaveLabel <> nil then begin writeln('xxx');ParCre.AddSec(ParCre.fLeaveLabel);end;
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
