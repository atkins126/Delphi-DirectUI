object Form1: TForm1
  Left = 288
  Top = 114
  Caption = 'Form1'
  ClientHeight = 804
  ClientWidth = 1135
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 507
    Height = 359
    AutoSize = True
  end
  object HotKey1: THotKey
    Left = 552
    Top = 200
    Width = 121
    Height = 19
    HotKey = 32833
    TabOrder = 0
    OnChange = HotKey1Change
    OnGesture = HotKey1Gesture
  end
  object Button1: TButton
    Left = 552
    Top = 334
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 408
    Width = 1119
    Height = 388
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 381
    Width = 499
    Height = 21
    TabOrder = 3
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
  end
end
