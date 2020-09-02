unit dx_flash;

{$I dx_define.inc}

interface

uses
  {$IFDEF FPC}
  LCLProc, LCLType, LMessages, LResources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Classes, SysUtils, Forms, Controls, Dialogs, Graphics,
  ExtCtrls, Menus, dx_scene, dx_utils, dx_vgcore, fe_flashplayer;

type

  TdxCustomFlashPlayer = class(TdxCustomBufferLayer, IfeFlash)
  private
    FMovie: WideString;
    FDriver: TfeFlashDriver;
    FOnFlashCall: TfeFlashCallEvent;
    FOnFSCommand: TfeFSCommandEvent;
    FPlugin: TfePlugin;
    procedure SetMovie(const Value: WideString);
    function GetDisableFlashCursor: boolean;
    function GetDisableFlashMenu: boolean;
    function GetPause: boolean;
    function GetSkin: string;
    function GetVolume: integer;
    procedure SetDisableFlashCursor(const Value: boolean);
    procedure SetDisableFlashMenu(const Value: boolean);
    procedure SetPause(const Value: boolean);
    procedure SetPlugin(const Value: TfePlugin);
    procedure SetSkin(const Value: string);
    procedure SetVolume(const Value: integer);
  protected
    procedure Loaded; override;
    procedure DoPaint(Sender: TObject; const ARect: TRect);
    procedure DoEraseBackground(Sender: TObject; const ARect: TRect);
    procedure LayerMouseMove(Shift: TShiftState; X, Y: single); override;
    procedure LayerMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: single); override;
    procedure LayerMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: single); override;
    procedure MouseWheel(Shift: TShiftState; WheelDelta: integer; var Handled: boolean); override;
    procedure KeyUp(var Key: Word; var Char: System.WideChar; Shift: TShiftState); override;
    procedure KeyDown(var Key: Word; var Char: System.WideChar; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { IfeFlash }
    procedure LoadMovie(const AUrl: WideString);
    procedure LoadMovieFromStream(const AStream: TStream);
    function GetVariable(const name: WideString): WideString;
    procedure SetVariable(const name: WideString; const value: WideString);
    function CallFunction(const request: WideString): WideString;
    procedure SetReturnValue(const returnValue: WideString);
    procedure Play;
    procedure StopPlay;
    procedure Rewind;
    procedure Forward;
    procedure Back;
    function GetLoop: boolean;
    function GetIsPlaying: boolean;
    function GetCurrentFrame: integer;
    function GetTotalFrames: integer;
    procedure SetLoop(const Value: boolean);
    procedure SetCurrentFrame(const Value: integer);
    property IsPlaying: boolean read GetIsPlaying;
    property Loop: boolean read GetLoop write SetLoop;
    property CurrentFrame: integer read GetCurrentFrame write SetCurrentFrame;
    property TotalFrames: integer read GetTotalFrames;
  published
    property CanFocused default true;
    property DisableFlashCursor: boolean read GetDisableFlashCursor write SetDisableFlashCursor default false;
    property DisableFlashMenu: boolean read GetDisableFlashMenu write SetDisableFlashMenu default true;
    property Movie: WideString read FMovie write SetMovie;
    property Plugin: TfePlugin read FPlugin write SetPlugin default feDefault;
    property Skin: string read GetSkin write SetSkin;
    property Pause: boolean read GetPause write SetPause;
    property Volume: integer read GetVolume write SetVolume;
    property OnFSCommand: TfeFSCommandEvent read FOnFSCommand write FOnFSCommand;
    property OnFlashCall: TfeFlashCallEvent read FOnFlashCall write FOnFlashCall;
  end;

  TdxFlashPlayer = class(TdxCustomFlashPlayer)
  private
  protected
  public
  published
    property Align;
    property Body;
    property Collider;
    property ColliseTrack;
    property Dynamic;
    property Velocity;
    property Margins;
    property Padding;
  end;

  TdxGUIFlashPlayer = class(TdxCustomFlashPlayer)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
  published
    property LayerAlign;
    property ZWrite default false;
  end;

  TvxFlashPlayer = class(TvxVisualObject, IfeFlash)
  private
    FBuffer: TvxBitmap;
    FDriver: TfeFlashDriver;
    FMovie: WideString;
    FPlugin: TfePlugin;
    FOnFlashCall: TfeFlashCallEvent;
    FOnFSCommand: TfeFSCommandEvent;
    procedure SetMovie(const Value: WideString);
    procedure SetPlugin(const Value: TfePlugin);
    function GetPause: boolean;
    function GetSkin: string;
    function GetVolume: integer;
    procedure SetDisableFlashCursor(const Value: boolean);
    procedure SetDisableFlashMenu(const Value: boolean);
    procedure SetPause(const Value: boolean);
    procedure SetSkin(const Value: string);
    procedure SetVolume(const Value: integer);
    function GetDisableFlashCursor: boolean;
    function GetDisableFlashMenu: boolean;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: single); override;
    procedure MouseMove(Shift: TShiftState; X, Y, Dx, Dy: single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: single); override;
    procedure MouseWheel(Shift: TShiftState; WheelDelta: integer; var Handled: boolean); override;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    procedure Paint; override;
    procedure Loaded; override;
    procedure DoPaint(Sender: TObject; const ARect: TRect);
    procedure DoEraseBackground(Sender: TObject; const ARect: TRect);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { IfeFlash }
    procedure LoadMovie(const AUrl: WideString);
    procedure LoadMovieFromStream(const AStream: TStream);
    function GetVariable(const name: WideString): WideString;
    procedure SetVariable(const name: WideString; const value: WideString);
    function CallFunction(const request: WideString): WideString;
    procedure SetReturnValue(const returnValue: WideString);
    procedure Play;
    procedure StopPlay;
    procedure Rewind;
    procedure Forward;
    procedure Back;
    function GetLoop: boolean;
    function GetIsPlaying: boolean;
    function GetCurrentFrame: integer;
    function GetTotalFrames: integer;
    procedure SetLoop(const Value: boolean);
    procedure SetCurrentFrame(const Value: integer);
    property IsPlaying: boolean read GetIsPlaying;
    property Loop: boolean read GetLoop write SetLoop;
    property CurrentFrame: integer read GetCurrentFrame write SetCurrentFrame;
    property TotalFrames: integer read GetTotalFrames;
  published
    property DisableFlashCursor: boolean read GetDisableFlashCursor write SetDisableFlashCursor default false;
    property DisableFlashMenu: boolean read GetDisableFlashMenu write SetDisableFlashMenu default true;
    property Movie: WideString read FMovie write SetMovie;
    property Plugin: TfePlugin read FPlugin write SetPlugin default feDefault;
    property Skin: string read GetSkin write SetSkin;
    property Pause: boolean read GetPause write SetPause;
    property Volume: integer read GetVolume write SetVolume;
    property OnFSCommand: TfeFSCommandEvent read FOnFSCommand write FOnFSCommand;
    property OnFlashCall: TfeFlashCallEvent read FOnFlashCall write FOnFlashCall;
  end;

