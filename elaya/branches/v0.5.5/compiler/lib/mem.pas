{    Elaya, the compiler for the elaya language
Copyright (C) 1999-2003  J.v.Iddekinge.
Web : www.elaya.org

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

unit mem;

interface
uses progutil;
function mem_reserve(ParSize : cardinal) : pointer;
procedure Mem_Free(ParPtr : pointer);
procedure InitMemmoryManager;
procedure DoneMemmoryManager;

implementation
type
	PBlockInfo=^TBlockInfo;
	TBlockInfo=record
		vrNextBlock     : PBlockInfo;
		vrPrvBlock      : PBlockInfo;
		vrBlockSize     : cardinal;
		vrItemSize      : cardinal;
		vrFreeListTop   : ppointer;
		vrFreeListSize  : cardinal;
		vrFreeArea      : pointer;
		vrFreeAreaSize  : cardinal;
		vrNextInfo      : PBlockInfo;
      vrDm1           : cardinal;
		vrDm2           : cardinal;
		vrBi            : cardinal;
     end;


const
      		block_Extra=sizeof(Pointer);
		Max_Fast =512;
		align_Size=16;
		block_size = 8*4096;
      magic=$02091969;

var
	vgBlocks:array[0..Max_Fast div align_size] of PBlockInfo;
	vgTop   : array[0..Max_Fast div align_size] of PBlockInfo;
	vgFull  :array[0..Max_Fast div align_size] of PBlockInfo;
	vgPrvMan:TMemoryManager;

function sbrk(ParSIze : longint):pointer;cdecl;external 'c' name 'sbrk';
function malloc(ParSize : longint):pointer;cdecl;external 'c' name 'malloc';
function ReAlloc(ParPtr : pointer;ParSize : longint):pointer;cdecl;external 'c' name 'realloc';
procedure free(ParPtr : pointer);cdecl;external 'c' name 'free';


procedure InitBlock(ParBlock : PBlockInfo;ParBlockSize,ParItemSize : cardinal);
var
	vlNumItems : cardinal;
begin
	vlNumItems := (ParBlockSize - sizeof(TBlockInfo)) div (ParItemSize + Block_Extra);
   ParBlock^.vrNextBlock := nil;
	ParBlock^.vrPrvBlock := nil;
	ParBlock^.vrFreeListTop   := (pointer(ParBlock) + ParBlockSize - (vlNumItems+1) * sizeof(pointer));
	ParBlock^.vrFreeListSize  := 0;
	ParBlock^.vrFreeArea      := pointer(@(ParBlock^.vrBi));
	ParBlock^.vrFreeAreaSize  := vlNumItems;
	ParBlock^.vrBlockSize     := ParBlockSize;
	ParBlock^.vrItemSize      := ParItemSize;
	ParBlock^.vrDm1           := magic;
end;

function NewBlock(ParSize : cardinal) : pointer;
var
	vlPtr : pointer;
begin
   vlPtr := sbrk(ParSIze);
	exit(vlPtr);
end;

procedure Mem_Free(ParPtr : pointer);
var
	vlBlock : PBlockInfo;
	vlPtr   : pointer;
	vlNo    : cardinal;
	vlNext  : PBlockInfo;
	vlPrv   : PBlockInfo;
begin
	if ParPtr = nil then begin
		writeln('Free nil ptr');
		halt(1);
	end;
	vlPtr :=ParPtr - block_extra;
	vlBlock := (ppointer(vlPtr))^;
	if vlBlock = nil then begin
		free(ParPtr - 16);
		exit;
	end;

	if (pointer(vlBlock) > vlPtr) or (pointer(vlBlock) + block_size < vlPtr)  then begin
		writeln('invalid block');
		halt(1);
	end;
	if vlBlock^.vrDm1 <> magic then begin
		writeln('Invalid super block ',cardinal(ParPtr),'/',cardinal(vlBlock));
		halt(1);
	end;
	 if (vlBlock^.vrFreeListSize = 0) and (vlBlock^.vrFreeAreaSize =0) then begin
		vlNo := vlBlock^.vrItemSize div align_size-1;
		vlNext := vlBlock^.vrNextBlock;
		vlPrv  := vlBlock^.vrPrvBlock;
		if vlPrv <> nil then vlPrv^.vrNextBlock := vlNext;
		if vlNext <> nil then begin
			vlNext^.vrPrvBlock := vlPrv;
			vlBlock^.vrNextBlock := nil;
		end;
		vlBlock^.vrPrvBlock := vgTop[vlNo];
		if vgTop[vlNo] = nil then begin
			vgBlocks[vlNo] := vlBlock;
		end else begin
			vgTop[vlNo]^.vrNextBlock := vlBlock;
		end;
		vgTop[vlNo] := vlBlock;
		if vlPrv = nil then vgFull[vlNo] := vlNext;
	end;
	inc(vlBlock^.vrFreeListTop);
	inc(vlBlock^.vrFreeListSIze);
	vlBlock^.vrFreeListTop^ :=vlPtr;
end;


function mem_reserve(ParSize : cardinal) : pointer;
var
   vlBLock   : PBlockInfo;
	vlPtr     : pointer;
	vlNo      : cardinal;
	vlNext    : PBlockInfo;
	vlISize   : cardinal;

begin
	if ParSize < max_fast - block_extra then begin
		vlNo := (ParSize + block_extra) div Align_Size;
		vlBlock := vgBlocks[vlNo];
		if(vlBlock = nil) then begin
			vlBlock :=NewBlock(block_size);
			vlISize := (vlNo + 1) *Align_Size;
			InitBlock(vlBlock,block_size,vlISize);
			vgBlocks[vlNo] := vlBlock;
			vgTop[vlNo] := vlBlock;
		end;
		if vlBlock^.vrFreeListSize <> 0 then begin

			vlPtr :=vlBlock^.vrFreeListTop^;
			dec(vlBlock^.vrFreeListTop);
			dec(vlBlock^.vrFreeListSize);
			ppointer(vlPtr)^ :=vlBlock;
		end else if vlBlock^.vrFreeAreaSize   <> 0 then begin
			inc(vlBlock^.vrFreeArea,vlBlock^.vrItemSize);
			dec(vlBlock^.vrFreeAreaSize);
			vlPtr := vlBlock^.vrFreeArea;
			ppointer(vlPtr)^ :=vlBlock;
		end else begin
			writeln('Internal error <<',cardinal(vlBlock));
			halt(1);
		end;
		if (vlBlock^.vrFreeListSize = 0) and (vlBlock^.vrFreeAreaSize = 0) then begin
				vlNext := vlBlock^.vrNextBlock;
				vgBlocks[vlNo] := vlNext;
				if vlNext <> nil then begin
					vlNext^.vrPrvBlock := nil;
				end else begin
					vgTop[vlNo] := nil;
				end;
				vlBlock^.vrNextBlock := vgFull[vlNo];
				vgFull[vlNo] := vlBlock;
		end;
		inc(vlPtr,block_extra);
		exit(vlPtr);
	end;
	vlPtr :=malloc(ParSize + 32);
	inc(vlPtr,16);
	(ppointer(vlPtr)-1)^ := nil;
	exit(vlPtr);

end;

function DoMallocMem(ParSize :longint):pointer;
begin
	exit(mem_reserve(ParSize));
end;

function DoFreeMemSize(var ParPtr :pointer;ParSize : longint):longint;
begin
	Mem_Free(ParPtr);
	exit(ParSize);
end;

function AllocMem(ParSize : longint):pointer;
var
	vlPtr : pointer;
begin
	vlPtr := mem_reserve(ParSize);
	fillchar(vlPtr^,ParSize,0);
	exit(vlPtr);
end;


function ReAllocMem(var ParPtr : pointer;ParSize : longint):pointer;
var
	vlBlock : PBlockInfo;
	vlPtr   : pointer;
	vlSize  : cardinal;
begin
	vlBlock := (ppointer(ParPtr) - 1)^;
	if vlBlock = nil then begin
		exit(ReAlloc(ParPtr,ParSize));
	end;
	vlPtr := mem_reserve(ParSize);
	vlSize := vlBlock^.vrItemSize - block_extra;
	if vlSize > ParSize then vlSize := ParSize;
	move(ParPtr^,vlPtr^,vlSize);
	mem_free(ParPtr);
	exit(vlPtr);
end;

function DoFreemem(var ParPtr : pointer) : Longint;
begin
	mem_Free(ParPtr);
	exit(0);
end;

function MemSize(ParPtr: pointer):longint;
begin
	exit(0);
end;

function Avail : longint;
begin
	exit(0);
end;

procedure DoneMemmoryManager;
begin
	SetMemoryManager(vgPrvMan);
end;

procedure InitMemmoryManager;
var
	vlMan : TMemoryManager;
begin
	GetMemoryManager(vgPrvMan);
	vlMan.GetMem := @mem_reserve;
	vlMan.Freemem := @DoFreemem;
	vlMan.FreeMemSize := @DoFreememSize;
	vlMan.AllocMem := @AllocMem;
	vlMan.ReAllocMem := @ReAllocMem;
	vlMan.MemSize := @memsize;
	vlMan.MemAvail := @avail;
	vlMan.MaxAvail := @avail;
	vlMan.HeapSize := @avail;
	SetMemoryManager(vlMan);
end;

begin
	fillchar(vgBlocks,sizeof(vgBlocks),0);
	fillchar(vgFull,sizeof(vgFull),0);
	fillchar(vgTop,sizeof(vgTop),0);
end.
