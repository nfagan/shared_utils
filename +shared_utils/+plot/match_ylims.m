function new_lims = match_ylims(axs)

if ( numel(axs) == 1 )
  new_lims = get( axs, 'ylim' );
  return;
end

lims = cell2mat( get(axs(:), 'ylim') );

mins = min( lims(:, 1) );
maxs = max( lims(:, 2) );

new_lims = [mins, maxs];

arrayfun( @(x) ylim(x, new_lims), axs );

end