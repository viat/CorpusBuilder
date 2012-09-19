% concatenate some VMII sentences to 10s with pauses
%
%
%

dataPath = '/Users/gary/Documents/Matlab/SPIT_Korpus/VMII/waveData/';

targetPath = 'concatVMII'; 
if ~exist(targetPath,'dir')
    mkdir(targetPath);
end

[folders, foldernames] = getFolders(dataPath);

for j=1:length(folders)
    
    
    [files, names] = getFiles(folders{j},1);
    
    %
    spkA = names{1}(strfind(names{1}, '.') - 1); % get last character from first file
    spkB = names{length(names)}(strfind(names{length(names)}, '.') - 1);% get last character from last file
    
    % find sentences with regular expressions
    expression = ['^[a-zA-Z0-9_]+' spkA '\.wav'];
    [idxA , ~, ~, waves, ~] = regexp(names,expression);
    expression = ['^[a-zA-Z0-9_]+' spkB '\.wav'];
    [idxB , ~, ~, waves, ~] = regexp(names,expression);
    
    % speaker A
    fs = 8000;
    k=1;
    i=1;
    A = [];
    filename = [targetPath '/' foldernames{j} 'A'];
    while i < length(files)
        
        while length(A) < fs*10
            
            if i <= length(files)
                if ~isempty(idxA{i}) % is speaker A ?
                    tmp = wavread(files{i});
                    noise = 0.001*(rand(ceil((rand*3*fs)),1)-0.5);  % up to 3 seconds pause
                    A = [A; tmp; noise];
                    i = i+1;
                else
                    i=i+1;
                    break;
                end
            else
                break;
            end
        end
        if ~isempty(A)
            wavwrite(A, fs, [filename num2str(k)]);
            k = k+1;
            A = [];
        end
    end
    
    % speaker B
    k=1;
    i=1;
    B = [];
    filename = [targetPath '/' foldernames{j} 'B'];
    while i < length(files)
        
        while length(B) < fs*10
            if i <= length(files)
                if ~isempty(idxB{i}) % is speaker B ?
                    tmp = wavread(files{i});
                    noise = 0.001*(rand(ceil((rand*3*fs)),1)-0.5); % up to 3 seconds pause
                    B = [B; tmp; noise];
                    i = i+1;
                else
                    i=i+1;
                    break;
                end
            else
                break;
            end
        end
        if ~isempty(B)
            wavwrite(B, fs, [filename num2str(k)]);
            k = k+1;
            B = [];
        end
    end
    
    
end

