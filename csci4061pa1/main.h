/**************************
 * maum.h -- the header file for maum.c 
 *
 *
 *
 *
 *************************/

#ifndef _MAIN_H_
#define _MAIN_H_

#define true 1
#define false 0
typedef int bool;

int makeargv(const char *s, const char *delimiters, char ***argvp);
void custmake_usage(char*);
void parse_file(char*);

#endif
