unit uServerModule;

interface

uses
  System.SysUtils, System.Classes, System.Json,
  DataSnap.DSProviderDataModuleAdapter,
  DataSnap.DSServer,
  DataSnap.DSAuth,
  DataSnap.DSSession,
  System.Generics.Collections,
  /// ORMBr JSON e DataSnap
  ormbr.rest.Json,
  ormbr.jsonutils.DataSnap,
  /// ORMBr Conexão database
  ormbr.factory.firedac,
  ormbr.factory.interfaces,
  ormbr.types.database,
  /// ORMBr
  ormbr.container.objectset,
  ormbr.container.objectset.interfaces,
  ormbr.session.dataset,
  // ormbr.model.master,
  ormbr.model.detail,
  ormbr.dml.generator.sqlite,

  uServerContainer,
  firedac.Stan.Intf, firedac.Stan.Option,
  firedac.Stan.Error, firedac.UI.Intf, firedac.Phys.Intf, firedac.Stan.Def,
  firedac.Stan.Pool, firedac.Stan.Async, firedac.Phys, firedac.Phys.sqlite,
  firedac.Phys.SQLiteDef, firedac.Stan.ExprFuncs, firedac.VCLUI.Wait, Data.DB,
  firedac.Comp.Client, firedac.Phys.FB, firedac.Phys.FBDef, SIS_USUARIO,
  SIS_EMPRESA,
  CONFIG_RESTAURANTE, GRUPO, PRODUTO, PEDIDO, ACBrBase, ACBrPosPrinter,
  Inifiles, Forms, MESA;

type
  TORMBr = class(TDSServerModule)
    FDConnection1: TFDConnection;
    ACBrPosPrinter1: TACBrPosPrinter;
  private
    { Private declarations }
    FSession: TDSSession;
    FConnectionKey: string;
    FMasterKey, FEmpresaKey: string;
    FConnection: IDBConnection;
    // FContainerMaster: IContainerObjectSet<Tmaster>;
    FContainerUsuario: IContainerObjectSet<TSisUsuario>;
    FContainerEmpresa: IContainerObjectSet<TSisEmpresa>;
    procedure AddKeys;
    procedure DeleteKeys;
    procedure GeneratorKeys;
    procedure RecoversKeys;
    procedure ControleDeSessao;
    function ConfirmarPedido(AValue: TJSONObject): TJSONObject;
  public
    { Public declarations }
    function master(AID: Integer = 0): TJSONArray;
    function acceptmaster(AValue: TJSONArray): TJSONString;
    function updatemaster(AValue: TJSONArray): TJSONString;
    function cancelmaster(AID: Integer): TJSONString;
    function nextpacket: TJSONArray;
    function getUsuario(NOME, PWD: String): TJSONArray;
    function Login(NOME, PWD: String): TJSONObject;
    function Empresa(id: String): TJSONArray;
    function updateConfirmarPedido(AValue: TJSONObject): TJSONObject;
    function PedidoMesa(id: Integer): TJSONObject;
    function DadosMesas(): TJSONArray;
  end;

implementation

uses
  uFormServer, System.Types, System.StrUtils;

{$R *.dfm}
{ TServerMethods1 }

function TORMBr.acceptmaster(AValue: TJSONArray): TJSONString;
// var
// LMasterList: TObjectList<Tmaster>;
// LFor: Integer;
begin
  /// <summary>
  /// Controle se Sessão
  /// </summary>
  { ControleDeSessao;

    try
    LMasterList := TORMBrJson.JsonToObjectList<Tmaster>(AValue.ToJSON);
    try
    for LFor := 0 to LMasterList.Count -1 do
    FContainerMaster.Insert(LMasterList.Items[LFor]);
    Result := TJSONString.Create('Dados inserido no banco com sucesso!!!');
    finally
    LMasterList.Clear;
    LMasterList.Free;
    end;
    except
    Result := TJSONString.Create('Houve um erro ao tentar inserir os dados no banco!!!');
    end; }
end;

