#!/bin/bash
# 
# 
#
# Created by Gary Grutzek on 03.05.2010
# Copyright 2011 VIAT. All rights reserved.


# HELPERS
###########
usage() {
 echo "Usage: $0 <source folder> <target folder> <bitrate: 16 or 32>"
 echo "be sure to have ffmpeg installed"
}

# MAIN
##########
if [ "$#" != "3" ]
 then
  echo "argc is $#"
  usage
  exit 1
fi

IN_DIRNAME=$1
OUT_DIRNAME=$2
BITRATE=$3

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

    OUT_FILENAME="${file%%.wav}_g726_${BITRATE}.wav"
    OUT_FILENAME=${OUT_FILENAME##*/}
    OUT_FILENAME="$OUT_PATH$OUT_FILENAME"
   	#echo $OUT_FILENAME
	TMP="tmp.wav"
	
  if [ $BITRATE == "16" ] 
  then
 	# to g726
 	ffmpeg -acodec pcm_s16le -ar 8000 -f wav -i $file -acodec g726 -ar 8000 -ab 16000 tmp.wav 
 	# back to wav
 	ffmpeg -acodec pcm_s16le -ar 8000 -f wav $OUT_FILENAME -acodec g726 -ar 8000 -ab 16000 -i tmp.wav 
 	rm $TMP
 elif [ $BITRATE == "32" ] 
 then 
echo 32
 	# to g726
 	ffmpeg -acodec pcm_s16le -ar 8000 -f wav -i $file -acodec g726 -ar 8000 -ab 32000 tmp.wav 
 	# back to wav
 	ffmpeg -acodec pcm_s16le -ar 8000 -f wav $OUT_FILENAME -acodec g726 -ar 8000 -ab 32000 -i tmp.wav 
 	rm $TMP
 fi

#exit 0
done

