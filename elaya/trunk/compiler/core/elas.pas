Unit ELAS;
{=========================================}
{Dont''t edit, file generated           }
{=========================================}
INTERFACE
USES cmp_cons,cmp_base,ELA_user,ELA_cons;
type
TELA_Scanner=class(TELA_user)
      public
      function   Comment: boolean;
      procedure  SymGet (var Parsym: INTEGER);override;
      function   HandleIgnores(var Parsym:integer):boolean;
      procedure   CheckLiteral(var ParSym:integer);
end;


IMPLEMENTATION
CONST 
 Start:array[#0..#255] of word=(
37,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,33
,10,12,14, 2
,19,20,23,21
,17,22,15,38
, 4, 4, 4, 4
, 4, 4, 4, 4
, 4, 4,18,16
,30,24,28,38
,34, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1,25
,38,26,35, 1
,38, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38
,38,38,38,38);

const
    noSym=121;


function TELA_Scanner.Comment: boolean;
var
      level        : longint;
      startLine    : longint;
      oldLineStart : longint;
begin
      level := 1;
      startLine := curLine;
      oldLineStart := lineStart;
      if ch='{' then begin
        NextCh;
        while true do begin
          if ch='}'then begin
                    DEC(level); oldEols := curLine - startLine; NextCh;
                    if level = 0 then exit(true);
        end else if ch =c_ef then exit(FALSE)
        else NextCh;
      end; { while true }
