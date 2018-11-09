function out = find(path, ext, rec)

%   FIND -- Find files with a given extension.
%
%     files = find( cd, '.txt' ); returns a cell array of absolute paths to
%     .txt files in the current directory.
%
%     files = find( cd, '.txt', true ); recursively searches subfolders of
%     the current directory, returning all matching files.
%
%     directories = find( cd, 'folders' ... ); absolute directory paths.
%
%     files = find( DIRS, ... ) where DIRS is a cell array of strings,
%     works as above, for each directory in `DIRS`, concatenating the
%     results into a single array `files`.
%
%     IN:
%       - `path` (char)
%       - `ext` (char)
%       - `rec` (logical) |OPTIONAL| -- Recursive search. Default is false.

if ( nargin < 3 ), rec = false; end

import shared_utils.assertions.*;

path = shared_utils.cell.ensure_cell( path );
ext = shared_utils.cell.ensure_cell( ext );

assert__is_cellstr_or_char( path, 'path' );
assert__is_cellstr_or_char( ext, 'extension' );
assert__isa( rec, 'logical' );

out = {};

for i = 1:numel(path)
  for j = 1:numel(ext)
    out = [ out, find_one(path{i}, ext{j}, rec) ];
  end
end

end

function out = find_one(path, ext, rec)

import shared_utils.io.dirnames;
import shared_utils.assertions.*;

assert__is_dir( path );

if ( ~rec )
  out = dirnames( path, ext, true );
  return;
end

out = find_impl( path, ext, {} );
end

function out = find_impl(path, ext, out)

import shared_utils.io.dirnames;

out = [ out, dirnames(path, ext, true) ];
folders = dirnames( path, 'folders', true );

if ( isempty(folders) ), return; end

for i = 1:numel(folders)
  out = find_impl( folders{i}, ext, out );
end

end