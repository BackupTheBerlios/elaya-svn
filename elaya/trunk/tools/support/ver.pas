{ Check if version of freepascal is correct}

{$ifndef VER1_0_4}
{$ifndef VER1_0_6}
{$note ************ FATAL ERROR *************}
{$note *                                    *}
{$note * Elaya requires freepascal verion   *}
{$note *                1.0.4               *}
{$note *                                    *}
{$note **************************************}
{$fatal sorry I give up}
{$endif}
{$endif}

begin
end.
