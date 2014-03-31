#include "mm.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>

//Global Variables
int total, next;
char* memoryPool;
char** memoryPointer;
int *memoryPoolMap, *currentMemoryPool;

//Find the first avaible block that fits the requested blockSize
int empty_block(int blockSize){
	int i, j, size, poolIndex;
	poolIndex = 0;
	size = 0;
	j = memoryPoolMap[0];

	for(i = 0; i < total; i++){				//For loop
		while(memoryPoolMap[i] == j && i < total){	//While loop increases the size and i counter
			i++;
			size++;
		}
		if(j == 0 && size >= blockSize){		//If j == 0 and the size is greated than the requested blockSize then return the index
			return poolIndex;
		}
		size = 0;
		poolIndex = i;
		j = memoryPoolMap[i];				//Sets j to our current index in the memoryPoolMap
		i--;						//Negates the for loop so that we are in the correct position
	}

	return -1;						//Return -1 if failed
}

int mm_init(unsigned long size) {
    /* create a memory pool and initialize data structure */

	if((memoryPool = malloc(size*sizeof(char))) == NULL){				//Check if memory pool is malloc successfully
		perror("Unable to allocate space for memoryPool on the heap\n");		//If failed, perror and return -1
		return -1;
	}

	intptr_t i;
	next = 1;
	total = (int)size;								//Sets total to be the size of the pool
	if ((memoryPoolMap = malloc(size*sizeof(int))) == NULL) {			//Check if memory pool map is malloc successfully
		perror("Unable to allocate space for memoryPoolMap on the heap\n");	//If failed, perror and return -1
		return -1;
	}
	if ((currentMemoryPool = malloc(size*sizeof(int))) == NULL) {			//Check if current memory pool is malloc successfully
		perror("Unable to allocate space for currentMemoryPool on the heap\n");	//If failed, perror and return -1
		return -1;
	}
	if((memoryPointer = malloc(size*sizeof(char*))) == NULL){			//Check if memory pointer is malloc successfully
		perror("Unable to allocate space for memoryPointer on the heap\n");	//If failed, perror and return -1
		return -1;
	}
	
	if(open("out.log", O_TRUNC | O_CREAT | O_WRONLY, (S_IRWXG | S_IRWXU | S_IRWXO)) == -1){		//Check if out.log file can be opened
		fprintf(stderr, "ERROR: failed to open out.log file\n");				//If failed, print error
	}
	for(i = 0; i < total; i++){						//For loop
		memoryPoolMap[i] = 0; 						
		currentMemoryPool[i] = 0;					
		memoryPointer[i] = (char*)(memoryPool + i*sizeof(char));	//Sets the memoryPointer index
	}

	return 0;
}


char *mm_alloc(unsigned long nbytes) {
    /* allocate nbytes memory space from the pool using first fit algorithm, and return it to the requester */
	int i, j, fd;
	char* message;
	
	if((i = empty_block(nbytes)) == -1){								//Check if there is memory available for malloc
		fd = open("out.log", (O_APPEND | O_CREAT | O_WRONLY), (S_IRWXG | S_IRWXU | S_IRWXO));	//Open the out.log file
		if(fd == -1){
			fprintf(stderr, "ERROR: failed to open out.log file\n");			//Print error if out.log couldn't be opened
		}
		message = "Request declined: no enough memory available!\n";				//Sets the message we want to put in out.log
		size_t messageLength;
		messageLength = strlen(message);							//Gets the length of the message
		write(fd, message, messageLength * sizeof(char));					//Write to out.log file
	    	close(fd);										//Close out.log file
	    	return NULL;
	}
	
	for(j = i; j < (i + nbytes); j++){
		memoryPoolMap[j] = next;								//Loops through the memoryPoolMap
	}

	next++;
	currentMemoryPool[i] = nbytes;
	return memoryPointer[i];
}

