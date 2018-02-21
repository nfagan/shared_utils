function shape = get_subplot_shape( N )

%   GET_SUPLOT_SHAPE -- Return an (M x N) pair of subplot dimensions from
%     the given linear size `N`.
%
%     IN:
%       - `N` (double)
%     OUT:
%       - `shape` (double)

import shared_utils.assertions.*;

assert__isa( N, 'double' );
assert__is_scalar( N );

if ( N <= 3 )
  shape = [ 1, N ];
  return;
end

n_rows = round( sqrt(N) );
n_cols = ceil( N/n_rows );
shape = [ n_rows, n_cols ];

end