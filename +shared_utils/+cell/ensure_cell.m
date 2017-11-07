function s = ensure_cell( s )

%   ENSURE_CELL -- Ensure an input is a cell array.
%
%     IN:
%       - `s` (/any/)
%     OUT:
%       - `s` (cell array)

if ( ~iscell(s) ), s = { s }; end
 
end