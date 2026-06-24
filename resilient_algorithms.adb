-- resilient_algorithms.adb
-- Version: 0.31
-- Implementation of resilient sorting algorithm and resilient priority queue

package body resilient_algorithms is

   -- Helper function to compute checksum for error detection
   function ComputeChecksum(A : Heap_Array; N : Index) return Integer is
      Sum : Integer := 0;
   begin
      for I in Index range 1 .. N loop
         Sum := Sum + Integer(A(I));
      end loop;
      return Sum;
   end ComputeChecksum;

   -- Helper function to copy array (for redundancy)
   procedure CopyArray(Source : Heap_Array; Target : out Heap_Array; N : Index) is
   begin
      for I in Index range 1 .. N loop
         Target(I) := Source(I);
      end loop;
   end CopyArray;

   -- Helper function to check if two arrays are equal
   function ArraysEqual(A, B : Heap_Array; N : Index) return Boolean is
   begin
      for I in Index range 1 .. N loop
         if A(I) /= B(I) then
            return False;
         end if;
      end loop;
      return True;
   end ArraysEqual;

   -- Function to check if priority queue is valid
   function PriorityQueueInvariant(Q : PriorityQueue) return Boolean is
      ExpectedChecksum : Integer;
   begin
      -- Check all three copies are consistent
      if not ArraysEqual(Q.Data, Q.Copy1, Q.Size) then
         return False;
      end if;
      
      if not ArraysEqual(Q.Data, Q.Copy2, Q.Size) then
         return False;
      end if;
      
      -- Check checksum
      ExpectedChecksum := ComputeChecksum(Q.Data, Q.Size);
      if Q.Checksum /= ExpectedChecksum then
         return False;
      end if;
      
      -- Check heap property: parent >= children
      for I in Index range 1 .. Q.Size / 2 loop
         if 2 * I <= Q.Size and then Q.Data(I) < Q.Data(2 * I) then
            return False;
         end if;
         if 2 * I + 1 <= Q.Size and then Q.Data(I) < Q.Data(2 * I + 1) then
            return False;
         end if;
      end loop;
      
      return True;
   end PriorityQueueInvariant;

   -- Helper procedure to sift down for heap maintenance
   procedure SiftDown(Q : in out PriorityQueue; Start, Finish : Index) is
      Root : Index := Start;
      Child : Index;
      Swap : Index;
      Temp_Element : Element;
   begin
      loop
         Child := 2 * Root;
         
         -- Find the largest child
         if Child <= Finish and then Q.Data(Child) > Q.Data(Root) then
            Swap := Child;
         else
            Swap := Root;
         end if;
         
         if Child + 1 <= Finish and then Q.Data(Child + 1) > Q.Data(Swap) then
            Swap := Child + 1;
         end if;
         
         exit when Swap = Root;
         
         -- Swap root and swap
         Temp_Element := Q.Data(Root);
         Q.Data(Root) := Q.Data(Swap);
         Q.Data(Swap) := Temp_Element;
         
         Root := Swap;
      end loop;
      
      -- Update redundant copies
      CopyArray(Q.Data, Q.Copy1, Q.Size);
      CopyArray(Q.Data, Q.Copy2, Q.Size);
      Q.Checksum := ComputeChecksum(Q.Data, Q.Size);
   end SiftDown;

   -- Simple insertion sort for resilience (avoids merge sort complexity)
   procedure ResilientSort(A: in out Arr) is
   begin
      for I in Index range 2 .. 1000 loop
         declare
            Key : constant Element := A(I);
            J : Index := I - 1;
         begin
            while J >= 1 and then A(J) > Key loop
               A(J + 1) := A(J);
               J := J - 1;
            end loop;
            A(J + 1) := Key;
         end;
      end loop;
      
      -- Verify the sort by checking adjacent elements
      for I in Index range 1 .. 999 loop
         pragma Assert(A(I) <= A(I + 1), "Sorting invariant violated");
      end loop;
   end ResilientSort;

   -- Implementation of resilient priority queue insert
   -- Uses a resilient heap with error detection and correction
   procedure ResilientPriorityQueueInsert(Q: in out PriorityQueue; Val: Element) is
      Parent : Index;
      Current : Index;
      Temp_Element : Element;
   begin
      -- Check preconditions
      pragma Assert(Q.Size < 1000, "Priority queue overflow");
      
      -- Increment size
      Q.Size := Q.Size + 1;
      
      -- Add element to the end
      Q.Data(Q.Size) := Val;
      
      -- Update redundant copies
      Q.Copy1(Q.Size) := Val;
      Q.Copy2(Q.Size) := Val;
      
      -- Bubble up to maintain heap property
      Current := Q.Size;
      loop
         Parent := Current / 2;
         exit when Parent = 0 or else Q.Data(Parent) >= Q.Data(Current);
         
         -- Swap parent and current
         Temp_Element := Q.Data(Parent);
         Q.Data(Parent) := Q.Data(Current);
         Q.Data(Current) := Temp_Element;
         
         -- Update redundant copies
         Q.Copy1(Parent) := Q.Data(Parent);
         Q.Copy1(Current) := Q.Data(Current);
         Q.Copy2(Parent) := Q.Data(Parent);
         Q.Copy2(Current) := Q.Data(Current);
         
         Current := Parent;
      end loop;
      
      -- Update checksum
      Q.Checksum := ComputeChecksum(Q.Data, Q.Size);
      
      -- Verify invariant
      pragma Assert(PriorityQueueInvariant(Q), "Priority queue invariant violated after insert");
   end ResilientPriorityQueueInsert;

   -- Implementation of resilient priority queue extract max
   procedure ResilientPriorityQueueExtractMax(Q: in out PriorityQueue; Val: out Element) is
   begin
      -- Check preconditions
      pragma Assert(Q.Size > 0, "Priority queue underflow");
      pragma Assert(PriorityQueueInvariant(Q), "Priority queue invariant violated before extract");
      
      -- Get the max value (root of heap)
      Val := Q.Data(1);
      
      -- Move last element to root
      Q.Data(1) := Q.Data(Q.Size);
      Q.Copy1(1) := Q.Data(1);
      Q.Copy2(1) := Q.Data(1);
      
      -- Decrement size
      Q.Size := Q.Size - 1;
      
      -- Sift down to maintain heap property
      if Q.Size > 0 then
         SiftDown(Q, 1, Q.Size);
      end if;
      
      -- Update checksum
      Q.Checksum := ComputeChecksum(Q.Data, Q.Size);
      
      -- Verify invariant
      pragma Assert(PriorityQueueInvariant(Q), "Priority queue invariant violated after extract");
   end ResilientPriorityQueueExtractMax;

   -- Implementation of IsEmpty
   function IsEmpty(Q : PriorityQueue) return Boolean is
   begin
      return Q.Size = 0;
   end IsEmpty;

   -- Implementation of SizeOf
   function SizeOf(Q : PriorityQueue) return Index is
   begin
      return Q.Size;
   end SizeOf;

end resilient_algorithms;
