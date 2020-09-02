unit dx_textbox;

{$I dx_define.inc}

interface

uses
  {$IFDEF FPC}
  LCLProc, LCLType, LMessages, LResources,
  {$ENDIF}
  {$ifdef win32}
  WinApi.Windows,
  {$endif}
  Classes, SysUtils, Controls, Forms, Menus, dx_utils, dx_scene,
  dx_objects, dx_vgcore;

type

  TdxTextBox3D = class(TdxShape3D)
  private
    FOnChange: TNotifyEvent;
    FReadOnly: boolean;
    FSelStart: integer;
    FSelLength: integer;
    FCaretPosition: integer;
    FMaxLength: integer;
    FFirstVisibleChar: integer;
    FLMouseSelecting: boolean;
    FNeedChange: boolean;
    FDisableCaret: boolean;
    FPassword: boolean;
    FPopupMenu: TPopupMenu;
    FOnTyping: TNotifyEvent;
    FText: WideString;
    FFont: TdxFont;
    FBackground: string;
    FSelection: string;
    FShowBackground: boolean;
    procedure InsertText(const AText: WideString);
    function GetSelLength: integer;
    function GetSelStart: integer;
    function GetSelText: WideString;
    procedure SetSelLength(const Value: integer);
    procedure SetSelStart(const Value: integer);
    function GetSelRect: TvxRect;
    procedure SetCaretPosition(const Value: integer);
    function GetCoordinatePosition(x: single): integer;
    procedure SetMaxLength(const Value: Integer);
    function GetNextWordBeging(StartPosition: integer): integer;
    function GetPrivWordBeging(StartPosition: integer): integer;
    procedure UpdateFirstVisibleChar;
    procedure UpdateCaretePosition;
    procedure SetPassword(const Value: boolean);
    procedure CreatePopupMenu;
    procedure DoCopy(Sender: TObject);
    procedure DoCut(Sender: TObject);
    procedure DoDelete(Sender: TObject);
    procedure DoPaste(Sender: TObject);
    procedure UpdatePopupMenuItems;
    procedure DoSelectAll(Sender: TObject);
    procedure SetFont(const Value: TdxFont);
    procedure SetBackground(const Value: string);
    procedure SetSelection(const Value: string);
    procedure SetShowBackground(const Value: boolean);
  protected
    procedure Change; virtual;
    function GetPasswordCharWidth: single;
    function TextWidth(const Str: WideString): single;
    procedure SetText(const Value: WideString); virtual;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    procedure ShapeMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: single); override;
    procedure ShapeMouseMove(Shift: TShiftState; X, Y: single); override;
    procedure ShapeMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: single); override;
    procedure FontChanged(Sender: TObject);
    procedure EnterFocus; override;
    procedure KillFocus; override;
    procedure ContextMenu(const ScreenPosition: TvxPoint); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function RayCastIntersect(const RayPos, RayDir: TdxVector;
      var Intersection: TdxVector): boolean; override;
    procedure Paint; override;
    procedure ClearSelection;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure PasteFromClipboard;
    procedure SelectAll;
    function GetCharX(a: integer): single;
    property CaretPosition: integer read FCaretPosition write SetCaretPosition;
    property SelStart: integer read GetSelStart write SetSelStart;
    property SelLength: integer read GetSelLength write SetSelLength;
    property SelText: WideString read GetSelText;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
  published
    property CanFocused default true;
    property Background: string read FBackground write SetBackground;
    property Selection: string read FSelection write SetSelection;
    property Cursor default crIBeam;
    property Font: TdxFont read FFont write SetFont;
    property Password: boolean read FPassword write SetPassword;
    property ShowBackground: boolean read FShowBackground write SetShowBackground default true;
    property Text: WideString read FText write SetText;
    property ReadOnly: boolean read FReadOnly write FReadOnly;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnTyping: TNotifyEvent read FOnTyping write FOnTyping;
  end;

implementation {===============================================================}