procedure TORMBr.AddKeys;
begin
  GeneratorKeys;
  TServerContainer1.GetDictionary.Add(FConnectionKey,
    TFactoryFireDAC.Create(FDConnection1, dnFirebird));
  FConnection := TServerContainer1.GetDictionary.Items[FConnectionKey]
    as TFactoryFireDAC;
  TServerContainer1.GetDictionary.Add(FMasterKey,
    TContainerObjectSet<TSisUsuario>.Create(FConnection, 10));
  TServerContainer1.GetDictionary.Add(FEmpresaKey,
    TContainerObjectSet<TSisEmpresa>.Create(FConnection, 10));
end;

function TORMBr.cancelmaster(AID: Integer): TJSONString;
// var
// LMaster: Tmaster;
begin
  /// <summary>
  /// Controle se Sessão
  /// </summary>
  { ControleDeSessao;

    try
    LMaster := FContainerMaster.Find(AID);
    FContainerMaster.Delete(LMaster);
    Result := TJSONString.Create('Dados excluídos do banco com sucesso!!!');
    except
    Result := TJSONString.Create('Houve um erro ao tentar excluir os dados no banco!!!');
    end; }
end;

function TORMBr.ConfirmarPedido(AValue: TJSONObject): TJSONObject;
var
  LMasterList: TObjectList<TPEDIDO>;
  vPed: TPEDIDO;
  vstr, vOBS, vNomeUsr, vEmpresa: String;
  vListaSabores: TStringDynArray;
  vProd: TPRODUTO;
  vSabor: TSABORES;
  ii, iSabor: Integer;
  vInsert, vItemImpresso: Boolean;
  vlistImp: TStringList;
  F: TIniFile;
begin
  ControleDeSessao;
  vItemImpresso := False;
  vlistImp := TStringList.Create;
  vlistImp.Add('</zera>');

  vstr := AValue.ToJSON;
  vPed := TORMBrJson.JsonToObject<TPEDIDO>(vstr);

  with FConnection.ExecuteSQL(' SELECT empra60nomefant FROM empresa ') do
  begin
    if RecordCount > 0 then
    begin
      vEmpresa := FieldByName('empra60nomefant').AsString;
      vlistImp.Add('</c><n></ce>' + vEmpresa + '</n>');
    end;
  end;

  with FConnection.ExecuteSQL
    (' select usuaa60login from USUARIO where USUAICOD = ' +
    IntToStr(vPed.CodUsr)) do
  begin
    if RecordCount > 0 then
    begin
      vNomeUsr := FieldByName('usuaa60login').AsString;
    end;
  end;

  if vPed.OBS = EmptyStr then
    vOBS := 'null'
  else
    vOBS := QuotedStr(vPed.OBS.Trim());

  if vPed.id <= 0 then
  begin
    vPed.id := 0;
  end
  else
    vlistImp.Add('</c><n></ce>PEDIDO ALTERADO</n>');

  vstr := 'select id from SP_GRAVAR_PEDIDO_WEB(' + vPed.id.ToString + ', ' +
    vPed.CodUsr.ToString + ', ' + vPed.MESA.ToString + ', ' +
    vPed.Total.ToString().Replace(',', '.') + ' , ' + vOBS + ',' + vPed.termicod.ToString + ')';

  vPed.id := FConnection.ExecuteSQL(vstr).FieldByName('id').AsInteger;

  vlistImp.Add('</c><n></ce>PEDIDO_NRO: ' + FormatFloat('####0000', vPed.id)
    + '</n>');
  vlistImp.Add('</c><n></ce> ' + vPed.OBS_MESA + '</n>');
  vlistImp.Add('</linha_simples>');
  vlistImp.Add('</c><n></ce>PRODUTOS</n>');
  vlistImp.Add('</linha_simples>');

  ii := 0;
  for vProd in vPed.Produtos do
  begin
    inc(ii);
    vstr := 'select id from SP_GRAVAR_PEDIDO_ITEM_WEB(' + vPed.id.ToString +
      ', ' + vPed.CodUsr.ToString + ', ' + vPed.MESA.ToString + ', ' +
      vProd.PRODN3VLRVENDA.ToString().Replace(',', '.') + ', ' +
      IntToStr(vProd.QTD) + ',' + ii.ToString + ', ' + IntToStr(vProd.id) + ',' + vPed.termicod.ToString + ')';

    //if (vProd.IMPRESSO <> 'S') then
      FConnection.ExecuteSQL(vstr);

    if (vProd.IMPRESSO <> 'S') or (vPed.ReImprimir = 'S') then
    begin
      vlistImp.Add('</c><n></ae>' + FormatFloat('000', vProd.QTD) + ' ' +
        vProd.PRODA60DESCR + '</n>');

      if (vProd.ListaSabores <> '') then
      begin
        vListaSabores := SplitString(vProd.ListaSabores,';');

        for iSabor := Low(vListaSabores) to High(vListaSabores) do
        begin
          if (vListaSabores[iSabor] <> '') then
          begin
            vlistImp.Add('</c><n></ae>' + vListaSabores[iSabor] + '</n>');
          end;
        end;
      end;