end;
exit(FALSE);
end;
procedure TELA_Scanner.CheckLiteral(var ParSym:integer);
var vlStr:string;
begin
      GetName(bp0,nextlen,vlStr);
      case byte(vlStr[1]) of
            65:   if vlStr ='AT' then ParSym := 19
                  else if vlStr ='ASCIIZ' then ParSym := 18
                  else if vlStr ='ASM' then ParSym := 17
                  else if vlStr ='AS' then ParSym := 16
                  else if vlStr ='ARRAY' then ParSym := 15
                  else if vlStr ='AND' then ParSym := 14
                  else if vlStr ='ALL' then ParSym := 13
                  else if vlStr ='ALIGN' then ParSym := 12
                  else if vlStr ='ABSTRACT' then ParSym := 11;
            66:   if vlStr ='BREAK' then ParSym := 23
                  else if vlStr ='BETWEEN' then ParSym := 22
                  else if vlStr ='BOOLEANTYPE' then ParSym := 21
                  else if vlStr ='BEGIN' then ParSym := 20;
            67:   if vlStr ='COUNT' then ParSym := 30
                  else if vlStr ='CONTINUE' then ParSym := 29
                  else if vlStr ='CONSTRUCTOR' then ParSym := 28
                  else if vlStr ='CONST' then ParSym := 27
                  else if vlStr ='CLASS' then ParSym := 26
                  else if vlStr ='CHARTYPE' then ParSym := 25
                  else if vlStr ='CDECL' then ParSym := 24;
            68:   if vlStr ='DOWNTO' then ParSym := 36
                  else if vlStr ='DO' then ParSym := 35
                  else if vlStr ='DIV' then ParSym := 34
                  else if vlStr ='DESTRUCTOR' then ParSym := 33
                  else if vlStr ='DEFAULT' then ParSym := 32
                  else if vlStr ='DEC' then ParSym := 31;
            69:   if vlStr ='EXTERNAL' then ParSym := 42
                  else if vlStr ='EXIT' then ParSym := 41
                  else if vlStr ='EXACT' then ParSym := 40
                  else if vlStr ='ENUM' then ParSym := 39
                  else if vlStr ='END' then ParSym := 38
                  else if vlStr ='ELSE' then ParSym := 37;
            70:   if vlStr ='FUNCTION' then ParSym := 47
                  else if vlStr ='FROM' then ParSym := 46
                  else if vlStr ='FOR' then ParSym := 45
                  else if vlStr ='FINAL' then ParSym := 44;
            72:   if vlStr ='HAS' then ParSym := 48;
            73:   if vlStr ='ISOLATE' then ParSym := 53
                  else if vlStr ='INHERITED' then ParSym := 52
                  else if vlStr ='INHERIT' then ParSym := 51
                  else if vlStr ='INC' then ParSym := 50
                  else if vlStr ='IF' then ParSym := 49;
            76:   if vlStr ='LEAVE' then ParSym := 43;
            77:   if vlStr ='MOD' then ParSym := 56
                  else if vlStr ='METATYPE' then ParSym := 55
                  else if vlStr ='MAIN' then ParSym := 54;
            78:   if vlStr ='NOT' then ParSym := 60
                  else if vlStr ='NUMBER' then ParSym := 59
                  else if vlStr ='NIL' then ParSym := 58
                  else if vlStr ='NAME' then ParSym := 57;
            79:   if vlStr ='OWNER' then ParSym := 67
                  else if vlStr ='OVERRIDE' then ParSym := 66
                  else if vlStr ='OVERLOAD' then ParSym := 65
                  else if vlStr ='OR' then ParSym := 64
                  else if vlStr ='OPERATOR' then ParSym := 63
                  else if vlStr ='OF' then ParSym := 62
                  else if vlStr ='OBJECT' then ParSym := 61;
            80:   if vlStr ='PTR' then ParSym := 74
                  else if vlStr ='PUBLIC' then ParSym := 73
                  else if vlStr ='PRIVATE' then ParSym := 72
                  else if vlStr ='PROTECTED' then ParSym := 71
                  else if vlStr ='PROPERTY' then ParSym := 70
                  else if vlStr ='PROGRAM' then ParSym := 69
                  else if vlStr ='PROCEDURE' then ParSym := 68;
            82:   if vlStr ='ROOT' then ParSym := 78
                  else if vlStr ='REPEAT' then ParSym := 77
                  else if vlStr ='RECORD' then ParSym := 76
                  else if vlStr ='READ' then ParSym := 75;
            83:   if vlStr ='STEP' then ParSym := 85
                  else if vlStr ='STRING' then ParSym := 84
                  else if vlStr ='SIZEOF' then ParSym := 83
                  else if vlStr ='SIGNED' then ParSym := 82
                  else if vlStr ='SIZE' then ParSym := 81
                  else if vlStr ='SHL' then ParSym := 80
                  else if vlStr ='SHR' then ParSym := 79;
            84:   if vlStr ='TYPE' then ParSym := 88
                  else if vlStr ='THEN' then ParSym := 87
                  else if vlStr ='TO' then ParSym := 86;
            85:   if vlStr ='USES' then ParSym := 92
                  else if vlStr ='UNIT' then ParSym := 91
                  else if vlStr ='UNION' then ParSym := 90
                  else if vlStr ='UNTIL' then ParSym := 89;
            86:   if vlStr ='VOIDTYPE' then ParSym := 99
                  else if vlStr ='VIRTUAL' then ParSym := 95
                  else if vlStr ='VAR' then ParSym := 94
                  else if vlStr ='VALUE' then ParSym := 93;
            87:   if vlStr ='WITH' then ParSym := 101
                  else if vlStr ='WHILE' then ParSym := 100
                  else if vlStr ='WRITELN' then ParSym := 98
                  else if vlStr ='WRITE' then ParSym := 97
                  else if vlStr ='WHERE' then ParSym := 96;
            88:   if vlStr ='XOR' then ParSym := 102;
      end;
end;


function TELA_Scanner.HandleIgnores(var ParSym:integer):boolean;
begin
      HandleIgnores :=false;
      while ch in[' ',CHR(9)..CHR(10),CHR(13)] do NextCh;
      if ( ch='{' ) and Comment then begin
            SymGet(ParSym);
            HandleIgnores := true;
      end;
end;


procedure TELA_Scanner.SymGet (var ParSym: integer);
var
      vlState: longint;
