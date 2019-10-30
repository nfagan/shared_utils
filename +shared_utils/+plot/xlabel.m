function xlabel(axs, lab)

%   XLABEL -- Set xlabels of multiple axes.

arrayfun( @(x) xlabel(x, lab), axs );

end