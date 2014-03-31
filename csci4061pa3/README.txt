Cuong Ly (4566337) & Adam Eickhoff (4088090)


This code was compiled and tested on KH2170-14 after completion of the program and tested on various KH2170 machines while being written.


This code is organized as follows:
	empty_block function: Finds the first available block that fits the requested blockSize (helper function)
	mm_init function: Creates a memory pool
	mm_alloc function: Allocates nbytes memory space from the pool using the first fit algorithm, then returns it
	mm_free function: Checks if ptr is valid or not, frees the pointer (if valid) and defragments
	mm_end function: Counts the total number of free blocks, cleans up the data structure, and frees the memory pool
	mm_assign function: Assigns values to the allocated memory space and checks for buffer overflow
	mm_check function: Checks for memory leaks
	map_memory function: Maps the memory (helper function)
					

This code can be compiled by typing 'make' into the terminal and run by typing './mm'. The './mm' command requires no inputs.
