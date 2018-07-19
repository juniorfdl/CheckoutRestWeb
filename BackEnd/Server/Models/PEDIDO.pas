unit PEDIDO;

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
  //[Entity]
  //[Table('PEDIDO','')]
  //[PrimaryKey('ID', AutoInc, NoSort, True, 'Chave primária')]
  TPEDIDO = class
  private
    FID: Integer;
    fProdutos: TObjectList<TPRODUTO>;
    fOBS: String;
    fCodUsr: Integer;
    fTotal: Double;
    fMesa: Integer;
    fReImprimir: String;
    fOBS_MESA: String;
    ftermicod: Integer;
    { Private declarations }
  public
    constructor create;
    destructor destroy; override;
    { Public declarations }
    //[Dictionary('GRUPICOD','Mensagem de validação','','','',taCenter)]
    property id: Integer read FID write FID;
    property CodUsr: Integer read fCodUsr write fCodUsr;
    property Total: Double read fTotal write fTotal;
    property Mesa: Integer read fMesa write fMesa;

    property OBS:String read fOBS write fOBS;

    property ReImprimir:String read fReImprimir write fReImprimir;
    property OBS_MESA:String read fOBS_MESA write fOBS_MESA;

    property termicod: Integer read ftermicod write ftermicod;

    //[Restrictions([NoValidate])]
    property Produtos: TObjectList<TPRODUTO> read fProdutos write fProdutos;
  end;

implementation

constructor TPEDIDO.create;
begin
  fProdutos := TObjectList<TPRODUTO>.Create;
end;

destructor TPEDIDO.destroy;
begin
  fProdutos.Free;
  inherited;
end;

initialization
  TRegisterClass.RegisterEntity(TPEDIDO);

end.
