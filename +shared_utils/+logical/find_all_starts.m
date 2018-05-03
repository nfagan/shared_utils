function [inds, l] = find_all_starts(a)

%   FIND_ALL_STARTS -- Find starting indices of all contiguous groups of
%     true values.
%
%     inds = find_all_starts( [true, true, false, true] ) returns [1, 4]
%
%     [inds, l] = ... also returns `l`, the number of contiguous values at
%     each inds(i).
%
%     The indices in `inds` are linear.
%
%     IN:
%       - `a` (logical)
%     OUT:
%       - `inds` (double) -- Starts of sequences of true values.
%       - `l` (double) -- Length or size of each sequence.

shared_utils.assertions.assert__isa( a, 'logical' );

if ( ~isvector(a) )
  a = a(:);
end

if ( numel(a) == 0 )
  inds = [];
  l = [];
  return;
end

inds = find( diff(a) == 1 ) + 1;

if ( a(1) ), inds = [ 1, inds ]; end

if ( nargout() == 1 ), return; end

if ( numel(inds) == 0 )
  l = [];
  return;
end

stops = shared_utils.logical.find_all_starts( ~a );

if ( isempty(stops) )
  l = 1;
  return;
end

l = zeros( size(inds) );

for i = 1:numel(inds)-1
  current = stops( stops > inds(i) & stops < inds(i+1) );
  l(i) = current - inds(i);
end

if ( stops(end) > inds(end) )
  l(end) = stops(end) - inds(end);
else
  l(end) = numel(a) - inds(end) + 1;
end

end