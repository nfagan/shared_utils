function new_lims = match_xlims(axs)

lims = cell2mat( get(axs(:), 'xlim') );

mins = min( lims(:, 1) );
maxs = max( lims(:, 2) );

new_lims = [mins, maxs];

arrayfun( @(x) xlim(x, new_lims), axs );

end