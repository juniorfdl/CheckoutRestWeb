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
  [Table('PRODUTO','')]
  [PrimaryKey('ID', AutoInc, NoSort, True, 'Chave primária')]
  TPRODUTO = class
  private
    FID: Integer;
    fQTD: Nullable<Integer>;
    FGRUPA60DESCR: String;
    fGRUPICOD: Integer;
    fPRODN3VLRVENDA: Double;
    fIMPRESSO: String;
    { Private declarations }
  public
    { Public declarations }
    [Restrictions([NoUpdate, NotNull])]
    [Column('PRODICOD', ftInteger)]
    property id: Integer read FID write FID;

    [Column('PRODA60DESCR', ftString)]
    property PRODA60DESCR:String read FGRUPA60DESCR write FGRUPA60DESCR;

    [Column('GRUPICOD', ftInteger)]
    property GRUPICOD: Integer read fGRUPICOD write FGRUPICOD;

    [Column('PRODN3VLRVENDA', ftInteger)]
    property PRODN3VLRVENDA: Double read fPRODN3VLRVENDA write fPRODN3VLRVENDA;

    [Restrictions([NoValidate])]
    property IMPRESSO: String read fIMPRESSO write fIMPRESSO;

    [Restrictions([NoValidate])]
    property QTD: Nullable<Integer> read fQTD write fQTD;
  end;

implementation

{ TPRODUTO }

initialization
  TRegisterClass.RegisterEntity(TPRODUTO);

end.