procedure Register;

implementation {===============================================================}

procedure Register;
begin
  RegisterNoIcon([TdxFlashPlayer, TdxGUIFlashPlayer, TvxFlashPlayer]);
end;

{ TdxCustomFlashPlayer }

constructor TdxCustomFlashPlayer.Create(AOwner: TComponent);
begin
  inherited;
  CheckFlashPlugins; // need to call after Application created
  CanFocused := true;
  ChangePlugin(FDriver, FPlugin, Movie, round(Width), round(Height), 0,
    nil, DoPaint, DoEraseBackground, FOnFSCommand, FOnFlashCall);
end;

destructor TdxCustomFlashPlayer.Destroy;
begin
  FreeAndNil(FDriver);
  inherited;
end;

procedure TdxCustomFlashPlayer.Loaded;
begin
  inherited;
  if FMovie <> '' then
    FDriver.LoadMovie(FMovie);
end;

procedure TdxCustomFlashPlayer.DoEraseBackground(Sender: TObject;
  const ARect: TRect);
var
  R: TRect;
  SaveIndex: integer;
begin
  if FDriver = nil then Exit;
  if FDriver.BufferBits <> nil then
    FillLongwordRect(FDriver.BufferBits, FDriver.Width, FDriver.Height, ARect.Left, ARect.Top, ARect.Right,
      ARect.Bottom, 0);
