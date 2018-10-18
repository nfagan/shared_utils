function ylabel(axs, lab)

%   YLABEL -- Set ylabels of multiple axes.
%
%     IN:
%       - `axs` (axes)
%       - `lab` (char)

arrayfun( @(x) ylabel(x, lab), axs );

end