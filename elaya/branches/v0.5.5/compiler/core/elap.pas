UNIT ELAP;
{ =========================================}
{This file is generated, Please don''t edit}
{ =========================================}



Interface

Uses dynset,cmp_base,confval,cmp_cons,error,module,linklist,types,stdobj,asminfo,
     vars,display,elacons,formbase,macobj,cblkbase,
     compbase,procs,elaTypes,node,extern,ddefinit,doperfun,
     varbase,params,elacfg,progutil,classes,
     nif,nlinenum,naddsub,execobj,exprdigi,
     cmp_type,largenum,blknodes,stmnodes, ELAS,ELA_cons,ELA_user;

Type
TELA_Parser=class(TELA_scanner)
      protected
      procedure   Commonsetup;override;
      Public
      destructor  destroy;override;
      procedure   parse;override;
      procedure   Pragma;override;
      procedure   GetErrorText(ParNo:longint;var ParErr:string);override;
      Procedure _RIdentMention ( var ParDigi : TIdentHookDigiItem);
      Procedure _RShortProcDef ( ParRoutine : TRoutine);
      Procedure _RParameterList ( ParList : THookDigiList);
      Procedure _RIdentObject ( ParLocal :TRoutine;var ParDef : TDefinition;var ParDigi : TIdentDigiItem;var ParMention : TMN_Type);
      Procedure _RInherited ( var ParDigi : TDigiItem);
      Procedure _ROwner ( var ParLocal : TDefinition);
      Procedure _RShortDRoutine ( ParRoutine : TRoutineCollection;ParItem :TIdentHookDigiItem);
      Procedure _RParameters ( ParOut : TIdentHookDigiItem);
      Procedure _RFact ( var ParDigi : TDigiItem);
      Procedure _RComp ( var ParDigi : TDigiItem);
      Procedure _RSimpelOper ( var ParDigi :TDigiItem);
      Procedure _RTypeCast ( var ParDigi : TDigiItem);
      Procedure _RTerm ( var ParDigi : TDigiItem);
      Procedure _RShrShl ( var ParDigi : TDigiItem);
      Procedure _RAdd ( var ParDigi : TDigiItem);
      Procedure _RLogicAnd ( var ParDigi : TDigiItem);
      Procedure _RLogic ( var ParDigi :TDigiItem);
      Procedure _RCompare ( var ParExp:TDigiItem);
      Procedure _RIdentOper ( var ParExp : TDigiItem);
      Procedure _RCodes ( ParNode:TNodeIdent);
      Procedure _RLeave ( ParNode : TNodeIdent);
      Procedure _RExprDigi ( var ParExpr : TDigiItem);
      Procedure _RLoad ( var Parexp:TFormulaNode);
      Procedure _RRepeat ( var ParNode:TNodeIdent);
      Procedure _RIf ( var ParNode:TNodeIdent);
      Procedure _RFor ( var ParNode :TNodeIdent);
      Procedure _RExpr ( var ParExpr : TFormulaNode);
      Procedure _RCount ( var ParNode:TNodeIdent);
      Procedure _RCode ( ParNode:TNodeIdent);
      Procedure _RWhile ( var ParNode:TNodeIdent);
      Procedure _RExit ( var ParNode:TNodeIdent);
      Procedure _RFormula ( var ParExp:TFormulaNode);
      Procedure _RIncDec ( var ParNode : TNodeIdent);
      Procedure _RParam ( var ParExpr : TFormulaNode;var ParName : string);
      Procedure _RWrite ( ParNode:TNodeIdent);
      Procedure _RContinue ( var ParNode : TNodeIdent);
      Procedure _RBreak ( var ParNode : TNodeIdent);
      Procedure _RRoutineHeader ( var ParRoutine:TRoutine;ParForward:boolean;var ParLevel : cardinal);
      Procedure _RParameterMapping ( var ParRoutine :TRoutine);
      Procedure _RParameterMappingItem ( ParRoutine :TRoutine);
      Procedure _RAsmBlock ( var ParNode:TNodeIdent);
      Procedure _RFunctionHead ( var ParRoutine:TRoutine;var ParHasses : cardinal);
      Procedure _RConstructorHead ( var ParRoutine : TRoutine;var ParHasses : cardinal);
      Procedure _ROperatorHead ( var ParRoutine:TRoutine);
      Procedure _ROperParDef ( ParRoutine:TRoutine);
      Procedure _RProcedureHead ( var ParRoutine:TRoutine;var ParHasses : cardinal);
      Procedure _RRoutineName ( var ParName : string;var ParAccess : TDefAccess;var ParHasses:cardinal);
      Procedure _RRoutineDotName ( var ParName : string;var ParHasses : cardinal);
      Procedure _RParamVarDef ( vlRoutine:TRoutine;var vlVirCheck:boolean);
      Procedure _RProperty;
      Procedure _RClassType ( const ParName : string;var ParType : TType);
      Procedure _RTypeDecl;
      Procedure _RTypeAs ( var ParType : TType);
      Procedure _RAnonymousType ( var ParTYpe : TType);
      Procedure _RPtrTypeDecl ( var ParType:TType;ParCanForward : boolean);
      Procedure _RCharDecl ( var ParType:TType);
      Procedure _RVoidTypeDecl ( var Partype:TType);
      Procedure _RParamDef ( ParRoutine:TRoutine);
      Procedure _RRoutineTypeDecl ( var ParType:TType);
      Procedure _ROrdDecl ( var ParType:TType);
      Procedure _RStringTypeDecl ( var ParType:TStringType);
      Procedure _RAsciizDecl ( var ParType:TType);
      Procedure _RRecord ( var PArType:TType);
      Procedure _RUnion ( var ParType :TType);
      Procedure _RBooleanType ( var ParType : TType);
      Procedure _REnum ( var ParType:TType);
      Procedure _REnumident ( var ParVal:TNumber);
      Procedure _RRoutineType ( var ParType : TType);
      Procedure _RArrayTypeDef ( var ParArray:TType);
      Procedure _RArrayRangeDef ( var ParLo,ParHi:TArrayIndex);
      Procedure _RNum_Or_Const_2 ( var ParVal:TValue);
      Procedure _RConstantDecl;
      Procedure _RConstantStringIdent ( var ParValue : TString);
      Procedure _RConstantStringValue ( var ParValue : TString);
      Procedure _RConstantStringFact ( var ParString : TString);
      Procedure _RConstantStringAdd ( var ParString : TString);
      Procedure _RConstantStringExpr ( var ParString : TString);
      Procedure _RH_Type ( var ParType:TType);
      Procedure _RNum_Or_Const ( var ParVal:TValue;var ParInvalid : boolean);
      Procedure _RDirectFact ( var ParVal:TValue;var ParInValid:boolean);
      Procedure _RDirectNeg ( var ParVal : TValue;var ParInvalid : boolean);
      Procedure _RDirectMul ( var ParVal:TValue;var ParInValid:boolean);
      Procedure _RDirectAdd ( var ParVal:TValue;var ParInValid:boolean);
      Procedure _RDirectLogic ( var ParVal : TValue;var ParInvalid:boolean);
      Procedure _RCharConst ( var ParValue : TValue);
      Procedure _RDirectExpr ( var ParVal:TValue);
      Procedure _RDirectNumber ( var ParNum:TNumber);
      Procedure _IXor;
      Procedure _IWith;
      Procedure _IWhile;
      Procedure _IVoidType;
      Procedure _IWriteln;
      Procedure _IWrite;
      Procedure _IWhere;
      Procedure _IVirtual;
      Procedure _IUnion;
      Procedure _IUntil;
      Procedure _IType;
      Procedure _IThen;
      Procedure _ITo;
      Procedure _IStep;
      Procedure _IString;
      Procedure _ISizeOf;
      Procedure _ISigned;
      Procedure _ISize;
      Procedure _IShl;
      Procedure _IShr;
      Procedure _IRoot;
      Procedure _IRepeat;
      Procedure _IRecord;
      Procedure _IRead;
      Procedure _IPtr;
      Procedure _IPrivate;
      Procedure _IProtected;
      Procedure _IProperty;
      Procedure _IProcedure;
      Procedure _IOwner;
      Procedure _IOverride;
      Procedure _IOverload;
      Procedure _IOr;
      Procedure _IOperator;
      Procedure _IOf;
      Procedure _IObject;
      Procedure _INot;
      Procedure _INumber;
      Procedure _INil;
      Procedure _IName;
      Procedure _IMod;
      Procedure _IMetaType;
      Procedure _IMain;
      Procedure _IIsolate;
      Procedure _IInherited;
      Procedure _IInherit;
      Procedure _IInc;
      Procedure _IIf;
      Procedure _IHas;
      Procedure _IFunction;
      Procedure _IFrom;
      Procedure _IFor;
      Procedure _IFinal;
      Procedure _ILeave;
      Procedure _IExternal;
      Procedure _IExit;
      Procedure _IExact;
      Procedure _IEnum;
      Procedure _IElse;
      Procedure _IDownTo;
      Procedure _IDo;
      Procedure _IDiv;
      Procedure _IDestructor;
      Procedure _IDefault;
      Procedure _IDec;
      Procedure _ICount;
      Procedure _IContinue;
      Procedure _IConstructor;
      Procedure _IConst;
      Procedure _IClass;
      Procedure _ICharType;
      Procedure _IBreak;
      Procedure _IBetween;
      Procedure _IBooleanType;
      Procedure _IBegin;
      Procedure _IAt;
      Procedure _IAsciiz;
      Procedure _IAsm;
      Procedure _IAs;
      Procedure _IArray;
      Procedure _IAnd;
      Procedure _IAbstract;
      Procedure _RBlockOfCode ( ParNode : TNodeIdent);
      Procedure _RRoutine;
      Procedure _IEnd;
      Procedure _RRoutineForward;
      Procedure _RConstant;
      Procedure _RExternal;
      Procedure _RTypeBlock;
      Procedure _ICDecl;
      Procedure _IPublic;
      Procedure _ELA;
      Procedure _IProgram;
      Procedure _IUnit;
      Procedure _RMod_Type;
      Procedure _IVar;
      Procedure _RVarBlock;
      Procedure _RUsableType ( var ParType : TType);
      Procedure _RVarDecl;
      Procedure _IUses;
      Procedure _RUseBlock;
      Procedure _RUsedUnit;
      Procedure _RDirectCardinal ( var ParNum : cardinal);
      Procedure _IAlign;
      Procedure _RAlign;
      Procedure _RDefIdentObj ( var ParDef : TDefinition;ParAccCheck : boolean);
      Procedure _RIdentObj ( var ParDef:TDefinition);
      Procedure _RNumber ( var ParNum : TNumber;var ParValid : boolean);
      Procedure _RDec_Number ( var ParNum:TNumber; var ParValid:boolean);
      Procedure _RBin_Number ( var ParNum:TNumber;var ParValid : boolean);
      Procedure _RHex_Number ( var ParNum:TNumber;var ParValid : boolean);
      Procedure _RText ( var ParString : string);
      Procedure _RString ( var ParString:String);
      Procedure _RIdent ( var ParIdent:string);
      Procedure _RConfigVar ( var ParString : string);
end;




IMPLEMENTATION

(*
	Elaya, the compiler for the elaya language
    Copyright (C) 1999-2002 J.v.Iddekinge.
    Email : iddekingej@lycos.com
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
*)


