#!/bin/bash
# 
# 
#
# Created by Gary Grutzek on 03.05.2010
# Copyright 2011 VIAT. All rights reserved.


# HELPERS
###########
usage() {
 echo "Usage: $0 <source folder> <target folder>"
 echo "be sure to have sox installed"
}

# MAIN
##########
if [ "$#" != "2" ]
 then
  echo "argc is $#"
  usage
  exit 1
fi

IN_DIRNAME=$1
OUT_DIRNAME=$2

# check if relative or absolute path
char=${IN_DIRNAME:0:1}
if [ $char == "/" ]
	then 
	IN_PATH="${IN_DIRNAME}/*"
elif [ $char == "." ]
	then
	IN_PATH="${IN_DIRNAME}/*"
	else 
	IN_PATH="./${IN_DIRNAME}/*"
fi

char=${OUT_DIRNAME:0:1}
if [ $char == "/" ]
	then 
	OUT_PATH="${OUT_DIRNAME}/"
elif [ $char == "." ]
	then
	OUT_PATH="${OUT_DIRNAME}/"
	else 
	OUT_PATH="./${OUT_DIRNAME}/"
fi

# make dir if not exist
mkdir -p $OUT_PATH

# do for each file in folder ...
for file in $IN_PATH

do
	
 OUT_FILENAME="${file%%.wav}_gsm.wav"
 OUT_FILENAME=${OUT_FILENAME##*/}
 OUT_FILENAME="$OUT_PATH$OUT_FILENAME"
 #echo $OUT_FILENAME
 
 TMP="tmp.gsm"
 # to gsm
 sox $file $TMP
 # back to wav
 sox $TMP -e signed-integer $OUT_FILENAME
 rm $TMP

#exit 0
done