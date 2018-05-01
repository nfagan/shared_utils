function [out, out_t] = slide_window(vec, t, window_size, step_size)

%   SLIDE_WINDOW -- Bin vector via any() operation.
%
%     IN:
%       - `vec` (logical)
%       - `t` (double) |OPTIONAL|
%       - `window_size` (double)
%       - `step_size` (double)
%     OUT:
%       - `out` (logical)
%       - `out_t` (double)

total = floor( numel(vec) / step_size );

N = numel( vec );

out = false( 1, total );

use_t = ~isempty( t );

if ( use_t )
  out_t = zeros( 1, total );
end

half_window = floor( window_size/2 );
start = 1;
stp = 1;
stop = min( N, start+window_size );

while ( stop <= N )
  out(stp) = any( vec(start:stop-1) );
  
  if ( use_t )
    out_t(stp) = t(start+half_window);
  end
  
  stp = stp + 1;
  start = start + step_size;
  stop = start + window_size;
end

end