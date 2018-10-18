function I = nearest_after(x, y)

%   NEAREST_AFTER -- Find indices of values in X closest to but greater 
%     than values in Y.
%
%     I = ... nearest_after( X, Y ) returns an array `I` the same size as 
%     `Y`; each element (i) of `I` is the index into `X` giving the value 
%     closest to the i-th element of `Y`, with the restriction that
%     `X(I(i))` is >= `Y(i)`.
%
%     IN:
%       - `x` (double)
%       - `y` (double)
%     OUT:
%       - `I` (double)

s = size( y );
n = prod( s );

I = zeros( s );

for i = 1:n
  offset = y(i) - x;
  gt_0 = find( offset >= 0 );
  
  if ( isempty(gt_0) ), continue; end
  
  [~, ind] = min( offset(gt_0) );
  I(i) = gt_0(ind);
end

end