end;

procedure TdxCustomFlashPlayer.DoPaint(Sender: TObject; const ARect: TRect);
var
  B: PdxColorArray;
begin
  if (FBuffer.Width <> Round(Width)) or (FBuffer.Height <> Round(Height)) then
    FBuffer.SetSize(FLayerWidth, FLayerHeight);
  if (FDriver.Width <> FBuffer.Width) or (FDriver.Height <> FBuffer.Height) then
    FDriver.Resize(FBuffer.Width, FBuffer.Height);
  if FBuffer.LockBitmapBits(B, true) then
  begin
    MoveLongword(FDriver.BufferBits, B, FBuffer.Width * FBuffer.Height);
    FBuffer.UnlockBitmapBits;
  end;
  Repaint;
end;

procedure TdxCustomFlashPlayer.KeyDown(var Key: Word; var Char: WideChar;
  Shift: TShiftState);
begin
  inherited;
  if Char <> #0 then
    FDriver.KeyPress(Char, Shift)
  else
    FDriver.KeyDown(Key, Shift)
end;

procedure TdxCustomFlashPlayer.KeyUp(var Key: Word; var Char: WideChar;
  Shift: TShiftState);
begin
  inherited;
  if Char = #0 then
    FDriver.KeyUp(Key, Shift)
end;

procedure TdxCustomFlashPlayer.LayerMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: single);
begin
  inherited;
  FDriver.MouseDown(Button, Shift, trunc(X), trunc(Y));
end;

procedure TdxCustomFlashPlayer.LayerMouseMove(Shift: TShiftState; X, Y: single);
begin
  inherited;
  FDriver.MouseMove(Shift, trunc(X), trunc(Y));
end;

procedure TdxCustomFlashPlayer.LayerMouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: single);
begin
  inherited;
  FDriver.MouseUp(Button, Shift, trunc(X), trunc(Y));
end;

procedure TdxCustomFlashPlayer.MouseWheel(Shift: TShiftState;
  WheelDelta: integer; var Handled: boolean);
begin
  inherited;
  FDriver.MouseWheel(Shift, 0, 0, WheelDelta, Handled);
end;

{ IfeFlash }

function TdxCustomFlashPlayer.CallFunction(const request: WideString): WideString;
begin
  Result := FDriver.CallFunction(request);
end;

function TdxCustomFlashPlayer.GetVariable(const name: WideString): WideString;
begin
  Result := FDriver.GetVariable(name);
end;

procedure TdxCustomFlashPlayer.SetReturnValue(const returnValue: WideString);
begin
  FDriver.SetReturnValue(returnValue);
end;

procedure TdxCustomFlashPlayer.SetVariable(const name, value: WideString);
begin
  FDriver.SetVariable(name, value);
end;

procedure TdxCustomFlashPlayer.LoadMovie(const AUrl: WideString);
begin
  FMovie := AUrl;
  if not (csLoading in ComponentState) then
    FDriver.LoadMovie(FMovie);
  if csDesigning in ComponentState then
    FDriver.Pause := true;
end;

procedure TdxCustomFlashPlayer.LoadMovieFromStream(const AStream: TStream);
begin
  FMovie := '';
  if not (csLoading in ComponentState) then
    FDriver.LoadMovieFromStream(AStream);
  if csDesigning in ComponentState then
    FDriver.Pause := true;