//      if Assigned(vProd.Sabores) then
//      begin
//        for vSabor in vProd.Sabores do
//        begin
//          if vSabor.Usar = True then
//          begin
//            vlistImp.Add('</c><n></ae>' + vSabor.Descricao + '</n>');
//          end;
//        end;
//      end;

      vItemImpresso := True;

      vstr := ' UPDATE prevendaitem SET IMPRESSO = ''S'' where prvdicod = ' +
        vPed.id.ToString + ' and PVITIPOS = ' + ii.ToString + ' AND PRODICOD = '
        + vProd.id.ToString;
      FConnection.ExecuteDirect(vstr);
      vProd.IMPRESSO := 'S';
    end;

  end;

  Result := TORMBrJSONUtil.JSONStringToJSONObject
    (TORMBrJson.ObjectToJsonString(vPed));

  if vPed.OBS <> EmptyStr then
  begin
    vlistImp.Add('</linha_simples>');
    vlistImp.Add('</c><n>' + vPed.OBS + '</n>');
    vlistImp.Add(' ');
  end;

  vlistImp.Add('</linha_simples>');
  vlistImp.Add('</fn></ce>' + FormatDateTime('dd/mm/yy hh:mm', Now) + ' ' +
    vNomeUsr);

  // vlistImp.Add('<e><n>NEGRITO E EXPANDIDA</n></e>');

  vlistImp.Add(' ');
  vlistImp.Add(' ');
  vlistImp.Add(' ');

  // vlistImp.Add('</corte_parcial>');
  vlistImp.Add('</corte_total>');

  if vItemImpresso then
    if FileExists(ExtractFilePath(Application.ExeName) + 'Conf.ini') then
    begin
      try
        F := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Conf.ini');
        try
          ACBrPosPrinter1.Porta := F.ReadString('ELGIN', 'PORTA', '');
          ACBrPosPrinter1.Ativar;
          ACBrPosPrinter1.Imprimir(vlistImp.Text);
        finally
          ACBrPosPrinter1.Desativar;
          F.Free;
        end;
      except

      end;
    end;

  FreeAndNil(vlistImp);
end;

procedure TORMBr.ControleDeSessao;
begin
  DeleteKeys;
  AddKeys;
  RecoversKeys;
end;

function TORMBr.DadosMesas: TJSONArray;
var
  vMesa: TMESA;
  LMesaList: TObjectList<TMESA>;
  vsql: String;
