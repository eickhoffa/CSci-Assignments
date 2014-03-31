#ifndef __MM_H
#define __MM_H

/* You are free to declare any data type here */

int mm_init(unsigned long size);
char *mm_alloc(unsigned long nbytes);
int mm_free(char *ptr);
void mm_end(unsigned long *free_num);
int mm_assign(char *ptr, char val);
unsigned long mm_check();


/*Maps the memory blocks and prints a block summary. Sets the number of allocated and free blocks*/
void map_memory(unsigned long *allocNumber, unsigned long *freeNumber);

/*Returns the index of the first adequate free block if it exists, -1 otherwise*/
int empty_block(int blockSize);




#endif