begin
      Inherited SymGet(ParSym);
      if HandleIgnores(ParSym) then exit;
      pos := nextPos;   nextPos := GetBufferPos;
      col := nextCol;   nextCol := GetBufferPos - lineStart;
      line := nextLine; nextLine := curLine;
      len := nextLen;   nextLen := 0;
      apx:= 0;
      vlState := start[ch];
      bp0 := GetBufferPos;
      while true do begin
            NextCh;
            inc(nextLen);
            case vlState of
                   1:   case ch of
                              '0'..'9','A'..'Z','_','a'..'z': begin
                              end;
                              else begin
                                    ParSym := 1;
                                    CheckLiteral(ParSym);
                                     exit;
                              end;
                        end;
                   2:   case ch of
                              CHR(39): vlState := 3;
                              CHR(1)..CHR(9),CHR(11)..CHR(12),CHR(14)..'&','('..CHR(255): begin
                              end;
                              else begin
                                    ParSym := noSym;
                                     exit;
                              end;
                        end;
                   3:   begin
                              ParSym := 2;
                              exit;
                        end;
                   4:   case ch of
                              'E': vlState := 5;
                              '.': vlState := 8;
                              '0'..'9': begin
                              end;
                              else begin
                                    ParSym := 3;
                                    exit;
                              end;
                        end;
                   5:   case ch of
                              '0'..'9': vlState := 7;
                              '+','-': vlState := 6;
                              else begin
                                    ParSym := noSym;
                                     exit;
                              end;
                        end;
                   6:   case ch of
                              '0'..'9': vlState := 7;
                              else begin
                                    ParSym := noSym;
                                     exit;
                              end;
                        end;
                   7:   case ch of
                              '0'..'9': begin
                              end;
                              else begin
                                    ParSym := 3;
                                    exit;
                              end;
                        end;
                   8:   case ch of
                              '0'..'9': vlState := 9;
                              else begin
                                    ParSym := noSym;
                                     exit;
                              end;
                        end;
                   9:   case ch of
                              'E': vlState := 5;
                              '0'..'9': begin
                              end;
                              else begin
                                    ParSym := 3;
                                    exit;
                              end;
                        end;
                  10:   case ch of
                              '0'..'9','A'..'F': vlState := 11;
                              else begin
                                    ParSym := noSym;
                                     exit;
                              end;
                        end;
                  11:   case ch of
                              '0'..'9','A'..'F': begin
                              end;
                              else begin
                                    ParSym := 4;
                                    exit;
                              end;
                        end;
                  12:   case ch of
                              'B','b': vlState := 13;
                              else begin
                                    ParSym := noSym;
                                     exit;
                              end;
                        end;
                  13:   case ch of
                              '0'..'1': begin
                              end;
                              else begin
                                    ParSym := 5;
                                    exit;
                              end;
                        end;
                  14:   begin
                              ParSym := 6;
                              exit;
                        end;
                  15:   begin
                              ParSym := 7;
                              exit;
                        end;
                  16:   begin
                              ParSym := 8;
                              exit;
                        end;
                  17:   begin
                              ParSym := 9;
                              exit;
                        end;
                  18:   case ch of
                              '=': vlState := 27;
                              else begin
                                    ParSym := 10;
                                    exit;
                              end;
                        end;
                  19:   begin
                              ParSym := 103;
                              exit;
                        end;
                  20:   begin
                              ParSym := 104;
                              exit;
                        end;
                  21:   begin
                              ParSym := 105;
                              exit;
                        end;
                  22:   begin
                              ParSym := 106;
                              exit;
                        end;
                  23:   begin
                              ParSym := 107;
                              exit;
                        end;
                  24:   begin
                              ParSym := 108;
                              exit;
                        end;
                  25:   begin
                              ParSym := 109;
                              exit;
                        end;
                  26:   begin
                              ParSym := 110;
                              exit;
                        end;
                  27:   begin
                              ParSym := 111;
                              exit;
                        end;
                  28:   case ch of
                              '=': vlState := 29;
                              '>': vlState := 36;
                              else begin
                                    ParSym := 112;
                                    exit;
                              end;
                        end;
                  29:   begin
                              ParSym := 113;
                              exit;
                        end;
                  30:   case ch of
                              '=': vlState := 31;
                              '>': vlState := 32;
                              else begin
                                    ParSym := 115;
                                    exit;
                              end;
                        end;
                  31:   begin
                              ParSym := 114;
                              exit;
                        end;
                  32:   begin
                              ParSym := 116;
                              exit;
                        end;
                  33:   begin
                              ParSym := 117;
                              exit;
                        end;
                  34:   begin
                              ParSym := 118;
                              exit;
                        end;
                  35:   begin
                              ParSym := 119;
                              exit;
                        end;
                  36:   begin
                              ParSym := 120;
                              exit;
                        end;
                    37: begin
                        ParSym := 0;
                        ch := #0;
                        DecCurrentPos;
                        exit;
                  end;
                  else begin
                         ParSym := noSym;
                        exit;
                  end;
            end;
      end;
end;
end
.