begin
  ControleDeSessao;

  LMesaList := TContainerObjectSet<TMESA>.Create(FConnection).Find;

  for vMesa in LMesaList do
  begin
    vsql := ' select first(1) prvdicod from prevenda where PRVDCIMPORT <> ''S'' and mesaicod = '
      + vMesa.id.ToString;

    vMESA.MESA := vMesa.id;

    with FConnection.ExecuteSQL(vsql) do
    begin
      if RecordCount > 0 then
      begin
        vMesa.PedidoAberto := 'S';
      end;
    end;

    if vMesa.VENDICOD = 0 then
    begin
      if vMesa.MESACSTATUS = 'F' then
      begin
        vMesa.OBS := 'Livre';
      end
      else if vMesa.MESACSTATUS = 'P' then
      begin
        vMesa.OBS := 'em Pedido';
      end
      else if vMesa.MESACSTATUS = 'E' then
      begin
        vMesa.OBS := 'em Conta';
      end;

      if vMesa.NOMECLIENTE <> '' then
        vMesa.OBS := vMesa.NOMECLIENTE;
    end
    else
    begin
      with FConnection.ExecuteSQL
        (' select VENDA60NOME from vendedor where vendicod = ' +
        vMesa.VENDICOD.ToString) do
      begin
        if RecordCount > 0 then
        begin
          vMesa.OBS := FieldByName('VENDA60NOME').AsString;
        end;
      end;
    end;

  end;

  Result := TORMBrJSONUtil.JSONStringToJSONArray<TMESA>(LMesaList);
end;

procedure TORMBr.DeleteKeys;
begin
  GeneratorKeys;
  if TServerContainer1.GetDictionary.ContainsKey(FConnectionKey) then
    TServerContainer1.GetDictionary.Remove(FConnectionKey);
  if TServerContainer1.GetDictionary.ContainsKey(FMasterKey) then
    TServerContainer1.GetDictionary.Remove(FMasterKey);

  if TServerContainer1.GetDictionary.ContainsKey(FEmpresaKey) then
    TServerContainer1.GetDictionary.Remove(FEmpresaKey);
end;

function TORMBr.Empresa(id: String): TJSONArray;
var
  LMasterList: TObjectList<TSisEmpresa>;
  vobj:TSisEmpresa;
begin
  ControleDeSessao;

  LMasterList := TObjectList<TSisEmpresa>.Create;
  try

    with FConnection.ExecuteSQL(' select terma60descr, termicod from TERMINAL order by TERMA60DESCR ') do
    begin
      while NotEof do
      begin
        vobj := TSisEmpresa.Create;
        vobj.id := FieldByName('termicod').AsInteger;
        vobj.FANTASIA := FieldByName('terma60descr').AsString;
        vobj.CEMP := FieldByName('termicod').AsInteger;
        LMasterList.Add(vobj);
      end;
    end;

    //LMasterList := FContainerEmpresa.Find;
    Result := TORMBrJSONUtil.JSONStringToJSONArray<TSisEmpresa>(LMasterList);
  finally
    LMasterList.Free;
  end;
end;

procedure TORMBr.GeneratorKeys;
begin
  FSession := TDSSessionManager.GetThreadSession;
  FConnectionKey := 'Connection_' + IntToStr(FSession.id);
  FMasterKey := 'Master_' + IntToStr(FSession.id);
  FEmpresaKey := 'Empresa_' + IntToStr(FSession.id);
end;

function TORMBr.getUsuario(NOME, PWD: String): TJSONArray;
var
  LMasterList: TObjectList<TSisUsuario>;
begin
  ControleDeSessao;

  LMasterList := TObjectList<TSisUsuario>.Create;
  try
    LMasterList := FContainerUsuario.FindWhere('USUAA60LOGIN = ' +
      QuotedStr(NOME) + ' AND USUAA5SENHA = ' + QuotedStr(PWD));
    Result := TORMBrJSONUtil.JSONStringToJSONArray<TSisUsuario>(LMasterList);
  finally
    LMasterList.Free;
  end;
end;

function TORMBr.Login(NOME, PWD: String): TJSONObject;
var
  LMasterList: TObjectList<TSisUsuario>;
  LMesaList: TObjectList<TCONFIG_RESTAURANTE>;
  LGrupoList: TObjectList<TGRUPO>;
  LProdutoList: TObjectList<TPRODUTO>;
  vGrupo: TGRUPO;
  vProduto: TPRODUTO;
  vSabor: TSABORES;
  v, vsql: String;
  vMesa: TCONFIG_RESTAURANTE;
