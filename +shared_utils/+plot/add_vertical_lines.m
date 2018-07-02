function hs = add_vertical_lines(axs, xs, linespec)

%   ADD_VERTICAL_LINES -- Overlay vertical lines on axes.
%
%     ... add_vertical_lines( axs, x, 'k--' ) plots vertical lines in each
%     `axs`, centered on `x` coordinate(s), as black dotted lines.
%
%     IN:
%       - `axs` (axes)
%       - `xs` (double)
%       - `linespec` (char)

if ( nargin < 3 || isempty(linespec) )
  linespec = 'k--';
end

inds = combvec( 1:numel(axs), 1:numel(xs) );

ncombs = size( inds, 2 );

hs = gobjects( 1, ncombs );

for i = 1:ncombs
  ax = axs(inds(1, i));
  x = xs(inds(2, i));
  
  hs(i) = plot( ax, [x; x], get(ax, 'ylim'), linespec );
end

end