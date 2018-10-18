function xlabel(axs, lab)

%   XLABEL -- Set xlabels of multiple axes.
%
%     IN:
%       - `axs` (axes)
%       - `lab` (char)

arrayfun( @(x) xlabel(x, lab), axs );

end