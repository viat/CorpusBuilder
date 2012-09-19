%% Add NOISE to a file
%
% Input arguments:
%       file:   Input file (wav) which the noise have to be added.
%       snr:    SNR(dB) to accomplish.
%       type:   Color of noise to be added ('w' for white, 'p' for pink or 'b' for brown).
%
% Output arguments:
%       y:      Wav file with the added noise.
%
% Notes:
%       Knowing that the energy of a signal is:
%       energy=sum(signal.^2)/size(signal);
%
%       The signal-to-noise ratio is:
%       SNR(dB) = 10*log10(energy(signal)/energy(noise));
%       
%       So that:
%       energy(signal)=energy(noise)*10.^(SNR(dB)/10);
%       energy(noise)=energy(signal)*10.^-(SNR(dB)/10);

%       Written by Bernat Escarra Vallmajor
%       Spring 2008
%       Fachhochschule Koeln
%
%       Gary Grutzek:
%       06/2010:  added filename for modded file support
%       06/2010:  added normalization only if neccessary
%
%%
function [y,n]=mod_noise(file,outFile,snr,type)

if nargin < 4
    type='w'; % If the color is not specified, white noise will be added.
end

[x,Fs]=wavread(file); % Reading the input file.
if Fs ~= 8000
    error('wrong Samplerate');
end


L=length(x); % Length of the input file.

% Creating the noise vector.
if type=='w'
    n=wavread('noises/whitenoise.wav');
    n=n(1:L);
elseif type=='p'
    n=wavread('noises/pinknoise.wav');
    n=n(1:L);
elseif type=='b'
    n=wavread('noises/brownnoise.wav');
    n=n(1:L);
end

Ex=sum(x.^2)/L; % Energy of the signal.

En=sum(n.^2)/L; % Energy of the created noise vector.

rEn=Ex*10.^-(snr/10); % Required energy of the noise.

b=rEn/En; % Relation betwen the original and the required energy.

a=sqrt(b); % Calculating the factor for which we have to modify the noise vector.

n=a*n; % Noise vector with the required energy.

y=x+n; % Adding the noise to the input file.

% y=mod_norm(y); % We ensure that there is no clipping, plus it has the maximum amplitude.

% norm if neccessary
if max(abs(y)) >= 1
    y = 0.99 * y/max(abs(y));
end

modname = [outFile(1:end-4) '_n' int2str(snr) type  '.wav']
wavwrite(y,Fs,modname) % Writing the output wav file.
end
