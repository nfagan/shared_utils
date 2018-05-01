function out = binned_any(vec, n)

assert( isa(vec, 'logical'), 'Input must be numeric or logical.' );
assert( ismatrix(vec), 'Input must be 2-dimensional.' );

if ( ~isvector(vec) )
  for j = 1:size(vec, 1)
    a = shared_utils.logical.binned_any( vec(j, :), n );
    if ( j == 1 )
      out = false( size(vec, 1), numel(a) );
    end
    out(j, :) = a;
  end
  return;
end

N = numel( vec );

m = ceil( N/n );

out = false( 1, ceil(N/n) );

stp = 1;

for i = 1:m
  if ( i < m )
    stop = stp + n - 1;
  else
    stop = numel( vec );
  end
  
  out(i) = any( vec(stp:stop) );
  stp = stp + n;
end

end