end;

procedure TdxCustomFlashPlayer.Play;
begin
  FDriver.Play;
end;

procedure TdxCustomFlashPlayer.StopPlay;
begin
  FDriver.StopPlay;
end;

procedure TdxCustomFlashPlayer.Rewind;
begin
  FDriver.Rewind;
end;

procedure TdxCustomFlashPlayer.Forward;
begin
  FDriver.Forward;
end;

procedure TdxCustomFlashPlayer.Back;
begin
  FDriver.Back;
end;

function TdxCustomFlashPlayer.GetLoop: boolean;
begin
  Result := FDriver.GetLoop;
end;

function TdxCustomFlashPlayer.GetIsPlaying: boolean;
begin
  Result := FDriver.GetIsPlaying;
end;

function TdxCustomFlashPlayer.GetCurrentFrame: integer;
begin
  Result := FDriver.GetCurrentFrame;
end;

function TdxCustomFlashPlayer.GetTotalFrames: integer;
begin
  Result := FDriver.GetTotalFrames;
end;

procedure TdxCustomFlashPlayer.SetLoop(const Value: boolean);
begin
  FDriver.SetLoop(Value);
end;

procedure TdxCustomFlashPlayer.SetCurrentFrame(const Value: integer);
begin
  FDriver.SetCurrentFrame(Value);
end;

{ props }

function TdxCustomFlashPlayer.GetDisableFlashCursor: boolean;
begin
  Result := FDriver.DisableFlashCursor;
end;

function TdxCustomFlashPlayer.GetDisableFlashMenu: boolean;
begin
  Result := FDriver.DisableFlashMenu;
end;

function TdxCustomFlashPlayer.GetPause: boolean;
begin
  Result := FDriver.Pause;
end;

function TdxCustomFlashPlayer.GetSkin: string;
begin
  Result := FDriver.Skin;
end;

function TdxCustomFlashPlayer.GetVolume: integer;
begin
  Result := FDriver.Volume;
end;

procedure TdxCustomFlashPlayer.SetDisableFlashCursor(const Value: boolean);
begin
  FDriver.DisableFlashCursor := Value;
end;

procedure TdxCustomFlashPlayer.SetDisableFlashMenu(const Value: boolean);
begin
  FDriver.DisableFlashMenu := Value;
end;

procedure TdxCustomFlashPlayer.SetMovie(const Value: WideString);
begin
  FMovie := Value;
  if not (csLoading in ComponentState) then
    FDriver.LoadMovie(FMovie);
end;

procedure TdxCustomFlashPlayer.SetPause(const Value: boolean);
begin
  FDriver.Pause := Value;
end;

procedure TdxCustomFlashPlayer.SetPlugin(const Value: TfePlugin);
begin
  if Plugin <> Value then
  begin
    FPlugin := Value;
    ChangePlugin(FDriver, FPlugin, Movie, round(Width), round(Height), 0,
      nil, DoPaint, DoEraseBackground, FOnFSCommand, FOnFlashCall);
  end;
end;

procedure TdxCustomFlashPlayer.SetSkin(const Value: string);
begin
  FDriver.Skin := Value;
end;

procedure TdxCustomFlashPlayer.SetVolume(const Value: integer);
begin
  FDriver.Volume := Value;
end;

{ TdxGUIFlashPlayer }

constructor TdxGUIFlashPlayer.Create(AOwner: TComponent);
begin
  inherited;
  Projection := dxProjectionScreen;
  Width := 256;
  Height := 256;
  ZWrite := false;
end;

{ TvxFlashPlayer }

constructor TvxFlashPlayer.Create(AOwner: TComponent);
begin
  inherited;
  CheckFlashPlugins; // need to call after Application created
  CanFocused := true;
  FBuffer := TvxBitmap.Create(round(Width), round(Height));
  ChangePlugin(FDriver, FPlugin, Movie, round(Width), round(Height), 0,
    nil, DoPaint, DoEraseBackground, FOnFSCommand, FOnFlashCall);
