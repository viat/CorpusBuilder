%
% apply telephone-like bandpass
%
[files, names] = getFiles('/SPIT_Korpus/Kielkorpus/Marburg_concat/'); % Training

path = 'BP';

if ~exist('BP','dir')
    mkdir('BP');
end

for i=1:length(files)
    tmp = wavread(files{i});
    a = conv(tmp,Num); % Num => FIRCoeff.mat
    wavwrite(a,8000,[path '/' names{i}(1:end-4) 'BP.wav']);
end

