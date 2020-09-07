object ScreenshotForm: TScreenshotForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Screenshot'
  ClientHeight = 649
  ClientWidth = 1008
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Image32: TImage32
    Left = 0
    Top = 0
    Width = 1008
    Height = 649
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    RepaintMode = rmOptimizer
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    TabOrder = 0
    OnDblClick = Image32DblClick
    OnMouseDown = Image32MouseDown
    OnMouseMove = Image32MouseMove
    OnMouseUp = Image32MouseUp
  end
  object ApplicationEvents2: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 440
    Top = 376
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.png'
    Filter = 'png|*.png|bmp|*.bmp|jpg|*.jpg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 528
    Top = 296
  end
end
