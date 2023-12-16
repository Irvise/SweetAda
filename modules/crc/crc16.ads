-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ crc16.ads                                                                                                 --
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

with Interfaces;
with Bits;

package CRC16
   with Pure => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Initialize
      return Interfaces.Unsigned_16
      with Inline => True;
   function Update
      (Value : Interfaces.Unsigned_16;
       Item  : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_16
      with Inline => True;
   function Compute
      (Value : Interfaces.Unsigned_16;
       Data  : Bits.Byte_Array)
      return Interfaces.Unsigned_16
      with Inline => True;
   function Finalize
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      with Inline => True;

end CRC16;
