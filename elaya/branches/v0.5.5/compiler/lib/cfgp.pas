UNIT CFGP;
{ =========================================}
{This file is generated, Please don''t edit}
{ =========================================}



Interface

Uses dynset,cmp_base,confdef,confnode,config,cmp_cons,progutil,cfg_error,stdobj, CFGS,CFG_cons,CFG_user;

Type
TCFG_Parser=class(TCFG_scanner)
      protected
      procedure   Commonsetup;override;
      Public
      destructor  destroy;override;
      procedure   parse;override;
      procedure   Pragma;override;
      procedure   GetErrorText(ParNo:longint;var ParErr:string);override;
      Procedure _CFG;
      Procedure _RSectionHead ( ParNOde : TSubListNode;var ParSection : TSectionNode);
      Procedure _RSection ( ParNode : TSubListNode);
      Procedure _RCodeLine ( ParNode : TSubListNode);
      Procedure _RVarDecl;
      Procedure _RFail ( ParNode : TSubListNode);
      Procedure _RWrite ( ParNode : TSubListNode);
      Procedure _RLoad ( ParNode : TSubListNode);
      Procedure _RIdentExpression ( var ParNode : TSubListNode);
      Procedure _RMul ( var ParNode : TSubListNode);
      Procedure _RAdd ( var ParNode : TSubListNode);
      Procedure _RExpression ( var ParNode :TSubListNode);
      Procedure _RConstantText ( var ParTxt :string);
      Procedure _RString ( var ParTxt : string);
      Procedure _RNumber ( var ParTxt : string);
      Procedure _RIdent ( var ParIdent : string);
      Procedure _IWrite;
      Procedure _IVar;
      Procedure _ISection;
      Procedure _IFail;
      Procedure _IEnd;
      Procedure _IDiv;
      Procedure _IConst;
end;




IMPLEMENTATION

 procedure TCFG_Parser.pragma;