uses Clipbrd;

{ TdxTextBox3D ==================================================================}

constructor TdxTextBox3D.Create(AOwner: TComponent);
begin
  inherited;
  FBackground := '#B0505050';
  FSelection := '#802A8ADF';
  FShowBackground := true;
  FFont := TdxFont.Create;
  FFont.OnChanged := FontChanged;
  CanFocused := true;
  Cursor := crIBeam;
  AutoCapture := true;
  Width := 10;
  Height := 2;
  FCaretPosition := 0;
  FSelStart := 0;
  FSelLength := 0;
  FFirstVisibleChar := 1;
  CreatePopupMenu;
end;

destructor TdxTextBox3D.Destroy;
begin
  FPopupMenu.Free;
  FFont.Free;
  inherited;
end;

procedure TdxTextBox3D.CreatePopupMenu;
var
  TmpItem: TMenuItem;
begin
  FPopupMenu := TPopupMenu.Create(Self);

  TmpItem := TMenuItem.Create(FPopupMenu);
  with TmpItem do
  begin
    Caption := 'Cut';
    OnClick := DoCut;
  end;
  FPopupMenu.Items.Add(TmpItem);

  TmpItem := TMenuItem.Create(FPopupMenu);
  with TmpItem do
  begin
    Caption := 'Copy';
    OnClick := DoCopy;
  end;
  FPopupMenu.Items.Add(TmpItem);

  TmpItem := TMenuItem.Create(FPopupMenu);
  with TmpItem do
  begin
    Caption := 'Paste';
    OnClick := DoPaste;
  end;
  FPopupMenu.Items.Add(TmpItem);

  TmpItem := TMenuItem.Create(FPopupMenu);
  with TmpItem do
  begin
    Caption := 'Delete';
    OnClick := DoDelete;
  end;
  FPopupMenu.Items.Add(TmpItem);

//  FPopupMenu.Items.NewBottomLine;

  TmpItem := TMenuItem.Create(FPopupMenu);
  with TmpItem do
  begin
    Caption := 'Select All';
    OnClick := DoSelectAll;
  end;
  FPopupMenu.Items.Add(TmpItem);
end;

procedure TdxTextBox3D.DoSelectAll(Sender: TObject);
begin
  SelectAll;
end;

procedure TdxTextBox3D.DoCut(Sender: TObject);
begin
  CutToClipboard;
end;

procedure TdxTextBox3D.DoCopy(Sender: TObject);
begin
  CopyToClipboard;
end;

procedure TdxTextBox3D.DoDelete(Sender: TObject);
begin
  ClearSelection;
end;

procedure TdxTextBox3D.DoPaste(Sender: TObject);
begin
  PasteFromClipboard;
end;

procedure TdxTextBox3D.UpdatePopupMenuItems;
var
  SelTextEmpty: boolean;
begin
  SelTextEmpty := SelText <> '';
  FPopupMenu.Items.Find('Cut').Enabled := SelTextEmpty and not ReadOnly;
  FPopupMenu.Items.Find('Copy').Enabled := SelTextEmpty;
  FPopupMenu.Items.Find('Paste').Enabled := (Clipbrd.Clipboard.AsText <> '') and not ReadOnly;
  FPopupMenu.Items.Find('Delete').Enabled := SelTextEmpty and not ReadOnly;
  FPopupMenu.Items.Find('Select All').Enabled := SelText <> Text;
end;

function TdxTextBox3D.TextWidth(const Str: WideString): single;
var
  R: TvxRect;
  C: TvxCanvas;
begin
  R := vgRect(0, 0, $FFFF, Height * 10);
  C := dx_vgcore.DefaultCanvasClass.Create(1, 1);
  if C <> nil then
  begin
    C.Font.Family := Font.Family;
    C.Font.Style := TvxFontStyle(Font.Style);
    C.Font.Size := Font.Size;
    if FPassword then
      C.MeasureText(R, R, 'a', false, vgTextAlignNear, vgTextAlignCenter)
    else
      C.MeasureText(R, R, Str, false, vgTextAlignNear, vgTextAlignCenter);
    C.Free;
  end;
  Result := R.Right / 10;
