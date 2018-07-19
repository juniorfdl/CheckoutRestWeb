program ORMBrServer;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uFormServer in 'uFormServer.pas' {Form1},
  uServerModule in 'uServerModule.pas' {ORMBr: TDSServerModule},
  uServerContainer in 'uServerContainer.pas' {ServerContainer1: TDataModule},
  uWebModule in 'uWebModule.pas' {WebModule1: TWebModule},
  ormbr.container.objectset.interfaces in '..\..\..\DataSnap\Source\Objectset\ormbr.container.objectset.interfaces.pas',
  ormbr.container.objectset in '..\..\..\DataSnap\Source\ormbr.container.objectset.pas',
  ormbr.objectset.abstract in '..\..\..\DataSnap\Source\ormbr.objectset.abstract.pas',
  ormbr.objectset.adapter in '..\..\..\DataSnap\Source\ormbr.objectset.adapter.pas',
  ormbr.objectset.bind in '..\..\..\DataSnap\Source\ormbr.objectset.bind.pas',
  ormbr.session.objectset in '..\..\..\DataSnap\Source\ormbr.session.objectset.pas',
  ormbr.model.client in '..\..\..\DataSnap\Data\Models\ormbr.model.client.pas',
  ormbr.model.detail in '..\..\..\DataSnap\Data\Models\ormbr.model.detail.pas',
  ormbr.model.lookup in '..\..\..\DataSnap\Data\Models\ormbr.model.lookup.pas',
  ormbr.model.master in '..\..\..\DataSnap\Data\Models\ormbr.model.master.pas',
  SIS_USUARIO in 'Models\SIS\SIS_USUARIO.pas',
  ormbr.dml.generator.firebird in '..\..\..\Source\Core\ormbr.dml.generator.firebird.pas',
  SIS_EMPRESA in 'Models\SIS\SIS_EMPRESA.pas',
  GRUPO in 'Models\GRUPO.pas',
  PRODUTO in 'Models\PRODUTO.pas',
  PEDIDO in 'Models\PEDIDO.pas',
  MESA in 'Models\MESA.pas',
  CONFIG_RESTAURANTE in 'Models\CONFIG_RESTAURANTE.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;

  //Application.ShowMainForm := False;
  //Application.MainFormOnTaskbar := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
