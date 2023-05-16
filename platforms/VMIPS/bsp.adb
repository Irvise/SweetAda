-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Definitions;
with Bits;
with MIPS;
with R3000;
with VMIPS;
with Exceptions;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
   use Bits;
   use MIPS;
   use R3000;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar (C : in Character) is
   begin
      loop
         exit when VMIPS.SPIMCONSOLE_DISPLAY1_CONTROL /= 0;
      end loop;
      VMIPS.SPIMCONSOLE_DISPLAY1_DATA := Unsigned_32 (To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      loop
         exit when VMIPS.SPIMCONSOLE_KEYBOARD1_CONTROL /= 0;
      end loop;
      Data := Unsigned_8 (VMIPS.SPIMCONSOLE_KEYBOARD1_DATA and 16#FF#);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
      PRId : PRId_Type;
   begin
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      -- Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("VMIPS", NL => True);
      -------------------------------------------------------------------------
      PRId := CP0_PRId_Read;
      Console.Print ("PRId: ", NL => False);
      Console.Print (PRId.Imp, NL => False);
      Console.Print (".", NL => False);
      Console.Print (PRId.Rev, NL => False);
      Console.Print_NewLine;
      case PRId.Imp is
         -- some datasheets indicate "3" as the value for an R3000A
         when 2      => Console.Print ("R3000A", NL => True);
         when 3      => Console.Print ("R3000A/R3051/R3052/R3071/R3081", NL => True);
         when 7      => Console.Print ("R3041", NL => True);
         when others => Console.Print ("CPU unknown", NL => True);
      end case;
      -------------------------------------------------------------------------
   end Setup;

end BSP;