{Elaya, the compiler for the elaya language
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


unit frames;
interface
uses largenum,streams,compbase,formbase,ddefinit,varbase,node,stdobj,macobj,linklist,elacons,elatypes,error,display;
type
	TAddressing=class(TListItem)
	private
		voOwner   : TDefinition;
		voContext : TDefinition;
		voDestroy : boolean;
		
		property iOwner   : TDefinition read voOwner write voOwner;
		property iContext : TDefinition read voContext write voContext;
		property iDestroy : boolean     read voDestroy write voDestroy;
		procedure   Clear;override;
		
	public
		
		property fOwner   : TDefinition read voOwner;
		property fContext : TDefinition read voContext;
		
		constructor Create(ParOwner,ParContext : TDefinition;ParDestroy:boolean);
		function    CreateFramePointerMac(ParCre : TSecCreator) : TMacBase;virtual;
		function    CreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator;ParOffset : TOffset;ParSize : TSize;ParSign:boolean):TMacBase;virtual;
		procedure   DestroyFramePointer;virtual;
		function    GetContextName : string;
	end;
	
	TMacAddressing=class(TAddressing)
	private
		voFramePointer : TMacBase;
		property fFramePointer : TMacBase read voFramePointer write voFramePointer;
	public
		function    CreateFramePointerMac(ParCre : TSecCreator) : TMacBase;override;
		constructor Create(ParOwner ,ParContext: TDefinition;ParMac : TMacbase;ParDestroy : boolean);
		
	end;
	
	TNodeAddressing=class(TAddressing)
	private
        voNode : TNodeIdent;
		property iNode : TNodeIdent read voNode write voNode;
	public
		function    CreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator;ParOffset : TOffset;ParSize : TSize;ParSign:boolean):TMacBase;override;
		function    CreateFramePointerMac(ParCre : TSecCreator) : TMacBase;override;
		constructor Create(ParOwner ,ParContext: TDefinition;ParNode : TNodeIdent;ParDestroy : boolean);
	end;


	TVarAddressing=class(TAddressing)
	private
		voFrameVar       : TVarBase;
		voFrameVarContext: TDefinition;
		voMacOption      : TMacCreateOption;
		property fFrameVar        : TVarBase           read voFrameVar        write voFrameVar;
		property iFrameVarContext : TDefinition        read voFrameVarContext write voFrameVarContext;
		property iMacOption       : TMacCreateOption read voMacOption       write voMacOption;
	public
		function    CreateFramePointerMac(ParCre : TSecCreator) : TMacBase;override;
		constructor Create(ParMacOption : TMacCreateOption;ParOwner,ParContext,ParFrameVarContext : TDefinition;ParVar : TVarBase;ParDestroy:boolean);
		procedure   DestroyFramePointer;override;
		
	end;
	
	TAddressingList=class(TList)
		function GetAddressingByOwner(parOwner : TDefinition) : TAddressing;
		function GetCheckAddressingByOwner(parOwner : TDefinition) : TAddressing;
		procedure AddAddressing(ParAddressing:TAddressing);
		procedure PopAddressing(ParOwner : TDefinition);
		function  CreateFramePointerMac(ParCOntext : TDefinition;parCre : TSecCreator) : TMacBase;
		function  CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator;ParOffset : TOffset;ParSize : TSize;ParSign:boolean):TMacBase;
	end;
	
	TFrame= class(TStrAbelRoot)
	private
		voPrevious     : TFrame;
		voShare	       : TFrame;
		voAddressList  : TAddressingList;
		voUpDirection  : boolean;
		voFrameSize    : TOffset;
		property  iUpDirection  : boolean         read voUpDirection  write voUpDirection;
		property  iFrameSize  : TOffset	        read voFrameSize  write voFrameSize;
		property  iPrevious   : TFrame          read voPrevious   write voPrevious;
		property  iShare      : TFrame		read voShare	  write voShare;
		property  iAddressLIst : TAddressingList read voAddressList write voAddressList;
		procedure Commonsetup;override;
		procedure Clear;override;

	public
		procedure SetShare(ParFrame : TFrame);
		property  fPrevious  : TFrame          read voPrevious   write voPrevious;
		property  fShare     : TFrame	       read voShare	 write  SetShare;
		property  fFrameSize : TOffset	       read vOFrameSize;
		
		procedure AddAddressing(ParOwner,ParContext : TDefinition;ParVar  : TMacBase;ParDestroy : boolean);
		procedure AddAddressing(ParOwner,ParContext,ParFrameVarContext : TDefinition;ParVar  : TVarBase;ParDestroy : boolean);
		procedure AddAddressing(ParMacOption : TMacCreateOption;ParOwner,ParContext,ParFrameVarContext : TDefinition;ParVar : TVarBase;ParDestroy:boolean);
		procedure AddAddressing(ParOwner, ParContext : TDefinition;ParNode : TNodeIdent;ParDestroy : boolean);
		
		procedure PopAddressing(ParOwner : TDefinition);
		constructor Create(ParUpDirection : boolean);
		function  GetNewOffset(const ParSize : TSize) : TOffset;
		function  CreateMac(ParContext :TDefinition;ParOpt : TMacCreateOption;ParCre : TSecCreator;ParOffset : TOffset;ParSize : TSize;ParSign:boolean):TMacBase;
		function  CreateFramePointerMac(ParContext :TDefinition;ParCre : TSecCreator) : TMacBase;
		function  LoadItem(ParWrite : TObjectStream):boolean;override;
		function  SaveItem(ParWrite : TObjectStream):boolean;override;
		function  GetTotalSize : TSize;
		function  HasPrevious(ParFrame : TFrame):boolean;
		procedure Print(ParDis : TDisplay);
	end;
	
	TFrameVariable=class(TVariable)
	private
		
		voOffset : TOffset;
		voFrame  : TFrame;
		
	public
		property    fFrame  : TFrame  read voFrame  write voFrame;
		property    fOffset : TOffset read voOffset write voOffset;
		
		constructor Create(const ParName : String;ParFrame:TFrame;ParOffset : TOffset;ParType:TType);
		function    CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase; override;
		function    LoadItem(ParWrite:TObjectStream):boolean;override;
		function    SaveItem(ParWrite:TObjectStream):boolean;override;
		function    IsSame(ParVar : TVarBase):boolean;override;
		function    CreateDB(ParCre  : TCreator):boolean;override;
		procedure InitVariable(ParOwner,ParContext : TDefinition;ParFrame : TFrame);virtual;
		procedure DoneVariable(PArOwner : TDefinition;ParFrame : TFrame);virtual;
	end;
	
	
	
	
