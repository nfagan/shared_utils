function axs = set_ylims(axs, to)

%   SET_YLIMS -- Set y limits for multiple axes.
%
%     ... set_ylims( axs, TO ) sets the y limits of each axis in `axs` to
%     `TO`.
%
%     See also shared_utils.plot.match_ylims
%
%     IN:
%       - `axs` (axes)
%       - `to` (double)
%     OUT:
%       - `axs` (axes)

axs = shared_utils.plot.set_lims( axs, 'ylim', to );

end