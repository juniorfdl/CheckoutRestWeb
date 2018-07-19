unit MESA;

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
  [Table('MESA','')]
  [PrimaryKey('ID', AutoInc, NoSort, True, 'Chave primária')]
  TMESA = class
  private
    FID: Integer;
    FNOMECLIENTE: String;
    fMESADFECHAMENTO: TDate;
    fMESACSTATUS: String;
    FVENDICOD: Integer;
    fMESAN3VLRTOTAL: Double;
    fMESADABERTURA: TDate;
    FMESAICAPAC: Integer;
    fMESADULTPED: TDate;
    FOBS: String;
    fPedidoAberto: String;
    fMESA: Integer;
    { Private declarations }
  public
    { Public declarations }
    [Restrictions([NoUpdate, NotNull])]
    [Column('MESAICOD', ftInteger)]
    [Dictionary('MESAICOD','Mensagem de validação','','','',taCenter)]
    property id: Integer read FID write FID;

    [Column('MESAICAPAC', ftInteger)]
    property MESAICAPAC: Integer read FMESAICAPAC write FMESAICAPAC;

    [Column('NOMECLIENTE', ftString, 60)]
    property NOMECLIENTE:String read FNOMECLIENTE write FNOMECLIENTE;

    [Column('MESACSTATUS', ftString, 1)]
    property MESACSTATUS:String read fMESACSTATUS write fMESACSTATUS;

    [Column('MESADABERTURA', ftDate)]
    property MESADABERTURA: TDate read fMESADABERTURA write fMESADABERTURA;

    [Column('MESADULTPED', ftDate)]
    property MESADULTPED: TDate read fMESADULTPED write fMESADULTPED;

    [Column('MESADFECHAMENTO', ftDate)]
    property MESADFECHAMENTO: TDate read fMESADFECHAMENTO write fMESADFECHAMENTO;

    [Column('MESAN3VLRTOTAL', ftFloat)]
    property MESAN3VLRTOTAL: Double read fMESAN3VLRTOTAL write fMESAN3VLRTOTAL;

    [Column('VENDICOD', ftInteger)]
    property VENDICOD: Integer read FVENDICOD write FVENDICOD;

    property PedidoAberto:String read fPedidoAberto write fPedidoAberto;
    property OBS:String read FOBS write FOBS;
    property MESA:Integer read fMESA write fMESA;
  end;

implementation

{ TMESA }

initialization
  TRegisterClass.RegisterEntity(TMESA);

end.