implementation

uses asminfo;

function    TNodeAddressing.CreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator;ParOffset : TOffset;ParSize : TSize;ParSign:boolean):TMacBase;
var
	vlMac : TMacBase;
begin
		if ParOpt = MCO_Result then begin
			vlMac := iNode.CreateMac(MCO_Result,ParCre);
			vlMac.AddExtraOffset(ParOffset);
			vlMac.SetSize(ParSize);
			vlMAc.SetSign(ParSign);
		end else begin
			vlMac := inherited CreateMac(ParOpt,ParCre,ParOffset,ParSize,ParSign);
		end;
		exit(vlMac);
end;


function    TNodeAddressing.CreateFramePointerMac(ParCre : TSecCreator) : TMacBase;
begin
	exit(iNode.CreateMac(MCO_ValuePointer,ParCre));
end;

constructor TNodeAddressing.Create(ParOwner ,ParContext: TDefinition;ParNode : TNodeIdent;ParDestroy : boolean);
begin
	inherited Create(ParOwner,ParContext,ParDestroy);
    iNode := ParNode;
end;


{--------( TFrameVariable )------------------------------------}

procedure TFrameVariable.DoneVariable(PArOwner : TDefinition;ParFrame : TFrame);
begin
end;

procedure TFrameVariable.InitVariable(ParOwner,ParContext : TDefinition;ParFrame : TFrame);
begin
end;


