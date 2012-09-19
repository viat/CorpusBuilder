#include <stdio.h>
#include <stdlib.h>
#include "nistConvert.h"


int main (int argc, const char * argv[]) {
	
    if (argc < 2)
	{
		printf("Usage: NISTConv <source filename> <target filename> (optional)\n");
		return EXIT_FAILURE;
	}
	if (argc == 3) 
		return convertNist(argv[1],argv[2]);
	else		
		return convertNist(argv[1],"0");	
}
