function out = bin(a, sz, discard)

%   BIN -- Partition a vector into a cell array of smaller vectors.
%
%     IN:
%       - `a` (numeric)
%       - `sz` (double) |SCALAR|
%       - `discard` (logical) |SCALAR| -- If true, will discard the final
%         bin of data if it has fewer elements than `sz`. Default is false,
%         in which case the final bin of data may have fewer elements than
%         `sz`.
%     OUT:
%       - `out` (cell array)

import shared_utils.assertions.*;

if ( nargin < 3 )
  discard = false;
else
  assert__isa( discard, 'logical' );
  assert__is_scalar( discard );
end

assert__is_vector( a );
assert__is_scalar( sz );

N = ceil( numel(a) / sz );

stp = 1;

out = cell( 1, N );

for i = 1:N
  if ( i < N )
    stop = stp + sz - 1;
  else
    stop = numel(a);
  end
  out{i} = a(stp:stop);
  stp = stp + sz;
end

if ( discard && numel(out{end} < sz) )
  out(end) = [];
end

end