function  TFrameVariable.CreateDB(ParCre  : TCreator):boolean;
begin
	exit(false);
end;

function  TFrameVariable.IsSame(ParVar : TVarBase):boolean;
begin
	exit(ParVar=self);
end;


constructor TFrameVariable.Create(const ParName : String;PArFrame : TFrame;ParOffset : TOffset;ParType:TType);
begin
	inherited Create(ParName,ParType);
	fFrame  := ParFrame;
	fOffset := ParOffset;
end;

function   TFrameVariable.CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator):TMacBase;
var vlMac : TMacBase;
	vlName : string;
begin
	GetTextStr(vlName);
	if fFrame = nil then fatal(fat_No_Frame_Defined,'At:TFrameVariable.CreateMac');
	if ParOpt in [MCO_Result,MCO_ValuePointer,MCO_ObjectPointer] then begin
		vlMac := fFrame.CreateMac(ParContext,ParOpt,ParCre,fOffset,iType.fSize,iType.GetSign);
	end else begin
		vlMac := inherited CreateMac(ParContext,ParOpt,ParCre);
	end;
	exit(vlMac);
end;

function TFrameVariable.LoadItem(ParWrite:TObjectStream):boolean;
var vlOffset : TOffset;
begin
	if inherited LoadItem(parWrite) then exit(true);
	if ParWrite.ReadLongint(vlOffset) then exit(true);
	if ParWrite.ReadPi(voFrame) then exit(true);
	fOffset := vlOffset;
	exit(false);
end;

function TFrameVariable.SaveItem(ParWrite:TObjectStream):boolean;
begin
	if inherited SaveItem(ParWrite) then exit(true);
	if ParWrite.WriteLongint(fOffset) then exit(true);
	if ParWrite.WritePi(fFrame) then exit(true);
	exit(false);
end;



{---( TAddresssing )---------------------------------------------------------------}


function  TAddressing.GetContextName : string;
begin
	if iContext = nil then begin
		exit('<NULL>');
	end else begin
		exit(iContext.GetErrorName +'-'+iContext.ClassName);
	end;
end;


procedure TAddressing.DestroyFramePointer;
begin
end;

procedure TAddressing.Clear;
begin
	inherited Clear;
	if iDestroy then DestroyFramePointer;
end;

constructor TAddressing.Create(parOwner,ParContext : TDefinition;ParDestroy : boolean);
begin
	inherited Create;
	iOwner   := ParOwner;
	iContext := ParContext;
	iDestroy := ParDestroy;
end;

function    TAddressing.CreateFramePointerMac(ParCre : TSecCreator) : TMacBase;
begin
	exit(nil);
end;


function    TAddressing.CreateMac(ParOpt:TMacCreateOption;ParCre:TSecCreator;ParOffset : TOffset;ParSize : TSize;ParSign:boolean):TMacBase;
var vlMac  : TMacBase;
	vlMac2 : TMemOfsMac;
	vlLi   : TLargeNumber;
begin
	case ParOpt of
	MCO_Result : begin
		vlMac := CreateFramePointerMac(ParCre);
		vlMac := TByPointerMac.Create(ParSize,ParSign,vlMac);
		ParCre.AddObject(vlMac);
		vlMac.SetExtraOffset(ParOffset);
	end;
	MCO_ValuePointer,MCO_ObjectPointer:begin
		if ParOffset = 0 then begin
			vlMac := CreateFramePointerMac(ParCre);
		end else begin
			vlMac   := CreateMac(MCO_Result,ParCre,ParOffset,ParSize,ParSign);
			vlMac2  := TMemOfsMac.Create;
			ParCre.AddObject(vlMac2);
			vlMac2.SetSourceMac(vlMac);
			vlMac   := vlMac2;
		end;
	end;
	MCO_Size:begin
		LoadInt(vlLi,ParOffset);
		vlMac := ParCre.CreateNumberMac(GetAssemblerInfo.GetSystemSize,LargeIsNeg(vlLi),vlLi);
	end
	else vlMac := nil;