begin
  ControleDeSessao;

  LMasterList := TObjectList<TSisUsuario>.Create;
  try
    LMasterList := FContainerUsuario.FindWhere('USUAA60LOGIN = ' +
      QuotedStr(NOME) + ' AND USUAA5SENHA = ' + QuotedStr(PWD));
    // LMesaList := TContainerObjectSet<TCONFIG_RESTAURANTE>.Create(FConnection).Find;
    LGrupoList := TContainerObjectSet<TGRUPO>.Create(FConnection).Find;

    // for vMesa in LMesaList do
    // begin
    // vsql := ' select first(1) prvdicod from prevenda where PRVDCIMPORT <> ''S'' and mesaicod = '
    // + vMesa.Mesa.ToString;
    //
    // with FConnection.ExecuteSQL(vsql) do
    // begin
    // if RecordCount > 0 then
    // begin
    // vMesa.PedidoAberto := 'S';
    // end;
    // end;
    // end;

    if LMasterList.Count = 1 then
    begin
      // LMasterList[0].CONFIG_RESTAURANTE := LMesaList;
      LMasterList[0].Grupos := LGrupoList;

      for vGrupo in LGrupoList do
      begin
        vGrupo.Produtos := TContainerObjectSet<TPRODUTO>.Create(FConnection)
          .FindWhere(' GRUPICOD = ' + IntToStr(vGrupo.id));

        for vProduto in vGrupo.Produtos do
        begin
          with FConnection.ExecuteSQL(' select B.id_sabor, B.descricao from PRODUTO_SABORES A '
            +' INNER JOIN SABORES B ON B.id_sabor = A.id_sabor WHERE A.prodicod = '+ vProduto.id.ToString) do
          begin
            while NotEof do
            begin
              vSabor := TSABORES.Create;
              vSabor.id := FieldByName('id_sabor').AsInteger;
              vSabor.Descricao := FieldByName('descricao').AsString;
              vProduto.Sabores.Add(vSabor);
            end;
          end;
        end;
      end;

      v := TORMBrJson.ObjectToJsonString(LMasterList[0]);
      Result := TORMBrJSONUtil.JSONStringToJSONObject(v);
    end
    else
      Result := TORMBrJSONUtil.JSONStringToJSONObject
        ('Usuário não Encontrado!');
  finally
    LMasterList.Free;
  end;
end;

procedure TORMBr.RecoversKeys;
begin
  GeneratorKeys;
  FConnection := TServerContainer1.GetDictionary.Items[FConnectionKey]
    as TFactoryFireDAC;
  FContainerUsuario := TServerContainer1.GetDictionary.Items[FMasterKey]
    as TContainerObjectSet<TSisUsuario>;
  FContainerEmpresa := TServerContainer1.GetDictionary.Items[FEmpresaKey]
    as TContainerObjectSet<TSisEmpresa>;
end;

function TORMBr.updatemaster(AValue: TJSONArray): TJSONString;
{ var
  LMasterList: TObjectList<Tmaster>;
  LMasterUpdate: Tmaster;
  LFor: Integer; }
begin
  /// <summary>
  /// Controle se Sessão
  /// </summary>
  { ControleDeSessao;

    try
    LMasterList := TORMBrJson.JsonToObjectList<Tmaster>(AValue.ToJSON);
    try
    for LFor := 0 to LMasterList.Count -1 do
    begin
    LMasterUpdate := FContainerMaster.Find(LMasterList.Items[LFor].master_id);
    FContainerMaster.Modify(LMasterUpdate);
    FContainerMaster.Update(LMasterList.Items[LFor]);
    end;
    Result := TJSONString.Create('Dados alterado no banco com sucesso!!!');
    finally
    LMasterList.Clear;
    LMasterList.Free;
    end;
    except
    Result := TJSONString.Create('Houve um erro ao tentar alterar os dados no banco!!!');
    end; }
end;

