function wavCut = netGen(name, percent, outFile)
%
%   net gen.m
%   packetloss simulator:
%   drops frames of 20ms randomly by filling with zeros
%
%   FH Köln, Institut für Nachrichtentechnik, 06/2010
%   (c) Gary Grutzek
%--

[wav, fs] = wavread(name);

packetSize = 0.02 * fs; % 20ms

% percentage
a = rand(1,floor(length(wav)/packetSize)) - (1 - (percent/100));%0.90; % 5% packetloss
a(a < 0) = 0;
a(a > 0) = 1;

% s = sum(a(a == 1));
%sum(a)/length(a) * 100

ups = zeros(size(wav));
j = 1;
for i=1:length(wav)
    ups(i) = a(j);
    if mod(i,packetSize) == 0 && j < length(a)
        j = j + 1;
    end
end
% loss = sum(ups)/length(wav)*100
ups = ~ups;
wavCut = wav .* ups;

% figure(1)
% subplot(211)
% plot(wav)
% hold on
% plot(wavCut,'r')
if nargin < 3
    wavwrite(wavCut,[name(1:end-4) '_loss.wav']);
else
    modname = [outFile(1:end-4) '_loss' int2str(percent) '.wav']
    wavwrite(wavCut,modname);
end

