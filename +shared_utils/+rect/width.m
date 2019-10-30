function w = width(rect)

%   WIDTH -- Get width of rect.
%
%     See also shared_utils.rect.height

if ( isvector(rect) )
  w = rect(3) - rect(1);
else
  w = rect(:, 3) - rect(:, 1);
end

end