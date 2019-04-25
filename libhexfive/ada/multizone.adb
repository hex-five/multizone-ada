package body MultiZone is
   function ECALL_SEND_C (arg1 : int; arg2 : System.Address) return int;  -- libhexfive.h:11
   pragma Import (C, ECALL_SEND_C, "ECALL_SEND");

   function ECALL_RECV_C (arg1 : int; arg2 : System.Address) return int;  -- libhexfive.h:12
   pragma Import (C, ECALL_RECV_C, "ECALL_RECV");

   function Ecall_Send (to : Zone; msg : Message) return Boolean is
   begin
      return ECALL_SEND_C (to, msg'Address) = 1;
   end Ecall_Send;

   function Ecall_Recv (from : Zone; msg : out Message) return Boolean is
   begin
      return ECALL_RECV_C (from, msg'Address) = 1;
   end Ecall_Recv;

end MultiZone;