end;

destructor TvxFlashPlayer.Destroy;
begin
  FreeAndNil(FDriver);
  FreeAndNil(FBuffer);
  inherited;
end;

procedure TvxFlashPlayer.Loaded;
begin
  inherited;
  if FMovie <> '' then
    FDriver.LoadMovie(FMovie);
end;

procedure TvxFlashPlayer.KeyDown(var Key: Word; var KeyChar: WideChar;
  Shift: TShiftState);
begin
  inherited;
  if KeyChar <> #0 then
    FDriver.KeyPress(KeyChar, Shift)
  else
    FDriver.KeyDown(Key, Shift)
end;

procedure TvxFlashPlayer.KeyUp(var Key: Word; var KeyChar: WideChar;
  Shift: TShiftState);
begin
  inherited;
  if KeyChar = #0 then
    FDriver.KeyUp(Key, Shift)
end;

procedure TvxFlashPlayer.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: single);
begin
  inherited;
  FDriver.MouseDown(Button, Shift, trunc(X), trunc(Y));
end;

procedure TvxFlashPlayer.MouseMove(Shift: TShiftState; X, Y, Dx,
  Dy: single);
begin
  inherited;
  FDriver.MouseMove(Shift, trunc(X), trunc(Y));
end;

procedure TvxFlashPlayer.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: single);
begin
  inherited;
  FDriver.MouseUp(Button, Shift, trunc(X), trunc(Y));
end;

procedure TvxFlashPlayer.MouseWheel(Shift: TShiftState;
  WheelDelta: integer; var Handled: boolean);
begin
  inherited;
  FDriver.MouseWheel(Shift, 0, 0, WheelDelta, Handled);
end;

procedure TvxFlashPlayer.DoEraseBackground(Sender: TObject; const ARect: TRect);
var
  R: TRect;
  SaveIndex: integer;
begin
  if FDriver = nil then Exit;
  if FDriver.BufferBits <> nil then
    FillLongwordRect(FDriver.BufferBits, FDriver.Width, FDriver.Height, ARect.Left, ARect.Top, ARect.Right,
      ARect.Bottom, 0);
end;

procedure TvxFlashPlayer.DoPaint(Sender: TObject; const ARect: TRect);
begin
  if (FBuffer.Width <> Round(Width)) or (FBuffer.Height <> Round(Height)) then
    FBuffer.SetSize(round(Width), round(Height));
  if (FDriver.Width <> FBuffer.Width) or (FDriver.Height <> FBuffer.Height) then
    FDriver.Resize(FBuffer.Width, FBuffer.Height);
  MoveLongword(FDriver.BufferBits, FBuffer.StartLine, FBuffer.Width * FBuffer.Height);
  Repaint;
end;

procedure TvxFlashPlayer.Paint;
var
  S: cardinal;
begin
  S := Canvas.SaveCanvas;
  Canvas.IntersectClipRect(LocalRect);
  Canvas.DrawBitmap(FBuffer, vgRect(0, 0, FBuffer.Width, FBuffer.Height), vgRect(0, 0, FBuffer.Width, FBuffer.Height), AbsoluteOpacity, true);
  Canvas.RestoreCanvas(S);
end;

procedure TvxFlashPlayer.SetMovie(const Value: WideString);
begin
  FMovie := Value;
  if not (csLoading in ComponentState) then
    FDriver.LoadMovie(FMovie);
end;

procedure TvxFlashPlayer.SetPlugin(const Value: TfePlugin);
begin
  if Plugin <> Value then
  begin
    FPlugin := Value;
    ChangePlugin(FDriver, FPlugin, Movie, round(Width), round(Height), 0,
      nil, DoPaint, DoEraseBackground, FOnFSCommand, FOnFlashCall);
  end;
