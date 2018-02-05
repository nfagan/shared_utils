function ind = contains(a, b)

%   CONTAINS -- Element-wise test of whether cell array of strings `a` 
%     contains the sub-string `b` or any of the cell array of sub-strings
%     `b`.
%
%     IN:
%       - `a` (cell array of strings)
%       - `b` (cell array of strings, char)
%     OUT:
%       - `ind` (logical)

if ( ischar(b) )
  ind = cellfun( @(x) shared_utils.char.contains(x, b), a );
  return;
end

ind = cellfun( @(x) any(cellfun(@(y) shared_utils.char.contains(x, y), b)), a );

end