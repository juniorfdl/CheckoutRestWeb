unit SIS_EMPRESA;

interface

uses
  Classes,
  DB,
  SysUtils,
  Generics.Collections,
  /// orm
  ormbr.mapping.attributes,
  ormbr.types.mapping,
  ormbr.types.lazy,
  ormbr.types.nullable,
  ormbr.mapping.register;

type
  [Entity]
  [Table('TERMINAL','')]
  [PrimaryKey('termicod', AutoInc, NoSort, false, 'Chave primária')]
  TSisEmpresa = class
  private
    { Private declarations }
    fid: Integer;
    FNOME: String;
    FFANTASIA: String;
    fCEMP: Integer;
    function GetCEMP: Integer;
  public
    { Public declarations }
    [Restrictions([NoUpdate, NotNull])]
    [Column('termicod', ftInteger)]
    [Dictionary('termicod','Mensagem de validação','','','',taCenter)]
    property id: Integer read fid write fid;

//    [Column('TERMA60DESCR', ftString, 60)]
//    [Dictionary('TERMA60DESCR','Mensagem de validação','','','',taLeftJustify)]
//    property NOME: String read FNOME write FNOME;

    [Column('TERMA60DESCR', ftString, 60)]
    [Dictionary('TERMA60DESCR','Mensagem de validação','','','',taLeftJustify)]
    property FANTASIA:String read FFANTASIA write FFANTASIA;

    [Restrictions([NoValidate])]
     property CEMP: Integer read GetCEMP write fCEMP;
  end;

implementation

{ TSisEmpresa }

function TSisEmpresa.GetCEMP: Integer;
begin
  Result := fid;
end;

initialization
  TRegisterClass.RegisterEntity(TSisEmpresa);

end.
