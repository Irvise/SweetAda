-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ integer_math.adb                                                                                          --
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

package body Integer_Math is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Log2
   ----------------------------------------------------------------------------
   function Log2 (Value : Positive) return Log_Integer is
   separate;

   ----------------------------------------------------------------------------
   -- Roundup
   ----------------------------------------------------------------------------
   function Roundup (Value : Natural; Modulo : Positive) return Natural is
   separate;

   ----------------------------------------------------------------------------
   -- Rounddown
   ----------------------------------------------------------------------------
   function Rounddown (Value : Natural; Modulo : Positive) return Natural is
   separate;

end Integer_Math;
