UNIT ELAP;
{ =========================================}
{This file is generated, Please don''t edit}
{ =========================================}



Interface

Uses dynset,cmp_base,confval,error,types,stdobj,asminfo,vars,display,elacons,formbase,cblkbase,
     compbase,procs,elaTypes,node,extern,ddefinit,doperfun,params,elacfg,progutil,classes,
     nif,nlinenum,naddsub,execobj,exprdigi,largenum,blknodes,stmnodes, ELAS,ELA_cons,ELA_user;

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
      Procedure _RIdentObject ( ParLocal :TDefinition;var ParDef : TDefinition;var ParDigi : TIdentDigiItem;var ParMention : TMN_Type);
      Procedure _RInherited ( var ParDigi : TDigiItem);
      Procedure _ROwner ( var ParLocal : TDefinition);
      Procedure _RShortDRoutine ( ParRoutine : TDefinition;ParItem :TIdentHookDigiItem);
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
      Procedure _RCodes ( var ParNode:TSubListStatementNode);
      Procedure _RLeave ( var ParNode : TNodeIdent);
      Procedure _RExprDigi ( var ParExpr : TDigiItem);
      Procedure _RLoad ( var Parexp:TFormulaNode);
      Procedure _RRepeat ( var ParNode:TSubListStatementNode);
      Procedure _RIf ( var ParNode:TSubListStatementNode);
      Procedure _RFor ( var ParNode :TSubListStatementnode);
      Procedure _RExpr ( var ParExpr : TFormulaNode);
      Procedure _RCount ( var ParNode:TSubListStatementNode);
      Procedure _RCode ( ParNode:TSubListStatementNode);
      Procedure _RWhile ( var ParNode:TSubListStatementNode);
      Procedure _RExit ( var ParNode:TNodeIdent);
      Procedure _RFormula ( var ParExp:TFormulaNode);
      Procedure _RIncDec ( var ParNode : TSubListStatementNode);
      Procedure _RParam ( var ParExpr : TFormulaNode;var ParName : ansistring);
      Procedure _RWrite ( ParNode:TSubListStatementNode);
      Procedure _RContinue ( var ParNode : TSubListStatementNode);
      Procedure _RBreak ( var ParNode : TSubListStatementNode);
      Procedure _RRoutineHeader ( var ParRoutine:TRoutine;ParForward:boolean;var ParLevel : cardinal);
      Procedure _RParameterMapping ( var ParRoutine :TRoutine);
      Procedure _RParameterMappingItem ( ParRoutine :TRoutine);
      Procedure _RAsmBlock ( var ParNode:TNodeIdent);
      Procedure _RFunctionHead ( var ParRoutine:TRoutine;var ParHasses : cardinal);
      Procedure _RConstructorHead ( var ParRoutine : TRoutine;var ParHasses : cardinal);
      Procedure _ROperatorHead ( var ParRoutine:TRoutine);
      Procedure _ROperParDef ( ParRoutine:TRoutine);
      Procedure _RProcedureHead ( var ParRoutine:TRoutine;var ParHasses : cardinal);
      Procedure _RRoutineName ( var ParName : ansistring;var ParAccess : TDefAccess;var ParHasses:cardinal);
      Procedure _RRoutineDotName ( var ParName : ansistring;var ParHasses : cardinal);
      Procedure _RParamVarDef ( vlRoutine:TRoutine;var vlVirCheck:boolean);
      Procedure _RProperty;
      Procedure _RClassType ( const ParName : ansistring;var ParType : TType);
      Procedure _RTypeDecl;
      Procedure _RTypeAs ( var ParType : TType);
      Procedure _RAnonymousType ( var ParTYpe : TType);
      Procedure _RPtrTypeDecl ( var ParType:TType;ParCanForward : boolean);
      Procedure _RCharDecl ( var ParType:TType);
      Procedure _RVoidTypeDecl ( var Partype:TType);
      Procedure _RParamDef ( ParRoutine:TRoutine);
      Procedure _RRoutineTypeDecl ( var ParType:TType);
      Procedure _ROrdDecl ( var ParType:TType);
      Procedure _RStringTypeDecl ( var ParType:TType);
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
      Procedure _RH_Type ( var ParType:TType);
      Procedure _RNum_Or_Const ( var ParVal:TValue;var ParValid : boolean);
      Procedure _RDirectFact ( var ParVal:TValue;var ParValid:boolean);
      Procedure _RDirectNeg ( var ParVal : TValue;var ParValid : boolean);
      Procedure _RDirectMul ( var ParVal:TValue;var ParValid:boolean);
      Procedure _RDirectAdd ( var ParVal:TValue;var ParValid:boolean);
      Procedure _RDirectLogic ( var ParVal : TValue;var ParValid:boolean);
      Procedure _RDirectExpr ( var ParVal:TValue);
      Procedure _RDirectString ( var ParStr : AnsiString);
      Procedure _RNumberConstant ( var ParValue : TValue;var ParValid : boolean);
      Procedure _RStringConstant ( var ParValue : TValue);
      Procedure _RDirectNumber ( var ParNum:TNumber);
      Procedure _RCharConst ( var ParValue : TValue);
      Procedure _IXor;
      Procedure _IWith;
      Procedure _IWhile;
      Procedure _IVoidType;
      Procedure _IWriteln;
      Procedure _IWrite;
      Procedure _IWhere;
      Procedure _IVirtual;
      Procedure _IValue;
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
      Procedure _IAll;
      Procedure _IAbstract;
      Procedure _RBlockOfCode ( ParNode : TSubListStatementNode);
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
      Procedure _RText ( var ParString : ansistring);
      Procedure _RString ( var ParString:ansistring);
      Procedure _RIdent ( var ParIdent:ansistring);
      Procedure _RConfigVar ( var ParString : ansistring);
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
            if (GetSym = 67) then begin
                  _ROwner( vlLocal);
            end;
            _RIdentObject( vlLocal,vlDef,vlDigi,vlMention);
             
            ParDigi := TIdentHookDigiItem.Create(vlDigi);
            ParDigi.fLocal := vlLocal;
             SetDigiPos(ParDigi);
            ;
            if (GetSym = 103) then begin
                  _RParameters( ParDigi);
            end;
            if (GetSym = 96) then begin
                  _RShortDRoutine( vlDef,ParDigi);
            end;
      end;
      
      Procedure TELA_Parser._RShortProcDef ( ParRoutine : TRoutine);
       
      var
      vlRoutine : TRoutine;
      vlNode    : TFormulaNode;
      vlError   : boolean;
      vlPrn     : TRoutineNode;
      vlName    : ansistring;
      vlLineInfo : TNodeident;
      
      begin
            _RIdent( vlName);
             
            vlNode  := nil;
            vlPrn   := nil;
            CreateShortSubCB(ParRoutine,vlName,vlRoutine,vlError);
            ;
            if (GetSym = 103) then begin
                  _RParamDef( vlRoutine);
            end;
              vlPrn := ProcessShortSubCb(vlRoutine); ;
            Expect(10);
            if (GetSym = 20) then begin
                  _RBlockOfCode( vlPrn);
                   vlPrn.FinishNode(fNDCreator,true);;
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
                  SynError(122);
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
          vlName : ansistring;
      
      begin
            Expect(103);
            _RParam( vlExpr,vlName);
              ParList.AddItem(vlExpr,vlName); ;
            WHILE (GetSym = 9) do begin
                  Get;
                  _RParam( vlExpr,vlName);
                    ParList.AddItem(vlExpr,vlName); ;
            end;
            Expect(104);
      end;
      
      Procedure TELA_Parser._RIdentObject ( ParLocal :TDefinition;var ParDef : TDefinition;var ParDigi : TIdentDigiItem;var ParMention : TMN_Type);
       
      var
      	vlIdent : ansistring;
      
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
            WHILE (GetSym = 52) do begin
                  _IInherited;
                    inc(vlLevel); ;
            end;
            if (GetSym = 62) then begin
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
                  if (GetSym = 103) then begin
                        _RParameters( vlOut);
                  end;
            end
            else begin
                  SynError(123);
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
            WHILE (GetSym = 67) do begin
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
      
      Procedure TELA_Parser._RShortDRoutine ( ParRoutine : TDefinition;ParItem :TIdentHookDigiItem);
       
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
      vlPSt   : ansistring;
      vlName  : ansistring;
      vlExpr  : TDigiItem;
      vlDigi  : TIdentHookDigiItem;
      
      begin
             
            vlValid := true;
            ParDigi := nil;
            ;
            case GetSym of
                  1, 67 : begin
                        _RIdentMention( vlDigi);
                          ParDigi :=vlDigi; ;
                  end;
                  52 : begin
                        _RInherited( vlDigi);
                          ParDigi := vlDigi; ;
                  end;
                  3..5 : begin
                        _RNumber( vlNum,vlValid);
                         
                        	if not(LargeInRange(vlNum ,Min_Longint, Max_Cardinal)) then SemError(Err_Num_Out_Of_Range);
                        	ParDigi := TNUmberDigiItem.Create(vlNum);
                        ;
                  end;
                  2, 6 : begin
                        _RText( vlPst);
                          ParDigi := TStringDigiItem.Create(vlPst);;
                  end;
                  58 : begin
                        _INil;
                          ParDigi := TNilDigiItem.Create ;
                  end;
                  60 : begin
                        _INot;
                            LexName(vlName); ;
                        Expect(103);
                        _RExprDigi( vlExpr);
                        Expect(104);
                          ParDigi := TSingleOperatorDigiItem.Create(vlExpr,vlName,TNotNode); ;
                  end;
                  83 : begin
                        _ISizeOf;
                        Expect(103);
                        _RExprDigi( vlExpr);
                        Expect(104);
                          ParDigi := TSizeOfDigiItem.Create(vlExpr);;
                  end;
                  103 : begin
                        Get;
                        _RExprDigi( ParDigi);
                        Expect(104);
                  end;
                  else begin
                        SynError(124);
                  end;
            end;
             
            SetDigiPos(ParDigi);
            ;
      end;
      
      Procedure TELA_Parser._RComp ( var ParDigi : TDigiItem);
       
      var
      vlNode2     : TFormulaNode;
      vlIdent     : ansistring;
      vlIndex     : TArrayDigiItem;
      vlOut       : TIdentHookDigiItem;
      vlDotOper   : TDotOperDigiItem;
      vlDigi      : TDigiItem;
      
      begin
            _RFact( vlDigi);
            WHILE (GetSym in [7 , 109 , 117 , 119]) do begin
                  if (GetSym = 119) then begin
                        Get;
                         
                        vlOut := HandleDeReference(vlDigi);
                        vlDigi := vlOut;
                        ;
                        if (GetSym = 103) then begin
                              _RParameters( vlOut);
                        end;
                  end
                   else if (GetSym = 109) then begin
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
                        Expect(110);
                  end
                   else if (GetSym = 7) then begin
                        Get;
                        _RIdent( vlIdent);
                         
                        		vlDotOper := HandleDotOperator(vlDigi,vlIdent);
                        		vlDigi := vlDotOper;
                        	;
                        if (GetSym = 103) then begin
                              _RParameters( vlDotOper.fField);
                        end;
                        if (GetSym = 96) then begin
                               
                              	vlDotOper.HandleRfi(fNDCreator);
                              	fNDCreator.AddCurrentDefinitionEx(vlDotOper.GetRecordType,false,true);
                              ;
                              _RShortDRoutine( vlDotOper.GetFieldIdentItem,vlDotOper.fField);
                                if vlDotOper.GetRecordType <> nil then fNDCreator.EndIdent;	;
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
                              SynError(125);
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
            if (GetSym = 118) then begin
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
            WHILE (GetSym = 16) do begin
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
      vlName     : ansistring;
      vlDigi1    : TDigiItem;
      vlDigi2    : TDigiItem;
      
      begin
             
            				vlNeg     := false;
                         vlOperator := nil;
            			;
            if (GetSym in [105 , 106]) then begin
                  if (GetSym = 105) then begin
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
            WHILE (GetSym in [34 , 56 , 107]) do begin
                  if (GetSym = 107) then begin
                        Get;
                           vlOperator := TMulNode;;
                  end
                   else if (GetSym = 34) then begin
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
                  if (GetSym in [105 , 106]) then begin
                        if (GetSym = 105) then begin
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
      	vlName : ansistring;
      
      begin
            _RTerm( vlDigi1);
            WHILE (GetSym in [79 , 80]) do begin
                  if (GetSym = 79) then begin
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
      vlName     : ansistring;
      vlDigi1    : TDigiItem;
      vlDigi2    : TDigiItem;
      
      begin
            _RShrShl( vlDigi1);
            WHILE (GetSym in [105 , 106]) do begin
                  if (GetSym = 106) then begin
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
      vlName     : ansistring;
      
      begin
            _RAdd( vlDigi1);
            WHILE (GetSym = 14) do begin
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
      	vlName     : ansistring;
      	vlOperator : TRefNodeIdent;
      
      begin
            _RLogicAnd( vlDigi1);
            WHILE (GetSym in [64 , 102]) do begin
                  if (GetSym = 64) then begin
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
      	vlName:ansistring;
      
      begin
            _RLogic( vlDigiL);
            WHILE(GetSym=108) or ((GetSym>=112) and (GetSym<=116)) do begin
                  case GetSym of
                        112 : begin
                              Get;
                                vlCode := IC_Bigger;   ;
                        end;
                        113 : begin
                              Get;
                                vlCode := IC_BiggerEq; ;
                        end;
                        115 : begin
                              Get;
                                vlCode := IC_Lower;    ;
                        end;
                        114 : begin
                              Get;
                                vlcode := IC_LowerEq;  ;
                        end;
                        108 : begin
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
      	vlName  : ansistring;
      
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
      
      Procedure TELA_Parser._RCodes ( var ParNode:TSubListStatementNode);
      begin
              ParNode := TBlockNode.Create;;
            _IBegin;
            WHILE vgDynSet[3].isSet(GetSym) do begin
                  _RCode( ParNode);
                  Expect(8);
            end;
            _IEnd;
      end;
      
      Procedure TELA_Parser._RLeave ( var ParNode : TNodeIdent);
      begin
            _ILeave;
              if ParNode <> nil then ParNode :=TLeaveNode.Create; ;
      end;
      
      Procedure TELA_Parser._RExprDigi ( var ParExpr : TDigiItem);
       
      var
      vlI1 : TDigiItem;
      vlI2 : TDigiItem;
      vlI3 : TDigiItem;
      vlName : ansistring;
      
      begin
            _RIdentOper( vlI1);
              ParExpr := vlI1; ;
            if (GetSym = 22) then begin
                  _IBetween;
                   LexName(vlName);;
                  Expect(103);
                  _RIdentOper( vlI2);
                  Expect(104);
                  _IAnd;
                  Expect(103);
                  _RIdentOper( vlI3);
                  Expect(104);
                   
                  ParExpr := TBetweenOperatorDigiItem.Create(vlI1,vlI2,vlI3,vlName);
                  SetDigiPos(ParExpr);
                  ;
            end;
      end;
      
      Procedure TELA_Parser._RLoad ( var Parexp:TFormulaNode);
        var
      vlName   : ansistring;
      vlDigiL  : TDigiItem;
      vlDigiR  : TDigiItem;
      
      begin
             
            ParExp := nil;
            ;
            _RExprDigi( vlDigiL);
            if (GetSym = 111) then begin
                  Get;
                    LexName(vlName); ;
                  _RExprDigi( vlDigiR);
                   
                  	if vlDigiL <> nil then ParExp := vlDigiL.CreateWriteNode(fNDCreator,vlDigiR);
                  	if vlDigiR <> nil then vlDigiR.Destroy;
                  ;
            end
             else if (GetSym in [8 , 37]) then begin
                   
                  if vlDigiL <> nil then ParExp :=TFormulaNode(vlDigiL.CreateExecuteNode(fNDCreator));
                  if (ParExp = nil) then ErrorText(Err_Cant_Execute,'');
                  ;
            end
            else begin
                  SynError(126);
            end;
            ; 
            if vlDigiL <> nil then vlDigiL.Destroy;
            ;
      end;
      
      Procedure TELA_Parser._RRepeat ( var ParNode:TSubListStatementNode);
        var vlCond:TFormulaNode; 
      begin
            _IRepeat;
              ParNode := TRepeatNode.Create;
            	   fNDCreator.AddCurrentNode(ParNode); ;
            WHILE vgDynSet[3].isSet(GetSym) do begin
                  _RCode( ParNode);
                  Expect(8);
            end;
            _IUntil;
            _RFormula( vlCond);
             
            TRepeatNode(ParNode).SetCond(vlCond);
            fNDCreator.EndNode;
            ;
      end;
      
      Procedure TELA_Parser._RIf ( var ParNode:TSubListStatementNode);
       
      var
      	vlCond : TFormulaNode;
      	vlThen : TThenElseNode;
      
      begin
            _IIf;
            _RFormula( vlCond);
             
            ParNode := TIfNode.Create;
            TIfNode(ParNode).SetCond(vlCond);
            vlThen := TThenElseNode.Create(True);
            ParNode.AddNode(vlThen);
            ;
            _IThen;
            _RCode( vlThen);
            if (GetSym = 37) then begin
                  _IElse;
                   
                  vlThen := TThenElseNode.Create(False);
                  ParNode.AddNode(vlThen);
                  ;
                  _RCode( vlThen);
            end;
      end;
      
      Procedure TELA_Parser._RFor ( var ParNode :TSubListStatementnode);
       
      var
      	vlExpr : TFormulaNode;
         vlNode : TForNode;
      
      begin
              vlNode := (TForNode.Create); ;
            _IFor;
            _RFormula( vlExpr);
              vlNode.SetBegin(vlExpr); ;
            _IUntil;
            _RFormula( vlExpr);
             
            vlNode.SetEnd(vlExpr);
            fNDCreator.AddCurrentNode(vlNode);
            ;
            if (GetSym = 35) then begin
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
      
      Procedure TELA_Parser._RCount ( var ParNode:TSubListStatementNode);
       
      var
      vlCount        : TFormulaNode;
      vlNode         : TCountNode;
      vlUp           : boolean;
      vlEnd          : TFormulaNode;
      vlAllOf        : TFormulaNode;
      vlStep         : TFormulaNode;
      vlEndCondition : TFormulaNode;
      vlBegin        : TFormulaNode;
      
      begin
             
            vlUp           := true;
            vlEndCondition := nil;
            vlEnd          := nil;
            vlAllOf        := nil;
            vlStep         := nil;
            vlBegin        := nil;
            ;
            _ICount;
            _RFormula( vlCount);
            if (GetSym = 13) then begin
                  _IAll;
                  _IOf;
                  _RFormula( vlAllOf);
            end
             else if (GetSym = 46) then begin
                  _IFrom;
                  _RFormula( vlBegin);
                  if (GetSym in [36 , 86]) then begin
                        if (GetSym = 86) then begin
                              _ITo;
                        end
                         else begin
                              _IDownTo;
                                vlUp := false;;
                        end
                        ;_RFormula( vlEnd);
                  end;
            end
            else begin
                  SynError(127);
            end;
            ;if (GetSym = 85) then begin
                  _IStep;
                  _RFormula( vlStep);
            end;
            if (GetSym = 89) then begin
                  _IUntil;
                  _RExpr( vlEndCondition);
            end;
             
            vlNode := TCountNode.Create;
            vlNode.SetCount(vlCount);
            vlNode.SetUp(vlUp);
            vlNode.SetAllOf(vlAllOf);
            vlNode.SetEnd(vlEnd);
            vlNode.SetBegin(vlBegin);
            if vlStep = nil then vlStep := TFormulaNode(fNDCreator.CreateIntNodeLOng(1));
            vlNode.SetStep(vlStep);
            vlNode.SetEndCondition(vlEndCondition);
            fNDCreator.AddCurrentNode(vlNode);
            ;
            if (GetSym = 35) then begin
                  _IDo;
                  _RCode( vlNode);
            end;
             
            ParNode := vlNode;
            fNDCreator.EndNode;
            ;
      end;
      
      Procedure TELA_Parser._RCode ( ParNode:TSubListStatementNode);
       
      var
      vlNode     : TSubListStatementNode;(* TODO Solve this*)
      vlForm     : TFormulanode;
      vlLineInfo : TNodeident;
      vlBaseNode : TNodeIdent;
      
      begin
             
             vlNode := nil;
             vlForm := nil;
             vlBaseNode := nil;
             if (GetConfigValues.fGenerateDebug) and (ParNode <> nil)  then begin
             	vlLineInfo := TLineNumberNode.create;
             	vlLineInfo.fLine := nextLine;
                 ParNode.AddNode(vlLineInfo);
             end;
            ;
            case GetSym of
                  1..6, 52, 58, 60, 67, 83, 103, 105..106, 118 : begin
                        _RLoad( vlForm);
                  end;
                  17 : begin
                        _RAsmBlock( vlNode);
                  end;
                  23 : begin
                        _RBreak( vlNode);
                  end;
                  29 : begin
                        _RContinue( vlNode);
                  end;
                  45 : begin
                        _RFor( vlNode);
                  end;
                  30 : begin
                        _RCount( vlNode);
                  end;
                  100 : begin
                        _RWhile( vlNode);
                  end;
                  49 : begin
                        _RIf( vlNode);
                  end;
                  77 : begin
                        _RRepeat( vlNode);
                  end;
                  41 : begin
                        _RExit( vlBaseNode);
                  end;
                  31, 50 : begin
                        _RIncDec( ParNode);
                  end;
                  43 : begin
                        _RLeave( vlNode);
                  end;
                  20 : begin
                        _RCodes( vlNode);
                  end;
                  97..98 : begin
                        _RWrite( ParNode);
                  end;
                  else begin
                        SynError(128);
                  end;
            end;
             
            if vlNode <> nil then ParNode.AddNode(vlNode);
            if vlForm <> nil then ParNode.AddNode(vlForm);
            if vlBaseNode <> nil then ParNode.AddNode(vlBaseNode);
            ;
      end;
      
      Procedure TELA_Parser._RWhile ( var ParNode:TSubListStatementNode);
       
      var
       vlCond : TFormulaNode;
      
      begin
            _IWhile;
            _RFormula( vlCond);
             
            ParNode := TWhileNode.Create;
            TWhileNode(ParNode).SetCond(vlCond);
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
             vlExp := nil;;
            _IExit;
            if (GetSym = 103) then begin
                  Get;
                  _RFormula( vlExp);
                  Expect(104);
            end;
             
            ParNode :=CreateExitNode(vlExp);
            ;
      end;
      
      Procedure TELA_Parser._RFormula ( var ParExp:TFormulaNode);
      begin
            _RExpr( ParExp);
      end;
      
      Procedure TELA_Parser._RIncDec ( var ParNode : TSubListStatementNode);
       
      var
      vlNode 		: TIncDecNode;
      vlIncrNode  : TFormulaNode;
      vlValueNode : TFormulaNode;
      vlIncFlag   : boolean;
      
      begin
             
            vlValueNode := nil;
            ;
            if (GetSym = 50) then begin
                  _IInc;
                    vlIncFlag := true; ;
            end
             else if (GetSym = 31) then begin
                  _IDec;
                    vlIncFlag := false;;
            end
            else begin
                  SynError(129);
            end;
            ;_RFormula( vlIncrNode);
            if (GetSym = 101) then begin
                  _IWith;
                  _RFormula( vlValueNode);
            end
             else if (GetSym in [8 , 37]) then begin
                    vlValueNode := TFormulaNode(fNDCreator.CreateIntNodeLong(1)); ;
            end
            else begin
                  SynError(130);
            end;
            ; ParNode.AddNode( TIncDecNode.Create(vlIncFlag,vlIncrNode,vlValueNode));;
      end;
      
      Procedure TELA_Parser._RParam ( var ParExpr : TFormulaNode;var ParName : ansistring);
      begin
              EmptyString(ParName); ;
            _RExpr( ParExpr);
            if (GetSym = 120) then begin
                  Get;
                  _RIdent( ParName);
            end;
      end;
      
      Procedure TELA_Parser._RWrite ( ParNode:TSubListStatementNode);
       
      var
      vlWritelnFlag:boolean;
      vlNl      : TDefinition;
      vlRoutine : TDefinition;
      vlOwner   : TDefinition;
      vlExpr    : TFormulaNode;
      vlName    : ansistring;
      vlNode    : TCallNode;
      
      begin
             
            vlWritelnFlag := false;
            vlNl          := nil;
            ;
            if (GetSym = 97) then begin
                  _IWrite;
            end
             else if (GetSym = 98) then begin
                  _IWriteln;
                    vlWritelnFlag := true; ;
            end
            else begin
                  SynError(131);
            end;
            ;if (GetSym = 103) then begin
                   
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
                  Expect(104);
            end;
             
            if vlWritelnFlag then begin
            if fNDCreator.GetWriteProc(true,vlNl,vlOwner) then begin
            	vlNode := TCallNode(vlNl.createExecuteNode(fNDCreator,vlOwner));
            	ParNode.AddNode(vlNode);
            end;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RContinue ( var ParNode : TSubListStatementNode);
      begin
            _IContinue;
              AddContinueNode(ParNode);;
      end;
      
      Procedure TELA_Parser._RBreak ( var ParNode : TSubListStatementNode);
      begin
            _IBreak;
              AddBreakNode(ParNode);;
      end;
      
      Procedure TELA_Parser._RRoutineHeader ( var ParRoutine:TRoutine;ParForward:boolean;var ParLevel : cardinal);
       
      var
      vlDef         : TRoutine;
      vlRootCB      : boolean;
      vlInherit     : boolean;
      vlParentName  : ansistring;
      vlVirtual     : TVirtualMode;
      vlName        : ansistring;
      vlOverLoad    : TOverloadMode;
      vlTmpAccess   : TDefAccess;
      vlHasses      : cardinal;
      vlInhFinal    : boolean;
      vlIsolate     : boolean;
      vlHasMain     : boolean;
      vlIsAbstract  : boolean;
      vlIsWrite     : boolean;
      
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
            if (GetSym = 97) then begin
                  _IWrite;
                    vlIsWrite := true; ;
            end;
            if (GetSym = 68) then begin
                  _RProcedureHead( vlDef,vlHasses);
            end
             else if (GetSym = 47) then begin
                  _RFunctionHead( vlDef,vlHasses);
            end
             else if (GetSym in [28 , 33]) then begin
                  _RConstructorHead( vlDef,vlHasses);
            end
             else if (GetSym = 63) then begin
                  _ROperatorHead( vlDef);
                    vlHasses := 0; ;
            end
            else begin
                  SynError(132);
            end;
            ;  ParLevel := vlHasses + 1; ;
            if (GetSym in [51 , 78]) then begin
                  if (GetSym = 78) then begin
                        _IRoot;
                        Expect(8);
                          vlRootCb := true ;
                  end
                   else begin
                        _IInherit;
                        if (GetSym = 44) then begin
                              _IFinal;
                                vlInhFinal := true ;
                        end;
                        _RIdent( vlParentName);
                          vlInherit := true; ;
                        if (GetSym = 103) then begin
                              _RParameterMapping( vlDef);
                        end;
                        Expect(8);
                  end
                  ;end;
            if (GetSym in [44 , 66 , 95]) then begin
                  if (GetSym = 95) then begin
                        _IVirtual;
                        Expect(8);
                          vlVirtual := Vir_Virtual; ;
                  end
                   else if (GetSym = 66) then begin
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
            if (GetSym = 53) then begin
                  _IIsolate;
                  Expect(8);
                    vlIsolate := true;;
            end;
            if (GetSym = 65) then begin
                  _IOverload;
                  if (GetSym = 57) then begin
                        _IName;
                          vlOverload := OVL_Name;;
                  end
                   else if (GetSym = 40) then begin
                        _IExact;
                          vlOverload := OVL_Exact; ;
                  end
                   else if (GetSym = 8) then begin
                          vlOverload := OVL_Type; ;
                  end
                  else begin
                        SynError(133);
                  end;
                  ;Expect(8);
            end;
            if (GetSym = 11) then begin
                  _IAbstract;
                  Expect(8);
                    vlIsAbstract := true; ;
            end;
            if (GetSym = 32) then begin
                  _IDefault;
                    vlDef.SetDefault(DT_Routine); ;
                  Expect(8);
            end;
             
            	verbose(VRB_Procedure_Name,'** Procedure name  :'+vlDef.FText);
            	if (ParForward) and (vlDef <> nil) then vlDef.SignalForwardDefined;
            	ParRoutine := ProcessRoutineItem(vlDef,vlIsolate,vlROotCb,vlInhFinal,vlInherit,vlParentName,vlVirtual,vlOverload,vlIsAbstract,vlIsWrite);
            ;
            if (GetSym = 48) then begin
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
                  WHILE vgDynSet[4].isSet(GetSym) do begin
                        case GetSym of
                              72 : begin
                                    _IPrivate;
                                      fNDCreator.fCurrentDefAccess := AF_Private;   ;
                              end;
                              71 : begin
                                    _IProtected;
                                      fNDCreator.fCurrentDefAccess := AF_Protected; ;
                              end;
                              70 : begin
                                    _RProperty;
                              end;
                              27 : begin
                                    _RConstant;
                              end;
                              94 : begin
                                    _RVarBlock;
                              end;
                              88 : begin
                                    _RTypeBlock;
                              end;
                              28, 33, 47, 63, 68, 97 : begin
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
            Expect(103);
            _RParameterMappingItem( ParRoutine);
            WHILE (GetSym = 9) do begin
                  Get;
                  _RParameterMappingItem( ParRoutine);
            end;
            Expect(104);
      end;
      
      Procedure TELA_Parser._RParameterMappingItem ( ParRoutine :TRoutine);
       
      var
      vlName : ansistring;
      vlVal  : TValue;
      vlMode : TMappingOption;
      
      begin
            if (GetSym in [1 , 118]) then begin
                   
                  	vlMode  := MO_Result;
                  ;
                  if (GetSym = 118) then begin
                        Get;
                          vlMode := MO_ObjectPointer; ;
                        _RIdent( vlName);
                  end
                   else begin
                        _RIdent( vlName);
                        if (GetSym = 119) then begin
                              Get;
                                vlMode := MO_ByPointer; (*Todo:vlMode =>MO_Result zijn *);
                        end;
                  end
                  ;  if parRoutine <> nil then ParRoutine.AddNormalParameterMapping(fNDcreator,vlName,vlMode);;
            end
             else if vgDynSet[5].isSet(GetSym) then begin
                  _RNum_Or_Const_2( vlVal);
                    if ParRoutine <> nil then ParRoutine.AddConstantParameterMapping(fNDCreator,vlVal); ;
            end
            else begin
                  SynError(134);
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
            WHILE((GetSym>=1) and (GetSym<=37)) or ((GetSym>=39) and (GetSym<=121)) do begin
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
      vlIdent  : ansistring;
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
            if (GetSym = 103) then begin
                  _RParamDef( vlFun);
            end;
            Expect(10);
            _RRoutineType( vlType);
            Expect(8);
              vlFun.SetFunType(fNDCreator,vlType); ;
            if (GetSym = 24) then begin
                  _ICDecl;
                  Expect(8);
                    vlFun.SetRoutineModes([RTM_CDecl],true);;
            end;
      end;
      
      Procedure TELA_Parser._RConstructorHead ( var ParRoutine : TRoutine;var ParHasses : cardinal);
       
      var
      vlIdent  : ansistring;
      vlAccess : TDefAccess;
      vlCDFlag : boolean;
      
      begin
            if (GetSym = 28) then begin
                  _IConstructor;
                    vlCdFlag := true; ;
            end
             else if (GetSym = 33) then begin
                  _IDestructor;
                    vlCdFlag := false; ;
            end
            else begin
                  SynError(135);
            end;
            ;_RRoutineName( vlIdent,vlAccess,ParHasses);
              ParRoutine:= CreateCDtor(vlIdent,vlAccess,vlCdFlag); ;
            if (GetSym = 103) then begin
                  _RParamDef( ParRoutine);
            end;
            Expect(8);
            if (GetSym = 24) then begin
                  _ICDecl;
                  Expect(8);
                    ParRoutine.SetRoutineModes([RTM_CDecl],true); ;
            end;
      end;
      
      Procedure TELA_Parser._ROperatorHead ( var ParRoutine:TRoutine);
       
      var
      vlType      : TType;
      vlName      : ansistring;
      vlHasReturn : boolean;
      vlWrite		: boolean;
      
      begin
            _IOperator;
             
            					vlHasReturn := false;
            					vlWrite := false;
            					ParRoutine := TOperatorFunction.Create('');
            					EmptyString(vlName);
            				;
            if (GetSym in [60 , 106]) then begin
                  if (GetSym = 60) then begin
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
             else if (GetSym = 103) then begin
                  _ROperParDef( ParRoutine);
                  case GetSym of
                        105 : begin
                              Get;
                        end;
                        106 : begin
                              Get;
                        end;
                        107 : begin
                              Get;
                        end;
                        34 : begin
                              _IDiv;
                        end;
                        102 : begin
                              _IXor;
                        end;
                        56 : begin
                              _IMod;
                        end;
                        64 : begin
                              _IOr;
                        end;
                        14 : begin
                              _IAnd;
                        end;
                        108 : begin
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
                        115 : begin
                              Get;
                        end;
                        116 : begin
                              Get;
                        end;
                        111 : begin
                              Get;
                        end;
                        22 : begin
                              _IBetween;
                        end;
                        117 : begin
                              Get;
                        end;
                        80 : begin
                              _IShl;
                        end;
                        79 : begin
                              _IShr;
                        end;
                        1 : begin
                              Get;
                        end;
                        else begin
                              SynError(136);
                        end;
                  end;
                   
                  					LexName(vlname);
                  			   		ParRoutine.SetText(vlName);
                  				;
                  _ROperParDef( ParRoutine);
                  if (GetSym = 97) then begin
                        _IWrite;
                        _ROperParDef( ParRoutine);
                         
                        					vlWrite := true;
                        					if vlName <> '#' then ErrorText(Err_Not_Expected,'WRITE');
                        				;
                  end;
                  if (GetSym = 14) then begin
                        _IAnd;
                        _ROperParDef( ParRoutine);
                         
                        					if vlName <>'BETWEEN' then ErrorText(Err_Not_Expected,'AND');
                        				;
                  end;
            end
            else begin
                  SynError(137);
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
            if (GetSym = 24) then begin
                  _ICDecl;
                  Expect(8);
                    ParRoutine.SetRoutineModes([RTM_CDecl],true); ;
            end;
      end;
      
      Procedure TELA_Parser._ROperParDef ( ParRoutine:TRoutine);
       
      var
      vlType  : TType;
      vlIdent : ansistring;
      vlConst : boolean;
      vlVar   : boolean;
      vlName  : TNameList;
      
      begin
             
            vlConst := false;
            vlVar   := false;
            vlName  := TNameList.Create;
            ;
            Expect(103);
            if (GetSym in [27 , 94]) then begin
                  if (GetSym = 27) then begin
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
            Expect(104);
             
            ParRoutine.AddParam(fNDCreator,vlName,vlType,vlVar,vlConst,false);
            vlName.Destroy;
            ;
      end;
      
      Procedure TELA_Parser._RProcedureHead ( var ParRoutine:TRoutine;var ParHasses : cardinal);
       
      var
      	vlIdent:ansistring;
      	vlAccess : TDefAccess;
      
      begin
            _IProcedure;
            _RRoutineName( vlIdent,vlAccess,ParHasses);
             
            ParRoutine := TProcedureObj.Create(vlIdent);
            ParRoutine.fDefAccess := vlAccess;
            ;
            if (GetSym = 103) then begin
                  _RParamDef( ParRoutine);
            end;
            Expect(8);
            if (GetSym = 24) then begin
                  _ICDecl;
                  Expect(8);
                    ParRoutine.SetRoutineModes([RTM_Cdecl],true);;
            end;
      end;
      
      Procedure TELA_Parser._RRoutineName ( var ParName : ansistring;var ParAccess : TDefAccess;var ParHasses:cardinal);
       
      var
      	vlname : ansistring;
      
      begin
             
            	ParHasses := 0;
            	ParAccess := AF_Current;
            ;
            _RRoutineDotName( vlName,ParHasses);
            if (GetSym = 48) then begin
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
                  if (GetSym in [71 , 72]) then begin
                        if (GetSym = 71) then begin
                              _IProtected;
                                ParAccess := AF_Protected; ;
                        end
                         else begin
                              _IPrivate;
                                ParAccess := AF_Private;   ;
                        end
                        ;_RIdent( vlName);
                  end
                   else if (GetSym in [8 , 10 , 103]) then begin
                         
                        if(ParHasses > 1) then begin
                        	EndIdent;
                        	dec(ParHasses);
                        end;
                        ParAccess := AF_Protected;
                        ;
                  end
                  else begin
                        SynError(138);
                  end;
                  ;end;
              ParName := vlName; ;
      end;
      
      Procedure TELA_Parser._RRoutineDotName ( var ParName : ansistring;var ParHasses : cardinal);
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
      	vlIdent   : ansistring;
      	vlAlias   : ansistring;
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
            if (GetSym = 95) then begin
                  _IVirtual;
                    vlVirtual := true ;
            end;
            if (GetSym in [27 , 94]) then begin
                  if (GetSym = 94) then begin
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
      	vlName         : ansistring;
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
            WHILE (GetSym in [71 , 72 , 73 , 75 , 97]) do begin
                    vlAcc := AF_Public ;
                  if (GetSym in [71 , 72 , 73]) then begin
                        if (GetSym = 73) then begin
                              _IPublic;
                                vlAcc := AF_Public; ;
                        end
                         else if (GetSym = 72) then begin
                              _IPrivate;
                                vlAcc := AF_private; ;
                        end
                         else begin
                              _IProtected;
                                vlAcc := AF_Protected; ;
                        end
                        ;end;
                  if (GetSym = 75) then begin
                        _IRead;
                          vlPropertyType := PT_Read; ;
                  end
                   else if (GetSym = 97) then begin
                        _IWrite;
                          vlPropertyType := PT_Write; ;
                  end
                  else begin
                        SynError(139);
                  end;
                  ;_RIdent( vlName);
                  Expect(8);
                   
                        	DoPropertyDefinition(vlName,vlAcc,vlPropertyType,vlProperty);
                  		;
            end;
            _IEnd;
            Expect(8);
      end;
      
      Procedure TELA_Parser._RClassType ( const ParName : ansistring;var ParType : TType);
       
      var
      	vlParent     : ansistring;
      	vlPrvAccess  : TDefAccess;
      	vlVirtual    : TVirtualMode;
      	vlIsolate    : boolean;
      	vlOfValue    : boolean;
      
      begin
             
            EmptyString(vlParent);
            vlVirtual := VIR_None;
            vlIsolate := false;
            vlOfValue := false;
            ;
            if (GetSym = 53) then begin
                  _IIsolate;
                    vlIsolate := true;;
            end;
            if (GetSym in [66 , 95]) then begin
                  if (GetSym = 95) then begin
                        _IVirtual;
                          vlVirtual := VIR_Virtual; ;
                  end
                   else begin
                        _IOverride;
                          vlVirtual := VIR_Override; ;
                  end
                  ;end;
            _IClass;
            if (GetSym = 62) then begin
                  _IOf;
                  _IValue;
                    vlOfValue := true; ;
            end;
            if vgDynSet[6].isSet(GetSym) then begin
                  if (GetSym = 51) then begin
                        _IInherit;
                        _RIdent( vlParent);
                  end;
                   
                  ParType := CreateClassType(ParName,vlParent,vlVirtual,false,vlIsolate,vlOfValue);
                  vlPrvAccess := fNDCreator.fCurrentDefAccess;
                  fNDCreator.fCurrentDefAccess := AF_Private;
                  ;
                  WHILE vgDynSet[7].isSet(GetSym) do begin
                        case GetSym of
                              72 : begin
                                    _IPrivate;
                                      fNDCreator.fCurrentDefAccess := AF_Private; ;
                              end;
                              71 : begin
                                    _IProtected;
                                      fNDCreator.fCurrentDefAccess := AF_Protected; ;
                              end;
                              73 : begin
                                    _IPublic;
                                      fNDCreator.fCurrentDefAccess := AF_Public; ;
                              end;
                              70 : begin
                                    _RProperty;
                              end;
                              88 : begin
                                    _RTypeBlock;
                              end;
                              94 : begin
                                    _RVarBlock;
                              end;
                              27 : begin
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
                   
                  ParType := CreateClassType(ParName,vlParent,vlVirtual,true,vlIsolate,vlOfValue);
                  ;
            end
            else begin
                  SynError(140);
            end;
            ;end;
      
      Procedure TELA_Parser._RTypeDecl;
       var
      vlIdent    : ansistring;
      vlType     : TType;
      vlPtrType  : TPtrType;
      vlDefType  : TDefaultTypeCode;
      vlAdded    : boolean;
      
      begin
            _RIdent( vlIdent);
             
            vlType     := nil;
            vLDefType  := DT_Nothing;
            vlAdded    := false;
            ;
            Expect(108);
            if (GetSym = 32) then begin
                  _IDefault;
                    vlDefType := DT_Default; ;
                  if (GetSym = 55) then begin
                        _IMetaType;
                          vlDefType := DT_Meta; ;
                  end;
            end;
            if vgDynSet[8].isSet(GetSym) then begin
                  if vgDynSet[9].isSet(GetSym) then begin
                        case GetSym of
                              59 : begin
                                    _ROrdDecl( vlType);
                                      HandleDefaultType(vlDefType,DT_Number,[DT_Number,DT_Boolean]) ;
                              end;
                              1 : begin
                                    _RTypeAs( vlType);
                                      HandleDefaultType(vlDefType,DT_Default,[]); ;
                              end;
                              99 : begin
                                    _RVoidTypeDecl( vlType);
                                      HandleDefaultType(vlDefType,DT_Void,[DT_Void]); ;
                              end;
                              25 : begin
                                    _RCharDecl( vlType);
                                      HandleDefaultType(vlDefType,DT_Char,[DT_Char]); ;
                              end;
                              39 : begin
                                    _REnum( vlType);
                                      HandleDefaultType(vlDefType,DT_Default,[DT_Boolean]); ;
                              end;
                              74 : begin
                                    _RPtrTypeDecl( vlPtrType,true );
                                     
                                    										vlType := vlPtrType;
                                         if (vlDefType=DT_Default) and (vlPtrType.fConstFlag) then vlDefType := DT_Const_Pointer;
                                          if vlDefType = DT_Meta then vlDefType := DT_Ptr_Meta;
                                    						 				HandleDefaultType(vlDefType,DT_Pointer,[DT_Const_Pointer,DT_Ptr_Meta,DT_Pointer]);
                                    	   				 ;
                              end;
                              84 : begin
                                    _RStringTypeDecl( vlType);
                                      HandleDefaultType(vlDefType,DT_String,[DT_String]); ;
                              end;
                              18 : begin
                                    _RAsciizDecl( vlType);
                                      HandleDefaultType(vlDefType,DT_Asciiz,[DT_Asciiz]); ;
                              end;
                              90 : begin
                                    _RUnion( vltype);
                                      HandleDefaultType(vlDefType,DT_Default,[]); ;
                              end;
                              26, 53, 66, 95 : begin
                                    _RClassType( vlIdent,vlType);
                                     
                                                vlAdded :=true;
                                    							 HandleDefaultType(vlDefType,DT_Default,[]);
                                             ;
                              end;
                              76 : begin
                                    _RRecord( vlType);
                                      HandleDefaultType(vlDefType,DT_Default,[DT_Meta]);;
                              end;
                              else begin
                                    SynError(141);
                              end;
                        end;
                  end
                   else if (GetSym = 21) then begin
                        _RBooleanType( vlType);
                          HandleDefaultType(vlDefType,DT_Boolean,[DT_Boolean]); ;
                  end
                   else begin
                        _RArrayTypeDef( vlType);
                          HandleDefaultType(vlDefType,DT_Default,[]); ;
                  end
                  ;Expect(8);
            end
             else if (GetSym in [47 , 61 , 68]) then begin
                  _RRoutineTypeDecl( vlType);
                    HandleDefaultType(vlDefType,DT_Default,[]); ;
            end
            else begin
                  SynError(142);
            end;
            ; 
            if not vlAdded then fNDCreator.AddType(vlIdent,vlType);
            if vlType <> nil then begin
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
      	vlSize    : TSize;
      
      begin
             
            ParType   := nil;
            ;
            _RH_Type( vlType2);
            if (GetSym = 81) then begin
                  _ISize;
                  Expect(108);
                  _RDirectCardinal( vlSize);
                   	if vlType2 <> nil then ParType := vlType2.CreateBasedOn(fNDCreator,vlSize);;
            end
             else if (GetSym = 8) then begin
                     ParType := TTypeAs.Create('',vlType2); ;
            end
            else begin
                  SynError(143);
            end;
            ;end;
      
      Procedure TELA_Parser._RAnonymousType ( var ParTYpe : TType);
      begin
              ParType := nil;;
            case GetSym of
                  15 : begin
                        _RArrayTypeDef( ParType);
                  end;
                  59 : begin
                        _ROrdDecl( ParType);
                  end;
                  18 : begin
                        _RAsciizDecl( ParType);
                  end;
                  84 : begin
                        _RStringTypeDecl( ParType);
                  end;
                  74 : begin
                        _RPtrTypeDecl( ParType,false );
                  end;
                  76 : begin
                        _RRecord( ParType);
                  end;
                  90 : begin
                        _RUnion( ParType);
                  end;
                  else begin
                        SynError(144);
                  end;
            end;
              AddAnonItem(ParType); ;
      end;
      
      Procedure TELA_Parser._RPtrTypeDecl ( var ParType:TType;ParCanForward : boolean);
       
      var
      vlName : ansistring;
      vlConstFlag : boolean;
      vlType : TType;
      
      begin
             
            vlConstFlag := false ;
            ParType := nil;
            ;
            _IPtr;
            if (GetSym = 27) then begin
                  _IConst;
                    vlConstFlag := true; ;
            end;
            if vgDynSet[10].isSet(GetSym) then begin
                  _RAnonymousType( vlType);
                    ParType := CreatePointerType(vlType,vlConstFlag); ;
            end
             else if (GetSym = 1) then begin
                  _RIdent( vlName);
                    ParType := CreatePointerType(vlName,ParCanForward,vlCOnstFlag);;
            end
            else begin
                  SynError(145);
            end;
            ;end;
      
      Procedure TELA_Parser._RCharDecl ( var ParType:TType);
       
      var
      vlSize : TSize;
      
      begin
            _ICharType;
            _ISize;
            Expect(108);
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
            Expect(103);
            _RParamVarDef( ParRoutine,vlVirCheck);
            WHILE (GetSym = 8) do begin
                  Get;
                  _RParamVarDef( ParRoutine,vlVirCheck);
            end;
            Expect(104);
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
            if (GetSym = 61) then begin
                  _IObject;
                    vlOfObject := true; ;
            end;
            if (GetSym = 68) then begin
                  _IProcedure;
                    vlRoutine := TProcedureObj.Create(''); ;
                  if (GetSym = 103) then begin
                        _RParamDef( vlRoutine);
                  end;
            end
             else if (GetSym = 47) then begin
                  _IFunction;
                    vlRoutine := TFunction.Create(''); ;
                  if (GetSym = 103) then begin
                        _RParamDef( vlRoutine);
                  end;
                  Expect(10);
                  _RRoutineType( vlType);
                    TFunction(vlRoutine).SetFunType(fNDCreator,vlType); ;
            end
            else begin
                  SynError(146);
            end;
            ;Expect(8);
            if (GetSym = 24) then begin
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
            if (GetSym = 82) then begin
                  _ISigned;
                    vlSign := true; ;
            end;
            _ISize;
            Expect(108);
            _RDirectCardinal( vlSize);
             
            if not (vlSIze in [1,2,4]) then SemError(Err_Illegal_Type_Size);
            ParType := TNumberType.Create(vlSIze,vlSign);
            ;
      end;
      
      Procedure TELA_Parser._RStringTypeDecl ( var ParType:TType);
       
      var
      	vlSize       : TSize;
      	vlType       : TType;
      	vlHasSize    : boolean;
      	vlHasDefaultSize : boolean;
      	vlLengthVarName  : ansistring;
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
            if (GetSym = 62) then begin
                  _IOf;
                  _RH_Type( vlType);
            end;
            if (GetSym = 94) then begin
                  _IVar;
                  _RIdent( vlLengthVarName);
                  Expect(10);
                  _RH_Type( vlLengthVarType);
            end;
            if (GetSym = 32) then begin
                  _IDefault;
                    vlHasDefaultSize := true ;
            end;
            if (GetSym = 81) then begin
                  _ISize;
                  Expect(108);
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
            Expect(108);
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
      	vlName : ansistring;
           vlSize : cardinal;
      	vlVal :TValue;
      
      begin
            _IBooleanType;
            _ISize;
            Expect(108);
            _RDirectCardinal( vlSize);
             
            	ParType := CreateBooleanType(vlSIze);
            ;
            Expect(103);
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
            Expect(104);
      end;
      
      Procedure TELA_Parser._REnum ( var ParType:TType);
       
      var
      	vlVal :TNumber;
      	vlCollection :TENumCollection;
      	vlName : ansistring;
      
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
      			vlIdent : ansistring;
      			vlVal : TValue;
      
      begin
            _RIdent( vlIdent);
            if (GetSym = 111) then begin
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
             else if (GetSym in [18 , 59 , 74 , 84]) then begin
                  if (GetSym = 18) then begin
                        _RAsciizDecl( ParType);
                  end
                   else if (GetSym = 59) then begin
                        _ROrdDecl( ParType);
                  end
                   else if (GetSym = 74) then begin
                        _RPtrTypeDecl( ParType,false );
                  end
                   else begin
                        _RStringTypeDecl( ParType);
                  end
                  ;  AddAnonItem(ParType); ;
            end
            else begin
                  SynError(147);
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
            Expect(109);
            _RArrayRangeDef( vlLo,vlHi);
             vlAr := TArrayType.Create(vlLo,vlHi);;
            WHILE (GetSym = 9) do begin
                  Get;
                  _RArrayRangeDef( vlLo,vlHi);
                    vlAr.AddType(TArrayType.Create(vlLO,vlHi)); ;
            end;
            Expect(110);
            _IOf;
            _RRoutineType( vltype);
             
            if vlType <> nil then begin
            	if vlType.fSize = 0 then SynError(err_cant_determine_size);
            end;
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
          vlValid   : boolean;
          vlNum     : TNumber;
          vlStr     : ansistring;
          vlNeg     : boolean;
      
      begin
             
            ParVal  := nil;
            vlNeg   := false;
            ;
            if (GetSym in [3 , 4 , 5 , 105 , 106]) then begin
                  if (GetSym in [105 , 106]) then begin
                        if (GetSym = 106) then begin
                              Get;
                                vlNeg := true; ;
                        end
                         else begin
                              Get;
                        end
                        ;end;
                  _RNumberConstant( ParVal,vlValid);
                   if vlNeg then CalculationStatusToError(ParVal.neg);;
            end
             else if (GetSym in [2 , 6 , 25]) then begin
                  _RStringConstant( ParVal);
            end
            else begin
                  SynError(148);
            end;
            ; if ParVal = nil then ParVal := TLongint.Create(1); ;
      end;
      
      Procedure TELA_Parser._RConstantDecl;
       
      var
      vlNameList : TNameList;
      vlStr      : ansistring;
      vlIdent    : ansistring;
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
            Expect(108);
            _RDirectExpr( vlVal);
             
            if vlVal.fType = VT_ansistring then begin
            	vlVal.GetString(vlStr);
            	fNDCreator.AddStringConst(vlNameList,vlStr);
            end else begin
            	fNDCreator.AddConstant(vlNameList,vlVal);
            end;
            vlVal.destroy;
            vlNameList.destroy;
            ;
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
      
      Procedure TELA_Parser._RNum_Or_Const ( var ParVal:TValue;var ParValid : boolean);
        var vlConst : TConstant;
      			
      begin
                ParVal := nil;;
            if (GetSym in [3 , 4 , 5]) then begin
                  _RNumberConstant( ParVal,ParValid);
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
                  	if ParVal = nil then ParVal := TLongint.Create(1);
                  ;
            end
             else if (GetSym in [2 , 6 , 25]) then begin
                  _RStringConstant( ParVal);
                    ParValid := true; ;
            end
            else begin
                  SynError(149);
            end;
            ; 
            if ParVal = nil then begin
            ParVal := TLongint.Create(1);
            ParValid := false;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RDirectFact ( var ParVal:TValue;var ParValid:boolean);
       
      var
      	vlNum :TSize;
      	vlType:TType;
      
      begin
             
            ParVal  := nil;
            ParValid := false;
            ;
            if((GetSym>=1) and (GetSym<=6)) or (GetSym=25) then begin
                  _RNum_Or_Const( ParVal,ParValid);
            end
             else if (GetSym = 103) then begin
                  Get;
                  _RDirectLogic( ParVal,ParValid);
                  Expect(104);
            end
             else if (GetSym = 58) then begin
                  _INil;
                   
                  	ParVal := TPointer.Create;
                    TPointer(ParVal).SetPointer(0);
                  	ParValid := true;
                  ;
            end
             else if (GetSym = 60) then begin
                  _INot;
                  Expect(103);
                  _RDirectLogic( ParVal,ParValid);
                  Expect(104);
                   
                  	if(ParValid) then begin
                  		if CalculationStatusToError(ParVal.NotVal) then ParValid := false;
                  	end;
                  ;
            end
             else if (GetSym = 83) then begin
                  _ISizeOf;
                  Expect(103);
                  _RH_Type( vlType);
                  Expect(104);
                   
                  	if vlType <> nil then begin
                  		vlNum := vlType.fSize;
                  		ParValid := true;
                  	end  else begin
                  		vlNum := 0;
                  		ParValid := false;
                  	end;
                  	ParVal := TLongint.Create(vlNum);
                  ;
            end
            else begin
                  SynError(150);
            end;
            ;  if ParVal = nil then ParVal := (TLongint.Create(1));;
      end;
      
      Procedure TELA_Parser._RDirectNeg ( var ParVal : TValue;var ParValid : boolean);
       
      Var
      	vlNeg : boolean;
      	
      
      begin
              vlNeg := false; ;
            WHILE (GetSym in [105 , 106]) do begin
                  if (GetSym = 106) then begin
                        Get;
                          vlNeg := true; ;
                  end
                   else begin
                        Get;
                  end
                  ;end;
            _RDirectFact( ParVal,ParValid);
             
            if(ParValid) then begin
            	if vlNeg then  begin
            		if CalculationStatusToError(ParVal.Neg) then ParValid := false;
            	end;
            end;
            ;
      end;
      
      Procedure TELA_Parser._RDirectMul ( var ParVal:TValue;var ParValid:boolean);
       
      var
      	vlVal   : TValue;
      	vlValid : boolean;
      
      begin
            _RDirectNeg( ParVal,ParValid);
            WHILE (GetSym in [34 , 56 , 107]) do begin
                  if (GetSym = 107) then begin
                        Get;
                        _RDirectNeg( vlval,vlValid);
                         
                        if ParValid and vlValid then begin
                         if CalculationStatusToError(ParVal.Mul(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                   else if (GetSym = 34) then begin
                        _IDiv;
                        _RDirectNeg( vlVal,vlValid);
                         
                        if ParValid and vlValid then begin
                         if CalculationStatusToError(ParVal.DivVal(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                   else begin
                        _IMod;
                        _RDirectNeg( vlVal,vlValid);
                         
                        if ParValid and vlValid then begin
                         if CalculationStatusToError(ParVal.ModVal(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                  ;  if vlVal <> nil then vlVal.destroy; ;
            end;
      end;
      
      Procedure TELA_Parser._RDirectAdd ( var ParVal:TValue;var ParValid:boolean);
       
      var
      	vlVal:TValue;
      	vlValid : boolean;
      
      begin
            _RDirectMul( ParVal,ParValid);
            WHILE (GetSym in [79 , 80 , 105 , 106]) do begin
                  if (GetSym = 105) then begin
                        Get;
                        _RDirectMul( vlVal,vlValid);
                         
                        if ParValid and vlValid then begin
                         if CalculationStatusToError(ParVal.Add(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                   else if (GetSym = 106) then begin
                        Get;
                        _RDirectMul( vlval,vlValid);
                         
                        if ParValid and vlValid then begin
                         if CalculationStatusToError(ParVal.Sub(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                   else if (GetSym = 80) then begin
                        _IShl;
                        _RDirectMul( vlVal,vlValid);
                         
                        if ParValid and  vlValid then begin
                         if CalculationStatusToError(ParVal.ShiftLeft(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                   else begin
                        _IShr;
                        _RDirectMul( vlVal,vlValid);
                         
                        if ParValid and vlValid then begin
                         if CalculationStatusToError(ParVal.ShiftRight(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                  ;   if vlVal <> nil then vlVal.destroy;;
            end;
      end;
      
      Procedure TELA_Parser._RDirectLogic ( var ParVal : TValue;var ParValid:boolean);
       
      var
      	vlVal : TValue;
      	vlValid: boolean;
      
      begin
              vlVal := nil;;
            _RDirectAdd( ParVal,ParValid);
            WHILE (GetSym in [14 , 64 , 102]) do begin
                  if (GetSym = 14) then begin
                        _IAnd;
                        _RDirectAdd( vlVal,vlValid);
                         
                        if ParValid and vlValid then begin
                         if CalculationStatusToError(ParVal.AndVal(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                   else if (GetSym = 64) then begin
                        _IOr;
                        _RDirectAdd( vlVal,vlValid);
                         
                        if ParValid and vlValid then begin
                         if CalculationStatusToError(ParVal.OrVal(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                   else begin
                        _IXor;
                        _RDirectAdd( vlVal,vlValid);
                         
                        if ParValid and vlValid then begin
                         if CalculationStatusToError(ParVal.XorVal(vlVal)) then ParValid := false;
                        end else begin
                         ParValid := false;
                        end;;
                        ;
                  end
                  ;  if vlVal <> nil then vlVal.Destroy; ;
            end;
      end;
      
      Procedure TELA_Parser._RDirectExpr ( var ParVal:TValue);
       
      var
      	vlValid:boolean;
      
      begin
            _RDirectLogic( ParVal,vlValid);
      end;
      
      Procedure TELA_Parser._RDirectString ( var ParStr : AnsiString);
       
      var
      	vlValue : TValue;
      
      begin
            _RDirectExpr( vlValue);
             
            	EmptyString(ParStr);
            	if vlValue <> nil then begin
            		if not(vlValue is TString) then begin
            			SemError(Err_Not_A_ansistring_Constant);
            		end else begin
            			ParStr := TString(vlValue).fText;
            		end;	
            		vlValue.destroy;
            	end;
            ;
      end;
      
      Procedure TELA_Parser._RNumberConstant ( var ParValue : TValue;var ParValid : boolean);
       
      var
      	vlNumber : TNumber;
      	vlValid  : boolean;
      
      begin
            _RNumber( vlNumber,ParValid);
             
            if not(LargeInRange(vlNumber, Min_Longint,Max_Cardinal)) then begin
            	ErrorText(Err_Num_Out_Of_Range,'');
            	ParValid := false;
            end;
            ParValue := TLongint.Create(vlNumber);
            ;
      end;
      
      Procedure TELA_Parser._RStringConstant ( var ParValue : TValue);
       
      var
      	vlStr : ansistring;
      
      begin
            if (GetSym = 25) then begin
                  _RCharConst( ParValue);
            end
             else if (GetSym in [2 , 6]) then begin
                  _RText( vlStr);
                   ParValue := TString.Create(vlStr);;
            end
            else begin
                  SynError(151);
            end;
            ;end;
      
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
      
      Procedure TELA_Parser._RCharConst ( var ParValue : TValue);
       
      var
      		vlNumber : TNumber;
      
      begin
            _ICharType;
            Expect(103);
            _RDirectNumber( vlNumber);
            Expect(104);
             
            if not(LargeInIntRange(vlNumber,0,255)) then SemError(Err_Num_Out_Of_range);
            ParValue := TString.Create(chr(vlNumber.vrNumber));
            ;
      end;
      
      Procedure TELA_Parser._IXor;
      begin
            Expect(102);
      end;
      
      Procedure TELA_Parser._IWith;
      begin
            Expect(101);
      end;
      
      Procedure TELA_Parser._IWhile;
      begin
            Expect(100);
      end;
      
      Procedure TELA_Parser._IVoidType;
      begin
            Expect(99);
      end;
      
      Procedure TELA_Parser._IWriteln;
      begin
            Expect(98);
      end;
      
      Procedure TELA_Parser._IWrite;
      begin
            Expect(97);
      end;
      
      Procedure TELA_Parser._IWhere;
      begin
            Expect(96);
      end;
      
      Procedure TELA_Parser._IVirtual;
      begin
            Expect(95);
      end;
      
      Procedure TELA_Parser._IValue;
      begin
            Expect(93);
      end;
      
      Procedure TELA_Parser._IUnion;
      begin
            Expect(90);
      end;
      
      Procedure TELA_Parser._IUntil;
      begin
            Expect(89);
      end;
      
      Procedure TELA_Parser._IType;
      begin
            Expect(88);
      end;
      
      Procedure TELA_Parser._IThen;
      begin
            Expect(87);
      end;
      
      Procedure TELA_Parser._ITo;
      begin
            Expect(86);
      end;
      
      Procedure TELA_Parser._IStep;
      begin
            Expect(85);
      end;
      
      Procedure TELA_Parser._IString;
      begin
            Expect(84);
      end;
      
      Procedure TELA_Parser._ISizeOf;
      begin
            Expect(83);
      end;
      
      Procedure TELA_Parser._ISigned;
      begin
            Expect(82);
      end;
      
      Procedure TELA_Parser._ISize;
      begin
            Expect(81);
      end;
      
      Procedure TELA_Parser._IShl;
      begin
            Expect(80);
      end;
      
      Procedure TELA_Parser._IShr;
      begin
            Expect(79);
      end;
      
      Procedure TELA_Parser._IRoot;
      begin
            Expect(78);
      end;
      
      Procedure TELA_Parser._IRepeat;
      begin
            Expect(77);
      end;
      
      Procedure TELA_Parser._IRecord;
      begin
            Expect(76);
      end;
      
      Procedure TELA_Parser._IRead;
      begin
            Expect(75);
      end;
      
      Procedure TELA_Parser._IPtr;
      begin
            Expect(74);
      end;
      
      Procedure TELA_Parser._IPrivate;
      begin
            Expect(72);
      end;
      
      Procedure TELA_Parser._IProtected;
      begin
            Expect(71);
      end;
      
      Procedure TELA_Parser._IProperty;
      begin
            Expect(70);
      end;
      
      Procedure TELA_Parser._IProcedure;
      begin
            Expect(68);
      end;
      
      Procedure TELA_Parser._IOwner;
      begin
            Expect(67);
      end;
      
      Procedure TELA_Parser._IOverride;
      begin
            Expect(66);
      end;
      
      Procedure TELA_Parser._IOverload;
      begin
            Expect(65);
      end;
      
      Procedure TELA_Parser._IOr;
      begin
            Expect(64);
      end;
      
      Procedure TELA_Parser._IOperator;
      begin
            Expect(63);
      end;
      
      Procedure TELA_Parser._IOf;
      begin
            Expect(62);
      end;
      
      Procedure TELA_Parser._IObject;
      begin
            Expect(61);
      end;
      
      Procedure TELA_Parser._INot;
      begin
            Expect(60);
      end;
      
      Procedure TELA_Parser._INumber;
      begin
            Expect(59);
      end;
      
      Procedure TELA_Parser._INil;
      begin
            Expect(58);
      end;
      
      Procedure TELA_Parser._IName;
      begin
            Expect(57);
      end;
      
      Procedure TELA_Parser._IMod;
      begin
            Expect(56);
      end;
      
      Procedure TELA_Parser._IMetaType;
      begin
            Expect(55);
      end;
      
      Procedure TELA_Parser._IMain;
      begin
            Expect(54);
      end;
      
      Procedure TELA_Parser._IIsolate;
      begin
            Expect(53);
      end;
      
      Procedure TELA_Parser._IInherited;
      begin
            Expect(52);
      end;
      
      Procedure TELA_Parser._IInherit;
      begin
            Expect(51);
      end;
      
      Procedure TELA_Parser._IInc;
      begin
            Expect(50);
      end;
      
      Procedure TELA_Parser._IIf;
      begin
            Expect(49);
      end;
      
      Procedure TELA_Parser._IHas;
      begin
            Expect(48);
      end;
      
      Procedure TELA_Parser._IFunction;
      begin
            Expect(47);
      end;
      
      Procedure TELA_Parser._IFrom;
      begin
            Expect(46);
      end;
      
      Procedure TELA_Parser._IFor;
      begin
            Expect(45);
      end;
      
      Procedure TELA_Parser._IFinal;
      begin
            Expect(44);
      end;
      
      Procedure TELA_Parser._ILeave;
      begin
            Expect(43);
      end;
      
      Procedure TELA_Parser._IExternal;
      begin
            Expect(42);
      end;
      
      Procedure TELA_Parser._IExit;
      begin
            Expect(41);
      end;
      
      Procedure TELA_Parser._IExact;
      begin
            Expect(40);
      end;
      
      Procedure TELA_Parser._IEnum;
      begin
            Expect(39);
      end;
      
      Procedure TELA_Parser._IElse;
      begin
            Expect(37);
      end;
      
      Procedure TELA_Parser._IDownTo;
      begin
            Expect(36);
      end;
      
      Procedure TELA_Parser._IDo;
      begin
            Expect(35);
      end;
      
      Procedure TELA_Parser._IDiv;
      begin
            Expect(34);
      end;
      
      Procedure TELA_Parser._IDestructor;
      begin
            Expect(33);
      end;
      
      Procedure TELA_Parser._IDefault;
      begin
            Expect(32);
      end;
      
      Procedure TELA_Parser._IDec;
      begin
            Expect(31);
      end;
      
      Procedure TELA_Parser._ICount;
      begin
            Expect(30);
      end;
      
      Procedure TELA_Parser._IContinue;
      begin
            Expect(29);
      end;
      
      Procedure TELA_Parser._IConstructor;
      begin
            Expect(28);
      end;
      
      Procedure TELA_Parser._IConst;
      begin
            Expect(27);
      end;
      
      Procedure TELA_Parser._IClass;
      begin
            Expect(26);
      end;
      
      Procedure TELA_Parser._ICharType;
      begin
            Expect(25);
      end;
      
      Procedure TELA_Parser._IBreak;
      begin
            Expect(23);
      end;
      
      Procedure TELA_Parser._IBetween;
      begin
            Expect(22);
      end;
      
      Procedure TELA_Parser._IBooleanType;
      begin
            Expect(21);
      end;
      
      Procedure TELA_Parser._IBegin;
      begin
            Expect(20);
      end;
      
      Procedure TELA_Parser._IAt;
      begin
            Expect(19);
      end;
      
      Procedure TELA_Parser._IAsciiz;
      begin
            Expect(18);
      end;
      
      Procedure TELA_Parser._IAsm;
      begin
            Expect(17);
      end;
      
      Procedure TELA_Parser._IAs;
      begin
            Expect(16);
      end;
      
      Procedure TELA_Parser._IArray;
      begin
            Expect(15);
      end;
      
      Procedure TELA_Parser._IAnd;
      begin
            Expect(14);
      end;
      
      Procedure TELA_Parser._IAll;
      begin
            Expect(13);
      end;
      
      Procedure TELA_Parser._IAbstract;
      begin
            Expect(11);
      end;
      
      Procedure TELA_Parser._RBlockOfCode ( ParNode : TSubListStatementNode);
       
      var
      	vlNode : TSubListStatementNode;
      
      begin
            _RCodes( vlNode);
             
            if ParNode <> nil then begin
            	ParNode.AddNode(vlNode);
            end else begin
            	vlNode.Destroy;
            end;
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
            WHILE vgDynSet[11].isSet(GetSym) do begin
                  case GetSym of
                        72 : begin
                              _IPrivate;
                               fNDCreator.fCurrentDefAccess := AF_Private; ;
                        end;
                        71 : begin
                              _IProtected;
                               fNDCreator.fCUrrentDefAccess := AF_Protected; ;
                        end;
                        70 : begin
                              _RProperty;
                        end;
                        94 : begin
                              _RVarBlock;
                        end;
                        88 : begin
                              _RTypeBlock;
                        end;
                         else begin
                              _RRoutine;
                        end;
                  end;
            end;
            if (GetSym = 20) then begin
                   
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
                  if vlMainCb <> nil then vlMainCb.FinishNode(fNDCreator);
                  ;
            end
             else if (GetSym = 38) then begin
                    vlroutine.PreNoMain(fNDCreator); ;
                  _IEnd;
            end
            else begin
                  SynError(152);
            end;
            ;Expect(8);
             
            
            if vlRoutine <> nil then begin
            	 vlRoutine.SetIsDefined;
            	if (vlRoutine.fStatements <> nil) and (vlMainCb <> vlRoutine) then vlRoutine.FinishNode(fNDCreator);
            end;
            fNDCreator.fCurrentDefAccess := vlPrvDefAccess;
            fNDCreator.EndIdentNum(vlLevel);
            ;
      end;
      
      Procedure TELA_Parser._IEnd;
      begin
            Expect(38);
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
      vlIdent   : ansistring;
      vlExt     : TExternalInterface;
      vlType    : TExternalType;
      vlRoutine : TRoutine;
      vlCDecl   : boolean;
      vlAt      : cardinal;
      vlHasAt   : boolean;
      vlHasses  : cardinal;
      vlExType  : ansistring;
      vlName    : ansistring;
      vlStr     : ansistring;
      
      begin
             
            vlHasAt := false;
            vlAt    := 0;
            vlType  := ET_Linked;
            vlCDecl := false;
            ;
            _IExternal;
            _RIdent( vlName);
            if (GetSym = 19) then begin
                  _IAt;
                  _RDirectCardinal( vlAt);
                    vlHasAt := true; ;
            end;
             	vlExt := CreateExternalInterface(vlName,vlHasAt,vlAt,vlCDecl);	;
            WHILE (GetSym in [47 , 68]) do begin
                  if (GetSym = 68) then begin
                        _RProcedureHead( vlRoutine,vlHasses);
                  end
                   else begin
                        _RFunctionHead( vlRoutine,vlHasses);
                  end
                  ;_IName;
                  _RDirectString( vlIdent);
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
                  SynError(153);
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
            Expect(24);
      end;
      
      Procedure TELA_Parser._IPublic;
      begin
            Expect(73);
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
            if (GetSym in [69 , 91]) then begin
                  _RMod_Type;
            end;
            if (GetSym = 92) then begin
                  _RUseBlock;
            end;
             
            if not SuccessFul then exit;
            fNDCreator.ProcessUseClause;
            if not SuccessFul then exit;
            Bind;
            if not successful then exit;
            ;
            WHILE (GetSym = 73) do begin
                  _IPublic;
                    vlSetMang := false; ;
                  if (GetSym = 24) then begin
                        _ICDecl;
                          vlSetMang := true;   ;
                  end;
                   
                  vlHasPublic := true;
                  fNDCreator.SetCurrentDefModes([DM_CPublic],vlSetMang);
                  fNDCreator.fInPublicSection  := true;
                  fNDCreator.fCUrrentDefAccess := AF_Public;
                  ;
                  WHILE vgDynSet[12].isSet(GetSym) do begin
                        if (GetSym = 88) then begin
                              _RTypeBlock;
                        end
                         else if (GetSym = 94) then begin
                              _RVarBlock;
                        end
                         else if (GetSym = 42) then begin
                              _RExternal;
                        end
                         else if (GetSym = 27) then begin
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
            WHILE vgDynSet[12].isSet(GetSym) do begin
                  if (GetSym = 88) then begin
                        _RTypeBlock;
                  end
                   else if (GetSym = 94) then begin
                        _RVarBlock;
                  end
                   else if vgDynSet[13].isSet(GetSym) then begin
                        _RRoutine;
                  end
                   else if (GetSym = 42) then begin
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
            if (GetSym = 20) then begin
                  _RBlockOfCode( vlPrn);
            end
             else if (GetSym = 38) then begin
                  _IEnd;
                    if (not fNDCreator.GetIsUnitFlag) then SemError(Err_Program_Needs_Main); ;
            end
            else begin
                  SynError(154);
            end;
            ;Expect(7);
             
            					   vlRoutine.fStatements := vlPrn;
            						vlPrn.FinishNode(fNDCreator,true);
            					   fNDCreator.EndIdent;
            					   WriteResFile;
            
            ;
      end;
      
      Procedure TELA_Parser._IProgram;
      begin
            Expect(69);
      end;
      
      Procedure TELA_Parser._IUnit;
      begin
            Expect(91);
      end;
      
      Procedure TELA_Parser._RMod_Type;
      begin
            if (GetSym = 91) then begin
                  _IUnit;
                     fNDCreator.SetIsUnitFlag(true); ;
            end
             else if (GetSym = 69) then begin
                  _IProgram;
            end
            else begin
                  SynError(155);
            end;
            ;Expect(8);
      end;
      
      Procedure TELA_Parser._IVar;
      begin
            Expect(94);
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
            if vgDynSet[14].isSet(GetSym) then begin
                  if (GetSym = 1) then begin
                        _RH_Type( ParType);
                  end
                   else begin
                        _RAnonymousType( ParType);
                  end
                  ;Expect(8);
            end
             else if (GetSym in [47 , 61 , 68]) then begin
                  _RRoutineTypeDecl( ParType);
                    AddAnonItem(ParType); ;
            end
            else begin
                  SynError(156);
            end;
            ;end;
      
      Procedure TELA_Parser._RVarDecl;
       
      var
      	vlIdent : ansistring;
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
            Expect(92);
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
      	vlName:ansistring;
      
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
      	vlName  : ansistring;
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
      	vlname:ansistring;
      
      begin
            _RIdent( vlName);
             
            ParDef := fNDCreator.GetPtr(vlName);
            if ParDef = nil then ErrorText(Err_Unkown_Ident,vlName);
            ;
      end;
      
      Procedure TELA_Parser._RNumber ( var ParNum : TNumber;var ParValid : boolean);
      begin
             
            	loadlong(ParNum,0);
            	ParValid := false;
            ;
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
                  SynError(157);
            end;
            ; 
            	if not(ParValid) then SemError(Err_Invalid_Number);
            ;
      end;
      
      Procedure TELA_Parser._RDec_Number ( var ParNum:TNumber; var ParValid:boolean);
       
      var
      vlTmp : ansistring;
      
      begin
            Expect(3);
             
            LexName(vlTmp);
            ParValid := not(StringToLarge(vlTmp, ParNum));
            if not ParValid then LoadLOng(ParNum,1);
            ;
      end;
      
      Procedure TELA_Parser._RBin_Number ( var ParNum:TNumber;var ParValid : boolean);
       
      var
      vlTmp:ansistring;
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
       
      var vlTmp : ansistring;
         vlErr : boolean;
      
      begin
            Expect(4);
             
            LexName(vlTmp);
            delete(vlTmp,1,1);
            ParNum := HexToLongint(vlTmp,vlErr);
            ParValid := not vLErr;
            ;
      end;
      
      Procedure TELA_Parser._RText ( var ParString : ansistring);
      begin
            if (GetSym = 2) then begin
                  _RString( ParString);
            end
             else if (GetSym = 6) then begin
                  _RConfigVar( ParString);
            end
            else begin
                  SynError(158);
            end;
            ;end;
      
      Procedure TELA_Parser._RString ( var ParString:ansistring);
      begin
            Expect(2);
             
            LexString(ParString);
            ParString := copy(ParString,2,length(PArString)-2);
            ;
      end;
      
      Procedure TELA_Parser._RIdent ( var ParIdent:ansistring);
      begin
            Expect(1);
              LexName(ParIdent); ;
      end;
      
      Procedure TELA_Parser._RConfigVar ( var ParString : ansistring);
       
      var
      	vlIdent :ansistring;
      
      begin
            Expect(6);
            _RIdent( vlIdent);
                if not(GetConfig.GetVarValue(vlIdent,ParString)) then ErrorText(Err_Unkown_COnfig_Variable,vlIdent); ;
      end;
      
      procedure TELA_Parser.Parse;
      begin
            MaxT :=121;
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
                  		13: ParErr :='"ALL" expected';
                  		14: ParErr :='"AND" expected';
                  		15: ParErr :='"ARRAY" expected';
                  		16: ParErr :='"AS" expected';
                  		17: ParErr :='"ASM" expected';
                  		18: ParErr :='"ASCIIZ" expected';
                  		19: ParErr :='"AT" expected';
                  		20: ParErr :='"BEGIN" expected';
                  		21: ParErr :='"BOOLEANTYPE" expected';
                  		22: ParErr :='"BETWEEN" expected';
                  		23: ParErr :='"BREAK" expected';
                  		24: ParErr :='"CDECL" expected';
                  		25: ParErr :='"CHARTYPE" expected';
                  		26: ParErr :='"CLASS" expected';
                  		27: ParErr :='"CONST" expected';
                  		28: ParErr :='"CONSTRUCTOR" expected';
                  		29: ParErr :='"CONTINUE" expected';
                  		30: ParErr :='"COUNT" expected';
                  		31: ParErr :='"DEC" expected';
                  		32: ParErr :='"DEFAULT" expected';
                  		33: ParErr :='"DESTRUCTOR" expected';
                  		34: ParErr :='"DIV" expected';
                  		35: ParErr :='"DO" expected';
                  		36: ParErr :='"DOWNTO" expected';
                  		37: ParErr :='"ELSE" expected';
                  		38: ParErr :='"END" expected';
                  		39: ParErr :='"ENUM" expected';
                  		40: ParErr :='"EXACT" expected';
                  		41: ParErr :='"EXIT" expected';
                  		42: ParErr :='"EXTERNAL" expected';
                  		43: ParErr :='"LEAVE" expected';
                  		44: ParErr :='"FINAL" expected';
                  		45: ParErr :='"FOR" expected';
                  		46: ParErr :='"FROM" expected';
                  		47: ParErr :='"FUNCTION" expected';
                  		48: ParErr :='"HAS" expected';
                  		49: ParErr :='"IF" expected';
                  		50: ParErr :='"INC" expected';
                  		51: ParErr :='"INHERIT" expected';
                  		52: ParErr :='"INHERITED" expected';
                  		53: ParErr :='"ISOLATE" expected';
                  		54: ParErr :='"MAIN" expected';
                  		55: ParErr :='"METATYPE" expected';
                  		56: ParErr :='"MOD" expected';
                  		57: ParErr :='"NAME" expected';
                  		58: ParErr :='"NIL" expected';
                  		59: ParErr :='"NUMBER" expected';
                  		60: ParErr :='"NOT" expected';
                  		61: ParErr :='"OBJECT" expected';
                  		62: ParErr :='"OF" expected';
                  		63: ParErr :='"OPERATOR" expected';
                  		64: ParErr :='"OR" expected';
                  		65: ParErr :='"OVERLOAD" expected';
                  		66: ParErr :='"OVERRIDE" expected';
                  		67: ParErr :='"OWNER" expected';
                  		68: ParErr :='"PROCEDURE" expected';
                  		69: ParErr :='"PROGRAM" expected';
                  		70: ParErr :='"PROPERTY" expected';
                  		71: ParErr :='"PROTECTED" expected';
                  		72: ParErr :='"PRIVATE" expected';
                  		73: ParErr :='"PUBLIC" expected';
                  		74: ParErr :='"PTR" expected';
                  		75: ParErr :='"READ" expected';
                  		76: ParErr :='"RECORD" expected';
                  		77: ParErr :='"REPEAT" expected';
                  		78: ParErr :='"ROOT" expected';
                  		79: ParErr :='"SHR" expected';
                  		80: ParErr :='"SHL" expected';
                  		81: ParErr :='"SIZE" expected';
                  		82: ParErr :='"SIGNED" expected';
                  		83: ParErr :='"SIZEOF" expected';
                  		84: ParErr :='"STRING" expected';
                  		85: ParErr :='"STEP" expected';
                  		86: ParErr :='"TO" expected';
                  		87: ParErr :='"THEN" expected';
                  		88: ParErr :='"TYPE" expected';
                  		89: ParErr :='"UNTIL" expected';
                  		90: ParErr :='"UNION" expected';
                  		91: ParErr :='"UNIT" expected';
                  		92: ParErr :='"USES" expected';
                  		93: ParErr :='"VALUE" expected';
                  		94: ParErr :='"VAR" expected';
                  		95: ParErr :='"VIRTUAL" expected';
                  		96: ParErr :='"WHERE" expected';
                  		97: ParErr :='"WRITE" expected';
                  		98: ParErr :='"WRITELN" expected';
                  		99: ParErr :='"VOIDTYPE" expected';
                  		100: ParErr :='"WHILE" expected';
                  		101: ParErr :='"WITH" expected';
                  		102: ParErr :='"XOR" expected';
                  		103: ParErr :='"(" expected';
                  		104: ParErr :='")" expected';
                  		105: ParErr :='"+" expected';
                  		106: ParErr :='"-" expected';
                  		107: ParErr :='"*" expected';
                  		108: ParErr :='"=" expected';
                  		109: ParErr :='"[" expected';
                  		110: ParErr :='"]" expected';
                  		111: ParErr :='":=" expected';
                  		112: ParErr :='">" expected';
                  		113: ParErr :='">=" expected';
                  		114: ParErr :='"<=" expected';
                  		115: ParErr :='"<" expected';
                  		116: ParErr :='"<>" expected';
                  		117: ParErr :='"#" expected';
                  		118: ParErr :='"@" expected';
                  		119: ParErr :='"^" expected';
                  		120: ParErr :='">>" expected';
                  		121: ParErr :='not expected';
                  		122: ParErr :='Invalid short nested Routine:"BEGIN","@","-","+","(","SIZEOF'
                  			+'","OWNER","NOT","NIL","INHERITED","&",binary number ,hexidec'
                  			+'imal number,integer number,string,identifier expected';
                  		123: ParErr :='Invalid inherited:"OF",identifier expected';
                  		124: ParErr :='Invalid formula:"OWNER",identifier,"INHERITED",binary number'
                  			+' ,hexidecimal number,integer number,"&",string,"NIL","NOT","'
                  			+'SIZEOF","(" expected';
                  		125: ParErr :='Invalid expression:identifier,"&",string expected';
                  		126: ParErr :='Invalid syntax:":=","ELSE",";" expected';
                  		127: ParErr :='Invalid count statement:"ALL","FROM" expected';
                  		128: ParErr :='Invalid code item:"@","-","+","(","SIZEOF","OWNER","NOT","NI'
                  			+'L","INHERITED","&",binary number ,hexidecimal number,integer'
                  			+' number,string,identifier,"ASM","BREAK","CONTINUE" etc... ex'
                  			+'pected';
                  		129: ParErr :='Invalid increment/decrement statement:"INC","DEC" expected';
                  		130: ParErr :='Invalid increment/decrement statement:"WITH","ELSE",";" expe'
                  			+'cted';
                  		131: ParErr :='Invalid write statement:"WRITE","WRITELN" expected';
                  		132: ParErr :='Invalid routine header:"PROCEDURE","FUNCTION","DESTRUCTOR","'
                  			+'CONSTRUCTOR","OPERATOR" expected';
                  		133: ParErr :='Invalid routine header:"NAME","EXACT",";" expected';
                  		134: ParErr :='Invalid parameter mapping item:"@",identifier,"-","+","CHART'
                  			+'YPE","&",binary number ,hexidecimal number,integer number,st'
                  			+'ring expected';
                  		135: ParErr :='Invalid routine header:"CONSTRUCTOR","DESTRUCTOR" expected';
                  		136: ParErr :='Invalid operator header:"+","-","*","DIV","XOR","MOD","OR","'
                  			+'AND","=",">",">=","<=","<","<>",":=","BETWEEN","#","SHL","SH'
                  			+'R",identifier expected';
                  		137: ParErr :='Invalid operator header:"-","NOT","(" expected';
                  		138: ParErr :='Invalid routine name:"PRIVATE","PROTECTED","(",":",";" expec'
                  			+'ted';
                  		139: ParErr :='Invalid property definition:"READ","WRITE" expected';
                  		140: ParErr :='Invalid class definition:"WRITE","VAR","TYPE","PUBLIC","PRIV'
                  			+'ATE","PROTECTED","PROPERTY","PROCEDURE","OPERATOR","INHERIT"'
                  			+',"FUNCTION","END","DESTRUCTOR","CONSTRUCTOR","CONST",";" exp'
                  			+'ected';
                  		141: ParErr :='Invalid type declaration:"NUMBER",identifier,"VOIDTYPE","CHA'
                  			+'RTYPE","ENUM","PTR","STRING","ASCIIZ","UNION","VIRTUAL","OVE'
                  			+'RRIDE","ISOLATE","CLASS","RECORD" expected';
                  		142: ParErr :='Invalid type declaration:"VOIDTYPE","VIRTUAL","UNION","STRIN'
                  			+'G","RECORD","PTR","OVERRIDE","NUMBER","ISOLATE","ENUM","CLAS'
                  			+'S","CHARTYPE","BOOLEANTYPE","ASCIIZ","ARRAY",identifier etc.'
                  			+'.. expected';
                  		143: ParErr :='Invalid type definition:"SIZE",";" expected';
                  		144: ParErr :='Invalid type declaration:"ARRAY","NUMBER","ASCIIZ","STRING",'
                  			+'"PTR","RECORD","UNION" expected';
                  		145: ParErr :='Invalid pointer type declaration:"UNION","STRING","RECORD","'
                  			+'PTR","NUMBER","ASCIIZ","ARRAY",identifier expected';
                  		146: ParErr :='Invalid type definition:"PROCEDURE","FUNCTION" expected';
                  		147: ParErr :='Invalid type:identifier,"STRING","PTR","NUMBER","ASCIIZ" exp'
                  			+'ected';
                  		148: ParErr :='Invalid identifier:"-","+",binary number ,hexidecimal number'
                  			+',integer number,"CHARTYPE","&",string expected';
                  		149: ParErr :='Invalid identifier:binary number ,hexidecimal number,integer'
                  			+' number,identifier,"CHARTYPE","&",string expected';
                  		150: ParErr :='Invalid formula:"CHARTYPE","&",binary number ,hexidecimal nu'
                  			+'mber,integer number,string,identifier,"(","NIL","NOT","SIZEO'
                  			+'F" expected';
                  		151: ParErr :='Invalid ansistring constant:"CHARTYPE","&",string expected';
                  		152: ParErr :='Invalid routine:"BEGIN","END" expected';
                  		153: ParErr :='Invalid type declaration:identifier,"ALIGN" expected';
                  		154: ParErr :='Invalid program definition:"BEGIN","END" expected';
                  		155: ParErr :='Invalid module type specification:"UNIT","PROGRAM" expected';
                  		156: ParErr :='Invalid type definition:"UNION","STRING","RECORD","PTR","NUM'
                  			+'BER","ASCIIZ","ARRAY",identifier,"PROCEDURE","OBJECT","FUNCT'
                  			+'ION" expected';
                  		157: ParErr :='Invalid number:integer number,binary number ,hexidecimal num'
                  			+'ber expected';
                  		158: ParErr :='Invalid ansistring:string,"&" expected';
            end;
      end;
      
      destructor  TELA_Parser.destroy;
      begin
            inherited destroy;
            DestroyDynSet(vgDynSet);
      end;
      
      const
      vgSetFill0:ARRAY[1..1] of cardinal=(0);
      vgSetFill1:ARRAY[1..15] of cardinal=(1,2,3,4,5,6,52,58,60,67,83,103,105,106,118);
      vgSetFill2:ARRAY[1..7] of cardinal=(1,28,33,47,63,68,97);
      vgSetFill3:ARRAY[1..30] of cardinal=(1,2,3,4,5,6,17,20,23,29,30,31,41,43,45,49,50,52,58,60,67,77,83,97,98,100,103,105,106,118);
      vgSetFill4:ARRAY[1..13] of cardinal=(27,28,33,47,54,63,68,70,71,72,88,94,97);
      vgSetFill5:ARRAY[1..8] of cardinal=(2,3,4,5,6,25,105,106);
      vgSetFill6:ARRAY[1..15] of cardinal=(27,28,33,38,47,51,63,68,70,71,72,73,88,94,97);
      vgSetFill7:ARRAY[1..13] of cardinal=(27,28,33,47,63,68,70,71,72,73,88,94,97);
      vgSetFill8:ARRAY[1..16] of cardinal=(1,15,18,21,25,26,39,53,59,66,74,76,84,90,95,99);
      vgSetFill9:ARRAY[1..14] of cardinal=(1,18,25,26,39,53,59,66,74,76,84,90,95,99);
      vgSetFill10:ARRAY[1..7] of cardinal=(15,18,59,74,76,84,90);
      vgSetFill11:ARRAY[1..11] of cardinal=(28,33,47,63,68,70,71,72,88,94,97);
      vgSetFill12:ARRAY[1..10] of cardinal=(27,28,33,42,47,63,68,88,94,97);
      vgSetFill13:ARRAY[1..6] of cardinal=(28,33,47,63,68,97);
      vgSetFill14:ARRAY[1..8] of cardinal=(1,15,18,59,74,76,84,90);
      
      
      procedure TELA_Parser.Commonsetup;
      begin
            
            inherited Commonsetup;
            iCase := false;
            
            MaxT := 121;
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
            end;
      end;
end
.