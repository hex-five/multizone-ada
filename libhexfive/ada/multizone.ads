-- Copyright(C) 2018 Hex Five Security, Inc. - All Rights Reserved

pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with System;

package MultiZone is

   procedure ECALL_YIELD;  -- libhexfive.h:8
   pragma Import (C, ECALL_YIELD, "ECALL_YIELD");

   procedure ECALL_WFI;  -- libhexfive.h:9
   pragma Import (C, ECALL_WFI, "ECALL_WFI");

   function ECALL_SEND (arg1 : int; arg2 : System.Address) return int;  -- libhexfive.h:11
   pragma Import (C, ECALL_SEND, "ECALL_SEND");

   function ECALL_RECV (arg1 : int; arg2 : System.Address) return int;  -- libhexfive.h:12
   pragma Import (C, ECALL_RECV, "ECALL_RECV");

   procedure ECALL_TRP_VECT (arg1 : int; arg2 : System.Address);  -- libhexfive.h:14
   pragma Import (C, ECALL_TRP_VECT, "ECALL_TRP_VECT");

   procedure ECALL_IRQ_VECT (arg1 : int; arg2 : System.Address);  -- libhexfive.h:15
   pragma Import (C, ECALL_IRQ_VECT, "ECALL_IRQ_VECT");

   procedure ECALL_CSRS_MIE;  -- libhexfive.h:17
   pragma Import (C, ECALL_CSRS_MIE, "ECALL_CSRS_MIE");

   procedure ECALL_CSRC_MIE;  -- libhexfive.h:18
   pragma Import (C, ECALL_CSRC_MIE, "ECALL_CSRC_MIE");

   procedure ECALL_CSRW_MTIMECMP;  -- libhexfive.h:20
   pragma Import (C, ECALL_CSRW_MTIMECMP, "ECALL_CSRW_MTIMECMP");

   function ECALL_CSRR_MTIME return int;  -- libhexfive.h:22
   pragma Import (C, ECALL_CSRR_MTIME, "ECALL_CSRR_MTIME");

   function ECALL_CSRR_MCYCLE return int;  -- libhexfive.h:23
   pragma Import (C, ECALL_CSRR_MCYCLE, "ECALL_CSRR_MCYCLE");

   function ECALL_CSRR_MINSTR return int;  -- libhexfive.h:24
   pragma Import (C, ECALL_CSRR_MINSTR, "ECALL_CSRR_MINSTR");

   function ECALL_CSRR_MHPMC3 return int;  -- libhexfive.h:25
   pragma Import (C, ECALL_CSRR_MHPMC3, "ECALL_CSRR_MHPMC3");

   function ECALL_CSRR_MHPMC4 return int;  -- libhexfive.h:26
   pragma Import (C, ECALL_CSRR_MHPMC4, "ECALL_CSRR_MHPMC4");

   function ECALL_CSRR_MISA return int;  -- libhexfive.h:28
   pragma Import (C, ECALL_CSRR_MISA, "ECALL_CSRR_MISA");

   function ECALL_CSRR_MVENDID return int;  -- libhexfive.h:29
   pragma Import (C, ECALL_CSRR_MVENDID, "ECALL_CSRR_MVENDID");

   function ECALL_CSRR_MARCHID return int;  -- libhexfive.h:30
   pragma Import (C, ECALL_CSRR_MARCHID, "ECALL_CSRR_MARCHID");

   function ECALL_CSRR_MIMPID return int;  -- libhexfive.h:31
   pragma Import (C, ECALL_CSRR_MIMPID, "ECALL_CSRR_MIMPID");

   function ECALL_CSRR_MHARTID return int;  -- libhexfive.h:32
   pragma Import (C, ECALL_CSRR_MHARTID, "ECALL_CSRR_MHARTID");

end MultiZone;