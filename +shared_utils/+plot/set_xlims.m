function axs = set_xlims(axs, to)

%   SET_XLIMS -- Set x limits for multiple axes.
%
%     ... set_xlims( axs, TO ) sets the x limits of each axis in `axs` to
%     `TO`.
%
%     See also shared_utils.plot.match_xlims
%
%     IN:
%       - `axs` (axes)
%       - `to` (double)
%     OUT:
%       - `axs` (axes)

axs = shared_utils.plot.set_lims( axs, 'xlim', to );

end