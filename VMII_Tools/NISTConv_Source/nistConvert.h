/*
 *  nistConvert.h
 *  NISTConv
 *
 *  Created by Gary on 13.12.10.
 *  Copyright 2010 FH Koeln. All rights reserved.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ipps.h"
#include "Wave.h"


#ifndef	NIST_CONV_H
#define NIST_CONV_H

int convertNist(const char *nistFile, const char *targetPath);


#endif