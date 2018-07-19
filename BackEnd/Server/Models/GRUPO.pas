unit GRUPO;

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
  ormbr.mapping.register, PRODUTO;

type
  [Entity]
  [Table('GRUPO','')]
  [PrimaryKey('ID', AutoInc, NoSort, True, 'Chave primária')]
  TGRUPO = class
  private
    FID: Integer;
    FGRUPA60DESCR: String;
    fProdutos: TObjectList<TPRODUTO>;
    { Private declarations }
  public
    constructor create;
    destructor destroy; override;
    { Public declarations }
    [Restrictions([NoUpdate, NotNull])]
    [Column('GRUPICOD', ftInteger)]
    //[Dictionary('GRUPICOD','Mensagem de validação','','','',taCenter)]
    property id: Integer read FID write FID;

    [Column('GRUPA60DESCR', ftString)]
    property GRUPA60DESCR:String read FGRUPA60DESCR write FGRUPA60DESCR;

    [Restrictions([NoValidate])]
    property Produtos: TObjectList<TPRODUTO> read fProdutos write fProdutos;
  end;

implementation

constructor TGRUPO.create;
begin
  fProdutos := TObjectList<TPRODUTO>.Create;
end;

destructor TGRUPO.destroy;
begin
  fProdutos.Free;
  inherited;
end;

initialization
  TRegisterClass.RegisterEntity(TGRUPO);

end.