end;

{ IfeFlash }

procedure TvxFlashPlayer.LoadMovie(const AUrl: WideString);
begin
  FMovie := AUrl;
  if not (csLoading in ComponentState) then
    FDriver.LoadMovie(FMovie);
  if csDesigning in ComponentState then
    FDriver.Pause := true;
end;

procedure TvxFlashPlayer.LoadMovieFromStream(const AStream: TStream);
begin
  FMovie := '';
  if not (csLoading in ComponentState) then
    FDriver.LoadMovieFromStream(AStream);
  if csDesigning in ComponentState then
    FDriver.Pause := true;
end;

function TvxFlashPlayer.GetVariable(const name: WideString): WideString;
begin
  Result := FDriver.GetVariable(name)
end;

procedure TvxFlashPlayer.SetVariable(const name: WideString; const value: WideString);
begin
  FDriver.SetVariable(name, value);
end;

function TvxFlashPlayer.CallFunction(const request: WideString): WideString;
begin
  FDriver.CallFunction(request);
end;

procedure TvxFlashPlayer.SetReturnValue(const returnValue: WideString);
begin
  FDriver.CallFunction(returnValue);
end;

procedure TvxFlashPlayer.Play;
begin
  FDriver.Play;
end;

procedure TvxFlashPlayer.StopPlay;
begin
  FDriver.StopPlay;
end;

function TvxFlashPlayer.GetPause: boolean;
begin
  Result := FDriver.Pause;
end;

function TvxFlashPlayer.GetSkin: string;
begin
  Result := FDriver.Skin
end;

function TvxFlashPlayer.GetVolume: integer;
begin
  Result := FDriver.Volume;
end;

procedure TvxFlashPlayer.SetDisableFlashCursor(const Value: boolean);
begin
  FDriver.DisableFlashCursor := Value;
end;

procedure TvxFlashPlayer.SetDisableFlashMenu(const Value: boolean);
begin
  FDriver.DisableFlashMenu := Value;
end;

procedure TvxFlashPlayer.SetPause(const Value: boolean);
begin
  FDriver.Pause := Value
end;

procedure TvxFlashPlayer.SetSkin(const Value: string);
begin
  FDriver.Skin := Value
end;

procedure TvxFlashPlayer.SetVolume(const Value: integer);
begin
  FDriver.Volume := Value
end;

function TvxFlashPlayer.GetDisableFlashCursor: boolean;
begin
  Result := FDriver.DisableFlashCursor;
end;

function TvxFlashPlayer.GetDisableFlashMenu: boolean;
begin
  Result := FDriver.DisableFlashMenu;
end;

procedure TvxFlashPlayer.Rewind;
begin
  FDriver.Rewind;
end;

procedure TvxFlashPlayer.Forward;
begin
  FDriver.Forward;
end;

procedure TvxFlashPlayer.Back;
begin
  FDriver.Back;
end;

function TvxFlashPlayer.GetLoop: boolean;
begin
  Result := FDriver.GetLoop;
end;

function TvxFlashPlayer.GetIsPlaying: boolean;
begin
  Result := FDriver.GetIsPlaying;
end;

function TvxFlashPlayer.GetCurrentFrame: integer;
begin
  Result := FDriver.GetCurrentFrame;
end;

function TvxFlashPlayer.GetTotalFrames: integer;
begin
  Result := FDriver.GetTotalFrames;
end;

procedure TvxFlashPlayer.SetLoop(const Value: boolean);
begin
  FDriver.SetLoop(Value);
end;

procedure TvxFlashPlayer.SetCurrentFrame(const Value: integer);
begin
  FDriver.SetCurrentFrame(Value);
end;

initialization
  RegisterDXObjects('Flash', [TdxFlashPlayer]);
  RegisterDXObjects('GUI', [TdxGUIFlashPlayer]);
  RegisterVGObjects('Flash', [TvxFlashPlayer]);
end.
