object ORMBr: TORMBr
  OldCreateOrder = False
  Height = 266
  Width = 372
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=Automafour'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'CharacterSet=WIN1252'
      'DriverID=FB')
    LoginPrompt = False
    Left = 36
    Top = 36
  end
  object ACBrPosPrinter1: TACBrPosPrinter
    Modelo = ppEscPosEpson
    EspacoEntreLinhas = 2
    ConfigBarras.MostrarCodigo = False
    ConfigBarras.LarguraLinha = 0
    ConfigBarras.Altura = 0
    ConfigBarras.Margem = 0
    ConfigQRCode.Tipo = 2
    ConfigQRCode.LarguraModulo = 4
    ConfigQRCode.ErrorLevel = 0
    LinhasEntreCupons = 2
    Left = 208
    Top = 72
  end
end