int mm_free(char *ptr) {
	/* Check if ptr is valid or not. Only free the valid pointer. Defragmentation. */
	int i, fd, memoryPoolIndex;
	char* message;
	intptr_t index;
	index = (intptr_t)ptr - (intptr_t)memoryPool;							//Sets index = ptr - memoryPool

	if((index < 0) || (index >= total) || (currentMemoryPool[index] == 0)){
		fd = open("out.log", (O_APPEND | O_CREAT | O_WRONLY), (S_IRWXG | S_IRWXU | S_IRWXO));	//Open/create/overwrite/append to out.log file
    		if(fd == -1){								
    			fprintf(stderr, "ERROR: failed to open out.log file\n");			//Error if unable to open
    		}
    		message = "Free error: not the right pointer!\n";					//Sets the message we want in out.log
		size_t messageLength;
		messageLength = strlen(message);							//Gets the length of the message
		if(write(fd, message, messageLength * sizeof(char)) < 0){
			fprintf(stderr, "ERROR: failed to write to out.log file\n");			//Error if unable to write to out.log
		}
		close(fd);										//Close out.log
		return -1;
	}

	memoryPoolIndex = currentMemoryPool[index];
	for(i = index; i < (memoryPoolIndex + index); i++){
		memoryPoolMap[i] = 0;									//Sets the memoryPoolMap data
	}
	currentMemoryPool[index] = 0;

	return 0;
}

void mm_end( unsigned long *free_num) {
	/* Count total free blocks. Clean up data structure. Free memory pool */
	unsigned long temp;
	total = 0;			//Reset total and next to 0
	next = 0;
	map_memory(&temp, free_num);	//Calls function to map the memory
	free(memoryPool);		//Free memoryPool
	free(memoryPoolMap);		//Free memoryPoolMap
	free(currentMemoryPool);	//Free currentMemoryPool
	free(memoryPointer);		//Free memoryPointer
}

//Assign values to allocated memory space and check buffer overflow
int mm_assign(char *ptr, char val) {
	int fd;
	intptr_t index;
	index = (intptr_t)ptr - (intptr_t)memoryPool;							//Sets index = ptr - memoryPool
	char* message;
	if((index < 0) || (index >= total) || (memoryPoolMap[index] == 0)){
		fd = open("out.log", (O_APPEND | O_CREAT | O_WRONLY), (S_IRWXG | S_IRWXU | S_IRWXO));	//Open/create/overwrite/append to out.log file
    		if(fd == -1){
    			fprintf(stderr, "ERROR: failed to open out.log file\n");			//Error if unable to open
    		}
		message = "Buffer Overflow: Try to access illegal memory space.\n";			//Sets the message we want in out.log
		size_t messageLength;
		messageLength = strlen(message);							//Gets the length of the message
		if(write(fd, message, messageLength * sizeof(char)) < 0){
			fprintf(stderr, "ERROR: failed to write to out.log file\n");			//Error if unable to write to out.log
		}
		close(fd);										//Close out.log file
		return -1;
	}

	*ptr = val;											//Sets ptr = val (input char)
	return 0;
}

//Checks for memory leaks
unsigned long mm_check() {
	unsigned long allocNumber, temp;
   	map_memory(&allocNumber, &temp);	//Calls function to map memory
	return allocNumber;
}

//Function used to map the memory
void map_memory(unsigned long *allocNumber, unsigned long *freeNumber){
	int i, j, blockSize;
	unsigned long totalAllocated = 0, totalFree = 0;
	blockSize = 0;
	j = memoryPoolMap[0];

	for(i = 0; i < total; i++){				//For loop
		while(memoryPoolMap[i] == j && i < total){	//While loop increases the block size and i counter
			blockSize++;
			i++;
		}
		if(j != 0){					//If the current index is allocated, then increases totalAllocated counter
			totalAllocated++;
		}
		else{						//Else increases totalFree counter
			totalFree++;
		}
		j = memoryPoolMap[i];
		blockSize = 0;					//Resets the block size
		i--;						//Negates the for loop so that we are in the correct position
	}
	*allocNumber = totalAllocated;				//Sets the number of allocated blocks
	*freeNumber = totalFree;				//Sets the number of free blocks
}
