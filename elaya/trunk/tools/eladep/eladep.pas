uses strings;
type


TRoot=class
protected
	procedure COmmonsetup;virtual;
	procedure Clear;virtual;
public
	constructor create;
	destructor destroy;override;
end;

TString=class(TRoot)
private
	voText : pchar;
	voLength : cardinal;
	property iText : pchar read voText write voText;
	property iLength : cardinal read voLength write voLength;
protected
	procedure  CommonSetup;override;
	procedure  clear;override;

public
	property fText : pchar read voText;
	property fLength : cardinal read voLength;

	procedure   GetString(var ParStr:string);
	constructor Create(const ParStr:string);
	function    IsEqualStr(const ParStr:String):boolean;
end;

	
	TSMListItem=class(TRoot)
	private
		voPrv : TSMLISTITEM;
		voNxt : TSMListItem;
		property iPrv:TSMListItem read voPrv write voPrv;
		property iNxt:TSMListItem read voNxt write voNxt;

	protected
		procedure commonsetup;override;

	public
		property fPrv:TSMListItem read voPrv write voPrv;
		property fNxt:TSMListItem read voNxt write voNxt;
	end;
	
	TSMTextItem=class(TSMListItem)
	private
		voText:TString;
		property iText:TString read voText write voText;
	protected
		procedure   commonsetup;override;
		procedure   Clear;override;

	public
		property    fText:TString read voText;
		procedure   GetTextStr(var ParStr:string);
		procedure   SetText(const ParStr:string);
		constructor Create(const ParTxt:string);
		function    IsEqualStr(const ParStr:string):boolean;
	end;
	
	
	TSMList=class(TRoot)
	private
		voStart : TSMListItem;
		voTop   : TSMListItem;
		property iStart : TSMListItem read voStart write voStart;
		property iTop   : TSMListItem read voTop  write voTop;

	protected
		procedure  Clear;override;
		procedure  Commonsetup;override;
	
	public
		property fStart : TSMListItem read voStart;
		property fTop   : TSMListItem read voTop;
		
		function  CutOut(ParItem:TSMListItem):TSMListItem;
		function  InsertAt(ParAt:TSMListItem;ParItem:TSMListItem):TSMListItem;
		function  InsertAtTop(PArItem : TSMListItem) :TSMListItem;
		function  DeleteLink(ParItem:TSMListItem):TSMListItem;
		function  GetPtrByNum(ParNUm : cardinal) : TSMListItem;
		procedure DeleteAll;
		procedure  ClearList;virtual;
		function  GetNumItems:longint;
		function  IsEmpty:boolean;
	end;
	
	
	TSMTextList=class(TSMList)
		function GetPtrByName(ParStart:TSMTextItem;const ParName:string):TSMTextItem;virtual;
	end;
	
	
	





	  TFileITem=class(TSMTextItem)
			procedure PrintELaName(var ParFile : text);
			procedure PrintEmdName(var ParFile : text);
			procedure PrintMakeReadVar(var ParFile : text);
			procedure PrintMakeWriteVar(var ParFile : text);
			procedure PrintItem(var ParFile : text);
			function  GetMainName : string;
			function  GetBareName : string;
	  end;



	  TFIleList=class(TSMTextList)
			procedure AddFIle(const ParStr : string);
			function GetFileByBareName(const ParStr : string):TFileItem;
			procedure  PrintList(var ParFile : Text);
	  end;

		


	  TUnitList=class(TSMTextList)
			procedure AddUnit(const ParStr : string);
			procedure PrintDep(var ParFile : Text);
	  end;



		TUnitItem=class(TSMTextItem)
			procedure PrintMakeWriteVar(var ParFile : Text);
	  	end;


	  TProgramItem=class(TFIleItem)
	  private
			voUnitList : TUNitList;
			voFileList : TFIleLIst;
	  protected
			procedure COmmonsetup;override;
			procedure Clear;override;
		public
			procedure AddUnit(const ParName :string);
			procedure PrintMake(var ParFile : Text);
			procedure PrintALlName(var ParFile : text);
			procedure PrintClean(var ParFile : Text);
			constructor Create(const ParStr : string;ParFileList : TFileList);
	 end;
	       TAutoLoadList=class(TFileList)
			function IsAutoLOad(const ParFile : string):boolean;
			procedure AddAutoLoadToProgram(ParProgram : TProgramItem);
		end;


		TAutoLoadProgramItem=class(TFileItem)
		private
			voAutoLoadList : TAutoLoadList;
		protected
			procedure Commonsetup;override;
			procedure Clear;override;
		public
			procedure AddAutoLoadToProgram(ParProgram : TProgramItem);
			procedure AddItem(const ParName : string);
		end;

		TAutoLoadProgramList=class(TSMTextList)
			function AddItem(const ParName : string) : TAutoLoadPRogramItem;
			function GetItemByName(const ParName : string) : TAutoLoadPRogramItem;
		end;


	TProgramList = class(TSMTextList)
	private
		voFIleList : TFileList;
		voAutoLoadProgramList : TAutoLoadProgramLIst;
	protected
		procedure COmmonsetup;override;
		procedure Clear;override;
	public
	   function AddProgram(const ParName : string) : TPRogramItem;
		procedure PrintMake(var Parfile : text);
		function LoadAutoList(const ParFileName : string) :boolean;

	end;