end;

procedure TdxTextBox3D.Paint;
var
  i: integer;
  R: TvxRect;
  C: TvxCanvas;
  Path: TvxPathData;
  vP: TvxPolygon;
  B: TvxPoint;
begin
  { draw text }
  Canvas.Font.Assign(Font);
  if FPassword then
  begin
    R.Left := 0;
    R.Right := R.Left + Font.Size / 10 * 0.4;
    R.Top := -Font.Size / 10 * 0.4 / 2;
    R.Bottom := Font.Size / 10 * 0.4 / 2;
    for i := 1 to Length(Text) do
    begin
      Canvas.FillRect(R, Depth, AbsoluteOpacity);
      vgOffsetRect(R, TextWidth('a'), 0);
    end;
  end
  else
  begin
    if Text <> '' then
    begin
      C := dx_vgcore.DefaultCanvasClass.Create(1, 1);
      if C <> nil then
      begin
        C.Font.Family := Font.Family;
        C.Font.Style := TvxFontStyle(Font.Style);
        C.Font.Size := Font.Size;
        Path := TvxPathData.Create;
        R := vgRect(0, 0, Width * 10, Height * 10);
        if C.TextToPath(Path, R, Copy(Text, FFirstVisibleChar, Length(Text) - FFirstVisibleChar + 1), false, vgTextAlignNear, vgTextAlignCenter) then
        begin
          B := Path.FlattenToPolygon(vP, 0.25);
          if (B.X > 0) and (B.Y > 0) then
          begin
            Canvas.FillPolygon(dxVector(Width / 2, Height / 2, 0), dxVector(vgRectWidth(R) / 10, vgRectHeight(R) / 10, Depth), R, vP, AbsoluteOpacity);
          end;
        end;
        Path.Free;
        C.Free;
      end;
    end;
  end;
  { back }
  if ShowBackground then
  begin
    Canvas.Material.Diffuse := Background;
    Canvas.FillCube(dxVector(width / 2, height / 2, 0), dxVector(Width, Height, 0.01), AbsoluteOpacity);
  end;
  { carret }
  if not IsFocused then Exit;
  { selection }
  if SelLength > 0 then
  begin
    R := GetSelRect;
    Canvas.Material.Diffuse := FSelection;
    Canvas.FillRect(R, Depth + 0.002 { zbuffer }, AbsoluteOpacity);
    Exit;
  end;
  { carret }
  if FDisableCaret then Exit;
  R := vgRect(0, (Height / 2) - Font.Size / 10 / 2, Width, (Height / 2) + Font.Size / 10 / 2);
  R.Left := GetCharX(FCaretPosition);
  R.Right := R.Left + Font.Size / 10 / 10;
  Canvas.Material.Diffuse := FSelection;
  Canvas.FillRect(R, Depth + 0.002 { zbuffer }, AbsoluteOpacity);
end;

procedure TdxTextBox3D.InsertText(const AText: WideString);
var
  TmpS: WideString;
begin
  if ReadOnly then Exit;

  TmpS := Text;
//  FActionStack.FragmentDeleted(SelStart + 1, Copy(TmpS, SelStart+1, SelLength));
  Delete(TmpS, SelStart + 1, SelLength);
//  FActionStack.FragmentInserted(SelStart + 1, Length(AText), SelLength <> 0);
  Insert(AText, TmpS, SelStart + 1);
  if (MaxLength <= 0) or (Length(TmpS) <= MaxLength) then
  begin
    Text := TmpS;
    CaretPosition := SelStart + Length(AText);
  end;
  SelLength := 0;
end;

procedure TdxTextBox3D.UpdateFirstVisibleChar;
var
  LEditRect: TvxRect;
