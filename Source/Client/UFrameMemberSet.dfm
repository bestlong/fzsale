inherited fFrameMemberSet: TfFrameMemberSet
  Width = 548
  Height = 468
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 548
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object LabelHint: TLabel
      Left = 0
      Top = 0
      Width = 548
      Height = 36
      Align = alTop
      AutoSize = False
      Caption = #20250#21592#21345#35774#32622
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object Label1: TLabel
      Left = 14
      Top = 48
      Width = 85
      Height = 12
      Caption = #20248#24800#26465#20214#28155#21152':'
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 106
      Top = 48
      Width = 12
      Height = 12
      Caption = #28385
    end
    object Label4: TLabel
      Left = 192
      Top = 48
      Width = 48
      Height = 12
      Caption = #20803#65292#20139#21463
    end
    object Label5: TLabel
      Left = 315
      Top = 48
      Width = 36
      Height = 12
      Caption = #25240#25187#12290
    end
    object BtnAdd: TImageButton
      Left = 352
      Top = 43
      Width = 65
      Height = 25
      OnClick = BtnAddClick
      ButtonID = 'btn_add'
      Checked = False
    end
    object EditMoney: TcxTextEdit
      Left = 122
      Top = 43
      TabOrder = 0
      Width = 65
    end
    object EditZheKou: TcxTextEdit
      Left = 245
      Top = 43
      TabOrder = 1
      Width = 65
    end
  end
  object GridList: TDrawGridEx
    Left = 0
    Top = 70
    Width = 548
    Height = 398
    Align = alClient
    TabOrder = 1
  end
end
