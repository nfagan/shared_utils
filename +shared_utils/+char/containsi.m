function tf = containsi(a, b)

%   CONTAINS -- True if string `a` contains substring `b`, ignoring case.
%
%     IN:
%       - `a` (char)
%       - `b` (char)
%     OUT:
%       - `tf` (logical)

tf = ~isempty( strfind(lower(a), lower(b)) );

end