function TORMBr.master(AID: Integer): TJSONArray;
// var
// LMasterList: TObjectList<Tmaster>;
begin
  /// <summary>
  /// Controle se Sessão
  /// </summaryFContainerMaster>
  { ControleDeSessao;

    LMasterList := TObjectList<Tmaster>.Create;
    try
    if AID = 0 then
    LMasterList := FContainerMaster.Find
    else
    LMasterList := .FindWhere('master_id = ' + IntToStr(AID));
    /// <summary>
    /// Retorna o JSON
    /// </summary>
    Result := TORMBrJSONUtil.JSONStringToJSONArray<Tmaster>(LMasterList);
    finally
    LMasterList.Free;
    end; }
end;

function TORMBr.nextpacket: TJSONArray;
// var
// LMasterList: TObjectList<Tmaster>;
begin
  /// <summary>
  /// Controle se Session
  /// </summary>
  { RecoversKeys;
    LMasterList := TObjectList<Tmaster>.Create;
    try
    FContainerMaster.NextPacket(LMasterList);
    Result := TORMBrJSONUtil.JSONStringToJSONArray<Tmaster>(LMasterList);
    finally
    LMasterList.Free;
    end; }
end;

function TORMBr.PedidoMesa(id: Integer): TJSONObject;
var
  item: TPEDIDO;
  vstr: String;
  vProd: TPRODUTO;
  vSabor: TSABORES;
  vResult: IDBResultSet;
begin
  ControleDeSessao;
  item := TPEDIDO.Create;
  item.id := 0;

  vstr := 'select first(1) PRVDICOD, VENDICOD, PRVDN2TOTITENS, CLIENTEOBS from prevenda where mesaicod = '
    + id.ToString + ' order by PRVDICOD desc ';

  with FConnection.ExecuteSQL(vstr) do
  begin
    if RecordCount > 0 then
    begin
      item.id := FieldByName('PRVDICOD').AsInteger;
      item.CodUsr := FieldByName('VENDICOD').AsInteger;
      item.Total := FieldByName('PRVDN2TOTITENS').AsFloat;
      item.OBS := FieldByName('CLIENTEOBS').AsString;
      item.MESA := id;
    end;
  end;

  vstr := 'select a.PRODICOD,a.PVITN3QTD,a.PVITN3VLRUNIT, b.proda60descr, b.grupicod, a.IMPRESSO '
    + ' from prevendaitem a inner join produto b on b.prodicod = a.prodicod ' +
    ' where a.PRVDICOD = ' + item.id.ToString;

  with FConnection.ExecuteSQL(vstr) do
  begin
    while NotEof do
    begin
      vProd := TPRODUTO.Create;
      vProd.id := FieldByName('PRODICOD').AsInteger;
      vProd.PRODA60DESCR := FieldByName('proda60descr').AsString;
      vProd.GRUPICOD := FieldByName('grupicod').AsInteger;
      vProd.PRODN3VLRVENDA := FieldByName('PVITN3VLRUNIT').AsFloat;
      vProd.QTD := FieldByName('PVITN3QTD').AsInteger;
      vProd.IMPRESSO := FieldByName('IMPRESSO').AsString;

      vResult := FConnection.ExecuteSQL(' select B.id_sabor, B.descricao from PRODUTO_SABORES A '
        +' INNER JOIN SABORES B ON B.id_sabor = A.id_sabor WHERE A.prodicod = '+ vProd.id.ToString);

      while vResult.NotEof do
      begin
        vSabor := TSABORES.Create;
        vSabor.id := vResult.FieldByName('id_sabor').AsInteger;
        vSabor.Descricao := vResult.FieldByName('descricao').AsString;
        vProd.Sabores.Add(vSabor);
      end;

      item.Produtos.Add(vProd);
    end;
  end;

  Result := TORMBrJSONUtil.JSONStringToJSONObject
    (TORMBrJson.ObjectToJsonString(item));
end;

function TORMBr.updateConfirmarPedido(AValue: TJSONObject): TJSONObject;
begin
  try
    Result := ConfirmarPedido(AValue);
  except
    on e: Exception do
    begin
      Result := TORMBrJSONUtil.JSONStringToJSONObject
        (TORMBrJson.ObjectToJsonString(TJSONString.Create(e.Message)));
    end;
  end;
end;

end.
