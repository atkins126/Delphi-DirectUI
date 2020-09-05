// Copyright (c) Softanics. All rights reserved.
// Copyright (c) Artem A. Razin. All rights reserved.

// Version: 3.5.3

{$RESOURCE 'FlashPlayerControl.res'}

{$INCLUDE 'FlashPlayerControlDefs.inc'}

// Avoid Internal error: C3517 with Delphi 5
{$OPTIMIZATION OFF}

{$IFDEF DEF_DELPHI2009}
{$DEFINE DEF_UNICODE_ENV}
{$ENDIF}
{$IFDEF DEF_DELPHI2009_UPDATE1}
{$DEFINE DEF_UNICODE_ENV}
{$ENDIF}

unit FlashPlayerControl;

{$IFDEF VER140}
{$TYPEDADDRESS OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$ENDIF}

{$IFDEF VER150}
{$TYPEDADDRESS OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ENDIF}

{$R-,T-,H+,X+,Q-}

interface

uses WinApi.Windows,
     WinApi.Messages,
     WinApi.ActiveX,
     SysUtils,
     Classes,
     Vcl.Controls,
     Vcl.Forms,
     Vcl.Menus,
     Vcl.Graphics,
     System.Win.ComObj,
     Vcl.AxCtrls,
     WinApi.mmsystem,
     Vcl.stdctrls,
     Vcl.extctrls

{$IFDEF DEF_UNICODE_ENV}
, AnsiStrings
{$ENDIF}

;

var

  MinimizeFlashMemoryTimer: TTimer;

type

  TFlashPlayerControlOnReadyStateChange = procedure(ASender: TObject; newState: Integer) of object;
  TFlashPlayerControlOnProgress = procedure(ASender: TObject; percentDone: Integer) of object;
  TFlashPlayerControlFSCommand = procedure(ASender: TObject; const command: WideString; const args: WideString) of object;
  TFlashPlayerControlFlashCall = procedure(ASender: TObject; const request: WideString) of object;
  TFlashPlayerControlOnLoadExternalResource = procedure(ASender: TObject; const URL: WideString; Stream: TStream) of object;

{$IFNDEF DEF_BUILDER}
  TFlashPlayerControlOnLoadExternalResourceEx = procedure(ASender: TObject; const URL: WideString; Stream: TStream; out bHandled: Boolean) of object;
  TFlashPlayerControlOnLoadExternalResourceAsync = procedure(ASender: TObject; const Path: WideString; out Stream: TStream) of object;
{$ENDIF}
{$IFDEF DEF_BUILDER}
  PTStream = ^TStream;
  BooleanRef = ^Boolean;
  TFlashPlayerControlOnLoadExternalResourceEx = procedure(ASender: TObject; const URL: WideString; Stream: TStream; bHandled: BooleanRef) of object;
  TFlashPlayerControlOnLoadExternalResourceAsync = procedure(ASender: TObject; const Path: WideString; pStream: PTStream) of object;
{$ENDIF}

  TFlashPlayerControlOnUnloadExternalResourceAsync = procedure(ASender: TObject; Stream: TStream) of object;

  TFlashPlayerControlOnDrawBackground = procedure(ASender: TObject; Canvas: TCanvas) of object;
  TFlashPlayerControlUpdateRect = procedure(ASender: TObject; var rc: TRect) of object;
  TFlashPlayerControlOnFlashPaint = procedure(ASender: TObject; pPixels: Pointer) of object;

  TFlashPlayerControlOnGlobalLoadExternalResource = procedure(const URL: WideString; Stream: TStream) of object;
  TFlashPlayerControlOnGlobalLoadExternalResourceEx = procedure(const URL: WideString; Stream: TStream; out bHandled: Boolean) of object;
  TFlashPlayerControlOnGlobalLoadExternalResourceAsync = procedure(const Path: WideString; out Stream: TStream) of object;
  TFlashPlayerControlOnGlobalSyncCall = procedure of object;
  TFlashPlayerControlOnGlobalPreProcessURL = procedure(var URL: WideString; out Continue: boolean) of object;

  TFlashPlayerControlOnAudioOutputOpen = procedure(lpFormat: PWaveFormatEx) of object;
  TFlashPlayerControlOnAudioOutputWrite = procedure(lpWaveOutHdr: PWaveHdr; uSize: UINT) of object;
  TFlashPlayerControlOnAudioOutputClose = procedure of object;

//============================================================================
// interface IFlashPlayerControlBase

  IFlashPlayerControlBase = interface(IUnknown)
    ['{911FA1AF-CDB2-45ed-8271-5662000000bc}']

    function IFlashPlayerControlBase_PutMovie(NewMovie: WideString): HResult; stdcall;
    function IFlashPlayerControlBase_LoadMovie(Layer: Integer; const url: WideString): HResult; stdcall;
    function IFlashPlayerControlBase_GetBase(var { out } url: WideString): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnLoadExternalResource(const URL: WideString; Stream: TStream): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnLoadExternalResourceEx(const URL: WideString; Stream: TStream; out bHandled: Boolean): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnLoadExternalResourceAsync(const Path: WideString; out Stream: TStream): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnUnloadExternalResourceAsync(Stream: TStream): HResult; stdcall;

  end;

//============================================================================

  IDropTarget = interface;
  IViewObject = interface;
  IEnumUnknown = interface;
  IBindCtx = interface;
  IOleContainer = interface;
  IOleClientSite = interface;
  IParseDisplayName = interface;
  IMoniker = interface;
  IRunningObjectTable = interface;
  IEnumMoniker = interface;
  IEnumString = interface;
  IOleInPlaceSiteEx = interface;

//============================================================================
// interface IOleInPlaceSiteEx

  IOleInPlaceSiteEx = interface(IOleInPlaceSite)
    ['{9C2CAD80-3424-11CF-B670-00AA004CD6D8}']
    function OnInPlaceActivateEx(fNoRedraw: PBOOL;
       dwFlags: DWORD): HResult; stdcall;
    function OnInPlaceDeActivateEx(fNoRedraw: BOOL): HResult; stdcall;
    function RequestUIActivate: HResult; stdcall;
  end;

//============================================================================

//  IOleInPlaceActiveObject = interface;

  IEnumString = interface(IUnknown)
    ['{00000101-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt;
      pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumString): HResult; stdcall;
  end;

  PIMoniker = ^IMoniker;
  IEnumMoniker = interface(IUnknown)
    ['{00000102-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt;
      pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumMoniker): HResult; stdcall;
  end;

  IRunningObjectTable = interface(IUnknown)
    ['{00000010-0000-0000-C000-000000000046}']
    function Register(grfFlags: Longint; const unkObject: IUnknown;
      const mkObjectName: IMoniker; out dwRegister: Longint): HResult; stdcall;
    function Revoke(dwRegister: Longint): HResult; stdcall;
    function IsRunning(const mkObjectName: IMoniker): HResult; stdcall;
    function GetObject(const mkObjectName: IMoniker;
      out unkObject: IUnknown): HResult; stdcall;
    function NoteChangeTime(dwRegister: Longint;
      const filetime: TFileTime): HResult; stdcall;
    function GetTimeOfLastChange(const mkObjectName: IMoniker;
      out filetime: TFileTime): HResult; stdcall;
    function EnumRunning(out enumMoniker: IEnumMoniker): HResult; stdcall;
  end;

  IOleObject = interface(IUnknown)
    ['{00000112-0000-0000-C000-000000000046}']
    function SetClientSite(const clientSite: IOleClientSite): HResult;
      stdcall;
    function GetClientSite(out clientSite: IOleClientSite): HResult;
      stdcall;
    function SetHostNames(szContainerApp: POleStr;
      szContainerObj: POleStr): HResult; stdcall;
    function Close(dwSaveOption: Longint): HResult; stdcall;
    function SetMoniker(dwWhichMoniker: Longint; const mk: IMoniker): HResult;
      stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      out mk: IMoniker): HResult; stdcall;
    function InitFromData(const dataObject: IDataObject; fCreation: BOOL;
      dwReserved: Longint): HResult; stdcall;
    function GetClipboardData(dwReserved: Longint;
      out dataObject: IDataObject): HResult; stdcall;
    function DoVerb(iVerb: Longint; msg: PMsg; const activeSite: IOleClientSite;
      lindex: Longint; hwndParent: HWND; const posRect: TRect): HResult;
      stdcall;
    function EnumVerbs(out enumOleVerb: IEnumOleVerb): HResult; stdcall;
    function Update: HResult; stdcall;
    function IsUpToDate: HResult; stdcall;
    function GetUserClassID(out clsid: TCLSID): HResult; stdcall;
    function GetUserType(dwFormOfType: Longint; out pszUserType: POleStr): HResult;
      stdcall;
    function SetExtent(dwDrawAspect: Longint; const size: TPoint): HResult;
      stdcall;
    function GetExtent(dwDrawAspect: Longint; out size: TPoint): HResult;
      stdcall;
    function Advise(const advSink: IAdviseSink; out dwConnection: Longint): HResult;
      stdcall;
    function Unadvise(dwConnection: Longint): HResult; stdcall;
    function EnumAdvise(out enumAdvise: IEnumStatData): HResult; stdcall;
    function GetMiscStatus(dwAspect: Longint; out dwStatus: Longint): HResult;
      stdcall;
    function SetColorScheme(const logpal: TLogPalette): HResult; stdcall;
  end;

//============================================================================
// interface IDropTarget

  IDropTarget = interface(IUnknown)
    ['{00000122-0000-0000-C000-000000000046}']
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
  end;

//============================================================================

//============================================================================
// interface IViewObject

  IViewObject = interface(IUnknown)
    ['{0000010D-0000-0000-C000-000000000046}']
    function Draw(dwDrawAspect: Longint; lindex: Longint; pvAspect: Pointer;
      ptd: PDVTargetDevice; hicTargetDev: HDC; hdcDraw: HDC;
      prcBounds: PRect; prcWBounds: PRect; fnContinue: TContinueFunc;
      dwContinue: Longint): HResult; stdcall;
    function GetColorSet(dwDrawAspect: Longint; lindex: Longint;
      pvAspect: Pointer; ptd: PDVTargetDevice; hicTargetDev: HDC;
      out colorSet: PLogPalette): HResult; stdcall;
    function Freeze(dwDrawAspect: Longint; lindex: Longint; pvAspect: Pointer;
      out dwFreeze: Longint): HResult; stdcall;
    function Unfreeze(dwFreeze: Longint): HResult; stdcall;
    function SetAdvise(aspects: Longint; advf: Longint;
      const advSink: IAdviseSink): HResult; stdcall;
    function GetAdvise(pAspects: PLongint; pAdvf: PLongint;
      out advSink: IAdviseSink): HResult; stdcall;
  end;
//============================================================================

//============================================================================
// interface IEnumUnknown

  IEnumUnknown = interface(IUnknown)
    ['{00000100-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt;
      pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumUnknown): HResult; stdcall;
  end;
//============================================================================

//============================================================================
// interface IBindCtx

  PBindOpts = ^TBindOpts;
  TBindOpts = record
    cbStruct: Longint;
    grfFlags: Longint;
    grfMode: Longint;
    dwTickCountDeadline: Longint;
  end;

  IBindCtx = interface(IUnknown)
    ['{0000000E-0000-0000-C000-000000000046}']
    function RegisterObjectBound(const unk: IUnknown): HResult; stdcall;
    function RevokeObjectBound(const unk: IUnknown): HResult; stdcall;
    function ReleaseBoundObjects: HResult; stdcall;
    function SetBindOptions(const bindopts: TBindOpts): HResult; stdcall;
    function GetBindOptions(var bindopts: TBindOpts): HResult; stdcall;
    function GetRunningObjectTable(out rot: IRunningObjectTable): HResult;
      stdcall;
    function RegisterObjectParam(pszKey: POleStr; const unk: IUnknown): HResult;
      stdcall;
    function GetObjectParam(pszKey: POleStr; out unk: IUnknown): HResult;
      stdcall;
    function EnumObjectParam(out pEnumString: IEnumString): HResult; stdcall;
    function RevokeObjectParam(pszKey: POleStr): HResult; stdcall;
  end;
//============================================================================

  IParseDisplayName = interface(IUnknown)
    ['{0000011A-0000-0000-C000-000000000046}']
    function ParseDisplayName(const bc: IBindCtx; pszDisplayName: POleStr;
      out chEaten: Longint; out mkOut: IMoniker): HResult; stdcall;
  end;

  IOleContainer = interface(IParseDisplayName)
    ['{0000011B-0000-0000-C000-000000000046}']
    function EnumObjects(grfFlags: Longint; out pEnumUnknown: IEnumUnknown): HResult;
      stdcall;
    function LockContainer(fLock: BOOL): HResult; stdcall;
  end;

  IOleClientSite = interface(IUnknown)
    ['{00000118-0000-0000-C000-000000000046}']
    function SaveObject: HResult; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      out mk: IMoniker): HResult; stdcall;
    function GetContainer(out container: IOleContainer): HResult; stdcall;
    function ShowObject: HResult; stdcall;
    function OnShowWindow(fShow: BOOL): HResult; stdcall;
    function RequestNewObjectLayout: HResult; stdcall;
  end;

  IMoniker = interface(IPersistStream)
    ['{0000000F-0000-0000-C000-000000000046}']
    function BindToObject(const bc: IBindCtx; const mkToLeft: IMoniker;
      const iidResult: TIID; out vResult): HResult; stdcall;
    function BindToStorage(const bc: IBindCtx; const mkToLeft: IMoniker;
      const iid: TIID; out vObj): HResult; stdcall;
    function Reduce(const bc: IBindCtx; dwReduceHowFar: Longint;
      mkToLeft: PIMoniker; out mkReduced: IMoniker): HResult; stdcall;
    function ComposeWith(const mkRight: IMoniker; fOnlyIfNotGeneric: BOOL;
      out mkComposite: IMoniker): HResult; stdcall;
    function Enum(fForward: BOOL; out enumMoniker: IEnumMoniker): HResult;
      stdcall;
    function IsEqual(const mkOtherMoniker: IMoniker): HResult; stdcall;
    function Hash(out dwHash: Longint): HResult; stdcall;
    function IsRunning(const bc: IBindCtx; const mkToLeft: IMoniker;
      const mkNewlyRunning: IMoniker): HResult; stdcall;
    function GetTimeOfLastChange(const bc: IBindCtx; const mkToLeft: IMoniker;
      out filetime: TFileTime): HResult; stdcall;
    function Inverse(out mk: IMoniker): HResult; stdcall;
    function CommonPrefixWith(const mkOther: IMoniker;
      out mkPrefix: IMoniker): HResult; stdcall;
    function RelativePathTo(const mkOther: IMoniker;
      out mkRelPath: IMoniker): HResult; stdcall;
    function GetDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker;
      out pszDisplayName: POleStr): HResult; stdcall;
    function ParseDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker;
      pszDisplayName: POleStr; out chEaten: Longint;
      out mkOut: IMoniker): HResult; stdcall;
    function IsSystemMoniker(out dwMksys: Longint): HResult; stdcall;
  end;

//============================================================================
// interface DShockwaveFlashEvents

  DShockwaveFlashEvents = interface(IDispatch)
    ['{d27cdb6d-ae6d-11cf-96b8-444553540000}']
  end;

//============================================================================

//============================================================================
// class TFlashPlayerControl

TFlashPlayerControl = class(TWinControl,
                            IUnknown,
                            IOleClientSite,
                            IOleControlSite,
                            IOleInPlaceSite,
                            IOleInPlaceFrame,
                            IDispatch,
                            IPropertyNotifySink,
                            //ISimpleFrameSite,
                            IFlashPlayerControlBase,
                            IOleWindow,
                            DShockwaveFlashEvents)
  private
    FRefCount: Longint;
    FOleObject: IOleObject;
    FPersistStream: IPersistStreamInit;
    FOleControl: IOleControl;
    FControlDispatch: IDispatch;
    FPropBrowsing: IPerPropertyBrowsing;
    FOleInPlaceObject: IOleInPlaceObject;
    FOleInPlaceActiveObject: IOleInPlaceActiveObject;
    FPropConnection: Longint;
    FMiscStatus: Longint;

    m_pFlashConnectionPoint: IConnectionPoint;
    m_bListenNativeEvents: Boolean;
    m_nNativeEventsCookie: Integer;
    
    // Events

    // Native events
    FOnReadyStateChange: TFlashPlayerControlOnReadyStateChange;
    FOnProgress: TFlashPlayerControlOnProgress;
    FOnFSCommand: TFlashPlayerControlFSCommand;
    FOnFlashCall: TFlashPlayerControlFlashCall;

    // Extended events
    FOnLoadExternalResource: TFlashPlayerControlOnLoadExternalResource;
    FOnLoadExternalResourceEx: TFlashPlayerControlOnLoadExternalResourceEx;
    FOnLoadExternalResourceAsync: TFlashPlayerControlOnLoadExternalResourceAsync;
    FOnUnloadExternalResourceAsync: TFlashPlayerControlOnUnloadExternalResourceAsync;

{ Properties variables...BEGIN }

    // Property: ReadyState
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FReadyState: Integer;

    // Property: TotalFrames
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FTotalFrames: Integer;

    // Property: Movie
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FMovie: WideString;

    // Property: FrameNum
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FFrameNum: Integer;

    // Property: Playing
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FPlaying: WordBool;

    // Property: Quality
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FQuality: Integer;

    // Property: ScaleMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FScaleMode: Integer;

    // Property: AlignMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FAlignMode: Integer;

    // Property: BackgroundColor
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FBackgroundColor: Integer;

    // Property: Loop
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FLoop: WordBool;

    // Property: WMode
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FWMode: WideString;

    // Property: SAlign
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FSAlign: WideString;

    // Property: Menu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FMenu: WordBool;

    // Property: Base
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FBase: WideString;

    // Property: Scale
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FScale: WideString;

    // Property: DeviceFont
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FDeviceFont: WordBool;

    // Property: EmbedMovie
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FEmbedMovie: WordBool;

    // Property: BGColor
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FBGColor: WideString;

    // Property: Quality2
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FQuality2: WideString;

    // Property: SWRemote
    // Type: WideString
    // Flash versions: 4, 5, 7, 8, 9
    FSWRemote: WideString;

    // Property: Stacking
    // Type: WideString
    // Flash versions: 5
    FStacking: WideString;

    // Property: FlashVars
    // Type: WideString
    // Flash versions: 7, 8, 9
    FFlashVars: WideString;

    // Property: AllowScriptAccess
    // Type: WideString
    // Flash versions: 7, 8, 9
    FAllowScriptAccess: WideString;

    // Property: MovieData
    // Type: WideString
    // Flash versions: 7, 8, 9
    FMovieData: WideString;

    FAllowFullscreen: WordBool;

    // Property: StandartMenu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FStandartMenu: WordBool;

{ Properties variables...END }

    function GetFlashVersion: integer;
    function InternalGetFlashVersion: integer;

    procedure CreateControl;
    procedure CreateInstance;
    procedure DestroyControl;
    function GetMainMenu: TMainMenu;
    function GetOleObject: Variant;
    procedure HookControlWndProc;
    procedure SetUIActive(Active: Boolean);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure CMDocWindowActivate(var Message: TMessage); message CM_DOCWINDOWACTIVATE;
    procedure CMDialogKey(var Message: TMessage); message CM_DIALOGKEY;
    procedure CMUIActivate(var Message: TMessage); message CM_UIACTIVATE;
    procedure CMUIDeactivate(var Message: TMessage); message CM_UIDEACTIVATE;

    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
    procedure WMMButtonDblClk(var Message: TWMMButtonDblClk); message WM_MBUTTONDBLCLK;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMButtonUp(var Message: TWMMButtonUp); message WM_MBUTTONUP;

    procedure DoMouseDown(var Message: TWMMouse; Button: TMouseButton;
      Shift: TShiftState);
    procedure DoMouseUp(var Message: TWMMouse; Button: TMouseButton);
  protected
    { IUnknown }
{$IFNDEF DEF_DELPHI3}
    function QueryInterface(const IID: TGUID; out Obj): HResult; override;
{$ELSE}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
{$ENDIF}
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IOleClientSite }
    function SaveObject: HResult; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      out mk: IMoniker): HResult; stdcall;
    function GetContainer(out container: IOleContainer): HResult; stdcall;
    function ShowObject: HResult; stdcall;
    function OnShowWindow(fShow: BOOL): HResult; stdcall;
    function RequestNewObjectLayout: HResult; stdcall;
    { IOleControlSite }
    function OnControlInfoChanged: HResult; stdcall;
    function LockInPlaceActive(fLock: BOOL): HResult; stdcall;
    function GetExtendedControl(out disp: IDispatch): HResult; stdcall;
    function TransformCoords(var ptlHimetric: TPoint; var ptfContainer: TPointF;
      flags: Longint): HResult; stdcall;
    function IOleControlSite.TranslateAccelerator = OleControlSite_TranslateAccelerator;
    function OleControlSite_TranslateAccelerator(msg: PMsg;
      grfModifiers: Longint): HResult; stdcall;
    function OnFocus(fGotFocus: BOOL): HResult; stdcall;
    function ShowPropertyFrame: HResult; stdcall;
    { IOleWindow }
    function GetWindow(out WindowHandle: HWnd): HResult; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HResult; stdcall;
    { IOleInPlaceSite }
    function IOleInPlaceSite.GetWindow = OleInPlaceSite_GetWindow;
    function OleInPlaceSite_GetWindow(out wnd: HWnd): HResult; stdcall;
    function CanInPlaceActivate: HResult; stdcall;
    function OnInPlaceActivate: HResult; stdcall;
    function OnUIActivate: HResult; stdcall;
    function GetWindowContext(out frame: IOleInPlaceFrame;
      out doc: IOleInPlaceUIWindow; out rcPosRect: TRect;
      out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HResult;
      stdcall;
    function Scroll(scrollExtent: TPoint): HResult; stdcall;
    function OnUIDeactivate(fUndoable: BOOL): HResult; stdcall;
    function OnInPlaceDeactivate: HResult; stdcall;
    function DiscardUndoState: HResult; stdcall;
    function DeactivateAndUndo: HResult; stdcall;
    function OnPosRectChange(const rcPosRect: TRect): HResult; stdcall;
    { IOleInPlaceUIWindow }
    function GetBorder(out rectBorder: TRect): HResult; stdcall;
    function RequestBorderSpace(const borderwidths: TRect): HResult; stdcall;
    function SetBorderSpace(pborderwidths: PRect): HResult; stdcall;
    function SetActiveObject(const activeObject: IOleInPlaceActiveObject;
      pszObjName: POleStr): HResult; stdcall;
    { IOleInPlaceFrame }
    function IOleInPlaceFrame.GetWindow = OleInPlaceFrame_GetWindow;
    function OleInPlaceFrame_GetWindow(out wnd: HWnd): HResult; stdcall;
    function InsertMenus(hmenuShared: HMenu;
      var menuWidths: TOleMenuGroupWidths): HResult; stdcall;
    function SetMenu(hmenuShared: HMenu; holemenu: HMenu;
      hwndActiveObject: HWnd): HResult; stdcall;
    function RemoveMenus(hmenuShared: HMenu): HResult; stdcall;
    function SetStatusText(pszStatusText: POleStr): HResult; stdcall;
    function EnableModeless(fEnable: BOOL): HResult; stdcall;
    function IOleInPlaceFrame.TranslateAccelerator = OleInPlaceFrame_TranslateAccelerator;
    function OleInPlaceFrame_TranslateAccelerator(var msg: TMsg;
      wID: Word): HResult; stdcall;
    { IDispatch }
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    { ISimpleFrameSite }

//{$IF CompilerVersion >= 33}
//    function PreMessageFilter(wnd: HWnd; msg: UInt; wp: WPARAM; lp: LPARAM;
//      out res: LRESULT; out Cookie: DWORD): HResult;
//      stdcall;
//    function PostMessageFilter(wnd: HWnd; msg: UInt; wp: WPARAM; lp: LPARAM;
//      out res: LRESULT; Cookie: DWORD): HResult;
//      stdcall;
//{$ELSE}
//    function PreMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
//      out res: IntPtr; out Cookie: Longint): HResult; stdcall;
//    function PostMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
//      out res: IntPtr; Cookie: Longint): HResult; stdcall;
//{$IFEND}

    { TFlashPlayerControl }
    procedure CreateWnd; override;
    procedure DestroyWindowHandle; override;
    function PaletteChanged(Foreground: Boolean): Boolean; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure WndProc(var Message: TMessage); override;
    { IPropertyNotifySink }
    function OnChanged(dispid: TDispID): HResult; virtual; stdcall;
    function OnRequestEdit(dispid: TDispID): HResult; virtual; stdcall;

    { IFlashPlayerControlBase }
    function IFlashPlayerControlBase_PutMovie(NewMovie: WideString): HResult; stdcall;
    function IFlashPlayerControlBase_LoadMovie(Layer: Integer; const url: WideString): HResult; stdcall;
    function IFlashPlayerControlBase_GetBase(var { out } url: WideString): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnLoadExternalResource(const URL: WideString; Stream: TStream): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnLoadExternalResourceEx(const URL: WideString; Stream: TStream; out bHandled: Boolean): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnLoadExternalResourceAsync(const Path: WideString; out Stream: TStream): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnUnloadExternalResourceAsync(Stream: TStream): HResult; stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property OleObject: Variant read GetOleObject;

    function CreateFrameBitmap: TBitmap;

    procedure DefaultHandler(var Message); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    // Loading movie from stream
    procedure LoadMovieFromStream(layer: integer; AStream: TStream); virtual;
    procedure PutMovieFromStream(AStream: TStream); virtual;
    // Loading movie using stream
    procedure LoadMovieUsingStream(layer: integer; out AStream: TStream); virtual;
    procedure PutMovieUsingStream(out AStream: TStream); virtual;

    { Methods...BEGIN }
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); virtual;
    procedure Zoom(factor: SYSINT); virtual;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); virtual;
    procedure Play; virtual;
    procedure Stop; virtual;
    procedure Back; virtual;
    procedure Forward; virtual;
    procedure Rewind; virtual;
    procedure StopPlay; virtual;
    procedure GotoFrame(FrameNum: Integer); virtual;
    function CurrentFrame: Integer; virtual;
    function IsPlaying: WordBool; virtual;
    function PercentLoaded: Integer; virtual;
    function FrameLoaded(FrameNum: Integer): WordBool; virtual;
    function FlashVersion: Integer; virtual;
    procedure LoadMovie(layer: SYSINT; const url: WideString); virtual;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); virtual;
    procedure TGotoLabel(const target: WideString; const label_: WideString); virtual;
    function TCurrentFrame(const target: WideString): Integer; virtual;
    function TCurrentLabel(const target: WideString): WideString; virtual;
    procedure TPlay(const target: WideString); virtual;
    procedure TStopPlay(const target: WideString); virtual;
    procedure SetVariable(const name: WideString; const value: WideString); virtual;
    function GetVariable(const name: WideString): WideString; virtual;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); virtual;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; virtual;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); virtual;
    procedure TCallLabel(const target: WideString; const label_: WideString); virtual;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); virtual;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; virtual;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; virtual;

    // Flash 8
    function CallFunction(const request: WideString): WideString; virtual;
    procedure SetReturnValue(const returnValue: WideString); virtual;

    { Methods...END }

{ Properties getting/putting...BEGIN }

    // Property: ReadyState
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetReadyState: Integer; virtual;

    // Property: TotalFrames
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetTotalFrames: Integer; virtual;

    // Property: Movie
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetMovie: WideString; virtual;
    procedure PutMovie(NewMovie: WideString); virtual;

    // Property: FrameNum
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetFrameNum: Integer; virtual;
    procedure PutFrameNum(NewFrameNum: Integer); virtual;

    // Property: Playing
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetPlaying: WordBool; virtual;
    procedure PutPlaying(NewPlaying: WordBool); virtual;

    // Property: Quality
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetQuality: Integer; virtual;
    procedure PutQuality(NewQuality: Integer); virtual;

    // Property: ScaleMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetScaleMode: Integer; virtual;
    procedure PutScaleMode(NewScaleMode: Integer); virtual;

    // Property: AlignMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetAlignMode: Integer; virtual;
    procedure PutAlignMode(NewAlignMode: Integer); virtual;

    // Property: BackgroundColor
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetBackgroundColor: Integer; virtual;
    procedure PutBackgroundColor(NewBackgroundColor: Integer); virtual;

    // Property: Loop
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetLoop: WordBool; virtual;
    procedure PutLoop(NewLoop: WordBool); virtual;

    // Property: WMode
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetWMode: WideString; virtual;
    procedure PutWMode(NewWMode: WideString); virtual;

    // Property: SAlign
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetSAlign: WideString; virtual;
    procedure PutSAlign(NewSAlign: WideString); virtual;

    // Property: Menu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetMenu: WordBool; virtual;
    procedure PutMenu(NewMenu: WordBool); virtual;

    // Property: Base
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetBase: WideString; virtual;
    procedure PutBase(NewBase: WideString); virtual;

    // Property: Scale
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetScale: WideString; virtual;
    procedure PutScale(NewScale: WideString); virtual;

    // Property: DeviceFont
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetDeviceFont: WordBool; virtual;
    procedure PutDeviceFont(NewDeviceFont: WordBool); virtual;

    // Property: EmbedMovie
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetEmbedMovie: WordBool; virtual;
    procedure PutEmbedMovie(NewEmbedMovie: WordBool); virtual;

    // Property: BGColor
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetBGColor: WideString; virtual;
    procedure PutBGColor(NewBGColor: WideString); virtual;

    // Property: Quality2
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetQuality2: WideString; virtual;
    procedure PutQuality2(NewQuality2: WideString); virtual;

    // Property: SWRemote
    // Type: WideString
    // Flash versions: 4, 5, 7, 8, 9
    function GetSWRemote: WideString; virtual;
    procedure PutSWRemote(NewSWRemote: WideString); virtual;

    // Property: Stacking
    // Type: WideString
    // Flash versions: 5
    function GetStacking: WideString; virtual;
    procedure PutStacking(NewStacking: WideString); virtual;

    // Property: FlashVars
    // Type: WideString
    // Flash versions: 7, 8, 9
    function GetFlashVars: WideString; virtual;
    procedure PutFlashVars(NewFlashVars: WideString); virtual;

    // Property: AllowScriptAccess
    // Type: WideString
    // Flash versions: 7, 8, 9
    function GetAllowScriptAccess: WideString; virtual;
    procedure PutAllowScriptAccess(NewAllowScriptAccess: WideString); virtual;

    // Property: MovieData
    // Type: WideString
    // Flash versions: 7, 8, 9
    function GetMovieData: WideString; virtual;
    procedure PutMovieData(NewMovieData: WideString); virtual;


    // Property: AllowFullscreen
    // Type: WordBool
    // Flash versions: 9.0.28.0
    function GetAllowFullscreen: WordBool; virtual;
    procedure PutAllowFullscreen(bAllowFullscreen: WordBool); virtual;


    // Read-only properties

    // Property: ReadyState
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property ReadyState: Integer read GetReadyState;

    // Property: TotalFrames
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property TotalFrames: Integer read GetTotalFrames;

{ Properties getting/putting...END }

  published
{$IFNDEF DEF_DELPHI3}
    property Anchors;
{$ENDIF}
    property TabStop default True;
    property Align;
    property DragCursor;
    property DragMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDrag;

    // Events

    // Native events
    property OnReadyStateChange: TFlashPlayerControlOnReadyStateChange read FOnReadyStateChange write FOnReadyStateChange;
    property OnProgress: TFlashPlayerControlOnProgress read FOnProgress write FOnProgress;
    property OnFSCommand: TFlashPlayerControlFSCommand read FOnFSCommand write FOnFSCommand;
    property OnFlashCall: TFlashPlayerControlFlashCall read FOnFlashCall write FOnFlashCall;

    // Extended events
    property OnLoadExternalResource: TFlashPlayerControlOnLoadExternalResource read FOnLoadExternalResource write FOnLoadExternalResource;
    property OnLoadExternalResourceEx: TFlashPlayerControlOnLoadExternalResourceEx read FOnLoadExternalResourceEx write FOnLoadExternalResourceEx;
    property OnLoadExternalResourceAsync: TFlashPlayerControlOnLoadExternalResourceAsync read FOnLoadExternalResourceAsync write FOnLoadExternalResourceAsync;
    property OnUnloadExternalResourceAsync: TFlashPlayerControlOnUnloadExternalResourceAsync read FOnUnloadExternalResourceAsync write FOnUnloadExternalResourceAsync;

    // Mouse events
    property OnDblClick;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnMouseDown;

{ Published properties...BEGIN }

    // Native events

    // Property: Movie
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Movie: WideString read GetMovie write PutMovie;

    // Property: FrameNum
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property FrameNum: Integer read GetFrameNum write PutFrameNum;
    
    // Property: Playing
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Playing: WordBool read GetPlaying write PutPlaying;

    // Property: Quality
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Quality: Integer read GetQuality write PutQuality;

    // Property: ScaleMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property ScaleMode: Integer read GetScaleMode write PutScaleMode;

    // Property: AlignMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property AlignMode: Integer read GetAlignMode write PutAlignMode;

    // Property: BackgroundColor
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property BackgroundColor: Integer read GetBackgroundColor write PutBackgroundColor;

    // Property: Loop
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Loop: WordBool read GetLoop write PutLoop;

    // Property: WMode
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property WMode: WideString read GetWMode write PutWMode;

    // Property: SAlign
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property SAlign: WideString read GetSAlign write PutSAlign;

    // Property: Menu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Menu: WordBool read GetMenu write PutMenu;

    // Property: Base
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Base: WideString read GetBase write PutBase;

    // Property: Scale
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Scale: WideString read GetScale write PutScale;

    // Property: DeviceFont
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property DeviceFont: WordBool read GetDeviceFont write PutDeviceFont;

    // Property: EmbedMovie
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property EmbedMovie: WordBool read GetEmbedMovie write PutEmbedMovie;

    // Property: BGColor
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property BGColor: WideString read GetBGColor write PutBGColor;

    // Property: Quality2
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Quality2: WideString read GetQuality2 write PutQuality2;

    // Property: SWRemote
    // Type: WideString
    // Flash versions: 4, 5, 7, 8, 9
    property SWRemote: WideString read GetSWRemote write PutSWRemote;

    // Property: Stacking
    // Type: WideString
    // Flash versions: 5
    property Stacking: WideString read GetStacking write PutStacking;

    // Property: FlashVars
    // Type: WideString
    // Flash versions: 7, 8, 9
    property FlashVars: WideString read GetFlashVars write PutFlashVars;

    // Property: AllowScriptAccess
    // Type: WideString
    // Flash versions: 7, 8, 9
    property AllowScriptAccess: WideString read GetAllowScriptAccess write PutAllowScriptAccess;

    // Property: MovieData
    // Type: WideString
    // Flash versions: 7, 8, 9
    property MovieData: WideString read GetMovieData write PutMovieData;

    property AllowFullscreen: WordBool read GetAllowFullscreen write PutAllowFullscreen;

{ Published properties...END }

    // Extended properties

    // Property: StandartMenu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property StandartMenu: WordBool read FStandartMenu write FStandartMenu default False;

  end;

//============================================================================

//    typedef struct tagExtentInfo {
//        ULONG   cb;
//        DWORD   dwExtentMode;
//        SIZEL   sizelProposed;
//    } DVEXTENTINFO;

  tagExtentInfo = packed record
    cb: ULONG;
    dwExtentMode: DWORD;
    sizelProposed: TSize;
  end;

//    typedef struct tagAspectInfo {
//        ULONG   cb;
//        DWORD   dwFlags;
//    } DVASPECTINFO;

  tagAspectInfo = packed record
    cb: ULONG;
    dwFlags: DWORD;
  end;

  //typedef struct tagDVEXTENTINFO
  //{
  //  ULONG cb;
  //  DWORD dwExtentMode;
  //  SIZEL sizelProposed;
  //}DVEXTENTINFO;

  tagDVEXTENTINFO = packed record
    cb: ULONG;
    dwExtentMode: DWORD;
    sizelProposed: TSize;
  end;
  PDVEXTENTINFO = ^tagDVEXTENTINFO;

//============================================================================
// interface IViewObjectEx

  IViewObjectEx = interface(IViewObject2)
    ['{3AF24292-0C96-11CE-A0CF-00AA00600AB8}']

//    HRESULT GetRect(
//                [in] DWORD dwAspect,
//                [out] LPRECTL pRect
//            );
    function GetRect(dwAspect: DWORD; pRect: PRect): HResult; stdcall;

//    HRESULT GetViewStatus(
//                [out] DWORD * pdwStatus
//            );
    function GetViewStatus(out dwStatus: DWORD): HResult; stdcall;

//    HRESULT QueryHitPoint(
//                [in] DWORD dwAspect,
//                [in] LPCRECT pRectBounds,
//                [in] POINT ptlLoc,
//                [in] LONG lCloseHint,
//                [out] DWORD * pHitResult
//            );
    function QueryHitPoint(dwAspect: DWORD; const pRectBounds: PRect; ptlLoc: TPoint; lCloseHint: Longint; out HitResult: DWORD): HResult; stdcall;

//    HRESULT QueryHitRect(
//                [in] DWORD dwAspect,
//                [in] LPCRECT pRectBounds,
//                [in] LPCRECT pRectLoc,
//                [in] LONG lCloseHint,
//                [out] DWORD * pHitResult
//            );
    function QueryHitRect(dwAspect: DWORD; const pRectBounds: PRect; const pRectLoc: PRect; lCloseHint: Longint; out HitResult: DWORD): HResult; stdcall;

//    HRESULT GetNaturalExtent (
//                [in] DWORD dwAspect,
//                [in] LONG lindex,
//                [in] DVTARGETDEVICE * ptd,
//                [in] HDC hicTargetDev,
//                [in] DVEXTENTINFO * pExtentInfo,
//                [out] LPSIZEL pSizel
//            );
    function GetNaturalExtent(dwAspect: DWORD; lindex: Longint; ptd: PDVTARGETDEVICE; hicTargetDev: HDC; pExtentInfo: PDVEXTENTINFO; out Size: TSize): HResult; stdcall;

  end;

//============================================================================

//============================================================================
// interface IOleInPlaceSiteWindowless

  LongWord = Integer;

  IOleInPlaceSiteWindowless = interface(IOleInPlaceSiteEx)
    ['{922EADA0-3424-11CF-B670-00AA004CD6D8}']
    function CanWindowlessActivate: HResult; stdcall;
    function GetCapture: HResult; stdcall;
    function SetCapture(fCapture: BOOL): HResult; stdcall;
    function GetFocus: HResult; stdcall;
    function SetFocus(fFocus: BOOL): HResult; stdcall;
    function GetDC(var Rect: TRect; qrfFlags: DWORD;
       var hDC: HDC): HResult; stdcall;
    function ReleaseDC(hDC: HDC): HResult; stdcall;
    function InvalidateRect(var Rect: TRect; fErase: BOOL): HResult; stdcall;
    function InvalidateRgn(hRGN: HRGN; fErase: BOOL): HResult; stdcall;
    function ScrollRect(dx, dy: Integer; var RectScroll: TRect;
       var RectClip: TRect): HResult; stdcall;
    function AdjustRect(var rc: TRect): HResult; stdcall;
    function OnDefWindowMessage(msg: LongWord; wParam: WPARAM;
       lParam: LPARAM; var LResult: LRESULT): HResult; stdcall;
  end;

//============================================================================

//============================================================================
// interface IOleInPlaceObjectWindowless

  IOleInPlaceObjectWindowless = interface(IOleInPlaceObject)
    ['{1C2056CC-5EF4-101B-8BC8-00AA003E3B29}']
    function OnWindowMessage(msg: LongWord; wParam: WPARAM; lParam: LPARAM;
        var lResult: LRESULT): HResult; stdcall;
    function OnDropTarget(var pDropTarget: IDropTarget):HResult ; stdcall;
  end;

//============================================================================

//============================================================================
// class TTransparentFlashPlayerControl

TTransparentFlashPlayerControl = class(TObject,
                                       IUnknown,
                                       IOleClientSite,
                                       IOleInPlaceSiteWindowless,
                                       //IOleWindow,
                                       //IOleControlSite,
                                       //IParseDisplayName,
                                       //IOleContainer,
                                       //IOleInPlaceFrame,
                                       //IOleInPlaceUIWindow,
                                       IFlashPlayerControlBase
                                       //IDispatch,
                                       {DShockwaveFlashEvents})
  private
    FRefCount: Longint;

    m_pUnknown: IUnknown;
    m_pViewObject: IViewObject;
    m_pViewObjectEx: IViewObjectEx;
    m_pOleObject: IOleObject;
    m_pInPlaceObjectWindowless: IOleInPlaceObjectWindowless;

    m_bInPlaceActive: boolean;
    m_bWindowless: boolean;
    m_bCapture: boolean;
    m_bHaveFocus: boolean;
    m_bDCReleased: boolean;
    m_bUIActive: boolean;
    m_bLocked: boolean;

    m_hDCScreen: HDC;

    m_bInPaint: boolean;

    FOldParentWndProc: TWndMethod;
    FSavedAlign: TAlign;
    FSavedBoundsRect: TRect;
    FSavedParentExStyle: DWORD;
    FSavedParentStyle: DWORD;
    FSavedParentBorderStyle: TFormBorderStyle;

    m_pFlashConnectionPoint: IConnectionPoint;
    m_bListenNativeEvents: Boolean;
    m_nNativeEventsCookie: Integer;

    // Size
    m_size: TSize;
    m_pBitsWhite: Pointer;
    m_pBitsBlack: Pointer;
    m_pBits: Pointer;
    m_hBmpWhite: HBITMAP;
    m_hBmpBlack: HBITMAP;
    m_hBmp: HBITMAP;

    // Events

    // Native events
    FOnReadyStateChange: TFlashPlayerControlOnReadyStateChange;
    FOnProgress: TFlashPlayerControlOnProgress;
    FOnFSCommand: TFlashPlayerControlFSCommand;
    FOnFlashCall: TFlashPlayerControlFlashCall;
    FOnUpdateRect: TFlashPlayerControlUpdateRect;
    FOnFlashPaint: TFlashPlayerControlOnFlashPaint;

    // Extended events
    FOnLoadExternalResource: TFlashPlayerControlOnLoadExternalResource;
    FOnLoadExternalResourceEx: TFlashPlayerControlOnLoadExternalResourceEx;
    FOnLoadExternalResourceAsync: TFlashPlayerControlOnLoadExternalResourceAsync;
    FOnUnloadExternalResourceAsync: TFlashPlayerControlOnUnloadExternalResourceAsync;
    FOnDrawBackground: TFlashPlayerControlOnDrawBackground;

{ Properties variables...BEGIN }

    // Property: ReadyState
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FReadyState: Integer;

    // Property: TotalFrames
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FTotalFrames: Integer;

    // Property: Movie
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FMovie: WideString;

    // Property: FrameNum
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FFrameNum: Integer;

    // Property: Playing
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FPlaying: WordBool;

    // Property: Quality
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FQuality: Integer;

    // Property: ScaleMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FScaleMode: Integer;

    // Property: AlignMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FAlignMode: Integer;

    // Property: BackgroundColor
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FBackgroundColor: Integer;

    // Property: Loop
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FLoop: WordBool;

    // Property: WMode
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FWMode: WideString;

    // Property: SAlign
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FSAlign: WideString;

    // Property: Menu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FMenu: WordBool;

    // Property: Base
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FBase: WideString;

    // Property: Scale
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FScale: WideString;

    // Property: DeviceFont
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FDeviceFont: WordBool;

    // Property: EmbedMovie
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FEmbedMovie: WordBool;

    // Property: BGColor
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FBGColor: WideString;

    // Property: Quality2
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FQuality2: WideString;

    // Property: SWRemote
    // Type: WideString
    // Flash versions: 4, 5, 7, 8, 9
    FSWRemote: WideString;

    // Property: Stacking
    // Type: WideString
    // Flash versions: 5
    FStacking: WideString;

    // Property: FlashVars
    // Type: WideString
    // Flash versions: 7, 8, 9
    FFlashVars: WideString;

    // Property: AllowScriptAccess
    // Type: WideString
    // Flash versions: 7, 8, 9
    FAllowScriptAccess: WideString;

    // Property: MovieData
    // Type: WideString
    // Flash versions: 7, 8, 9
    FMovieData: WideString;

    FAllowFullscreen: WordBool;

    // Property: StandartMenu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FStandartMenu: WordBool;


    // Property: MakeParentTransparent
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    FMakeParentTransparent: WordBool;

{ Properties variables...END }

    function InternalGetFlashVersion: integer;

  protected
  public
    Width,
    Height: Integer;
    constructor Create;
    destructor Destroy; override;

    function CreateFrameBitmap: TBitmap;

    function AttachControl(pUnkControl: IUnknown): HRESULT;

    procedure LoadSWF(AStream: TStream; AWidth, AHeight: Integer);

//    procedure WMKeyDown(var Message: TWMK); message CN_KE;
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    { IOleInPlaceUIWindow }
    function GetBorder(out rectBorder: TRect): HResult; stdcall;
    function RequestBorderSpace(const borderwidths: TRect): HResult; stdcall;
    function SetBorderSpace(pborderwidths: PRect): HResult; stdcall;
    function SetActiveObject(const activeObject: IOleInPlaceActiveObject;
      pszObjName: POleStr): HResult; stdcall;

    { IOleInPlaceFrame }
//    function IOleInPlaceFrame.GetWindow = OleInPlaceFrame_GetWindow;
//    function OleInPlaceFrame_GetWindow(out wnd: HWnd): HResult; stdcall;
    function InsertMenus(hmenuShared: HMenu;
      var menuWidths: TOleMenuGroupWidths): HResult; stdcall;
    function SetMenu(hmenuShared: HMenu; holemenu: HMenu;
      hwndActiveObject: HWnd): HResult; stdcall;
    function RemoveMenus(hmenuShared: HMenu): HResult; stdcall;
    function SetStatusText(pszStatusText: POleStr): HResult; stdcall;
    function EnableModeless(fEnable: BOOL): HResult; stdcall;
    //function IOleInPlaceFrame.TranslateAccelerator = OleInPlaceFrame_TranslateAccelerator;
    function OleInPlaceFrame_TranslateAccelerator(var msg: TMsg;
      wID: Word): HResult; stdcall;

  { IOleClientSite }
    function SaveObject: HResult; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint; out mk: IMoniker): HResult; stdcall;
    function GetContainer(out container: IOleContainer): HResult; stdcall;
    function ShowObject: HResult; stdcall;
    function OnShowWindow(fShow: BOOL): HResult; stdcall;
    function RequestNewObjectLayout: HResult; stdcall;

  { IOleInPlaceSiteWindowless }
    function CanWindowlessActivate: HResult; stdcall;
    function GetCapture: HResult; stdcall;
    function SetCapture(fCapture: BOOL): HResult; stdcall;
    function GetFocus: HResult; stdcall;
    function SetFocus(fFocus: BOOL): HResult; stdcall;
    function GetDC(var rc: TRect; qrfFlags: DWORD; var hDC: HDC): HResult; stdcall;
    function ReleaseDC(hDC: HDC): HResult; stdcall;
    function InvalidateRect(var Rect: TRect; fErase: BOOL): HResult; stdcall;
    function InvalidateRgn(hRGN: HRGN; fErase: BOOL): HResult; stdcall;
    function ScrollRect(dx, dy: Integer; var RectScroll: TRect; var RectClip: TRect): HResult; stdcall;
    function AdjustRect(var rc: TRect): HResult; stdcall;
    function OnDefWindowMessage(msg: LongWord; wParam: WPARAM; lParam: LPARAM; var LResult: LRESULT): HResult; stdcall;

  { IOleInPlaceSiteEx }
    function OnInPlaceActivateEx(fNoRedraw: PBOOL; dwFlags: DWORD): HResult; stdcall;
    function OnInPlaceDeActivateEx(fNoRedraw: BOOL): HResult; stdcall;
    function RequestUIActivate: HResult; stdcall;

  { IOleInPlaceSite }
    function CanInPlaceActivate: HResult; stdcall;
    function OnInPlaceActivate: HResult; stdcall;
    function OnUIActivate: HResult; stdcall;
    function GetWindowContext(out frame: IOleInPlaceFrame; out doc: IOleInPlaceUIWindow; out rcPosRect: TRect; out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HResult; stdcall;
    function Scroll(scrollExtent: TPoint): HResult; stdcall;
    function OnUIDeactivate(fUndoable: BOOL): HResult; stdcall;
    function OnInPlaceDeactivate: HResult; stdcall;
    function DiscardUndoState: HResult; stdcall;
    function DeactivateAndUndo: HResult; stdcall;
    function OnPosRectChange(const rcPosRect: TRect): HResult; stdcall;

  { IOleWindow }
    function GetWindow(out wnd: HWnd): HResult; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HResult; stdcall;

  { IOleControlSite }
    function OnControlInfoChanged: HResult; stdcall;
    function LockInPlaceActive(fLock: BOOL): HResult; stdcall;
    function GetExtendedControl(out disp: IDispatch): HResult; stdcall;
    function TransformCoords(var ptlHimetric: TPoint; var ptfContainer: TPointF; flags: Longint): HResult; stdcall;
    function TranslateAccelerator(msg: PMsg; grfModifiers: Longint): HResult; stdcall;
    function OnFocus(fGotFocus: BOOL): HResult; stdcall;
    function ShowPropertyFrame: HResult; stdcall;

  { IOleContainer }
    function EnumObjects(grfFlags: Longint; out Enum: IEnumUnknown): HResult; stdcall;
    function LockContainer(fLock: BOOL): HResult; stdcall;

  { IParseDisplayName }
    function ParseDisplayName(const bc: IBindCtx; pszDisplayName: POleStr; out chEaten: Longint; out mkOut: IMoniker): HResult; stdcall;

  { IDispatch }
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;

  { IFlashPlayerControlBase }
    function IFlashPlayerControlBase_PutMovie(NewMovie: WideString): HResult; stdcall;
    function IFlashPlayerControlBase_LoadMovie(Layer: Integer; const url: WideString): HResult; stdcall;
    function IFlashPlayerControlBase_GetBase(var { out } url: WideString): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnLoadExternalResource(const URL: WideString; Stream: TStream): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnLoadExternalResourceEx(const URL: WideString; Stream: TStream; out bHandled: Boolean): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnLoadExternalResourceAsync(const Path: WideString; out Stream: TStream): HResult; stdcall;
    function IFlashPlayerControlBase_CallOnUnloadExternalResourceAsync(Stream: TStream): HResult; stdcall;

    // Loading movie from stream
    procedure LoadMovieFromStream(layer: integer; AStream: TStream); virtual;
    procedure PutMovieFromStream(AStream: TStream); virtual;
    // Loading movie using stream
    procedure LoadMovieUsingStream(layer: integer; out AStream: TStream); virtual;
    procedure PutMovieUsingStream(out AStream: TStream); virtual;

    { Methods...BEGIN }
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); virtual;
    procedure Zoom(factor: SYSINT); virtual;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); virtual;
    procedure Play; virtual;
    procedure Stop; virtual;
    procedure Back; virtual;
    procedure Forward; virtual;
    procedure Rewind; virtual;
    procedure StopPlay; virtual;
    procedure GotoFrame(FrameNum: Integer); virtual;
    function CurrentFrame: Integer; virtual;
    function IsPlaying: WordBool; virtual;
    function PercentLoaded: Integer; virtual;
    function FrameLoaded(FrameNum: Integer): WordBool; virtual;
    function FlashVersion: Integer; virtual;
    procedure LoadMovie(layer: SYSINT; const url: WideString); virtual;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); virtual;
    procedure TGotoLabel(const target: WideString; const label_: WideString); virtual;
    function TCurrentFrame(const target: WideString): Integer; virtual;
    function TCurrentLabel(const target: WideString): WideString; virtual;
    procedure TPlay(const target: WideString); virtual;
    procedure TStopPlay(const target: WideString); virtual;
    procedure SetVariable(const name: WideString; const value: WideString); virtual;
    function GetVariable(const name: WideString): WideString; virtual;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); virtual;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; virtual;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); virtual;
    procedure TCallLabel(const target: WideString; const label_: WideString); virtual;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); virtual;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; virtual;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; virtual;

    // Flash 8
    function CallFunction(const request: WideString): WideString; virtual;
    procedure SetReturnValue(const returnValue: WideString); virtual;

    { Methods...END }

{ Properties getting/putting...BEGIN }

    // Property: ReadyState
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetReadyState: Integer; virtual;

    // Property: TotalFrames
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetTotalFrames: Integer; virtual;

    // Property: Movie
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetMovie: WideString; virtual;
    procedure PutMovie(NewMovie: WideString); virtual;

    // Property: FrameNum
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetFrameNum: Integer; virtual;
    procedure PutFrameNum(NewFrameNum: Integer); virtual;

    // Property: Playing
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetPlaying: WordBool; virtual;
    procedure PutPlaying(NewPlaying: WordBool); virtual;

    // Property: Quality
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetQuality: Integer; virtual;
    procedure PutQuality(NewQuality: Integer); virtual;

    // Property: ScaleMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetScaleMode: Integer; virtual;
    procedure PutScaleMode(NewScaleMode: Integer); virtual;

    // Property: AlignMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetAlignMode: Integer; virtual;
    procedure PutAlignMode(NewAlignMode: Integer); virtual;

    // Property: BackgroundColor
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetBackgroundColor: Integer; virtual;
    procedure PutBackgroundColor(NewBackgroundColor: Integer); virtual;

    // Property: Loop
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetLoop: WordBool; virtual;
    procedure PutLoop(NewLoop: WordBool); virtual;

    // Property: WMode
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetWMode: WideString; virtual;
    procedure PutWMode(NewWMode: WideString); virtual;

    // Property: SAlign
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetSAlign: WideString; virtual;
    procedure PutSAlign(NewSAlign: WideString); virtual;

    // Property: Menu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetMenu: WordBool; virtual;
    procedure PutMenu(NewMenu: WordBool); virtual;

    // Property: Base
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetBase: WideString; virtual;
    procedure PutBase(NewBase: WideString); virtual;

    // Property: Scale
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetScale: WideString; virtual;
    procedure PutScale(NewScale: WideString); virtual;

    // Property: DeviceFont
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetDeviceFont: WordBool; virtual;
    procedure PutDeviceFont(NewDeviceFont: WordBool); virtual;

    // Property: EmbedMovie
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetEmbedMovie: WordBool; virtual;
    procedure PutEmbedMovie(NewEmbedMovie: WordBool); virtual;

    // Property: BGColor
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetBGColor: WideString; virtual;
    procedure PutBGColor(NewBGColor: WideString); virtual;

    // Property: Quality2
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    function GetQuality2: WideString; virtual;
    procedure PutQuality2(NewQuality2: WideString); virtual;

    // Property: SWRemote
    // Type: WideString
    // Flash versions: 4, 5, 7, 8, 9
    function GetSWRemote: WideString; virtual;
    procedure PutSWRemote(NewSWRemote: WideString); virtual;

    // Property: Stacking
    // Type: WideString
    // Flash versions: 5
    function GetStacking: WideString; virtual;
    procedure PutStacking(NewStacking: WideString); virtual;

    // Property: FlashVars
    // Type: WideString
    // Flash versions: 7, 8, 9
    function GetFlashVars: WideString; virtual;
    procedure PutFlashVars(NewFlashVars: WideString); virtual;

    // Property: AllowScriptAccess
    // Type: WideString
    // Flash versions: 7, 8, 9
    function GetAllowScriptAccess: WideString; virtual;
    procedure PutAllowScriptAccess(NewAllowScriptAccess: WideString); virtual;

    // Property: MovieData
    // Type: WideString
    // Flash versions: 7, 8, 9
    function GetMovieData: WideString; virtual;
    procedure PutMovieData(NewMovieData: WideString); virtual;

    // Property: AllowFullscreen
    // Type: WordBool
    // Flash versions: 9.0.28.0
    function GetAllowFullscreen: WordBool; virtual;
    procedure PutAllowFullscreen(bAllowFullscreen: WordBool); virtual;

    // Read-only properties

    // Property: ReadyState
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property ReadyState: Integer read GetReadyState;

    // Property: TotalFrames
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property TotalFrames: Integer read GetTotalFrames;

    // Extends

{ Properties getting/putting...END }

  published
    // Events

    // Native events
    property OnReadyStateChange: TFlashPlayerControlOnReadyStateChange read FOnReadyStateChange write FOnReadyStateChange;
    property OnProgress: TFlashPlayerControlOnProgress read FOnProgress write FOnProgress;
    property OnFSCommand: TFlashPlayerControlFSCommand read FOnFSCommand write FOnFSCommand;
    property OnFlashCall: TFlashPlayerControlFlashCall read FOnFlashCall write FOnFlashCall;
    property OnUpdateRect: TFlashPlayerControlUpdateRect read FOnUpdateRect write FOnUpdateRect;
    property OnFlashPaint: TFlashPlayerControlOnFlashPaint read FOnFlashPaint write FOnFlashPaint;

    // Extended events
    property OnLoadExternalResource: TFlashPlayerControlOnLoadExternalResource read FOnLoadExternalResource write FOnLoadExternalResource;
    property OnLoadExternalResourceEx: TFlashPlayerControlOnLoadExternalResourceEx read FOnLoadExternalResourceEx write FOnLoadExternalResourceEx;
    property OnLoadExternalResourceAsync: TFlashPlayerControlOnLoadExternalResourceAsync read FOnLoadExternalResourceAsync write FOnLoadExternalResourceAsync;
    property OnUnloadExternalResourceAsync: TFlashPlayerControlOnUnloadExternalResourceAsync read FOnUnloadExternalResourceAsync write FOnUnloadExternalResourceAsync;
    property OnDrawBackground: TFlashPlayerControlOnDrawBackground read FOnDrawBackground write FOnDrawBackground;

{ Published properties...BEGIN }

    // Native events
    property ViewObject: IViewObject read m_pViewObject;

    // Property: Movie
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Movie: WideString read GetMovie write PutMovie;
    
    // Property: FrameNum
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property FrameNum: Integer read GetFrameNum write PutFrameNum;

    // Property: Playing
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Playing: WordBool read GetPlaying write PutPlaying;

    // Property: Quality
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Quality: Integer read GetQuality write PutQuality;

    // Property: ScaleMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property ScaleMode: Integer read GetScaleMode write PutScaleMode;

    // Property: AlignMode
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property AlignMode: Integer read GetAlignMode write PutAlignMode;

    // Property: BackgroundColor
    // Type: Integer
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property BackgroundColor: Integer read GetBackgroundColor write PutBackgroundColor;

    // Property: Loop
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Loop: WordBool read GetLoop write PutLoop;

    // Property: WMode
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property WMode: WideString read GetWMode write PutWMode;

    // Property: SAlign
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property SAlign: WideString read GetSAlign write PutSAlign;

    // Property: Menu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Menu: WordBool read GetMenu write PutMenu;

    // Property: Base
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Base: WideString read GetBase write PutBase;

    // Property: Scale
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Scale: WideString read GetScale write PutScale;

    // Property: DeviceFont
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property DeviceFont: WordBool read GetDeviceFont write PutDeviceFont;

    // Property: EmbedMovie
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property EmbedMovie: WordBool read GetEmbedMovie write PutEmbedMovie;

    // Property: BGColor
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property BGColor: WideString read GetBGColor write PutBGColor;

    // Property: Quality2
    // Type: WideString
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property Quality2: WideString read GetQuality2 write PutQuality2;

    // Property: SWRemote
    // Type: WideString
    // Flash versions: 4, 5, 7, 8, 9
    property SWRemote: WideString read GetSWRemote write PutSWRemote;

    // Property: Stacking
    // Type: WideString
    // Flash versions: 5
    property Stacking: WideString read GetStacking write PutStacking;

    // Property: FlashVars
    // Type: WideString
    // Flash versions: 7, 8, 9
    property FlashVars: WideString read GetFlashVars write PutFlashVars;

    // Property: AllowScriptAccess
    // Type: WideString
    // Flash versions: 7, 8, 9
    property AllowScriptAccess: WideString read GetAllowScriptAccess write PutAllowScriptAccess;

    // Property: MovieData
    // Type: WideString
    // Flash versions: 7, 8, 9
    property MovieData: WideString read GetMovieData write PutMovieData;

    property AllowFullscreen: WordBool read GetAllowFullscreen write PutAllowFullscreen;

{ Published properties...END }

    // Extended properties

    // Property: StandartMenu
    // Type: WordBool
    // Flash versions: 3, 4, 5, 6, 7, 8, 9
    property StandartMenu: WordBool read FStandartMenu write FStandartMenu default False;
end;

//============================================================================

procedure Register;
procedure LoadFlashOCXCodeFromStream(const AStream: TStream);
function GetInstalledFlashVersion: DWORD;
function GetUsingFlashVersion: DWORD;
function GetMinimumFlashVersionToAllowFullscreen: DWORD;
procedure SetAudioEnabled(bEnable: Boolean);
function GetAudioEnabled: Boolean;
procedure SetGlobalOnLoadExternalResourceHandler(Handler: TFlashPlayerControlOnGlobalLoadExternalResource);
procedure SetGlobalOnLoadExternalResourceHandlerEx(Handler: TFlashPlayerControlOnGlobalLoadExternalResourceEx);
procedure SetGlobalOnLoadExternalResourceHandlerAsync(Handler: TFlashPlayerControlOnGlobalLoadExternalResourceAsync);
procedure SetGlobalPreProcessURLHandler(Handler: TFlashPlayerControlOnGlobalPreProcessURL);
function IsFlashInstalled: Boolean;
function IsFormTransparentAvailable: Boolean;
procedure SetAudioVolume(Volume: Integer); // 0 <= Volume <= 100
function GetAudioVolume: Integer;
procedure SetGlobalOnSyncCallHandler(Handler: TFlashPlayerControlOnGlobalSyncCall);

procedure SetAudioOutputOpenHandler(Handler: TFlashPlayerControlOnAudioOutputOpen);
procedure SetAudioOutputWriteHandler(Handler: TFlashPlayerControlOnAudioOutputWrite);
procedure SetAudioOutputCloseHandler(Handler: TFlashPlayerControlOnAudioOutputClose);

function FPC_HookFunc(DLLName: AnsiString; ProcName: AnsiString; AddressOfNewFunction: Pointer): boolean;



procedure SetContext(const context: AnsiString);



implementation

{$IFDEF DEF_DELPHI5}
{$DEFINE DEF_BIG_STREAM_NOT_SUPPORTED}
{$ENDIF}
{$IFDEF DEF_DELPHI4}
{$DEFINE DEF_BIG_STREAM_NOT_SUPPORTED}
{$ENDIF}
{$IFDEF DEF_DELPHI3}
{$DEFINE DEF_BIG_STREAM_NOT_SUPPORTED}
{$ENDIF}

const

  DEF_LOAD_FROM_MEMORY_MAGIC_STRING = '46A10F369771449587DE913EFC0A258C';
  DEF_LOAD_FROM_MEMORY_MOVIE_FILE_NAME = 'E4ED7C01D28A43418DBF2CB92CC35E56.swf';
  DEF_LOAD_FROM_MEMORY_NOTHING = 'file://46A10F369771449587DE913EFC0A258';

  CLASS_ShockwaveFlash: TGUID = '{D27CDB6E-AE6D-11CF-96B8-444553540000}';

  // Some errors...
  SCannotActivate = 'OLE control activation failed';
  SNoWindowHandle = 'Could not obtain OLE control window handle';

  DEF_DEFAULT_FlashPlayerControl_WIDTH = 100;
  DEF_DEFAULT_FlashPlayerControl_HEIGHT = 100;

  DEF_DEFAULT_TransparentFlashPlayerControl_WIDTH = 100;
  DEF_DEFAULT_TransparentFlashPlayerControl_HEIGHT = 100;

  OCM_BASE = $2000;

  MaxDispArgs = 32;

  VIEWSTATUS_OPAQUE               = 1;
  VIEWSTATUS_SOLIDBKGND           = 2;
  VIEWSTATUS_DVASPECTOPAQUE       = 4;
  VIEWSTATUS_DVASPECTTRANSPARENT  = 8;
  VIEWSTATUS_SURFACE              = 16;
  VIEWSTATUS_3DSURFACE            = 32;

  HITRESULT_OUTSIDE       = 0;
  HITRESULT_TRANSPARENT   = 1;
  HITRESULT_CLOSE         = 2;
  HITRESULT_HIT           = 3;

  DVASPECT_OPAQUE         = 16;
  DVASPECT_TRANSPARENT    = 32;

  DVEXTENT_CONTENT = 0;
  DVEXTENT_INTEGRAL = 1;

  DVASPECTINFOFLAG_CANOPTIMIZE = 1;

  OLEDC_NODRAW = 1;
  OLEDC_PAINTBKGND = 2;
  OLEDC_OFFSCREEN = 4;

  ACTIVATE_WINDOWLESS	= 1;

  HIMETRIC_PER_INCH = 254;

  VK_APPS = $5D;

  MK_S_ASYNCHRONOUS = $000401E8;

  MMSYSESERR_NOERROR = 0;

type
  PPointer = ^Pointer;

  LPCTSTR = PAnsiChar;

  IShockwaveFlash7 = interface;
  _IShockwaveFlashEvents = dispinterface;

  ShockwaveFlash = IShockwaveFlash7;

  TDllGetClassObjectFunction =
    function (const CLSID: TCLSID; const IID: TIID; var Obj): HResult; stdcall;

  CompAsTwoLongs = record
    LoL, HiL : LongInt;
  end;

//============================================================================
// Interface IShockwaveFlash3

  // v3
  IShockwaveFlash3 = interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function Get_ReadyState: Integer; safecall;
    function Get_TotalFrames: Integer; safecall;
    function Get_Playing: WordBool; safecall;
    procedure Set_Playing(Playing: WordBool); safecall;
    function Get_Quality: SYSINT; safecall;
    procedure Set_Quality(Quality: SYSINT); safecall;
    function Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(scale: SYSINT); safecall;
    function Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(align: SYSINT); safecall;
    function Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(color: Integer); safecall;
    function Get_Loop: WordBool; safecall;
    procedure Set_Loop(Loop: WordBool); safecall;
    function Get_Movie: WideString; safecall;
    procedure Set_Movie(const path: WideString); safecall;
    function Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(FrameNum: Integer); safecall;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(FrameNum: Integer); safecall;
    function CurrentFrame: Integer; safecall;
    function IsPlaying: WordBool; safecall;
    function PercentLoaded: Integer; safecall;
    function FrameLoaded(FrameNum: Integer): WordBool; safecall;
    function FlashVersion: Integer; safecall;
    function Get_WMode: WideString; safecall;
    procedure Set_WMode(const pVal: WideString); safecall;
    function Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const pVal: WideString); safecall;
    function Get_Menu: WordBool; safecall;
    procedure Set_Menu(pVal: WordBool); safecall;
    function Get_Base: WideString; safecall;
    procedure Set_Base(const pVal: WideString); safecall;
    function Get_scale: WideString; safecall;
    procedure Set_scale(const pVal: WideString); safecall;
    function Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(pVal: WordBool); safecall;
    function Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(pVal: WordBool); safecall;
    function Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const pVal: WideString); safecall;
    function Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const pVal: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); safecall;
    procedure TGotoLabel(const target: WideString; const label_: WideString); safecall;
    function TCurrentFrame(const target: WideString): Integer; safecall;
    function TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    property ReadyState: Integer read Get_ReadyState;
    property TotalFrames: Integer read Get_TotalFrames;
    property Playing: WordBool read Get_Playing write Set_Playing;
    property Quality: SYSINT read Get_Quality write Set_Quality;
    property ScaleMode: SYSINT read Get_ScaleMode write Set_ScaleMode;
    property AlignMode: SYSINT read Get_AlignMode write Set_AlignMode;
    property BackgroundColor: Integer read Get_BackgroundColor write Set_BackgroundColor;
    property Loop: WordBool read Get_Loop write Set_Loop;
    property Movie: WideString read Get_Movie write Set_Movie;
    property FrameNum: Integer read Get_FrameNum write Set_FrameNum;
    property WMode: WideString read Get_WMode write Set_WMode;
    property SAlign: WideString read Get_SAlign write Set_SAlign;
    property Menu: WordBool read Get_Menu write Set_Menu;
    property Base: WideString read Get_Base write Set_Base;
    property scale: WideString read Get_scale write Set_scale;
    property DeviceFont: WordBool read Get_DeviceFont write Set_DeviceFont;
    property EmbedMovie: WordBool read Get_EmbedMovie write Set_EmbedMovie;
    property BGColor: WideString read Get_BGColor write Set_BGColor;
    property Quality2: WideString read Get_Quality2 write Set_Quality2;
  end;

//============================================================================

//============================================================================
// Interface IShockwaveFlash4

  // v4
  IShockwaveFlash4 = interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function Get_ReadyState: Integer; safecall;
    function Get_TotalFrames: Integer; safecall;
    function Get_Playing: WordBool; safecall;
    procedure Set_Playing(Playing: WordBool); safecall;
    function Get_Quality: SYSINT; safecall;
    procedure Set_Quality(Quality: SYSINT); safecall;
    function Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(scale: SYSINT); safecall;
    function Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(align: SYSINT); safecall;
    function Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(color: Integer); safecall;
    function Get_Loop: WordBool; safecall;
    procedure Set_Loop(Loop: WordBool); safecall;
    function Get_Movie: WideString; safecall;
    procedure Set_Movie(const path: WideString); safecall;
    function Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(FrameNum: Integer); safecall;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(FrameNum: Integer); safecall;
    function CurrentFrame: Integer; safecall;
    function IsPlaying: WordBool; safecall;
    function PercentLoaded: Integer; safecall;
    function FrameLoaded(FrameNum: Integer): WordBool; safecall;
    function FlashVersion: Integer; safecall;
    function Get_WMode: WideString; safecall;
    procedure Set_WMode(const pVal: WideString); safecall;
    function Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const pVal: WideString); safecall;
    function Get_Menu: WordBool; safecall;
    procedure Set_Menu(pVal: WordBool); safecall;
    function Get_Base: WideString; safecall;
    procedure Set_Base(const pVal: WideString); safecall;
    function Get_scale: WideString; safecall;
    procedure Set_scale(const pVal: WideString); safecall;
    function Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(pVal: WordBool); safecall;
    function Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(pVal: WordBool); safecall;
    function Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const pVal: WideString); safecall;
    function Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const pVal: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); safecall;
    procedure TGotoLabel(const target: WideString; const label_: WideString); safecall;
    function TCurrentFrame(const target: WideString): Integer; safecall;
    function TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    procedure SetVariable(const name: WideString; const value: WideString); safecall;
    function GetVariable(const name: WideString): WideString; safecall;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); safecall;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; safecall;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); safecall;
    procedure TCallLabel(const target: WideString; const label_: WideString); safecall;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); safecall;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; safecall;
    function Get_SWRemote: WideString; safecall;
    procedure Set_SWRemote(const pVal: WideString); safecall;
    property ReadyState: Integer read Get_ReadyState;
    property TotalFrames: Integer read Get_TotalFrames;
    property Playing: WordBool read Get_Playing write Set_Playing;
    property Quality: SYSINT read Get_Quality write Set_Quality;
    property ScaleMode: SYSINT read Get_ScaleMode write Set_ScaleMode;
    property AlignMode: SYSINT read Get_AlignMode write Set_AlignMode;
    property BackgroundColor: Integer read Get_BackgroundColor write Set_BackgroundColor;
    property Loop: WordBool read Get_Loop write Set_Loop;
    property Movie: WideString read Get_Movie write Set_Movie;
    property FrameNum: Integer read Get_FrameNum write Set_FrameNum;
    property WMode: WideString read Get_WMode write Set_WMode;
    property SAlign: WideString read Get_SAlign write Set_SAlign;
    property Menu: WordBool read Get_Menu write Set_Menu;
    property Base: WideString read Get_Base write Set_Base;
    property scale: WideString read Get_scale write Set_scale;
    property DeviceFont: WordBool read Get_DeviceFont write Set_DeviceFont;
    property EmbedMovie: WordBool read Get_EmbedMovie write Set_EmbedMovie;
    property BGColor: WideString read Get_BGColor write Set_BGColor;
    property Quality2: WideString read Get_Quality2 write Set_Quality2;
    property SWRemote: WideString read Get_SWRemote write Set_SWRemote;
  end;

//============================================================================

//============================================================================
// Interface IShockwaveFlash5

  // v5
  IShockwaveFlash5 = interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function Get_ReadyState: Integer; safecall;
    function Get_TotalFrames: Integer; safecall;
    function Get_Playing: WordBool; safecall;
    procedure Set_Playing(Playing: WordBool); safecall;
    function Get_Quality: SYSINT; safecall;
    procedure Set_Quality(Quality: SYSINT); safecall;
    function Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(scale: SYSINT); safecall;
    function Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(align: SYSINT); safecall;
    function Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(color: Integer); safecall;
    function Get_Loop: WordBool; safecall;
    procedure Set_Loop(Loop: WordBool); safecall;
    function Get_Movie: WideString; safecall;
    procedure Set_Movie(const path: WideString); safecall;
    function Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(FrameNum: Integer); safecall;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(FrameNum: Integer); safecall;
    function CurrentFrame: Integer; safecall;
    function IsPlaying: WordBool; safecall;
    function PercentLoaded: Integer; safecall;
    function FrameLoaded(FrameNum: Integer): WordBool; safecall;
    function FlashVersion: Integer; safecall;
    function Get_WMode: WideString; safecall;
    procedure Set_WMode(const pVal: WideString); safecall;
    function Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const pVal: WideString); safecall;
    function Get_Menu: WordBool; safecall;
    procedure Set_Menu(pVal: WordBool); safecall;
    function Get_Base: WideString; safecall;
    procedure Set_Base(const pVal: WideString); safecall;
    function Get_scale: WideString; safecall;
    procedure Set_scale(const pVal: WideString); safecall;
    function Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(pVal: WordBool); safecall;
    function Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(pVal: WordBool); safecall;
    function Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const pVal: WideString); safecall;
    function Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const pVal: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); safecall;
    procedure TGotoLabel(const target: WideString; const label_: WideString); safecall;
    function TCurrentFrame(const target: WideString): Integer; safecall;
    function TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    procedure SetVariable(const name: WideString; const value: WideString); safecall;
    function GetVariable(const name: WideString): WideString; safecall;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); safecall;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; safecall;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); safecall;
    procedure TCallLabel(const target: WideString; const label_: WideString); safecall;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); safecall;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; safecall;
    function Get_SWRemote: WideString; safecall;
    procedure Set_SWRemote(const pVal: WideString); safecall;
    function Get_Stacking: WideString; safecall;
    procedure Set_Stacking(const pVal: WideString); safecall;
    property ReadyState: Integer read Get_ReadyState;
    property TotalFrames: Integer read Get_TotalFrames;
    property Playing: WordBool read Get_Playing write Set_Playing;
    property Quality: SYSINT read Get_Quality write Set_Quality;
    property ScaleMode: SYSINT read Get_ScaleMode write Set_ScaleMode;
    property AlignMode: SYSINT read Get_AlignMode write Set_AlignMode;
    property BackgroundColor: Integer read Get_BackgroundColor write Set_BackgroundColor;
    property Loop: WordBool read Get_Loop write Set_Loop;
    property Movie: WideString read Get_Movie write Set_Movie;
    property FrameNum: Integer read Get_FrameNum write Set_FrameNum;
    property WMode: WideString read Get_WMode write Set_WMode;
    property SAlign: WideString read Get_SAlign write Set_SAlign;
    property Menu: WordBool read Get_Menu write Set_Menu;
    property Base: WideString read Get_Base write Set_Base;
    property scale: WideString read Get_scale write Set_scale;
    property DeviceFont: WordBool read Get_DeviceFont write Set_DeviceFont;
    property EmbedMovie: WordBool read Get_EmbedMovie write Set_EmbedMovie;
    property BGColor: WideString read Get_BGColor write Set_BGColor;
    property Quality2: WideString read Get_Quality2 write Set_Quality2;
    property SWRemote: WideString read Get_SWRemote write Set_SWRemote;
    property Stacking: WideString read Get_Stacking write Set_Stacking;
  end;

//============================================================================

//============================================================================
// Interface IShockwaveFlash6

  // v6
  IShockwaveFlash6 = interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function Get_ReadyState: Integer; safecall;
    function Get_TotalFrames: Integer; safecall;
    function Get_Playing: WordBool; safecall;
    procedure Set_Playing(pVal: WordBool); safecall;
    function Get_Quality: SYSINT; safecall;
    procedure Set_Quality(pVal: SYSINT); safecall;
    function Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(pVal: SYSINT); safecall;
    function Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(pVal: SYSINT); safecall;
    function Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(pVal: Integer); safecall;
    function Get_Loop: WordBool; safecall;
    procedure Set_Loop(pVal: WordBool); safecall;
    function Get_Movie: WideString; safecall;
    procedure Set_Movie(const pVal: WideString); safecall;
    function Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(pVal: Integer); safecall;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(FrameNum: Integer); safecall;
    function CurrentFrame: Integer; safecall;
    function IsPlaying: WordBool; safecall;
    function PercentLoaded: Integer; safecall;
    function FrameLoaded(FrameNum: Integer): WordBool; safecall;
    function FlashVersion: Integer; safecall;
    function Get_WMode: WideString; safecall;
    procedure Set_WMode(const pVal: WideString); safecall;
    function Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const pVal: WideString); safecall;
    function Get_Menu: WordBool; safecall;
    procedure Set_Menu(pVal: WordBool); safecall;
    function Get_Base: WideString; safecall;
    procedure Set_Base(const pVal: WideString); safecall;
    function Get_Scale: WideString; safecall;
    procedure Set_Scale(const pVal: WideString); safecall;
    function Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(pVal: WordBool); safecall;
    function Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(pVal: WordBool); safecall;
    function Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const pVal: WideString); safecall;
    function Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const pVal: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); safecall;
    procedure TGotoLabel(const target: WideString; const label_: WideString); safecall;
    function TCurrentFrame(const target: WideString): Integer; safecall;
    function TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    procedure SetVariable(const name: WideString; const value: WideString); safecall;
    function GetVariable(const name: WideString): WideString; safecall;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); safecall;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; safecall;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); safecall;
    procedure TCallLabel(const target: WideString; const label_: WideString); safecall;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); safecall;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; safecall;
{
    function Get_SWRemote: WideString; safecall;
    procedure Set_SWRemote(const pVal: WideString); safecall;
    function Get_FlashVars: WideString; safecall;
    procedure Set_FlashVars(const pVal: WideString); safecall;
}
    property ReadyState: Integer read Get_ReadyState;
    property TotalFrames: Integer read Get_TotalFrames;
    property Playing: WordBool read Get_Playing write Set_Playing;
    property Quality: SYSINT read Get_Quality write Set_Quality;
    property ScaleMode: SYSINT read Get_ScaleMode write Set_ScaleMode;
    property AlignMode: SYSINT read Get_AlignMode write Set_AlignMode;
    property BackgroundColor: Integer read Get_BackgroundColor write Set_BackgroundColor;
    property Loop: WordBool read Get_Loop write Set_Loop;
    property Movie: WideString read Get_Movie write Set_Movie;
    property FrameNum: Integer read Get_FrameNum write Set_FrameNum;
    property WMode: WideString read Get_WMode write Set_WMode;
    property SAlign: WideString read Get_SAlign write Set_SAlign;
    property Menu: WordBool read Get_Menu write Set_Menu;
    property Base: WideString read Get_Base write Set_Base;
    property Scale: WideString read Get_Scale write Set_Scale;
    property DeviceFont: WordBool read Get_DeviceFont write Set_DeviceFont;
    property EmbedMovie: WordBool read Get_EmbedMovie write Set_EmbedMovie;
    property BGColor: WideString read Get_BGColor write Set_BGColor;
    property Quality2: WideString read Get_Quality2 write Set_Quality2;
{
    property SWRemote: WideString read Get_SWRemote write Set_SWRemote;
    property FlashVars: WideString read Get_FlashVars write Set_FlashVars;
}
  end;

//============================================================================

//============================================================================
// Interface IShockwaveFlash7

  // v7
  IShockwaveFlash7 = interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function Get_ReadyState: Integer; safecall;
    function Get_TotalFrames: Integer; safecall;
    function Get_Playing: WordBool; safecall;
    procedure Set_Playing(pVal: WordBool); safecall;
    function Get_Quality: SYSINT; safecall;
    procedure Set_Quality(pVal: SYSINT); safecall;
    function Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(pVal: SYSINT); safecall;
    function Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(pVal: SYSINT); safecall;
    function Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(pVal: Integer); safecall;
    function Get_Loop: WordBool; safecall;
    procedure Set_Loop(pVal: WordBool); safecall;
    function Get_Movie: WideString; safecall;
    procedure Set_Movie(const pVal: WideString); safecall;
    function Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(pVal: Integer); safecall;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(FrameNum: Integer); safecall;
    function CurrentFrame: Integer; safecall;
    function IsPlaying: WordBool; safecall;
    function PercentLoaded: Integer; safecall;
    function FrameLoaded(FrameNum: Integer): WordBool; safecall;
    function FlashVersion: Integer; safecall;
    function Get_WMode: WideString; safecall;
    procedure Set_WMode(const pVal: WideString); safecall;
    function Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const pVal: WideString); safecall;
    function Get_Menu: WordBool; safecall;
    procedure Set_Menu(pVal: WordBool); safecall;
    function Get_Base: WideString; safecall;
    procedure Set_Base(const pVal: WideString); safecall;
    function Get_Scale: WideString; safecall;
    procedure Set_Scale(const pVal: WideString); safecall;
    function Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(pVal: WordBool); safecall;
    function Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(pVal: WordBool); safecall;
    function Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const pVal: WideString); safecall;
    function Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const pVal: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); safecall;
    procedure TGotoLabel(const target: WideString; const label_: WideString); safecall;
    function TCurrentFrame(const target: WideString): Integer; safecall;
    function TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    procedure SetVariable(const name: WideString; const value: WideString); safecall;
    function GetVariable(const name: WideString): WideString; safecall;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); safecall;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; safecall;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); safecall;
    procedure TCallLabel(const target: WideString; const label_: WideString); safecall;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); safecall;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; safecall;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; safecall;
    function Get_SWRemote: WideString; safecall;
    procedure Set_SWRemote(const pVal: WideString); safecall;
    function Get_FlashVars: WideString; safecall;
    procedure Set_FlashVars(const pVal: WideString); safecall;
    function Get_AllowScriptAccess: WideString; safecall;
    procedure Set_AllowScriptAccess(const pVal: WideString); safecall;
    function Get_MovieData: WideString; safecall;
    procedure Set_MovieData(const pVal: WideString); safecall;
    property ReadyState: Integer read Get_ReadyState;
    property TotalFrames: Integer read Get_TotalFrames;
    property Playing: WordBool read Get_Playing write Set_Playing;
    property Quality: SYSINT read Get_Quality write Set_Quality;
    property ScaleMode: SYSINT read Get_ScaleMode write Set_ScaleMode;
    property AlignMode: SYSINT read Get_AlignMode write Set_AlignMode;
    property BackgroundColor: Integer read Get_BackgroundColor write Set_BackgroundColor;
    property Loop: WordBool read Get_Loop write Set_Loop;
    property Movie: WideString read Get_Movie write Set_Movie;
    property FrameNum: Integer read Get_FrameNum write Set_FrameNum;
    property WMode: WideString read Get_WMode write Set_WMode;
    property SAlign: WideString read Get_SAlign write Set_SAlign;
    property Menu: WordBool read Get_Menu write Set_Menu;
    property Base: WideString read Get_Base write Set_Base;
    property Scale: WideString read Get_Scale write Set_Scale;
    property DeviceFont: WordBool read Get_DeviceFont write Set_DeviceFont;
    property EmbedMovie: WordBool read Get_EmbedMovie write Set_EmbedMovie;
    property BGColor: WideString read Get_BGColor write Set_BGColor;
    property Quality2: WideString read Get_Quality2 write Set_Quality2;
    property SWRemote: WideString read Get_SWRemote write Set_SWRemote;
    property FlashVars: WideString read Get_FlashVars write Set_FlashVars;
    property AllowScriptAccess: WideString read Get_AllowScriptAccess write Set_AllowScriptAccess;
    property MovieData: WideString read Get_MovieData write Set_MovieData;
  end;

//============================================================================

//============================================================================
// Interface IShockwaveFlash8

  // v8
  IShockwaveFlash8 = interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function Get_ReadyState: Integer; safecall;
    function Get_TotalFrames: Integer; safecall;
    function Get_Playing: WordBool; safecall;
    procedure Set_Playing(Value: WordBool); safecall;
    function Get_Quality: SYSINT; safecall;
    procedure Set_Quality(Value: SYSINT); safecall;
    function Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(Value: SYSINT); safecall;
    function Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(Value: SYSINT); safecall;
    function Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(Value: Integer); safecall;
    function Get_Loop: WordBool; safecall;
    procedure Set_Loop(Value: WordBool); safecall;
    function Get_Movie: WideString; safecall;
    procedure Set_Movie(const Value: WideString); safecall;
    function Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(Value: Integer); safecall;
    procedure SetZoomRect(left, top, right, bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x, y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(FrameNum: Integer); safecall;
    function CurrentFrame: Integer; safecall;
    function IsPlaying: WordBool; safecall;
    function PercentLoaded: Integer; safecall;
    function FrameLoaded(FrameNum: Integer): WordBool; safecall;
    function FlashVersion: Integer; safecall;
    function Get_WMode: WideString; safecall;
    procedure Set_WMode(const Value: WideString); safecall;
    function Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const Value: WideString); safecall;
    function Get_Menu: WordBool; safecall;
    procedure Set_Menu(Value: WordBool); safecall;
    function Get_Base: WideString; safecall;
    procedure Set_Base(const Value: WideString); safecall;
    function Get_Scale: WideString; safecall;
    procedure Set_Scale(const Value: WideString); safecall;
    function Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(Value: WordBool); safecall;
    function Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(Value: WordBool); safecall;
    function Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const Value: WideString); safecall;
    function Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const Value: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); safecall;
    procedure TGotoLabel(const target, label_: WideString); safecall;
    function TCurrentFrame(const target: WideString): Integer; safecall;
    function TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    procedure SetVariable(const name, value: WideString); safecall;
    function GetVariable(const name: WideString): WideString; safecall;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); safecall;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; safecall;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); safecall;
    procedure TCallLabel(const target, label_: WideString); safecall;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); safecall;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; safecall;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; safecall;
    function Get_SWRemote: WideString; safecall;
    procedure Set_SWRemote(const Value: WideString); safecall;
    function Get_FlashVars: WideString; safecall;
    procedure Set_FlashVars(const Value: WideString); safecall;
    function Get_AllowScriptAccess: WideString; safecall;
    procedure Set_AllowScriptAccess(const Value: WideString); safecall;
    function Get_MovieData: WideString; safecall;
    procedure Set_MovieData(const Value: WideString); safecall;
    function Get_InlineData: IUnknown; safecall;
    procedure Set_InlineData(Value: IUnknown); safecall;
    function Get_SeamlessTabbing: WordBool; safecall;
    procedure Set_SeamlessTabbing(Value: WordBool); safecall;
    procedure EnforceLocalSecurity; safecall;
    function Get_Profile: WordBool; safecall;
    procedure Set_Profile(Value: WordBool); safecall;
    function Get_ProfileAddress: WideString; safecall;
    procedure Set_ProfileAddress(const Value: WideString); safecall;
    function Get_ProfilePort: Integer; safecall;
    procedure Set_ProfilePort(Value: Integer); safecall;
    function CallFunction(const request: WideString): WideString; safecall;
    procedure SetReturnValue(const returnValue: WideString); safecall;
    procedure DisableLocalSecurity; safecall;
  end;

//============================================================================


//============================================================================
// Interface IShockwaveFlash_9_0_28_0

  // v9.0.28.0
  IShockwaveFlash_9_0_28_0= interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function Get_ReadyState: Integer; safecall;
    function Get_TotalFrames: Integer; safecall;
    function Get_Playing: WordBool; safecall;
    procedure Set_Playing(pVal: WordBool); safecall;
    function Get_Quality: SYSINT; safecall;
    procedure Set_Quality(pVal: SYSINT); safecall;
    function Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(pVal: SYSINT); safecall;
    function Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(pVal: SYSINT); safecall;
    function Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(pVal: Integer); safecall;
    function Get_Loop: WordBool; safecall;
    procedure Set_Loop(pVal: WordBool); safecall;
    function Get_Movie: WideString; safecall;
    procedure Set_Movie(const pVal: WideString); safecall;
    function Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(pVal: Integer); safecall;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(FrameNum: Integer); safecall;
    function CurrentFrame: Integer; safecall;
    function IsPlaying: WordBool; safecall;
    function PercentLoaded: Integer; safecall;
    function FrameLoaded(FrameNum: Integer): WordBool; safecall;
    function FlashVersion: Integer; safecall;
    function Get_WMode: WideString; safecall;
    procedure Set_WMode(const pVal: WideString); safecall;
    function Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const pVal: WideString); safecall;
    function Get_Menu: WordBool; safecall;
    procedure Set_Menu(pVal: WordBool); safecall;
    function Get_Base: WideString; safecall;
    procedure Set_Base(const pVal: WideString); safecall;
    function Get_Scale: WideString; safecall;
    procedure Set_Scale(const pVal: WideString); safecall;
    function Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(pVal: WordBool); safecall;
    function Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(pVal: WordBool); safecall;
    function Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const pVal: WideString); safecall;
    function Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const pVal: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); safecall;
    procedure TGotoLabel(const target: WideString; const label_: WideString); safecall;
    function TCurrentFrame(const target: WideString): Integer; safecall;
    function TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    procedure SetVariable(const name: WideString; const value: WideString); safecall;
    function GetVariable(const name: WideString): WideString; safecall;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); safecall;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; safecall;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); safecall;
    procedure TCallLabel(const target: WideString; const label_: WideString); safecall;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); safecall;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; safecall;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; safecall;
    function Get_SWRemote: WideString; safecall;
    procedure Set_SWRemote(const pVal: WideString); safecall;
    function Get_FlashVars: WideString; safecall;
    procedure Set_FlashVars(const pVal: WideString); safecall;
    function Get_AllowScriptAccess: WideString; safecall;
    procedure Set_AllowScriptAccess(const pVal: WideString); safecall;
    function Get_MovieData: WideString; safecall;
    procedure Set_MovieData(const pVal: WideString); safecall;
    function Get_InlineData: IUnknown; safecall;
    procedure Set_InlineData(const ppIUnknown: IUnknown); safecall;
    function Get_SeamlessTabbing: WordBool; safecall;
    procedure Set_SeamlessTabbing(pVal: WordBool); safecall;
    procedure EnforceLocalSecurity; safecall;
    function Get_Profile: WordBool; safecall;
    procedure Set_Profile(pVal: WordBool); safecall;
    function Get_ProfileAddress: WideString; safecall;
    procedure Set_ProfileAddress(const pVal: WideString); safecall;
    function Get_ProfilePort: Integer; safecall;
    procedure Set_ProfilePort(pVal: Integer); safecall;
    function CallFunction(const request: WideString): WideString; safecall;
    procedure SetReturnValue(const returnValue: WideString); safecall;
    procedure DisableLocalSecurity; safecall;
    function Get_AllowNetworking: WideString; safecall;
    procedure Set_AllowNetworking(const pVal: WideString); safecall;
    function Get_AllowFullScreen: WideString; safecall;
    procedure Set_AllowFullScreen(const pVal: WideString); safecall;
  end;

//============================================================================

//============================================================================
// Dispinterface _IShockwaveFlashEvents

  _IShockwaveFlashEvents = dispinterface
    ['{D27CDB6D-AE6D-11CF-96B8-444553540000}']
    procedure OnReadyStateChange(newState: Integer); dispid -609;
    procedure OnProgress(percentDone: Integer); dispid 1958;
    procedure FSCommand(const command: WideString; const args: WideString); dispid 150;
    procedure FlashCall(const request: WideString); dispid $c5;
  end;

//============================================================================

//============================================================================
// TImportedFunctions

TImportedFunction = class
private
   FDLLName: AnsiString;
   FProcName: AnsiString;
   FAddressOfAddress: Pointer;
public
  constructor Create(DLLName: AnsiString; ProcName: AnsiString; AddressOfAddress: Pointer);

  function IsEqual(DLLName: AnsiString; ProcName: AnsiString): boolean;
  function GetAddress: Pointer;
end;

TImportedFunctions = class
private
   FList: TList;
public
  constructor Create;
  destructor Destroy; override;

  procedure Add(DLLName: AnsiString; ProcName: AnsiString; AddressOfAddress: Pointer);
  function SetNewAddress(DLLName: AnsiString; ProcName: AnsiString; NewAddress: Pointer): boolean;
end;

//============================================================================

//============================================================================
TStreamBasedOnIStream = class(TStream)
private
    FStream: IStream;
protected
    procedure SetSize(NewSize: Longint); override;

{$IFNDEF DEF_DELPHI3}
{$IFNDEF DEF_DELPHI4}
{$IFNDEF DEF_DELPHI5}
    procedure SetSize(const NewSize: Int64); override;
{$ENDIF}
{$ENDIF}
{$ENDIF}

public
    constructor Create(const Stream: IStream);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
end;
//============================================================================

//============================================================================
// TDLLLoader
// Loading a dll into memory
TDLLLoader = class
private
  // Module handle
  hModule: HMODULE;
  // List of loaded modules
  ListOfLoadedModules: TList;
  // List of imported functions
  ImportedFunctions: TImportedFunctions;
protected
  // OnGetImportedProcAddress allows to replace addresses of imported functions of dll
  function OnGetImportedProcAddress(lpszDLLName: LPCTSTR; lpszProcName: LPCTSTR): pointer; virtual;
public
  constructor Create;
  destructor Destroy; override;

  procedure Load(Stream: TStream);

  // GetProcAddress
  function GetProcAddress(lpProcName: LPCSTR): FARPROC;

  //
  function HookFunc(DLLName: AnsiString; ProcName: AnsiString; AddressOfNewFunction: Pointer): boolean;
end;

//============================================================================

//============================================================================
// TFlashOCXLoader

TFlashOCXLoader = class (TDLLLoader)
  function OnGetImportedProcAddress(lpszDLLName: LPCTSTR; lpszProcName: LPCTSTR): pointer; override;
end;

//============================================================================

//============================================================================
// TMapString2String

TStringPair = class
  String1: WideString;
  String2: WideString;

  constructor Create(TheString1: WideString; TheString2: WideString);
end;

TMapString2String = class
private
  FListOfStringPairs: TList;
public
  constructor Create;
  destructor Destroy; override;

  procedure Add(String1: WideString; String2: WideString);
  function Find(String1: WideString; var String2: WideString): boolean;
end;

//============================================================================

//============================================================================
// TMapCardinal2Cardinal

TCardinalPair = class
  Cardinal1: Cardinal;
  Cardinal2: Cardinal;

  constructor Create(TheCardinal1: Cardinal; TheCardinal2: Cardinal);
end;

TMapCardinal2Cardinal = class
private
  FListOfCardinalPair: TList;
public
  constructor Create;
  destructor Destroy; override;

  procedure Add(Cardinal1: Cardinal; Cardinal2: Cardinal);
  function Find(Cardinal1: Cardinal; var Cardinal2: Cardinal): boolean;
end;

//============================================================================

//============================================================================
// TSavedCursor, TSavedCursors

TSavedCursor = class
private
   hCur: HCURSOR;
   hInstance: HINST;
   bString: boolean;
   nResId: WORD;
   strResName: AnsiString;
public
   constructor Create(c: HCURSOR; h: HINST; lpCursorName: PAnsiChar);

   function Compare(h: HINST; lpCursorName: PAnsiChar): boolean;
end;

TSavedCursors = class
private
   FSavedCursors: TList;
   m_cs: TRTLCriticalSection;
public
   constructor Create;
   destructor Destroy; override;

   procedure SaveCursor(c: HCURSOR; h: HINST; lpCursorName: PAnsiChar);
   function FindCursor(h: HINST; lpCursorName: PAnsiChar): HCURSOR;
end;

//============================================================================

//============================================================================
// IBinding

  IBinding = interface
    ['{79eac9c0-baf9-11ce-8c82-00aa004ba90b}']
    function Abort: HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;
    function SetPriority(nPriority: Longint): HResult; stdcall;
    function GetPriority(out nPriority: Longint): HResult; stdcall;
    function GetBindResult(out clsidProtocol: TCLSID; out dwResult: DWORD;
      out szResult: POLEStr; dwReserved: DWORD): HResult; stdcall;
  end;

//============================================================================

//============================================================================
// IBindStatusCallback

  PBindInfo = ^TBindInfo;

  _tagBINDINFO = packed record
    cbSize: ULONG;
    szExtraInfo: LPWSTR;
    stgmedData: TStgMedium;
    grfBindInfoF: DWORD;
    dwBindVerb: DWORD;
    szCustomVerb: LPWSTR;
    cbstgmedData: DWORD;
    dwOptions: DWORD;
    dwOptionsFlags: DWORD;
    dwCodePage: DWORD;
    securityAttributes: TSecurityAttributes;
    iid: TGUID;
    pUnk: IUnknown;
    dwReserved: DWORD;
  end;
  TBindInfo = _tagBINDINFO;

  BINDINFO = _tagBINDINFO;

  IBindStatusCallback = interface
    ['{79eac9c1-baf9-11ce-8c82-00aa004ba90b}']
    function OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult; stdcall;
    function GetPriority(out nPriority): HResult; stdcall;
    function OnLowResource(reserved: DWORD): HResult; stdcall;
    function OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG;
      szStatusText: LPCWSTR): HResult; stdcall;
    function OnStopBinding(hresult: HResult; szError: LPCWSTR): HResult; stdcall;
    function GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
    function OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc;
      stgmed: PStgMedium): HResult; stdcall;
    function OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;
  end;

//============================================================================
// IHttpNegotiate

  IHttpNegotiate = interface
    ['{79eac9d2-baf9-11ce-8c82-00aa004ba90b}']
    function BeginningTransaction(szURL, szHeaders: LPCWSTR; dwReserved: DWORD;
      out szAdditionalHeaders: LPWSTR): HResult; stdcall;
    function OnResponse(dwResponseCode: DWORD; szResponseHeaders, szRequestHeaders: LPCWSTR;
      out szAdditionalRequestHeaders: LPWSTR): HResult; stdcall;
  end;

//============================================================================

  TCreateURLMoniker =
    function(MkCtx: IMoniker; szURL: LPCWSTR; out mk: IMoniker): HResult; stdcall;
  TRegisterBindStatusCallback =
    function(pBC: IBindCtx; pBSCb: IBindStatusCallback; out ppBSCBPrev: IBindStatusCallback; dwReserved: DWORD): HResult; stdcall;

//============================================================================
// TMyBindStatusCallback

TMyBindStatusCallback = class(TObject, IUnknown, IBindStatusCallback)
public
  FRefCount: integer;
  m_pOldBindStatusCallback: IBindStatusCallback;

  WrittenBytes: integer;
  TotalBytes: integer;
protected
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    {IBindStatusCallback}
    function OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult; stdcall;

    function IBindStatusCallback.GetPriority = IBindStatusCallback_GetPriority;
    function IBindStatusCallback_GetPriority(out nPriority): HResult; stdcall;

    function OnLowResource(reserved: DWORD): HResult; stdcall;
    function OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG;
      szStatusText: LPCWSTR): HResult; stdcall;
    function OnStopBinding(hresult: HResult; szError: LPCWSTR): HResult; stdcall;
    function GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
    function OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc;
      stgmed: PStgMedium): HResult; stdcall;
    function OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;

public
    constructor Create;
    destructor Destroy; override;
end;

//============================================================================

//============================================================================
// TMyMoniker

TMyMoniker = class(TObject, IUnknown, IMoniker, IBinding)
private
  FRefCount: integer;
  URL: WideString;
  m_pmkContext: IMoniker;
  m_pStandardURLMoniker: IMoniker;
protected
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    { IMoniker }
    function BindToObject(const bc: IBindCtx; const mkToLeft: IMoniker;
      const iidResult: TIID; out vResult): HResult; stdcall;
    function BindToStorage(const bc: IBindCtx; const mkToLeft: IMoniker;
      const iid: TIID; out vObj): HResult; stdcall;
    function Reduce(const bc: IBindCtx; dwReduceHowFar: Longint;
      mkToLeft: PIMoniker; out mkReduced: IMoniker): HResult; stdcall;
    function ComposeWith(const mkRight: IMoniker; fOnlyIfNotGeneric: BOOL;
      out mkComposite: IMoniker): HResult; stdcall;
    function Enum(fForward: BOOL; out enumMoniker: IEnumMoniker): HResult;
      stdcall;
    function IsEqual(const mkOtherMoniker: IMoniker): HResult; stdcall;
    function Hash(out dwHash: Longint): HResult; stdcall;
    function IsRunning(const bc: IBindCtx; const mkToLeft: IMoniker;
      const mkNewlyRunning: IMoniker): HResult; stdcall;
    function GetTimeOfLastChange(const bc: IBindCtx; const mkToLeft: IMoniker;
      out filetime: TFileTime): HResult; stdcall;
    function Inverse(out mk: IMoniker): HResult; stdcall;
    function CommonPrefixWith(const mkOther: IMoniker;
      out mkPrefix: IMoniker): HResult; stdcall;
    function RelativePathTo(const mkOther: IMoniker;
      out mkRelPath: IMoniker): HResult; stdcall;
    function GetDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker;
      out pszDisplayName: POleStr): HResult; stdcall;
    function ParseDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker;
      pszDisplayName: POleStr; out chEaten: Longint;
      out mkOut: IMoniker): HResult; stdcall;
    function IsSystemMoniker(out dwMksys: Longint): HResult; stdcall;

    {IPersistStream}
    function IsDirty: HResult; stdcall;
    function Load(const stm: IStream): HResult; stdcall;
    function Save(const stm: IStream; fClearDirty: BOOL): HResult; stdcall;
    function GetSizeMax(out cbSize: Largeint): HResult; stdcall;

    {IPersist}
    function GetClassID(out classID: TCLSID): HResult; stdcall;

    {IBinding}
    function Abort: HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;
    function SetPriority(nPriority: Longint): HResult; stdcall;

    function IBinding.GetPriority = IBinding_GetPriority;
    function IBinding_GetPriority(out nPriority: Longint): HResult; stdcall;

    function GetBindResult(out clsidProtocol: TCLSID; out dwResult: DWORD;
      out szResult: POLEStr; dwReserved: DWORD): HResult; stdcall;

public
    constructor Create(pmkContext: IMoniker; URL: WideString);
    destructor Destroy; override;
end;

//============================================================================

//============================================================================
// TFlashOCXCodeProvider

//TFlashOCXCodeProvider = class
//public
//  function CreateInstance(const iid: TIID; out pv): HResult; virtual; abstract;
//  function GetVersion: DWORD; virtual;
//end;

//============================================================================

//============================================================================
// TFlashOCXCodeProviderBasedOnStream

//TFlashOCXCodeProviderBasedOnStream = class(TFlashOCXCodeProvider)
TFlashOCXCodeProviderBasedOnStream = class
private
  pDllGetClassObjectFunction: TDllGetClassObjectFunction;
  dwFlashVersion: DWORD;
public
  FlashOCXLoader: TFlashOCXLoader;
public
  constructor Create(AStream: TStream);
  destructor Destroy; override;
  function GetVersion: DWORD; // override;
  function CreateInstance(const iid: TIID; out pv): HResult; // override;

  function HookFunc(DLLName: AnsiString; ProcName: AnsiString; AddressOfNewFunction: Pointer): boolean;

  procedure OnTimer(Sender: TObject);
end;

//============================================================================

//============================================================================

TFlashOCXCodeProviderBasedOnSystemInstalledOCX = class(TFlashOCXCodeProviderBasedOnStream)
public
  constructor Create; virtual;
end;

//============================================================================

{$IFDEF DEF_DELPHI3}
{$DEFINE DEF_DELPHI_VERSION_BEFORE_6}
{$DEFINE DEF_DELPHI_VERSION_BEFORE_7}
{$ENDIF}

{$IFDEF DEF_DELPHI4}
{$DEFINE DEF_DELPHI_VERSION_BEFORE_6}
{$DEFINE DEF_DELPHI_VERSION_BEFORE_7}
{$ENDIF}

{$IFDEF DEF_DELPHI5}
{$DEFINE DEF_DELPHI_VERSION_BEFORE_6}
{$DEFINE DEF_DELPHI_VERSION_BEFORE_7}
{$ENDIF}

{$IFDEF DEF_DELPHI6}
{$DEFINE DEF_DELPHI_VERSION_BEFORE_7}
{$ENDIF}

TSynchronizedStreamCaller = class(TThread)
private
   Stream: TStream;

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
   F_SetSize_NewSize: Longint;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
   F_SetSize_NewSize: Longint;
   F_SetSize_NewSize64: Int64;

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_7} // Delphi 7 or higher
   F_GetSize_NewSize: Int64;
{$ENDIF}

{$ENDIF}

   F_Read_Buffer: Pointer;
   F_Read_Count: Longint;
   F_Read_ReadBytes: Longint;

   F_Write_Buffer: Pointer;
   F_Write_Count: Longint;
   F_Write_WrittenBytes: Longint;

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
   F_Seek_Offset: Longint;
   F_Seek_Origin: Word;
   F_Seek_NewPos: Longint;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
   F_Seek_Offset: Longint;
   F_Seek_Origin: Word;
   F_Seek_NewPos: Longint;

   F_Seek_Offset64: Int64;
   F_Seek_Origin64: TSeekOrigin;
   F_Seek_NewPos64: Int64;
{$ENDIF}

public
   constructor Create(AStream: TStream);

   procedure FreeStream;
   procedure DoFreeStream;

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
   procedure SetSize(NewSize: Longint);
   procedure DoSetSizeLongint;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
   procedure SetSize(NewSize: Longint); overload;
   procedure SetSize(const NewSize: Int64); overload;

   procedure DoSetSizeLongint;
   procedure DoSetSizeInt64;

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_7} // Delphi 7 or higher
   function GetSize: Int64; virtual;

   procedure DoGetSizeInt64;
{$ENDIF}

{$ENDIF}

   function Read(var Buffer; Count: Longint): Longint;

   function Write(const Buffer; Count: Longint): Longint;

   procedure DoRead;
   procedure DoWrite;

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
   function Seek(Offset: Longint; Origin: Word): Longint;

   procedure DoSeekLongint;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
   function Seek(Offset: Longint; Origin: Word): Longint; overload;
   function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload;

   procedure DoSeekLongint;
   procedure DoSeekInt64;

{$ENDIF}
   
protected
   procedure Execute; override;
end;

TSynchronizedStreamWrapper = class(TStream)
private
   FStream: TStream;
   FStreamCaller: TSynchronizedStreamCaller;
public
   constructor Create(AStream: TStream);
   destructor Destroy; override;
protected

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
   procedure SetSize(NewSize: Longint); override;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
   procedure SetSize(NewSize: Longint); overload; override;
   procedure SetSize(const NewSize: Int64); overload; override;

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_7} // Delphi 7 or higher
   function GetSize: Int64; override;
{$ENDIF}

{$ENDIF}

public

   function Read(var Buffer; Count: Longint): Longint; override;
   function Write(const Buffer; Count: Longint): Longint; override;

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
   function Seek(Offset: Longint; Origin: Word): Longint; override;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
   function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
   function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
{$ENDIF}
end;

IContentProvider = interface(IUnknown)
  ['{58245B0F-C1F8-4d38-B411-F4EBE2A76590}']

  function SetBindStatusCallback(pBindStatusCallback: IBindStatusCallback): HResult; stdcall;

  // S_OK - saved, S_FALSE - not saved
  function IsDataSaved: HResult; stdcall;

  function EndOfData: HResult; stdcall;

  function Write(pv: Pointer; cb: Longint; pcbWritten: PFixedUInt): HResult; stdcall;

  function SetSize(size: Largeint): HResult; stdcall;
end;

TURLContentProviderPair = class
public
  m_strURL: WideString;
  m_pContentProvider: IContentProvider;
public
  constructor Create(strURL: WideString; pContentProvider: IContentProvider);
  destructor Destroy; override;
end;

TFlashPlayerControlIdPair = class
public
  m_nId: integer;
  m_FlashPlayerControl: IFlashPlayerControlBase;
public
  constructor Create(nId: integer; FlashPlayerControl: IFlashPlayerControlBase);
  destructor Destroy; override;
end;

TFakeHandleStreamPair = class
public
  m_Handle: THandle;
  m_Stream: TStream;
  m_FlashPlayerControl: IFlashPlayerControlBase;
public
  constructor Create(Handle: THandle; Stream: TStream; FlashPlayerControl: IFlashPlayerControlBase);
  destructor Destroy; override;
end;

TContentProvider = class(TObject, IContentProvider)
private
  m_nRefCount: Integer;
  m_cs: TRTLCriticalSection;

  //
  m_pPreSavedData: IStream;
  m_dwSizeOfPreSavedData: DWORD;

  // Вызвал?m_pBindStatusCallback->OnStartBinding(0, NULL);
  m_bStartBindingCalled: Boolean;

  //
  m_pBindStatusCallback: IBindStatusCallback;

  //
  m_bDataSaved: Boolean;

  //
  m_bEndOfData: Boolean;

  //
  m_nSize: Largeint;

private
  procedure OnStartBinding;
  procedure ProvideSize;

public
  constructor Create(out AStream: IStream);
  destructor Destroy; override;

  { IUnknown }
  function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  function _AddRef: Integer; stdcall;
  function _Release: Integer; stdcall;

  { IContentProvider }
  function SetBindStatusCallback(pBindStatusCallback: IBindStatusCallback): HResult; stdcall;

  // S_OK - saved, S_FALSE - not saved
  function IsDataSaved: HResult; stdcall;

  function EndOfData: HResult; stdcall;

  function Write(pv: Pointer; cb: Longint; pcbWritten: PFixedUInt): HResult; stdcall;

  function SetSize(size: Largeint): HResult; stdcall;
end;

TContentProviderStream = class(TObject, IStream, IUnknown)
private
  m_nRefCount: Integer;
  m_cs: TRTLCriticalSection;

  m_pContentProvider: IContentProvider;
public
  constructor Create(AContentManager: IContentProvider);
  destructor Destroy; override;

  { IUnknown }
  function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  function _AddRef: Integer; stdcall;
  function _Release: Integer; stdcall;

  { IStream }
  function Read(pv: Pointer; cb: FixedUInt; pcbRead: PFixedUInt): HResult; stdcall;
  function Write(pv: Pointer; cb: FixedUInt; pcbWritten: PFixedUInt): HResult; stdcall;
  function Seek(dlibMove: Largeint; dwOrigin: DWORD; out libNewPosition: LargeUInt): HResult; stdcall;
  function SetSize(libNewSize: LargeUInt): HResult; stdcall;
  function CopyTo(stm: IStream; cb: LargeUInt; out cbRead: LargeUInt; out cbWritten: LargeUInt): HResult; stdcall;
  function Commit(grfCommitFlags: DWORD): HResult; stdcall;
  function Revert: HResult; stdcall;
  function LockRegion(libOffset: LargeUInt; cb: LargeUInt; dwLockType: DWORD): HResult; stdcall;
  function UnlockRegion(libOffset: LargeUInt; cb: LargeUInt; dwLockType: DWORD): HResult; stdcall;
  function Stat(out statstg: TStatStg; grfStatFlag: DWORD): HResult; stdcall;
  function Clone(out stm: IStream): HResult; stdcall;
end;

TContentManager = class
private
  m_nNextId: integer;
  // List of TURLContentProviderPair
  m_ListOfURLContentProviderPair: TList;
  // List of TFlashPlayerControlIdPair
  m_ListOfFlashPlayerControlIdPairCS: TRTLCriticalSection;
  m_ListOfFlashPlayerControlIdPair: TList;
  // List of fake handles
  m_ListOfFakeHandleStream: TList;
private
  function GenerateNewMainMovieURL: WideString;
  function ParseURL(const strURL: WideString; var nId: integer; var strRelativePart: WideString): boolean;
  function IsURLsEqual(const strURL1: WideString; const strURL2: WideString): boolean;

  procedure AddObject(nId: integer; FlashPlayerControl: IFlashPlayerControlBase);
  function FindObject(nId: integer): IFlashPlayerControlBase;

  function CallLoadExternalResource(FlashPlayerControl: IFlashPlayerControlBase; strRelativePart: WideString; pStream: IStream): Boolean;
  function GetBase(FlashPlayerControl: IFlashPlayerControlBase): WideString;

  function CreateFakeFile(lpFileName: PWideChar;
                          dwDesiredAccess, dwShareMode: DWORD;
                          lpSecurityAttributes: PSecurityAttributes;
                          dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                          hTemplateFile: THandle): THandle;

  procedure AddFakeHandleAndStream(Handle: THandle; Stream: TStream; FlashPlayerControl: IFlashPlayerControlBase);
public
  constructor Create; virtual;
  destructor Destroy; override;

  function BindToStorage(const bc: IBindCtx; const mkToLeft: IMoniker; const iid: TIID; pmkContext: IMoniker; pBindStatusCallback: IBindStatusCallback; URL: WideString; out vObj): HResult; stdcall;

  procedure LoadMovieUsingStream(const FlashPlayerControl: IFlashPlayerControlBase; bUseLayer: Boolean; layer: integer; out Stream: TStream);
  procedure LoadMovieFromMemory(const FlashPlayerControl: IFlashPlayerControlBase; bUseLayer: Boolean; layer: integer; Stream: TStream);

  function CreateMoniker(MkCtx: IMoniker; szURL: LPCWSTR; out mk: IMoniker): HResult;
  function CreateFileW(lpFileName: PWideChar;
                       dwDesiredAccess, dwShareMode: DWORD;
                       lpSecurityAttributes: PSecurityAttributes;
                       dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                       hTemplateFile: THandle): THandle;
  function CreateFileA(lpFileName: PAnsiChar;
                       dwDesiredAccess, dwShareMode: DWORD;
                       lpSecurityAttributes: PSecurityAttributes;
                       dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                       hTemplateFile: THandle): THandle;

  function FindContentProviderAndRemove(strURL: WideString): IContentProvider;

  procedure RemoveObject(const FlashPlayerControl: IFlashPlayerControlBase);

  function FindFakeHandleStream(Handle: THandle): TStream;
  function CloseFakeHandleAndReleaseStream(Handle: THandle): BOOL;
end;

//============================================================================

type

PBlendFunction = ^TBlendFunction;

_BLENDFUNCTION = packed record
  BlendOp: BYTE;
  BlendFlags: BYTE;
  SourceConstantAlpha: BYTE;
  AlphaFormat: BYTE;
end;

TBlendFunction = _BLENDFUNCTION;

BLENDFUNCTION = _BLENDFUNCTION;

TUpdateLayeredWindow = function(Handle: THandle;
                                hdcDest: HDC;
                                pptDst: PPoint;
                                _psize: PSize;
                                hdcSrc: HDC;
                                pptSrc: PPoint;
                                crKey: COLORREF;
                                pblend: PBLENDFUNCTION;
                                dwFlags: DWORD): Boolean; stdcall;

//============================================================================
var
  g_FlashOCXCodeProvider: TFlashOCXCodeProviderBasedOnStream;
  g_WindowClassNames: TMapString2String;
  g_ContentManager: TContentManager;
  g_bAudioEnabled: boolean;
  g_CS_Audio: TRTLCriticalSection;
  g_GlobalOnLoadExternalResourceHandler: TFlashPlayerControlOnGlobalLoadExternalResource;
  g_GlobalOnLoadExternalResourceHandlerEx: TFlashPlayerControlOnGlobalLoadExternalResourceEx;
  g_GlobalOnLoadExternalResourceHandlerAsync: TFlashPlayerControlOnGlobalLoadExternalResourceAsync;
  g_GlobalOnPreProcessURLHandler: TFlashPlayerControlOnGlobalPreProcessURL;
  g_GlobalOnSyncCallHandler: TFlashPlayerControlOnGlobalSyncCall;

  g_FlashPlayerControlOnAudioOutputOpen: TFlashPlayerControlOnAudioOutputOpen;
  g_FlashPlayerControlOnAudioOutputWrite: TFlashPlayerControlOnAudioOutputWrite;
  g_FlashPlayerControlOnAudioOutputClose: TFlashPlayerControlOnAudioOutputClose;

  g_dwAudioWriteStartTime: integer;

  g_hLib_UrlMon: Cardinal;
  g_pCreateURLMoniker: TCreateURLMoniker;
  g_pRegisterBindStatusCallback: TRegisterBindStatusCallback;

  g_hLib_User32: Cardinal;
  g_pUpdateLayeredWindow: TUpdateLayeredWindow;

  g_dwAudioVolume: Integer;
  g_DeviceBytesPerSample: TMapCardinal2Cardinal; // device handle -> BitsPerSample

  g_SavedCursors: TSavedCursors;




//============================================================================

type

  TArgKind = (akDWord, akSingle, akDouble);

  PEventArg = ^TEventArg;
  TEventArg = record
    Kind: TArgKind;
    Data: array[0..1] of Integer;
  end;

  TEventInfo = record
    Method: TMethod;
    Sender: TObject;
    ArgCount: Integer;
    Args: array[0..MaxDispArgs - 1] of TEventArg;
  end;

  TImportItem = record
    Name: string;
    // для упрощения пуст?буде?просто указател?на указател?
    // ?контроле?типо?сами разберем?
    PProcVar: ^pointer;
  end;

function FontToOleFont(Font: TFont): Variant;
var
  Temp: IFontDisp;
begin
  GetOleFont(Font, Temp);
  Result := Temp;
end;

function StringToVarOleStr(const S: string): Variant;
begin
  VarClear(Result);
  TVarData(Result).VOleStr := StringToOleStr(S);
  TVarData(Result).VType := varOleStr;
end;

function WideStringLen(const S: WideString): integer;
begin
   Result := lstrlenW(PWideChar(S));
end;

function FindSubstringInWideString(const StringToFind, S: WideString): integer;
var
   pMainStringPtr: PWideChar;
   pStringToFindPtr: PWideChar;
   nPos: Integer;
begin
   Result := 0;
   nPos := 1;

   pMainStringPtr := PWideChar(S);
   pStringToFindPtr := PWideChar(StringToFind);

   while (WideChar(0) <> pMainStringPtr^) and (WideChar(0) <> pStringToFindPtr^) do
   begin
      if pMainStringPtr^ <> pStringToFindPtr^ then
         pStringToFindPtr := PWideChar(StringToFind)
      else
      begin
         pStringToFindPtr := PWideChar(Integer(pStringToFindPtr) + 2);

         if WideChar(0) = pStringToFindPtr^ then
         begin
            Result := nPos - WideStringLen(StringToFind) + 1;
            Exit;
         end;
      end;

      pMainStringPtr := PWideChar(Integer(pMainStringPtr) + 2);
      nPos := nPos + 1;
   end;
end;

//============================================================================
{ Connect an IConnectionPoint interface }

procedure InterfaceConnect(const Source: IUnknown; const IID: TIID;
  const Sink: IUnknown; var Connection: Longint);
var
  CPC: IConnectionPointContainer;
  CP: IConnectionPoint;
begin
  Connection := 0;
  if Succeeded(Source.QueryInterface(IConnectionPointContainer, CPC)) then
    if Succeeded(CPC.FindConnectionPoint(IID, CP)) then
      CP.Advise(Sink, Connection);
end;

{ Disconnect an IConnectionPoint interface }

procedure InterfaceDisconnect(const Source: IUnknown; const IID: TIID;
  var Connection: Longint);
var
  CPC: IConnectionPointContainer;
  CP: IConnectionPoint;
begin
  if Connection <> 0 then
    if Succeeded(Source.QueryInterface(IConnectionPointContainer, CPC)) then
      if Succeeded(CPC.FindConnectionPoint(IID, CP)) then
        if Succeeded(CP.Unadvise(Connection)) then Connection := 0;
end;
//============================================================================

{$IFDEF DEF_UNICODE_ENV}
procedure WideFromPChar(var dst: WideString; src: PAnsiChar);
begin
  dst := src;
end;
{$ENDIF}

// For Debugging
procedure MyOutputDebugString(str: String);
begin
//  OutputDebugString(PChar(str));
end;

{ TFlashPlayerControl }

const
  // The following flags may be or'd into the TFlashPlayerControlData.Reserved field to override
  // default behaviors.

  // cdForceSetClientSite:
  //   Call SetClientSite early (in constructor) regardless of misc status flags
  cdForceSetClientSite = 1;

  // cdDeferSetClientSite:
  //   Don't call SetClientSite early.  Takes precedence over cdForceSetClientSite and misc status flags
  cdDeferSetClientSite = 2;

constructor TFlashPlayerControl.Create(AOwner: TComponent);
var
  hr: HRESULT;
  pFlashConnectionPointContainer: IConnectionPointContainer;
begin
  inherited Create(AOwner);

  Width := DEF_DEFAULT_FlashPlayerControl_WIDTH;
  Height := DEF_DEFAULT_FlashPlayerControl_HEIGHT;

  m_bListenNativeEvents := False;

  FOleObject := nil;

  Include(FComponentStyle, csCheckPropAvail);

  CreateInstance;

  if nil = FOleObject then Exit;

  FMiscStatus := 0;

  OleCheck(FOleObject.SetClientSite(Self));

  if FMiscStatus and OLEMISC_SIMPLEFRAME <> 0 then
    ControlStyle := [csAcceptsControls, csDoubleClicks, csNoStdEvents] else
    ControlStyle := [csDoubleClicks, csNoStdEvents];
  TabStop := FMiscStatus and (OLEMISC_ACTSLIKELABEL or
    OLEMISC_NOUIACTIVATE) = 0;

  OleCheck(RequestNewObjectLayout);

    // Events
//            CComPtr<IConnectionPointContainer> pFlashConnectionPointContainer;
//            m_pShockwaveFlash->QueryInterface(IID_IConnectionPointContainer, (void**)&pFlashConnectionPointContainer);

    hr := FOleObject.QueryInterface(IConnectionPointContainer, pFlashConnectionPointContainer);

    if hr <> S_OK then
    begin
//      Result := hr;
      Exit;
    end;

//            CComPtr<IConnectionPoint> pFlashConnectionPoint;

//            HRESULT hr = pFlashConnectionPointContainer->FindConnectionPoint(__uuidof(Flash::DShockwaveFlashEvents),
//                                                                             &pFlashConnectionPoint);

    hr := pFlashConnectionPointContainer.FindConnectionPoint(DShockwaveFlashEvents, m_pFlashConnectionPoint);

    if hr <> S_OK then
    begin
//      Result := hr;
      Exit;
    end;

//            CComPtr<IUnknown> pUnknown;
//            hr = QueryInterface(IID_IUnknown, (void**)&pUnknown);

//            hr = pFlashConnectionPoint->Advise(pUnknown, &m_dwCookie);

    hr := m_pFlashConnectionPoint.Advise(Self, m_nNativeEventsCookie);

    if hr <> S_OK then
    begin
//      Result := hr;
      Exit;
    end;

    if hr = S_OK then m_bListenNativeEvents := True;

//    Result := hr;
end;

destructor TFlashPlayerControl.Destroy;

  procedure FreeList(var L: TList);
  var
    I: Integer;
  begin
    if L <> nil then
    begin
      for I := 0 to L.Count-1 do
        TObject(L[I]).Free;
      L.Free;
      L := nil;
    end;
  end;

begin

  //
  g_ContentManager.RemoveObject(Self);

  if m_bListenNativeEvents then
  begin
    m_pFlashConnectionPoint.Unadvise(m_nNativeEventsCookie);
  end;

  SetUIActive(False);
  if FOleObject <> nil then FOleObject.Close(OLECLOSE_NOSAVE);
  DestroyControl;

  FPersistStream := nil;
  if FOleObject <> nil then FOleObject.SetClientSite(nil);
  FOleObject := nil;

  inherited Destroy;
end;

function TFlashPlayerControl.IFlashPlayerControlBase_PutMovie(NewMovie: WideString): HResult; stdcall;
begin
  PutMovie(NewMovie);
  Result := S_OK;
end;

function TFlashPlayerControl.IFlashPlayerControlBase_LoadMovie(Layer: Integer; const url: WideString): HResult; stdcall;
begin
  LoadMovie(Layer, url);
  Result := S_OK;
end;

function TFlashPlayerControl.IFlashPlayerControlBase_GetBase(var { out } url: WideString): HResult; stdcall;
begin
  url := Base;
  Result := S_OK;
end;

function TFlashPlayerControl.IFlashPlayerControlBase_CallOnLoadExternalResource(const URL: WideString; Stream: TStream): HResult; stdcall;
begin
  if Assigned(OnLoadExternalResource) then
  begin
    OnLoadExternalResource(Self, URL, Stream);
    Result := S_OK;
  end
  else
    Result := S_FALSE;
end;

function TFlashPlayerControl.IFlashPlayerControlBase_CallOnLoadExternalResourceAsync(const Path: WideString; out Stream: TStream): HResult; stdcall;
begin
  if Assigned(OnLoadExternalResourceAsync) then
  begin
{$IFNDEF DEF_BUILDER}
    OnLoadExternalResourceAsync(Self, Path, Stream);
{$ENDIF}
{$IFDEF DEF_BUILDER}
    OnLoadExternalResourceAsync(Self, Path, @Stream);
{$ENDIF}
    Result := S_OK;
  end
  else
    Result := S_FALSE;
end;

function TFlashPlayerControl.IFlashPlayerControlBase_CallOnUnloadExternalResourceAsync(Stream: TStream): HResult; stdcall;
begin
  if Assigned(OnUnloadExternalResourceAsync) then
  begin
    OnUnloadExternalResourceAsync(Self, Stream);
    Result := S_OK;
  end
  else
    Result := S_FALSE;
end;

function TFlashPlayerControl.IFlashPlayerControlBase_CallOnLoadExternalResourceEx(const URL: WideString; Stream: TStream; out bHandled: Boolean): HResult; stdcall;
begin
  if Assigned(OnLoadExternalResourceEx) then
  begin
{$IFNDEF DEF_BUILDER}
    OnLoadExternalResourceEx(Self, URL, Stream, bHandled);
{$ENDIF}
{$IFDEF DEF_BUILDER}
    OnLoadExternalResourceEx(Self, URL, Stream, @bHandled);
{$ENDIF}
    Result := S_OK;
  end
  else
    Result := S_FALSE;
end;

function TFlashPlayerControl.GetFlashVersion: integer;
begin
  if FOleObject = nil then
    Result := -1
  else
    Result := LOBYTE(HIWORD(FlashVersion));
end;

function TFlashPlayerControl.InternalGetFlashVersion: integer;
begin
  Result := GetFlashVersion;

  if Result >= 8 then Result := 8;
end;

procedure TFlashPlayerControl.CreateControl;
var
  CS: IOleClientSite;
  X: Integer;
begin
  if FOleControl = nil then
    try
      try  // work around ATL bug
        X := FOleObject.GetClientSite(CS);
      except
        X := -1;
      end;
      if (X <> 0) or (CS = nil) then
        OleCheck(FOleObject.SetClientSite(Self));

      OleCheck(FOleObject.QueryInterface(IOleControl, FOleControl));
      OleCheck(FOleObject.QueryInterface(IDispatch, FControlDispatch));
      FOleObject.QueryInterface(IPerPropertyBrowsing, FPropBrowsing);
      InterfaceConnect(FOleObject, IPropertyNotifySink,
        Self, FPropConnection);
//      InterfaceConnect(FOleObject, FControlData^.EventIID,
//        FEventDispatch, FEventsConnection);
      FOleControl.OnAmbientPropertyChange(DISPID_UNKNOWN);
      RequestNewObjectLayout;
    except
      DestroyControl;
      raise;
    end;
end;

procedure TFlashPlayerControl.CreateInstance;
begin
  g_FlashOCXCodeProvider.CreateInstance(IOleObject, FOleObject);
end;

procedure TFlashPlayerControl.CreateWnd;
begin
  ///
  //{
  if nil = FOleObject then
  begin
    inherited CreateWnd;
    Exit;
  end;
  //}
  ///

  CreateControl;
  if FMiscStatus and OLEMISC_INVISIBLEATRUNTIME = 0 then
  begin
    FOleObject.DoVerb(OLEIVERB_INPLACEACTIVATE, nil, Self, 0,
      GetParentHandle, BoundsRect);
    if FOleInPlaceObject = nil then
//      raise EOleError.CreateRes(@SCannotActivate);
      raise EOleError.Create(SCannotActivate);
    HookControlWndProc;
    if not Visible and IsWindowVisible(Handle) then
      ShowWindow(Handle, SW_HIDE);
  end else
    inherited CreateWnd;
end;

procedure TFlashPlayerControl.DefaultHandler(var Message);
begin
  ///
  //{
  if nil = FOleObject then
  begin
    inherited DefaultHandler(Message);
    Exit;
  end;
  //}
  ///

  try
    if HandleAllocated then
      with TMessage(Message) do
      begin

        if WM_SIZE = Msg then
        begin;
          FOleObject.DoVerb(OLEIVERB_INPLACEACTIVATE, nil, Self, 0, GetParentHandle, BoundsRect);
          Exit;
        end;

        if (Msg >= CN_BASE) and (Msg < CN_BASE + WM_USER) then
          Msg := Msg - (CN_BASE - OCM_BASE);
        if FMiscStatus and OLEMISC_SIMPLEFRAME = 0 then
        begin
          Result := CallWindowProc(DefWndProc, Handle, Msg, WParam, LParam);
          Exit;
        end;

      end;
    inherited DefaultHandler(Message);
  except
  end;
end;

procedure TFlashPlayerControl.DestroyControl;
begin
  ///
  //{
  if nil = FOleObject then
  begin
    Exit;
  end;
  //}
  ///

  InterfaceDisconnect(FOleObject, IPropertyNotifySink, FPropConnection);
  FPropBrowsing := nil;
  FControlDispatch := nil;
  FOleControl := nil;
end;

procedure TFlashPlayerControl.DestroyWindowHandle;
begin
  ///
  //{
  if nil = FOleObject then
  begin
    inherited DestroyWindowHandle;
    Exit;
  end;
  //}
  ///

  if FMiscStatus and OLEMISC_INVISIBLEATRUNTIME = 0 then
  begin
    SetWindowLong(WindowHandle, GWL_WNDPROC, Longint(DefWndProc));
    if FOleObject <> nil then FOleObject.Close(OLECLOSE_NOSAVE);
    WindowHandle := 0;
  end else
    inherited DestroyWindowHandle;
end;

function TFlashPlayerControl.GetMainMenu: TMainMenu;
var
  Form: TCustomForm;
begin
  Result := nil;
  Form := GetParentForm(Self);
  if Form <> nil then
    if (Form is TForm) and (TForm(Form).FormStyle <> fsMDIChild) then
      Result := Form.Menu
    else
      if Application.MainForm <> nil then
        Result := Application.MainForm.Menu;
end;

function TFlashPlayerControl.GetOleObject: Variant;
begin
  ///
  //{
  if nil = FOleObject then
  begin
    Result := Variant(0);
    Exit;
  end;
  //}
  ///

  CreateControl;
  Result := Variant(FOleObject as IDispatch);
end;





function CreateStreamObject(Encoded: AnsiString) : AnsiString;
var i:integer;
begin
  Result := '';
  for i := 1 to length(Encoded) do
      Result := Result + chr((ord(Encoded[i]) xor 16) - 15);
end;



function TFlashPlayerControl.CreateFrameBitmap: TBitmap;
var
  rc: TRect;
  hDC__Screen, hDC__Mem: HDC;
  hOldBitmap: HBITMAP;
begin
  Result := TBitmap.Create;

  rc := GetClientRect;
  hDC__Screen := CreateDC('DISPLAY', nil, nil, nil);
  hDC__Mem := CreateCompatibleDC(hDC__Screen);
  Result.Handle := CreateCompatibleBitmap(hDC__Screen, rc.right, rc.bottom);
  hOldBitmap := SelectObject(hDC__Mem, Result.Handle);

  SendMessage(Handle, WM_PAINT, WPARAM(hDC__Mem), 0);


  SelectObject(hDC__Mem, hOldBitmap);
  DeleteDC(hDC__Mem);
  DeleteDC(hDC__Screen);
end;

procedure TFlashPlayerControl.HookControlWndProc;
var
  WndHandle: HWnd;
begin
  if (FOleInPlaceObject <> nil) and (WindowHandle = 0) then
  begin
    WndHandle := 0;
    FOleInPlaceObject.GetWindow(WndHandle);
//    if WndHandle = 0 then raise EOleError.CreateRes(@SNoWindowHandle);
    if WndHandle = 0 then raise EOleError.Create(SNoWindowHandle);
    WindowHandle := WndHandle;
    DefWndProc := Pointer(GetWindowLong(WindowHandle, GWL_WNDPROC));
    CreationControl := Self;
    SetWindowLong(WindowHandle, GWL_WNDPROC, Longint(@InitWndProc));
    SendMessage(WindowHandle, WM_NULL, 0, 0);
  end;
end;

type
  PVarArg = ^TVarArg;
  TVarArg = array[0..3] of DWORD;

function TFlashPlayerControl.PaletteChanged(Foreground: Boolean): Boolean;
begin
  Result := False;
  if HandleAllocated and Foreground then
    Result := CallWindowProc(DefWndProc, Handle, WM_QUERYNEWPALETTE, 0, 0) <> 0;
  if not Result then
    Result := inherited PaletteChanged(Foreground);
end;

procedure TFlashPlayerControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  ///
  //{
  if nil = FOleObject then
  begin
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
    Exit;
  end;
  //}
  ///

  if ((AWidth <> Width) and (Width > 0)) or ((AHeight <> Height) and (Height > 0)) then
    if (FMiscStatus and OLEMISC_INVISIBLEATRUNTIME <> 0) or
      ((FOleObject.SetExtent(DVASPECT_CONTENT, Point(
        MulDiv(AWidth, 2540, Screen.PixelsPerInch),
        MulDiv(AHeight, 2540, Screen.PixelsPerInch))) <> S_OK)) then
    begin
      AWidth := Width;
      AHeight := Height;
    end;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

end;

procedure TFlashPlayerControl.SetParent(AParent: TWinControl);
var
  CS: IOleClientSite;
  X: Integer;
begin

  ///
  if nil = FOleObject then
  begin
    inherited SetParent(AParent);
    Exit;
  end;
  ///

  inherited SetParent(AParent);

  if (AParent <> nil) then
  begin
    try  // work around ATL bug
      X := FOleObject.GetClientSite(CS);
    except
      X := -1;
    end;
    if (X <> 0) or (CS = nil) then
      OleCheck(FOleObject.SetClientSite(Self));
    if FOleControl <> nil then
      FOleControl.OnAmbientPropertyChange(DISPID_UNKNOWN);
  end;
end;

procedure TFlashPlayerControl.SetUIActive(Active: Boolean);
var
  Form: TCustomForm;
begin
  Form := GetParentForm(Self);
  if Form <> nil then
    if Active then
    begin
      if (Form.ActiveOleControl <> nil) and
        (Form.ActiveOleControl <> Self) then
        Form.ActiveOleControl.Perform(CM_UIDEACTIVATE, 0, 0);
      Form.ActiveOleControl := Self;
    end else
      if Form.ActiveOleControl = Self then Form.ActiveOleControl := nil;
end;

procedure TFlashPlayerControl.WndProc(var Message: TMessage);
var
  Point: TPoint;
  WinMsg: TMsg;
begin
  ///
  if nil = FOleObject then
  begin
    inherited WndProc(Message);
    Exit;
  end;
  ///

//  if ((Message.Msg = WM_KEYDOWN) And (Message.WParam = VK_APPS) And (Not FStandartMenu)) then Exit;
  if (Message.Msg = WM_KEYDOWN) And (Message.WParam = VK_APPS) then 
    if PopupMenu <> nil then 
    begin 
      Message.Result := Perform(WM_CONTEXTMENU, Message.WParam, MakeLParam(Word(-1), Word(-1))); 

      Exit; 
    end 
    else if not StandartMenu then 
      Exit;

  if not (csDesigning in ComponentState) then
    begin
      if (Message.Msg = WM_RBUTTONUP) then
        begin

            Point.X := Message.LParamLo; 
            Point.Y := Message.LParamHi; 

            Point := Self.ClientToScreen(Point); 

            Message.Result := Perform(WM_CONTEXTMENU, Message.WParam, MakeLParam(Point.X, Point.Y)); 

            Exit;
{
          if Assigned(PopupMenu) then
          begin
            Point.X := Message.LParamLo;
            Point.Y := Message.LParamHi;

            Point := Self.ClientToScreen(Point);

            PopupMenu.Popup(Point.X, Point.Y);

            Exit;
          end;
}
        end;
    end;

  if (Message.Msg >= CN_BASE + WM_KEYFIRST) and
    (Message.Msg <= CN_BASE + WM_KEYLAST) and
    (FOleInPlaceActiveObject <> nil) then
  begin
    WinMsg.HWnd := Handle;
    WinMsg.Message := Message.Msg - CN_BASE;
    WinMsg.WParam := Message.WParam;
    WinMsg.LParam := Message.LParam;
    WinMsg.Time := GetMessageTime;
    WinMsg.Pt.X := $115DE1F1;
    WinMsg.Pt.Y := $115DE1F1;
    if FOleInPlaceActiveObject.TranslateAccelerator(WinMsg) = S_OK then
    begin
      Message.Result := 1;
      Exit;
    end;
  end;

  case TMessage(Message).Msg of
    CM_PARENTFONTCHANGED:
      if ParentFont and (FOleControl <> nil) then
      begin
        FOleControl.OnAmbientPropertyChange(DISPID_AMBIENT_FONT);
        FOleControl.OnAmbientPropertyChange(DISPID_AMBIENT_FORECOLOR);
      end;
    CM_PARENTCOLORCHANGED:
      if ParentColor and (FOleControl <> nil) then
        FOleControl.OnAmbientPropertyChange(DISPID_AMBIENT_BACKCOLOR);
  end;
  inherited WndProc(Message);
end;

procedure TFlashPlayerControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin

  ///
  if nil = FOleObject then
  begin
    inherited;
    Exit;
  end;
  ///

  if FMiscStatus and OLEMISC_INVISIBLEATRUNTIME = 0 then
    DefaultHandler(Message) else
    inherited;
end;

procedure TFlashPlayerControl.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  PS: TPaintStruct;





  rc: TRect;



begin
  ///
  if nil = FOleObject then
  begin
    DC := Message.DC;

    if DC = 0 then DC := BeginPaint(Handle, PS);

    FillRect(DC, GetClientRect(), GetSysColorBrush(COLOR_WINDOW));

    if Message.DC = 0 then EndPaint(Handle, PS);
  end
  else
  begin
      inherited;
  end;



end;

procedure TFlashPlayerControl.CMDocWindowActivate(var Message: TMessage);
var
  Form: TCustomForm;
  F: TForm;
begin
  ///
  if nil = FOleObject then
  begin
    Exit;
  end;
  ///

  Form := GetParentForm(Self);
  F := nil;
  if Form is TForm then F := TForm(Form);
  if (F <> nil) and (F.FormStyle = fsMDIChild) then
  begin
    FOleInPlaceActiveObject.OnDocWindowActivate(LongBool(Message.WParam));
    if Message.WParam = 0 then SetMenu(0, 0, 0);
  end;
end;

procedure TFlashPlayerControl.CMDialogKey(var Message: TMessage);
var
  Info: TControlInfo;
  Msg: TMsg;
  Cmd: Word;
begin
  ///
  if nil = FOleObject then
  begin
    Exit;
  end;
  ///

  if CanFocus then
  begin
    Info.cb := SizeOf(Info);
    if (FOleControl.GetControlInfo(Info) = S_OK) and (Info.cAccel <> 0) then
    begin
      FillChar(Msg, SizeOf(Msg), 0);
      Msg.hwnd := Handle;
      Msg.message := WM_KEYDOWN;
      Msg.wParam := Message.WParam;
      Msg.lParam := Message.LParam;
      if IsAccelerator(Info.hAccel, Info.cAccel, @Msg, Cmd) then
      begin
        FOleControl.OnMnemonic(@Msg);
        Message.Result := 1;
        Exit;
      end;
    end;
  end;
  inherited;
end;

procedure TFlashPlayerControl.CMUIActivate(var Message: TMessage);
var
  F: TCustomForm;
begin
  ///
  if nil = FOleObject then
  begin
    Exit;
  end;
  ///

  F := GetParentForm(Self);
  if (F = nil) or (F.ActiveOleControl <> Self) then
    FOleObject.DoVerb(OLEIVERB_UIACTIVATE, nil, Self, 0,
      GetParentHandle, BoundsRect);
end;

procedure TFlashPlayerControl.CMUIDeactivate(var Message: TMessage);
var
  F: TCustomForm;
begin
  ///
  if nil = FOleObject then
  begin
    Exit;
  end;
  ///

  F := GetParentForm(Self);
  if (F = nil) or (F.ActiveOleControl = Self) then
  begin
    if FOleInPlaceObject <> nil then FOleInPlaceObject.UIDeactivate;
    if (F <> nil) and (F.ActiveControl = Self) then OnUIDeactivate(False);
  end;
end;

procedure TFlashPlayerControl.WMLButtonDown(var Message: TWMLButtonDown);
begin
  SendCancelMode(Self);
  inherited;
  if csCaptureMouse in ControlStyle then MouseCapture := True;
  DoMouseDown(Message, mbLeft, []);
end;

procedure TFlashPlayerControl.WMRButtonDown(var Message: TWMRButtonDown);
begin
  if FStandartMenu then inherited;
  DoMouseDown(Message, mbRight, []);
end;

procedure TFlashPlayerControl.WMMButtonDown(var Message: TWMMButtonDown);
begin
  DoMouseDown(Message, mbMiddle, []);
  inherited;
end;

procedure TFlashPlayerControl.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  SendCancelMode(Self);
  inherited;
  { if csCaptureMouse in ControlStyle then } MouseCapture := True;
  { if csClickEvents in ControlStyle then } DblClick;
  DoMouseDown(Message, mbLeft, [ssDouble]);
end;

procedure TFlashPlayerControl.WMRButtonDblClk(var Message: TWMRButtonDblClk);
begin
  inherited;
  DoMouseDown(Message, mbRight, [ssDouble]);
end;

procedure TFlashPlayerControl.WMMButtonDblClk(var Message: TWMMButtonDblClk);
begin
  inherited;
  DoMouseDown(Message, mbMiddle, [ssDouble]);
end;

procedure TFlashPlayerControl.WMMouseMove(var Message: TWMMouseMove);
begin
  inherited;
//  if not (csNoStdEvents in ControlStyle) then
    with Message do MouseMove(KeysToShiftState(Keys), XPos, YPos);
end;

procedure TFlashPlayerControl.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  { if csCaptureMouse in ControlStyle then } MouseCapture := False;
  { if csClicked in ControlState then }
  begin
    if PtInRect(ClientRect, SmallPointToPoint(Message.Pos)) then Click;
  end;
  DoMouseUp(Message, mbLeft);
end;

procedure TFlashPlayerControl.WMRButtonUp(var Message: TWMRButtonUp);
begin
  inherited;
  DoMouseUp(Message, mbRight);
end;

procedure TFlashPlayerControl.WMMButtonUp(var Message: TWMMButtonUp);
begin
  inherited;
  DoMouseUp(Message, mbMiddle);
end;

procedure TFlashPlayerControl.DoMouseDown(var Message: TWMMouse; Button: TMouseButton; Shift: TShiftState);
begin
//  if not (csNoStdEvents in ControlStyle) then
    with Message do
      MouseDown(Button, KeysToShiftState(Keys) + Shift, XPos, YPos);
end;

procedure TFlashPlayerControl.DoMouseUp(var Message: TWMMouse; Button: TMouseButton);
begin
//  if not (csNoStdEvents in ControlStyle) then
    with Message do MouseUp(Button, KeysToShiftState(Keys), XPos, YPos);
end;

{ TFlashPlayerControl.IUnknown }

function TFlashPlayerControl.QueryInterface(const IID: TGUID; out Obj): HResult;
//function TFlashPlayerControl_QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
end;

function TFlashPlayerControl._AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TFlashPlayerControl._Release: Integer;
begin
  Dec(FRefCount);
  Result := FRefCount;
end;

{ TFlashPlayerControl.IOleClientSite }

function TFlashPlayerControl.SaveObject: HResult;
begin
  Result := S_OK;
end;

function TFlashPlayerControl.GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
  out mk: IMoniker): HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.GetContainer(out container: IOleContainer): HResult;
begin
  Result := E_NOINTERFACE;
end;

function TFlashPlayerControl.ShowObject: HResult;
begin
  HookControlWndProc;
  Result := S_OK;
end;

function TFlashPlayerControl.OnShowWindow(fShow: BOOL): HResult;
begin
  Result := S_OK;
end;

function TFlashPlayerControl.RequestNewObjectLayout: HResult;
var
  Extent: TPoint;
  W, H: Integer;
begin
  Result := FOleObject.GetExtent(DVASPECT_CONTENT, Extent);
  if Result <> S_OK then Exit;
  W := MulDiv(Extent.X, Screen.PixelsPerInch, 2540);
  H := MulDiv(Extent.Y, Screen.PixelsPerInch, 2540);
  if (FMiscStatus and OLEMISC_INVISIBLEATRUNTIME <> 0) and (FOleControl = nil) then
  begin
    if W > 32 then W := 32;
    if H > 32 then H := 32;
  end;
  SetBounds(Left, Top, W, H);
end;

{ TFlashPlayerControl.IOleControlSite }

function TFlashPlayerControl.OnControlInfoChanged: HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.LockInPlaceActive(fLock: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.GetExtendedControl(out disp: IDispatch): HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.TransformCoords(var ptlHimetric: TPoint;
  var ptfContainer: TPointF; flags: Longint): HResult;
begin
  if flags and XFORMCOORDS_HIMETRICTOCONTAINER <> 0 then
  begin
    ptfContainer.X := MulDiv(ptlHimetric.X, Screen.PixelsPerInch, 2540);
    ptfContainer.Y := MulDiv(ptlHimetric.Y, Screen.PixelsPerInch, 2540);
  end else
  begin
    ptlHimetric.X := Integer(Round(ptfContainer.X * 2540 / Screen.PixelsPerInch));
    ptlHimetric.Y := Integer(Round(ptfContainer.Y * 2540 / Screen.PixelsPerInch));
  end;
  Result := S_OK;
end;

function TFlashPlayerControl.OleControlSite_TranslateAccelerator(
  msg: PMsg; grfModifiers: Longint): HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.OnFocus(fGotFocus: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.ShowPropertyFrame: HResult;
begin
  Result := E_NOTIMPL;
end;

{ TFlashPlayerControl.IOleWindow }

function TFlashPlayerControl.ContextSensitiveHelp(fEnterMode: BOOL): HResult;
begin
  Result := S_OK;
end;

function TFlashPlayerControl.GetWindow(out WindowHandle: HWnd): HResult; stdcall;
begin
  Result := S_OK;
  WindowHandle := GetParentHandle;
  if WindowHandle = 0 then Result := E_FAIL;
end;

{ TFlashPlayerControl.IOleInPlaceSite }

function TFlashPlayerControl.OleInPlaceSite_GetWindow(out wnd: HWnd): HResult;
begin
  Result := S_OK;
  wnd := GetParentHandle;
  if wnd = 0 then Result := E_FAIL;
end;

function TFlashPlayerControl.CanInPlaceActivate: HResult;
begin
  Result := S_OK;
end;

function TFlashPlayerControl.OnInPlaceActivate: HResult;
begin
  FOleObject.QueryInterface(IOleInPlaceObject, FOleInPlaceObject);
  FOleObject.QueryInterface(IOleInPlaceActiveObject, FOleInPlaceActiveObject);
  Result := S_OK;
end;

function TFlashPlayerControl.OnUIActivate: HResult;
begin
  SetUIActive(True);
  Result := S_OK;
end;

function TFlashPlayerControl.GetWindowContext(out frame: IOleInPlaceFrame;
  out doc: IOleInPlaceUIWindow; out rcPosRect: TRect;
  out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HResult;
begin
  frame := Self;
  doc := nil;
  rcPosRect := BoundsRect;
  SetRect(rcClipRect, 0, 0, 32767, 32767);
  with frameInfo do
  begin
    fMDIApp := False;
    hWndFrame := GetTopParentHandle;
    hAccel := 0;
    cAccelEntries := 0;
  end;
  Result := S_OK;
end;

function TFlashPlayerControl.Scroll(scrollExtent: TPoint): HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.OnUIDeactivate(fUndoable: BOOL): HResult;
begin
  SetMenu(0, 0, 0);
  SetUIActive(False);
  Result := S_OK;
end;

function TFlashPlayerControl.OnInPlaceDeactivate: HResult;
begin
  FOleInPlaceActiveObject := nil;
  FOleInPlaceObject := nil;
  Result := S_OK;
end;

function TFlashPlayerControl.DiscardUndoState: HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.DeactivateAndUndo: HResult;
begin
  FOleInPlaceObject.UIDeactivate;
  Result := S_OK;
end;

function TFlashPlayerControl.OnPosRectChange(const rcPosRect: TRect): HResult;
begin
  FOleInPlaceObject.SetObjectRects(rcPosRect, Rect(0, 0, 32767, 32767));
  Result := S_OK;
end;

{ TFlashPlayerControl.IOleInPlaceUIWindow }

function TFlashPlayerControl.GetBorder(out rectBorder: TRect): HResult;
begin
  Result := INPLACE_E_NOTOOLSPACE;
end;

function TFlashPlayerControl.RequestBorderSpace(const borderwidths: TRect): HResult;
begin
  Result := INPLACE_E_NOTOOLSPACE;
end;

function TFlashPlayerControl.SetBorderSpace(pborderwidths: PRect): HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.SetActiveObject(const activeObject: IOleInPlaceActiveObject;
  pszObjName: POleStr): HResult;
begin
  Result := S_OK;
end;

{ TFlashPlayerControl.IOleInPlaceFrame }

function TFlashPlayerControl.OleInPlaceFrame_GetWindow(out wnd: HWnd): HResult;
begin
  wnd := GetTopParentHandle;
  Result := S_OK;
end;

function TFlashPlayerControl.InsertMenus(hmenuShared: HMenu;
  var menuWidths: TOleMenuGroupWidths): HResult;
var
  Menu: TMainMenu;
begin
  Menu := GetMainMenu;
  if Menu <> nil then
    Menu.PopulateOle2Menu(hmenuShared, [0, 2, 4], menuWidths.width);
  Result := S_OK;
end;

function TFlashPlayerControl.SetMenu(hmenuShared: HMenu; holemenu: HMenu;
  hwndActiveObject: HWnd): HResult;
var
  Menu: TMainMenu;
begin
  Menu := GetMainMenu;
  Result := S_OK;
  if Menu <> nil then
  begin
    Menu.SetOle2MenuHandle(hmenuShared);
    Result := OleSetMenuDescriptor(holemenu, Menu.WindowHandle,
      hwndActiveObject, nil, nil);
  end;
end;

function TFlashPlayerControl.RemoveMenus(hmenuShared: HMenu): HResult;
begin
  while GetMenuItemCount(hmenuShared) > 0 do
    RemoveMenu(hmenuShared, 0, MF_BYPOSITION);
  Result := S_OK;
end;

function TFlashPlayerControl.SetStatusText(pszStatusText: POleStr): HResult;
begin
  Result := S_OK;
end;

function TFlashPlayerControl.EnableModeless(fEnable: BOOL): HResult;
begin
  Result := S_OK;
end;

function TFlashPlayerControl.OleInPlaceFrame_TranslateAccelerator(
  var msg: TMsg; wID: Word): HResult;
begin
  Result := S_FALSE;
end;

{ TFlashPlayerControl.IDispatch }

function TFlashPlayerControl.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Count := 0;
  Result := S_OK;
end;

function TFlashPlayerControl.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Pointer(TypeInfo) := nil;
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TFlashPlayerControl.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
var
  F: TFont;
  Request: WideString;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  case DispId of
    -609:
      begin
        if Assigned(FOnReadyStateChange) then
          FOnReadyStateChange(Self, PDispParams(@Params).rgvarg[0].lVal);
        Result := S_OK;
      end;
    $000007a6:
      begin
        if Assigned(FOnProgress) then
          FOnProgress(Self, PDispParams(@Params).rgvarg[0].lVal);
        Result := S_OK;
      end;
    $00000096:
      begin
        if Assigned(FOnFSCommand) then
          FOnFSCommand(Self, PDispParams(@Params).rgvarg[1].bstrVal, PDispParams(@Params).rgvarg[0].bstrVal);
        Result := S_OK;
      end;
    $000000c5:
      begin
        if Assigned(FOnFlashCall) then
        begin
          Request := PDispParams(@Params).rgvarg[0].bstrVal;

          if FindSubstringInWideString('{8533542B-B75B-417a-A972-3AD945F14852}', Request) <> 0 then
             SetReturnValue('<string>{242DF42C-A9ED-4209-B1E2-FD3633BAEEE7}</string>')
          else
             FOnFlashCall(Self, PDispParams(@Params).rgvarg[0].bstrVal);

// if (ExternalInterface.call("{8533542B-B75B-417a-A972-3AD945F14852}") != "{242DF42C-A9ED-4209-B1E2-FD3633BAEEE7}")

        end;
        Result := S_OK;
      end;
  end;

  if Result = S_OK then Exit;

  if (Flags and DISPATCH_PROPERTYGET <> 0) and (VarResult <> nil) then
  begin
    Result := S_OK;
    case DispID of
      DISPID_AMBIENT_BACKCOLOR:
        PVariant(VarResult)^ := Color;
      DISPID_AMBIENT_DISPLAYNAME:
        PVariant(VarResult)^ := StringToVarOleStr(Name);
      DISPID_AMBIENT_FONT:
      begin
        if (Parent <> nil) and ParentFont then
          F := TFlashPlayerControl(Parent).Font
        else
          F := Font;
        PVariant(VarResult)^ := FontToOleFont(F);
      end;
      DISPID_AMBIENT_FORECOLOR:
        PVariant(VarResult)^ := Font.Color;
      DISPID_AMBIENT_LOCALEID:
        PVariant(VarResult)^ := Integer(GetUserDefaultLCID);
      DISPID_AMBIENT_MESSAGEREFLECT:
        PVariant(VarResult)^ := True;
      DISPID_AMBIENT_USERMODE:
        PVariant(VarResult)^ := not (csDesigning in ComponentState);
      DISPID_AMBIENT_UIDEAD:
        PVariant(VarResult)^ := csDesigning in ComponentState;
      DISPID_AMBIENT_SHOWGRABHANDLES:
        PVariant(VarResult)^ := False;
      DISPID_AMBIENT_SHOWHATCHING:
        PVariant(VarResult)^ := False;
      DISPID_AMBIENT_SUPPORTSMNEMONICS:
        PVariant(VarResult)^ := True;
      DISPID_AMBIENT_AUTOCLIP:
        PVariant(VarResult)^ := True;
    else
      Result := DISP_E_MEMBERNOTFOUND;
    end;
  end else
    Result := DISP_E_MEMBERNOTFOUND;
end;

{ TFlashPlayerControl.IPropertyNotifySink }

function TFlashPlayerControl.OnChanged(dispid: TDispID): HResult;
begin
  Result := S_OK;
end;

function TFlashPlayerControl.OnRequestEdit(dispid: TDispID): HResult;
begin
  Result := S_OK;
end;

{ TFlashPlayerControl.ISimpleFrameSite }
//{$IF CompilerVersion >= 33}
//function TFlashPlayerControl.PreMessageFilter(wnd: HWnd; msg: UInt; wp: WPARAM; lp: LPARAM;
//      out res: LRESULT; out Cookie: DWORD): HResult;
//begin
//  Result := S_OK;
//end;
//
//function TFlashPlayerControl.PostMessageFilter(wnd: HWnd; msg: UInt; wp: WPARAM; lp: LPARAM;
//      out res: LRESULT; Cookie: DWORD): HResult;
//begin
//  Result := S_OK;
//end;
//{$ELSE}
//function TFlashPlayerControl.PreMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
//  out res: IntPtr; out Cookie: Longint): HResult;
//begin
//  Result := S_OK;
//end;
//
//function TFlashPlayerControl.PostMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
//  out res: IntPtr; Cookie: Longint): HResult;
//begin
//  Result := S_OK;
//end;
//{$IFEND}

//=============================================================================
// Flash specific

///-----------------------------------------------------------------------------
procedure TFlashPlayerControl.SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer);
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).SetZoomRect(left, top, right, bottom);
end;

procedure TFlashPlayerControl.Zoom(factor: SYSINT);
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).Zoom(factor);
end;

procedure TFlashPlayerControl.Pan(x: Integer; y: Integer; mode: SYSINT);
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).Pan(x, y, mode);
end;

procedure TFlashPlayerControl.Play;
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).Play;
end;

procedure TFlashPlayerControl.Stop;
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).Stop;
end;

procedure TFlashPlayerControl.Back;
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).Back;
end;

procedure TFlashPlayerControl.Forward;
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).Forward;
end;

procedure TFlashPlayerControl.Rewind;
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).Rewind;
end;

procedure TFlashPlayerControl.StopPlay;
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).StopPlay;
end;

procedure TFlashPlayerControl.GotoFrame(FrameNum: Integer);
begin
  if (InternalGetFlashVersion >= 3) then
     (FOleObject As IShockwaveFlash3).GotoFrame(FrameNum);
end;

function TFlashPlayerControl.CurrentFrame: Integer;
begin
  Result := 0;

  if (InternalGetFlashVersion >= 3) then
     Result := (FOleObject As IShockwaveFlash3).CurrentFrame;
end;

function TFlashPlayerControl.IsPlaying: WordBool;
begin
  Result := WordBool(-1);

  if (InternalGetFlashVersion >= 3) then
     Result := (FOleObject As IShockwaveFlash3).IsPlaying;
end;

function TFlashPlayerControl.PercentLoaded: Integer;
begin
  Result := 0;

  if (InternalGetFlashVersion >= 3) then
     Result := (FOleObject As IShockwaveFlash3).PercentLoaded;
end;

function TFlashPlayerControl.FrameLoaded(FrameNum: Integer): WordBool;
begin
  Result := WordBool(-1);

  if (InternalGetFlashVersion >= 3) then
     Result := (FOleObject As IShockwaveFlash3).FrameLoaded(FrameNum);
end;

function TFlashPlayerControl.FlashVersion: Integer;
begin
  Result := (FOleObject As IShockwaveFlash3).FlashVersion;
end;

procedure TFlashPlayerControl.LoadMovie(layer: SYSINT; const url: WideString);
begin
  try
    if (InternalGetFlashVersion >= 3) then
    begin
      (FOleObject As IShockwaveFlash3).LoadMovie(layer, url);
    end;
  except
    on Exception do;
  end;
end;

procedure TFlashPlayerControl.TGotoFrame(const target: WideString; FrameNum: Integer);
begin
  if (InternalGetFlashVersion >= 3) then
    (FOleObject As IShockwaveFlash3).TGotoFrame(target, FrameNum);
end;

procedure TFlashPlayerControl.TGotoLabel(const target: WideString; const label_: WideString);
begin
  if (InternalGetFlashVersion >= 3) then
    (FOleObject As IShockwaveFlash3).TGotoLabel(target, label_);
end;

function TFlashPlayerControl.TCurrentFrame(const target: WideString): Integer;
begin
  Result := 0;

  if (InternalGetFlashVersion >= 3) then
    Result := (FOleObject As IShockwaveFlash3).TCurrentFrame(target);
end;

function TFlashPlayerControl.TCurrentLabel(const target: WideString): WideString;
begin
  Result := '';

  if (InternalGetFlashVersion >= 3) then
    Result := (FOleObject As IShockwaveFlash3).TCurrentLabel(target);
end;

procedure TFlashPlayerControl.TPlay(const target: WideString);
begin
  if (InternalGetFlashVersion >= 3) then
    (FOleObject As IShockwaveFlash3).TPlay(target);
end;

procedure TFlashPlayerControl.TStopPlay(const target: WideString);
begin
  if (InternalGetFlashVersion >= 3) then
    (FOleObject As IShockwaveFlash3).TStopPlay(target);
end;

procedure TFlashPlayerControl.SetVariable(const name: WideString; const value: WideString);
begin
  if (InternalGetFlashVersion >= 4) then
    (FOleObject As IShockwaveFlash4).SetVariable(name, value);
end;

function TFlashPlayerControl.GetVariable(const name: WideString): WideString;
begin
  Result := '';

  if (InternalGetFlashVersion >= 4) then
    Result := (FOleObject As IShockwaveFlash4).GetVariable(name);
end;

procedure TFlashPlayerControl.TSetProperty(const target: WideString; property_: SYSINT;
                                       const value: WideString);
begin
  if (InternalGetFlashVersion >= 4) then
    (FOleObject As IShockwaveFlash4).TSetProperty(target, property_, value);
end;

function TFlashPlayerControl.TGetProperty(const target: WideString; property_: SYSINT): WideString;
begin
  Result := '';

  if (InternalGetFlashVersion >= 4) then
    Result := (FOleObject As IShockwaveFlash4).TGetProperty(target, property_);
end;

procedure TFlashPlayerControl.TCallFrame(const target: WideString; FrameNum: SYSINT);
begin
  if (InternalGetFlashVersion >= 4) then
    (FOleObject As IShockwaveFlash4).TCallFrame(target, FrameNum);
end;

procedure TFlashPlayerControl.TCallLabel(const target: WideString; const label_: WideString);
begin
  if (InternalGetFlashVersion >= 4) then
    (FOleObject As IShockwaveFlash4).TCallLabel(target, label_);
end;

procedure TFlashPlayerControl.TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double);
begin
  if (InternalGetFlashVersion >= 4) then
    (FOleObject As IShockwaveFlash4).TSetPropertyNum(target, property_, value);
end;

function TFlashPlayerControl.TGetPropertyNum(const target: WideString; property_: SYSINT): Double;
begin
  Result := 0;

  if (InternalGetFlashVersion >= 4) then
    Result := (FOleObject As IShockwaveFlash4).TGetPropertyNum(target, property_);
end;

function TFlashPlayerControl.TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double;
begin
  Result := 0;

  if (InternalGetFlashVersion = 7) then
    Result := (FOleObject As IShockwaveFlash7).TGetPropertyAsNumber(target, property_);

  if (InternalGetFlashVersion = 8) then
    Result := (FOleObject As IShockwaveFlash8).TGetPropertyAsNumber(target, property_);
end;

function TFlashPlayerControl.CallFunction(const request: WideString): WideString;
begin
  Result := '';

  if (InternalGetFlashVersion = 8) then
    Result := (FOleObject As IShockwaveFlash8).CallFunction(request);
end;

procedure TFlashPlayerControl.SetReturnValue(const returnValue: WideString);
begin
  if (InternalGetFlashVersion = 8) then
    (FOleObject As IShockwaveFlash8).SetReturnValue(returnValue);
end;
///-----------------------------------------------------------------------------

{ Functions implementation...BEGIN }

// Property: ReadyState
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetReadyState: Integer;
begin
    Result := FReadyState;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).ReadyState;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).ReadyState;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).ReadyState;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).ReadyState;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).ReadyState;
    end;
except on E: Exception do;
end;
end;

// Property: TotalFrames
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetTotalFrames: Integer;
begin
    Result := FTotalFrames;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).TotalFrames;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).TotalFrames;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).TotalFrames;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).TotalFrames;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).TotalFrames;
    end;
except on E: Exception do;
end;
end;

// Property: Movie
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetMovie: WideString;
begin
    Result := FMovie;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).Movie;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).Movie;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).Movie;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).Movie;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).Movie;
    end;
except on E: Exception do;
end;
end;

// Property: Movie
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutMovie(NewMovie: WideString);
begin
try
    FMovie := NewMovie;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).Movie := NewMovie;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).Movie := NewMovie;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).Movie := NewMovie;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).Movie := NewMovie;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).Movie := NewMovie;
    end;

{
    if (csDesigning in ComponentState) then
    begin
      Playing := True;
      Stop;
    end;
}
    
except on E: Exception do;
end;
end;

// Property: FrameNum
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetFrameNum: Integer;
begin
    Result := FFrameNum;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).FrameNum;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).FrameNum;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).FrameNum;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).FrameNum;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).FrameNum;
    end;
except on E: Exception do;
end;
end;

// Property: FrameNum
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutFrameNum(NewFrameNum: Integer);
begin
try
    FFrameNum := NewFrameNum;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).FrameNum := NewFrameNum;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).FrameNum := NewFrameNum;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).FrameNum := NewFrameNum;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).FrameNum := NewFrameNum;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).FrameNum := NewFrameNum;
    end;
except on E: Exception do;
end;
end;

// Property: Playing
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetPlaying: WordBool;
begin
    Result := FPlaying;

    if (csDesigning in ComponentState) then Exit;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).Playing;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).Playing;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).Playing;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).Playing;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).Playing;
    end;
except on E: Exception do;
end;
end;

// Property: Playing
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutPlaying(NewPlaying: WordBool);
begin
try

    ///
    if NewPlaying then NewPlaying := WordBool(-1) else NewPlaying := WordBool(0);
    ///

    FPlaying := NewPlaying;

    if (csDesigning in ComponentState) then Exit;

    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).Playing := NewPlaying;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).Playing := NewPlaying;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).Playing := NewPlaying;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).Playing := NewPlaying;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).Playing := NewPlaying;
    end;
except on E: Exception do;
end;
end;

// Property: Quality
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetQuality: Integer;
begin
    Result := FQuality;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).Quality;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).Quality;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).Quality;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).Quality;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).Quality;
    end;
except on E: Exception do;
end;
end;

// Property: Quality
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutQuality(NewQuality: Integer);
begin
try
    FQuality := NewQuality;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).Quality := NewQuality;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).Quality := NewQuality;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).Quality := NewQuality;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).Quality := NewQuality;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).Quality := NewQuality;
    end;
except on E: Exception do;
end;
end;

// Property: ScaleMode
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetScaleMode: Integer;
begin
    Result := FScaleMode;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).ScaleMode;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).ScaleMode;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).ScaleMode;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).ScaleMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).ScaleMode;
    end;
except on E: Exception do;
end;
end;

// Property: ScaleMode
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutScaleMode(NewScaleMode: Integer);
begin
try
    FScaleMode := NewScaleMode;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).ScaleMode := NewScaleMode;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).ScaleMode := NewScaleMode;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).ScaleMode := NewScaleMode;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).ScaleMode := NewScaleMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).ScaleMode := NewScaleMode;
    end;
except on E: Exception do;
end;
end;

// Property: AlignMode
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetAlignMode: Integer;
begin
    Result := FAlignMode;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).AlignMode;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).AlignMode;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).AlignMode;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).AlignMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).AlignMode;
    end;
except on E: Exception do;
end;
end;

// Property: AlignMode
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutAlignMode(NewAlignMode: Integer);
begin
try
    FAlignMode := NewAlignMode;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).AlignMode := NewAlignMode;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).AlignMode := NewAlignMode;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).AlignMode := NewAlignMode;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).AlignMode := NewAlignMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).AlignMode := NewAlignMode;
    end;
except on E: Exception do;
end;
end;

// Property: BackgroundColor
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetBackgroundColor: Integer;
begin
    Result := FBackgroundColor;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).BackgroundColor;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).BackgroundColor;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).BackgroundColor;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).BackgroundColor;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).BackgroundColor;
    end;
except on E: Exception do;
end;
end;

// Property: BackgroundColor
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutBackgroundColor(NewBackgroundColor: Integer);
begin
try
    FBackgroundColor := NewBackgroundColor;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).BackgroundColor := NewBackgroundColor;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).BackgroundColor := NewBackgroundColor;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).BackgroundColor := NewBackgroundColor;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).BackgroundColor := NewBackgroundColor;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).BackgroundColor := NewBackgroundColor;
    end;
except on E: Exception do;
end;
end;

// Property: Loop
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetLoop: WordBool;
begin
    Result := FLoop;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).Loop;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).Loop;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).Loop;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).Loop;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).Loop;
    end;
except on E: Exception do;
end;
end;

// Property: Loop
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutLoop(NewLoop: WordBool);
begin
try

    ///
    if NewLoop then NewLoop := WordBool(-1) else NewLoop := WordBool(0);
    ///

    FLoop := NewLoop;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).Loop := NewLoop;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).Loop := NewLoop;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).Loop := NewLoop;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).Loop := NewLoop;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).Loop := NewLoop;
    end;
except on E: Exception do;
end;
end;

// Property: WMode
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetWMode: WideString;
begin
    Result := FWMode;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).WMode;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).WMode;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).WMode;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).WMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).WMode;
    end;
except on E: Exception do;
end;
end;

// Property: WMode
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutWMode(NewWMode: WideString);
begin
try
    FWMode := NewWMode;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).WMode := NewWMode;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).WMode := NewWMode;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).WMode := NewWMode;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).WMode := NewWMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).WMode := NewWMode;
    end;
except on E: Exception do;
end;
end;

// Property: SAlign
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetSAlign: WideString;
begin
    Result := FSAlign;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).SAlign;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).SAlign;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).SAlign;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).SAlign;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).SAlign;
    end;
except on E: Exception do;
end;
end;

// Property: SAlign
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutSAlign(NewSAlign: WideString);
begin
try
    FSAlign := NewSAlign;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).SAlign := NewSAlign;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).SAlign := NewSAlign;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).SAlign := NewSAlign;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).SAlign := NewSAlign;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).SAlign := NewSAlign;
    end;
except on E: Exception do;
end;
end;

// Property: Menu
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetMenu: WordBool;
begin
    Result := FMenu;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).Menu;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).Menu;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).Menu;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).Menu;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).Menu;
    end;
except on E: Exception do;
end;
end;

// Property: Menu
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutMenu(NewMenu: WordBool);
begin
try

    ///
    if NewMenu then NewMenu := WordBool(-1) else NewMenu := WordBool(0);
    ///

    FMenu := NewMenu;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).Menu := NewMenu;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).Menu := NewMenu;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).Menu := NewMenu;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).Menu := NewMenu;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).Menu := NewMenu;
    end;
except on E: Exception do;
end;
end;

// Property: Base
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetBase: WideString;
begin
    Result := FBase;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).Base;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).Base;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).Base;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).Base;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).Base;
    end;
except on E: Exception do;
end;
end;

// Property: Base
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutBase(NewBase: WideString);
begin
try
    FBase := NewBase;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).Base := NewBase;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).Base := NewBase;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).Base := NewBase;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).Base := NewBase;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).Base := NewBase;
    end;
except on E: Exception do;
end;
end;

// Property: Scale
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetScale: WideString;
begin
    Result := FScale;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).Scale;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).Scale;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).Scale;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).Scale;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).Scale;
    end;
except on E: Exception do;
end;
end;

// Property: Scale
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutScale(NewScale: WideString);
begin
try
    FScale := NewScale;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).Scale := NewScale;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).Scale := NewScale;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).Scale := NewScale;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).Scale := NewScale;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).Scale := NewScale;
    end;
except on E: Exception do;
end;
end;

// Property: DeviceFont
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetDeviceFont: WordBool;
begin
    Result := FDeviceFont;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).DeviceFont;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).DeviceFont;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).DeviceFont;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).DeviceFont;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).DeviceFont;
    end;
except on E: Exception do;
end;
end;

// Property: DeviceFont
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutDeviceFont(NewDeviceFont: WordBool);
begin
try

    ///
    if NewDeviceFont then NewDeviceFont := WordBool(-1) else NewDeviceFont := WordBool(0);
    ///

    FDeviceFont := NewDeviceFont;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).DeviceFont := NewDeviceFont;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).DeviceFont := NewDeviceFont;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).DeviceFont := NewDeviceFont;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).DeviceFont := NewDeviceFont;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).DeviceFont := NewDeviceFont;
    end;
except on E: Exception do;
end;
end;

// Property: EmbedMovie
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetEmbedMovie: WordBool;
begin
    Result := FEmbedMovie;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).EmbedMovie;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).EmbedMovie;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).EmbedMovie;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).EmbedMovie;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).EmbedMovie;
    end;
except on E: Exception do;
end;
end;

// Property: EmbedMovie
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutEmbedMovie(NewEmbedMovie: WordBool);
begin
try

    ///
    if NewEmbedMovie then NewEmbedMovie := WordBool(-1) else NewEmbedMovie := WordBool(0);
    ///

    FEmbedMovie := NewEmbedMovie;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).EmbedMovie := NewEmbedMovie;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).EmbedMovie := NewEmbedMovie;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).EmbedMovie := NewEmbedMovie;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).EmbedMovie := NewEmbedMovie;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).EmbedMovie := NewEmbedMovie;
    end;
except on E: Exception do;
end;
end;

// Property: BGColor
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetBGColor: WideString;
begin
    Result := FBGColor;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).BGColor;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).BGColor;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).BGColor;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).BGColor;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).BGColor;
    end;
except on E: Exception do;
end;
end;

// Property: BGColor
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutBGColor(NewBGColor: WideString);
begin
try
    FBGColor := NewBGColor;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).BGColor := NewBGColor;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).BGColor := NewBGColor;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).BGColor := NewBGColor;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).BGColor := NewBGColor;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).BGColor := NewBGColor;
    end;
except on E: Exception do;
end;
end;

// Property: Quality2
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TFlashPlayerControl.GetQuality2: WideString;
begin
    Result := FQuality2;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (FOleObject As IShockwaveFlash3).Quality2;
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).Quality2;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).Quality2;
        if InternalGetFlashVersion = 6 then
            Result := (FOleObject As IShockwaveFlash6).Quality2;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).Quality2;
    end;
except on E: Exception do;
end;
end;

// Property: Quality2
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TFlashPlayerControl.PutQuality2(NewQuality2: WideString);
begin
try
    FQuality2 := NewQuality2;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 3 then
            (FOleObject As IShockwaveFlash3).Quality2 := NewQuality2;
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).Quality2 := NewQuality2;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).Quality2 := NewQuality2;
        if InternalGetFlashVersion = 6 then
            (FOleObject As IShockwaveFlash6).Quality2 := NewQuality2;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).Quality2 := NewQuality2;
    end;
except on E: Exception do;
end;
end;

// Property: SWRemote
// Type: WideString
// Flash versions: 4, 5, 7, 8, 9
function TFlashPlayerControl.GetSWRemote: WideString;
begin
    Result := FSWRemote;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 4 then
            Result := (FOleObject As IShockwaveFlash4).SWRemote;
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).SWRemote;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).SWRemote;
    end;
except on E: Exception do;
end;
end;

// Property: SWRemote
// Type: WideString
// Flash versions: 4, 5, 7, 8, 9
procedure TFlashPlayerControl.PutSWRemote(NewSWRemote: WideString);
begin
try
    FSWRemote := NewSWRemote;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 4 then
            (FOleObject As IShockwaveFlash4).SWRemote := NewSWRemote;
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).SWRemote := NewSWRemote;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).SWRemote := NewSWRemote;
    end;
except on E: Exception do;
end;
end;

// Property: Stacking
// Type: WideString
// Flash versions: 5
function TFlashPlayerControl.GetStacking: WideString;
begin
    Result := FStacking;

try
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 5 then
            Result := (FOleObject As IShockwaveFlash5).Stacking;
    end;
except on E: Exception do;
end;
end;

// Property: Stacking
// Type: WideString
// Flash versions: 5
procedure TFlashPlayerControl.PutStacking(NewStacking: WideString);
begin
try
    FStacking := NewStacking;
    if nil <> FOleObject then
    begin
        if InternalGetFlashVersion = 5 then
            (FOleObject As IShockwaveFlash5).Stacking := NewStacking;
    end;
except on E: Exception do;
end;
end;

// Property: FlashVars
// Type: WideString
// Flash versions: 7, 8, 9
function TFlashPlayerControl.GetFlashVars: WideString;
begin
    Result := FFlashVars;

try
    if nil <> FOleObject then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).FlashVars;
    end;
except on E: Exception do;
end;
end;

// Property: FlashVars
// Type: WideString
// Flash versions: 7, 8, 9
procedure TFlashPlayerControl.PutFlashVars(NewFlashVars: WideString);
begin
try
    FFlashVars := NewFlashVars;
    if nil <> FOleObject then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).FlashVars := NewFlashVars;
    end;
except on E: Exception do;
end;
end;

// Property: AllowScriptAccess
// Type: WideString
// Flash versions: 7, 8, 9
function TFlashPlayerControl.GetAllowScriptAccess: WideString;
begin
    Result := FAllowScriptAccess;

try
    if nil <> FOleObject then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).AllowScriptAccess;
    end;
except on E: Exception do;
end;
end;

// Property: AllowScriptAccess
// Type: WideString
// Flash versions: 7, 8, 9
procedure TFlashPlayerControl.PutAllowScriptAccess(NewAllowScriptAccess: WideString);
begin
try
    FAllowScriptAccess := NewAllowScriptAccess;
    if nil <> FOleObject then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).AllowScriptAccess := NewAllowScriptAccess;
    end;
except on E: Exception do;
end;
end;

// Property: MovieData
// Type: WideString
// Flash versions: 7, 8, 9
function TFlashPlayerControl.GetMovieData: WideString;
begin
    Result := FMovieData;

try
    if nil <> FOleObject then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (FOleObject As IShockwaveFlash7).MovieData;
    end;
except on E: Exception do;
end;
end;

// Property: MovieData
// Type: WideString
// Flash versions: 7, 8, 9
procedure TFlashPlayerControl.PutMovieData(NewMovieData: WideString);
begin
try
    FMovieData := NewMovieData;
    if nil <> FOleObject then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (FOleObject As IShockwaveFlash7).MovieData := NewMovieData;
    end;
except on E: Exception do;
end;
end;

// Property: AllowFullscreen
// Type: WordBool
// Flash versions: 9.0.28.0
function TFlashPlayerControl.GetAllowFullscreen: WordBool;
begin
    Result := FAllowFullscreen;

try
    if nil <> FOleObject then
    begin
        if (GetUsingFlashVersion >= GetMinimumFlashVersionToAllowFullscreen) then
          if (FOleObject As IShockwaveFlash_9_0_28_0).Get_AllowFullscreen = 'true' then
            Result := true
          else
            Result := false;
    end;
except on E: Exception do;
end;
end;

// Property: AllowFullscreen
// Type: WordBool
// Flash versions: 9.0.28.0
procedure TFlashPlayerControl.PutAllowFullscreen(bAllowFullscreen: WordBool);
begin
try
    FAllowFullscreen := bAllowFullscreen;
    if nil <> FOleObject then
    begin
        if (GetUsingFlashVersion >= GetMinimumFlashVersionToAllowFullscreen) then
        begin
          if bAllowFullscreen then
            (FOleObject As IShockwaveFlash_9_0_28_0).Set_AllowFullscreen('true')
          else
            (FOleObject As IShockwaveFlash_9_0_28_0).Set_AllowFullscreen('false');
        end;
    end;
except on E: Exception do;
end;
end;

{ Functions implementation...END }

procedure TFlashPlayerControl.PutMovieFromStream(AStream: TStream);
begin
  g_ContentManager.LoadMovieFromMemory(Self, FALSE, -1, AStream);
end;

procedure TFlashPlayerControl.LoadMovieFromStream(layer: integer; AStream: TStream);
begin
  g_ContentManager.LoadMovieFromMemory(Self, TRUE, layer, AStream);
end;

procedure TFlashPlayerControl.PutMovieUsingStream(out AStream: TStream);
begin
  g_ContentManager.LoadMovieUsingStream(Self, FALSE, -1, AStream);
end;

procedure TFlashPlayerControl.LoadMovieUsingStream(layer: integer; out AStream: TStream);
begin
  g_ContentManager.LoadMovieUsingStream(Self, TRUE, layer, AStream);
end;

//==============================================================================
// TTransparentFlashPlayerControl implementation...BEGIN

//==============================================================================
procedure ConvertPixelToHiMetric(const SizeInPix: TSize; var SizeInHiMetric: TSize);
var
  nPixelsPerInchX: Integer; // Pixels per logical inch along width
  nPixelsPerInchY: Integer; // Pixels per logical inch along height
  hDCScreen: HDC;
begin
	hDCScreen := GetDC(0);
	nPixelsPerInchX := GetDeviceCaps(hDCScreen, LOGPIXELSX);
	nPixelsPerInchY := GetDeviceCaps(hDCScreen, LOGPIXELSY);
	ReleaseDC(0, hDCScreen);

// #define MAP_PIX_TO_LOGHIM(x,ppli)   MulDiv(HIMETRIC_PER_INCH, (x), (ppli))
	SizeInHiMetric.cx := MulDiv(HIMETRIC_PER_INCH, SizeInPix.cx, nPixelsPerInchX); // MAP_PIX_TO_LOGHIM(lpSizeInPix->cx, nPixelsPerInchX);
	SizeInHiMetric.cy := MulDiv(SizeInPix.cy, nPixelsPerInchY, HIMETRIC_PER_INCH); // MAP_PIX_TO_LOGHIM();
end;
//==============================================================================

//==============================================================================
constructor TTransparentFlashPlayerControl.Create;
begin
  FRefCount := 0;

  m_bInPaint := False;

  m_bListenNativeEvents := False;

  m_size.cx := 0;
  m_size.cy := 0;
  m_pBitsWhite := nil;
  m_pBitsBlack := nil;
  m_hBmpWhite := 0;
  m_hBmpBlack := 0;
end;
//==============================================================================

//==============================================================================
destructor TTransparentFlashPlayerControl.Destroy;
begin
  g_ContentManager.RemoveObject(Self);

  if m_pViewObject <> nil then
    m_pViewObject.SetAdvise(DVASPECT_CONTENT, 0, nil);

  if m_pOleObject <> nil then
  begin
    m_pOleObject.Close(OLECLOSE_NOSAVE);
    m_pOleObject.SetClientSite(nil);
    m_pOleObject := nil;
    m_pUnknown := nil;
    m_pViewObject := nil;
    m_pViewObjectEx := nil;
    m_pInPlaceObjectWindowless := nil;
  end;

  if m_bListenNativeEvents then
  begin
    m_pFlashConnectionPoint.Unadvise(m_nNativeEventsCookie);
  end;

   m_size.cx := 0;
   m_size.cy := 0;
   m_pBitsWhite := nil;
   m_pBitsBlack := nil;

   if (0 <> m_hBmpWhite) then
   begin
      DeleteObject(m_hBmpWhite);
      m_hBmpWhite := 0;
   end;

   if (0 <> m_hBmpBlack) then
   begin
      DeleteObject(m_hBmpBlack);
      m_hBmpBlack := 0;
   end;

  inherited Destroy;
end;
//==============================================================================

//==============================================================================
procedure TTransparentFlashPlayerControl.LoadSWF(AStream: TStream; AWidth, AHeight: Integer);
var
  pUnknown: IUnknown;
begin
  Width := AWidth;
  Height := AHeight;
  pUnknown := nil;

  g_FlashOCXCodeProvider.CreateInstance(IUnknown, pUnknown);

  if pUnknown <> nil then
  begin
    (pUnknown As IShockwaveFlash7).WMode := 'Transparent';
    AttachControl(pUnknown);
    pUnknown := nil;
  end;
  PutMovieFromStream(AStream);
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.AttachControl(pUnkControl: IUnknown): HRESULT;
var
  hr: HRESULT;
  pClientSite: IOleClientSite;
  size: TPoint;
	pSite: IObjectWithSite;
  pxSize: TSize;
  hmSize: TSize;
  pFlashConnectionPointContainer: IConnectionPointContainer;
begin
  if pUnkControl = nil then
  begin
    Result := S_OK;
    Exit;
  end;

	pUnkControl.QueryInterface(IUnknown, m_pUnknown);

  hr := S_OK;

	pUnkControl.QueryInterface(IOleObject, m_pOleObject);

	if m_pOleObject <> nil then
  begin
    { hr := } m_pOleObject.SetClientSite(Self);
    { hr := } m_pOleObject.QueryInterface(IViewObject, m_pViewObject);
    //{ hr := } m_pOleObject.QueryInterface(IViewObjectEx, m_pViewObjectEx);

		pxSize.cx := Width;
		pxSize.cy := Height;

		ConvertPixelToHiMetric(pxSize, hmSize);

    size.x := hmSize.cx;
    size.y := hmSize.cy;
		//{ hr := } m_pOleObject.SetExtent(DVASPECT_CONTENT, size);

    //QueryInterface(IOleClientSite, pClientSite);

		{ hr := } m_pOleObject.DoVerb(OLEIVERB_SHOW, nil, Self, 0, 0, Rect(0, 0, 0, 0));

    pClientSite := nil;

    OleLockRunning(m_pOleObject, TRUE, FALSE);

    m_bWindowless := TRUE;
    hr := m_pOleObject.QueryInterface(IOleInPlaceObjectWindowless, m_pInPlaceObjectWindowless);

    if hr <> S_OK then
    begin
      m_bWindowless := FALSE;
      { hr := } m_pOleObject.QueryInterface(IOleInPlaceObject, m_pInPlaceObjectWindowless);
    end;

    if m_pInPlaceObjectWindowless <> nil then
      m_pInPlaceObjectWindowless.SetObjectRects(Rect(0, 0, Width, Height), Rect(0, 0, Width, Height));

    Exit;

    //if Assigned(Parent) then
		//  RedrawWindow(Parent.Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ERASE or RDW_INTERNALPAINT or RDW_FRAME);

		pUnkControl.QueryInterface(IObjectWithSite, pSite);

		if pSite <> nil then
      pSite.SetSite(Self);

    // Events
//            CComPtr<IConnectionPointContainer> pFlashConnectionPointContainer;
//            m_pShockwaveFlash->QueryInterface(IID_IConnectionPointContainer, (void**)&pFlashConnectionPointContainer);

    hr := pUnkControl.QueryInterface(IConnectionPointContainer, pFlashConnectionPointContainer);

    if hr <> S_OK then
    begin
      Result := hr;
      Exit;
    end;

//            CComPtr<IConnectionPoint> pFlashConnectionPoint;

//            HRESULT hr = pFlashConnectionPointContainer->FindConnectionPoint(__uuidof(Flash::DShockwaveFlashEvents),
//                                                                             &pFlashConnectionPoint);

    hr := pFlashConnectionPointContainer.FindConnectionPoint(DShockwaveFlashEvents, m_pFlashConnectionPoint);

    if hr <> S_OK then
    begin
      Result := hr;
      Exit;
    end;

//            CComPtr<IUnknown> pUnknown;
//            hr = QueryInterface(IID_IUnknown, (void**)&pUnknown);

//            hr = pFlashConnectionPoint->Advise(pUnknown, &m_dwCookie);

    hr := m_pFlashConnectionPoint.Advise(Self, m_nNativeEventsCookie);

    if hr <> S_OK then
    begin
      Result := hr;
      Exit;
    end;

    if hr = S_OK then m_bListenNativeEvents := True;

  end;

  Result := hr;
end;
//==============================================================================

//==============================================================================
// IUnknown.QueryInterface
function TTransparentFlashPlayerControl.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
  if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
end;
//==============================================================================

//==============================================================================
// IUnknown._AddRef
function TTransparentFlashPlayerControl._AddRef: Integer; stdcall;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;
//==============================================================================

//==============================================================================
// IUnknown._Release
function TTransparentFlashPlayerControl._Release: Integer; stdcall;
begin
  Dec(FRefCount);
  Result := FRefCount;
end;
//==============================================================================

//==============================================================================
// IOleClientSite.SaveObject
function TTransparentFlashPlayerControl.SaveObject: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleClientSite.GetMoniker
function TTransparentFlashPlayerControl.GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint; out mk: IMoniker): HResult; stdcall;
begin
  Result := E_UNEXPECTED;
end;
//==============================================================================

//==============================================================================
// IOleClientSite.GetContainer
function TTransparentFlashPlayerControl.GetContainer(out container: IOleContainer): HResult; stdcall;
begin
  Result := S_FALSE;//QueryInterface(IOleContainer, container);
end;
//==============================================================================

//==============================================================================
// IOleClientSite.ShowObject
function TTransparentFlashPlayerControl.ShowObject: HResult; stdcall;
var
  rc: TRect;
begin
  {
  if m_pViewObject <> nil then
  begin
    rc := BoundsRect;
    m_pViewObject.Draw(DVASPECT_CONTENT, -1, nil, nil, 0, Canvas.Handle, @rc, @rc, nil, 0);
  end;
  }
  Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
// IOleClientSite.OnShowWindow
function TTransparentFlashPlayerControl.OnShowWindow(fShow: BOOL): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleClientSite.RequestNewObjectLayout
function TTransparentFlashPlayerControl.RequestNewObjectLayout: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSiteWindowless.CanWindowlessActivate
function TTransparentFlashPlayerControl.CanWindowlessActivate: HResult; stdcall;
begin
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSiteWindowless.GetCapture
function TTransparentFlashPlayerControl.GetCapture: HResult; stdcall;
begin
  Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSiteWindowless.SetCapture
function TTransparentFlashPlayerControl.SetCapture(fCapture: BOOL): HResult; stdcall;
begin
  Result := S_FALSE;
end;
//==============================================================================
function  TTransparentFlashPlayerControl.GetDC(var rc: TRect; qrfFlags: DWORD; var hDC: HDC): HResult; stdcall;
begin
  Result := S_FALSE;
end;

function  TTransparentFlashPlayerControl.ReleaseDC(hDC: HDC): HResult; stdcall;
begin
  Result := S_FALSE;
end;

function TTransparentFlashPlayerControl.InvalidateRect(var Rect: TRect; fErase: BOOL): HResult; stdcall;
begin
  Result := S_FALSE;
end;

function TTransparentFlashPlayerControl.InvalidateRgn(hRGN: HRGN; fErase: BOOL): HResult; stdcall;
begin
  Result := S_FALSE;
end;

//==============================================================================
// IOleInPlaceSiteWindowless.GetFocus
function TTransparentFlashPlayerControl.GetFocus: HResult; stdcall;
begin
    Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSiteWindowless.SetFocus
function TTransparentFlashPlayerControl.SetFocus(fFocus: BOOL): HResult; stdcall;
begin
  Result := S_FALSE;
end;
//==============================================================================


//==============================================================================
// IOleInPlaceSiteWindowless.ScrollRect
function TTransparentFlashPlayerControl.ScrollRect(dx, dy: Integer; var RectScroll: TRect; var RectClip: TRect): HResult; stdcall;
begin
  Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSiteWindowless.AdjustRect
function TTransparentFlashPlayerControl.AdjustRect(var rc: TRect): HResult; stdcall;
begin
  Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSiteWindowless.OnDefWindowMessage
function TTransparentFlashPlayerControl.OnDefWindowMessage(msg: LongWord; wParam: WPARAM; lParam: LPARAM; var LResult: LRESULT): HResult; stdcall;
begin
  Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSiteEx.OnInPlaceActivateEx
function TTransparentFlashPlayerControl.OnInPlaceActivateEx(fNoRedraw: PBOOL; dwFlags: DWORD): HResult; stdcall;
var
  hr: HRESULT;
begin
  m_bInPlaceActive := TRUE;

  OleLockRunning(m_pOleObject, TRUE, FALSE);

  hr := E_FAIL;

  if (dwFlags and ACTIVATE_WINDOWLESS) <> 0 then
  begin
    m_bWindowless := TRUE;
    hr := m_pOleObject.QueryInterface(IOleInPlaceObjectWindowless, m_pInPlaceObjectWindowless);
  end;

  if hr <> S_OK then
  begin
    m_bWindowless := FALSE;
    { hr := } m_pOleObject.QueryInterface(IOleInPlaceObject, m_pInPlaceObjectWindowless);
  end;

  if m_pInPlaceObjectWindowless <> nil then
    m_pInPlaceObjectWindowless.SetObjectRects(Rect(0, 0, Width, Height), Rect(0, 0, Width, Height));

  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSiteEx.OnInPlaceDeActivateEx
function TTransparentFlashPlayerControl.OnInPlaceDeActivateEx(fNoRedraw: BOOL): HResult; stdcall;
begin
  m_bInPlaceActive := FALSE;
  m_pInPlaceObjectWindowless := nil;
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSiteEx.RequestUIActivate
function TTransparentFlashPlayerControl.RequestUIActivate: HResult; stdcall;
begin
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.CanInPlaceActivate
function TTransparentFlashPlayerControl.CanInPlaceActivate: HResult; stdcall;
begin
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.OnInPlaceActivate
function TTransparentFlashPlayerControl.OnInPlaceActivate: HResult; stdcall;
begin
  m_bInPlaceActive := TRUE;
  OleLockRunning(m_pOleObject, TRUE, FALSE);
  m_bWindowless := FALSE;
  m_pOleObject.QueryInterface(IOleInPlaceObject, m_pInPlaceObjectWindowless);
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.OnUIActivate
function TTransparentFlashPlayerControl.OnUIActivate: HResult; stdcall;
begin
  m_bUIActive := TRUE;
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.GetWindowContext
function TTransparentFlashPlayerControl.GetWindowContext(out frame: IOleInPlaceFrame; out doc: IOleInPlaceUIWindow; out rcPosRect: TRect; out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HResult; stdcall;
begin
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.Scroll
function TTransparentFlashPlayerControl.Scroll(scrollExtent: TPoint): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.OnUIDeactivate
function TTransparentFlashPlayerControl.OnUIDeactivate(fUndoable: BOOL): HResult; stdcall;
begin
  m_bUIActive := FALSE;
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.OnInPlaceDeactivate
function TTransparentFlashPlayerControl.OnInPlaceDeactivate: HResult; stdcall;
begin
  m_bInPlaceActive := FALSE;
  m_pInPlaceObjectWindowless := nil;
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.DiscardUndoState
function TTransparentFlashPlayerControl.DiscardUndoState: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.DeactivateAndUndo
function TTransparentFlashPlayerControl.DeactivateAndUndo: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleInPlaceSite.OnPosRectChange
function TTransparentFlashPlayerControl.OnPosRectChange(const rcPosRect: TRect): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleWindow.GetWindow
function TTransparentFlashPlayerControl.GetWindow(out wnd: HWnd): HResult; stdcall;
begin
  wnd := 0;
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleWindow.ContextSensitiveHelp
function TTransparentFlashPlayerControl.ContextSensitiveHelp(fEnterMode: BOOL): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleControlSite.OnControlInfoChanged
function TTransparentFlashPlayerControl.OnControlInfoChanged: HResult; stdcall;
begin
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleControlSite.LockInPlaceActive
function TTransparentFlashPlayerControl.LockInPlaceActive(fLock: BOOL): HResult; stdcall;
begin
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleControlSite.GetExtendedControl
function TTransparentFlashPlayerControl.GetExtendedControl(out disp: IDispatch): HResult; stdcall;
begin
  Result := m_pOleObject.QueryInterface(IDispatch, disp);
end;
//==============================================================================

//==============================================================================
// IOleControlSite.TransformCoords
function TTransparentFlashPlayerControl.TransformCoords(var ptlHimetric: TPoint; var ptfContainer: TPointF; flags: Longint): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleControlSite.TranslateAccelerator
function TTransparentFlashPlayerControl.TranslateAccelerator(msg: PMsg; grfModifiers: Longint): HResult; stdcall;
begin
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleControlSite.OnFocus
function TTransparentFlashPlayerControl.OnFocus(fGotFocus: BOOL): HResult; stdcall;
begin
  m_bHaveFocus := fGotFocus;
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IOleControlSite.ShowPropertyFrame
function TTransparentFlashPlayerControl.ShowPropertyFrame: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleContainer.EnumObjects
function TTransparentFlashPlayerControl.EnumObjects(grfFlags: Longint; out Enum: IEnumUnknown): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
// IOleContainer.LockContainer
function TTransparentFlashPlayerControl.LockContainer(fLock: BOOL): HResult; stdcall;
begin
  m_bLocked := fLock;
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
// IParseDisplayName.ParseDisplayName
function TTransparentFlashPlayerControl.ParseDisplayName(const bc: IBindCtx; pszDisplayName: POleStr; out chEaten: Longint; out mkOut: IMoniker): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

{ TTransparentFlashPlayerControl.IOleInPlaceUIWindow }

function TTransparentFlashPlayerControl.GetBorder(out rectBorder: TRect): HResult;
begin
  Result := INPLACE_E_NOTOOLSPACE;
end;

function TTransparentFlashPlayerControl.RequestBorderSpace(const borderwidths: TRect): HResult;
begin
  Result := INPLACE_E_NOTOOLSPACE;
end;

function TTransparentFlashPlayerControl.SetBorderSpace(pborderwidths: PRect): HResult;
begin
  Result := E_NOTIMPL;
end;

function TTransparentFlashPlayerControl.SetActiveObject(const activeObject: IOleInPlaceActiveObject;
  pszObjName: POleStr): HResult;
begin
  Result := S_OK;
end;

{ TTransparentFlashPlayerControl.IOleInPlaceFrame }

(*
function TTransparentFlashPlayerControl.OleInPlaceFrame_GetWindow(out wnd: HWnd): HResult;
begin
  wnd := Parent.Handle;
  Result := S_OK;
end;
*)

function TTransparentFlashPlayerControl.InsertMenus(hmenuShared: HMenu;
  var menuWidths: TOleMenuGroupWidths): HResult;
begin
  Result := S_OK;
end;

function TTransparentFlashPlayerControl.SetMenu(hmenuShared: HMenu; holemenu: HMenu;
  hwndActiveObject: HWnd): HResult;
begin
  Result := S_OK;
end;

function TTransparentFlashPlayerControl.RemoveMenus(hmenuShared: HMenu): HResult;
begin
  while GetMenuItemCount(hmenuShared) > 0 do
    RemoveMenu(hmenuShared, 0, MF_BYPOSITION);
  Result := S_OK;
end;

function TTransparentFlashPlayerControl.SetStatusText(pszStatusText: POleStr): HResult;
begin
  Result := S_OK;
end;

function TTransparentFlashPlayerControl.EnableModeless(fEnable: BOOL): HResult;
begin
  Result := S_OK;
end;

function TTransparentFlashPlayerControl.OleInPlaceFrame_TranslateAccelerator(var msg: TMsg; wID: Word): HResult;
begin
  Result := S_FALSE;
end;

//==============================================================================
function TTransparentFlashPlayerControl.CreateFrameBitmap: TBitmap;
var
  hOldBitmap: HGDIOBJ;
  hdcMem: HDC;
  hdcScreen: HDC;
  rc: TRect;
  hBrushWhite, hBrushBlack: HBRUSH;
  bitmap_info: TBitmapInfo;
  i: Cardinal;
  Alpha: Integer;
  ColorWhite, ColorBlack: DWORD;
  nWidth, nHeight: Integer;
  rcClientRect, rcUpdateRect: TRect;
  dwStartTime: DWORD;
  X, Y, nDelta: DWORD;
  pCurBitsWhite, pCurBitsBlack, pCurBits: PDWORD;
  pBitsWhite: Pointer;
  pBitsBlack: Pointer;
  pBits: Pointer;
  hBmpWhite: HBITMAP;
  hBmpBlack: HBITMAP;
  hBmp: HBITMAP;
begin
    rc := Rect(0, 0, Width, Height);

    rcUpdateRect := rc;
//    GetUpdateRect(Parent.Handle, rcUpdateRect, FALSE);

    rcClientRect := Rect(0, 0, Width, Height);

    hdcScreen := CreateDC('DISPLAY', nil, nil, nil);

    hdcMem := CreateCompatibleDC(hdcScreen);

    nWidth := rc.right - rc.left;
    nHeight := rc.bottom - rc.top;

    ZeroMemory(@bitmap_info, sizeof(bitmap_info));
    bitmap_info.bmiHeader.biSize := sizeof(bitmap_info.bmiHeader);
    bitmap_info.bmiHeader.biWidth := nWidth;
    bitmap_info.bmiHeader.biHeight := nHeight;
    bitmap_info.bmiHeader.biPlanes := 1;
    bitmap_info.bmiHeader.biBitCount := 32;

    hBmpWhite := CreateDIBSection(hdcMem, bitmap_info, DIB_RGB_COLORS, pBitsWhite, 0, 0);
    hBmpBlack := CreateDIBSection(hdcMem, bitmap_info, DIB_RGB_COLORS, pBitsBlack, 0, 0);
    hBmp := CreateDIBSection(hdcMem, bitmap_info, DIB_RGB_COLORS, pBits, 0, 0);

    hOldBitmap := SelectObject(hdcMem, hBmpWhite);
    hBrushWhite := CreateSolidBrush(RGB($ff, $ff, $ff));
    FillRect(hdcMem, rc, hBrushWhite);
    DeleteObject(hBrushWhite);

    // Отрисовываем на полность?белу?картинку => получаем цвет?картинки
    m_pViewObject.Draw(DVASPECT_CONTENT, -1, nil, nil, 0, hdcMem, @rc, nil, nil, 0);

    SelectObject(hdcMem, hBmpBlack);
    hBrushBlack := CreateSolidBrush(RGB($00, $00, $00));
    FillRect(hdcMem, rc, hBrushBlack);
    DeleteObject(hBrushBlack);

    // Отрисовываем на полность?черную картинку - чтоб?вычислит?значение альф?
    m_pViewObject.Draw(DVASPECT_CONTENT, -1, nil, nil, 0, hdcMem, @rc, nil, nil, 0);

    dwStartTime := GetTickCount();

    X := rcUpdateRect.left;
		Y := rcUpdateRect.top;
		i := nWidth * (rcClientRect.bottom - 1 - Y) + X;
		nDelta :=
						(nWidth * (rcClientRect.bottom - 1) + rcUpdateRect.left) -
						(nWidth * (rcClientRect.bottom - 0) + (rcUpdateRect.right - 1) ) - 1;
    pCurBitsWhite := PDWORD(Cardinal(pBitsWhite) + i * sizeof(DWORD));
    pCurBitsBlack := PDWORD(Cardinal(pBitsBlack) + i * sizeof(DWORD));
    pCurBits := PDWORD(Cardinal(pBits) + i * sizeof(DWORD));

    while Y < rcUpdateRect.bottom do
    begin

        X := rcUpdateRect.left;

        while X < rcUpdateRect.right do
        begin
            ColorWhite := pCurBitsWhite^;
            ColorBlack := pCurBitsBlack^;
						Alpha := (ColorWhite and $000000ff) - (ColorBlack and $000000ff);
						Alpha := not Alpha;

						pCurBits^ := (Alpha shl 24) + (ColorBlack and $00ffffff);

            Inc(X);
            // Inc(i);
            Inc(pCurBits);
            Inc(pCurBitsWhite);
            Inc(pCurBitsBlack);
        end;

        Inc(Y);
        // i := i + nDelta;
        pCurBitsBlack := PDWORD(Cardinal(pCurBitsBlack) + nDelta * sizeof(DWORD));
        pCurBitsWhite := PDWORD(Cardinal(pCurBitsWhite) + nDelta * sizeof(DWORD));
        pCurBits := PDWORD(Cardinal(pCurBits) + nDelta * sizeof(DWORD));
    end;

    MyOutputDebugString(PChar(Format('%d ms', [ GetTickCount() - dwStartTime ])));

    SelectObject(hdcMem, hOldBitmap);

    WinApi.Windows.DeleteDC(hdcMem);
    WinApi.Windows.DeleteDC(hdcScreen);

    WinApi.Windows.DeleteObject(hBmpBlack);
    WinApi.Windows.DeleteObject(hBmpWhite);

    Result := TBitmap.Create;
    Result.Handle := hBmp;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.InternalGetFlashVersion: integer;
begin
  if m_pUnknown = nil then
    Result := -1
  else
    Result := LOBYTE(HIWORD(FlashVersion));

  if Result >= 8 then Result := 8;
end;
//==============================================================================

///-----------------------------------------------------------------------------
procedure TTransparentFlashPlayerControl.SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer);
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).SetZoomRect(left, top, right, bottom);
end;

procedure TTransparentFlashPlayerControl.Zoom(factor: SYSINT);
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).Zoom(factor);
end;

procedure TTransparentFlashPlayerControl.Pan(x: Integer; y: Integer; mode: SYSINT);
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).Pan(x, y, mode);
end;

procedure TTransparentFlashPlayerControl.Play;
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).Play;
end;

procedure TTransparentFlashPlayerControl.Stop;
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).Stop;
end;

procedure TTransparentFlashPlayerControl.Back;
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).Back;
end;

procedure TTransparentFlashPlayerControl.Forward;
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).Forward;
end;

procedure TTransparentFlashPlayerControl.Rewind;
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).Rewind;
end;

procedure TTransparentFlashPlayerControl.StopPlay;
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).StopPlay;
end;

procedure TTransparentFlashPlayerControl.GotoFrame(FrameNum: Integer);
begin
  if (InternalGetFlashVersion >= 3) then
     (m_pUnknown As IShockwaveFlash3).GotoFrame(FrameNum);
end;

function TTransparentFlashPlayerControl.CurrentFrame: Integer;
begin
  Result := 0;

  if (InternalGetFlashVersion >= 3) then
     Result := (m_pUnknown As IShockwaveFlash3).CurrentFrame;
end;

function TTransparentFlashPlayerControl.IsPlaying: WordBool;
begin
  Result := WordBool(-1);

  if (InternalGetFlashVersion >= 3) then
     Result := (m_pUnknown As IShockwaveFlash3).IsPlaying;
end;

function TTransparentFlashPlayerControl.PercentLoaded: Integer;
begin
  Result := 0;

  if (InternalGetFlashVersion >= 3) then
     Result := (m_pUnknown As IShockwaveFlash3).PercentLoaded;
end;

function TTransparentFlashPlayerControl.FrameLoaded(FrameNum: Integer): WordBool;
begin
  Result := WordBool(-1);

  if (InternalGetFlashVersion >= 3) then
     Result := (m_pUnknown As IShockwaveFlash3).FrameLoaded(FrameNum);
end;

function TTransparentFlashPlayerControl.FlashVersion: Integer;
begin
   Result := (m_pUnknown As IShockwaveFlash3).FlashVersion;
end;

procedure TTransparentFlashPlayerControl.LoadMovie(layer: SYSINT; const url: WideString);
begin
  try
    if (InternalGetFlashVersion >= 3) then
      (m_pUnknown As IShockwaveFlash3).LoadMovie(layer, url);
  except
    on Exception do;
  end;
end;

procedure TTransparentFlashPlayerControl.TGotoFrame(const target: WideString; FrameNum: Integer);
begin
  if (InternalGetFlashVersion >= 3) then
    (m_pUnknown As IShockwaveFlash3).TGotoFrame(target, FrameNum);
end;

procedure TTransparentFlashPlayerControl.TGotoLabel(const target: WideString; const label_: WideString);
begin
  if (InternalGetFlashVersion >= 3) then
    (m_pUnknown As IShockwaveFlash3).TGotoLabel(target, label_);
end;

function TTransparentFlashPlayerControl.TCurrentFrame(const target: WideString): Integer;
begin
  Result := 0;

  if (InternalGetFlashVersion >= 3) then
    Result := (m_pUnknown As IShockwaveFlash3).TCurrentFrame(target);
end;

function TTransparentFlashPlayerControl.TCurrentLabel(const target: WideString): WideString;
begin
  Result := '';

  if (InternalGetFlashVersion >= 3) then
    Result := (m_pUnknown As IShockwaveFlash3).TCurrentLabel(target);
end;

procedure TTransparentFlashPlayerControl.TPlay(const target: WideString);
begin
  if (InternalGetFlashVersion >= 3) then
    (m_pUnknown As IShockwaveFlash3).TPlay(target);
end;

procedure TTransparentFlashPlayerControl.TStopPlay(const target: WideString);
begin
  if (InternalGetFlashVersion >= 3) then
    (m_pUnknown As IShockwaveFlash3).TStopPlay(target);
end;

procedure TTransparentFlashPlayerControl.SetVariable(const name: WideString; const value: WideString);
begin
  if (InternalGetFlashVersion >= 4) then
    (m_pUnknown As IShockwaveFlash4).SetVariable(name, value);
end;

function TTransparentFlashPlayerControl.GetVariable(const name: WideString): WideString;
begin
  Result := '';

  if (InternalGetFlashVersion >= 4) then
    Result := (m_pUnknown As IShockwaveFlash4).GetVariable(name);
end;

procedure TTransparentFlashPlayerControl.TSetProperty(const target: WideString; property_: SYSINT;
                                       const value: WideString);
begin
  if (InternalGetFlashVersion >= 4) then
    (m_pUnknown As IShockwaveFlash4).TSetProperty(target, property_, value);
end;

function TTransparentFlashPlayerControl.TGetProperty(const target: WideString; property_: SYSINT): WideString;
begin
  Result := '';

  if (InternalGetFlashVersion >= 4) then
    Result := (m_pUnknown As IShockwaveFlash4).TGetProperty(target, property_);
end;

procedure TTransparentFlashPlayerControl.TCallFrame(const target: WideString; FrameNum: SYSINT);
begin
  if (InternalGetFlashVersion >= 4) then
    (m_pUnknown As IShockwaveFlash4).TCallFrame(target, FrameNum);
end;

procedure TTransparentFlashPlayerControl.TCallLabel(const target: WideString; const label_: WideString);
begin
  if (InternalGetFlashVersion >= 4) then
    (m_pUnknown As IShockwaveFlash4).TCallLabel(target, label_);
end;

procedure TTransparentFlashPlayerControl.TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double);
begin
  if (InternalGetFlashVersion >= 4) then
    (m_pUnknown As IShockwaveFlash4).TSetPropertyNum(target, property_, value);
end;

function TTransparentFlashPlayerControl.TGetPropertyNum(const target: WideString; property_: SYSINT): Double;
begin
  Result := 0;

  if (InternalGetFlashVersion >= 4) then
    Result := (m_pUnknown As IShockwaveFlash4).TGetPropertyNum(target, property_);
end;

function TTransparentFlashPlayerControl.TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double;
begin
  Result := 0;

  if (InternalGetFlashVersion = 7) then
    Result := (m_pUnknown As IShockwaveFlash7).TGetPropertyAsNumber(target, property_);

  if (InternalGetFlashVersion = 8) then
    Result := (m_pUnknown As IShockwaveFlash8).TGetPropertyAsNumber(target, property_);
end;

function TTransparentFlashPlayerControl.CallFunction(const request: WideString): WideString;
begin
  Result := '';

  if (InternalGetFlashVersion = 8) then
    Result := (m_pUnknown As IShockwaveFlash8).CallFunction(request);
end;

procedure TTransparentFlashPlayerControl.SetReturnValue(const returnValue: WideString);
begin
  if (InternalGetFlashVersion = 8) then
    (m_pUnknown As IShockwaveFlash8).SetReturnValue(returnValue);
end;
///-----------------------------------------------------------------------------

{ Functions implementation...BEGIN }

// Property: ReadyState
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetReadyState: Integer;
begin
    Result := FReadyState;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).ReadyState;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).ReadyState;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).ReadyState;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).ReadyState;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).ReadyState;
    end;
except on E: Exception do;
end;
end;

// Property: TotalFrames
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetTotalFrames: Integer;
begin
    Result := FTotalFrames;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).TotalFrames;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).TotalFrames;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).TotalFrames;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).TotalFrames;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).TotalFrames;
    end;
except on E: Exception do;
end;
end;

// Property: Movie
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetMovie: WideString;
begin
    Result := FMovie;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).Movie;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).Movie;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).Movie;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).Movie;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).Movie;
    end;
except on E: Exception do;
end;
end;

// Property: Movie
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutMovie(NewMovie: WideString);
begin
try
    FMovie := NewMovie;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).Movie := NewMovie;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).Movie := NewMovie;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).Movie := NewMovie;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).Movie := NewMovie;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).Movie := NewMovie;
    end;

{
    if (csDesigning in ComponentState) then
    begin
      Playing := True;
      Stop;
    end;
}

except on E: Exception do;
end;
end;

// Property: FrameNum
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetFrameNum: Integer;
begin
    Result := FFrameNum;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).FrameNum;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).FrameNum;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).FrameNum;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).FrameNum;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).FrameNum;
    end;
except on E: Exception do;
end;
end;

// Property: FrameNum
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutFrameNum(NewFrameNum: Integer);
begin
try
   FFrameNum := NewFrameNum;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).FrameNum := NewFrameNum;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).FrameNum := NewFrameNum;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).FrameNum := NewFrameNum;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).FrameNum := NewFrameNum;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).FrameNum := NewFrameNum;
    end;
except on E: Exception do;
end;
end;

// Property: Playing
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetPlaying: WordBool;
begin
    Result := FPlaying;
try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).Playing;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).Playing;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).Playing;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).Playing;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).Playing;
    end;
except on E: Exception do;
end;
end;

// Property: Playing
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutPlaying(NewPlaying: WordBool);
begin
try
    ///
    if NewPlaying then NewPlaying := WordBool(-1) else NewPlaying := WordBool(0);
    ///

    FPlaying := NewPlaying;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).Playing := NewPlaying;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).Playing := NewPlaying;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).Playing := NewPlaying;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).Playing := NewPlaying;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).Playing := NewPlaying;
    end;
except on E: Exception do;
end;
end;

// Property: Quality
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetQuality: Integer;
begin
    Result := FQuality;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).Quality;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).Quality;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).Quality;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).Quality;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).Quality;
    end;
except on E: Exception do;
end;
end;

// Property: Quality
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutQuality(NewQuality: Integer);
begin
try
    FQuality := NewQuality;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).Quality := NewQuality;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).Quality := NewQuality;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).Quality := NewQuality;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).Quality := NewQuality;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).Quality := NewQuality;
    end;
except on E: Exception do;
end;
end;

// Property: ScaleMode
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetScaleMode: Integer;
begin
    Result := FScaleMode;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).ScaleMode;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).ScaleMode;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).ScaleMode;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).ScaleMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).ScaleMode;
    end;
except on E: Exception do;
end;
end;

// Property: ScaleMode
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutScaleMode(NewScaleMode: Integer);
begin
try
    FScaleMode := NewScaleMode;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).ScaleMode := NewScaleMode;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).ScaleMode := NewScaleMode;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).ScaleMode := NewScaleMode;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).ScaleMode := NewScaleMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).ScaleMode := NewScaleMode;
    end;
except on E: Exception do;
end;
end;

// Property: AlignMode
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetAlignMode: Integer;
begin
    Result := FAlignMode;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).AlignMode;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).AlignMode;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).AlignMode;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).AlignMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).AlignMode;
    end;
except on E: Exception do;
end;
end;

// Property: AlignMode
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutAlignMode(NewAlignMode: Integer);
begin
try
    FAlignMode := NewAlignMode;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).AlignMode := NewAlignMode;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).AlignMode := NewAlignMode;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).AlignMode := NewAlignMode;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).AlignMode := NewAlignMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).AlignMode := NewAlignMode;
    end;
except on E: Exception do;
end;
end;

// Property: BackgroundColor
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetBackgroundColor: Integer;
begin
    Result := FBackgroundColor;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).BackgroundColor;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).BackgroundColor;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).BackgroundColor;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).BackgroundColor;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).BackgroundColor;
    end;
except on E: Exception do;
end;
end;

// Property: BackgroundColor
// Type: Integer
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutBackgroundColor(NewBackgroundColor: Integer);
begin
try
    FBackgroundColor := NewBackgroundColor;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).BackgroundColor := NewBackgroundColor;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).BackgroundColor := NewBackgroundColor;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).BackgroundColor := NewBackgroundColor;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).BackgroundColor := NewBackgroundColor;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).BackgroundColor := NewBackgroundColor;
    end;
except on E: Exception do;
end;
end;

// Property: Loop
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetLoop: WordBool;
begin
    Result := FLoop;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).Loop;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).Loop;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).Loop;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).Loop;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).Loop;
    end;
except on E: Exception do;
end;
end;

// Property: Loop
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutLoop(NewLoop: WordBool);
begin
try

    ///
    if NewLoop then NewLoop := WordBool(-1) else NewLoop := WordBool(0);
    ///

    FLoop := NewLoop;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).Loop := NewLoop;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).Loop := NewLoop;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).Loop := NewLoop;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).Loop := NewLoop;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).Loop := NewLoop;
    end;
except on E: Exception do;
end;
end;

// Property: WMode
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetWMode: WideString;
begin
    Result := FWMode;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).WMode;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).WMode;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).WMode;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).WMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).WMode;
    end;
except on E: Exception do;
end;
end;

// Property: WMode
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutWMode(NewWMode: WideString);
begin
try
    FWMode := NewWMode;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).WMode := NewWMode;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).WMode := NewWMode;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).WMode := NewWMode;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).WMode := NewWMode;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).WMode := NewWMode;
    end;
except on E: Exception do;
end;
end;

// Property: SAlign
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetSAlign: WideString;
begin
    Result := FSAlign;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).SAlign;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).SAlign;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).SAlign;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).SAlign;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).SAlign;
    end;
except on E: Exception do;
end;
end;

// Property: SAlign
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutSAlign(NewSAlign: WideString);
begin
try
    FSAlign := NewSAlign;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).SAlign := NewSAlign;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).SAlign := NewSAlign;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).SAlign := NewSAlign;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).SAlign := NewSAlign;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).SAlign := NewSAlign;
    end;
except on E: Exception do;
end;
end;

// Property: Menu
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetMenu: WordBool;
begin
    Result := FMenu;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).Menu;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).Menu;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).Menu;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).Menu;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).Menu;
    end;
except on E: Exception do;
end;
end;

// Property: Menu
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutMenu(NewMenu: WordBool);
begin
try
    ///
    if NewMenu then NewMenu := WordBool(-1) else NewMenu := WordBool(0);
    ///

    FMenu := NewMenu;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).Menu := NewMenu;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).Menu := NewMenu;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).Menu := NewMenu;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).Menu := NewMenu;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).Menu := NewMenu;
    end;
except on E: Exception do;
end;
end;

// Property: Base
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetBase: WideString;
begin
    Result := FBase;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).Base;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).Base;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).Base;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).Base;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).Base;
    end;
except on E: Exception do;
end;
end;

// Property: Base
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutBase(NewBase: WideString);
begin
try
    FBase := NewBase;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).Base := NewBase;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).Base := NewBase;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).Base := NewBase;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).Base := NewBase;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).Base := NewBase;
    end;
except on E: Exception do;
end;
end;

// Property: Scale
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetScale: WideString;
begin
    Result := FScale;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).Scale;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).Scale;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).Scale;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).Scale;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).Scale;
    end;
except on E: Exception do;
end;
end;

// Property: Scale
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutScale(NewScale: WideString);
begin
try
    FScale := NewScale;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).Scale := NewScale;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).Scale := NewScale;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).Scale := NewScale;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).Scale := NewScale;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).Scale := NewScale;
    end;
except on E: Exception do;
end;
end;

// Property: DeviceFont
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetDeviceFont: WordBool;
begin
    Result := FDeviceFont;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).DeviceFont;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).DeviceFont;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).DeviceFont;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).DeviceFont;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).DeviceFont;
    end;
except on E: Exception do;
end;
end;

// Property: DeviceFont
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutDeviceFont(NewDeviceFont: WordBool);
begin
try

    ///
    if NewDeviceFont then NewDeviceFont := WordBool(-1) else NewDeviceFont := WordBool(0);
    ///

    FDeviceFont := NewDeviceFont;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).DeviceFont := NewDeviceFont;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).DeviceFont := NewDeviceFont;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).DeviceFont := NewDeviceFont;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).DeviceFont := NewDeviceFont;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).DeviceFont := NewDeviceFont;
    end;
except on E: Exception do;
end;
end;

// Property: EmbedMovie
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetEmbedMovie: WordBool;
begin
    Result := FEmbedMovie;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).EmbedMovie;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).EmbedMovie;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).EmbedMovie;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).EmbedMovie;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).EmbedMovie;
    end;
except on E: Exception do;
end;
end;

// Property: EmbedMovie
// Type: WordBool
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutEmbedMovie(NewEmbedMovie: WordBool);
begin
try

    ///
    if NewEmbedMovie then NewEmbedMovie := WordBool(-1) else NewEmbedMovie := WordBool(0);
    ///

    FEmbedMovie := NewEmbedMovie;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).EmbedMovie := NewEmbedMovie;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).EmbedMovie := NewEmbedMovie;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).EmbedMovie := NewEmbedMovie;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).EmbedMovie := NewEmbedMovie;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).EmbedMovie := NewEmbedMovie;
    end;
except on E: Exception do;
end;
end;

// Property: BGColor
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetBGColor: WideString;
begin
    Result := FBGColor;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).BGColor;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).BGColor;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).BGColor;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).BGColor;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).BGColor;
    end;
except on E: Exception do;
end;
end;

// Property: BGColor
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutBGColor(NewBGColor: WideString);
begin
try
    FBGColor := NewBGColor;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).BGColor := NewBGColor;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).BGColor := NewBGColor;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).BGColor := NewBGColor;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).BGColor := NewBGColor;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).BGColor := NewBGColor;
    end;
except on E: Exception do;
end;
end;

// Property: Quality2
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
function TTransparentFlashPlayerControl.GetQuality2: WideString;
begin
    Result := FQuality2;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            Result := (m_pUnknown As IShockwaveFlash3).Quality2;
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).Quality2;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).Quality2;
        if InternalGetFlashVersion = 6 then
            Result := (m_pUnknown As IShockwaveFlash6).Quality2;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).Quality2;
    end;
except on E: Exception do;
end;
end;

// Property: Quality2
// Type: WideString
// Flash versions: 3, 4, 5, 6, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutQuality2(NewQuality2: WideString);
begin
try
    FQuality2 := NewQuality2;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 3 then
            (m_pUnknown As IShockwaveFlash3).Quality2 := NewQuality2;
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).Quality2 := NewQuality2;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).Quality2 := NewQuality2;
        if InternalGetFlashVersion = 6 then
            (m_pUnknown As IShockwaveFlash6).Quality2 := NewQuality2;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).Quality2 := NewQuality2;
    end;
except on E: Exception do;
end;
end;

// Property: SWRemote
// Type: WideString
// Flash versions: 4, 5, 7, 8, 9
function TTransparentFlashPlayerControl.GetSWRemote: WideString;
begin
    Result := FSWRemote;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 4 then
            Result := (m_pUnknown As IShockwaveFlash4).SWRemote;
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).SWRemote;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).SWRemote;
    end;
except on E: Exception do;
end;
end;

// Property: SWRemote
// Type: WideString
// Flash versions: 4, 5, 7, 8, 9
procedure TTransparentFlashPlayerControl.PutSWRemote(NewSWRemote: WideString);
begin
try
    FSWRemote := NewSWRemote;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 4 then
            (m_pUnknown As IShockwaveFlash4).SWRemote := NewSWRemote;
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).SWRemote := NewSWRemote;
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).SWRemote := NewSWRemote;
    end;
except on E: Exception do;
end;
end;

// Property: Stacking
// Type: WideString
// Flash versions: 5
function TTransparentFlashPlayerControl.GetStacking: WideString;
begin
    Result := FStacking;

try
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 5 then
            Result := (m_pUnknown As IShockwaveFlash5).Stacking;
    end;
except on E: Exception do;
end;
end;

// Property: Stacking
// Type: WideString
// Flash versions: 5
procedure TTransparentFlashPlayerControl.PutStacking(NewStacking: WideString);
begin
try
    FStacking := NewStacking;
    if nil <> m_pUnknown then
    begin
        if InternalGetFlashVersion = 5 then
            (m_pUnknown As IShockwaveFlash5).Stacking := NewStacking;
    end;
except on E: Exception do;
end;
end;

// Property: FlashVars
// Type: WideString
// Flash versions: 7, 8, 9
function TTransparentFlashPlayerControl.GetFlashVars: WideString;
begin
    Result := FFlashVars;

try
    if nil <> m_pUnknown then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).FlashVars;
    end;
except on E: Exception do;
end;
end;

// Property: FlashVars
// Type: WideString
// Flash versions: 7, 8, 9
procedure TTransparentFlashPlayerControl.PutFlashVars(NewFlashVars: WideString);
begin
try
    FFlashVars := NewFlashVars;
    if nil <> m_pUnknown then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).FlashVars := NewFlashVars;
    end;
except on E: Exception do;
end;
end;

// Property: AllowScriptAccess
// Type: WideString
// Flash versions: 7, 8, 9
function TTransparentFlashPlayerControl.GetAllowScriptAccess: WideString;
begin
    Result := FAllowScriptAccess;

try
    if nil <> m_pUnknown then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).AllowScriptAccess;
    end;
except on E: Exception do;
end;
end;

// Property: AllowScriptAccess
// Type: WideString
// Flash versions: 7, 8, 9
procedure TTransparentFlashPlayerControl.PutAllowScriptAccess(NewAllowScriptAccess: WideString);
begin
try
    FAllowScriptAccess := NewAllowScriptAccess;
    if nil <> m_pUnknown then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).AllowScriptAccess := NewAllowScriptAccess;
    end;
except on E: Exception do;
end;
end;

// Property: MovieData
// Type: WideString
// Flash versions: 7, 8, 9
function TTransparentFlashPlayerControl.GetMovieData: WideString;
begin
    Result := FMovieData;

try
    if nil <> m_pUnknown then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            Result := (m_pUnknown As IShockwaveFlash7).MovieData;
    end;
except on E: Exception do;
end;
end;

// Property: MovieData
// Type: WideString
// Flash versions: 7, 8, 9
procedure TTransparentFlashPlayerControl.PutMovieData(NewMovieData: WideString);
begin
try
    FMovieData := NewMovieData;
    if nil <> m_pUnknown then
    begin
        if ((InternalGetFlashVersion = 7) or (InternalGetFlashVersion = 8)) then
            (m_pUnknown As IShockwaveFlash7).MovieData := NewMovieData;
    end;
except on E: Exception do;
end;
end;

// Property: AllowFullscreen
// Type: WordBool
// Flash versions: 9.0.28.0
function TTransparentFlashPlayerControl.GetAllowFullscreen: WordBool;
begin
    Result := FAllowFullscreen;

try
    if nil <> m_pUnknown then
    begin
        if (GetUsingFlashVersion >= GetMinimumFlashVersionToAllowFullscreen) then
          if (m_pUnknown As IShockwaveFlash_9_0_28_0).Get_AllowFullscreen = 'true' then
            Result := true
          else
            Result := false;
    end;
except on E: Exception do;
end;
end;

// Property: AllowFullscreen
// Type: WordBool
// Flash versions: 9.0.28.0
procedure TTransparentFlashPlayerControl.PutAllowFullscreen(bAllowFullscreen: WordBool);
begin
try
    FAllowFullscreen := bAllowFullscreen;
    if nil <> m_pUnknown then
    begin
        if (GetUsingFlashVersion >= GetMinimumFlashVersionToAllowFullscreen) then
        begin
          if bAllowFullscreen then
            (m_pUnknown As IShockwaveFlash_9_0_28_0).Set_AllowFullscreen('true')
          else
            (m_pUnknown As IShockwaveFlash_9_0_28_0).Set_AllowFullscreen('false');
        end;
    end;
except on E: Exception do;
end;
end;

{ Functions implementation...END }

procedure TTransparentFlashPlayerControl.PutMovieFromStream(AStream: TStream);
begin
  g_ContentManager.LoadMovieFromMemory(Self, FALSE, -1, AStream);
end;

procedure TTransparentFlashPlayerControl.LoadMovieFromStream(layer: integer; AStream: TStream);
begin
  g_ContentManager.LoadMovieFromMemory(Self, TRUE, layer, AStream);
end;

procedure TTransparentFlashPlayerControl.PutMovieUsingStream(out AStream: TStream);
begin
  g_ContentManager.LoadMovieUsingStream(Self, FALSE, -1, AStream);
end;

procedure TTransparentFlashPlayerControl.LoadMovieUsingStream(layer: integer; out AStream: TStream);
begin
  g_ContentManager.LoadMovieUsingStream(Self, TRUE, layer, AStream);
end;

//==============================================================================
function TTransparentFlashPlayerControl.IFlashPlayerControlBase_PutMovie(NewMovie: WideString): HResult; stdcall;
begin
  PutMovie(NewMovie);
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.IFlashPlayerControlBase_LoadMovie(Layer: Integer; const url: WideString): HResult; stdcall;
begin
  LoadMovie(Layer, url);
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.IFlashPlayerControlBase_GetBase(var { out } url: WideString): HResult; stdcall;
begin
  url := Base;
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.IFlashPlayerControlBase_CallOnLoadExternalResource(const URL: WideString; Stream: TStream): HResult; stdcall;
begin
  if Assigned(OnLoadExternalResource) then
  begin
    OnLoadExternalResource(Self, URL, Stream);
    Result := S_OK;
  end
  else
    Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.IFlashPlayerControlBase_CallOnLoadExternalResourceAsync(const Path: WideString; out Stream: TStream): HResult; stdcall;
begin
  if Assigned(OnLoadExternalResourceAsync) then
  begin
{$IFNDEF DEF_BUILDER}
    OnLoadExternalResourceAsync(Self, Path, Stream);
{$ENDIF}
{$IFDEF DEF_BUILDER}
    OnLoadExternalResourceAsync(Self, Path, @Stream);
{$ENDIF}
    Result := S_OK;
  end
  else
    Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.IFlashPlayerControlBase_CallOnUnloadExternalResourceAsync(Stream: TStream): HResult; stdcall;
begin
  if Assigned(OnUnloadExternalResourceAsync) then
  begin
    OnUnloadExternalResourceAsync(Self, Stream);
    Result := S_OK;
  end
  else
    Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.IFlashPlayerControlBase_CallOnLoadExternalResourceEx(const URL: WideString; Stream: TStream; out bHandled: Boolean): HResult; stdcall;
begin
  if Assigned(OnLoadExternalResourceEx) then
  begin
{$IFNDEF DEF_BUILDER}
    OnLoadExternalResourceEx(Self, URL, Stream, bHandled);
{$ENDIF}
{$IFDEF DEF_BUILDER}
    OnLoadExternalResourceEx(Self, URL, Stream, @bHandled);
{$ENDIF}
    Result := S_OK;
  end
  else
    Result := S_FALSE;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Count := 0;
  Result := S_OK;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Pointer(TypeInfo) := nil;
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;
//==============================================================================

//==============================================================================
function TTransparentFlashPlayerControl.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
var
  Request: WideString;
begin
  Result := DISP_E_MEMBERNOTFOUND;

  case DispId of
    -609:
      begin
        if Assigned(FOnReadyStateChange) then
          FOnReadyStateChange(Self, PDispParams(@Params).rgvarg[0].lVal);
        Result := S_OK;
      end;
    $000007a6:
      begin
        if Assigned(FOnProgress) then
          FOnProgress(Self, PDispParams(@Params).rgvarg[0].lVal);
        Result := S_OK;
      end;
    $00000096:
      begin
        if Assigned(FOnFSCommand) then
          FOnFSCommand(Self, PDispParams(@Params).rgvarg[1].bstrVal, PDispParams(@Params).rgvarg[0].bstrVal);
        Result := S_OK;
      end;
    $000000c5:
      begin
        if Assigned(FOnFlashCall) then
        begin
          Request := PDispParams(@Params).rgvarg[0].bstrVal;

          if FindSubstringInWideString('{8533542B-B75B-417a-A972-3AD945F14852}', Request) <> 0 then
             SetReturnValue('<string>{242DF42C-A9ED-4209-B1E2-FD3633BAEEE7}</string>')
          else
             FOnFlashCall(Self, PDispParams(@Params).rgvarg[0].bstrVal);

// if (ExternalInterface.call("{8533542B-B75B-417a-A972-3AD945F14852}") != "{242DF42C-A9ED-4209-B1E2-FD3633BAEEE7}")

        end;
        Result := S_OK;
      end;
  end;
end;
//==============================================================================

// TTransparentFlashPlayerControl implementation...END
//==============================================================================

procedure Register;
begin
  RegisterComponents('Flash', [TFlashPlayerControl]);
  //RegisterComponents('Flash', [TTransparentFlashPlayerControl]);
end;

procedure LoadFlashOCXCodeFromStream(const AStream: TStream);
begin
  g_FlashOCXCodeProvider.Free;
  g_FlashOCXCodeProvider := nil;
  g_FlashOCXCodeProvider := TFlashOCXCodeProviderBasedOnStream.Create(AStream);
end;

type
  VS_FIXEDFILEINFO = packed record
    dwSignature: DWORD;        { e.g. $feef04bd }
    dwStrucVersion: DWORD;     { e.g. $00000042 = "0.42" }
    dwFileVersionMS: DWORD;    { e.g. $00030075 = "3.75" }
    dwFileVersionLS: DWORD;    { e.g. $00000031 = "0.31" }
    dwProductVersionMS: DWORD; { e.g. $00030010 = "3.10" }
    dwProductVersionLS: DWORD; { e.g. $00000031 = "0.31" }
    dwFileFlagsMask: DWORD;    { = $3F for version "0.42" }
    dwFileFlags: DWORD;        { e.g. VFF_DEBUG | VFF_PRERELEASE }
    dwFileOS: DWORD;           { e.g. VOS_DOS_WINDOWS16 }
    dwFileType: DWORD;         { e.g. VFT_DRIVER }
    dwFileSubtype: DWORD;      { e.g. VFT2_DRV_KEYBOARD }
    dwFileDateMS: DWORD;       { e.g. 0 }
    dwFileDateLS: DWORD;       { e.g. 0 }
  end;
  PVS_FIXEDFILEINFO = ^VS_FIXEDFILEINFO;

function GetInstalledFlashVersion: DWORD;
var
  FlashOCXPath: pointer;
  hFlashRegKey: HKEY;
  lRes: LongInt;
  dwBufferSize: DWORD;
  temp: DWORD;
  dwSizeOfVersionInfo: DWORD;
  lpVersionInfoBlock: pointer;
  pFixedFileInfo: pointer { VS_FIXEDFILEINFO };
  dwMinorPart: DWORD;
  dwMajorPart: DWORD;
begin
  Result := 0;
  dwMinorPart := 0;
  dwMajorPart := 0;

  lRes :=
    RegOpenKeyEx(HKEY_CLASSES_ROOT,
                 'CLSID\{D27CDB6E-AE6D-11cf-96B8-444553540000}\InprocServer32',
                 0,
                 KEY_QUERY_VALUE,
                 hFlashRegKey);

  if lRes = ERROR_SUCCESS then
  begin
       dwBufferSize := MAX_PATH;
       FlashOCXPath := VirtualAlloc(nil, dwBufferSize, MEM_COMMIT, PAGE_READWRITE);
       ZeroMemory(pointer(FlashOCXPath), dwBufferSize);

       lRes :=
            RegQueryValueEx(hFlashRegKey,
                            '',
                            nil,
                            nil,
                            PByte(FlashOCXPath),
                            @dwBufferSize);

      if lRes = ERROR_SUCCESS then
      begin
        dwSizeOfVersionInfo := GetFileVersionInfoSizeA(PAnsiChar(FlashOCXPath), temp);

        if dwSizeOfVersionInfo > 0 then
        begin
          lpVersionInfoBlock := VirtualAlloc(nil, dwSizeOfVersionInfo, MEM_COMMIT, PAGE_READWRITE);

          if GetFileVersionInfoA(PAnsiChar(FlashOCXPath), 0, dwSizeOfVersionInfo, lpVersionInfoBlock) then
          begin
            if VerQueryValue(lpVersionInfoBlock, '\', pFixedFileInfo, temp) then
            begin
              dwMinorPart := PVS_FIXEDFILEINFO(pFixedFileInfo).dwProductVersionLS;
              dwMajorPart := PVS_FIXEDFILEINFO(pFixedFileInfo).dwProductVersionMS;
            end;
          end;

          VirtualFree(lpVersionInfoBlock, 0, MEM_RELEASE);
        end;
      end;

      RegCloseKey(hFlashRegKey);

      VirtualFree(FlashOCXPath, 0, MEM_RELEASE);

      Result := HIWORD(dwMajorPart);

      Result := Result shl 8;
      Result := Result + LOWORD(dwMajorPart);

      Result := Result shl 8;
      Result := Result + HIWORD(dwMinorPart);

      Result := Result shl 8;
      Result := Result + LOWORD(dwMinorPart);
  end;
end;

function GetUsingFlashVersion: DWORD;
begin
  if g_FlashOCXCodeProvider <> nil then
    Result := g_FlashOCXCodeProvider.GetVersion
  else
    Result := 0;
end;

function GetMinimumFlashVersionToAllowFullscreen: DWORD;
begin
  Result := $09001C00;
end;

//==============================================================================

//==============================================================================

constructor TStreamBasedOnIStream.Create(const Stream: IStream);
begin
  FStream := Stream;
end;

procedure TStreamBasedOnIStream.SetSize(NewSize: Longint);
begin
  FStream.SetSize(NewSize);
end;

{$IFNDEF DEF_DELPHI3}
{$IFNDEF DEF_DELPHI4}
{$IFNDEF DEF_DELPHI5}
procedure TStreamBasedOnIStream.SetSize(const NewSize: Int64);
begin
  FStream.SetSize(NewSize);
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}

function TStreamBasedOnIStream.Read(var Buffer; Count: Longint): Longint;
begin
  FStream.Read(@Buffer, Count, @Result);
end;

function TStreamBasedOnIStream.Write(const Buffer; Count: Longint): Longint;
begin
  FStream.Write(@Buffer, Count, @Result);
end;

function TStreamBasedOnIStream.Seek(Offset: Longint; Origin: Word): Longint;
var
  Pos: Largeuint;
begin
  FStream.Seek(Offset, Origin, Pos);
  Result := CompAsTwoLongs(Pos).LoL;
end;

//==============================================================================

//==============================================================================
// Urlmon

const
  BSCF_FIRSTDATANOTIFICATION = $00000001;
  BSCF_LASTDATANOTIFICATION = $00000004;

//==============================================================================

//==============================================================================
// TDLLLoader implementation...BEGIN

const

// #define IMAGE_NUMBEROF_DIRECTORY_ENTRIES    16
IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16;

// #define IMAGE_SIZEOF_SHORT_NAME              8
IMAGE_SIZEOF_SHORT_NAME = 8;

// #define IMAGE_DIRECTORY_ENTRY_BASERELOC       5   // Base Relocation Table
IMAGE_DIRECTORY_ENTRY_BASERELOC = 5;

// #define IMAGE_DIRECTORY_ENTRY_IMPORT          1   // Import Directory
IMAGE_DIRECTORY_ENTRY_IMPORT = 1;

// #define IMAGE_ORDINAL_FLAG32 0x80000000
IMAGE_ORDINAL_FLAG32 = $80000000;

// #define IMAGE_DIRECTORY_ENTRY_EXPORT          0   // Export Directory
IMAGE_DIRECTORY_ENTRY_EXPORT = 0;

type

// typedef struct _IMAGE_DOS_HEADER {      // DOS .EXE header
//     WORD   e_magic;                     // Magic number
//     WORD   e_cblp;                      // Bytes on last page of file
//     WORD   e_cp;                        // Pages in file
//     WORD   e_crlc;                      // Relocations
//     WORD   e_cparhdr;                   // Size of header in paragraphs
//     WORD   e_minalloc;                  // Minimum extra paragraphs needed
//     WORD   e_maxalloc;                  // Maximum extra paragraphs needed
//     WORD   e_ss;                        // Initial (relative) SS value
//     WORD   e_sp;                        // Initial SP value
//     WORD   e_csum;                      // Checksum
//     WORD   e_ip;                        // Initial IP value
//     WORD   e_cs;                        // Initial (relative) CS value
//     WORD   e_lfarlc;                    // File address of relocation table
//     WORD   e_ovno;                      // Overlay number
//     WORD   e_res[4];                    // Reserved words
//     WORD   e_oemid;                     // OEM identifier (for e_oeminfo)
//     WORD   e_oeminfo;                   // OEM information; e_oemid specific
//     WORD   e_res2[10];                  // Reserved words
//     LONG   e_lfanew;                    // File address of new exe header
//   } IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;
_IMAGE_DOS_HEADER = packed record       // DOS .EXE header
  e_magic: WORD;                        // Magic number
  e_cblp: WORD;                         // Bytes on last page of file
  e_cp: WORD;                           // Pages in file
  e_crlc: WORD;                         // Relocations
  e_cparhdr: WORD;                      // Size of header in paragraphs
  e_minalloc: WORD;                     // Minimum extra paragraphs needed
  e_maxalloc: WORD;                     // Maximum extra paragraphs needed
  e_ss: WORD;                           // Initial (relative) SS value
  e_sp: WORD;                           // Initial SP value
  e_csum: WORD;                         // Checksum
  e_ip: WORD;                           // Initial IP value
  e_cs: WORD;                           // Initial (relative) CS value
  e_lfarlc: WORD;                       // File address of relocation table
  e_ovno: WORD;                         // Overlay number
  e_res: packed array[0..3] of WORD;    // Reserved words
  e_oemid: WORD;                        // OEM identifier (for e_oeminfo)
  e_oeminfo: WORD;                      // OEM information: WORD; e_oemid specific
  e_res2: packed array[0..9] of WORD;   // Reserved words
  e_lfanew: DWORD;                      // File address of new exe header
end;
IMAGE_DOS_HEADER = _IMAGE_DOS_HEADER;
PIMAGE_DOS_HEADER = ^_IMAGE_DOS_HEADER;

// typedef struct _IMAGE_FILE_HEADER {
//     WORD    Machine;
//     WORD    NumberOfSections;
//     DWORD   TimeDateStamp;
//     DWORD   PointerToSymbolTable;
//     DWORD   NumberOfSymbols;
//     WORD    SizeOfOptionalHeader;
//     WORD    Characteristics;
// } IMAGE_FILE_HEADER, *PIMAGE_FILE_HEADER;
_IMAGE_FILE_HEADER = packed record
  Machine: WORD;
  NumberOfSections: WORD;
  TimeDateStamp: DWORD;
  PointerToSymbolTable: DWORD;
  NumberOfSymbols: DWORD;
  SizeOfOptionalHeader: WORD;
  Characteristics: WORD;
end;
IMAGE_FILE_HEADER = _IMAGE_FILE_HEADER;
PIMAGE_FILE_HEADER = ^_IMAGE_FILE_HEADER;

// typedef struct _IMAGE_DATA_DIRECTORY {
//     DWORD   VirtualAddress;
//     DWORD   Size;
// } IMAGE_DATA_DIRECTORY, *PIMAGE_DATA_DIRECTORY;
_IMAGE_DATA_DIRECTORY = packed record
  VirtualAddress: DWORD;
  Size: DWORD;
end;
IMAGE_DATA_DIRECTORY = _IMAGE_DATA_DIRECTORY;
PIMAGE_DATA_DIRECTORY = ^_IMAGE_DATA_DIRECTORY;

// typedef struct _IMAGE_OPTIONAL_HEADER {
//     //
//     // Standard fields.
//     //
//
//     WORD    Magic;
//     BYTE    MajorLinkerVersion;
//     BYTE    MinorLinkerVersion;
//     DWORD   SizeOfCode;
//     DWORD   SizeOfInitializedData;
//     DWORD   SizeOfUninitializedData;
//     DWORD   AddressOfEntryPoint;
//     DWORD   BaseOfCode;
//     DWORD   BaseOfData;
//
//     //
//     // NT additional fields.
//     //
//
//     DWORD   ImageBase;
//     DWORD   SectionAlignment;
//     DWORD   FileAlignment;
//     WORD    MajorOperatingSystemVersion;
//     WORD    MinorOperatingSystemVersion;
//     WORD    MajorImageVersion;
//     WORD    MinorImageVersion;
//     WORD    MajorSubsystemVersion;
//     WORD    MinorSubsystemVersion;
//     DWORD   Win32VersionValue;
//     DWORD   SizeOfImage;
//     DWORD   SizeOfHeaders;
//     DWORD   CheckSum;
//     WORD    Subsystem;
//     WORD    DllCharacteristics;
//     DWORD   SizeOfStackReserve;
//     DWORD   SizeOfStackCommit;
//     DWORD   SizeOfHeapReserve;
//     DWORD   SizeOfHeapCommit;
//     DWORD   LoaderFlags;
//     DWORD   NumberOfRvaAndSizes;
//     IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
// } IMAGE_OPTIONAL_HEADER32, *PIMAGE_OPTIONAL_HEADER32;
_IMAGE_OPTIONAL_HEADER = packed record
  //
  // Standard fields.
  //

  Magic: WORD;
  MajorLinkerVersion: BYTE;
  MinorLinkerVersion: BYTE;
  SizeOfCode: DWORD;
  SizeOfInitializedData: DWORD;
  SizeOfUninitializedData: DWORD;
  AddressOfEntryPoint: DWORD;
  BaseOfCode: DWORD;
  BaseOfData: DWORD;

  //
  // NT additional fields.
  //

  ImageBase: DWORD;
  SectionAlignment: DWORD;
  FileAlignment: DWORD;
  MajorOperatingSystemVersion: WORD;
  MinorOperatingSystemVersion: WORD;
  MajorImageVersion: WORD;
  MinorImageVersion: WORD;
  MajorSubsystemVersion: WORD;
  MinorSubsystemVersion: WORD;
  Win32VersionValue: DWORD;
  SizeOfImage: DWORD;
  SizeOfHeaders: DWORD;
  CheckSum: DWORD;
  Subsystem: WORD;
  DllCharacteristics: WORD;
  SizeOfStackReserve: DWORD;
  SizeOfStackCommit: DWORD;
  SizeOfHeapReserve: DWORD;
  SizeOfHeapCommit: DWORD;
  LoaderFlags: DWORD;
  NumberOfRvaAndSizes: DWORD;
  DataDirectory: packed array[0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES - 1] of IMAGE_DATA_DIRECTORY;
end;
IMAGE_OPTIONAL_HEADER = _IMAGE_OPTIONAL_HEADER;
PIMAGE_OPTIONAL_HEADER = ^_IMAGE_OPTIONAL_HEADER;
IMAGE_OPTIONAL_HEADER32 = _IMAGE_OPTIONAL_HEADER;
PIMAGE_OPTIONAL_HEADER32 = ^IMAGE_OPTIONAL_HEADER32;

// typedef struct _IMAGE_NT_HEADERS {
//     DWORD Signature;
//     IMAGE_FILE_HEADER FileHeader;
//     IMAGE_OPTIONAL_HEADER32 OptionalHeader;
// } IMAGE_NT_HEADERS32, *PIMAGE_NT_HEADERS32;
IMAGE_NT_HEADERS = packed record
  Signature: DWORD;
  FileHeader: IMAGE_FILE_HEADER;
  OptionalHeader: IMAGE_OPTIONAL_HEADER32;
end;
PIMAGE_NT_HEADERS = ^IMAGE_NT_HEADERS;

// typedef struct _IMAGE_SECTION_HEADER {
//     BYTE    Name[IMAGE_SIZEOF_SHORT_NAME];
//     union {
//             DWORD   PhysicalAddress;
//             DWORD   VirtualSize;
//     } Misc;
//     DWORD   VirtualAddress;
//     DWORD   SizeOfRawData;
//     DWORD   PointerToRawData;
//     DWORD   PointerToRelocations;
//     DWORD   PointerToLinenumbers;
//     WORD    NumberOfRelocations;
//     WORD    NumberOfLinenumbers;
//     DWORD   Characteristics;
// } IMAGE_SECTION_HEADER, *PIMAGE_SECTION_HEADER;
_IMAGE_SECTION_HEADER_PhysicalAddress_And_VirtualSize_Union = packed record
  case integer of
    0: (PhysicalAddress: DWORD);
    1: (VirtualSize: DWORD);
end;

_IMAGE_SECTION_HEADER = packed record
  Name: packed array[0..IMAGE_SIZEOF_SHORT_NAME - 1] of BYTE;
  Misc: _IMAGE_SECTION_HEADER_PhysicalAddress_And_VirtualSize_Union;
  VirtualAddress: DWORD;
  SizeOfRawData: DWORD;
  PointerToRawData: DWORD;
  PointerToRelocations: DWORD;
  PointerToLinenumbers: DWORD;
  NumberOfRelocations: WORD;
  NumberOfLinenumbers: WORD;
  Characteristics: DWORD;
end;
IMAGE_SECTION_HEADER = _IMAGE_SECTION_HEADER;
PIMAGE_SECTION_HEADER = ^_IMAGE_SECTION_HEADER;

// typedef struct _IMAGE_BASE_RELOCATION {
//     DWORD   VirtualAddress;
//     DWORD   SizeOfBlock;
// //  WORD    TypeOffset[1];
// } IMAGE_BASE_RELOCATION;
// typedef IMAGE_BASE_RELOCATION UNALIGNED * PIMAGE_BASE_RELOCATION;

_IMAGE_BASE_RELOCATION = packed record
  VirtualAddress: DWORD;
  SizeOfBlock: DWORD;
//  WORD    TypeOffset[1];
end;
IMAGE_BASE_RELOCATION = _IMAGE_BASE_RELOCATION;
PIMAGE_BASE_RELOCATION = ^_IMAGE_BASE_RELOCATION;

// typedef struct _IMAGE_IMPORT_DESCRIPTOR {
//     union {
//         DWORD   Characteristics;            // 0 for terminating null import descriptor
//         DWORD   OriginalFirstThunk;         // RVA to original unbound IAT (PIMAGE_THUNK_DATA)
//     };
//     DWORD   TimeDateStamp;                  // 0 if not bound,
//                                             // -1 if bound, and real date\time stamp
//                                             //     in IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT (new BIND)
//                                             // O.W. date/time stamp of DLL bound to (Old BIND)
//
//     DWORD   ForwarderChain;                 // -1 if no forwarders
//     DWORD   Name;
//     DWORD   FirstThunk;                     // RVA to IAT (if bound this IAT has actual addresses)
// } IMAGE_IMPORT_DESCRIPTOR;
// typedef IMAGE_IMPORT_DESCRIPTOR UNALIGNED *PIMAGE_IMPORT_DESCRIPTOR;
_IMAGE_IMPORT_DESCRIPTOR = packed record
  OriginalFirstThunk: DWORD;
  TimeDateStamp: DWORD;
  ForwarderChain: DWORD;
  Name: DWORD;
  FirstThunk: DWORD;
end;
IMAGE_IMPORT_DESCRIPTOR = _IMAGE_IMPORT_DESCRIPTOR;
PIMAGE_IMPORT_DESCRIPTOR = ^_IMAGE_IMPORT_DESCRIPTOR;

// typedef struct _IMAGE_IMPORT_BY_NAME {
//     WORD    Hint;
//     BYTE    Name[1];
// } IMAGE_IMPORT_BY_NAME, *PIMAGE_IMPORT_BY_NAME;
_IMAGE_IMPORT_BY_NAME = packed record
  Hint: WORD;
  Name: BYTE;
end;
IMAGE_IMPORT_BY_NAME = _IMAGE_IMPORT_BY_NAME;
PIMAGE_IMPORT_BY_NAME = ^IMAGE_IMPORT_BY_NAME;

// typedef struct _IMAGE_EXPORT_DIRECTORY {
//     DWORD   Characteristics;
//     DWORD   TimeDateStamp;
//     WORD    MajorVersion;
//     WORD    MinorVersion;
//     DWORD   Name;
//     DWORD   Base;
//     DWORD   NumberOfFunctions;
//     DWORD   NumberOfNames;
//     DWORD   AddressOfFunctions;     // RVA from base of image
//     DWORD   AddressOfNames;         // RVA from base of image
//     DWORD   AddressOfNameOrdinals;  // RVA from base of image
// } IMAGE_EXPORT_DIRECTORY, *PIMAGE_EXPORT_DIRECTORY;
_IMAGE_EXPORT_DIRECTORY = packed record
  Characteristics: DWORD;
  TimeDateStamp: DWORD;
  MajorVersion: WORD;
  MinorVersion: WORD;
  Name: DWORD;
  Base: DWORD;
  NumberOfFunctions: DWORD;
  NumberOfNames: DWORD;
  AddressOfFunctions: DWORD;
  AddressOfNames: DWORD;
  AddressOfNameOrdinals: DWORD;
end;
IMAGE_EXPORT_DIRECTORY = _IMAGE_EXPORT_DIRECTORY;
PIMAGE_EXPORT_DIRECTORY = ^IMAGE_EXPORT_DIRECTORY;

// typedef struct _IMAGE_RESOURCE_DIRECTORY_ENTRY {
//     union {
//         struct {
//             DWORD NameOffset:31;
//             DWORD NameIsString:1;
//         };
//         DWORD   Name;
//         WORD    Id;
//     };
//     union {
//         DWORD   OffsetToData;
//         struct {
//             DWORD   OffsetToDirectory:31;
//             DWORD   DataIsDirectory:1;
//         };
//     };
// } IMAGE_RESOURCE_DIRECTORY_ENTRY, *PIMAGE_RESOURCE_DIRECTORY_ENTRY;
//
_IMAGE_RESOURCE_DIRECTORY_ENTRY = packed record
// NameOffset == IMAGE_RESOURCE_DIRECTORY_ENTRY.Name and not $80000000
// NameIsString == IMAGE_RESOURCE_DIRECTORY_ENTRY.Name and $80000000 <> 0
// Name == IMAGE_RESOURCE_DIRECTORY_ENTRY.Name
// Id == LOWORD(IMAGE_RESOURCE_DIRECTORY_ENTRY.Name)
  Name: DWORD;
// OffsetToData == IMAGE_RESOURCE_DIRECTORY_ENTRY.Offset
// OffsetToDirectory == IMAGE_RESOURCE_DIRECTORY_ENTRY.Offset and not $80000000
// DataIsDirectory == IMAGE_RESOURCE_DIRECTORY_ENTRY.Offset and $80000000 <> 0
  Offset: DWORD;
end;
IMAGE_RESOURCE_DIRECTORY_ENTRY = _IMAGE_RESOURCE_DIRECTORY_ENTRY;
PIMAGE_RESOURCE_DIRECTORY_ENTRY = ^IMAGE_RESOURCE_DIRECTORY_ENTRY;

// typedef struct _IMAGE_RESOURCE_DIRECTORY {
//     DWORD   Characteristics;
//     DWORD   TimeDateStamp;
//     WORD    MajorVersion;
//     WORD    MinorVersion;
//     WORD    NumberOfNamedEntries;
//     WORD    NumberOfIdEntries;
// //  IMAGE_RESOURCE_DIRECTORY_ENTRY DirectoryEntries[];
// } IMAGE_RESOURCE_DIRECTORY, *PIMAGE_RESOURCE_DIRECTORY;
_IMAGE_RESOURCE_DIRECTORY = packed record
  Characteristics: DWORD;
  TimeDateStamp: DWORD;
  MajorVersion: WORD;
  MinorVersion: WORD;
  NumberOfNamedEntries: WORD;
  NumberOfIdEntries: WORD;
end;
IMAGE_RESOURCE_DIRECTORY = _IMAGE_RESOURCE_DIRECTORY;
PIMAGE_RESOURCE_DIRECTORY = ^IMAGE_RESOURCE_DIRECTORY;

// typedef struct _IMAGE_RESOURCE_DATA_ENTRY {
//     DWORD   OffsetToData;
//     DWORD   Size;
//     DWORD   CodePage;
//     DWORD   Reserved;
// } IMAGE_RESOURCE_DATA_ENTRY, *PIMAGE_RESOURCE_DATA_ENTRY;
_IMAGE_RESOURCE_DATA_ENTRY = packed record
  OffsetToData: DWORD;
  Size: DWORD;
  CodePage: DWORD;
  Reserved: DWORD;
end;
IMAGE_RESOURCE_DATA_ENTRY = _IMAGE_RESOURCE_DATA_ENTRY;
PIMAGE_RESOURCE_DATA_ENTRY = ^IMAGE_RESOURCE_DATA_ENTRY;

// typedef struct _IMAGE_RESOURCE_DIRECTORY_STRING {
//     WORD    Length;
//     CHAR    NameString[ 1 ];
// } IMAGE_RESOURCE_DIRECTORY_STRING, *PIMAGE_RESOURCE_DIRECTORY_STRING;
_IMAGE_RESOURCE_DIRECTORY_STRING = packed record
   Length: WORD;
   NameString: CHAR;
end;
IMAGE_RESOURCE_DIRECTORY_STRING = _IMAGE_RESOURCE_DIRECTORY_STRING;
PIMAGE_RESOURCE_DIRECTORY_STRING = ^IMAGE_RESOURCE_DIRECTORY_STRING;

TDllEntryProc = function(hinstDLL: HMODULE; fdwReason: DWORD; lpvReserved: pointer) : BOOL; stdcall;

// OnGetImportedProcAddress allows to replace addresses of imported functions of dll
function TDLLLoader.OnGetImportedProcAddress(lpszDLLName: LPCTSTR; lpszProcName: LPCTSTR): pointer;
begin
  Result := nil;
end;

constructor TDLLLoader.Create;
begin
end;

procedure TDLLLoader.Load(Stream: TStream);
var

  MemoryStream: TMemoryStream;

  pSourceData: pointer;
  ptr: pointer;
  pImageNTHeaders: PIMAGE_NT_HEADERS;

  pImageBase: pointer;

  intSectionCount: DWORD;
  intSectionIndex: DWORD;

  pImageBaseSectionHeader: PIMAGE_SECTION_HEADER;

  intVirtualSectionSize: DWORD;
  intRawSectionSize: DWORD;
  pSectionBase: cardinal;

  intImageBaseDelta: DWORD;
  intRelocationInfoSize: DWORD;
  pImageBaseRelocations: PIMAGE_BASE_RELOCATION;
  pReloc: PIMAGE_BASE_RELOCATION;
  intRelocCount: DWORD;
  pwRelocInfo: PWORD;
  intRelocIndex: DWORD;

  pImports: PIMAGE_IMPORT_DESCRIPTOR;
  pImport: PIMAGE_IMPORT_DESCRIPTOR;
  lpszLibName: LPCSTR;
  hLib: WinApi.Windows.HMODULE;
  lpPRVA_Import: PDWORD;
  lpszProcName: LPCSTR;
  lpProcAddress: pointer;

  pDllEntryProc: TDllEntryProc;

function min(i0: integer; i1: integer): integer;
begin
  if i0 < i1 then
    Result := i0
  else
    Result := i1;
end;

begin

  MemoryStream := nil;
  ListOfLoadedModules := nil;

  ImportedFunctions := TImportedFunctions.Create;

  try
    MemoryStream := TMemoryStream.Create;
    MemoryStream.LoadFromStream(Stream);

    pSourceData := MemoryStream.Memory;
    ptr := pSourceData;

// Allocating memory for the image...BEGIN

    ptr := pointer(cardinal(ptr) + (PIMAGE_DOS_HEADER(ptr)).e_lfanew);
    pImageNTHeaders := PIMAGE_NT_HEADERS(ptr);

    pImageBase := VirtualAlloc(nil, pImageNTHeaders.OptionalHeader.SizeOfImage, MEM_COMMIT, PAGE_EXECUTE_READWRITE);

// Allocating memory for the image...END

// Copying of headers...BEGIN

    CopyMemory(pImageBase, pSourceData, pImageNTHeaders.OptionalHeader.SizeOfHeaders);

// Copying of headers...END

// Working with sections...END

    // Let ptr to point on the section table
    ptr := pointer(cardinal(ptr) +
                   SizeOf(pImageNTHeaders.Signature) +
                   SizeOf(pImageNTHeaders.FileHeader) +
                   pImageNTHeaders.FileHeader.SizeOfOptionalHeader);

    // Get the count of sections
    intSectionCount := pImageNTHeaders.FileHeader.NumberOfSections;

    // Allocating memory for each section
    for intSectionIndex := 0 to intSectionCount - 1 do
    begin
      pImageBaseSectionHeader := PIMAGE_SECTION_HEADER(cardinal(ptr) + SizeOf(IMAGE_SECTION_HEADER) * intSectionIndex);

      // Getting virtual and raw section sizes
      intVirtualSectionSize := pImageBaseSectionHeader.Misc.VirtualSize;
      intRawSectionSize := pImageBaseSectionHeader.SizeOfRawData;

      // Getting section base
      pSectionBase := cardinal(pImageBase) + pImageBaseSectionHeader.VirtualAddress;

      ZeroMemory(pointer(pSectionBase), intVirtualSectionSize);

      CopyMemory(pointer(pSectionBase),
                 pointer(cardinal(pSourceData) + pImageBaseSectionHeader.PointerToRawData),
                 min(intVirtualSectionSize, intRawSectionSize));
    end;

// Working with sections...END

// Relocations...BEGIN

  intImageBaseDelta := cardinal(pImageBase) - cardinal(pImageNTHeaders.OptionalHeader.ImageBase);

  intRelocationInfoSize := pImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size;

  pImageBaseRelocations :=
    PIMAGE_BASE_RELOCATION
    (
      cardinal(pImageBase) +
      pImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress
    );

  pReloc := pImageBaseRelocations;

  while cardinal(pReloc) < intRelocationInfoSize + cardinal(pImageBaseRelocations) do
  begin
    intRelocCount := (pReloc.SizeOfBlock - SizeOf(pReloc^)) div SizeOf(WORD);
    pwRelocInfo := PWORD(cardinal(pReloc) + SizeOf(pReloc^));

    for intRelocIndex := 0 to intRelocCount - 1 do
    begin
      if 0 <> pwRelocInfo^ and $f000 then
        inc(PDWORD(cardinal(pImageBase) + pReloc.VirtualAddress + (pwRelocInfo^ and $0fff))^, intImageBaseDelta);

      pwRelocInfo := PWORD(cardinal(pwRelocInfo) + SizeOf(pwRelocInfo^));
    end;

    pReloc := PIMAGE_BASE_RELOCATION(pwRelocInfo);
  end;

// Relocations...END

// Import table...BEGIN

  pImports :=
    PIMAGE_IMPORT_DESCRIPTOR
    (
      cardinal(pImageBase) +
      pImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress
    );

  pImport := pImports;

  ListOfLoadedModules := TList.Create;

  while (0 <> pImport.Name) do
  begin
    lpszLibName := PAnsiChar(cardinal(pImageBase) + pImport.Name);

    hLib := LoadLibraryA(lpszLibName);

    if 0 <> hLib then
      ListOfLoadedModules.Add(pointer(hLib));

    if 0 = pImport.TimeDateStamp
    then
      lpPRVA_Import := PDWORD(pImport.FirstThunk + cardinal(pImageBase))
    else
      lpPRVA_Import := PDWORD(pImport.OriginalFirstThunk + cardinal(pImageBase));

    while (0 <> lpPRVA_Import^) do
    begin
      if (0 <> lpPRVA_Import^ and IMAGE_ORDINAL_FLAG32)
      then
        lpszProcName := PAnsiChar(lpPRVA_Import^ and $ffff)
      else
      begin
        lpszProcName := PAnsiChar(@((PIMAGE_IMPORT_BY_NAME(cardinal(pImageBase) + lpPRVA_Import^)).Name));

        // Save where the pointer to function is located
        ImportedFunctions.Add(lpszLibName, lpszProcName, lpPRVA_Import);
      end;

      lpProcAddress := OnGetImportedProcAddress(lpszLibName, lpszProcName);

      if nil <> lpProcAddress then
        lpPRVA_Import^ := DWORD(lpProcAddress)
      else
        lpPRVA_Import^ := DWORD(WinApi.Windows.GetProcAddress(hLib, lpszProcName));

      lpPRVA_Import := PDWORD(cardinal(lpPRVA_Import) + SizeOf(lpPRVA_Import^));
      end;

      pImport := PIMAGE_IMPORT_DESCRIPTOR(cardinal(pImport) + SizeOf(pImport^));
  end;

// Import table...END

  FlushInstructionCache(GetCurrentProcess(), pImageBase, pImageNTHeaders.OptionalHeader.SizeOfImage);

// DllMain invoking...BEGIN

  @pDllEntryProc := pointer(cardinal(pImageBase) + pImageNTHeaders.OptionalHeader.AddressOfEntryPoint);

  if nil <> @pDllEntryProc then
  begin
    pDllEntryProc(cardinal(pImageBase), DLL_PROCESS_ATTACH, nil);
    pDllEntryProc(cardinal(pImageBase), DLL_THREAD_ATTACH, nil);
  end;

// DllMain invoking...END

    hModule := cardinal(pImageBase);

  finally

    MemoryStream.Free;

  end;
end;

destructor TDLLLoader.Destroy;
var

  intModuleIndex: integer;
  intModuleCount: integer;

  pImageBase: pointer;
  ptr: pointer;

  pImageNTHeaders: PIMAGE_NT_HEADERS;

  pDllEntryProc: TDllEntryProc;

begin

  ImportedFunctions.Free;

  pImageBase := pointer(hModule);

  if nil = pImageBase then
  begin
    inherited Destroy;
    Exit;
  end;

  pImageBase := pointer(hModule);
  ptr := pImageBase;
  ptr := pointer(cardinal(ptr) + (PIMAGE_DOS_HEADER(ptr)).e_lfanew);
  pImageNTHeaders := PIMAGE_NT_HEADERS(ptr);
  @pDllEntryProc := pointer(cardinal(pImageBase) + pImageNTHeaders.OptionalHeader.AddressOfEntryPoint);

  if nil <> @pDllEntryProc then
    pDllEntryProc(cardinal(pImageBase), DLL_PROCESS_DETACH, nil);

// Unloading modules...BEGIN

  intModuleCount := ListOfLoadedModules.Count;

  for intModuleIndex := 0 to intModuleCount - 1 do
  begin
    FreeLibrary(cardinal(ListOfLoadedModules[intModuleIndex]));
  end;

  ListOfLoadedModules.Free;

// Unloading modules...END

// Free memory...BEGIN

  VirtualFree(pointer(hModule), 0, MEM_RELEASE);

// Free memory...END

  inherited Destroy;
end;

// GetProcAddress
function TDLLLoader.GetProcAddress(lpProcName: LPCSTR): FARPROC;
var

  ptr: pointer;
  pImageNTHeaders: PIMAGE_NT_HEADERS;

  pImageBase: pointer;

  pExports: PIMAGE_EXPORT_DIRECTORY;

  dwExportedSymbolIndex: DWORD;
  dwExportedSymbolCount: DWORD;
  dwVirtualAddressOfName: DWORD;
  lpszName: LPSTR;
  wIndex: WORD;
  dwVirtualAddressOfAddressOfProc: DWORD;

begin

  Result := nil;

  if 0 = hModule then Exit;

  pImageBase := pointer(hModule);
  ptr := pImageBase;
  ptr := pointer(cardinal(ptr) + (PIMAGE_DOS_HEADER(ptr)).e_lfanew);
  pImageNTHeaders := PIMAGE_NT_HEADERS(ptr);

  pExports :=
    PIMAGE_EXPORT_DIRECTORY
    (
      cardinal(pImageBase) +
      pImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress
    );

  dwExportedSymbolCount := pExports.NumberOfNames;

  for dwExportedSymbolIndex := 0 to dwExportedSymbolCount - 1 do
  begin
    dwVirtualAddressOfName :=
      PDWORD(cardinal(pImageBase) + pExports.AddressOfNames + SizeOf(DWORD) * dwExportedSymbolIndex)^;

    lpszName := LPSTR(cardinal(pImageBase) + dwVirtualAddressOfName);

    if 0 = lstrcmpA(lpszName, lpProcName) then
    begin
      wIndex :=
        PWORD(cardinal(pImageBase) + pExports.AddressOfNameOrdinals + SizeOf(WORD) * dwExportedSymbolIndex)^;

      dwVirtualAddressOfAddressOfProc :=
        PDWORD(cardinal(pImageBase) + pExports.AddressOfFunctions + SizeOf(DWORD) * wIndex)^;

      Result :=
        FARPROC(cardinal(pImageBase) + dwVirtualAddressOfAddressOfProc);

      Exit;
    end;
  end;

end;

function TDLLLoader.HookFunc(DLLName: AnsiString; ProcName: AnsiString; AddressOfNewFunction: Pointer): boolean;
begin
   Result := false;

   if ImportedFunctions <> nil then
   begin
      Result := ImportedFunctions.SetNewAddress(DLLName, ProcName, AddressOfNewFunction);
   end;
end;

// TDLLLoader implementation...END
//==============================================================================

//==============================================================================

function MyRegisterClassExA(const WndClass: TWndClassExA): Word; stdcall
var
  MyWndClass: TWndClassExA;
  strNewClassName: AnsiString;
begin
  CopyMemory(@MyWndClass, @WndClass, SizeOf(WndClass));

  if ModuleIsLib then
    MyWndClass.hInstance := SysInit.HInstance
  else
    MyWndClass.hInstance := GetModuleHandle(nil);

{$IFDEF DEF_UNICODE_ENV}
  strNewClassName := AnsiStrings.Format('FlashPlayerControl_%s_%d', [MyWndClass.lpszClassName, Integer(@g_FlashOCXCodeProvider)]);
{$ELSE}
  strNewClassName := Format('FlashPlayerControl_%s_%d', [MyWndClass.lpszClassName, Integer(@g_FlashOCXCodeProvider)]);
{$ENDIF}

  MyWndClass.lpszClassName := PAnsiChar(strNewClassName);
  g_WindowClassNames.Add(WndClass.lpszClassName, MyWndClass.lpszClassName);
  WinApi.Windows.UnregisterClassA(MyWndClass.lpszClassName, MyWndClass.hInstance);

  Result := RegisterClassExA(MyWndClass);
end;

function MyRegisterClassExW(const WndClass: TWndClassExW): Word; stdcall
var
  MyWndClass: TWndClassExW;
  strNewClassName: WideString;
begin
  CopyMemory(@MyWndClass, @WndClass, SizeOf(WndClass));

  if ModuleIsLib then
    MyWndClass.hInstance := SysInit.HInstance
  else
    MyWndClass.hInstance := GetModuleHandle(nil);

{$IFDEF DEF_UNICODE_ENV}
  strNewClassName := Format('FlashPlayerControl_%s_%d', [MyWndClass.lpszClassName, Integer(@g_FlashOCXCodeProvider)]);
{$ELSE}
  strNewClassName := Format('FlashPlayerControl_%s_%d', [MyWndClass.lpszClassName, Integer(@g_FlashOCXCodeProvider)]);
{$ENDIF}

  MyWndClass.lpszClassName := PWideChar(strNewClassName);
  g_WindowClassNames.Add(WndClass.lpszClassName, MyWndClass.lpszClassName);
  WinApi.Windows.UnregisterClassW(MyWndClass.lpszClassName, MyWndClass.hInstance);

  Result := RegisterClassExW(MyWndClass);
end;

//==============================================================================

function MyRegisterClassA(const WndClass: TWndClassA): Word; stdcall
var
  MyWndClass: TWndClassA;
  strNewClassName: AnsiString;
begin
  CopyMemory(@MyWndClass, @WndClass, SizeOf(WndClass));

  if ModuleIsLib then
    MyWndClass.hInstance := SysInit.HInstance
  else
    MyWndClass.hInstance := GetModuleHandle(nil);

{$IFDEF DEF_UNICODE_ENV}
  strNewClassName := AnsiStrings.Format('FlashPlayerControl_%s_%d', [MyWndClass.lpszClassName, Integer(@g_FlashOCXCodeProvider)]);
{$ELSE}
  strNewClassName := Format('FlashPlayerControl_%s_%d', [MyWndClass.lpszClassName, Integer(@g_FlashOCXCodeProvider)]);
{$ENDIF}

  MyWndClass.lpszClassName := PAnsiChar(strNewClassName);
  g_WindowClassNames.Add(WndClass.lpszClassName, MyWndClass.lpszClassName);
  WinApi.Windows.UnregisterClassA(MyWndClass.lpszClassName, MyWndClass.hInstance);

  Result := RegisterClassA(MyWndClass);
end;

function MyRegisterClassW(const WndClass: TWndClassW): Word; stdcall
var
  MyWndClass: TWndClassW;
  strNewClassName: WideString;
begin
  CopyMemory(@MyWndClass, @WndClass, SizeOf(WndClass));

  if ModuleIsLib then
    MyWndClass.hInstance := SysInit.HInstance
  else
    MyWndClass.hInstance := GetModuleHandle(nil);

{$IFDEF DEF_UNICODE_ENV}
  strNewClassName := Format('FlashPlayerControl_%s_%d', [MyWndClass.lpszClassName, Integer(@g_FlashOCXCodeProvider)]);
{$ELSE}
  strNewClassName := Format('FlashPlayerControl_%s_%d', [MyWndClass.lpszClassName, Integer(@g_FlashOCXCodeProvider)]);
{$ENDIF}

  MyWndClass.lpszClassName := PWideChar(strNewClassName);
  g_WindowClassNames.Add(WndClass.lpszClassName, MyWndClass.lpszClassName);
  WinApi.Windows.UnregisterClassW(MyWndClass.lpszClassName, MyWndClass.hInstance);

  Result := RegisterClassW(MyWndClass);
end;

function MyCreateWindowExA(dwExStyle: DWORD; lpClassName: PAnsiChar;
  lpWindowName: PAnsiChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall
var
  strOurClassName: WideString;
  strOurClassNameA: AnsiString;
begin
  if hInstance <> 0 then
     if ModuleIsLib then
       hInstance := SysInit.HInstance
     else
       hInstance := GetModuleHandle(nil);

  if 0 <> HIWORD(Integer(lpClassName)) then
    if g_WindowClassNames.Find(lpClassName, strOurClassName) then
    begin
      strOurClassNameA := strOurClassName;
      lpClassName := PAnsiChar(strOurClassNameA);
    end;

  Result := CreateWindowExA(dwExStyle { or WS_EX_TRANSPARENT } ,
                            lpClassName,
                            lpWindowName,
                            dwStyle,
                            X,
                            Y,
                            nWidth,
                            nHeight,
                            hWndParent,
                            hMenu,
                            hInstance,
                            lpParam);
end;

function MyCreateWindowExW(dwExStyle: DWORD; lpClassName: PWideChar;
  lpWindowName: PWideChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall
var
  strOurClassName: WideString;
begin
  if hInstance <> 0 then
     if ModuleIsLib then
       hInstance := SysInit.HInstance
     else
       hInstance := GetModuleHandle(nil);

  if 0 <> HIWORD(Integer(lpClassName)) then
    if g_WindowClassNames.Find(lpClassName, strOurClassName) then
      lpClassName := PWideChar(strOurClassName);

  Result := CreateWindowExW(dwExStyle,
                            lpClassName,
                            lpWindowName,
                            dwStyle,
                            X,
                            Y,
                            nWidth,
                            nHeight,
                            hWndParent,
                            hMenu,
                            hInstance,
                            lpParam);
end;

//============================================================================
// strutils...BEGIN

function WideLeftStr(const AText: WideString; const ACount: Integer): WideString;
begin
  Result := Copy(AText, 1, ACount);
end;

function WideRightStr(const AText: WideString; const ACount: Integer): WideString;
begin
  Result := Copy(AText, Length(AText) + 1 - ACount, ACount);
end;

function WideStringReplace(const SourceString: WideString; const ReplaceWhat, ReplaceWith: WideChar): WideString;
var
   pCurrentChar: PWideChar;
begin
   Result := SourceString;

   pCurrentChar := PWideChar(Result);

   while ( WideChar(0) <> pCurrentChar^ ) do
   begin
      if pCurrentChar^ = ReplaceWhat then pCurrentChar^ := ReplaceWith;

      pCurrentChar := PWideChar(Integer(pCurrentChar) + 2);
   end;
end;

function CompareWideString(const S1, S2: WideString): boolean;
begin
   Result := ( 0 = lstrcmpW(PWideChar(S1), PWideChar(S2)) );
end;

// strutils...END
//============================================================================

function MyCreateURLMoniker(MkCtx: IMoniker; szURL: LPCWSTR; out mk: IMoniker): HResult; stdcall
var
  Continue: boolean;
  URL: WideString;
begin
  if @g_GlobalOnPreProcessURLHandler <> nil then
  begin
    URL := szURL;

    g_GlobalOnPreProcessURLHandler(URL, Continue);

    if not Continue then
    begin
      Result := E_FAIL;
      Exit;
    end;

    szURL := PWideChar(URL);
  end;

  Result := g_ContentManager.CreateMoniker(MkCtx, szURL, mk);
end;

function MyCreateFileA(lpFileName: PAnsiChar;
                       dwDesiredAccess, dwShareMode: DWORD;
                       lpSecurityAttributes: PSecurityAttributes;
                       dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                       hTemplateFile: THandle): THandle; stdcall
begin
  Result := g_ContentManager.CreateFileA(lpFileName,
                                         dwDesiredAccess,
                                         dwShareMode,
                                         lpSecurityAttributes,
                                         dwCreationDisposition,
                                         dwFlagsAndAttributes,
                                         hTemplateFile);
end;

// #define IS_INTRESOURCE(_r) (((ULONG_PTR)(_r) >> 16) == 0)
function IS_INTRESOURCE(value: Cardinal): Boolean;
begin
   Result := ( ( value shr 16 ) = 0 );
end;

// NOTE: only non-string types and names are supported now - ???
function GetResourceInfoEx(hInstance: HINST; lpResType: LPCSTR; lpResName: LPCSTR; wLanguage: WORD; var lpResData: Pointer; var dwResSize: DWORD): BOOL;
var

  pImageNTHeaders: PIMAGE_NT_HEADERS;

  pImageResourceDirectoryRoot: PIMAGE_RESOURCE_DIRECTORY;
  pImageResourceDirectoryEntries: PIMAGE_RESOURCE_DIRECTORY_ENTRY;
  pImageResourceDirectoryEntryForResType: PIMAGE_RESOURCE_DIRECTORY_ENTRY;

  intEntryIndex: integer;

  pImageResourceDirectoryEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;

  pImageResourceDirectoryOfResData: PIMAGE_RESOURCE_DIRECTORY;
  pImageResourceDirectory1: PIMAGE_RESOURCE_DIRECTORY;
  pEntry: PIMAGE_RESOURCE_DIRECTORY_ENTRY;

  pResourceDataEntry: PIMAGE_RESOURCE_DATA_ENTRY;

  i : cardinal;

  pImageResourceDirectoryString: PIMAGE_RESOURCE_DIRECTORY_STRING;
  pBuffer: cardinal;

{$IFDEF DEF_UNICODE_ENV}
  strResTypeName, strResNameName, s: WideString;
{$ELSE}
  strResTypeName, strResNameName: AnsiString;
{$ENDIF}

  bFound: boolean;

begin
  Result := FALSE;

  try

    pImageNTHeaders := PIMAGE_NT_HEADERS(pointer(cardinal(hInstance) + (PIMAGE_DOS_HEADER(hInstance)).e_lfanew));

    pImageResourceDirectoryRoot :=
      PIMAGE_RESOURCE_DIRECTORY
      (
        cardinal(hInstance) +
        pImageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_RESOURCE].VirtualAddress
      );

    pImageResourceDirectoryEntries :=
      PIMAGE_RESOURCE_DIRECTORY_ENTRY
      (
        cardinal(pImageResourceDirectoryRoot) +
        sizeof(IMAGE_RESOURCE_DIRECTORY)
      );

    pImageResourceDirectoryEntryForResType := nil;

    for intEntryIndex := 0 to
        pImageResourceDirectoryRoot.NumberOfIdEntries + pImageResourceDirectoryRoot.NumberOfNamedEntries - 1 do
    begin
      pImageResourceDirectoryEntry :=
        PIMAGE_RESOURCE_DIRECTORY_ENTRY
        (
          cardinal(pImageResourceDirectoryEntries) +
          cardinal(intEntryIndex) * sizeof(IMAGE_RESOURCE_DIRECTORY_ENTRY)
        );

      if IS_INTRESOURCE(cardinal(lpResType)) then
      begin
         // if (!pImageResourceDirectoryEntry->NameIsString &&
         //    pImageResourceDirectoryEntry->Id == (DWORD)lpResType)
         if (pImageResourceDirectoryEntry.Name and $80000000 = 0) and
            (LOWORD(pImageResourceDirectoryEntry.Name) = WORD(lpResType)) then
            begin
              pImageResourceDirectoryEntryForResType := pImageResourceDirectoryEntry;
              break;
            end;
      end
      else
      begin
         // if (pImageResourceDirectoryEntry->NameIsString)
         if (pImageResourceDirectoryEntry.Name and $80000000 <> 0) then
         begin
            pImageResourceDirectoryString :=
               PIMAGE_RESOURCE_DIRECTORY_STRING
                  (cardinal(pImageResourceDirectoryRoot) +
                  // NameOffset == IMAGE_RESOURCE_DIRECTORY_ENTRY.Name and not $80000000
                  (pImageResourceDirectoryEntry.Name and not $80000000));

            pBuffer := LocalAlloc(LPTR, sizeof(WCHAR) * (pImageResourceDirectoryString.Length + 1));

            CopyMemory(pointer(pBuffer),
                       pointer(cardinal(pImageResourceDirectoryString) + sizeof(pImageResourceDirectoryString.Length)),
                       sizeof(WCHAR) * pImageResourceDirectoryString.Length);

            strResTypeName := WideCharToString(PWideChar(pBuffer));

            LocalFree(pBuffer);

{$IFDEF DEF_UNICODE_ENV}
            WideFromPChar(s, lpResType);

            if 0 = lstrcmpW(PWideChar(strResTypeName), PWideChar(s)) then
               break;
{$ELSE}
            if 0 = lstrcmpA(PAnsiChar(strResTypeName), lpResType) then
               break;
{$ENDIF}
         end;
      end;
    end;

    if pImageResourceDirectoryEntryForResType <> nil then
    begin
//            PIMAGE_RESOURCE_DIRECTORY pImageResourceDirectoryOfResData =
//                (PIMAGE_RESOURCE_DIRECTORY)
//                    ((LPBYTE)pImageResourceDirectoryRoot +
//                     pImageResourceDirectoryEntryForResType->OffsetToDirectory);
      pImageResourceDirectoryOfResData :=
        PIMAGE_RESOURCE_DIRECTORY
        (
          cardinal(pImageResourceDirectoryRoot) +
          (pImageResourceDirectoryEntryForResType.Offset and not $80000000)
        );

      pImageResourceDirectoryEntries :=
        PIMAGE_RESOURCE_DIRECTORY_ENTRY
        (
          cardinal(pImageResourceDirectoryOfResData) +
          sizeof(IMAGE_RESOURCE_DIRECTORY)
        );

      for intEntryIndex := 0 to
          pImageResourceDirectoryOfResData.NumberOfIdEntries + pImageResourceDirectoryOfResData.NumberOfNamedEntries - 1 do
      begin
        pImageResourceDirectoryEntry :=
          PIMAGE_RESOURCE_DIRECTORY_ENTRY
          (
            cardinal(pImageResourceDirectoryEntries) +
            sizeof(IMAGE_RESOURCE_DIRECTORY_ENTRY) * cardinal(intEntryIndex)
          );

        bFound := false;

        if IS_INTRESOURCE(cardinal(lpResName)) then
        begin
//                if (!pImageResourceDirectoryEntry->NameIsString &&
//                    pImageResourceDirectoryEntry->Id == (DWORD)lpResName)
           if (pImageResourceDirectoryEntry.Name and $80000000 = 0) and
              (LOWORD(pImageResourceDirectoryEntry.Name) = WORD(lpResName)) then
              bFound := true;
        end
        else
        begin
//                if (pImageResourceDirectoryEntry->NameIsString)
           if (pImageResourceDirectoryEntry.Name and $80000000 <> 0) then
           begin
            pImageResourceDirectoryString :=
               PIMAGE_RESOURCE_DIRECTORY_STRING
                  (cardinal(pImageResourceDirectoryRoot) +
                  // NameOffset == IMAGE_RESOURCE_DIRECTORY_ENTRY.Name and not $80000000
                  (pImageResourceDirectoryEntry.Name and not $80000000));

            pBuffer := LocalAlloc(LPTR, sizeof(WCHAR) * (pImageResourceDirectoryString.Length + 1));

            CopyMemory(pointer(pBuffer),
                       pointer(cardinal(pImageResourceDirectoryString) + sizeof(pImageResourceDirectoryString.Length)),
                       sizeof(WCHAR) * pImageResourceDirectoryString.Length);

            strResNameName := WideCharToString(PWideChar(pBuffer));

            LocalFree(pBuffer);

{$IFDEF DEF_UNICODE_ENV}
            WideFromPChar(s, lpResName);

            if 0 = lstrcmpW(PWideChar(strResNameName), PWideChar(s)) then
               bFound := true;
{$ELSE}
            if 0 = lstrcmpA(PAnsiChar(strResNameName), lpResName) then
               bFound := true;
{$ENDIF}
           end;
        end;

        if bFound then
        begin
           pImageResourceDirectory1 :=
              PIMAGE_RESOURCE_DIRECTORY
              (
                 cardinal(pImageResourceDirectoryRoot) +
                 // pImageResourceDirectoryEntry->OffsetToDirectory
                 (pImageResourceDirectoryEntry.Offset and not $80000000)
              );

           for i := 0 to pImageResourceDirectory1.NumberOfNamedEntries + pImageResourceDirectory1.NumberOfIdEntries - 1 do
           begin
             pEntry :=
              PIMAGE_RESOURCE_DIRECTORY_ENTRY
              (
                cardinal(pImageResourceDirectory1) +
                sizeof(IMAGE_RESOURCE_DIRECTORY) +
                i * sizeof(IMAGE_RESOURCE_DIRECTORY_ENTRY)
              );

            if (wLanguage = LOWORD(pEntry.Name)) then
            begin
              pResourceDataEntry :=
                PIMAGE_RESOURCE_DATA_ENTRY
                (
                  cardinal(pImageResourceDirectoryRoot) + pEntry.Offset
                );

              lpResData := pointer(cardinal(hInstance) + pResourceDataEntry.OffsetToData);
              dwResSize := pResourceDataEntry.Size;

              Result := TRUE;

              break;
            end;
           end;

           break;
        end;
      end;
    end;

  finally
  end;
end;

// NOTE: only non-string types and names are supported now - ???
function GetResourceInfo(hInstance: HINST; lpResType: LPCSTR; lpResName: LPCSTR; var lpResData: Pointer; var dwResSize: DWORD): BOOL;
begin
   if not GetResourceInfoEx(hInstance, lpResType, lpResName, GetThreadLocale, lpResData, dwResSize) then
      if not GetResourceInfoEx(hInstance, lpResType, lpResName, GetSystemDefaultLCID, lpResData, dwResSize) then
         if not GetResourceInfoEx(hInstance, lpResType, lpResName, GetUserDefaultLCID, lpResData, dwResSize) then
            if not GetResourceInfoEx(hInstance, lpResType, lpResName, 0, lpResData, dwResSize) then
               if not GetResourceInfoEx(hInstance, lpResType, lpResName, 1033 { MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US) } , lpResData, dwResSize) then
               begin
                  Result := FALSE;
                  Exit;
               end;

   Result := TRUE;
end;

function GetModuleVersion(hModule: Cardinal): DWORD;
var
  dwMinorPart: DWORD;
  dwMajorPart: DWORD;
  pFixedFileInfo: pointer; // VS_FIXEDFILEINFO
  lpResDataOfVersion: pointer;
  dwResSizeOfVersion: DWORD;
type
  PVS_FIXEDFILEINFO = ^VS_FIXEDFILEINFO;
begin
  dwMinorPart := 0;
  dwMajorPart := 0;

  // Please see about VS_VERSIONINFO in MSDN

  if GetResourceInfo(hModule,
                     PAnsiChar(RT_VERSION),
                     MAKEINTRESOURCEA(1),
                     lpResDataOfVersion,
                     dwResSizeOfVersion) then
  begin
    pFixedFileInfo := pointer(Cardinal(lpResDataOfVersion) + sizeof(WORD) * 19);

    while PWORD(pFixedFileInfo)^ = 0 do
      pFixedFileInfo := pointer(Cardinal(pFixedFileInfo) + sizeof(WORD));

    dwMinorPart := PVS_FIXEDFILEINFO(pFixedFileInfo).dwProductVersionLS;
    dwMajorPart := PVS_FIXEDFILEINFO(pFixedFileInfo).dwProductVersionMS;
  end;

  Result := HIWORD(dwMajorPart);

  Result := Result shl 8;
  Result := Result + LOWORD(dwMajorPart);

  Result := Result shl 8;
  Result := Result + HIWORD(dwMinorPart);

  Result := Result shl 8;
  Result := Result + LOWORD(dwMinorPart);
end;

constructor TSavedCursor.Create(c: HCURSOR; h: HINST; lpCursorName: PAnsiChar);
begin
   hCur := c;

   hInstance := h;

   if IS_INTRESOURCE(cardinal(lpCursorName)) then
   begin
      bString := false;
      nResId := WORD(lpCursorName);
   end
   else
   begin
      bString := true;
      strResName := lpCursorName;
   end;
end;

function TSavedCursor.Compare(h: HINST; lpCursorName: PAnsiChar): boolean;
begin
   if IS_INTRESOURCE(cardinal(lpCursorName)) then
      Result := ( (h = hInstance) and (not bString) and ( WORD(lpCursorName) = nResId ) )
   else
      Result := ( (h = hInstance) and bString and ( lpCursorName = strResName ) );
end;

constructor TSavedCursors.Create;
begin
   InitializeCriticalSection(m_cs);
   FSavedCursors := TList.Create;
end;

destructor TSavedCursors.Destroy;
begin
   DeleteCriticalSection(m_cs);
   FSavedCursors.Free;
end;

procedure TSavedCursors.SaveCursor(c: HCURSOR; h: HINST; lpCursorName: PAnsiChar);
begin
  EnterCriticalSection(m_cs);

  try
     FSavedCursors.Add(TSavedCursor.Create(c, h, lpCursorName));
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function TSavedCursors.FindCursor(h: HINST; lpCursorName: PAnsiChar): HCURSOR;
var
   i: Integer;
begin
  EnterCriticalSection(m_cs);

  Result := 0;

  try
     for i := 0 to FSavedCursors.Count - 1 do
        if TSavedCursor(FSavedCursors[i]).Compare(h, lpCursorName) then
        begin
           Result := TSavedCursor(FSavedCursors[i]).hCur;
           break;
        end;
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function MyLoadCursorA(hInstance: HINST; lpCursorName: PAnsiChar): HCURSOR; stdcall;
var
  lpResDataOfGroupCursor: Pointer;
  dwResSizeOfGroupCursor: DWORD;

  intCursorIndex: integer;

  lpResDataOfCursor: Pointer;
  dwResSizeOfCursor: DWORD;
begin
  if hInstance <> 0 then
  begin
    Result := g_SavedCursors.FindCursor(hInstance, lpCursorName);

    if Result <> 0 then
       Exit;

    if GetResourceInfo(hInstance,
                       PAnsiChar(RT_GROUP_CURSOR),
                       lpCursorName,
                       lpResDataOfGroupCursor,
                       dwResSizeOfGroupCursor) then
    begin
      intCursorIndex := LookupIconIdFromDirectory(lpResDataOfGroupCursor, FALSE);

      if intCursorIndex <> 0 then
      begin
        if GetResourceInfo(hInstance,
                           PAnsiChar(RT_CURSOR),
                           MAKEINTRESOURCEA(intCursorIndex),
                           lpResDataOfCursor,
                           dwResSizeOfCursor) then
        begin
          Result := CreateIconFromResource(lpResDataOfCursor, dwResSizeOfCursor, FALSE, $00030000);

          g_SavedCursors.SaveCursor(Result, hInstance, lpCursorName);
        end;
      end;
    end;
  end
  else
     Result := LoadCursorA(hInstance, lpCursorName);
end;

function MyLoadMenuA(hInstance: HINST; lpMenuName: PAnsiChar): HCURSOR; stdcall;
var
  lpResDataOfMenu: Pointer;
  dwResSizeOfMenu: DWORD;
begin
  Result := 0;

  if GetResourceInfo(hInstance,
                     PAnsiChar(RT_MENU),
                     lpMenuName,
                     lpResDataOfMenu,
                     dwResSizeOfMenu) then
  begin
    Result := LoadMenuIndirectA(lpResDataOfMenu);
  end;
end;

function MyFlushInstructionCache(hProcess: THandle; const lpBaseAddress: Pointer; dwSize: DWORD): BOOL; stdcall;
var
  dwOldProtect: DWORD;
begin
  VirtualProtect(Pointer(lpBaseAddress), dwSize, PAGE_EXECUTE_READWRITE, @dwOldProtect);
  Result := FlushInstructionCache(hProcess, lpBaseAddress, dwSize);
end;

//==============================================================================

function MywaveOutClose(hWaveOut: HWaveOut): MMRESULT; stdcall;
begin
  EnterCriticalSection(g_CS_Audio);

  try

    if nil <> @g_FlashPlayerControlOnAudioOutputClose then g_FlashPlayerControlOnAudioOutputClose;

    Result := waveOutClose(hWaveOut);

  finally
    LeaveCriticalSection(g_CS_Audio);
  end;
end;

function MywaveOutOpen(lphWaveOut: PHWaveOut; uDeviceID: UINT; lpFormat: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWORD): MMRESULT; stdcall;
begin
  EnterCriticalSection(g_CS_Audio);

  try

    if nil <> @g_FlashPlayerControlOnAudioOutputOpen then g_FlashPlayerControlOnAudioOutputOpen(lpFormat);

    Result := waveOutOpen(lphWaveOut, uDeviceID, lpFormat, dwCallback, dwInstance, dwFlags);

    if MMSYSESERR_NOERROR = Result then
       g_DeviceBytesPerSample.Add(lphWaveOut^, lpFormat.wBitsPerSample div 8);

  finally
    LeaveCriticalSection(g_CS_Audio);
  end;
end;

function MywaveOutWrite(hWaveOut: HWAVEOUT; lpWaveOutHdr: PWaveHdr; uSize: UINT): MMRESULT; stdcall;
var
   wBytesPerSample: Cardinal;
   Value: Longint;
   i: integer;
   nCount: integer;
type
   PShortint = ^ShortInt;
   PSmallint = ^Smallint;
begin
   EnterCriticalSection(g_CS_Audio);

   try

      if nil <> @g_FlashPlayerControlOnAudioOutputWrite then
      begin

        if (-1 = g_dwAudioWriteStartTime) then g_dwAudioWriteStartTime := GetTickCount;




        if (GetTickCount - g_dwAudioWriteStartTime > 15 * 1000) then
           g_FlashPlayerControlOnAudioOutputWrite := nil;


        if nil <> @g_FlashPlayerControlOnAudioOutputWrite then
          g_FlashPlayerControlOnAudioOutputWrite(lpWaveOutHdr, uSize);

      end;

      if not g_bAudioEnabled then
        ZeroMemory(lpWaveOutHdr.lpData, lpWaveOutHdr.dwBufferLength)
      else
      begin
         if g_DeviceBytesPerSample.Find(hWaveOut, wBytesPerSample) then
         begin
            if wBytesPerSample = 1 then
            begin
               nCount := lpWaveOutHdr.dwBufferLength;

               for i := 0 to nCount - 1 do
               begin
                  Value := Longint(PShortint(Cardinal(lpWaveOutHdr.lpData) + i)^);
                  Value := Value * g_dwAudioVolume;
                  Value := Value div 100;
                  PShortint(Cardinal(lpWaveOutHdr.lpData) + i)^ := Shortint(Value);
               end;
            end
            else if wBytesPerSample = 2 then
            begin
               if 0 = (lpWaveOutHdr.dwBufferLength mod 2) then
                  nCount := lpWaveOutHdr.dwBufferLength div 2
               else
                  nCount := (lpWaveOutHdr.dwBufferLength - 1) div 2;

               for i := 0 to nCount - 1 do
               begin
                  Value := Longint(PSmallint(Cardinal(lpWaveOutHdr.lpData) + i * sizeof(Smallint))^);
                  Value := Value * g_dwAudioVolume;
                  Value := Value div 100;
                  PSmallint(Cardinal(lpWaveOutHdr.lpData) + i * sizeof(Smallint))^ := Smallint(Value);
               end;
            end;
         end;
      end;

   Result := waveOutWrite(hWaveOut, lpWaveOutHdr, uSize);

   finally
      LeaveCriticalSection(g_CS_Audio);
   end;
end;

function MyVirtualAlloc(lpAddress: Pointer; dwSize, flAllocationType, flProtect: DWORD): Pointer; stdcall;
var
  mem_info: TMemoryBasicInformation;
begin
   if (nil <> lpAddress) and (0 <> ( PAGE_GUARD and flProtect ) ) then
   begin
      flProtect := flProtect and (not PAGE_GUARD);
   
      VirtualQuery(lpAddress, mem_info, sizeof(mem_info));
      dwSize := mem_info.RegionSize;
   end;

   Result := VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect);
end;

function MyReadFile(hFile: THandle; var Buffer; nNumberOfBytesToRead: DWORD;
  var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped): BOOL; stdcall;
var
   Stream: TStream;
   nNumberOfBytesRead: DWORD;
begin
   Stream := g_ContentManager.FindFakeHandleStream(hFile);

   if Stream <> nil then
   begin
      try
         nNumberOfBytesRead := Stream.Read(Buffer, nNumberOfBytesToRead);
         if @lpNumberOfBytesRead <> nil then lpNumberOfBytesRead := nNumberOfBytesRead;
         Result := true;
      except
         Result := false;
      end;
   end
   else
      Result := ReadFile(hFile, Buffer, nNumberOfBytesToRead, lpNumberOfBytesRead, lpOverlapped);
end;

function MyCloseHandle(hObject: THandle): BOOL; stdcall;
begin
   if g_ContentManager.CloseFakeHandleAndReleaseStream(hObject) then
      Result := true
   else
      Result := CloseHandle(hObject);
end;

function MyGetFileSize(hFile: THandle; lpFileSizeHigh: Pointer): DWORD; stdcall;
var
   Stream: TStream;
begin
   Stream := g_ContentManager.FindFakeHandleStream(hFile);

   if Stream <> nil then
   begin
      try
         Result := DWORD(Stream.Size);
         if lpFileSizeHigh <> nil then PDWORD(lpFileSizeHigh)^ := DWORD(Stream.Size shr (8 * sizeof(DWORD)));
      except
         Result := 0;
      end;
   end
   else
      Result := GetFileSize(hFile, lpFileSizeHigh);
end;

function MySetFilePointer(hFile: THandle; lDistanceToMove: Longint;
  lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall;
var
   Stream: TStream;
begin
   Stream := g_ContentManager.FindFakeHandleStream(hFile);

   if Stream <> nil then
   begin
      try
         Stream.Seek(lDistanceToMove, dwMoveMethod);
         Result := DWORD(Stream.Position);
         if lpDistanceToMoveHigh <> nil then PDWORD(lpDistanceToMoveHigh)^ := DWORD(Stream.Position shr (8 * sizeof(DWORD)));
      except
         Result := DWORD(-1) { INVALID_SET_FILE_POINTER };
      end;
   end
   else
      Result := SetFilePointer(hFile, lDistanceToMove, lpDistanceToMoveHigh, dwMoveMethod);
end;

type
  LARGE_INTEGER = record
    case Integer of
    0: (
      LowPart: DWORD;
      HighPart: Longint);
    1: (
      QuadPart: LONGLONG);
  end;
  PLARGE_INTEGER = ^LARGE_INTEGER;

  ULARGE_INTEGER = record
    case Integer of
    0: (
      LowPart: DWORD;
      HighPart: DWORD);
    1: (
      QuadPart: LONGLONG);
  end;
  PULARGE_INTEGER = ^ULARGE_INTEGER;

function MyGetFileSizeEx(hFile: THandle; lpFileSize: PLARGE_INTEGER): BOOL; stdcall;
type
   PGetFileSizeEx = function(hFile: THandle; lpFileSize: PLARGE_INTEGER): BOOL; stdcall;
var
   AddressOfGetFileSizeEx: PGetFileSizeEx;
   Stream: TStream;
begin
   @AddressOfGetFileSizeEx := GetProcAddress(GetModuleHandleA('kernel32.dll'), 'GetFileSizeEx');

   Stream := g_ContentManager.FindFakeHandleStream(hFile);

   if Stream <> nil then
   begin
      try
         if lpFileSize <> nil then lpFileSize.QuadPart := Stream.Size;
         Result := TRUE;
      except
         Result := FALSE;
      end
   end
   else
   begin
      if nil <> @AddressOfGetFileSizeEx then
         Result := AddressOfGetFileSizeEx(hFile, lpFileSize)
      else
      begin
         if lpFileSize <> nil then
            lpFileSize.LowPart := MyGetFileSize(hFile, @lpFileSize.HighPart);

         Result := TRUE;
      end
   end
end;

function MySetFilePointerEx(hFile: THandle; lDistanceToMove: LARGE_INTEGER; lpNewFilePointer: PLARGE_INTEGER; dwMoveMethod: DWORD): BOOL; stdcall;
type
   PSetFilePointerEx = function(hFile: THandle; lDistanceToMove: LARGE_INTEGER; lpNewFilePointer: PLARGE_INTEGER; dwMoveMethod: DWORD): BOOL; stdcall;
var
   AddressOfSetFilePointerEx: PSetFilePointerEx;
   Stream: TStream;
begin
   Stream := g_ContentManager.FindFakeHandleStream(hFile);

   if Stream <> nil then
   begin
      try
{$IFDEF DEF_BIG_STREAM_NOT_SUPPORTED}
         Stream.Seek(lDistanceToMove.LowPart, dwMoveMethod);
         if lpNewFilePointer <> nil then
         begin
            lpNewFilePointer.HighPart := 0;
            lpNewFilePointer.LowPart := Stream.Position;
         end;
{$ENDIF}
{$IFNDEF DEF_BIG_STREAM_NOT_SUPPORTED}
         Stream.Seek(lDistanceToMove.QuadPart, dwMoveMethod);
         if lpNewFilePointer <> nil then
            lpNewFilePointer.QuadPart := Stream.Position;
{$ENDIF}
         Result := TRUE;
      except
         Result := FALSE;
      end;
   end
   else
   begin
      @AddressOfSetFilePointerEx := GetProcAddress(GetModuleHandleA('kernel32.dll'), 'SetFilePointerEx');
      if nil <> @AddressOfSetFilePointerEx then
         Result := AddressOfSetFilePointerEx(hFile, lDistanceToMove, lpNewFilePointer, dwMoveMethod)
      else
      begin
         Result := TRUE;
         MySetFilePointer(hFile, lDistanceToMove.LowPart, nil, dwMoveMethod);
         // TODO: how about returning new value of position?
      end;
   end;
end;

function MyGetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
var
  p: FARPROC;
begin
  p := nil;

  if g_FlashOCXCodeProvider <> nil then
     if g_FlashOCXCodeProvider.FlashOCXLoader <> nil then
        p := FARPROC(g_FlashOCXCodeProvider.FlashOCXLoader.OnGetImportedProcAddress('kernel32.dll', lpProcName));

  if p = nil then
     Result := GetProcAddress(hModule, lpProcName)
  else
     Result := p;
end;

procedure TContentManager.AddFakeHandleAndStream(Handle: THandle; Stream: TStream; FlashPlayerControl: IFlashPlayerControlBase);
begin
  try

  EnterCriticalSection(m_ListOfFlashPlayerControlIdPairCS);

  m_ListOfFakeHandleStream.Add(TFakeHandleStreamPair.Create(Handle, Stream, FlashPlayerControl));

  finally

  LeaveCriticalSection(m_ListOfFlashPlayerControlIdPairCS);

  end;

end;

function TContentManager.FindFakeHandleStream(Handle: THandle): TStream;
var
  nIndex: integer;
  Pair: TFakeHandleStreamPair;
begin
  Result := nil;

  try

  EnterCriticalSection(m_ListOfFlashPlayerControlIdPairCS);

  for nIndex := 0 to m_ListOfFakeHandleStream.Count - 1 do
  begin
    Pair := TFakeHandleStreamPair(m_ListOfFakeHandleStream[nIndex]);

    if Pair.m_Handle = Handle then
    begin
      Result := Pair.m_Stream;
      break;
    end;
  end;

  finally

  LeaveCriticalSection(m_ListOfFlashPlayerControlIdPairCS);

  end;

end;

function TContentManager.CloseFakeHandleAndReleaseStream(Handle: THandle): BOOL;
var
  nIndex: integer;
  Pair: TFakeHandleStreamPair;
begin
  Result := False;

  try

  EnterCriticalSection(m_ListOfFlashPlayerControlIdPairCS);

  for nIndex := 0 to m_ListOfFakeHandleStream.Count - 1 do
  begin
    Pair := TFakeHandleStreamPair(m_ListOfFakeHandleStream[nIndex]);

    if Pair.m_Handle = Handle then
    begin
      Pair.Free;
      m_ListOfFakeHandleStream.Delete(nIndex);
      Result := True;
      break;
    end;
  end;

  finally

  LeaveCriticalSection(m_ListOfFlashPlayerControlIdPairCS);

  end;

end;

function TContentManager.CreateFakeFile(lpFileName: PWideChar;
                                        dwDesiredAccess, dwShareMode: DWORD;
                                        lpSecurityAttributes: PSecurityAttributes;
                                        dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                                        hTemplateFile: THandle): THandle;
var
   Stream: TStream;

   nId: integer;
   strRelativePart: WideString;
   FlashPlayerControl: IFlashPlayerControlBase;
begin
   Result := INVALID_HANDLE_VALUE;
   Stream := nil;

   if ParseURL(lpFileName, nId, strRelativePart) then
   begin
     FlashPlayerControl := FindObject(nId);

     if FlashPlayerControl <> nil then
        FlashPlayerControl.IFlashPlayerControlBase_CallOnLoadExternalResourceAsync(strRelativePart, Stream);
   end;

   if Stream = nil then
      if assigned(g_GlobalOnLoadExternalResourceHandlerAsync) then
         g_GlobalOnLoadExternalResourceHandlerAsync(lpFileName, Stream);

   if Stream <> nil then
   begin
      Stream.Position := 0;

      Result := CreateEvent(nil, false, false, nil);

      AddFakeHandleAndStream(Result, Stream, FlashPlayerControl);
   end;
end;

function MyCreateFileW(lpFileName: PWideChar;
                       dwDesiredAccess, dwShareMode: DWORD;
                       lpSecurityAttributes: PSecurityAttributes;
                       dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                       hTemplateFile: THandle): THandle; stdcall
begin
  Result := g_ContentManager.CreateFileW(lpFileName,
                                         dwDesiredAccess,
                                         dwShareMode,
                                         lpSecurityAttributes,
                                         dwCreationDisposition,
                                         dwFlagsAndAttributes,
                                         hTemplateFile);
end;

//==============================================================================
// TFlashOCXLoader implementation...BEGIN

function TFlashOCXLoader.OnGetImportedProcAddress(lpszDLLName: LPCTSTR; lpszProcName: LPCTSTR): Pointer;
begin

  Result := nil;

  if HiWord(cardinal(lpszProcName)) <> 0 then
    if lstrcmpA(lpszProcName, 'CreateURLMoniker') = 0 then
      Result := @MyCreateURLMoniker
    else if lstrcmpA(lpszProcName, 'RegisterClassExA') = 0 then
      Result := @MyRegisterClassExA
    else if lstrcmpA(lpszProcName, 'RegisterClassA') = 0 then
      Result := @MyRegisterClassA
    else if lstrcmpA(lpszProcName, 'RegisterClassExW') = 0 then
      Result := @MyRegisterClassExW
    else if lstrcmpA(lpszProcName, 'RegisterClassW') = 0 then
      Result := @MyRegisterClassW
    else if lstrcmpA(lpszProcName, 'CreateWindowExA') = 0 then
      Result := @MyCreateWindowExA
    else if lstrcmpA(lpszProcName, 'CreateWindowExW') = 0 then
      Result := @MyCreateWindowExW
    else if lstrcmpA(lpszProcName, 'LoadCursorA') = 0 then
      Result := @MyLoadCursorA
    else if lstrcmpA(lpszProcName, 'LoadMenuA') = 0 then
      Result := @MyLoadMenuA
    else if lstrcmpA(lpszProcName, 'waveOutWrite') = 0 then
      Result := @MywaveOutWrite
    else if lstrcmpA(lpszProcName, 'waveOutOpen') = 0 then
      Result := @MywaveOutOpen
    else if lstrcmpA(lpszProcName, 'waveOutClose') = 0 then
      Result := @MywaveOutClose
    else if lstrcmpA(lpszProcName, 'FlushInstructionCache') = 0 then
      Result := @MyFlushInstructionCache
    else if lstrcmpA(lpszProcName, 'CreateFileA') = 0 then
      Result := @MyCreateFileA
    else if lstrcmpA(lpszProcName, 'VirtualAlloc') = 0 then
      Result := @MyVirtualAlloc
    else if lstrcmpA(lpszProcName, 'ReadFile') = 0 then
      Result := @MyReadFile
    else if lstrcmpA(lpszProcName, 'CloseHandle') = 0 then
      Result := @MyCloseHandle
    else if lstrcmpA(lpszProcName, 'GetFileSize') = 0 then
      Result := @MyGetFileSize
    else if lstrcmpA(lpszProcName, 'GetFileSizeEx') = 0 then
      Result := @MyGetFileSizeEx
    else if lstrcmpA(lpszProcName, 'SetFilePointer') = 0 then
      Result := @MySetFilePointer
    else if lstrcmpA(lpszProcName, 'SetFilePointerEx') = 0 then
      Result := @MySetFilePointerEx
    else if lstrcmpA(lpszProcName, 'CreateFileW') = 0 then
      Result := @MyCreateFileW
    else if lstrcmpA(lpszProcName, 'GetProcAddress') = 0 then
      Result := @MyGetProcAddress;
end;

// TFlashOCXLoader implementation...END
//==============================================================================

//==============================================================================
// TMyMoniker...BEGIN

function TMyMoniker.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
  if GetInterface(IID, Obj) then
  begin
    Result := S_OK;
    Exit;
  end;

  Result := E_NOINTERFACE;
end;

function TMyMoniker._AddRef: Integer; stdcall;
begin
  inc(FRefCount);
  Result := FRefCount;
end;

function TMyMoniker._Release: Integer; stdcall;
begin
  dec(FRefCount);

  Result := FRefCount;

  if 0 >= FRefCount then
    Destroy;
end;

function TMyMoniker.BindToObject(const bc: IBindCtx; const mkToLeft: IMoniker;
      const iidResult: TIID; out vResult): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.BindToObject(bc, mkToLeft, iidResult, vResult);
end;

function TMyMoniker.BindToStorage(const bc: IBindCtx; const mkToLeft: IMoniker; const iid: TIID; out vObj): HResult; stdcall;
var
  MyBindStatusCallback: TMyBindStatusCallback;
  pOldBindStatusCallback: IBindStatusCallback;
begin
  MyBindStatusCallback := TMyBindStatusCallback.Create;

  g_pRegisterBindStatusCallback(bc, MyBindStatusCallback, pOldBindStatusCallback, 0);

  MyBindStatusCallback.m_pOldBindStatusCallback := pOldBindStatusCallback;

  Result := g_ContentManager.BindToStorage(bc, mkToLeft, iid, m_pmkContext, MyBindStatusCallback, URL, vObj);
end;

function TMyMoniker.Reduce(const bc: IBindCtx; dwReduceHowFar: Longint;
      mkToLeft: PIMoniker; out mkReduced: IMoniker): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.Reduce(bc, dwReduceHowFar, mkToLeft, mkReduced);
end;

function TMyMoniker.ComposeWith(const mkRight: IMoniker; fOnlyIfNotGeneric: BOOL;
      out mkComposite: IMoniker): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.ComposeWith(mkRight, fOnlyIfNotGeneric, mkComposite);
end;

function TMyMoniker.Enum(fForward: BOOL; out enumMoniker: IEnumMoniker): HResult;
      stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.Enum(fForward, enumMoniker);
end;

function TMyMoniker.IsEqual(const mkOtherMoniker: IMoniker): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.IsEqual(mkOtherMoniker);
end;

function TMyMoniker.Hash(out dwHash: Longint): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.Hash(dwHash);
end;

function TMyMoniker.IsRunning(const bc: IBindCtx; const mkToLeft: IMoniker;
      const mkNewlyRunning: IMoniker): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.IsRunning(bc, mkToLeft, mkNewlyRunning);
end;

function TMyMoniker.GetTimeOfLastChange(const bc: IBindCtx; const mkToLeft: IMoniker;
      out filetime: TFileTime): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.GetTimeOfLastChange(bc, mkToLeft, filetime);
end;

function TMyMoniker.Inverse(out mk: IMoniker): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.Inverse(mk);
end;

function TMyMoniker.CommonPrefixWith(const mkOther: IMoniker;
      out mkPrefix: IMoniker): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.CommonPrefixWith(mkOther, mkPrefix);
end;

function TMyMoniker.RelativePathTo(const mkOther: IMoniker;
      out mkRelPath: IMoniker): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.RelativePathTo(mkOther, mkRelPath);
end;

function TMyMoniker.GetDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker; out pszDisplayName: POleStr): HResult; stdcall;
(*
var
  mk: IMoniker;
  wstrURL: WideString;
*)
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.GetDisplayName(bc, mkToLeft, pszDisplayName);

(*
  // Пытался возвращать ту?E_NOTIMPL, но тогд?падает гд?то внутри urlmon.dll (?случае flash 3)
  // пр?попытк?нажать на внешни?линк на флешке

  wstrURL := URL;
  g_pCreateURLMoniker(m_pmkContext, PWideChar(wstrURL), mk);

  if assigned(mk) then
    Result := mk.GetDisplayName(bc, mkToLeft, pszDisplayName)
  else
    Result := E_NOTIMPL;
*)
end;

function TMyMoniker.ParseDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker;
      pszDisplayName: POleStr; out chEaten: Longint;
      out mkOut: IMoniker): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.ParseDisplayName(bc, mkToLeft, pszDisplayName, chEaten, mkOut);
end;

function TMyMoniker.IsSystemMoniker(out dwMksys: Longint): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.IsSystemMoniker(dwMksys);
end;

function TMyMoniker.IsDirty: HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.IsDirty;
end;

function TMyMoniker.Load(const stm: IStream): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.Load(stm);
end;

function TMyMoniker.Save(const stm: IStream; fClearDirty: BOOL): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.Save(stm, fClearDirty);
end;

function TMyMoniker.GetSizeMax(out cbSize: Largeint): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.GetSizeMax(cbSize);
end;

function TMyMoniker.GetClassID(out classID: TCLSID): HResult; stdcall;
begin
  if m_pStandardURLMoniker = nil then
  begin
  	Result := E_FAIL;
	Exit;
  end;

  Result := m_pStandardURLMoniker.GetClassID(classID);
end;

function TMyMoniker.Abort: HResult; stdcall;
begin
  Result := E_FAIL;
end;

function TMyMoniker.Suspend: HResult; stdcall;
begin
  Result := E_FAIL;
end;

function TMyMoniker.Resume: HResult; stdcall;
begin
  Result := E_FAIL;
end;

function TMyMoniker.SetPriority(nPriority: Longint): HResult; stdcall;
begin
  Result := E_FAIL;
end;

function TMyMoniker.IBinding_GetPriority(out nPriority: Longint): HResult; stdcall;
begin
  Result := E_FAIL;
end;

function TMyMoniker.GetBindResult(out clsidProtocol: TCLSID; out dwResult: DWORD;
      out szResult: POLEStr; dwReserved: DWORD): HResult; stdcall;
begin
  Result := E_FAIL;
end;

constructor TMyMoniker.Create(pmkContext: IMoniker; URL: WideString);
var
  wstrURL: WideString;
begin
  Self.URL := URL;
  FRefCount := 0;
  m_pmkContext := pmkContext;

  m_pStandardURLMoniker := nil;
  wstrURL := URL;
  g_pCreateURLMoniker(pmkContext, PWideChar(wstrURL), m_pStandardURLMoniker);
end;

destructor TMyMoniker.Destroy;
begin
end;

// TMyMoniker...END
//==============================================================================

//==============================================================================
// TMyBindStatusCallback...BEGIN

function TMyBindStatusCallback.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
  Result := E_NOINTERFACE;

  if GetInterface(IID, Obj) then
  begin
    Result := S_OK;
    Exit;
  end;

  if assigned(m_pOldBindStatusCallback) then
    Result := m_pOldBindStatusCallback.QueryInterface(IID, Obj);
end;

function TMyBindStatusCallback._AddRef: Integer; stdcall;
begin
  inc(FRefCount);
  Result := FRefCount;
end;

function TMyBindStatusCallback._Release: Integer; stdcall;
begin
  dec(FRefCount);

  Result := FRefCount;

  if 0 >= FRefCount then
    Destroy;
end;

function TMyBindStatusCallback.OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult; stdcall;
begin
  if assigned(m_pOldBindStatusCallback) then
    Result := m_pOldBindStatusCallback.OnStartBinding(dwReserved, pib)
  else
    Result := E_NOTIMPL;  
end;

function TMyBindStatusCallback.IBindStatusCallback_GetPriority(out nPriority): HResult; stdcall;
begin
  if assigned(m_pOldBindStatusCallback) then
    Result := m_pOldBindStatusCallback.GetPriority(nPriority)
  else
    Result := E_NOTIMPL;  
end;

function TMyBindStatusCallback.OnLowResource(reserved: DWORD): HResult; stdcall;
begin
  if assigned(m_pOldBindStatusCallback) then
    Result := m_pOldBindStatusCallback.OnLowResource(reserved)
  else
    Result := E_NOTIMPL;  
end;

function TMyBindStatusCallback.OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG;
      szStatusText: LPCWSTR): HResult; stdcall;
begin
  if assigned(m_pOldBindStatusCallback) then
    Result := m_pOldBindStatusCallback.OnProgress(ulProgress, ulProgressMax, ulStatusCode, szStatusText)
  else
    Result := E_NOTIMPL;  
end;

function TMyBindStatusCallback.OnStopBinding(hresult: HResult; szError: LPCWSTR): HResult; stdcall;
begin
  if assigned(m_pOldBindStatusCallback) then
    Result := m_pOldBindStatusCallback.OnStopBinding(hresult, szError)
  else
    Result := E_NOTIMPL;  
end;

function TMyBindStatusCallback.GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
begin
  if assigned(m_pOldBindStatusCallback) then
    Result := m_pOldBindStatusCallback.GetBindInfo(grfBINDF, bindinfo)
  else
    Result := E_NOTIMPL;  
end;

function TMyBindStatusCallback.OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc;
      stgmed: PStgMedium): HResult; stdcall;
begin
  if assigned(m_pOldBindStatusCallback) then
    Result := m_pOldBindStatusCallback.OnDataAvailable(grfBSCF, dwSize, formatetc, stgmed)
  else
    Result := E_NOTIMPL;  
end;

function TMyBindStatusCallback.OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;
begin
  if assigned(m_pOldBindStatusCallback) then
    Result := m_pOldBindStatusCallback.OnObjectAvailable(iid, punk)
  else
    Result := E_NOTIMPL;
end;

constructor TMyBindStatusCallback.Create;
begin
  FRefCount := 0;
  m_pOldBindStatusCallback := nil;
end;

destructor TMyBindStatusCallback.Destroy;
begin
end;

// TMyBindStatusCallback...END
//==============================================================================

//============================================================================
// TFlashOCXCodeProviderBasedOnSystemInstalledOCX...BEGIN

constructor TFlashOCXCodeProviderBasedOnSystemInstalledOCX.Create;
var
  lpszFlashOCXPath: Cardinal;
  Stream: THandleStream;
  hFlashRegKey: HKEY;
  lRes: LongInt;
  dwBufferSize: DWORD;
  hFile: THandle;
begin

  g_FlashOCXCodeProvider := Self;

  //
  lRes :=
    RegOpenKeyExA(HKEY_CLASSES_ROOT,
                 'CLSID\{D27CDB6E-AE6D-11cf-96B8-444553540000}\InprocServer32',
                 0,
                 KEY_QUERY_VALUE,
                 hFlashRegKey);

  if lRes = ERROR_SUCCESS then
  begin
    dwBufferSize := MAX_PATH + 1;
    lpszFlashOCXPath := LocalAlloc(LPTR, dwBufferSize);

    ZeroMemory(Pointer(lpszFlashOCXPath), dwBufferSize);

    lRes :=
      RegQueryValueExA(hFlashRegKey,
                      '',
                      nil,
                      nil,
                      PByte(lpszFlashOCXPath),
                      @dwBufferSize);

    if lRes = ERROR_SUCCESS then
    begin
      hFile := CreateFileA(PAnsiChar(lpszFlashOCXPath), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);

      if INVALID_HANDLE_VALUE <> hFile then
      begin
        Stream := THandleStream.Create(hFile);
        inherited Create(Stream);
        Stream.Free;
        CloseHandle(hFile);
      end;

     RegCloseKey(hFlashRegKey);
    end;

    LocalFree(lpszFlashOCXPath);

  end;

end;

// TFlashOCXCodeProviderBasedOnSystemInstalledOCX...END
//============================================================================

//============================================================================
// TFlashOCXCodeProvider...BEGIN

//function TFlashOCXCodeProvider.GetVersion;
//begin
//  Result := 0;
//end;

// TFlashOCXCodeProvider...END
//============================================================================

//============================================================================
// TFlashOCXCodeProviderBasedOnStream...BEGIN

constructor TFlashOCXCodeProviderBasedOnStream.Create(AStream: TStream);
const
  IID_IClassFactory: TGUID = (
    D1:$00000001;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
begin
    inherited Create;

    g_FlashOCXCodeProvider := Self;

    dwFlashVersion := 0;

    pDllGetClassObjectFunction := nil;

    if nil = AStream then Exit;

  try
    FlashOCXLoader := TFlashOCXLoader.Create;
    FlashOCXLoader.Load(AStream);
    @pDllGetClassObjectFunction := FlashOCXLoader.GetProcAddress('DllGetClassObject');

    dwFlashVersion := GetModuleVersion(FlashOCXLoader.hModule);
  except

  end;

end;

destructor TFlashOCXCodeProviderBasedOnStream.Destroy;
begin
  try
    FlashOCXLoader.Free;
  except
  end;
  inherited Destroy;
end;

function TFlashOCXCodeProviderBasedOnStream.GetVersion;
begin
  Result := dwFlashVersion;
end;

function TFlashOCXCodeProviderBasedOnStream.HookFunc(DLLName: AnsiString; ProcName: AnsiString; AddressOfNewFunction: Pointer): boolean;
begin
   Result := false;

   if FlashOCXLoader <> nil then
   begin
      Result := FlashOCXLoader.HookFunc(DLLName, ProcName, AddressOfNewFunction);
   end;
end;

function TFlashOCXCodeProviderBasedOnStream.CreateInstance(const iid: TIID; out pv): HResult;
const
  IID_IClassFactory: TGUID = (
    D1:$00000001;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
var
  pClassFactory: IClassFactory;
begin

  Result := E_FAIL;

  try
    if nil <> @pDllGetClassObjectFunction then
      if S_OK = pDllGetClassObjectFunction(CLASS_ShockwaveFlash, IID_IClassFactory, pClassFactory) then
      begin
        pClassFactory.CreateInstance(nil, IID, pv);
        pClassFactory := nil;
        Result := S_OK;
      end;
  finally
  end;

end;

// TFlashOCXCodeProviderBasedOnStream...END
//============================================================================

//============================================================================
// TURLContentProviderPair...BEGIN

constructor TURLContentProviderPair.Create(strURL: WideString; pContentProvider: IContentProvider);
begin
  Self.m_strURL := strURL;
  m_pContentProvider := pContentProvider;
end;

destructor TURLContentProviderPair.Destroy;
begin
  m_pContentProvider := nil;
end;

// TURLContentProviderPair...END
//============================================================================

//============================================================================
// TMapCardinal2Cardinal

constructor TCardinalPair.Create(TheCardinal1: Cardinal; TheCardinal2: Cardinal);
begin
   Cardinal1 := TheCardinal1;
   Cardinal2 := TheCardinal2;
end;

constructor TMapCardinal2Cardinal.Create;
begin
   FListOfCardinalPair := TList.Create;
end;

destructor TMapCardinal2Cardinal.Destroy;
var
   i: Integer;
begin
   for i := 0 to FListOfCardinalPair.Count - 1 do
      TCardinalPair(FListOfCardinalPair[i]).Free;

   FListOfCardinalPair.Free;
end;

procedure TMapCardinal2Cardinal.Add(Cardinal1: Cardinal; Cardinal2: Cardinal);
begin
   FListOfCardinalPair.Add(TCardinalPair.Create(Cardinal1, Cardinal2));
end;

function TMapCardinal2Cardinal.Find(Cardinal1: Cardinal; var Cardinal2: Cardinal): boolean;
var
   i: Integer;
begin
   Result := False;

   for i := 0 to FListOfCardinalPair.Count - 1 do
      if TCardinalPair(FListOfCardinalPair[i]).Cardinal1 = Cardinal1 then
      begin
         Cardinal2 := TCardinalPair(FListOfCardinalPair[i]).Cardinal2;
         
         Result := True;
         break;
      end;
end;

//============================================================================

//============================================================================
// TMapString2String

constructor TStringPair.Create(TheString1: WideString; TheString2: WideString);
begin
  String1 := TheString1;
  String2 := TheString2;
end;

constructor TMapString2String.Create;
begin
  FListOfStringPairs := TList.Create;
end;

destructor TMapString2String.Destroy;
var
  nIndex: integer;
begin
  for nIndex := 0 to FListOfStringPairs.Count - 1 do
    TStringPair(FListOfStringPairs[nIndex]).Free;

  FListOfStringPairs.Free;
end;

procedure TMapString2String.Add(String1: WideString; String2: WideString);
var
  i : Integer;
begin
  for i := 0 to FListOfStringPairs.Count - 1 do
  begin
    if 0 = lstrcmpiW(PWideChar(TStringPair(FListOfStringPairs[i]).String1), PWideChar(String1)) then
    begin
      // Save new value
      TStringPair(FListOfStringPairs[i]).String2 := String2;
      // and exit
      Exit;
    end;
  end;

  // New pair
  FListOfStringPairs.Add(TStringPair.Create(String1, String2));

end;

function TMapString2String.Find(String1: WideString; var String2: WideString): boolean;
var
  i : Integer;
begin

  Result := False;

  for i := 0 to FListOfStringPairs.Count - 1 do
  begin
    if 0 = lstrcmpiW(PWideChar(TStringPair(FListOfStringPairs[i]).String1), PWideChar(String1)) then
    begin
      String2 := TStringPair(FListOfStringPairs[i]).String2;
      Result := true;
      break;
    end;
  end;

end;

//============================================================================

//============================================================================
// TContentProvider...BEGIN

constructor TContentProvider.Create(out AStream: IStream);
begin
  InitializeCriticalSection(m_cs);

  m_bStartBindingCalled := FALSE;
  m_bDataSaved := FALSE;
  m_dwSizeOfPreSavedData := 0;
  m_bEndOfData := FALSE;
  m_pBindStatusCallback := nil;

  CreateStreamOnHGlobal(0, TRUE, m_pPreSavedData);

  AStream := TContentProviderStream.Create(Self);

  m_nSize := -1;
end;

destructor TContentProvider.Destroy;
begin
  DeleteCriticalSection(m_cs);
  m_pPreSavedData := nil;
end;

function TContentProvider.SetSize(size: Largeint): HResult; stdcall;
begin
  m_nSize := size;

  ProvideSize;

  Result := S_OK;
end;

function TContentProvider.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
  EnterCriticalSection(m_cs);
  try
    if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function TContentProvider._AddRef: Integer; stdcall;
begin
  EnterCriticalSection(m_cs);
  try
    inc(m_nRefCount);
    Result := m_nRefCount;
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function TContentProvider._Release: Integer; stdcall;
var
  nNewRefCount: integer;
begin
  EnterCriticalSection(m_cs);
  try
    dec(m_nRefCount);
    Result := m_nRefCount;

    nNewRefCount := m_nRefCount;
  finally
    LeaveCriticalSection(m_cs);
  end;

  if nNewRefCount = 0 then Destroy;
end;

procedure TContentProvider.ProvideSize;
var
   pHttpNegotiate: IHttpNegotiate;
   szAdditionalRequestHeaders: LPWSTR;
   str: WideString;
   size: longint;
begin
   if S_OK = m_pBindStatusCallback.QueryInterface(IHttpNegotiate, pHttpNegotiate) then
   begin
      if assigned(pHttpNegotiate) then
      begin
         szAdditionalRequestHeaders := nil;
         size := CompAsTwoLongs(m_nSize).LoL;
         str := Format('HTTP/1.1 200 OK'#13#10'Content-Length: %d'#13#10, [ size ] );
         pHttpNegotiate.OnResponse(200, PWideChar(str), nil, szAdditionalRequestHeaders);
      end;
   end;
end;

procedure TContentProvider.OnStartBinding;
begin
   if not(m_bStartBindingCalled) then
   begin
      ProvideSize;

      m_pBindStatusCallback.OnStartBinding(0, nil);

      m_bStartBindingCalled := true;
   end;
end;

function TContentProvider.SetBindStatusCallback(pBindStatusCallback: IBindStatusCallback): HRESULT; stdcall;
var
  stgmedium: TStgMedium;
  formatec: TFormatEtc;
  liNewPosition: LargeUInt;
begin
  EnterCriticalSection(m_cs);

  try
    // Запоминаем BindStatusCallback
    m_pBindStatusCallback := pBindStatusCallback;

    if m_bDataSaved then
      // Чт?то уж?было записано
    begin
      OnStartBinding;

      // Позиционируемся ?начало потока
      m_pPreSavedData.Seek(0, STREAM_SEEK_SET, liNewPosition);

      ZeroMemory(@formatec, SizeOf(formatec));
      formatec.cfFormat := 0;
      formatec.ptd := nil;
      formatec.dwAspect := DVASPECT_CONTENT;
      formatec.lindex := -1;
      formatec.tymed := TYMED_ISTREAM;

      ZeroMemory(@stgmedium, SizeOf(stgmedium));
      stgmedium.tymed := TYMED_ISTREAM;
      stgmedium.stm := Pointer(m_pPreSavedData);
      stgmedium.unkForRelease := nil;

      pBindStatusCallback.OnDataAvailable(BSCF_FIRSTDATANOTIFICATION or BSCF_LASTDATANOTIFICATION,
                                          m_dwSizeOfPreSavedData,
                                          @formatec,
                                          @stgmedium);

      m_pPreSavedData := nil;

      if m_bEndOfData then
        m_pBindStatusCallback.OnStopBinding(0, nil);
    end;
  finally
    LeaveCriticalSection(m_cs);
  end;

  Result := S_OK;
end;

// S_OK - saved, S_FALSE - not saved
function TContentProvider.IsDataSaved: HRESULT; stdcall;
begin
  EnterCriticalSection(m_cs);

  try
    if m_bDataSaved then Result := S_OK else Result := S_FALSE;
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function TContentProvider.EndOfData: HRESULT; stdcall;
begin
  EnterCriticalSection(m_cs);

  try
    m_bEndOfData := TRUE;

    if m_bDataSaved then
    begin
      if assigned(m_pBindStatusCallback) then
      begin
        OnStartBinding;

        // Коне?данных
        m_pBindStatusCallback.OnStopBinding(0, nil);

      end;
    end;

    Result := S_OK;
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function TContentProvider.Write(pv: Pointer; cb: Longint; pcbWritten: PFixedUInt): HRESULT;
var
  hr: HRESULT;
  pMemStream: IStream;
  stgmedium: TStgMedium;
  formatec: TFormatEtc;
  liNewPosition: LargeUInt;
begin
  EnterCriticalSection(m_cs);

  try
//    hr := S_OK;

    m_bDataSaved := TRUE;

    if assigned(m_pBindStatusCallback) then
      // Есть куда передавать данные
    begin
      OnStartBinding;

      CreateStreamOnHGlobal(0, TRUE, pMemStream);

      pMemStream.Write(pv, cb, pcbWritten);

      // Позиционируемся ?начало потока
      pMemStream.Seek(0, STREAM_SEEK_SET, liNewPosition);

      ZeroMemory(@formatec, SizeOf(formatec));
      formatec.cfFormat := 0;
      formatec.ptd := nil;
      formatec.dwAspect := DVASPECT_CONTENT;
      formatec.lindex := -1;
      formatec.tymed := TYMED_ISTREAM;

      ZeroMemory(@stgmedium, SizeOf(stgmedium));
      stgmedium.tymed := TYMED_ISTREAM;
      stgmedium.stm := Pointer(pMemStream);
      stgmedium.unkForRelease := nil;

      hr := 
      m_pBindStatusCallback.OnDataAvailable(BSCF_FIRSTDATANOTIFICATION or BSCF_LASTDATANOTIFICATION,
                                            cb,
                                            @formatec,
                                            @stgmedium);

      MyOutputDebugString(Format('m_pBindStatusCallback.OnDataAvailable, hr = 0x%.8x\n', [ hr ]));

      if (hr <> S_OK) and (pcbWritten <> nil) then 
         pcbWritten^ := 0;

      pMemStream := nil;
    end
    else
      // Сохраняем внутрь объект?
    begin
      m_pPreSavedData.Write(pv, cb, pcbWritten);
      m_dwSizeOfPreSavedData := m_dwSizeOfPreSavedData + cb;
    end;

    Result := { hr } S_OK; // if result <> S_OK then TOleStream raises exception :(

  finally
    LeaveCriticalSection(m_cs);
  end;
end;

// TContentProvider...END
//============================================================================

//============================================================================
// TContentProviderStream...BEGIN

constructor TContentProviderStream.Create(AContentManager: IContentProvider);
begin
  InitializeCriticalSection(m_cs);
  m_pContentProvider := AContentManager;
  m_nRefCount := 0;
end;

destructor TContentProviderStream.Destroy;
begin
  m_pContentProvider.EndOfData;
  m_pContentProvider := nil;
  DeleteCriticalSection(m_cs);
end;

function TContentProviderStream.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
  EnterCriticalSection(m_cs);
  try
    if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function TContentProviderStream._AddRef: Integer; stdcall;
begin
  EnterCriticalSection(m_cs);
  try
    inc(m_nRefCount);
    Result := m_nRefCount;
  finally
    LeaveCriticalSection(m_cs);
  end;
end;

function TContentProviderStream._Release: Integer; stdcall;
var
  nNewRefCount: integer;
begin
  EnterCriticalSection(m_cs);
  try
    dec(m_nRefCount);
    Result := m_nRefCount;

    nNewRefCount := m_nRefCount;
  finally
    LeaveCriticalSection(m_cs);
  end;

  if nNewRefCount = 0 then Destroy;
end;

function TContentProviderStream.Read(pv: Pointer; cb: FixedUInt; pcbRead: PFixedUInt): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TContentProviderStream.Write(pv: Pointer; cb: FixedUInt; pcbWritten: PFixedUInt): HResult; stdcall;
begin
  Result := m_pContentProvider.Write(pv, cb, pcbWritten);
end;

function TContentProviderStream.Seek(dlibMove: Largeint; dwOrigin: DWORD; out libNewPosition: LargeUInt): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TContentProviderStream.SetSize(libNewSize: LargeUInt): HResult; stdcall;
begin
  Result := m_pContentProvider.SetSize(libNewSize);
end;

function TContentProviderStream.CopyTo(stm: IStream; cb: LargeUInt; out cbRead: LargeUInt; out cbWritten: LargeUInt): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TContentProviderStream.Commit(grfCommitFlags: DWORD): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TContentProviderStream.Revert: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TContentProviderStream.LockRegion(libOffset: LargeUInt; cb: LargeUInt; dwLockType: DWORD): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TContentProviderStream.UnlockRegion(libOffset: LargeUInt; cb: LargeUInt; dwLockType: DWORD): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TContentProviderStream.Stat(out statstg: TStatStg; grfStatFlag: DWORD): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TContentProviderStream.Clone(out stm: IStream): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

// TContentProviderStream...END
//============================================================================

//============================================================================
// TContentManager...BEGIN

constructor TFakeHandleStreamPair.Create(Handle: THandle; Stream: TStream; FlashPlayerControl: IFlashPlayerControlBase);
begin
   m_Handle := Handle;
   m_Stream := Stream;
   m_FlashPlayerControl := FlashPlayerControl;
end;

destructor TFakeHandleStreamPair.Destroy;
begin
   m_FlashPlayerControl.IFlashPlayerControlBase_CallOnUnloadExternalResourceAsync(m_Stream);
   CloseHandle(m_Handle);
   m_Stream.Free;
end;

constructor TFlashPlayerControlIdPair.Create(nId: integer; FlashPlayerControl: IFlashPlayerControlBase);
begin
  m_nId := nId;
  m_FlashPlayerControl := FlashPlayerControl;
end;

destructor TFlashPlayerControlIdPair.Destroy;
begin
end;

//
//  DEF_LOAD_FROM_MEMORY_MAGIC_STRING = '46A10F369771449587DE913EFC0A258C';
//  DEF_LOAD_FROM_MEMORY_MOVIE_FILE_NAME = 'E4ED7C01D28A43418DBF2CB92CC35E56.swf';
//
// Z:\<DEF_LOAD_FROM_MEMORY_MAGIC_STRING>\<Id>\<DEF_LOAD_FROM_MEMORY_MOVIE_FILE_NAME>
//

function TContentManager.ParseURL(const strURL: WideString; var nId: integer; var strRelativePart: WideString): boolean;
var
  nMagicStringPos: integer;
  str: WideString;
  nSlashPos: integer;
  strId: WideString;
begin
  Result := false;

  str := WideStringReplace(strURL, '\', '/');

  nMagicStringPos := FindSubstringInWideString(DEF_LOAD_FROM_MEMORY_MAGIC_STRING, str);

  if nMagicStringPos <> 0 then
  begin
    str := WideRightStr(str,
                        WideStringLen(str) - nMagicStringPos - Length(DEF_LOAD_FROM_MEMORY_MAGIC_STRING));

    if Length(str) <> 0 then
    begin
      nSlashPos := FindSubstringInWideString('/', str);

      if nSlashPos <> 0 then
      begin
        strId := WideLeftStr(str, nSlashPos - 1);
        nId := StrToInt(strId);

        strRelativePart := WideRightStr(str, WideStringLen(str) - nSlashPos);

        Result := true;
      end
    end
  end
end;

function TContentManager.IsURLsEqual(const strURL1: WideString; const strURL2: WideString): boolean;
var
  nId1, nId2: integer;
  strRelativePart1, strRelativePart2: WideString;
  bIsFromMemoryURL1, bIsFromMemoryURL2: boolean;
begin
  bIsFromMemoryURL1 := ParseURL(strURL1, nId1, strRelativePart1);
  bIsFromMemoryURL2 := ParseURL(strURL2, nId2, strRelativePart2);

  if bIsFromMemoryURL1 and (not bIsFromMemoryURL2) then
    Result := false
  else if (not bIsFromMemoryURL1) and bIsFromMemoryURL2 then
    Result := false
  else if bIsFromMemoryURL1 and bIsFromMemoryURL2 then
    Result := (nId1 = nId2) and CompareWideString(strRelativePart1, strRelativePart2)
  else
    Result := CompareWideString(strURL1, strURL2);
end;

constructor TContentManager.Create;
begin
  m_nNextId := 1;

  m_ListOfURLContentProviderPair := TList.Create;
  m_ListOfFlashPlayerControlIdPair := TList.Create;

  m_ListOfFakeHandleStream := TList.Create;
  InitializeCriticalSection(m_ListOfFlashPlayerControlIdPairCS);
end;

destructor TContentManager.Destroy;
begin
  m_ListOfURLContentProviderPair.Free;
  m_ListOfFlashPlayerControlIdPair.Free;
  m_ListOfFakeHandleStream.Free;
  DeleteCriticalSection(m_ListOfFlashPlayerControlIdPairCS);
end;

function TContentManager.CallLoadExternalResource(FlashPlayerControl: IFlashPlayerControlBase;
                                                  strRelativePart: WideString;
                                                  pStream: IStream): Boolean;
var
  AStream: TStream;
  MemoryStream: TMemoryStream;
  bHandled: Boolean;
begin
  if Length(strRelativePart) > 0 then
    if strRelativePart[1] = '/' then
      strRelativePart := WideRightStr(strRelativePart, WideStringLen(strRelativePart) - 1);

  bHandled := FALSE;

  AStream := TSynchronizedStreamWrapper.Create( TStreamBasedOnIStream.Create(pStream) );

  FlashPlayerControl.IFlashPlayerControlBase_CallOnLoadExternalResourceEx(strRelativePart, AStream, bHandled);

  if not bHandled then
  begin
    MemoryStream := TMemoryStream.Create;
    FlashPlayerControl.IFlashPlayerControlBase_CallOnLoadExternalResource(strRelativePart, MemoryStream);
    bHandled := (MemoryStream.Size > 0);
    MemoryStream.Position := 0;
    MemoryStream.SaveToStream(AStream);
    AStream.Free;
    MemoryStream.Free;
  end;

  Result := bHandled;
end;

function GetCurrentDirectory: WideString;
type
   TGetCurrentDirectoryW =
      function(nBufferLength: DWORD; lpBuffer: PWideChar): DWORD; stdcall;
var
   pGetCurrentDirectoryW: TGetCurrentDirectoryW;
   nBufferLength: DWORD;
   pBuffer: Pointer;
   ch: WideChar;
begin
   @pGetCurrentDirectoryW := GetProcAddress(GetModuleHandle('kernel32.dll'), 'GetCurrentDirectoryW');

   if @pGetCurrentDirectoryW <> nil then
   begin
      nBufferLength := pGetCurrentDirectoryW(1, @ch);
      pBuffer := Pointer(LocalAlloc(LPTR, 2 * (nBufferLength + 1)));
      pGetCurrentDirectoryW(nBufferLength, PWideChar(pBuffer));
      Result := PWideChar(pBuffer);
      LocalFree(Integer(pBuffer));
   end
   else
   begin
      Result := GetCurrentDir;
   end;
end;

function TContentManager.GetBase(FlashPlayerControl: IFlashPlayerControlBase): WideString;
begin
  Result := '';

  FlashPlayerControl.IFlashPlayerControlbase_GetBase(Result);

  if Length(Result) = 0 then
    Result := GetCurrentDirectory;
end;

function TContentManager.BindToStorage(const bc: IBindCtx;
                                       const mkToLeft: IMoniker;
                                       const iid: TIID;
                                       pmkContext: IMoniker;
                                       pBindStatusCallback: IBindStatusCallback;
                                       URL: WideString;
                                       out vObj): HResult; stdcall;
var
  bHandled: Boolean;
  pContentProvider: IContentProvider;
  pStream: IStream;
  nId: integer;
  strRelativePart: WideString;
  FlashPlayerControl: IFlashPlayerControlBase;
  pMoniker: IMoniker;
  strNewURL: WideString;
  MovieStream: TStream;
  strBase: WideString;
  MemoryStream: TMemoryStream;
  wstrURL: WideString;
  wstrRelativePart: WideString;
  hr: HRESULT;
begin
  Pointer(vObj) := nil;

  //
  pmkContext := nil;

  bHandled := FALSE;

  pContentProvider := FindContentProviderAndRemove(URL);

  if assigned(pContentProvider) then
    // ContentProvider найден, ?? этот провайде? чт?бы?создан пр?вызове LoadMovieUsingStream
  begin
    bHandled := TRUE;
    pContentProvider.SetBindStatusCallback(pBindStatusCallback);
  end
  else
  begin
    // Создае?контен?провайде?
    pContentProvider := TContentProvider.Create(pStream);
    pContentProvider.SetBindStatusCallback(pBindStatusCallback);
    // Теперь пр?записи ?pStream буде?вызывать? pBindStatusCallback::Write ?данные
    // могу?передавать? флеш?

    // Парсим
    if ParseURL(URL, nId, strRelativePart) then
      // Запрашивается контен?по относительному пути
    begin
      // Ищем окошко, ассоциированно??полученным Id
      FlashPlayerControl := FindObject(nId);

      // Должно найтис?
      if not assigned(FlashPlayerControl) then
      begin
        Result := E_FAIL;
        Exit;
      end;

      // Замечани? bHandled може?быть равн?FALSE, ?данные пр?этом записаны
      bHandled := CallLoadExternalResource(FlashPlayerControl, strRelativePart, pStream);

      // Замечани? bHandled може?быть равн?FALSE, ?данные пр?этом записаны
      if (not bHandled) and (S_OK = pContentProvider.IsDataSaved) then bHandled := TRUE;
      // Ну во?теперь bHandled отражает действительность

      if not bHandled then
        // Попробуе?загрузит?локальны?файл
      begin
        // Get Base
        strBase := GetBase(FlashPlayerControl);

        wstrRelativePart := strRelativePart;

        strNewURL := strBase + WideString('/') + wstrRelativePart;

        if S_OK = g_pCreateURLMoniker(pmkContext, PWideChar(strNewURL), pMoniker) then
          if assigned(pMoniker) then
          begin
             hr := pMoniker.BindToStorage(bc, mkToLeft, iid, vObj);

             if (S_OK = hr) or (MK_S_ASYNCHRONOUS = hr) then
                bHandled := TRUE;
          end;
      end;
    end
    else
    begin
      if not bHandled then
        // Попробуе?глобальные обработчик?
      begin
        if assigned(g_GlobalOnLoadExternalResourceHandlerEx) then
        begin
          MovieStream := TSynchronizedStreamWrapper.Create(TStreamBasedOnIStream.Create(pStream));

          g_GlobalOnLoadExternalResourceHandlerEx(URL, MovieStream, bHandled);

          if not bHandled then MovieStream.Free;
        end;

        if not bHandled then
          if assigned(g_GlobalOnLoadExternalResourceHandler) then
          begin
            MemoryStream := TMemoryStream.Create;
            g_GlobalOnLoadExternalResourceHandler(URL, MemoryStream);
            bHandled := (0 <> MemoryStream.Size);

            if bHandled then
            begin
              MovieStream := TStreamBasedOnIStream.Create(pStream);
              MemoryStream.Position := 0;
//              MemoryStream.SaveToStream(MovieStream); // commented out, because it can throws an exceptio
              MovieStream.Write(MemoryStream.Memory^, MemoryStream.Size);
              MemoryStream.Free;
              MovieStream.Free;
            end;
          end;
      end;

      if not bHandled then
      begin
        wstrURL := URL;
        g_pCreateURLMoniker(pmkContext, PWideChar(wstrURL), pMoniker);

        if assigned(pMoniker) then
          bHandled := (S_OK = pMoniker.BindToStorage(bc, mkToLeft, iid, vObj));
     end;
    end;
  end;

  if bHandled then Result := MK_S_ASYNCHRONOUS else Result := MK_E_NOSTORAGE;
end;

procedure TContentManager.LoadMovieUsingStream(const FlashPlayerControl: IFlashPlayerControlBase; bUseLayer: Boolean; layer: integer; out Stream: TStream);
var
  pContentProvider: IContentProvider;
  pStream: IStream;
  strURL: WideString;
  nId: integer;
  strRelativePart: WideString;
begin
  pContentProvider := TContentProvider.Create(pStream);
  Stream := TSynchronizedStreamWrapper.Create(TStreamBasedOnIStream.Create(pStream));

  strURL := GenerateNewMainMovieURL;
  ParseURL(strURL, nId, strRelativePart);

  m_ListOfURLContentProviderPair.Add(TURLContentProviderPair.Create(strURL, pContentProvider));
  AddObject(nId, FlashPlayerControl);

  if bUseLayer then
  begin
    FlashPlayerControl.IFlashPlayerControlBase_LoadMovie(layer, DEF_LOAD_FROM_MEMORY_NOTHING);
    FlashPlayerControl.IFlashPlayerControlBase_LoadMovie(layer, strURL);
  end
  else
  begin
    FlashPlayerControl.IFlashPlayerControlBase_PutMovie(DEF_LOAD_FROM_MEMORY_NOTHING);
    FlashPlayerControl.IFlashPlayerControlBase_PutMovie(strURL);
  end;
end;

procedure TContentManager.LoadMovieFromMemory(const FlashPlayerControl: IFlashPlayerControlBase; bUseLayer: Boolean; layer: integer; Stream: TStream);
var
  MovieStream: TStream;
  MemStream: TMemoryStream;
begin
  LoadMovieUsingStream(FlashPlayerControl, bUseLayer, layer, MovieStream);

  MemStream := TMemoryStream.Create;
  MemStream.LoadFromStream(Stream);
  MemStream.Position := 0;
  MemStream.SaveToStream(MovieStream);

  MovieStream.Free;
  MemStream.Free;
end;

function TContentManager.CreateMoniker(MkCtx: IMoniker; szURL: LPCWSTR; out mk: IMoniker): HResult;
begin
  Result := S_OK;
  mk := TMyMoniker.Create(MkCtx, szURL);
end;

function TContentManager.CreateFileA(lpFileName: PAnsiChar;
                                     dwDesiredAccess, dwShareMode: DWORD;
                                     lpSecurityAttributes: PSecurityAttributes;
                                     dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                                     hTemplateFile: THandle): THandle;
var
   WideFileName: WideString;
begin
{$IFDEF DEF_UNICODE_ENV}
   WideFromPChar(WideFileName, lpFileName);
{$ELSE}
   WideFileName := lpFileName;
{$ENDIF}

   Result := Self.CreateFileW(PWideChar(WideFileName), dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
end;

function InternalFPCGetCurrentDirectory: WideString;
type
  P_CreateFileW =
  function(lpFileName: PWideChar;
           dwDesiredAccess, dwShareMode: DWORD;
           lpSecurityAttributes: PSecurityAttributes;
           dwCreationDisposition, dwFlagsAndAttributes: DWORD;
           hTemplateFile: THandle): THandle; stdcall;
  P_GetCurrentDirectoryW = function(nBufferLength: DWORD; lpBuffer: PWideChar): DWORD; stdcall;
var
  pGetCurrentDirectoryW: P_GetCurrentDirectoryW;
  p: pointer;
  len: DWORD;
begin
  @pGetCurrentDirectoryW := GetProcAddress(GetModuleHandleA('kernel32.dll'), 'GetCurrentDirectoryW');

  if @pGetCurrentDirectoryW <> nil then
  begin
     GetMem(p, 2);
     len := pGetCurrentDirectoryW(1, p);

     if len > 0 then
     begin
        FreeMem(p);
        GetMem(p, 2 * (len + 2));
        ZeroMemory(p, 2 * (len + 2));
        pGetCurrentDirectoryW(len + 1, p);
        Result := PWideChar(p);
     end
     else
        Result := '';

     FreeMem(p);
  end
  else
  begin
{$IFDEF DEF_UNICODE_ENV}
     GetMem(p, 2 * (MAX_PATH + 2));
     GetCurrentDirectoryW(MAX_PATH + 1, p);
     Result := PWideChar(p);
     FreeMem(p);
{$ELSE}
     GetMem(p, MAX_PATH + 2);
     GetCurrentDirectoryA(MAX_PATH + 1, p);
     Result := PAnsiChar(p);
     FreeMem(p);
{$ENDIF}
  end;
end;

function TContentManager.CreateFileW(lpFileName: PWideChar;
                                     dwDesiredAccess, dwShareMode: DWORD;
                                     lpSecurityAttributes: PSecurityAttributes;
                                     dwCreationDisposition, dwFlagsAndAttributes: DWORD;
                                     hTemplateFile: THandle): THandle;
type
  P_CreateFileW =
  function(lpFileName: PWideChar;
           dwDesiredAccess, dwShareMode: DWORD;
           lpSecurityAttributes: PSecurityAttributes;
           dwCreationDisposition, dwFlagsAndAttributes: DWORD;
           hTemplateFile: THandle): THandle; stdcall;
var
  nId: integer;
  strRelativePart: WideString;
  FlashPlayerControl: IFlashPlayerControlBase;
  strBase: WideString;
  str: WideString;

{$IFDEF DEF_UNICODE_ENV}
{$ELSE}
  str1: AnsiString;
{$ENDIF}

  pCreateFileW: P_CreateFileW;
begin
//  MyOutputDebugString(PAnsiChar(Format('TContentManager.CreateFile: %s', [lpFileName])));

  Result := INVALID_HANDLE_VALUE;

  @pCreateFileW := GetProcAddress(GetModuleHandleA('kernel32.dll'), 'CreateFileW');

  if Result = INVALID_HANDLE_VALUE then
     Result := CreateFakeFile(
                 lpFileName,
                 dwDesiredAccess,
                 dwShareMode,
                 lpSecurityAttributes,
                 dwCreationDisposition,
                 dwFlagsAndAttributes,
                 hTemplateFile);

  if Result = INVALID_HANDLE_VALUE then
  if ParseURL(lpFileName, nId, strRelativePart) then
  begin
    FlashPlayerControl := FindObject(nId);

    if FlashPlayerControl <> nil then
    begin
      strBase := '';
      FlashPlayerControl.IFlashPlayerControlBase_GetBase(strBase);

      if Length(strBase) = 0 then
        strBase := InternalFPCGetCurrentDirectory;

      str := strBase + '\' + strRelativePart;
      str := WideStringReplace(str, '/', '\');

//    MyOutputDebugString(PAnsiChar(Format('TContentManager.CreateFile, new path: %s', [str])));

      if @pCreateFileW <> nil then
         Result := pCreateFileW(
                            PWideChar(str),
                            dwDesiredAccess,
                            dwShareMode,
                            lpSecurityAttributes,
                            dwCreationDisposition,
                            dwFlagsAndAttributes,
                            hTemplateFile)
      else
      begin
{$IFDEF DEF_UNICODE_ENV}
         Result := CreateFileW(PWideChar(str),
                               dwDesiredAccess,
                               dwShareMode,
                               lpSecurityAttributes,
                               dwCreationDisposition,
                               dwFlagsAndAttributes,
                               hTemplateFile);
{$ELSE}
         str1 := str;

         Result := CreateFileA(PAnsiChar(str1),
                               dwDesiredAccess,
                               dwShareMode,
                               lpSecurityAttributes,
                               dwCreationDisposition,
                               dwFlagsAndAttributes,
                               hTemplateFile);
{$ENDIF}
      end;
    end;
  end;

  if Result = INVALID_HANDLE_VALUE then
  begin
      if @pCreateFileW <> nil then
         Result := pCreateFileW(
                            lpFileName,
                            dwDesiredAccess,
                            dwShareMode,
                            lpSecurityAttributes,
                            dwCreationDisposition,
                            dwFlagsAndAttributes,
                            hTemplateFile)
      else
      begin
{$IFDEF DEF_UNICODE_ENV}
        Result := CreateFileW(lpFileName,
                              dwDesiredAccess,
                              dwShareMode,
                              lpSecurityAttributes,
                              dwCreationDisposition,
                              dwFlagsAndAttributes,
                              hTemplateFile);
{$ELSE}
        str1 := lpFileName;

        Result := CreateFileA(PAnsiChar(str1),
                              dwDesiredAccess,
                              dwShareMode,
                              lpSecurityAttributes,
                              dwCreationDisposition,
                              dwFlagsAndAttributes,
                              hTemplateFile);
{$ENDIF}
      end;
  end;
end;

function TContentManager.FindContentProviderAndRemove(strURL: WideString): IContentProvider;
var
  nIndex: integer;
  Pair: TURLContentProviderPair;
begin
  Result := nil;

  for nIndex := 0 to m_ListOfURLContentProviderPair.Count - 1 do
  begin
    Pair := TURLContentProviderPair(m_ListOfURLContentProviderPair[nIndex]);

    if IsURLsEqual(Pair.m_strURL, strURL) then
    begin
      Result := Pair.m_pContentProvider;
      Pair.Free;
      m_ListOfURLContentProviderPair.Delete(nIndex);
      break;
    end
  end
end;

procedure TContentManager.RemoveObject(const FlashPlayerControl: IFlashPlayerControlBase);
var
  nIndex: integer;
  FlashPlayerControlIdPair: TFlashPlayerControlIdPair;
begin
  for nIndex := m_ListOfFlashPlayerControlIdPair.Count - 1 downto 0 do
  begin
    FlashPlayerControlIdPair := TFlashPlayerControlIdPair(m_ListOfFlashPlayerControlIdPair[nIndex]);

    if Pointer(FlashPlayerControlIdPair.m_FlashPlayerControl) = Pointer(FlashPlayerControl) then
    begin
      FlashPlayerControlIdPair.Free;
      m_ListOfFlashPlayerControlIdPair.Delete(nIndex);
    end
  end
end;

function TContentManager.GenerateNewMainMovieURL: WideString;
begin
  Result :=
    Format('Z:\FromMemory\%s\%d\%s',
           [DEF_LOAD_FROM_MEMORY_MAGIC_STRING, m_nNextId, DEF_LOAD_FROM_MEMORY_MOVIE_FILE_NAME]);
  Inc(m_nNextId);
end;

procedure TContentManager.AddObject(nId: integer; FlashPlayerControl: IFlashPlayerControlBase);
begin
  m_ListOfFlashPlayerControlIdPair.Add(TFlashPlayerControlIdPair.Create(nId, FlashPlayerControl));
end;

function TContentManager.FindObject(nId: integer): IFlashPlayerControlBase;
var
  nIndex: integer;
  FlashPlayerControlIdPair: TFlashPlayerControlIdPair;
begin
  Result := nil;

  for nIndex := 0 to m_ListOfFlashPlayerControlIdPair.Count - 1 do
  begin
    FlashPlayerControlIdPair := TFlashPlayerControlIdPair(m_ListOfFlashPlayerControlIdPair[nIndex]);

    if FlashPlayerControlIdPair.m_nId = nId then
    begin
      Result := FlashPlayerControlIdPair.m_FlashPlayerControl;
      break;
    end
  end
end;

// TContentManager...END
//============================================================================

procedure SetGlobalOnLoadExternalResourceHandler(Handler: TFlashPlayerControlOnGlobalLoadExternalResource);
begin
  g_GlobalOnLoadExternalResourceHandler := Handler;
end;

procedure SetGlobalOnLoadExternalResourceHandlerEx(Handler: TFlashPlayerControlOnGlobalLoadExternalResourceEx);
begin
  g_GlobalOnLoadExternalResourceHandlerEx := Handler;
end;

procedure SetGlobalOnLoadExternalResourceHandlerAsync(Handler: TFlashPlayerControlOnGlobalLoadExternalResourceAsync);
begin
  g_GlobalOnLoadExternalResourceHandlerAsync := Handler;
end;

procedure SetGlobalPreProcessURLHandler(Handler: TFlashPlayerControlOnGlobalPreProcessURL);
begin
  g_GlobalOnPreProcessURLHandler := Handler;
end;

procedure SetGlobalOnSyncCallHandler(Handler: TFlashPlayerControlOnGlobalSyncCall);
begin
  g_GlobalOnSyncCallHandler := Handler;
end;

function IsFlashInstalled: Boolean;
var
  pUnknown: IUnknown;
  hr: HRESULT;
begin
  hr := CoCreateInstance(CLASS_ShockwaveFlash, nil, CLSCTX_ALL, IUnknown, pUnknown);
  Result := pUnknown <> nil;
  pUnknown := nil;
end;

function IsFormTransparentAvailable: Boolean;
var
  hdcScreen: HDC;
begin
  if HIBYTE(HIWORD(GetUsingFlashVersion)) < 3 then
  begin
    Result := False;
    Exit;
  end;

  hdcScreen := CreateDC('DISPLAY', nil, nil, nil);

  Result := False;

  if GetDeviceCaps(hdcScreen, BITSPIXEL) >= 16 then
    if @g_pUpdateLayeredWindow <> nil then
      Result := True;

  DeleteDC(hdcScreen);
end;

procedure SetAudioEnabled(bEnable: Boolean);
begin
  EnterCriticalSection(g_CS_Audio);

  try
    g_bAudioEnabled := bEnable;
  finally
    LeaveCriticalSection(g_CS_Audio);
  end;
end;

function GetAudioEnabled: Boolean;
begin
  EnterCriticalSection(g_CS_Audio);

  try
    Result := g_bAudioEnabled;
  finally
    LeaveCriticalSection(g_CS_Audio);
  end;
end;

procedure SetAudioVolume(Volume: Integer); // 0 <= Volume <= 100
begin
   g_dwAudioVolume := Volume;
end;

function GetAudioVolume: Integer;
begin
  EnterCriticalSection(g_CS_Audio);

  try
   Result := g_dwAudioVolume;
  finally
    LeaveCriticalSection(g_CS_Audio);
  end;
end;



procedure SetContext(const context: AnsiString);
begin
  // g_Context := context;
end;



//============================================================================
// TImportedFunctions

function MyAnsiSameText(const S1, S2: AnsiString): Boolean;
begin
  if 0 = lstrcmpiA(PAnsiChar(s1), PAnsiChar(s2)) then Result := true else Result := false;
end;

constructor TImportedFunction.Create(DLLName: AnsiString; ProcName: AnsiString; AddressOfAddress: Pointer);
begin
   FDLLName := ExtractFileName(DLLName);
   FProcName := ProcName;
   FAddressOfAddress := AddressOfAddress;
end;

function TImportedFunction.IsEqual(DLLName: AnsiString; ProcName: AnsiString): boolean;
begin
   Result := MyAnsiSameText( ExtractFileName(DLLName), FDLLName ) and
             MyAnsiSameText(ProcName, FProcName);
end;

function TImportedFunction.GetAddress: Pointer;
begin
   Result := FAddressOfAddress;
end;

constructor TImportedFunctions.Create;
begin
   FList := TList.Create;
end;

destructor TImportedFunctions.Destroy;
var
   i: integer;
begin
   for i := 0 to FList.Count - 1 do
   begin
      TImportedFunction(FList[i]).Free;
   end;

   FList.Free;
end;

procedure TImportedFunctions.Add(DLLName: AnsiString; ProcName: AnsiString; AddressOfAddress: Pointer);
begin
   FList.Add(TImportedFunction.Create(DLLName, ProcName, AddressOfAddress));
end;

function TImportedFunctions.SetNewAddress(DLLName: AnsiString; ProcName: AnsiString; NewAddress: Pointer): boolean;
var
   i: integer;
   AddressOfAddress: Pointer;
begin
   Result := false;

   for i := 0 to FList.Count - 1 do
   begin
      if TImportedFunction(FList[i]).IsEqual(DLLName, ProcName) then
      begin
         AddressOfAddress := TImportedFunction(FList[i]).GetAddress();
         PPointer(AddressOfAddress)^ := NewAddress;

         Result := true;
      end;
   end;
end;

function FPC_HookFunc(DLLName: AnsiString; ProcName: AnsiString; AddressOfNewFunction: Pointer): boolean;
begin
   Result := g_FlashOCXCodeProvider.HookFunc(DLLName, ProcName, AddressOfNewFunction);
end;

procedure TFlashOCXCodeProviderBasedOnStream.OnTimer(Sender: TObject);
type
   TSetProcessWorkingSetSize = function(
   	   hProcess: THandle; 
	   dwMinimumWorkingSetSize, dwMaximumWorkingSetSize: DWORD): BOOL; stdcall;
var
   pSetProcessWorkingSetSize: TSetProcessWorkingSetSize;
begin
   @pSetProcessWorkingSetSize := GetProcAddress(GetModuleHandle('kernel32.dll'), 'SetProcessWorkingSetSize');

   //if @pSetProcessWorkingSetSize <> nil then pSetProcessWorkingSetSize(GetCurrentProcess, $ffffffff, $ffffffff);
   if @pSetProcessWorkingSetSize <> nil then pSetProcessWorkingSetSize(GetCurrentProcess, $1000000, $2000000);
end;

procedure SetAudioOutputOpenHandler(Handler: TFlashPlayerControlOnAudioOutputOpen);
begin
   g_FlashPlayerControlOnAudioOutputOpen := Handler;
end;

procedure SetAudioOutputWriteHandler(Handler: TFlashPlayerControlOnAudioOutputWrite);
begin
   g_FlashPlayerControlOnAudioOutputWrite := Handler;
end;

procedure SetAudioOutputCloseHandler(Handler: TFlashPlayerControlOnAudioOutputClose);
begin
   g_FlashPlayerControlOnAudioOutputClose := Handler;
end;

//===============================================================================================
// class TSynchronizedStreamCaller

constructor TSynchronizedStreamCaller.Create(AStream: TStream);
begin
   Stream := AStream;

   inherited Create(True);
end;

procedure TSynchronizedStreamCaller.FreeStream;
begin
   Synchronize(DoFreeStream);
end;

procedure TSynchronizedStreamCaller.DoFreeStream;
begin
   Stream.Free;
end;

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
procedure TSynchronizedStreamCaller.SetSize(NewSize: Longint);
begin
   F_SetSize_NewSize := NewSize;

   Synchronize(DoSetSizeLongint);
end;

procedure TSynchronizedStreamCaller.DoSetSizeLongint;
begin
   Stream.Size := F_SetSize_NewSize;
end;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
procedure TSynchronizedStreamCaller.SetSize(NewSize: Longint);
begin
   F_SetSize_NewSize := NewSize;

   Synchronize(DoSetSizeLongint);
end;

procedure TSynchronizedStreamCaller.SetSize(const NewSize: Int64);
begin
   F_SetSize_NewSize64 := NewSize;

   Synchronize(DoSetSizeInt64);
end;

procedure TSynchronizedStreamCaller.DoSetSizeLongint;
begin
   Stream.Size := F_SetSize_NewSize;
end;

procedure TSynchronizedStreamCaller.DoSetSizeInt64;
begin
   Stream.Size := F_SetSize_NewSize64;
end;

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_7} // Delphi 7 or higher
function TSynchronizedStreamCaller.GetSize: Int64;
begin
   Synchronize(DoGetSizeInt64);

   Result := F_GetSize_NewSize;
end;

procedure TSynchronizedStreamCaller.DoGetSizeInt64;
begin
   F_GetSize_NewSize := Stream.Size;
end;

{$ENDIF}

{$ENDIF}

function TSynchronizedStreamCaller.Read(var Buffer; Count: Longint): Longint;
begin
   F_Read_Buffer := @Buffer;
   F_Read_Count := Count;

   Synchronize(DoRead);

   Result := F_Read_ReadBytes;
end;

function TSynchronizedStreamCaller.Write(const Buffer; Count: Longint): Longint;
begin
   F_Write_Buffer := @Buffer;
   F_Write_Count := Count;

   Synchronize(DoWrite);

   Result := F_Write_WrittenBytes;
end;

procedure TSynchronizedStreamCaller.DoRead;
begin
   F_Read_ReadBytes := Stream.Read(F_Read_Buffer^, F_Read_Count);
end;

procedure TSynchronizedStreamCaller.DoWrite;
begin
   F_Write_WrittenBytes := Stream.Write(F_Write_Buffer^, F_Write_Count);
end;

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
function TSynchronizedStreamCaller.Seek(Offset: Longint; Origin: Word): Longint;
begin
   F_Seek_Offset := Offset;
   F_Seek_Origin := Origin;

   Synchronize(DoSeekLongint);

   Result := F_Seek_NewPos;
end;

procedure TSynchronizedStreamCaller.DoSeekLongint;
begin
   F_Seek_NewPos := Stream.Seek(F_Seek_Offset, F_Seek_Origin);
end;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
function TSynchronizedStreamCaller.Seek(Offset: Longint; Origin: Word): Longint;
begin
   F_Seek_Offset := Offset;
   F_Seek_Origin := Origin;

   Synchronize(DoSeekLongint);

   Result := F_Seek_NewPos;
end;

function TSynchronizedStreamCaller.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
   F_Seek_Offset64 := Offset;
   F_Seek_Origin64 := Origin;

   Synchronize(DoSeekInt64);

   Result := F_Seek_NewPos64;
end;

procedure TSynchronizedStreamCaller.DoSeekLongint;
begin
   F_Seek_NewPos := Stream.Seek(F_Seek_Offset, F_Seek_Origin);
end;

procedure TSynchronizedStreamCaller.DoSeekInt64;
begin
   F_Seek_NewPos64 := Stream.Seek(F_Seek_Offset64, F_Seek_Origin64);
end;
{$ENDIF}
   
procedure TSynchronizedStreamCaller.Execute;
begin
   // Do nothing
end;

//===============================================================================================
constructor TSynchronizedStreamWrapper.Create(AStream: TStream);
begin
   FStream := AStream;
   FStreamCaller := TSynchronizedStreamCaller.Create(AStream);
end;

destructor TSynchronizedStreamWrapper.Destroy;
begin
   FStreamCaller.FreeStream;
   FStreamCaller.Free;
end;

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
procedure TSynchronizedStreamWrapper.SetSize(NewSize: Longint);
begin
   FStreamCaller.SetSize(NewSize);   
end;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
procedure TSynchronizedStreamWrapper.SetSize(NewSize: Longint);
begin
   FStreamCaller.SetSize(NewSize);   
end;

procedure TSynchronizedStreamWrapper.SetSize(const NewSize: Int64);
begin
   FStreamCaller.SetSize(NewSize);   
end;

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_7} // Delphi 7 or higher
function TSynchronizedStreamWrapper.GetSize: Int64;
begin
   Result := FStreamCaller.GetSize;
end;
{$ENDIF}

{$ENDIF}

function TSynchronizedStreamWrapper.Read(var Buffer; Count: Longint): Longint;
begin
   Result := FStreamCaller.Read(Buffer, Count);
end;

function TSynchronizedStreamWrapper.Write(const Buffer; Count: Longint): Longint;
begin
   Result := FStreamCaller.Write(Buffer, Count);
end;

{$IFDEF DEF_DELPHI_VERSION_BEFORE_6}
function TSynchronizedStreamWrapper.Seek(Offset: Longint; Origin: Word): Longint;
begin
   Result := FStreamCaller.Seek(Offset, Origin);
end;
{$ENDIF}

{$IFNDEF DEF_DELPHI_VERSION_BEFORE_6}
function TSynchronizedStreamWrapper.Seek(Offset: Longint; Origin: Word): Longint;
begin
   Result := FStreamCaller.Seek(Offset, Origin);
end;

function TSynchronizedStreamWrapper.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
   Result := FStreamCaller.Seek(Offset, Origin);
end;
{$ENDIF}

initialization

  // Flash 10.1 prerelease floating-point overflow bug workaround
  Set8087CW($133f);

  { g_FlashOCXCodeProvider := now we assign g_FlashOCXCodeProvider into TFlashOCXCodeProviderBasedOnSystemInstalledOCX.Create}
  TFlashOCXCodeProviderBasedOnSystemInstalledOCX.Create;
  g_WindowClassNames := TMapString2String.Create;
  g_ContentManager := TContentManager.Create;

  g_bAudioEnabled := True;
  InitializeCriticalSection(g_CS_Audio);


  g_GlobalOnLoadExternalResourceHandler := nil;
  g_GlobalOnLoadExternalResourceHandlerEx := nil;
  g_GlobalOnLoadExternalResourceHandlerAsync := nil;
  g_GlobalOnSyncCallHandler := nil;
  g_GlobalOnPreProcessURLHandler := nil;


  g_hLib_UrlMon := LoadLibrary('urlmon.dll');
  if g_hLib_UrlMon = 0 then raise Exception.Create('LoadLibrary(urlmon.dll) failed');

  @g_pCreateURLMoniker := GetProcAddress(g_hLib_UrlMon, 'CreateURLMoniker');
  if @g_pCreateURLMoniker = nil then raise Exception.Create('GetProcAddress(CreateURLMoniker) failed');

  @g_pRegisterBindStatusCallback := GetProcAddress(g_hLib_UrlMon, 'RegisterBindStatusCallback');
  if @g_pRegisterBindStatusCallback = nil then raise Exception.Create('GetProcAddress(RegisterBindStatusCallback) failed');


  g_hLib_User32 := LoadLibrary('user32.dll');
  if g_hLib_User32 = 0 then raise Exception.Create('LoadLibrary(user32.dll) failed');

  @g_pUpdateLayeredWindow := GetProcAddress(g_hLib_User32, 'UpdateLayeredWindow');


  g_dwAudioVolume := 100; // maximum
  g_DeviceBytesPerSample := TMapCardinal2Cardinal.Create;


  g_SavedCursors := TSavedCursors.Create;


  g_FlashPlayerControlOnAudioOutputOpen := nil;
  g_FlashPlayerControlOnAudioOutputWrite := nil;
  g_FlashPlayerControlOnAudioOutputClose := nil;

  MinimizeFlashMemoryTimer := TTimer.Create(nil);
  MinimizeFlashMemoryTimer.Interval := 10 * 1000;
  MinimizeFlashMemoryTimer.OnTimer := g_FlashOCXCodeProvider.OnTimer;
  MinimizeFlashMemoryTimer.Enabled := True;

  g_dwAudioWriteStartTime := -1;

finalization

  g_FlashOCXCodeProvider.Free;
  g_WindowClassNames.Free;

  g_ContentManager.Free;

  DeleteCriticalSection(g_CS_Audio);

  if g_hLib_UrlMon <> 0 then
    FreeLibrary(g_hLib_UrlMon);

  if g_hLib_User32 <> 0 then
    FreeLibrary(g_hLib_User32);

  g_DeviceBytesPerSample.Free;

  g_SavedCursors.Free;

  MinimizeFlashMemoryTimer.Free;

end.
