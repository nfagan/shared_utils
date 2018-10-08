function I = nearest(x, y)

%   NEAREST -- Find indices of closest values.
%
%     I = ... nearest( X, Y ) returns an array `I` the same size as `Y`;
%     each element (i) of `I` is the index into `X` giving the value 
%     closest to the i-th element of `Y`.
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
  [~, ind] = min( abs(x - y(i)) );
  I(i) = ind;
end

end