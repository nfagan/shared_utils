function [a, ind] = containing(a, b)

%   CONTAINING -- Retain elements of `a` containing substring `b`.
%
%     IN:
%       - `a` (cell array of strings)
%       - `b` (char)
%     OUT:
%       - `a` (cell array of strings)
%       - `ind` (logical) -- Index of elements of `a` that contain `b`.

ind = cellfun( @(x) shared_utils.char.contains(x, b), a );

a = a(ind);

end