object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 238
  Width = 328
  object AdsConnection: TAdsConnection
    IsConnected = True
    ConnectPath = 'E:\DelphiProjects\_Kuhtin\CheckProduct\bin\ADS'
    LoginPrompt = False
    Left = 64
    Top = 32
  end
  object AdsQueryPickUp: TAdsQuery
    SQL.Strings = (
      'select c.TEL, i.* '
      'from customer c join invitem i on c.tel = i.ACCSS '
      
        'where c.TEL = '#39'7274275526'#39' and i.PICKUP = False and i.ALTERATION' +
        ' = False')
    AdsConnection = AdsConnection
    Left = 64
    Top = 104
    ParamData = <>
  end
  object AdsQueryNotReady: TAdsQuery
    AdsConnection = AdsConnection
    Left = 168
    Top = 104
    ParamData = <>
  end
  object AdsQuery: TAdsQuery
    SQL.Strings = (
      'select * from customer where tel = '#39'7274294140'#39)
    AdsConnection = AdsConnection
    Left = 264
    Top = 104
    ParamData = <>
  end
end