var

   vgFile : file;
   CurrentChar : char;
	vlIsPascal : boolean;
	vlName : string;
	vlCnt : cardinal;
	vlList : TprogramList;
	vlFiles : TFileList;
	vlAutoLoad : string;
	vlParamCount : cardinal;
	vlCurrent : TSMTextItem;
	vlUnitDir : string;
   vlUnitExt : string;
	vlSourceExt : string;
   vlCommand : string;
	vlStart : string;
	vlIgnore : TSMTextList;
	vlOutputFileName : string;
   vlOutputFile : text;
   vlError      : boolean;
procedure LowerStr(var ParStr :string);
var
	vlCnt : cardinal;
begin
	vlCnt := length(ParStr);
	while vlCnt > 0 do begin
		case ParStr[vlCnt] of
		'A'..'Z':inc(ParStr[vlCnt],32);
		end;
		dec(vlCnt);
	end;
end;


	
	
	

{----( TRoot)-----------------------------------------------}

procedure TRoot.Clear;
begin
end;

procedure TRoot.COmmonsetup;
begin
end;

constructor TRoot.create;
begin
	commonsetup;
end;

destructor TRoot.Destroy;
begin
	clear;
end;
{----( TString )--------------------------------------------}


procedure TString.CommonSetup;
begin
	inherited commonsetup;
	iText := nil;
end;


constructor TString.create(const ParStr:string);
var
	vlPtr : pointer;
begin
	inherited create;
	iLength := Length(ParStr);
	getmem(vlPtr,iLength + 1);
	iText := vlPtr;
	StrPCopy(iText,ParStr);
end;


procedure TString.GetString(var ParStr:string);
var
	vlLength : cardinal;
begin
	vlLength := fLength;
	if(vlLength > 255) then vlLength := 255;
	SetLength(ParStr, vlLength);
	move(iText^,ParStr[1],vlLength);
end;

function TString.IsEqualStr(const ParStr:String):boolean;
var
	vlP1 :pchar;
	vlP2 : pchar;
	vlLength : cardinal;
begin
	vlLength := length(ParStr);
	if(vlLength <> iLength) then exit(false);
	vlP1 := voText;
	vlP2 := @ParStr[1];
	while (vlLength > 0) and (vlP1^ = vlP2^) do begin
		inc(vLp1);
		inc(vlP2);
		dec(vlLength);
	end;
	exit(vlLength = 0);
end;


procedure TString.Clear;
begin
	inherited clear;
	if(iText <> nil) then Freemem(voText);
end;

{------( TSMTextList )------------------------------------------------}



function TSMTextList.GetPtrByName(ParStart:TSMTextItem;const ParName:string):TSMTextItem;
var vlCurrent:TSMTextItem;
begin
	GetPtrByName := nil;
	if ParStart <> nil then vlCurrent := TSMTextItem(ParStart.fNxt)
	else vlCurrent := TSMTextItem(iStart);
	while (vlCurrent <> nil) and not(vlCurrent.IsEqualStr(ParName)) do vlCurrent := TSMTextItem(vlCurrent.fNxt);
	GetPtrByName := vlCurrent;
end;




{-------( TSMTextItem )-----------------------------------------------}



procedure TSMTextItem.commonsetup;
begin
	inherited commonsetup;
	iText := nil;
end;

function  TSMTextItem.IsEqualStr(const ParStr:string):boolean;
begin
	if iText = nil then exit(false);
	exit(iText.IsEqualStr(ParStr));
