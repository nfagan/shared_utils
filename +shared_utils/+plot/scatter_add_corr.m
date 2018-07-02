function [hs, store_stats] = scatter_add_corr(ids, X, Y, alpha)

%   SCATTER_ADD_CORR -- 

if ( nargin < 4 ), alpha = 0.05; end

update_prop = 'defaultLegendAutoUpdate';
s = get( gcf, update_prop );
set( gcf, update_prop, 'off' );

hs = gobjects( size(ids) );
store_stats = zeros( numel(ids), 2 );

for i = 1:numel(ids)
  ax = ids(i).axes;
  ind = ids(i).index;
  
  x = X(ind);
  y = Y(ind);
  
  [r, p] = corr( x, y, 'rows', 'complete' );
  
  xlims = get( ax, 'xlim' );
  ylims = get( ax, 'ylim' );
  xticks = get( ax, 'xtick' );
  
  ps = polyfit( x, y, 1 );
  y = polyval( ps, xticks );
  
  set( ax, 'nextplot', 'add' );
  h = plot( ax, xticks, y );
  
  h.Annotation.LegendInformation.IconDisplayStyle = 'off';
  hs(i) = h;  
  
  coord_func = @(x) ((x(2)-x(1)) * 0.75) + x(1);
  
  xc = coord_func( xlims );
  yc = coord_func( ylims );
  
  txt = sprintf( 'R = %0.2f, p = %0.3f', r, p);
  
  if ( p < alpha ), txt = sprintf( '%s *', txt ); end
  
  text( ax, xc, yc, txt );
  
  store_stats(i, :) = [ r, p ];
end

set( gcf, update_prop, s );


end