begin
  if FFirstVisibleChar >= (FCaretPosition + 1) then
  begin
    FFirstVisibleChar := FCaretPosition;
    if FFirstVisibleChar < 1 then
      FFirstVisibleChar := 1;
  end
  else
  begin
    LEditRect := vgRect(0, 0, Width, Height);

{    if PasswordKind <> pkNone then
      while ((FCaretPosition - FFirstVisibleChar + 1) * GetPasswordCharWidth >
        LEditRect.Right - LEditRect.Left)
        and (FFirstVisibleChar < Length(Text)) do
        Inc(FFirstVisibleChar)
    else }
    begin
      while (TextWidth(Copy(Text, FFirstVisibleChar, FCaretPosition - FFirstVisibleChar + 1)) > LEditRect.Right - LEditRect.Left) and (FFirstVisibleChar < Length(Text)) do
      begin
        if TextWidth(Copy(Text, FFirstVisibleChar + 500, (FCaretPosition - FFirstVisibleChar + 500) + 1)) > LEditRect.Right - LEditRect.Left then
          Inc(FFirstVisibleChar, 500)
        else
          if TextWidth(Copy(Text, FFirstVisibleChar + 100, (FCaretPosition - FFirstVisibleChar + 100) + 1)) > LEditRect.Right - LEditRect.Left then
            Inc(FFirstVisibleChar, 100)
          else
            if TextWidth(Copy(Text, FFirstVisibleChar + 50, (FCaretPosition - FFirstVisibleChar + 100) + 1)) > LEditRect.Right - LEditRect.Left then
              Inc(FFirstVisibleChar, 50)
            else
              if TextWidth(Copy(Text, FFirstVisibleChar + 10, (FCaretPosition - FFirstVisibleChar + 10) + 1)) > LEditRect.Right - LEditRect.Left then
                Inc(FFirstVisibleChar, 10)
              else
                Inc(FFirstVisibleChar);
      end;
    end;
  end;
  Repaint;
end;

procedure TdxTextBox3D.UpdateCaretePosition;
begin
  SetCaretPosition(CaretPosition);
end;

function TdxTextBox3D.GetPasswordCharWidth: single;
begin
  Result := TextWidth('a');
end;

function TdxTextBox3D.GetCoordinatePosition(x: single): integer;
var
  CurX: double;
  TmpX,
  WholeTextWidth: single;
  T: TvxObject;
  Str, StrA: WideString;
begin
  Result := FFirstVisibleChar - 1;
  if Length(Text) = 0 then
    Exit;
  if FPassword then
    WholeTextWidth := Length(Text) * GetPasswordCharWidth
  else
    WholeTextWidth := TextWidth(Copy(Text, 1, Length(Text)));

  TmpX := x;

  if FPassword then
  begin
    Result := Result + Trunc((TmpX) / GetPasswordCharWidth);
    if Result < 0 then
      Result := 0
    else
      if Result > Length(Text) then
        Result := Length(Text);
  end
  else
  begin
    StrA := System.Copy(Text, FFirstVisibleChar, Result - FFirstVisibleChar + 1);
    Str := System.Copy(Text, FFirstVisibleChar, Result - FFirstVisibleChar + 2);
    while (TextWidth(StrA) < TmpX) and (Result < Length(Text)) do
    begin
      if (TmpX > TextWidth(StrA) + ((TextWidth(Str) - TextWidth(StrA)) / 2)) and (TmpX < TextWidth(Str)) then
      begin
        Result := Result + 1;
        Break;
      end;
      if TmpX < TextWidth(Str) then Break;
      Result := Result + 1;
      StrA := Str;
      Str := Copy(Text, FFirstVisibleChar, Result - FFirstVisibleChar + 2);
    end;
  end;
end;

function TdxTextBox3D.GetCharX(a: integer): single;
var
  WholeTextWidth: single;
  R: TvxRect;
  C: TvxCanvas;
