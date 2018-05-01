function new_lims = match_ylims(axs)

lims = cell2mat( get(axs(:), 'ylim') );

mins = min( lims(:, 1) );
maxs = max( lims(:, 2) );

new_lims = [mins, maxs];

arrayfun( @(x) ylim(x, new_lims), axs );

end