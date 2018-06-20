function axs = tseries_xticks(axs, t, spc)

%   TSERIES_XTICKS -- Add time series labels to x-axis or x-axes.
%
%     ... tseries_xticks( axs, t ); labels the xticks in each axes in `axs`
%     with every third time point in `t`, including the last time point,
%     and 0, if it exists in `t`.
%
%     IN:
%       - `axs` (axes)
%       - `t` (double)
%       - `spc` (double)

if ( nargin < 3 ), spc = 3; end

ticklabs = get_tick_labs( t, spc );

for i = 1:numel(axs)
  ax = axs(i);
  xlims = get( ax, 'xlim' );
  xdiff = xlims(2) - xlims(1);
  
  assert( xdiff == numel(t), 'Time series do not correspond to plotted data.' );
  
  set( ax, 'xtick', 1:xdiff );  
  set( ax, 'xticklabels', ticklabs );
end

end

function labs = get_tick_labs(t, spc)

timelabs = arrayfun( @num2str, t, 'un', 0 );

zero_ind = t == 0;

labs = repmat( {''}, 1, numel(t) );
labs(1:spc:end) = timelabs(1:spc:end);
labs(zero_ind) = timelabs(zero_ind);
labs(end) = timelabs(end);
end