begin
  Result := 0;

  C := dx_vgcore.DefaultCanvasClass.Create(1, 1);
  if C = nil then Exit;
  C.Font.Family := Font.Family;
  C.Font.Style := TvxFontStyle(Font.Style);
  C.Font.Size := Font.Size;

  if FPassword then
    WholeTextWidth := Length(Text) * GetPasswordCharWidth
  else
    R := vgRect(0, 0, Width * 10, Height * 10);

  C.MeasureText(R, R, Text, false, vgTextAlignNear, vgTextAlignCenter);
  WholeTextWidth := R.Right / 10;

  if a > 0 then
  begin
    if FPassword then
    begin
      if a <= Length(Text) then
        Result := Result + (a - FFirstVisibleChar + 1) * GetPasswordCharWidth
      else
        Result := Result + (Length(Text) - FFirstVisibleChar + 1) * GetPasswordCharWidth;
    end
    else
    begin
      if a <= Length(Text) then
      begin
        R := vgRect(0, 0, Width * 10, Height * 10);
        C.MeasureText(R, R, Copy(Text, FFirstVisibleChar, a - FFirstVisibleChar + 1), false, vgTextAlignNear, vgTextAlignCenter);
        Result := Result + (R.Right / 10);
      end
      else
      begin
{        R := ContentRect;
        Canvas.MeasureText(R, R, Copy(Text, FFirstVisibleChar, Length(Text) - FFirstVisibleChar + 1), false, TextAlign, vgTextAlignCenter);
        Result := Result + vgRectWidth(R);}
      end;
    end;
  end;
  C.Free;

  Result := Result
end;

function TdxTextBox3D.GetNextWordBeging(StartPosition: integer): integer;
var
  SpaceFound,
    WordFound: boolean;
begin
  Result := StartPosition;
  SpaceFound := false;
  WordFound := false;
  while (Result + 2 <= Length(Text)) and
    ((not ((Text[Result + 1] <> vgWideSpace) and SpaceFound))
    or not WordFound) do
  begin
    if Text[Result + 1] = vgWideSpace then
      SpaceFound := true;
    if Text[Result + 1] <> vgWideSpace then begin
      WordFound := true;
      SpaceFound := false;
    end;

    Result := Result + 1;
  end;
  if not SpaceFound then
    Result := Result + 1;
end;

function TdxTextBox3D.GetPrivWordBeging(StartPosition: integer): integer;
var
  WordFound: boolean;
begin
  Result := StartPosition;
  WordFound := false;
  while (Result > 0) and
    ((Text[Result] <> vgWideSpace) or not WordFound) do
  begin
    if Text[Result] <> vgWideSpace then
      WordFound := true;
    Result := Result - 1;
  end;
end;

function TdxTextBox3D.GetSelStart: integer;
begin
  if FSelLength > 0 then
    Result := FSelStart
  else
    if FSelLength < 0 then
      Result := FSelStart + FSelLength
    else
      Result := CaretPosition;
end;

function TdxTextBox3D.GetSelRect: TvxRect;
begin
  Result := vgRect(Width / 2, (Height / 2) - Font.Size / 10 / 1.8, Width, (Height / 2) + Font.Size / 10 / 1.8);
  Result.Left := GetCharX(SelStart);
  Result.Right := GetCharX(SelStart + SelLength);
end;

function TdxTextBox3D.GetSelLength: integer;
begin
  Result := Abs(FSelLength);
end;

function TdxTextBox3D.GetSelText: WideString;
begin
  Result := Copy(Text, SelStart + 1, SelLength);
end;

procedure TdxTextBox3D.SetSelLength(const Value: integer);
begin
  if FSelLength <> Value then
  begin
    FSelLength := Value;
    Repaint;
  end;
end;

procedure TdxTextBox3D.SetSelStart(const Value: integer);
begin
  if FSelStart <> Value then
  begin
    SelLength := 0;
    FSelStart := Value;
    CaretPosition := FSelStart;
    Repaint;
  end;