procedure TELA_Parser.pragma;
begin
      
      End;
      
      Procedure TELA_Parser._RIdentMention ( var ParDigi : TIdentHookDigiItem);
       
      var
               vlDef     : TDefinition;
               vlMention : TMN_Type;
               vlLocal   : TDefinition;
      		vlDigi    : TIdentDigiItem;
      
      begin
              vlLocal := nil; ;
            if (GetSym = 66) then begin
                  _ROwner( vlLocal);
            end;
            _RIdentObject( TRoutine(vlLocal),vlDef,vlDigi,vlMention);
             
            ParDigi := TIdentHookDigiItem.Create(vlDigi);
            ParDigi.fLocal := vlLocal;
             SetDigiPos(ParDigi);
            ;
            if (GetSym = 101) then begin
                  _RParameters( ParDigi);
            end;
            if (GetSym = 94) then begin
                  _RShortDRoutine( TRoutineCollection(vlDef),ParDigi);
            end;
      end;
      
      Procedure TELA_Parser._RShortProcDef ( ParRoutine : TRoutine);
       
      var
      vlRoutine : TRoutine;
      vlNode    : TFormulaNode;
      vlError   : boolean;
      vlPrn     : TRoutineNode;
      vlName    : string;
      vlLineInfo : TNodeident;
      
      begin
            _RIdent( vlName);
             
            vlNode  := nil;
            vlPrn   := nil;
            CreateShortSubCB(ParRoutine,vlName,vlRoutine,vlError);
            ;
            if (GetSym = 101) then begin
                  _RParamDef( vlRoutine);
            end;
             
            if not vlError then vlPrn := ProcessShortSubCb(vlRoutine);
            ;
            Expect(10);
            if (GetSym = 19) then begin
                  _RBlockOfCode( vlPrn);
            end
             else if vgDynSet[1].isSet(GetSym) then begin
                  _RFormula( vlNode);
                   
                  if not vlError then begin
                  CreateFormulaShortSubCB(vlRoutine,vlNode);
                  end else begin
                  if vlNode <> nil then vlNode.Destroy;
                  end;
                  ;
            end
            else begin
                  SynError(120);
            end;
            ;Expect(8);
             
            if vlRoutine <> nil then begin
            vlRoutine.SetIsDefined;
            EndIdent;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RParameterList ( ParList : THookDigiList);
       
      var vlExpr : TFormulaNode;
          vlName : string;
      
      begin
            Expect(101);
            _RParam( vlExpr,vlName);
              ParList.AddItem(vlExpr,vlName); ;
            WHILE (GetSym = 9) do begin
                  Get;
                  _RParam( vlExpr,vlName);
                    ParList.AddItem(vlExpr,vlName); ;
            end;
            Expect(102);
      end;
      
      Procedure TELA_Parser._RIdentObject ( ParLocal :TRoutine;var ParDef : TDefinition;var ParDigi : TIdentDigiItem;var ParMention : TMN_Type);
       
      var
      	vlIdent : string;
      
      begin
            _RIdent( vlident);
             
            	DoIdentObject(ParLocal,ParDef,ParDigi,ParMention,vlIdent);
            ;
      end;
      
      Procedure TELA_Parser._RInherited ( var ParDigi : TDigiItem);
       
      var
       vlDef     : TDefinition;
       vlMention : TMN_Type;
      vlLevel   : cardinal;
      vlOut     : TIdentHookDigiItem;
      vlDigi    : TIdentDigiItem;
      
      begin
             
            vlLevel :=  1;
             vlOut   := nil;
            ;
            _IInherited;
            WHILE (GetSym = 51) do begin
                  _IInherited;
                    inc(vlLevel); ;
            end;
            if (GetSym = 61) then begin
                  _IOf;
                  _IMain;
                    DoInheritedOfMain(vlLevel,vlOut); ;
            end
             else if (GetSym = 1) then begin
                  _RIdentObject( nil,vlDef,vlDigi,vlMention);
                   
                  	vlOut := TIdentHookDigiItem.Create(vlDigi);
                      SetDigiPos(vlOut);
                  	vlOut.fInheritLevel := vlLevel;
                  
                  ;
                  if (GetSym = 101) then begin
                        _RParameters( vlOut);
                  end;
            end
            else begin
                  SynError(121);
            end;
            ; 
            ParDigi := vlOut;
            ;
      end;
      
      Procedure TELA_Parser._ROwner ( var ParLocal : TDefinition);
       
      var
      	vlNum     : cardinal;
      
      begin
              vlNum := 1;;
            _IOwner;
            WHILE (GetSym = 66) do begin
                  _IOwner;
                    inc(vlNum) ;
            end;
             
            ParLocal := fNDCreator.GetCurrentDefinitionByNum(vlNum);
             if ParLocal = nil then begin
            	SemError(Err_Has_No_Owner);
            end else begin
            	if ParLocal is TClassType then ParLocal := TClassType(ParLocal).fObject;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RShortDRoutine ( ParRoutine : TRoutineCollection;ParItem :TIdentHookDigiItem);
       
      var
      	vlRoutine : TRoutine;
           vlPrvAcc  : TDefAccess;
      	vlItem    : TShortNotationDigiItem;
      	vlContext : TDefinition;
      
      begin
             
            vlPrvAcc := fNDCreator.fCUrrentDefAccess;
            fNDCreator.fCurrentDefAccess := AF_Private;
            vlRoutine := CreateShortERtn(ParRoutine,ParItem);
            fNDCreator.fCurrentDefAccess := AF_Protected;
            ;
            _IWhere;
            WHILE vgDynSet[2].isSet(GetSym) do begin
                  if (GetSym = 1) then begin
                        _RShortProcDef( vlRoutine);
                  end
                   else begin
                        _RRoutine;
                  end
                  ;end;
            _IEnd;
             
            fNDCreator.fCurrentDefAccess := vlPrvAcc;
            ProcessShortDyRoutine(vlRoutine);
            if vlRoutine <> nil then vlContext := vlRoutine.GetRealOwner;
            vlItem := TShortNotationDigiItem.Create(vlRoutine,vlContext);
            SetDigiPos(vlItem);
            ParItem.SetShort(vlItem);
            ;
      end;
      
      Procedure TELA_Parser._RParameters ( ParOut : TIdentHookDigiItem);
      begin
            _RParameterList( ParOut.fList);
      end;
      
      Procedure TELA_Parser._RFact ( var ParDigi : TDigiItem);
       
      var
      vlNum   : TNumber;
      vlValid : boolean;
      vlPSt   : String;
      vlName  : string;
      vlExpr  : TDigiItem;
      
      begin
             
            vlValid := true;
            ParDigi := nil;
            ;
            case GetSym of
                  1, 66 : begin
                        _RIdentMention( TIdentHookDigiItem(ParDigi));
                  end;
                  51 : begin
                        _RInherited( TIdentHookDigiItem(ParDigi));
                  end;
                  3..5 : begin
                        _RNumber( vlNum,vlValid);
                         
                        	if not(LargeInRange(vlNum ,Min_Longint, Max_Cardinal)) then SemError(Err_Num_Out_Of_Range);
                        	if not vlValid then SemError(Err_int_Invalid_number);
                        	ParDigi := TNUmberDigiItem.Create(vlNum);
                        ;
                  end;
                  2, 6 : begin
                        _RText( vlPst);
                          ParDigi := TStringDigiItem.Create(vlPst);;
                  end;
                  57 : begin
                        _INil;
                          ParDigi := TNilDigiItem.Create ;
                  end;
                  59 : begin
                        _INot;
                            LexName(vlName); ;
                        Expect(101);
                        _RExprDigi( vlExpr);
                        Expect(102);
                          ParDigi := TSingleOperatorDigiItem.Create(vlExpr,vlName,TNotNode); ;
                  end;
                  82 : begin
                        _ISizeOf;
                        Expect(101);
                        _RExprDigi( vlExpr);
                        Expect(102);
                          ParDigi := TSizeOfDigiItem.Create(vlExpr);;
                  end;
                  101 : begin
                        Get;
                        _RExprDigi( ParDigi);
                        Expect(102);
                  end;
                  else begin
                        SynError(122);
                  end;
            end;
             
            SetDigiPos(ParDigi);
            ;
      end;
      
      Procedure TELA_Parser._RComp ( var ParDigi : TDigiItem);
       
      var
      vlNode2     : TFormulaNode;
      vlIdent     : String;
      vlIndex     : TArrayDigiItem;
      vlOut       : TIdentHookDigiItem;
      vlDotOper   : TDotOperDigiItem;
      vlDigi      : TDigiItem;
      
      begin
            _RFact( vlDigi);
            WHILE (GetSym in [7 , 107 , 115 , 117]) do begin
                  if (GetSym = 117) then begin
                        Get;
                         
                        vlOut := HandleDeReference(vlDigi);
                        vlDigi := vlOut;
                        ;
                        if (GetSym = 101) then begin
                              _RParameters( vlOut);
                        end;
                  end
                   else if (GetSym = 107) then begin
                        Get;
                         
                        vlIndex := TArrayDigiItem.Create(vlDigi);
                        vlDigi := vlIndex;
                        SetDigiPos(vlIndex);
                        ;
                        _RExpr( vlNode2);
                          vlIndex.AddIndexItem(vlNode2);
                        WHILE (GetSym = 9) do begin
                              Get;
                              _RExpr( vlNode2);
                                vlIndex.AddIndexItem(vlNode2);;
                        end;
                        Expect(108);
                  end
                   else if (GetSym = 7) then begin
                        Get;
                        _RIdent( vlIdent);
                         
                        		vlDotOper := HandleDotOperator(vlDigi,vlIdent);
                        		vlDigi := vlDotOper;
                        	;
                        if (GetSym = 101) then begin
                              _RParameters( vlDotOper.fField);
                        end;
                        if (GetSym = 94) then begin
                               
                              		vlDotOper.HandleRfi(fNDCreator);
                              		fNDCreator.AddCurrentDefinitionEx(vlDotOper.GetRecordType,false,true);
                              	;
                              _RShortDRoutine( TRoutineCollection(vlDotOper.GetFieldIdentItem),vlDotOper.fField);
                               
                              if vlDotOper.GetRecordType <> nil then fNDCreator.EndIdent;
                              	;
                        end;
                  end
                   else begin
                        Get;
                          EmptyString(vlIdent) ;
                        if (GetSym = 1) then begin
                              Get;
                                  LexString(vlIdent);  ;
                        end
                         else if (GetSym in [2 , 6]) then begin
                              _RText( vlIdent);
                        end
                        else begin
                              SynError(123);
                        end;
                        ; 
                        vlDigi := THashOperatorDigiItem.Create(vlDigi,TStringDIgiItem.Create(vlIdent),'#',nil);
                        ;
                  end
                  ;end;
             
            ParDigi := vlDigi;
            ;
      end;
      
      Procedure TELA_Parser._RSimpelOper ( var ParDigi :TDigiItem);
       
      var
      vlDigi : TDigiItem;
      vlPtr  : boolean;
      
      begin
             
            	vlPtr := false;
            ;
            if (GetSym = 116) then begin
                  Get;
                    vlPtr := true; ;
            end;
            _RComp( vlDigi);
             
            	if vlPtr then begin
            		vlDigi := TPointerOfDigiItem.Create(vlDigi);
            		SetDigiPos(vlDigi);
            	end;
            	ParDigi := vlDigi;
            ;
      end;
      
      Procedure TELA_Parser._RTypeCast ( var ParDigi : TDigiItem);
       
      var
      	vlDigi : TDigiItem;
      	vlDef  : TDefinition;
      
      begin
            _RSimpelOper( vlDigi);
            WHILE (GetSym = 15) do begin
                  _IAs;
                  _RDefIdentObj( vlDef,false);
                    vlDigi := TCastDigiItem.Create(vlDigi,vlDef);
                  											 SetDigiPos(vlDigi);;
            end;
              ParDigi := vlDigi; ;
      end;
      
      Procedure TELA_Parser._RTerm ( var ParDigi : TDigiItem);
       
      var
      vlOperator : TRefNodeIdent;
      vlneg      : boolean;
      vlName     : string;
      vlDigi1    : TDigiItem;
      vlDigi2    : TDigiItem;
      
      begin
             
            				vlNeg     := false;
                         vlOperator := nil;
            			;
            if (GetSym in [103 , 104]) then begin
                  if (GetSym = 103) then begin
                        Get;
                  end
                   else begin
                        Get;
                         
                        		   vlNeg := true;
                        	   	   lexName(vlName);
                        	;
                  end
                  ;end;
            _RTypeCast( vlDigi1);
             
                        	if vlNeg then begin
            						vlDigi1 := TSingleOperatorDigiItem.Create(vlDigi1,vlName,TNegNode);
            						SetDigiPos(vlDigi1);
            					end;
            			;
            WHILE (GetSym in [33 , 55 , 105]) do begin
                  if (GetSym = 105) then begin
                        Get;
                           vlOperator := TMulNode;;
                  end
                   else if (GetSym = 33) then begin
                        _IDiv;
                           vlOperator := TDivNode; ;
                  end
                   else begin
                        _IMod;
                         vlOperator := TModNode;;
                  end
                  ; 
                  				LexName(vlName);
                  				vlNeg := false;
                  			;
                  if (GetSym in [103 , 104]) then begin
                        if (GetSym = 103) then begin
                              Get;
                        end
                         else begin
                              Get;
                               vlNeg := true;;
                        end
                        ;end;
                  _RTypeCast( vlDigi2);
                   
                  				if vlNeg then begin
                  					vlDigi2 := TSingleOperatorDigiItem.create(vlDigi2,'-',TNegNode);
                  					SetDigiPos(vlDigi2);
                  				end;
                  				vlDigi1 := TDualOperatorDigiItem.create(vlDigi1,vlDigi2,vlName,vlOperator);
                  				SetDigiPos(vlDigi1);
                  			 ;
            end;
             
            				ParDigi := vlDigi1;
            			;
      end;
      
      Procedure TELA_Parser._RShrShl ( var ParDigi : TDigiItem);
       
      var
      	vlOperator : TRefNodeIdent;
      	vlDigi1 : TDigiItem;
      	vlDigi2 : TDigiItem;
      	vlName : string;
      
      begin
            _RTerm( vlDigi1);
            WHILE (GetSym in [78 , 79]) do begin
                  if (GetSym = 78) then begin
                        _IShr;
                          vlOperator := TShrNode; ;
                  end
                   else begin
                        _IShl;
                          vlOperator := TShlNode; ;
                  end
                  ;  LexName(vlName); ;
                  _RTerm( vlDigi2);
                   
                  	vlDigi1 := TDualOperatorDigiItem.Create(vlDigi1,vlDigi2,vlName,vlOperator);
                  ;
            end;
              ParDigi := vlDigi1;
      end;
      
      Procedure TELA_Parser._RAdd ( var ParDigi : TDigiItem);
       
      var
      vlOperator : TRefNodeident;
      vlName     : String;
      vlDigi1    : TDigiItem;
      vlDigi2    : TDigiItem;
      
      begin
            _RShrShl( vlDigi1);
            WHILE (GetSym in [103 , 104]) do begin
                  if (GetSym = 104) then begin
                        Get;
                         vlOperator := TSubNode;;
                  end
                   else begin
                        Get;
                         vlOperator := TAddNode;;
                  end
                  ;  lexname(vlName);;
                  _RShrShl( vlDigi2);
                   
                  	vlDigi1 := TDualOperatorDigiItem.Create(vlDigi1,vlDigi2,vlName,vlOperator);
                  	SetDigiPos(vlDigi1);
                  ;
            end;
             
             ParDigi := vlDigi1;
            ;
      end;
      
      Procedure TELA_Parser._RLogicAnd ( var ParDigi : TDigiItem);
       
      var
      vlDigi1    : TDigiItem;
       vlDigi2    : TDigiItem;
      vlName     : string;
      
      begin
            _RAdd( vlDigi1);
            WHILE (GetSym = 13) do begin
                  _IAnd;
                    LexName(vlName); ;
                  _RAdd( vlDigi2);
                   
                  vlDigi1 := TDualOperatorDigiItem.create(vlDigi1,vlDigi2,vlName,TAndNode);
                  SetDigiPos(vlDigi1);
                  ;
            end;
             
            ParDigi := vlDigi1;
            ;
      end;
      
      Procedure TELA_Parser._RLogic ( var ParDigi :TDigiItem);
       
      var
      	vlDigi1    : TDigiItem;
      	vlDigi2    : TDigiItem;
      	vlName     : string;
      	vlOperator : TRefNodeIdent;
      
      begin
            _RLogicAnd( vlDigi1);
            WHILE (GetSym in [63 , 100]) do begin
                  if (GetSym = 63) then begin
                        _IOr;
                          vlOperator := TOrNode; ;
                  end
                   else begin
                        _IXor;
                          vlOperator := TXorNode;;
                  end
                  ;  LexName(vlName); ;
                  _RLogicAnd( vlDigi2);
                   
                  vlDigi1 := TDualOperatorDigiItem.Create(vlDigi1,vlDigi2,vlName,vlOperator);
                  SetDigiPos(vlDigi1);
                  ;
            end;
              ParDigi := vlDigi1;;
      end;
      
      Procedure TELA_Parser._RCompare ( var ParExp:TDigiItem);
       
      var
      	vlDigiL : TDigiItem;
      	vlDigiR : TDigiItem;
      	vlCode  : TIdentCode;
      	vlName:String;
      
      begin
            _RLogic( vlDigiL);
            WHILE vgDynSet[3].isSet(GetSym) do begin
                  case GetSym of
                        110 : begin
                              Get;
                                vlCode := IC_Bigger;   ;
                        end;
                        111 : begin
                              Get;
                                vlCode := IC_BiggerEq; ;
                        end;
                        113 : begin
                              Get;
                                vlCode := IC_Lower;    ;
                        end;
                        112 : begin
                              Get;
                                vlcode := IC_LowerEq;  ;
                        end;
                        106 : begin
                              Get;
                                vlCode := IC_Eq;	  ;
                        end;
                         else begin
                              Get;
                                vlCode := IC_NotEq;	  ;
                        end;
                  end;
                    LexName(vlName);       ;
                  _RLogic( vlDigiR);
                   
                  				vlDigiL := TCompOperatorDigiItem.Create(vlDigiL,vlDigiR,vlName,vlCode);
                  				SetDigiPos(vlDigiL);
                  			;
            end;
             	ParExp := vlDigiL ;
      end;
      
      Procedure TELA_Parser._RIdentOper ( var ParExp : TDigiItem);
       
      var
      	vlDigiL : TDigiItem;
      	vlDigiR : TDigiItem;
      	vlName  : string;
      
      begin
            _RCompare( vlDigiL);
            if (GetSym = 1) then begin
                  _RIdent( vlName);
                  _RCompare( vlDigiR);
                   
                  	vlDigiL := TDualOperatorDigiItem.Create(vlDigiL,vlDigiR,vlName,nil);
                  	SetDigiPos(vlDigiL);
                  ;
            end;
              ParExp := vlDigiL ;
      end;
      
      Procedure TELA_Parser._RCodes ( ParNode:TNodeIdent);
       
      var
      	vlNode : TBlockNode;
      
      begin
            _IBegin;
             
            	vlNode := TBlockNode.Create;
            	AddNodeToNode(ParNode,vlNode);
            ;
            WHILE vgDynSet[4].isSet(GetSym) do begin
                  _RCode( vlNode);
                  Expect(8);
            end;
            _IEnd;
      end;
      
      Procedure TELA_Parser._RLeave ( ParNode : TNodeIdent);
      begin
            _ILeave;
              if ParNode <> nil then ParNode.AddNode(TLeaveNode.Create); ;
      end;
      
      Procedure TELA_Parser._RExprDigi ( var ParExpr : TDigiItem);
       
      var
      vlI1 : TDigiItem;
      vlI2 : TDigiItem;
      vlI3 : TDigiItem;
      vlName : string;
      
      begin
            _RIdentOper( vlI1);
              ParExpr := vlI1; ;
            if (GetSym = 21) then begin
                  _IBetween;
                   LexName(vlName);;
                  Expect(101);
                  _RIdentOper( vlI2);
                  Expect(102);
                  _IAnd;
                  Expect(101);
                  _RIdentOper( vlI3);
                  Expect(102);
                   
                  ParExpr := TBetweenOperatorDigiItem.Create(vlI1,vlI2,vlI3,vlName);
                  SetDigiPos(ParExpr);
                  ;
            end;
      end;
      
      Procedure TELA_Parser._RLoad ( var Parexp:TFormulaNode);
        var
      vlName   : string;
      vlDigiL  : TDigiItem;
      vlDigiR  : TDigiItem;
      
      begin
             
            ParExp := nil;
            ;
            _RExprDigi( vlDigiL);
            if (GetSym = 109) then begin
                  Get;
                    LexName(vlName); ;
                  _RExprDigi( vlDigiR);
                   
                  	if vlDigiL <> nil then ParExp := vlDigiL.CreateWriteNode(fNDCreator,vlDigiR);
                  	if vlDigiR <> nil then vlDigiR.Destroy;
                  ;
            end
             else if (GetSym in [8 , 36]) then begin
                   
                  if vlDigiL <> nil then ParExp :=TFormulaNode(vlDigiL.CreateExecuteNode(fNDCreator));
                  if (ParExp = nil) then ErrorText(Err_Cant_Execute,'?');
                  ;
            end
            else begin
                  SynError(124);
            end;
            ; 
            if vlDigiL <> nil then vlDigiL.Destroy;
            ;
      end;
      
      Procedure TELA_Parser._RRepeat ( var ParNode:TNodeIdent);
        var vlCond:TFormulaNode; 
      begin
            _IRepeat;
              ParNode := TRepeatNode.Create;
            	   fNDCreator.AddCurrentNode(ParNode); ;
            WHILE vgDynSet[4].isSet(GetSym) do begin
                  _RCode( ParNode);
                  Expect(8);
            end;
            _IUntil;
            _RFormula( vlCond);
             
            TRepeatNode(ParNode).SetCond(fNDCreator,vlCond);
            fNDCreator.EndNode;
            ;
      end;
      
      Procedure TELA_Parser._RIf ( var ParNode:TNodeIdent);
       
      var
      	vlCond : TFormulaNode;
      	vlThen : TThenElseNode;
      
      begin
            _IIf;
            _RFormula( vlCond);
             
            ParNode := TIfNode.Create;
            TIfNode(ParNode).SetCond(fNDCreator,vlCond);
            vlThen := TThenElseNode.Create(True);
            ParNode.AddNode(vlThen);
            ;
            _IThen;
            _RCode( vlThen);
            if (GetSym = 36) then begin
                  _IElse;
                   
                  vlThen := TThenElseNode.Create(False);
                  ParNode.AddNode(vlThen);
                  ;
                  _RCode( vlThen);
            end;
      end;
      
      Procedure TELA_Parser._RFor ( var ParNode :TNodeIdent);
       
      var
      	vlExpr : TFormulaNode;
           vlNode : TForNode;
      
      begin
              vlNode := (TForNode.Create); ;
            _IFor;
            _RFormula( vlExpr);
              vlNode.SetBegin(fNDCreator,vlExpr); ;
            _IUntil;
            _RFormula( vlExpr);
             
            vlNode.SetEnd(vlExpr);
            fNDCreator.AddCurrentNode(vlNode);
            ;
            if (GetSym = 34) then begin
                  _IDo;
                  _RCode( vlNode);
            end;
             
            ParNode := vlNode;
            fNDCreator.EndNode;
            ;
      end;
      
      Procedure TELA_Parser._RExpr ( var ParExpr : TFormulaNode);
       
      var
      	vlDigi : TDigiItem;
      
      begin
            _RExprDigi( vlDigi);
             
            ParExpr := nil;
            if (vlDigi <> Nil) then begin
            	ParExpr := vlDigi.CreateReadNode(fNDCreator);
            	vlDigi.Destroy;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RCount ( var ParNode:TNodeIdent);
       
      var
      vlN1,vln2,vlN3,vlN4:TFormulaNode;
      vlNode : TCountNode;
      vlUp   : boolean;
      vlEndCondition : TFormulaNode;
      
      begin
             
            vlN4   := nil;
            vlNode := TCountNode.Create;
            vlUp   := false;
            ;
            _ICount;
            _RFormula( vlN1);
               vlNode.SetCount(fNDCreator,vlN1); ;
            _IFrom;
            _RFormula( vlN2);
               vlNode.SetBegin(fNDCreator,vlN2); ;
            if (GetSym in [35 , 85]) then begin
                  if (GetSym = 85) then begin
                        _ITo;
                           vlUp := true; ;
                  end
                   else begin
                        _IDownTo;
                           vlUp := false; ;
                  end
                  ;   vlNode.Setup(vlUp); ;
                  _RFormula( vlN3);
                     vlNode.SetEnd(fNDCreator,vlN3); ;
            end;
            if (GetSym = 84) then begin
                  _IStep;
                  _RFormula( vlN4);
            end;
             
            if vlN4 = nil then vlN4 := TFormulaNode(fNDCreator.CreateIntNodeLOng(1));
            vlNode.SetStep(fNDCreator,vlN4);
            fNDCreator.AddCurrentNode(vlNode);
            ;
            if (GetSym = 88) then begin
                  _IUntil;
                  _RExpr( vlEndCondition);
                   
                  	vlNode.SetEndCondition(fNDCreator,vlEndCondition);
                  ;
            end;
            if (GetSym = 34) then begin
                  _IDo;
                  _RCode( vlNode);
            end;
             
            ParNode := vlNode;
            fNDCreator.EndNode;
            ;
      end;
      
      Procedure TELA_Parser._RCode ( ParNode:TNodeIdent);
       
      var
      vlNode     : TNodeIdent;
      vlLineInfo : TNodeident;
      
      begin
             
             vlNode := nil;
             if (GetConfigValues.fGenerateDebug) and (ParNode <> nil)  then begin
             	vlLineInfo := TLineNumberNode.create;
             	vlLineInfo.fLine := nextLine;
            	ParNode.AddNode(vlLineInfo);
             end;
            ;
            case GetSym of
                  1..6, 51, 57, 59, 66, 82, 101, 103..104, 116 : begin
                        _RLoad( TFormulaNode(vlNode));
                  end;
                  16 : begin
                        _RAsmBlock( vlNode);
                  end;
                  22 : begin
                        _RBreak( vlNode);
                  end;
                  28 : begin
                        _RContinue( vlNode);
                  end;
                  44 : begin
                        _RFor( vlNode);
                  end;
                  29 : begin
                        _RCount( vlNode);
                  end;
                  98 : begin
                        _RWhile( vlNode);
                  end;
                  48 : begin
                        _RIf( vlNode);
                  end;
                  76 : begin
                        _RRepeat( vlNode);
                  end;
                  40 : begin
                        _RExit( vlNode);
                  end;
                  30, 49 : begin
                        _RIncDec( vlNode);
                  end;
                  19 : begin
                        _RCodes( ParNode);
                  end;
                  42 : begin
                        _RLeave( ParNode);
                  end;
                  95..96 : begin
                        _RWrite( ParNode);
                  end;
                  else begin
                        SynError(125);
                  end;
            end;
             
            if vlNode <> nil then AddNodeToNode(ParNode,vlNode);
            ;
      end;
      
      Procedure TELA_Parser._RWhile ( var ParNode:TNodeIdent);
       
      var
       vlCond : TFormulaNode;
      
      begin
            _IWhile;
            _RFormula( vlCond);
             
            ParNode := TWhileNode.Create;
            TWhileNode(ParNode).SetCond(fNDCreator,vlCond);
            fNDCreator.AddCurrentNode(ParNode);
            ;
            _IDo;
            _RCode( ParNode);
              fNDCreator.EndNode; ;
      end;
      
      Procedure TELA_Parser._RExit ( var ParNode:TNodeIdent);
       
      var
      vlExp : TFormulaNode;
      
      begin
             
            vlExp := nil;
            ;
            _IExit;
            if (GetSym = 101) then begin
                  Get;
                  _RFormula( vlExp);
                  Expect(102);
            end;
             
            ParNode := CreateExitNode(vlExp);
            ;
      end;
      
      Procedure TELA_Parser._RFormula ( var ParExp:TFormulaNode);
      begin
            _RExpr( ParExp);
      end;
      
      Procedure TELA_Parser._RIncDec ( var ParNode : TNodeIdent);
       
      var
      vlNode 		: TIncDecNode;
      vlIncrNode  : TFormulaNode;
      vlValueNode : TFormulaNode;
      vlIncFlag   : boolean;
      
      begin
             
            vlValueNode := nil;
            ;
            if (GetSym = 49) then begin
                  _IInc;
                    vlIncFlag := true; ;
            end
             else if (GetSym = 30) then begin
                  _IDec;
                    vlIncFlag := false;;
            end
            else begin
                  SynError(126);
            end;
            ;_RFormula( vlIncrNode);
            if (GetSym = 99) then begin
                  _IWith;
                  _RFormula( vlValueNode);
            end
             else if (GetSym in [8 , 36]) then begin
                    vlValueNode := TFormulaNode(fNDCreator.CreateIntNodeLong(1)); ;
            end
            else begin
                  SynError(127);
            end;
            ; ParNode := TIncDecNode.Create(vlIncFlag,vlIncrNode,vlValueNode);;
      end;
      
      Procedure TELA_Parser._RParam ( var ParExpr : TFormulaNode;var ParName : string);
      begin
              EmptyString(ParName); ;
            _RExpr( ParExpr);
            if (GetSym = 118) then begin
                  Get;
                  _RIdent( ParName);
            end;
      end;
      
      Procedure TELA_Parser._RWrite ( ParNode:TNodeIdent);
       
      var
      vlWritelnFlag:boolean;
      vlNl      : TDefinition;
      vlRoutine : TDefinition;
      vlOwner   : TDefinition;
      vlExpr    : TFormulaNode;
      vlName    : string;
      vlNode    : TCallNode;
      
      begin
             
            vlWritelnFlag := false;
            vlNl          := nil;
            ;
            if (GetSym = 95) then begin
                  _IWrite;
            end
             else if (GetSym = 96) then begin
                  _IWriteln;
                   
                  vlWritelnFlag := true;
                  ;
            end
            else begin
                  SynError(128);
            end;
            ;if (GetSym = 101) then begin
                   
                  fNDCreator.GetWriteProc(false,vlRoutine,vlOwner);
                  ;
                  Get;
                  _RParam( vlExpr,vlName);
                    HandleWriteStatement(vlExpr,vlName,vlRoutine,vlOwner,ParNode); ;
                  WHILE (GetSym = 9) do begin
                        Get;
                        _RParam( vlExpr,vlName);
                          HandleWriteStatement(vlExpr,vlName,vlRoutine,vlOwner,ParNode); ;
                  end;
                  Expect(102);
            end;
             
            if vlWritelnFlag then begin
            if fNDCreator.GetWriteProc(true,vlNl,vlOwner) then begin
            	vlNode := TCallNode(vlNl.createExecuteNode(fNDCreator,vlOwner));
            	AddNodeToNode(ParNode,vlNode);
            end;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RContinue ( var ParNode : TNodeIdent);
      begin
            _IContinue;
              AddContinueNode(ParNode);;
      end;
      
      Procedure TELA_Parser._RBreak ( var ParNode : TNodeIdent);
      begin
            _IBreak;
              AddBreakNode(ParNode);;
      end;
      
      Procedure TELA_Parser._RRoutineHeader ( var ParRoutine:TRoutine;ParForward:boolean;var ParLevel : cardinal);
       
      var
      vlDef         : TRoutine;
      vlRootCB      : boolean;
      vlInherit     : boolean;
      vlParentName  : string;
      vlVirtual     : TVirtualMode;
      vlName        : string;
      vlOverLoad    : TOverloadMode;
      vlTmpAccess   : TDefAccess;
      vlHasses      : cardinal;
      vlInhFinal    : boolean;
      vlIsolate     : boolean;
      vlHasMain     : boolean;
      vlIsAbstract  : boolean;
      
      begin
             
            vlRootCB  := false;
            vlInherit := false;
            vlVirtual := VIr_None;
            EmptyString(vlParentName);
            vlOverload := Ovl_None;
            vlInhFinal := false;
            vlIsolate  := false;
            vlHasMain  := false;
            vlIsAbstract := false;
            ;
            if (GetSym = 67) then begin
                  _RProcedureHead( vlDef,vlHasses);
            end
             else if (GetSym = 46) then begin
                  _RFunctionHead( vlDef,vlHasses);
            end
             else if (GetSym in [27 , 32]) then begin
                  _RConstructorHead( vlDef,vlHasses);
            end
             else if (GetSym = 62) then begin
                  _ROperatorHead( vlDef);
                    vlHasses := 0; ;
            end
            else begin
                  SynError(129);
            end;
            ;  ParLevel := vlHasses + 1; ;
            if (GetSym in [50 , 77]) then begin
                  if (GetSym = 77) then begin
                        _IRoot;
                        Expect(8);
                          vlRootCb := true ;
                  end
                   else begin
                        _IInherit;
                        if (GetSym = 43) then begin
                              _IFinal;
                                vlInhFinal := true ;
                        end;
                        _RIdent( vlParentName);
                          vlInherit := true; ;
                        if (GetSym = 101) then begin
                              _RParameterMapping( vlDef);
                        end;
                        Expect(8);
                  end
                  ;end;
            if (GetSym in [43 , 65 , 93]) then begin
                  if (GetSym = 93) then begin
                        _IVirtual;
                        Expect(8);
                          vlVirtual := Vir_Virtual; ;
                  end
                   else if (GetSym = 65) then begin
                        _IOverride;
                        Expect(8);
                          vlVirtual := Vir_override;;
                  end
                   else begin
                        _IFinal;
                        Expect(8);
                          vlVirtual := VIR_Final;;
                  end
                  ;end;
            if (GetSym = 52) then begin
                  _IIsolate;
                  Expect(8);
                    vlIsolate := true;;
            end;
            if (GetSym = 64) then begin
                  _IOverload;
                  if (GetSym = 56) then begin
                        _IName;
                          vlOverload := OVL_Name;;
                  end
                   else if (GetSym = 39) then begin
                        _IExact;
                          vlOverload := OVL_Exact; ;
                  end
                   else if (GetSym = 8) then begin
                          vlOverload := OVL_Type; ;
                  end
                  else begin
                        SynError(130);
                  end;
                  ;Expect(8);
            end;
            if (GetSym = 11) then begin
                  _IAbstract;
                  Expect(8);
                    vlIsAbstract := true; ;
            end;
            if (GetSym = 31) then begin
                  _IDefault;
                    vlDef.SetDefault(DT_Routine); ;
                  Expect(8);
            end;
             
            	vlDef.GetTextStr(vlName);
            	verbose(VRB_Procedure_Name,'** Procedure name  :'+vlName);
            	if (ParForward) and (vlDef <> nil) then vlDef.SignalForwardDefined;
            	ParRoutine := ProcessRoutineItem(vlDef,vlIsolate,vlROotCb,vlInhFinal,vlInherit,vlParentName,vlVirtual,vlOverload,vlIsAbstract);
            ;
            if (GetSym = 47) then begin
                  _IHas;
                   
                  if ParRoutine <> nil then begin
                  	ParRoutine.SignalHasForward(fNDCreator);
                  	if not(RTM_Extended in ParRoutine.fRoutineModes) then begin
                  		ErrorDef(Err_Rtn_Is_Not_Extended,ParRoutine);
                  	end;
                  end;
                  vlTmpAccess := fNDCreator.fCurrentDefAccess;
                  fNDCreator.fCurrentDefAccess := AF_Private;
                  ;
                  WHILE vgDynSet[5].isSet(GetSym) do begin
                        case GetSym of
                              71 : begin
                                    _IPrivate;
                                      fNDCreator.fCurrentDefAccess := AF_Private;   ;
                              end;
                              70 : begin
                                    _IProtected;
                                      fNDCreator.fCurrentDefAccess := AF_Protected; ;
                              end;
                              69 : begin
                                    _RProperty;
                              end;
                              26 : begin
                                    _RConstant;
                              end;
                              92 : begin
                                    _RVarBlock;
                              end;
                              87 : begin
                                    _RTypeBlock;
                              end;
                              27, 32, 46, 62, 67 : begin
                                    _RRoutineForward;
                              end;
                               else begin
                                    _IMain;
                                    Expect(8);
                                     
                                    if vlHasMain then SemError(Err_Duplicate_Main_Keyword);
                                    vlHasMain := true;
                                    ;
                              end;
                        end;
                  end;
                  _IEnd;
                  Expect(8);
                   
                  fNDCreator.fCurrentDefAccess := vlTmpAccess;
                  if ParRoutine <>nil then begin
                  	ParRoutine.SetRoutineStates([RTS_Has_SR_Lock],true);
                  	if(vlHasMain) then begin
                  			ParRoutine.PreBlockOfCode(fNDCreator);
                  	end else begin
                  			ParRoutine.PreNoMain(fNDCreator);
                  	end;
                  end;
                  ;
            end;
      end;
      
      Procedure TELA_Parser._RParameterMapping ( var ParRoutine :TRoutine);
      begin
            Expect(101);
            _RParameterMappingItem( ParRoutine);
            WHILE (GetSym = 9) do begin
                  Get;
                  _RParameterMappingItem( ParRoutine);
            end;
            Expect(102);
      end;
      
      Procedure TELA_Parser._RParameterMappingItem ( ParRoutine :TRoutine);
       
      var
      vlName : string;
      vlVal  : TValue;
      vlMode : TMappingOption;
      
      begin
            if (GetSym in [1 , 116]) then begin
                   
                  	vlMode  := MO_Result;
                  ;
                  if (GetSym = 116) then begin
                        Get;
                          vlMode := MO_ObjectPointer; ;
                        _RIdent( vlName);
                  end
                   else begin
                        _RIdent( vlName);
                        if (GetSym = 117) then begin
                              Get;
                                vlMode := MO_ByPointer; (*Todo:vlMode =>MO_Result zijn *);
                        end;
                  end
                  ;  if parRoutine <> nil then ParRoutine.AddNormalParameterMapping(fNDcreator,vlName,vlMode);;
            end
             else if vgDynSet[6].isSet(GetSym) then begin
                  _RNum_Or_Const_2( vlVal);
                    if ParRoutine <> nil then ParRoutine.AddConstantParameterMapping(fNDCreator,vlVal); ;
            end
            else begin
                  SynError(131);
            end;
            ;end;
      
      Procedure TELA_Parser._RAsmBlock ( var ParNode:TNodeIdent);
       
      var
      	vlPos,vlSIze :longint;
      	vlPtr:pointer;
      
      begin
            _IAsm;
            get;
              vlPos  := GetCurrentPosition;;
            WHILE vgDynSet[7].isSet(GetSym) do begin
                  get;
            end;
             
            vlSize := GetCurrentPosition - vlPos +len;
            GetBufBlock(vlPos,vlSize,vlPtr);
            ParNode := (TAsmNode.Create(vlSize,vlPtr));
            ;
            _IEnd;
      end;
      
      Procedure TELA_Parser._RFunctionHead ( var ParRoutine:TRoutine;var ParHasses : cardinal);
       
      var
      vlType   : TType;
      vlIdent  : string;
      vlFun    : TFunction;
      vlAccess : TDefAccess;
      
      begin
            _IFunction;
            _RRoutineName( vlIdent,vlAccess,ParHasses);
             
            vlFun            := TFunction.Create(vlIdent);
            vlFun.fDefAccess := vlAccess;
            ParRoutine       := vlFun;
            vlType           := nil;
            ;
            if (GetSym = 101) then begin
                  _RParamDef( vlFun);
            end;
            Expect(10);
            _RRoutineType( vlType);
            Expect(8);
              vlFun.SetFunType(fNDCreator,vlType); ;
            if (GetSym = 23) then begin
                  _ICDecl;
                  Expect(8);
                    vlFun.SetRoutineModes([RTM_CDecl],true);;
            end;
      end;
      
      Procedure TELA_Parser._RConstructorHead ( var ParRoutine : TRoutine;var ParHasses : cardinal);
       
      var
      vlIdent  : string;
      vlAccess : TDefAccess;
      vlCDFlag : boolean;
      
      begin
            if (GetSym = 27) then begin
                  _IConstructor;
                    vlCdFlag := true; ;
            end
             else if (GetSym = 32) then begin
                  _IDestructor;
                    vlCdFlag := false; ;
            end
            else begin
                  SynError(132);
            end;
            ;_RRoutineName( vlIdent,vlAccess,ParHasses);
              ParRoutine:= CreateCDtor(vlIdent,vlAccess,vlCdFlag); ;
            if (GetSym = 101) then begin
                  _RParamDef( ParRoutine);
            end;
            Expect(8);
            if (GetSym = 23) then begin
                  _ICDecl;
                  Expect(8);
                    ParRoutine.SetRoutineModes([RTM_CDecl],true); ;
            end;
      end;
      
      Procedure TELA_Parser._ROperatorHead ( var ParRoutine:TRoutine);
       
      var
      vlType      : TType;
      vlName      : string;
      vlHasReturn : boolean;
      vlWrite		: boolean;
      
      begin
            _IOperator;
             
            					vlHasReturn := false;
                            vlWrite := false;
            					TOperatorFunction(ParRoutine) := TOperatorFunction.Create('');
            					EmptyString(vlName);
            				;
            if (GetSym in [59 , 104]) then begin
                  if (GetSym = 59) then begin
                        _INot;
                  end
                   else begin
                        Get;
                  end
                  ; 
                  					LexName(vlName);
                  			   		ParRoutine.SetText(vlName);
                  				;
                  _ROperParDef( ParRoutine);
            end
             else if (GetSym = 101) then begin
                  _ROperParDef( ParRoutine);
                  case GetSym of
                        103 : begin
                              Get;
                        end;
                        104 : begin
                              Get;
                        end;
                        105 : begin
                              Get;
                        end;
                        33 : begin
                              _IDiv;
                        end;
                        100 : begin
                              _IXor;
                        end;
                        55 : begin
                              _IMod;
                        end;
                        63 : begin
                              _IOr;
                        end;
                        13 : begin
                              _IAnd;
                        end;
                        106 : begin
                              Get;
                        end;
                        110 : begin
                              Get;
                        end;
                        111 : begin
                              Get;
                        end;
                        112 : begin
                              Get;
                        end;
                        113 : begin
                              Get;
                        end;
                        114 : begin
                              Get;
                        end;
                        109 : begin
                              Get;
                        end;
                        21 : begin
                              _IBetween;
                        end;
                        115 : begin
                              Get;
                        end;
                        79 : begin
                              _IShl;
                        end;
                        78 : begin
                              _IShr;
                        end;
                        1 : begin
                              Get;
                        end;
                        else begin
                              SynError(133);
                        end;
                  end;
                   
                  					LexName(vlname);
                  			   		ParRoutine.SetText(vlName);
                  				;
                  _ROperParDef( ParRoutine);
                  if (GetSym = 95) then begin
                        _IWrite;
                        _ROperParDef( ParRoutine);
                         
                        					vlWrite := true;
                        					if vlName <> '#' then ErrorText(Err_Not_Expected,'WRITE');
                        				;
                  end;
                  if (GetSym = 13) then begin
                        _IAnd;
                        _ROperParDef( ParRoutine);
                         
                        					if vlName <>'BETWEEN' then ErrorText(Err_Not_Expected,'AND');
                        				;
                  end;
            end
            else begin
                  SynError(134);
            end;
            ;if (GetSym = 10) then begin
                  Get;
                  _RRoutineType( vlType);
                   
                  vlHasreturn := true;
                  if (vlName = ':=') or (vlWrite and (vlName = '#')) then SemError(Err_Cant_Return_value);
                  TFunction(ParRoutine).SetFunType(fNDCreator,vlType);
                  ;
            end;
            Expect(8);
             
            if (vlName <> ':=') and ((vlName <> '#') or not(vlWrite))  and not(vlHasReturn) then SemError(err_Must_Return_Value);
            ;
            if (GetSym = 23) then begin
                  _ICDecl;
                  Expect(8);
                    ParRoutine.SetRoutineModes([RTM_CDecl],true); ;
            end;
      end;
      
      Procedure TELA_Parser._ROperParDef ( ParRoutine:TRoutine);
       
      var
      vlType  : TType;
      vlIdent : string;
      vlConst : boolean;
      vlVar   : boolean;
      vlName  : TNameList;
      
      begin
             
            vlConst := false;
            vlVar   := false;
            vlName  := TNameList.Create;
            ;
            Expect(101);
            if (GetSym in [26 , 92]) then begin
                  if (GetSym = 26) then begin
                        _IConst;
                          vlCOnst := TRUE; ;
                  end
                   else begin
                        _IVar;
                          vlVar   := true; ;
                  end
                  ;end;
            _RIdent( vlIdent);
              vlName.AddName(vlIdent); ;
            Expect(10);
            _RRoutineType( vlType);
            Expect(102);
             
            ParRoutine.AddParam(fNDCreator,vlName,vlType,vlVar,vlConst,false);
            vlName.Destroy;
            ;
      end;
      
      Procedure TELA_Parser._RProcedureHead ( var ParRoutine:TRoutine;var ParHasses : cardinal);
       
      var
      	vlIdent:string;
      	vlAccess : TDefAccess;
      
      begin
            _IProcedure;
            _RRoutineName( vlIdent,vlAccess,ParHasses);
             
            ParRoutine := TProcedureObj.Create(vlIdent);
            ParRoutine.fDefAccess := vlAccess;
            ;
            if (GetSym = 101) then begin
                  _RParamDef( ParRoutine);
            end;
            Expect(8);
            if (GetSym = 23) then begin
                  _ICDecl;
                  Expect(8);
                    ParRoutine.SetRoutineModes([RTM_Cdecl],true);;
            end;
      end;
      
      Procedure TELA_Parser._RRoutineName ( var ParName : string;var ParAccess : TDefAccess;var ParHasses:cardinal);
       
      var
      	vlname : string;
      
      begin
             
            	ParHasses := 0;
            	ParAccess := AF_Current;
            ;
            _RRoutineDotName( vlName,ParHasses);
            if (GetSym = 47) then begin
                  _IHas;
                   
                  HandleHasClause(vlName);
                   inc(ParHasses);
                  ;
                  WHILE (GetSym = 1) do begin
                        _RRoutineDotName( vlName,ParHasses);
                         
                        HandleHasClause(vlName);
                         inc(ParHasses);
                        ;
                        _IHas;
                  end;
                  if (GetSym in [70 , 71]) then begin
                        if (GetSym = 70) then begin
                              _IProtected;
                                ParAccess := AF_Protected; ;
                        end
                         else begin
                              _IPrivate;
                                ParAccess := AF_Private;   ;
                        end
                        ;_RIdent( vlName);
                  end
                   else if (GetSym in [8 , 10 , 101]) then begin
                         
                        if(ParHasses > 1) then begin
                        	EndIdent;
                        	dec(ParHasses);
                        end;
                        ParAccess := AF_Protected;
                        ;
                  end
                  else begin
                        SynError(135);
                  end;
                  ;end;
              ParName := vlName; ;
      end;
      
      Procedure TELA_Parser._RRoutineDotName ( var ParName : string;var ParHasses : cardinal);
      begin
            _RIdent( ParName);
            WHILE (GetSym = 7) do begin
                  Get;
                   
                  		inc(ParHasses);
                  		HandleRoutineDotName(ParName);
                  	;
                  _RIdent( ParName);
            end;
      end;
      
      Procedure TELA_Parser._RParamVarDef ( vlRoutine:TRoutine;var vlVirCheck:boolean);
       
      var
      	vlIdent   : string;
      	vlAlias   : string;
      	vlType    : TType;
      	vlVar     : boolean;
      	vlConst   : boolean;
      	vlName    : TNameList;
      	vlVirtual : boolean;
      
      begin
             
            vlName := TNameList.Create;
            EmptyString(vlAlias);
            vlVirtual := false;
            vlVar     := false;
            vlConst   := false;
            vlType    := nil;
            ;
            if (GetSym = 93) then begin
                  _IVirtual;
                    vlVirtual := true ;
            end;
            if (GetSym in [26 , 92]) then begin
                  if (GetSym = 92) then begin
                        _IVar;
                          vlVar   := true;;
                  end
                   else begin
                        _IConst;
                          vlConst := true; ;
                  end
                  ;end;
            _RIdent( vlIdent);
              vlName.AddName(vlIdent);;
            WHILE (GetSym = 9) do begin
                  Get;
                  _RIdent( vlIdent);
                    vlName.AddName(vlIdent);;
            end;
            Expect(10);
            _RRoutineType( vlType);
             
            if vlRoutine <> nil then vlRoutine.AddParam(fNDCreator,vlName,vlType,vlVar,vlConst,vlVirtual);
            vlName.destroy;
            if vlVirtual then begin
            	vlVirCheck := true;
            end else if vlVirCheck then begin
            	ErrorText(Err_Stat_Befor_vir_Param,vlIdent);
            end;
            ;
      end;
      
      Procedure TELA_Parser._RProperty;
       
      var
      	vlName         : string;
      	vlProperty     : TProperty;
      	vlAcc          : TDefAccess;
      	vlPropertyType : TPropertyType;
      	vlType         : TType;
      
      begin
            _IProperty;
            _RIdent( vlName);
            Expect(10);
            _RUsableType( vlType);
             
            		vlProperty := TProperty.Create(vlName,vlType);
            		AddIdent(vlProperty);
            	;
            _IBegin;
            WHILE (GetSym in [70 , 71 , 72 , 74 , 95]) do begin
                    vlAcc := AF_Public ;
                  if (GetSym in [70 , 71 , 72]) then begin
                        if (GetSym = 72) then begin
                              _IPublic;
                                vlAcc := AF_Public; ;
                        end
                         else if (GetSym = 71) then begin
                              _IPrivate;
                                vlAcc := AF_private; ;
                        end
                         else begin
                              _IProtected;
                                vlAcc := AF_Protected; ;
                        end
                        ;end;
                  if (GetSym = 74) then begin
                        _IRead;
                          vlPropertyType := PT_Read; ;
                  end
                   else if (GetSym = 95) then begin
                        _IWrite;
                          vlPropertyType := PT_Write; ;
                  end
                  else begin
                        SynError(136);
                  end;
                  ;_RIdent( vlName);
                  Expect(8);
                   
                        	DoPropertyDefinition(vlName,vlAcc,vlPropertyType,vlProperty);
                  		;
            end;
            _IEnd;
            Expect(8);
      end;
      
      Procedure TELA_Parser._RClassType ( const ParName : string;var ParType : TType);
       
      var
      	vlParent     : string;
      	vlPrvAccess  : TDefAccess;
      	vlVirtual    : TVirtualMode;
      	vlIsolate    : boolean;
      
      begin
             
            EmptyString(vlParent);
            vlVirtual := VIR_None;
            vlIsolate := false;
            ;
            if (GetSym = 52) then begin
                  _IIsolate;
                    vlIsolate := true;;
            end;
            if (GetSym in [65 , 93]) then begin
                  if (GetSym = 93) then begin
                        _IVirtual;
                          vlVirtual := VIR_Virtual; ;
                  end
                   else begin
                        _IOverride;
                          vlVirtual := VIR_Override; ;
                  end
                  ;end;
            _IClass;
            if vgDynSet[8].isSet(GetSym) then begin
                  if (GetSym = 50) then begin
                        _IInherit;
                        _RIdent( vlParent);
                  end;
                   
                  ParType := CreateClassType(ParName,vlParent,vlVirtual,false,vlIsolate);
                  vlPrvAccess := fNDCreator.fCurrentDefAccess;
                  fNDCreator.fCurrentDefAccess := AF_Private;
                  ;
                  WHILE vgDynSet[9].isSet(GetSym) do begin
                        case GetSym of
                              71 : begin
                                    _IPrivate;
                                      fNDCreator.fCurrentDefAccess := AF_Private; ;
                              end;
                              70 : begin
                                    _IProtected;
                                      fNDCreator.fCurrentDefAccess := AF_Protected; ;
                              end;
                              72 : begin
                                    _IPublic;
                                      fNDCreator.fCurrentDefAccess := AF_Public; ;
                              end;
                              69 : begin
                                    _RProperty;
                              end;
                              87 : begin
                                    _RTypeBlock;
                              end;
                              92 : begin
                                    _RVarBlock;
                              end;
                              26 : begin
                                    _RConstant;
                              end;
                               else begin
                                    _RRoutineForward;
                              end;
                        end;
                  end;
                  _IEnd;
                   
                  TClassType(ParType).FinishClass;
                  fNDCreator.EndIdent;
                  fNDCreator.fCurrentDefAccess := vlPrvAccess;
                  ;
            end
             else if (GetSym = 8) then begin
                   
                  ParType := CreateClassType(ParName,vlParent,vlVirtual,true,vlIsolate);
                  ;
            end
            else begin
                  SynError(137);
            end;
            ;end;
      
      Procedure TELA_Parser._RTypeDecl;
       var
      vlIdent    : string;
      vlType     : TType;
      vlDefType  : TDefaultTypeCode;
      vlAdded    : boolean;
      
      begin
            _RIdent( vlIdent);
             
            vlType     := nil;
            vLDefType  := DT_Nothing;
            vlAdded    := false;
            ;
            Expect(106);
            if (GetSym = 31) then begin
                  _IDefault;
                    vlDefType := DT_Default; ;
                  if (GetSym = 54) then begin
                        _IMetaType;
                          vlDefType := DT_Meta; ;
                  end;
            end;
            if vgDynSet[10].isSet(GetSym) then begin
                  if vgDynSet[11].isSet(GetSym) then begin
                        case GetSym of
                              58 : begin
                                    _ROrdDecl( vlType);
                                      HandleDefaultType(vlDefType,DT_Number,[DT_Number,DT_Boolean]) ;
                              end;
                              1 : begin
                                    _RTypeAs( vlType);
                                      HandleDefaultType(vlDefType,DT_Default,[]); ;
                              end;
                              97 : begin
                                    _RVoidTypeDecl( vlType);
                                      HandleDefaultType(vlDefType,DT_Void,[DT_Void]); ;
                              end;
                              24 : begin
                                    _RCharDecl( vlType);
                                      HandleDefaultType(vlDefType,DT_Char,[DT_Char]); ;
                              end;
                              38 : begin
                                    _REnum( vlType);
                                      HandleDefaultType(vlDefType,DT_Default,[DT_Boolean]); ;
                              end;
                              73 : begin
                                    _RPtrTypeDecl( vlType,true );
                                     
                                             if vlDefType = DT_Meta then vlDefType := DT_Ptr_Meta;
                                    							 HandleDefaultType(vlDefType,DT_Pointer,[DT_Asciiz,DT_Ptr_Meta,DT_Pointer]);
                                          				 ;
                              end;
                              83 : begin
                                    _RStringTypeDecl( TStringType(vlType));
                                      HandleDefaultType(vlDefType,DT_String,[DT_String]); ;
                              end;
                              17 : begin
                                    _RAsciizDecl( vlType);
                                      HandleDefaultType(vlDefType,DT_Asciiz,[DT_Asciiz]); ;
                              end;
                              89 : begin
                                    _RUnion( vltype);
                                      HandleDefaultType(vlDefType,DT_Default,[]); ;
                              end;
                              25, 52, 65, 93 : begin
                                    _RClassType( vlIdent,vlType);
                                     
                                                vlAdded :=true;
                                    							 HandleDefaultType(vlDefType,DT_Default,[]);
                                             ;
                              end;
                              75 : begin
                                    _RRecord( vlType);
                                      HandleDefaultType(vlDefType,DT_Default,[DT_Meta]);;
                              end;
                              else begin
                                    SynError(138);
                              end;
                        end;
                  end
                   else if (GetSym = 20) then begin
                        _RBooleanType( vlType);
                          HandleDefaultType(vlDefType,DT_Boolean,[DT_Boolean]); ;
                  end
                   else begin
                        _RArrayTypeDef( vlType);
                          HandleDefaultType(vlDefType,DT_Default,[]); ;
                  end
                  ;Expect(8);
            end
             else if (GetSym in [46 , 60 , 67]) then begin
                  _RRoutineTypeDecl( vlType);
                    HandleDefaultType(vlDefType,DT_Default,[]); ;
            end
            else begin
                  SynError(139);
            end;
            ; 
            if not vlAdded then fNDCreator.AddType(vlIdent,vlType);
            if vlType <> nil then begin
            vlType.AfterDef(fNDCreator);
             if (vlDefType <> DT_Nothing) then begin
            	vlType.SetDefault(vlDefType);
            	fNDCreator.AddToDefault(vlType);
            end;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RTypeAs ( var ParType : TType);
       
      var
      	vlType2   : TType;
      	vlHasSize : boolean;
      	vlSize    : TSize;
      
      begin
             
            vlHasSize := false;
            ParType   := nil;
            ;
            _RH_Type( vlType2);
            if (GetSym = 80) then begin
                  _ISize;
                  Expect(106);
                  _RDirectCardinal( vlSize);
                   
                  			if vlType2 <> nil then begin
                  				ParType    := vlType2.CreateBasedOn(fNDCreator,vlSize);
                  			end;
                  			vlHasSize := true;
                  		;
            end;
              if not vlHasSize then ParType    := TTypeAs.Create('',vlType2); ;
      end;
      
      Procedure TELA_Parser._RAnonymousType ( var ParTYpe : TType);
      begin
              ParType := nil;;
            case GetSym of
                  14 : begin
                        _RArrayTypeDef( ParType);
                  end;
                  58 : begin
                        _ROrdDecl( ParType);
                  end;
                  17 : begin
                        _RAsciizDecl( ParType);
                  end;
                  83 : begin
                        _RStringTypeDecl( TStringType(ParType));
                  end;
                  73 : begin
                        _RPtrTypeDecl( ParType,false );
                  end;
                  75 : begin
                        _RRecord( ParType);
                  end;
                  89 : begin
                        _RUnion( ParType);
                  end;
                  else begin
                        SynError(140);
                  end;
            end;
              AddAnonItem(ParType); ;
      end;
      
      Procedure TELA_Parser._RPtrTypeDecl ( var ParType:TType;ParCanForward : boolean);
       
      var
      vlName : string;
      vlConstFlag : boolean;
      vlType : TType;
      
      begin
              vlConstFlag := false ; ;
            _IPtr;
            if (GetSym = 26) then begin
                  _IConst;
                    vlConstFlag := true; ;
            end;
            if vgDynSet[12].isSet(GetSym) then begin
                  _RAnonymousType( vlType);
                    ParType := CreatePointerType(vlType,vlConstFlag); ;
            end
             else if (GetSym = 1) then begin
                  _RIdent( vlName);
                    ParType := CreatePointerType(vlName,ParCanForward,vlCOnstFlag);;
            end
            else begin
                  SynError(141);
            end;
            ;end;
      
      Procedure TELA_Parser._RCharDecl ( var ParType:TType);
       
      var
      vlSize : TSize;
      
      begin
            _ICharType;
            _ISize;
            Expect(106);
            _RDirectCardinal( vlSize);
             
            if not (vlSIze in [1,2,4]) then SemError(Err_Illegal_Type_Size);
            ParType := TCharType.Create(vlSize);
            ;
      end;
      
      Procedure TELA_Parser._RVoidTypeDecl ( var Partype:TType);
      begin
            _IVoidType;
              ParType := TVoidType.Create; ;
      end;
      
      Procedure TELA_Parser._RParamDef ( ParRoutine:TRoutine);
       
      var
      	vlVirCheck : boolean;
      
      begin
             
            fNDCreator.AddCurrentDefinition(ParRoutine);
            vlVirCheck := false;
            ;
            Expect(101);
            _RParamVarDef( ParRoutine,vlVirCheck);
            WHILE (GetSym = 8) do begin
                  Get;
                  _RParamVarDef( ParRoutine,vlVirCheck);
            end;
            Expect(102);
               if ParRoutine <> nil then EndIdent; ;
      end;
      
      Procedure TELA_Parser._RRoutineTypeDecl ( var ParType:TType);
       
      var
      	vlRoutine : TRoutine;
      	vlType    : TType;
      	vlOfObject: boolean;
      
      begin
             
            vlRoutine  := nil;
            vlOfObject := false;
            ;
            if (GetSym = 60) then begin
                  _IObject;
                    vlOfObject := true; ;
            end;
            if (GetSym = 67) then begin
                  _IProcedure;
                    vlRoutine := TProcedureObj.Create(''); ;
                  if (GetSym = 101) then begin
                        _RParamDef( vlRoutine);
                  end;
            end
             else if (GetSym = 46) then begin
                  _IFunction;
                    vlRoutine := TFunction.Create(''); ;
                  if (GetSym = 101) then begin
                        _RParamDef( vlRoutine);
                  end;
                  Expect(10);
                  _RRoutineType( vlType);
                    TFunction(vlRoutine).SetFunType(fNDCreator,vlType); ;
            end
            else begin
                  SynError(142);
            end;
            ;Expect(8);
            if (GetSym = 23) then begin
                  _ICDecl;
                    vlRoutine.SetRoutineModes([RTM_Cdecl],true);;
                  Expect(8);
            end;
             
            
            Partype := TRoutineType.Create(true,vlRoutine,vlOfObject);
            if (vlRoutine <> nil) and (vlOfObject) then begin
            	vlType   := fNDCreator.GetDefaultIdent(DT_Ptr_Meta,Size_DontCare,false);
            	vlRoutine.AddParam(TFixedFrameParameter.Create(name_self,ParType,TRoutineType(ParType).fParamFrame,TRoutineType(ParType).fPushedFrame,ParType,false));
            	vlRoutine.PreProcessParameterList(nil,nil,FNDCreator);
            end;
            
            ;
      end;
      
      Procedure TELA_Parser._ROrdDecl ( var ParType:TType);
       
      var
      	vlSign:boolean;
      	vlSize:TSize;
      
      begin
             vlSign := false; ;
            _INumber;
            if (GetSym = 81) then begin
                  _ISigned;
                    vlSign := true; ;
            end;
            _ISize;
            Expect(106);
            _RDirectCardinal( vlSize);
             
            if not (vlSIze in [1,2,4]) then SemError(Err_Illegal_Type_Size);
            ParType := TNumberType.Create(vlSIze,vlSign);
            ;
      end;
      
      Procedure TELA_Parser._RStringTypeDecl ( var ParType:TStringType);
       
      var
      	vlSize       : TSize;
      	vlType       : TType;
      	vlHasSize    : boolean;
      	vlHasDefaultSize : boolean;
      	vlLengthVarName  : string;
      	vlLengthVarType  : TTYpe;
      
      begin
             
            vlSize    := 255;
            vlType    := nil;
            vlHasSize := false;
            vlHasDefaultSize := false;
            vlLengthVarType := nil;
            EmptyString(vlLengthVarName);
            ;
            _IString;
            if (GetSym = 61) then begin
                  _IOf;
                  _RH_Type( vlType);
            end;
            if (GetSym = 92) then begin
                  _IVar;
                  _RIdent( vlLengthVarName);
                  Expect(10);
                  _RH_Type( vlLengthVarType);
            end;
            if (GetSym = 31) then begin
                  _IDefault;
                    vlHasDefaultSize := true ;
            end;
            if (GetSym = 80) then begin
                  _ISize;
                  Expect(106);
                  _RDirectCardinal( vlSize);
                    vlHasSize := true ;
            end;
              ParType :=CreateStringType(vlType,vlLengthVarName,vlLengthVarType,vlHasDefaultSize,vlSize,vlHasSize); ;
      end;
      
      Procedure TELA_Parser._RAsciizDecl ( var ParType:TType);
       
      var
      	vlSize : TSize;
      	vlType : TType;
      
      begin
            _IAsciiz;
            _ISize;
            Expect(106);
            _RDirectCardinal( vlSize);
             
            vlType := fNDCreator.GetDefaultChar;
             if vlSize < 0 then SemError(err_Illegal_type_Size);
            ParType := TAsciizType.Create(vlType,vlSize);
            ;
      end;
      
      Procedure TELA_Parser._RRecord ( var PArType:TType);
      begin
            _IRecord;
              ParType := fNDCreator.CreateRecord; ;
            WHILE (GetSym = 1) do begin
                  _RVarDecl;
            end;
            _IEnd;
              Endident; ;
      end;
      
      Procedure TELA_Parser._RUnion ( var ParType :TType);
      begin
            _IUnion;
              ParType:= fNDCreator.AddUnion; ;
            WHILE (GetSym = 1) do begin
                  _RVarDecl;
            end;
            _IEnd;
              EndIdent; ;
      end;
      
      Procedure TELA_Parser._RBooleanType ( var ParType : TType);
       
      var
      	vlName : string;
           vlSize : cardinal;
      	vlVal :TValue;
      
      begin
            _IBooleanType;
            _ISize;
            Expect(106);
            _RDirectCardinal( vlSize);
             
            	ParType := CreateBooleanType(vlSIze);
            ;
            Expect(101);
            _RIdent( vlName);
             
            				 vlVal := TBoolean.Create(true);
            				fNDCreator.AddConstant(vlName,vlVal,ParType);
                   vlVal.Destroy;
            			;
            Expect(9);
            _RIdent( vlName);
             
            					vlVal := TBoolean.Create(false);
            					fNDCreator.AddConstant(vlName,vlVal,ParType);
                	vlVal.Destroy;
            				;
            Expect(102);
      end;
      
      Procedure TELA_Parser._REnum ( var ParType:TType);
       
      var
      	vlVal :TNumber;
      	vlCollection :TENumCollection;
      	vlName : string;
      
      begin
            _IEnum;
             
            Partype := SetEnumBegin;
            vlCollection := TEnumCollection.Create;
            GetNewAnonName(vlName);
            vlCollection.SetText(vlName);
            LoadLong(vlVal, 0);
            AddIdent(vlCollection);
             fNDCreator.AddCurrentDefinition(vlCollection);
            ;
            WHILE (GetSym = 1) do begin
                  _REnumident( vlVal);
                  Expect(8);
            end;
            _IEnd;
              EndEnum; ;
      end;
      
      Procedure TELA_Parser._REnumident ( var ParVal:TNumber);
       
      	var
      			vlIdent : string;
      			vlVal : TValue;
      
      begin
            _RIdent( vlIdent);
            if (GetSym = 109) then begin
                  Get;
                  _RDirectNumber( ParVal);
            end;
             
            vlVal := TLongint.Create(ParVal);
            fNDCreator.AddIdent(TEnumCons.Create(vlIdent,vlVal));
            LargeAddLong(ParVal,1);
            ;
      end;
      
      Procedure TELA_Parser._RRoutineType ( var ParType : TType);
      begin
              ParType := nil;;
            if (GetSym = 1) then begin
                  _RH_Type( ParType);
            end
             else if (GetSym in [17 , 58 , 73 , 83]) then begin
                  if (GetSym = 17) then begin
                        _RAsciizDecl( ParType);
                  end
                   else if (GetSym = 58) then begin
                        _ROrdDecl( ParType);
                  end
                   else if (GetSym = 73) then begin
                        _RPtrTypeDecl( ParType,false );
                  end
                   else begin
                        _RStringTypeDecl( TStringType(ParType));
                  end
                  ;  AddAnonItem(ParType); ;
            end
            else begin
                  SynError(143);
            end;
            ;end;
      
      Procedure TELA_Parser._RArrayTypeDef ( var ParArray:TType);
       
      var
      vlLo   : TArrayIndex;
      vlHi   : TArrayIndex;
       vlAr   : TArrayType;
      vlType : TType;
      
      begin
            _IArray;
            Expect(107);
            _RArrayRangeDef( vlLo,vlHi);
             vlAr := TArrayType.Create(vlLo,vlHi);;
            WHILE (GetSym = 9) do begin
                  Get;
                  _RArrayRangeDef( vlLo,vlHi);
                    vlAr.AddType(TArrayType.Create(vlLO,vlHi)); ;
            end;
            Expect(108);
            _IOf;
            _RRoutineType( vltype);
             
            vlAr.SetTopType(vlType);
            ParArray := vlAr;
            if vlAr.CalculateSize then SemError(Err_Array_Too_Big);
            ;
      end;
      
      Procedure TELA_Parser._RArrayRangeDef ( var ParLo,ParHi:TArrayIndex);
      begin
            _RDirectNumber( ParLo);
            _ITo;
            _RDirectNumber( ParHi );
              if LargeCompare(ParLo , ParHi)=LC_Bigger  then SemError(Err_Inverse_Range); ;
      end;
      
      Procedure TELA_Parser._RNum_Or_Const_2 ( var ParVal:TValue);
        var
          vlValid : boolean;
          vlNum   : TNumber;
          vlStr   : String;
          vlNeg   : boolean;
      
      begin
             
             ParVal  := nil;
             vlValid := true;
             vlNeg   := false;
            ;
            if (GetSym in [3 , 4 , 5 , 103 , 104]) then begin
                  if (GetSym in [103 , 104]) then begin
                        if (GetSym = 104) then begin
                              Get;
                                vlNeg := true; ;
                        end
                         else begin
                              Get;
                        end
                        ;end;
                  _RNumber( vlNum,vlValid);
                   
                  	if vlNeg then LargeNeg(vlNum);
                  	if Not(LargeInRange(vlNum, Min_Longint, Max_Cardinal)) then ErrorText(Err_Num_Out_Of_Range,'3');
                  	ParVal := TLongint.Create(vlNum);
                  	if not vlValid then SemError(Err_int_Invalid_Number);
                  ;
            end
             else if (GetSym = 24) then begin
                  _RCharConst( ParVal);
            end
             else if (GetSym in [2 , 6]) then begin
                  _RText( vlStr);
                     ParVal := TString.Create(vlStr); ;
            end
            else begin
                  SynError(144);
            end;
            ; 
            if ParVal = nil then begin
            	ParVal := TLongint.Create(1);
            end;
            ;
      end;
      
      Procedure TELA_Parser._RConstantDecl;
       
      var
      vlNameList : TNameList;
      vlStr      : String;
      vlIdent    : string;
      vlVal      : TValue;
      
      begin
              vlNameList := TNameList.Create;;
            _RIdent( vlIdent);
              vlNameList.AddName(vlIdent);;
            WHILE (GetSym = 9) do begin
                  Get;
                  _RIdent( vlIdent);
                    vlNameList.AddName(vlIdent);;
            end;
            Expect(106);
            _RDirectExpr( vlVal);
             
            if vlVal.fType = VT_String then begin
            	vlVal.GetString(vlStr);
            	fNDCreator.AddStringConst(vlNameList,vlStr);
            end else begin
            	fNDCreator.AddConstant(vlNameList,vlVal);
            end;
            vlVal.destroy;
            vlNameList.destroy;
            ;
      end;
      
      Procedure TELA_Parser._RConstantStringIdent ( var ParValue : TString);
       
      var
      	vlConst : TConstant;
      
      begin
            _RIdentObj( TDefinition(vlConst));
             
            ParValue := nil;
            if (vlConst <> nil) then begin
            	if((vlConst is TConstant)) then begin
            		ParValue := TString(vlConst.fVal.Clone);
            		if ParValue.fType <> vt_String then ErrorDef(Err_Not_A_String_Constant,vlConst);
            	end else begin
            		ErrorDef(Err_Not_A_String_COnstant,vlConst);
            	end;
            end;
            if ParValue = nil then ParValue := TString.Create('');
            ;
      end;
      
      Procedure TELA_Parser._RConstantStringValue ( var ParValue : TString);
       
      var
      	vlStr : string;
      
      begin
            if (GetSym = 24) then begin
                  _RCharConst( ParValue);
            end
             else if (GetSym in [2 , 6]) then begin
                  _RText( vlStr);
                   
                  	ParValue := TString.Create(vlStr);
                  ;
            end
            else begin
                  SynError(145);
            end;
            ;end;
      
      Procedure TELA_Parser._RConstantStringFact ( var ParString : TString);
      begin
              ParString := nil; ;
            if (GetSym in [2 , 6 , 24]) then begin
                  _RConstantStringValue( ParString);
            end
             else if (GetSym = 1) then begin
                  _RConstantStringIdent( ParString);
            end
             else if (GetSym = 101) then begin
                  Get;
                  _RConstantStringExpr( ParString);
                  Expect(102);
            end
            else begin
                  SynError(146);
            end;
            ;end;
      
      Procedure TELA_Parser._RConstantStringAdd ( var ParString : TString);
       
      var
      	vlValue : TString;
      
      begin
            _RConstantStringFact( ParString);
            WHILE (GetSym = 103) do begin
                  Get;
                  _RConstantStringFact( vlValue);
                   
                  if  vlValue <> nil then begin
                  	if (ParString <> nil) then begin
                  		CalculationStatusToError(ParString.Add(vlValue));
                  	end;
                  	vlValue.Destroy;
                  end;
                  ;
            end;
      end;
      
      Procedure TELA_Parser._RConstantStringExpr ( var ParString : TString);
      begin
            _RConstantStringAdd( ParString);
      end;
      
      Procedure TELA_Parser._RH_Type ( var ParType:TType);
       
      var
      	vlDef : TDefinition;
      
      begin
            _RDefIdentObj( vlDef,true);
             
            ParType := nil;
            if vlDef <> nil then begin
            if not(vlDef is TType) then begin
            	ErrorDef(Err_Not_A_Type,vlDef);
            end else begin
            	ParType := TType(vlDef);
            end;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RNum_Or_Const ( var ParVal:TValue;var ParInvalid : boolean);
        var vlConst : TConstant;
      			       vlValid : boolean;
      			       vlNum   : TNumber;
      			       vlStr   : String; 
      begin
                ParVal := nil;
            			     vlValid := true; ;
            if (GetSym in [3 , 4 , 5]) then begin
                  _RNumber( vlNum,vlValid);
                   
                  			 if not(LargeInRange(vlNum, Min_Longint,Max_Cardinal)) then ErrorText(Err_Num_Out_Of_Range,'2');
                  			 ParVal := TLongint.Create(vlNum);
                              if not vlValid then ParInvalid := true;
                  		 ;
            end
             else if (GetSym = 1) then begin
                  _RDefIdentObj( TDefinition(vlConst),false);
                   
                  ParVal := nil;
                  if (vlConst <> nil) then begin
                  	if not(vlConst is TConstant) then begin
                  		SemError(Err_Not_An_Integer_Const)
                  	end else begin
                  		ParVal := vlConst.fVal.Clone;
                  	end;
                  end;
                  if ParVal = nil then ParVal := (TLongint.Create(1));
                  ;
            end
             else if (GetSym = 24) then begin
                  _RCharConst( ParVal);
            end
             else if (GetSym in [2 , 6]) then begin
                  _RText( vlStr);
                     ParVal := TString.Create(vlStr); ;
            end
            else begin
                  SynError(147);
            end;
            ; 
            if ParVal = nil then begin
            ParVal := TLongint.Create(1);
            ParInvalid := true;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RDirectFact ( var ParVal:TValue;var ParInValid:boolean);
       
      var
      	vlNum :TSize;
      	vlType:TType;
      
      begin
              ParVal     := nil; ;
            if vgDynSet[13].isSet(GetSym) then begin
                  _RNum_Or_Const( ParVal,ParInvalid);
            end
             else if (GetSym = 101) then begin
                  Get;
                  _RDirectLogic( ParVal,ParInValid);
                  Expect(102);
            end
             else if (GetSym = 57) then begin
                  _INil;
                   
                  	ParVal := TPointer.Create;
                      TPointer(ParVal).SetPointer(0);
                  ;
            end
             else if (GetSym = 59) then begin
                  _INot;
                  Expect(101);
                  _RDirectLogic( ParVal,ParInvalid);
                  Expect(102);
                    if CalculationStatusToError(ParVal.NotVal) then ParInvalid := true; ;
            end
             else if (GetSym = 82) then begin
                  _ISizeOf;
                  Expect(101);
                  _RH_Type( vlType);
                  Expect(102);
                   
                  	if vlType <> nil then begin
                  		vlNum := vlType.fSize
                  	end  else begin
                  		vlNum := 0;
                  		ParInvalid := true;
                  	end;
                  	ParVal := TLongint.Create(vlNum);
                  ;
            end
            else begin
                  SynError(148);
            end;
            ;  if ParVal = nil then ParVal := (TLongint.Create(1));;
      end;
      
      Procedure TELA_Parser._RDirectNeg ( var ParVal : TValue;var ParInvalid : boolean);
       
      Var
      	vlNeg : boolean;
      
      begin
              vlNeg := false;;
            WHILE (GetSym in [103 , 104]) do begin
                  if (GetSym = 104) then begin
                        Get;
                          vlNeg := true; ;
                  end
                   else begin
                        Get;
                  end
                  ;end;
            _RDirectFact( ParVal,ParInvalid);
             
             if vlNeg then  ParInvalid := ParInvalid or CalculationStatusToError(ParVal.Neg);
            ;
      end;
      
      Procedure TELA_Parser._RDirectMul ( var ParVal:TValue;var ParInValid:boolean);
        var vlVal:TValue;   
      begin
            _RDirectNeg( ParVal,ParInValid);
            WHILE (GetSym in [33 , 55 , 105]) do begin
                  if (GetSym = 105) then begin
                        Get;
                        _RDirectNeg( vlval,ParInValid);
                          ParInValid := ParInValid or CalculationStatusToError(ParVal.Mul(vlVal)); ;
                  end
                   else if (GetSym = 33) then begin
                        _IDiv;
                        _RDirectNeg( vlVal,ParInValid);
                          ParInValid := ParInValid or CalculationStatusToError(ParVal.DivVal(vlVal)); ;
                  end
                   else begin
                        _IMod;
                        _RDirectNeg( vlVal,ParInvalid);
                          ParInvalid := ParInvalid or CalculationStatusToError(ParVal.ModVal(vlVal));;
                  end
                  ;  vlVal.destroy; ;
            end;
      end;
      
      Procedure TELA_Parser._RDirectAdd ( var ParVal:TValue;var ParInValid:boolean);
       
      var
      	vlVal:TValue;
      
      begin
            _RDirectMul( ParVal,ParInValid);
            WHILE (GetSym in [78 , 79 , 103 , 104]) do begin
                  if (GetSym = 103) then begin
                        Get;
                        _RDirectMul( vlVal,ParInValid);
                          ParInvalid := ParInvalid or CalculationStatusToError(ParVal.Add(vlVal)); ;
                  end
                   else if (GetSym = 104) then begin
                        Get;
                        _RDirectMul( vlval,ParInValid);
                          ParInvalid := ParInvalid or CalculationStatusToError(ParVal.Sub(vlVal)); ;
                  end
                   else if (GetSym = 79) then begin
                        _IShl;
                        _RDirectMul( vlVal,ParInValid);
                          ParInvalid := ParInvalid or CalculationStatusToError(ParVal.ShiftLeft(vlVal)); ;
                  end
                   else begin
                        _IShr;
                        _RDirectMul( vlVal,ParInValid);
                          ParInvalid := ParInvalid or CalculationStatusToError(ParVal.ShiftRight(vlVal)); ;
                  end
                  ;   vlVal.destroy;;
            end;
      end;
      
      Procedure TELA_Parser._RDirectLogic ( var ParVal : TValue;var ParInvalid:boolean);
       
      var
      	vlVal : TValue;
      
      begin
            _RDirectAdd( ParVal,ParInvalid);
            WHILE (GetSym in [13 , 63 , 100]) do begin
                  if (GetSym = 13) then begin
                        _IAnd;
                        _RDirectAdd( vlVal,ParInvalid);
                          ParInvalid := ParInvalid or CalculationStatusToError(ParVal.AndVal(vlVal)); ;
                  end
                   else if (GetSym = 63) then begin
                        _IOr;
                        _RDirectAdd( vlVal,ParInvalid);
                          ParInvalid := ParInvalid or CalculationStatusToError(ParVal.OrVal(vlVal)); ;
                  end
                   else begin
                        _IXor;
                        _RDirectAdd( vlVal,ParInvalid);
                          ParInvalid := ParInvalid or CalculationStatusToError(ParVal.XorVal(vlVal)); ;
                  end
                  ;  if vlVal <> nil then vlVal.Destroy; ;
            end;
      end;
      
      Procedure TELA_Parser._RCharConst ( var ParValue : TValue);
       
      var
      		vlNumber : TNumber;
      
      begin
            _ICharType;
            Expect(101);
            _RDirectNumber( vlNumber);
            Expect(102);
             
            if not(LargeInIntRange(vlNumber,0,255)) then SemError(Err_Num_Out_Of_range);
            ParValue := TString.Create(chr(vlNumber.vrNumber));
            ;
      end;
      
      Procedure TELA_Parser._RDirectExpr ( var ParVal:TValue);
       
      var
      	vlInvalid:boolean;
      
      begin
              vlInValid := false; ;
            _RDirectLogic( ParVal,vlInValid);
              if vlInValid then SemError(Err_Invalid_Operation); ;
      end;
      
      Procedure TELA_Parser._RDirectNumber ( var ParNum:TNumber);
       
      var
      	vlValue : TValue;
      
      begin
            _RDirectExpr( vlValue);
             
            if (vlValue<> nil) then begin
            	if vlValue.GetNumber(ParNum) then SemError(Err_Not_An_Integer_const);
            	vlValue.destroy;
            end else begin
            	LoadLong(ParNum , 0);
            end;
            ;
      end;
      
      Procedure TELA_Parser._IXor;
      begin
            Expect(100);
      end;
      
      Procedure TELA_Parser._IWith;
      begin
            Expect(99);
      end;
      
      Procedure TELA_Parser._IWhile;
      begin
            Expect(98);
      end;
      
      Procedure TELA_Parser._IVoidType;
      begin
            Expect(97);
      end;
      
      Procedure TELA_Parser._IWriteln;
      begin
            Expect(96);
      end;
      
      Procedure TELA_Parser._IWrite;
      begin
            Expect(95);
      end;
      
      Procedure TELA_Parser._IWhere;
      begin
            Expect(94);
      end;
      
      Procedure TELA_Parser._IVirtual;
      begin
            Expect(93);
      end;
      
      Procedure TELA_Parser._IUnion;
      begin
            Expect(89);
      end;
      
      Procedure TELA_Parser._IUntil;
      begin
            Expect(88);
      end;
      
      Procedure TELA_Parser._IType;
      begin
            Expect(87);
      end;
      
      Procedure TELA_Parser._IThen;
      begin
            Expect(86);
      end;
      
      Procedure TELA_Parser._ITo;
      begin
            Expect(85);
      end;
      
      Procedure TELA_Parser._IStep;
      begin
            Expect(84);
      end;
      
      Procedure TELA_Parser._IString;
      begin
            Expect(83);
      end;
      
      Procedure TELA_Parser._ISizeOf;
      begin
            Expect(82);
      end;
      
      Procedure TELA_Parser._ISigned;
      begin
            Expect(81);
      end;
      
      Procedure TELA_Parser._ISize;
      begin
            Expect(80);
      end;
      
      Procedure TELA_Parser._IShl;
      begin
            Expect(79);
      end;
      
      Procedure TELA_Parser._IShr;
      begin
            Expect(78);
      end;
      
      Procedure TELA_Parser._IRoot;
      begin
            Expect(77);
      end;
      
      Procedure TELA_Parser._IRepeat;
      begin
            Expect(76);
      end;
      
      Procedure TELA_Parser._IRecord;
      begin
            Expect(75);
      end;
      
      Procedure TELA_Parser._IRead;
      begin
            Expect(74);
      end;
      
      Procedure TELA_Parser._IPtr;
      begin
            Expect(73);
      end;
      
      Procedure TELA_Parser._IPrivate;
      begin
            Expect(71);
      end;
      
      Procedure TELA_Parser._IProtected;
      begin
            Expect(70);
      end;
      
      Procedure TELA_Parser._IProperty;
      begin
            Expect(69);
      end;
      
      Procedure TELA_Parser._IProcedure;
      begin
            Expect(67);
      end;
      
      Procedure TELA_Parser._IOwner;
      begin
            Expect(66);
      end;
      
      Procedure TELA_Parser._IOverride;
      begin
            Expect(65);
      end;
      
      Procedure TELA_Parser._IOverload;
      begin
            Expect(64);
      end;
      
      Procedure TELA_Parser._IOr;
      begin
            Expect(63);
      end;
      
      Procedure TELA_Parser._IOperator;
      begin
            Expect(62);
      end;
      
      Procedure TELA_Parser._IOf;
      begin
            Expect(61);
      end;
      
      Procedure TELA_Parser._IObject;
      begin
            Expect(60);
      end;
      
      Procedure TELA_Parser._INot;
      begin
            Expect(59);
      end;
      
      Procedure TELA_Parser._INumber;
      begin
            Expect(58);
      end;
      
      Procedure TELA_Parser._INil;
      begin
            Expect(57);
      end;
      
      Procedure TELA_Parser._IName;
      begin
            Expect(56);
      end;
      
      Procedure TELA_Parser._IMod;
      begin
            Expect(55);
      end;
      
      Procedure TELA_Parser._IMetaType;
      begin
            Expect(54);
      end;
      
      Procedure TELA_Parser._IMain;
      begin
            Expect(53);
      end;
      
      Procedure TELA_Parser._IIsolate;
      begin
            Expect(52);
      end;
      
      Procedure TELA_Parser._IInherited;
      begin
            Expect(51);
      end;
      
      Procedure TELA_Parser._IInherit;
      begin
            Expect(50);
      end;
      
      Procedure TELA_Parser._IInc;
      begin
            Expect(49);
      end;
      
      Procedure TELA_Parser._IIf;
      begin
            Expect(48);
      end;
      
      Procedure TELA_Parser._IHas;
      begin
            Expect(47);
      end;
      
      Procedure TELA_Parser._IFunction;
      begin
            Expect(46);
      end;
      
      Procedure TELA_Parser._IFrom;
      begin
            Expect(45);
      end;
      
      Procedure TELA_Parser._IFor;
      begin
            Expect(44);
      end;
      
      Procedure TELA_Parser._IFinal;
      begin
            Expect(43);
      end;
      
      Procedure TELA_Parser._ILeave;
      begin
            Expect(42);
      end;
      
      Procedure TELA_Parser._IExternal;
      begin
            Expect(41);
      end;
      
      Procedure TELA_Parser._IExit;
      begin
            Expect(40);
      end;
      
      Procedure TELA_Parser._IExact;
      begin
            Expect(39);
      end;
      
      Procedure TELA_Parser._IEnum;
      begin
            Expect(38);
      end;
      
      Procedure TELA_Parser._IElse;
      begin
            Expect(36);
      end;
      
      Procedure TELA_Parser._IDownTo;
      begin
            Expect(35);
      end;
      
      Procedure TELA_Parser._IDo;
      begin
            Expect(34);
      end;
      
      Procedure TELA_Parser._IDiv;
      begin
            Expect(33);
      end;
      
      Procedure TELA_Parser._IDestructor;
      begin
            Expect(32);
      end;
      
      Procedure TELA_Parser._IDefault;
      begin
            Expect(31);
      end;
      
      Procedure TELA_Parser._IDec;
      begin
            Expect(30);
      end;
      
      Procedure TELA_Parser._ICount;
      begin
            Expect(29);
      end;
      
      Procedure TELA_Parser._IContinue;
      begin
            Expect(28);
      end;
      
      Procedure TELA_Parser._IConstructor;
      begin
            Expect(27);
      end;
      
      Procedure TELA_Parser._IConst;
      begin
            Expect(26);
      end;
      
      Procedure TELA_Parser._IClass;
      begin
            Expect(25);
      end;
      
      Procedure TELA_Parser._ICharType;
      begin
            Expect(24);
      end;
      
      Procedure TELA_Parser._IBreak;
      begin
            Expect(22);
      end;
      
      Procedure TELA_Parser._IBetween;
      begin
            Expect(21);
      end;
      
      Procedure TELA_Parser._IBooleanType;
      begin
            Expect(20);
      end;
      
      Procedure TELA_Parser._IBegin;
      begin
            Expect(19);
      end;
      
      Procedure TELA_Parser._IAt;
      begin
            Expect(18);
      end;
      
      Procedure TELA_Parser._IAsciiz;
      begin
            Expect(17);
      end;
      
      Procedure TELA_Parser._IAsm;
      begin
            Expect(16);
      end;
      
      Procedure TELA_Parser._IAs;
      begin
            Expect(15);
      end;
      
      Procedure TELA_Parser._IArray;
      begin
            Expect(14);
      end;
      
      Procedure TELA_Parser._IAnd;
      begin
            Expect(13);
      end;
      
      Procedure TELA_Parser._IAbstract;
      begin
            Expect(11);
      end;
      
      Procedure TELA_Parser._RBlockOfCode ( ParNode : TNodeIdent);
      begin
            _RCodes( ParNode);
             
            if ParNode <> nil then ParNode.FinishNode(fNDCreator,true);
            ;
      end;
      
      Procedure TELA_Parser._RRoutine;
       
      var
      	vlPrn          : TRoutineNode;
      	vlMainCB       : TRoutine;
      	vlRoutine      : TRoutine;
      	vlPrvDefAccess : TDefAccess;
      	vlLevel        : cardinal;
      
      begin
             
                  vlPrvDefAccess := fNDCreator.fCurrentDefAccess;
                  vlMainCb   := nil;
            ;
            _RRoutineHeader( vlRoutine,false,vlLevel);
             
                  fNDCreator.fCurrentDefAccess := AF_Private;
                  vlMainCB := vlRoutine;
            ;
            WHILE vgDynSet[14].isSet(GetSym) do begin
                  case GetSym of
                        71 : begin
                              _IPrivate;
                               fNDCreator.fCurrentDefAccess := AF_Private; ;
                        end;
                        70 : begin
                              _IProtected;
                               fNDCreator.fCUrrentDefAccess := AF_Protected; ;
                        end;
                        69 : begin
                              _RProperty;
                        end;
                        92 : begin
                              _RVarBlock;
                        end;
                        87 : begin
                              _RTypeBlock;
                        end;
                         else begin
                              _RRoutine;
                        end;
                  end;
            end;
            if (GetSym = 19) then begin
                   
                  vlRoutine.PreBlockOfCode(fNDCreator);
                  vlMainCb := vlRoutine.fPhysicalAddress;
                  if vlMainCB <> nil then begin
                  	vlPrn    := vlMainCB.fStatements;
                  end else begin
                  	vlPrn := nil;
                  end;
                  ;
                  _RBlockOfCode( vlPrn);
                   
                  if vlMainCb <> nil then vlMainCB.CreatePostCode(fNDCreator);
                  if Rtm_Abstract in vlRoutine.fRoutineModes then  ErrorDef(Err_No_Main_For_Abstr_fun,vlroutine);
                  ;
            end
             else if (GetSym = 37) then begin
                    vlroutine.PreNoMain(fNDCreator); ;
                  _IEnd;
            end
            else begin
                  SynError(149);
            end;
            ;Expect(8);
             
            
            if vlRoutine <> nil then begin
            	 vlRoutine.SetIsDefined;
            	if vlRoutine.fStatements <> nil then vlRoutine.fStatements.ValidateAfter(fNDCreator);
            end;
            fNDCreator.fCurrentDefAccess := vlPrvDefAccess;
            fNDCreator.EndIdentNum(vlLevel);
            ;
      end;
      
      Procedure TELA_Parser._IEnd;
      begin
            Expect(37);
      end;
      
      Procedure TELA_Parser._RRoutineForward;
       
      var
      	vlDef      : TRoutine;
      	vlHasLevel : cardinal;
      
      begin
            _RRoutineHeader( vlDef,true,vlHasLevel);
             
            if vlDef <> nil then begin
            	if (RTM_Abstract in vlDef.fRoutineModes) then vlDef.SetIsDefined;
            end;
            fNDCreator.EndIdentNum(vlHasLevel);
            ;
      end;
      
      Procedure TELA_Parser._RConstant;
      begin
            _IConst;
            WHILE (GetSym = 1) do begin
                  _RConstantDecl;
                  Expect(8);
            end;
      end;
      
      Procedure TELA_Parser._RExternal;
       var
      vlIdent   : Tstring;
      vlExt     : TExternalInterface;
      vlType    : TExternalType;
      vlRoutine : TRoutine;
      vlCDecl   : boolean;
      vlAt      : cardinal;
      vlHasAt   : boolean;
      vlHasses  : cardinal;
      vlExType : TString;
      vlName    : TString;
      vlCDeclTxt: TString;
      vlStr     : string;
      
      begin
             
            vlHasAt := false;
            vlAt    := 0;
            vlType  := ET_Error;
            vlCDecl := false;
            vlCDeclTxt := nil;
            ;
            _IExternal;
            _RConstantStringExpr( vlExType);
             
            		vlType := ET_Error;
            		if vlExType <> nil then begin
            			vlExType.ToUpper;
            			if vlExType.IsEqualStr(Ext_Linked) then vlType := ET_Linked;
            			if vlExType.IsEqualStr(Ext_Dll) then vlType := ET_Dll;
            		end;
            		if vlType = ET_Error then begin
            			vlType := ET_Linked;
            			EmptyString(vlStr);
            			if (vlExType <> nil) then vlExType.GetString(vlStr);
            			ErrorText(Err_Wrong_External_Type,vlStr);
            		end;
            		if(vlExType <> nil) then vlExType.Destroy;
            	;
            if (GetSym = 18) then begin
                  _IAt;
                  _RDirectCardinal( vlAt);
                    vlHasAt := true; ;
            end;
            _RConstantStringExpr( vlName);
             
            			vlExt := CreateExternalInterface(vlName,vlType,vlHasAt,vlAt);
            		;
            if vgDynSet[15].isSet(GetSym) then begin
                  if (GetSym = 23) then begin
                        _ICDecl;
                          vlCDecl := true;;
                  end
                   else begin
                        _RConstantStringExpr( vlCDeclTxt);
                         
                        				if vlCDeclTxt <> nil then begin
                        					vlCDeclTxt.ToUpper;
                        					if vlCDeclTxt.IsEqualStr(Ext_Normal) then begin
                        						vlCDecl := false
                        					end else if vlCDeclTxt.IsEqualStr(Ext_CDecl) then begin
                        						vlCDecl := true;
                        					end else begin
                        						vlCDeclTxt.GetString(vlStr);
                        						ErrorText(Err_Wrong_Calling_Type,vlStr);
                        					end;
                        					vlCDeclTxt.Destroy;
                        				end;
                        			;
                  end
                  ;end;
            WHILE (GetSym in [46 , 67]) do begin
                  if (GetSym = 67) then begin
                        _RProcedureHead( vlRoutine,vlHasses);
                  end
                   else begin
                        _RFunctionHead( vlRoutine,vlHasses);
                  end
                  ;_IName;
                  _RConstantStringExpr( vlIdent);
                  Expect(8);
                   
                         if vlRoutine <>  nil then begin
                  			fNDCreator.EndIdentNum(vlHasses);
                  			vlRoutine.PreProcessParameterList(nil,nil,fNDcreator);
                  			CreateExternalInterfaceObject(vlCDecl,vlRoutine,vlExt,vlIdent);
                  		end;
                  	;
            end;
            _IEnd;
            Expect(8);
              if vlExt <> nil then Endident; ;
      end;
      
      Procedure TELA_Parser._RTypeBlock;
      begin
            _IType;
            if (GetSym = 1) then begin
                  _RTypeDecl;
            end
             else if (GetSym = 12) then begin
                  _RAlign;
            end
            else begin
                  SynError(150);
            end;
            ;WHILE (GetSym in [1 , 12]) do begin
                  if (GetSym = 1) then begin
                        _RTypeDecl;
                  end
                   else begin
                        _RAlign;
                  end
                  ;end;
              fNDCreator.BindForward; ;
      end;
      
      Procedure TELA_Parser._ICDecl;
      begin
            Expect(23);
      end;
      
      Procedure TELA_Parser._IPublic;
      begin
            Expect(72);
      end;
      
      Procedure TELA_Parser._ELA;
       
      var
      vlPrn       : TRoutineNode;
       vlRoutine   : TStartupProc;
       vlHasPublic : boolean;
       vlSetMang   : boolean;
      
      begin
             
              vlHasPublic := false;
              fNDCreator.AutoLoadModule;
            ;
            if (GetSym in [68 , 90]) then begin
                  _RMod_Type;
            end;
            if (GetSym = 91) then begin
                  _RUseBlock;
            end;
             
            if not SuccessFul then exit;
            fNDCreator.ProcessUseClause;
            if not SuccessFul then exit;
            Bind;
            if not successful then exit;
            ;
            WHILE (GetSym = 72) do begin
                  _IPublic;
                    vlSetMang := false; ;
                  if (GetSym = 23) then begin
                        _ICDecl;
                          vlSetMang := true;   ;
                  end;
                   
                  vlHasPublic := true;
                  fNDCreator.SetCurrentDefModes([DM_CPublic],vlSetMang);
                  fNDCreator.fInPublicSection  := true;
                  fNDCreator.fCUrrentDefAccess := AF_Public;
                  ;
                  WHILE vgDynSet[16].isSet(GetSym) do begin
                        if (GetSym = 87) then begin
                              _RTypeBlock;
                        end
                         else if (GetSym = 92) then begin
                              _RVarBlock;
                        end
                         else if (GetSym = 41) then begin
                              _RExternal;
                        end
                         else if (GetSym = 26) then begin
                              _RConstant;
                        end
                         else begin
                              _RRoutineForward;
                        end
                        ;end;
                  _IEnd;
                  _IPublic;
            end;
             
            fNdCreator.fCurrentDefAccess := AF_Private;
            fNDCreator.fInPublicSection  := false;
            fNDCreator.SetCurrentDefModes([DM_CPublic],false);
            if not(fNDCreator.GetIsUnitFlag) and (vlHasPublic) then SemError(Err_Prog_Cant_Have_Pubs) else
            if fNDCreator.GetIsUnitFlag and not(vlHasPublic) then SemError(Err_Unit_Must_Have_Pubs);
            ;
            WHILE vgDynSet[16].isSet(GetSym) do begin
                  if (GetSym = 87) then begin
                        _RTypeBlock;
                  end
                   else if (GetSym = 92) then begin
                        _RVarBlock;
                  end
                   else if (GetSym in [27 , 32 , 46 , 62 , 67]) then begin
                        _RRoutine;
                  end
                   else if (GetSym = 41) then begin
                        _RExternal;
                  end
                   else begin
                        _RConstant;
                  end
                  ;end;
             
            vlRoutine := TStartupProc.Create(fNDCreator.fCollection,fNDCreator.GetIsUnitFlag);
            vlRoutine.SetIsDefined;
            fNDCreator.fCurrentDefAccess := AF_Public;
            fNDCreator.AddRoutineItem(vlRoutine);
            fNDCreator.AddCurrentDefinition(vlRoutine);
            vlPrn   := TRoutineNode.Create(vlRoutine);
            ;
            if (GetSym = 19) then begin
                  _RBlockOfCode( vlPrn);
            end
             else if (GetSym = 37) then begin
                  _IEnd;
                    if (not fNDCreator.GetIsUnitFlag) then SemError(Err_Program_Needs_Main); ;
            end
            else begin
                  SynError(151);
            end;
            ;Expect(7);
             
            					   vlRoutine.fStatements := vlPrn;
            					   if vlPrn <> nil then vlPrn.ValidateAfter(fNDCreator);
            					   fNDCreator.EndIdent;
            					   WriteResFile;
            
            ;
      end;
      
      Procedure TELA_Parser._IProgram;
      begin
            Expect(68);
      end;
      
      Procedure TELA_Parser._IUnit;
      begin
            Expect(90);
      end;
      
      Procedure TELA_Parser._RMod_Type;
      begin
            if (GetSym = 90) then begin
                  _IUnit;
                     fNDCreator.SetIsUnitFlag(true); ;
            end
             else if (GetSym = 68) then begin
                  _IProgram;
            end
            else begin
                  SynError(152);
            end;
            ;Expect(8);
      end;
      
      Procedure TELA_Parser._IVar;
      begin
            Expect(92);
      end;
      
      Procedure TELA_Parser._RVarBlock;
      begin
            _IVar;
            WHILE (GetSym in [1 , 12]) do begin
                  if (GetSym = 1) then begin
                        _RVarDecl;
                  end
                   else begin
                        _RAlign;
                  end
                  ;end;
      end;
      
      Procedure TELA_Parser._RUsableType ( var ParType : TType);
      begin
             
            ParType := nil;
            ;
            if vgDynSet[17].isSet(GetSym) then begin
                  if (GetSym = 1) then begin
                        _RH_Type( ParType);
                  end
                   else begin
                        _RAnonymousType( ParType);
                  end
                  ;Expect(8);
            end
             else if (GetSym in [46 , 60 , 67]) then begin
                  _RRoutineTypeDecl( ParType);
                    AddAnonItem(ParType); ;
            end
            else begin
                  SynError(153);
            end;
            ;end;
      
      Procedure TELA_Parser._RVarDecl;
       
      var
      	vlIdent : string;
      	vlName  : TNameList;
      	vlTYpe  : TType;
      
      begin
             
            vlName := TNameList.Create;
             vlType := nil;
            ;
            _RIdent( vlIdent);
              vlName.AddName(vlIdent);;
            WHILE (GetSym = 9) do begin
                  Get;
                  _RIdent( vlIdent);
                    vlName.AddName(vlIdent);;
            end;
            Expect(10);
            _RUsableType( vlType);
             
            AddVar(vlName,vlType);
            vlName.destroy;
            ;
      end;
      
      Procedure TELA_Parser._IUses;
      begin
            Expect(91);
      end;
      
      Procedure TELA_Parser._RUseBlock;
      begin
            _IUses;
            _RUsedUnit;
            WHILE (GetSym = 9) do begin
                  Get;
                  _RUsedUnit;
            end;
            Expect(8);
      end;
      
      Procedure TELA_Parser._RUsedUnit;
       
      var
      	vlName:string;
      
      begin
            _RIdent( vlName);
             
            		LowerStr(vlName);
            		fNDCreator.AddUnitInUse(vlName);
            	 ;
      end;
      
      Procedure TELA_Parser._RDirectCardinal ( var ParNum : cardinal);
       
      var
         vlNum : TNumber;
      
      begin
            _RDirectNumber( vlNum);
             
            if not(LargeInRange(vlNum ,Min_Cardinal, Max_Cardinal)) then SemError(Err_Num_Out_Of_Range);
            ParNum := LargeToCardinal(vlNum);
            ;
      end;
      
      Procedure TELA_Parser._IAlign;
      begin
            Expect(12);
      end;
      
      Procedure TELA_Parser._RAlign;
       
      var
      	vlAlign : TSize;
      
      begin
            _IAlign;
            _RDirectCardinal( vlAlign);
            Expect(8);
              GetConfig.SetAlign(vlAlign);;
      end;
      
      Procedure TELA_Parser._RDefIdentObj ( var ParDef : TDefinition;ParAccCheck : boolean);
       
      var
      	vlName  : string;
      	vlOwner : TDefinition;
      
      begin
            _RIdentObj( ParDef);
            WHILE (GetSym = 7) do begin
                  Get;
                  _RIdent( vlName);
                   
                  if ParDef <> nil then begin
                  	ParDef.GetPtrByName(vlName,[SO_Local],vlOwner,ParDef);
                  	if ParDef = nil then ErrorText(Err_Unkown_Ident,vlName);
                  end;
                  ;
            end;
             
            if(ParAccCheck) then fNDCreator.CheckAccessLevel(ParDef);
            ;
      end;
      
      Procedure TELA_Parser._RIdentObj ( var ParDef:TDefinition);
       
      var
      	vlname:string;
      
      begin
            _RIdent( vlName);
             
            ParDef := fNDCreator.GetPtr(vlName);
            if ParDef = nil then ErrorText(Err_Unkown_Ident,vlName);
            ;
      end;
      
      Procedure TELA_Parser._RNumber ( var ParNum : TNumber;var ParValid : boolean);
      begin
              	 loadlong(ParNum,0); ;
            if (GetSym = 3) then begin
                  _RDec_Number( ParNum,ParValid);
            end
             else if (GetSym = 5) then begin
                  _RBin_Number( ParNum,ParValid);
            end
             else if (GetSym = 4) then begin
                  _RHex_Number( ParNum,ParValid);
            end
            else begin
                  SynError(154);
            end;
            ;end;
      
      Procedure TELA_Parser._RDec_Number ( var ParNum:TNumber; var ParValid:boolean);
       
      var
      vlTmp : String;
      
      begin
            Expect(3);
             
            LexName(vlTmp);
            ParValid := not(StringToLarge(vlTmp, ParNum));
            if not ParValid then LoadLOng(ParNum,1);
            ;
      end;
      
      Procedure TELA_Parser._RBin_Number ( var ParNum:TNumber;var ParValid : boolean);
       
      var
      vlTmp:string;
      vlErr:boolean;
      
      begin
            Expect(5);
             
            LexName(vlTmp);
            delete(vlTmp,1,2);
            ParNum := BinToLongint(vlTmp,vlErr);
            ParValid := not vlErr;
            ;
      end;
      
      Procedure TELA_Parser._RHex_Number ( var ParNum:TNumber;var ParValid : boolean);
       
      var vlTmp : string;
         vlErr : boolean;
      
      begin
            Expect(4);
             
            LexName(vlTmp);
            delete(vlTmp,1,1);
            ParNum := HexToLongint(vlTmp,vlErr);
            ParValid := not vLErr;
            ;
      end;
      
      Procedure TELA_Parser._RText ( var ParString : string);
      begin
            if (GetSym = 2) then begin
                  _RString( ParString);
            end
             else if (GetSym = 6) then begin
                  _RConfigVar( ParString);
            end
            else begin
                  SynError(155);
            end;
            ;end;
      
      Procedure TELA_Parser._RString ( var ParString:String);
      begin
            Expect(2);
             
            LexString(ParString);
            ParString := copy(ParString,2,length(PArString)-2);
            ;
      end;
      
      Procedure TELA_Parser._RIdent ( var ParIdent:string);
      begin
            Expect(1);
              LexName(ParIdent); ;
      end;
      
      Procedure TELA_Parser._RConfigVar ( var ParString : string);
       
      var
      	vlIdent :string;
      
      begin
            Expect(6);
            _RIdent( vlIdent);
                if not(GetConfig.GetVarValue(vlIdent,ParString)) then ErrorText(Err_Unkown_COnfig_Variable,vlIdent); ;
      end;
      
      procedure TELA_Parser.Parse;
      begin
            MaxT :=119;
            SetupCompiler;
             Get;
            _ELA;
      end;
      procedure   TELA_Parser.GetErrorText(ParNo:longint;var ParErr:string);
      begin
            case ParNo of
                  		0: ParErr :='EOF expected';
                  		1: ParErr :='identifier expected';
                  		2: ParErr :='string expected';
                  		3: ParErr :='integer number expected';
                  		4: ParErr :='hexidecimal number expected';
                  		5: ParErr :='binary number  expected';
                  		6: ParErr :='"&" expected';
                  		7: ParErr :='"." expected';
                  		8: ParErr :='";" expected';
                  		9: ParErr :='"," expected';
                  		10: ParErr :='":" expected';
                  		11: ParErr :='"ABSTRACT" expected';
                  		12: ParErr :='"ALIGN" expected';
                  		13: ParErr :='"AND" expected';
                  		14: ParErr :='"ARRAY" expected';
                  		15: ParErr :='"AS" expected';
                  		16: ParErr :='"ASM" expected';
                  		17: ParErr :='"ASCIIZ" expected';
                  		18: ParErr :='"AT" expected';
                  		19: ParErr :='"BEGIN" expected';
                  		20: ParErr :='"BOOLEANTYPE" expected';
                  		21: ParErr :='"BETWEEN" expected';
                  		22: ParErr :='"BREAK" expected';
                  		23: ParErr :='"CDECL" expected';
                  		24: ParErr :='"CHARTYPE" expected';
                  		25: ParErr :='"CLASS" expected';
                  		26: ParErr :='"CONST" expected';
                  		27: ParErr :='"CONSTRUCTOR" expected';
                  		28: ParErr :='"CONTINUE" expected';
                  		29: ParErr :='"COUNT" expected';
                  		30: ParErr :='"DEC" expected';
                  		31: ParErr :='"DEFAULT" expected';
                  		32: ParErr :='"DESTRUCTOR" expected';
                  		33: ParErr :='"DIV" expected';
                  		34: ParErr :='"DO" expected';
                  		35: ParErr :='"DOWNTO" expected';
                  		36: ParErr :='"ELSE" expected';
                  		37: ParErr :='"END" expected';
                  		38: ParErr :='"ENUM" expected';
                  		39: ParErr :='"EXACT" expected';
                  		40: ParErr :='"EXIT" expected';
                  		41: ParErr :='"EXTERNAL" expected';
                  		42: ParErr :='"LEAVE" expected';
                  		43: ParErr :='"FINAL" expected';
                  		44: ParErr :='"FOR" expected';
                  		45: ParErr :='"FROM" expected';
                  		46: ParErr :='"FUNCTION" expected';
                  		47: ParErr :='"HAS" expected';
                  		48: ParErr :='"IF" expected';
                  		49: ParErr :='"INC" expected';
                  		50: ParErr :='"INHERIT" expected';
                  		51: ParErr :='"INHERITED" expected';
                  		52: ParErr :='"ISOLATE" expected';
                  		53: ParErr :='"MAIN" expected';
                  		54: ParErr :='"METATYPE" expected';
                  		55: ParErr :='"MOD" expected';
                  		56: ParErr :='"NAME" expected';
                  		57: ParErr :='"NIL" expected';
                  		58: ParErr :='"NUMBER" expected';
                  		59: ParErr :='"NOT" expected';
                  		60: ParErr :='"OBJECT" expected';
                  		61: ParErr :='"OF" expected';
                  		62: ParErr :='"OPERATOR" expected';
                  		63: ParErr :='"OR" expected';
                  		64: ParErr :='"OVERLOAD" expected';
                  		65: ParErr :='"OVERRIDE" expected';
                  		66: ParErr :='"OWNER" expected';
                  		67: ParErr :='"PROCEDURE" expected';
                  		68: ParErr :='"PROGRAM" expected';
                  		69: ParErr :='"PROPERTY" expected';
                  		70: ParErr :='"PROTECTED" expected';
                  		71: ParErr :='"PRIVATE" expected';
                  		72: ParErr :='"PUBLIC" expected';
                  		73: ParErr :='"PTR" expected';
                  		74: ParErr :='"READ" expected';
                  		75: ParErr :='"RECORD" expected';
                  		76: ParErr :='"REPEAT" expected';
                  		77: ParErr :='"ROOT" expected';
                  		78: ParErr :='"SHR" expected';
                  		79: ParErr :='"SHL" expected';
                  		80: ParErr :='"SIZE" expected';
                  		81: ParErr :='"SIGNED" expected';
                  		82: ParErr :='"SIZEOF" expected';
                  		83: ParErr :='"STRING" expected';
                  		84: ParErr :='"STEP" expected';
                  		85: ParErr :='"TO" expected';
                  		86: ParErr :='"THEN" expected';
                  		87: ParErr :='"TYPE" expected';
                  		88: ParErr :='"UNTIL" expected';
                  		89: ParErr :='"UNION" expected';
                  		90: ParErr :='"UNIT" expected';
                  		91: ParErr :='"USES" expected';
                  		92: ParErr :='"VAR" expected';
                  		93: ParErr :='"VIRTUAL" expected';
                  		94: ParErr :='"WHERE" expected';
                  		95: ParErr :='"WRITE" expected';
                  		96: ParErr :='"WRITELN" expected';
                  		97: ParErr :='"VOIDTYPE" expected';
                  		98: ParErr :='"WHILE" expected';
                  		99: ParErr :='"WITH" expected';
                  		100: ParErr :='"XOR" expected';
                  		101: ParErr :='"(" expected';
                  		102: ParErr :='")" expected';
                  		103: ParErr :='"+" expected';
                  		104: ParErr :='"-" expected';
                  		105: ParErr :='"*" expected';
                  		106: ParErr :='"=" expected';
                  		107: ParErr :='"[" expected';
                  		108: ParErr :='"]" expected';
                  		109: ParErr :='":=" expected';
                  		110: ParErr :='">" expected';
                  		111: ParErr :='">=" expected';
                  		112: ParErr :='"<=" expected';
                  		113: ParErr :='"<" expected';
                  		114: ParErr :='"<>" expected';
                  		115: ParErr :='"#" expected';
                  		116: ParErr :='"@" expected';
                  		117: ParErr :='"^" expected';
                  		118: ParErr :='">>" expected';
                  		119: ParErr :='not expected';
                  		120: ParErr :='Invalid short nested Routine:"BEGIN","@","-","+","(","SIZEOF'
                  			+'","OWNER","NOT","NIL","INHERITED","&",binary number ,hexidec'
                  			+'imal number,integer number,string,identifier expected';
                  		121: ParErr :='Invalid inherited:"OF",identifier expected';
                  		122: ParErr :='Invalid formula:"OWNER",identifier,"INHERITED",binary number'
                  			+' ,hexidecimal number,integer number,"&",string,"NIL","NOT","'
                  			+'SIZEOF","(" expected';
                  		123: ParErr :='Invalid expression:identifier,"&",string expected';
                  		124: ParErr :='Invalid syntax:":=","ELSE",";" expected';
                  		125: ParErr :='Invalid code item:"@","-","+","(","SIZEOF","OWNER","NOT","NI'
                  			+'L","INHERITED","&",binary number ,hexidecimal number,integer'
                  			+' number,string,identifier,"ASM","BREAK","CONTINUE" etc... ex'
                  			+'pected';
                  		126: ParErr :='Invalid increment/decrement statement:"INC","DEC" expected';
                  		127: ParErr :='Invalid increment/decrement statement:"WITH","ELSE",";" expe'
                  			+'cted';
                  		128: ParErr :='Invalid write statement:"WRITE","WRITELN" expected';
                  		129: ParErr :='Invalid routine header:"PROCEDURE","FUNCTION","DESTRUCTOR","'
                  			+'CONSTRUCTOR","OPERATOR" expected';
                  		130: ParErr :='Invalid routine header:"NAME","EXACT",";" expected';
                  		131: ParErr :='Invalid parameter mapping item:"@",identifier,"-","+","CHART'
                  			+'YPE","&",binary number ,hexidecimal number,integer number,st'
                  			+'ring expected';
                  		132: ParErr :='Invalid routine header:"CONSTRUCTOR","DESTRUCTOR" expected';
                  		133: ParErr :='Invalid operator header:"+","-","*","DIV","XOR","MOD","OR","'
                  			+'AND","=",">",">=","<=","<","<>",":=","BETWEEN","#","SHL","SH'
                  			+'R",identifier expected';
                  		134: ParErr :='Invalid operator header:"-","NOT","(" expected';
                  		135: ParErr :='Invalid routine name:"PRIVATE","PROTECTED","(",":",";" expec'
                  			+'ted';
                  		136: ParErr :='Invalid property definition:"READ","WRITE" expected';
                  		137: ParErr :='Invalid class definition:"VAR","TYPE","PUBLIC","PRIVATE","PR'
                  			+'OTECTED","PROPERTY","PROCEDURE","OPERATOR","INHERIT","FUNCTI'
                  			+'ON","END","DESTRUCTOR","CONSTRUCTOR","CONST",";" expected';
                  		138: ParErr :='Invalid type declaration:"NUMBER",identifier,"VOIDTYPE","CHA'
                  			+'RTYPE","ENUM","PTR","STRING","ASCIIZ","UNION","VIRTUAL","OVE'
                  			+'RRIDE","ISOLATE","CLASS","RECORD" expected';
                  		139: ParErr :='Invalid type declaration:"VOIDTYPE","VIRTUAL","UNION","STRIN'
                  			+'G","RECORD","PTR","OVERRIDE","NUMBER","ISOLATE","ENUM","CLAS'
                  			+'S","CHARTYPE","BOOLEANTYPE","ASCIIZ","ARRAY",identifier etc.'
                  			+'.. expected';
                  		140: ParErr :='Invalid RAnonymousType:"ARRAY","NUMBER","ASCIIZ","STRING","P'
                  			+'TR","RECORD","UNION" expected';
                  		141: ParErr :='Invalid RPtrTypeDecl:"UNION","STRING","RECORD","PTR","NUMBER'
                  			+'","ASCIIZ","ARRAY",identifier expected';
                  		142: ParErr :='Invalid type definition:"PROCEDURE","FUNCTION" expected';
                  		143: ParErr :='Invalid type:identifier,"STRING","PTR","NUMBER","ASCIIZ" exp'
                  			+'ected';
                  		144: ParErr :='Invalid identifier:"-","+",binary number ,hexidecimal number'
                  			+',integer number,"CHARTYPE","&",string expected';
                  		145: ParErr :='Invalid string constant:"CHARTYPE","&",string expected';
                  		146: ParErr :='Invalid string constant:"CHARTYPE","&",string,identifier,"("'
                  			+' expected';
                  		147: ParErr :='Invalid identifier:binary number ,hexidecimal number,integer'
                  			+' number,identifier,"CHARTYPE","&",string expected';
                  		148: ParErr :='Invalid formula:"CHARTYPE","&",binary number ,hexidecimal nu'
                  			+'mber,integer number,string,identifier,"(","NIL","NOT","SIZEO'
                  			+'F" expected';
                  		149: ParErr :='Invalid routine:"BEGIN","END" expected';
                  		150: ParErr :='Invalid type declaration:identifier,"ALIGN" expected';
                  		151: ParErr :='Invalid program definition:"BEGIN","END" expected';
                  		152: ParErr :='Invalid module type specification:"UNIT","PROGRAM" expected';
                  		153: ParErr :='Invalid type definition:"UNION","STRING","RECORD","PTR","NUM'
                  			+'BER","ASCIIZ","ARRAY",identifier,"PROCEDURE","OBJECT","FUNCT'
                  			+'ION" expected';
                  		154: ParErr :='Invalid number:integer number,binary number ,hexidecimal num'
                  			+'ber expected';
                  		155: ParErr :='Invalid string:string,"&" expected';
            end;
      end;
      
      destructor  TELA_Parser.destroy;
      begin
            inherited destroy;
            DestroyDynSet(vgDynSet);
      end;
      
      const
      vgSetFill0:ARRAY[1..1] of cardinal=(0);
      vgSetFill1:ARRAY[1..15] of cardinal=(1,2,3,4,5,6,51,57,59,66,82,101,103,104,116);
      vgSetFill2:ARRAY[1..6] of cardinal=(1,27,32,46,62,67);
      vgSetFill3:ARRAY[1..6] of cardinal=(106,110,111,112,113,114);
      vgSetFill4:ARRAY[1..30] of cardinal=(1,2,3,4,5,6,16,19,22,28,29,30,40,42,44,48,49,51,57,59,66,76,82,95,96,98,101,103,104,116);
      vgSetFill5:ARRAY[1..12] of cardinal=(26,27,32,46,53,62,67,69,70,71,87,92);
      vgSetFill6:ARRAY[1..8] of cardinal=(2,3,4,5,6,24,103,104);
      vgSetFill7:ARRAY[1..118] of cardinal=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119);
      vgSetFill8:ARRAY[1..14] of cardinal=(26,27,32,37,46,50,62,67,69,70,71,72,87,92);
      vgSetFill9:ARRAY[1..12] of cardinal=(26,27,32,46,62,67,69,70,71,72,87,92);
      vgSetFill10:ARRAY[1..16] of cardinal=(1,14,17,20,24,25,38,52,58,65,73,75,83,89,93,97);
      vgSetFill11:ARRAY[1..14] of cardinal=(1,17,24,25,38,52,58,65,73,75,83,89,93,97);
      vgSetFill12:ARRAY[1..7] of cardinal=(14,17,58,73,75,83,89);
      vgSetFill13:ARRAY[1..7] of cardinal=(1,2,3,4,5,6,24);
      vgSetFill14:ARRAY[1..10] of cardinal=(27,32,46,62,67,69,70,71,87,92);
      vgSetFill15:ARRAY[1..6] of cardinal=(1,2,6,23,24,101);
      vgSetFill16:ARRAY[1..9] of cardinal=(26,27,32,41,46,62,67,87,92);
      vgSetFill17:ARRAY[1..8] of cardinal=(1,14,17,58,73,75,83,89);
      
      
      procedure TELA_Parser.Commonsetup;
      begin
            
            inherited Commonsetup;
            iCase := false;
            
            MaxT := 119;
            CreateDynSet(vgDynSet);
            if fOwnDynset then begin
                  vgDynSet[0].SetByArray(vgSetFill0);
                  vgDynSet[1].SetByArray(vgSetFill1);
                  vgDynSet[2].SetByArray(vgSetFill2);
                  vgDynSet[3].SetByArray(vgSetFill3);
                  vgDynSet[4].SetByArray(vgSetFill4);
                  vgDynSet[5].SetByArray(vgSetFill5);
                  vgDynSet[6].SetByArray(vgSetFill6);
                  vgDynSet[7].SetByArray(vgSetFill7);
                  vgDynSet[8].SetByArray(vgSetFill8);
                  vgDynSet[9].SetByArray(vgSetFill9);
                  vgDynSet[10].SetByArray(vgSetFill10);
                  vgDynSet[11].SetByArray(vgSetFill11);
                  vgDynSet[12].SetByArray(vgSetFill12);
                  vgDynSet[13].SetByArray(vgSetFill13);
                  vgDynSet[14].SetByArray(vgSetFill14);
                  vgDynSet[15].SetByArray(vgSetFill15);
                  vgDynSet[16].SetByArray(vgSetFill16);
                  vgDynSet[17].SetByArray(vgSetFill17);
            end;
      end;
end
.