begin
      
      End;
      
      Procedure TCFG_Parser._CFG;
      begin
            WHILE (GetSym in [4 , 8 , 9]) do begin
                  if (GetSym in [4 , 9]) then begin
                        _RVarDecl;
                  end
                   else begin
                        _RSection( iConfig.fProgram);
                        Expect(18);
                  end
                  ;end;
            _IEnd;
      end;
      
      Procedure TCFG_Parser._RSectionHead ( ParNOde : TSubListNode;var ParSection : TSectionNode);
        var
          vlSection : TSectionNode;
          vlNode    : TEqualConfigNode;
      
      begin
             
            vlSection := TSectionNode.Create;
            AddNodeToNode(ParNode,vlSection);
            ;
            _ISection;
            if (GetSym = 14) then begin
                  Get;
                  WHILE (GetSym in [1 , 2 , 3 , 14]) do begin
                          vlNode := TEqualConfigNode.Create; ;
                        _RExpression( vlNode);
                        Expect(19);
                        _RExpression( vlNode);
                          vlSection.AddCondition(vlNode);  ;
                  end;
                  Expect(15);
            end;
             
            ParSection := vlSection;
            ;
      end;
      
      Procedure TCFG_Parser._RSection ( ParNode : TSubListNode);
        var vlSection : TSectionNode; 
      begin
            _RSectionHead( ParNode,vlSection);
            WHILE (GetSym in [1 , 7 , 8 , 10]) do begin
                  _RCodeLine( vlSection);
                  Expect(18);
            end;
            _IEnd;
      end;
      
      Procedure TCFG_Parser._RCodeLine ( ParNode : TSubListNode);
      begin
            if (GetSym = 1) then begin
                  _RLoad( ParNode);
            end
             else if (GetSym = 8) then begin
                  _RSection( ParNode);
            end
             else if (GetSym = 10) then begin
                  _RWrite( ParNode);
            end
             else if (GetSym = 7) then begin
                  _RFail( ParNode);
            end
            else begin
                  SynError(21);
            end;
            ;end;
      
      Procedure TCFG_Parser._RVarDecl;
       
      var   vlName  : string;
           vlValue : string;
           vlReadOnly :boolean;
      
      begin
             
             EmptyString(vlName);
             EmptyString(vlValue);
            ;
            if (GetSym = 9) then begin
                  _IVar;
                    vlReadOnly := false; ;
            end
             else if (GetSym = 4) then begin
                  _IConst;
                    vlReadOnly := true; ;
            end
            else begin
                  SynError(22);
            end;
            ;_RIdent( vlName);
            if (GetSym = 16) then begin
                  Get;
                  _RConstantText( vlValue);
            end;
            Expect(18);
              AddVar(vlName,vlValue,vlReadOnly); ;
      end;
      
      Procedure TCFG_Parser._RFail ( ParNode : TSubListNode);
       
      var
      	vlNode : TFailNode;
      
      begin
              vlNode := TFailNode.Create; ;
            _IFail;
            Expect(14);
            _RExpression( vlNode);
            Expect(15);
              AddNodeToNode(ParNode,vlNode); ;
      end;
      
      Procedure TCFG_Parser._RWrite ( ParNode : TSubListNode);
         var
       vlNode : TWriteConfigNode;
      
      begin
              vlNode := TWriteConfigNode.Create;;
            _IWrite;
            Expect(14);
            _RExpression( vlNode);
            WHILE (GetSym = 17) do begin
                  Get;
                  _RExpression( vlNode);
            end;
            Expect(15);
              AddNodeTONode(ParNode,vlNode); ;
      end;
      
      Procedure TCFG_Parser._RLoad ( ParNode : TSubListNode);
        var
      vlIdent : string;
      vlNode  : TLoadConfigNode;
      
      begin
             
            EmptyString(vlIdent);
            ;
            _RIdent( vlIdent);
               vlNode := CreateLoadNode(vlIdent);;
            Expect(16);
            _RExpression( vlNode);
               AddNodeToNode(ParNode,vlNode);;
      end;
      
      Procedure TCFG_Parser._RIdentExpression ( var ParNode : TSubListNode);
       
      var   vlTxt  : string;
      
      begin
               EmptyString(vlTxt);
             ParNode := nil;
            ;
            if (GetSym = 2) then begin
                  _RString( vlTxt);
                   
                  ParNode := CreateStringConstantNode(vlTxt);
                  ;
            end
             else if (GetSym = 3) then begin
                  _RNumber( vlTxt);
                   
                  ParNode := CreateIntConstantNode(vlTxt);
                  ;
            end
             else if (GetSym = 1) then begin
                  _RIdent( vlTxt);
                   
                  ParNode := GetVarNode(vlTxt);
                  ;
            end
             else if (GetSym = 14) then begin
                  Get;
                  _RExpression( ParNode);
                  Expect(15);
            end
            else begin
                  SynError(23);
            end;
            ;end;
      
      Procedure TCFG_Parser._RMul ( var ParNode : TSubListNode);
        var vlI2          : TMathCOnfigNode;
          vlCode        : TOperatorCode;
          vlPrvCode     : TOperatorCode;
      
      begin
             
            vlPrvCode := OC_None;
            ;
            _RIdentExpression( ParNode);
            WHILE (GetSym in [5 , 13]) do begin
                  if (GetSym = 13) then begin
                        Get;
                          vlCode := OC_Mul; ;
                  end
                   else begin
                        _IDiv;
                          vlCOde := OC_Div; ;
                  end
                  ;_RIdentExpression( vlI2);
                   
                  AddDualNode(vlPrvCode,ParNode,vlCode,vlI2);
                  ;
            end;
      end;
      
      Procedure TCFG_Parser._RAdd ( var ParNode : TSubListNode);
        var vlI2          : TMathCOnfigNode;
          vlCode        : TOperatorCode;
          vlPrvCode     : TOperatorCode;
      
      begin
             
            vlPrvCode := OC_None;
            ;
            _RMul( ParNode);
            WHILE (GetSym in [11 , 12]) do begin
                  if (GetSym = 11) then begin
                        Get;
                          vlCode := OC_Add; ;
                  end
                   else begin
                        Get;
                          vlCOde := OC_Sub; ;
                  end
                  ;_RMul( vlI2);
                   
                  AddDualNode(vlPrvCode,ParNode,vlCode,vlI2);
                  ;
            end;
      end;
      
      Procedure TCFG_Parser._RExpression ( var ParNode :TSubListNode);
       var
        vlNode : TSubListNode; 
      begin
            _RAdd( vlNode);
              AddNodeToNode(ParNode,vlNode); ;
      end;
      
      Procedure TCFG_Parser._RConstantText ( var ParTxt :string);
      begin
              EmptyString(ParTxt); ;
            if (GetSym = 2) then begin
                  _RString( ParTxt);
            end
             else if (GetSym = 3) then begin
                  _RNumber( ParTxt);
            end
            else begin
                  SynError(24);
            end;
            ;end;
      
      Procedure TCFG_Parser._RString ( var ParTxt : string);
      begin
            Expect(2);
              LexString(ParTxt);
            ParTxt := copy(ParTxt,2,length(ParTxt)-2);
            ;
      end;
      
      Procedure TCFG_Parser._RNumber ( var ParTxt : string);
      begin
            Expect(3);
              LexName(ParTxt);  ;
      end;
      
      Procedure TCFG_Parser._RIdent ( var ParIdent : string);
      begin
            Expect(1);
              LexName(ParIdent); ;
      end;
      
      Procedure TCFG_Parser._IWrite;
      begin
            Expect(10);
      end;
      
      Procedure TCFG_Parser._IVar;
      begin
            Expect(9);
      end;
      
      Procedure TCFG_Parser._ISection;
      begin
            Expect(8);
      end;
      
      Procedure TCFG_Parser._IFail;
      begin
            Expect(7);
      end;
      
      Procedure TCFG_Parser._IEnd;
      begin
            Expect(6);
      end;
      
      Procedure TCFG_Parser._IDiv;
      begin
            Expect(5);
      end;
      
      Procedure TCFG_Parser._IConst;
      begin
            Expect(4);
      end;
      
      procedure TCFG_Parser.Parse;
      begin
            MaxT :=20;
            SetupCompiler;
             Get;
            _CFG;
      end;
      procedure   TCFG_Parser.GetErrorText(ParNo:longint;var ParErr:string);
      begin
            case ParNo of
                  		0: ParErr :='EOF expected';
                  		1: ParErr :='an identifier expected';
                  		2: ParErr :='a string expected';
                  		3: ParErr :='a number expected';
                  		4: ParErr :='"CONST" expected';
                  		5: ParErr :='"DIV" expected';
                  		6: ParErr :='"END" expected';
                  		7: ParErr :='"FAIL" expected';
                  		8: ParErr :='"SECTION" expected';
                  		9: ParErr :='"VAR" expected';
                  		10: ParErr :='"WRITE" expected';
                  		11: ParErr :='"+" expected';
                  		12: ParErr :='"-" expected';
                  		13: ParErr :='"*" expected';
                  		14: ParErr :='"(" expected';
                  		15: ParErr :='")" expected';
                  		16: ParErr :='":=" expected';
                  		17: ParErr :='"," expected';
                  		18: ParErr :='";" expected';
                  		19: ParErr :='"=" expected';
                  		20: ParErr :='not expected';
                  		21: ParErr :='Invalid statement:an identifier,"SECTION","WRITE","FAIL" exp'
                  			+'ected';
                  		22: ParErr :='Invalid Variable declaration:"VAR","CONST" expected';
                  		23: ParErr :='Invalid expression:a string,a number,an identifier,"(" expec'
                  			+'ted';
                  		24: ParErr :='Invalid expression:a string,a number expected';
            end;
      end;
      
      destructor  TCFG_Parser.destroy;
      begin
            inherited destroy;
            DestroyDynSet(vgDynSet);
      end;
      
      const
      vgSetFill0:ARRAY[1..1] of cardinal=(0);
      
      
      procedure TCFG_Parser.Commonsetup;
      begin
            
            inherited Commonsetup;
            iCase := false;
            
            MaxT := 20;
            CreateDynSet(vgDynSet);
            if fOwnDynset then begin
                  vgDynSet[0].SetByArray(vgSetFill0);
            end;
      end;
end
.