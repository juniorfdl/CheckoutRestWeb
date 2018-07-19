unit CONFIG_RESTAURANTE;

interface

uses
  Classes,
  DB,
  SysUtils,
  Generics.Collections,
  ormbr.mapping.attributes,
  ormbr.types.mapping,
  ormbr.types.lazy,
  ormbr.types.nullable,
  ormbr.mapping.register;

type
  [Entity]
  [Table('CONFIG_RESTAURANTE','')]
  [PrimaryKey('ID', AutoInc, NoSort, True, 'Chave primária')]
  TCONFIG_RESTAURANTE = class
  private
    FOBS: String;
    FID: Integer;
    FMESA: Integer;
    fPedidoAberto: String;
    { Private declarations }
  public
    { Public declarations }
    [Restrictions([NoUpdate, NotNull])]
    [Column('ID', ftInteger)]
    [Dictionary('ID','Mensagem de validação','','','',taCenter)]
    property id: Integer read FID write FID;

    [Column('MESA', ftInteger)]
    //[Dictionary('MESA','Mensagem de validação','','','',taLeftJustify)]
    property MESA: Integer read FMESA write FMESA;

    [Column('OBS', ftString, 200)]
    //[Dictionary('OBS','Mensagem de validação','','','',taLeftJustify)]
    property OBS:String read FOBS write FOBS;

    property PedidoAberto:String read fPedidoAberto write fPedidoAberto;
  end;

implementation

{ TCONFIG_RESTAURANTE }

initialization
  TRegisterClass.RegisterEntity(TCONFIG_RESTAURANTE);

end.
