function hs = add_horizontal_lines(axs, ys, linespec)

%   ADD_HORIZONTAL_LINES -- Overlay horizontal lines on axes.
%
%     ... add_horizontal_lines( axs, y, 'k--' ) plots horizontal lines in 
%     each `axs`, centered on `y` coordinate(s), as black dotted lines.
%
%     IN:
%       - `axs` (axes)
%       - `ys` (double)
%       - `linespec` (char)

if ( nargin < 3 || isempty(linespec) )
  linespec = 'k--';
end

inds = combvec( 1:numel(axs), 1:numel(ys) );

ncombs = size( inds, 2 );

hs = gobjects( 1, ncombs );

for i = 1:ncombs
  ax = axs(inds(1, i));
  y = ys(inds(2, i));
  
  hs(i) = plot( ax, get(ax, 'xlim'), [y; y], linespec );
end

end