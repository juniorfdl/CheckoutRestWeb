CREATE OR ALTER procedure SP_GRAVAR_PEDIDO_WEB (
    PID integer,
    COD_USR integer,
    NR_MESA integer,
    VALOR numeric(15,2),
    OBS varchar(60),
    TERMICOD integer)
returns (
    ID integer)
as
 declare variable CLIEA13ID varchar(100);
 declare variable empricod integer;
 declare variable plrcicod integer;
begin

  if (pid = 0) then
  begin
    for select Max(PRVDICOD) + 1 as Contador from PREVENDA
    into :id do begin end
  end
  else
   id = pid;

  for select cliea13id, empricod, plrcicod from terminal
      where termicod = :termicod
  into :cliea13id, :empricod, :plrcicod do begin end

  if (coalesce(id,0) = 0) then
    id = 1;

  if (coalesce(OBS, '') = '') then
    OBS = 'Mesa: '||:nr_mesa;

  update or Insert into PREVENDA
    (TERMICOD, PRVDICOD, VENDICOD, PRVDN2TOTITENS,
     CLIENTEOBS, mesaicod, cliea13id, CLIENTENOME, PDVCPRECONCLU, PRVDCIMPORT,pdvddhvenda, plrcicod, empricod)
  Values (:termicod, :id, :nr_mesa, :valor, trim(:OBS), :nr_mesa, :cliea13id,
  'CONSUMIDOR', 'S','N',current_timestamp, :empricod, :plrcicod);

  suspend;
end;