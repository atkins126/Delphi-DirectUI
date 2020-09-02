unit uFlash;
interface
uses
   WinApi.windows, SysUtils, Classes, Zlib;
type
   TBitWidth = Integer;
   TSWFRect = packed record
     Xmin: Integer;                                           // in twips
     Xmax: Integer;                                           // in twips
     Ymin: Integer;                                           // in twips
     Ymax: Integer;                                           // in twips
   end;
   TSWFColor = packed record
     R : Byte;
     G : Byte;
     B : Byte;
     RGB : string;
   end;
   TSWFHeader = packed record
     Signature: array[0..2] of ansichar;
     Version: byte;
     FileLength: cardinal;
     FrameSize: TSWFRect;
     FrameRate: byte;
     FrameRateRemainder: byte;
     FrameCount: cardinal;
     BkColor : TSWFColor;
   end;
   TTagHandle   = record
     ID   : Integer;
     Length   : Integer;
     HandleLength   : Integer;
   end;

  function GetSwfFileHeader(const FileName: string; var Header: TSWFHeader): boolean;
  function GetSwfStreamHeader(const FileStream: TStream; var Header: TSWFHeader): boolean;

implementation
function ReadNBits(const Buffer; Position: longint; Count: TBitWidth): longint;
var
   I, B: longint;
begin
   Result := 0;
   B := 1 shl (Count - 1);
   for I := Position to Position + Count - 1 do
   begin
     if (PByteArray(@Buffer)^[I div 8] and (128 shr (I mod 8))) <> 0 then
       Result := Result or B;
     B := B shr 1;
   end;
end;

function ReadTagHandle(const Buffer; Position : Longint): TTagHandle;
var
   v : Smallint;
begin
   v :=   PSmallint(@PByteArray(@Buffer)^[Position])^;
   Result.ID :=   v shr 6;
   v :=   v shl 10;
   Result.Length :=   v shr 10;
   if Result.Length = $FFFFFF then
   begin
     //³¤tag
     Result.HandleLength :=   6;
     Result.Length :=   PInteger(@PByteArray(@Buffer)^[Position + 2])^;
   end
   else
     Result.HandleLength :=   2;
end;

function GetSwfFileHeader(const FileName: string; var Header: TSWFHeader): boolean;
var
   FileStream: TFileStream;
begin
   Result := False;
   if not FileExists(FileName) then Exit;
   FileStream := TFileStream.Create(FileName, fmOpenRead);
   try
    GetSwfStreamHeader(FileStream, Header);
   finally
     FileStream.Free;
   end;
end;

function GetSwfStreamHeader(const FileStream: TStream; var Header: TSWFHeader): boolean;
const
   BuffSize = 64;
var
   Buffer: PByteArray;
   NBitsField: byte;
   Poz: longword;
   MemStream: TMemoryStream;
   ZStream: TDecompressionStream;
   Tag : TTagHandle;
begin
   Result := False;
   FileStream.Position := 0;
   if FileStream.Size > 22 then
   begin
     GetMem(Buffer, BuffSize);
     try
       FileStream.Read(Header, 8);
       if (Header.Signature = 'CWS') and (Header.Version >= 6) then
       begin
         Result := True;
         MemStream := TMemoryStream.Create;
         try
           MemStream.CopyFrom(FileStream, FileStream.Size - 8);
           MemStream.Position := 0;
           ZStream := TDecompressionStream.Create(MemStream);
           try
             ZStream.Read(Buffer^, BuffSize);
           finally
             ZStream.Free;
           end;
         finally
           MemStream.Free;
         end;
       end
       else
       begin
         FileStream.Read(Buffer^, BuffSize);
         Result := Header.Signature = 'FWS';
       end;
       if Result then
         with Header do
         begin
           Poz := 0;
           NBitsField := TBitWidth(ReadNBits(Buffer^, Poz, 5));
           Inc(Poz, 5);
           FrameSize.Xmin := Integer(ReadNBits(Buffer^, Poz, NBitsField));
           Inc(Poz, NBitsField);
           FrameSize.Xmax := Integer(ReadNBits(Buffer^, Poz, NBitsField));
           Inc(Poz, NBitsField);
           FrameSize.Ymin := Integer(ReadNBits(Buffer^, Poz, NBitsField));
           Inc(Poz, NBitsField);
           FrameSize.Ymax := Integer(ReadNBits(Buffer^, Poz, NBitsField));
           Inc(Poz, NBitsField);

           Exit;

           NBitsField := Poz mod 8;
           Poz := Poz div 8;
           if (NBitsField > 0) then
             Inc(Poz);
           FrameRateRemainder := Buffer^[Poz];              // 8.[8]
           FrameRate := Buffer^[Poz + 1];
           FrameCount := Buffer^[Poz + 2] or (Buffer^[Poz + 3] shl 8);
           Inc(Poz, 4);
           Tag :=   ReadTagHandle(Buffer^, poz);
           while Tag.ID <> 9 do
           begin
             Inc(Poz, Tag.Length + Tag.HandleLength);
             Tag :=   ReadTagHandle(Buffer^, Poz);
           end;
           BkColor.R := Buffer^[Poz + 2];
           BkColor.G := Buffer^[Poz + 3];
           BkColor.B := Buffer^[Poz + 4];
           BkColor.RGB :=   StringReplace(
               Format('%2x%2x%2x', [BkColor.R, BkColor.G, BkColor.B]),
               ' ', '0', [rfReplaceAll]);
         end;
     finally
       FreeMem(Buffer);
     end;
   end;
end;

end.
