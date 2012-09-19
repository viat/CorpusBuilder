% convert NIST Files
%
% - call c tool for a-law to linear conversion
%
%
folder = uigetdir('/Users/gary/Desktop');
if (folder ~= 0)
    [folders , folderNames] = getFolders([folder '/']);
    
    for k=1:length(folders)
        
        [files, names] = getFiles([folders{k} '/'], 1);
        
        if ~isempty(files)
            for i=1:length(files)
                %  [files{i} '/'];
                %fid = fopen('/NistConv/g003atw2_004_AAK.nis','r');
                %             tmp = fgetl(fid);
                %             len = str2num(fgetl(fid));
                %             frewind(fid);
                %             tmp = fread(fid,1024);
                %             data = fread(fid,inf,'uint8');
                %             fclose(fid);
                %
                %             fid = fopen('test.raw','w');
                %             fwrite(fid,data);
                %             fclose(fid);
                
                targetPath = ['/Users/gary/Desktop/VMII/waveData/' folderNames{k} '/'];
                targetName = [targetPath names{i}(1:end-4) '.wav'];
                
                
                if ~exist(targetPath,'dir')
                    mkdir(targetPath);
                end
                system(['./NISTConv ' files{i} ' ' targetName]);
            end
        else
            disp('empty folder!');
            folders{k}
        end
    end
end