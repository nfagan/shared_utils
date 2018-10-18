function I = nearest_before(x, y)

%   NEAREST_BEFORE -- Find indices of values in X closest to but less than 
%     values in Y.
%
%     I = ... nearest_before( X, Y ) returns an array `I` the same size as 
%     `Y`; each element (i) of `I` is the index into `X` giving the value 
%     closest to the i-th element of `Y`, with the restriction that
%     `X(I(i))` is <= `Y(i)`.
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
  lt_0 = find( offset <= 0 );
  
  if ( isempty(lt_0) ), continue; end
  
  [~, ind] = max( offset(lt_0) );
  I(i) = lt_0(ind);
end

end