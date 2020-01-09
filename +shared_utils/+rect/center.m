function c = center(r)

%   CENTER -- Center of rect.
%
%     c = shared_utils.rect.center( rect ); returns a 2-element vector
%     giving the (x, y) center of `rect`.
%
%     cs = shared_utils.rect.center( rects ); for the Mx4 matrix of `rects`
%     returns an Mx2 matrix of centers.
%
%     See also shared_utils.rect.width, shared_utils.rect.height

if ( isvector(r) )
  c = [ mean(r([1, 3])), mean(r([2, 4])) ];
else
  c = [ mean(r(:, [1, 3]), 2), mean(r(:, [2, 4]), 2) ];
end

end