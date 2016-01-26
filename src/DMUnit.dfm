object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object CpConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=CP')
    Connected = True
    LoginPrompt = False
    Left = 32
    Top = 17
  end
  object FDQueryPickUp: TFDQuery
    Connection = CpConnection
    Left = 32
    Top = 80
  end
  object FDQueryNotReady: TFDQuery
    Connection = CpConnection
    Left = 120
    Top = 80
  end
end
