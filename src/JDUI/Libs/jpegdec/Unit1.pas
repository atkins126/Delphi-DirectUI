unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  jpegdec, VCL.Menus, Vcl.Consts,
  Dialogs, ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, WinSpool,Printers;

type
  TForm1 = class(TForm)
    Image1: TImage;
    HotKey1: THotKey;
    Button1: TButton;
    Memo1: TMemo;
    ComboBox1: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure HotKey1Change(Sender: TObject);
    procedure HotKey1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TPrinterInfo = record
    SeverName         : PChar;
    PrinterName       : PChar;
    ShareName         : PChar;
    PortName          : PChar;
    DriverName        : PChar;
    Comment           : PChar;
    Location          : PChar;
    DeviceMode        : PDeviceModeW;
    SepFile           : PChar;
    PrintProcessor    : PChar;
    DataType          : PChar;
    Parameters        : PChar;
    SecurityDescriptor: PSecurityDescriptor;
    Attributes        : Cardinal;
    DefaultPriority   : Cardinal;
    StartTime         : Cardinal;
    UntilTime         : Cardinal;
    Status            : Cardinal;
    Jobs              : Cardinal;
    AveragePPM        : Cardinal;
end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function GetCurrentPrinterHandle(APrinter: PChar): THandle;
var
Device, Driver, Port : array[0..255] of char;
hDeviceMode: THandle;
begin
Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
if not OpenPrinter(APrinter, Result, nil) then RaiseLastWin32Error;
end;

function GetCurrentPrinterInformation(APrinter: PChar): TPrinterInfo;
var
hPrinter : THandle;
pInfo: PPrinterInfo2;
bytesNeeded: DWORD;
begin
hprinter := GetCurrentPrinterHandle(APrinter);
try
    Winspool.GetPrinter( hPrinter, 2, Nil, 0, @bytesNeeded );
    pInfo := AllocMem( bytesNeeded );
    try
      Winspool.GetPrinter( hPrinter, 2, pInfo, bytesNeeded, @bytesNeeded );
       Result.SeverName          := pInfo^.pServerName;
       Result.PrinterName        := pInfo^.pPrinterName;
       Result.ShareName          := pInfo^.pShareName;
       Result.PortName           := pInfo^.pPortName;
       Result.DriverName         := pInfo^.pDriverName;
       Result.Comment            := pInfo^.pComment;
       Result.Location           := pInfo^.pLocation;
       Result.DeviceMode         := pInfo^.pDevMode;
       Result.SepFile            := pInfo^.pSepFile;
       Result.PrintProcessor     := pInfo^.pPrintProcessor;
       Result.DataType           := pInfo^.pDatatype;
       Result.Parameters         := pInfo^.pParameters;
       Result.SecurityDescriptor := pInfo^.pSecurityDescriptor;
       Result.Attributes         := pInfo^.Attributes;
       Result.DefaultPriority    := pInfo^.DefaultPriority;
       Result.StartTime          := pInfo^.StartTime;
       Result.UntilTime          := pInfo^.UntilTime;
       Result.Status             := pInfo^.Status;
       Result.Jobs               := pInfo^.cJobs;
       Result.AveragePPM         := pInfo^.AveragePPM;
    finally
      FreeMem( pInfo );
    end;
finally
    ClosePrinter( hPrinter );
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  APrinter: String;
  PrinterInfo: TPrinterInfo;
begin
  for APrinter in Printer.Printers do
  begin
    PrinterInfo := GetCurrentPrinterInformation(PChar(APrinter));
    with memo1.Lines do
    begin
        Add('PrinterName: ' + PrinterInfo.PrinterName);
        Add('PaperSize: ' + IntToStr(PrinterInfo.DeviceMode.dmPaperSize));
        Add('PaperLength: ' + IntToStr(PrinterInfo.DeviceMode.dmPaperLength));
        Add('PaperWidth: ' + IntToStr(PrinterInfo.DeviceMode.dmPaperWidth));
        Add('PrintQuality: ' + IntToStr(PrinterInfo.DeviceMode.dmPrintQuality));
        Add('-------------------------------------------------------------------');
        Add('')
    end;
  end;
  //ComboBox1.Items.Assign(Printer.Printers);
  //ComboBox1.ItemIndex := 0;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  PrinterInfo: TPrinterInfo;
