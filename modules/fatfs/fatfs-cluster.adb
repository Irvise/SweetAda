-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-cluster.adb                                                                                         --
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

package body FATFS.Cluster is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Is_Valid
      (CCB : in CCB_Type)
      return Boolean with
      Inline => True;

   function Is_Valid
      (C : in Cluster_Type;
       F : in FAT_Type)
      return Boolean with
      Inline => True;

   procedure Get_Next
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean);

   procedure Internal_Locate
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;
       Success :    out Boolean);

   procedure Locate
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;
       Success :    out Boolean);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Is_Valid
   ----------------------------------------------------------------------------
   -- Return True if CCB is valid.
   ----------------------------------------------------------------------------
   function Is_Valid
      (CCB : in CCB_Type)
      return Boolean
      is
   begin
      return CCB.Start_Sector > 0 and then CCB.Sector_Count > 0;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Is_Valid
   ----------------------------------------------------------------------------
   -- Return True if cluster points to a data cluster.
   ----------------------------------------------------------------------------
   function Is_Valid
      (C : in Cluster_Type;
       F : in FAT_Type)
      return Boolean
      is
   begin
      case F is
         when FAT16  => return C >= 2 and then C < 16#FFF0#;
         when FAT32  => return C >= 2 and then C < 16#FFFF_FFF0#;
         when others => return False;
      end case;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Is_End
   ----------------------------------------------------------------------------
   -- Return True if sector is at the end of a cluster.
   ----------------------------------------------------------------------------
   function Is_End
      (CCB : in CCB_Type)
      return Boolean
      is
   begin
      return Unsigned_16 (CCB.Current_Sector - CCB.Start_Sector) >= CCB.Sector_Count; -- __FIX__ to be done in endianness?
   end Is_End;

   ----------------------------------------------------------------------------
   -- To_Sector
   ----------------------------------------------------------------------------
   -- Compute sector address of a cluster.
   ----------------------------------------------------------------------------
   function To_Sector
      (D : in Descriptor_Type;
       C : in Cluster_Type)
      return Sector_Type
      is
   begin
      return D.Cluster_Start + Sector_Type (C - 2) * Sector_Type (D.Sectors_Per_Cluster);
   end To_Sector;

   ----------------------------------------------------------------------------
   -- File_EOF
   ----------------------------------------------------------------------------
   -- Return data cluster EOF value.
   ----------------------------------------------------------------------------
   function File_EOF
      (F : in FAT_Type)
      return Cluster_Type
      is
   begin
      case F is
         when FAT16  => return 16#FFF8#;
         when FAT32  => return 16#FFFF_FFF8#;
         when others => return 1;
      end case;
   end File_EOF;

   ----------------------------------------------------------------------------
   -- Map
   ----------------------------------------------------------------------------
   -- Look for an arbitrary region of the filesystem as if it was a cluster.
   ----------------------------------------------------------------------------
   procedure Map
      (CCB   :    out CCB_Type;
       S     : in     Sector_Type;
       Count : in     Unsigned_16)
       is
   begin
      CCB.Start_Sector    := S;
      CCB.Previous_Sector := 0;
      CCB.Current_Sector  := S;
      CCB.Sector_Count    := Count;
      CCB.Cluster         := 0;     -- this is not actually a cluster
      CCB.First_Cluster   := 0;     -- there is no first cluster
      CCB.IO_Bytes        := 0;
   end Map;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open a cluster.
   ----------------------------------------------------------------------------
   procedure Open
      (D          : in     Descriptor_Type;
       CCB        : in out CCB_Type;
       C          : in     Cluster_Type;
       Keep_First : in     Boolean)
      is
      IO_Bytes      : constant Unsigned_32 := CCB.IO_Bytes;
      The_Cluster   : Cluster_Type := C;
      First_Cluster : Cluster_Type := CCB.First_Cluster;
   begin
      if Is_Valid (The_Cluster, D.FAT_Style) then
         Map (CCB, To_Sector (D, The_Cluster), D.Sectors_Per_Cluster);
         CCB.Cluster := The_Cluster; -- save cluster number
      else
         -- no clusters
         The_Cluster := 0;
         First_Cluster := 0;
         Map (CCB, 0, D.Sectors_Per_Cluster);
      end if;
      if Keep_First then
         CCB.First_Cluster := First_Cluster;
         CCB.IO_Bytes      := IO_Bytes;
      else
         CCB.First_Cluster := The_Cluster;
      end if;
   end Open;

   ----------------------------------------------------------------------------
   -- Get_Next
   ----------------------------------------------------------------------------
   -- Open next cluster, if any.
   ----------------------------------------------------------------------------
   procedure Get_Next
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean)
      is
      Sector : Sector_Type := D.FAT_Start (D.FAT_Index); -- start of FAT
      C      : Cluster_Type := CCB.Cluster;              -- current, then next cluster #
   begin
      if not Is_Valid (CCB) or else C < 2 or else CCB.First_Cluster < 2 then
         -- invalid CCB or end of cluster chain
         Success := False;
         return;
      end if;
      -- locate FAT sector for this cluster number
      Sector := FAT_Sector (D, D.FAT_Style, C);
      D.Read (Physical_Sector (D, Sector), B, Success);
      -- __FIX__ endian?
      if not Success then
         return;
      end if;
      -- retrieve next cluster #
      C := FAT_Entry (D, B, C);
      if not Is_Valid (C, D.FAT_Style) then
         -- no next cluster, treat as an error
         Success := False;
      else
         Open (D, CCB, C, Keep_First => True);
      end if;
   end Get_Next;

   ----------------------------------------------------------------------------
   -- Advance
   ----------------------------------------------------------------------------
   -- Advance by one sector in a cluster.
   ----------------------------------------------------------------------------
   procedure Advance
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean)
      is
   begin
      if not Is_Valid (CCB) then
         Success := False;
         return;
      end if;
      if Is_End (CCB) then
         Get_Next (D, CCB, B, Success);
      else
         CCB.Current_Sector := CCB.Current_Sector + 1;
         Success := True;
      end if;
   end Advance;

   ----------------------------------------------------------------------------
   -- Peek
   ----------------------------------------------------------------------------
   -- Read a cluster, without sector bumping.
   ----------------------------------------------------------------------------
   procedure Peek
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
   begin
      if not Is_Valid (CCB) then
         Success := False;
         return;
      end if;
      if Is_End (CCB) then
         Get_Next (D, CCB, B, Success);
      else
         Success := True;
      end if;
      if Success then
         D.Read (Physical_Sector (D, CCB.Current_Sector), B, Success);
         -- __FIX__ endian?
      end if;
   end Peek;

   ----------------------------------------------------------------------------
   -- Rewind
   ----------------------------------------------------------------------------
   -- Rewind the cluster chain.
   ----------------------------------------------------------------------------
   procedure Rewind
      (D   : in     Descriptor_Type;
       CCB : in out CCB_Type)
      is
   begin
      if CCB.First_Cluster >= 2 then
         Open (D, CCB, CCB.First_Cluster, Keep_First => True);
      else
         CCB.Current_Sector := CCB.Start_Sector;
      end if;
      CCB.Previous_Sector := 0;
      CCB.IO_Bytes        := 0;
   end Rewind;

   ----------------------------------------------------------------------------
   -- Internal_Locate
   ----------------------------------------------------------------------------
   -- Search a free cluster.
   ----------------------------------------------------------------------------
   procedure Internal_Locate
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
      Sector : Sector_Type;
      First  : Boolean := True;
   begin
      Success := False;
      if D.Search_Cluster < 2 then
         D.Search_Cluster := 2; -- search from start of FAT
      end if;
      loop
         Sector := FAT_Sector (D, D.FAT_Style, D.Search_Cluster);
         exit when FAT_Is_End (D, Sector);
         if D.Search_Cluster /= D.Next_Writable_Cluster then -- reserve one cluster for writes
            if FAT_Entry_Index (D.FAT_Style, D.Search_Cluster) = 0 or else D.Search_Cluster = 2 or else First then
               First := False;
               D.Read (Physical_Sector (D, Sector), B, Success); -- read in FAT sector
               exit when not Success;
            end if;
            if FAT_Entry (D, B, D.Search_Cluster) = 0 then
               return; -- free cluster located
            end if;
         end if;
         D.Search_Cluster := D.Search_Cluster + 1;
      end loop;
      D.Search_Cluster := 0; -- no space or I/O error
   end Internal_Locate;

   ----------------------------------------------------------------------------
   -- Locate
   ----------------------------------------------------------------------------
   -- Search for free cluster.
   ----------------------------------------------------------------------------
   procedure Locate
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
      Retry : constant Boolean := D.Search_Cluster > 2;
   begin
      Internal_Locate (D, B, Success);
      if (not Success or else D.Search_Cluster = 0) and then Retry then
         Internal_Locate (D, B, Success);
      end if;
      if Success then
         D.Next_Writable_Cluster := D.Search_Cluster;
      else
         D.Next_Writable_Cluster := 0;
      end if;
   end Locate;

   ----------------------------------------------------------------------------
   -- Prelocate
   ----------------------------------------------------------------------------
   -- Pre-locate a free cluster.
   ----------------------------------------------------------------------------
   procedure Prelocate
      (D : in out Descriptor_Type;
       B :    out Block_Type)
      is
      Success : Boolean;
   begin
      if D.Next_Writable_Cluster < 2 then
         Locate (D, B, Success);
      end if;
   end Prelocate;

   ----------------------------------------------------------------------------
   -- Put_First
   ----------------------------------------------------------------------------
   -- Put a 16/32-bit cluster # into directory entry.
   ----------------------------------------------------------------------------
   procedure Put_First
      (D  : in     Descriptor_Type;
       DE : in out Directory_Entry_Type;
       C  : in     Cluster_Type)
      is
   begin
      DE.First_Cluster := Unsigned_16 (Unsigned_32 (C) and 16#0000_FFFF#);
      if D.FAT_Style = FAT32 then
         DE.Cluster_High := Unsigned_16 (Shift_Right (Unsigned_32 (C), 16));
      end if;
   end Put_First;

   ----------------------------------------------------------------------------
   -- Get_First
   ----------------------------------------------------------------------------
   -- Get a 16/32-bit cluster # from directory entry.
   ----------------------------------------------------------------------------
   function Get_First
      (D  : in     Descriptor_Type;
       DE : in Directory_Entry_Type)
      return Cluster_Type
      is
   begin
      case D.FAT_Style is
         when FAT16 => return Cluster_Type (DE.First_Cluster);
         when FAT32 => return Cluster_Type (
                                            Shift_Left (Unsigned_32 (DE.Cluster_High), 16)
                                            or Unsigned_32 (DE.First_Cluster)
                                           );
         when others => return 0;
      end case;
   end Get_First;

   ----------------------------------------------------------------------------
   -- Claim
   ----------------------------------------------------------------------------
   -- Claim the cluster by marking it as last in cluster chain.
   ----------------------------------------------------------------------------
   procedure Claim
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;      -- I/O buffer to use
       C       : in     Cluster_Type;    -- cluster to mark
       Chain   : in     Cluster_Type;    -- cluster or File_EOF (end of chain)
       Success :    out Boolean)
      is
      Sector : constant Sector_Type := FAT_Sector (D, D.FAT_Style, C);
   begin
      if C = D.Next_Writable_Cluster then
         D.Next_Writable_Cluster := 0;                          -- mark this as in use
      end if;
      D.Read (Physical_Sector (D, Sector), B, Success); -- read in the FAT cluster
      if Success then
         FAT_Put_Entry (D, B, C, Chain);                         -- mark as in use (as EOF)
         FAT_Update (D, Sector, B, Success);                     -- update all FAT copies
      end if;
   end Claim;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read cluster and advance by one sector.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
   begin
      Peek (D, CCB, B, Success);
      if Success then
         CCB.Previous_Sector := CCB.Current_Sector;
         CCB.Current_Sector  := CCB.Current_Sector + 1;
         CCB.IO_Bytes        := CCB.IO_Bytes + Unsigned_32 (D.Sector_Size);
      end if;
   end Read;

   ----------------------------------------------------------------------------
   -- Reread
   ----------------------------------------------------------------------------
   -- Re-read the last read sector of a cluster.
   ----------------------------------------------------------------------------
   procedure Reread
      (D       : in     Descriptor_Type;
       CCB     : in     CCB_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
   begin
      if CCB.Previous_Sector = 0 then
         Success := False;
         return;
      end if;
      D.Read (Physical_Sector (D, CCB.Previous_Sector), B, Success);
   end Reread;

   ----------------------------------------------------------------------------
   -- Release_Chain
   ----------------------------------------------------------------------------
   -- Release a cluster chain.
   ----------------------------------------------------------------------------
   procedure Release_Chain
      (D             : in     Descriptor_Type;
       First_Cluster : in     Cluster_Type;
       B             :    out Block_Type)
      is
      C       : Cluster_Type; -- current cluster in chain
      C_Next  : Cluster_Type; -- next cluster in chain
      Sector  : Sector_Type;  -- FAT sector for cluster
      Success : Boolean;
   begin
      C := First_Cluster;
      loop
         exit when not Is_Valid (C, D.FAT_Style);
         -- read FAT Sector for current cluster
         Sector := FAT_Sector (D, D.FAT_Style, C);
         D.Read (Physical_Sector (D, Sector), B, Success);
         exit when not Success;
         -- update the FAT Sector entry
         C_Next := FAT_Entry (D, B, C);      -- get next cluster, if any
         FAT_Put_Entry (D, B, C, 0);         -- mark this cluster as free
         FAT_Update (D, Sector, B, Success); -- update all FAT entries
         exit when not Success;
         C := C_Next;
      end loop;
   end Release_Chain;

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write the next sector, get next/extend cluster and write.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out WCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean)
      is
      New_Cluster : Cluster_Type := 0;
      DI          : Unsigned_16;
   begin
      if File.CCB.Current_Sector = 0 then
         -- we have an empty new file to write
         null;
      elsif not Is_Valid (File.CCB) then
         Success := False;
         return;
      end if;
      if Unsigned_16 (File.CCB.Current_Sector - File.CCB.Start_Sector) >= File.CCB.Sector_Count or else
         File.CCB.Current_Sector = 0
      then
         -- add first cluster or add a new cluster
         if D.Next_Writable_Cluster < 2 then
            Success := False;
            return; -- no more space or I/O error(s)
         end if;
         -- save write data to the new cluster
         New_Cluster := D.Next_Writable_Cluster;
         D.Write (Physical_Sector (D, To_Sector (D, New_Cluster)), B, Success);
         if not Success then
            return; -- I/O error
         end if;
         -- tell filesystem that we've claimed this cluster
         Claim (D, B, New_Cluster, File_EOF (D.FAT_Style), Success);
         if not Success then
            return;
         end if;
         ---------------------------------------------------------------------
         -- when adding the first cluster, we must update the file's directory
         -- entry with the cluster #
         ---------------------------------------------------------------------
         if File.CCB.Current_Sector = 0 then
            declare
               Dir : aliased Directory_Entry_Array (0 .. 15) with
                  Address    => B (0)'Address,
                  Import     => True,
                  Convention => Ada;
            begin
               D.Read (Physical_Sector (D, File.Directory_Sector), B, Success);
               if Success then
                  DI := File.Directory_Index mod 16;
                  Put_First (D, Dir (DI), New_Cluster);
                  D.Write (Physical_Sector (D, File.Directory_Sector), B, Success);
               end if;
            end;
            if Success then
               Open (D, File.CCB, New_Cluster, Keep_First => False);
            else
               return; -- I/O error
            end if;
         else
            -- otherwise add a cluster to this file's chain
            Claim (D, B, File.CCB.Cluster, New_Cluster, Success); -- link current cluster to next
            if Success then
               Open (D, File.CCB, New_Cluster, Keep_First => True);
            else
               return;
            end if;
         end if;
         File.CCB.IO_Bytes := File.CCB.IO_Bytes + Unsigned_32 (D.Sector_Size);
         Prelocate (D, B);                                                           -- get next free cluster
         D.Read (Physical_Sector (D, File.CCB.Current_Sector), B, Success); -- restore user''s buffer
      else
         D.Write (Physical_Sector (D, File.CCB.Current_Sector), B, Success); -- a simple write
         if Success then
            File.CCB.IO_Bytes := File.CCB.IO_Bytes + Unsigned_32 (D.Sector_Size);
         end if;
      end if;
      File.CCB.Previous_Sector := File.CCB.Current_Sector;     -- the sector just written
      File.CCB.Current_Sector  := File.CCB.Current_Sector + 1; -- the next write goes here
   end Write;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a cluster.
   ----------------------------------------------------------------------------
   procedure Close
      (CCB : out CCB_Type)
      is
   begin
      CCB.Start_Sector := 0;
      CCB.Sector_Count := 0;
   end Close;

end FATFS.Cluster;
