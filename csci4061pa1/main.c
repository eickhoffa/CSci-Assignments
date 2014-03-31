/*******************************
 * main.c
 *
 * Source code for main
 *
 ******************************/
#include "util.h"
#include "main.h"
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <errno.h>
/*********
 * Simple usage instructions
 *********/
char* target;
int add_Echo, no_New_Target;
void custmake_usage(char* progname) {
	fprintf(stderr, "Usage: %s [options] [target]\n", progname);
	fprintf(stderr, "-f FILE\t\tRead FILE as a custMakefile.\n");
	fprintf(stderr, "-h\t\tPrint this message and exit.\n");
	fprintf(stderr, "-n\t\tDon't actually execute commands, just print them.\n");
	exit(0);
}

typedef struct Node {
	char* data;		//Linked list structure
	char* commands;
	struct Node *next;
} NODE;

NODE *head = NULL;

int search(char* data){

	NODE* node = head;
	int index = 0;
	while(node != NULL){
		/* Search through the list and look for the node with the specified data 
		   If found, return 0.
		   */
		if(node->data==data){
			printf("Found a node with data %s at position %d\n", data, index);
			return 0;
		}
		node=node->next;
		index++;
	}
	printf("Did not find %s\n", data);
	return -1;
}

int add_node(char* data){		//Adds node to linked list

	NODE* node = NULL;
	if (head == NULL){
		head=(NODE*)malloc(sizeof(NODE));
		if (head == NULL){
			printf("Error: could not allocate memory.\n");
			exit(1);
		}
		/* We are creating the very first node
		   Allocate memory to head here and check for any errors 
		   */
		head->next=NULL;
    		int token_Length = strlen(data);
		head->data = (char*) malloc(token_Length * sizeof(char));
    		head->data = strcpy(head->data, data);
   
   //string copy, malloc
	}else{
		/*  Allocate memory for a node here and check for any errors 
			Make sure you rearange the head to point to this node.
			*/
		node=(NODE *)malloc(sizeof(NODE));
		if (node == NULL){
			printf("Error: could not allocate memory.\n");
			exit(1);
		}
    		int token_Length = strlen(data);
		node->data = (char*) malloc(token_Length * sizeof(char));
    		node->data = strcpy(node->data, data);
		NODE * current = head;
		while(current->next != NULL){
			current = current->next;
		}
		current->next = node;
		node->next = NULL;
	}
	return 0;
}


int makeargv(const char *s, const char *delimiters, char ***argvp) {
	int error;
	int i;
	int numtokens;
	const char *snew;
	char *t;

	if ((s == NULL) || (delimiters == NULL) || (argvp == NULL)) {
		errno = EINVAL;
		return -1;
	}
	*argvp = NULL;                           
	snew = s + strspn(s, delimiters);         /* snew is real start of string */
	if ((t = malloc(strlen(snew) + 1)) == NULL) 
		return -1; 
		strcpy(t, snew);               
		numtokens = 0;
	if (strtok(t, delimiters) != NULL)     /* count the number of tokens in s */
		for (numtokens = 1; strtok(NULL, delimiters) != NULL; numtokens++) ; 

                             /* create argument array for ptrs to the tokens */
	if ((*argvp = malloc((numtokens + 1)*sizeof(char *))) == NULL) {
		error = errno;
		free(t);
		errno = error;
		return -1; 
	} 
                        /* insert pointers to tokens into the argument array */
	if (numtokens == 0) 
		free(t);
	else {
		strcpy(t, snew);
		**argvp = strtok(t, delimiters);
		for (i = 1; i < numtokens; i++)
		*((*argvp) + i) = strtok(NULL, delimiters);
	} 
	*((*argvp) + numtokens) = NULL;             /* put in final NULL pointer */
	return numtokens;
}




/****************************** 
 * this is the function that, when given a proper filename, will
 * parse the custMakefile and read in the targets and commands
 ***************/
