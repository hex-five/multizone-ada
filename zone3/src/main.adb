-- Copyright(C) 2019 Hex Five Security, Inc. - All Rights Reserved

with Ada;
with Ada.Unchecked_Conversion;
with Board;       use Board;
with Board.LEDs;  use Board.LEDs;
with HAL;         use HAL;
with MultiZone;   use MultiZone;
with OwiTask;     use OwiTask;
with SiFive;      use SiFive;
with SiFive.CLINT;
with SiFive.GPIO;
with Spi;         use Spi;

with Interfaces.C; use Interfaces.C;

procedure Main is
   type User_LED_Select is access all User_LED;
   type Cmd is array (0 .. 2) of UInt8;

   CMD_DUMMY : constant Cmd := (others => 16#FF#);
   LED : User_LED_Select := Red_LED'Access;
   LED_ON_TIME : constant := CLINT.Machine_Time_Value'(RTC_FREQ*20/1000);
   LED_OFF_TIME : constant := CLINT.Machine_Time_Value'(RTC_FREQ);
   PING_TIME : constant := CLINT.Machine_Time_Value'(RTC_FREQ);
   led_timer : CLINT.Machine_Time_Value := CLINT.Machine_Time_Value'(0);
   ping_timer : CLINT.Machine_Time_Value := CLINT.Machine_Time_Value'(0);
   rx_data : UInt32 := 0;
   usb_state : UInt32 := 0;
begin
   Board.LEDs.Initialize;
   Spi.spi_init;

   loop
      -- Detect USB state every 1sec
      if CLINT.Machine_Time > ping_timer then
        rx_data := spi_rw(CMD_DUMMY'Address);
        ping_timer := CLINT.Machine_Time + PING_TIME;
      end if;

      -- Update USB state
      declare
        USB_ATTACH : constant Message := (0 => 1, others => 0);
        USB_DETACH : constant Message := (0 => 2, others => 0);
        Status : Boolean;
      begin
        if rx_data /= usb_state then
          usb_state := rx_data;

          if rx_data = UInt32'(16#12670000#) then
            LED := Green_LED'Access;
            Status := Ecall_Send (1, USB_ATTACH);
          else
            LED := Red_LED'Access;
            Status := Ecall_Send (1, USB_DETACH);
            owi_task_stop_request;
          end if;
        end if;
      end;

      -- OWI sequence run
      if usb_state = 16#12670000# then
        declare
          cmd_word : UInt32 := owi_task_run(CLINT.Machine_Time);
          cmd_bytes : Cmd;

          function UInt32_To_UInt8 is new Ada.Unchecked_Conversion
            (Source => UInt32,
             Target => UInt8);
        begin
          if cmd_word /= -1 then
            cmd_bytes(0) := UInt32_To_UInt8 (cmd_word);
            cmd_bytes(1) := UInt32_To_UInt8 (Shift_Right (cmd_word,  8));
            cmd_bytes(2) := UInt32_To_UInt8 (Shift_Right (cmd_word, 16));
            rx_data := spi_rw (cmd_bytes'Address);
            ping_timer := CLINT.Machine_Time + PING_TIME;
          end if;
        end;
      end if;

      declare
        msg : Message;
        Status : Boolean := Ecall_Recv (1, msg);
      begin
        if Status then
          -- OWI sequence select
          if usb_state = 16#12670000# then
            case msg(0) is
              when Character'Pos('<') => owi_task_fold;
              when Character'Pos('>') => owi_task_unfold;
              when Character'Pos('1') => owi_task_start_request;
              when Character'Pos('0') => owi_task_stop_request;
              when others => null;
            end case;
          end if;

          -- Ping Pong & Change LED color
          if msg(0) = Character'Pos('p') and msg(1) = Character'Pos('i') and msg(2) = Character'Pos('n') and msg(3) = Character'Pos('g') then
            Status := Ecall_Send (1, msg);
          elsif msg(0) = Character'Pos('r') and msg(1) = Character'Pos('e') and msg(2) = Character'Pos('d') then
            LED := Red_LED'Access;
          elsif msg(0) = Character'Pos('g') and msg(1) = Character'Pos('r') and msg(2) = Character'Pos('e') and msg(3) = Character'Pos('e') then
            LED := Green_LED'Access;
          elsif msg(0) = Character'Pos('b') and msg(1) = Character'Pos('l') and msg(2) = Character'Pos('u') and msg(3) = Character'Pos('e') then
            LED := Blue_LED'Access;
          end if;
        end if;
      end;

      -- LED blink
      if CLINT.Machine_Time > led_timer then
        if GPIO.Set (Red_LED) or GPIO.Set (Green_LED) or GPIO.Set (Blue_LED) then
            All_LEDs_Off;
            led_timer := CLINT.Machine_Time + LED_OFF_TIME;
        else
            All_LEDs_Off;
            Turn_On (LED.all);
            led_timer := CLINT.Machine_Time + LED_ON_TIME;
        end if;
      end if;
      ECALL_YIELD;
   end loop;
end Main;
