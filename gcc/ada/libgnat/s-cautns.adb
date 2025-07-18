------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                 S Y S T E M . C A S E _ U T I L _ N S S                  --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                     Copyright (C) 1995-2025, AdaCore                     --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  Ghost code, loop invariants and assertions in this unit are meant for
--  analysis only, not for run-time checking, as it would be too costly
--  otherwise. This is enforced by setting the assertion policy to Ignore.

pragma Assertion_Policy (Ghost          => Ignore,
                         Loop_Invariant => Ignore,
                         Assert         => Ignore);

package body System.Case_Util_NSS
  with SPARK_Mode
is
   --------------
   -- To_Lower --
   --------------

   function To_Lower (A : Character) return Character is
      A_Val : constant Natural := Character'Pos (A);

   begin
      if A in 'A' .. 'Z'
        or else A_Val in 16#C0# .. 16#D6#
        or else A_Val in 16#D8# .. 16#DE#
      then
         return Character'Val (A_Val + 16#20#);
      else
         return A;
      end if;
   end To_Lower;

   procedure To_Lower (A : in out String) is
   begin
      for J in A'Range loop
         A (J) := To_Lower (A (J));

         pragma Loop_Invariant
           (for all K in A'First .. J => A (K) = To_Lower (A'Loop_Entry (K)));
      end loop;
   end To_Lower;

   --------------
   -- To_Mixed --
   --------------

   procedure To_Mixed (A : in out String) is
      Ucase : Boolean := True;

   begin
      for J in A'Range loop
         if Ucase then
            A (J) := To_Upper (A (J));
         else
            A (J) := To_Lower (A (J));
         end if;

         pragma Loop_Invariant
           (for all K in A'First .. J =>
              (if K = A'First
                 or else A'Loop_Entry (K - 1) = '_'
               then
                 A (K) = To_Upper (A'Loop_Entry (K))
               else
                 A (K) = To_Lower (A'Loop_Entry (K))));

         Ucase := A (J) = '_';
      end loop;
   end To_Mixed;

   --------------
   -- To_Upper --
   --------------

   function To_Upper (A : Character) return Character is
      A_Val : constant Natural := Character'Pos (A);

   begin
      if A in 'a' .. 'z'
        or else A_Val in 16#E0# .. 16#F6#
        or else A_Val in 16#F8# .. 16#FE#
      then
         return Character'Val (A_Val - 16#20#);
      else
         return A;
      end if;
   end To_Upper;

   procedure To_Upper (A : in out String) is
   begin
      for J in A'Range loop
         A (J) := To_Upper (A (J));

         pragma Loop_Invariant
           (for all K in A'First .. J => A (K) = To_Upper (A'Loop_Entry (K)));
      end loop;
   end To_Upper;

end System.Case_Util_NSS;
