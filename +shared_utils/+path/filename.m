function f = filename(p)

%   FILENAME -- Get the filename component of a path
%
%     IN:
%       - `p` (char)
%     OUT:
%       - `f` (char)

[~, f] = fileparts( p );

end