void parse_file(char* filename) {

	char* line = malloc(160*sizeof(char));
	FILE* fp = file_open(filename);
	pid_t child_PID;
	int child_Status, return_Value, current_Is_Match, dependency_Length, token_Length, i, j, k;
	int current_Is_Target = 0, no_Dependencies = 0, has_Colon = 0;
	char* colon_Location;
	char* token;
	char* token_Without_Colon;
	char** command_Line_Array;
	while((line = file_getline(line, fp)) != NULL){
	// this loop will go through the given file, one line at a time
	// this is where you need to do the work of interpreting
	// each line of the file to be able to deal with it later
		token = strtok(line, " \n\t\v\f\r");
	  	while (token != NULL){		//While the token is not NULL
	    		token_Length = strlen(token);		//Get the length of the token (includes has_Colon)
	    		if((colon_Location = (char*)malloc(token_Length * sizeof(char))) == NULL){	//Allocate space
				perror("Unable to allocate memory.\n");		
			}
			colon_Location = strchr(token, ':');		//Find location of the has_Colon
			has_Colon = colon_Location-token;		//Gets the first token (such as all, main, util, parseutil...)
			if(colon_Location != NULL){		//Goes into this if statement as long as the line contains a has_Colon
				if(has_Colon != (token_Length-1)){		//Checks to make sure the has_Colon is at the end of the word
					perror("Colon located in the wrong position.\n");
					return;
				}else{
					if((token_Without_Colon = malloc((token_Length-1) * sizeof(char))) == NULL){
						perror("Unable to allocate memory.\n");
					}
					token_Without_Colon = strncpy(token_Without_Colon, token, token_Length-1);		//Copies the token without colon into token_Without_Colon
					token = token_Without_Colon;		//Sets token to be itself (minus the has_Colon)
					if(current_Is_Target){		//Makes sure there is an end command before the new target
						perror("Target does not contain 'end'.\n");
						return;
					}
					current_Is_Target = 1;
					if(no_New_Target){		//Sets our new target, then resets the no_New_Target
						target = token;
						no_New_Target = 0;
					}
				}

			}
			
			if((strcmp(token, "end") != 0) && current_Is_Target && no_Dependencies){		//If we don't have any dependencies, it is a target, and it is not an end command
				i = 0;
				if(add_Echo){		//If we have a -n tag
					add_node("echo");	//Adds an extra echo to each command line and increases our counter
					i++;
				}
				while(token != NULL){	//If our token is NULL
					add_node(token);	//Adds the token to our linked list and increases our counter
					i++;
					token = strtok(NULL, " \n\t\v\f\r");	//Strips the line of colons, new lines, tabs, etc...
				}
				NODE* current = head;		//Creates a node that is equal to the head of the linked list
				if((command_Line_Array = malloc(i*sizeof(char**))) == NULL){	//Allocating space for our command lines
					perror("Unable to allocate memory.\n");
				}
				
				NODE* temp = head;	
				j = 0;
				while(temp != NULL){
					j++;
					temp = temp->next;
				}
				
		  		if(current!=NULL){		//While our current is not NULL
		  		
		  			for(k=0; k < j; k++){
		  				dependency_Length = strlen(current->data);		//Finds the length of our current data
		  				if((command_Line_Array[k] = malloc(dependency_Length*sizeof(char))) == NULL){	//Allocates array for our command line
							perror("Unable to allocate memory.\n");
						}	
						command_Line_Array[k] = strcpy(command_Line_Array[k], current->data);		//Copies our current data into the command line array
    						current = current->next;	//Moves current down the linked list and increments our index pointer
					
		  			}
		  		
  				}
				head = NULL;		//Sets the head to be NULL
				command_Line_Array[j] = NULL;	//And the command line to be NULL
				j = 0;
				child_PID = fork();	//Forks and sets the child_PID
				if(child_PID < 0){	//If the fork fails then prints an error
					perror("Failed to fork.\n");
				}else if(child_PID == 0){		//If you are in the child
					execvp(command_Line_Array[0], command_Line_Array);	//Execute the command
					perror("Child failed to execute.\n");	//Print error if exec failed
				}else if(child_PID != wait(NULL)){	//If parent didn't wait then print error
					perror("Parent did not wait on child.\n");
				}else{
					break;
				}
			}
			
	    		if ((target != NULL) && (strcmp(token,target) == 0) && current_Is_Target){	//Goes into this if statement as long as the target is not NULL, the token and target are equal, and it is a target that we want
				current_Is_Match = 1;		//Keeps track of whether or not we have a match
				token = strtok(NULL, " :\n\t\v\r\f");		//Strips the line of colons, new lines, tabs, etc...
				if(token == NULL){		//If the token is NULL
					target = NULL;		//Sets our target to NULL
					no_Dependencies = 1;		//Keeps track that there are no dependencies, then breaks
					break;
				}
				while(token!=NULL){		//While the token is not NULL
					target = strcpy(target, token);		//Copies the token into our target
					child_PID = fork();		//Forks and sets the child_PID
					if(child_PID > 0){		//If the child is not done
                      				child_PID = wait(&child_Status);		//Parent continues to wait on child status
						return_Value = 1;		//Changes our return value
	      				}else{
						return_Value = 0;		//Sets our return value
						current_Is_Match = 0;		//Changes to say that we no longer have a match, then breaks
						break;
					}
					token = strtok(NULL, " :\n\t\v\r\f");	//Strips the line of colons, new lines, tabs, etc...
				}
				if(return_Value == 1){		//If we are ready to return
					no_Dependencies = 1;		//Says that we have no more dependencies
					target = NULL;		//Sets our target to be NULL
				}
				break;
		
	    		}
			
			if(no_Dependencies && (strcmp(token, "end") == 0) && current_Is_Target){	//Returns if token is end, it is a target, and it is not a dependency
				return;
			}
			if(strcmp(token, "end") == 0){		//If we are done then changes our variable stating that we are at a target to 0 (false)
				current_Is_Target = 0;
				break;
			}else{
	    			break;
	    		}
	  	}
  
	}
	fclose(fp);
	free(line);
	free(colon_Location);
	free(token_Without_Colon);
	free(command_Line_Array);	
}

