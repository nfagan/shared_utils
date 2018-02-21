function out = find_nearest(a, x)

%   FIND_NEAREST -- Find index of element closest to array of elements.
%
%     IN:
%       - `a` (double)
%       - `x` (double)
%     OUT:
%       - `out` (double)

[~, out] = min( abs(a - x) );

end