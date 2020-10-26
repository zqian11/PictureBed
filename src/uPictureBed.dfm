object FMain: TFMain
  Left = 443
  Top = 253
  Width = 536
  Height = 555
  Caption = 'PictureBed'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 41
    Width = 520
    Height = 375
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 1
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object imgBox: TImage
      Left = 2
      Top = 2
      Width = 516
      Height = 371
      Align = alClient
      AutoSize = True
      Center = True
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnUpload: TButton
      Left = 118
      Top = 8
      Width = 100
      Height = 25
      Caption = #19978#20256
      Enabled = False
      TabOrder = 0
      OnClick = btnUploadClick
    end
    object btnLocalFile: TButton
      Left = 8
      Top = 8
      Width = 100
      Height = 25
      Caption = #26412#22320#25991#20214
      TabOrder = 1
      OnClick = btnLocalFileClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 416
    Width = 520
    Height = 100
    Align = alBottom
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      520
      100)
    object cxlbl1: TLabel
      Left = 10
      Top = 11
      Width = 50
      Height = 13
      Caption = 'Markdown'
    end
    object cxlbl2: TLabel
      Left = 10
      Top = 43
      Width = 30
      Height = 13
      Caption = 'HTML'
    end
    object cxlbl3: TLabel
      Left = 10
      Top = 73
      Width = 20
      Height = 13
      Caption = 'Link'
    end
    object edtMarkdown: TEdit
      Left = 71
      Top = 10
      Width = 353
      Height = 19
      Anchors = [akLeft, akRight]
      BevelInner = bvNone
      BevelOuter = bvNone
      ReadOnly = True
      TabOrder = 0
    end
    object btnCopyMarkdown: TButton
      Left = 433
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akRight]
      Caption = #22797#21046
      TabOrder = 1
      OnClick = btnCopyMarkdownClick
    end
    object btnCopyHTML: TButton
      Left = 433
      Top = 37
      Width = 75
      Height = 25
      Anchors = [akRight]
      Caption = #22797#21046
      TabOrder = 3
      OnClick = btnCopyHTMLClick
    end
    object btnCopyLink: TButton
      Left = 433
      Top = 67
      Width = 75
      Height = 25
      Anchors = [akRight]
      Caption = #22797#21046
      TabOrder = 2
      OnClick = btnCopyLinkClick
    end
    object edtHTML: TEdit
      Left = 71
      Top = 41
      Width = 353
      Height = 19
      Anchors = [akLeft, akRight]
      BevelInner = bvNone
      BevelOuter = bvNone
      ReadOnly = True
      TabOrder = 4
    end
    object edtLink: TEdit
      Left = 71
      Top = 72
      Width = 353
      Height = 19
      Anchors = [akLeft, akRight]
      BevelInner = bvNone
      BevelOuter = bvNone
      ReadOnly = True
      TabOrder = 5
    end
  end
  object dlgOpenPic: TOpenPictureDialog
    Left = 480
    Top = 8
  end
end
