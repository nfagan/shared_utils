function h = height(rect)

%   HEIGHT -- Get height of rect.
%
%     See also shared_utils.rect.width

if ( isvector(rect) )
  h = rect(4) - rect(2);
else
  h = rect(:, 4) - rect(:, 2);
end

end