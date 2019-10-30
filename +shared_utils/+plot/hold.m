function axs = hold(axs, state)

%   HOLD -- Hold axes contents.
%
%     ... hold( axs ); holds axes in `axs` 'on'.
%     ... hold( axs, STATE ); applies the hold `STATE` to  axes in `axs`.
%
%     See also shared_utils.plot.add_horizontal_lines

if ( nargin == 1 ), state = 'on'; end
arrayfun( @(x) hold(x, state), axs );

end