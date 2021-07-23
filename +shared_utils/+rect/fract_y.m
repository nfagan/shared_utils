function v = fract_y(r, y)

%   FRACT_X -- Express component as fraction of rect x-span.
%
%     v = shared_utils.rect.fract_x( r, y ); for the 4-element vector `r` 
%     and array `y` returns an array the same size as `y` expressing each
%     `y` as a fraction in [0, 1] of the y-span of `r`.
%
%     v = shared_utils.rect.fract_y( r, y ); for the Mx4 matrix operates
%     element-wise for rows of `r` and elements of `y`.
%
%     See also shared_utils.rect.center, shared_utils.rect.fract_x

if ( numel(r) == 4 )
  v = (y - r(2)) ./ (r(4) - r(2));
else
  v = (y - r(:, 2)) ./ (r(:, 4) - r(:, 2));
end

end