/************************
 * util.c
 *
 * utility functions
 *
 ************************/

#include "util.h"
#include <stdlib.h>

/***************
 * These functions are just some handy file functions.
 * We have not yet covered opening and reading from files in C,
 * so we're saving you the pain of dealing with it, for now.
 *******/
FILE* file_open(char* filename) {
	FILE* fp = fopen(filename, "r");
	if(fp == NULL) {
		fprintf(stderr, "ERROR: while opening file %s, abort.\n", filename);
		exit(1);
	}
	return fp;
}

/*******************
 * To use this function properly, create a char* and malloc 
 * 160 bytes for it. Then pass that char* in as the argument
 * this function take in the file pointer return form the function file_open and 
 * a char buffer pointer buffer.
 * this function read in 160 characters from the fp and store them into the buffer pointed by buffer
 * pointer.
 ******************/
char* file_getline(char* buffer, FILE* fp) {
	buffer = fgets(buffer, 160, fp);
	return buffer;
}
