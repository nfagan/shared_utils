function files = findmat(P, varargin)

%   FINDMAT -- Find .mat files.
%
%     files = shared_utils.io.findmat( P ); is the same as
%     files = shared_utils.io.find( P, '.mat' );
%
%     files = shared_utils.io.findmat( ..., true ) recursively searches
%     subfolders of `P`.
%
%     See also shared_utils.io.find
%
%     IN:
%       - `P` (char, cell array of strings)
%       - `is_recursive` (logical) |SCALAR|
%     OUT:
%       - `files` (cell array of strings)

files = shared_utils.io.find( P, '.mat', varargin{:} );

end