end;
exit(vlMac);
end;


{--( TMacAddressing )-------------------------------------------------------------}

constructor TMacAddressing.Create(ParOwner,ParContext : TDefinition;ParMac : TMacbase;ParDestroy : boolean);
begin
	inherited Create(ParOwner,ParContext,ParDestroy);
	fFramePointer := ParMac;
end;

function  TMacAddressing.CreateFramePointerMac( ParCre :TSecCreator):TMacBase;
begin
	exit(fFramePointer);
end;



{---( TVarAddressing )----------------------------------------------------------}

function    TVarAddressing.CreateFramePointerMac(ParCre : TSecCreator) : TMacBase;
begin
	exit(fFrameVar.CreateMac(iFrameVarContext,iMacOption, ParCre));
end;

constructor TVarAddressing.Create(ParMacOption : TMacCreateOption;ParOwner ,ParContext,ParFrameVarContext: TDefinition;ParVar : TVarBase;ParDestroy : boolean);
begin
	inherited Create(ParOwner,ParContext,ParDestroy);
	fFrameVar        := ParVar;
	iFrameVarContext := ParFrameVarContext;
	iMacOption       := ParMacOption;
end;

procedure TVarAddressing.DestroyFramePointer;
begin
	fFrameVar.Destroy;
end;

{---( TAddressingList )------------------------------------------------------------}


function TAddressingList.GetAddressingByOwner(parOwner : TDefinition) : TAddressing;
var
	vlCurrent : TAddressing;
begin
	vlCurrent := TAddressing(fTop);
	while (vlCurrent <> nil) do begin
		if (vlCurrent.fContext = ParOwner) then break;
		vlCurrent := TAddressing(vlCurrent.fPrv);
	end;
	exit(vlCurrent);
	
end;

function TAddressingList.GetCheckAddressingByOwner(ParOwner :TDefinition):TAddressing;
var
	vlName    : string;
	vlAddressing : TAddressing;
begin
	if fTop = nil then fatal(fat_no_addressing_Defined,'');
	vlAddressing := GetAddressingByOwner(ParOwner);
	if vlAddressing  = nil then begin
		vlAddressing := TAddressing(fTop);
		while(vlAddressing <> nil) do begin
			writeln(cardinal(vlAddressing.fContext),' ',cardinal(ParOwner),' ',vlAddressing.GetContextName);
			vlAddressing := TAddressing(vlAddressing.fPrv);
		end;
		if(ParOwner <> nil) then begin
			ParOwner.GetTextStr(vlName);
		end else begin
			vlName := '<NULL>';
		end;
		fatal(FAt_Addressing_not_found,vlName);
	end;
	exit(vlAddressing);
end;


function  TAddressingList.CreateFramePointerMac(ParContext : TDefinition;parCre : TSecCreator) : TMacBase;
var
	vlCurrent  :TAddressing;
begin
	
	vlCurrent := GetCheckAddressingByOwner(ParContext);
	exit(vlCurrent.CreateFramePointerMAc(ParCre));
end;

function  TAddressingList.CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator;ParOffset : TOffset;ParSize : TSize;ParSign:boolean):TMacBAse;
var
	vlCurrent : TAddressing;
begin
	vlCurrent := GetCheckAddressingByOwner(ParContext);
	exit(vlCurrent.CreateMac(ParOpt,ParCre,ParOffset,ParSize,PArSign));
end;

procedure TAddressingList.AddAddressing(ParAddressing:TAddressing);
begin
	insertAtTop(ParAddressing);
end;

procedure TAddressingList.PopAddressing(ParOwner : TDefinition);
var
	vlName1 : string;
	vlName2 : string;
