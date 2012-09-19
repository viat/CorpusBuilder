function [fc, names] = getFiles(filePath, FULLPATH)
% [files, names] = getFiles(filePath, fullPath)
%
% Read list of files from path
% - relative to first (!) MATLAB search path or full path if FULLPATH == 1 (optional)
% - ignore directories and .DS-Store and other hidden files
% - return cell Array with full path filenames ('/Users/.../.../bla.txt')
%   and cell Array with all filenames ('bla.txt')
%
% FH Köln, Institut für Nachrichtentechnik, 05/2010
% (c) Gary Grutzek
%--------------------------------------------------------------------------

if nargin == 1
    p = path;
    p = p(1:(find(p==':',1,'first')-1)); % find p==';' on Windows OS !!
    if strcmp(filePath(end),'/');
        p = [p filePath];
    else
        p = [p filePath '/'];
    end
    
elseif FULLPATH == 1
    p = filePath;
    if ~strcmp(filePath(end),'/');
        p = [p '/'];
    end
end

files = dir(p);

j = 1;
for i=1:length(files)
    if files(i).isdir
        cut(j) = i; % cut directories
        j = j+1;
    elseif strcmp(files(i).name(1), '.')
        cut(j) = i; % cut '.DSStore' and other hidden files
        j = j+1;
    else
        names{i} = files(i).name;   % the filenames
        files(i).name = [p files(i).name]; % append the full path
    end
end

if exist('cut','var')
    files(cut) = [];
end
if exist('names','var')
    names(cellfun(@isempty,names)) = []; % strip empty elements
    fc = struct2cell(files);
    fc = fc(1,:); % only keep filenames
else
    disp('No files found!');
    fc = [];
    names = [];
end


