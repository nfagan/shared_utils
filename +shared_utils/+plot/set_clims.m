function axs = set_clims(axs, to)

%   SET_CLIMS -- Set c limits for multiple axes.
%
%     ... set_clims( axs, TO ) sets the c limits of each axis in `axs` to
%     `TO`.
%
%     See also shared_utils.plot.match_clims
%
%     IN:
%       - `axs` (axes)
%       - `to` (double)
%     OUT:
%       - `axs` (axes)

axs = shared_utils.plot.set_lims( axs, 'clim', to );

end