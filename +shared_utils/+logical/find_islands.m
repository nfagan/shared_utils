function [starts, durs] = find_islands(vec)

%   FIND_ISLANDS -- Find starting indices of all contiguous groups of 
%     non-zero elements.
%
%     inds = find_islands( [true, true, false, true] ) returns [1, 4]
%
%     [inds, l] = ... also returns `l`, the number of contiguous values at
%     each inds(i).
%
%     The indices in `inds` will be linear with respect to the input.
%
%     https://stackoverflow.com/questions/3274043/finding-islands-of-zeros-in-a-sequence
%
%     IN:
%       - `vec` (logical)
%     OUT:
%       - `inds` (double) -- Starts of sequences of true values.
%       - `l` (double) -- Length or size of each sequence.

tsig = vec(:)';
dsig = diff( [0 tsig 0] );
starts = find( dsig > 0 );
ends = find( dsig < 0 ) - 1;
durs = ends - starts + 1;

end