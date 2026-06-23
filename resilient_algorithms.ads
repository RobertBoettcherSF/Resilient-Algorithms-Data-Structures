-- resilient_algorithms.ads
-- Version: 0.01
-- Specifications and contracts for resilient sorting algorithm and resilient priority queue

package ResilientAlgorithms with SPARK_Mode is

   -- Specifications and contracts for resilient sorting algorithm
   procedure ResilientSort(A: in out Arr)
     with
       Pre => -- Preconditions,
       Post => -- Postconditions;

   -- Specifications and contracts for resilient priority queue
   procedure ResilientPriorityQueueInsert(Q: in out PriorityQueue; Val: Element)
     with
       Pre => -- Preconditions,
       Post => -- Postconditions;

end ResilientAlgorithms;
