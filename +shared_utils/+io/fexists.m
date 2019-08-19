function tf = fexists( file_path )

%   FEXISTS -- True if a file exists.
%
%     tf = shared_utils.io.fexists( path ); returns true if the file given
%     by the char vector `path` exists.
%
%     tf = shared_utils.io.fexists( paths ); for the cell array of strings
%     `paths` returns true for elements of `paths` that are existing
%     files.
%
%     See also shared_utils.io.dexists, exist

if ( ischar(file_path) )
  tf = exist( file_path, 'file' ) == 2;
else
  tf = cellfun( @(x) exist(file_path, 'file') == 2, file_path );
end

end