end;

procedure TdxTextBox3D.SetCaretPosition(const Value: integer);
begin
  if Value < 0 then
    FCaretPosition := 0
  else
    if Value > Length(Text) then
      FCaretPosition := Length(Text)
    else
      FCaretPosition := Value;

  UpdateFirstVisibleChar;

  if SelLength <= 0 then
    FSelStart := Value;

  Repaint;
{  if Focused then
    SetCaretPos(GetCharX(FCaretPosition), ContentRect.Top);}
end;

procedure TdxTextBox3D.SetMaxLength(const Value: Integer);
begin
  if FMaxLength <> Value then
  begin
    FMaxLength := Value;
  end;
end;

procedure TdxTextBox3D.CopyToClipboard;
var
  Data: THandle;
  DataPtr: Pointer;
  Size: Cardinal;
  S: WideString;
begin
  {$IFNDEF FPC}
//  if PasswordKind = pkNone then
    if Length(SelText) > 0 then
    begin
      S := SelText;
        begin
          Size := Length(S);
          Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, 2 * Size + 2);
          try
            DataPtr := GlobalLock(Data);
            try
              Move(PWideChar(S)^, DataPtr^, 2 * Size + 2);
              Clipbrd.Clipboard.SetAsHandle(CF_UNICODETEXT, Data);
            finally
              GlobalUnlock(Data);
            end;
          except
            GlobalFree(Data);
            raise;
          end;
        end;
    end;
  {$ELSE}
  if SelText <> '' then
    Clipbrd.Clipboard.AsText := UTF8Encode(SelText);
  {$ENDIF}
end;

procedure TdxTextBox3D.PasteFromClipboard;
var
  Data: THandle;
  Insertion: WideString;
begin
  if ReadOnly then Exit;
  {$IFNDEF FPC}
  if Clipbrd.Clipboard.HasFormat(CF_UNICODETEXT) then
  begin
    Data := Clipbrd.Clipboard.GetAsHandle(CF_UNICODETEXT);
    try
      if Data <> 0 then
        Insertion := PWideChar(GlobalLock(Data));
    finally
      if Data <> 0 then GlobalUnlock(Data);
    end;
  end
  else
    Insertion := Clipbrd.Clipboard.AsText;

  InsertText(Insertion);
  {$ELSE}
  InsertText(UTF8Decode(Clipbrd.Clipboard.AsText));
  {$ENDIF}
end;

procedure TdxTextBox3D.ClearSelection;
var
  TmpS: WideString;
begin
  if ReadOnly then Exit;

  TmpS := Text;
//  FActionStack.FragmentDeleted(SelStart+1, Copy(TmpS,SelStart+1,SelLength));
  Delete(TmpS, SelStart + 1, SelLength);
  CaretPosition := SelStart;
  Text := TmpS;
  SelLength := 0;
end;

procedure TdxTextBox3D.CutToClipboard;
begin
//  if PasswordKind = pkNone then
    CopyToClipboard;
  ClearSelection;
end;

procedure TdxTextBox3D.SelectAll;
begin
  SetCaretPosition(Length(Text));
  SelStart := 0;
  SelLength := Length(Text);
  Repaint;
end;

procedure TdxTextBox3D.KeyDown(var Key: Word; var KeyChar: System.WideChar;
  Shift: TShiftState);
var
  S: wideString;
  TmpS: WideString;
  OldCaretPosition: integer;
begin
  inherited ;
  OldCaretPosition := CaretPosition;
  case Key of
    VK_RETURN: Change;
    VK_END: CaretPosition := Length(Text);
    VK_HOME: CaretPosition := 0;
    VK_LEFT:
      if ssCtrl in Shift then
        CaretPosition := GetPrivWordBeging(CaretPosition)
      else
        CaretPosition := CaretPosition - 1;
    VK_RIGHT:
      if ssCtrl in Shift then
        CaretPosition := GetNextWordBeging(CaretPosition)
      else
        CaretPosition := CaretPosition + 1;
    VK_DELETE, 8: {Delete or BackSpace key was pressed}
      if not ReadOnly then
      begin
        if SelLength <> 0 then
        begin
          if Shift = [ssShift] then
            CutToClipboard
          else
            ClearSelection;
        end
        else
        begin
          TmpS := Text;
          if TmpS <> '' then
            if Key = VK_DELETE then
            begin
