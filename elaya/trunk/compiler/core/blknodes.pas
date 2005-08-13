unit blknodes;
interface
uses display,node,pocObj,useitem,linklist;
type

TBlockNode=class(TSubListStatementNode)
	private
		voName       : ansistring;
		voLeaveLabel : TLabelPoc;
		property iName : ansistring read voName write voName;
		property iLeaveLabel : TLabelPoc read voLeaveLabel write voLeaveLabel;
	public
		property fName : ansistring read voName;
		function getLeaveLabel : TLabelPoc;
		procedure Print(ParDis : TDisplay);override;
		function CreateSec(ParCre : TSecCreator):boolean;override;
		function  IsSubNodesSec:boolean;override;
		procedure ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);override;
		constructor Create(const p_name : ansistring);
	end;

	TBlockNodeItem = class(TListItem)
	private
		voNode : TBlockNode;
		property iNode : TBlockNode read voNode write voNode;
	public
		property fNode : TBlockNode read voNode;

		function getName : ansistring;
		constructor Create(ParNode :TBlockNode);
	end;

	TBlockNodeLIst = class(TList)
		function getBlockByName(const ParName : ansistring) : TBlockNode;
		function getCurrentBlock : TBlockNode;
		procedure popBlock;
		procedure AddNode(ParNode :TBlockNode);
	end;

implementation

{---( TBlockNodeItem )---------------------------------------}


function TBlockNodeItem.getName : ansistring;
begin
	exit(iNode.fName);
end;

constructor TBlockNodeItem.Create(ParNode :TBlockNode);
begin
	inherited Create;
	iNode := ParNode;
end;

{---( TBlockNodeList )--------------------------------------}

procedure TBlockNodeList.AddNode(parNode : TBlockNode);
begin
	InsertAtTop(TBlockNodeItem.Create(ParNode));
end;

function TBlockNodeList.getCurrentBlock : TBlockNode;
var
	vlNode : TBlockNode;
begin
	vlNode := nil;
	if(fTop <> nil) then vLNode := TBlockNodeItem(fTop).fNode;
	exit(vlNode);
end;

procedure TBlockNodeList.popBlock;
begin
	deleteLink(fTop);
end;

function TBlockNodelist.getBlockByName(const ParName : ansistring) : TBlockNode;
var
	l_Item : TBlockNodeItem;
begin
	l_item := TBlockNodeItem(fStart);
	while (l_item <> nil) and (l_item.GetName <> ParName) do l_item := TBlockNodeItem(l_item.fNxt);
	if(l_item <> nil) then 	exit(l_item.fNode);

	exit(nil);
end;

{----( TBlockNode )------------------------------------------------------}


function TBlockNode.getLeaveLabel : TLabelPoc;
begin
	if(iLeaveLabel = nil) then  iLeaveLabel := TLabelPoc.Create;
	exit(iLeaveLabel);
end;

constructor TBlockNode.Create(const p_name : ansistring);
begin
	inherited Create;
	iName := p_name;
	iLeaveLabel := nil;
end;

procedure TBlockNode.ValidateDefinitionUse(ParCre : TSecCreator;ParMode : TAccessMode;var ParUseList : TUseList);
begin
	fParts.ValidateDefinitionUse(ParCre,ParMode,ParUseList);
end;

function TBlockNode.IsSubNodesSec:boolean;
begin
	exit(true);
end;

function TBlockNode.CreateSec(ParCre : TSecCreator):boolean;
begin
	ParCre.AddBlock(self);

	fParts.CreateSec(ParCre);
	if iLeaveLabel <> nil then ParCre.AddSec(iLeaveLabel);
	ParCre.PopBlock;
	exit(false);
end;

procedure TBlockNode.Print(ParDis : TDisplay);
begin
	ParDis.WriteNl('<block>');
	fParts.Print(ParDis);
	ParDis.WriteNl('</block>');
end;

end.
