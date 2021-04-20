function r = expand(r, x, y)

%   EXPAND -- Expand rect.
%
%     r = shared_utils.rect.expand( r, x, y ); adds +/- `x` and `y` to `r`.
%
%     `r` can be a 4-element vector or Mx4 matrix 
%
%     See also shared_utils.rect.inside, shared_utils.rect.is_rect

shared_utils.assertions.assert__is_rect( r );

if ( nargin == 2 )
  [x, y, success] = shared_utils.rect.extract_xy( x );
  if ( ~success )
    narginchk( 3, 3 );
  end
end

if ( isvector(r) && isscalar(x) )
  r(1) = r(1) - x;
  r(3) = r(3) + x;
  r(2) = r(2) - y;
  r(4) = r(4) + y;    
  
elseif ( isvector(r) )
  tmp = r;
  r = zeros( numel(x), 4 );
  
  r(:, 1) = tmp(1) - x;
  r(:, 3) = tmp(3) + x;
  r(:, 2) = tmp(2) - y;
  r(:, 4) = tmp(4) + y;
  
else
  r(:, 1) = r(:, 1) - x;
  r(:, 3) = r(:, 3) + x;
  r(:, 2) = r(:, 2) - y;
  r(:, 4) = r(:, 4) + y;
end

end