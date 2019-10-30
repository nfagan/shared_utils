function f = fullscreen(f)

%   FULLSCREEN -- Make a figure fullscreen.
%
%     ... fullscreen() makes the current figure fullscreen.
%     ... fullscreen( f ) makes the figure handle `f` fullscreen.
%     f = ... returns the handle(s) to the figure(s).

if ( nargin < 1 ), f = gcf; end

set( f, 'units', 'normalized' );
set( f, 'position', [0, 0, 1, 1] );

end