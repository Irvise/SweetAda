-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu_i586.adb                                                                                              --
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

with System.Machine_Code;
with Definitions;

package body CPU_i586 is

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
   -- MSRs access subprograms
   ----------------------------------------------------------------------------

   function MSR_Read return Register_Type is
      Result : Register_Type;
   begin
      Asm (
           Template => ""              & CRLF &
                       "        rdmsr" & CRLF &
                       "",
           Outputs  => Register_Type'Asm_Output ("=A", Result),
           Inputs   => MSR_Type'Asm_Input ("c", MSR_Register_Number),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MSR_Read;

   procedure MSR_Write (Value : in Register_Type) is
   begin
      Asm (
           Template => ""              & CRLF &
                       "        wrmsr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        Register_Type'Asm_Input ("A", Value),
                        MSR_Type'Asm_Input ("c", MSR_Register_Number)
                       ),
           Clobber  => "",
           Volatile => True
          );
   end MSR_Write;

   ----------------------------------------------------------------------------
   -- RDMSR/WRMSR
   ----------------------------------------------------------------------------

   function RDMSR (MSR_Register_Number : MSR_Type) return Unsigned_64 is
      Result : Unsigned_64;
   begin
      Asm (
           Template => ""              & CRLF &
                       "        rdmsr" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=A", Result),
           Inputs   => MSR_Type'Asm_Input ("c", MSR_Register_Number),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end RDMSR;

   procedure WRMSR (MSR_Register_Number : in MSR_Type; Value : in Unsigned_64) is
   begin
      Asm (
           Template => ""              & CRLF &
                       "        wrmsr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        Unsigned_64'Asm_Input ("A", Value),
                        MSR_Type'Asm_Input ("c", MSR_Register_Number)
                       ),
           Clobber  => "",
           Volatile => True
          );
   end WRMSR;

   ----------------------------------------------------------------------------
   -- RDTSC
   ----------------------------------------------------------------------------
   -- Time Stamp Counter
   -- __INF__ usr/local/src/rtems-4.10.2/c/src/lib/libcpu/i386/cpuModel.h
   ----------------------------------------------------------------------------
   function RDTSC return Unsigned_64 is
      Result : Unsigned_64;
   begin
      Asm (
           Template => ""              & CRLF &
                       "        rdtsc" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=A", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end RDTSC;

   ----------------------------------------------------------------------------
   -- TLB_Entry_Invalidate
   ----------------------------------------------------------------------------
   -- __INF__ http://x86.renejeschke.de/html/file_module_x86_id_144.html
   ----------------------------------------------------------------------------
   -- procedure TLB_Entry_Invalidate is
   -- begin
   --    null;
   -- end TLB_Entry_Invalidate;

end CPU_i586;
