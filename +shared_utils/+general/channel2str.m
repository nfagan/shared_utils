function strs = channel2str(prefix, chan)

%   CHANNEL2STR -- Convert channel numbers to prefixed channel strings.
%
%     S = ... channel2str( 'FP', 1 ) returns 'FP01'.
%     S = ... channel2str( 'FP', 11 ) returns 'FP11'.
%     S = ... channel2str( 'FP', [1, 2] ) returns { 'FP01', 'FP02' }
%
%     See also shared_utils.general.json_channels2num
%
%     IN:
%       - `prefix` (char)
%       - `chan` (double)
%     OUT:
%       - `strs` (char, cell array of strings)

if ( numel(chan) > 1 )
  strs = arrayfun( @(x) single_chan(prefix, x), chan, 'un', false );
else
  strs = single_chan( prefix, chan );
end

end

function str = single_chan(prefix, chan)

if ( chan < 10 )
  str = sprintf( '%s0%d', prefix, chan );
else
  str = sprintf( '%s%d', prefix, chan );
end

end