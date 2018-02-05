function tf = fexists( file_path )

%   FEXISTS -- True if a file exists.
%
%     IN:
%       - `file_path` (char)
%     OUT:
%       - `tf` (logical)

tf = exist( file_path, 'file' ) == 2;

end