begin
  PrinterInfo := GetCurrentPrinterInformation(PChar(ComboBox1.Text));
  memo1.Clear;
with memo1.Lines do
begin
    Add('GENERAL INFORMATION');
    Add('');
    Add('ServerName: ' + PrinterInfo.SeverName);
    Add('PrinterName: ' + PrinterInfo.PrinterName);
    Add('ShareName: ' + PrinterInfo.ShareName);
    Add('PortName: ' + PrinterInfo.PortName);
    Add('DriverName: ' + PrinterInfo.DriverName);
    Add('Comment: ' + PrinterInfo.Comment);
    Add('Location: ' + PrinterInfo.Location);
    Add('SepFile: ' + PrinterInfo.SepFile);
    Add('PrintProcessor: ' + PrinterInfo.PrintProcessor);
    Add('DataType: ' + PrinterInfo.DataType);
    Add('Parameters: ' + PrinterInfo.Parameters);
    Add('Attributes: ' + IntToStr(PrinterInfo.Attributes));
    Add('DefaultPriority: ' + IntToStr(PrinterInfo.DefaultPriority));
    Add('StartTime: ' + IntToStr(PrinterInfo.StartTime));
    Add('UntilTime: ' + IntToStr(PrinterInfo.UntilTime));
    Add('Status: ' + IntToStr(PrinterInfo.Status));
    Add('Jobs: ' + IntToStr(PrinterInfo.Jobs));
    Add('AveragePPM: ' + IntToStr(PrinterInfo.AveragePPM));
    Add('');
    Add('DEVICEMODE INFORMATION');
    Add('');

    Add('DeviceName: ' + PrinterInfo.DeviceMode.dmDeviceName);
    Add('SpecVersion: ' + IntToStr(PrinterInfo.DeviceMode.dmSpecVersion));
    Add('DriverVersion: ' + IntToStr(PrinterInfo.DeviceMode.dmDriverVersion));
    Add('Size: ' + IntToStr(PrinterInfo.DeviceMode.dmSize));
    Add('DriverExtra: ' + IntToStr(PrinterInfo.DeviceMode.dmDriverExtra));
    Add('Fields: ' + IntToStr(PrinterInfo.DeviceMode.dmFields));
    Add('Orientation: ' + IntToStr(PrinterInfo.DeviceMode.dmOrientation));
    Add('PaperSize: ' + IntToStr(PrinterInfo.DeviceMode.dmPaperSize));
    Add('PaperLength: ' + IntToStr(PrinterInfo.DeviceMode.dmPaperLength));
    Add('PaperWidth: ' + IntToStr(PrinterInfo.DeviceMode.dmPaperWidth));
    Add('Scale: ' + IntToStr(PrinterInfo.DeviceMode.dmScale));
    Add('Copies: ' + IntToStr(PrinterInfo.DeviceMode.dmCopies));
    Add('DefaultSource: ' + IntToStr(PrinterInfo.DeviceMode.dmDefaultSource));
    Add('PrintQuality: ' + IntToStr(PrinterInfo.DeviceMode.dmPrintQuality));
    Add('Color: ' + IntToStr(PrinterInfo.DeviceMode.dmColor));
    Add('Duplex: ' + IntToStr(PrinterInfo.DeviceMode.dmDuplex));
    Add('YResolution: ' + IntToStr(PrinterInfo.DeviceMode.dmYResolution));
    Add('TTOption: ' + IntToStr(PrinterInfo.DeviceMode.dmTTOption));
    Add('Collate: ' + IntToStr(PrinterInfo.DeviceMode.dmCollate));
    Add('LogPixels: ' + IntToStr(PrinterInfo.DeviceMode.dmLogPixels));
    Add('BitsPerPel: ' + IntToStr(PrinterInfo.DeviceMode.dmBitsPerPel));
    Add('PelsWidth: ' + IntToStr(PrinterInfo.DeviceMode.dmPelsWidth));
    Add('PelsHeight: ' + IntToStr(PrinterInfo.DeviceMode.dmPelsHeight));
    Add('DisplayFlags: ' + IntToStr(PrinterInfo.DeviceMode.dmDisplayFlags));
    Add('DisplayFrequency: ' + IntToStr(PrinterInfo.DeviceMode.dmDisplayFrequency));
    Add('ICMMethod: ' + IntToStr(PrinterInfo.DeviceMode.dmICMMethod));
    Add('ICMintent: ' + IntToStr(PrinterInfo.DeviceMode.dmICMIntent));
    Add('MediaType: ' + IntToStr(PrinterInfo.DeviceMode.dmMediaType));
    Add('DitherType: ' + IntToStr(PrinterInfo.DeviceMode.dmDitherType));
    Add('ICCManufacturer: ' + IntToStr(PrinterInfo.DeviceMode.dmICCManufacturer));
    Add('ICCModel: ' + IntToStr(PrinterInfo.DeviceMode.dmICCModel));
    Add('PanningWidth: ' + IntToStr(PrinterInfo.DeviceMode.dmPanningWidth));
    Add('PanningHeight: ' + IntToStr(PrinterInfo.DeviceMode.dmPanningHeight));
