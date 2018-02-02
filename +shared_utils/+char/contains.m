function tf = contains(a, b)

%   CONTAINS -- True if string `a` contains substring `b`.
%
%     IN:
%       - `a` (char)
%       - `b` (char)
%     OUT:
%       - `tf` (logical)

tf = ~isempty( strfind(a, b) );

end