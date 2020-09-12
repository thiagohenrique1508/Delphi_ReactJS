object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 399
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 16
    Width = 312
    Height = 41
    Caption = 'Gerar Controller Horse'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 63
    Width = 312
    Height = 41
    Caption = 'Gerar Arquivos React JS'
    TabOrder = 1
    OnClick = Button2Click
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=dbreact'
      'User_Name=admin'
      'Password=masterkey'
      'Server=dbreact.ct1nvvf7kvgn.us-east-1.rds.amazonaws.com'
      'DriverID=MySQL')
    Left = 176
    Top = 152
  end
end
