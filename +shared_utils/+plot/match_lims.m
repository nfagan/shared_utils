function new_lims = match_lims(axs, kind, set_func)

if ( numel(axs) == 1 )
  new_lims = get( axs, kind );
  return;
end

lims = cell2mat( get(axs(:), kind) );

mins = min( lims(:, 1) );
maxs = max( lims(:, 2) );

new_lims = [mins, maxs];

arrayfun( @(x) set_func(x, new_lims), axs );

end