end;


procedure TSMTextItem.GetTextStr(var ParStr:string);
begin
	iText.GetString(ParStr);
end;

procedure   TSMTextItem.SetText(const ParStr:string);
begin
	if fText <> nil then fText.Destroy;
	iText := TString.Create(ParStr);
end;

constructor TSMTextItem.Create(const ParTxt:string);
begin
	inherited Create;
	SetText(ParTxt);
end;


procedure TSMTextItem.Clear;
begin
	inherited Clear;
	if iText <> nil then iText.Destroy;
end;




{---( TSMListItem )-----------------------------------------------------------}
procedure TSMListItem.Commonsetup;
begin
	inherited Commonsetup;
	iPrv := nil;
	iNxt := nil;
end;


{---( TSMList )------------------------------------------------------------------}


function TSMList.GetPtrByNum(ParNUm : cardinal) : TSMListItem;
var
	vlCurrent : TSMListItem;
begin
	vlCurrent := iStart;
	while (vlCurrent <> nil) and (ParNum > 1) do begin
		vlCurrent := vlCurrent.fNxt;
		dec(ParNum);
	end;
	exit(vlCurrent);
end;


function TSMList.CutOut(ParItem:TSMListItem):TSMListItem;
var vlNxt:TSMListItem;
begin
	if ParItem = nil then exit(nil);
	vlNxt := ParItem.fNxt;
	CutOut := vlNxt;
	if vlNxt = nil   then iTop  := ParItem.fPrv
	else vlNxt.fPrv := parItem.fPrv;
	if ParItem.fPrv <> nil  then parItem.fPrv.fNxt := vlNxt
	else iStart := vlNxt;
end;


function TSMList.IsEmpty:boolean;
begin
	exit(iStart = nil);
end;

function TSMList.GetNumItems:longint;
var vlCnt:longint;
	vlCur:TSMListItem;
begin
	vlCur := iStart;
	vlCnt :=0;
	while vlCur <> nil do begin
		inc(vlCnt);
		vlCur := vlCur.fNxt;
	end;
	GetNumItems := vlCnt;
end;


function TSMList.InsertAtTop(PArItem : TSMListItem) :TSMListItem;
begin
	exit(InsertAt(iTop,ParItem));
end;

function TSMList.InsertAt(ParAt:TSMListItem;ParITem:TSMListItem):TSMListItem;
var vlNxt : TSMListItem;
begin
	InsertAt := ParItem;
	if ParItem = nil then exit;
	if ParAt = nil then begin
		ParItem.fPrv := nil;
		ParItem.fNxt := iStart;
		if iStart <> nil then iStart.fPrv := ParItem;
		iStart := ParItem;
	end else begin
		vlNxt := ParAt.fNxt;
		if vlNxt <> nil then vlNxt.fPrv := ParItem;
		ParItem.fPrv := ParAt;
		ParItem.fNxt := vlNxt;
		ParAt.fNxt := ParItem;
	end;
	if ParItem.fNxt =nil then iTop := ParItem;
end;

function TSMList.DeleteLink(ParItem:TSMListItem):TSMListItem;
begin
	DeleteLink := CutOut(ParItem);
	if ParItem <> nil then ParItem.Destroy;
end;


procedure TSMList.DeleteAll;
begin
	while iStart <> nil do iStart := deleteLink(iStart);
end;

procedure TSMList.Commonsetup;
begin
	inherited Commonsetup;
	iStart := nil;
	iTop   := nil;
end;

procedure TSMList.ClearList;
begin
	DeleteAll;
end;

procedure TSMList.Clear;
begin
	inherited Clear;
	ClearList;
end;




function GetFileName(const ParName : string): string;
var
	vlCnt : cardinal;
