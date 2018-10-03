unit PRODUTO;

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
  [Table('SABORES', '')]
  [PrimaryKey('ID', NotInc, NoSort, True, 'Chave primária')]
  TSABORES = Class
  Strict private
    FDescricao: String;
    FID: Integer;
    fUsar: Boolean;
  public
    [Column('ID_SABOR', ftInteger)]
    property id: Integer read FID write FID;
    [Column('DESCRICAO', ftString)]
    property Descricao: String read FDescricao write FDescricao;
    [Restrictions([NoValidate])]
    property Usar: Boolean read fUsar write fUsar;
  End;

  [Entity]
  [Table('PRODUTO', '')]
  [PrimaryKey('ID', AutoInc, NoSort, True, 'Chave primária')]
  TPRODUTO = class
  Strict private
    FID: Integer;
    fQTD: nullable<Integer>;
    FGRUPA60DESCR: String;
    fGRUPICOD: Integer;
    fPRODN3VLRVENDA: Double;
    fIMPRESSO: String;
    fSabores: TObjectList<TSABORES>;
    fListaSabores: String;
    { Private declarations }
  public
    constructor create;
    destructor destroy; override;
    { Public declarations }
    [Restrictions([NoUpdate, NotNull])]
    [Column('PRODICOD', ftInteger)]
    property id: Integer read FID write FID;

    [Column('PRODA60DESCR', ftString)]
    property PRODA60DESCR: String read FGRUPA60DESCR write FGRUPA60DESCR;

    [Column('GRUPICOD', ftInteger)]
    property GRUPICOD: Integer read fGRUPICOD write fGRUPICOD;

    [Column('PRODN3VLRVENDA', ftInteger)]
    property PRODN3VLRVENDA: Double read fPRODN3VLRVENDA write fPRODN3VLRVENDA;

    [Restrictions([NoValidate])]
    property IMPRESSO: String read fIMPRESSO write fIMPRESSO;

    [Restrictions([NoValidate])]
    property QTD: nullable<Integer> read fQTD write fQTD;

    property Sabores: TObjectList<TSABORES> read fSabores write fSabores;
    property ListaSabores:String read fListaSabores write fListaSabores;
  end;

implementation

{ TPRODUTO }

constructor TPRODUTO.create;
begin
  fSabores := TObjectList<TSABORES>.create;
end;

destructor TPRODUTO.destroy;
begin
  fSabores.Free;
  inherited;
end;

initialization

TRegisterClass.RegisterEntity(TPRODUTO);

end.
