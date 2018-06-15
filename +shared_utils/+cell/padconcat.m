function y = padconcat(arr, dim, fillwith)

%   PADCONCAT -- Pad arrays to match sizes, and then concat.
%
%     y = ... padconcat( arr, dim ) pads each element of `arr` with 
%     NaNs such that the sizes of the elements along each dimension,
%     except `dim`, match, and then concatenates across `dim` to produce
%     a single array. 
%
%     NaNs are appended to the end of the array along each dimension.
%
%     y = ... padconcat( arr ) is the same as y = ... padconcat( arr, 1 );
%
%     IN:
%       - `arr` (cell array)
%       - `dim` (double) |SCALAR|
%       - `fillwith` (double) |SCALAR|

if ( nargin < 3 )
  fillwith = NaN;
end

if ( nargin < 2 )
  dim = 1;
end

szs = cell2mat( cellfun(@(x) size(x), arr(:), 'un', false) );

maxs = max( szs, [], 1 );

padded = cell( size(arr) );

for i = 1:numel(arr)
  a = arr{i};
  maxs(dim) = szs(i, dim);
  padded{i} = padarray( a, maxs-szs(i, :), fillwith, 'post' );
end

y = cat( dim, padded{:} );

end