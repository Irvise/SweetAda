-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Core;
with LLutils;
with SPARC;
with Sun4m;
with IOEMU;

package body Exceptions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use LLutils;
   use SPARC;

   Trap_Table : array (Natural range 0 .. 255) of aliased TrapTable_Item_Type;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process is
   begin
      Core.Tick_Count := @ + 1;
      Sun4m.System_Timer_ClearLR;
      -- IOEMU "TIMER" LED blinking
      IOEMU.IOEMU_IO0 := 16#FF#;
      IOEMU.IOEMU_IO0 := 16#00#;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
      Trap_Template  : TrapTable_Item_Type;
      Vector_Address : Address;
      Displacement   : Storage_Offset;
      function To_U32 is new Ada.Unchecked_Conversion (Storage_Offset, Unsigned_32);
   begin
      -------------------------------------------------------------------------
      Trap_Template.Code (1) := 16#0100_0000#; -- nop
      Trap_Template.Code (2) := 16#0100_0000#; -- nop
      Trap_Template.Code (3) := 16#0100_0000#; -- nop
      for Index in Trap_Table'Range loop
         Vector_Address := To_Address (Integer_Address (16#100# + Index));
         Displacement := Address_Displacement (Vector_Address, Trap_Table (Index).Code (0)'Address, 2);
         Trap_Template.Code (0) := BRANCH_ALWAYS_Instruction or (To_U32 (Displacement) and 16#003F_FFFF#);
         Trap_Table (Index) := Trap_Template;
      end loop;
      -------------------------------------------------------------------------
   end Init;

end Exceptions;
