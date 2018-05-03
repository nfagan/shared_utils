function rect(rect, ax)

assert( numel(rect) == 4, 'Specify a rect as a 4-element vector.' );

w = rect(3) - rect(1);
h = rect(4) - rect(2);

x = rect(1);
y = rect(2);

if ( nargin < 2 )
  rectangle( 'position', [x, y, w, h] );
else
  rectangle( 'position', [x, y, w, h], 'parent', ax );
end

end