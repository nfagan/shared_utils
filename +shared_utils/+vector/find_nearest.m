function index = find_nearest(a, x)

%   FIND_NEAREST -- Find index of element closest to array of elements.
%
%     IN:
%       - `a` (double)
%       - `x` (double)
%     OUT:
%       - `index` (double)

[~, index] = histc( x, a );

if ( index == 0 || index > length(a) )
  fprintf( '\n inexact' );
  [~, index] = min( abs(a - x) );
  return;
end

check = abs( x - a(index) ) < abs( x - a(index+1) );

if ( ~check )
  index = index + 1;
end

end