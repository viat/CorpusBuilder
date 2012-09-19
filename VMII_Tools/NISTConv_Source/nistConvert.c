/*
 *  nistConvert.c
 *  NISTConv
 *
 *  Created by Gary on 13.12.10.
 *  Copyright 2010 FH Koeln. All rights reserved.
 *
 */

#include "nistConvert.h"


int convertNist(const char *nistFile,  const char *targetPath)
{
	char *error;
	char tmp[12];
	int headerLen; //
	int fileSize;
	unsigned char *nistData;
	short *waveData;
	IppStatus status;
	const char *wavName;
	// generate wavfilename
	//char wavName[(strlen(nistFile)+1)];
	if (strcmp(targetPath, "0")== 0)
	{
		wavName = malloc(strlen(nistFile)+1);
		strncpy(wavName, nistFile, strlen(nistFile)-4);
		strcat(wavName, ".wav");
	}
	else
	{
		wavName = targetPath;
	}
	
	// open nist file
	FILE *fid = fopen(nistFile, "r");
	if (fid == NULL) 
	{
		printf("File not found!\n");
		return EXIT_FAILURE;
	}
	fseek(fid, 0, SEEK_END); 
	fileSize = ftell(fid); // get filesize
	rewind(fid);
	
	error = fgets(tmp, 10, fid); // skip first line
	error = fgets(tmp, 10, fid); // length of header as a string
	if (error == NULL)
	{
		printf("File error!\n");
		return EXIT_FAILURE;
	}
	headerLen = strtol(tmp, NULL, 10); // length of header as int
	
	// skip header
	fseek(fid, headerLen, SEEK_SET);
	
	// load data
	nistData = malloc(sizeof(char)*(fileSize-headerLen));
	fread(nistData, sizeof(char), fileSize-headerLen, fid);
	fclose(fid);
	
	// convert alaw to 16Bit linear PCM
	waveData = malloc(sizeof(short)*(fileSize-headerLen));
	status = ippsALawToLin_8u16s(nistData, waveData, (fileSize-headerLen));
	
	// write linear PCM-data to file
	//	fid = fopen(wavName,"w");
	//	fwrite(waveData, sizeof(short), (fileSize-headerLen), fid);
	//	fclose(fid);
	WriteWav(wavName, waveData, (fileSize-headerLen), 8000, 16);
	
	free(nistData);
	free(waveData);
	return EXIT_SUCCESS;
}


