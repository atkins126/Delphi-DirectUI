object frmParticleDesign: TfrmParticleDesign
  Left = 348
  Top = 204
  ActiveControl = dxScene1
  BorderStyle = bsDialog
  Caption = 'Particle FX Designer'
  ClientHeight = 562
  ClientWidth = 938
  Color = 3158064
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = 10526880
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dxScene1: TdxScene
    Left = 0
    Top = 0
    Width = 938
    Height = 562
    Align = alClient
    Quality = dxLowQuality
    FillColor = '#FF020202'
    AmbientColor = '#FF202020'
    Camera = Camera1
    RealTimeSleep = 0
    UsingDesignCamera = False
    DesignCameraPos = -20.000000000000000000
    DesignCameraZAngle = -8.699967384338379000
    DesignCameraXAngle = 14.000100135803220000
    DesignSnapGridShow = False
    DesignSnapToGrid = False
    DesignSnapToLines = True
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
      object Plane1: TdxPlane
        DragMode = dxDragManual
        DragDisableHighlight = False
        RotateAngle.Point = '(-90,0,0)'
        Locked = False
        Width = 11.377074241638180000
        Height = 12.846874237060550000
        Depth = 0.009999999776482582
        DesignHide = False
        Opacity = 1.000000000000000000
        OnMouseDown = Plane1MouseDown
        OnMouseMove = Plane1MouseMove
        OnMouseUp = Plane1MouseUp
        Align = dxNone
        Collider = False
        ColliseTrack = False
        Dynamic = False
        Material.Diffuse = '#FFD9D2C8'
        Material.Ambient = '#FF303030'
        Material.BitmapMode = dxTexModulate
        Material.BitmapTileX = 1.000000000000000000
        Material.BitmapTileY = 1.000000000000000000
        Material.FillMode = dxSolid
        Quanternion = '(0.707107,0,0,0.707106)'
      end
      object GUIImage1: TdxGUIImage
        DragMode = dxDragManual
        DragDisableHighlight = False
        Position.Point = '(454.5,281,0)'
        Locked = True
        Width = 428.999969482421900000
        Height = 562.000000000000000000
        Depth = 3.000000000000000000
        DesignHide = False
        Opacity = 1.000000000000000000
        TwoSide = True
        Visible = False
        LayerAlign = dxLayerClient
        Bitmap.PNG = {
          FFD8FFE000104A46494600010101006000600000FFDB00430001010101010101
          0101010101010101010101010101010101010101010101010101010101010101
          01010101010101010101010101010101010101010101010101FFDB0043010101
          0101010101010101010101010101010101010101010101010101010101010101
          010101010101010101010101010101010101010101010101010101010101FFC0
          00110800C0014003012200021101031101FFC4001F0000010501010101010100
          000000000000000102030405060708090A0BFFC400B510000201030302040305
          0504040000017D01020300041105122131410613516107227114328191A10823
          42B1C11552D1F02433627282090A161718191A25262728292A3435363738393A
          434445464748494A535455565758595A636465666768696A737475767778797A
          838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7
          B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1
          F2F3F4F5F6F7F8F9FAFFC4001F01000301010101010101010100000000000001
          02030405060708090A0BFFC400B5110002010204040304070504040001027700
          0102031104052131061241510761711322328108144291A1B1C109233352F015
          6272D10A162434E125F11718191A262728292A35363738393A43444546474849
          4A535455565758595A636465666768696A737475767778797A82838485868788
          898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4
          C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9
          FAFFDA000C03010002110311003F00FE5DEB3E8AD0A002B3E8AD0A002B3E8AD0
          A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8A
          D0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E
          8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B
          3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A00
          2B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A
          002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD
          0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8
          AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3
          E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002
          B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A0
          02B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0
          A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8A
          D0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E
          8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B
          3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A00
          2B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A
          002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD
          0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8
          AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3
          E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002
          B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A0
          02B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0
          A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8A
          D0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E
          8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B
          3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A00
          2B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A
          002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD
          0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8
          AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3
          E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002
          B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A0
          02B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0
          A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8A
          D0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E
          8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B
          3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A00
          2B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A
          002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD
          0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8
          AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A002B3E8AD0A00FFD9}
        WrapMode = vgImageTile
        Quanternion = '(0,0,0,1)'
      end
      object Emitter: TdxParticleEmitter
        DragMode = dxDragManual
        DragDisableHighlight = False
        Locked = False
        Width = 1.000000000000000000
        Height = 1.000000000000000000
        Depth = 1.000000000000000000
        DesignHide = False
        Opacity = 1.000000000000000000
        Align = dxNone
        Collider = False
        ColliseTrack = False
        Dynamic = False
        ParticlePerSecond = 20.000000000000000000
        FollowToOwner = False
        SpreadAngle = 360.000000000000000000
        Friction = 1.000000000000000000
        Rect.Rect = '(0.125,0.125,0.250,0.250)'
        LifeTime = 3.000000000000000000
        VelocityMin = 0.500000000000000000
        VelocityMax = 0.800000011920929000
        ColorBegin = '#FFFFFFFF'
        ScaleBegin = 1.000000000000000000
        ColorEnd = '#00FFFFFF'
        ScaleEnd = 0.100000001490116100
        Quanternion = '(0,0,0,1)'
      end
      object Camera1: TdxCamera
        DragMode = dxDragManual
        DragDisableHighlight = False
        Position.Point = '(0,-10,0)'
        Locked = False
        Width = 1.000000000000000000
        Height = 1.000000000000000000
        Depth = 1.000000000000000000
        DesignHide = False
        Opacity = 1.000000000000000000
        Quanternion = '(0,0,0,1)'
      end
      object PropertiesRight: TdxGUIObjectLayer
        DragMode = dxDragManual
        DragDisableHighlight = True
        Position.Point = '(803.5,281,0)'
        Locked = False
        Width = 269.000000000000000000
        Height = 562.000000000000000000
        Depth = 8.000000000000000000
        DesignHide = False
        Opacity = 1.000000000000000000
        ShowHint = True
        TwoSide = True
        ModulationColor = '#FFFFFFFF'
        LayerAlign = dxLayerMostRight
        Fill.Style = vgBrushNone
        Quanternion = '(0,0,0,1)'
        DesignSnapGridShow = False
        DesignSnapToGrid = False
        DesignSnapToLines = True
        object Root4: TvxLayout
          Width = 269.000000000000000000
          Height = 562.000000000000000000
          Margins.Rect = '(4,4,4,4)'
          object Background2: TvxBackground
            Align = vaContents
            Width = 269.000000000000000000
            Height = 562.000000000000000000
            Margins.Rect = '(4,4,4,4)'
            TabOrder = 0
          end
          object GroupBox2: TvxGroupBox
            Align = vaTop
            Position.Point = '(4,4)'
            Width = 261.000000000000000000
            Height = 267.000000000000000000
            Margins.Rect = '(10,15,10,10)'
            TabOrder = 1
            Font.Size = 11.000000953674320000
            TextAlign = vgTextAlignCenter
            Text = 'Particle colors:'
            object ColorBox1: TvxColorBox
              Position.Point = '(39,114.910)'
              Width = 102.999938964843800000
              Height = 18.999938964843750000
              TabOrder = 0
            end
            object ColorQuad1: TvxColorQuad
              Position.Point = '(39,20)'
              Width = 89.000000000000000000
              Height = 94.909912109375000000
              TabOrder = 1
              Hue = 0.500000000000000000
              Lum = 1.000000000000000000
              Alpha = 1.000000000000000000
              ColorBox = ColorBox1
              OnChange = ColorQuad1Change
            end
            object ColorPicker1: TvxColorPicker
              Position.Point = '(128,20)'
              Width = 14.000000953674320000
              Height = 94.909912109375000000
              TabOrder = 2
              Hue = 0.500000000000000000
              ColorQuad = ColorQuad1
            end
            object Layout1: TvxLayout
              Position.Point = '(147,20)'
              Width = 104.000007629394500000
              Height = 113.909866333007800000
              object numR: TvxNumberBox
                Align = vaTop
                Position.Point = '(20,0)'
                Width = 84.000007629394530000
                Height = 19.000000000000000000
                Padding.Rect = '(20,0,0,3)'
                TabOrder = 0
                Font.Size = 11.000000953674320000
                ReadOnly = False
                OnChange = numRChange
                Max = 255.000015258789100000
                ValueType = vgValueInteger
                HorzIncrement = 1.000000000000000000
                VertIncrement = 5.000000000000000000
                object Label1: TvxLabel
                  Align = vaLeft
                  Position.Point = '(-20,0)'
                  Width = 30.000000000000000000
                  Height = 19.000000000000000000
                  Padding.Rect = '(-20,0,0,0)'
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  TextAlign = vgTextAlignNear
                  Text = 'R:'
                end
              end
              object numB: TvxNumberBox
                Align = vaTop
                Position.Point = '(20,44)'
                Width = 84.000007629394530000
                Height = 19.000000000000000000
                Padding.Rect = '(20,0,0,3)'
                TabOrder = 1
                Font.Size = 11.000000953674320000
                ReadOnly = False
                OnChange = numRChange
                Max = 255.000015258789100000
                ValueType = vgValueInteger
                HorzIncrement = 1.000000000000000000
                VertIncrement = 5.000000000000000000
                object TvxLabel
                  Align = vaLeft
                  Position.Point = '(-20,0)'
                  Width = 30.000000000000000000
                  Height = 19.000000000000000000
                  Padding.Rect = '(-20,0,0,0)'
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  TextAlign = vgTextAlignNear
                  Text = 'B:'
                end
              end
              object numG: TvxNumberBox
                Align = vaTop
                Position.Point = '(20,22)'
                Width = 84.000007629394530000
                Height = 19.000000000000000000
                Padding.Rect = '(20,0,0,3)'
                TabOrder = 2
                Font.Size = 11.000000953674320000
                ReadOnly = False
                OnChange = numRChange
                Max = 255.000015258789100000
                ValueType = vgValueInteger
                HorzIncrement = 1.000000000000000000
                VertIncrement = 5.000000000000000000
                object TvxLabel
                  Align = vaLeft
                  Position.Point = '(-20,0)'
                  Width = 30.000000000000000000
                  Height = 19.000000000000000000
                  Padding.Rect = '(-20,0,0,0)'
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  TextAlign = vgTextAlignNear
                  Text = 'G:'
                end
              end
              object Label2: TvxLabel
                Align = vaTop
                Position.Point = '(0,90)'
                Width = 104.000007629394500000
                Height = 19.000000000000000000
                TabOrder = 3
                Font.Size = 11.000000953674320000
                TextAlign = vgTextAlignNear
                Text = 'Hex:'
                object textRGBA: TvxTextBox
                  Align = vaRight
                  Position.Point = '(26.000,0)'
                  Width = 77.999969482421880000
                  Height = 19.000000000000000000
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  ReadOnly = False
                  OnChange = textRGBAChange
                  Password = False
                  Text = 'TextBox'
                end
              end
              object numA: TvxNumberBox
                Align = vaTop
                Position.Point = '(20,66)'
                Width = 84.000007629394530000
                Height = 19.000000000000000000
                Padding.Rect = '(20,0,0,5)'
                TabOrder = 4
                Font.Size = 11.000000953674320000
                ReadOnly = False
                OnChange = numRChange
                Max = 255.000015258789100000
                ValueType = vgValueInteger
                HorzIncrement = 1.000000000000000000
                VertIncrement = 5.000000000000000000
                object TvxLabel
                  Align = vaLeft
                  Position.Point = '(-20,0)'
                  Width = 30.000000000000000000
                  Height = 19.000000000000000000
                  Padding.Rect = '(-20,0,0,0)'
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  TextAlign = vgTextAlignNear
                  Text = 'A:'
                end
              end
            end
            object partGradBack: TvxRectangle
              Position.Point = '(8,20)'
              Width = 19.000003814697270000
              Height = 237.909881591796900000
              Fill.Bitmap.Bitmap.PNG = {
                FFD8FFE000104A46494600010101006000600000FFDB00430001010101010101
                0101010101010101010101010101010101010101010101010101010101010101
                01010101010101010101010101010101010101010101010101FFDB0043010101
                0101010101010101010101010101010101010101010101010101010101010101
                010101010101010101010101010101010101010101010101010101010101FFC0
                001108001F002003012200021101031101FFC4001F0000010501010101010100
                000000000000000102030405060708090A0BFFC400B510000201030302040305
                0504040000017D01020300041105122131410613516107227114328191A10823
                42B1C11552D1F02433627282090A161718191A25262728292A3435363738393A
                434445464748494A535455565758595A636465666768696A737475767778797A
                838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7
                B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1
                F2F3F4F5F6F7F8F9FAFFC4001F01000301010101010101010100000000000001
                02030405060708090A0BFFC400B5110002010204040304070504040001027700
                0102031104052131061241510761711322328108144291A1B1C109233352F015
                6272D10A162434E125F11718191A262728292A35363738393A43444546474849
                4A535455565758595A636465666768696A737475767778797A82838485868788
                898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4
                C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9
                FAFFDA000C03010002110311003F00FEFE2BF19E8AFD98A002BF19E8AFD98A00
                2BF19E8AFD98A002BF19E8AFD98A00FFD9}
              Fill.Bitmap.WrapMode = vgWrapTile
              Fill.Style = vgBrushBitmap
              Sides = [vgSideTop, vgSideLeft, vgSideBottom, vgSideRight]
            end
            object partGrad: TvxRectangle
              Position.Point = '(8,20)'
              Width = 19.000003814697270000
              Height = 237.909881591796900000
              Fill.Style = vgBrushGradient
              Fill.Gradient.Points = <
                item
                  Color = '#FFFFFFFF'
                end
                item
                  Color = '#00FFFFFF'
                  Offset = 1.000000000000000000
                end>
              Fill.Gradient.Style = vgLinearGradient
              Sides = [vgSideTop, vgSideLeft, vgSideBottom, vgSideRight]
            end
            object ColorQuad2: TvxColorQuad
              Position.Point = '(39,144)'
              Width = 89.000000000000000000
              Height = 94.909912109375000000
              TabOrder = 6
              Hue = 0.500000000000000000
              Lum = 1.000000000000000000
              Alpha = 1.000000000000000000
              ColorBox = ColorBox2
              OnChange = ColorQuad2Change
            end
            object ColorPicker2: TvxColorPicker
              Position.Point = '(128,144)'
              Width = 14.000000953674320000
              Height = 94.909912109375000000
              TabOrder = 7
              Hue = 0.500000000000000000
              ColorQuad = ColorQuad2
            end
            object ColorBox2: TvxColorBox
              Position.Point = '(39,238.910)'
              Width = 102.999938964843800000
              Height = 18.999938964843750000
              TabOrder = 8
            end
            object Layout2: TvxLayout
              Position.Point = '(147,144)'
              Width = 104.000007629394500000
              Height = 113.909866333007800000
              object numR2: TvxNumberBox
                Align = vaTop
                Position.Point = '(20,0)'
                Width = 84.000007629394530000
                Height = 19.000000000000000000
                Padding.Rect = '(20,0,0,3)'
                TabOrder = 0
                Font.Size = 11.000000953674320000
                ReadOnly = False
                OnChange = numR2Change
                Max = 255.000015258789100000
                ValueType = vgValueInteger
                HorzIncrement = 1.000000000000000000
                VertIncrement = 5.000000000000000000
                object TvxLabel
                  Align = vaLeft
                  Position.Point = '(-20,0)'
                  Width = 30.000000000000000000
                  Height = 19.000000000000000000
                  Padding.Rect = '(-20,0,0,0)'
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  TextAlign = vgTextAlignNear
                  Text = 'R:'
                end
              end
              object numB2: TvxNumberBox
                Align = vaTop
                Position.Point = '(20,44)'
                Width = 84.000007629394530000
                Height = 19.000000000000000000
                Padding.Rect = '(20,0,0,3)'
                TabOrder = 1
                Font.Size = 11.000000953674320000
                ReadOnly = False
                OnChange = numR2Change
                Max = 255.000015258789100000
                ValueType = vgValueInteger
                HorzIncrement = 1.000000000000000000
                VertIncrement = 5.000000000000000000
                object TvxLabel
                  Align = vaLeft
                  Position.Point = '(-20,0)'
                  Width = 30.000000000000000000
                  Height = 19.000000000000000000
                  Padding.Rect = '(-20,0,0,0)'
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  TextAlign = vgTextAlignNear
                  Text = 'B:'
                end
              end
              object numG2: TvxNumberBox
                Align = vaTop
                Position.Point = '(20,22)'
                Width = 84.000007629394530000
                Height = 19.000000000000000000
                Padding.Rect = '(20,0,0,3)'
                TabOrder = 2
                Font.Size = 11.000000953674320000
                ReadOnly = False
                OnChange = numR2Change
                Max = 255.000015258789100000
                ValueType = vgValueInteger
                HorzIncrement = 1.000000000000000000
                VertIncrement = 5.000000000000000000
                object TvxLabel
                  Align = vaLeft
                  Position.Point = '(-20,0)'
                  Width = 30.000000000000000000
                  Height = 19.000000000000000000
                  Padding.Rect = '(-20,0,0,0)'
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  TextAlign = vgTextAlignNear
                  Text = 'G:'
                end
              end
              object TvxLabel
                Align = vaTop
                Position.Point = '(0,90)'
                Width = 104.000007629394500000
                Height = 19.000000000000000000
                TabOrder = 3
                Font.Size = 11.000000953674320000
                TextAlign = vgTextAlignNear
                Text = 'Hex:'
                object textRGBA2: TvxTextBox
                  Align = vaRight
                  Position.Point = '(26.000,0)'
                  Width = 77.999969482421880000
                  Height = 19.000000000000000000
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  ReadOnly = False
                  OnChange = textRGBA2Change
                  Password = False
                  Text = 'TextBox'
                end
              end
              object numA2: TvxNumberBox
                Align = vaTop
                Position.Point = '(20,66)'
                Width = 84.000007629394530000
                Height = 19.000000000000000000
                Padding.Rect = '(20,0,0,5)'
                TabOrder = 4
                Font.Size = 11.000000953674320000
                ReadOnly = False
                OnChange = numR2Change
                Max = 255.000015258789100000
                ValueType = vgValueInteger
                HorzIncrement = 1.000000000000000000
                VertIncrement = 5.000000000000000000
                object TvxLabel
                  Align = vaLeft
                  Position.Point = '(-20,0)'
                  Width = 30.000000000000000000
                  Height = 19.000000000000000000
                  Padding.Rect = '(-20,0,0,0)'
                  TabOrder = 0
                  Font.Size = 11.000000953674320000
                  TextAlign = vgTextAlignNear
                  Text = 'A:'
                end
              end
            end
          end
          object GroupBox1: TvxGroupBox
            Align = vaTop
            Position.Point = '(4,277)'
            Width = 263.000000000000000000
            Height = 280.000000000000000000
            Margins.Rect = '(4,20,4,4)'
            Padding.Rect = '(0,6,-2,0)'
            TabOrder = 2
            Font.Size = 11.000000953674320000
            TextAlign = vgTextAlignCenter
            Text = 'Texture:'
            object popupBitmap: TvxCompoundPopupBox
              Position.Point = '(60,-3)'
              Width = 105.999923706054700000
              Height = 21.000015258789060000
              Padding.Rect = '(0,5,0,0)'
              TabOrder = 0
              TextLabel.Align = vaLeft
              TextLabel.Locked = True
              TextLabel.Width = 1.000000000000000000
              TextLabel.Height = 21.000015258789060000
              TextLabel.Padding.Rect = '(0,0,5,0)'
              TextLabel.TabOrder = 0
              TextLabel.Font.Size = 11.000000953674320000
              TextLabel.TextAlign = vgTextAlignFar
              TextLabel.Text = 'Caption'
              TextLabel.WordWrap = False
              PopupBox.Align = vaVertCenter
              PopupBox.Locked = True
              PopupBox.Width = 99.999923706054690000
              PopupBox.Height = 21.000000000000000000
              PopupBox.TabOrder = 0
              PopupBox.StaysPressed = False
              PopupBox.IsPressed = False
              PopupBox.Font.Size = 11.000000953674320000
              PopupBox.TextAlign = vgTextAlignCenter
              PopupBox.ItemIndex = -1
              Value = -1
              OnChange = cbBitmapListChange
            end
            object imageTexture: TvxImage
              Align = vaClient
              Position.Point = '(4,20)'
              Width = 255.000000000000000000
              Height = 256.000000000000000000
              Bitmap.PNG = {
                89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4
                89000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
                00097048597300000EC300000EC301C76FA8640000000B494441541857636000
                020000050001AAD5C8510000000049454E44AE426082}
              WrapMode = vgImageFit
              object resizeLayout: TvxLayout
                Align = vaFit
                Position.Point = '(0,6)'
                Width = 255.000000000000000000
                Height = 243.000000000000000000
                object rectSelection: TvxSelection
                  Position.Point = '(109,92)'
                  Width = 50.000000000000000000
                  Height = 50.000000000000000000
                  Visible = False
                  GripSize = 3.000000000000000000
                  HideSelection = False
                  Proportional = False
                  OnChange = rectSelectionChange
                end
              end
            end
            object btnAddBitmap: TvxButton
              Position.Point = '(173,-3)'
              Width = 66.000061035156250000
              Height = 21.000000000000000000
              OnClick = btnAddBitmapClick
              TabOrder = 2
              StaysPressed = False
              IsPressed = False
              TextAlign = vgTextAlignCenter
              Text = 'Add...'
            end
          end
        end
      end
      object PropertiesLeft: TdxGUIObjectLayer
        DragMode = dxDragManual
        DragDisableHighlight = True
        Position.Point = '(120,281,0)'
        Locked = False
        Width = 240.000030517578100000
        Height = 562.000000000000000000
        Depth = 8.000000000000000000
        DesignHide = False
        Opacity = 1.000000000000000000
        ShowHint = True
        TwoSide = True
        ModulationColor = '#FFFFFFFF'
        LayerAlign = dxLayerMostLeft
        Fill.Style = vgBrushNone
        Quanternion = '(0,0,0,1)'
        DesignSnapGridShow = False
        DesignSnapToGrid = False
        DesignSnapToLines = True
        object Root2: TvxLayout
          Width = 240.000000000000000000
          Height = 562.000000000000000000
          Margins.Rect = '(9,9,9,9)'
          object Background1: TvxBackground
            Align = vaContents
            Locked = True
            Width = 240.000000000000000000
            Height = 562.000000000000000000
            HitTest = False
            TabOrder = 0
          end
          object popupBlendMode: TvxCompoundPopupBox
            Align = vaTop
            Position.Point = '(9,14)'
            Width = 222.000000000000000000
            Height = 21.000000000000000000
            Padding.Rect = '(0,5,0,0)'
            TabOrder = 1
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 21.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.Font.Size = 11.000000953674320000
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Blend Mode:'
            TextLabel.WordWrap = False
            PopupBox.Align = vaVertCenter
            PopupBox.Locked = True
            PopupBox.Width = 147.000000000000000000
            PopupBox.Height = 21.000000000000000000
            PopupBox.TabOrder = 0
            PopupBox.StaysPressed = False
            PopupBox.IsPressed = False
            PopupBox.Font.Size = 11.000000953674320000
            PopupBox.TextAlign = vgTextAlignCenter
            PopupBox.Items.strings = (
              'Additive'
              'Normal')
            PopupBox.ItemIndex = 0
            Value = 0
            OnChange = rgShadeModeClick
          end
          object trackParticleCount: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,41)'
            Width = 222.000000000000000000
            Height = 15.999984741210940000
            Padding.Rect = '(0,6,0,0)'
            TabOrder = 2
            DecimalDigits = 0
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 15.999984741210940000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Particle p/s:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Position.Point = '(0,1)'
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.Padding.Rect = '(0,1,0,1)'
            TrackBar.TabOrder = 0
            TrackBar.Min = 1.000000000000000000
            TrackBar.Max = 500.000000000000000000
            TrackBar.Frequency = 1.000000000000000000
            TrackBar.Orientation = vgHorizontal
            TrackBar.Value = 50.000000000000000000
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '50'
            OnChange = trackParticleCountChange
          end
          object trackLifetime: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,57.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 3
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Particle life:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Min = 0.100000001490116100
            TrackBar.Max = 10.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Value = 3.000000000000000000
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '3.00s'
            Suffix = 's'
            OnChange = trackLifetimeChange
          end
          object trackVelocityMin: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,132.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 4
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Velocity Min:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 5.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Value = 2.000000000000000000
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '2.00'
            OnChange = trackVelocityMinChange
          end
          object trackSpread: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,82.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 5
            DecimalDigits = 0
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Spread Angle:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 360.000000000000000000
            TrackBar.Frequency = 1.000000000000000000
            TrackBar.Orientation = vgHorizontal
            TrackBar.Value = 360.000000000000000000
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '360'
            OnChange = trackSpreadChange
          end
          object trackVelocityMax: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,148.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 6
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Velocity Max:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 5.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Value = 2.000000000000000000
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '2.00'
            OnChange = trackVelocityMaxChange
          end
          object trackSpinMin: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,280)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 7
            DecimalDigits = 0
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Spin Begin:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 3600.000000000000000000
            TrackBar.Frequency = 1.000000000000000000
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0'
            OnChange = trackSpinMinChange
          end
          object trackScaleMin: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,321)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 8
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Scale Begin:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Min = 0.100000001490116100
            TrackBar.Max = 5.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Value = 1.000000000000000000
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '1.00'
            OnChange = trackScaleMinChange
          end
          object trackSpinMax: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,296)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 9
            DecimalDigits = 0
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Spin End:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 3600.000000000000000000
            TrackBar.Frequency = 1.000000000000000000
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0'
            OnChange = trackSpinMaxChange
          end
          object trackScaleMax: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,337)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 10
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Scale End:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Min = 0.100000001490116100
            TrackBar.Max = 5.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Value = 1.000000000000000000
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '1.00'
            OnChange = trackScaleMaxChange
          end
          object trackGravityX: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,362)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 11
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Gravity X:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Min = -10.000000000000000000
            TrackBar.Max = 10.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackGravityXChange
          end
          object trackGravityY: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,378)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 12
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Gravity Y:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Min = -10.000000000000000000
            TrackBar.Max = 10.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackGravityYChange
          end
          object trackGravityZ: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,394)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 13
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Gravity Z:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Min = -10.000000000000000000
            TrackBar.Max = 10.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackGravityZChange
          end
          object trackRadialMin: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,214.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 14
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Center Min:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Min = -5.000000000000000000
            TrackBar.Max = 0.001000000047497451
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackRadialMinChange
          end
          object trackRadialMax: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,230.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 15
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Center Max:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Min = -5.000000000000000000
            TrackBar.Max = 0.001000000047497451
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackRadialMaxChange
          end
          object trackTangentMin: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,173.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 16
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Tangent Min:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 15.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackTangentMinChange
          end
          object trackTangentMax: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,189.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 17
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Tangent Max:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 15.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackTangentMaxChange
          end
          object trackDirectionAngle: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,107.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 18
            DecimalDigits = 0
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Direction:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 360.000000000000000000
            TrackBar.Frequency = 1.000000000000000000
            TrackBar.Orientation = vgHorizontal
            TrackBar.Value = 360.000000000000000000
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '360'
            OnChange = trackDirectionAngleChange
          end
          object modalLayout: TvxLayout
            Align = vaBottom
            Position.Point = '(9,508)'
            Width = 222.000000000000000000
            Height = 45.000000000000000000
            Visible = False
            object TvxButton
              Align = vaBottomRight
              Position.Point = '(32,14)'
              Width = 72.000061035156250000
              Height = 22.000000000000000000
              TabOrder = 0
              StaysPressed = False
              IsPressed = False
              Font.Size = 11.000000953674320000
              ModalResult = 1
              TextAlign = vgTextAlignCenter
              Text = 'OK'
            end
            object TvxButton
              Align = vaBottomRight
              Position.Point = '(114,14)'
              Width = 80.000000000000000000
              Height = 22.000000000000000000
              TabOrder = 1
              StaysPressed = False
              IsPressed = False
              Font.Size = 11.000000953674320000
              ModalResult = 2
              TextAlign = vgTextAlignCenter
              Text = 'Cancel'
            end
          end
          object trackPositionDispersionX: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,419)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 20
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Dispersion X:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 50.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackPositionDispersionXChange
          end
          object trackPositionDispersionY: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,435)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 21
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Dispersion Y:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 50.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackPositionDispersionYChange
          end
          object trackPositionDispersionZ: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,451)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            TabOrder = 22
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Dispersion Z:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Max = 50.000000000000000000
            TrackBar.Frequency = 0.100000001490116100
            TrackBar.Orientation = vgHorizontal
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '0.00'
            OnChange = trackPositionDispersionZChange
          end
          object trackFriction: TvxCompoundTrackBar
            Align = vaTop
            Position.Point = '(9,255.000)'
            Width = 222.000000000000000000
            Height = 16.000000000000000000
            Padding.Rect = '(0,9,0,0)'
            TabOrder = 23
            TextLabel.Align = vaLeft
            TextLabel.Locked = True
            TextLabel.Width = 70.000000000000000000
            TextLabel.Height = 16.000000000000000000
            TextLabel.Padding.Rect = '(0,0,5,0)'
            TextLabel.TabOrder = 0
            TextLabel.TextAlign = vgTextAlignFar
            TextLabel.Text = 'Friction:'
            TextLabel.WordWrap = False
            TrackBar.Align = vaVertCenter
            TrackBar.Locked = True
            TrackBar.Width = 97.000000000000000000
            TrackBar.Height = 15.000000000000000000
            TrackBar.TabOrder = 0
            TrackBar.Min = 0.100000001490116100
            TrackBar.Max = 2.000000000000000000
            TrackBar.Frequency = 0.009999999776482582
            TrackBar.Orientation = vgHorizontal
            TrackBar.Value = 1.000000000000000000
            TrackBar.Tracking = True
            ValueLabel.Align = vaVertCenter
            ValueLabel.Position.Point = '(5,0)'
            ValueLabel.Locked = True
            ValueLabel.Width = 45.000000000000000000
            ValueLabel.Height = 15.000000000000000000
            ValueLabel.Padding.Rect = '(5,0,0,0)'
            ValueLabel.TabOrder = 0
            ValueLabel.TextAlign = vgTextAlignCenter
            ValueLabel.Text = '1.00'
            OnChange = trackFrictionChange
          end
        end
      end
    end
  end
end
