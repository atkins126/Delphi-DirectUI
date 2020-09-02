unit dx_timer;

{$I dx_define.inc}

interface

uses
  {$IFDEF FPC}
  LCLProc, LCLType, LMessages, LResources,
  {$ENDIF}
  {$IFDEF WIN32}
  Windows,
  {$ENDIF}
  SysUtils, Classes;

type

  TdxTimer = class(TComponent)
  private
    FEnabled: Boolean;
    FInterval: Cardinal;
    FKeepAlive: Boolean;
    FOnTimer: TNotifyEvent;
    FPriority: TThreadPriority;
    FStreamedEnabled: Boolean;
    FThread: TThread;
    function GetThread: TThread;
    procedure SetEnabled(const Value: Boolean);
    procedure SetInterval(const Value: Cardinal);
    procedure SetOnTimer(const Value: TNotifyEvent);
    procedure SetPriority(const Value: TThreadPriority);
    procedure SetKeepAlive(const Value: Boolean);
  protected
    procedure DoOnTimer;
    procedure Loaded; override;
    procedure StopTimer;
    procedure UpdateTimer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Thread: TThread read GetThread;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default False;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property KeepAlive: Boolean read FKeepAlive write SetKeepAlive default False;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
    property Priority: TThreadPriority read FPriority write SetPriority default tpNormal;
  end;

implementation

uses
  Forms,
  Messages;

type
  TdxTimerThread = class(TThread)
  private
    FEvent: THandle;
    FHasBeenSuspended: Boolean;
    FInterval: Cardinal;
    FTimer: TdxTimer;
  protected
    procedure DoSuspend;
    procedure Execute; override;
  public
    constructor Create(ATimer: TdxTimer);
    destructor Destroy; override;
    procedure Stop;
    property Interval: Cardinal read FInterval;
    property Timer: TdxTimer read FTimer;
  end;

function SubtractMin0(const Big, Small: Cardinal): Cardinal;
begin
  if Big <= Small then
    Result := 0
  else
    Result := Big - Small;
end;

//=== TdxTimerThread =========================================================

constructor TdxTimerThread.Create(ATimer: TdxTimer);
begin
  { Create suspended because of priority setting }
  inherited Create(True);
  FreeOnTerminate := True;
  { Manually reset = false; Initial State = false }
//  FEvent := CreateEvent(nil, False, False, nil);
  if FEvent = 0 then
    {$IFDEF COMPILER6_UP}
    RaiseLastOSError;
    {$ELSE}
//    RaiseLastWin32Error;
    {$ENDIF COMPILER6_UP}
  FInterval := ATimer.FInterval;
  FTimer := ATimer;
  Priority := ATimer.Priority;
  Resume;
end;

destructor TdxTimerThread.Destroy;
begin
  Stop;
  inherited Destroy;
{  if FEvent <> 0 then
    CloseHandle(FEvent);}
end;

procedure TdxTimerThread.DoSuspend;
begin
  FHasBeenSuspended := True;
  Suspend;
end;

procedure TdxTimerThread.Execute;
var
  Offset, TickCount: Cardinal;
begin
{  if WaitForSingleObject(FEvent, Interval) <> WAIT_TIMEOUT then
    Exit;}

  while not Terminated do
  begin
    FHasBeenSuspended := False;

//    TickCount := GetTickCount;
    if not Terminated then
      Synchronize(FTimer.DoOnTimer);

    // Determine how much time it took to execute OnTimer event handler. Take a care
    // of wrapping the value returned by GetTickCount API around zero if Windows is
    // run continuously for more than 49.7 days.
    if FHasBeenSuspended then
      Offset := 0
    else
    begin
{      Offset := GetTickCount;
      if Offset >= TickCount then
        Dec(Offset, TickCount)
      else
        Inc(Offset, High(Cardinal) - TickCount);}
    end;

    // Make sure Offset is less than or equal to FInterval.
    // (rb) Ensure it's atomic, because of KeepAlive
{    if WaitForSingleObject(FEvent, SubtractMin0(Interval, Offset)) <> WAIT_TIMEOUT then
      Exit;}
  end;
end;

procedure TdxTimerThread.Stop;
begin
  Terminate;
//  SetEvent(FEvent);
  if Suspended then
    Resume;
  Sleep(0);
end;

//=== TdxTimer =========================================================

constructor TdxTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInterval := 1000;
  FPriority := tpIdle;
end;

destructor TdxTimer.Destroy;
begin
  StopTimer;
  inherited Destroy;
end;

procedure TdxTimer.DoOnTimer;
begin
  if csDestroying in ComponentState then
    Exit;

  try
    if Assigned(FOnTimer) then
      FOnTimer(Self);
  except
    {$IFDEF COMPILER6_UP}
    if Assigned(ApplicationHandleException) then
      ApplicationHandleException(Self);
    {$ELSE}
    Application.HandleException(Self);
    {$ENDIF COMPILER6_UP}
  end;
end;

function TdxTimer.GetThread: TThread;
begin
  Result := FThread;
end;

procedure TdxTimer.Loaded;
begin
  inherited Loaded;
  SetEnabled(FStreamedEnabled);
end;

procedure TdxTimer.SetEnabled(const Value: Boolean);
begin
  if csLoading in ComponentState then
    FStreamedEnabled := Value
  else
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TdxTimer.SetInterval(const Value: Cardinal);
begin
  if FInterval <> Value then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TdxTimer.SetKeepAlive(const Value: Boolean);
begin
  if Value <> KeepAlive then
  begin
    StopTimer;
    FKeepAlive := Value;
    UpdateTimer;
  end;
end;

procedure TdxTimer.SetOnTimer(const Value: TNotifyEvent);
begin
  if @FOnTimer <> @Value then
  begin
    FOnTimer := Value;
    UpdateTimer;
  end;
end;

procedure TdxTimer.SetPriority(const Value: TThreadPriority);
begin
  if FPriority <> Value then
  begin
    FPriority := Value;
    if FThread <> nil then
      FThread.Priority := FPriority;
  end;
end;

procedure TdxTimer.StopTimer;
begin
  if FThread is TdxTimerThread then
    TdxTimerThread(FThread).Stop;
  FThread := nil;
end;

procedure TdxTimer.UpdateTimer;
var
  DoEnable: Boolean;
begin
  if ComponentState * [csDesigning, csLoading] <> [] then
    Exit;

  DoEnable := FEnabled and Assigned(FOnTimer) and (FInterval > 0);

  if not KeepAlive then
    StopTimer;

  if DoEnable then
  begin
    if FThread is TdxTimerThread then
      TdxTimerThread(FThread).FInterval := FInterval
    else
      FThread := TdxTimerThread.Create(Self);

    if FThread.Suspended then
      FThread.Resume;
  end
  else
  if FThread is TdxTimerThread then
  begin
    if not FThread.Suspended then
      TdxTimerThread(FThread).DoSuspend;

    TdxTimerThread(FThread).FInterval := FInterval;
  end;
end;

end.

