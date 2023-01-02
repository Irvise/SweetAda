-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ videofont8x8.ads                                                                                          --
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

package Videofont8x8 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   package SSE renames System.Storage_Elements;

   Font_Width       : constant := 8;
   Font_Height      : constant := 8;
   Font_NCharacters : constant := 256;

   type Font_Character_Type is new SSE.Storage_Array (0 .. SSE.Storage_Offset (Font_Height - 1)) with
      Alignment => 8;

   ----------------------------------------------------------------------------
   -- CodePage 437 (CP 437, OEM 437, PC-8, MS-DOS Latin US)
   -- CGA 8x8 BIOS font bitmap
   ----------------------------------------------------------------------------

   -- font bitmap values reversed - bit0 is leftmost when drawn on video
   Font : constant array (0 .. Font_NCharacters - 1) of Font_Character_Type :=
      [
       [16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0x00 |  ^@|
       [16#7E#, 16#81#, 16#A5#, 16#81#, 16#BD#, 16#99#, 16#81#, 16#7E#], -- 0x01 |  ^A|
       [16#7E#, 16#FF#, 16#DB#, 16#FF#, 16#C3#, 16#E7#, 16#FF#, 16#7E#], -- 0x02 |  ^B|
       [16#6C#, 16#FE#, 16#FE#, 16#FE#, 16#7C#, 16#38#, 16#10#, 16#00#], -- 0x03 |  ^C|
       [16#10#, 16#38#, 16#7C#, 16#FE#, 16#7C#, 16#38#, 16#10#, 16#00#], -- 0x04 |  ^D|
       [16#38#, 16#7C#, 16#38#, 16#FE#, 16#FE#, 16#92#, 16#10#, 16#7C#], -- 0x05 |  ^E|
       [16#00#, 16#10#, 16#38#, 16#7C#, 16#FE#, 16#7C#, 16#38#, 16#7C#], -- 0x06 |  ^F|
       [16#00#, 16#00#, 16#18#, 16#3C#, 16#3C#, 16#18#, 16#00#, 16#00#], -- 0x07 |  ^G|
       [16#FF#, 16#FF#, 16#E7#, 16#C3#, 16#C3#, 16#E7#, 16#FF#, 16#FF#], -- 0x08 |  ^H|
       [16#00#, 16#3C#, 16#66#, 16#42#, 16#42#, 16#66#, 16#3C#, 16#00#], -- 0x09 |  ^I|
       [16#FF#, 16#C3#, 16#99#, 16#BD#, 16#BD#, 16#99#, 16#C3#, 16#FF#], -- 0x0A |  ^J|
       [16#0F#, 16#07#, 16#0F#, 16#7D#, 16#CC#, 16#CC#, 16#CC#, 16#78#], -- 0x0B |  ^K|
       [16#3C#, 16#66#, 16#66#, 16#66#, 16#3C#, 16#18#, 16#7E#, 16#18#], -- 0x0C |  ^L|
       [16#3F#, 16#33#, 16#3F#, 16#30#, 16#30#, 16#70#, 16#F0#, 16#E0#], -- 0x0D |  ^M|
       [16#7F#, 16#63#, 16#7F#, 16#63#, 16#63#, 16#67#, 16#E6#, 16#C0#], -- 0x0E |  ^N|
       [16#99#, 16#5A#, 16#3C#, 16#E7#, 16#E7#, 16#3C#, 16#5A#, 16#99#], -- 0x0F |  ^O|
       [16#80#, 16#E0#, 16#F8#, 16#FE#, 16#F8#, 16#E0#, 16#80#, 16#00#], -- 0x10 |  ^P|
       [16#02#, 16#0E#, 16#3E#, 16#FE#, 16#3E#, 16#0E#, 16#02#, 16#00#], -- 0x11 |  ^Q|
       [16#18#, 16#3C#, 16#7E#, 16#18#, 16#18#, 16#7E#, 16#3C#, 16#18#], -- 0x12 |  ^R|
       [16#66#, 16#66#, 16#66#, 16#66#, 16#66#, 16#00#, 16#66#, 16#00#], -- 0x13 |  ^S|
       [16#7F#, 16#DB#, 16#DB#, 16#7B#, 16#1B#, 16#1B#, 16#1B#, 16#00#], -- 0x14 |  ^T|
       [16#3E#, 16#63#, 16#38#, 16#6C#, 16#6C#, 16#38#, 16#86#, 16#FC#], -- 0x15 |  ^U|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#7E#, 16#7E#, 16#7E#, 16#00#], -- 0x16 |  ^V|
       [16#18#, 16#3C#, 16#7E#, 16#18#, 16#7E#, 16#3C#, 16#18#, 16#FF#], -- 0x17 |  ^W|
       [16#18#, 16#3C#, 16#7E#, 16#18#, 16#18#, 16#18#, 16#18#, 16#00#], -- 0x18 |  ^X|
       [16#18#, 16#18#, 16#18#, 16#18#, 16#7E#, 16#3C#, 16#18#, 16#00#], -- 0x19 |  ^Y|
       [16#00#, 16#18#, 16#0C#, 16#FE#, 16#0C#, 16#18#, 16#00#, 16#00#], -- 0x1A |  ^Z|
       [16#00#, 16#30#, 16#60#, 16#FE#, 16#60#, 16#30#, 16#00#, 16#00#], -- 0x1B |  ^[|
       [16#00#, 16#00#, 16#C0#, 16#C0#, 16#C0#, 16#FE#, 16#00#, 16#00#], -- 0x1C |  ^\|
       [16#00#, 16#24#, 16#66#, 16#FF#, 16#66#, 16#24#, 16#00#, 16#00#], -- 0x1D |  ^]|
       [16#00#, 16#18#, 16#3C#, 16#7E#, 16#FF#, 16#FF#, 16#00#, 16#00#], -- 0x1E |  ^^|
       [16#00#, 16#FF#, 16#FF#, 16#7E#, 16#3C#, 16#18#, 16#00#, 16#00#], -- 0x1F |  ^_|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0x20 |    |
       [16#18#, 16#3C#, 16#3C#, 16#18#, 16#18#, 16#00#, 16#18#, 16#00#], -- 0x21 |   !|
       [16#6C#, 16#6C#, 16#6C#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0x22 |   "|
       [16#6C#, 16#6C#, 16#FE#, 16#6C#, 16#FE#, 16#6C#, 16#6C#, 16#00#], -- 0x23 |   #|
       [16#18#, 16#7E#, 16#C0#, 16#7C#, 16#06#, 16#FC#, 16#18#, 16#00#], -- 0x24 |   $|
       [16#00#, 16#C6#, 16#CC#, 16#18#, 16#30#, 16#66#, 16#C6#, 16#00#], -- 0x25 |   %|
       [16#38#, 16#6C#, 16#38#, 16#76#, 16#DC#, 16#CC#, 16#76#, 16#00#], -- 0x26 |   &|
       [16#30#, 16#30#, 16#60#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0x27 |   '|
       [16#18#, 16#30#, 16#60#, 16#60#, 16#60#, 16#30#, 16#18#, 16#00#], -- 0x28 |   (|
       [16#60#, 16#30#, 16#18#, 16#18#, 16#18#, 16#30#, 16#60#, 16#00#], -- 0x29 |   )|
       [16#00#, 16#66#, 16#3C#, 16#FF#, 16#3C#, 16#66#, 16#00#, 16#00#], -- 0x2A |   *|
       [16#00#, 16#18#, 16#18#, 16#7E#, 16#18#, 16#18#, 16#00#, 16#00#], -- 0x2B |   +|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#18#, 16#18#, 16#30#], -- 0x2C |   ,|
       [16#00#, 16#00#, 16#00#, 16#7E#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0x2D |   -|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#18#, 16#18#, 16#00#], -- 0x2E |   .|
       [16#06#, 16#0C#, 16#18#, 16#30#, 16#60#, 16#C0#, 16#80#, 16#00#], -- 0x2F |   /|
       [16#7C#, 16#CE#, 16#DE#, 16#F6#, 16#E6#, 16#C6#, 16#7C#, 16#00#], -- 0x30 |   0|
       [16#30#, 16#70#, 16#30#, 16#30#, 16#30#, 16#30#, 16#FC#, 16#00#], -- 0x31 |   1|
       [16#78#, 16#CC#, 16#0C#, 16#38#, 16#60#, 16#CC#, 16#FC#, 16#00#], -- 0x32 |   2|
       [16#78#, 16#CC#, 16#0C#, 16#38#, 16#0C#, 16#CC#, 16#78#, 16#00#], -- 0x33 |   3|
       [16#1C#, 16#3C#, 16#6C#, 16#CC#, 16#FE#, 16#0C#, 16#1E#, 16#00#], -- 0x34 |   4|
       [16#FC#, 16#C0#, 16#F8#, 16#0C#, 16#0C#, 16#CC#, 16#78#, 16#00#], -- 0x35 |   5|
       [16#38#, 16#60#, 16#C0#, 16#F8#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0x36 |   6|
       [16#FC#, 16#CC#, 16#0C#, 16#18#, 16#30#, 16#30#, 16#30#, 16#00#], -- 0x37 |   7|
       [16#78#, 16#CC#, 16#CC#, 16#78#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0x38 |   8|
       [16#78#, 16#CC#, 16#CC#, 16#7C#, 16#0C#, 16#18#, 16#70#, 16#00#], -- 0x39 |   9|
       [16#00#, 16#18#, 16#18#, 16#00#, 16#00#, 16#18#, 16#18#, 16#00#], -- 0x3A |   :|
       [16#00#, 16#18#, 16#18#, 16#00#, 16#00#, 16#18#, 16#18#, 16#30#], -- 0x3B |   ;|
       [16#18#, 16#30#, 16#60#, 16#C0#, 16#60#, 16#30#, 16#18#, 16#00#], -- 0x3C |   <|
       [16#00#, 16#00#, 16#7E#, 16#00#, 16#7E#, 16#00#, 16#00#, 16#00#], -- 0x3D |   =|
       [16#60#, 16#30#, 16#18#, 16#0C#, 16#18#, 16#30#, 16#60#, 16#00#], -- 0x3E |   >|
       [16#3C#, 16#66#, 16#0C#, 16#18#, 16#18#, 16#00#, 16#18#, 16#00#], -- 0x3F |   ?|
       [16#7C#, 16#C6#, 16#DE#, 16#DE#, 16#DC#, 16#C0#, 16#7C#, 16#00#], -- 0x40 |   @|
       [16#30#, 16#78#, 16#CC#, 16#CC#, 16#FC#, 16#CC#, 16#CC#, 16#00#], -- 0x41 |   A|
       [16#FC#, 16#66#, 16#66#, 16#7C#, 16#66#, 16#66#, 16#FC#, 16#00#], -- 0x42 |   B|
       [16#3C#, 16#66#, 16#C0#, 16#C0#, 16#C0#, 16#66#, 16#3C#, 16#00#], -- 0x43 |   C|
       [16#F8#, 16#6C#, 16#66#, 16#66#, 16#66#, 16#6C#, 16#F8#, 16#00#], -- 0x44 |   D|
       [16#FE#, 16#62#, 16#68#, 16#78#, 16#68#, 16#62#, 16#FE#, 16#00#], -- 0x45 |   E|
       [16#FE#, 16#62#, 16#68#, 16#78#, 16#68#, 16#60#, 16#F0#, 16#00#], -- 0x46 |   F|
       [16#3C#, 16#66#, 16#C0#, 16#C0#, 16#CE#, 16#66#, 16#3A#, 16#00#], -- 0x47 |   G|
       [16#CC#, 16#CC#, 16#CC#, 16#FC#, 16#CC#, 16#CC#, 16#CC#, 16#00#], -- 0x48 |   H|
       [16#78#, 16#30#, 16#30#, 16#30#, 16#30#, 16#30#, 16#78#, 16#00#], -- 0x49 |   I|
       [16#1E#, 16#0C#, 16#0C#, 16#0C#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0x4A |   J|
       [16#E6#, 16#66#, 16#6C#, 16#78#, 16#6C#, 16#66#, 16#E6#, 16#00#], -- 0x4B |   K|
       [16#F0#, 16#60#, 16#60#, 16#60#, 16#62#, 16#66#, 16#FE#, 16#00#], -- 0x4C |   L|
       [16#C6#, 16#EE#, 16#FE#, 16#FE#, 16#D6#, 16#C6#, 16#C6#, 16#00#], -- 0x4D |   M|
       [16#C6#, 16#E6#, 16#F6#, 16#DE#, 16#CE#, 16#C6#, 16#C6#, 16#00#], -- 0x4E |   N|
       [16#38#, 16#6C#, 16#C6#, 16#C6#, 16#C6#, 16#6C#, 16#38#, 16#00#], -- 0x4F |   O|
       [16#FC#, 16#66#, 16#66#, 16#7C#, 16#60#, 16#60#, 16#F0#, 16#00#], -- 0x50 |   P|
       [16#7C#, 16#C6#, 16#C6#, 16#C6#, 16#D6#, 16#7C#, 16#0E#, 16#00#], -- 0x51 |   Q|
       [16#FC#, 16#66#, 16#66#, 16#7C#, 16#6C#, 16#66#, 16#E6#, 16#00#], -- 0x52 |   R|
       [16#7C#, 16#C6#, 16#E0#, 16#78#, 16#0E#, 16#C6#, 16#7C#, 16#00#], -- 0x53 |   S|
       [16#FC#, 16#B4#, 16#30#, 16#30#, 16#30#, 16#30#, 16#78#, 16#00#], -- 0x54 |   T|
       [16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#FC#, 16#00#], -- 0x55 |   U|
       [16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#78#, 16#30#, 16#00#], -- 0x56 |   V|
       [16#C6#, 16#C6#, 16#C6#, 16#C6#, 16#D6#, 16#FE#, 16#6C#, 16#00#], -- 0x57 |   W|
       [16#C6#, 16#C6#, 16#6C#, 16#38#, 16#6C#, 16#C6#, 16#C6#, 16#00#], -- 0x58 |   X|
       [16#CC#, 16#CC#, 16#CC#, 16#78#, 16#30#, 16#30#, 16#78#, 16#00#], -- 0x59 |   Y|
       [16#FE#, 16#C6#, 16#8C#, 16#18#, 16#32#, 16#66#, 16#FE#, 16#00#], -- 0x5A |   Z|
       [16#78#, 16#60#, 16#60#, 16#60#, 16#60#, 16#60#, 16#78#, 16#00#], -- 0x5B |   [|
       [16#C0#, 16#60#, 16#30#, 16#18#, 16#0C#, 16#06#, 16#02#, 16#00#], -- 0x5C |   \|
       [16#78#, 16#18#, 16#18#, 16#18#, 16#18#, 16#18#, 16#78#, 16#00#], -- 0x5D |   ]|
       [16#10#, 16#38#, 16#6C#, 16#C6#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0x5E |   ^|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#FF#], -- 0x5F |   _|
       [16#30#, 16#30#, 16#18#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0x60 |   `|
       [16#00#, 16#00#, 16#78#, 16#0C#, 16#7C#, 16#CC#, 16#76#, 16#00#], -- 0x61 |   a|
       [16#E0#, 16#60#, 16#60#, 16#7C#, 16#66#, 16#66#, 16#DC#, 16#00#], -- 0x62 |   b|
       [16#00#, 16#00#, 16#78#, 16#CC#, 16#C0#, 16#CC#, 16#78#, 16#00#], -- 0x63 |   c|
       [16#1C#, 16#0C#, 16#0C#, 16#7C#, 16#CC#, 16#CC#, 16#76#, 16#00#], -- 0x64 |   d|
       [16#00#, 16#00#, 16#78#, 16#CC#, 16#FC#, 16#C0#, 16#78#, 16#00#], -- 0x65 |   e|
       [16#38#, 16#6C#, 16#64#, 16#F0#, 16#60#, 16#60#, 16#F0#, 16#00#], -- 0x66 |   f|
       [16#00#, 16#00#, 16#76#, 16#CC#, 16#CC#, 16#7C#, 16#0C#, 16#F8#], -- 0x67 |   g|
       [16#E0#, 16#60#, 16#6C#, 16#76#, 16#66#, 16#66#, 16#E6#, 16#00#], -- 0x68 |   h|
       [16#30#, 16#00#, 16#70#, 16#30#, 16#30#, 16#30#, 16#78#, 16#00#], -- 0x69 |   i|
       [16#0C#, 16#00#, 16#1C#, 16#0C#, 16#0C#, 16#CC#, 16#CC#, 16#78#], -- 0x6A |   j|
       [16#E0#, 16#60#, 16#66#, 16#6C#, 16#78#, 16#6C#, 16#E6#, 16#00#], -- 0x6B |   k|
       [16#70#, 16#30#, 16#30#, 16#30#, 16#30#, 16#30#, 16#78#, 16#00#], -- 0x6C |   l|
       [16#00#, 16#00#, 16#CC#, 16#FE#, 16#FE#, 16#D6#, 16#D6#, 16#00#], -- 0x6D |   m|
       [16#00#, 16#00#, 16#B8#, 16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#00#], -- 0x6E |   n|
       [16#00#, 16#00#, 16#78#, 16#CC#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0x6F |   o|
       [16#00#, 16#00#, 16#DC#, 16#66#, 16#66#, 16#7C#, 16#60#, 16#F0#], -- 0x70 |   p|
       [16#00#, 16#00#, 16#76#, 16#CC#, 16#CC#, 16#7C#, 16#0C#, 16#1E#], -- 0x71 |   q|
       [16#00#, 16#00#, 16#DC#, 16#76#, 16#62#, 16#60#, 16#F0#, 16#00#], -- 0x72 |   r|
       [16#00#, 16#00#, 16#7C#, 16#C0#, 16#70#, 16#1C#, 16#F8#, 16#00#], -- 0x73 |   s|
       [16#10#, 16#30#, 16#FC#, 16#30#, 16#30#, 16#34#, 16#18#, 16#00#], -- 0x74 |   t|
       [16#00#, 16#00#, 16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#76#, 16#00#], -- 0x75 |   u|
       [16#00#, 16#00#, 16#CC#, 16#CC#, 16#CC#, 16#78#, 16#30#, 16#00#], -- 0x76 |   v|
       [16#00#, 16#00#, 16#C6#, 16#C6#, 16#D6#, 16#FE#, 16#6C#, 16#00#], -- 0x77 |   w|
       [16#00#, 16#00#, 16#C6#, 16#6C#, 16#38#, 16#6C#, 16#C6#, 16#00#], -- 0x78 |   x|
       [16#00#, 16#00#, 16#CC#, 16#CC#, 16#CC#, 16#7C#, 16#0C#, 16#F8#], -- 0x79 |   y|
       [16#00#, 16#00#, 16#FC#, 16#98#, 16#30#, 16#64#, 16#FC#, 16#00#], -- 0x7A |   z|
       [16#1C#, 16#30#, 16#30#, 16#E0#, 16#30#, 16#30#, 16#1C#, 16#00#], -- 0x7B |   {|
       [16#18#, 16#18#, 16#18#, 16#00#, 16#18#, 16#18#, 16#18#, 16#00#], -- 0x7C |   ||
       [16#E0#, 16#30#, 16#30#, 16#1C#, 16#30#, 16#30#, 16#E0#, 16#00#], -- 0x7D |   }|
       [16#76#, 16#DC#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0x7E |   ~|
       [16#00#, 16#10#, 16#38#, 16#6C#, 16#C6#, 16#C6#, 16#FE#, 16#00#], -- 0x7F | DEL|
       [16#78#, 16#CC#, 16#C0#, 16#CC#, 16#78#, 16#18#, 16#0C#, 16#78#], -- 0x80 |^M-@|
       [16#00#, 16#CC#, 16#00#, 16#CC#, 16#CC#, 16#CC#, 16#7E#, 16#00#], -- 0x81 |^M-A|
       [16#1C#, 16#00#, 16#78#, 16#CC#, 16#FC#, 16#C0#, 16#78#, 16#00#], -- 0x82 |^M-B|
       [16#7E#, 16#C3#, 16#3C#, 16#06#, 16#3E#, 16#66#, 16#3F#, 16#00#], -- 0x83 |^M-C|
       [16#CC#, 16#00#, 16#78#, 16#0C#, 16#7C#, 16#CC#, 16#7E#, 16#00#], -- 0x84 |^M-D|
       [16#E0#, 16#00#, 16#78#, 16#0C#, 16#7C#, 16#CC#, 16#7E#, 16#00#], -- 0x85 |^M-E|
       [16#30#, 16#30#, 16#78#, 16#0C#, 16#7C#, 16#CC#, 16#7E#, 16#00#], -- 0x86 |^M-F|
       [16#00#, 16#00#, 16#78#, 16#C0#, 16#C0#, 16#78#, 16#0C#, 16#38#], -- 0x87 |^M-G|
       [16#7E#, 16#C3#, 16#3C#, 16#66#, 16#7E#, 16#60#, 16#3C#, 16#00#], -- 0x88 |^M-H|
       [16#CC#, 16#00#, 16#78#, 16#CC#, 16#FC#, 16#C0#, 16#78#, 16#00#], -- 0x89 |^M-I|
       [16#E0#, 16#00#, 16#78#, 16#CC#, 16#FC#, 16#C0#, 16#78#, 16#00#], -- 0x8A |^M-J|
       [16#CC#, 16#00#, 16#70#, 16#30#, 16#30#, 16#30#, 16#78#, 16#00#], -- 0x8B |^M-K|
       [16#7C#, 16#C6#, 16#38#, 16#18#, 16#18#, 16#18#, 16#3C#, 16#00#], -- 0x8C |^M-L|
       [16#E0#, 16#00#, 16#70#, 16#30#, 16#30#, 16#30#, 16#78#, 16#00#], -- 0x8D |^M-M|
       [16#C6#, 16#38#, 16#6C#, 16#C6#, 16#FE#, 16#C6#, 16#C6#, 16#00#], -- 0x8E |^M-N|
       [16#30#, 16#30#, 16#00#, 16#78#, 16#CC#, 16#FC#, 16#CC#, 16#00#], -- 0x8F |^M-O|
       [16#1C#, 16#00#, 16#FC#, 16#60#, 16#78#, 16#60#, 16#FC#, 16#00#], -- 0x90 |^M-P|
       [16#00#, 16#00#, 16#7F#, 16#0C#, 16#7F#, 16#CC#, 16#7F#, 16#00#], -- 0x91 |^M-Q|
       [16#3E#, 16#6C#, 16#CC#, 16#FE#, 16#CC#, 16#CC#, 16#CE#, 16#00#], -- 0x92 |^M-R|
       [16#78#, 16#CC#, 16#00#, 16#78#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0x93 |^M-S|
       [16#00#, 16#CC#, 16#00#, 16#78#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0x94 |^M-T|
       [16#00#, 16#E0#, 16#00#, 16#78#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0x95 |^M-U|
       [16#78#, 16#CC#, 16#00#, 16#CC#, 16#CC#, 16#CC#, 16#7E#, 16#00#], -- 0x96 |^M-V|
       [16#00#, 16#E0#, 16#00#, 16#CC#, 16#CC#, 16#CC#, 16#7E#, 16#00#], -- 0x97 |^M-W|
       [16#00#, 16#CC#, 16#00#, 16#CC#, 16#CC#, 16#7C#, 16#0C#, 16#F8#], -- 0x98 |^M-X|
       [16#C3#, 16#18#, 16#3C#, 16#66#, 16#66#, 16#3C#, 16#18#, 16#00#], -- 0x99 |^M-Y|
       [16#CC#, 16#00#, 16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0x9A |^M-Z|
       [16#18#, 16#18#, 16#7E#, 16#C0#, 16#C0#, 16#7E#, 16#18#, 16#18#], -- 0x9B |^M-[|
       [16#38#, 16#6C#, 16#64#, 16#F0#, 16#60#, 16#E6#, 16#FC#, 16#00#], -- 0x9C |^M-\|
       [16#CC#, 16#CC#, 16#78#, 16#FC#, 16#30#, 16#FC#, 16#30#, 16#30#], -- 0x9D |^M-]|
       [16#F8#, 16#CC#, 16#CC#, 16#FA#, 16#C6#, 16#CF#, 16#C6#, 16#C7#], -- 0x9E |^M-^|
       [16#0E#, 16#1B#, 16#18#, 16#3C#, 16#18#, 16#18#, 16#D8#, 16#70#], -- 0x9F |^M-_|
       [16#1C#, 16#00#, 16#78#, 16#0C#, 16#7C#, 16#CC#, 16#7E#, 16#00#], -- 0xA0 | M- |
       [16#38#, 16#00#, 16#70#, 16#30#, 16#30#, 16#30#, 16#78#, 16#00#], -- 0xA1 | M-!|
       [16#00#, 16#1C#, 16#00#, 16#78#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0xA2 | M-"|
       [16#00#, 16#1C#, 16#00#, 16#CC#, 16#CC#, 16#CC#, 16#7E#, 16#00#], -- 0xA3 | M-#|
       [16#00#, 16#F8#, 16#00#, 16#F8#, 16#CC#, 16#CC#, 16#CC#, 16#00#], -- 0xA4 | M-$|
       [16#FC#, 16#00#, 16#CC#, 16#EC#, 16#FC#, 16#DC#, 16#CC#, 16#00#], -- 0xA5 | M-%|
       [16#3C#, 16#6C#, 16#6C#, 16#3E#, 16#00#, 16#7E#, 16#00#, 16#00#], -- 0xA6 | M-&|
       [16#38#, 16#6C#, 16#6C#, 16#38#, 16#00#, 16#7C#, 16#00#, 16#00#], -- 0xA7 | M-'|
       [16#30#, 16#00#, 16#30#, 16#60#, 16#C0#, 16#CC#, 16#78#, 16#00#], -- 0xA8 | M-(|
       [16#00#, 16#00#, 16#00#, 16#FC#, 16#C0#, 16#C0#, 16#00#, 16#00#], -- 0xA9 | M-)|
       [16#00#, 16#00#, 16#00#, 16#FC#, 16#0C#, 16#0C#, 16#00#, 16#00#], -- 0xAA | M-*|
       [16#C3#, 16#C6#, 16#CC#, 16#DE#, 16#33#, 16#66#, 16#CC#, 16#0F#], -- 0xAB | M-+|
       [16#C3#, 16#C6#, 16#CC#, 16#DB#, 16#37#, 16#6F#, 16#CF#, 16#03#], -- 0xAC | M-,|
       [16#18#, 16#18#, 16#00#, 16#18#, 16#18#, 16#18#, 16#18#, 16#00#], -- 0xAD | M--|
       [16#00#, 16#33#, 16#66#, 16#CC#, 16#66#, 16#33#, 16#00#, 16#00#], -- 0xAE | M-.|
       [16#00#, 16#CC#, 16#66#, 16#33#, 16#66#, 16#CC#, 16#00#, 16#00#], -- 0xAF | M-/|
       [16#22#, 16#88#, 16#22#, 16#88#, 16#22#, 16#88#, 16#22#, 16#88#], -- 0xB0 | M-0|
       [16#55#, 16#AA#, 16#55#, 16#AA#, 16#55#, 16#AA#, 16#55#, 16#AA#], -- 0xB1 | M-1|
       [16#DB#, 16#77#, 16#DB#, 16#EE#, 16#DB#, 16#77#, 16#DB#, 16#EE#], -- 0xB2 | M-2|
       [16#18#, 16#18#, 16#18#, 16#18#, 16#18#, 16#18#, 16#18#, 16#18#], -- 0xB3 | M-3|
       [16#18#, 16#18#, 16#18#, 16#18#, 16#F8#, 16#18#, 16#18#, 16#18#], -- 0xB4 | M-4|
       [16#18#, 16#18#, 16#F8#, 16#18#, 16#F8#, 16#18#, 16#18#, 16#18#], -- 0xB5 | M-5|
       [16#36#, 16#36#, 16#36#, 16#36#, 16#F6#, 16#36#, 16#36#, 16#36#], -- 0xB6 | M-6|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#FE#, 16#36#, 16#36#, 16#36#], -- 0xB7 | M-7|
       [16#00#, 16#00#, 16#F8#, 16#18#, 16#F8#, 16#18#, 16#18#, 16#18#], -- 0xB8 | M-8|
       [16#36#, 16#36#, 16#F6#, 16#06#, 16#F6#, 16#36#, 16#36#, 16#36#], -- 0xB9 | M-9|
       [16#36#, 16#36#, 16#36#, 16#36#, 16#36#, 16#36#, 16#36#, 16#36#], -- 0xBA | M-:|
       [16#00#, 16#00#, 16#FE#, 16#06#, 16#F6#, 16#36#, 16#36#, 16#36#], -- 0xBB | M-;|
       [16#36#, 16#36#, 16#F6#, 16#06#, 16#FE#, 16#00#, 16#00#, 16#00#], -- 0xBC | M-<|
       [16#36#, 16#36#, 16#36#, 16#36#, 16#FE#, 16#00#, 16#00#, 16#00#], -- 0xBD | M-=|
       [16#18#, 16#18#, 16#F8#, 16#18#, 16#F8#, 16#00#, 16#00#, 16#00#], -- 0xBE | M->|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#F8#, 16#18#, 16#18#, 16#18#], -- 0xBF | M-?|
       [16#18#, 16#18#, 16#18#, 16#18#, 16#1F#, 16#00#, 16#00#, 16#00#], -- 0xC0 | M-@|
       [16#18#, 16#18#, 16#18#, 16#18#, 16#FF#, 16#00#, 16#00#, 16#00#], -- 0xC1 | M-A|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#FF#, 16#18#, 16#18#, 16#18#], -- 0xC2 | M-B|
       [16#18#, 16#18#, 16#18#, 16#18#, 16#1F#, 16#18#, 16#18#, 16#18#], -- 0xC3 | M-C|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#FF#, 16#00#, 16#00#, 16#00#], -- 0xC4 | M-D|
       [16#18#, 16#18#, 16#18#, 16#18#, 16#FF#, 16#18#, 16#18#, 16#18#], -- 0xC5 | M-E|
       [16#18#, 16#18#, 16#1F#, 16#18#, 16#1F#, 16#18#, 16#18#, 16#18#], -- 0xC6 | M-F|
       [16#36#, 16#36#, 16#36#, 16#36#, 16#37#, 16#36#, 16#36#, 16#36#], -- 0xC7 | M-G|
       [16#36#, 16#36#, 16#37#, 16#30#, 16#3F#, 16#00#, 16#00#, 16#00#], -- 0xC8 | M-H|
       [16#00#, 16#00#, 16#3F#, 16#30#, 16#37#, 16#36#, 16#36#, 16#36#], -- 0xC9 | M-I|
       [16#36#, 16#36#, 16#F7#, 16#00#, 16#FF#, 16#00#, 16#00#, 16#00#], -- 0xCA | M-J|
       [16#00#, 16#00#, 16#FF#, 16#00#, 16#F7#, 16#36#, 16#36#, 16#36#], -- 0xCB | M-K|
       [16#36#, 16#36#, 16#37#, 16#30#, 16#37#, 16#36#, 16#36#, 16#36#], -- 0xCC | M-L|
       [16#00#, 16#00#, 16#FF#, 16#00#, 16#FF#, 16#00#, 16#00#, 16#00#], -- 0xCD | M-M|
       [16#36#, 16#36#, 16#F7#, 16#00#, 16#F7#, 16#36#, 16#36#, 16#36#], -- 0xCE | M-N|
       [16#18#, 16#18#, 16#FF#, 16#00#, 16#FF#, 16#00#, 16#00#, 16#00#], -- 0xCF | M-O|
       [16#36#, 16#36#, 16#36#, 16#36#, 16#FF#, 16#00#, 16#00#, 16#00#], -- 0xD0 | M-P|
       [16#00#, 16#00#, 16#FF#, 16#00#, 16#FF#, 16#18#, 16#18#, 16#18#], -- 0xD1 | M-Q|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#FF#, 16#36#, 16#36#, 16#36#], -- 0xD2 | M-R|
       [16#36#, 16#36#, 16#36#, 16#36#, 16#3F#, 16#00#, 16#00#, 16#00#], -- 0xD3 | M-S|
       [16#18#, 16#18#, 16#1F#, 16#18#, 16#1F#, 16#00#, 16#00#, 16#00#], -- 0xD4 | M-T|
       [16#00#, 16#00#, 16#1F#, 16#18#, 16#1F#, 16#18#, 16#18#, 16#18#], -- 0xD5 | M-U|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#3F#, 16#36#, 16#36#, 16#36#], -- 0xD6 | M-V|
       [16#36#, 16#36#, 16#36#, 16#36#, 16#FF#, 16#36#, 16#36#, 16#36#], -- 0xD7 | M-W|
       [16#18#, 16#18#, 16#FF#, 16#18#, 16#FF#, 16#18#, 16#18#, 16#18#], -- 0xD8 | M-X|
       [16#18#, 16#18#, 16#18#, 16#18#, 16#F8#, 16#00#, 16#00#, 16#00#], -- 0xD9 | M-Y|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#1F#, 16#18#, 16#18#, 16#18#], -- 0xDA | M-Z|
       [16#FF#, 16#FF#, 16#FF#, 16#FF#, 16#FF#, 16#FF#, 16#FF#, 16#FF#], -- 0xDB | M-[|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#FF#, 16#FF#, 16#FF#, 16#FF#], -- 0xDC | M-\|
       [16#F0#, 16#F0#, 16#F0#, 16#F0#, 16#F0#, 16#F0#, 16#F0#, 16#F0#], -- 0xDD | M-]|
       [16#0F#, 16#0F#, 16#0F#, 16#0F#, 16#0F#, 16#0F#, 16#0F#, 16#0F#], -- 0xDE | M-^|
       [16#FF#, 16#FF#, 16#FF#, 16#FF#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0xDF | M-_|
       [16#00#, 16#00#, 16#76#, 16#DC#, 16#C8#, 16#DC#, 16#76#, 16#00#], -- 0xE0 | M-`|
       [16#00#, 16#78#, 16#CC#, 16#F8#, 16#CC#, 16#F8#, 16#C0#, 16#C0#], -- 0xE1 | M-a|
       [16#00#, 16#FC#, 16#CC#, 16#C0#, 16#C0#, 16#C0#, 16#C0#, 16#00#], -- 0xE2 | M-b|
       [16#00#, 16#FE#, 16#6C#, 16#6C#, 16#6C#, 16#6C#, 16#6C#, 16#00#], -- 0xE3 | M-c|
       [16#FC#, 16#CC#, 16#60#, 16#30#, 16#60#, 16#CC#, 16#FC#, 16#00#], -- 0xE4 | M-d|
       [16#00#, 16#00#, 16#7E#, 16#D8#, 16#D8#, 16#D8#, 16#70#, 16#00#], -- 0xE5 | M-e|
       [16#00#, 16#66#, 16#66#, 16#66#, 16#66#, 16#7C#, 16#60#, 16#C0#], -- 0xE6 | M-f|
       [16#00#, 16#76#, 16#DC#, 16#18#, 16#18#, 16#18#, 16#18#, 16#00#], -- 0xE7 | M-g|
       [16#FC#, 16#30#, 16#78#, 16#CC#, 16#CC#, 16#78#, 16#30#, 16#FC#], -- 0xE8 | M-h|
       [16#38#, 16#6C#, 16#C6#, 16#FE#, 16#C6#, 16#6C#, 16#38#, 16#00#], -- 0xE9 | M-i|
       [16#38#, 16#6C#, 16#C6#, 16#C6#, 16#6C#, 16#6C#, 16#EE#, 16#00#], -- 0xEA | M-j|
       [16#1C#, 16#30#, 16#18#, 16#7C#, 16#CC#, 16#CC#, 16#78#, 16#00#], -- 0xEB | M-k|
       [16#00#, 16#00#, 16#7E#, 16#DB#, 16#DB#, 16#7E#, 16#00#, 16#00#], -- 0xEC | M-l|
       [16#06#, 16#0C#, 16#7E#, 16#DB#, 16#DB#, 16#7E#, 16#60#, 16#C0#], -- 0xED | M-m|
       [16#38#, 16#60#, 16#C0#, 16#F8#, 16#C0#, 16#60#, 16#38#, 16#00#], -- 0xEE | M-n|
       [16#78#, 16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#CC#, 16#00#], -- 0xEF | M-o|
       [16#00#, 16#FC#, 16#00#, 16#FC#, 16#00#, 16#FC#, 16#00#, 16#00#], -- 0xF0 | M-p|
       [16#30#, 16#30#, 16#FC#, 16#30#, 16#30#, 16#00#, 16#FC#, 16#00#], -- 0xF1 | M-q|
       [16#60#, 16#30#, 16#18#, 16#30#, 16#60#, 16#00#, 16#FC#, 16#00#], -- 0xF2 | M-r|
       [16#18#, 16#30#, 16#60#, 16#30#, 16#18#, 16#00#, 16#FC#, 16#00#], -- 0xF3 | M-s|
       [16#0E#, 16#1B#, 16#1B#, 16#18#, 16#18#, 16#18#, 16#18#, 16#18#], -- 0xF4 | M-t|
       [16#18#, 16#18#, 16#18#, 16#18#, 16#18#, 16#D8#, 16#D8#, 16#70#], -- 0xF5 | M-u|
       [16#30#, 16#30#, 16#00#, 16#FC#, 16#00#, 16#30#, 16#30#, 16#00#], -- 0xF6 | M-v|
       [16#00#, 16#76#, 16#DC#, 16#00#, 16#76#, 16#DC#, 16#00#, 16#00#], -- 0xF7 | M-w|
       [16#38#, 16#6C#, 16#6C#, 16#38#, 16#00#, 16#00#, 16#00#, 16#00#], -- 0xF8 | M-x|
       [16#00#, 16#00#, 16#00#, 16#18#, 16#18#, 16#00#, 16#00#, 16#00#], -- 0xF9 | M-y|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#18#, 16#00#, 16#00#, 16#00#], -- 0xFA | M-z|
       [16#0F#, 16#0C#, 16#0C#, 16#0C#, 16#EC#, 16#6C#, 16#3C#, 16#1C#], -- 0xFB | M-{|
       [16#78#, 16#6C#, 16#6C#, 16#6C#, 16#6C#, 16#00#, 16#00#, 16#00#], -- 0xFC | M-||
       [16#70#, 16#18#, 16#30#, 16#60#, 16#78#, 16#00#, 16#00#, 16#00#], -- 0xFD | M-}|
       [16#00#, 16#00#, 16#3C#, 16#3C#, 16#3C#, 16#3C#, 16#00#, 16#00#], -- 0xFE | M-~|
       [16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#, 16#00#]  -- 0xFF |    |
      ];

end Videofont8x8;
