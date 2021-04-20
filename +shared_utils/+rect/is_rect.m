function tf = is_rect(r)

%   IS_RECT -- True if input is a 4-element vector or Mx4 matrix.
%
%     See also shared_utils.rect.width

tf = ismatrix( r ) && ((isvector(r) && numel(r) == 4) || size(r, 2) == 4);

end