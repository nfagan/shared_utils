function [x, y, success] = extract_xy(x)

[m, n] = size( x );
y = nan;
success = true;

if ( m == 2 && n ~= 2 )
  tmp = x;
  x = reshape( x(1, :), [], 1 );
  y = reshape( tmp(2, :), [], 1 );

elseif ( n == 2 )
  tmp = x;
  x = x(:, 1);
  y = tmp(:, 2);

elseif ( numel(x) == 2 )
  tmp = x;
  x = x(1);
  y = tmp(2);

else
  success = false;
end

end