function new_lims = match_xlims(axs)

if ( numel(axs) == 1 )
  new_lims = get( axs, 'xlim' );
  return;
end

lims = cell2mat( get(axs(:), 'xlim') );

mins = min( lims(:, 1) );
maxs = max( lims(:, 2) );

new_lims = [mins, maxs];

arrayfun( @(x) xlim(x, new_lims), axs );

end