//              FActionStack.FragmentDeleted(CaretPosition + 1,TmpS[CaretPosition + 1]);
              Delete(TmpS, CaretPosition + 1, 1);
            end
            else
            begin {BackSpace key was pressed}
{              if CaretPosition > 0 then
                FActionStack.FragmentDeleted(CaretPosition,TmpS[CaretPosition]);}
              Delete(TmpS, CaretPosition, 1);
              CaretPosition := CaretPosition - 1;
            end;
          Text := TmpS;
          if Assigned(FOnTyping) then FOnTyping(Self);
        end;
      end;
    VK_INSERT:
      if Shift = [ssCtrl] then
      begin
        CopyToClipboard;
      end
      else
        if Shift = [ssShift] then
        begin
          PasteFromClipboard;
          if Assigned(FOnTyping) then FOnTyping(Self);
        end;
  end;

  case KeyChar of
    'c','C':
      if Shift = [ssCtrl] then
      begin
        CopyToClipboard;
        KeyChar := #0;
      end;
    'v', 'V':
      if Shift = [ssCtrl] then
      begin
        PasteFromClipboard;
        if Assigned(FOnTyping) then FOnTyping(Self);
        KeyChar := #0;
      end;
    'x', 'X':
      if Shift = [ssCtrl] then
      begin
        CutToClipboard;
        KeyChar := #0;
      end;
    'z', 'Z':
      if Shift = [ssCtrl] then
      begin
        {UnDo};
        KeyChar := #0;
      end;
  end;

  if Key in [VK_END, VK_HOME, VK_LEFT, VK_RIGHT] then
  begin
    if ssShift in Shift then
    begin
      if SelLength = 0 then
        FSelStart := OldCaretPosition;
      FSelStart := CaretPosition;
      FSelLength := FSelLength - (CaretPosition - OldCaretPosition);
    end
    else
      FSelLength := 0;
    Repaint;
  end;

  if (Ord(KeyChar) >= 32) and not ReadOnly then
  begin
    S := KeyChar;
    InsertText(S);
    if Assigned(FOnTyping) then FOnTyping(Self);
  end;

  UpdateCaretePosition;
end;

procedure TdxTextBox3D.KeyUp(var Key: Word; var KeyChar: System.WideChar;
  Shift: TShiftState);
begin
  inherited ;
end;

function TdxTextBox3D.RayCastIntersect(const RayPos, RayDir: TdxVector; var Intersection: TdxVector): boolean;
var
  ip: TdxVector;
  p: array [0..5] of TdxVector;
  CubeSize: TdxVector;
  r: TdxVector;
  i: Integer;
  t, e: Single;
  eSize: TdxVector;
