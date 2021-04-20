function axs = set_lims(axs, kind, to)

%   SET_LIMS -- Set axes limits.
%
%     ... set_lims( axs, 'ylim', YLIM ) sets the 'ylim' property of each
%     axis in `axs` to `YLIM`.
%
%     See also shared_utils.plot.match_xlims, shared_utils.plot.set_xlims
%
%     IN:
%       - `axs` (axes)
%       - `kind` (char)
%       - `to` (double)
%     OUT:
%       - `axs` (axes)

if ( isempty(to) )
  return
end

arrayfun( @(x) set(x, kind, to), axs );

end