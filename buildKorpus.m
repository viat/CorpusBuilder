%-----------------------------------------------------------------------
%  Build SPIT-Corpus
%       Loads 16Bit 8kHz PCM wave data, modifies and writes to given output
%       directory.
%       Other samplerate should be possible but needs some changes in the scripts
%       Be sure to have sox and ffmpeg installed for GSM and G726
%
%       1) select desired alterations
%       2) set input path
%       3) set output path
%
%   known issues:
%       - noise is not computed on the fly! could be
%         detected by highly sensitive matching algorithm
%       - do not use spaces in filepaths
%
% FH Köln, Institut für Nachrichtentechnik, 06/2010
% (c) Gary Grutzek
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
% USER SETTINGS
%-------------------------------------------------------------------------

% multiple choice: select desired alteration - 0 = OFF, 1 = ON
ORIGINAL = 1; 
WHITE_NOISE = 1;
PINK_NOISE = 1;
MP3_32 = 1;
MP3_96 = 1;
PACKET_LOSS_5 = 1;
PACKET_LOSS_10 = 1;
G726_32 = 1;
G726_16 = 1;
GSM = 1;

% input folder of wav-files to be converted
wavefilepath = '/path/to/folder/with/input/wavefiles/';

% output path
targetDir = 'spitme';

%-------------------------------------------------------------------------
% USER SETTINGS END
%-------------------------------------------------------------------------

addpath('utilities/', 'utilities/mp3readwrite/');

% Set Environment Variable to overcome
% ffmpeg,sox command not found error (GSM and G726)
p=getenv('PATH');
if ~strcmp(p(end-14:end),':/usr/local/bin')
    setenv('PATH', [getenv('PATH') ':/usr/local/bin']);
    %getenv PATH
end

% get files from given directory, exclude hidden files
[files, names] = getFiles(wavefilepath,1); % ('path',1) if fullpath

if ~exist(targetDir,'dir')
    mkdir(targetDir);
end

tmp = [];
addpath('utilities')
for i=1:length(files)
    
    if ORIGINAL % copy original unaltered file to destination folder
        system(['cp ' files{i} ' ' targetDir]);
    end
    
    if WHITE_NOISE % white noise 20 db SNR
        tmp = mod_noise(files{i},[targetDir '/' names{i}], 20, 'w');
    end
    
    if PINK_NOISE % pink noise 20 db SNR
        tmp = mod_noise(files{i},[targetDir '/' names{i}], 20, 'p');
    end
    
    
    if PACKET_LOSS_5 %  5% packet loss
        tmp = netGen(files{i},5, [targetDir '/' names{i}]);
    end
    
    if PACKET_LOSS_10 %  10% packet loss
        tmp = netGen(files{i},10, [targetDir '/' names{i}]);
    end
    
    if MP3_32
        %  Note: requires external binaries mpg123 and mp3info;
        %  http://labrosa.ee.columbia.edu/matlab/mp3read.html
        [wav, sr] = wavread(files{i});
        mp3write(wav, 8000, 16, [targetDir '/' names{i}(1:end-4) '_mp3_32kbps.mp3'], '--quiet -h -b 32');
    end
    
    if MP3_96
        [wav, sr] = wavread(files{i});
        mp3write(wav, 8000, 16, [targetDir '/' names{i}(1:end-4) '_mp3_96kbps.mp3'], '--quiet -h -b 96');
    end

end


% G726 32 kbps
if G726_32
    err = system(['./wavToG726.sh ' wavefilepath ' ' targetDir ' 32']);
end

% G726 16 kbps
if G726_16
    err = system(['./wavToG726.sh ' wavefilepath ' ' targetDir ' 16']);
end

% GSM full rate
if GSM
    err = system(['./wavToGSM.sh ' wavefilepath ' ' targetDir]);
end


disp('-------------------------')
disp('--------  DONE ----------')


