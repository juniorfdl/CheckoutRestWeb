create procedure SP_GRAVAR_PEDIDO_WEB (
    PID integer,
    COD_USR integer,
    NR_MESA integer,
    VALOR numeric(15,2),
    OBS varchar(60),
    termicod integer)
returns (
    ID integer)
as
  declare variable cliea13id varchar(100);
begin

  if (pid = 0) then
  begin
    for select Max(PRVDICOD) + 1 as Contador from PREVENDA
    into :id do begin end
  end
  else
   id = pid;

  for select cliea13id from terminal
      where termicod = :termicod
  into :cliea13id do begin end

  if (coalesce(id,0) = 0) then
    id = 1;

  if (coalesce(OBS, '') = '') then
    OBS = 'Mesa: '||:nr_mesa;

  update or Insert into PREVENDA
    (TERMICOD, PRVDICOD, VENDICOD, PRVDN2TOTITENS,
     CLIENTEOBS, mesaicod, cliea13id, CLIENTENOME, PDVCPRECONCLU, PRVDCIMPORT,pdvddhvenda)
  Values (:termicod, :id, :nr_mesa, :valor, trim(:OBS), :nr_mesa, :cliea13id,
  'CONSUMIDOR', 'S','N',current_timestamp);

  suspend;
end
