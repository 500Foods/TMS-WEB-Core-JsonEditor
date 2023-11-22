object Form1: TForm1
  Width = 894
  Height = 696
  CSSLibrary = cssBootstrap
  ElementFont = efCSS
  OnCreate = MiletusFormCreate
  ClientHeight = 657
  ClientWidth = 878
  object divBackground: TWebHTMLDiv
    Left = 8
    Top = 8
    Width = 862
    Height = 641
    ElementID = 'divBackground'
    HeightStyle = ssPercent
    WidthStyle = ssPercent
    ElementPosition = epIgnore
    ElementFont = efCSS
    Role = ''
    object divMain: TWebHTMLDiv
      Left = 8
      Top = 8
      Width = 833
      Height = 617
      ElementID = 'divMain'
      HeightStyle = ssAuto
      WidthStyle = ssAuto
      ChildOrder = 2
      ElementPosition = epIgnore
      ElementFont = efCSS
      Role = ''
      object divOptions: TWebHTMLDiv
        Left = 8
        Top = 8
        Width = 200
        Height = 593
        ElementClassName = 'resize-right'
        ElementID = 'divOptions'
        HeightStyle = ssAuto
        WidthStyle = ssAuto
        ChildOrder = 2
        ElementPosition = epIgnore
        ElementFont = efCSS
        Role = ''
        object divConfigs: TWebHTMLDiv
          Left = 8
          Top = 56
          Width = 101
          Height = 49
          ElementID = 'divConfigs'
          HeightStyle = ssAuto
          WidthStyle = ssAuto
          ElementPosition = epIgnore
          ElementFont = efCSS
          Role = ''
        end
        object divOptionsBG: TWebHTMLDiv
          Left = 8
          Top = 8
          Width = 101
          Height = 42
          ElementID = 'divOptionsBG'
          HeightStyle = ssAuto
          WidthStyle = ssAuto
          ChildOrder = 2
          ElementPosition = epIgnore
          ElementFont = efCSS
          Role = ''
        end
        object divConfigButtons: TWebHTMLDiv
          Left = 8
          Top = 111
          Width = 101
          Height = 58
          ElementID = 'divConfigButtons'
          HeightStyle = ssAuto
          WidthStyle = ssAuto
          ChildOrder = 2
          ElementPosition = epIgnore
          ElementFont = efCSS
          Role = ''
          object btnLoadConfig: TWebButton
            Left = 3
            Top = 3
            Width = 80
            Height = 25
            Caption = 
              '<i class="fa-solid fa-upload fa-fw Icon me-2 fa-xl"></i><span cl' +
              'ass="Label">Load Configuration</span>'
            ElementClassName = 'btn btn-success'
            ElementID = 'btnLoadConfig'
            ElementFont = efCSS
            ElementPosition = epIgnore
            HeightStyle = ssAuto
            HeightPercent = 100.000000000000000000
            WidthStyle = ssPercent
            WidthPercent = 100.000000000000000000
            OnClick = btnLoadConfigClick
          end
          object btnViewActionLog: TWebButton
            Left = 3
            Top = 29
            Width = 80
            Height = 25
            Caption = 
              '<i class="fa-solid fa-scroll fa-fw me-2 Icon fa-xl"></i><span cl' +
              'ass="Label">View Action Log</span>'
            ChildOrder = 1
            ElementClassName = 'btn btn-danger'
            ElementID = 'btnViewActionLog'
            ElementFont = efCSS
            ElementPosition = epIgnore
            HeightStyle = ssAuto
            HeightPercent = 100.000000000000000000
            WidthStyle = ssAuto
            WidthPercent = 100.000000000000000000
            OnClick = btnViewActionLogClick
          end
        end
        object divJSONTree: TWebHTMLDiv
          Left = 8
          Top = 208
          Width = 101
          Height = 49
          ElementID = 'divJSONTree'
          HeightStyle = ssAuto
          WidthStyle = ssAuto
          ChildOrder = 3
          ElementPosition = epIgnore
          ElementFont = efCSS
          Role = ''
          Visible = False
        end
        object divJSONButtons: TWebHTMLDiv
          Left = 11
          Top = 263
          Width = 101
          Height = 93
          ElementID = 'divJSONButtons'
          HeightStyle = ssAuto
          WidthStyle = ssAuto
          ChildOrder = 2
          ElementPosition = epIgnore
          ElementFont = efCSS
          Role = ''
          Visible = False
          object btnEditJSON: TWebButton
            Left = 3
            Top = 3
            Width = 80
            Height = 25
            Caption = 
              '<i class="fa-solid fa-upload fa-fw Icon me-2 fa-xl"></i><span cl' +
              'ass="Label">Load Configuration</span>'
            ElementClassName = 'btn btn-success'
            ElementID = 'btnEditJSON'
            ElementFont = efCSS
            ElementPosition = epIgnore
            HeightStyle = ssAuto
            HeightPercent = 100.000000000000000000
            WidthStyle = ssPercent
            WidthPercent = 100.000000000000000000
          end
          object btnQuitJSON: TWebButton
            Left = 3
            Top = 29
            Width = 80
            Height = 25
            Caption = 
              '<i class="fa-solid fa-scroll fa-fw me-2 Icon fa-xl"></i><span cl' +
              'ass="Label">View Action Log</span>'
            ChildOrder = 1
            ElementClassName = 'btn btn-danger'
            ElementID = 'btnQuitJSON'
            ElementFont = efCSS
            ElementPosition = epIgnore
            HeightStyle = ssAuto
            HeightPercent = 100.000000000000000000
            WidthStyle = ssAuto
            WidthPercent = 100.000000000000000000
            OnClick = btnViewActionLogClick
          end
          object btnSaveJSON: TWebButton
            Left = 3
            Top = 53
            Width = 80
            Height = 25
            Caption = 
              '<i class="fa-solid fa-scroll fa-fw me-2 Icon fa-xl"></i><span cl' +
              'ass="Label">View Action Log</span>'
            ChildOrder = 1
            ElementClassName = 'btn btn-danger'
            ElementID = 'btnSaveJSON'
            ElementFont = efCSS
            ElementPosition = epIgnore
            HeightStyle = ssAuto
            HeightPercent = 100.000000000000000000
            WidthStyle = ssAuto
            WidthPercent = 100.000000000000000000
            OnClick = btnViewActionLogClick
          end
        end
      end
      object divWork: TWebHTMLDiv
        Left = 225
        Top = 8
        Width = 592
        Height = 598
        ElementID = 'divWork'
        HeightStyle = ssAuto
        WidthStyle = ssAuto
        ChildOrder = 2
        ElementPosition = epIgnore
        ElementFont = efCSS
        Role = ''
        object divWorkBG: TWebHTMLDiv
          Left = 8
          Top = 8
          Width = 100
          Height = 41
          ElementID = 'divWorkBG'
          HeightStyle = ssAuto
          WidthStyle = ssAuto
          ChildOrder = 1
          ElementPosition = epIgnore
          ElementFont = efCSS
          Role = ''
        end
        object pageControl: TWebPageControl
          Left = 3
          Top = 55
          Width = 400
          Height = 300
          ElementID = 'pageControl'
          HeightStyle = ssAuto
          WidthStyle = ssAuto
          ChildOrder = 1
          ElementFont = efCSS
          TabIndex = 0
          ShowTabs = False
          TabOrder = 1
          object pageActionLog: TWebTabSheet
            Left = 0
            Top = 20
            Width = 400
            Height = 280
            ElementClassName = 'Page'
            ElementID = 'pageActionLog'
            HeightStyle = ssAuto
            WidthStyle = ssAuto
            Caption = 'AL'
            ElementFont = efCSS
            ElementPosition = epIgnore
            object divActionLog: TWebHTMLDiv
              Left = 3
              Top = 12
              Width = 358
              Height = 253
              ElementID = 'divActionLog'
              HeightStyle = ssAuto
              WidthStyle = ssAuto
              ElementPosition = epIgnore
              ElementFont = efCSS
              Role = ''
            end
          end
          object pageFileHistory: TWebTabSheet
            Left = 0
            Top = 20
            Width = 400
            Height = 280
            ElementClassName = 'Page'
            ElementID = 'pageFileHistory'
            HeightStyle = ssAuto
            WidthStyle = ssAuto
            Caption = 'FH'
            ChildOrder = 1
            ElementFont = efCSS
            ElementPosition = epIgnore
            object divFileHistory: TWebHTMLDiv
              Left = 16
              Top = 22
              Width = 369
              Height = 235
              ElementID = 'divFileHistory'
              HeightStyle = ssAuto
              WidthStyle = ssAuto
              ElementPosition = epIgnore
              ElementFont = efCSS
              Role = ''
            end
          end
          object WebPageControl1Sheet3: TWebTabSheet
            Left = 0
            Top = 20
            Width = 400
            Height = 280
            Caption = 'Text'
            ChildOrder = 2
            ElementFont = efCSS
          end
        end
      end
    end
  end
  object tmrStart: TWebTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrStartTimer
    Left = 80
    Top = 408
  end
  object AddConfig: TMiletusOpenDialog
    DefaultExt = '.config'
    Filter = 'Config Files|*.config|JSON Files|*.json|All files|*.*'
    Options = [ofReadOnly, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoReadOnlyReturn, ofEnableSizing, ofDontAddToRecent, ofForceShowHidden]
    Title = 'JSON Editor'
    OnExecute = AddConfigExecute
    Left = 56
    Top = 464
  end
  object OpenJSON: TMiletusOpenDialog
    DefaultExt = '.json'
    Filter = 'Config Files|*.config|JSON Files|*.json|All files|*.*'
    FilterIndex = 2
    Options = [ofReadOnly, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoReadOnlyReturn, ofEnableSizing, ofDontAddToRecent, ofForceShowHidden]
    Title = 'JSON Editor'
    OnExecute = OpenJSONExecute
    Left = 136
    Top = 464
  end
end
