function y = distribute(x, n)

%   DISTRIBUTE -- Distribute values over bins.
%
%     Y = ... distribute( X, N ); returns a cell array `Y` containing the
%     values of `X` maximally evenly distributed over `N` bins.
%
%     IN:
%       - `x` (/any/)
%       - `n` (double)
%     OUT:
%       - `y` (cell)

validateattributes( n, {'double'}, {'scalar'}, 'distribute', 'n' );

[~, e] = histcounts( x(:), n );
inds = discretize( x, e );

y = cell( 1, n );
ns = unique( inds );

for i = 1:numel(ns)
  assign_to = ns(i);
  ind = inds == assign_to;
  y{assign_to} = x(ind);  
end

end