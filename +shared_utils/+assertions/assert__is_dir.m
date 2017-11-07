function assert__is_dir(pathstr, folder_type)

%   ASSERT__IS_DIR -- Ensure a folder exists.
%
%     IN:
%       - `pathstr` (char) -- Full path to the folder.
%       - `folder_type` (char) |OPTIONAL| -- Optionally add a more
%         descriptive folder name (.e.g., '.mat files') in case the
%         assertion fails.

if ( nargin < 2 ), folder_type = '(unspecified)'; end

shared_utils.assertions.assert__isa( pathstr, 'char', 'the path to the folder' );
shared_utils.assertions.assert__isa( folder_type, 'char', 'the type of folder' );

assert( exist(pathstr, 'dir') == 7, 'Folder of type ''%s'', ''%s'', does not exist.' ...
  , folder_type, pathstr );

end