function ylabel(axs, lab)

%   YLABEL -- Set ylabels of multiple axes.

arrayfun( @(x) ylabel(x, lab), axs );

end