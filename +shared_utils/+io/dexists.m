function tf = dexists( file_path )

%   DEXISTS -- True if a directory exists.
%
%     IN:
%       - `dir_path` (char)
%     OUT:
%       - `tf` (logical)

tf = exist( file_path, 'dir' ) == 7;

end