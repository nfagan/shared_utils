function rect(rect)

assert( numel(rect) == 4, 'Specify a rect as a 4-element vector.' );

w = rect(3) - rect(1);
h = rect(4) - rect(2);

x = rect(1);
y = rect(2);

rectangle( 'position', [x, y, w, h] );

end