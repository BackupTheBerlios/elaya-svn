unit linkobj;
interface
uses stdobj,simplist,elacons;




type
	TLO_Status=(LOS_Ok,LOS_Same_Name_Diff_File,LOS_Same_Name_Diff_CDecl);

TLinkObjItem=class(TSMListItem)
	private
		voName	: ansiString;
		voFile	: ansiString;
		voCDecl  : boolean;
		voType   : TExternalType;

		property iName : AnsiString read voName write voName;
		property iFile : AnsiString read voFile write voFile;
		property iCdecl : boolean read voCDecl write voCDecl;
		property iType  : TExternalType read voType write voType;

	public

		property fCDecl : boolean read voCDecl;
		property fFile : AnsiString read voFile;
		property fType : TExternalType read voType;

		constructor Create(const ParName,ParFile : ansistring;ParType : TExternalType;ParCDecl : boolean);
		function IsName(const ParName: ansistring) : boolean;
		function IsFile(const ParFile : ansistring) : boolean;
	end;

TLinkObjList=class(TSMList)
	public
			function  AddObject(const ParName,ParFile : ansistring;ParType : TExternalType;ParCDecl : boolean):TLo_Status;
			function GetItemByName(const ParName : ansistring) : TLinkObjItem;
	end;

implementation

{-----( TLinkObjItem )---------------------------------------------------------------------------__}

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

function  TLinkObjList.AddObject(const ParName,ParFile : ansistring;ParType : TExternalType;ParCDecl : boolean):TLo_Status;
var
	vlCurrent : TLinkObjItem;
begin
	vlCurrent := GetItemByName(ParName);
	if (vlCurrent <> nil) then begin
		if not vlCurrent.IsFile(ParFile) then exit(LOS_Same_Name_Diff_File);   {TODO add to errors}
		if  vlCurrent.fCDecl <> ParCDecl then exit(Los_Same_Name_Diff_CDecl);
	end else begin
		insertAtTop(TLinkObjItem.Create(ParName,ParFile,ParType,ParCDecl));
	end;
	exit(Los_Ok);
end;



end.
