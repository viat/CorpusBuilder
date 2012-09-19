VIAT Corpus Builder
=============

Create the VIAT test corpus with the help of some Shell-Scripts and Matlab files. Telephone Spam files are also included.

Loads 16Bit 8kHz PCM wave data, modifies and writes to given output directory.
Other samplerates should be possible but needs some changes in the scripts

Be sure to have sox and ffmpeg installed for GSM and G726
   
known issues:
- noise is not computed on the fly! could be
  detected by highly sensitive matching algorithm
- do not use spaces in file path

Cologne University of Applied Sciences 
Institut für Nachrichtentechnik  
Gary Grutzek	08/2012

--------------------------
Dependencies:

ffmpeg
http://ffmpeg.org

SOX
http://sox.sourceforge.net

mp3write, mpg123 and mp3info
http://labrosa.ee.columbia.edu/matlab/mp3read.html