begin
	if fTop = nil then begin
		ParOwner.GetTextStr(vlName1);
		Fatal(Fat_No_Addressing_defined ,[' name = ',vlName1]);
	end else if TAddressing(fTop).fOwner <> ParOwner then begin
		vlName1 := '<NULL>';
		if ParOwner <> nil then ParOwner.GetTextStr(vlName1);
		vlName2 := '<NULL>';
		if TAddressing(fTop).fOwner<> nil then TAddressing(fTop).fOwner.GetTextStr(vlName2);
		Fatal(FAT_Invalid_Pop_Addressing,['Owner: Parameter = ',vlName1,' and must be  Name2=',vlName2]);
	end;
	DeleteLink(fTop);
end;


{---( TFrame )---------------------------------------------------------------------}

procedure TFrame.SetShare(ParFrame : TFrame);
begin
	if ParFrame <> nil then begin
		if not (ParFrame is TFrame) then runerror(1023);
	end;
	iShare := ParFrame;
end;

procedure TFrame.Print(ParDis : TDisplay);
begin
	ParDis.Print(['Frame :',cardinal(self)]);ParDis.nl;
	ParDis.SetLeftMargin(3);
	if fPrevious <> nil then begin
		ParDis.Print(['Previous : ']);
		fPrevious.Print(ParDis);
	end;
	if fShare <> nil then begin
		ParDis.Print(['Share :']);
		fShare.Print(ParDis);
	end;
	ParDis.SetLeftMargin(-3);
END;

function  TFrame.HasPrevious(ParFrame : TFrame):boolean;
var vlFrame : TFrame;
begin
	vlFrame := self;
	while (vlFrame <> nil) and (vlFrame <> ParFrame) do vlFrame := vlFrame.fPrevious;
	if vlFrame <> nil then exit(true);
	vlFrame := self;
	while (vlFrame <> nil) and (vlFrame <> ParFrame) do vlFrame := vlFrame.fShare;
	exit(vlFrame <> nil);
	
end;


function  TFrame.CreateFramePointerMac(ParContext : TDefinition;ParCre : TSecCreator) : TMacBase;
begin
	exit(iAddressList.CreateFramePointerMac(ParContext,ParCre));
end;

function  TFrame.CreateMac(ParContext : TDefinition;ParOpt:TMacCreateOption;ParCre:TSecCreator;ParOffset : TOffset;ParSize : TSize;ParSign:boolean):TMacBase;
var
	vlPrevSize : longint;
begin
	if not (ParOpt in [MCO_Result,MCO_ObjectPointer,MCO_ValuePointer]) then begin
		fatal(fat_invalid_Mac_Number,['Mac_option=',cardinal(ParOpt)])
	end;
	if iPrevious <> nil then begin
		vlPrevSize := iPrevious.GetTotalSize;
		if not iUpDirection then vlPrevSize := -vlPrevSize;
	end else begin
		vlPrevSize := 0;
	end;
	exit(iAddressList.CreateMac(ParContext,ParOpt,PArCre,ParOffset+vlPrevSize,ParSIze,ParSign));
end;



procedure TFrame.AddAddressing(ParOwner, ParContext : TDefinition;ParVar : TMacBase;ParDestroy : boolean);
begin
	iAddressList.AddAddressing(TMacAddressing.Create(ParOwner,ParContext,ParVar,ParDestroy));
	if iPrevious <> nil then iPrevious.AddAddressing(ParOwner,ParContext,ParVar,false);
	if iShare    <> nil then iShare.AddAddressing(ParOwner,ParContext,parVar,false);
end;

procedure TFrame.AddAddressing(ParOwner, ParContext : TDefinition;ParNode : TNodeIdent;ParDestroy : boolean);
begin
	iAddressList.AddAddressing(TNodeAddressing.Create(ParOwner,ParContext,ParNode,ParDestroy));
	if iPrevious <> nil then iPrevious.AddAddressing(ParOwner,ParContext,ParNode,false);
	if iShare    <> nil then iShare.AddAddressing(ParOwner,ParContext,parNode,false);
