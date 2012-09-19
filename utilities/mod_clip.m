%% Non-linear distortion (CLIPPING)
%
% Input arguments:
%       file:           Input file (wav) which have to be distorted.
%       percent:        Amount of clipping required (%).
%       outFilePath:    fullpath & filename of modded file
%
% Output arguments:
%       y:              Wav file containing the distorted audio.
%

%       Written by Bernat Escarra Vallmajor
%       Spring 2008
%       Fachhochschule Koeln
%
%       filepath support added by Gary Grutzek 06/10
%
%%
function y=mod_clip(file,percent,outFile)
[x,Fs]=wavread(file);
L=length(x);

maximum=max(x);
minimum=min(x);

percent=percent/100;

nmax=maximum-percent*maximum;
nmin=minimum-percent*minimum;

x=max(x,nmin); % Clip elements from below, force x >= lowerBound
x=min(x,nmax); % Clip elements from above, force x <= upperBound

% for j=1:L
%     if sign(x(j))==1
%         x(j)=(maximum/nmax)*x(j);
%     elseif sign(x(j))==-1
%         x(j)=(minimum/nmin)*x(j);
%     end
% end

y=x;

if nargin < 3
    wavwrite(y,Fs,'mod_clip.wav');
else
    modname = [outFile(1:end-4) '_c' int2str(percent) '.wav']
    wavwrite(y,Fs,modname);
end
