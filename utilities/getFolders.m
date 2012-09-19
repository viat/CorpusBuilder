function [fc, names] = getFolders(filePath)
% [folders, names] = getFiles(filePath)
%
% Read list of files from path 
% - ignore directories and .DS-Store and other hidden files
% - return cell Array with full path foldernames ('/Users/.../.../bla')
%   and cell Array with all foldernames ('bla')
% 
% FH Köln, Institut für Nachrichtentechnik, 05/2010
% (c) Gary Grutzek
%--------------------------------------------------------------------------



folders = dir(filePath);

j = 1;
for i=1:length(folders)
    if (folders(i).isdir == 0)
        cut(j) = i; % cut directories
        j = j+1;
    elseif strcmp(folders(i).name(1), '.')
        cut(j) = i; % cut '.DSStore' and other hidden files
        j = j+1;
     else
         names{i} = folders(i).name;   % the filenames
         folders(i).name = [filePath folders(i).name]; % append thhe full path
    end
end
if exist('cut','var')
    folders(cut) = []; 
end
if exist('names','var')
    names(cellfun(@isempty,names)) = []; % strip empty cELL
    fc = struct2cell(folders);
    fc = fc(1,:); % only keep filenames
else
    disp('No folders found!');
    fc = [];
    names = [];
end