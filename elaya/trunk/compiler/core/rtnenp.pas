unit  rtnenp;
interface

uses asminfo,frames,macobj,pocobj,elatypes,stdobj,elacons,objlist,display,resource,lsstorag;
type
		TRoutinePoc=class(TSubPoc)
		private
			voName	              : AnsiString;
			voExitLabel           : TLabelPoc;
			voCDeclFlag           : boolean;
			voParamSize           : TSize;
			voLocalFramePtr       : TMacBase;
			voNeedStackFrame      : boolean;
			voHasNeverStackFrame  : boolean;
			voLocalFrame          : TFrame;
			voHasOwnFramePtr      : boolean;
			voObjectList          : TObjectList;
		protected
			property  iLocalFrame         : TFrame        read voLocalFrame         write voLocalFrame;
			property  iExitLabel          : TLabelPoc     read voExitLabel          write voExitLabel;
			property  iLocalFramePtr      : TMacBase      read voLocalFramePtr      write voLocalFramePtr;
			property  iCDeclFlag          : boolean       read voCDeclFlag          write voCDeclFlag;
			property  iParamSize          : TSize	      read voParamSize          write voParamSize;
			property  iName	              : AnsiString    read voName               write voName;
			property  iNeedStackFrame     : boolean       read voNeedStackFrame     write voNeedStackFrame;
			property  iHasNeverStackFrame : boolean       read voHasNeverStackFrame write voHasNeverStackFrame;
			property  iHasOwnFramePtr     : boolean       read voHasOwnFramePtr     write voHasOwnFramePtr;
			property  iObjectList         : TObjectList   read voObjectList          write voObjectLIst;
			procedure   Clear;override;
   		procedure   Commonsetup;override;

		public
			property  fObjectList         : TObjectList   read voObjectList;
			property  fHasNeverStackFrame : boolean    read voHasNeverStackFrame     write voHasNeverStackFrame;
			property  fNeedStackFrame     : boolean    read voNeedStackFrame         write voNeedStackFrame;
			property  fHasOwnFramePtr     : boolean    read voHasOwnFramePtr;
			property  fParamSize          : TSize      read voParamSize;
			property  fLocalFramePtr      : TMacBase   read voLocalFramePtr;
			property  fCDeclFlag          : boolean    read voCDeclFlag;
			property  fName               : AnsiString read voName;
			constructor Create(const ParName : String;ParCDeclFlag : boolean;ParOwnerPoc : TRoutinePoc;ParSharedLocalFrame : boolean;ParLocalframe : TFrame;ParParamSize : TSize);
			
			
			function  CreateInst(ParCre:TInstCreator):boolean;override;
			procedure Print(ParDis:TDisplay);override;
			procedure ProcessPocList(ParStorage : TTlvStorageList);
			function  CreateExitLabel : TLabelPoc;
			function  GetLocalSize : TSize;
			function  Optimize : boolean;override;
		end;
		
implementation


	{----( TRoutinePoc )------------------------------------------------------}
	
	
	function TRoutinePoc.GetLocalSize  : TSize;
	begin
		if iHasNeverStackFrame then begin
			exit(0);
		end else begin
			exit(iLocalFrame.GetTotalSize);
		end;
	end;
	
	constructor TRoutinePoc.Create(const ParName : String;ParCDeclFlag : boolean;
							ParOwnerPoc : TRoutinePoc;ParSharedLocalFrame : boolean;
					ParLocalframe : TFrame ;ParParamSize : TSize);
	begin
		iLocalFrame     := ParLocalFrame;
		inherited Create;
		iCDeclFlag     := ParCDeclFlag;
		iParamSize     := ParParamSize;
		iName          := ParName;
		if ParSharedLocalFrame  then begin
			iHasOwnFramePtr := false;
			iLocalFramePtr := ParOwnerPoc.fLocalFramePtr;
		end else begin
			iHasOwnFramePtr := true;
			iLocalFramePtr  := TResultMac.Create(GetAssemblerInfo.GetSystemSize,false);
			iObjectList.AddObject(iLocalFramePtr);
		end;
		
	end;
	
	procedure TRoutinePoc.Clear;
	begin
		inherited Clear;
		if iExitLabel  <> nil then iExitLabel.Destroy;
		if iObjectList <> nil then iObjectList.Destroy;
	end;
	
	procedure TRoutinePoc.Print(parDis:TDisplay);
	begin
		PArDis.Print(['---( ',iName,' )']);
		if ParDis.fWidth > ParDis.fCol then ParDis.WriteRep(ParDis.fWidth - ParDis.fCol,'-');
		ParDis.nl;
		ParDis.nl;
		parDis.Write('Frame Var=');
		iLocalFramePtr.Print(ParDis);
		ParDis.nl;
		fPocList.Print(ParDis);
	end;
	
	function TRoutinePoc.Optimize:boolean;
	begin
		exit(fPocList.Optimize);
	end;
	
	procedure TRoutinePoc.ProcessPocList(ParStorage : TTlvStorageList);
	begin
		if iExitLabel <> nil then begin
			fPocList.AddSec(iExitLabel);
			iExitLabel := nil;
		end;
		fPocList.AssignTLStorage(ParStorage);
		ParStorage.CalculateStorageAddress(iLocalFrame);
		LinearizeSubList;
		Optimize;
	end;
	
	procedure TRoutinePoc.Commonsetup;
	begin
		inherited Commonsetup;
		iExitLabel      := nil;
		iParamSize      := 0;
		iIdentCode      := (Ic_RoutinePoc);
		iNeedStackFrame := true;
		iHasNeverStackFrame := false;
		iObjectList     := TObjectList.Create;
	end;
	
	function TRoutinePoc.CreateExitLabel:TLabelPoc;
	begin
		if iExitLabel = nil then iExitLabel := TLabelPoc.Create;
		exit(iExitLabel);
	end;
	
	function  TRoutinePoc.CreateInst(ParCre:TInstCreator):boolean;
	begin
		GetAssemblerInfo.CreateRoutineInit(ParCre,self);
		if fPocList.CreateInst(ParCre) then exit(true);
		GetAssemblerInfo.CreateRoutineExit(parCre,self);
	end;


end.
