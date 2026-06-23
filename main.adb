-- main.adb
-- Version: 0.03
-- Test program for resilient algorithms

with resilient_algorithms; use resilient_algorithms;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure main is
   -- Test array for sorting
   Test_Array : Arr := (others => 1);
   
   -- Test priority queue
   Test_Queue : PriorityQueue;
   Extracted_Value : Element;
   
begin
   Put_Line("=== Resilient Algorithms Test Program ===");
   New_Line;
   
   -- Test 1: Resilient Sort
   Put_Line("Test 1: Resilient Sort");
   
   -- Fill array with values for testing
   for I in Index range 1 .. 10 loop
      Test_Array(I) := Element(I * 10);
   end loop;
   for I in Index range 11 .. 20 loop
      Test_Array(I) := Element(210 - I * 10);
   end loop;
   for I in Index range 21 .. 1000 loop
      Test_Array(I) := 1;
   end loop;
   
   Put("Array before sorting: ");
   for I in Index range 1 .. 20 loop
      Put(Integer(Test_Array(I)));
      Put(" ");
   end loop;
   New_Line;
   
   -- Sort the array
   ResilientSort(Test_Array);
   
   Put("Array after sorting: ");
   for I in Index range 1 .. 20 loop
      Put(Integer(Test_Array(I)));
      Put(" ");
   end loop;
   New_Line;
   New_Line;
   
   -- Test 2: Priority Queue
   Put_Line("Test 2: Resilient Priority Queue");
   
   -- Insert elements
   ResilientPriorityQueueInsert(Test_Queue, 50);
   ResilientPriorityQueueInsert(Test_Queue, 30);
   ResilientPriorityQueueInsert(Test_Queue, 80);
   ResilientPriorityQueueInsert(Test_Queue, 10);
   ResilientPriorityQueueInsert(Test_Queue, 90);
   ResilientPriorityQueueInsert(Test_Queue, 40);
   
   Put("Priority queue size: ");
   Put(Integer(SizeOf(Test_Queue)));
   New_Line;
   
   Put_Line("Extracting elements from priority queue:");
   
   -- Extract elements (should come out in descending order)
   for I in 1 .. 6 loop
      ResilientPriorityQueueExtractMax(Test_Queue, Extracted_Value);
      Put("Extracted: ");
      Put(Integer(Extracted_Value));
      Put(" - Remaining size: ");
      Put(Integer(SizeOf(Test_Queue)));
      New_Line;
   end loop;
   
   Put("Priority queue is empty: ");
   Put(Boolean'Image(IsEmpty(Test_Queue)));
   New_Line;
   
   Put_Line("=== All tests completed successfully ===");

end main;
