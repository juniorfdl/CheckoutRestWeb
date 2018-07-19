create or alter procedure SP_GRAVAR_PEDIDO_ITEM_WEB (
    PID integer,
    COD_USR integer,
    NR_MESA integer,
    VALOR numeric(15,2),
    QTD numeric(15,2),
    ITEM integer,
    ID_PRODUTO integer,
    termicod integer)
returns (
    ID integer)
AS
begin

  --delete from prevendaitem
  --where prvdicod = :pid and PVITIPOS > :item;

  update or insert into prevendaitem
  (TERMICOD,PRVDICOD,PVITIPOS,PRODICOD,PVITN3QTD,PVITN3VLRUNIT,PVITN3VLRCUSTUNIT,
   VENDICOD, PVITCSTATUS)
   values
   (:termicod, :pid, :item, :id_produto, :qtd, :valor, :qtd * :valor, :cod_usr, 'A');

  id = pid;

  EXECUTE PROCEDURE SP_GRAVAR_PEDIDO_MESA_WEB(:nr_mesa, :cod_usr,
    (SELECT SUM(PVITN3VLRCUSTUNIT) FROM prevendaitem WHERE prvdicod = :pid));

  suspend;
end
