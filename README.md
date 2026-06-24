# Resilient-Algorithms-Data-Structures

This repository provides an Ada implementation of resilient algorithms and data structures as described in the research paper "Exploiting non-constant safe memory in resilient algorithms and data structures". The implementation focuses on resilient sorting and priority queues.

## Overview

This project demonstrates **resilient algorithms** implemented in **Ada**. The algorithms use **triple modular redundancy (TMR)** and **checksum verification** to detect and handle faults in memory.

> **Note**: This implementation uses standard Ada (not Ada SPARK) as certain parts were difficult to verify with GNATPROVE.

## Features

### 1. Resilient Sorting Algorithm
- **Insertion Sort** implementation with runtime assertions
- Sorts arrays of type `Arr` (1..1000 elements of type `Element`)
- Includes post-sort verification via assertions
- Handles edge cases with proper array bounds checking

### 2. Resilient Priority Queue
- **Max-Heap** implementation with triple modular redundancy
- Each element is stored in three copies (`Data`, `Copy1`, `Copy2`)
- **Checksum verification** for error detection
- **Heap property** maintained and verified
- Operations:
  - `ResilientPriorityQueueInsert`: Insert element with heap maintenance
  - `ResilientPriorityQueueExtractMax`: Remove and return maximum element
  - `IsEmpty`: Check if queue is empty
  - `SizeOf`: Return current queue size

### 3. Fault Detection Mechanisms
- **Triple Modular Redundancy (TMR)**: All priority queue data is stored in triplicate
- **Checksum Validation**: Integer checksum of all elements for error detection
- **Runtime Assertions**: `pragma Assert` statements verify invariants at runtime

## Implementation Details

### Type System
- `Element`: Integer range 1..1000
- `Index`: Integer range 0..1000
- `Arr`: Array (1..1000) of Element
- `Heap_Array`: Array (1..1000) of Element
- `PriorityQueue`: Record containing Data, Copy1, Copy2, Size, and Checksum

### Resilience Techniques
1. **TMR for Data Storage**: Priority queue maintains three identical copies of the heap
2. **Checksum Verification**: After each operation, checksum is recalculated and verified
3. **Invariant Checking**: `PriorityQueueInvariant` function verifies:
   - All three copies are identical
   - Checksum matches computed value
   - Heap property is maintained

## Usage

### Building
```bash
# Compile with GPRBuild
gprbuild -P resilient_algorithms.gpr

# Clean build
rm -rf obj bin && gprbuild -P resilient_algorithms.gpr
```

### Running
```bash
./bin/main
```

### Output
The test program demonstrates:
1. **Resilient Sort**: Sorts an array and displays first/last 20 elements before and after
2. **Priority Queue**: Inserts elements, extracts in descending order, verifies size

## Verification

### Current Status
- ✅ Compiles with zero warnings
- ✅ Runs without runtime errors
- ✅ All assertions pass
- ✅ Sorting produces correct results
- ✅ Priority queue operations work correctly

## Files

- `resilient_algorithms.ads`: Package specification with type definitions
- `resilient_algorithms.adb`: Package body with implementations
- `resilient_algorithms.gpr`: GNAT project file
- `main.adb`: Test program demonstrating functionality
- `README.md`: This file

## Research Context

This implementation supports the research in:
> "Exploiting non-constant safe memory in resilient algorithms and data structures"

The code demonstrates how formal methods (SPARK) can be used to verify resilient algorithms that tolerate memory faults through redundancy and error detection.

## Future Work

- Add gnatprove verification scripts
- Implement additional resilient data structures (e.g., resilient hash tables, trees)
- Add fault injection testing
- Extend SPARK contracts for full formal verification

## License

This project is open source and available for academic and research use.
