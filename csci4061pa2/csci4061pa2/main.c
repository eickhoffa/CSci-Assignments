#include "main.h"
#define BUF_SIZE 32

void traverseDirectory(char* directoryName, char* inputString) {
	DIR* dirptr;
	FILE* logFile;
	struct dirent *current;
	char *currentDirectory, *currentDirectoryParent, *stringPath, *tempString, *outputString, *filter, *currentFileName;
	filter = inputString;
	
	if((tempString = malloc(sizeof(char)*256)) == NULL){
		perror("Unable to allocate memory.\n");
	}
	if ((dirptr = opendir(directoryName)) != NULL){		//If we are still in a directory
		
		current = readdir(dirptr);			//Set the struct current directory
		currentDirectory = current->d_name;		//Create the pointer to the current directory
		current = readdir(dirptr);			//Resets the struct current directory
		currentDirectoryParent = current->d_name;	//Sets the parent of the current directory
		
		if((stringPath = malloc(sizeof(char)*256)) == NULL){
			perror("Unable to allocate memory.\n");
		}
		if((outputString = malloc(sizeof(char)*256)) == NULL){
			perror("Unable to allocate memory.\n");
		}
		
  			while ((current = readdir (dirptr)) != NULL){	//While we still have a directory (haven't reached a file)
		    		currentFileName = current->d_name;		//setting currentFileName
    				strcpy(stringPath, directoryName);		//Copies the directory name to the string path
    				strcat(stringPath, currentFileName);		//Concatenate the file name to the string path
    			
    				strcpy(outputString, stringPath);			//Copies the string path to the output string
    				strcat(outputString, "\n");				//Adds a new line to the end
    				if ((logFile = fopen("log.txt", "a")) != NULL) {	//Creates the file if it doesn't exist or appends
						fputs(outputString, logFile);		//Adds the string to the log.txt file
    				}else{							//Else print error that log.txt couldn't open
    					printf("Couldn't open log.txt.\n");
    					exit(0);
    				}
    				fclose(logFile);
    				strcat(stringPath, "/");		//If it is still a directory then it adds a / to the end
    				traverseDirectory(stringPath, filter);		//Recalls traverseDirectory on the directory
  			}
  		closedir (dirptr);
  		free(stringPath);	//Free stringPath
  		free(outputString);	//Free outputString
	}
	else {
		FILE *inputFile;
		pid_t childPID;	
		int fd[2], oldSTDout, fileInDirectory, outputText;
		ssize_t fileToPipe;
		char buffer[BUF_SIZE];
	
		strncpy(tempString, directoryName, strlen(directoryName)-1);	//Else copies the directory name to a temporary string
		outputText = open("out.txt", O_CREAT | O_WRONLY | O_APPEND, S_IRUSR | S_IWUSR);		//Creates the out.txt file or appends to the existing one
		pipe(fd);		//Open the pipe
		if((childPID = fork()) < 0){		//Fork and create the child pid
			perror("Failed to fork.\n");
		}	
		if (childPID == 0)		//If in the child process
		{
			close(fd[1]);				//Close the write end of the pipe
			oldSTDout = dup(STDOUT_FILENO);		//Create a copy of the file
			if((dup2(outputText, STDOUT_FILENO)) != STDOUT_FILENO){		//Creates a new file descriptor
				printf("Dup2 failed.\n");
				exit(0);
			}
			if((dup2(fd[0], STDIN_FILENO)) != STDIN_FILENO){		//Reads from the pipe
				printf("Dup2 failed.\n");
				exit(0);
			}
			close(fd[0]);				//Close the read end of the pipe
			execlp("grep", "grep", filter, (char *) 0);	//Execute grep
			perror("Child failed to execute.\n");
		}else if(childPID > 0){		//If in the parent process
			close(fd[0]);				//Close the read end of the pipe
			inputFile = fopen(tempString, "r");	//Opens the files in the directory
			fileInDirectory = fileno(inputFile);
			while ((fileToPipe = read(fileInDirectory, buffer, BUF_SIZE))!=0){	//While the pipe is not empty
				write(fd[1], buffer, fileToPipe);				//Writes to the child from the pipe
			}
			fclose(inputFile);		//Closes the file
			close(fileInDirectory);		//Closes the file
			close(fd[1]);			//Close the write end of the pipe.
		}
	}
	free(tempString);	//Free tempString
}




int main(int argc, char *argv[]){
	struct stat buffer;
	
	if (argc < 3){		//If not enough arguments
		printf("Not enough arguments.\n");	//Print and exit
		exit(0);
	}else if(argc > 3){	//If too many arguments
		printf("Too many arguments.\n");	//Print and exit
		exit(0);
	}

	if((stat("log.txt", &buffer)) == 0){
		if((remove("log.txt")) != 0){
			perror("Error deleting log.txt");
		}
	}
	
	if((stat("out.txt", &buffer)) == 0){
		if((remove("out.txt")) != 0){
			perror("Error deleting log.txt");
		}
	}
	
	traverseDirectory(argv[1], argv[2]);	//Calls traverseDirectory with the input directory and input string

	return 0;
}
