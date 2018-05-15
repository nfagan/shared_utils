function out = json_channels2num( channels )

%   JSON_CHANNELS2NUM -- Convert channel strings or numbers to numbers.
%
%     out = ... json_channels2num( {'1-4'} ) returns 1:4.
%     out = ... json_channels2num( [1, 2] ) returns [1, 2]
%     out = ... json_channels2num( {'1-3', 2, 4} ) returns [1, 2, 3, 2, 4] 
%
%     IN:
%       - `channels` (cell array, double)
%     OUT:
%       - `out` (double)

%   channels are a simple array of numbers
if ( isa(channels, 'double') )
  out = channels;
  return;
end
%   otherwise, channels are either a string like "17-32", or a mix of
%   string and number
shared_utils.assertions.assert__isa( channels, 'cell', 'channels' );
out = [];
for j = 1:numel(channels)
  chan = channels{j};    
  if ( isa(chan, 'double') )
    out(end+1) = chan;
    continue;
  end
  if ( isa(chan, 'char') )
    ind = strfind( chan, '-' );
    err_msg = sprintf( ['Wrong format for string channel interval;' ...
      , ' expected a format like this: "17-32", but got this: "%s".'] ...
      , chan );

    assert( numel(ind) == 1, err_msg );

    start = str2double( chan(1:ind-1) );
    stop = str2double( chan(ind+1:end) );

    assert( ~isnan(start) && ~isnan(stop), err_msg );

    interval = start:stop;

    out(end+1:end+numel(interval)) = interval;

    continue;
  end

  error( 'Unrecognized channel type "%s."', class(chan) );
end

end