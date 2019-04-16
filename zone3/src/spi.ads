-- Copyright(C) 2019 Hex Five Security, Inc. - All Rights Reserved

pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with HAL;          use HAL;
With System;

package Spi is

   procedure spi_init;  -- ./spi.h:8
   pragma Import (C, spi_init, "spi_init");

   function spi_rw (cmd : System.Address) return UInt32;  -- ./spi.h:9
   pragma Import (C, spi_rw, "spi_rw");

end Spi;
