function new_lims = match_clims(axs)

if ( numel(axs) == 1 )
  new_lims = get( axs, 'clim' );
  return;
end

lims = cell2mat( get(axs(:), 'clim') );

mins = min( lims(:, 1) );
maxs = max( lims(:, 2) );

new_lims = [mins, maxs];

arrayfun( @(x) set(x, 'clim', new_lims), axs );

end