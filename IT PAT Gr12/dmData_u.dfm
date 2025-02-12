object dmData: TdmData
  Height = 563
  Width = 857
  object dsUsers: TDataSource
    DataSet = tblUsers
    Left = 256
    Top = 48
  end
  object adoCon: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=E:\Documents\IT PAT' +
      ' Gr12\Win32\Debug\FlightsDB.mdb;Mode=ReadWrite;Persist Security ' +
      'Info=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 64
    Top = 48
  end
  object tblUsers: TADOTable
    Active = True
    Connection = adoCon
    CursorType = ctStatic
    TableName = 'tblUsers'
    Left = 168
    Top = 48
  end
  object tblStats: TADOTable
    Active = True
    Connection = adoCon
    CursorType = ctStatic
    TableName = 'tblStats'
    Left = 168
    Top = 128
  end
  object dsStats: TDataSource
    DataSet = tblStats
    Left = 248
    Top = 136
  end
  object tblFlights: TADOTable
    Active = True
    Connection = adoCon
    CursorType = ctStatic
    TableName = 'tblFlights'
    Left = 168
    Top = 208
  end
  object dsFlights: TDataSource
    DataSet = tblFlights
    Left = 248
    Top = 216
  end
end
