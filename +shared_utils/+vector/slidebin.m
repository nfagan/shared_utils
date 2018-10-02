function b = slidebin(a, win, step, discard_uneven)

%   SLIDEBIN -- Bin vector with sliding window.
%
%     B = ... slidebin( A, WIN, STEP ) bins the array `A` into a cell array
%     of N bins of mostly size `WIN`, stepped by `STEP`. The last bin of
%     `B` may be smaller than size `WIN`.
%
%     B = ... slidebin( ..., DISCARD_UNEVEN ) controls whether to discard
%     the last bin if it is not of size `WIN`. Default is false.
%
%     IN:
%       - `a` (/any/)
%       - `win` (double)
%       - `step` (double)
%     OUT:
%       - `b` (cell array)

if ( nargin < 4 ), discard_uneven = false; end

validateattributes( win, {'double'}, {'scalar'}, 2 );
validateattributes( step, {'double'}, {'scalar'}, 3 );

b = {};

if ( isempty(win) ), return; end

N = numel( a );
start = 1;
first = true;

while ( first || stop < N )
  stop = min( start + win - 1, numel(a) );
  
  ind = start:stop;
  
  if ( discard_uneven && numel(ind) ~= win )
    break;
  end
  
  b{end+1} = a(ind);
  
  start = start + step;
  
  first = false;
end

end