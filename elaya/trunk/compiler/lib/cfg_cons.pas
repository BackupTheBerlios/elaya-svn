unit cfg_cons;
{ This file is generated, Please don''t edit}

Interface

uses dynset;
const

	MaxP  =21;
	MaxSS =0;
	SetSize=16;

var
      vgDynSet : array[0..maxSS] of TDynamicSet;

Implementation

BEGIN 
      fillchar(vgDynSet, sizeof(vgDynSet),0);
END.
