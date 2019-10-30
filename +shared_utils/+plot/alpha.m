function axs = alpha(axs, value)

%   ALPHA -- Set global alpha for axes.
%
%     shared_utils.plot.alpha( axs, value ); sets the alpha value in each
%     axis in the array of axes handles `axs` to `value`.
%
%     See also shared_utils.plot.set_xlims

arrayfun( @(x) alpha(x, value), axs );

end