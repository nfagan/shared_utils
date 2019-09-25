function f = prevent_legend_autoupdate(f)

%   PREVENT_LEGEND_AUTOUPDATE -- Prevent legend from auto-updating.

if ( nargin < 1 )
  f = gcf();
end

for i = 1:numel(f)
  set( f(i), 'defaultLegendAutoUpdate', 'off' );
end

end