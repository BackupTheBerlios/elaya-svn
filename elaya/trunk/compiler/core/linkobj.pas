unit linkobj;
interface
uses stdobj,simplist,elacons;




type
	TLO_Status=(LOS_Ok,LOS_Same_Name_Diff_File,LOS_Same_Name_Diff_CDecl);

	TLinkObjItem=class;

	TDependItem=class(TSMListItem)
	private
		voItem : TLinkObjItem;
		property iItem : TLinkObjItem read voItem write voItem;
	public
		property fItem : TLinkObjItem read voItem;
		constructor Create(ParItem : TLinkObjItem);
	end;

	TDependencyList=class(TSMList)
		procedure AddDependency(ParItem :TLinkObjItem);
	end;

	TLinkObjItem=class(TSMListItem)
	private
		voName	: ansiString;
		voFile	: ansiString;
		voCDecl  : boolean;
		voType   : TExternalType;
		voDependency : TDependencyList;

		property iName : AnsiString read voName write voName;
		property iFile : AnsiString read voFile write voFile;
		property iCdecl : boolean read voCDecl write voCDecl;
		property iType  : TExternalType read voType write voType;
		property iDependencyList : TDependencyList read voDependency write voDependency;
	protected
		procedure Commonsetup;override;
		procedure clear;override;
	public

		property fCDecl : boolean read voCDecl;
		property fFile : AnsiString read voFile;
		property fType : TExternalType read voType;
		property fName : AnsiString read voName write voName;
		property fDependencyList : TDependencyList read voDependency;
		constructor Create(const ParName,ParFile : ansistring;ParType : TExternalType;ParCDecl : boolean);
		function IsName(const ParName: ansistring) : boolean;
		function IsFile(const ParFile : ansistring) : boolean;
		procedure AddDependency(ParItem :TLinkObjItem);
	end;

	TLinkObjList=class(TSMList)
	public
			function AddObject(const ParName,ParFile : ansistring;ParType : TExternalType;ParCDecl : boolean):TLinkObjItem;
			function GetItemByName(const ParName : ansistring) : TLinkObjItem;
	end;

implementation

{-----( TDependItem )---------------------------------------------------------------------------}

constructor TDependItem.Create(ParItem :TLinkObjItem);
begin
	iItem := ParItem;
	inherited Create;
end;

{-----( TDependingList )------------------------------------------------------------------------}

procedure TDependencyList.AddDependency(ParItem : TLinkObjItem);
begin
	insertAtTop(TDependItem.Create(ParItem));
end;

{-----( TLinkObjItem )---------------------------------------------------------------------------__}

procedure TLinkObjItem.AddDependency(ParItem : TLinkObjItem);
begin
	iDependencyList.AddDependency(ParItem);
end;

procedure TLinkObjitem.Commonsetup;
begin
	iDependencyList := TDependencylist.Create;
	inherited Commonsetup;
end;

procedure TLinkObjItem.Clear;
begin
	if iDependencyList <> nil then iDependencyList.Destroy;
	inherited Clear;
end;

constructor  TLinkObjItem.Create(const ParName,ParFile : ansistring;ParType : TExternalType;ParCDecl : boolean);
begin
	iName := ParName;
	iFile := ParFile;
	iCdecl := ParCDecl;
	iType := ParType;
	inherited Create;
end;

function TLinkObjItem.IsName(const ParName : ansistring):boolean;
begin
	exit(iName = ParName);
end;

function TLinkObjItem.IsFile(const ParFile : ansistring) : boolean;
begin
	exit(iFile = ParFIle);
end;



{----( TLinkObjList )-------------------------------------------------------}

function  TLinkObjList.GetItemByName(const ParName : ansistring) : TLinkObjItem;
var
	vlCurrent : TLinkObjItem;
begin
	vlCurrent := TLinkObjItem(fStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsName(ParName)) do vlCurrent := TLinkObjItem(vlCurrent.fNxt);
	exit(vlCurrent);
end;

function  TLinkObjList.AddObject(const ParName,ParFile : ansistring;ParType : TExternalType;ParCDecl : boolean):TLinkObjItem;
var
	vlCurrent : TLinkObjItem;
begin
	vlCurrent := GetItemByName(ParName);
	if (vlCurrent <> nil) then exit(vlCurrent);
	vlCurrent := TLinkObjItem.Create(ParName,ParFile,ParType,ParCDecl);
	insertAtTop(vlCurrent);
	exit(vlCurrent);
end;



end.