end;
end;

procedure TForm1.FormShow(Sender: TObject);
var Bmp: TBitmap;
begin
  with TMemoryStream.Create do
  try
    LoadFromFile('C:\Users\jin\Desktop\i湖南高速公路图.jpg'); //Sample Pictures\Tree.jpg');
    Bmp := JpegDecode(Memory,Size);
    if Bmp<>nil then
    try
      Image1.Picture.Bitmap := Bmp;
    finally
      Bmp.Free;
    end;
  finally
    Free;
  end;
end;

type
  TMenuKeyCap = (mkcBkSp, mkcTab, mkcEsc, mkcEnter, mkcSpace, mkcPgUp,
    mkcPgDn, mkcEnd, mkcHome, mkcLeft, mkcUp, mkcRight, mkcDown, mkcIns,
    mkcDel, mkcShift, mkcCtrl, mkcAlt);

var
  MenuKeyCaps: array[TMenuKeyCap] of string = (
    SmkcBkSp, SmkcTab, SmkcEsc, SmkcEnter, SmkcSpace, SmkcPgUp,
    SmkcPgDn, SmkcEnd, SmkcHome, SmkcLeft, SmkcUp, SmkcRight,
    SmkcDown, SmkcIns, SmkcDel, SmkcShift, SmkcCtrl, SmkcAlt);

function GetSpecialName(ShortCut: TShortCut): string;
var
  ScanCode: Integer;
{$IF DEFINED(CLR)}
  KeyName: StringBuilder;
{$ELSE}
  KeyName: array[0..255] of Char;
{$ENDIF}
begin
  Result := '';
  ScanCode := MapVirtualKey(LoByte(Word(ShortCut)), 0) shl 16;
  if ScanCode <> 0 then
  begin
{$IF DEFINED(CLR)}
    KeyName := StringBuilder.Create(256);
    GetKeyNameText(ScanCode, KeyName, KeyName.Capacity);
    GetSpecialName := KeyName.ToString;
{$ELSE}
    if GetKeyNameText(ScanCode, KeyName, Length(KeyName)) <> 0 then
      Result := KeyName
    else
      Result := '';
{$ENDIF}
  end;
end;

function ShortCutToString(ShortCut: TShortCut): string;
var
  Name: string;
  Key: Byte;
begin
  Key := LoByte(Word(ShortCut));
  case Key of
    $08, $09:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcBkSp) + Key - $08)];
    $0D: Name := MenuKeyCaps[mkcEnter];
    $1B: Name := MenuKeyCaps[mkcEsc];
    $20..$28:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcSpace) + Key - $20)];
    $2D..$2E:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcIns) + Key - $2D)];
    $30..$39: Name := Chr(Key - $30 + Ord('0'));
    $41..$5A: Name := Chr(Key - $41 + Ord('A'));
    $60..$69: Name := Chr(Key - $60 + Ord('0'));
    $70..$87: Name := 'F' + IntToStr(Key - $6F);
  else
    Name := GetSpecialName(ShortCut);
  end;

  Result := '';
  if ShortCut and scShift <> 0 then Result := Result + MenuKeyCaps[mkcShift];
  if ShortCut and scCtrl <> 0 then Result := Result + MenuKeyCaps[mkcCtrl];
  if ShortCut and scAlt <> 0 then Result := Result + MenuKeyCaps[mkcAlt];
  Result := Result + Name;
end;

procedure TForm1.HotKey1Change(Sender: TObject);
begin
  Caption := ShortCutToString(HotKey1.HotKey);
end;

procedure TForm1.HotKey1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  Caption := Vcl.Menus.ShortCutToText(HotKey1.HotKey);
end;

end.
