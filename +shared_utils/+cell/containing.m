function [a, ind] = containing(a, b)

%   CONTAINING -- Retain elements of `a` containing substring or any of the
%     array of sub-strings `b`.
%
%     a = ... containing( {'aa', 'cc', 'bb'}, 'c' ) returns {'cc'}
%
%     a = ... containing( {'aa', 'cc', 'bb'}, {'b', 'c'} } 
%     returns {'cc', 'bb'};
%
%     IN:
%       - `a` (cell array of strings)
%       - `b` (cell array of strings, char)
%     OUT:
%       - `a` (cell array of strings)
%       - `ind` (logical) -- Index of elements of `a` that contain `b`.

ind = shared_utils.cell.contains( a, b );
a = a(ind);

end