int main(int argc, char* argv[]) {
	// Declarations for getopt
	extern int optind;
	extern char* optarg;
	int ch;
	char* format = "f:hn";

	// Variables you'll want to use
	char* filename = "custMakefile";
	bool execute = true;

	// Use getopt code to take input appropriately (see section 3).
	while((ch = getopt(argc, argv, format)) != -1) {
		switch(ch) {
			case 'f':
				filename = strdup(optarg);
				break;
			case 'n':
				execute = 0;
				break;
			case 'h':
				custmake_usage(argv[0]);
				break;
		}
	}
	argc -= optind;
	argv += optind;
	if(!execute){		//If we have a -n tag then sets a variable stating that we need to print out the commands instead of executing them
		add_Echo = 1;
	}
	if((target = (char*)malloc(160*sizeof(char))) == NULL){	//Allocates space for our target
		perror("Unable to allocate memory.\n");
	}	
	
	if(*argv != NULL){	//If argv is not NULL
		target = strcpy(target, *argv);		//Then sets the target to be argv
	}else{
		no_New_Target = 1;		//Otherwise states that we have no new targets
	}

	/* at this point, what is left in argv is the target that was
		specified on the command line. If getopt is still really confusing,
		try printing out what's in argv right here, then just run
		custmake with various command-line arguments. */

	parse_file(filename);
	

 
	/* after parsing the file, you'll want to execute the target
		that was specified on the command line, along with its dependencies, etc. */
	
	return 0;
}
