function tf = dexists( file_path )

%   DEXISTS -- True if a directory exists.
%
%     tf = shared_utils.io.dexists( path ); returns true if the folder given
%     by the char vector `path` exists.
%
%     tf = shared_utils.io.dexists( paths ); for the cell array of strings
%     `paths` returns true for elements of `paths` that are existing
%     directories.
%
%     See also shared_utils.io.fexists, exist

if ( ischar(file_path) )
  tf = exist( file_path, 'dir' ) == 7;
else
  tf = cellfun( @(x) exist(x, 'dir') == 7, file_path );
end

end