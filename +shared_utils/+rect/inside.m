function tf = inside(r, x, y)

%   INSIDE -- True for (x, y) coordinates inside a rect.
%
%     tf = shared_utils.rect.inside( r, x, y ); for the rect `r` and arrays
%     `x` and `y` returns true if coordinates (`x`, `y`) are inside of `r`.
%     
%     `r` and `x` and `y` must have compatible sizes. If `r` is a 4-element
%     vector, `x` and `y` can be of any size. If `x` and `y` are scalar,
%     then `r` can be a 4-element vector or an Mx4 matrix with any number
%     of rows. Otherwise, the number of rows of `r` must match the number
%     of elements of `x` and `y`.
%
%     The lower-bound of `r` is inclusive, whereas the upper-bound is 
%     exclusive.
%
%     See also shared_utils.rect.width, shared_utils.rect.is_rect

if ( nargin == 2 )
  [x, y, success] = shared_utils.rect.extract_xy( x );
  if ( ~success )
    narginchk( 3, 3 );
  end
end

if ( isvector(r) )
  tf = x >= r(1) & x < r(3) & y >= r(2) & y < r(3);
  
elseif ( ~shared_utils.rect.is_rect(r) )
  error( 'Rect must be a 4-element vector or matrix with 4 columns.' );
  
else
  tf = x >= r(:, 1) & x < r(:, 3) & y >= r(:, 2) & y < r(:, 3);
end

end