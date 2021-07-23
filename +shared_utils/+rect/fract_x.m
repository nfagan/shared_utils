function v = fract_x(r, x)

%   FRACT_X -- Express component as fraction of rect x-span.
%
%     v = shared_utils.rect.fract_x( r, x ); for the 4-element vector `r` 
%     and array `x` returns an array the same size as `x` expressing each
%     `x` as a fraction in [0, 1] of the x-span of `r`.
%
%     v = shared_utils.rect.fract_y( r, x ); for the Mx4 matrix operates
%     element-wise for rows of `r` and elements of `x`.
%
%     See also shared_utils.rect.center, shared_utils.rect.fract_y

if ( numel(r) == 4 )
  v = (x - r(1)) ./ (r(3) - r(1));
else
  v = (x - r(:, 1)) ./ (r(:, 3) - r(:, 1));
end

end