end;

procedure TFrame.AddAddressing(ParOwner,ParContext,ParFrameVarContext : TDefinition;ParVar : TVarBase;ParDestroy:boolean);
begin
	iAddressList.AddAddressing(TVarAddressing.Create(MCO_Result,ParOwner,ParContext,ParFrameVarContext,ParVar,ParDestroy));
	if iPrevious <> nil then iPrevious.AddAddressing(ParOwner,ParContext,ParFrameVarContext,ParVar,false);
	if iShare  <> nil then iShare.AddAddressing(ParOwner,ParContext,ParFrameVarContext,ParVar,false);
end;

procedure TFrame.AddAddressing(ParMacOption : TMacCreateOption;ParOwner,ParContext,ParFrameVarContext : TDefinition;ParVar : TVarBase;ParDestroy:boolean);
begin
	iAddressList.AddAddressing(TVarAddressing.Create(ParMacOption,ParOwner,ParContext,ParFrameVarContext,ParVar,ParDestroy));
	if iPrevious <> nil then iPrevious.AddAddressing(ParOwner,ParContext,ParFrameVarContext,ParVar,false);
	if iShare  <> nil then iShare.AddAddressing(ParOwner,ParContext,ParFrameVarContext,ParVar,false);
end;

procedure TFrame.PopAddressing(ParOwner : TDefinition);
begin
	iAddressList.PopAddressing(ParOwner);
	if iPrevious <> nil then iPrevious.PopAddressing(ParOwner);
	if iShare <> nil    then iShare.PopAddressing(ParOwner);
end;

procedure TFrame.Commonsetup;
begin
	inherited Commonsetup;
	iAddressList := TAddressingList.Create;
	iPrevious   := nil;
	iShare      := nil;
	iFrameSize  := 0;
end;

procedure TFrame.Clear;
begin
	inherited Clear;
	if iAddressList <> nil then iAddressList.Destroy;
end;

function TFrame.LoadItem(ParWrite:TObjectStream):boolean;
begin
	if inherited LoadITem(ParWrite) then exit(true);
	if PArWrite.ReadBoolean(voUpDirection) then exit(true);
	if ParWrite.ReadLongint(voFrameSize) then exit(true);
	if ParWrite.ReadPi(voPrevious)       then exit(true);
	if ParWrite.ReadPi(voShare)	     then exit(true);
	exit(False);
end;

function TFrame.SaveItem(ParWrite:TObjectStream):boolean;
begin
	if inherited SaveItem(ParWrite) then exit(true);
	if ParWrite.WriteBoolean(iUpDirection) then exit(true);
	if ParWrite.Writelongint(iFrameSize) then exit(true);
	if ParWrite.WritePi(iPrevious)       then exit(true);
	if ParWrite.Writepi(iShare)	     then exit(true);
	exit(false);
end;


function TFrame.GetNewOffset(const ParSize : TSize) : TOffset;
var vlOffset : TOffset;
begin
	if not iUpDirection then  iFrameSize := iFrameSize - ParSize;
	vlOffset := iFrameSize;
	if iUpDirection then iFrameSIze := iFrameSize + ParSize;
	exit(vlOffset);
end;

function TFrame.GetTotalSize : TSize;
var vlPrevSize : TOffset;
begin
	if iPrevious <> nil then begin
		vlPrevSize := iPrevious.GetTotalSize;
	end else begin
		vlPrevSize :=0;
	end;
	if iUpDirection then inc(vlPrevSize,iFrameSize)
	else dec(vlPrevSize,iFrameSize);
	exit(vlPrevSize);
end;

constructor TFrame.Create(ParUpDirection : boolean);
begin
	inherited Create;
	iUpDirection := PArUpDirection;
end;

end.
