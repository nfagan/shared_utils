function files = filter_files(files, containing, not_containing)

%   FILTER_FILES -- Filter cell array of filenames.
%
%     f = ... filter_files( files, containing ); returns the subset of
%     `files` that contain any of the sub-strings in `containing`.
%
%     f = ... filter_files( ..., not_containing ); further retains the
%     subset of `files` that contain none of the sub-strings in
%     `not_containing`.
%
%     See also shared_utils.io.find, shared_utils.cell.contains

if ( nargin < 2 ), containing = {}; end
if ( nargin < 3 ), not_containing = {}; end

if ( ~isempty(containing) )
  files = shared_utils.cell.containing( files, containing );
end

if ( ~isempty(not_containing) )
  files(shared_utils.cell.contains(files, not_containing)) = [];
end

end