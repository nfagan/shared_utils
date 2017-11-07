function names = dirnames(pathstr, kind, append_path)

%   DIRNAMES -- Get file or folder names in the given path.
%
%     names = ... dirnames( '~/Documents', '.mat' ) returns a cell array of
%     filenames that end with '.mat'
%
%     names = ... dirnames( '~/Documents', 'folders' ) returns directory
%     names, excluding '.' and '..'.
%
%     names = ... dirnames( ..., true ) appends `pathstr` to each of the
%     found files in `names`, such that each element of `names` is a
%     complete file-path.
%
%     See also shared_utils.io.dirstruct
%
%     IN:
%       - `pathstr` (char) -- Path to the directory to query.
%       - `kind` (char) -- Type of file to look for, or 'folders'.
%     OUT:
%       - `names` (cell array of strings)

if ( nargin < 3 ), append_path = false; end

names = shared_utils.io.dirstruct( pathstr, kind );
names = { names(:).name };

if ( append_path )
  names = cellfun( @(x) fullfile(pathstr, x), names, 'un', false );
end

end

