/*
 *  Wave.c
 *  Feature-Extraction Framework
 *
 *	read and write wavefiles
 *
 *	known issues: supports only well-formated mono PCM Wave files
 *				  no tagging, just plain 44-Byte header!
 *
 *  Created by Gary on 08.09.10.
 *  Copyright 2010 Fachhochschule Koeln. All rights reserved.
 */
#include "Wave.h"
#include <stdio.h>
#include <stdlib.h>

int ReadWav(const char *path, struct waveFile *ptrWav)
{
	FILE *fid; 
	fid = fopen(path,"r");
	
	if (fid == NULL)
	{
		printf("couldn't open file!\n");
		return EXIT_FAILURE;
	}
	else
	{
		fread(ptrWav->chunkID, 1, 4, fid);		// read 4 chars  // -> same as *(ptrWav).chunkID
		fread(&ptrWav->fileLength, 4, 1, fid);	// read 1 uint32_t
		fread(ptrWav->typeID, 1, 4, fid);		// read 4 chars
		
		// read Subchunk 1 -> Format
		fread(ptrWav->subchunk1ID, 1, 4, fid);	// read 4 chars
		fread(&ptrWav->subchunk1Size, 1, 20, fid); // read 20 Bytes
		
		if (ptrWav->audioFormat != 1)
		{
			printf("no PCM file!\n");
			return EXIT_FAILURE; // no PCM
		}
		if (ptrWav->noOfChannels != 1)
		{
			printf("only mono supported!\n");
			return EXIT_FAILURE; // no mono
		}		
		//read subchunk 2 -> data
		fread(ptrWav->subchunk2ID, 1, 4, fid);
		fread(&ptrWav->subchunk2Size, 4, 1, fid);
		if (ptrWav->subchunk2Size > ptrWav->fileLength) 
		{
			printf("unknown file error!\n");
			return EXIT_FAILURE;
		}	
		ptrWav->dataLength = ptrWav->subchunk2Size / ptrWav->bytesPerSample;
		// get data
		ptrWav->data = (int16_t *)malloc(ptrWav->subchunk2Size); // memory allocation for data array
		fread(ptrWav->data, ptrWav->bytesPerSample, ptrWav->dataLength, fid); // read dataLength bytes
		
		/* //debug prints
		printf("%s\n", ptrWav->chunkID);
		printf("%d\n", ptrWav->fileLength);
		printf("%s\n", ptrWav->typeID);
		printf("%s\n", ptrWav->subchunk1ID);
		printf("%d\n", ptrWav->subchunk1Size);
		printf("%d\n", ptrWav->audioFormat);
		printf("%d\n", ptrWav->noOfChannels);
		printf("fs: %d\n", ptrWav->fs);
		printf("%d\n", ptrWav->byteRate);
		printf("%d\n", ptrWav->bytesPerSample);		// block align
		printf("q: %d\n", ptrWav->bitsPerSample);
		printf("%s\n",ptrWav->subchunk2ID);
		printf("%d\n", ptrWav->dataLength);
		printf("%d\n", ptrWav->data[0]);
		printf("%d\n", ptrWav->data[1]);
		printf("%d\n", ptrWav->data[2]);
		printf("%d\n", ptrWav->data[3]);
		printf("%d\n", ptrWav->data[ptrWav->dataLength/2-4]);
		printf("%d\n", ptrWav->data[ptrWav->dataLength/2-3]);
		printf("%d\n", ptrWav->data[ptrWav->dataLength/2-2]);
		printf("%d\n", ptrWav->data[ptrWav->dataLength/2-1]); // last value: pointer is 16bit aligned while datalength is no of bytes!
		*/
		fclose(fid);
	}
	return EXIT_SUCCESS;
}


// write wave file
int WriteWav(const char *path, int16_t *data, uint32_t dataLength, int fs, int bitsPerSample)
{
	struct waveFile wav;
	struct waveFile *ptrWav; // pointer to struct
	ptrWav = &wav;			 // useless ??

	// collect header info
	wav.chunkID[0] = 'R';
	wav.chunkID[1] = 'I';
	wav.chunkID[2] = 'F';
	wav.chunkID[3] = 'F';
	wav.fileLength = dataLength * (int)(bitsPerSample/8) + 36; //44 byte header + data - 8
	wav.typeID[0] = 'W';
	wav.typeID[1] = 'A';
	wav.typeID[2] = 'V';
	wav.typeID[3] = 'E';
	wav.subchunk1ID[0] = 'f'; 
	wav.subchunk1ID[1] = 'm'; 
	wav.subchunk1ID[2] = 't'; 
	wav.subchunk1ID[3] = ' ';
	wav.subchunk1Size = 16;
	wav.audioFormat = 1;
	wav.noOfChannels = 1;
	wav.fs = fs;
	wav.bitsPerSample = bitsPerSample;
	wav.bytesPerSample = (int)(bitsPerSample/8);
	wav.byteRate = fs * wav.noOfChannels * wav.bytesPerSample;
	wav.subchunk2ID[0] = 'd';
	wav.subchunk2ID[1] = 'a';
	wav.subchunk2ID[2] = 't';
	wav.subchunk2ID[3] = 'a';
	wav.subchunk2Size = dataLength * wav.bytesPerSample;
	
	// write to file
	FILE *fid; 
	fid = fopen(path,"w");
	
	if (fid == NULL)
	{
		printf("couldn't create file!\n");
		return EXIT_FAILURE;
	}	
	else 
	{
		// write simple 44 byte header to file
		fwrite(ptrWav->chunkID, 1, 44, fid); 
		// write data to file
		fwrite(data, wav.bytesPerSample, dataLength , fid);
	}
	fclose(fid);
	return EXIT_SUCCESS;
}

