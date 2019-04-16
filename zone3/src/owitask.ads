-- Copyright(C) 2019 Hex Five Security, Inc. - All Rights Reserved

pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with HAL;          use HAL;

package OwiTask is

   procedure owi_task_start_request;  -- ./owi_task.h:8
   pragma Import (C, owi_task_start_request, "owi_task_start_request");

   procedure owi_task_stop_request;  -- ./owi_task.h:9
   pragma Import (C, owi_task_stop_request, "owi_task_stop_request");

   procedure owi_task_fold;  -- ./owi_task.h:10
   pragma Import (C, owi_task_fold, "owi_task_fold");

   procedure owi_task_unfold;  -- ./owi_task.h:11
   pragma Import (C, owi_task_unfold, "owi_task_unfold");

   function owi_task_run (time : UInt64) return UInt32;  -- ./owi_task.h:12
   pragma Import (C, owi_task_run, "owi_task_run");

end OwiTask;
