unit SIS_USUARIO;

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
  ormbr.mapping.register, CONFIG_RESTAURANTE, GRUPO;

type
  [Entity]
  [Table('USUARIO','')]
  [PrimaryKey('USUAICOD', AutoInc, NoSort, True, 'Chave primária')]
  TSisUsuario = class
  private
    { Private declarations }
    FID: Integer;
    FNOME: String;
    FPWD: String;
    FCONFIG_RESTAURANTE: TObjectList<TCONFIG_RESTAURANTE>;
    FGrupos: TObjectList<TGRUPO>;
  public
    constructor create;
    destructor destroy; override;
    { Public declarations }
    [Restrictions([NoUpdate, NotNull])]
    [Column('USUAICOD', ftInteger)]
    [Dictionary('USUAICOD','Mensagem de validação','','','',taCenter)]
    property id: Integer read FID write FID;

    [Column('USUAA60LOGIN', ftString, 60)]
    [Dictionary('USUAA60LOGIN','Mensagem de validação','','','',taLeftJustify)]
    property NOME: String read FNOME write FNOME;

    [Column('USUAA5SENHA', ftString, 60)]
    [Dictionary('USUAA5SENHA','Mensagem de validação','','','',taLeftJustify)]
    property PWD:String read FPWD write FPWD;

    [Restrictions([NoValidate])]
    property CONFIG_RESTAURANTE: TObjectList<TCONFIG_RESTAURANTE> read FCONFIG_RESTAURANTE write FCONFIG_RESTAURANTE;

    [Restrictions([NoValidate])]
    property Grupos: TObjectList<TGRUPO> read FGrupos write FGrupos;
  end;

implementation

{ TSisUsuario }

constructor TSisUsuario.create;
begin
  FCONFIG_RESTAURANTE := TObjectList<TCONFIG_RESTAURANTE>.Create;
  FGrupos := TObjectList<TGRUPO>.Create;
end;

destructor TSisUsuario.destroy;
begin
  FCONFIG_RESTAURANTE.Free;
  FGrupos.Free;
  inherited;
end;

initialization
  TRegisterClass.RegisterEntity(TSisUsuario);

end.
