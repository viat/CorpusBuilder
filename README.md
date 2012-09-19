VIAT Corpus Builder
=============
Create the VIAT test corpus with the help of some Shell-Scripts and Matlab files. Telephone Spam files are also included.
Loads 16Bit 8kHz PCM wave data, modifies and writes to given output directory.
Other samplerates should be possible but needs some changes in the scripts.

Be sure to have sox and ffmpeg installed for GSM and G726

The Spit corpus consists of 200 files and is based on 20 real telephone-SPAM recordings.
In order to test the robustness of the algorithm, the 20 SPAM files were intentionally altered by noise, audio- and telephone codecs. 

The alterations in detail are:

   1. original
  	2. G726 16 kbps
	3. G726 32 kbps
  	4. GSM fullrate
	5. mp3-codec 32 kbps
	6. mp3-codec 96 kbps
 	7. pink noise 20dB SNR
  	8. white noise 20dB SNR
  	9. packet loss 5%
  	10. packet loss 10%

Naming Convention:

SPIT_xx_extension.wav (e.g.: SPIT_04_gsm.wav)

extensions are:

 gsm
 g726_16
 g726_32
 n20p
 n20w
 loss5
 loss10
 32 kbps
 96 kbps
 
 
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