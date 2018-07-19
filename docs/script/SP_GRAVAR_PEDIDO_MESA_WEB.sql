create or alter procedure SP_GRAVAR_PEDIDO_MESA_WEB (
    PCODIGO integer,
    PVENDEDOR integer,
    PVALOR numeric(15,2))
AS
begin

  if (EXISTS(select 1 from MESA WHERE mesaicod = :pcodigo)) then
  BEGIN
    UPDATE MESA SET mesan3vlrtotal = :pVALOR, mesacstatus = 'P'
    WHERE mesaicod = :pcodigo;
  END
  ELSE BEGIN
    INSERT INTO MESA
      (mesaicod, mesaicapac, mesacstatus,  mesadabertura, mesan3vlrtotal, vendicod)
    VALUES
      (:pcodigo, 5, 'P', current_timestamp,  :pvalor, :pVENDEDOR);
  END

  suspend;
end