begin
  Result := false;
  e := 0.5 + 0.001; //Small value for floating point imprecisions
  CubeSize.V[0] := Width;
  CubeSize.V[1] := Height;
  CubeSize.V[2] := Depth;
  eSize.V[0] := Width * e;
  eSize.V[1] := Height * e;
  eSize.V[2] := Depth * e;
  p[0] := XHmgVector;
  p[1] := YHmgVector;
  p[2] := ZHmgVector;
  p[3] := dxVector(-1,  0,  0);
  p[4] := dxVector(0, -1,  0);
  p[5] := dxVector(0,  0, -1);
  for i := 0 to 5 do
  begin
    if dxVectorDotProduct(p[i], RayDir) > 0 then
    begin
      t := - (p[i].V[0]*RayPos.V[0] + p[i].V[1]*RayPos.V[1] + p[i].V[2]*RayPos.V[2] + 0.5 * CubeSize.V[i mod 3])
           / (p[i].V[0]*RayDir.V[0] + p[i].V[1]*RayDir.V[1] + p[i].V[2]*RayDir.V[2]);
      r := dxVector(RayPos.V[0] + t*RayDir.V[0], RayPos.V[1] + t*RayDir.V[1], RayPos.V[2] + t*RayDir.V[2]);
      if (Abs(r.V[0]) <= eSize.V[0]) and (Abs(r.V[1]) <= eSize.V[1]) and (Abs(r.V[2]) <= eSize.V[2]) and
         (dxVectorDotProduct(dxVectorSubtract(r, RayPos), RayDir) > 0) then
      begin
        Intersection := dxVector(LocalToAbsolute(dxPoint(r)));
        Result := true;
        Exit;
      end;
    end;
  end;
  Result := false;
end;

procedure TdxTextBox3D.ShapeMouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: single);
begin
  inherited;
  if Button = mbLeft then
    FLMouseSelecting := true;

  if Button = mbLeft then
  begin
    CaretPosition := GetCoordinatePosition(x);
    SelLength := 0;
  end;
end;

procedure TdxTextBox3D.ShapeMouseMove(Shift: TShiftState; X, Y: single);
var
  OldCaretPosition: integer;
  TmpNewPosition : integer;
begin
  inherited;
  if FLMouseSelecting then
  begin
    TmpNewPosition := GetCoordinatePosition(x);
    OldCaretPosition := CaretPosition;
    if (x > Width) then
      CaretPosition := TmpNewPosition +1
    else
      CaretPosition := TmpNewPosition;
    if SelLength = 0 then
      FSelStart := OldCaretPosition;
    FSelStart := CaretPosition;
    FSelLength := FSelLength - (CaretPosition - OldCaretPosition);
  end;
end;

procedure TdxTextBox3D.ShapeMouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: single);
begin
  inherited;
  FLMouseSelecting := false;
end;

procedure TdxTextBox3D.Change;
begin
  if FNeedChange and Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TdxTextBox3D.ContextMenu(const ScreenPosition: TvxPoint);
begin
  inherited;
  if csDesigning in ComponentState then Exit;

  UpdatePopupMenuItems;
  FPopupMenu.PopupComponent := Self;
  FPopupMenu.Popup(round(ScreenPosition.X), round(ScreenPosition.Y));
end;

procedure TdxTextBox3D.KillFocus;
begin
  inherited ;
  Change;
end;

procedure TdxTextBox3D.EnterFocus;
begin
  inherited;
  CaretPosition := Length(Text);
  FNeedChange := false;
end;

procedure TdxTextBox3D.SetText(const Value: WideString);
begin
  if FText <> Value then
  begin
    FText := Value; 
    FNeedChange := true;
  end;
end;

procedure TdxTextBox3D.SetPassword(const Value: boolean);
begin
  if FPassword <> Value then
  begin
    FPassword := Value;
    Repaint;
  end;
end;

procedure TdxTextBox3D.SetFont(const Value: TdxFont);
begin
  FFont.Assign(Value);
end;

procedure TdxTextBox3D.FontChanged(Sender: TObject);
begin
  Repaint;
end;

procedure TdxTextBox3D.SetBackground(const Value: string);
begin
  if FBackground <> Value then
  begin
    FBackground := Value;
    Repaint;
  end;
end;

procedure TdxTextBox3D.SetSelection(const Value: string);
begin
  if FSelection <> Value then
  begin
    FSelection := Value;
    Repaint;
  end;
end;

procedure TdxTextBox3D.SetShowBackground(const Value: boolean);
begin
  if FShowBackground <> Value then
  begin
    FShowBackground := Value;
    Repaint;
  end;
end;

initialization
  RegisterDXObjects('Controls', [TdxTextBox3D]);
end.


