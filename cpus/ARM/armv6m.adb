-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv6m.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Machine_Code;
with Definitions;

package body ARMv6M is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   CRLF : String renames Definitions.CRLF;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- NOP
   ----------------------------------------------------------------------------
   procedure NOP is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        nop" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   ----------------------------------------------------------------------------
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT is
   begin
      Asm (
           Template => ""             & CRLF &
                       "        bkpt" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- WFI
   ----------------------------------------------------------------------------
   procedure WFI is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        wfi" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end WFI;

   ----------------------------------------------------------------------------
   -- DMB
   ----------------------------------------------------------------------------
   procedure DMB is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        dmb" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end DMB;

   ----------------------------------------------------------------------------
   -- DSB
   ----------------------------------------------------------------------------
   procedure DSB is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        dsb" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end DSB;

   ----------------------------------------------------------------------------
   -- ISB
   ----------------------------------------------------------------------------
   procedure ISB is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        isb" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end ISB;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable is
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        cpsie   i" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable is
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        cpsid   i" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

   ----------------------------------------------------------------------------
   -- Fiq_Enable
   ----------------------------------------------------------------------------
   procedure Fiq_Enable is
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        cpsie   f" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Fiq_Enable;

   ----------------------------------------------------------------------------
   -- Fiq_Disable
   ----------------------------------------------------------------------------
   procedure Fiq_Disable is
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        cpsid   f" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Fiq_Disable;

   ----------------------------------------------------------------------------
   -- Memory synchronization
   ----------------------------------------------------------------------------
   procedure Memory_Synchronization is
   begin
      null;
   end Memory_Synchronization;

end ARMv6M;
