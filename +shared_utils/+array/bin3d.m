function out = bin3d( data, window_size, step_size )

%   BIN3D -- Bin a matrix into a three-dimensional array.
%
%     out = ... bin3d( rand(6), 3 ) creates a 3-d array `out` whose
%     elements at (:, :, 1) are the first 3 columns of rand(6), and whose
%     elements at (:, :, 2) are the second 3 columns.
%
%     out = ... bin3d( rand(6), 3, 2 ) works as above, but steps each
%     window by 2, such that the second window contains columns 3:5 of
%     rand(6).
%
%     IN:
%       - `data` (double) -- Matrix.
%       - `window_size` (double) -- Number of columns of `data` per slice.
%       - `step_size` (double) -- Amount to increment the start of each
%         window.
%     OUT:
%       - `out` (double) -- 3-d array.

if ( nargin < 3 || isempty(step_size) )
  step_size = window_size;
end

shared_utils.assertions.assert__isa( data, 'double' );
assert( ismatrix(data) && ~isvector(data), 'Data must be a 2d matrix.' );

N = size( data, 2 );

n_steps = floor( N / step_size );

stop = min( N, window_size );
start = 0;
stp = 1;
cols = 1:stop;

out = nan( size(data, 1), stop, n_steps );

while ( stop <= N )
  out(:, cols, stp) = data(:, start+1:stop);
  if ( stop == N ), break; end;
  stp = stp + 1;
  start = start + step_size;
  stop = start + window_size;
  stop = min( N, stop );
  cols = 1:(stop-start);
end

end