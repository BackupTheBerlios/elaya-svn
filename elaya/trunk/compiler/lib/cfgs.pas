Unit CFGS;
{=========================================}
{Dont''t edit, file generated           }
{=========================================}
INTERFACE
USES cmp_cons,cmp_base,CFG_user,CFG_cons;
type
TCFG_Scanner=class(TCFG_user)
      public
      function   Comment: boolean;
      procedure  SymGet (var Parsym: INTEGER);override;
      function   HandleIgnores(var Parsym:integer):boolean;
      procedure   CheckLiteral(var ParSym:integer);
end;


IMPLEMENTATION
CONST 
 Start:array[#0..#255] of word=(
15,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16, 2
, 8, 9, 7, 5
,12, 6,16,16
, 4, 4, 4, 4
, 4, 4, 4, 4
, 4, 4,10,13
,16,14,16,16
,16, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1,16
,16,16,16, 1
,16, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1, 1
, 1, 1, 1,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16
,16,16,16,16);

const
    noSym=21;


function TCFG_Scanner.Comment: boolean;
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
procedure TCFG_Scanner.CheckLiteral(var ParSym:integer);
var vlStr:string;
begin
      GetName(bp0,nextlen,vlStr);
      case byte(vlStr[1]) of
            67:   if vlStr ='CONST' then ParSym := 5;
            68:   if vlStr ='DIV' then ParSym := 6;
            69:   if vlStr ='END' then ParSym := 7;
            70:   if vlStr ='FAIL' then ParSym := 8;
            83:   if vlStr ='SECTION' then ParSym := 9;
            86:   if vlStr ='VAR' then ParSym := 10;
            87:   if vlStr ='WRITE' then ParSym := 11;
      end;
end;


function TCFG_Scanner.HandleIgnores(var ParSym:integer):boolean;
begin
      HandleIgnores :=false;
      while ch in[' ',CHR(9)..CHR(10),CHR(13)] do NextCh;
      if ( ch='{' ) and Comment then begin
            SymGet(ParSym);
            HandleIgnores := true;
      end;
end;


procedure TCFG_Scanner.SymGet (var ParSym: integer);
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
                              '0'..'9': begin
                              end;
                              else begin
                                    ParSym := 3;
                                    exit;
                              end;
                        end;
                   5:   begin
                              ParSym := 12;
                              exit;
                        end;
                   6:   begin
                              ParSym := 13;
                              exit;
                        end;
                   7:   begin
                              ParSym := 14;
                              exit;
                        end;
                   8:   begin
                              ParSym := 15;
                              exit;
                        end;
                   9:   begin
                              ParSym := 16;
                              exit;
                        end;
                  10:   case ch of
                              '=': vlState := 11;
                              else begin
                                    ParSym := noSym;
                                     exit;
                              end;
                        end;
                  11:   begin
                              ParSym := 17;
                              exit;
                        end;
                  12:   begin
                              ParSym := 18;
                              exit;
                        end;
                  13:   begin
                              ParSym := 19;
                              exit;
                        end;
                  14:   begin
                              ParSym := 20;
                              exit;
                        end;
                    15: begin
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