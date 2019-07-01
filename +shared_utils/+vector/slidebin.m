function b = slidebin(a, win, step, discard_uneven)

%   SLIDEBIN -- Bin vector with sliding window.
%
%     B = ... slidebin( A, WIN, STEP ) bins the array `A` into a cell array
%     of N bins of mostly size `WIN`, stepped by `STEP`. The last bin of
%     `B` may be smaller than size `WIN`.
%
%     B = ... slidebin( A, W ) uses `W` for both window and step sizes.
%
%     B = ... slidebin( ..., DISCARD_UNEVEN ) controls whether to discard
%     the last bin if it is not of size `WIN`. Default is false.

if ( nargin < 4 ), discard_uneven = false; end
if ( nargin < 3 ), step = win; end

validateattributes( win, {'double'}, {'scalar'}, 2 );
validateattributes( step, {'double'}, {'scalar'}, 3 );

if ( isempty(win) ), b = {}; return; end

N = numel( a );
start = 1;
first = true;

b = cell( 1, floor(N / step) );
assign_stp = 1;

while ( first || stop <= N )
  stop = min( start + win - 1, N );
  
  ind = start:stop;
  
  if ( isempty(ind) || (discard_uneven && numel(ind) ~= win) )
    break;
  end
  
  b{assign_stp} = a(ind);
  
  start = start + step;
  assign_stp = assign_stp + 1;
  
  first = false;
end

b(assign_stp:end) = [];

end