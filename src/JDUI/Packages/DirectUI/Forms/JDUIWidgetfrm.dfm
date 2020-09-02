object Widget3DSwithForm: TJDUIWidget3DSwithForm
  Left = 490
  Top = 244
  BorderStyle = bsNone
  Caption = 'DXScene'
  ClientHeight = 434
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object dxScene: TdxScene
    Left = 0
    Top = 0
    Width = 487
    Height = 434
    Align = alClient
    Quality = dxHighQuality
    FillColor = '#00000000'
    AmbientColor = '#00000000'
    Transparency = True
    RealTimeSleep = 0
    OnUpdateLayer = dxSceneUpdateLayer
    DesignCameraPos = -60.516677856445310000
    DesignCameraZAngle = 0.000000000000000000
    DesignCameraXAngle = 20.000000000000000000
    DesignSnapGridShow = True
    DesignSnapToGrid = False
    DesignSnapToLines = True
    DesignShowHint = True
    object Root1: TdxVisualObject
      DragMode = dxDragManual
      DragDisableHighlight = False
      Locked = False
      Width = 1.000000000000000000
      Height = 1.000000000000000000
      Depth = 1.000000000000000000
      DesignHide = False
      Opacity = 1.000000000000000000
      Quanternion = '(0,0,0,1)'
      object WidgetLayout: TdxGUIObjectLayer
        DragMode = dxDragManual
        DragDisableHighlight = True
        Position.Point = '(243.5,217,0)'
        Locked = False
        Width = 487.000000000000000000
        Height = 434.000000000000000000
        Depth = 8.000000000000000000
        DesignHide = False
        Opacity = 1.000000000000000000
        ShowHint = True
        TwoSide = True
        ModulationColor = '#FFFFFFFF'
        LayerAlign = dxLayerContents
        Fill.Style = vgBrushNone
        Quanternion = '(0,0,0,1)'
        DesignSnapGridShow = False
        DesignSnapToGrid = False
        DesignSnapToLines = True
        object Root2: TvxLayout
          Align = vaClient
          Width = 487.000000000000000000
          Height = 434.000000000000000000
          object Front: TvxRectangle
            Align = vaClient
            Width = 487.000000000000000000
            Height = 434.000000000000000000
            HitTest = False
            Fill.Bitmap.Bitmap.PNG = {
              89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4
              89000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
              00097048597300000EC300000EC301C76FA8640000000D494441541857636060
              60600000000500018A33E3000000000049454E44AE426082}
            Fill.Bitmap.WrapMode = vgWrapTile
            Fill.Style = vgBrushBitmap
            Stroke.Style = vgBrushNone
            xRadius = 13.000000000000000000
            yRadius = 13.000000000000000000
            Corners = []
            CornerType = vgCornerBevel
            Sides = [vgSideTop, vgSideLeft, vgSideBottom, vgSideRight]
          end
          object Back: TvxRectangle
            Align = vaClient
            Width = 128.000000000000000000
            Height = 128.000000000000000000
            HitTest = False
            Visible = False
            DesignHide = True
            Fill.Bitmap.Bitmap.PNG = {
              89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4
              89000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
              00097048597300000EC300000EC301C76FA8640000000D494441541857636060
              60600000000500018A33E3000000000049454E44AE426082}
            Fill.Bitmap.WrapMode = vgWrapTile
            Fill.Style = vgBrushBitmap
            Stroke.Style = vgBrushNone
            Corners = []
            CornerType = vgCornerBevel
            Sides = [vgSideTop, vgSideLeft, vgSideBottom, vgSideRight]
          end
        end
      end
    end
  end
end
