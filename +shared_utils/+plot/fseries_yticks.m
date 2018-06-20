function axs = fseries_yticks(axs, f, spc)

if ( nargin < 3 ), spc = 3; end

ticklabs = get_tick_labs( f, spc );

for i = 1:numel(axs)
  ax = axs(i);
  ylims = get( ax, 'ylim' );
  ydiff = ylims(2) - ylims(1);
  
  assert( ydiff == numel(f), 'Frequencies do not correspond to plotted data.' );
  
  set( ax, 'ytick', 1:ydiff );  
  set( ax, 'yticklabels', ticklabs );
end

end

function labs = get_tick_labs(f, spc)

timelabs = arrayfun( @num2str, f, 'un', 0 );
labs = repmat( {''}, 1, numel(f) );
labs(1:spc:end) = timelabs(1:spc:end);
labs(end) = timelabs(end);
end