begin
	vlCnt := length(ParName);
	while (vlCnt > 0) and ((ParName[vlCnt]<>'/') and (ParName[vlCnt]<>'\')) do dec(vlCnt);
	exit(copy(ParName,vlCnt + 1,length(ParName) - vlCnt));
end;



{-------( TAutoLoadPRogramList)--------------------------------------------------------------------}

function TAutoLoadProgramList.AddItem(const ParName : string) : TAutoLoadPRogramItem;
var
	vlItem : TAutoLoadProgramItem;
begin
	vlItem := TAutoLoadPRogramItem.Create(ParName);
	insertAtTop(vlItem);
	exit(vlItem);
end;

function TAutoLoadProgramList.GetItemByName(const ParName : string) : TAutoLoadPRogramItem;
var
	vlItem : TAutoLOadProgramItem;
	vlName : string;
	vlItemName : string;
begin
	vlName := GetFileName(ParName);
	LowerStr(vlName);
	vlItem := TAutoLoadProgramItem(fStart);
	while vlItem <> nil do begin
		vlItem.GetTextStr(vlItemName);
		LowerStr(vlItemName);
		if (vlItemName  = vlName) then break;
		vlItem := TautoLoadProgramItem(vlItem.fNxt);
	end;
	if (vlItem = nil) then begin
			vlItem := TAutoLoadProgramItem(GetPtrByName(nil,'*'));
	end;
	exit(vlItem);
end;



{--------( TAutoLoadProgramItem )----------------------------------------------------------------}

procedure TAutoLoadProgramItem.Commonsetup;
begin
	inherited COmmonsetup;
	voAutoLoadList := TAutoLoadList.Create;
end;

procedure TAutoLoadProgramItem.Clear;
begin
	inherited Clear;
	voAutoLoadList.Destroy;
end;

procedure TAutoLoadProgramItem.AddItem(const ParName : string);
begin
	voAutoLoadList.AddFile(ParName);
end;


procedure TAutoLoadPRogramItem.AddAutoLoadToProgram(ParProgram : TProgramItem);
begin
	voAutoLoadList.AddAutoLoadToProgram(ParProgram);
end;

{--( TAutoLoadList)-----------------------------------------------------------------------------}

function TAutoLoadList.IsAutoLOad(const ParFile : string):boolean;
var
	vlFile : string;
begin
	vlFile := GetFileName(ParFIle);
	exit(GetPtrByName(nil,vlFile) <> nil);
end;

procedure TAutoLoadList.AddAutoLoadToProgram(ParProgram : TProgramItem);
var
	vlName  : string;
	vlCurrent : TFileItem;
begin
	ParProgram.GetTextStr(vlName);
	if IsAutoLoad(vlName) then exit;
	vlCurrent := TFileItem(fStart);
	while vlCurrent<> nil do begin
		vlCurrent.GetTextStr(vlName);
		ParProgram.AddUnit(vlName);
		vlCurrent := TFileItem(vlCurrent.fNxt);
	end;
end;

{----( TFileItem )-------------------------------------------------------}



function  TFileItem.GetMainName : string;
var
	vlStr : string;
	vlPs : cardinal;
begin
	vlStr := GetBareName;
	vlPs := pos('.',vlStr);
	if vlPs > 0 then vlStr := copy(vlStr,1,vlPs -1);
	exit(vlStr);
end;

function  TFileItem.GetBareName : string;
var
	vlName : string;
begin
	GetTextStr(vlName);
	exit(GetFileName(vlName));
end;


procedure TFileItem.PrintElaName(var ParFile : text);
var
	vlName : string;
begin
	GetTextStr(vlName);
	write(ParFile,vlName,vlSourceExt);
end;

procedure TFileItem.PrintEmdName(var ParFile :text);
var
	vLName : string;
begin
	GetTextStr(vlName);
	write(ParFile,GetBareName,vlUnitExt);
end;

procedure TFileItem.PrintMakeWriteVar(var ParFile : text);
var
	vlName : string;
begin
	GetTextStr(vlName);
	write(ParFile,GetBareName,'_unit');
end;

procedure TFileItem.PrintMakeReadVar(var ParFile : text);
var
	vlName : string;
begin
	GetTextStr(vlName);
	write(ParFile,'$(');PrintMakeWriteVar(ParFile);write(ParFile,')');
end;

procedure TFileItem.PrintItem(var ParFile : text);
begin
		if vlIgnore.GetPtrByName(nil,GetBareName) = nil then begin
			PrintMakeWriteVar(ParFile); write(ParFile,'=');
			if vlFiles.GetFileByBareName(GetBareName)<> nil then write(ParFile,vlUnitDir);
			PrintEmdName(ParFile);
			writeln(ParFile);
		end;
end;


function TFileList.GetFileByBareName(const ParStr : string):TFileItem;
var
	vlCurrent : TFileItem;
begin
	vlCurrent := TFileItem(fStart);
	while (vlCurrent <> nil) and (vlCurrent.GetMainName <> ParStr) do begin
		vlCurrent := TFileItem(vlCurrent.fNxt);
	end;
	exit(vlCurrent);
end;

procedure TFileList.AddFIle(const ParStr : string);
begin
	if GetPtrByName(nil,ParStr) <> nil then exit;
	InsertAtTop(TFileItem.Create(ParStr));
end;

procedure TFileList.PrintList(var ParFile :text);
var
	vlItem : TFileItem;
begin
   vlItem := TFileItem(fStart);
	while vlItem <> nil do begin
		vlItem.PrintItem(ParFile);
		vlItem := TFileItem(vlItem.fNxt);
	end;
end;


{---( TProgramList )-----------------------------------------------------------}
function TPRogramList.LoadAutoList(const ParFileName : string) :boolean;
var
	vlFile : TExt;
	vlLine : string;
	vlPos  : cardinal;
	vlSource : string;
	vlItem : TAutoLoadProgramItem;
	vlDep : string;
begin
	Assign(vlFile,ParFileName);
	reset(vlFile);
	if ioresult <> 0 then exit(true);
	while not(eof(vlFile)) do begin
		readln(vlFile,vlLine);
		vlPos := pos(':',vlLine);
		vlSource :=copy(vlLine,1,vlPos-1);
		vlItem := voAutoLoadProgramList.AddItem(vlSource);
		delete(vlLine,1,vlPos);
		while length(vlLine)> 0 do begin
			vlPos := pos(',',vlLine);
			if vlPos = 0 then vLPos:= length(vlLine) + 1;
			vlDep := copy(vlLIne,1,vlPos - 1);
			vlItem.AddItem(vlDep);
			voFileList.AddFile(vlDep);
			delete(vlLine,1,vlPos);
   	end;
	end;
	exit(false);
end;

function TProgramList.AddProgram(const ParName : string) : TPRogramItem;
var
	vlItem : TProgramItem;
	vlAutoP : TAutoLoadProgramItem;
begin

	voFileList.AddFile(ParName);
	vlItem := TProgramItem.Create(ParName,voFileList);
	vlAutoP := voAutoLOadProgramList.GetItemByName(ParName);
	if vlAutoP <> nil then vlAutoP.AddAutoLoadToProgram(vlItem);
	InsertAtTop(vlItem);
	exit(vlItem);
end;

procedure TProgramList.Commonsetup;
begin
	inherited Commonsetup;
	voFIleList := TFIleList.Create;
	voAutoLoadProgramList := TAutoLoadProgramList.Create;
end;


procedure TProgramList.Clear;
begin
	inherited Clear;
	voFileList.Destroy;
	voAutoLoadProgramList.Destroy;
end;



procedure TProgramList.PrintMake(var ParFile : text);
var
	vlCurrent : TProgramItem;
begin
	voFileList.PrintList(ParFile);
	vlCurrent := TProgramItem(fStart);
	write(ParFile,'all_',vlStart,':');
	while vlCurrent <> nil do begin
		vlCurrent.PrintAllName(ParFile);
		vlCUrrent := TProgramItem(vlCurrent.fNxt);
	end;
	writeln(ParFile);
	writeln(ParFile);
	writeln(ParFile,'clean_',vlStart,':');
	vlCurrent := TProgramItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.PrintClean(ParFile);
		vlCUrrent := TProgramItem(vlCurrent.fNxt);
	end;
	writeln(ParFile);
	writeln(ParFIle);
	vlCurrent := TProgramItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.PrintMake(ParFile);
		writeln(ParFile);
		vlCUrrent := TProgramItem(vlCurrent.fNxt);
	end;
end;

constructor TProgramItem.Create(const ParStr : string;ParFileList : TFileList);
begin
	voFileList := ParFileLIst;
	inherited Create(ParStr);
end;

procedure TProgramItem.AddUnit(const ParName : string);
begin
	voUNitList.AddUnit(ParName);
	voFileList.AddFile(ParNAme);
end;




procedure TProgramItem.PrintClean(var ParFile : text);
begin
	writeln(ParFile,chr(9),'rm -f ',vlUnitDir,GetBareName,'.*');
end;

procedure TProgramItem.PrintALlName(var ParFile : Text);
begin
	if fPrv <> nil then write(ParFile,chr(9));
	PrintMakeReadVar(ParFile);
	if fNxt <> nil then write(ParFile,'\');
	writeln(ParFile);
end;

procedure TProgramItem.PrintMake(var ParFile : text);
begin
   PrintMakeReadVar(ParFile);
	write(ParFile,':');
	voUnitList.PrintDep(ParFile);
	write(ParFile,chr(9));PrintElaName(ParFile);writeln(ParFile);
	if length(vlCommand) > 0 then begin
		write(ParFile,chr(9),'$(',vlCommand,') ');
		printElaName(ParFIle);
		writeln(ParFIle);
	end;
	writeln(ParFile);
end;

procedure TProgramItem.Commonsetup;
begin
	inherited COmmonsetup;
	voUnitList := TUnitList.Create;
end;

procedure TProgramItem.Clear;
begin
	inherited Clear;
	if voUnitList <> nil then voUnitList.Destroy;
end;



procedure TUnitList.AddUnit(const ParStr : string);
begin
	InsertAtTop(TUnitItem.Create(ParStr));
end;

procedure TUnitList.PrintDep(var ParFile : text);
var
	vlCurrent : TUnitItem;
	vlName : string;
begin

	vlCurrent := TUnitItem(fStart);
	while vlCurrent <> nil do begin
		vlCurrent.GetTextStr(vlName);
		if vlIgnore.GetPtrByName(nil,vlName) = nil then begin
			if vlCurrent.fPrv <> nil then write(chr(9));
			write(ParFile,'$(');
			vlCurrent.PrintMakeWriteVar(ParFile);
			writeln(ParFile,')\');
		end;
		vlCurrent := TUnitItem(vlCurrent.fNxt);
	end;

end;

procedure TUnitItem.PrintMakeWriteVar(var ParFile : text);
var
	vlName : string;
begin
	GetTextStr(vlName);
	write(ParFile,vlName,'_unit');
end;


function GetNextChar :boolean;
begin
	if eof(vgFile) then exit(true);
	blockread(vgFile,CurrentChar,1);
	if ioresult <> 0 then begin
		writeln('Error');
		halt(1);
	end;
	if CurrentChar in ['a'..'z'] then dec(CurrentChar,32);
	exit(false);
end;


function GetNextIdent(var ParStr : string) : boolean;
var
	vlComment : cardinal;
begin
	vlComment := 0;
	SetLength(ParStr,0);
	repeat
		if CurrentChar = '{' then inc(vlComment) else
		if (CurrentChar = '}') then begin
			if  (vlComment > 0) then dec(vlComment);
		end else if (vlComment = 0) and (not(CurrentChar in [#9,#32,#13,#10])) then break;
		if GetNextChar then exit(true);
	until false;
	case CurrentChar of
		'_','A'..'Z':begin
			repeat
				ParStr := ParStr + CurrentCHar;
				if GetNextChar then break;
			until not(CurrentChar in['A'..'Z','0'..'9','_']);
		end else begin
			ParStr :=CurrentChar;
			GetNextChar;
		end;
	end;
	exit(false);
end;


function Expect(const PArStr :string;var ParOut : string):boolean;
begin
	if GetNextIdent(ParOut) then begin
		writeln('"',ParOut,' not found but end of file');
		exit(true);
	end;
	if ParOut <> ParStr then begin
		writeln('"',ParStr,' not found but:"',ParOut,'"');
		exit(true);
	end;
	exit(false);
end;


function FileName(const ParName : string):string;
var
	vlCnt : cardinal;
begin
	vlCnt := length(ParName);
	while (vlCnt >0) and (ParName[vlCnt] <>'.') do dec(vlCnt);
	if vlCnt = 0 then vlCnt := length(ParName) +1;
	exit(copy(ParName,1,vlCnt - 1));
end;


function Run(ParItem : TPRogramItem):boolean;
var
	vlStr : string;
	vlType : string;
begin
	if GetNextChar then exit(true);
	if GetNExtIdent(vlStr) then exit(true);
	if (vlStr = 'UNIT') or (vlStr='PROGRAM')  then begin
	vlType := vlStr;
		if vlIsPascal then begin
			if GetNextIdent(vlStr) then exit(true);
		end;
		if Expect(';',vlStr) then exit(true);
		if vlIsPascal and (vlType='UNIT')  then begin
			if GetNextIdent(vlStr) then exit(true);
			if vlStr <> 'INTERFACE' then exit(true);
		end;
		if GetNextIdent(vlStr) then exit(true);
	end;
	if vlStr <> 'USES' then exit(false);
	while true do begin
		if GetNextIdent(vlStr) then break;
		LowerStr(vlStr);
		ParItem.AddUnit(vlStr);
		if GetNextIdent(vlStr) then break;
		if vlStr =';' then break;
		if vlStr <>',' then begin
			writeln('"," expected but ',vlStr,' found');
   		exit(true);
		end;
	end;
	exit(false);
end;

function RunFile(const ParFileName : string;ParList : TProgramList):boolean;
var
	vlItem : TProgramItem;
	vlFn : string;
	vlResult : boolean;
begin
	vlFn := FIleName(ParFileName);
	assign(vgFile,ParFileName);
	vlItem := ParList.AddProgram(vlFn);
	reset(vgFile,1);
	if ioresult <> 0 then begin
		writeln('Can''''t open file:',ParFileName);
		exit(true);
	end;
	vlResult := Run(vlItem);
	close(vgFile);
	exit(vlResult);
end;





function NextParam(var ParStr : string):boolean;
begin
	SetLength(PArStr,0);
	if vlParamCount >= ParamCount then exit(true);
	inc(vlParamCount);

	ParStr := paramstr(vlParamCount);
	exit(false);
end;


function getparameters:boolean;
var
	vlStr :string;
begin
	while not(NextParam(vlStr)) do begin
		if(vlStr[1]='-') then begin
			if length(vlStr) <2 then exit(true);
			case vlStr[2] of 
			'o':if nextParam(vlOutputFileName) then exit(true);
			'a':if NextParam(vlAutoLoad) then exit(true);
			'u':if NextParam(vlUnitDir)    then exit(true);
			'p':vlIsPascal := true;
			'e':if NextParam(vlUnitExt) then exit(true);
			's':if NextParam(vlSourceExt) then exit(true);
		         'c':if NextParam(vlCommand) then exit(true);
			'm':if NextParam(vlStart) then exit(true);
			'i':begin
					if NextParam(vlStr) then exit(true);
					vlIgnore.InsertAtTop(TSMTextItem.Create(vlStr));
				end;
			end;
		end else begin
			vlFiles.AddFile(vlStr);
		end;
	end;   
	exit(false);
end;

begin
	if ParamCount=0 then begin
		writeln('Syntax error :');
		writeln('   eladep <filename> [-a <autoload>] [-c <compile command>] [-m <start>] [-p] [-e <unit extention>] [-u <unit directory>] [-s <source ext>] -o <outputfile>');
		halt(1);
	end;
	vlList := TProgramList.create;
	vlFiles := TFileList.Create;
	vlIgnore := TSMTextList.Create;

	vlCnt := 1;
	vlParamCount := 0;
	vlIsPascal := false;
	SetLength(vlAutoLOad,0);
	SetLength(vlUnitDir,0);
	SetLength(vlUnitExt,0);
	SetLength(vLSourceExt,0);
	SetLength(vlCommand,0);
	SetLength(vlOutputFileName,0);
	vlStart := 'main';
	if getparameters then begin
		writeln('Invalid parameters');
		halt(1);
	end;

	if length(vlOutputFileName) = 0 then begin
		writeln('No outputfile ');
		halt(1);
	end;

	if length(vlAutoLoad) <> 0 then begin
	   if vlList.LoadAutoList(vlAutoLoad) then begin
			writeln('Can''''t load autoloading list ',vlAutoLoad);
			halt(1);
		end;
	end;

	vlCurrent := TSMTextItem(vlFiles.fStart);
	vlError := false;
	while (vlCurrent <> nil) do begin
		vlCurrent.GetTextStr(vlName);
		if runfile(vlName,vlList) then begin
			writeln('syntax error in file ',vlName);
			vlError := true;
		end;
		vlCurrent := TSMTextItem(vlCurrent.fNxt);
	end;

	if vlError then begin
		writeln('Parsing errors found, no output written');
		halt(1);
	end;
	assign(vlOutputFile,vlOutputFileName);
	rewrite(vlOutputFile);
	if ioresult <> 0 then begin
		writeln('Can''''t open output filename :',vlOutputFileName);
		halt(1);
	end;
	vlList.PrintMake(vlOutputFile);
	close(vlOutputFile);
	vlList.Destroy;
	vlFiles.Destroy;
	close(vgFile);
end.

