{
Elaya,; the compiler for the ;elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web   : www.elaya.org

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

unit exprdigi;
interface
uses sysutils,largenum,elatypes,params,classes,ddefinit,cblkbase,execobj,error,
node,elacons,ndcreat,stdobj,formbase,simplist,progutil;
type
	
	TDigiList=class(TSMList)
	end;
	
	TDigiItem=class(TSMListItem)
	private
		voLine : cardinal;
		voCol  : cardinal;
		voPos  : cardinal;
		property iLine : cardinal read voLine write voLine;
		property iCol  : cardinal read voCol write voCol;
		property iPos  : cardinal read voPos write voPos;
	protected
		procedure Commonsetup;override;

	public
		property fLine : cardinal read voLine write voLine;
		property fCol  : cardinal read voCol write voCol;
		property fPos  : cardinal read voPos write voPos;
		function CreateReadNode(ParCre : TNDCreator) : TFormulaNode;virtual;
		function CreateWriteNode(ParCre : TNDCreator;ParFrom : TDigiItem):TFormulaNode;virtual;
		function CreateDotWriteNode(ParCre : TNDCreator;ParLeft : TFormulaNode;ParFrom : TDigiItem):TFormulaNode;virtual;
		function CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;virtual;
		function CreateObjectPointerOfNode(ParCre : TNDCreator) : TFormulaNode;
		procedure SetNodePos(ParNode : TNodeIdent);
	end;

	
	TNodeDigiItem=class(TDigiItem)
	private
		voNode : TFormulaNode;
		voIsUsed : boolean;
		
	protected
		property iNode   : TFormulaNode read voNode write voNode;
		property iIsUSed : boolean read voIsUsed write voIsUsed;
		procedure Commonsetup;override;
		procedure Clear;override;

	public
		property fNode   : TFormulaNode read voNode write voNode;

		function Can(ParCan : TCan_Types) : boolean;
		function GetType : TType;
		function CreateReadNode(ParCre : TNDCreator) : TFormulaNode;override;
		constructor Create(ParNode : TFormulaNode);
	end;


	TIdentDigiItem=class(TDigiItem)
	private
		voItem  :TFormulaDefinition;
		voOwner : TDefinition;
	protected
		property iItem  : TFormulaDefinition read voItem  write voItem;
		property iOwner : TDefinition read voOwner write voOwner;
	public
		property  fItem : TFormulaDefinition read voItem;
		function CreateReadNode(ParCre : TNDCreator) : TFormulaNode;override;
		constructor Create(ParItem :TFormulaDefinition;ParOwner : TDefinition);
		function CreateWriteNode(ParCre : TNDCreator;ParFrom : TDigiItem):TFormulaNode;override;
		function CreateDotWriteNode(ParCre : TNDCreator;ParLeft : TFormulaNode;ParFrom : TDigiItem):TFormulaNode;override;
		function CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;override;
		procedure PreCreate(ParCre :TNDCreator);virtual;
	end;
	
	
	THookDigiItem=class(TNodeDigiItem)
	private
		voName : AnsiString;
		
		property iName : AnsiString read voName write voName;
	public
		property fName : AnsiString read voName;
		constructor Create(ParNode : TFormulaNode;const ParNAme : ansistring);
		function HasName : boolean;
	end;

	THookDigiList = class(TDigiList)
	public
		procedure AddItem(ParNode : TFormulaNode;const ParName : ansistring);
		function IsSameParameters(ParPar : TProcParList;ParExact : boolean):boolean;
	end;
	
	TShortNotationDigiItem=class(TIdentDigiItem)
	public
		procedure ProcessNode(ParCre :TNDCreator;ParNode : TFormulaNode);
	end;
	
	
	TSubItemDigiItem=class(TDigiItem)
	private
		voItem : TDigiItem;
		
	protected
		property iItem : TDigiItem  read voItem write voItem;
		
	public
		procedure Clear;override;
		constructor Create(ParItem : TDigiItem);
	end;
	
	
	TIdentHookDigiItem=class(TSubItemDigiItem)
	private
		voList    : THookDigiList;
		voShort   : TShortNotationDigiItem;
		voLocal   : TDefinition;
		voInheritLevel : cardinal;
		voRecordNode   : TFormulaNode;
		
		property iList        : THookDigiList          read voList         write voList;
		property iShort       : TShortNotationDigiItem read voShort        write voShort;
		property iInheritLevel: cardinal               read voInheritLevel write voInheritLevel;
		property iLocal       : TDefinition            read voLocal        write voLocal;
		property iRecordNode  : TFormulaNode           read voRecordNode   write voRecordNode;
	protected
		procedure Commonsetup;override;
		procedure clear;override;

	public
		property fList         : THookDigiList read voList;
		property fInheritLevel : cardinal      read voInheritLevel write voInheritLevel;
		property fLocal        : TDefinition   read voLocal        write voLocal;
		property fRecordNode   : TFormulaNode  read voRecordNode   write voRecordNode;		
		function CreateReadNode(ParCre : TNDCreator) : TFormulaNode;override;
		function CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;override;
		function ProcessNode(ParCre : TNDCreator;ParNode : TFormulaNode) : TFormulaNode;
		function CreateDotWriteNode(ParCre : TNDCreator;ParLeft : TFormulaNode;ParFrom : TDigiItem):TFormulaNode;override;
		function CreateWriteNode(ParCre : TNDCreator;ParValue : TDigiItem) : TFormulaNode;override;
		function IsSameParameters(ParPar : TProcParList;ParExact : boolean):boolean;
		procedure SetShort(ParShort : TShortNotationDigiItem);
	end;
	
	
	TNamendIdentDigiItem=class(TIdentDigiItem)
	private
		voName  : AnsiString;
		voIsDetermend : boolean;
	protected
		property iName        : AnsiString read voName  write voName;
		property iIsDetermend : boolean    read voIsDetermend write voIsDetermend;
	protected
		procedure Commonsetup;override;
	public
		property fItem  : TFormulaDefinition read voItem;
		
		constructor create(const ParName : ansistring);
		procedure DetermenItem(ParCre :TNDCreator;ParLocal : TFormulaNode);
		procedure PreCreate(ParCre : TNDCreator);override;
	end;
	
	TDotOperDigiItem=class(TSubItemDigiItem) {TODO: Make inherit from TIdentHookDigi?}
	private
		voField      : TIdentHookDigiItem;
		voFieldIdent : TNamendIdentDigiItem;
		voRecordNode : TFormulaNode;
		
	protected
		property iField      : TIdentHookDigiItem   read voField      write voField;
		property iFieldIdent : TNamendIdentDigiItem read voFieldIdent write voFieldIdent;
		property iRecordNode : TFormulaNode         read voRecordNode  write voRecordNode;
		procedure Clear;override;
		procedure Commonsetup;override;

		
	public
		property fField : TIdentHookDigiItem read voField;
		function GetFieldIdentItem : TDefinition;
		constructor Create(ParItem  : TDigiItem;ParField :TIdentHookDigiItem;ParFieldIdent : TNamendIdentDigiItem);
		function CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;override;
		function CreateReadNode(ParCre : TNDCreator):TFormulaNode;override;
		function CreateWriteNode(ParCre : TNDCreator;ParDigi : TDigiItem) :TFormulaNode;override;
		procedure HandleRFI(PArCre : TNDCreator);
		function  CanRecord(ParCan :TCan_Types):boolean;
		function  GetRecordType : TType;
		function  ProcessNode(ParCre :TNDCreator;ParNode : TFormulaNode) : TFormulaNode;
	end;
	
	
	TNumberDigiItem=class(TDigiItem)
	private
		voNumber : TNumber;
	protected
		property iNumber : TNumber read voNumber write voNumber;
	public
		constructor Create(const ParNumber : TNUmber);
		function CreateReadNode(ParCre : TNDCreator):TFormulaNode;override;
	end;
	
	TStringDigiItem=class(TDigiItem)
	private
		voString : TString;
	protected
		property iString : TString read voString write voString;
	public
		constructor Create(const ParString : ansistring);
		function CreateReadNode(ParCre : TNDCreator):TFormulaNode;override;
		procedure clear;override;
	end;
	
	TOperatorDigiItem=class(TDigiItem)
	private
		voExprL         : TDigiItem;
	protected
		property iExprL : TDigiItem read voExprL write voExprL;
	public
		procedure Clear;override;
		constructor Create(ParExprL : TDigiItem);
	end;
	
	TNamendOperatorDigiItem=class(TOperatorDigiItem)
	private
		voOperator : TString;
		voOperatorClass : TRefNodeIdent;
		
		property iOperator : TString read voOperator write voOperator;
		property iOperatorClass : TRefNodeIdent read voOperatorClass write voOperatorClass;
		
	public
		constructor Create(ParExprL : TDigiItem;const ParOperator : ansistring;ParClass :TRefNodeIdent);
		procedure Clear;override;
	end;
	
	TSingleOperatorDigiItem=class(TNamendOperatorDigiItem)
	public
		function CreateReadNode(ParCre : TNDCreator):TFormulaNode;override;
	end;
	
	TDualOperatorDigiItem=class(TNamendOperatorDigiItem)
	private
		voExprR : TDigiItem;
	protected
		property iExprR : TDigiItem read voExprR write voExprR;
	public
		constructor Create(ParExprL,ParExprR : TDigiItem;const ParOperator : ansistring;ParClass :TRefNodeIdent);
		function CreateReadNode(ParCre : TNDCreator):TFormulaNode;override;
		procedure clear;override;
	end;

	THashOperatorDigiItem=class(TDualOperatorDigiItem)
	public
 		function CreateWriteNode(ParCre : TNDCreator;ParFrom : TDigiItem):TFormulaNode;override;
	end;


	TBetweenOperatorDigiItem=class(TNamendOperatorDigiItem)
	private
		voLo : TDigiItem;
		voHi : TDigiItem;
	protected
		property iLo : TDigiItem read voLo write voLo;
		property iHi : TDigiItem read voHi write voHi;
	public
		constructor Create(ParExprL,ParLo,ParHi : TDigiItem;const ParOperator : ansistring);
		function CreateReadNode(ParCre : TNDCreator):TFormulaNode;override;
		procedure clear;override;
	end;

	TCompOperatorDigiItem=class(TNamendOperatorDigiItem)
	private
		voExprR : TDigiItem;
		voCompType : TIdentCode;
	protected
		property iExprR : TDigiItem read voExprR write voExprR;
		property iCompType : TIdentCode read voCompType write voCompType;
	public
		constructor Create(ParExprL,ParExprR : TDigiItem;const ParOperator : ansistring;ParCompType : TIdentCode);
		function CreateReadNode(ParCre : TNDCreator):TFormulaNode;override;
		procedure clear;override;
	end;
	
	
	TByPointerOperatorDigiItem=class(TOperatorDigiItem)
	public
		function CreateReadNode(ParCre : TNDCreator):TFormulaNode;override;
		function CreateExecuteNode(ParCre : TNDCreator):TFormulaNode;override;
	end;
	
	TArrayDigiList=class(TDigiList)
	public
		procedure AddItem(ParNode : TFormulaNode);
		procedure AddIndexExprToNode(ParCre :TNDCreator;ParArray : TArrayIndexNode);
	end;
	
	TArrayDigiItem=class(TOperatorDigiItem)
	private
		voList  : TArrayDigiList;
		
		property iList  : TArrayDigiList read voList write voList;
		
	protected
		procedure commonsetup;override;
		procedure Clear;override;

	public
		procedure AddIndexItem(ParNode : TFormulaNode);
		function CreateReadNode(ParCre : TNDCreator) : TFormulaNOde;override;
	end;
	
	TSizeOfDigiItem=class(TOperatorDigiItem)
	public
		function CreateReadNode(ParCre : TNDCreator) : TFormulaNode;override;
	end;
	
	TNilDigiItem = class(TDigiItem)
	public
		function CreateReadNode(ParCre : TNDCreator) : TFormulaNode;override;
	end;
	
	TPointerOfDigiItem=class(TOperatorDigiItem)
	public
		function CreateReadNode(ParCre : TNDCreator) : TFormulaNode;override;
	end;

	TCastDigiItem=class(TDigiItem)
	private
		voExpression : TDigiItem;
		voCastIdent  : TDefinition;
	protected
		property iExpression : TDigiItem read voExpression write voExpression;
		property iCastIdent  : TDefinition read voCastIdent write voCastIdent;
		procedure Clear;override;
	public
		constructor Create(ParExpression : TDigiItem;ParCastIdent : TDefinition);
		function CreateReadNode(ParCre : TNDCreator) : TFormulaNode;override;
		function CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;override;
		function ProcessNode(ParCre : TNDCreator;ParNode : TFormulaNode) : TFormulaNode;
		function CreateDotWriteNode(ParCre : TNDCreator;ParLeft : TFormulaNode;ParFrom : TDigiItem):TFormulaNode;override;
		function CreateWriteNode(ParCre : TNDCreator;ParValue : TDigiItem) : TFormulaNode;override;
	end;

implementation

uses procs;


{-----( TCastDigiItem )-----------------------------------------------------------}

procedure TCastDigiItem.Clear;
begin
	inherited Clear;
	if iExpression<> nil then iExpression.Destroy;
end;

constructor TCastDigiItem.Create(ParExpression : TDigiItem;ParCastIdent : TDefinition);
begin
	inherited Create;
	iExpression := ParExpression;
	iCastIdent := ParCastIdent;
end;

function TCastDigiItem.ProcessNode(ParCre : TNDcreator;ParNode :TFormulaNode) : TFormulaNode;
var
	vlResult : TFormulaNode;
begin
	vlResult := nil;
	if ParNode <> nil then begin
		vlResult := TTypeNode.Create(TType(iCastIdent),ParNode);
		SetNodePos(vlResult);
	end;
	exit(vlResult);
end;

function TCastDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	if iCastIdent = nil then exit(nil);
	if iExpression = nil then exit(nil);
	if not(iCastIdent is TTYpe) then begin
		ParCre.ErrorDef(Err_Not_A_Type,iCastIdent);
		exit(nil);
	end;
	vlNode := iExpression.CreateReadNode(ParCre);
	exit(ProcessNode(ParCre,vlNode));
end;


function TCastDigiItem.CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;
var
	vlNode : TFormulaNode;
begin
	if iCastIdent = nil then exit(nil);
	if iExpression = nil then exit(nil);
	if not(iCastIdent is TTYpe) then begin
		ParCre.ErrorDef(Err_Not_A_Type,iCastIdent);
		exit(nil);
	end;
	vlNode := iExpression.CreateReadNode(ParCre);
	exit(ProcessNode(ParCre,vlNode));
end;

function  TCastDigiItem.CreateDotWriteNode(ParCre : TNDCreator;ParLeft : TFormulaNode;ParFrom : TDigiItem):TFormulaNode;
var
	vlNode : TFormulaNode;
	vlValue : TFormulaNode;
	vlNodeU : TFormulaNode;
	vlField : TFormulaNode;
begin
	if ParFrom = nil then exit(nil);
	vlField := CreateReadNode(ParCre);
	if vlField = nil then exit(nil);
	vlField.fRecord :=ParLeft;
	vlNode := vlField;
	vlValue := ParFrom.CreateReadNode(ParCre);
	SetNodePos(vlNode);
	SetNodePos(vlValue);
	vlNodeU := ParCre.MakeLoadNode(vlValue,vlNOde);
	SetNodePos(vlNodeU);
	exit(vlNodeU);
end;


function TCastDigiItem.CreateWriteNode(ParCre : TNDCreator;ParValue : TDigiItem) : TFormulaNode;
var
	vlNode : TFormulaNode;
	vlValue : TFormulaNode;
	vlNodeU : TFormulaNode;
begin
	if ParValue = nil then exit(nil);
	vlNode := CreateReadNode(ParCre);
	if vlNode = nil then exit(nil);
	vlValue := ParValue.CreateReadNode(ParCre);
	SetNodePos(vlNode);
	vlNodeU := ParCre.MakeLoadNode(vlValue,vlNode);
	SetNodePos(vlNodeU);
	exit(vlNodeU);
end;

{---( TPointerTODigiItem )---------------------------------------------------}

function TPointerOfDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	vlNode := nil;
	if iExprL <> nil then begin
		vlNode := iExprL.CreateObjectPointerOfNode(ParCre); {TODO : CreateValuePointer of(hernoem classe)}
		setnodepos(vlNode);
	end;
	exit(vlNode);
end;


{---( TSingleOperatorDigiItem )----------------------------------------------}

function TSingleOperatorDigiItem.CreateReadNode(ParCre : TNDCreator):TFormulaNode;
var
	vlNodeL : TFormulaNode;
	vlResult : TFormulaNode;
	vlName   : ansistring;
begin
	vlResult := nil;
	if iExprL <> nil then begin
		vlNodeL := iExprL.CreateReadNode(ParCre);
		iOperator.GetString(vlName);
		ParCre.ProcessSingleOperator(vlNodeL,vlResult,vlName,iOperatorClass);
	end;
	exit(vlResult);
end;

{---( TNamedOPeratorDigiItem )-----------------------------------------------}

constructor TNamendOPeratorDigiItem.Create(ParExprL : TDigiItem;const ParOperator : ansistring;ParClass : TRefNodeIdent);
begin
	inherited Create(ParExprL);
	iOperator := TString.Create(ParOperator);
	iOperatorClass := ParClass;
end;

procedure TNamendOperatorDigiItem.Clear;
begin
	inherited Clear;
	if iOperator <> nil then iOperator.Destroy;
end;


{---( TNilDigiItem )---------------------------------------------------------}

function TNilDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	vlNode := TFormulaNode(ParCre.GetPointerCons(nil));
	SetNodePos(vlNode);
	exit(vlNode);
end;


{---( TSizeofDigiItem )-------------------------------------------------------}

function TSizeOfDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNode;
var
	vlExpr : TFormulaNode;
	vlNode : TFormulaNode;
begin
	vlNode := nil;
	if iExprL <> nil then begin
		vlExpr := iExprL.CreateReadNode(ParCre);
		vlNode := TSizeOfNode.Create(vlExpr);
		SetNodePos(vlNode);
	end;
	exit(vlNode);
end;

{---( TOperatorDigiItem )------------------------------------------------------}

procedure TOperatorDigiItem.Clear;
begin
	inherited Clear;
	if iExprL <> nil then iExprL.Destroy;
end;

constructor TOperatorDigiItem.Create(ParExprL : TDigiItem);
begin
	inherited Create;
	iExprL := ParExprL;
end;

{---( jTArrayDigiList )---------------------------------------------------------}

procedure TArrayDigiList.AddItem(ParNode : TFormulaNode);
begin
	InsertAtTop(TNodeDigiItem.Create(ParNode));
end;

procedure TArrayDigiList.AddIndexExprToNode(ParCre :TNDCreator;ParArray : TArrayIndexNode);
var
	vlCurrent : TNodeDigiItem;
	vlNode    : TFormulaNode;
begin
	vlCurrent := TNodeDigiItem(fStart);
	while (vlCurrent <> nil) do begin
		vlNode :=  vlCurrent.CreateReadNode(ParCre);
		if vlNode <> nil then ParArray.AddNode(vlNode);
		vlCurrent := TNodeDigiItem(vlCurrent.fNxt);
	end;
end;



{---( TArrayDigiItem )---------------------------------------------------------}

procedure TArrayDigiItem.Commonsetup;
begin
	inherited Commonsetup;
	iList := TArrayDigiList.Create;
end;

procedure TArrayDigiItem.Clear;
begin
	inherited Clear;
	if iList <> nil then iLIst.Destroy;
end;


procedure TArrayDigiItem.AddIndexItem(parNode : TFormulaNode);
begin
	iList.AddItem(ParNode);
end;

function TArrayDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNOde;
var
	vlNode : TArrayIndexNode;
	vlBase : TFormulaNode;
begin
	vlNode := nil;
	if iExprL <> nil then begin
		vlBase := iExprL.CreateReadNode(ParCre);
		vlNode := TArrayIndexNode.Create(vlBase);
		iList.AddIndexExprToNode(ParCre,vlNode);
		SetNodePos(vlNode);
	end;
	exit(vlNode);
end;


{---( TByPointerOperatorDigiItem )----------------------------------------------}

function TByPointerOperatorDigiItem.CreateReadNode(ParCre : TNDCreator):TFormulaNode;
var
	vlNode : TFormulaNode;
	vlNode2 : TFormulaNode;
	vlType : TType;
begin                              {TODO what to fold in CreateExecuteNode?}
	vlNode2   := nil;              {TODO CreateDeReferencePorinterNode methode?}
	if iExprL <> nil then begin
		vlNode := iExprL.CreateReadNode(ParCre);
		if vlNode <> nil then begin
			vlNode.Proces(ParCre);{TODO Proces problem}
			vlType   := vlNode.GetOrgType;
			if vlType <> nil then begin
				if vlType is TRoutineType then begin
					vlNode2 := TCallNode.Create(''); {TODO THis can better}
					TCallNode(vlNode2).SetRoutineItem(ParCre,TRoutineType(vlType).fRoutine,nil);
					TCallNode(vlNode2).SetCallAddress(PARCRE,vlNode);
					TCallNode(vlNode2).fFrame := TRoutineType(vlType).fPushedFrame;
				end else begin
					vlNode2 := TByPtrNode.Create(vlNode);
				end;
				SetNodePos(vlNode2);
			end else begin
				vlNode.Destroy;
			end;
		end;
	end;
	exit(vlNode2);
end;

function TByPointerOperatorDigiItem.CreateExecuteNode(ParCre : TNDCreator):TFormulaNode;
begin
	exit(CreateReadNode(ParCre));
end;

{---( TStringDIgiItem )-------------------------------------------------------}

constructor TStringDigiItem.Create(const ParString : ansistring);
begin
	inherited Create;
	iString := TString.Create(ParString);
end;

function TStringDigiItem.CreateReadNode(ParCre : TNDCreator):TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	vlNode := TFormulaNode(ParCre.ConvertTextToNode(iString.NewString));
	SetNodePos(vlNode);
	exit(vlNode);
end;

procedure TStringDigiItem.clear;
begin
	inherited Clear;
	if iString <> nil then iString.Destroy;
end;


{---( THasOperatorDigiItem )--------------------------------------------------}

function THashOperatorDigiItem.CreateWriteNode(ParCre : TNDCreator;ParFrom : TDigiItem):TFormulaNode;
var
	vlOut : TFormulaNode;
	vlNodeL : TFormulaNode;
	vlNodeR : TFormulaNode;
	vlFrom  : TFormulaNode;
	vlName  : ansistring;
begin
		if (iExprL  = nil) or (iExprR = nil) then exit(nil);
		if ParFrom = nil then exit(nil);
		vlNodeL := iExprl.CreateReadNode(ParCre);
		vlNodeR := iExprR.CreateReadNode(ParCre);
		if vlNodeR = nil then begin
			vlNodeL.Destroy;
			exit(nil);
		end;
		vlFrom  := ParFrom.CreateReadNode(ParCre);
		if(vlFrom = nil) then begin
			vlNodeL.Destroy;
			vlNodeR.Destroy;
			exit(nil);
		end;
		iOperator.Getstring(vlName);
		ParCre.ProcessOperator([vlNodeL,vlNodeR,vlFrom],vlOut,vlName,true);
		exit(vlOut);
end;


{---( TDualOperatorDigiItem )-------------------------------------------------}

constructor TDualOperatorDigiItem.Create(ParExprL,ParExprR : TDigiItem;const ParOperator : ansistring;ParClass :TRefNodeIdent);
begin
	inherited Create(ParExprL,ParOperator,ParClass);
	iExprR := ParExprR;
end;

function  TDualOperatorDigiItem.CreateReadNode(ParCre : TNDCreator):TFormulaNode;
var
	vlNodeL : TFormulaNode;
	vlNodeR : TFormulaNode;
	vlOperator : ansistring;
begin
	vlNodeL := nil;
	if(iExprl <> nil) and (iExprR <> nil) then begin
		vlNodeL := iExprL.CreateReadNode(ParCre);
		vlNodeR := iExprR.CreateReadNode(ParCre);
		iOperator.GetString(vlOperator);
		vlNodeL := ParCre.ProcessDualOperator(vlNodeR,vlNodeL,vlOperator,iOperatorCLass);
	end;
	exit(vlNodeL);
end;

procedure TDualOperatorDigiItem.clear;
begin
	if iExprR <> nil    then iExprR.Destroy;
	inherited Clear;
end;

{----------( TBetweenOperatorDigiItem )---------------------------------------------------}

constructor TBetweenOperatorDigiItem.Create(ParExprL,ParLo,ParHi : TDigiItem;const ParOperator : ansistring);
begin
	inherited Create(ParExprL,ParOperator,nil);
	iLo := ParLo;
	iHi := PArHi;
end;

function TBetweenOperatorDigiItem.CreateReadNode(ParCre : TNDCreator):TFormulaNode;
var
	vlLoNode : TFormulaNode;
	vlHiNode : TFormulaNode;
	vlLNode  : TFormulaNode;
	vlResult : TFormulaNode;
	vlName : ansistring;
begin
	vlResult := nil;
	if (iLo <> nil) and (iHi <> nil) and (iExprL <> nil) then begin
		vlLoNode := iLo.CreateReadNode(ParCre);
		vlHiNode := iHi.CreateReadNode(ParCre);
		vlLNOde  := iExprL.CreateReadNode(ParCre);
		iOperator.GetString(vlName);
		ParCre.ProcessBetweenOperator(vlLNode,vlLoNode,vlHiNode,vlResult,vlName);
    end;
	exit(vlResult);
end;

procedure TBetweenOperatorDigiItem.clear;
begin
	inherited Clear;
	if iLo <> nil then iLo.Destroy;
	if iHi <> nil then iHi.Destroy;
end;


{-----------( TCompOperatorDigiitem )---------------------------------------------}

constructor TCompOperatorDigiItem.Create(ParExprL,ParExprR : TDigiItem;const ParOperator : ansistring;ParCompType : TIdentCode);
begin
	inherited Create(ParExprL,ParOperator,nil);
	iExprR := ParExprR;
	iCompType := ParCompType;
end;

function  TCompOperatorDigiItem.CreateReadNode(ParCre : TNDCreator):TFormulaNode;
var
	vlNodeL : TFormulaNode;
	vlNodeR : TFormulaNode;
	vlOperator : ansistring;
begin
	vlNodeL := nil;
	if(iExprl <> nil) and (iExprR <> nil) then begin
		vlNodeL := iExprL.CreateReadNode(ParCre);
		vlNodeR := iExprR.CreateReadNode(ParCre);
		iOperator.GetString(vlOperator);
		ParCre.ProcessCompOperator(vlNodeR,vlNodeL,vlOperator,iCompType);
	end;
	exit(vlNodeL);
end;

procedure TCompOperatorDigiItem.clear;
begin
	if iExprR <> nil    then iExprR.Destroy;
	inherited Clear;
end;

{---( TIdentDigiItem )----------------------------------------------------------}


procedure TIdentDIgiItem.PreCreate(ParCre : TNDCreator);
begin
end;

function TIdentDigiItem.CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;
var
	vlNode : TNodeIdent ;
begin
	PreCreate(ParCre);
	vlNode := nil;
	if(iItem <> nil) then begin
		vlNode := iItem.CreateExecuteNode(ParCre,iOwner);
		SetNodePos(vlNode);
	end;
	exit(vlNode);
end;


function TIdentDIgiItem.CreateDotWriteNode(ParCre : TNDCreator;ParLeft : TFormulaNode;ParFrom : TDigiItem):TFormulaNode;
var
	vlNode : TFormulaNode;
	vlFailed : TFailedNode;
begin                    {TODO: SetPos wrong position is set after loadnode}
	PreCreate(ParCre);
	vlNode := nil;
	if(iItem <> nil) then begin
		if (ParLeft <> nil) and  (ParFrom <> nil) then begin
			vlNode := TFormulaNode(iItem.CreateWriteDotNode(ParCre,ParLeft,ParFrom.CreateReadNode(ParCre),iOwner));
		end;
	end else begin
		vlFailed := TFailedNode.Create;
		vlFailed.AddNode(ParLeft);
		vlNode := vlFailed;
	end;
	SetNodePos(vlNode);
	exit(vlNode);
end;

function TIdentDigiItem.CreateWriteNode(ParCre : TNDCreator;ParFrom : TDigiItem):TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	PreCreate(ParCre);
	vlNode := nil;
	if(iItem <> nil) then begin
		if ParFrom <> nil then begin
			vlNode := TFormulaNode(iItem.CreateWriteNode(ParCre,iOwner,ParFrom.CreateReadNode(ParCre)));
			SetNodePos(vlNode);
		end;
	end;
	exit(vlNode);
end;


function TIdentDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNode;
var
	vlNode : TFormulaNode ;
begin
	PreCreate(ParCre);
	vlNode := nil;
	if(iItem <> nil) then begin
		vlNode := iItem.CreateReadNode(ParCre,iOwner);
		SetNodePos(vlNode);
	end;
	exit(vlNode);
end;

constructor TIdentDigiItem.Create(ParItem :TFormulaDefinition;ParOwner : TDefinition);
begin
	inherited Create;
	iItem := ParItem;
	iOwner := ParOwner;
end;


{---( TNamendIdentDigiItem )---------------------------------------------------}

{TODO Can better (PreCreate and DetermenItem)}
procedure TNamendIdentDigiItem.Commonsetup;
begin
	iIsDetermend := false;
	inherited Commonsetup;
end;

procedure TNamendIdentDigiItem.PreCreate(ParCre : TNDCreator);
begin
	if not iIsDetermend then DetermenItem(ParCre,nil);
end;


procedure TNamendIdentDigiItem.DetermenItem(ParCre :TNDCreator;ParLocal : TFormulaNode);
var
	vlOwner : TDefinition;
	vlItem  : TDefinition;
	vlType  : TType;
begin

	vlType := nil;
	if ParLocal <> nil then begin
		 ParLocal.Proces(ParCre);
		 vlType := ParLocal.GetType;
	end;
	if vlType <> nil then begin
		vlType.GetPtrByName(iName,[],vlOwner,vlItem);
		if vlItem = nil then ParCre.ErrorText(Err_Not_A_Member,iName);
	end else begin
		ParCre.GetIdentBYName(iName,vlOwner,vlItem);
		if vlItem = nil then ParCre.ErrorText(Err_Unkown_ident,iName);
	end;
	iIsDetermend := true;
	iItem := TFormulaDefinition(vlItem);
	iOwner := vlOwner;
end;


constructor TNamendIdentDigiItem.create(const ParName : ansistring);
begin
	inherited Create(nil,nil);
	iName := ParName;
end;

{---( TNumberDIgiItem )--------------------------------------------------------}

constructor TNumberDigiItem.Create(const ParNumber : TNumber);
begin
	inherited Create;
	iNumber := ParNumber;
end;

function TNumberDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNode;
var
	vlNode :TFormulaNode;
begin
	vlNode := TFormulaNode(ParCre.CreateIntNode(iNumber));
	SetNodePos(vlNode);
	exit(vlNode);
end;


{---( TSHortNotationDigiItem )-------------------------------------------------}

procedure TShortNotationDigiItem.ProcessNode(ParCre :TNDCreator;ParNode : TFormulaNode);
begin
	if (ParNode <> nil) and (iItem <> nil) then begin
		TCallNode(ParNode).SetRoutineName(iItem.fText);
		TCallNode(ParNode).SetRoutineItem(ParCre,TRoutine(iItem),iOwner);
	end;
end;



{---( TNodeDigiItem )------------------------------------------------------------}

function TNodeDigiItem.Can(ParCan : TCan_Types) : boolean;
begin
	if iNode <> nil then begin
		SetNodePos(iNode);
		exit(iNode.Can(ParCan));
	end else begin
		exit(false);
	end;
end;


function TNodeDigiItem.GetType : TType;
begin
	if iNode <> nil then begin
		exit(iNode.GetType);
	end else begin
		exit(nil);
	end;
end;

function TNodeDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNode;
begin
	iIsUsed := true;
	exit(iNode);
end;

constructor TNodeDigiItem.Create(ParNode : TFormulaNode);
begin
	inherited Create;
	iNode := ParNode;
end;

procedure TNodeDigiItem.commonsetup;
begin
	inherited COmmonsetup;
	iIsUsed :=false;
end;

procedure TNodeDigiItem.Clear;
begin
	inherited Clear;
	if (iNode <> nil) and (not iIsUsed) then iNode.Destroy;
end;


{---( TDigiItem )-------------------------------------------------------------}

procedure TDigiItem.Commonsetup;
begin
	inherited Commonsetup;
	iCol  := 0;
	iLine := 0;
	iPos  := 0;
end;

function TDigiItem.CreateObjectPointerOfNode(ParCre : TNDCreator) : TFormulaNode;
var
	vlNode : TFormulaNode;
	vlExpr : TFormulaNode;
begin
	vlNode := CreateReadNode(ParCre); {TODO : CreateValuePointer of(hernoem classe)}
	vlExpr := nil;
	if vlNode <> nil then begin

		vlExpr := vlNode.CreateObjectPointerOfNode(ParCre);
		if(vlExpr = nil) then begin
			vlNode.Destroy;
		end else begin
			SetNodePos(vlExpr);
		end;
	end;
	exit(vlExpr);
end;

function TDigiItem.CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;
begin
	exit(CreateReadNode(ParCre));
end;

function TDigiItem.CreateDotWriteNode(ParCre : TNDCreator;ParLeft : TFormulaNode;ParFrom : TDigiItem):TFormulaNode;
begin
	fatal(fat_abstract_routine,['class=',classname]);
	exit(nil);
end;


function TDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNode;
begin
	fatal(fat_abstract_routine,['class=',classname]);
	exit(nil);
end;

procedure TDigIItem.SetNodePos(ParNode : TNodeIdent);
begin
	if ParNode <> nil then  ParNode.SetPos(fLine,fCol,fPos);
end;

function TDigiItem.CreateWriteNode(ParCre : TNDCreator;ParFrom : TDigiItem) : TFormulaNode;
{TODO replace by abstract?}
var
	vlNodeL : TFormulaNode;
	vlNodeR : TFormulaNode;
	vlNodeU : TFormulaNode;
begin
	if ParFrom = nil then exit(nil);
	vlNodeL := CreateReadNode(ParCre);
	if vlNodeL = nil then exit(nil);
	vlNodeR := ParFrom.CreateReadNode(ParCre);
	if vlNodeR = nil then begin
		vlNodeL.destroy;
		exit(nil);
	end;
	vlNodeU := ParCre.MakeLoadNode(vlNodeR,vlNodeL);
	SetNodePos(vlNodeU);
	exit(vlNodeU);
end;




{---( THookDigiItem )--------------------------------------------------------------}



constructor THookDigiItem.Create(ParNode : TFormulaNode;const ParName : ansistring);
begin
	inherited Create(ParNode);
	iName := ParName;
end;


function THookDigiItem.HasName : boolean;
begin
	exit(length(iName) <> 0);
end;

{---( THookDigiList )-------------------------------------------------------------}

function THookDigiList.IsSameParameters(ParPar : TProcParList;ParExact : boolean):boolean;
var
	vlCurrent : THookDigiItem;
	vlCnt     : cardinal;
	vlName    : ansistring;
	vlParam   : TParameterVar;
	vlOwner   : TDefinition;

begin
	vlCnt := 0;
	vlCurrent := THookDigiItem(fStart);
	vlParam := nil;
	while (vlCurrent <> nil) do begin

		if vlCurrent.HasName then begin
			vlName := vlCurrent.fName;
			ParPar.GetPtrByName(vlname,vlOwner,vlParam);
			if (vlParam = nil) or (not(vlParam is TParameterVar)) then exit(false);
		end  else begin
			vlParam := ParPar.GetNextNormalParameter(vlParam);			
			if(vlParam = nil) then exit(false);
		end;
		if  not(vlParam.IsCompWithParamExpr(ParExact,vlCurrent.fNode)) then exit(false);

		vlCurrent := THookDigiItem(vlCurrent.fNxt);
		inc(vlcnt);

	end;
	exit(ParPar.GetParamByNum(vlCnt+1)  = nil);
end;


procedure THookDigiList.AddItem(ParNode : TFormulaNode;const ParName : ansistring);
var
	vlItem : THookDigiItem;
begin
	vlItem := THookDigiItem.Create(ParNode,ParName);
	insertAtTop(vlItem);
end;

{----( TIdentHookDigiItem )---------------------------------------------------------------}

procedure TIdentHookDigiItem.SetShort(ParShort : TShortNotationDigiItem);
begin
	if iShort <> nil then iShort.Destroy;
	iShort := ParShort;
end;


function TIdentHookDigiItem.IsSameParameters(ParPar : TProcParList;ParExact : boolean):boolean;
begin
	exit(iList.IsSameParameters(ParPar,parExact));
end;


function TIdentHookDigiItem.CreateReadNode(ParCre : TNDCreator) : TFormulaNode;
var
	vlIdent	  : TFormulaNode;
begin
	if(iItem = nil) then exit(nil);
	vlIdent := iItem.CreateReadNode(ParCre);

	if vlIdent = nil then exit(nil);
	exit(ProcessNode(ParCre,vlIdent));
end;


function TIdentHookDigiItem.CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;
var
	vlNode : TNodeIdent;
begin
	if(iItem = nil) then exit(nil);
	vlNode := iItem.CreateExecuteNode(ParCre);
	if vlNode = nil then exit(nil);
	exit(ProcessNode(ParCre,TFormulaNode(vlNode)));
end;

function  TIdentHookDigiItem.CreateDotWriteNode(ParCre : TNDCreator;ParLeft : TFormulaNode;ParFrom : TDigiItem):TFormulaNode;
var
	vlNode : TFormulaNode;
	vlItem  : TFormulaNode;
begin
	if iItem = nil then exit(nil);
	vlNode := iItem.CreateDotWriteNode(ParCre,ParLeft,ParFrom);
	if vlNode = nil then exit(nil);
	SetNodePos(vlNode);
	vlItem := vlNode;
	ProcessNode(ParCre,vlItem);
	exit(vlNode);
end;


function TIdentHookDigiItem.CreateWriteNode(ParCre : TNDCreator;ParValue : TDigiItem) : TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	if iItem = nil then exit(nil);
	vlNode := iItem.CreateWriteNode(ParCre,ParValue);
	if vlNode = nil then exit(nil);
	SetNodePos(vlNode);
	ProcessNode(ParCre,vlNode);
	exit(vlNode);
end;

function TIdentHookDigiItem.ProcessNode(ParCre : TNDCreator;ParNode : TformulaNode) : TFormulaNode;
var
	vlByName     : boolean;
	vlParCnt     : cardinal;
	vlCurrent    : THookDigiItem;
	vlName       : ansistring;
	vlNode       : TFormulaNode;
	vlCall       : TCallNode;
	vlDestroy    : TDefinition;
	vlIsCallNode : boolean;
	vlCode       : TRoutine;
	vlOwner      : TDefinition;
	vlType       : TType;
	vlOwner2     : TDefinition;
	vlOrgRoutine : TRoutine;
	vlOrgOwner   : TDefinition;
	vlLevel      : cardinal;
	vlType2       : TType;
begin
	if parNode = nil then exit(nil);
	vlCurrent := THookDigiItem(iList.FStart);
	SetNodePos(ParNode);
	vlByName := false;
	vlIsCallNode := (ParNode is TCallNode);
	if not(vlIsCallNode) and (vlCurrent <> nil) then ParCre.AddNodeError(ParNode,Err_Symbol_Not_Expected,'(');

	if vlCurrent <> nil then vlByName := vlCurrent.HasName;
	vlParCnt := 0;
	while (vlCurrent <> nil) do begin
		inc(vlParCnt);
		vlNode := vlCurrent.CreateReadNode(ParCre);
		if vlNode <> nil then begin
			if not vlIsCallNode then begin
				vlNode.Destroy;
			end else if vlByName then begin
				if not(vlCurrent.HasName) then ParCre.AddNodeError(vlNode,Err_Must_Pass_By_name,'Parameter '+IntToStr(vlParCnt));
				vlName := vlCurrent.fName;
				TCallNode(ParNode).AddNodeAndName(vlNode,vlName);
			end else begin
 				if vlCurrent.HasName  then ParCre.AddNodeError(vlNode,Err_Must_Not_Pass_By_Name,'Parameter '+IntToStr(vlParCnt));
				TCallNode(ParNode).AddNode(vlNode);
			end;
		end;
		vlCurrent := THookDigiItem(vlCurrent.fNxt);
	end;
	if(iInheritLevel > 0) and not(vlIsCallNode) then begin
		ParCre.AddNodeError(vlNode,Err_Routine_Expected,'');
	end else if vlIsCallNode then begin
		if(iInheritLevel = 0) then begin
			if(TCallNode(ParNode).fRoutineItem = nil) then begin
				TCallNode(ParNode).GetRoutineNameStr(vlName);
				vlType2 := nil;
				if(iRecordNode <> nil) then vlType2 := iRecordNode.GetType;
				if(vlType2 <> nil) then begin
					vlType2.GetPtrByObject(vlName,ParNode,[],vlOrgOwner,TDefinition(vlOrgRoutine));
				end else begin
					ParCre.GetPtrByObject(vlName,ParNode,vlOrgOwner,TDefinition(vlOrgRoutine));			
				end;								
				TCallNode(ParNode).SetRoutineItem(ParCre,vlOrgRoutine,vlOrgOwner);
			end;
			if iShort <> nil then iShort.ProcessNode(ParCre,ParNode);
			{TODO IsDistructor?=>TCallNode.Afterall os}
			if (TCallNode(ParNode).fRoutineItem  <> nil) and (TCallNode(ParNode).fRoutineItem is TDestructor) then begin
				vlDestroy := ParCre.GetDefaultDestroy;
				vlCall := TCallNode(vlDestroy.CreateExecuteNode(ParCre,nil));
				vlCall.AddNode(ParNode);
				ParNode := vlCall;
			end;
		end else begin
			TCallNode(ParNode).GetRoutineNameStr(vlName);
			writeln('>>>',vlName);
			ParCre.GetPtrByObject(vlName,ParNode,vlOrgOwner,TDefinition(vlOrgRoutine));
			writeln(cardinal(vlOrgRoutine));
			if not(vlOrgRoutine.CanUseInherited)  then ParCre.ErrorText(Err_Cant_Inh_Non_virt_ext_Rtn,vlName);
			vlOwner2 := vlOrgOwner;
			if vlOrgRoutine <> nil then begin
				vlLevel := iInheritLevel;
				while (vlLevel >0) and (vlOrgOwner <> nil) do begin
					vlOrgOwner := vlOrgOwner.GetParent;
					dec(vlLevel);
				end;
				if (vlOrgOwner = nil) then begin
					ParCre.SemError(Err_Has_No_parent);
				end else  begin
					vlOrgOwner.GetPtrByObject(vlName,ParNode,[SO_Local],vlOwner,TDefinition(vlCode));
					if vlCode = nil then begin
						ParCre.ErrorText(Err_unkown_ident,vlName);
					end else begin
						if vlCOde.HasAbstracts  then  ParCre.ErrorText(Err_Abstract_Routine,vlName);
						vlType := ParCre.GetCheckDefaultType(dt_pointer,size_dontcare,false,'pointer');
						TCallNode(ParNode).SetRoutineItem(ParCre,vlCode,vlOwner2);
						TCallNode(ParNode).SetCallAddress(ParCre,TLabelNode.Create(vlCode,vlType));
					end;
				end;
			end;
		end ;
	end;
	exit(ParNode);
end;

procedure TIdentHookDigiITem.Commonsetup;
begin
	inherited Commonsetup;
	iList := THookDigiList.Create;
	iShort := nil;
	iLocal := nil;
	iInheritLevel := 0;
	iRecordNode   := nil;
end;

procedure TIdentHookDigiItem.Clear;
begin
	inherited Clear;
	iList.Destroy;
	if iShort <> nil then iShort.Destroy;
end;


{---( TSUbItemDigiItem )------------------------------------------------}


procedure   TSubItemDigiItem.Clear;
begin
	inherited Clear;
	if iItem <> nil then iItem.Destroy;
end;

constructor TSubItemDigiItem.Create(ParItem : TDigiItem);
begin
	inherited Create;
	iItem := ParItem;
end;


{---( TDotOperDigiitem )-----------------------------------------------------}

function TDotOperDigiItem.GetFieldidentItem : TDefinition;
begin
	if (iField <> nil) then begin
		exit(iFieldIdent.fItem);
	end else begin
		exit(nil);
	end;
end;



function  TDotOperDigiItem.CanRecord(ParCan :TCan_Types):boolean;
begin
	if iRecordNode <> nil then begin
		exit(iRecordNode.Can(ParCan));
	end;
	exit(false);
end;


procedure TDotOperDigiItem.HandleRFI(ParCre : TNDCreator);
var
	vlNode :TFormulaNode;
begin
	if(iField = nil) then exit;
	vlNode := iItem.CreateReadNode(ParCre);
	if(vlNode = nil) then exit;
	SetNodePos(vlNode);
	if not(vlNode.Can([Can_Dot])) then ParCre.AddNodeError(vlNode,ERR_Has_No_Members,'');
	iFieldIdent.DetermenItem(ParCre,vlNode);
	iRecordNode := vLNode;
	iField.fLocal := vlNode.GetType;

	if(iField <> nil) then begin
		if(iField is TIdentHookDigiItem) then TIdentHookDigiItem(iField).fRecordNode := vlNode;
	end;
end;

procedure TDotOperDigiItem.Clear;
begin
	inherited Clear;
	if iField <> nil then iField.Destroy;
end;

constructor TDotOperDigiItem.Create(ParItem :TDigiItem;ParField  : TIdentHookDigiItem;ParFieldIdent : TNamendIdentDigiItem);
begin
	inherited Create(ParItem);
	iField := ParField;
	iFieldIdent := ParFieldIdent;
end;

procedure TDotOperDigiItem.Commonsetup;
begin
	inherited Commonsetup;
	iRecordNode := nil;
end;


function  TDotOperDigiItem.GetRecordType : TType;
begin
	if iRecordNode <> nil then begin
		exit(iRecordNode.GetType);
	end;
	exit(nil);
end;



function TDotOperDigiItem.CreateWriteNode(ParCre : TNDCreator;ParDigi : TDigiItem) :TFormulaNode;
var
	vlField : TFormulaNode;
begin
	if (ParDigi = nil) or (iItem = nil)  then begin
		if iRecordNode <> nil then begin
			iRecordNode.Destroy;
			iRecordNode := nil;
		end;
		exit(nil);
	end;
	if iRecordNode = nil then HandleRfi(ParCre);
	if(iRecordNode = nil) then exit(nil);

	vlField := iField.CreateDotWriteNode(ParCre,iRecordNode,ParDigi);
	SetNodePos(vlField);
	exit(vlField);
end;


function TDotOperDigiItem.CreateExecuteNode(ParCre : TNDCreator) : TNodeIdent;
var
	vlNode : TFOrmulaNode;
begin
	if(iItem = nil) then exit(nil);
	if iRecordNode = nil then HandleRfi(ParCre);
	vlNode :=TFormulaNode(iField.CreateExecuteNode(ParCre));
	exit(ProcessNode(ParCre,vlNode));
end;


function TDotOperDigiItem.CreateReadNode(ParCre :TNDCreator) : TFormulaNode;
var
	vlNode : TFormulaNode;
begin
	if(iItem = nil) then exit(nil);
	if iRecordNode = nil then HandleRfi(ParCre);
	vlNode := iField.CreateReadNode(ParCre);
	exit(ProcessNode(ParCre,vlNode));
end;

function TDotOperDigiItem.ProcessNode(ParCre :TNDCreator;ParNode : TFormulaNode) : TFormulaNode;
begin
	if ParNode = nil then begin
		ParNode := TErrorFormulaNode.Create;
		SetNodePos(ParNode);
	end;
	if(iRecordNode = nil) then begin
		ParNode.Destroy;
		exit(nil);
	end;
	ParNode.fRecord := iRecordNode;
	exit(ParNode);
end;


end.
