UNIT CFGP;
{ =========================================}
{This file is generated, Please don''t edit}
{ =========================================}



Interface

Uses dynset,cmp_base,confnode,progutil,stdobj, CFGS,CFG_cons,CFG_user;

Type
TCFG_Parser=class(TCFG_scanner)
      protected
      procedure   Commonsetup;override;
      Public
      destructor  destroy;override;
      procedure   parse;override;
      procedure   Pragma;override;
      procedure   GetErrorText(ParNo:longint;var ParErr:ansistring);override;
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
      Procedure _RConstantText ( var ParTxt :ansistring);
      Procedure _Ransistring ( var ParTxt : ansistring);
      Procedure _RNumber ( var ParTxt : ansistring);
      Procedure _RIdent ( var ParIdent : ansistring);
      Procedure _IWrite;
      Procedure _IVar;
      Procedure _ISection;
      Procedure _IFail;
      Procedure _IEnd;
      Procedure _IDiv;
      Procedure _IConst;
end;




IMPLEMENTATION

(*    Elaya, the Fcompiler for the elaya language
    Copyright (C) 1999-2002  J.v.Iddekinge.
    Web   : www.elaya.org
    Email : iddekingej@lycos.com

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


procedure TCFG_Parser.pragma;
begin

      End;

      Procedure TCFG_Parser._CFG;
      begin
            WHILE (GetSym in [5 , 9 , 10]) do begin
                  if (GetSym in [5 , 10]) then begin
                        _RVarDecl;
                  end
                   else begin
                        _RSection( fConfig.fProgram);
                        Expect(19);
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
            if (GetSym = 15) then begin
                  Get;
                  WHILE (GetSym in [1 , 2 , 3 , 15]) do begin
                          vlNode := TEqualConfigNode.Create; ;
                        _RExpression( vlNode);
                        Expect(20);
                        _RExpression( vlNode);
                          vlSection.AddCondition(vlNode);  ;
                  end;
                  Expect(16);
            end;

            ParSection := vlSection;
            ;
      end;

      Procedure TCFG_Parser._RSection ( ParNode : TSubListNode);
        var vlSection : TSectionNode;
      begin
            _RSectionHead( ParNode,vlSection);
            WHILE (GetSym in [1 , 8 , 9 , 11]) do begin
                  _RCodeLine( vlSection);
                  Expect(19);
            end;
            _IEnd;
      end;

      Procedure TCFG_Parser._RCodeLine ( ParNode : TSubListNode);
      begin
            if (GetSym = 1) then begin
                  _RLoad( ParNode);
            end
             else if (GetSym = 9) then begin
                  _RSection( ParNode);
            end
             else if (GetSym = 11) then begin
                  _RWrite( ParNode);
            end
             else if (GetSym = 8) then begin
                  _RFail( ParNode);
            end
            else begin
                  SynError(22);
            end;
            ;end;

      Procedure TCFG_Parser._RVarDecl;

      var   vlName  : ansistring;
           vlValue : ansistring;
           vlReadOnly :boolean;

      begin

             EmptyString(vlName);
             EmptyString(vlValue);
            ;
            if (GetSym = 10) then begin
                  _IVar;
                    vlReadOnly := false; ;
            end
             else if (GetSym = 5) then begin
                  _IConst;
                    vlReadOnly := true; ;
            end
            else begin
                  SynError(23);
            end;
            ;_RIdent( vlName);
            if (GetSym = 17) then begin
                  Get;
                  _RConstantText( vlValue);
            end;
            Expect(19);
              AddVar(vlName,vlValue,vlReadOnly); ;
      end;

      Procedure TCFG_Parser._RFail ( ParNode : TSubListNode);

      var
      	vlNode : TFailNode;

      begin
              vlNode := TFailNode.Create; ;
            _IFail;
            Expect(15);
            _RExpression( vlNode);
            Expect(16);
              AddNodeToNode(ParNode,vlNode); ;
      end;

      Procedure TCFG_Parser._RWrite ( ParNode : TSubListNode);
         var
       vlNode : TWriteConfigNode;

      begin
              vlNode := TWriteConfigNode.Create;;
            _IWrite;
            Expect(15);
            _RExpression( vlNode);
            WHILE (GetSym = 18) do begin
                  Get;
                  _RExpression( vlNode);
            end;
            Expect(16);
              AddNodeTONode(ParNode,vlNode); ;
      end;

      Procedure TCFG_Parser._RLoad ( ParNode : TSubListNode);
        var
      vlIdent : ansistring;
      vlNode  : TLoadConfigNode;

      begin

            EmptyString(vlIdent);
            ;
            _RIdent( vlIdent);
               vlNode := CreateLoadNode(vlIdent);;
            Expect(17);
            _RExpression( vlNode);
               AddNodeToNode(ParNode,vlNode);;
      end;

      Procedure TCFG_Parser._RIdentExpression ( var ParNode : TSubListNode);

      var   vlTxt  : ansistring;

      begin
               EmptyString(vlTxt);
             ParNode := nil;
            ;
            if (GetSym = 2) then begin
                  _Ransistring( vlTxt);

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
             else if (GetSym = 15) then begin
                  Get;
                  _RExpression( ParNode);
                  Expect(16);
            end
            else begin
                  SynError(24);
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
            WHILE (GetSym in [6 , 14]) do begin
                  if (GetSym = 14) then begin
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
            WHILE (GetSym in [12 , 13]) do begin
                  if (GetSym = 12) then begin
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

      Procedure TCFG_Parser._RConstantText ( var ParTxt :ansistring);
      begin
              EmptyString(ParTxt); ;
            if (GetSym = 2) then begin
                  _Ransistring( ParTxt);
            end
             else if (GetSym = 3) then begin
                  _RNumber( ParTxt);
            end
            else begin
                  SynError(25);
            end;
            ;end;

      Procedure TCFG_Parser._Ransistring ( var ParTxt : ansistring);
      begin
            Expect(2);
              LexString(ParTxt);
            ParTxt := copy(ParTxt,2,length(ParTxt)-2);
            ;
      end;

      Procedure TCFG_Parser._RNumber ( var ParTxt : ansistring);
      begin
            Expect(3);
              LexName(ParTxt);  ;
      end;

      Procedure TCFG_Parser._RIdent ( var ParIdent : ansistring);
      begin
            Expect(1);
              LexName(ParIdent); ;
      end;

      Procedure TCFG_Parser._IWrite;
      begin
            Expect(11);
      end;

      Procedure TCFG_Parser._IVar;
      begin
            Expect(10);
      end;

      Procedure TCFG_Parser._ISection;
      begin
            Expect(9);
      end;

      Procedure TCFG_Parser._IFail;
      begin
            Expect(8);
      end;

      Procedure TCFG_Parser._IEnd;
      begin
            Expect(7);
      end;

      Procedure TCFG_Parser._IDiv;
      begin
            Expect(6);
      end;

      Procedure TCFG_Parser._IConst;
      begin
            Expect(5);
      end;

      procedure TCFG_Parser.Parse;
      begin
            MaxT :=21;
            SetupCompiler;
             Get;
            _CFG;
      end;
      procedure   TCFG_Parser.GetErrorText(ParNo:longint;var ParErr:ansistring);
      begin
            case ParNo of
                  		0: ParErr :='EOF expected';
                  		1: ParErr :='an identifier expected';
                  		2: ParErr :='a ansistring expected';
                  		3: ParErr :='a number expected';
                  		4: ParErr :='PRAGMA expected';
                  		5: ParErr :='"CONST" expected';
                  		6: ParErr :='"DIV" expected';
                  		7: ParErr :='"END" expected';
                  		8: ParErr :='"FAIL" expected';
                  		9: ParErr :='"SECTION" expected';
                  		10: ParErr :='"VAR" expected';
                  		11: ParErr :='"WRITE" expected';
                  		12: ParErr :='"+" expected';
                  		13: ParErr :='"-" expected';
                  		14: ParErr :='"*" expected';
                  		15: ParErr :='"(" expected';
                  		16: ParErr :='")" expected';
                  		17: ParErr :='":=" expected';
                  		18: ParErr :='"," expected';
                  		19: ParErr :='";" expected';
                  		20: ParErr :='"=" expected';
                  		21: ParErr :='not expected';
                  		22: ParErr :='Invalid statement:an identifier,"SECTION","WRITE","FAIL" exp'
                  			+'ected';
                  		23: ParErr :='Invalid Variable declaration:"VAR","CONST" expected';
                  		24: ParErr :='Invalid expression:a ansistring,a number,an identifier,"(" expec'
                  			+'ted';
                  		25: ParErr :='Invalid expression:a ansistring,a number expected';
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

            MaxT := 21;
            CreateDynSet(vgDynSet);
            if fOwnDynset then begin
                  vgDynSet[0].SetByArray(vgSetFill0);
            end;
      end;
end
.
